#!/bin/bash

# PLATFORM is the environment variable that
# retrieves the name of the runnnig platform
export PLATFORM

# ostype returns the lowercase OS name
ostype() {
  uname | lower
}

# os_detect export the PLATFORM variable as runnning os
os_detect() {
    export PLATFORM
    case "$(ostype)" in
        *'linux'*)      PLATFORM='linux'   ;;
        *'darwin'*)     PLATFORM='osx'     ;;
        *'mingw32_nt'*) PLATFORM='windows' ;;
        *)              PLATFORM='unknown' ;;
    esac
}

# is_osx returns true if the PLATFORM is osx
is_osx() {
    os_detect
    if [ "$PLATFORM" = "osx" ]; then
        return 0
    else
        return 1
    fi
}
alias is_mac=is_osx

# is_linux returns true if the PLATFORM is linux
is_linux() {
    os_detect
    if [ "$PLATFORM" = "linux" ]; then
        return 0
    else
        return 1
    fi
}

# is_windows returns true if the PLATFORM is windows
is_windows() {
    os_detect
    if [ "$PLATFORM" = "windows" ]; then
        return 0
    else
        return 1
    fi
}

# get_os returns os name of the PLATFORM that is runnnig
get_os() {
  local os
  for os in osx linux windows; do
      if is_$os; then
          echo $os
      fi
  done
}
