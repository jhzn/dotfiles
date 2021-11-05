local actions = require('telescope.actions')
require('telescope').setup{
	defaults = {
		mappings = {
			i = {
				["<C-n>"] = false,
				["<C-p>"] = false,
				["<C-k>"] = actions.move_selection_previous,
				["<C-j>"] = actions.move_selection_next,
			},
		--	n = {},
		},
		file_ignore_patterns = {"node_modules"}
	},
	pickers = {
		buffers = {
			sort_mru = true,
			-- ignore_current_buffer = true,
			-- sorter = require('telescope.sorters').get_substr_matcher(),
		}
	}
}
