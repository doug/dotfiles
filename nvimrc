" Ensure POSIX shell

if &shell =~# 'fish$'
    set shell=sh
endif

call plug#begin('~/.nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-commentary'
if executable('ctags')
  Plug 'majutsushi/tagbar'
endif
Plug 'jpalardy/vim-slime'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer'}
Plug 'elzr/vim-json'
Plug 'spf13/vim-autoclose'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Lokaltog/vim-easymotion'
Plug 'fatih/vim-go'
Plug 'editorconfig/editorconfig-vim'
Plug 'tikhomirov/vim-glsl'
Plug 'rking/ag.vim'
" Group dependencies, vim-snippets depends on ultisnips
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'sjl/badwolf'
Plug 'simnalamburt/vim-mundo'

call plug#end()

" basic setup
set t_Co=256
set background=dark
colorscheme badwolf
set number

" Add a local leader which is also ,
let mapleader=" "
let maplocalleader=" "

" Extra easy escape with jj or kk
inoremap jj <esc>
inoremap kk <esc>

" Indentation
set tabstop=2
set softtabstop=2
set expandtab

" Column width 80 marker
set colorcolumn=80
set textwidth=80

" stop highlighting after I searched
nmap <silent> // :nohlsearch<cr>

" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>

" Nerdtree
map <C-e> :NERDTreeToggle<CR>

nnoremap <leader>u :GundoToggle<CR>

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

let g:synastic_javascript_checkers=['jscs']

" Load local overides and extensions
if filereadable(expand('~/.nvimrc.local'))
  source ~/.nvimrc.local
endif
