" Use Vundle to load the plugins you want
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

if filereadable(expand('~/.vimrc.bundles.local'))
  source ~/.vimrc.bundles.local
endif

Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'mileszs/ack.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdcommenter'
if executable('ctags')
  Plugin 'majutsushi/tagbar'
endif
Plugin 'jpalardy/vim-slime'
if !exists('g:no_ycm')
  Plugin 'Valloric/YouCompleteMe'
else
  "Plugin 'Shougo/neocomplete.vim'
endif
Plugin 'elzr/vim-json'
"Plugin 'jnwhiteh/vim-golang'
"Plugin 'nsf/gocode',  {'rtp': 'vim/'}
Plugin 'spf13/vim-autoclose'
Plugin 'thinkpixellab/flatland', {'rtp': 'Vim/'}
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/vim-easymotion'
"Plugin 'Shougo/unite.vim'
Plugin 'fatih/vim-go'
Plugin 'sirver/ultisnips'
"Plugin 'honza/vim-snippets'
Plugin 'wavded/vim-stylus'
Plugin 'editorconfig/editorconfig-vim'

call vundle#end()
filetype plugin indent on

syntax enable

" Add a local leader which is also ,
let mapleader=","
let maplocalleader=","

" This is totally awesome - remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <esc>
inoremap kk <esc>

" Indentation
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Fast saving
nmap ;w :w!<cr>
imap ;w <esc>:w!<cr>

" set text width default
set textwidth=100

" stop highlighting after I searched
nmap <silent> // :nohlsearch<cr>

" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>

" Set filetype for troublesome types
augroup filetype
  "autocmd! " autocmd! clears previous group commands with same name rather than append
  autocmd BufRead,BufNewFile *.proto set ft=proto
augroup end

" Automatic formating on save
augroup go
  autocmd FileType go setlocal tabstop=2
augroup end

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

" Colors
set t_Co=256
"set background=dark
"colorscheme Monokai
set background=light
colorscheme summerfruit256

" no relative lines
set number
set norelativenumber

" no spell check
set nospell

" Go auto fmt with goimports - https://github.com/bradfitz/goimports "
let g:gofmt_command = "goimports"

" http://vimbits.com/bits/128
" automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc
au BufWritePost .vimrc.fork so ~/.vimrc.fork
au BufWritePost .vimrc.local so ~/.vimrc.local

" Go tags for tagbar https://github.com/jstemmer/gotags
"let g:tagbar_type_go = {
    "\ 'ctagstype' : 'go',
    "\ 'kinds'     : [
        "\ 'p:package',
        "\ 'i:imports:1',
        "\ 'c:constants',
        "\ 'v:variables',
        "\ 't:types',
        "\ 'n:interfaces',
        "\ 'w:fields',
        "\ 'e:embedded',
        "\ 'm:methods',
        "\ 'r:constructor',
        "\ 'f:functions'
    "\ ],
    "\ 'sro' : '.',
    "\ 'kind2scope' : {
        "\ 't' : 'ctype',
        "\ 'n' : 'ntype'
    "\ },
    "\ 'scope2kind' : {
        "\ 'ctype' : 't',
        "\ 'ntype' : 'n'
    "\ },
    "\ 'ctagsbin'  : 'gotags',
    "\ 'ctagsargs' : '-sort -silent'
"\ }

" easymotion configuration

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" easymotion configuration end

"if !exists('g:no_ycm')
  " youcompleteme
  let g:ycm_auto_trigger = 1
  let g:EclimCompletionMethod = 'omnifunc'
  "let g:ycm_autoclose_preview_window_after_insertion = 0
  "let g:ycm_autoclose_preview_window_after_completion = 0
"else
  "" neocomplete
  "" Disable AutoComplPop.
  "let g:acp_enableAtStartup = 0
  "" Use neocomplete.
  "let g:neocomplete#enable_at_startup = 1
  "" Use smartcase.
  "let g:neocomplete#enable_smart_case = 1
  "" <TAB> completion
  "inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
"endif

" Disable preview window for YCM and neocomplete
"set completeopt-=preview
"set g:ycm_add_preview_to_completeopt = 0

" Make help and completion descriptions in preview scratch splitbelow
set splitbelow

" Ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-l>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" End Ultisnips

" Syntastic
let g:syntastic_auto_loc_list=1
"let g:syntastic_disabled_filetypes=['html']
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers=['gjslint']
"let g:syntastic_html_tidy_ignore_errors=["proprietary attribute" ,"trimming empty <", "unescaped &" , "lacks \"action", "is not recognized!", "discarding unexpected"]
let g:syntastic_html_tidy_ignore_errors=["discarding unexpected", "is not recognized!", "proprietary attribute"]
" End Syntastic

" Airline
let g:airline_theme='light'
" End Airline

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

