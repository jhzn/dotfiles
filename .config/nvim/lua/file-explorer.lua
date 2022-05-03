-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local grep_dir = function(node)
	local search_dir = node.absolute_path
	vim.api.nvim_command(string.format("lua require('telescope.builtin').live_grep( { search_dirs = { '%s' } } )", search_dir))
end

require'nvim-tree'.setup {
	disable_netrw       = true,
	hijack_netrw        = true,
	open_on_setup       = false,
	ignore_ft_on_setup  = {},
	auto_close          = false,
	open_on_tab         = false,
	hijack_cursor       = false,
	update_cwd          = true,
	update_to_buf_dir   = {
		enable = true,
		auto_open = true,
	},
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
		ignore = true,
		timeout = 500,
	},
	view = {
		width = 50,
		height = 30,
		hide_root_folder = false,
		side = 'left',
		auto_resize = true,
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
	}
}
