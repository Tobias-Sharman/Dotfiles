local M = {}

local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")

	return {
		tonumber(hex:sub(1, 2), 16),
		tonumber(hex:sub(3, 4), 16),
		tonumber(hex:sub(5, 6), 16),
	}
end

function M.blend(fg, bg, alpha)
	local fg_rgb = hex_to_rgb(fg)
	local bg_rgb = hex_to_rgb(bg)

	local function channel(index)
		local value = alpha * fg_rgb[index] + (1 - alpha) * bg_rgb[index]
		return math.floor(math.min(math.max(0, value), 255) + 0.5)
	end

	return string.format("#%02X%02X%02X", channel(1), channel(2), channel(3))
end

function M.darken(hex, amount, bg)
	return M.blend(hex, bg or "#000000", math.abs(amount))
end

function M.lighten(hex, amount, fg)
	return M.blend(hex, fg or "#ffffff", math.abs(amount))
end

function M.vary(flavour, by_flavour, default)
	if by_flavour[flavour] ~= nil then
		return by_flavour[flavour]
	end

	return default
end

function M.style(...)
	local spec = {}

	for _, style in ipairs({ ... }) do
		spec[style] = true
	end

	return spec
end

function M.with(spec, extra)
	return vim.tbl_extend("force", spec, extra)
end

return M
