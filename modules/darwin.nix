{ pkgs, lib, username, homeDirectory, profile ? "personal", ... }:

let
  # 共通のCaskアプリ
  commonCasks = [
    # ev:casks:common:start
    # 開発ツール
    "docker-desktop"  # docker は docker-desktop に統合
    "ghostty"
    "ngrok"
    "cursor"
    "google-chrome"
    "anaconda"

    # AI
    "chatgpt"
    "claude"

    # ブラウザ
    "arc"

    # ユーティリティ
    "1password"
    "alfred"
    "blackhole-2ch"
    "cmd-eikana"
    "scroll-reverser"
    "displaylink"
    "obsidian"

    # コミュニケーション・エンタメ
    "slack"
    "spotify"
    "zoom"
    # line - App Store からインストール（Caskなし）
    "readdle-spark"
    # ev:casks:common:end
    "hiddenbar"
    "appcleaner"
    "codex-app"
  ];

  # 個人用の追加Caskアプリ
  personalCasks = [
    # 音楽制作
    "ableton-live-suite"
    "izotope-product-portal"
    "native-access"
    "splice"
    "background-music"
    "waves-central"
    "ilok-license-manager"
    "sonic-visualiser"

    # その他
    # kindle - Homebrew Cask で管理（commonCasks）
    # SIGMA_PhotoPro6 - 手動インストール（Caskなし）
  ];

  # 手動インストールが必要なアプリ（参考用コメント）
  # 共通:
  #   - Xcode (App Store)
  #   - Clean (App Store?)
  # 個人用（音楽制作）:
  #   - Logic Pro X (App Store)
  #   - Spitfire Audio, Muse Hub, XLN Online Installer, Output Hub
  #   - inMusic Software Center, Arcade (Splice経由)
  #   - SoundID Reference, iZotope Audiolens/Ozone 9 (iZotope Portal経由)
  #   - MOTU系, MPC, Neuro Desktop
  #   - SIGMA_PhotoPro6

  # プロファイルに応じたCaskリスト
  casks = if profile == "personal" then commonCasks ++ personalCasks else commonCasks;
in
{
  # Nix設定
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Unfree packages
  # Claude Code CLI (`claude-code`) is marked as unfree in nixpkgs.
  # Allow only the minimum set we need.
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
    "claude-code-bin"
    "claude-code-acp"
    "claude-code-router"
  ];

  # Homebrew管理
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # cleanup = "zap";  # 管理外のアプリを削除（危険なので無効化）
      # cleanup = "uninstall";  # Caskリストから削除されたアプリのみ削除
      cleanup = "none";  # 何も削除しない（安全）
    };
    brews = [
      "ffmpeg"  # 動画処理
    ];
    casks = casks;
  };

  # macOSシステム設定
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };

    # Finder
    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv";  # リスト表示
    };

    # グローバル設定
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      # キーリピート設定
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };

    # トラックパッド
    trackpad = {
      Clicking = true;  # タップでクリック
      TrackpadRightClick = true;
    };
  };

  # キーボード設定
  system.keyboard = {
    enableKeyMapping = true;
    # CapsLockをControlにリマップ（必要なら有効化）
    # remapCapsLockToControl = true;
  };

  # セキュリティ設定
  security.pam.services.sudo_local.touchIdAuth = true;  # Touch ID で sudo

  # プライマリユーザー（nix-darwin がユーザー固有の設定に使用）
  system.primaryUser = username;

  # システムバージョン（nix-darwin用）
  system.stateVersion = 5;
}
