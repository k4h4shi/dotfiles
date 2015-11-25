"""""""""""""
"my setting
""""""""""""""
" about tab
set tabstop=2
set autoindent
set shiftwidth=2
set expandtab

" number
set number

" use jj as <ESC>
inoremap <silent> jj <ESC>

"""""""""""""
" Neo Bundle 
"""""""""""""

if has('vim_starting')
	set nocompatible		" Be IMproved

	" Required:
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" Requird:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBudle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
" check for uninstalled plugin

" originalrepos on git hub
NeoBundle 'Shoug/unite.vim'
NeoBundle 'Shoug/vimproc'
NeoBundle 'The-NERD-tree'
NeoBundle 'The-NERD-Commiter'
NeoBundle 'Gist.vim'

call neobundle#end()

""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

" Required:
filetype plugin indent on	

" If there are uninstalled bundles fonund on startup,
" this will conveniently prompt you to install them.
"NeoBundleCheck


""""""""""
"NERDTree
""""""""""
let NERDTreeShowHidden = 1
let file_name = expand("%:p")
if has('vim_starting') && file_name == ""
		autocmd VimEnter * execute 'NERDTree ./'
endif
