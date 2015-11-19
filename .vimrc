set tabstop=4

"""""""""""""
" Neo Bundle 
"""""""""""""
set nocompatible	"be iMproved
filetype off

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
	call neobundle#begin(expand('~/.vim/bundle/'))
	NeoBundleFetch 'Shougo/neobundle.vim'
	" originalrepos on git hub
	NeoBundle 'Shougo/neobundle.vim'
	NeoBundle 'Shougo/vimproc'
	NeoBundle 'vimClojure'
	NeoBundle 'Shougo/vimshell'
	NeoBundle 'Shougo/unite.vim'
	NeoBundle 'Shougo/neocomplcashe'
	NeoBundle 'Shougo/neosnippet'
	NeoBundle 'Shougo/vim-slime'
	NeoBundle 'Shougo/syntastic'
	call neobundle#end()
endif
""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

filetype plugin indent on	" requied!
filetype indent on
syntax on

