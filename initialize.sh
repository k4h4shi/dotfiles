#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# if script exists
dir=$(cd $(dirname $0);pwd)
# ignorefiles
ignorefiles=("." ".." ".git" "${0##*/}")

for dotfile in .?*; do
	is_ignored=0
	for ignorefile in ${ignorefiles[@]}; do
		if [ $dotfile = $ignorefile ]; then
			is_ignored=1
			break
		fi
	done

	if [ $is_ignored -ne 1 ]; then
  		ln -s -v -f "$dir/$dotfile" $HOME
	fi
done
