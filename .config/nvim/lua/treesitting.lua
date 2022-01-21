local ts_utils = require'nvim-treesitter.ts_utils'


function Get_current_function_name()
	local current_node = ts_utils.get_node_at_cursor() if not current_node then return "" end
	local expr = current_node

	while expr do
		if expr:type() == 'function_definition' then
			break
		end
		expr = expr:parent()
	end

	if not expr then return "" end
	put("apa")

	return (ts_utils.get_node_text(expr:child(1)))[1]
end

function GET_banan()
	return "HJEJ"
end

