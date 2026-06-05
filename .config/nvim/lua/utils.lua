local M = {}

function M.merge(a, b)
	if type(a) == 'table' and type(b) == 'table' then
		for k,v in pairs(b) do if type(v)=='table' and type(a[k] or false)=='table' then merge(a[k],v) else a[k]=v end end
	end
	return a
end

function M.ts_function_surrounding_current_cursor()
	-- return M.ts_function_surrounding_cursor(require('nvim-treesitter.ts_utils').get_node_at_cursor())
	return M.ts_function_surrounding_cursor(vim.treesitter.get_node())
end
-- lua print(require('nvim-treesitter.ts_utils').get_node_at_cursor():type())
-- lua print(require("utils").get_function_name(require('nvim-treesitter.ts_utils').get_node_at_cursor(), "field_definition"))
-- Retrieve the name of the function the cursor is in.
-- Inspired by https://old.reddit.com/r/neovim/comments/pd8f07/using_treesitter_to_efficiently_show_the_function/hao7zl5/
function M.ts_function_surrounding_cursor(current_node)
	-- First attempt to find a function_declaration
	local res = M.get_function_name(current_node, 'function_declaration')
	-- If that fails try finding a method_declaration
	if res == "" then
		res = M.get_function_name(current_node, 'method_declaration')
		-- if res == "" then
			-- return  M.get_function_name(current_node, 'field_definition')
		-- end
	end
	return res
end

function M.get_function_name(current_node, obj_name)
	if not current_node then
		return ""
	end
	-- put("Type: " .. current_node:type())
	if current_node:type() ~= obj_name then
		return M.get_function_name(current_node:parent(), obj_name)
	end

	local function find_name (node)
		for i = 0, node:named_child_count() - 1, 1 do
			local child = node:named_child(i)
			local type = child:type()

			local func_name = vim.treesitter.get_node_text(child, vim.api.nvim_get_current_buf())
			-- Uncomment to debug
			-- put(obj_name .. " | " .. type .. " | " .. func_name)




			-- if obj_name == 'field_definition' and type == 'property_identifier' then -- Javascript
				-- local t = vim.treesitter.get_node_text(child, vim.api.nvim_get_current_buf())
				-- return t
			-- end
			if obj_name == 'method_declaration' and type == 'field_identifier' then -- Golang
				return func_name
			end
			if obj_name == 'function_declaration' and type == 'identifier' then -- Golang
				return func_name
			end

			local name = find_name(child)
			if name then
				return name
			end
		end

		return nil
	end

	return find_name(current_node)
end

function M.file_exists(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end

function M.clipboard_set(content)
	vim.fn.setreg("+", content)
end

function M.is_big_file(filepath)
	filepath = vim.fn.expand(filepath)
	stat = vim.loop.fs_stat(filepath, function(_, stat)
		return stat
	end)
	if not stat or not stat.size then
		return
	end
	if stat.size > 10000 then
		return true
	end
	return false
end

function M.longest_line(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	if #lines == 0 then
		return 0
	end
	-- local width = #(lines[1])
	local width = 0
	for _, line in ipairs(lines) do
		if #line > width then
			width = #line
		end
	end
	return width
end


---Validates args for `throttle()` and  `debounce()`.
local function td_validate(fn, ms)
	vim.validate{
		fn = { fn, 'f' },
		ms = {
			ms,
			function(ms)
				return type(ms) == 'number' and ms > 0
			end,
			"number > 0",
		},
	}
end
--- Throttles a function on the leading edge. Automatically `schedule_wrap()`s.
---
--@param fn (function) Function to throttle
--@param timeout (number) Timeout in ms
--@returns (function, timer) throttled function and timer. Remember to call
---`timer:close()` at the end or you will leak memory!
--
-- Source: https://gist.github.com/runiq/31aa5c4bf00f8e0843cd267880117201
function M.throttle_leading(fn, ms)
	td_validate(fn, ms)
	local timer = vim.loop.new_timer()
	local running = false

	local function wrapped_fn(...)
		if not running then
			timer:start(ms, 0, function()
				running = false
			end)
			running = true
			pcall(vim.schedule_wrap(fn), select(1, ...))
		end
	end
	return wrapped_fn, timer
end


function M.debounce_leading(fn, ms)
	td_validate(fn, ms)
	local timer = vim.loop.new_timer()
	local running = false

	local function wrapped_fn(...)
		timer:start(ms, 0, function()
			running = false
		end)

		if not running then
			running = true
			pcall(vim.schedule_wrap(fn), select(1, ...))
		end
	end
	return wrapped_fn, timer
end

return M

