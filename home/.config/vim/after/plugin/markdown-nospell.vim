" Force spell off for Markdown-ish buffers.
"
" Some plugins/colorschemes enable spell later than ftplugin (e.g. on BufEnter).
" Using multiple events makes this resilient.
augroup k4h4shi_markdown_nospell
  autocmd!
  autocmd FileType markdown,markdown.pandoc,markdown.mdx setlocal nospell
  autocmd BufEnter,WinEnter *.md,*.markdown,*.mdx setlocal nospell
augroup END

