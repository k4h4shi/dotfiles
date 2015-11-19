set tabstop=4

"""""""""""""
" Neo Bundle 
"""""""""""""
set nocompatioble	"be iMproved
filetype off

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
	call neobundle#rc(expand('~/.vim/bundle/'))
endif
" originalrepos on git hub
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'vimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcashe'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vim-slime'
NeoBundle 'Shougo/syntastic'
""NeoBundle 'https://bitbucket.org/kovisoft/slimv'



