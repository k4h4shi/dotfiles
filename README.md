# dotfiles
kotaro.t@k4h4shi's configuration for vim, zsh, tmux and more.

## Usage

### Git clone
You should first clone the repo and move into the derectroy.
```
git clone https://github.com/k4h4shi/dotfiles.git
cd dotfiles
```

### Make
You can deploy, install, clean, or destroy with make commands.

You can use `make help` to show the help same as down below.

```
init    => Initialize enviroment settings.
deploy  => Create symlinks to home directory.
update  => Fetch all changes from remote repo.
install => Run update, deploy, init.
clean   => remove the dotfiles.
destroy => remove the dotfiles and this repo.
```

### tmux
- change prefix to C-t
- set default-shell as zsh
- set vim like key-bind
- set escape-time to 1
- set [base|pane-base] index to 1
- status bar

Tmux key bindings:

```
| vertical split
- horizontal split

h select left pane
j select down pane
k select up pane
l select right pane

H resize pane plus 5 to left
J resize pane plus 5 to down
K resize pane plus 5 to up
L resize pane plus 5 to right

C-h select previous window
C-l select next window
C-o select pane

r reload .tmux.conf
```

Installed Plugins:
- tpm
- tmux-yank
- tmux-open
- tmux-battery
- tmux-sensible
- tmux-colors-solarized

### vim
Plugins:
- [junegunn/vim-plug](https://github.com/junegunn/vim-plug)
- [scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)
- [jistr/vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs)
- [Shougo/vimproc.vim](https://github.com/Shougo/vimproc.vim)
- [thinca/vim-quickrun](https://github.com/thinca/vim-quickrun)
- [Shougo/neocomplete](https://github.com/Shougo/neocomplete)
- [Shougo/neocomplcache](https://github.com/Shougo/neocomplcache)
- [Shougo/neosnippet](https://github.com/Shougo/neosnippet)
- [Shougo/neosnippet-snippets](https://github.com/Shougo/neosnippet-snippets)
- [honza/vim-snippets](https://github.com/honza/vim-snippets)
- [majutsushi/tagbar](https://github.com/majutsushi/tagbar)
- [szw/vim-tags](https://github.com/szw/vim-tags)
- [scrooloose/syntastic](https://github.com/scrooloose/syntastic)
- [pmsorhaindo/syntastic-local-eslint.vim](https://github.com/pmsorhaindo/syntastic-local-eslint.vim)
- [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown)
- [kannokanno/previm](https://github.com/kannokanno/previm)
- [tyru/open-browser.vim](https://github.com/tyru/open-browser.vim)
- [Yggdroot/indentLine](https://github.com/Yggdroot/indentLine)
- [alvan/vim-closetag](https://github.com/alvan/vim-closetag)
- [hail2u/vim-css3-syntax](https://github.com/hail2u/vim-css3-syntax)
- [mattn/emmet-vim](https://github.com/mattn/emmet-vim)
- [tpope/vim-surround](https://github.com/tpope/vim-surround)
- [ryym/vim-riot](https://github.com/ryym/vim-riot)
- [posva/vim-vue](https://github.com/posva/vim-vue)
- [elzr/vim-json](https://github.com/elzr/vim-json)
- [leafgarland/typescript-vim](https://github.com/leafgarland/typescript-vim)
- [jason0x43/vim-js-indent](https://github.com/jason0x43/vim-js-indent)
- [rizzatti/dash.vim](https://github.com/rizzatti/dash.vim)
