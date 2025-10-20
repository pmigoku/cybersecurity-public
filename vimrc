" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
"filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
"set number

" Highlight cursor line underneath the cursor horizontally.
"set cursorline

" Highlight cursor line underneath the cursor vertically.
" set cursorcolumn

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
"set nobackup

let s:vim_data_dir = expand('~/.vim')
let &backupdir = s:vim_data_dir . '/backup//'
let &directory = s:vim_data_dir . '/swap//'
let &undodir = s:vim_data_dir . '/undo//'

if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

set undofile " Enable persistent undo




" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set wrap
" set nowrap

set ignorecase     " Ignore case in searches
set smartcase      " Override ignorecase if search contains uppercase letters
set incsearch      " Incremental search
set hlsearch       " Highlight search results

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Folding: Use marker-based folding, map backslash to toggle fold
set foldmethod=marker
nnoremap \ za

" Timestamp: Insert current timestamp with F5 (Normal and Insert modes)
" CORRECTED: Removed leading ':' from mappings below
nnoremap <F5> "=strftime("%Y-%m-%d-%H:%M:%S")<CR>PA--<space>
inoremap <F5> <C-R>=strftime("%Y-%m-%d-%H:%M:%S")<CR>--<space>

" Highlighting: Custom rules for timestamps and comments
" Note: Timestamp rule currently matches only starting with 2024
syn match timestamp '^2025-.*.-- '
hi timestamp ctermfg=black ctermbg=yellow

syn match comment '^#.*'
hi comment ctermfg=green ctermbg=black


" Custon status line
set laststatus=2  " Always display the status line
set statusline=%f\ %y\ %l/%L\ %c\ %p%%\ %r
