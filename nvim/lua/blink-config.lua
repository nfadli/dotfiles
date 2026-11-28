vim.pack.add({
	"https://github.com/mrcjkb/rustaceanvim",
})
vim.pack.add({
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
})
require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({ virtual_text = false })

vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons", version = "stable" },
})
require("mini.icons").setup()
require("mini.icons").mock_nvim_web_devicons()

vim.pack.add({
	"https://github.com/saghen/blink.lib",
	{ src = "https://github.com/saghen/blink.pairs", version = vim.version.range("*") },
})
require("blink.pairs").download():pwait(60000)
require("blink.pairs").setup()

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
		menu = {
			border = "single",
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind", gap = 1 },
					{ "source_name" },
				},
				components = {
					source_name = {
						text = function(ctx)
							return "[" .. ctx.source_name .. "]"
						end,
					},
				},
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
})
vim.pack.add({
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
})
require("nvim-ts-autotag").setup({})
vim.pack.add({
	{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
})

require("tree-sitter-manager").setup({
	auto_install = true,
	highlight = true,
})
