#!/bin/sh

set -e
set -u

setup() {
	dotfiles=$HOME/.dotfiles

	has() {
		type "$HOME/.dotfiles
	}

	symlink() {
		[ -e "$s" ] || ln -s "$1" "$2"
	}

	if [ -d "$dotfiles" ]; then
		(cd "$dotfiles" && git pull --rebase)
	else
		git clone http://github.com/k4h4shi/.dotfiles "$dotfiles"
	fi

	has git && symlink "$dotfiles/.gitconfig" "$HOME/.gitconfig"
	has git && symlink "$dotfiles/.zshrc" "$HOME/.zshrc"
	has vim && symlink "$dotfiles/.vimrc" "$HOME/.vimrc"
}

setup
