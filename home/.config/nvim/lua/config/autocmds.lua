-- Keep spell off for Markdown. LazyVim enables spell for some text filetypes.
local aug = vim.api.nvim_create_augroup("k4h4shi-markdown", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
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
