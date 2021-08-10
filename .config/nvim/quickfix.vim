let g:the_primeagen_qf_l = 0
let g:the_primeagen_qf_g = 0

fun! ToggleQFList(global)
	if a:global
		if g:the_primeagen_qf_g == 1
			cclose
		else
			copen
		end
	else
		echo 'toggle locallist'
		if g:the_primeagen_qf_l == 1
			lclose
		else
			lopen
		end
	endif
endfun

" Populate locallist with lsp diagnostics automatically
augroup locallist
	autocmd!
	autocmd User LspDiagnosticsChanged :lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
augroup END

augroup fixlist
	autocmd!
	autocmd BufWinEnter quickfix call SetQFControlVariable()
	autocmd BufWinLeave * call UnsetQFControlVariable()
augroup END

fun! SetQFControlVariable()
	if getwininfo(win_getid())[0]['loclist'] == 1
		let g:the_primeagen_qf_l = 1
	else
		let g:the_primeagen_qf_g = 1
	end
endfun

fun! UnsetQFControlVariable()
	if getwininfo(win_getid())[0]['loclist'] == 1
		let g:the_primeagen_qf_l = 0
	else
		let g:the_primeagen_qf_g = 0
	end
endfun

nnoremap <C-q> :call ToggleQFList(1)<CR>
nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz

" close local fixlist window
nnoremap <leader>q :call ToggleQFList(0)<CR>zz
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz
