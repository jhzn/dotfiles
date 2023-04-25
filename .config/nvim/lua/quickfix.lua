local M = {}

is_locallist_open = false
is_qflist_open = false

function M.ToggleLL()
	if is_locallist_open then
		vim.cmd("lclose")
		is_locallist_open = false
	else
		is_locallist_open = true
		vim.diagnostic.setloclist({ open_loclist = true, severity = vim.diagnostic.severity.ERROR })
	end
end

function M.ToggleQF()
	if is_qflist_open then
		vim.cmd("cclose")
		is_qflist_open = false
	else
		is_qflist_open = true
		vim.diagnostic.setqflist({ open_qflist = true, severity = vim.diagnostic.severity.ERROR })
		-- vim.diagnostic.setqflist({ open_qflist = true })
	end
end

return M
