# Homebrew
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# nodenv
export PATH="$HOME/.nodenv/shims:$PATH"

# Android
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"

# Java
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Rust
source "$HOME/.cargo/env"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias python=python3
alias pip=pip3
