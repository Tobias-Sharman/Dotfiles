local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = {
	"ansible-language-server",
	"bash-language-server",
	"clangd",
	"docker-language-server",
	"gopls",
	"lua_ls",
	"terraform-ls",
	-- "nil",
}

for _, server in ipairs(servers) do
	local config = require("ink.lsp.servers." .. server)

	config.capabilities = capabilities

	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end
