#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# プロファイル選択（引数で指定、デフォルトは common）
PROFILE="${1:-common}"

echo "==> dotfiles apply"
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

if ! command -v nix &>/dev/null; then
  echo "Error: Nix is not installed."
  echo "Run ./install.sh first."
  exit 1
fi

# Flakesを有効化（念のため）
if ! nix flake --help &>/dev/null 2>&1; then
  echo "==> Enabling flakes..."
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

cd "$DOTFILES"

if [[ "$(uname)" == "Darwin" ]]; then
  echo "==> Running darwin-rebuild switch..."
  echo "    Using profile: $PROFILE"

  sudo -H env DOTFILES_USERNAME="$USER" DOTFILES_HOME="$HOME" DOTFILES_DIR="$DOTFILES" nix run nix-darwin \
    --extra-experimental-features "nix-command flakes" \
    -- switch --flake ".#${PROFILE}" --impure
else
  echo "==> Running home-manager switch..."
  CONFIG_NAME="${USER:-default}"
  echo "    Using configuration: $CONFIG_NAME"

  DOTFILES_DIR="$DOTFILES" nix run home-manager -- switch --flake ".#${CONFIG_NAME}" --impure -b backup
fi

echo ""
echo "==> Done!"
echo "    Restart your shell to apply changes."
