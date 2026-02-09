" Common settings shared by Vim and Neovim.
" Keep this file small: only truly-editor-agnostic defaults and keymaps.

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch
set nospell
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" Clipboard (Neovim: unnamedplus. Vim: falls back if unsupported.)
if has('clipboard')
  set clipboard^=unnamedplus
endif

" Basic keymaps (muscle memory)
inoremap jj <Esc>
cnoremap jj <BS><C-c>

" IME handling (macOS)
silent! source ~/.config/vim/ime.vim
