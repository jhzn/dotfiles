" Set custom settings based on file extension
autocmd FileType dart setlocal shiftwidth=2 softtabstop=2 expandtab
" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e
" Open file explorer on startup
"autocmd BufEnter * NvimTreeOpen

syntax on


"Flashy transparency :) make sure you terminal follows along
hi Normal guibg=NONE ctermbg=NONE
let g:onedark_transparent_background = 1 " By default it is 0
colorscheme onedark


" Nvim-tree.lua
nnoremap ,m :NvimTreeToggle<CR>
nnoremap ,n :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <F1> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" LSP completion
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"Disable Ex mode
map Q <nop>

" Disable Arrow keys in Normal mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>


filetype on "detect files bases on type
filetype plugin on "when a file is edited its plugin file is loaded(if there is one)
filetype indent on "maintain indentation

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

"replace currently selected text with default register
"without yanking it
"vnoremap <leader>p _dP
"replace with Register 0
map <leader>rr ciw<C-r>0<Esc>

"Clears highlighted
nnoremap <CR> :noh<CR>

"Keybinding to toggle syncronization of window scrolling
map <leader>S :windo set scb!<CR>

"Keybinding to refresh vim config
nnoremap <F12> :source ~/.config/nvim/init.lua <CR>

"Sweet way of previewing markdown
map <leader>ö :execute
			\ '!mkdir -p $HOME/tmp && pandoc --from=gfm % -o $HOME/tmp/nvim-markdown.pdf && (xdg-open $HOME/tmp/nvim-markdown.pdf ) 2> /dev/null & '<enter> | redraw!


" visual shifting and keep visual selection
vnoremap < <gv
vnoremap > >gv

"make Y behave like D and C
nnoremap Y y$
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Zoom / Restore window.
function! s:ZoomToggle() abort
	if exists('t:zoomed') && t:zoomed
		execute t:zoom_winrestcmd
		let t:zoomed = 0
	else
		let t:zoom_winrestcmd = winrestcmd()
		resize
		vertical resize
		let t:zoomed = 1
	endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-W>o :ZoomToggle<CR>

"improve default gx command by opening the URL/filepath in the background instead. This way we dont lock the old window.
nnoremap gx :execute
			\ "!xdg-open" expand("<cfile>")" &"<cr>

noremap <Leader><space> :update<CR>

" Some sweet macros!
" PHP
"replace PHP array() to []
let @p='/\<array\>(dema%r]``ar['






" TODO these are not perfect, find a better solution
" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
	let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction

command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)
