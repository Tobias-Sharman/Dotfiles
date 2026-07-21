-- ============================================================================
-- Colour scheme
-- ============================================================================

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

-- ============================================================================
-- Cmake toolings
-- ============================================================================

local M = {}

local function run(command)
	vim.cmd("!" .. command)
end

function M.cmake_configure()
	run("cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && ln -sf build/compile_commands.json compile_commands.json")
end

function M.cmake_build()
	run("cmake --build build")
end

function M.cmake_configure_and_build()
	run(
		"cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && ln -sf build/compile_commands.json compile_commands.json && cmake --build build"
	)
end

function M.cmake_test()
	run("ctest --test-dir build --output-on-failure")
end

return M
