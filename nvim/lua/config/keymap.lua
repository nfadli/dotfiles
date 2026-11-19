vim.g.mapleader = " "
local map = vim.api.nvim_set_keymap

map("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "Out" })
map("n", "<leader>w", ":w<cr>", { noremap = true, silent = true, desc = "Save" })
map("n", "<leader>q", ":q<cr>", { noremap = true, silent = true, desc = "Save" })
