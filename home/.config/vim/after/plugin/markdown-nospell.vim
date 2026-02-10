" Force spell off for Markdown-ish buffers.
"
" Some plugins/colorschemes enable spell later than ftplugin (e.g. on BufEnter).
" Using multiple events makes this resilient.
augroup k4h4shi_markdown_nospell
  autocmd!
  autocmd FileType markdown,markdown.pandoc,markdown.mdx setlocal nospell
  autocmd BufEnter,WinEnter *.md,*.markdown,*.mdx setlocal nospell
  " If something enables spell later, immediately turn it back off for Markdown buffers.
  autocmd OptionSet spell if &l:filetype =~# '^markdown\\%($\\|\\.\\)' || expand('%:e') =~# '^\%(md\|markdown\|mdx\)$' | setlocal nospell | endif
augroup END
