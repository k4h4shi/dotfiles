" vim-plug self managing
if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')

"" vim-plug
Plug 'junegunn/vim-plug',
        \ {'dir': '~/.vim/plugged/vim-plug/autoload'}

"" nerdtree
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
Plug 'jason0x43/vim-js-indent'
Plug 'ryym/vim-riot'
Plug 'posva/vim-vue'

"" JSON syntax
Plug 'elzr/vim-json'


call plug#end()

