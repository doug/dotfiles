" Ensure POSIX shell

if &shell =~# 'fish$'
  set shell=sh
endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.config/nvim/bundle/neobundle.vim/
endif


call neobundle#begin(expand('~/.config/nvim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" Load local overides for bundles
if filereadable(expand('~/.vimrc.bundle.local'))
  source ~/.vimrc.bundle.local
else
  NeoBundle 'tpope/vim-sensible'
  NeoBundle 'tpope/vim-commentary'
  NeoBundle 'scrooloose/nerdtree'
  NeoBundle 'kien/ctrlp.vim'
  NeoBundle 'terryma/vim-multiple-cursors'
  NeoBundle 'scrooloose/syntastic'
  if executable('ctags')
    NeoBundle 'majutsushi/tagbar'
  endif
  NeoBundle 'elzr/vim-json'
  NeoBundle 'bling/vim-airline'
  NeoBundle 'fatih/vim-go'
  NeoBundle 'tikhomirov/vim-glsl'
  NeoBundle 'editorconfig/editorconfig-vim'
  NeoBundle 'mkarmona/colorsbox'
  NeoBundle 'Valloric/YouCompleteMe'
  " NeoBundle 'Valloric/YouCompleteMe', {
  " \ 'build': {
  "       \ 'mac': 'install.py --clang-completer --gocode-completer',
  "       \ 'linux': 'install.py --clang-completer --gocode-completer',
  "       \ 'unix': 'install.py --clang-completer --gocode-completer'
  " \ }
  " \ }
  NeoBundleLazy 'flowtype/vim-flow', {
        \ 'autoload': {'filetypes': 'javascript'},
        \ 'build': {
        \   'mac': 'npm install -g flow-bin',
        \   'unix': 'npm install -g flow-bin'
        \ }}
  " NeoBundle 'Shougo/vimproc.vim', {
  "       \ 'build' : {
  "       \     'windows' : 'tools\\update-dll-mingw',
  "       \     'cygwin' : 'make -f make_cygwin.mak',
  "       \     'mac' : 'make',
  "       \     'linux' : 'make',
  "       \     'unix' : 'gmake',
  "       \    },
  "       \ }
  " NeoBundle 'Quramy/tsuquyomi'
  NeoBundle 'clausreinke/typescript-tools.vim'
  NeoBundle 'leafgarland/typescript-vim'
  NeoBundle 'Chiel92/vim-autoformat'
  NeoBundle 'freitass/todo.txt-vim'
endif

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

" basic setup
set t_Co=256
" colorscheme colorsbox-material
set background=dark
set number

" Add a local leader which is also ,
let mapleader=" "
let maplocalleader=" "

" Extra easy escape with jj or kk
inoremap jj <esc>
inoremap kk <esc>

" Indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Column width 80 marker
set colorcolumn=80
set textwidth=80

" stop highlighting after I searched
nmap <silent> // :nohlsearch<cr>

" toggle paste mode
nmap <leader>pp :set paste!<cr>

" Nerdtree
map <C-e> :NERDTreeToggle<CR>

nnoremap <leader>u :GundoToggle<CR>

" Navigation without <c-w> (which closes tabs)
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" YCM YouCompleteMe configurations
if !exists("g:ycm_semantic_triggers")
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']

" " make YCM compatible with UltiSnips (using supertab)
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:SuperTabDefaultCompletionType = '<C-n>'

" " better key bindings for UltiSnipsExpandTrigger
" let g:UltiSnipsExpandTrigger = '<tab>'
" let g:UltiSnipsJumpForwardTrigger = '<tab>'
" let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

let g:synastic_javascript_checkers=['jscs']

" automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" flow config
let g:flow#autoclose=1
let g:flow#flowpath="/home/dougfritz/.nvm/versions/node/v5.0.0/bin/flow"
let g:flow#omnifunc=1

" Ctrl+P
let g:ctrlp_custom_ignore = 'node_modules\|bower_components\|DS_Store\|git'

" Autoformat
let g:formatter_js = ['jscs']
" au BufWrite * :Autoformat

" Todo Outline
autocmd BufRead,BufNewFile *.ol.txt set autoindent ts=4 sw=4 noexpandtab

" Load local overides and extensions
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
