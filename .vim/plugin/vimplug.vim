call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs' 

"" vimproc
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

"" quickrun
Plug 'thinca/vim-quickrun'

"" 補完
if Meet_neocomplete_requirements()
  Plug 'Shougo/neocomplete'
else
  Plug 'Shougo/neocomplcache'
endif

"" スニペット
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

"" ctags
Plug 'majutsushi/tagbar'
Plug 'szw/vim-tags'

"" 構文チェック
Plug 'scrooloose/syntastic'
Plug 'pmsorhaindo/syntastic-local-eslint.vim'

"" markdownプレビュー
Plug 'plasticboy/vim-markdown'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'

"" indent可視化
Plug 'Yggdroot/indentLine'

"" HTML/CSS
Plug 'alvan/vim-closetag'
Plug 'hail2u/vim-css3-syntax'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'

"" js
Plug 'ryym/vim-riot'

"" ruby
Plug 'tpope/vim-endwise'
Plug 'osyo-manga/vim-monster'

"" JSON syntax
Plug 'elzr/vim-json'

Plug 'leafgarland/typescript-vim'
Plug 'jason0x43/vim-js-indent'

"" アウトライン表示
Plug 'Shougo/unite.vim'
Plug 'h1mesuke/unite-outline'
call plug#end()
