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
