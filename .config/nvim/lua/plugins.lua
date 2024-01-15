vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd vimball]]
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerCompile
	augroup end
]])

require("theme")
if not vim.g.theme_style then
	vim.g.theme_style = "darker"
end

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'navarasu/onedark.nvim',
		config = function()


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
			}
			if vim.g.theme_style == "light" then
				cfg.diagnostics.darker = false
				cfg.highlights = {
					CursorLine = {bg = '$bg2'},
					Visual = {bg = '$bg3'},
				}
				vim.o.background = 'light'
			else
				cfg.diagnostics.darker = true
				cfg.highlights = {
					CursorLine = {bg = '$bg2'},
					Visual = {bg = '$bg0'},
				}
				vim.o.background = 'dark'
			end

			require('onedark').setup(cfg)
			require('onedark').load()
		end,
	}

	use 'nvim-tree/nvim-web-devicons'
	use {
		'NTBBloodbath/galaxyline.nvim',
		branch = 'main',
		config = function()
			-- put(require('onedark.colors'))
			require'galaxylineconf'
		end,
		requires = {'nvim-tree/nvim-web-devicons', opt = true},
		after = "onedark.nvim",
	}


	use {
		"windwp/nvim-spectre",
		config = function()
			require('spectre').setup()
		end,
	}


	use {
		'nvim-tree/nvim-tree.lua',
		-- requires = {
			-- 'nvim-tree/nvim-web-devicons'
		-- },
		config = function()
			require("file-explorer")
		end
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
		config = function()
			require("telescope_conf")
		end,
	}

	use {
		'phaazon/hop.nvim',
		branch = 'v1', -- optional but strongly recommended
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
		end
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = "all", -- one of "all or a list of languages
				--ignore_install = { "javascript" }, -- List of parsers to ignore installing
				highlight = {
					enable = true,              -- false will disable the whole extension
					disable = function(lang, bufnr) -- Disable in large C++ buffers
						return require("utils").longest_line(bufnr) > 5000 or vim.api.nvim_buf_line_count(bufnr) > 50000
						-- return vim.api.nvim_buf_line_count(bufnr) > 50000
					end,
					additional_vim_regex_highlighting = true -- Makes highliting only comment when using :set spell
				},
			}
		end,
	}

	use {
		'nvim-treesitter/nvim-treesitter-context',
		config = function ()
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

	}

	-- LSP stuff
	use 'neovim/nvim-lspconfig'

	-- Config for nvim-cmp
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/nvim-cmp'

	-- Snippets
	use "L3MON4D3/LuaSnip"
	use "saadparwaiz1/cmp_luasnip"

	use {
		"kosayoda/nvim-lightbulb",
		config = function()
			vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
		end,
	}

	-- GO stuff
	-- use { "kyoh86/vim-go-coverage", ft="go" }
	use { "rafaelsq/nvim-goc.lua", ft="go",
		config = function()

			-- if set, when we switch between buffers, it will not split more than once. It will switch to the existing buffer instead
			vim.opt.switchbuf = 'useopen'

			local goc = require'nvim-goc'
			goc.setup({ verticalSplit = false })  -- default to horizontal


			vim.keymap.set('n', '<Leader>gcf', goc.Coverage, {silent=true})       -- run for the whole File
			vim.keymap.set('n', '<Leader>gct', goc.CoverageFunc, {silent=true})   -- run only for a specific Test unit
			vim.keymap.set('n', '<Leader>gcc', goc.ClearCoverage, {silent=true})  -- clear coverage highlights

			-- If you need custom arguments, you can supply an array as in the example below.
			-- vim.keymap.set('n', '<Leader>gcf', function() goc.Coverage({ "-race", "-count=1" }) end, {silent=true})
			-- vim.keymap.set('n', '<Leader>gct', function() goc.CoverageFunc({ "-race", "-count=1" }) end, {silent=true})

			vim.keymap.set('n', ']a', goc.Alternate, {silent=true})
			vim.keymap.set('n', '[a', goc.AlternateSplit, {silent=true})          -- set verticalSplit=true for vertical

			cf = function(testCurrentFunction)
				local cb = function(path)
					if path then

						-- `xdg-open|open` command performs the same function as double-clicking on the file.
						-- change from `xdg-open` to `open` on MacOSx
						vim.cmd(":silent exec \"!xdg-open " .. path .. "\"")
					end
				end

				if testCurrentFunction then
					goc.CoverageFunc(nil, cb, 0)
				else
					goc.Coverage(nil, cb)
				end
			end

			-- If you want to open it in your browser, you can use the commands below.
			-- You need to create a callback function to configure which command to use to open the HTML.
			-- On Linux, `xdg-open` is generally used, on MacOSx it's just `open`.
			vim.keymap.set('n', '<leader>gca', cf, {silent=true})
			vim.keymap.set('n', '<Leader>gcb', function() cf(true) end, {silent=true})

			-- default colors
			-- vim.api.nvim_set_hl(0, 'GocNormal', {link='Comment'})
			-- vim.api.nvim_set_hl(0, 'GocCovered', {link='String'})
			-- vim.api.nvim_set_hl(0, 'GocUncovered', {link='Error'})


		end
	}


	use 'scrooloose/nerdcommenter'
	use 'tpope/vim-surround'
	-- Git integration

	use { 'bobrown101/git-blame.nvim',
		config = function()
			vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>lua require('git_blame').run()<cr>", { noremap = true, silent = true })
		end,
	}
	use "editorconfig/editorconfig-vim"

	-- use "ustcyue/proto-number"

end)
