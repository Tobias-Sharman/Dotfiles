-- ============================================================================
-- Treesitter
-- ============================================================================

-- Try to enable built-in Treesitter highlighting.
vim.api.nvim_create_autocmd("FileType", {
	desc = "Start built-in Treesitter highlighting where available",
	pattern = { "c", "cpp", "lua", "vim", "vimdoc", "markdown" },
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- ============================================================================
-- Spelling
-- ============================================================================

vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable spellcheck for prose-like files",
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en_gb" }
	end,
})

-- ============================================================================
-- Yank highlight
-- ============================================================================

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})

-- ============================================================================
-- Format
-- ============================================================================

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Format C and C++ files before saving",
	pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.cc", "*.cxx", "*.hh", "*.hxx" },
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		local clang_format = vim.fs.find(".clang-format", {
			path = vim.fs.dirname(args.file),
			upward = true,
			type = "file",
			limit = 1,
		})[1]

		if clang_format == nil then
			return
		end

		vim.lsp.buf.format({
			bufnr = args.buf,
			async = false,
			timeout_ms = 2000,
			filter = function(client)
				return client.name == "clangd"
			end,
		})
	end,
})

-- ============================================================================
-- Whitespace cleanup
-- ============================================================================

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Remove trailing whitespace and extra blank lines at EOF",
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end

		local cursor = vim.api.nvim_win_get_cursor(0)

		-- Remove trailing whitespace from every line.
		--
		-- This keeps files clean, but also means indentation on otherwise blank
		-- lines will be removed.
		vim.cmd([[%s/\s\+$//e]])

		-- Remove extra empty lines at the end of the buffer.
		while vim.api.nvim_buf_line_count(0) > 1 do
			local last_line = vim.api.nvim_buf_get_lines(0, -2, -1, false)[1]

			if last_line ~= "" then
				break
			end

			vim.api.nvim_buf_set_lines(0, -2, -1, false, {})
		end

		pcall(vim.api.nvim_win_set_cursor, 0, cursor)
	end,
})
