" Ensure POSIX shell

if &shell =~# 'fish$'
  set shell=sh
endif

" Ale Config
" Must set ale config before load.
let g:ale_completion_enabled = 1
let g:ale_set_ballons = 1
" Error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
" Enable integration with airline.
let g:airline#extensions#ale#enabled = 1

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
  " Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
  " if executable('ctags')
  "   Plug 'majutsushi/tagbar'
  " endif

  " Navigation
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'bling/vim-airline'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'epeli/slimux'

  " Code Editing
  Plug 'tpope/vim-commentary'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'w0rp/ale'

  " Languages
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
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
set mouse=a
syntax enable
set t_Co=256
colorscheme peaksea

" Map leader and localleader
let mapleader=" "
let maplocalleader=" "

" Indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Column width 80 marker
set colorcolumn=80
set textwidth=80

" automatically remove trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Omni complete spliting
set splitbelow
set splitright

" Vimwiki for markdown
let g:vimwiki_list = [{'path': '~/wiki/', 'index': '_Sidebar', 'syntax': 'markdown', 'ext': '.md'}]
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

" Slimux
let g:slimux_select_from_current_window = 1

" Keybindings ================================================================

" Extra easy escape with jj or kk
inoremap jj <esc>
inoremap kk <esc>


" stop highlighting after I searched
nmap <silent> // :nohlsearch<cr>

" toggle paste mode
nmap <leader>pp :set paste!<cr>


" Nerdtree
map <C-e> :NERDTreeToggle<CR>

" Navigation without <c-w> (which closes tabs)
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Vimwiki
:autocmd FileType vimwiki map <leader>d :VimwikiMakeDiaryNote<CR>
:autocmd FileType vimwiki map <leader>c :call ToggleCalendar()<CR>

" FZF instead of ctrl-p
map <C-p> :Files<CR>

" Slimux
map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
map <Leader>a :SlimuxShellLast<CR>
map <Leader>k :SlimuxSendKeysLast<CR>

" Ale keybindings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <C-f> <Plug>(ale_fix)
nnoremap <buffer> <C-]> :ALEGoToDefinition<CR>
autocmd FileType python          nnoremap <buffer> <C-]> :call jedi#goto()<CR>



" Load local overides and extensions
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

