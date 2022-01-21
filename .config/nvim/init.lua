-- Bootstrap packer if it is not installed on the host
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
	execute 'packadd packer.nvim'
end

function _G.put(...)
	local objects = {}
	for i = 1, select('#', ...) do
		local v = select(i, ...)
		table.insert(objects, vim.inspect(v))
	end

	print(table.concat(objects, '\n'))
	return ...
end

require('plugins')

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options
local HOME = vim.env.HOME

-- easier to create mappings with this
local function map(mode, lhs, rhs, opts)
	local options = {noremap = true}
	if opts then options = vim.tbl_extend('force', options, opts) end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

g.mapleader = " "

-- Make VIM and X11 share the came clipboard
-- opt.clipboard:append { "unnamed", "unnamedplus" }
opt.clipboard:append { "unnamedplus" }
vim.o.completeopt = "menuone,noselect"

opt.guicursor = 'a:blinkon100' -- make cursor blink
-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults :)
opt.splitbelow = true
opt.splitright = true
-- opt.spelllang = { 'en_gb', 'sv' } -- TODO figure out some way to toggle between different languages
opt.spelllang = { 'en_gb'}
opt.spell = true
opt.tabstop = 4      -- To match the sample file
opt.expandtab = false    -- Use tabs, not spaces
opt.wrap = false  --dont wrap lines visually
opt.relativenumber = true --Relative linenumber and absolut linenumber where the cursor currently is
opt.number = true --Relative linenumber and absolut linenumber where the cursor currently is
opt.list = true-- Shows whitespace as a character
opt.listchars = { lead = '·', trail = '·', tab = '→ ', eol = '¬' }
g.tabstop = 4       -- number of visual spaces per TAB
opt.softtabstop = 4   -- number of spaces in tab when editing
opt.shiftwidth = 4 -- Make tabbing 4 spaces wide
opt.cursorline = true          -- highlight current line
opt.showmatch = true           -- highlight matching [{()}]
opt.incsearch = true           -- search as characters are entered
opt.inccommand = "nosplit"  -- show substititions live
opt.hlsearch = true            -- highlight matches
opt.path:append { '**' } --Enables recusive :find for example
opt.ignorecase = true
-- Ignore filepaths when fuzzy finding
opt.wildignore:append { '**/node_modules/**', '**/vendor/**' }
opt.mouse = "nv"
opt.autowrite = true

-- increment to 2 because the format changed in some version of neovim
opt.undodir = HOME .. '/.cache/nvim_undo2'
opt.undofile = true

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})


-- Detect filetype and set it, if vim cant figure it out
Detect_ft = function()
	if vim.bo.filetype == "" then
		local set_ft = function(t) vim.opt.filetype=t end
		local cmd = 'file --mime-type ' .. vim.api.nvim_buf_get_name(0) ..  " | awk '{printf \"%s\", $2}'"
		local mime = vim.fn.system({"sh", "-c", cmd})
		if mime == "application/json" then set_ft("json") end
		if mime == "application/xml" then set_ft("xml") end
	end
end
cmd [[ autocmd BufEnter * lua Detect_ft() ]]

cmd [[ autocmd BufNewFile,BufRead *.bicep set filetype=bicep ]]

-- TODO port to lua
cmd'source ~/.config/nvim/legacy.vim'
require('lsp')
require('treesitting')
