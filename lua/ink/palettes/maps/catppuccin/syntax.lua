local U = require("ink.palettes.maps.catppuccin.util")

local M = {}

function M.from_palette(cat, flavour)
	return {
		Comment = {
			fg = cat.overlay2,
			italic = true,
		}, -- just comments

		SpecialComment = { link = "Special" }, -- special things inside a comment

		Constant = { fg = cat.peach }, -- any constant

		String = { fg = cat.green }, -- string constant
		Character = { fg = cat.teal }, -- character constant
		Number = { fg = cat.peach }, -- number constant
		Float = { link = "Number" }, -- floating point constant
		Boolean = { fg = cat.peach }, -- boolean constant

		Identifier = { fg = cat.flamingo }, -- any variable name
		Function = { fg = cat.blue }, -- function name

		Statement = { fg = cat.mauve }, -- any statement
		Conditional = { fg = cat.mauve }, -- if, then, else, endif, switch
		Repeat = { fg = cat.mauve }, -- for, do, while
		Label = { fg = cat.sapphire }, -- case, default
		Operator = { fg = cat.sky }, -- sizeof, +, *, etc.
		Keyword = { fg = cat.mauve }, -- any other keyword
		Exception = { fg = cat.mauve }, -- try, catch, throw

		PreProc = { fg = cat.pink }, -- generic preprocessor
		Include = { fg = cat.mauve }, -- #include
		Define = { link = "PreProc" }, -- #define
		Macro = { fg = cat.mauve }, -- same as Define
		PreCondit = { link = "PreProc" }, -- #if, #else, #endif

		StorageClass = { fg = cat.yellow }, -- static, register, volatile
		Structure = { fg = cat.yellow }, -- struct, union, enum
		Special = { fg = cat.pink }, -- special symbol
		Type = { fg = cat.yellow }, -- int, long, char
		Typedef = { link = "Type" }, -- typedef

		SpecialChar = { link = "Special" }, -- special character in a constant

		Tag = {
			fg = cat.lavender,
			bold = true,
		}, -- tags

		Delimiter = { fg = cat.overlay2 }, -- delimiter character
		Debug = { link = "Special" }, -- debugging statements

		Underlined = { underline = true },
		Bold = { bold = true },
		Italic = { italic = true },

		Error = { fg = cat.red }, -- erroneous construct

		Todo = {
			bg = cat.flamingo,
			fg = cat.base,
			bold = true,
		}, -- TODO, FIXME, XXX

		qfLineNr = { fg = cat.yellow },
		qfFileName = { fg = cat.blue },

		htmlH1 = {
			fg = cat.pink,
			bold = true,
		},

		htmlH2 = {
			fg = cat.blue,
			bold = true,
		},

		mkdCodeDelimiter = {
			bg = cat.base,
			fg = cat.text,
		},

		mkdCodeStart = {
			fg = cat.flamingo,
			bold = true,
		},

		mkdCodeEnd = {
			fg = cat.flamingo,
			bold = true,
		},

		-- debugging
		debugPC = {
			bg = cat.crust,
		}, -- current line in terminal-debug

		debugBreakpoint = {
			bg = cat.base,
			fg = cat.overlay0,
		}, -- breakpoint colours in terminal-debug

		-- illuminate
		illuminatedWord = { bg = cat.surface1 },
		illuminatedCurWord = { bg = cat.surface1 },

		-- diff
		Added = { fg = cat.green },
		Changed = { fg = cat.blue },

		diffAdded = { fg = cat.green },
		diffRemoved = { fg = cat.red },
		diffChanged = { fg = cat.blue },
		diffOldFile = { fg = cat.yellow },
		diffNewFile = { fg = cat.peach },
		diffFile = { fg = cat.blue },
		diffLine = { fg = cat.overlay0 },
		diffIndexLine = { fg = cat.teal },

		DiffAdd = {
			bg = U.darken(cat.green, 0.18, cat.base),
		}, -- diff mode added line

		DiffChange = {
			bg = U.darken(cat.blue, 0.07, cat.base),
		}, -- diff mode changed line

		DiffDelete = {
			bg = U.darken(cat.red, 0.18, cat.base),
		}, -- diff mode deleted line

		DiffText = {
			bg = U.darken(cat.blue, 0.30, cat.base),
		}, -- diff mode changed text

		-- Neovim health
		healthError = { fg = cat.red },
		healthSuccess = { fg = cat.teal },
		healthWarning = { fg = cat.yellow },

		-- misc glyphs
		GlyphPalette1 = { fg = cat.red },
		GlyphPalette2 = { fg = cat.teal },
		GlyphPalette3 = { fg = cat.yellow },
		GlyphPalette4 = { fg = cat.blue },
		GlyphPalette6 = { fg = cat.teal },
		GlyphPalette7 = { fg = cat.text },
		GlyphPalette9 = { fg = cat.red },

		-- rainbow
		rainbow1 = { fg = cat.red },
		rainbow2 = { fg = cat.peach },
		rainbow3 = { fg = cat.yellow },
		rainbow4 = { fg = cat.green },
		rainbow5 = { fg = cat.sapphire },
		rainbow6 = { fg = cat.lavender },

		-- csv
		csvCol0 = { fg = cat.red },
		csvCol1 = { fg = cat.peach },
		csvCol2 = { fg = cat.yellow },
		csvCol3 = { fg = cat.green },
		csvCol4 = { fg = cat.sky },
		csvCol5 = { fg = cat.blue },
		csvCol6 = { fg = cat.lavender },
		csvCol7 = { fg = cat.mauve },
		csvCol8 = { fg = cat.pink },

		-- markdown
		markdownHeadingDelimiter = {
			fg = cat.peach,
			bold = true,
		},

		markdownCode = { fg = cat.flamingo },
		markdownCodeBlock = { fg = cat.flamingo },

		markdownLinkText = {
			fg = cat.blue,
			underline = true,
		},

		markdownH1 = { link = "rainbow1" },
		markdownH2 = { link = "rainbow2" },
		markdownH3 = { link = "rainbow3" },
		markdownH4 = { link = "rainbow4" },
		markdownH5 = { link = "rainbow5" },
		markdownH6 = { link = "rainbow6" },
	}
end

return M
