{ config, ... }:
{
  # Git
  programs.git = {
    enable = true;
    ignores = [
      ".vscode/"
      ".worktrees/"
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
      rm = "gomi";
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

      # dot command: make `dot go` change current shell directory
      dot() {
        if [[ "''${1:-}" == "go" ]]; then
          cd "''${DOTFILES_DIR:-$HOME/src/github/k4h4shi/dotfiles}"
          return
        fi
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

      # vi mode
      bindkey -v

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
}
