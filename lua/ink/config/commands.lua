local palettes = require("ink.palettes")
local state = require("ink.state")

vim.api.nvim_create_user_command("Ink", function(opts)
	local palette = opts.args

	if not palettes.has(palette) then
		vim.notify("Unknown ink palette: " .. palette, vim.log.levels.ERROR)
		return
	end

	vim.g.ink_palette = palette
	state.set_palette(palette)

	require("ink.highlights").apply(palette)
end, {
	nargs = 1,
	complete = function()
		return palettes.names()
	end,
})
