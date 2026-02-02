#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# プロファイル選択（引数で指定、デフォルトは personal）
PROFILE="${1:-personal}"

echo "==> dotfiles installer"
echo "    Location: $DOTFILES"
echo "    User: $USER"
echo "    Home: $HOME"
echo "    Profile: $PROFILE"
echo ""

# プロファイルの検証
if [[ "$PROFILE" != "personal" && "$PROFILE" != "common" ]]; then
  echo "Error: Unknown profile '$PROFILE'"
  echo "Usage: $0 [personal|common]"
  echo "  personal - 共通アプリ + 音楽制作アプリ（デフォルト）"
  echo "  common   - 共通アプリのみ"
  exit 1
fi

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

# 3. Homebrewのインストール（macOSの場合）
if [[ "$(uname)" == "Darwin" ]] && ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Homebrewの環境を読み込む
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

cd "$DOTFILES"

# 4. macOS: nix-darwin でセットアップ
if [[ "$(uname)" == "Darwin" ]]; then
  echo "==> Running darwin-rebuild switch..."
  echo "    Using profile: $PROFILE"

  # nix-darwin switch実行
  # --impure: 環境変数（USER, HOME）を読み取るために必要
  # sudo: システム設定の変更に必要
  # HOME/USER を明示的に渡す（sudoで失われるため）
  sudo HOME="$HOME" USER="$USER" nix run nix-darwin \
    --extra-experimental-features "nix-command flakes" \
    -- switch --flake ".#${PROFILE}" --impure

# Linux: home-manager でセットアップ
else
  echo "==> Running home-manager switch..."
  CONFIG_NAME="${USER:-default}"
  echo "    Using configuration: $CONFIG_NAME"

  nix run home-manager -- switch --flake ".#${CONFIG_NAME}" --impure -b backup
fi

echo ""
echo "==> Done!"
echo "    Restart your shell to apply changes."
