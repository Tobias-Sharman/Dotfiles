local M = {}

function M.from_palette(cat, flavour)
	return {
		terminal_color_0 = cat.overlay0,
		terminal_color_8 = cat.overlay1,

		terminal_color_1 = cat.red,
		terminal_color_9 = cat.red,

		terminal_color_2 = cat.green,
		terminal_color_10 = cat.green,

		terminal_color_3 = cat.yellow,
		terminal_color_11 = cat.yellow,

		terminal_color_4 = cat.blue,
		terminal_color_12 = cat.blue,

		terminal_color_5 = cat.pink,
		terminal_color_13 = cat.pink,

		terminal_color_6 = cat.sky,
		terminal_color_14 = cat.sky,

		terminal_color_7 = cat.text,
		terminal_color_15 = cat.text,
	}
end

return M
