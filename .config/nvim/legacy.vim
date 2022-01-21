" Set custom settings based on file extension
autocmd FileType dart setlocal shiftwidth=2 softtabstop=2 expandtab
" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e

" Autosave, doesnt work perfectly with go auto format. TODO fix
" autocmd InsertLeave * write

syntax on

let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_textobj_enabled = 0


" ChadTree
" Need a function because CHADtree doesnt work great when using:
" autocmd Filetype CHADTree
function CTree()
	CHADopen
	" " Removes listchars from CHADTree
	" " sleep 100m
	" " setlocal nolist
	" " redraw
endfunction
nnoremap ,m <cmd>call CTree()<cr>
autocmd BufEnter * if (&filetype == "chadtree") | setlocal nolist
"close vim if chadtree is the last window
autocmd BufEnter * if (winnr("$") == 1 && &filetype == "chadtree") | q | endif

" Nvim-tree.lua
" nnoremap ,m :NvimTreeToggle<CR>
" nnoremap ,n :NvimTreeRefresh<CR>
" " autocmd BufEnter * :NvimTreeFindFile
" function Banan()
	" if (&filetype != "NvimTree")
		" NvimTreeFindFile
	" endif
" endfunction
"autocmd BufEnter * call Banan()

" Cursor is always in the middle of the screen
" Must be done with a autocmd because ChadTree behaves weird otherwise
" autocmd BufEnter * setlocal scrolloff=999
set scrolloff=999

" Useful when for example wanting to run dlv with a break point
function FileAndLineNumber()
	let file_and_line_number=execute('echo @% . ":" . line(".")')
	"remove \n from begining of string
	let @+=substitute(file_and_line_number, "\n", "", "")
endfunction
nnoremap <leader>y <cmd>call FileAndLineNumber()<CR>

" Telescope
nnoremap <C-P> <cmd>lua require("telescope.builtin").find_files()<cr>
nnoremap <A-p> <cmd>lua require('telescope.builtin').find_files({no_ignore=true, hidden=true})<cr>
nnoremap <C-F> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <F1> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>h <cmd>lua require('telescope.builtin').help_tags()<cr>

" Nerdcommenter
" remove default mappings
let g:NERDCreateDefaultMappings = 0
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
nnoremap <C-c> :call nerdcommenter#Comment("n", "Toggle")<CR>
vnoremap <C-c> :call nerdcommenter#Comment("n", "Toggle")<CR>

" LSP completion
"inoremap <silent><expr> <C-Space> compe#complete()
"inoremap <silent><expr> <CR>      compe#confirm('<CR>')
"inoremap <silent><expr> <C-e>     compe#close('<C-e>')
"inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
"inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

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
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" delete without yanking
nnoremap <leader>d "_d
nnoremap <leader>D "_d$
vnoremap <leader>d "_d
vnoremap <leader>D "_d$

"replace currently selected text with default register
"without yanking it
"vnoremap <leader>p _dP
"replace with Register 0
map <leader>rr ciw<C-r>0<Esc>

map <C-q> :x<CR>

nnoremap <leader>d "_d

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

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

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

" Some sweet macros!
" PHP
"replace PHP array() to []
let @p='/\<array\>(dema%r]``ar['

" Setup easier bindings for help/man pages
autocmd FileType help nnoremap <buffer> gd <C-]>
autocmd FileType man nnoremap <buffer> gd <C-]>


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
