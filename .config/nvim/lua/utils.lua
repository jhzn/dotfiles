local M = {}

function M.merge(a, b)
	if type(a) == 'table' and type(b) == 'table' then
		for k,v in pairs(b) do if type(v)=='table' and type(a[k] or false)=='table' then merge(a[k],v) else a[k]=v end end
	end
	return a
end

function M.ts_function_surrounding_current_cursor()
	return M.ts_function_surrounding_cursor(require('nvim-treesitter.ts_utils').get_node_at_cursor())
end

-- Retrieve the name of the function the cursor is in.
-- Inspired by https://old.reddit.com/r/neovim/comments/pd8f07/using_treesitter_to_efficiently_show_the_function/hao7zl5/
function M.ts_function_surrounding_cursor(current_node)
	-- First attempt to find a function_declaration
	local res = M.get_function_name(current_node, 'function_declaration')
	-- If that fails try finding a method_declaration
	if res == "" then
		return M.get_function_name(current_node, 'method_declaration')
	end
	return res
end

function M.get_function_name(current_node, obj_name)
	if not current_node then
		return ""
	end
	if current_node:type() ~= obj_name then
		return M.get_function_name(current_node:parent(), obj_name)
	end

	local function find_name (node)
		for i = 0, node:named_child_count() - 1, 1 do
			local child = node:named_child(i)
			local type = child:type()
			if obj_name == 'method_declaration' then
				if type == 'field_identifier' then
					return vim.treesitter.get_node_text(child, vim.api.nvim_get_current_buf())
				end
			else
				if type == 'identifier' or type == 'operator_name' then
					return vim.treesitter.get_node_text(child, vim.api.nvim_get_current_buf())
				end
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

return M
