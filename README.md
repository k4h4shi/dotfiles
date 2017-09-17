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
