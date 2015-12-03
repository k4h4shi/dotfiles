if [ -f ~./bashrc ]; then
        source ~/.bashrc
fi
export PATH=/usr/local/bin:$PATH
eval "$(rbenv init -)"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
