""""""""""""
" NERDTree "
""""""""""""
let g:NERDTreeChDirMode=2
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 30
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.db
nnoremap <silent> <leader>nf :NERDTreeFind<CR>
noremap <leader>n :NERDTreeToggle<CR>


