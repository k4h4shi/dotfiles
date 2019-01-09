set bell-style visible
eval "$(rbenv init -)"

# brew-wrap
if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

# alias
alias dotfiles="cd ~/src/github.com/k4h4shi/dotfiles"
