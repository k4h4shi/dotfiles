# enviroment var
export LANG=ja_JP.UTF-8
export EDITOR=vim

# vim like key bind
bindkey -v

# enable auto complete
autoload -Uz compinit; compinit

setopt correct
setopt auto_cd
setopt no_beep

# alias
alias .='$HOME/src/github.com/k4h4shi/dotfiles/'
alias ...='cd ../..'
alias ....='cd ../../..'

alias g='cd $(ghq root)/$(ghq list | peco)'
alias gh='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
alias gv='vim $(ghq list -p | peco)/README.md'

alias ggl='googler'
alias c='clear'

alias k4h4shi.com='$HOME/src/github.com/k4h4shi/k4h4shi.com/'

hash  

setopt auto_pushd

# setopt pushd_ignore_daps
setopt extended_glob
setopt hist_ignore_space

# zsyle ':completion:*:default' menu select=1
WORDCHARS='*?_-.[]~=&;!#%^(){}<>'

export PATH="/usr/local/bin:$PATH"

# export GOPATH
export GOPATH="$HOME"
export PATH="$PATH:$HOME/bin"

# peco
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# brew-file
if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap 
fi

clear
