
""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" Autocmds """""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""

" Set custom settings based on file extension
autocmd FileType dart setlocal shiftwidth=2 softtabstop=2 expandtab
" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" Autosave, doesnt work perfectly with go auto format. TODO fix
" autocmd InsertLeave * write
" Cursor is always in the middle of the screen
" Must be done with a autocmd because ChadTree behaves weird otherwise
autocmd BufEnter * setlocal scrolloff=999
"
" Setup easier bindings for help/man pages
autocmd FileType help nnoremap <buffer> gd <C-]>
autocmd FileType man nnoremap <buffer> gd <C-]>




""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""" Misc stuff """"""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""

syntax on

filetype on "detect files bases on type
filetype plugin on "when a file is edited its plugin file is loaded(if there is one)
filetype indent on "maintain indentation

" Nerdcommenter (commenter plugin)
" remove default mappings
let g:NERDCreateDefaultMappings = 0
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
"
" Some sweet macros!
" PHP
"replace PHP array() to []
let @p='/\<array\>(dema%r]``ar['





""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" Commands """""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" Search literally!
" use :S .....
com! -nargs=1 S :let @/='\V'.escape(<q-args>, '\\')| normal! n

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

" Winbar to the left, with info if file is modified and its relative file path
" set winbar=%=%m\ %f



""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""" Key mappings """""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""

" Nvim-tree.lua
nnoremap ,m :NvimTreeToggle<CR>
nnoremap ,n :NvimTreeRefresh<CR>
nnoremap ,x :NvimTreeCollapse<CR>

" Yarn $file:$line_number
nnoremap <leader>yl <cmd>lua vim.fn.setreg("+", string.format("%s:%s", vim.api.nvim_buf_get_name(0), vim.fn.line(".")))<CR>
" Yank '$MyFunctionName^'
nnoremap <leader>yf <cmd>lua vim.fn.setreg("+", string.format("'^%s$'", require("utils").ts_function_surrounding_current_cursor())) <cr>
nnoremap <leader>l <cmd>lua vim.fn.setreg("+", string.format("%s", require("utils").ts_function_surrounding_current_cursor())) <cr>

" Telescope(fuzzy picker for file names and file content)
nnoremap <C-P> <cmd>lua require("telescope.builtin").find_files()<cr>
nnoremap <A-p> <cmd>lua require('telescope.builtin').find_files({no_ignore=true, hidden=true})<cr>
nnoremap <C-F> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <F1> <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <C-R> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>

" Spectre(project wide search and replace)
nnoremap <A-f> :lua require('spectre').open()<CR>
nnoremap <A-r> :lua require('spectre.actions').run_replace()<CR>

nnoremap <C-c> :call nerdcommenter#Comment("n", "Toggle")<CR>
vnoremap <C-c> :call nerdcommenter#Comment("n", "Toggle")<CR>

" Hop plugin
nnoremap <A-h> :lua require'hop'.hint_words()<cr>
vnoremap <A-h> :lua require'hop'.hint_words()<cr>

"Disable command history
nnoremap q: <nop>
nnoremap Q <nop>

" Disable keys normal mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

map <home> <nop>
map <end> <nop>
map <pageup> <nop>
map <pagedown> <nop>

" Disable keys keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

imap <home> <nop>
imap <end> <nop>
imap <pageup> <nop>
imap <pagedown> <nop>

" Shortcutting split navigation, saving a keypress:
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" delete without yanking
nnoremap <leader>d "_d
nnoremap <leader>D "_d$
nnoremap <leader>dd 0"_d$

"replace currently selected text with default register
"without yanking it
"vnoremap <leader>p _dP
"replace with Register 0
map <leader>ww ciw<C-r>0<Esc>
map <leader>,, ct,<C-r>0<Esc>
map <leader>(( ci(<C-r>0<Esc>

map <C-q> :x<CR>

" Source: https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
vnoremap p "_dP

"Clears highlighted
nnoremap <ESC> :noh<CR>
nnoremap <BS> :
vnoremap <BS> :

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
nnoremap Y yg_

" I never use x to copy stuff
nnoremap x "_x
" I never use c to copy stuff
nnoremap c "_c

" center cursor
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Move hightlighted text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Maximize a window
nnoremap <leader>m :tabedit %<CR>

"improve default gx command by opening the URL/filepath in the background instead. This way we dont lock the old window.
nnoremap gx :execute
			\ "!xdg-open" expand("<cfile>")" &"<cr>

" normal mode: save
nnoremap <c-s> :w<CR>
" insert mode: escape to normal and save
inoremap <c-s> <Esc>:w<CR>
" visual mode: escape to normal and save
vnoremap <c-s> <Esc>:w<CR>

" ability to insert newline. Should work without shortcut, but something is
" affecting it. TODO What is?
inoremap <CR> <CR>


nnoremap <leader>g :!git add %<CR>
