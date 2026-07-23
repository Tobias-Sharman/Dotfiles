return {
	cmd = { "ansible-language-server", "--stdio" },

	filetypes = {
		"yaml.ansible",
	},

	root_markers = {
		"ansible.cfg",
		".ansible-lint",
		"roles",
		"playbook.yml",
		"site.yml",
		".git",
	},

	settings = {
		ansible = {
			ansible = {
				path = "ansible",
			},
			executionEnvironment = {
				enabled = false,
			},
			python = {
				interpreterPath = "python3",
			},
		},
	},
}
