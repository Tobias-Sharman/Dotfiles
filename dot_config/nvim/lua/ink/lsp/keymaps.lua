local format = require("ink.config.format")

local function lsp_keymap(buffer, mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, {
		buffer = buffer,
		desc = desc,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("ink-lsp-keymaps", {
		clear = true,
	}),

	desc = "Set LSP keymaps",

	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client:supports_method("textDocument/inlayHint", event.buf) then
			vim.lsp.inlay_hint.enable(true, {
				bufnr = event.buf,
			})

			lsp_keymap(event.buf, "n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
					bufnr = event.buf,
				}), {
					bufnr = event.buf,
				})
			end, "Toggle inlay hints")
		end

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

		lsp_keymap(event.buf, "n", "<leader>lf", function()
			format.format(event.buf)
		end, "Format buffer")
	end,
})
