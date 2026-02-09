vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Common Vimscript settings shared by Vim/Neovim live in ~/.config/vim/common.vim
do
  local common_vimrc = vim.fn.stdpath("config") .. "/../vim/common.vim"
  if vim.fn.filereadable(common_vimrc) == 1 then
    vim.cmd("silent source " .. vim.fn.fnameescape(common_vimrc))
  end
end
