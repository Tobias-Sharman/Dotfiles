local M = {}

local function make(source, flavour)
	return function()
		local raw = require("ink.palettes." .. source).get(flavour)
		return require("ink.palettes.maps." .. source).from_palette(raw, flavour)
	end
end

local sources = {
	catppuccin_latte = make("catppuccin", "latte"),
	catppuccin_frappe = make("catppuccin", "frappe"),
	catppuccin_macchiato = make("catppuccin", "macchiato"),
	catppuccin_mocha = make("catppuccin", "mocha"),
}

function M.get(name)
	name = name or vim.g.ink_palette or "catppuccin_mocha"

	local get_palette = sources[name]

	if not get_palette then
		vim.notify("Unknown ink palette: " .. name, vim.log.levels.ERROR)
		get_palette = sources.catppuccin_mocha
	end

	return get_palette()
end

function M.has(name)
	return sources[name] ~= nil
end

function M.names()
	return vim.tbl_keys(sources)
end

return M
