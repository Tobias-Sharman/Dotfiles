local U = require("ink.palettes.maps.catppuccin.util")

local M = {}

function M.from_palette(cat, flavour)
	local cursor_line = U.vary(
		flavour,
		{
			latte = U.lighten(cat.mantle, 0.70, cat.base),
		},
		U.darken(cat.surface0, 0.64, cat.base)
	)

	return {
		ColorColumn = { bg = cat.surface0 }, -- used for the columns set with 'colorcolumn'
		Conceal = { fg = cat.overlay1 }, -- placeholder characters substituted for concealed text

		Cursor = { fg = cat.base, bg = cat.rosewater }, -- character under the cursor
		lCursor = { fg = cat.base, bg = cat.rosewater }, -- cursor when language-mapping is used
		CursorIM = { fg = cat.base, bg = cat.rosewater }, -- cursor in IME mode

		CursorColumn = { bg = cat.mantle }, -- screen-column at the cursor
		CursorLine = { bg = cursor_line }, -- screen-line at the cursor

		Dimmed = { fg = cat.overlay1 },
		Directory = { fg = cat.blue }, -- directory names
		EndOfBuffer = { fg = cat.surface1 }, -- filler lines after the end of the buffer

		ErrorMsg = {
			fg = cat.red,
			bold = true,
			italic = true,
		}, -- error messages on the command line

		VertSplit = { fg = cat.crust }, -- column separating vertically split windows

		Folded = {
			fg = cat.blue,
			bg = cat.surface1,
		}, -- line used for closed folds

		FoldColumn = { fg = cat.overlay0 }, -- 'foldcolumn'
		SignColumn = { fg = cat.surface1 }, -- column where signs are displayed
		SignColumnSB = { bg = cat.crust, fg = cat.surface1 }, -- sidebar sign column

		Substitute = {
			bg = cat.surface1,
			fg = U.vary(flavour, { latte = cat.red }, cat.pink),
		}, -- substitute replacement text

		LineNr = { fg = cat.surface1 }, -- line number
		CursorLineNr = { fg = cat.lavender }, -- cursor-line number

		MatchParen = {
			fg = cat.peach,
			bg = U.darken(cat.surface1, 0.70, cat.base),
			bold = true,
		}, -- matching parenthesis

		ModeMsg = {
			fg = cat.text,
			bold = true,
		}, -- showmode message

		MsgSeparator = { link = "WinSeparator" }, -- separator for scrolled messages
		MoreMsg = { fg = cat.blue }, -- more prompt
		NonText = { fg = cat.overlay0 }, -- non-text characters

		Normal = {
			fg = cat.text,
			bg = cat.base,
		}, -- normal text

		NormalNC = {
			fg = cat.text,
			bg = cat.base,
		}, -- normal text in non-current windows

		NormalSB = {
			fg = cat.text,
			bg = cat.crust,
		}, -- normal text in sidebar windows

		NormalFloat = {
			fg = cat.text,
			bg = cat.mantle,
		}, -- normal text in floating windows

		FloatBorder = {
			fg = cat.blue,
			bg = cat.mantle,
		},

		FloatTitle = {
			fg = cat.subtext0,
			bg = cat.mantle,
		}, -- title of floating windows

		FloatShadow = {
			bg = cat.overlay0,
			blend = 80,
		},

		FloatShadowThrough = {
			bg = cat.overlay0,
			blend = 100,
		},

		Pmenu = {
			bg = cat.mantle,
			fg = cat.overlay2,
		}, -- popup menu normal item

		PmenuBorder = {
			bg = cat.mantle,
			fg = cat.blue,
		}, -- popup menu border

		PmenuSel = {
			bg = cat.surface0,
			bold = true,
		}, -- popup menu selected item

		PmenuMatch = {
			fg = cat.text,
			bold = true,
		}, -- popup menu matching text

		PmenuMatchSel = {
			bold = true,
		}, -- popup menu matching selected text

		PmenuSbar = { bg = cat.surface0 }, -- popup menu scrollbar
		PmenuThumb = { bg = cat.overlay0 }, -- popup menu scrollbar thumb
		PmenuExtra = { fg = cat.overlay0 }, -- popup menu extra text

		PmenuExtraSel = {
			bg = cat.surface0,
			fg = cat.overlay0,
			bold = true,
		}, -- popup menu selected extra text

		ComplMatchIns = { link = "PreInsert" }, -- matched text of current completion
		PreInsert = { fg = cat.overlay2 }, -- preinserted completion text
		ComplHint = { fg = cat.subtext0 }, -- selected completion virtual text
		ComplHintMore = { link = "Question" }, -- extra completion virtual text

		Question = { fg = cat.blue }, -- hit-enter prompt and questions

		QuickFixLine = {
			bg = U.darken(cat.surface1, 0.70, cat.base),
			bold = true,
		}, -- current quickfix item

		Search = {
			bg = U.darken(cat.sky, 0.30, cat.base),
			fg = cat.text,
		}, -- last search pattern

		IncSearch = {
			bg = U.darken(cat.sky, 0.90, cat.base),
			fg = cat.mantle,
		}, -- incremental search

		CurSearch = {
			bg = cat.red,
			fg = cat.mantle,
		}, -- current search match

		SpecialKey = { link = "NonText" }, -- unprintable characters

		SpellBad = {
			sp = cat.red,
			undercurl = true,
		}, -- spelling mistake

		SpellCap = {
			sp = cat.yellow,
			undercurl = true,
		}, -- should start with capital

		SpellLocal = {
			sp = cat.blue,
			undercurl = true,
		}, -- local spelling variant

		SpellRare = {
			sp = cat.green,
			undercurl = true,
		}, -- rare word

		StatusLine = {
			fg = cat.text,
			bg = cat.mantle,
		}, -- status line of current window

		StatusLineNC = {
			fg = cat.surface1,
			bg = cat.mantle,
		}, -- status line of non-current windows

		TabLine = {
			bg = cat.crust,
			fg = cat.overlay0,
		}, -- inactive tab page label

		TabLineFill = {
			bg = cat.mantle,
		}, -- tab line fill

		TabLineSel = {
			link = "Normal",
		}, -- active tab page label

		TermCursor = {
			fg = cat.base,
			bg = cat.rosewater,
		}, -- cursor in focused terminal

		TermCursorNC = {
			fg = cat.base,
			bg = cat.overlay2,
		}, -- cursor in unfocused terminal

		Title = {
			fg = cat.blue,
			bold = true,
		}, -- titles

		Visual = {
			bg = cat.surface1,
			bold = true,
		}, -- visual mode selection

		VisualNOS = {
			bg = cat.surface1,
			bold = true,
		}, -- visual mode selection when selection is not owned

		WarningMsg = { fg = cat.yellow }, -- warning messages
		Whitespace = { fg = cat.surface1 }, -- listchars whitespace
		WildMenu = { bg = cat.overlay0 }, -- current match in wildmenu

		WinBar = { fg = cat.rosewater },
		WinBarNC = { link = "WinBar" },
		WinSeparator = { fg = cat.crust },
	}
end

return M
