local actions = require('telescope.actions')
local previewers = require("telescope.previewers")
local utils = require("utils")

-- local telescope = require("telescope")
-- local telescopeConfig = require("telescope.config")

-- -- Clone the default Telescope configuration
-- local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
-- -- I want to search in hidden/dot files.
-- table.insert(vimgrep_arguments, "--hidden")
-- -- table.insert(vimgrep_arguments, "--glob")
-- table.insert(vimgrep_arguments, "--smart-case")
-- -- I don't want to search in the `.git` directory.
-- table.insert(vimgrep_arguments, "!**/.git/*")
--


-- local new_maker = function(filepath, bufnr, opts)
  -- opts = opts or {}
  -- if utils.is_big_file(filepath) then
	  -- return
  -- end
  -- previewers.buffer_previewer_maker(filepath, bufnr, opts)
-- end


-- TODO replace with a common function to calculate if file is big
-- Source: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#ignore-files-bigger-than-a-threshold
local previewers = require("telescope.previewers")
local new_maker = function(filepath, bufnr, opts)
	opts = opts or {}

	filepath = vim.fn.expand(filepath)
	vim.loop.fs_stat(filepath, function(_, stat)
		if not stat then return end
		if stat.size > 100000 then
			return
		else
			previewers.buffer_previewer_maker(filepath, bufnr, opts)
		end
	end)
end


require('telescope').setup{
	defaults = {
		  buffer_previewer_maker = new_maker,
		-- vimgrep_arguments = vimgrep_arguments,
		-- vimgrep_arguments = { 'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' },
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
		live_grep = {
			additional_args = function(opts)
				return {"--hidden"}
			end
		},
		buffers = {
			sort_mru = true,
			-- ignore_current_buffer = true,
			-- sorter = require('telescope.sorters').get_substr_matcher(),
		}
	}
}
