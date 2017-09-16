# dotfiles
kotaro.t@k4h4shi's configuration for vim, zsh, tmux and more.

## Usage

### git clone
You should first clone the repo and move into the derectroy.
```
git clone https://github.com/k4h4shi/dotfiles.git
cd dotfiles
```

### Make
You can deploy, install, clean, or destroy with make commands.

You can use `make help` to show the help same as down below.

```
- init    => Initialize enviroment settings.
- deploy  => Create symlinks to home directory.
- update  => Fetch all changes from remote repo.
- install => Run update, deploy, init
- clean   => remove the dotfiles
- destroy => remove the dotfiles and this repo
```
