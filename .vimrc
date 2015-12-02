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

" set color
syntax on
" use jj as <ESC>
inoremap <silent> jj <ESC>

"""""""""""""
" Neo Bundle 
"""""""""""""

if has('vim_starting')
	set nocompatible		" Be IMproved

	" required:
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" Requird:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBudle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
" check for uninstalled plugin

" originalrepos on git hub
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'Gist.vim'
NeoBundle 'sudo.vim'
NeoBundle 'ref.vim'

call neobundle#end()

""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

" Required:
filetype plugin indent on	

" If there are uninstalled bundles fonund on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck


""""""""""
"NERDTree
""""""""""
let NERDTreeShowHidden = 1
let file_name = expand("%:p")
autocmd vimenter * if !argc() | NERDTree | endif



