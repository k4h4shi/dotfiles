if [ -f ~./bashrc ]; then
        source ~/.bashrc
fi
export PATH="/usr/local/sbin:$PATH"
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
eval "$(rbenv init -)"
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

