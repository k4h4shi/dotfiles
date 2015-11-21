bindkey -v
autoload -Uz compinit; compinit
setopt auto_cd
alias ...='cd ../..'
alias ....='cd ../../..'
hash -d home=/Users/kotaro/src/github.com/k4h4shi/dotfiles
setopt auto_pushd
setopt pushd_ignore_daps
setopt extended_glob
setopt hist_ignore_space
zsyle ':completion:*:default' menu select=1
WORDCHARS='*?_-.[]~=&;!#%^(){}<>'
