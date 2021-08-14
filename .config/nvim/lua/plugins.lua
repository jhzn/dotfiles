vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd vimball]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'navarasu/onedark.nvim',
		config = function()
			require('onedark').setup()
		end,
	}

	--use {
		--'hoob3rt/lualine.nvim',
		--requires = {'kyazdani42/nvim-web-devicons', opt = true},
		--config = function()
			--require("statusline")
		--end,
	--}

	use {
		"kyazdani42/nvim-tree.lua",
		requires = {'kyazdani42/nvim-web-devicons', opt = true},
		config = function()
			require("file-explorer")
		end,
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
			}
		end,
	}

	-- LSP stuff
	use 'neovim/nvim-lspconfig'
	use "hrsh7th/nvim-compe"
	use {
		"kosayoda/nvim-lightbulb",
		config = function()
			vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
		end,
	}
	use "norcalli/snippets.nvim"

	-- GO stuff
	-- use 'fatih/vim-go' -- not needed anymore?
	use 'buoto/gotests-vim'

	use 'scrooloose/nerdcommenter'
	use 'tpope/vim-surround'
	-- Git integration
--	use 'tpope/vim-fugitive'
	use {
		'lewis6991/gitsigns.nvim',
		requires = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('gitsigns').setup()
		end
	}
	--use {
		--"lukas-reineke/indent-blankline.nvim",
		--config = function()
			--g.indent_blankline_space_char = ' '
		--end,
	--}

end)
