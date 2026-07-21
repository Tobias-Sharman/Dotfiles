local M = {}

function M.from_palette(cat, flavour)
	local colors = {
		-- Reference: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md

		-- Identifiers
		["@variable"] = { fg = cat.text }, -- Any variable name that does not have another highlight.
		["@variable.builtin"] = { fg = cat.red }, -- Variable names that are defined by the languages, like this or self.
		["@variable.parameter"] = { fg = cat.maroon }, -- For parameters of a function.
		["@variable.member"] = { fg = cat.lavender }, -- For fields.

		["@constant"] = { link = "Constant" }, -- For constants
		["@constant.builtin"] = { fg = cat.peach }, -- For constants that are built in the language: nil in Lua.
		["@constant.macro"] = { link = "Macro" }, -- For constants that are defined by macros: NULL in C.

		["@module"] = {
			fg = cat.yellow,
			italic = true,
		}, -- For identifiers referring to modules and namespaces.

		["@label"] = { link = "Label" }, -- For labels: label: in C and :label: in Lua.

		-- Literals
		["@string"] = { link = "String" }, -- For strings.
		["@string.documentation"] = { fg = cat.teal }, -- For strings documenting code, e.g. Python docstrings.
		["@string.regexp"] = { fg = cat.pink }, -- For regexes.
		["@string.escape"] = { fg = cat.pink }, -- For escape characters within a string.
		["@string.special"] = { link = "Special" }, -- Other special strings.
		["@string.special.path"] = { link = "Special" }, -- Filenames.
		["@string.special.symbol"] = { fg = cat.flamingo }, -- Symbols or atoms.

		["@string.special.url"] = {
			fg = cat.blue,
			italic = true,
			underline = true,
		}, -- URLs, links, and emails.

		["@punctuation.delimiter.regex"] = { link = "@string.regexp" },

		["@character"] = { link = "Character" }, -- Character literals.
		["@character.special"] = { link = "SpecialChar" }, -- Special characters, e.g. wildcards.

		["@boolean"] = { link = "Boolean" }, -- For booleans.
		["@number"] = { link = "Number" }, -- For all numbers.
		["@number.float"] = { link = "Float" }, -- For floats.

		-- Types
		["@type"] = { link = "Type" }, -- For types.
		["@type.builtin"] = { fg = cat.mauve }, -- For builtin types.
		["@type.definition"] = { link = "Type" }, -- Type definitions, e.g. typedef in C.
		["@attribute"] = { link = "Constant" }, -- Attribute annotations, e.g. Python decorators.
		["@property"] = { fg = cat.lavender }, -- For fields, e.g. foo.bar.

		-- Functions
		["@function"] = { link = "Function" }, -- For function calls and definitions.
		["@function.builtin"] = { fg = cat.peach }, -- Builtin functions.
		["@function.call"] = { link = "Function" }, -- Function calls.
		["@function.macro"] = { fg = cat.pink }, -- Macro-defined functions.
		["@function.method"] = { link = "Function" }, -- Method definitions.
		["@function.method.call"] = { link = "Function" }, -- Method calls.
		["@constructor"] = { fg = cat.yellow }, -- Constructor calls and definitions.

		["@operator"] = { link = "Operator" }, -- For operators.

		-- Keywords
		["@keyword"] = { link = "Keyword" }, -- For keywords that do not fall into another category.
		["@keyword.modifier"] = { link = "Keyword" }, -- const, static, public, etc.
		["@keyword.type"] = { link = "Keyword" }, -- struct, enum, etc.
		["@keyword.coroutine"] = { link = "Keyword" }, -- async, await, go, etc.
		["@keyword.function"] = { fg = cat.mauve }, -- Keywords used to define a function.
		["@keyword.operator"] = { fg = cat.mauve }, -- New keyword operator.
		["@keyword.import"] = { link = "Include" }, -- #include, use, require, etc.
		["@keyword.repeat"] = { link = "Repeat" }, -- Loop keywords.
		["@keyword.return"] = { fg = cat.mauve },
		["@keyword.debug"] = { link = "Exception" }, -- Debugger-related keywords.
		["@keyword.exception"] = { link = "Exception" }, -- Exception-related keywords.
		["@keyword.conditional"] = { link = "Conditional" }, -- Conditional keywords.
		["@keyword.conditional.ternary"] = { link = "Operator" }, -- Ternary operators.
		["@keyword.directive"] = { link = "PreProc" }, -- Preprocessor directives and shebangs.
		["@keyword.directive.define"] = { link = "Define" }, -- Preprocessor definition directives.

		-- JS and derivative
		["@keyword.export"] = { fg = cat.mauve },

		-- Punctuation
		["@punctuation.delimiter"] = { link = "Delimiter" }, -- ; . ,
		["@punctuation.bracket"] = { fg = cat.overlay2 }, -- Brackets and parentheses.
		["@punctuation.special"] = { link = "Special" }, -- Special punctuation.

		-- Comment
		["@comment"] = { link = "Comment" },
		["@comment.documentation"] = { link = "Comment" }, -- Comments documenting code.
		["@comment.error"] = { fg = cat.base, bg = cat.red },
		["@comment.warning"] = { fg = cat.base, bg = cat.yellow },
		["@comment.hint"] = { fg = cat.base, bg = cat.blue },
		["@comment.todo"] = { fg = cat.base, bg = cat.flamingo },
		["@comment.note"] = { fg = cat.base, bg = cat.rosewater },

		-- Markup
		["@markup"] = { fg = cat.text }, -- Text in a markup language.

		["@markup.strong"] = {
			fg = cat.red,
			bold = true,
		}, -- Bold text.

		["@markup.italic"] = {
			fg = cat.red,
			italic = true,
		}, -- Italic text.

		["@markup.strikethrough"] = {
			fg = cat.text,
			strikethrough = true,
		}, -- Strikethrough text.

		["@markup.underline"] = { link = "Underlined" }, -- Underlined text.
		["@markup.heading"] = { fg = cat.blue }, -- Headings.

		["@markup.heading.markdown"] = {
			bold = true,
		}, -- Bold headings in markdown, but not HTML or other markup.

		["@markup.math"] = { fg = cat.blue }, -- Math environments.
		["@markup.quote"] = { fg = cat.pink }, -- Block quotes.
		["@markup.environment"] = { fg = cat.pink }, -- Markup environments.
		["@markup.environment.name"] = { fg = cat.blue }, -- Markup environment names.
		["@markup.link"] = { fg = cat.lavender }, -- Text references, footnotes, citations, etc.
		["@markup.link.label"] = { fg = cat.lavender }, -- Link/reference descriptions.

		["@markup.link.url"] = {
			fg = cat.blue,
			italic = true,
			underline = true,
		}, -- URLs, links, and emails.

		["@markup.raw"] = { fg = cat.green }, -- Inline code / raw text.
		["@markup.list"] = { fg = cat.teal },
		["@markup.list.checked"] = { fg = cat.green }, -- Checked todo notes.
		["@markup.list.unchecked"] = { fg = cat.overlay1 }, -- Unchecked todo notes.

		-- Diff
		["@diff.plus"] = { link = "diffAdded" }, -- Added text.
		["@diff.minus"] = { link = "diffRemoved" }, -- Deleted text.
		["@diff.delta"] = { link = "diffChanged" }, -- Changed text.

		-- Tags
		["@tag"] = { fg = cat.blue }, -- HTML/XML tag names.
		["@tag.builtin"] = { fg = cat.blue }, -- JSX tag names.

		["@tag.attribute"] = {
			fg = cat.yellow,
			italic = true,
		}, -- XML/HTML attributes.

		["@tag.delimiter"] = { fg = cat.teal }, -- Tag delimiters like < > /

		-- Misc
		["@error"] = { link = "Error" },

		-- Language specific: Bash
		["@function.builtin.bash"] = {
			fg = cat.red,
			italic = true,
		},

		["@variable.parameter.bash"] = { fg = cat.green },

		-- Markdown
		["@markup.heading.1.markdown"] = { link = "rainbow1" },
		["@markup.heading.2.markdown"] = { link = "rainbow2" },
		["@markup.heading.3.markdown"] = { link = "rainbow3" },
		["@markup.heading.4.markdown"] = { link = "rainbow4" },
		["@markup.heading.5.markdown"] = { link = "rainbow5" },
		["@markup.heading.6.markdown"] = { link = "rainbow6" },

		-- HTML
		["@markup.heading.html"] = { link = "@markup" },
		["@markup.heading.1.html"] = { link = "@markup" },
		["@markup.heading.2.html"] = { link = "@markup" },
		["@markup.heading.3.html"] = { link = "@markup" },
		["@markup.heading.4.html"] = { link = "@markup" },
		["@markup.heading.5.html"] = { link = "@markup" },
		["@markup.heading.6.html"] = { link = "@markup" },

		-- Java
		["@constant.java"] = { fg = cat.teal },

		-- CSS
		["@property.css"] = { fg = cat.blue },
		["@property.scss"] = { fg = cat.blue },
		["@property.id.css"] = { fg = cat.yellow },
		["@property.class.css"] = { fg = cat.yellow },
		["@type.css"] = { fg = cat.lavender },
		["@type.tag.css"] = { fg = cat.blue },
		["@string.plain.css"] = { fg = cat.text },
		["@number.css"] = { fg = cat.peach },
		["@keyword.directive.css"] = { link = "Keyword" },

		-- HTML
		["@string.special.url.html"] = { fg = cat.green },
		["@markup.link.label.html"] = { fg = cat.text },
		["@character.special.html"] = { fg = cat.red },

		-- Lua
		["@constructor.lua"] = { link = "@punctuation.bracket" },

		-- Python
		["@constructor.python"] = { fg = cat.sky },

		-- YAML
		["@label.yaml"] = { fg = cat.yellow },

		-- Ruby
		["@string.special.symbol.ruby"] = { fg = cat.flamingo },

		-- PHP
		["@function.method.php"] = { link = "Function" },
		["@function.method.call.php"] = { link = "Function" },

		-- C/CPP
		["@keyword.import.c"] = { fg = cat.yellow },
		["@keyword.import.cpp"] = { fg = cat.yellow },

		-- C#
		["@attribute.c_sharp"] = { fg = cat.yellow },

		-- gitcommit
		["@comment.warning.gitcommit"] = { fg = cat.yellow },

		-- gitignore
		["@string.special.path.gitignore"] = { fg = cat.text },

		-- Misc
		gitcommitSummary = {
			fg = cat.rosewater,
			italic = true,
		},

		zshKSHFunction = { link = "Function" },
	}

	-- Legacy highlights
	colors["@parameter"] = colors["@variable.parameter"]
	colors["@field"] = colors["@variable.member"]
	colors["@namespace"] = colors["@module"]
	colors["@float"] = colors["@number.float"]
	colors["@symbol"] = colors["@string.special.symbol"]
	colors["@string.regex"] = colors["@string.regexp"]

	colors["@text"] = colors["@markup"]
	colors["@text.strong"] = colors["@markup.strong"]
	colors["@text.emphasis"] = colors["@markup.italic"]
	colors["@text.underline"] = colors["@markup.underline"]
	colors["@text.strike"] = colors["@markup.strikethrough"]
	colors["@text.uri"] = colors["@markup.link.url"]
	colors["@text.math"] = colors["@markup.math"]
	colors["@text.environment"] = colors["@markup.environment"]
	colors["@text.environment.name"] = colors["@markup.environment.name"]
	colors["@text.title"] = colors["@markup.heading"]
	colors["@text.literal"] = colors["@markup.raw"]
	colors["@text.reference"] = colors["@markup.link"]
	colors["@text.todo.checked"] = colors["@markup.list.checked"]
	colors["@text.todo.unchecked"] = colors["@markup.list.unchecked"]

	colors["@comment.note"] = colors["@comment.hint"]

	-- @text.todo is now for todo comments, not todo notes like in markdown.
	colors["@text.todo"] = colors["@comment.todo"]
	colors["@text.warning"] = colors["@comment.warning"]
	colors["@text.note"] = colors["@comment.note"]
	colors["@text.danger"] = colors["@comment.error"]

	-- @text.uri is now:
	-- > @markup.link.url in markup links
	-- > @string.special.url outside of markup
	--
	-- This mirrors Catppuccin's upstream alias. Note that upstream currently
	-- aliases this to @markup.link.uri, even though the primary modern capture
	-- in the same file is @markup.link.url.
	colors["@text.uri"] = colors["@markup.link.uri"]

	colors["@method"] = colors["@function.method"]
	colors["@method.call"] = colors["@function.method.call"]

	colors["@text.diff.add"] = colors["@diff.plus"]
	colors["@text.diff.delete"] = colors["@diff.minus"]

	colors["@type.qualifier"] = colors["@keyword.modifier"]
	colors["@keyword.storage"] = colors["@keyword.modifier"]
	colors["@define"] = colors["@keyword.directive.define"]
	colors["@preproc"] = colors["@keyword.directive"]
	colors["@storageclass"] = colors["@keyword.storage"]
	colors["@conditional"] = colors["@keyword.conditional"]
	colors["@exception"] = colors["@keyword.exception"]
	colors["@include"] = colors["@keyword.import"]
	colors["@repeat"] = colors["@keyword.repeat"]

	colors["@symbol.ruby"] = colors["@string.special.symbol.ruby"]
	colors["@variable.member.yaml"] = colors["@field.yaml"]

	colors["@text.title.1.markdown"] = colors["@markup.heading.1.markdown"]
	colors["@text.title.2.markdown"] = colors["@markup.heading.2.markdown"]
	colors["@text.title.3.markdown"] = colors["@markup.heading.3.markdown"]
	colors["@text.title.4.markdown"] = colors["@markup.heading.4.markdown"]
	colors["@text.title.5.markdown"] = colors["@markup.heading.5.markdown"]
	colors["@text.title.6.markdown"] = colors["@markup.heading.6.markdown"]

	colors["@method.php"] = colors["@function.method.php"]
	colors["@method.call.php"] = colors["@function.method.call.php"]

	return colors
end

return M
