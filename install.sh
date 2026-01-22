#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

for item in "$DOTFILES/home/".*; do
  name="$(basename "$item")"
  [[ "$name" == "." || "$name" == ".." ]] && continue

  dest="$HOME/$name"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "${dest}.bak-${TS}"
    echo "backup: $dest"
  fi

  ln -sfn "$item" "$dest"
  echo "link: $dest -> $item"
done

echo "done"
