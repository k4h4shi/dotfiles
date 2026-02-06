#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> dotfiles apply (home-only)"
echo "    Location: $DOTFILES"
echo "    User: $USER"
echo "    Home: $HOME"
echo ""

if ! command -v nix &>/dev/null; then
  echo "Error: Nix is not installed."
  echo "Run ./install.sh first."
  exit 1
fi

if ! nix flake --help &>/dev/null 2>&1; then
  echo "==> Enabling flakes..."
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

cd "$DOTFILES"

CONFIG_NAME="${USER:-default}"

DOTFILES_DIR="$DOTFILES" nix run home-manager -- \
  switch --flake ".#${CONFIG_NAME}" --impure -b backup

echo ""
echo "==> Done!"
echo "    Restart your shell to apply changes."
