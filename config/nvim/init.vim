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

  " Autocomplete
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  if executable('ctags')
    Plug 'majutsushi/tagbar'
  endif

  " Navigation
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  " Plug 'bling/vim-airline'
  Plug 'itchyny/lightline.vim'
  " Plug 'kien/ctrlp.vim'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'epeli/slimux'

  " Code Editing
  " Plug 'tomtom/tcomment_vim'
  Plug 'tpope/vim-commentary'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'w0rp/ale'
  Plug 'scrooloose/syntastic'

  " Languages
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  Plug 'Shougo/vimproc.vim', { 'do' : 'make' } | Plug 'quramy/tsuquyomi'
  Plug 'leafgarland/typescript-vim'

  " Organization
  Plug 'vimwiki/vimwiki'
  Plug 'itchyny/calendar.vim'

endif

" Color schemes
Plug 'vim-scripts/peaksea'

call plug#end()


" basic setup
set background=dark
set number
syntax enable
set t_Co=256
colorscheme peaksea

" Add a local leader which is also ,
let mapleader=" "
let maplocalleader=" "

" Extra easy escape with jj or kk
inoremap jj <esc>
inoremap kk <esc>

" Indentation
"
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
let g:ycm_semantic_triggers['python'] = ['.']

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
let g:syntastic_html_tidy_ignore_errors = [
      \ 'discarding unexpected',
      \ 'is not recognized!'
      \ ]
let g:syntastic_quiet_messages = { 'regex': ['google_type_annotations'] }
let g:syntastic_python_checkers = ['gpylint']

" '/Users/dougfritz//bin/google-closure-compiler'
" --compiler_flags="--language_in=ES6"'

" Ctrl+P
" let g:ctrlp_custom_ignore = 'node_modules\|bower_components\|DS_Store\|git'
" Use FZF instead of ctrl-p
map <C-p> :FZF<CR>

" Paste toggle
" set pastetoggle=<leader>p

" Omni complete spliting
set splitbelow
set splitright

" Vimwiki for markdown
let g:vimwiki_list = [{'path': '~/wiki/', 'index': '_Sidebar', 'syntax': 'markdown', 'ext': '.md'}]
:autocmd FileType vimwiki map <leader>d :VimwikiMakeDiaryNote<CR>
function! ToggleCalendar()
  execute ":Calendar"
  if exists("g:calendar_open")
    if g:calendar_open == 1
      execute "q"
      unlet g:calendar_open
    else
      g:calendar_open = 1
    end
  else
    let g:calendar_open = 1
  end
endfunction
:autocmd FileType vimwiki map <leader>c :call ToggleCalendar()<CR>

" Slimux
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
map <Leader>a :SlimuxShellLast<CR>
map <Leader>k :SlimuxSendKeysLast<CR>

let g:slimux_select_from_current_window = 1

" Ale
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Load local overides and extensions
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab
