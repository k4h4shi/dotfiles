-- LazyVim enables spell for markdown by default (wrap_spell autocmd).
-- Disable that behavior cleanly (instead of fighting it with extra autocmds).
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("k4h4shi-disable-lazyvim-wrap-spell", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    -- LazyVim creates this augroup name.
    pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

    -- Recreate the original behavior without markdown.
    local group = vim.api.nvim_create_augroup("lazyvim_wrap_spell", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = { "text", "plaintex", "typst", "gitcommit" },
      callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
      end,
    })
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
