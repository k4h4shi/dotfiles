return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- Remap picker split from <C-s> (tmux prefix) to <C-x>.
      -- Snacks normalizes keys internally (e.g. <c-s> -> <C-S>).
      opts = opts or {}
      opts.picker = opts.picker or {}
      opts.picker.win = opts.picker.win or {}

      opts.picker.win.input = opts.picker.win.input or {}
      opts.picker.win.input.keys = opts.picker.win.input.keys or {}
      opts.picker.win.input.keys["<C-S>"] = false
      opts.picker.win.input.keys["<C-X>"] = { "edit_split", mode = { "i", "n" } }

      opts.picker.win.list = opts.picker.win.list or {}
      opts.picker.win.list.keys = opts.picker.win.list.keys or {}
      opts.picker.win.list.keys["<C-S>"] = false
      opts.picker.win.list.keys["<C-X>"] = "edit_split"
    end,
  },
}
