local M = {}

local flavours = {
	latte = true,
	frappe = true,
	macchiato = true,
	mocha = true,
}

function M.get(flavour)
	flavour = flavour or "mocha"

	if not flavours[flavour] then
		vim.notify("Unknown Catppuccin flavour: " .. flavour, vim.log.levels.ERROR)
		flavour = "mocha"
	end

	return require("ink.palettes.catppuccin." .. flavour)
end

return M
