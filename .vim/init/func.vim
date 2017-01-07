"""""""""""""
" Functions "
"""""""""""""
function! Meet_neocomplete_requirements()
  return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

