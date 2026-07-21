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

function M.from_palette(cat, flavour)
	local ink = {}

	for _, module in ipairs(modules) do
		ink[module] = require("ink.palettes.maps.catppuccin." .. module).from_palette(cat, flavour)
	end

	return ink
end

return M
