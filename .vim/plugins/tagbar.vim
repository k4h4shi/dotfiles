" tagbar
if ! empty(neobundle#get("tagbar"))
  let g:tagbar_width = 20
  nn <silent> <leader>t : TagbarToggle<CR>
endif
