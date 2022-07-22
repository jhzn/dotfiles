local M = {}

function M.merge(a, b)
	if type(a) == 'table' and type(b) == 'table' then
		for k,v in pairs(b) do if type(v)=='table' and type(a[k] or false)=='table' then merge(a[k],v) else a[k]=v end end
	end
	return a
end

-- Retrieve the name of the function the cursor is in.
-- Inspired by https://old.reddit.com/r/neovim/comments/pd8f07/using_treesitter_to_efficiently_show_the_function/hao7zl5/
function M.ts_function_surrounding_cursor(current_node)
	local res = M.get_function_name(current_node, 'function_declaration')
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
		return M.banan(current_node:parent(), obj_name)
	end

	local function find_name (node)
		for i = 0, node:named_child_count() - 1, 1 do
			local child = node:named_child(i)
			local type = child:type()
			if obj_name == 'method_declaration' then
				-- put(obj_name)
				-- put(type .. vim.treesitter.query.get_node_text(child, vim.api.nvim_get_current_buf()))
				if type == 'field_identifier' then
					return vim.treesitter.query.get_node_text(child, vim.api.nvim_get_current_buf())
				end
			else
				if type == 'identifier' or type == 'operator_name' then
					return vim.treesitter.query.get_node_text(child, vim.api.nvim_get_current_buf())
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

return M
