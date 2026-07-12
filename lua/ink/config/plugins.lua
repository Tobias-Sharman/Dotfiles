vim.pack.add({
	-- LSP configuration helpers
	{
		src = "https://github.com/neovim/nvim-lspconfig",
	},

	-- Formatting
	{
		src = "https://github.com/stevearc/conform.nvim",
	},

	-- Linting
	{
		src = "https://github.com/mfussenegger/nvim-lint",
	},

	-- Completion
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = "v1",
	},

	-- Fuzzy finding
	{
		src = "https://github.com/ibhagwan/fzf-lua",
	},

	-- Git signs / hunks
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
	},

	-- Automatic pairs
	{
		src = "https://github.com/windwp/nvim-autopairs",
	},

	-- Icons
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons",
	},

	-- Statusline
	{
		src = "https://github.com/nvim-lualine/lualine.nvim",
	},

	-- Markdown preview

	{
		src = "https://github.com/OXY2DEV/markview.nvim",
	},
})

require("ink.config.format").setup()

require("ink.config.lint").setup()

require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<Tab>"] = {
			"accept",
			"fallback",
		},
		["<S-Tab>"] = {
			"select_prev",
			"fallback",
		},
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = {
			auto_show = true,
		},
	},
})

require("fzf-lua").setup({})

require("gitsigns").setup({})

require("nvim-autopairs").setup({})

require("nvim-web-devicons").setup({})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto", -- TODO: Later once colour management is more sophisticated maybe not auto
		component_separators = {
			left = "",
			right = "",
		},
		section_separators = {
			left = "",
			right = "",
		},
	},

	sections = {
		lualine_a = {
			"mode",
		},
		lualine_b = {
			"branch",
			"diff",
			"diagnostics",
		},
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_x = {
			"searchcount",
			"selectioncount",
			"filetype",
		},
		lualine_y = {
			"progress",
		},
		lualine_z = {
			"location",
		},
	},
})

require("markview").setup({
	preview = {
		enable = true,

		icon_provider = "internal", -- you have nvim-web-devicons installed
		debounce = 0,

		splitview_winopts = {
			split = "right",
			win = 0,
		},
	},
})
