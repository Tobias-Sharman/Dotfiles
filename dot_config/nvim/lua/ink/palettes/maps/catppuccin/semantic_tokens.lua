local M = {}

function M.from_palette(cat, flavour)
	return {
		-- https://neovim.io/doc/user/lsp.html#lsp-semantic-highlight

		-- LSPs can detect enum members where Treesitter often cannot.
		["@lsp.type.enumMember"] = { fg = cat.teal },

		-- Treesitter can already handle normal variables in buffers, and LSP
		-- variable tokens can be less accurate in some cases.
		["@lsp.type.variable"] = {},

		-- In cases where the LSP is more specific than Treesitter, allow it
		-- to override Treesitter.
		["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
		["@lsp.typemod.function.builtin"] = { link = "@function.builtin" },
	}
end

return M
