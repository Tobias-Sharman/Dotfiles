require("ink.lsp.keymaps")

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

vim.lsp.enable({
	"clangd",
})
