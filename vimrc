" Ensure POSIX shell
if &shell =~# 'fish$'
    set shell=sh
endif

" Use Vundle to load the plugins you want
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

if filereadable(expand('~/.vimrc.bundles.local'))
  source ~/.vimrc.bundles.local
endif

Plugin 'tpope/vim-sensible'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-commentary'
if executable('ctags')
  Plugin 'majutsushi/tagbar'
endif
Plugin 'jpalardy/vim-slime'
if !exists('g:no_ycm')
  Plugin 'Valloric/YouCompleteMe'
endif
Plugin 'elzr/vim-json'
Plugin 'spf13/vim-autoclose'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'fatih/vim-go'
Plugin 'sirver/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'wavded/vim-stylus'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'tikhomirov/vim-glsl'
Plugin 'rking/ag.vim'
Plugin 'marijnh/tern_for_vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'mxw/vim-jsx'
Plugin 'ervandew/supertab'
Plugin 'terryma/vim-expand-region'
Plugin 'sjl/badwolf'
Plugin 'simnalamburt/vim-mundo'
Plugin 'flowtype/vim-flow'

call vundle#end()
filetype plugin indent on

syntax enable

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

" better undo tree
nnoremap <leader>u :GundoToggle<CR>

" remove trailing whitespace and pesky ^M
augroup cleanwhitespace
  autocmd BufWritePre * :%s/[ \t\r]\+$//e
augroup end

" copy text to system clipboard
if has("macunix")
  vmap <c-x> :!pbcopy<cr>
  vmap <c-c> :w !pbcopy<cr><cr>
else
  " copy and paste
  vmap <C-c> "+yi
  vmap <C-x> "+c
  vmap <C-v> c<ESC>"+p
  imap <C-v> <ESC>"+pa
endif

" Space will toggle folds!
nnoremap <space> za

if has("gui_running")
  " Font for gui
  if has("gui_gtk2")
      set guifont=Source\ Code\ Pro\ 11,DejaVu\ Sans\ Mono\ 11,Andale\ Mono\ Regular\ 11,Consolas\ Regular\ 11,Courier\ New\ Regular\ 11
  elseif has("gui_mac")
      set guifont=Source\ Code\ Pro:h12,Menlo:h12,Andale_Mono:h12,Consolas:h12,Courier_New:h12
  elseif has("gui_win32")
      set guifont=Source\ Code\ Pro:h12,Menlo:h12,Andale_Mono:h12,Consolas:h12,Courier_New:h12
  endif
  if has("gui_macvim")
    set transparency=0
    set guifont=Source\ Code\ Pro:h12,Menlo:h12,Andale_Mono:h12,Consolas:h12,Courier_New:h12
  endif
endif

" Nerdtree
map <C-e> :NERDTreeToggle<CR>

" Tagbar
map <C-t> :TagbarToggle<CR>

" Slime
let g:slime_target = "tmux"
let g:slime_python_ipython = 1

" Colors
set t_Co=256
set background=dark

" colorscheme Monokai
" colorscheme badwolf
" set background=light
" colorscheme summerfruit256

" no relative lines
set number
set norelativenumber

" no spell check
set nospell

" move by screen line for wrapped text
noremap j gj
noremap k gk

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

let g:synastic_javascript_checkers=['jscs']

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
