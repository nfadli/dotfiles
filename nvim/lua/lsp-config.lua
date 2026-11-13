vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
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
				library = {
					vim.env.VIMRUNTIME,
				},
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

local servers = {
	"lua_ls",
	"vtsls",
	"tailwindcss",
	"emmet_ls",
	"css",
	"zls",
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
