if [ -f ~./bashrc ]; then
        source ~/.bashrc
fi
export PATH=/usr/local/bin:$PATH
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
eval "$(rbenv init -)"
