{ lib
, outOfStore
, homeRoot
, homeRootStr
, localBinStoreImportNames ? [ "tmux-ime-status" "dot" "obs" "rm" ]
}:

let
  mkOutOfStoreSource = rel: outOfStore "${homeRootStr}/${rel}";

  mkAutoEntry = rel: type:
    lib.nameValuePair rel ({
      source = mkOutOfStoreSource rel;
    } // lib.optionalAttrs (type == "directory") { recursive = true; });

  readDirIfExists = path: if builtins.pathExists path then builtins.readDir path else { };

  # `home/Library` は macOS が内部で書き込む（例: `~/Library/Fonts`）ため、
  # ルートディレクトリ自体を symlink にすると Home Manager の安全チェックに引っかかる。
  #
  # そのため `~/Library` は実ディレクトリのままにして、`home/Library` 配下の “ファイル” だけを
  # 個別に展開する（ディレクトリは symlink 化しない）。
  mkLibraryFileEntries =
    let
      mkFileEntry = rel: {
        "Library/${rel}" = {
          source = mkOutOfStoreSource "Library/${rel}";
        };
      };

      walk = relPrefix: dirPath:
        let children = builtins.readDir dirPath;
        in
        lib.foldl' lib.recursiveUpdate { } (
          lib.mapAttrsToList
            (name: type:
              let
                rel = if relPrefix == "" then name else "${relPrefix}/${name}";
                full = dirPath + "/${name}";
              in
              if type == "directory" then
                walk rel full
              else if type == "regular" || type == "symlink" then
                mkFileEntry rel
              else
                { }
            )
            children
        );
    in
    dirPath:
      let
        # Fonts は Home Manager 側で触るため除外（`~/Library` は実 dir のままにする）
        top = readDirIfExists dirPath;
        topFiltered = lib.filterAttrs (name: _type: name != "Fonts") top;
      in
      lib.foldl' lib.recursiveUpdate { } (
        lib.mapAttrsToList
          (name: type:
            if type == "directory" then
              walk name (dirPath + "/${name}")
            else if type == "regular" || type == "symlink" then
              mkFileEntry name
            else
              { }
          )
          topFiltered
      );

  top = builtins.readDir homeRoot;

  # Whitelist:
  # - `home/` 直下は “dotfiles (regular files)” のみ自動展開する
  #   (ディレクトリは勝手に展開しない。mutable/生成物が混ざりやすいため)
  topDotfilesRegular =
    lib.filterAttrs
      (name: type:
        type == "regular"
        && lib.hasPrefix "." name
        && name != ".DS_Store")
      top;
  topDotfilesEntries = lib.mapAttrs' (name: type: mkAutoEntry name type) topDotfilesRegular;

  # Explicit entries (non-dotfile)
  explicitEntries = {
    "AGENTS.md" = {
      source = mkOutOfStoreSource "AGENTS.md";
    };
  };

  # Tool roots:
  # `.claude` / `.cursor` / `.gemini` / `.codex` / `.vive` は配下ディレクトリも含めて展開する。
  #
  # NOTE: recursive 方式にしておくことで、$HOME 側のディレクトリは実体のまま保持され、
  #       追加で生成される state/caches も $HOME 側に書ける（repo 側に流れにくい）。
  toolRootEntries = {
    ".claude" = {
      source = mkOutOfStoreSource ".claude";
      recursive = true;
    };
    ".cursor" = {
      source = mkOutOfStoreSource ".cursor";
      recursive = true;
    };
    ".gemini" = {
      source = mkOutOfStoreSource ".gemini";
      recursive = true;
    };
    ".codex" = {
      source = mkOutOfStoreSource ".codex";
      recursive = true;
    };
    ".vive" = {
      source = mkOutOfStoreSource ".vive";
      recursive = true;
    };
    ".tmux" = {
      source = mkOutOfStoreSource ".tmux";
      recursive = true;
    };
  };

  # Library (files-only)
  libraryDir = homeRoot + "/Library";
  libraryEntries = mkLibraryFileEntries libraryDir;

  # .config
  configDir = homeRoot + "/.config";
  configChildren = readDirIfExists configDir;

  configNonLocalEnvChildren =
    lib.filterAttrs (name: _type: name != "local-env") configChildren;
  configNonLocalEnvEntries =
    lib.mapAttrs'
      (name: type: mkAutoEntry ".config/${name}" type)
      configNonLocalEnvChildren;

  localEnvDir = configDir + "/local-env";
  localEnvChildren = readDirIfExists localEnvDir;
  # local-env はディレクトリ自体は管理せず、配下のテンプレのみ管理する
  localEnvEntries =
    lib.mapAttrs'
      (name: type: mkAutoEntry ".config/local-env/${name}" type)
      localEnvChildren;

  # .local
  localDir = homeRoot + "/.local";
  localChildren = readDirIfExists localDir;

  localNonBinChildren = lib.filterAttrs (name: _type: name != "bin") localChildren;
  localNonBinEntries =
    lib.mapAttrs'
      (name: type: mkAutoEntry ".local/${name}" type)
      localNonBinChildren;

  localBinDir = localDir + "/bin";
  localBinChildren = readDirIfExists localBinDir;
  localBinEntries =
    lib.mapAttrs'
      (name: type:
        let rel = ".local/bin/${name}";
        in
        if type == "directory" then
          mkAutoEntry rel type
        else if lib.elem name localBinStoreImportNames then
          lib.nameValuePair rel {
            # NOTE: out-of-store symlink が sandbox で読めず失敗することがあるため、store に取り込む
            source = homeRoot + "/.local/bin/${name}";
            executable = true;
          }
        else
          lib.nameValuePair rel {
            source = mkOutOfStoreSource rel;
            executable = true;
          }
      )
      localBinChildren;
in
lib.foldl' lib.recursiveUpdate { } [
  topDotfilesEntries
  explicitEntries
  toolRootEntries
  libraryEntries
  configNonLocalEnvEntries
  localEnvEntries
  localNonBinEntries
  localBinEntries
]
