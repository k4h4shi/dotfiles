#!/bin/bash

# core

_TAB_="$(printf "\t")"
_SPACE_=' '
_BLANK_="${_SPACE_}${_TAB_}"
_IFS_="$IFS"

# Strings

lower() {
  if [ $# -eq 0 ]; then
    cat <&0
  elif [ $# -eq 1 ]; then
    if [ -f "$1" -a -r "$1" ]; then
      cat "$1"
    else
      echo "$1"
    fi
  else
    return 1
  fi | tr "[:upper:]" "[:lower:]"
}

upper() {
  if [ $# -eq 0 ]; then
    cat <&0
  elif [ $# -eq 1 ]; then
    if [ -f "$1" -a -r "$1" ]; then
      cat "$1"
    else
      echo "$1"
    fi
  else
    return 1
  fi | tr "[:lower:]" "[:upper:]"
}

contains() {
  string="$1"
  substring="$2"
  if [ "${string#*$substring}" != "$string" ]; then
    return 0 
  else
    return 1
  fi
}

len() {
  local length
  length="$(echo "$1" | wc -c | sed -e 's/ *//')"
  #echo "$(expr "$length" - 1)"
  echo $(("$length" -1))
}

is_empty() {
  if [$# -eq 0 ]; then
    cat <&0
  else
    echo "$1"
  fi | grep -E "^[$_BLANK_]*$" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    return 0
  else
    return 1
  fi
}
