"" Figure out environment
let os = substitute(system("uname -s"), '\n$', '', '')

"" Plugins ====================================================================

call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized' " Solarized color scheme
Plug 'vim-airline/vim-airline'          " Airline status line
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/vim-easy-align'          " Easy align
Plug 'bronson/vim-trailing-whitespace'  " vim-trailing-whitespace
Plug 'ervandew/supertab'                " Supertab
Plug 'tomtom/tcomment_vim'              " TComment
Plug 'tpope/vim-surround'               " Surround
Plug 'ctrlpvim/ctrlp.vim'               " CTRLP
Plug 'szw/vim-maximizer'                " maximizer
Plug 'christoomey/vim-tmux-navigator'   " vim-tmux-navigator

if $MYSETUP_DEVEL == 1                  " general development plugins
   Plug 'tpope/vim-fugitive'            " fugitive
   if executable('ag')                  " ag
      Plug 'rking/ag.vim'
   endif
   Plug 'airblade/vim-rooter'           " Rooter
   Plug 'scrooloose/syntastic'          " syntastic
   Plug 'scrooloose/nerdtree'           " NERDTree
   Plug 'AndrewRadev/linediff.vim'      " LineDiff
endif

if $MYSETUP_DEVEL_SW == 1               " software development-specific plugins
   Plug 'Rip-Rip/clang_complete'        " clang_complete
endif

if $MYSETUP_DEVEL_HW == 1               " hardware development-specific plugins
   Plug 'nachumk/systemverilog.vim'     " SystemVerilog
endif

call plug#end()                         " Add plugins to &runtimepath


"" General ====================================================================

set number                              " Show line numbers
set linebreak                           " Break lines at word (requires wrap)
set showbreak=+++                       " Wrap-broken line prefix
set textwidth=79                        " Line wrap (number of cols)
set colorcolumn=+1                      " Highlight column beyond textwidth
set showmatch                           " Highlight matching brace
set visualbell                          " Use visual bell (no beeping)

set hlsearch                            " Highlight all search results
set smartcase                           " Enable smart-case search
set ignorecase                          " Always case-insensitive
set incsearch                           " Searches for strings incrementally

set autoindent                          " Auto-indent new lines
set expandtab                           " Use spaces instead of tabs
set shiftwidth=3                        " Number of auto-indent spaces
set smartindent                         " Enable smart-indent
set smarttab                            " Enable smart-tabs
set softtabstop=3                       " Number of spaces per Tab


"" Advanced ===================================================================

set ruler                               " Show row and column ruler information
set laststatus=2                        " Always show status line$
set undolevels=1000                     " Number of undo levels
set backspace=indent,eol,start          " Backspace behaviour
set timeoutlen=1000
set ttimeoutlen=0                       " Fix ESC timeout
set wildmenu
set wildmode=longest:full,full          " Turn on wildment
set mouse=a                             " Enable mouse support
set ttymouse=xterm2
set cursorline                          " Highlight current line
set listchars=tab:▸\ ,eol:¬             " Use special characters for whitespace
set fdm=syntax                          " Set fold mode to syntax-based
set nofoldenable                        " Turn off folding by default
set tags=./tags;~/work                  " set tags search path


"" Leader commands ============================================================

" \l - show whitespaces
nmap <leader>l :set list!<CR>
" \s - switch Syntastic on/off
nmap <leader>s :SyntasticToggleMode<CR>
" \f - toggle folds on/off
nmap <leader>f :call FoldToggle()<CR>
" \v - edit vimrc
nmap <leader>v :e ~/.vimrc<CR>
" \r - reload vimrc
nmap <leader>r :source ~/.vimrc<CR>
" \q - close current buffer
nmap <leader>q :bp <BAR> bd #<CR>
" \c - new buffer
nmap <leader>c :enew<CR>
" \<space> - turn off search highlight
nmap <leader><SPACE> :nohlsearch<CR>
" \N - toggle line numbers
nmap <leader>N :set invnumber<CR>
" \p - toggle paste mode and line numbers
nmap <leader>p :call PasteToggle()<CR>

"" Keybindings ================================================================

" Move between vim and tmux windows using ALT+movement and cursor keys
let g:tmux_navigator_no_mappings = 1
if os == "Darwin"
   execute "set <M-h>=˙"
   execute "set <M-j>=∆"
   execute "set <M-k>=˚"
   execute "set <M-l>=¬"
else
   execute "set <M-h>=\eh"
   execute "set <M-j>=\ej"
   execute "set <M-k>=\ek"
   execute "set <M-l>=\el"
endif
nnoremap <silent> <M-j> :TmuxNavigateDown<CR>
nnoremap <silent> <M-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <M-l> :TmuxNavigateRight<CR>
nnoremap <silent> <M-k> :TmuxNavigateUp<CR>
nnoremap <silent> <M-CR> :TmuxNavigatePrevious<CR>
nnoremap <M-Down> :TmuxNavigateDown<CR>
nnoremap <M-Left> :TmuxNavigateLeft<CR>
nnoremap <M-Right> :TmuxNavigateRight<CR>
nnoremap <M-Up> :TmuxNavigateUp<CR>

" Unmap cursor keys (use hjkl)
map <Up> <NOP>
map <Down> <NOP>
map <Left> <NOP>
map <Right> <NOP>

" Move between buffers using CTRL+movement
nmap <silent> <C-H> :bp<CR>
nmap <silent> <C-L> :bn<CR>

" Create splits with CTRL+W- and CTRL+W|
nmap <silent> <C-W>- :sp<CR>
nmap <silent> <C-W>\| :vsp<CR>

" Scroll with CTRL+J/CTRL+K
nmap <silent> <C-J> 3<C-E>
nmap <silent> <C-K> 3<C-Y>

" Move in command line and insert mode with CTRL+HJKL
cnoremap <C-H> <Left>
cnoremap <C-J> <Down>
cnoremap <C-K> <Up>
cnoremap <C-L> <Right>
inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-L> <Right>

" Start NERDTree with CTRL+N
noremap <C-N> :NERDTreeToggle<CR>

" Get to command line with ;
noremap ; :
vnoremap ; :

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

" move cursor through visual lines
nnoremap j gj
nnoremap k gk

" jk is escape
inoremap jk <Esc>

" Maximize screens with CTRL-W z
nmap <C-W>z :MaximizerToggle<CR>
let g:maximizer_set_default_mapping = 0


"" Colorscheme / appearance ===================================================

" Set colorscheme
colorscheme solarized
highlight Folded cterm=none ctermfg=11
syntax enable
set background=dark
"let g:solarized_termcolors=256

" Set up airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'


"" Search and index plugins ===================================================

" Set up ctrlp
let g:gctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.(gt|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use the nearest .git directory as the cwd
let g:ctrlp_working_path_mode = 'r'

" Use ag as search command
if executable('ag')
   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>

" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


"" Syntax checkers ============================================================

" Configure Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" let g:syntastic_systemverilog_checkers = ['verilator']
let g:syntastic_filetype_map = { "systemverilog" : "verilog" }

" Configure Clang
let g:clang_user_options='|| exit 0'


"" Functions ==================================================================

" Toggle fold display
function! FoldToggle()
   if &foldcolumn
      setlocal foldcolumn=0
      setlocal nofoldenable
   else
      setlocal foldcolumn=4
      setlocal foldenable
   endif
endfunction

" Toggle paste mode and line numbers
function! PasteToggle()
   if &paste
      setlocal nopaste
      setlocal number
   else
      setlocal paste
      setlocal nonumber
   endif
endfunction


"" Source local settings ======================================================

if filereadable(expand('~/.localvimrc'))
   source ~/.localvimrc
endif

