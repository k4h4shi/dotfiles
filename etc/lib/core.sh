#!/bin/bash

# set DOTPATH as default variable
if [ -z "${DOTPPATH:-}" ]; then
  DOTPATH=~/.dotfiles; export DOTPATH
fi

# is_exists returns true if excutable $1 exists $PATH
is_exists() {
  which "$1" >/dev/null 2>&1
  return $?
}

# has is wrapper function
has() {
  is_exists "$@"
}

# die returns exit code eroor and echo error message
die() {
  e_error "$1" 1>&2
  exit "${2:-1}"
}

# is_login_shell returns true if current shell is first shell
is_login_shell() {
  [ "$SHLVL" = 1]
}

# is_git_repo returns true if cwd is in git repository
is_git_repo() {
  git rev-parse --is-inside-work-tree &>/dev/null
  return $?
}

# is_screen_runnning returns true if GNU screen is running
is_screen_running() {
  [ ! -z "$STY" ]
}

# is_tmux_runnning returns true if rmux is running 
is_tmux_running() {
  [ ! -z "$TMUX" ]
}
# is_screen_or_tmux_runnning returns true if GNU screen or tmux is running
is_screnen_or_tmux_running() {
  is_screen_running || is_tmux_running
}

# shell_has_started_interactively returns true if the current shell is 
# running from command line
shell_has_started_interactively() {
  [ ! -z "SSH_CLIENT" ]
}

# is_ssh_running returns true if the ssh deamon is available
is_ssh_running() {
  [ ! -z "$SSH_CLIENT" ]
}

# is_debug returns true if $DEBUG is set
is_debug() {
  if [ "$DEBUG" = 1 ]; then
    return 0
  else
    return 1
  fi
}
alias is_int=is_number
alias is_num=is_number

# path_remove returns new $PATH trailing $1 in $PATH removed
path_remove() {
  if [ $# -eq 0 ]; then
    die "too few arguments"
  fi

  local arg path

  path=":$PATH:"

  for arg in "$@"
  do
    path="${path//:$arg:/:}"
  done

  path="${path%:}"
  path="${path#:}"

  echo "$path"
}
