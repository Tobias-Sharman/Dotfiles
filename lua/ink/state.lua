local M = {}

local state_dir = vim.fn.stdpath("state") .. "/ink"
local palette_file = state_dir .. "/palette"

function M.get_palette()
	local file = io.open(palette_file, "r")

	if not file then
		return nil
	end

	local palette = file:read("*l")
	file:close()

	if palette == "" then
		return nil
	end

	return palette
end

function M.set_palette(palette)
	vim.fn.mkdir(state_dir, "p")

	local file = io.open(palette_file, "w")

	if not file then
		vim.notify("Could not save ink palette", vim.log.levels.ERROR)
		return
	end

	file:write(palette)
	file:close()
end

return M
