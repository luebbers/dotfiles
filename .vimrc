"" General
set number                     "  Show line numbers
set linebreak                  "  Break lines at word (requires Wrap lines)
set showbreak=+++              "  Wrap-broken line prefix
set textwidth=79               "  Line wrap (number of cols)
set colorcolumn=+1             "  Highlight column beyond textwidth
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
set timeoutlen=1000
set ttimeoutlen=0              "  Fix ESC timeout
set wildmenu
set wildmode=longest:full,full "  Turn on wildment
set mouse=a                    "  Enable mouse support
set cursorline                 "  Highlight current line
set listchars=tab:▸\ ,eol:¬    "  Use special characters for whitespace
set fdm=syntax                 "  Set fold mode to syntax-based
set nofoldenable               "  Turn off folding by default

"" Leader commands
nmap <leader>l :set list!<CR>             " \l - show whitespaces
nmap <leader>s :SyntasticToggleMode<CR>   " \s - switch Syntastic on/off
nmap <leader>f :call FoldToggle()<CR>     " \f - toggle folds on/off
nmap <leader>v :e ~/.vimrc<CR>            " \v - edit vimrc
nmap <leader>r :source ~/.vimrc<CR>       " \r - reload vimrc
nmap <leader>bq :bp <BAR> bd #<CR>        " \bq - close current buffer
nmap <leader>bn :enew<CR>                 " \bn - new buffer

"" Functions
function! FoldToggle()
   if &foldcolumn
      setlocal foldcolumn=0
      setlocal nofoldenable
   else
      setlocal foldcolumn=4
      setlocal foldenable
   endif
endfunction

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
" Move between buffers using CTRL+movement
nmap <silent> <C-H> :bp<CR>
nmap <silent> <C-L> :bn<CR>
" Create splits with CTRL+W- and CTRL+W|
nmap <silent> <C-W>- :sp<CR>
nmap <silent> <C-W>\| :vsp<CR>
" Scroll with CTRL+J/CTRL+K
nmap <silent> <C-J> 3<C-E>
nmap <silent> <C-K> 3<C-Y>
" Save with CTRL+S
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it."
command! -nargs=0 -bar Update if &modified
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>
inoremap <c-s> <Esc>:Update<CR>
" use . to repeat command for visual selection
vnoremap . :normal .<CR>

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

" EasyAlign
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" vim-trailing-whitespace
Plug 'bronson/vim-trailing-whitespace'

" Supertab
Plug 'ervandew/supertab'

" TComment
Plug 'tomtom/tcomment_vim'

" Surround
Plug 'tpope/vim-surround'

" CTRLP
Plug 'ctrlpvim/ctrlp.vim'

if $MYSETUP_DEVEL == 1          " general development plugins
" fugitive
Plug 'tpope/vim-fugitive'

"ack
if executable('ack-grep')
   Plug 'mileszs/ack.vim'
endif

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
highlight Folded cterm=none ctermfg=11

" Set up airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Set up ctrlp
let g:gctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.(gt|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_working_path_mode = 'r'

" Use a leader instead of the actual named binding
nmap <leader>p :CtrlP<cr>

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>

