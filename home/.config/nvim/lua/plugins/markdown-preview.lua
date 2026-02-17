return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    init = function()
      local node = vim.fn.exepath("node")
      if node == "" then
        local nix_node = ("/etc/profiles/per-user/%s/bin/node"):format(vim.env.USER or "")
        if vim.fn.executable(nix_node) == 1 then
          node = nix_node
        end
      end

      if node ~= "" then
        vim.g.mkdp_node_command = node
      end
    end,
    build = function()
      vim.fn["mkdp#util#install_sync"](1)
    end,
  },
}
