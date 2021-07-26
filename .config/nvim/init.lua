-- Bootstrap packer if it is not installed on the host
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

require('plugins')

vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
    autocmd BufWritePost plugins.lua PackerSync
  augroup end
]], false)

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
opt.clipboard:append { "unnamedplus" }
vim.o.completeopt = "menuone,noselect"

-- make cursor blink
opt.guicursor = 'a:blinkon100'
opt.spelllang = { 'en_gb', 'sv' }

-- Splits open at the bottom and right, which is non-retarded, unlike vim defaults :)
opt.splitbelow = true
opt.splitright = true

opt.tabstop = 4      -- To match the sample file
opt.expandtab = false    -- Use tabs, not spaces
opt.wrap = false  --dont wrap lines visually
opt.relativenumber = true --Relative linenumber and absolut linenumber where the cursor currently is
opt.number = true --Relative linenumber and absolut linenumber where the cursor currently is
opt.list = true-- Shows whitespace as a character
opt.listchars = { lead = '.', trail = '.', tab = '→ ', eol = '¬' }
g.tabstop = 4       -- number of visual spaces per TAB
opt.softtabstop = 4   -- number of spaces in tab when editing
opt.shiftwidth = 4 -- Make tabbing 4 spaces wide
opt.cursorline = true          -- highlight current line
opt.showmatch = true           -- highlight matching [{()}]
opt.incsearch = true           -- search as characters are entered
opt.hlsearch = true            -- highlight matches
opt.path:append { '**' } --Enables recusive :find for example
opt.ignorecase = true
-- Ignore filepaths when fuzzy finding
opt.wildignore:append { '**/node_modules/**', '**/vendor/**' }
opt.mouse = "nv"

-- increment to 2 because the format changed in some version of neovim
opt.undodir = HOME .. '/.cache/nvim_undo2'
opt.undofile = true

-- <Tab> to navigate the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

-- TODO port to lua
cmd'source ~/.config/nvim/legacy.vim'

require('lsp')
