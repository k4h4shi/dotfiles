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
    gh
    jq
    ripgrep
    fd
    fzf
    tmux

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

  # AI設定ファイル（シンボリックリンク）
  home.file = {
    # Claude Code
    ".claude/agents".source = "${dotfilesDir}/home/.claude/agents";
    ".claude/commands".source = "${dotfilesDir}/home/.claude/commands";
    ".claude/skills".source = "${dotfilesDir}/home/.claude/skills";
    ".claude/settings.json".source = "${dotfilesDir}/home/.claude/settings.json";

    # Cursor
    ".cursor/commands".source = "${dotfilesDir}/home/.cursor/commands";
    ".cursor/rules".source = "${dotfilesDir}/home/.cursor/rules";

    # Gemini CLI
    ".gemini/commands".source = "${dotfilesDir}/home/.gemini/commands";

    # Codex CLI
    ".codex/skills/custom".source = "${dotfilesDir}/home/.codex/skills";

    # Vive
    ".vive".source = "${dotfilesDir}/home/.vive";
  };
}
