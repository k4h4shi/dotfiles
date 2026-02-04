{ config, pkgs, username, homeDirectory, ... }:

let
  dotfilesDir =
    let env = builtins.getEnv "DOTFILES_DIR";
    in if env != "" then env else builtins.toString ./..;
  outOfStore = config.lib.file.mkOutOfStoreSymlink;
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

  # AI設定ファイル（シンボリックリンク）
  home.file = {
    # zshrc entrypoint (keep writable for installers)
    ".zshrc".source = outOfStore "${dotfilesDir}/home/.zshrc";

    # Claude Code
    ".claude/agents".source = outOfStore "${dotfilesDir}/home/.claude/agents";
    ".claude/commands".source = outOfStore "${dotfilesDir}/home/.claude/commands";
    ".claude/skills".source = outOfStore "${dotfilesDir}/home/.claude/skills";
    ".claude/CLAUDE.md".source = outOfStore "${dotfilesDir}/home/.claude/CLAUDE.md";
    ".claude/settings.json".source =
      outOfStore "${dotfilesDir}/home/.claude/settings.json";

    # Cursor
    ".cursor/commands".source = outOfStore "${dotfilesDir}/home/.cursor/commands";
    ".cursor/rules".source = outOfStore "${dotfilesDir}/home/.cursor/rules";

    # Cursor (User settings)
    "Library/Application Support/Cursor/User/settings.json".source =
      outOfStore "${dotfilesDir}/home/Library/Application Support/Cursor/User/settings.json";
    "Library/Application Support/Cursor/User/keybindings.json".source =
      outOfStore "${dotfilesDir}/home/Library/Application Support/Cursor/User/keybindings.json";
    "Library/Application Support/Cursor/User/extensions.json".source =
      outOfStore "${dotfilesDir}/home/Library/Application Support/Cursor/User/extensions.json";

    # Gemini CLI
    ".gemini/commands".source = outOfStore "${dotfilesDir}/home/.gemini/commands";

    # Codex CLI
    ".codex/skills/custom".source = outOfStore "${dotfilesDir}/home/.codex/skills";
    ".codex/instructions.md".source =
      outOfStore "${dotfilesDir}/home/.codex/instructions.md";

    # Vive
    ".vive".source = outOfStore "${dotfilesDir}/home/.vive";

    # Local bin
    ".local/bin/ghostty-tab" = {
      # NOTE: `outOfStore` becomes a symlink to /Users/... which the Nix builder
      # (sandbox) cannot read, causing `cp: ... Permission denied`.
      # Import into the Nix store instead.
      source = ../home/.local/bin/ghostty-tab;
      executable = true;
    };
    ".local/bin/ev" = {
      source = ../home/.local/bin/ev;
      executable = true;
    };

    # Machine-local environment (template, not symlink)
    # 端末ローカルのパッケージ管理用テンプレート
    ".config/local-env/flake.nix.template".source =
      "${dotfilesDir}/home/.config/local-env/flake.nix.template";
    ".config/local-env/README.md".source =
      "${dotfilesDir}/home/.config/local-env/README.md";
  };

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
