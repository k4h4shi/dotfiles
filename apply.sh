#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/dotfiles.sh
source "$DOTFILES/scripts/lib/dotfiles.sh"

# プロファイル選択（引数で指定、デフォルトは common）
PROFILE="${1:-common}"

print_runtime_header "dotfiles apply" "$DOTFILES" "$PROFILE"
validate_profile_or_die "$PROFILE" "$0"
ensure_submodules
require_nix_or_die
enable_flakes_if_needed

cd "$DOTFILES"

if is_macos; then
  run_darwin_switch "$DOTFILES" "$PROFILE"
else
  run_home_manager_switch "$DOTFILES"
fi

print_done
