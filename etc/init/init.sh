#!/bin/bash

# stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit1' ERR INT
set -eu


if [ -z "$DOTPATH" ]; then
    echo '$DOTPATH not set' >&2
    exit 1
fi

source "$DOTPATH"/etc/lib/core.sh
source "$DOTPATH"/etc/lib/lang.sh
source "$DOTPATH"/etc/lib/util.sh
source "$DOTPATH"/etc/lib/io.sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing 'sudo' time stamp
#             until this script has finished
while true
do
    sudo -n true
    # wait 60 sec
    sleep 60;
    kill -0 "$$" || exit
done 2>/dev/null &

for i in "$DOTPATH"/etc/init/"$(get_os)"/*.sh
do
  if [ -f "$i" ]; then
    log_info "$(e_arrow "$(basename "$i")")"
      if [ "${DEBUG:-}" != 1 ]; then
        bash "$i"
      fi
  else
    continue
  fi
done

log_pass "$0: Finish!!" | sed "s $DOTPATH \$DOTPATH g"
