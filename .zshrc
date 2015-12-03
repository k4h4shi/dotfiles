bindkey -v
autoload -Uz compinit; compinit
setopt auto_cd
alias ...='cd ../..'
alias ....='cd ../../..'
alias dotfiles='cd /Users/kotaro/dotfiles'
hash  
setopt auto_pushd
# setopt pushd_ignore_daps
setopt extended_glob
setopt hist_ignore_space
# zsyle ':completion:*:default' menu select=1
WORDCHARS='*?_-.[]~=&;!#%^(){}<>'

