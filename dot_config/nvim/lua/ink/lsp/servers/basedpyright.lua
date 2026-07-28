return {
	cmd = { "basedpyright-langserver", "--stdio" },

	filetypes = {
		"python",
	},

	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},

	single_file_support = true,

	before_init = function(_, config)
		local venv = vim.fs.find(".venv", {
			path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
			upward = true,
			limit = 1,
		})[1]
		if venv then
			config.settings.basedpyright.pythonPath = venv .. "/bin/python"
		end
	end,

	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "standard",
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",

				diagnosticSeverityOverrides = {
					reportUnusedImport = "none",
					reportUnusedVariable = "none",
				},

				inlayHints = {
					callArgumentNames = true,
					variableTypes = true,
					functionReturnTypes = true,
					genericTypes = false,
				},
			},
		},
	},
}
