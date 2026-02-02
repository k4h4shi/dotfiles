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

    # Gemini CLI
    ".gemini/commands".source = "${dotfilesDir}/home/.gemini/commands";

    # Codex CLI
    ".codex/skills/custom".source = "${dotfilesDir}/home/.codex/skills";
    ".codex/instructions.md".source = "${dotfilesDir}/home/.codex/instructions.md";

    # Vive
    ".vive".source = "${dotfilesDir}/home/.vive";
  };
}
