{ pkgs, username, homeDirectory, ... }:

let
  dotfilesDir = builtins.toString ./..;
in
{
  home.username = username;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "24.05";

  # パッケージ
  home.packages = with pkgs; [
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
    # Claude Code
    ".claude/agents".source = "${dotfilesDir}/home/.claude/agents";
    ".claude/commands".source = "${dotfilesDir}/home/.claude/commands";
    ".claude/skills".source = "${dotfilesDir}/home/.claude/skills";
    ".claude/CLAUDE.md".source = "${dotfilesDir}/home/.claude/CLAUDE.md";
    ".claude/settings.json".source = "${dotfilesDir}/home/.claude/settings.json";

    # Cursor
    ".cursor/commands".source = "${dotfilesDir}/home/.cursor/commands";
    ".cursor/rules".source = "${dotfilesDir}/home/.cursor/rules";

    # Cursor (User settings)
    "Library/Application Support/Cursor/User/settings.json".source =
      "${dotfilesDir}/home/Library/Application Support/Cursor/User/settings.json";
    "Library/Application Support/Cursor/User/keybindings.json".source =
      "${dotfilesDir}/home/Library/Application Support/Cursor/User/keybindings.json";
    "Library/Application Support/Cursor/User/extensions.json".source =
      "${dotfilesDir}/home/Library/Application Support/Cursor/User/extensions.json";

    # Gemini CLI
    ".gemini/commands".source = "${dotfilesDir}/home/.gemini/commands";

    # Codex CLI
    ".codex/skills/custom".source = "${dotfilesDir}/home/.codex/skills";
    ".codex/instructions.md".source = "${dotfilesDir}/home/.codex/instructions.md";

    # Vive
    ".vive".source = "${dotfilesDir}/home/.vive";

    # Local bin
    ".local/bin/ghostty-tab" = {
      source = "${dotfilesDir}/home/.local/bin/ghostty-tab";
      executable = true;
    };
  };
}
