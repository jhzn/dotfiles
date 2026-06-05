
require("theme")
if not vim.g.theme_style then
	vim.g.theme_style = "darker"
end

vim.pack.add(
	{ 'https://github.com/navarasu/onedark.nvim' },
		-- priority = 1000, -- make sure to load this before all the other start plugins
	{ load = function()
		-- Flashy transparency :) make sure you terminal follows along
		vim.cmd([[
			hi Normal guibg=NONE ctermbg=NONE
		]])
		-- local c = require('onedark.colors')
		local cfg = {
			-- Main options --
			style = vim.g.theme_style, -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
			transparent = true,  -- Show/hide background
			term_colors = true, -- Change terminal color as per the selected theme style
			ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
			-- toggle theme style ---
			toggle_style_key = '<leader>ts', -- Default keybinding to toggle
			toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

			-- Change code style ---
			-- Options are italic, bold, underline, none
			-- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
			code_style = {
				comments = 'italic',
				keywords = 'none',
				functions = 'none',
				strings = 'none',
				variables = 'none'
			},

			-- Plugins Config --
			diagnostics = {
				undercurl = true,   -- use undercurl for diagnostics
				background = true,    -- use background color for virtual text
			},
			lualine = {
				transparent = false, -- lualine center bar transparency
			},
		}
		if vim.g.theme_style == "light" then
			-- cfg.diagnostics.darker = false
			-- cfg.highlights = {
				-- CursorLine = {bg = '$bg2'},
				-- Visual = {bg = '$bg3'},
				-- ["comments"] = {fg = '$grey'},
				-- ["@comment"] = {fg = '$grey'},
				-- ["@lsp.type.comment"] = {fg = '$grey'},
			-- }
			vim.o.background = 'dark'
		else
			cfg.diagnostics.darker = true
			cfg.colors = {
				bright_orange = "#ff8800",    -- define a new color
				-- green = '#00ffaa',            -- redefine an existing color
				dark_green = '#475a39'
			}
			cfg.highlights = {
				-- CursorLine = {bg = '#494f5c'},
				CursorLine = {bg = '$bg0'},
				Visual = {bg = '$grey'},
				["comments"] = {fg = '$dark_green'},
				["@comment"] = {fg = '$dark_green'},
				["@lsp.type.comment"] = {fg = '$dark_green'},

				-- ["@comment"] = {fg="$orange"},
			}
			vim.o.background = 'dark'
		end

		require('onedark').setup(cfg)
		require('onedark').load()
	end,
})

vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons' } )
vim.pack.add(
	{ 'https://github.com/nvim-lualine/lualine.nvim'},
	{
		-- requires = { 'nvim-tree/nvim-web-devicons', opt = true },
		load = function()
			-- put(require('onedark.colors'))
			require'lualineconf'
		end,
	})
vim.pack.add(
	{ "https://github.com/nvim-pack/nvim-spectre"},
	{	load = function()
			require('spectre').setup()
		end,
})


vim.pack.add(
	{ 'https://github.com/nvim-tree/nvim-tree.lua'},
	-- requires = {
		-- 'nvim-tree/nvim-web-devicons'
	-- },
	{load = function()
		require("file-explorer")
	end
})

vim.pack.add({
	'https://github.com/nvim-telescope/telescope.nvim'},
	{requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
	load = function()
		require("telescope_conf")
	end,
})

vim.pack.add(
	{ "https://github.com/romus204/tree-sitter-manager.nvim"},
	-- dependencies = {}, -- tree-sitter CLI must be installed system-wide
	{load = function()
		require("tree-sitter-manager").setup({
			-- Default Options
			-- ensure_installed = {}, -- list of parsers to install at the start of a neovim session
			-- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
			-- auto_install = false, -- if enabled, install missing parsers when editing a new file
			-- highlight = true, -- treesitter highlighting is enabled by default
			-- languages = {}, -- override or add new parser sources
			-- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
			-- query_dir = vim.fn.stdpath("data") .. "/site/queries",
		})
	end
})

vim.pack.add(
	{ 'https://github.com/nvim-treesitter/nvim-treesitter-context'},
	{load = function ()
		require'treesitter-context'.setup{
			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
			throttle = true, -- Throttles plugin updates (may improve performance)
			max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
			patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
			-- For all filetypes
			-- Note that setting an entry here replaces all other patterns for this entry.
			-- By setting the 'default' entry below, you can control which nodes you want to
			-- appear in the context window.
			default = {
				'class',
				'function',
				'method',
				-- 'for', -- These won't appear in the context
				-- 'while',
				-- 'if',
				-- 'switch',
				-- 'case',
			},
			-- Example for a specific filetype.
			-- If a pattern is missing, *open a PR* so everyone can benefit.
			--   rust = {
			--       'impl_item',
			--   },
		},
		exact_patterns = {
			-- Example for a specific filetype with Lua patterns
			-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
			-- exactly match "impl_item" only)
			-- rust = true,
		}
	}
	end

})

	-- LSP stuff
vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig' ,

	-- Config for nvim-cmp
	'https://github.com/hrsh7th/cmp-nvim-lsp' ,
	'https://github.com/hrsh7th/cmp-buffer' ,
	'https://github.com/hrsh7th/cmp-path' ,
	'https://github.com/hrsh7th/cmp-cmdline' ,
	'https://github.com/hrsh7th/nvim-cmp' ,

	-- Snippets
	"https://github.com/L3MON4D3/LuaSnip" ,
	"https://github.com/saadparwaiz1/cmp_luasnip" ,
})

	-- -- {
		-- -- "kosayoda/nvim-lightbulb",
		-- -- load = function()
			-- -- vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
		-- -- end,
	-- -- }

	-- -- GO stuff
	-- -- { "kyoh86/vim-go-coverage", ft="go" }
	-- { "https://github.com/rafaelsq/nvim-goc.lua", ft="go",
		-- load = function()

			-- -- if set, when we switch between buffers, it will not split more than once. It will switch to the existing buffer instead
			-- vim.opt.switchbuf = 'useopen'

			-- local goc = require'nvim-goc'
			-- goc.setup({ verticalSplit = false })  -- default to horizontal


			-- vim.keymap.set('n', '<Leader>gcf', goc.Coverage, {silent=true})       -- run for the whole File
			-- vim.keymap.set('n', '<Leader>gct', goc.CoverageFunc, {silent=true})   -- run only for a specific Test unit
			-- vim.keymap.set('n', '<Leader>gcc', goc.ClearCoverage, {silent=true})  -- clear coverage highlights

			-- -- If you need custom arguments, you can supply an array as in the example below.
			-- -- vim.keymap.set('n', '<Leader>gcf', function() goc.Coverage({ "-race", "-count=1" }) end, {silent=true})
			-- -- vim.keymap.set('n', '<Leader>gct', function() goc.CoverageFunc({ "-race", "-count=1" }) end, {silent=true})

			-- vim.keymap.set('n', ']a', goc.Alternate, {silent=true})
			-- vim.keymap.set('n', '[a', goc.AlternateSplit, {silent=true})          -- set verticalSplit=true for vertical

			-- cf = function(testCurrentFunction)
				-- local cb = function(path)
					-- if path then

						-- -- `xdg-open|open` command performs the same function as double-clicking on the file.
						-- -- change from `xdg-open` to `open` on MacOSx
						-- vim.cmd(":silent exec \"!xdg-open " .. path .. "\"")
					-- end
				-- end

				-- if testCurrentFunction then
					-- goc.CoverageFunc(nil, cb, 0)
				-- else
					-- goc.Coverage(nil, cb)
				-- end
			-- end

			-- -- If you want to open it in your browser, you can use the commands below.
			-- -- You need to create a callback function to configure which command to use to open the HTML.
			-- -- On Linux, `xdg-open` is generally used, on MacOSx it's just `open`.
			-- vim.keymap.set('n', '<leader>gca', cf, {silent=true})
			-- vim.keymap.set('n', '<Leader>gcb', function() cf(true) end, {silent=true})

			-- -- default colors
			-- -- vim.api.nvim_set_hl(0, 'GocNormal', {link='Comment'})
			-- -- vim.api.nvim_set_hl(0, 'GocCovered', {link='String'})
			-- -- vim.api.nvim_set_hl(0, 'GocUncovered', {link='Error'})


		-- end
	-- },
vim.pack.add({
	"https://github.com/vrischmann/tree-sitter-templ",
	'https://github.com/scrooloose/nerdcommenter',
	'https://github.com/tpope/vim-surround',
	"https://github.com/editorconfig/editorconfig-vim"
 })
	-- -- Git integration

vim.pack.add(
	{ 'https://github.com/bobrown101/git-blame.nvim'},
	{load = function()
			vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>lua require('git_blame').run()<cr>", { noremap = true, silent = true })
		end,
})

	-- -- use "ustcyue/proto-number"

-- )
