vim.pack.add({
  "https://github.com/j-hui/fidget.nvim",
  { src = 'https://github.com/neovim/nvim-lspconfig' },
})
require("fidget").setup {}
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
          },
        },
      },
    },
  },
  vtsls = {},
  tailwindcss = {},
  emmet_ls = {},
  clangd = {},
}

for server, config in pairs(servers) do
  if next(config) ~= nil then
    vim.lsp.config(server, config)
  end
  vim.lsp.enable(server)
end
