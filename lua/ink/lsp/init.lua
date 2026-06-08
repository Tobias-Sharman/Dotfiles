require("ink.lsp.keymaps")
require("ink.lsp.servers")

vim.diagnostic.config({
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})
