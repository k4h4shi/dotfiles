set tabstop=4
set number
"""""""""""""
" Neo Bundle 
"""""""""""""
set nocompatible	"be iMproved
filetype plugin indent off

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
	call neobundle#begin(expand('~/.vim/bundle/'))
	NeoBundleFetch 'Shougo/neobundle.vim'
	" check for uninstalled plugin
	NeoBundleCheck

	" originalrepos on git hub
	NeoBundle 'Shoug/unite.vim'
	NeoBundle 'Shoug/vimproc'
	NeoBundle 'The-NERD-tree'
	NeoBundle 'The-NERD-Commiter'
	NeoBundle 'Gist.vim'
	call neobundle#end()
endif
""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

filetype plugin indent on	" requied!
filetype indent on
syntax on


""""""""""
"NERDTree
""""""""""
let NERDTreeShowHidden = 1
let file_name = expand("%:p")
if has('vim_starting') && file_name == ""
		autocmd VimEnter * execute 'NERDTree ./'
endif
