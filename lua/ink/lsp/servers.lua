local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("clangd", {
	capabilities = capabilities,

	cmd = {
		"clangd",
	},

	filetypes = {
		"c",
		"cpp",
		"objc",
		"objcpp",
		"cuda",
	},

	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
})

vim.lsp.enable("clangd")
