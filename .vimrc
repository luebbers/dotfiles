"" General
set number                     "  Show line numbers
set linebreak                  "  Break lines at word (requires Wrap lines)
set showbreak=+++              "  Wrap-broken line prefix
set textwidth=79               "  Line wrap (number of cols)
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
set laststatus=2               "  Always show status line$
set undolevels=1000            "  Number of undo levels
set backspace=indent,eol,start "  Backspace behaviour
let mapleader=","              "  Change leader key to ','
set timeoutlen=1000
set ttimeoutlen=0              "  Fix ESC timeout
set wildmenu
set wildmode=longest:full,full "  Turn on wildment
set mouse=a                    "  Enable mouse support
set cursorline                 "  Highlight current line
set listchars=tab:▸\ ,eol:¬    "  Use special characters for whitespace

"" Leader commands
nmap <leader>l :set list!<CR>

"" Keybindings
" Move between windows using ALT+movement or cursor keys
execute "set <M-h>=\eh"
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
execute "set <M-l>=\el"
nmap <silent> <M-j> :wincmd j<CR>
nmap <silent> <M-h> :wincmd h<CR>
nmap <silent> <M-l> :wincmd l<CR>
nmap <silent> <M-k> :wincmd k<CR>
nmap <silent> <Down> :wincmd j<CR>
nmap <silent> <Left> :wincmd h<CR>
nmap <silent> <Right> :wincmd l<CR>
nmap <silent> <Up> :wincmd k<CR>
" Move between tabs using CTRL+movement
nmap <silent> <C-H> :tabp<CR>
nmap <silent> <C-L> :tabn<CR>
" Create splits with CTRL+W- and CTRL+W|
nmap <silent> <C-W>- :sp<CR>
nmap <silent> <C-W>\| :vsp<CR>
" Save with CTRL+S
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it."
command -nargs=0 -bar Update if &modified
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>
inoremap <c-s> <Esc>:Update<CR>

"" Plugins
call plug#begin('~/.vim/plugged')

" solarized
Plug 'altercation/vim-colors-solarized'
syntax enable
set background=dark
"let g:solarized_termcolors=256

" Airline status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" vim-bufferline
Plug 'bling/vim-bufferline'
let g:bufferline_echo = 0

" EasyAlign
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

if $MYSETUP_DEVEL == 1          " general development plugins
" fugitive
Plug 'tpope/vim-fugitive'

" syntastic
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_systemverilog_checkers = ['verilator']
endif

if $MYSETUP_DEVEL_SW == 1        " software development-specific plugins
" clang_complete
Plug 'Rip-Rip/clang_complete'
let g:clang_user_options='|| exit 0'
endif

if $MYSETUP_DEVEL_HW == 1        " hardware development-specific plugins
" SystemVerilog
Plug 'nachumk/systemverilog.vim'
let g:syntastic_filetype_map = { "systemverilog" : "verilog" }
endif

" Add plugins to &runtimepath
call plug#end()

" Set colorscheme (needs runtimepath)
colorscheme solarized
