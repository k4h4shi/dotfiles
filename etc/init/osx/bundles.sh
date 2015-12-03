#!/bin_bash

# Stop script if erroers occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# This script is only supported with OS X
if ! is_osx; then
    log_fail "error: this script is only supported with osx"
    exit 1
fi

if has "brew"; then
    if ! brew tap Homebrew/bundle; then
     log_fail "error: failed to tap Homebrew/bundle"
     exit 1
    fi

    buitin cd "$DOTPATH"/etc/init/assets/brew
    if [ ! -f Brewfile ]; then
      brew bundle dump
    fi

    brew bundle
else
    log_fail "error: require: brew"
    exit 1
fi

log_pass "brew: tapped succesfully"
