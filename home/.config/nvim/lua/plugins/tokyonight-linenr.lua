return {
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      opts = opts or {}
      local prev = opts.on_highlights

      opts.on_highlights = function(hl, c)
        if type(prev) == "function" then
          prev(hl, c)
        end

        -- Keep it within TokyoNight palette, just more legible.
        hl.LineNr = { fg = c.comment }
        hl.LineNrAbove = { fg = c.comment }
        hl.LineNrBelow = { fg = c.comment }
        hl.CursorLineNr = { fg = c.blue, bold = true }
      end
    end,
  },
}

