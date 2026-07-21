local M = {}

function M.apply(set, ink)
	for group, spec in pairs(ink.integrations) do
		if spec ~= nil then
			set(0, group, spec)
		end
	end
end

return M
