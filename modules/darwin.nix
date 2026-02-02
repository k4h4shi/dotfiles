{ pkgs, username, homeDirectory, profile ? "personal", ... }:

let
  # 共通のCaskアプリ
  commonCasks = [
    # 開発ツール
    "docker"
    "docker-desktop"
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
    "cmd-eikana"
    "scroll-reverser"
    "displaylink"
    "obsidian"

    # コミュニケーション・エンタメ
    "slack"
    "spotify"
    "zoom"
    "line"
    "readdle-spark"
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
    "kindle"
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

  # Homebrew管理
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";  # 管理外のアプリを削除
    };
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
  security.pam.enableSudoTouchIdAuth = true;  # Touch ID で sudo

  # システムバージョン（nix-darwin用）
  system.stateVersion = 5;
}
