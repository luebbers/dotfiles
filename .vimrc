"" General
set number                     "  Show line numbers
set linebreak                  "  Break lines at word (requires Wrap lines)
set showbreak=+++              "  Wrap-broken line prefix
set textwidth=100              "  Line wrap (number of cols)
set showmatch                  "  Highlight matching brace
set visualbell                 "  Use visual bell (no beeping)
 
set hlsearch                   "  Highlight all search results
set smartcase                  "  Enable smart-case search
set ignorecase                 "  Always case-insensitive
set incsearch                  "  Searches for strings incrementally
 
set autoindent                 "  Auto-indent new lines
set expandtab                  "  Use spaces instead of tabs
set shiftwidth=3               "  Number of auto-indent spaces
set smartindent                "  Enable smart-indent
set smarttab                   "  Enable smart-tabs
set softtabstop=3              "  Number of spaces per Tab
 
"" Advanced
set ruler                      "  Show row and column ruler information
 
set undolevels=1000            "  Number of undo levels
set backspace=indent,eol,start "  Backspace behaviour
let mapleader=","              "  Change leader key to ','
set timeoutlen=1000
set ttimeoutlen=0              "  Fix ESC timeout

"" Keybindings
" Move between windows using ALT+movement
execute "set <M-h>=\eh"
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
execute "set <M-l>=\el"
nmap <silent> <M-j> :wincmd j<CR>
nmap <silent> <M-h> :wincmd h<CR>
nmap <silent> <M-l> :wincmd l<CR>
nmap <silent> <M-k> :wincmd k<CR>
" Move between tabs using CTRL+movement
nmap <silent> <C-H> :tabp<CR>
nmap <silent> <C-L> :tabn<CR>
" Create splits with CTRL+W- and CTRL+W|
nmap <silent> <C-W>- :sp<CR>
nmap <silent> <C-W>\| :vsp<CR>

"" Plugins
call plug#begin('~/.vim/plugged')

" EasyAlign
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" clang_complete
Plug 'Rip-Rip/clang_complete'
let g:clang_user_options='|| exit 0'

" fugitive
Plug 'tpope/vim-fugitive'

" Add plugins to &runtimepath
call plug#end()

