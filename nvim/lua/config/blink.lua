vim.pack.add({
	"https://github.com/rafamadriz/friendly-snippets",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
})
require("blink.cmp").setup({
	keymap = { preset = "default" },

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = { auto_show = false },
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
})
--
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
})
local servers = { "lua_ls", "clangd", "tailwindcss", "vtsls", "emmet_ls", "cssls" }
vim.lsp.enable(servers)
vim.pack.add({
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})
require("fidget").setup({})
require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({ virtual_text = false })
