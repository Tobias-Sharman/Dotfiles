local M = {}

local function has_name_upward(bufnr, names)
	local file = vim.api.nvim_buf_get_name(bufnr)

	if file == "" then
		return false
	end

	return vim.fs.find(names, {
		path = vim.fs.dirname(file),
		upward = true,
		limit = 1,
	})[1] ~= nil
end

function M.setup()
	local lint = require("lint")

	lint.linters_by_ft = {
		go = {
			"golangcilint",
		},

		sh = {
			"shellcheck",
		},

		bash = {
			"shellcheck",
		},

		zsh = {
			"shellcheck",
		},

		sql = {
			"sqlfluff",
		},

		dockerfile = {
			"hadolint",
		},
	}
end

function M.lint(bufnr)
	if vim.bo[bufnr].buftype ~= "" then
		return
	end

	local ft = vim.bo[bufnr].filetype

	if
		ft == "sql"
		and not has_name_upward(bufnr, {
			".sqlfluff",
			"pyproject.toml",
			"setup.cfg",
			"tox.ini",
		})
	then
		return
	end

	if ft == "go" and not has_name_upward(bufnr, {
		"go.work",
		"go.mod",
		".git",
	}) then
		return
	end

	require("lint").try_lint()
end

return M
