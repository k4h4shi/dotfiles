#!/bin/bash

# install homebrew
# https://brew.sh/index_ja.html 
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install brewfile
brew doctor || exit;
brew install argon/mas/mas
brew install rcmdnk/file/brew-file

## run brewfile install
brew file install
exit;
