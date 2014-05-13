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
endif
Plugin 'elzr/vim-json'
Plugin 'nsf/gocode',  {'rtp': 'vim/'}
Plugin 'Townk/vim-autoclose'

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

" Fast saving
nmap ;w :w!<cr>
imap ;w <esc>:w!<cr>

" set text width default
set textwidth=100

" Add emacs beginning and end of line
"map <c-a> ^
"map! <c-a> <c-o>^
"map <c-e> $
"map! <c-e> <c-o>$

" stop highlighting after I searched
nmap <silent> // :nohlsearch<cr>

" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>

" Set filetype for troublesome types
augroup filetype
  autocmd!
  autocmd BufRead,BufNewFile *.proto set ft=proto
  autocmd BufRead,BufNewFile *.go set ft=go
augroup end

" Automatic formating on save
augroup go
  autocmd!
  autocmd FileType go autocmd BufWritePre <buffer> Fmt
  autocmd FileType go setlocal noexpandtab
augroup end

" remove trailing whitespace and pesky ^M
augroup whitespace
  autocmd!
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
      set guifont=DejaVu\ Sans\ Mono\ 11,Andale\ Mono\ Regular\ 11,Consolas\ Regular\ 11,Courier\ New\ Regular\ 11
  elseif has("gui_mac")
      set guifont=Menlo\ Regular:h12,Andale\ Mono\ Regular:h12,Consolas\ Regular:h12,Courier\ New\ Regular:h12
  elseif has("gui_win32")
      set guifont=Menlo:h12,Andale_Mono:h12,Consolas:h12,Courier_New:h12
  endif
  if has("gui_macvim")
    set transparency=0
    set guifont=Menlo\ Regular:h12,Andale\ Mono\ Regular:h12,Consolas\ Regular:h12,Courier\ New\ Regular:h12
  endif
endif

" Nerdtree
map <C-e> :NERDTreeToggle<CR>

" Slime
let g:slime_target = "tmux"

" Colors
set t_Co=256
set background=dark
colorscheme Monokai

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
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

