require("ink.config.options")
require("ink.config.plugins")
require("ink.config.keymaps")
require("ink.config.autocmds")

local state = require("ink.state")
vim.g.ink_palette = vim.g.ink_palette or state.get_palette() or "catppuccin_mocha"
require("ink.highlights").apply(vim.g.ink_palette)

require("ink.config.commands")
require("ink.lsp")
