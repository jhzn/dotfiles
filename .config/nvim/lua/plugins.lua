vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd vimball]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

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
			require('onedark').setup {
				-- Main options --
				style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
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

				-- Custom Highlights --
				colors = {}, -- Override default colors
				highlights = {}, -- Override highlight groups

				-- Plugins Config --
				diagnostics = {
					darker = true, -- darker colors for diagnostic
					undercurl = true,   -- use undercurl for diagnostics
					background = true,    -- use background color for virtual text
				},
			}
			require('onedark').load()
			end,
		}

	use {
		"windwp/nvim-spectre",
		config = function()
			require('spectre').setup()
		end,
	}

	use {
		"ms-jpq/chadtree",
		branch = "chad",
		run = ":CHADdeps",
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
		config = function()
			require("telescope_conf")
		end,
	}

	use {
		'glepnir/galaxyline.nvim',
		branch = 'main',
		config = function() require'galaxylineconf' end,
		requires = {'kyazdani42/nvim-web-devicons', opt = true}
	}

	use "p00f/nvim-ts-rainbow"

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
				--ignore_install = { "javascript" }, -- List of parsers to ignore installing
				highlight = {
					enable = true,              -- false will disable the whole extension
					--disable = { "c", "rust" },  -- list of language that will be disabled
				},
				incremental_selection = { enable = true, keymaps = { init_selection = '<CR>', scope_incremental = '<CR>', node_incremental = '<TAB>', node_decremental = '<S-TAB>', }, },
				rainbow = {
					enable = true,
					-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
					extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
					max_file_lines = nil, -- Do not enable for files with more than n lines, int
					-- colors = {}, -- table of hex strings
					-- termcolors = {} -- table of colour name strings
				}
			}
		end,
	}

	-- LSP stuff
	use 'neovim/nvim-lspconfig'

	-- conf for nvim-cmp
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
	-- not needed anymore?
	-- GoCoverage, snippets are used
	use {
		'fatih/vim-go',
		config = function()
			vim.g.go_def_mapping_enabled = 0
			vim.g.go_doc_keywordprg_enabled = 0
			vim.g.go_textobj_enabled = 0
		end,
	}
	use "kyoh86/vim-go-coverage"
	use 'buoto/gotests-vim'

	use 'scrooloose/nerdcommenter'
	use 'tpope/vim-surround'
	-- Git integration

	use { 'bobrown101/git-blame.nvim',
		config = function()
			vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>lua require('git_blame').run()<cr>", { noremap = true, silent = true })
		end,
	}
	use "editorconfig/editorconfig-vim"

end)
