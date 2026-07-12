local commands = require("ink.config.commands")
local format = require("ink.config.format")
local lint = require("ink.config.lint")

local group = vim.api.nvim_create_augroup("InkAutocmds", {
	clear = true,
})

-- ============================================================================
-- Treesitter
-- ============================================================================

-- Try to enable built-in Treesitter highlighting.
vim.api.nvim_create_autocmd("FileType", {
	group = group,
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
	group = group,
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
	group = group,
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
	group = group,
	desc = "Format buffer before saving",
	callback = function(args)
		format.format(args.buf)
	end,
})

-- ============================================================================
-- Lint
-- ============================================================================

vim.api.nvim_create_autocmd("BufWritePost", {
	group = group,
	desc = "Run configured linters after saving",
	pattern = {
		"*.go",
		"*.sh",
		"*.bash",
		"*.zsh",
		"*.sql",
	},

	callback = function(args)
		lint.lint(args.buf)
	end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	group = group,
-- 	desc = "Format Nix files before saving",
-- 	pattern = "*.nix",
-- 	callback = function(args)
-- 		if vim.bo[args.buf].buftype ~= "" then
-- 			return
-- 		end
--
-- 		if vim.fn.executable("nixfmt") == 0 then
-- 			return
-- 		end
--
-- 		vim.lsp.buf.format({
-- 			bufnr = args.buf,
-- 			async = false,
-- 			timeout_ms = 2000,
-- 			filter = function(client)
-- 				return client.name == "nil"
-- 			end,
-- 		})
-- 	end,
-- })

-- ============================================================================
-- Cmake toolings
-- ============================================================================

-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	group = group,
-- 	pattern = { "CMakeLists.txt", "*.cmake" },
-- 	callback = commands.cmake_configure,
-- 	desc = "Configure CMake after CMake files change",
-- })
