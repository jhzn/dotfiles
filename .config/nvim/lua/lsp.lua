local nvim_lsp = require('lspconfig')

function _G.put(...)
	local objects = {}
	for i = 1, select('#', ...) do
		local v = select(i, ...)
		table.insert(objects, vim.inspect(v))
	end

	print(table.concat(objects, '\n'))
	return ...
end

function format_range_operator()
	local old_func = vim.go.operatorfunc
	_G.op_func_formatting = function()
		local start = vim.api.nvim_buf_get_mark(0, '[')
		local finish = vim.api.nvim_buf_get_mark(0, ']')
		vim.lsp.buf.range_formatting({}, start, finish)
		vim.go.operatorfunc = old_func
		_G.op_func_formatting = nil
	end
	vim.go.operatorfunc = 'v:lua.op_func_formatting'
	vim.api.nvim_feedkeys('g@', 'n', false)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	--Enable completion triggered by <c-x><c-o>
	-- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>zz', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	-- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<C-space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	--buf_set_keymap('n', '<space>j', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	--buf_set_keymap('n', '<space>k', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	--buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
	end

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	elseif client.resolved_capabilities.document_range_formatting then
		vim.api.nvim_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", {noremap = true})
		vim.api.nvim_set_keymap("v", "gm", "<cmd>lua format_range_operator()<CR>", {noremap = true})
	end

	if client.name == "efm" then
				-- Setup autoformatting on save
		vim.api.nvim_exec([[
			autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync(nil, 2000)
			autocmd BufWritePre *.tsx lua vim.lsp.buf.formatting_sync(nil, 2000)
			]], false)
	end
	if client.name == "gopls" then
		-- Setup autoformatting on save
		vim.api.nvim_exec([[
			autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)
			autocmd BufWritePre *.go.in lua vim.lsp.buf.formatting_sync(nil, 100)
			]], false)
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

	vim.cmd 'source ~/.config/nvim/quickfix.vim'

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
  -- Setup lspconfig.
  --
	-- print("Starting LSP server: " .. client.name)
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
local function make_config(servername)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

	-- local on_attach_fn = on_attach(servername)
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

local function efm_conf()
	local eslint = {
		lintCommand = 'eslint_d --cache -f unix --stdin --stdin-filename ${INPUT}',
		lintIgnoreExitCode = true,
		lintStdin = true,
		lintFormats = { '%f:%l:%c: %m' },
		-- formatCommand = 'eslint --stdin --stdin-filename=${INPUT}',
		-- formatStdin = true,
	}

	local clang_format = { formatCommand = 'clang-format -style=LLVM ${INPUT}', formatStdin = true }
	local prettier = { formatCommand = 'prettier --stdin-filepath ${INPUT}', formatStdin = true }
	local stylua = { formatCommand = 'stylua -s -', formatStdin = true }

	return {
		-- cpp = { clang_format },
		css = { prettier },
		html = { prettier },
		javascript = { prettier, eslint },
		javascriptreact = { prettier, eslint },
		json = { prettier },
		lua = { stylua },
		markdown = { prettier },
		scss = { prettier },
		typescript = { prettier, eslint },
		-- typescriptreact = { prettier, eslint },
		typescriptreact = { prettier },
		yaml = { prettier },
		graphql = { prettier },
	}
end


local function setup_servers()
	local servers = { "rust_analyzer", "gopls", "pylsp", "bashls", "sumneko_lua", "tsserver", "efm" }
	for _, server in pairs(servers) do
		local config = make_config(server)
		-- language specific config
		if server == "lua" then
			config.settings = lua_settings
		end
		if server == "efm" then
			format_config = efm_conf()
			config.init_options = { documentFormatting = true }
			config.filetypes = vim.tbl_keys(format_config)
			config.settings = {
					lintDebounce = "2s",
					rootMarkers = {".git/"},
					languages = format_config,
				}
		end
		-- print(server)
		require'lspconfig'[server].setup(config)
	end
end

setup_servers()


---------------------------------------------
------------------ Completion ---------------
---------------------------------------------

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-- Setup nvim-cmp.
local cmp = require'cmp'
local lsp_symbols = {
	Text = "   (Text) ",
	Method = "   (Method)",
	Function = "   (Function)",
	Constructor = "   (Constructor)",
	Field = " ﴲ  (Field)",
	Variable = "[] (Variable)",
	Class = "   (Class)",
	Interface = " ﰮ  (Interface)",
	Module = "   (Module)",
	Property = " 襁 (Property)",
	Unit = "   (Unit)",
	Value = "   (Value)",
	Enum = " 練 (Enum)",
	Keyword = "   (Keyword)",
	Snippet = "   (Snippet)",
	Color = "   (Color)",
	File = "   (File)",
	Reference = "   (Reference)",
	Folder = "   (Folder)",
	EnumMember = "   (EnumMember)",
	Constant = " ﲀ  (Constant)",
	Struct = " ﳤ  (Struct)",
	Event = "   (Event)",
	Operator = "   (Operator)",
	TypeParameter = "   (TypeParameter)",
}

cmp.setup({
	formatting = {
		format = function(entry, item)
			item.kind = lsp_symbols[item.kind]
			item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				neorg = "[Neorg]",
			})[entry.source.name]

			return item
		end,
	},
	snippet = {
		expand = function(args)
			-- For `vsnip` user.
			-- vim.fn["vsnip#anonymous"](args.body)

			-- For `luasnip` user.
			require('luasnip').lsp_expand(args.body)

			-- For `ultisnips` user.
			-- vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = {
		['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		['<s-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = 'nvim_lsp' },

		-- For vsnip user.
		-- { name = 'vsnip' },

		-- For luasnip user.
		{ name = 'luasnip' },

		-- For ultisnips user.
		-- { name = 'ultisnips' },

		{ name = 'buffer' },
		{ name = 'path' },
	}
})
-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})
-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})








-- ----------------------------------------------
-- -------------- Snippets ----------------------
-- ----------------------------------------------


-- -- Utility functions for compe and luasnip
-- local t = function(str)
	-- return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

-- local check_back_space = function()
	-- local col = vim.fn.col '.' - 1
	-- if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
		-- return true
	-- else
		-- return false
	-- end
-- end

-- -- Use (s-)tab to:
-- --- move to prev/next item in completion menu
-- --- jump to prev/next snippet's placeholder
-- local luasnip = require 'luasnip'

-- _G.tab_complete = function()
	-- if vim.fn.pumvisible() == 1 then
		-- return t '<C-n>'
	-- elseif luasnip.expand_or_jumpable() then
		-- return t '<Plug>luasnip-expand-or-jump'
	-- elseif check_back_space() then
		-- return t '<Tab>'
	-- else
		-- return vim.fn['compe#complete']()
	-- end
-- end

-- _G.s_tab_complete = function()
	-- if vim.fn.pumvisible() == 1 then
		-- return t '<C-p>'
	-- elseif luasnip.jumpable(-1) then
		-- return t '<Plug>luasnip-jump-prev'
	-- else
		-- return t '<S-Tab>'
	-- end
-- end

-- -- Map tab to the above tab complete functions
-- vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
-- vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
-- vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
-- vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })

-- -- Map compe confirm and complete functions
-- vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
-- vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })
