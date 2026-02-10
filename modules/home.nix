{ config, pkgs, username, homeDirectory, ... }:

let
  dotfilesDir =
    let env = builtins.getEnv "DOTFILES_DIR";
    in if env != "" then env else builtins.toString ./..;
  lib = pkgs.lib;

  # `home/` は「dotfiles置き場」なので、Git管理（flake source）に依存せず
  # 実ディスク上のディレクトリをスキャンして自動展開する。
  #
  # - `DOTFILES_DIR` が渡されていればそれを使う（apply.sh で渡している）
  # - 渡されていない場合は flake source 配下を使う
  homeRoot = builtins.toPath "${dotfilesDir}/home";
  homeRootStr = "${dotfilesDir}/home";
  homeModuleLib = builtins.toPath "${dotfilesDir}/modules/lib";

  # NOTE:
  # flake の git source には untracked file が含まれないため、
  # 分離した補助 module は DOTFILES_DIR 基準で参照する。
  homeFileEntries = import (homeModuleLib + "/home-file-entries.nix") {
    inherit lib homeRoot homeRootStr;
    outOfStore = config.lib.file.mkOutOfStoreSymlink;
  };
in
{
  imports = [
    (homeModuleLib + "/home-programs.nix")
  ];

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
    gh-dash
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
    gomi
  ];

  # `home/` 配下の自動展開ロジックは可読性のため別ファイルに分離
  # (`modules/lib/home-file-entries.nix`)。
  home.file = homeFileEntries;

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

  # macOS wallpaper
  #
  # This is best-effort: if System Events automation is denied, don't fail apply.
  home.activation.macosWallpaper = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    src="${dotfilesDir}/assets/wallpapers/beautiful-aerial-shot-modern-city-architecture-with-illuminated-tower-side.jpg"
    wall="$HOME/.local/share/wallpapers/beautiful-aerial-shot-modern-city-architecture-with-illuminated-tower-side.jpg"

    if [ -e "$src" ]; then
      mkdir -p "$(dirname "$wall")"
      if ! cmp -s "$src" "$wall" 2>/dev/null; then
        cp -f "$src" "$wall"
      fi
      /usr/bin/osascript -e 'tell application "System Events" to tell every desktop to set picture to POSIX file "'"$wall"'"' >/dev/null 2>&1 || true
    fi
  '';
}
