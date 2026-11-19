vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		go = { "gofumpt", "goimports" },
		rust = { "rustfmt" },
		sh = { "shfmt" },
		javascript = { "oxfmt" },
		javascriptreact = { "oxfmt" },
		typescript = { "oxfmt" },
		typescriptreact = { "oxfmt" },
		json = { "oxfmt" },
		jsonc = { "oxfmt" },
		html = { "oxfmt" },
		css = { "oxfmt" },
		scss = { "oxfmt" },
		less = { "oxfmt" },
		vue = { "oxfmt" },
		svelte = { "oxfmt" },
		astro = { "oxfmt" },
		graphql = { "oxfmt" },
		yaml = { "oxfmt" },
		markdown = { "oxfmt" },
		mdx = { "oxfmt" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = {
		timeout_ms = 500,
	},
})
