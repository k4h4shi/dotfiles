-- LazyVim enables spell for markdown by default (wrap_spell autocmd).
-- Override only markdown *after* LazyVim sets its autocmds, without touching LazyVim internals.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("k4h4shi-markdown-nospell", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    local markdown_fts = { "markdown", "markdown.pandoc", "markdown.mdx", "mdx" }
    local group = vim.api.nvim_create_augroup("k4h4shi-markdown-nospell-ft", { clear = true })

    -- New markdown buffers: ensure spell stays off.
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = markdown_fts,
      callback = function()
        vim.opt_local.spell = false
      end,
    })

    -- Existing markdown buffers: fix immediately when VeryLazy fires.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(markdown_fts, vim.bo[buf].filetype) then
        vim.bo[buf].spell = false
      end
    end
  end,
})

-- Allow terminal background (Ghostty opacity/background-image) to show through.
-- Colorschemes often set an explicit background for these highlight groups.
do
  local function make_transparent()
    local set = vim.api.nvim_set_hl
    local none = { bg = "none" }
    set(0, "Normal", none)
    set(0, "NormalNC", none)
    set(0, "SignColumn", none)
    set(0, "EndOfBuffer", none)
    set(0, "NormalFloat", none)
    set(0, "FloatBorder", none)
  end

  local aug2 = vim.api.nvim_create_augroup("k4h4shi-transparent-bg", { clear = true })
  vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = aug2,
    callback = make_transparent,
  })

  -- Apply immediately for cases where init runs after a colorscheme is already set.
  make_transparent()
end
