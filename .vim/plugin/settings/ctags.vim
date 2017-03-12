" ctags
let g:vim_tag_project_tags_command = "/usr/local/Celler/ctags/5.8_1/bin/ctags -f .tags -R . 2>/dev/null"
let g:vim_tags_gems_command = "/usr/local/Cellar/ctags/5.8_1/bin/ctags -R -f .Gemfile.lock.tag `bundle show --paths` 2>/dev/null"
let g:vim_tags_suto_generate = 1
set tags+=.tags
set tags+=.Gemfile.lock.tags

if has("path_extra")
  set tags+=tags;
endif

