#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# プロファイル選択（引数で指定、デフォルトは common）
PROFILE="${1:-common}"

echo "==> dotfiles installer"
echo "    Location: $DOTFILES"
echo "    User: $USER"
echo "    Home: $HOME"
echo "    Profile: $PROFILE"
echo ""

# プロファイルの検証
if [[ "$PROFILE" != "personal" && "$PROFILE" != "common" ]]; then
  echo "Error: Unknown profile '$PROFILE'"
  echo "Usage: $0 [common|personal]"
  echo "  common   - 共通アプリのみ（デフォルト）"
  echo "  personal - 共通アプリ + 音楽制作アプリ"
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

# 4. 反映（共通処理）
./apply.sh "$PROFILE"
