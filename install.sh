#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> dotfiles installer"
echo "    Location: $DOTFILES"
echo "    User: $USER"
echo "    Home: $HOME"
echo ""

# 1. Nixのインストール
if ! command -v nix &>/dev/null; then
  echo "==> Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install)

  # Nixの環境を読み込む
  if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi

  echo ""
  echo "==> Nix installed. You may need to restart your shell."
  echo "    After restarting, run this script again."
  exit 0
fi

echo "==> Nix is already installed: $(which nix)"

# 2. Flakesを有効化
if ! nix flake --help &>/dev/null 2>&1; then
  echo "==> Enabling flakes..."
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# 3. home-managerでセットアップ
echo "==> Running home-manager switch..."
cd "$DOTFILES"

# 設定名（現在のユーザー名を使用）
CONFIG_NAME="${USER:-default}"
echo "    Using configuration: $CONFIG_NAME"

# home-manager switch実行
# --impure: 環境変数（USER, HOME）を読み取るために必要
nix run home-manager -- switch --flake ".#${CONFIG_NAME}" --impure -b backup

echo ""
echo "==> Done!"
echo "    Restart your shell to apply changes."
