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
	use "L3MON4D3/LuaSnip"

	-- GO stuff
	use 'fatih/vim-go' -- not needed anymore?
	use 'buoto/gotests-vim'

	use 'scrooloose/nerdcommenter'
	use 'tpope/vim-surround'
	-- Git integration

	use { 'bobrown101/git-blame.nvim',
		config = function()
			vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>lua require('git_blame').run()<cr>", { noremap = true, silent = true })
		end,
	}


end)
