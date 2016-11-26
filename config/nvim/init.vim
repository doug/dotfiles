" Ensure POSIX shell

if &shell =~# 'fish$'
  set shell=sh
endif

call plug#begin('~/.config/nvim/bundle')

if filereadable(expand('~/.vimrc.bundle.local'))
  source ~/.vimrc.bundle.local
else

  function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
      !./install.py
    endif
  endfunction

  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'tomtom/tcomment_vim'
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  Plug 'scrooloose/syntastic'
  Plug 'kien/ctrlp.vim'
  Plug 'bling/vim-airline'
  Plug 'sjl/gundo.vim'
  Plug 'Shougo/vimproc.vim', { 'do' : 'make' } | Plug 'quramy/tsuquyomi'
  Plug 'pangloss/vim-javascript'
	Plug 'leafgarland/typescript-vim'
	Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
  if executable('ctags')
    Plug 'majutsushi/tagbar'
  endif

endif

call plug#end()

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

" automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Typescript
let g:tsuquyomi_disable_quickfix = 1 " Use syntastic instead.

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_typescript_checkers = ['tsuquyomi'] " Instead of tsc.
" let g:syntastic_javascript_checkers = ['tern', 'closurecompiler', 'jscs','jshint']
" let g:syntastic_javascript_checkers = ['tern_lint', 'jscs', 'eslint']
let g:syntastic_javascript_checkers = ['tern_lint']
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_checkers = ['closurecompiler']
let g:syntastic_javascript_closurecompiler_script = '$HOME/.homebrew/bin/closure-compiler'

" '/Users/dougfritz//bin/google-closure-compiler'
" --compiler_flags="--language_in=ES6"'

" Ctrl+P
let g:ctrlp_custom_ignore = 'node_modules\|bower_components\|DS_Store\|git'

" Paste toggle
set pastetoggle=<leader>p

" Omni complete spliting
set splitbelow
set splitright

" Load local overides and extensions
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
