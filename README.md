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
- [junegunn/vim-plug](https://github.com/junegunn/vim-plug): Plugin manager
- [scrooloose/nerdtree](https://github.com/scrooloose/nerdtree):  File system explorer
- [jistr/vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs): Plugin making NERDTree like a true panel. shared among tabs.
- [Shougo/vimproc.vim](https://github.com/Shougo/vimproc.vim): Asynchronous executer.
- [thinca/vim-quickrun](https://github.com/thinca/vim-quickrun): Source code  runner.
- [Shougo/neocomplete](https://github.com/Shougo/neocomplete): Auto complete with cache
- [Shougo/neocomplcache](https://github.com/Shougo/neocomplcache): Substitution for neocomplete
- [Shougo/neosnippet](https://github.com/Shougo/neosnippet): Auto complete with Snippete
- [Shougo/neosnippet-snippets](https://github.com/Shougo/neosnippet-snippets): Standard Snippets for neosnippete
- [honza/vim-snippets](https://github.com/honza/vim-snippets): Snippets files for various programming languages
- [majutsushi/tagbar](https://github.com/majutsushi/tagbar): A class outline viewer
- [szw/vim-tags](https://github.com/szw/vim-tags): The Ctags generator for vim
- [scrooloose/syntastic](https://github.com/scrooloose/syntastic): An external syntax checker
- [pmsorhaindo/syntastic-local-eslint.vim](https://github.com/pmsorhaindo/syntastic-local-eslint.vim): ESLint runner for syntastics
- [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown): Syntax highlighting, matching rules and mappings for markdown
- [kannokanno/previm](https://github.com/kannokanno/previm): A previewr for markdown
- [tyru/open-browser.vim](https://github.com/tyru/open-browser.vim): Open URI with a browser from editor
- [Yggdroot/indentLine](https://github.com/Yggdroot/indentLine): A plugin used for displaying thin vertical lines at each indentation.
- [alvan/vim-closetag](https://github.com/alvan/vim-closetag): Auto tag closer
- [hail2u/vim-css3-syntax](https://github.com/hail2u/vim-css3-syntax): syntax highliter for CSS 3
- [mattn/emmet-vim](https://github.com/mattn/emmet-vim): emmet for vim
- [tpope/vim-surround](https://github.com/tpope/vim-surround): utility for surroundings.
- [ryym/vim-riot](https://github.com/ryym/vim-riot): syntax highlighting and indentation for riot.js
- [posva/vim-vue](https://github.com/posva/vim-vue): syntax highlighting for vue.js
- [elzr/vim-json](https://github.com/elzr/vim-json): Distinct highlighting of keywords vs values, JSON-specific (non-JS) warnings, quote concealing.
- [leafgarland/typescript-vim](https://github.com/leafgarland/typescript-vim): Typescript syntax files for Vim
- [jason0x43/vim-js-indent](https://github.com/jason0x43/vim-js-indent): Vim indenter for standalone and embedded JavaScript and TypeScrip
- [rizzatti/dash.vim](https://github.com/rizzatti/dash.vim): search for dash from vim 
