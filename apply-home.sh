#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/dotfiles.sh
source "$DOTFILES/scripts/lib/dotfiles.sh"

print_runtime_header "dotfiles apply (home-only)" "$DOTFILES"
ensure_submodules
require_nix_or_die
enable_flakes_if_needed

cd "$DOTFILES"

run_home_manager_switch "$DOTFILES"
print_done
