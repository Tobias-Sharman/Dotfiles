local M = {}

local function has_name_upward_from_dir(dir, names)
	if dir == nil or dir == "" then
		return false
	end

	return vim.fs.find(names, {
		path = dir,
		upward = true,
		limit = 1,
	})[1] ~= nil
end

function M.setup()
	local conform = require("conform")

	conform.setup({
		notify_on_error = true,
		notify_no_formatters = false,

		formatters_by_ft = {
			c = {
				"clang-format",
			},

			cpp = {
				"clang-format",
			},

			objc = {
				"clang-format",
			},

			objcpp = {
				"clang-format",
			},

			cuda = {
				"clang-format",
			},

			lua = {
				"stylua",
			},

			sh = {
				"shfmt",
			},

			bash = {
				"shfmt",
			},

			zsh = {
				"shfmt",
			},

			sql = {
				"sqlfluff",
			},

			go = {
				"goimports",
				"gofumpt",
			},

			terraform = {
				"terraform_fmt",
			},

			yaml = {
				"yamlfmt",
			},

			["*"] = {
				"trim_whitespace",
				"trim_newlines",
			},
		},

		formatters = {
			["clang-format"] = {
				condition = function(_, ctx)
					return has_name_upward_from_dir(ctx.dirname, {
						".clang-format",
					})
				end,
			},

			stylua = {
				condition = function(_, ctx)
					return has_name_upward_from_dir(ctx.dirname, {
						"stylua.toml",
						".stylua.toml",
					})
				end,
			},

			sqlfluff = {
				condition = function(_, ctx)
					return has_name_upward_from_dir(ctx.dirname, {
						".sqlfluff",
						"pyproject.toml",
						"setup.cfg",
						"tox.ini",
					})
				end,
			},
		},
	})
end

function M.format(bufnr)
	if vim.bo[bufnr].buftype ~= "" then
		return
	end

	require("conform").format({
		bufnr = bufnr,
		async = false,
		timeout_ms = 2000,
		lsp_format = "fallback",
	})
end

return M
