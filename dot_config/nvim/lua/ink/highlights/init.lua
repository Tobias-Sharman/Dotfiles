local palettes = require("ink.palettes")

local M = {}

local modules = {
	"editor",
	"syntax",
	"treesitter",
	"lsp",
	"semantic_tokens",
	"terminal",
	"integrations",
}

function M.apply(name)
	name = name or vim.g.ink_palette or "catppuccin_mocha"

	vim.opt.termguicolors = true
	vim.g.colors_name = "ink-" .. name

	vim.cmd("highlight clear")

	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end

	local ink = palettes.get(name)
	local set = vim.api.nvim_set_hl

	for _, module in ipairs(modules) do
		require("ink.highlights." .. module).apply(set, ink)
	end
end

return M
