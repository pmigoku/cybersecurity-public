" ========== Core VIM settings ==============================================================================================================================

set nocompatible " Disable compatibility with vi which can cause unexpected issues.
filetype on " Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype indent on " Load an indent file for the detected file type.
syntax on " Turn syntax highlighting on.
"set cursorline " Highlight cursor line underneath the cursor horizontally.
"set cursorcolumn " Highlight cursor line underneath the cursor vertically.
set shiftwidth=4 " Set shift width to 4 spaces.
set tabstop=4 " Set tab width to 4 columns.
set expandtab " Use space characters instead of tabs.
set scrolloff=10 " Do not let cursor scroll below or above N number of lines when scrolling.
set laststatus=2  " Always display the status line
set statusline=%f\ %y\ %l/%L\ %c\ %p%%\ %r "shows file path, type, current line number, number of lines, column num, position in percentage, read only if RO
set history=1000 " Set the commands to save in history default number is 20.
set showcmd " Show partial command you type in the last line of the screen.

"====================== Backup Options ========================
" enable auto backups in ~/.vim and retain undo history after file close!

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


" ========== Search Options =========
set ignorecase     " Ignore case in searches
set smartcase      " Override ignorecase if search contains uppercase letters
set incsearch      " Incremental search
set hlsearch       " Highlight search results


" ========== Folding =========
" Folding: Use marker-based folding, map backslash to toggle fold
set foldmethod=marker
nnoremap \ za



" ========== Timestamps & Highlighting ===========================================

" Timestamp: Insert current timestamp with F5 (Normal and Insert modes)
nnoremap <F5> "=strftime("%Y-%m-%d-%H:%M:%S")<CR>PA--<space>
inoremap <F5> <C-R>=strftime("%Y-%m-%d-%H:%M:%S")<CR>--<space>

" Highlighting: Custom rules for timestamps and comments
" Note: Timestamp rule currently matches only starting with 2024
syn match timestamp '^2025-.*.-- '
hi timestamp ctermfg=black ctermbg=yellow

syn match comment '^#.*'
hi comment ctermfg=green ctermbg=black



