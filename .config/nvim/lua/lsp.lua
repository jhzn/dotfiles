local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	--Enable completion triggered by <c-x><c-o>
	-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	-- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<C-space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '<space>j', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>k', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)


	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	end
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
			augroup lsp_document_highlight
			autocmd! * <buffer>
			autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
			]], false)
	end

	vim.cmd'source ~/.config/nvim/quickfix.vim'

		--vim.lsp.diagnostic.on_publish_diagnostics, {
			--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
			--virtual_text = false,
			--underline = true,
		--}
	--)
	--
	vim.cmd [[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help({ focusable = false })]]

	-- show a window with the LSP diagnostic when moving cursor on the same line
	--vim.cmd [[ autocmd CursorMoved * lua vim.lsp.diagnostic.show_line_diagnostics() ]]
end

-- Configure lua language server for neovim development
local lua_settings = {
	Lua = {
	runtime = {
	 -- LuaJIT in the case of Neovim
	  version = 'LuaJIT',
	  path = vim.split(package.path, ';'),
	},
	diagnostics = {
	-- Get the language server to recognize the `vim` global
	  globals = {'vim'},
	},
	workspace = {
		-- Make the server aware of Neovim runtime files
		library = {
			[vim.fn.expand('$VIMRUNTIME/lua')] = true,
			[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
			},
		},
	}
}

-- config that activates keymaps and enables snippet support
local function make_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return {
	-- enable snippet support
	capabilities = capabilities,
	-- map buffer local keybindings when the language server attaches
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	}
  }
end

local function setup_servers()
	require'lspinstall'.setup() -- important

	local servers = require'lspinstall'.installed_servers()
	table.insert(servers, "rust_analyzer")
	table.insert(servers, "gopls")
	table.insert(servers, "pylsp")

	for _, server in pairs(servers) do
	local config = make_config()
	-- language specific config
	if server == "lua" then
		config.settings = lua_settings
	end
	if server == "gopls" then
		-- Setup autoformatting on save
		vim.api.nvim_exec([[
			autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
			autocmd BufWritePre *.go.in lua vim.lsp.buf.formatting_sync(nil, 1000)
			]], false)
	end

	require'lspconfig'[server].setup(config)
	end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
	setup_servers() -- reload installed servers
	vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end





---------------------------------------------
------------------ Completion ---------------
---------------------------------------------
require'compe'.setup {
	enabled = true;
	autocomplete = true;
	debug = false;
	min_length = 1;
	preselect = 'enable';
	throttle_time = 80;
	source_timeout = 200;
	resolve_timeout = 800;
	incomplete_delay = 400;
	max_abbr_width = 100;
	max_kind_width = 100;
	max_menu_width = 100;
	documentation = {
	border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
	winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
	max_width = 120,
	min_width = 60,
	max_height = math.floor(vim.o.lines * 0.3),
	min_height = 1,
  };

  source = {
	path = true;
	buffer = true;
	calc = true;
	nvim_lsp = true;
	nvim_lua = true;
	vsnip = true;
	ultisnips = true;
	luasnip = true;
  };
}










----------------------------------------------
-------------- Snippets ----------------------
----------------------------------------------


--require'snippets'.use_suggested_mappings()

-- This variant will set up the mappings only for the *CURRENT* buffer.
--require'snippets'.use_suggested_mappings(true)

-- There are only two keybindings specified by the suggested keymappings, which is <C-k> and <C-j>
-- They are exactly equivalent to:

-- <c-k> will either expand the current snippet at the word or try to jump to
-- the next position for the snippet.
--vim.cmd("inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>")

-- <c-j> will jump backwards to the previous field.
-- If you jump before the first field, it will cancel the snippet.
--vim.cmd("inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>")
