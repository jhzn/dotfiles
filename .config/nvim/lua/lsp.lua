local lspconfig = require("lspconfig")
local lsputil = require("lspconfig/util")

---------------------------------------------
-------------- Completion/Snippets ----------
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
local cmp = require("cmp")
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
			-- put(cmp.visible())
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
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
		-- ["<C-CR>"] = cmp.mapping.confirm( { behavior = cmp.ConfirmBehavior.Replace, select = true }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
})
-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})
-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})










---------------------------------------------
------------------ LSP ----------------------
---------------------------------------------

local go_lsp_client_conf = function()

	Go_org_imports = function(wait_ms)
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
	end
	vim.cmd([[ autocmd BufWritePre *.go silent! lua Format_code() ]])
	vim.cmd([[ autocmd BufWritePre *.go silent! lua Go_org_imports() ]])

	-- Setup autoformatting on save
	-- Implements command to run gotests binary from vim
	Go_tests = function(all)
		local cmd = {}
		local binary = "gotests"
		if all == true then
			cmd = {
				binary,
				"-w",
				"-all",
				vim.api.nvim_buf_get_name(0),
			}
		else
			local function_name = require("utils").ts_function_surrounding_current_cursor()
			if function_name == "" then
				print("Failed to get function name.. Not continuing")
				return
			end
			cmd = {
				binary,
				"-w",
				"-only",
				string.format("^%s$", function_name), -- Regex looks like '^MyFunction$'
				vim.api.nvim_buf_get_name(0), -- Current absolute filename
			}
		end
		put(cmd)
		put(vim.fn.system(cmd))
	end
	vim.cmd([[
		command! GoTestCreate :lua Go_tests(false)
		command! GoTestCreateAll :lua Go_tests(true)
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

local get_clients_from_cmd_args = function(arg)
	local result = {}
	for id in (arg or ''):gmatch '(%d+)' do
		result[id] = vim.lsp.get_client_by_id(tonumber(id))
	end
	if vim.tbl_isempty(result) then
		return require('lspconfig.util').get_managed_clients()
	end
	return vim.tbl_values(result)
end

PylspAutoFormat = false

TogglePylspAutoFormat = function()
	put(PylspAutoFormat)
	PylspAutoFormat = not PylspAutoFormat
	put(PylspAutoFormat)


	vim.api.nvim_exec([[ LspRestart ]], false)

	-- TODO FIX
	-- for _, client in ipairs(vim.lsp.get_active_clients()) do
	-- put(client.name)
	-- -- client.stop()
	-- vim.defer_fn(function()
	-- local config = require('lspconfig.configs')[client.name]
	-- put(config.launch())
	-- vim.lsp.start_client(client)
	-- put("starting...")
	-- end, 500)
	-- end


end


Format_code = function()
	vim.lsp.buf.format({
		async = true,
		timeout_ms = 2000,
	})
end

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local opts = { noremap = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>zz", opts)
	buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<C-space>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- Set some keybinds conditional on server capabilities
	if client.server_capabilities.documentFormattingProvider then
		buf_set_keymap("n", "<space>f", "<cmd>lua Format_code()<CR>", opts)
	elseif client.server_capabilities.document_range_formatting then
		vim.api.nvim_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", { noremap = true })
		vim.api.nvim_set_keymap("v", "gm", "<cmd>lua format_range_operator()<CR>", { noremap = true })
	end

	if client.name == "efm" then
		-- Setup autoformatting on save
		vim.api.nvim_exec(
			[[
			autocmd BufWritePre *.ts lua Format_code()
			autocmd BufWritePre *.tsx lua Format_code()
			]],
			false
		)
	end
	if client.name == "sumneko" then
		vim.api.nvim_exec([[ autocmd BufWritePre *.lua lua Format_code() ]], false)
	end
	if client.name == "gopls" then
		go_lsp_client_conf()
	end
	if client.name == "pylsp" and PylspAutoFormat then
		vim.api.nvim_exec([[ autocmd BufWritePre *.py silent! lua Format_code() ]], false)
	end

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
			augroup lsp_document_highlight
			autocmd! * <buffer>
			autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
			]],
			false
		)
	end

	vim.cmd([[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help({ focusable = false })]])

	-- show a window with the LSP diagnostic when moving cursor on the same line
	--vim.cmd [[ autocmd CursorMoved * lua vim.lsp.diagnostic.show_line_diagnostics() ]]
	-- Setup lspconfig.
	--
	-- put("Starting LSP server: " .. client.name)
end

local function lua_lsp_server_conf()
	local sumneko_root_path = vim.env.sumneko_root_path
	if not sumneko_root_path then
		return {}
	end
	local sumneko_binary = "lua-language-server"

	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	-- Configure lua language server for neovim development
	return {
		cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
		Lua = {
			runtime = {
				-- LuaJIT in the case of Neovim
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				enable = true,
				globals = { "vim", "describe" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
		},
	}
end

-- config that activates keymaps and enables snippet support
local function default_server_conf()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	return {
		-- enable snippet support
		capabilities = capabilities,
		-- map buffer local keybindings when the language server attaches
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
	}
end

local utils = require("utils")

local function efm_server_conf()
	-- local eslint = {
		-- lintCommand = "eslint_d --cache -f unix --stdin --stdin-filename ${INPUT}",
		-- lintIgnoreExitCode = true,
		-- lintStdin = true,
		-- lintFormats = { "%f:%l:%c: %m" },
		-- -- formatCommand = 'eslint --stdin --stdin-filename=${INPUT}',
		-- -- formatStdin = true,
	-- }

	local prettier = { formatStdin = true }
	local prettier_bin = "node_modules/prettier/bin-prettier.js"
	if utils.file_exists(prettier_bin) then
		prettier.formatCommand = "./" .. prettier_bin .. " --stdin-filepath ${INPUT}"
	else
		prettier.formatCommand = "prettier --stdin-filepath ${INPUT}"
	end

	return {
		-- css = { prettier },
		-- html = { prettier },
		-- javascript = { prettier, eslint },
		-- javascriptreact = { prettier, eslint },
		-- json = { prettier },
		-- lua = { formatCommand = "stylua" },
		markdown = { prettier },
		-- scss = { prettier },
		typescript = { prettier },
		typescriptreact = { prettier },
		yaml = { prettier },
		-- graphql = { prettier },
	}
end

local function go_lsp_server_conf()
	-- see if the file exists
	function FileExists(file)
		local f = io.open(file, "rb")
		if f then f:close() end
		return f ~= nil
	end

	-- Get the value of the module name from go.mod in PWD
	function GetGoModuleName()
		if not FileExists("go.mod") then return nil end
		for line in io.lines("go.mod") do
			if vim.startswith(line, "module") then
				local items = vim.split(line, " ")
				local module_name = vim.trim(items[2])
				return module_name
			end
		end
		return nil
	end

	-- local goModule = GetGoModuleName()
	return {
		analyses = {
			unusedparams = true,
			-- fieldalignment = true,
			nilness = true,
			shadow = true,
			unusedwrite = true,
			useany = true,
			unusedvariable = true,
		},
		staticcheck = true,
		-- ['local'] = goModule,
		['local'] = "",
	}

end

local servers = {
	"rust_analyzer",
	"gopls",
	"pylsp",
	"bashls",
	-- "sumneko_lua",
	"tsserver",
	"efm",
	"bicep",
	"yamlls"
}
for _, server in pairs(servers) do
	local config = default_server_conf()
	-- language specific config
	if server == "gopls" then
		config.settings = {
			gopls = go_lsp_server_conf()
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
				},
			},
		}
	end
	if server == "sumneko_lua" then
		config = utils.merge(config, lua_lsp_server_conf())
	end
	if server == "efm" then
		local efm_config = efm_server_conf()
		local cfg = {
			-- root_dir = lspconfig.util.root_pattern("."),
			init_options = { documentFormatting = true },
			filetypes = vim.tbl_keys(efm_config),
			settings = {
				lintDebounce = "5s",
				-- rootMarkers = { "." },
				languages = efm_config,
				log_level = 4,
				log_file = '/tmp/efm.log'
			},
		}
		config = utils.merge(config, cfg)
	end
	if server == "yamlls" then
		config.settings = {
			yaml = {
				format = {
					enable = true,
				},
				hover = true,
				completion = true,
				-- ... -- other settings. note this overrides the lspconfig defaults.
				schemas = {
					-- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
					["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
					["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = ".gitlab-ci.yml",
					-- ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = "deploy/cloudformation/*",
					["https://kubernetesjsonschema.dev/v1.10.3-standalone/service-v1.json"] = "k8s_*",
					["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.0/all.json"] = "k8s_*",
					-- ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "api.yaml"
					-- ["https://kubernetesjsonschema.dev/v1.14.0/deployment-apps-v1.json"] = "",
					-- ["../path/relative/to/file.yml"] = "/.github/workflows/*",
					-- ["/path/from/root/of/project"] = "/.github/workflows/*",
				},
				-- customTags = {
					-- "!fn",
					-- "!And",
					-- "!If",
					-- "!Not",
					-- "!Equals",
					-- "!Or",
					-- "!FindInMap sequence",
					-- "!Base64",
					-- "!Cidr",
					-- "!Ref",
					-- "!Ref Scalar",
					-- "!Sub",
					-- "!GetAtt",
					-- "!GetAZs",
					-- "!ImportValue",
					-- "!Select",
					-- "!Split",
					-- "!Join sequence",
				-- },
			},
		}
	end
	if server == "bicep" then
		config = utils.merge(config, {
			cmd = { "dotnet", vim.env.HOME .. "/bin/bicep-langserver/Bicep.LangServer.dll" },
		})
	end

	lspconfig[server].setup(config)
end
