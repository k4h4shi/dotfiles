"""""""""""
" rubocop "
"""""""""""
" syntastic_mode_mapをactivveにするとバッファ保存時にsysntasticが走る
" activefiletypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = {'mode' : 'passive', 'active_filetypes' : ['ruby'] }
let g:systastic_ruby_checkers = ['rubocop']

