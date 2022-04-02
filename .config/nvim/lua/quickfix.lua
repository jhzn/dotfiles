is_locallist_open = false
is_qflist_open = false

function ToggleLL()
	if is_locallist_open then
		vim.cmd("lclose")
		is_locallist_open = false
	else
		is_locallist_open = true
		vim.diagnostic.setloclist({ open_loclist = true, severity = vim.diagnostic.severity.ERROR })
	end
end

function ToggleQF()
	if is_qflist_open then
		vim.cmd("cclose")
		is_qflist_open = false
	else
		is_qflist_open = true
		vim.diagnostic.setqflist({ open_qflist = true, severity = vim.diagnostic.severity.ERROR })
		-- vim.diagnostic.setqflist({ open_qflist = true })
	end
end

vim.cmd[[
	nnoremap <A-q> :lua ToggleQF()<CR>
	nnoremap <A-j> :cnext<CR>zz
	nnoremap <A-k> :cprev<CR>zz

	nnoremap <leader>q :lua ToggleLL()<CR>
	nnoremap <leader>j :lnext<CR>zz
	nnoremap <leader>k :lprev<CR>zz
]]
