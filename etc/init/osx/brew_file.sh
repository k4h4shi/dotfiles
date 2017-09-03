#!/bin_bash

source "$DOTPATH"/etc/lib/core.sh
source "$DOTPATH"/etc/lib/lang.sh
source "$DOTPATH"/etc/lib/io.sh
source "$DOTPATH"/etc/lib/util.sh

# Stop script if erroers occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# This script is only supported with OS X
if ! is_osx; then
    log_fail "error: this script is only supported with osx"
    exit 1
fi

if has "brew"; then

    if ! brew update; then 
      log_fail "error: failed to update home brew"
      exit 1
    fi

    if ! brew doctor; then
      log_fail "error: failed to brew doctor"
      exit 1
    fi

    if brew install rcmdnk/file/brew-file; then
     log_pass "rcmdnk/file/brew-file is already installed" 
    else
     log_fail "error: failed to clone rcmdnk/file/brew-file"
     exit 1
    fi

    builtin cd "$DOTPATH"/
    if [ ! -f .brewfile/Brewfile ]; then
      brew bundle install
    fi
  
else
    log_fail "error: require: brew"
    exit 1
fi

log_pass "brew: Brew-file installed sccessfully!"
