-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local grep_dir = function(node)
	local search_dir = node.absolute_path
	vim.api.nvim_command(string.format("lua require('telescope.builtin').live_grep( { search_dirs = { '%s' } } )", search_dir))
end

-- Source: https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
local function open_nvim_tree(data)
	local IGNORED_FT = {
		"markdown",
	}
	-- buffer is a real file on the disk
	local real_file = vim.fn.filereadable(data.file) == 1
	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	local argc = vim.fn.argc() > 0
	if argc  then
		return
	end
	-- &ft
	local filetype = vim.bo[data.buf].ft
	-- only files please
	if not real_file and not no_name then
		return
	end
	-- skip ignored filetypes
	if vim.tbl_contains(IGNORED_FT, filetype) then
		return
	end

	local path = vim.loop.cwd() .. "/.git"
	put(path)
	local ok, err = vim.loop.fs_stat(path)
	if not ok then
		return
	end

	-- open the tree but don't focus it
	require("nvim-tree.api").tree.toggle({ focus = false })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

require'nvim-tree'.setup {
	disable_netrw       = true,
	hijack_netrw        = true,
	open_on_tab         = false,
	hijack_cursor       = false,
	update_cwd          = true,
	diagnostics = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		}
	},
	update_focused_file = {
		enable      = true,
		update_cwd  = false,
		ignore_list = {}
	},
	system_open = {
		cmd  = nil,
		args = {}
	},
	filters = {
		dotfiles = false,
		custom = {}
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
	-- actions = { open_file = { } },
	view = {
		width = 50,
		hide_root_folder = false,
		side = 'left',
		mappings = {
			custom_only = false,
			list = {
				{ key = "f", action = "Live grep dir", action_cb = grep_dir },
			},
		},
		number = false,
		relativenumber = false,
		signcolumn = "yes"
	},
	trash = {
		cmd = "trash",
		require_confirm = true
	},
	renderer = {
		indent_width = 4,
		indent_markers = {
			enable = true,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				bottom = "─",
				none = " ",
			},
		},
	}
}
