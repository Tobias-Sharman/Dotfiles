local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = {
	"clangd",
	"lua_ls",
	-- "nil",
}

for _, server in ipairs(servers) do
	local config = require("ink.lsp.servers." .. server)

	config.capabilities = capabilities

	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end
