{ config, pkgs, username, homeDirectory, ... }:

let
  dotfilesDir =
    let env = builtins.getEnv "DOTFILES_DIR";
    in if env != "" then env else builtins.toString ./..;
  outOfStore = config.lib.file.mkOutOfStoreSymlink;
  lib = pkgs.lib;

  homeRoot = ../home;
  homeRootStr = "${dotfilesDir}/home";

  # `home/` 配下は基本的に自動で $HOME に展開する。
  # 例外:
  # - `.config/local-env`: 端末ローカルで書き換える領域なのでディレクトリ自体は管理しない（テンプレのみ）。
  # - `.local/bin`: 一部は sandbox で読めない out-of-store を避け、Nix store に取り込む。
  mkOutOfStoreSource = rel: outOfStore "${homeRootStr}/${rel}";

  mkAutoEntry = rel: type:
    lib.nameValuePair rel {
      source = mkOutOfStoreSource rel;
    };

  readDirIfExists = path: if builtins.pathExists path then builtins.readDir path else { };

  # `.local/bin` のうち、sandbox で out-of-store が読めず失敗しやすいものは store 取り込みにする
  localBinStoreImportNames = [ "ghostty-tab" "ev" ];
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
    };

    initContent = ''
      # Homebrew (macOS)
      if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

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
  # - `.local/bin` は一部（`ghostty-tab`, `ev`）だけ store 取り込みにして sandbox 問題を回避する。
  home.file =
    let
      top = builtins.readDir homeRoot;

      # `.config` / `.local` は例外ルールを適用するため、ここでは除外
      topAuto = lib.filterAttrs (name: _type: name != ".config" && name != ".local") top;
      topAutoEntries = lib.mapAttrs' (name: type: mkAutoEntry name type) topAuto;

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
      topAutoEntries
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
