" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = { 'mode' : 'active' }
let g:syntastic_ruby_checkers=['rubocop', 'mri']
let g:syntastic_javascript_checkers=['eslint']

let g:syntasitic_enable_signs = 1
let g:syntasitic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

