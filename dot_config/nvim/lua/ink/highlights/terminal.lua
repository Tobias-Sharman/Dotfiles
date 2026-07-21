local M = {}

function M.apply(set, ink)
	for name, colour in pairs(ink.terminal) do
		vim.g[name] = colour
	end
end

return M
