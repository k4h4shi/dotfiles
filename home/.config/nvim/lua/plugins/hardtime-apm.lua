return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },
  {
    "ThePrimeagen/vim-apm",
    cmd = "VimApm",
    config = function()
      vim.g.vim_apm_log_level = "info"
    end,
  },
}
