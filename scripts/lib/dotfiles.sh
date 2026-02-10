#!/usr/bin/env bash

# Shared helpers for dotfiles management scripts.

is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

print_runtime_header() {
  local title="$1"
  local dotfiles="$2"
  local profile="${3:-}"

  echo "==> $title"
  echo "    Location: $dotfiles"
  echo "    User: ${USER:-unknown}"
  echo "    Home: ${HOME:-unknown}"
  if [[ -n "$profile" ]]; then
    echo "    Profile: $profile"
  fi
  echo ""
}

ensure_submodules() {
  if [[ ! -d "$DOTFILES/.git" ]]; then
    return 0
  fi

  if git -C "$DOTFILES" submodule status --recursive 2>/dev/null | rg -q '^-'; then
    echo "==> Initializing git submodules..."
    git -C "$DOTFILES" submodule update --init --recursive
  fi
}

print_done() {
  echo ""
  echo "==> Done!"
  echo "    Restart your shell to apply changes."
}

validate_profile_or_die() {
  local profile="$1"
  local script_name="$2"

  if [[ "$profile" == "common" || "$profile" == "personal" ]]; then
    return 0
  fi

  echo "Error: Unknown profile '$profile'"
  echo "Usage: $script_name [common|personal]"
  echo "  common   - 共通アプリのみ（デフォルト）"
  echo "  personal - 共通アプリ + 音楽制作アプリ"
  exit 1
}

require_nix_or_die() {
  if command -v nix >/dev/null 2>&1; then
    return 0
  fi

  echo "Error: Nix is not installed."
  echo "Run ./install.sh first."
  exit 1
}

enable_flakes_if_needed() {
  if nix flake --help >/dev/null 2>&1; then
    return 0
  fi

  local nix_conf="$HOME/.config/nix/nix.conf"
  if [[ -f "$nix_conf" ]] && awk '
    /^experimental-features[[:space:]]*=/ {
      has_nix = ($0 ~ /(^|[[:space:]])nix-command($|[[:space:]])/)
      has_flakes = ($0 ~ /(^|[[:space:]])flakes($|[[:space:]])/)
      if (has_nix && has_flakes) {
        found = 1
      }
    }
    END { exit found ? 0 : 1 }
  ' "$nix_conf"; then
    return 0
  fi

  echo "==> Enabling flakes..."
  mkdir -p "$HOME/.config/nix"
  local tmp
  tmp="$(mktemp)"

  if [[ -f "$nix_conf" ]]; then
    awk '
      BEGIN { updated = 0 }
      /^experimental-features[[:space:]]*=/ {
        if ($0 !~ /(^|[[:space:]])nix-command($|[[:space:]])/) {
          $0 = $0 " nix-command"
        }
        if ($0 !~ /(^|[[:space:]])flakes($|[[:space:]])/) {
          $0 = $0 " flakes"
        }
        updated = 1
      }
      { print }
      END {
        if (updated == 0) {
          print "experimental-features = nix-command flakes"
        }
      }
    ' "$nix_conf" > "$tmp"
  else
    printf '%s\n' "experimental-features = nix-command flakes" > "$tmp"
  fi

  mv "$tmp" "$nix_conf"
}

load_nix_env_if_installed() {
  # shellcheck disable=SC1091
  if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  # shellcheck disable=SC1090
  elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
}

install_nix_if_missing() {
  if command -v nix >/dev/null 2>&1; then
    echo "==> Nix is already installed: $(command -v nix)"
    return 0
  fi

  echo "==> Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install)
  load_nix_env_if_installed

  echo ""
  echo "==> Nix installed. You may need to restart your shell."
  echo "    After restarting, run this script again."
  return 1
}

install_homebrew_if_missing() {
  if ! is_macos || command -v brew >/dev/null 2>&1; then
    return 0
  fi

  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

run_darwin_switch() {
  local dotfiles="$1"
  local profile="$2"

  echo "==> Running darwin-rebuild switch..."
  echo "    Using profile: $profile"

  sudo -H env DOTFILES_USERNAME="${USER:-}" DOTFILES_HOME="$HOME" DOTFILES_DIR="$dotfiles" nix run nix-darwin \
    --extra-experimental-features "nix-command flakes" \
    -- switch --flake ".#${profile}" --impure
}

run_home_manager_switch() {
  local dotfiles="$1"
  local config_name="${USER:-default}"

  echo "==> Running home-manager switch..."
  echo "    Using configuration: $config_name"

  DOTFILES_DIR="$dotfiles" nix run home-manager -- switch --flake ".#${config_name}" --impure -b backup
}
