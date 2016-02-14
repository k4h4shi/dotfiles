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
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'Gist.vim'
NeoBundle 'sudo.vim'
NeoBundle 'ref.vim'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'myhere/vim-nodejs-complete'
call neobundle#end()

""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

" Required:
filetype plugin indent on	

" If there are uninstalled bundles fonund on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck


""""""""""""
" NERDTree "
""""""""""""
let NERDTreeShowHidden = 1
let file_name = expand("%:p")
autocmd vimenter * if !argc() | NERDTree | endif

"""""""""""""
" emmet-vim "
"""""""""""""
let g:user_emmet_leader_key='<c-e>'
let g:user_emmet_settings = {
    \    'variables': {
    \      'lang': "ja"
    \    },
    \   'indentatun': '  '
    \ }
"""""""""""""
" quick-run "
"""""""""""""
let g:quickrun_config={'*': {'split': ''}}

"""""""""""""
" quick-run "
"""""""""""""
autocmd FileType javascript setlocal omnifunc=nodejscomplete#CompleteJS
if !exists('g:neocomplcache_omni_functions')
  let g:neocomplcache_omni_functions = {}
endif
let g:neocomplcache_omni_functions.javascript = 'nodejscomplete#CompleteJS'
let g:node_usejscomplete = 1
imap <C-f> <C-x><C-o>
