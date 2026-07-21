return {
	cmd = { "gopls" },

	filetypes = {
		"go",
		"gomod",
		"gowork",
		"gotmpl",
	},

	root_markers = {
		"go.work",
		"go.mod",
		".git",
	},

	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,

			analyses = {
				unusedparams = true,
				shadow = true,
				nilness = true,
				unusedwrite = true,
			},

			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
