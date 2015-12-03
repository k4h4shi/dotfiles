bindkey -v
autoload -Uz compinit; compinit
setopt auto_cd
alias ...='cd ../..'
alias ....='cd ../../..'
alias dotfiles='cd /Users/kotaro/dotfiles'
hash  
setopt auto_pushd
# setopt pushd_ignore_daps
setopt extended_glob
setopt hist_ignore_space
# zsyle ':completion:*:default' menu select=1
WORDCHARS='*?_-.[]~=&;!#%^(){}<>'

# google search by w3m
funciton google() {
	local str opt
	if [ $ != 0 ]; then
	for i in $*;
 	do
		str="$str+$i"
	done
	str=`echo $str | sed 's/^\+//'`
	opt='search?num=50&hl=ja&lr=lang_ja'
	fi
	w3m http://www.google.co.jp/$opt
}
