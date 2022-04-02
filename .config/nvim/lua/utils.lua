local M = {}

function M.merge(a, b)
	if type(a) == 'table' and type(b) == 'table' then
		for k,v in pairs(b) do if type(v)=='table' and type(a[k] or false)=='table' then merge(a[k],v) else a[k]=v end end
	end
	return a
end

prev_function_node = nil
prev_function_name = ""

-- Source https://old.reddit.com/r/neovim/comments/pd8f07/using_treesitter_to_efficiently_show_the_function/hao7zl5/
-- < Retrieve the name of the function the cursor is in.
-- TODO can we make this cleaner?
function M.ts_function_surrounding_cursor()
    local ts_utils = require('nvim-treesitter.ts_utils')
    local current_node = ts_utils.get_node_at_cursor()

    if not current_node then
        return ""
    end

    local func = current_node

    while func do
        if func:type() == 'function_declaration' then
            break
        end

        func = func:parent()
    end

    if not func then
        prev_function_node = nil
        prev_function_name = ""
        return ""
    end

    if func == prev_function_node then
        return prev_function_name
    end

    prev_function_node = func

    local find_name
    find_name = function(node)
        for i = 0, node:named_child_count() - 1, 1 do
            local child = node:named_child(i)
            local type = child:type()

            if type == 'identifier' or type == 'operator_name' then
                return (ts_utils.get_node_text(child))[1]
            else
                local name = find_name(child)

                if name then
                    return name
                end
            end
        end

        return nil
    end

    prev_function_name = find_name(func)
    return prev_function_name
end

return M
