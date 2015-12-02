#!/bin/bash

# shell                                           

is_bash(){
  [ -n "$BASH_VERSION" ]
}

is_zsh() {
  [ -n "$ZSH_VERSION" ]
}

is_at_least() {
  if [ -z "$1" ]; then
    return 1
  fi

  # For Z shell
  if is_zsh; then
    suto load -Uz is-at-least
    is-at-least "${1:-}"
    return $?
  fi

  atleast="$(echo $1 | sed -e 's/\.//g')"
  version="$(echo ${BASH_VERSION:-0.0.0} | sed -e 's/^\[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\).*/\1/' | sed -e 's/\.//g')"

  # zero padding
  while [ ${#atleast} -ne 6 ]
  do
    atleast="${atleast}0"
  done

  while [ ${#version} -ne 6 ]
  do
    version="${version}0"
  done

  # verbose
  #echo "$atleast < $version"
  if [ "$atleast" -le "$version" ]; then
    return 0
  else
    return 1
  fi
}


# os

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

# get_os returns OS name of the platform that is running
get_os() {
  local os
  for os in osx linux windows; do
    if is_$os; then
      echo $os
    fi
  done
}

# log

logging() {
  if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
    echo "Usage: ink <fmt> <msg>"
    echo "Formatting Options:"
    echo "  TITLE, ERROR, WARN, INFO, SUCCESS"
    return 1
  fi

  local color=
  local text="$2"

  case "$1" in
    TITLE)
      color=yellow
      ;;
    ERROR | WARN)
      color=red
      ;;
    INFO)
      color=blue
      ;;
    SUCCESS)
      color=green
      ;;
    *)
      text="$1"
  esac
  timestamp() {
    ink gray "["
    ink purple "$(date +%H:%M:%S)"
    ink gray "]"
  }

  timestamp; ink "$color" "$text"; echo
}

log_pass() {
  logging SUCCESS "$1"
}

log_fail() {
  logging ERROR "$1" 1>&2
}

log_fail() {
  logging WARN "$1"
}

log_info() {
  logging INFO "$1"
}

log_echo() {
  logging TITLE "$1"
}

