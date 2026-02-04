# Entrypoint for zsh. Keep this file writable for installer scripts.

# Load Home Manager's zsh config if present.
if [[ -f "$HOME/.config/zsh/.zshrc" ]]; then
  source "$HOME/.config/zsh/.zshrc"
fi

# --- Installer scripts may append below ---
