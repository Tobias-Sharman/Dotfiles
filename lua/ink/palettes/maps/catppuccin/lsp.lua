local U = require("ink.palettes.maps.catppuccin.util")

local M = {}

function M.from_palette(cat, flavour)
	local error = cat.red
	local warning = cat.yellow
	local info = cat.sky
	local hint = cat.teal
	local ok = cat.green
	local darkening_percentage = 0.095

	local inlay_hint_bg = U.vary(flavour, {
		latte = U.lighten(cat.mantle, 0.70, cat.base),
	}, U.darken(cat.surface0, 0.64, cat.base))

	return {
		-- These groups are for the native LSP client.
		LspReferenceText = { bg = cat.surface1 }, -- text references
		LspReferenceRead = { bg = cat.surface1 }, -- read references
		LspReferenceWrite = { bg = cat.surface1 }, -- write references

		-- diagnostic virtual text
		DiagnosticVirtualTextError = {
			bg = U.darken(error, darkening_percentage, cat.base),
			fg = error,
		},

		DiagnosticVirtualTextWarn = {
			bg = U.darken(warning, darkening_percentage, cat.base),
			fg = warning,
		},

		DiagnosticVirtualTextInfo = {
			bg = U.darken(info, darkening_percentage, cat.base),
			fg = info,
		},

		DiagnosticVirtualTextHint = {
			bg = U.darken(hint, darkening_percentage, cat.base),
			fg = hint,
		},

		DiagnosticVirtualTextOk = {
			bg = U.darken(hint, darkening_percentage, cat.base),
			fg = ok,
		},

		DiagnosticError = { fg = error },
		DiagnosticWarn = { fg = warning },
		DiagnosticInfo = { fg = info },
		DiagnosticHint = { fg = hint },
		DiagnosticOk = { fg = ok },

		DiagnosticUnderlineError = {
			undercurl = true,
			sp = error,
		},

		DiagnosticUnderlineWarn = {
			undercurl = true,
			sp = warning,
		},

		DiagnosticUnderlineInfo = {
			undercurl = true,
			sp = info,
		},

		DiagnosticUnderlineHint = {
			undercurl = true,
			sp = hint,
		},

		DiagnosticUnderlineOk = {
			undercurl = true,
			sp = ok,
		},

		DiagnosticFloatingError = { fg = error },
		DiagnosticFloatingWarn = { fg = warning },
		DiagnosticFloatingInfo = { fg = info },
		DiagnosticFloatingHint = { fg = hint },
		DiagnosticFloatingOk = { fg = ok },

		DiagnosticSignError = { fg = error },
		DiagnosticSignWarn = { fg = warning },
		DiagnosticSignInfo = { fg = info },
		DiagnosticSignHint = { fg = hint },
		DiagnosticSignOk = { fg = ok },

		LspDiagnosticsDefaultError = { fg = error },
		LspDiagnosticsDefaultWarning = { fg = warning },
		LspDiagnosticsDefaultInformation = { fg = info },
		LspDiagnosticsDefaultHint = { fg = hint },

		LspSignatureActiveParameter = {
			bg = cat.surface0,
			bold = true,
		},

		LspDiagnosticsError = { fg = error },
		LspDiagnosticsWarning = { fg = warning },
		LspDiagnosticsInformation = { fg = info },
		LspDiagnosticsHint = { fg = hint },

		LspDiagnosticsVirtualTextError = { fg = error },
		LspDiagnosticsVirtualTextWarning = { fg = warning },
		LspDiagnosticsVirtualTextInformation = { fg = info },
		LspDiagnosticsVirtualTextHint = { fg = hint },

		LspDiagnosticsUnderlineError = {
			undercurl = true,
			sp = error,
		},

		LspDiagnosticsUnderlineWarning = {
			undercurl = true,
			sp = warning,
		},

		LspDiagnosticsUnderlineInformation = {
			undercurl = true,
			sp = info,
		},

		LspDiagnosticsUnderlineHint = {
			undercurl = true,
			sp = hint,
		},

		LspCodeLens = { fg = cat.overlay0 },
		LspCodeLensSeparator = { link = "LspCodeLens" },

		LspInlayHint = {
			fg = cat.overlay0,
			bg = inlay_hint_bg,
		},

		LspInfoBorder = { link = "FloatBorder" },
	}
end

return M
