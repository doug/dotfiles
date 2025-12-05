" -----------------------------------------------------------------------------
" 1. PREAMBLE: THE ESSENTIALS
" -----------------------------------------------------------------------------
set nocompatible            " Abandon Vi legacy support for modern Vim features
filetype plugin indent on   " Enable filetype detection and indentation
syntax on                   " Enable syntax highlighting

" -----------------------------------------------------------------------------
" 2. AESTHETICS & UI
" -----------------------------------------------------------------------------
set number                  " Show line numbers
set relativenumber          " Relative numbers for easier jumping (e.g., '10j')
set cursorline              " Highlight the current line for visual clarity
set scrolloff=8             " Keep 8 lines of context above/below cursor
set signcolumn=yes          " Always show sign column (prevents text shifting)
set termguicolors           " Enable 24-bit True Color
set background=dark         " Assume a dark background


" -----------------------------------------------------------------------------
" 3. TABULATIONS & INDENTATION (The "Spaces > Tabs" Standard)
" -----------------------------------------------------------------------------
set tabstop=2               " A tab is 4 spaces wide
set shiftwidth=2            " Indents are 4 spaces wide
set expandtab               " Convert tabs to spaces (essential for Python/YAML)
set autoindent              " Copy indentation from previous line
set smartindent             " Smarter indentation logic for C-like languages

" -----------------------------------------------------------------------------
" 4. SEARCH & NAVIGATION
" -----------------------------------------------------------------------------
set ignorecase              " Case insensitive search...
set smartcase               " ...unless you type a capital letter
set incsearch               " Show search matches as you type
set hlsearch                " Highlight all search matches
" Press <Esc> to clear search highlights
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>

" -----------------------------------------------------------------------------
" 5. SYSTEM INTEGRATION
" -----------------------------------------------------------------------------
set clipboard+=unnamed      " Sync Vim's clipboard with the system clipboard
" set clipboard+=unnamedplus      " Sync Vim's clipboard with the system clipboard
set undofile                " Persist undo history across sessions
set noswapfile              " Disable swap files (modern systems rarely need them)
vnoremap p "_dP             " Prevent replacing visual selection from overwriting the clipboard

" -----------------------------------------------------------------------------
" 6. PLUGINS (Requires vim-plug)
" -----------------------------------------------------------------------------
" Automatic installation of vim-plug if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" The Essentials
Plug 'tpope/vim-sensible'       " A universal set of defaults
Plug 'tpope/vim-commentary'     " Comment stuff out with 'gc'
Plug 'tpope/vim-surround'       " Manipulate quotes/brackets (e.g., 'cs"')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder binary
Plug 'junegunn/fzf.vim'         " Fuzzy finder mappings

" Visuals
Plug 'ellisonleao/gruvbox.nvim' " A high-quality retro theme (Neovim optimised)
Plug 'vim-airline/vim-airline'  " Lean status line

call plug#end()

" -----------------------------------------------------------------------------
" 7. CONFIGURATION
" -----------------------------------------------------------------------------
" Theme Setup
try
    colorscheme gruvbox
catch
    try 
        colorscheme retrobox
    catch
        colorscheme default     " Fallback if gruvbox isn't installed
    endtry
endtry

" Key Mappings
let mapleader = " "         " Spacebar is the best Leader key
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>w :w<CR>   " Quick save

" Load local overides and extensions
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

