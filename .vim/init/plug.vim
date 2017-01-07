""""""""""""""""""
" Neo Bundle Core"
""""""""""""""""""
if has('vim_starting')
	set nocompatible		" Be iMproved

	" Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

let neobundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
let solarized_vim=expand('~/.vim/colors/solarized.vim')

let g:vim_bootstrap_langs = "javascript,ruby,html"
let g:vim_bootstrap_editor = "vim"

if !filereadable(neobundle_readme)
  echo "Installing NeoBundle..."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim/
  let g:not_finish_neobundle = "yes"

  " Run shell script if exist on custom select language
endif

if !filereadable(solarized_vim)
  echo "Installing Solarized Theme..."
  echo ""

  silent !mkdir -p ~/.vim/colors
  silent !mkdir -p ~/.vim/tmp
  silent !git clone https://github.com/altercation/vim-colors-solarized.git ~/.vim/tmp/solarized
  !mv ~/.vim/tmp/solarized/colors/solarized.vim ~/.vim/colors/
endif

" Requird:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBudle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

""""""""""""""""""""""""""""""
" NeoBundle install packages "
""""""""""""""""""""""""""""""
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'scrooloose/nerdtree'

"" vimproc
NeoBundle 'Shougo/vimproc.vim', {
\  'build' : {
\    'windows' : 'tools\\update-dll-mingw',
\    'cygwin'  : 'make -f make_cygwin.mak',
\    'mac'     : 'make -f make_mac.mak',
\    'linux'   : 'make -f make_mac.mak',
\    'unix'    : 'gmake -f make_mac.mak',
\  },
\ }

"" quickrun
NeoBundle 'thinca/vim-quickrun'

"" 補完
if Meet_neocomplete_requirements()
  NeoBundle 'Shougo/neocomplete'
else
  NeoBundle 'Shougo/neocomplcache'
endif

"" スニペット
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'honza/vim-snippets'

"" ctags
NeoBundle 'majutsushi/tagbar'
NeoBundle 'szw/vim-tags'

"" 構文チェック
NeoBundle 'scrooloose/syntastic'
NeoBundle 'pmsorhaindo/syntastic-local-eslint.vim'

"" markdownプレビュー
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'

"" indent可視化
NeoBundle 'Yggdroot/indentLine'

"" HTML/CSS
NeoBundle 'alvan/vim-closetag'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'tpope/vim-surround'

"" ruby
NeoBundle 'tpope/vim-endwise'
NeoBundle 'osyo-manga/vim-monster'

"" JSON syntax
NeoBundle 'elzr/vim-json'

NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'jason0x43/vim-js-indent'

call neobundle#end()

" Required:
filetype plugin indent on	

" If there are uninstalled bundles fonund on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
