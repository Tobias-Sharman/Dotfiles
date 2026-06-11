vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set
local commands = require("ink.config.commands")

-- ============================================================================
-- Files
-- ============================================================================

keymap("n", "<leader>w", "<cmd>write<cr>", {
	desc = "Save file",
})

keymap("n", "<leader>q", "<cmd>quit<cr>", {
	desc = "Quit",
})

keymap("n", "<leader>x", "<cmd>xit<cr>", {
	desc = "Save and quit",
})

-- ============================================================================
-- Search
-- ============================================================================

keymap("n", "<esc>", "<cmd>nohlsearch<cr>", {
	desc = "Clear search highlight",
})

-- ============================================================================
-- Editing
-- ============================================================================

keymap("n", "<leader>j", function()
	local count = vim.v.count1
	vim.cmd("move .+" .. count)
	vim.cmd("normal! ==")
end, {
	desc = "Move line down",
})

keymap("n", "<leader>k", function()
	local count = vim.v.count1
	vim.cmd("move .-" .. (count + 1))
	vim.cmd("normal! ==")
end, {
	desc = "Move line up",
})

keymap("x", "<leader>j", ":move '>+1<cr>gv=gv", {
	desc = "Move selection down",
})

keymap("x", "<leader>k", ":move '<-2<cr>gv=gv", {
	desc = "Move selection up",
})

-- ============================================================================
-- Fuzzy finding
-- ============================================================================
local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>ff", fzf.files, {
	desc = "Find files",
})

vim.keymap.set("n", "<leader>fg", fzf.live_grep, {
	desc = "Live grep",
})

vim.keymap.set("n", "<leader>fb", fzf.buffers, {
	desc = "Find buffers",
})

vim.keymap.set("n", "<leader>fh", fzf.help_tags, {
	desc = "Find help",
})

vim.keymap.set("n", "<leader>fo", fzf.oldfiles, {
	desc = "Find old files",
})

vim.keymap.set("n", "<leader>fk", fzf.keymaps, {
	desc = "Find keymaps",
})

vim.keymap.set("n", "<leader>fc", fzf.commands, {
	desc = "Find commands",
})

vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, {
	desc = "Find document symbols",
})

vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, {
	desc = "Find document diagnostics",
})

-- ============================================================================
-- Git visibility
-- ============================================================================
vim.keymap.set("n", "<leader>gs", fzf.git_status, {
	desc = "Git status",
})

vim.keymap.set("n", "<leader>gc", fzf.git_commits, {
	desc = "Git commits",
})

vim.keymap.set("n", "<leader>gb", fzf.git_branches, {
	desc = "Git branches",
})

-- ============================================================================
-- Cmake toolings
-- ============================================================================

vim.keymap.set("n", "<leader>cc", commands.cmake_configure, {
	desc = "CMake configure",
})

vim.keymap.set("n", "<leader>cb", commands.cmake_build, {
	desc = "CMake build",
})

vim.keymap.set("n", "<leader>cr", commands.cmake_configure_and_build, {
	desc = "CMake configure and build",
})

vim.keymap.set("n", "<leader>ct", commands.cmake_test, {
	desc = "CMake test",
})
