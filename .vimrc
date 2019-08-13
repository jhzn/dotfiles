set number "Show line numbers

"Make VIM and X11 share the came clipboard. 
"Make sure you have a vim version compiled with +clipboard or +xterm_clipboard
"Use 'vim --version | grep clipboard' and find those string
"More info here: https://vim.fandom.com/wiki/Accessing_the_system_clipboard
set clipboard=unnamedplus

set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set cursorline          " highlight current line
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
