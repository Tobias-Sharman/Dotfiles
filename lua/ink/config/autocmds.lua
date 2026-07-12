local commands = require("ink.config.commands")

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

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	desc = "Format Lua files before saving",
	pattern = "*.lua",
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		if vim.fn.executable("stylua") == 0 then
			return
		end

		local file = vim.api.nvim_buf_get_name(args.buf)

		if file == "" then
			return
		end

		local stylua_config = vim.fs.find({ "stylua.toml", ".stylua.toml" }, {
			path = vim.fs.dirname(file),
			upward = true,
			type = "file",
			limit = 1,
		})[1]

		if stylua_config == nil then
			return
		end

		local text = table.concat(vim.api.nvim_buf_get_lines(args.buf, 0, -1, false), "\n")

		local result = vim.system({
			"stylua",
			"--config-path",
			stylua_config,
			"--stdin-filepath",
			file,
			"-",
		}, {
			stdin = text,
			text = true,
		}):wait()

		if result.code ~= 0 then
			vim.notify(result.stderr or "stylua failed", vim.log.levels.ERROR)
			return
		end

		vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, vim.split(result.stdout, "\n", { plain = true }))
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

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	desc = "Format shell files before saving",
	pattern = { "*.sh", "*.bash", "*.zsh", "*.command" },
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		if vim.fn.executable("shfmt") == 0 then
			return
		end

		vim.system({ "shfmt", "-w", args.file }):wait()
		vim.cmd.edit()
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	desc = "Format SQL files before saving",
	pattern = "*.sql",
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end

		if vim.fn.executable("sqlfluff") == 0 then
			return
		end

		local sqlfluff_config = vim.fs.find({
			".sqlfluff",
			"pyproject.toml",
			"setup.cfg",
			"tox.ini",
		}, {
			path = vim.fs.dirname(args.file),
			upward = true,
			type = "file",
			limit = 1,
		})[1]

		if sqlfluff_config == nil then
			return
		end

		vim.system({ "sqlfluff", "format", "--force", args.file }):wait()
		vim.cmd.edit()
	end,
})

-- ============================================================================
-- Whitespace cleanup
-- ============================================================================

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
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

-- ============================================================================
-- Cmake toolings
-- ============================================================================

-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	group = group,
-- 	pattern = { "CMakeLists.txt", "*.cmake" },
-- 	callback = commands.cmake_configure,
-- 	desc = "Configure CMake after CMake files change",
-- })
