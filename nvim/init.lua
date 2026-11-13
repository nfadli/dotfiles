if vim.g.vscode then
	vim.opt.clipboard = "unnamedplus"
	vim.opt.ignorecase = true
	vim.opt.smartcase = false
	vim.opt.iskeyword:append({ "-" })

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	local vscode = require("vscode")
	local keymap = vim.keymap.set
	local opts = { noremap = true, silent = true }
	keymap("n", "<leader>e", function()
		vscode.action("oil-code.open")
	end, opts)

	keymap("n", "<C-j>", function()
		vscode.action("workbench.action.terminal.toggleTerminal")
	end, opts)

	keymap("n", "<leader>r", function()
		vscode.action("workbench.action.openRecent")
	end, opts)

	keymap("n", "<leader>b", function()
		vscode.action("workbench.action.closeActiveEditor")
	end, opts)

	keymap("n", "<leader>w", function()
		vscode.action("workbench.action.files.save")
	end, opts)

	keymap("n", "H", function()
		vscode.action("workbench.action.previousEditor")
	end, opts)

	keymap("n", "L", function()
		vscode.action("workbench.action.nextEditor")
	end, opts)
	keymap("n", "<leader>nh", function()
		vim.cmd("nohlsearch")
		vscode.action("notifications.clearAll")
	end, opts)
else
	vim.env.CC = "gcc"
	require("options")
	require("keymaps")
	require("oil-config")
	require("snacks-config")
	require("flash-config")
	require("conform-config")
	require("tree-sitter-config")
	require("lsp-config")
	require("blink-config")
	require("etc-config")
end
