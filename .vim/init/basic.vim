"""""""""""""""
" Basic Setup "
"""""""""""""""
let mapleader="\<Space>"

"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"" Fix backspace indent
set backspace=indent,eol,start

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files
set nobackup
set noswapfile

set fileformats=unix,dos,mac
set showcmd
set shell=/bin/zsh

set whichwrap=h,l,b,s,<,>,[,]

"" Copy/Paste/Cut
set clipboard=unnamed,unnamedplus

" Indent
set tabstop=2
set autoindent
set shiftwidth=2
set expandtab

"" disalbe auto comment 
autocmd FileType * setlocal formatoptions-=ro

"" show doble quote in JSON
let g:vim_json_syntax_conceal = 0