""""""""""""
"my setting
""""""""""""""
" vimのエンコーディングをutf-8にする。
set encoding=utf-8

" ファイルフォーマットを設定
set fileformats=unix,dos,mac

" set color
syntax on

" about tab
set tabstop=2
set autoindent
set shiftwidth=2
set expandtab

" number
set number


" use jj as <ESC>
inoremap <silent> jj <ESC>

"activate load plugin as file type
filetype plugin indent on

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
" auto complete
NeoBundle 'myhere/vim-nodejs-complete'
NeoBundle 'marcus/rsense'
NeoBundle 'supermomonga/neocomplete-rsense.vim'

" static analysis
NeoBundle 'scrooloose/syntasitc'

" refs
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vimref-ri'

" tag jump
NeoBundle 'szw/vim-tags'

" close automaticaly 
NeoBundle 'tpope/vim-endwise'

call neobundle#end()

""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

j" Required:
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
"""""""""""""
" Rsense "
"""""""""""""
let g:rsenseHome = '/usr/local/bin/rsense'
let g:rsenseUseOmniFunc = 1

"""""""""""""""""""
" neocomplete.vim "
"""""""""""""""""""

let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#force_omini_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'

"""""""""""
" rubocop "
"""""""""""
" syntastic_mode_mapをactivveにすy流とバッファ保存時にsysntasticが走るa
" activefiletypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = {'mode' : 'passive', 'active_filetypes' : ['ruby'] }
let g:systastci_ruby_checkers = ['rubocop']

