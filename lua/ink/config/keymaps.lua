vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set

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
