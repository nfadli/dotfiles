vim.g.mapleader = " "
map = vim.api.nvim_set_keymap
map("i", "jk", "<Esc>", {})
map("n", "<leader>w", ":w<cr>", {})
map("n", "<leader>q", ":q<cr>", {})
map("n", "<leader>nh", ":nohl<cr>", {})
