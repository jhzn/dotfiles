call plug#begin('~/.config/nvim/plugins')

" Themes
Plug 'https://github.com/rakr/vim-one.git'
Plug 'https://github.com/joshdick/onedark.vim'

" Nice to have
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/vim-airline/vim-airline'

" Language stuff
Plug 'https://github.com/Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'https://github.com/sheerun/vim-polyglot'
Plug 'https://github.com/fatih/vim-go'

call plug#end()

" ## PLUGINS conf begin ##
"
" Nerdtree begin
map <C-b> :NERDTreeToggle<CR>
" Nerdtree end

" Deoplete
let g:deoplete#enable_at_startup = 1

" Theme begin

"let g:airline_theme='one'
"colorscheme one
"set background=dark " for the dark version

let g:airline_theme='onedark'
syntax on
colorscheme onedark


"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
" Theme end


" ## PLUGINS conf end ##

"Make VIM and X11 share the came clipboard. Neovim require no extra thought, it works out of the box
"Make sure you have a vim version compiled with +clipboard or +xterm_clipboard
"Use 'vim --version | grep clipboard' and find those string
"More info here: https://vim.fandom.com/wiki/Accessing_the_system_clipboard
set clipboard=unnamedplus

set completeopt=longest,menuone

set number "Show line numbers
set list	" Shows whitespace as a character
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4	" Make tabbing 4 spaces wide
set cursorline          " highlight current line
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %


" taken form here https://shapeshed.com/vim-netrw/
"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 25
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END
