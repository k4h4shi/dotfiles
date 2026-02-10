#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/dotfiles.sh
source "$DOTFILES/scripts/lib/dotfiles.sh"

# プロファイル選択（引数で指定、デフォルトは common）
PROFILE="${1:-common}"

print_runtime_header "dotfiles installer" "$DOTFILES" "$PROFILE"
validate_profile_or_die "$PROFILE" "$0"
ensure_submodules

# 1. Nixのインストール
if ! install_nix_if_missing; then
  exit 0
fi

# 2. Flakesを有効化
enable_flakes_if_needed

# 3. Homebrewのインストール（macOSの場合）
install_homebrew_if_missing

cd "$DOTFILES"

# 4. 反映（共通処理）
./apply.sh "$PROFILE"
