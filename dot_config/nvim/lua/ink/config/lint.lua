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
		c = {
			"clangtidy",
		},

		cpp = {
			"clangtidy",
		},

		objc = {
			"clangtidy",
		},

		objcpp = {
			"clangtidy",
		},

		go = {
			"golangcilint",
		},

		python = {
			"ruff",
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

		terraform = {
			"tflint",
		},

		dockerfile = {
			"hadolint",
		},

		yaml = {
			"ansible_lint",
		},
	}
end

function M.lint(bufnr)
	if vim.bo[bufnr].buftype ~= "" then
		return
	end

	local ft = vim.bo[bufnr].filetype

	if
		(ft == "c" or ft == "cpp" or ft == "objc" or ft == "objcpp")
		and not has_name_upward(bufnr, {
			"compile_commands.json",
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

	if ft == "terraform" and not has_name_upward(bufnr, {
		".tflint.hcl",
	}) then
		return
	end

	if
		ft == "yaml"
		and not has_name_upward(bufnr, {
			"ansible.cfg",
			"roles",
			"playbook.yml",
			"site.yml",
		})
	then
		return
	end

	require("lint").try_lint()
end

return M
