local lspconfig = require('lspconfig')
local lsputil = require 'lspconfig/util'

function _G.put(...)
	local objects = {} for i = 1, select('#', ...) do
		local v = select(i, ...)
		table.insert(objects, vim.inspect(v))
	end

	print(table.concat(objects, '\n'))
	return ...
end


---------------------------------------------
------------------ Completion ---------------
---------------------------------------------

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-- Setup nvim-cmp.
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

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require('cmp')
require("snippets")


cmp.setup({
	snippet = {
		expand = function(args)
			-- For `luasnip` user.
			luasnip.lsp_expand(args.body)
		end,
	},
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
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select  = true,
		}),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
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

---------------------------------------------
------------------ LSP ----------------------
---------------------------------------------


local go_lsp_conf = function()
	Goimports = function(timeout_ms)
		local context = { only = { "source.organizeImports" } }
		vim.validate { context = { context, "t", true } }

		local params = vim.lsp.util.make_range_params()
		params.context = context

		-- See the implementation of the textDocument/codeAction callback
		-- (lua/vim/lsp/handler.lua) for how to do this properly.
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
		if not result or next(result) == nil then return end
		local actions = result[1].result
		if not actions then return end
		local action = actions[1]

		-- textDocument/codeAction can return either Command[] or CodeAction[]. If it
		-- is a CodeAction, it can have either an edit, a command or both. Edits
		-- should be executed first.
		if action.edit or type(action.command) == "table" then
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit)
			end
			if type(action.command) == "table" then
				vim.lsp.buf.execute_command(action.command)
			end
		else
			vim.lsp.buf.execute_command(action)
		end
	end

	vim.cmd([[ autocmd BufWritePre *.go lua Goimports(1000) ]])
	-- Setup autoformatting on save
	vim.cmd([[
		autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 500)
		autocmd BufWritePre *.go.in lua vim.lsp.buf.formatting_sync(nil, 500)
		]])


	-- Implements command to run gotests binary from vim
	Go_tests = function(all)
		local cmd = {}
		local binary = "gotests"
		if all == true then
			cmd = {
				binary,
				'-w',
				"-all",
				vim.api.nvim_buf_get_name(0),
			}
		else
			cmd = {
				binary,
				'-w',
				"-only", string.format("^%s$", require("utils").ts_function_surrounding_cursor()), -- Regex looks like '^MyFunction$'
				vim.api.nvim_buf_get_name(0), -- Current absolute filename
			}
		end

		print(vim.fn.system(cmd))
	end
	vim.cmd([[
		command! GoTest :lua Go_tests(false)
		command! GoTestAll :lua Go_tests(true)
	]])

end


-- local function format_range_operator()
	-- local old_func = vim.go.operatorfunc
	-- _G.op_func_formatting = function()
		-- local start = vim.api.nvim_buf_get_mark(0, '[')
		-- local finish = vim.api.nvim_buf_get_mark(0, ']')
		-- vim.lsp.buf.range_formatting({}, start, finish)
		-- vim.go.operatorfunc = old_func
		-- _G.op_func_formatting = nil
	-- end
	-- vim.go.operatorfunc = 'v:lua.op_func_formatting'
	-- vim.api.nvim_feedkeys('g@', 'n', false)
-- end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	local opts = { noremap=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>zz', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<C-space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

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
		go_lsp_conf()
	end
	if client.name == "pylsp" then
		vim.api.nvim_exec([[
			autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 2000)
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

	-- vim.cmd 'source ~/.config/nvim/quickfix.vim'
	require("quickfix")


	-- -- Set location list with the errors of a file
	-- local method = "textDocument/publishDiagnostics"
	-- local default_handler = vim.lsp.handlers[method]
	-- vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
		-- print("banan")
		-- default_handler(err, method, result, client_id, bufnr, config)
		-- local diagnostics = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR})
		-- local qflist = {}
		-- for buffer_number, diagnostic in pairs(diagnostics) do
			-- for _, d in ipairs(diagnostic) do
				-- d.bufnr = buffer_number
				-- d.lnum = d.range.start.line + 1
				-- d.col = d.range.start.character + 1
				-- d.text = d.message
				-- table.insert(qflist, d)
			-- end
		-- end
		-- vim.diagnostic.setloclist(qflist,'r')
	-- end

	-- local severity_map = { "E", "W", "I", "H" }

	-- local parse_diagnostics = function(diagnostics)
		-- if not diagnostics then return end
		-- local items = {}
		-- for _, diagnostic in ipairs(diagnostics) do
			-- local fname = vim.fn.bufname()
			-- local position = diagnostic.range.start
			-- local severity = diagnostic.severity
			-- table.insert(items, {
				-- filename = fname,
				-- type = severity_map[severity],
				-- lnum = position.line + 1,
				-- col = position.character + 1,
				-- text = diagnostic.message:gsub("\r", ""):gsub("\n", " ")
			-- })
		-- end
		-- return items
	-- end

	-- -- redefine unwanted callbacks to be an empty function
	-- -- notice that I keep `vim.lsp.util.buf_diagnostics_underline()`
	-- vim.lsp.util.buf_diagnostics_signs = function() return end
	-- vim.lsp.util.buf_diagnostics_virtual_text = function() return end

	-- update_diagnostics_loclist = function()
		-- bufnr = vim.fn.bufnr()
		-- diagnostics = vim.lsp.util.diagnostics_by_buf[bufnr]

		-- items = parse_diagnostics(diagnostics)
		-- vim.diagnostic.setloclist(items)

		-- -- vim.api.nvim_command("doautocmd QuickFixCmdPost")
	-- end

	-- vim.api.nvim_command [[autocmd! User LspDiagnosticsChanged lua update_diagnostics_loclist()]]


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
	-- put("Starting LSP server: " .. client.name)
end

local function lua_lsp_conf()
	local sumneko_root_path = vim.env.HOME .. "/.nix-profile/share/lua-language-server"
	local sumneko_binary = 'lua-language-server'

	local runtime_path = vim.split(package.path, ';')
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	-- Configure lua language server for neovim development
	return {
		cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
		-- cmd = {sumneko_binary},
		Lua = {
			runtime = {
				-- LuaJIT in the case of Neovim
				version = 'LuaJIT',
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				enable = true,
				globals = {'vim', 'describe'},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand('$VIMRUNTIME/lua/vim')] = true,
					[vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
				},
			},
		}
	}
end

-- config that activates keymaps and enables snippet support
local function make_config()
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
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

	-- local clang_format = { formatCommand = 'clang-format -style=LLVM ${INPUT}', formatStdin = true }
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

local utils = require("utils")

-- local servers = { "rust_analyzer", "gopls", "pylsp", "bashls", "sumneko_lua", "tsserver", "efm", "bicep", "yamlls" }
local servers = { "rust_analyzer", "gopls", "pylsp", "bashls", "sumneko_lua", "tsserver", "efm"  }
-- local servers = {}
for _, server in pairs(servers) do
	local config = make_config()
	-- language specific config
	if server == "gopls" then
		config.settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					-- fieldalignment = true,
					nilness = true,
					shadow = true,
					unusedwrite = true,
				},
				staticcheck = true,
			},
		}
	end
	if server == "pylsp" then
		config.settings = {
			pylsp = {
				-- configurationSources = {'flake8'},
				plugins = {
					pylint = { enabled = false },
					flake8 = { enabled = true },
					pycodestyle = { enabled = false },
					pyflakes = { enabled = false },
					mccabe = { enabled = false },
				}
			}
		}
	end
	-- if server == "yamlls" then
		-- config.settings = {
			-- yaml = {
				-- -- ... -- other settings. note this overrides the lspconfig defaults.
				-- schemas = {
					-- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					-- -- ["../path/relative/to/file.yml"] = "/.github/workflows/*",
					-- -- ["/path/from/root/of/project"] = "/.github/workflows/*",
				-- },
			-- },
		-- }
	-- end
	if server == "sumneko_lua" then
		config = utils.merge(config, lua_lsp_conf())
		-- put(config)
	end
	if server == "efm" then
		local format_config = efm_conf()
		config.init_options = { documentFormatting = true }
		config.filetypes = vim.tbl_keys(format_config)
		config.cmd = {"efm-langserver", "-logfile", "/tmp/efm.log", "-loglevel", "4" }
		config.settings = {
				lintDebounce = "5s",
				rootMarkers = {"."},
				languages = format_config,
			}
	end
	-- if server == "bicep" then
		-- config = merge(config, {
			-- cmd = { "dotnet", vim.env.HOME .. "/bin/bicep-langserver/Bicep.LangServer.dll" },
		-- })
	-- end
	lspconfig[server].setup(config)
end

