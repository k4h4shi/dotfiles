{ config, pkgs, username, homeDirectory, ... }:

let
  dotfilesDir =
    let env = builtins.getEnv "DOTFILES_DIR";
    in if env != "" then env else builtins.toString ./..;
  outOfStore = config.lib.file.mkOutOfStoreSymlink;
  lib = pkgs.lib;

  # `home/` は「dotfiles置き場」なので、Git管理（flake source）に依存せず
  # 実ディスク上のディレクトリをスキャンして自動展開する。
  #
  # - `DOTFILES_DIR` が渡されていればそれを使う（apply.sh で渡している）
  # - 渡されていない場合は flake source 配下を使う
  homeRoot = builtins.toPath "${dotfilesDir}/home";
  homeRootStr = "${dotfilesDir}/home";

  # `home/` 配下は基本的に自動で $HOME に展開する。
  # 例外:
  # - `.config/local-env`: 端末ローカルで書き換える領域なのでディレクトリ自体は管理しない（テンプレのみ）。
  # - `.local/bin`: 一部は sandbox で読めない out-of-store を避け、Nix store に取り込む。
  mkOutOfStoreSource = rel: outOfStore "${homeRootStr}/${rel}";

  mkAutoEntry = rel: type:
    lib.nameValuePair rel ({
      source = mkOutOfStoreSource rel;
    } // lib.optionalAttrs (type == "directory") { recursive = true; });

  readDirIfExists = path: if builtins.pathExists path then builtins.readDir path else { };

  # `.local/bin` のうち、sandbox で out-of-store が読めず失敗しやすいものは store 取り込みにする
  localBinStoreImportNames = [ "ghostty-tab" "tmux-ime-status" "tmux-ime-apply" "dot" ];

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
                rel =
                  if relPrefix == "" then name else "${relPrefix}/${name}";
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
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  # パッケージ
  home.packages = with pkgs; [
    # ev:packages:start
    # 開発ツール
    git
    git-lfs
    gh
    glab
    jq
    ripgrep
    fd
    fzf
    tmux
    pkgs.macism
    awscli2
    railway
    dnsutils

    # 言語・ランタイム
    nodejs_22
    rustup
    python3
    ruby

    # AI
    claude-code
    codex

    # ビルドツール
    gnumake
    cmake

    # その他
    curl
    wget
    tree
    # ev:packages:end
  ];

  # Git
  programs.git = {
    enable = true;
    ignores = [
      ".vscode/"
      ".worktree/"
      ".claude/settings.local.json"
    ];
    settings = {
      user = {
        name = "Kotaro Takahashi";
        email = "kotaro.t@k4h4shi.com";
      };
      core = {
        editor = "vim";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Zsh
  programs.zsh = {
    enable = true;
    # NOTE: relative paths are deprecated in Home Manager.
    # Use an absolute path derived from XDG base dirs.
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      python = "python3";
      pip = "pip3";
      ll = "ls -la";
      g = "git";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      da = "cd ~/src/github/k4h4shi/dotfiles && ./apply.sh";
      sz = "source ~/.zshrc";
      sa = "alias | sort";
      ez = "exec zsh";
    };

    initContent = ''
      # Homebrew (macOS)
      if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      # Default editor
      export EDITOR=vim
      export VISUAL=vim

      # Android SDK
      export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
      export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"

      # Java (macOS)
      if [[ -x /usr/libexec/java_home ]]; then
        export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null || true)
      fi

      # Rust
      [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

      # Local bin
      export PATH="$HOME/.local/bin:$PATH"

      # dot command: use subcommands; `dot cd` for directory jump
      dot() {
        command dot "$@"
      }

      # UTF-8 combining characters (macOS default)
      if [[ "$(locale LC_CTYPE)" == "UTF-8" ]]; then
        setopt COMBINING_CHARS
      fi

      # History settings (macOS default)
      HISTFILE=''${ZDOTDIR:-$HOME}/.zsh_history
      HISTSIZE=2000
      SAVEHIST=1000

      # Key bindings (macOS default - terminfo based)
      typeset -g -A key
      [[ -n "$terminfo[kbs]" ]] && key[Backspace]=$terminfo[kbs]
      [[ -n "$terminfo[kich1]" ]] && key[Insert]=$terminfo[kich1]
      [[ -n "$terminfo[kdch1]" ]] && key[Delete]=$terminfo[kdch1]
      [[ -n "$terminfo[khome]" ]] && key[Home]=$terminfo[khome]
      [[ -n "$terminfo[kend]" ]] && key[End]=$terminfo[kend]
      [[ -n "$terminfo[kpp]" ]] && key[PageUp]=$terminfo[kpp]
      [[ -n "$terminfo[knp]" ]] && key[PageDown]=$terminfo[knp]
      [[ -n "$terminfo[kcuu1]" ]] && key[Up]=$terminfo[kcuu1]
      [[ -n "$terminfo[kcub1]" ]] && key[Left]=$terminfo[kcub1]
      [[ -n "$terminfo[kcud1]" ]] && key[Down]=$terminfo[kcud1]
      [[ -n "$terminfo[kcuf1]" ]] && key[Right]=$terminfo[kcuf1]

      [[ -n ''${key[Delete]} ]] && bindkey "''${key[Delete]}" delete-char
      [[ -n ''${key[Home]} ]] && bindkey "''${key[Home]}" beginning-of-line
      [[ -n ''${key[End]} ]] && bindkey "''${key[End]}" end-of-line
      [[ -n ''${key[Up]} ]] && bindkey "''${key[Up]}" up-line-or-search
      [[ -n ''${key[Down]} ]] && bindkey "''${key[Down]}" down-line-or-search

      # マシンローカル設定（dotfiles管理外）
      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

      # マシンローカルの profile を PATH に追加
      if [[ -d ~/.local-env/profile/bin ]]; then
        export PATH="$HOME/.local-env/profile/bin:$PATH"
      fi
    '';
  };

  # home-manager自身を管理
  programs.home-manager.enable = true;

  # direnv（プロジェクトごとの環境自動切り替え）
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # starship（モダンなプロンプト）
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
    };
  };

  # `home/` 配下は原則 dotfiles 置き場として扱い、追加した時点で展開されるようにする。
  #
  # NOTE:
  # - `.config/local-env` は端末ローカルで編集される領域のため、ディレクトリ自体は home-manager 管理にしない。
  #   ただしテンプレは `home/` から展開する。
  # - `.local/bin` は一部（`ghostty-tab`, `dot`）だけ store 取り込みにして sandbox 問題を回避する。
  home.file =
    let
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
      toolRootEntries
      libraryEntries
      configNonLocalEnvEntries
      localEnvEntries
      localNonBinEntries
      localBinEntries
    ];

  # Machine-local environment bootstrap (do not overwrite if user customized)
  home.activation.localEnvBootstrap = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    localEnvDir="$HOME/.config/local-env"

    if [ -d "$localEnvDir" ]; then
      if [ ! -e "$localEnvDir/flake.nix" ] && [ -f "$localEnvDir/flake.nix.template" ]; then
        cp "$localEnvDir/flake.nix.template" "$localEnvDir/flake.nix"
      fi

      if [ ! -e "$localEnvDir/.envrc" ]; then
        printf '%s\n' "use flake" > "$localEnvDir/.envrc"
      fi
    fi
  '';
}
