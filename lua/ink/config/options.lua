-- ============================================================================
-- Editing
-- ============================================================================

-- Tabs
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- End of file
vim.opt.fixendofline = true
vim.opt.endofline = true

-- Undo
vim.opt.undofile = true

-- ============================================================================
-- Display
-- ============================================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Lines
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- UI columns
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.colorcolumn = "80,120"

-- Colours
vim.opt.termguicolors = true

-- Whitespace
vim.opt.list = true
vim.opt.listchars = {
	tab = "│ ",
	lead = "·",
	trail = "·",
	nbsp = "␣",
}

-- ============================================================================
-- Search
-- ============================================================================

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- ============================================================================
-- Windows
-- ============================================================================

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
