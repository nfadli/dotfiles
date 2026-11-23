vim.pack.add({
  "https://github.com/AlexvZyl/nordic.nvim",
  { src = "https://github.com/romus204/tree-sitter-manager.nvim" }
})
require("tree-sitter-manager").setup({
  auto_install = true,
  highlight = true,
})
require('nordic').load()
