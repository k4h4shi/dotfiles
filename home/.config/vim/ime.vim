" IME: switch to English (ABC) when entering Normal mode (macOS).
" - Works in both Vim and Neovim.
" - Requires `macism`.

if !executable('macism')
  finish
endif

let s:last = 0.0

function! s:ime_to_english() abort
  " Throttle: avoid spawning macism too frequently on rapid mode transitions.
  let now = reltimefloat(reltime())
  if now - s:last < 0.2
    return
  endif
  let s:last = now

  let english = get(g:, 'ime_english_input_source', 'com.apple.keylayout.ABC')

  " Prefer async job APIs if available.
  if exists('*jobstart')
    call jobstart(['macism', english], {'detach': v:true})
  elseif exists('*job_start')
    call job_start(['macism', english])
  else
    " Last resort (sync): keep it quiet.
    silent! call system('macism ' . shellescape(english))
  endif
endfunction

augroup ime_to_english
  autocmd!
  autocmd VimEnter * call s:ime_to_english()
  if exists('##ModeChanged')
    autocmd ModeChanged *:n* call s:ime_to_english()
  else
    " Fallback for older Vim: best-effort.
    autocmd InsertLeave * call s:ime_to_english()
  endif
augroup END

