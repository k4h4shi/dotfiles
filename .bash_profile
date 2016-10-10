if [ -f ~./bashrc ]; then
        source ~/.bashrc
fi
export PATH=/usr/local/bin:$PATH
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
eval "$(rbenv init -)"
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ANDROID_SDK_ROOT
export PATH=$ANDROID_SDK_ROOT:$PATH
export PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$PATH

export PATH=/usr/local/sbin:/tools:/platform-tools::/Users/kotaro/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
