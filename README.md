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

### zsh

```
# commands
. : cd dotfiles
.. : cd ../../
... : cd ../../../

c: clear
ggl: googler
```

### Move Around Tmux Pane and Vim Window
You can move around pane and window.

```
C-h select left pane 
C-j select down pane
C-k select up pane
C-l select right pane
```

### tmux
- change prefix to C-Space
- set default-shell as zsh
- set vim like key-bind
- set escape-time to 1
- set [base|pane-base] index to 1
- status bar

Tmux key bindings:

```
| vertical split
- horizontal split

H resize pane plus 5 to left
J resize pane plus 5 to down
K resize pane plus 5 to up
L resize pane plus 5 to right

c create window
x close current window

C-h select previous window
C-l select next window

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

#### Vim key bindings

Normal mode:
```
# Save and Quit
\w: write
\q: quit
\wq: write and quit
\z: write and quit all
\e: edit
\h: help

# Tab and Files
C-n: next tab
C-p: prevoius tab 
gf: open a file under the cursor

# Plugin
\r: QuickRun
\n: NERDTree
\nf: NERDTreeFind
\t: TagBar
\y: emmet-vim
\p: Previm open
\f: CtrlP

\pi: PlugInstall
\pu: PlugUpdate
\pc: PlugClean
\pg: PlugUpgrade

# Dotfiles
\.: open dotfiles with NERDTree
\ev: edit .vimrc
\et: edit .tmux.conf
\ez: edit .zshrc
\er: edit README.md
```

Insert mode:
```
C-[ : escape
Enter(after search): remove highlight

C-n: next suggest
C-p: previosu suggest
C-k: apply snipet
```

Command mode:
```
:QuickRun => quick run
:PrevimOpen => Previm open
```

#### Plugins:
Plugin Manager:
- [junegunn/vim-plug](https://github.com/junegunn/vim-plug)

Extensional Pane:
- [scrooloose/nerdtree](https://github.com/scrooloose/nerdtree)
- [jistr/vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs)
- [majutsushi/tagbar](https://github.com/majutsushi/tagbar)
- [szw/vim-tags](https://github.com/szw/vim-tags)

Code Runner & Previewer
- [Shougo/vimproc.vim](https://github.com/Shougo/vimproc.vim)
- [thinca/vim-quickrun](https://github.com/thinca/vim-quickrun)
- [kannokanno/previm](https://github.com/kannokanno/previm)
- [tyru/open-browser.vim](https://github.com/tyru/open-browser.vim)

Auto completion:
- [Shougo/neocomplete](https://github.com/Shougo/neocomplete)
- [Shougo/neocomplcache](https://github.com/Shougo/neocomplcache)
- [Shougo/neosnippet](https://github.com/Shougo/neosnippet)
- [Shougo/neosnippet-snippets](https://github.com/Shougo/neosnippet-snippets)
- [honza/vim-snippets](https://github.com/honza/vim-snippets)
- [alvan/vim-closetag](https://github.com/alvan/vim-closetag)
- [mattn/emmet-vim](https://github.com/mattn/emmet-vim)
- [tpope/vim-surround](https://github.com/tpope/vim-surround)
-
Syntax checker & highlighter:
- [scrooloose/syntastic](https://github.com/scrooloose/syntastic)
- [pmsorhaindo/syntastic-local-eslint.vim](https://github.com/pmsorhaindo/syntastic-local-eslint.vim)
- [plasticboy/vim-markdown](https://github.com/plasticboy/vim-markdown)
- [Yggdroot/indentLine](https://github.com/Yggdroot/indentLine)
- [hail2u/vim-css3-syntax](https://github.com/hail2u/vim-css3-syntax)
- [ryym/vim-riot](https://github.com/ryym/vim-riot)
- [posva/vim-vue](https://github.com/posva/vim-vue)
- [elzr/vim-json](https://github.com/elzr/vim-json)
- [jason0x43/vim-js-indent](https://github.com/jason0x43/vim-js-indent)
