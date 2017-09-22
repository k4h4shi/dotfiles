"""""""""""""""
" Basic Setup "
"""""""""""""""
" - set {option}={string}: set option
" - let {variable}={value}: declear variable
" - autocmd [group] {event} {pat} {cmd}: execute cmd when specific event 
"   happen.

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

""""""""""""""""""
" Keymap Setting "
""""""""""""""""""
" - nmap: normal mode
" - imap: insert mode
" - xmap: visual mode
" - ormap: OR
" - normap: NOR

" use jj as <ESC>
" inoremap <silent> jj <ESC>
" remove hilight when type <CR> after Searching with /.
nnoremap <CR> :noh<CR><CR>


""""""""""""""""""""""""
" Functions & commands "
""""""""""""""""""""""""
" # if statement
" if { condition1 } 
"   { statement1 } 
" elseif { condition2 }
"   { statement2 } 
" else
"   { statement3 }
" endif
"
" # for statement
" for { var } in { list }
"   { statement }
" endfor
" 
" # while statement
" while { condition }
"   { statement }
" endwhile
"
" # function 
" function! {funcname}({args})
"   { statement }
" endfunction
" 
" # command
" command! { command }
"

function! Meet_neocomplete_requirements()
  return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

"""""""""""""""""""
" Visual Settings "
"""""""""""""""""""
syntax enable
set ruler

"""""""""""""""""""
" Plugin Settings "
"""""""""""""""""""
runtime! plugin/*.vim
runtime! plugin/settings/*.vim
