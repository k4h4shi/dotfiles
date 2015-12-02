#!/bin/bash


newline() {
  printf "\n"
}

header() {
  printf " \033[37;1m%s\033[m\n" "$*"
}

error() {
  printf " \033[31m%s\033[m\n" "✖ $*" 1>&2
}

warning() {
  printf " \033[31m%s\033[m\n" " $*"
}

done() {
  printf " \033[37;1m%s\033[m...\033[32mOK\033[m\n" "✔ $*"
}

arrow() {
  printf " \033[37;1m%s\033[m\n" "➜ $*"
}

indent() {
  for ((i=0; i<${1:-4}; i++)); do
      echon " "
  done
  if [ -n "$2"]; then
      echo "$2"
  else
      cat <&0
  fi
}

echon() {
  echo "$*" | tr -d '\n'
}

noecho() {
  if [ "$(echo -n)" = "-n" ]; then
   echo "${*:-> }\c"
  fi
}

success() {
  printf " \033[37;1m%s\033[m%s...\033[32mOK\033[m\n" "✔ " "$*"
}

failure() {
  die "${1:-$FUNCNAME}"
}
ink() {
  if [ "$#" -eq 0 -o "$#" -gt 2 ]; then
    echo "Usage: ink <color> <text>"
    echo "Colors:"
    echo "  black, white, red, green, yellow, blue, purple, cyan, gray"
    return 1
  fi
  
  local open="\033["
  local close="${open}0m"
  local black="0;30m"
  local red="1;31m"
  local green="1;32m"
  local yellow="1;33m"
  local blue="1;34m"
  local purple="1;35m"
  local cyan="1;36m"
  local gray="0;37m"
  local white="$close"

  local text="$1"
  local color="$close"

  if [ "$#" -eq 2 ]; then
    text="$2"
    case "$1" in
        black | red | green | yellow | blue | purple | cyan | gray | white)
        eval color="\$$1"
        ;;
    esac
  fi

  printf "${open}${color}${text}${close}"
}

