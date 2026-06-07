local function lsp_keymap(buffer, mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, {
		buffer = buffer,
		desc = desc,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Set LSP keymaps",
	callback = function(event)
		lsp_keymap(event.buf, "n", "gd", vim.lsp.buf.definition, "Go to definition")
		lsp_keymap(event.buf, "n", "gD", vim.lsp.buf.declaration, "Go to declaration")
		lsp_keymap(event.buf, "n", "gr", vim.lsp.buf.references, "Go to references")
		lsp_keymap(event.buf, "n", "gi", vim.lsp.buf.implementation, "Go to implementation")

		lsp_keymap(event.buf, "n", "K", vim.lsp.buf.hover, "Hover documentation")

		lsp_keymap(event.buf, "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		lsp_keymap(event.buf, { "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

		lsp_keymap(event.buf, "n", "<leader>d", vim.diagnostic.open_float, "Show diagnostic")

		lsp_keymap(event.buf, "n", "[d", function()
			vim.diagnostic.jump({
				count = -1,
				float = true,
			})
		end, "Previous diagnostic")

		lsp_keymap(event.buf, "n", "]d", function()
			vim.diagnostic.jump({
				count = 1,
				float = true,
			})
		end, "Next diagnostic")

		lsp_keymap(event.buf, "n", "<leader>f", function()
			vim.lsp.buf.format({
				async = true,
				bufnr = event.buf,
			})
		end, "Format buffer")
	end,
})
