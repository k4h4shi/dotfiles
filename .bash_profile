if [ -f ~./bashrc ]; then
        source ~/.bashrc
fi
export PATH=/usr/local/bin:$PATH
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
eval "$(rbenv init -)"
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
