bindkey -v
autoload -Uz compinit; compinit
setopt auto_cd
alias ...='cd ../..'
alias ....='cd ../../..'
alias dotfiles='cd $HOME/src/github.com/k4h4shi/dotfiles/'
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

# ruby 
export PATH=$PATH:/usr/local/bin:/usr/local/Cellar/typesafe-activator/1.2.12:~/Documents/lib/play-2.2.3:$HOME/.rbenv/bin

eval "$(rbenv init -)"
