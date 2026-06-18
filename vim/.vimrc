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
" In plain Vim inside tmux, true color needs these explicit sequences or it
" silently falls back to a dull 256-color palette. Neovim handles this itself.
if !has('nvim')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Quality-of-life behavior
set hidden                  " Switch buffers without saving
set splitbelow splitright   " New splits open below and to the right
set mouse=a                 " Mouse support (resize splits, scroll)
set confirm                 " Prompt instead of erroring on unsaved :q
set updatetime=300          " Fire CursorHold quickly (default 4000ms)
set linebreak               " Wrap long lines at word boundaries, not mid-word
set wildmode=longest:full,full  " Better command-line completion behavior
set wildignorecase          " Case-insensitive file/command completion
if has('nvim')
  set inccommand=nosplit    " Live preview of :substitute as you type
endif


" -----------------------------------------------------------------------------
" 3. TABULATIONS & INDENTATION (The "Spaces > Tabs" Standard)
" -----------------------------------------------------------------------------
set tabstop=2               " A tab is 2 spaces wide
set shiftwidth=2            " Indents are 2 spaces wide
set expandtab               " Convert tabs to spaces (essential for Python/YAML)
set autoindent              " Copy indentation from previous line
" 'smartindent' dropped: 'filetype plugin indent on' provides better,
" language-aware indentation and avoids smartindent's quirks (e.g. forcing
" '#' comments to column 0).

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
set clipboard+=unnamedplus  " Sync Vim's clipboard with the system clipboard
" Create the directory if it doesn't exist
if !isdirectory($HOME . '/.vim/undo')
    call mkdir($HOME . '/.vim/undo', 'p', 0700)
endif
set undodir=~/.vim/undo  " Set the central undo directory
set undofile                " Persist undo history across sessions
set noswapfile              " Disable swap files (modern systems rarely need them)
vnoremap p "_dP             " Prevent replacing visual selection from overwriting the clipboard

" -----------------------------------------------------------------------------
" 6. PLUGINS (Requires vim-plug)
" -----------------------------------------------------------------------------
" Automatic installation of vim-plug if missing
let s:plug_path = '~/.vim/autoload/plug.vim'
if has('nvim')
  let s:plug_path = stdpath('data') . '/site/autoload/plug.vim'
endif
if empty(glob(s:plug_path))
  execute 'silent !curl -fLo ' . s:plug_path . ' --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" The Essentials
Plug 'tpope/vim-sensible'       " A universal set of defaults
Plug 'tpope/vim-commentary'     " Comment stuff out with 'gc'
Plug 'tpope/vim-surround'       " Manipulate quotes/brackets (e.g., 'cs"')
Plug 'jiangmiao/auto-pairs'     " Auto-insert closing ) } ] " '
Plug 'liuchengxu/vim-which-key' " Popup showing leader-key mappings

" Git (read-only goodies; works in git + colocated jj repos)
Plug 'tpope/vim-fugitive'       " :Git, :Git blame, :Gdiffsplit, history browsing
Plug 'airblade/vim-gitgutter'   " +/-/~ change signs in the sign column

" LSP (Neovim only — provides ready-made server configs for vim.lsp.enable())
if has('nvim')
  Plug 'neovim/nvim-lspconfig'
endif
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder binary
Plug 'junegunn/fzf.vim'         " Fuzzy finder mappings

" Visuals
Plug 'morhetz/gruvbox'          " Retro theme; pure vimscript, works in Vim + Neovim
Plug 'vim-airline/vim-airline'  " Lean status line

" Navigation & Knowledge Graph
Plug 'preservim/nerdtree'             " File tree sidebar (Vim + Neovim)
Plug 'lervag/wiki.vim'                " The 'articulate' linking engine

" Markdown Sovereignty
Plug 'preservim/vim-markdown'         " Folding and syntax
Plug 'godlygeek/tabular'              " Necessary for table alignment
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }


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

" which-key: press <leader> and pause to see available mappings
set timeoutlen=500          " How long which-key waits before popping up
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

" File tree (NERDTree): <leader>e toggles, <leader>E reveals current file
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>
let g:NERDTreeShowHidden = 1          " Show dotfiles (this is a dotfiles repo!)
let g:NERDTreeMinimalUI = 1           " Drop the '?' help hint banner
" Close Vim if NERDTree is the only window left
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Quick save
nnoremap <leader>w :w<CR>

" -----------------------------------------------------------------------------
" 8. WIKI CONFIG
" -----------------------------------------------------------------------------
let g:wiki_root = '~/notes'             " SET YOUR VAULT PATH HERE
let g:wiki_filetypes = ['md']
let g:wiki_link_extension = '.md'
let g:wiki_link_target_type = 'md'
let g:wiki_fzf_pages_opts = '--reverse'

let g:vim_markdown_folding_level = 2    " Sensible default folding
let g:vim_markdown_frontmatter = 1      " Support YAML metadata
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_edit_url_in_browser = 1
set foldlevelstart=99                 " Default to open everything

" Note Navigation
nnoremap <leader>wf :WikiPages<CR>
nnoremap <leader>wt :WikiTags<CR>

" Backlinks: This will list all files that link to your current note
nnoremap <leader>wb :WikiGraphRelated<CR>

" General Search (The standard fzf.vim commands)
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>

" -----------------------------------------------------------------------------
" GIT (fugitive + gitgutter)
" -----------------------------------------------------------------------------
" Read-only workflow: blame, history, diffs. Under jj, commit/stage with jj
" itself, not fugitive (jj ignores git's index, so staging here is lost).
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
nnoremap <leader>gl :Git log --oneline<CR>
" Gitgutter: ]c / [c jump between hunks (defaults); preview the current hunk
nnoremap <leader>hp :GitGutterPreviewHunk<CR>
" gitgutter relies on updatetime (already set to 300 above) for responsiveness

" -----------------------------------------------------------------------------
" LSP (native Neovim client; Neovim only, configured in Lua)
" -----------------------------------------------------------------------------
" Built-in keymaps (Neovim 0.11+): K hover, grn rename, gra code action,
" grr references, gri implementation, gO symbols, [d / ]d diagnostics,
" <C-S> signature help (insert mode). We add 'gd' for go-to-definition below.
if has('nvim')
lua << EOF
  -- Nicer completion menu behavior
  vim.o.completeopt = 'menu,menuone,noselect'

  -- Go: extend gopls with gofumpt formatting, staticcheck, and useful analyses
  -- (set before enable so it merges into nvim-lspconfig's default config)
  vim.lsp.config('gopls', {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        analyses = { unusedparams = true, unusedwrite = true, nilness = true },
      },
    },
  })

  -- Enable language servers (configs come from nvim-lspconfig). A server only
  -- attaches if its binary is on PATH; missing ones are silently skipped.
  vim.lsp.enable({
    -- Main languages
    'pyright',                -- Python types     (uv tool install pyright)
    'ruff',                   -- Python lint/fmt  (uv tool install ruff)
    'ts_ls',                  -- TS/JS            (npm i -g typescript typescript-language-server)
    'gopls',                  -- Go               (installed)
    -- Secondary
    'rust_analyzer',          -- Rust             (installed)
    'clangd',                 -- C/C++            (installed)
    -- Mobile
    'sourcekit',              -- Swift/iOS        (ships with the Xcode toolchain)
    'kotlin_language_server', -- Kotlin/Android   (brew install kotlin-language-server)
    -- This config
    'lua_ls',                 -- Lua              (brew install lua-language-server)
  })

  -- Show diagnostics inline as virtual text
  vim.diagnostic.config({ virtual_text = true })

  -- Per-buffer setup when a server attaches to it
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      -- Built-in autocompletion as you type
      vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
      -- gd = go-to-definition (the one common map Neovim doesn't bind by default)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
        { buffer = ev.buf, desc = 'LSP go-to-definition' })
    end,
  })

  -- Go: organize imports + format on save (the standard gofmt/goimports flow)
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
      -- Apply gopls' "organize imports" code action
      local params = vim.lsp.util.make_range_params(0, 'utf-16')
      params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
      local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 3000)
      for _, res in pairs(result or {}) do
        for _, action in pairs(res.result or {}) do
          if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit, 'utf-16')
          end
        end
      end
      -- Then format the buffer
      vim.lsp.buf.format({ async = false })
    end,
  })
EOF
endif

" Markdown Preview
nnoremap <leader>mp :MarkdownPreviewToggle<CR>

" Quick Wikilink Creation (Visual Mode: select text and press [[ )
vnoremap [[ s[[<C-r>"]][<Esc>

" --- AUTOCMDS ---
augroup FoamStyle
  autocmd!
  " Enable spellcheck for notes
  autocmd FileType markdown setlocal spell
  " Wrap text at 80 characters for readability
  autocmd FileType markdown setlocal textwidth=80
augroup END

" Go uses hard tabs (gofmt enforces it); override the global 2-space expandtab
augroup GoStyle
  autocmd!
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

" -----------------------------------------------------------------------------
" Restore cursor to its last position when reopening a file
" -----------------------------------------------------------------------------
augroup RestoreCursor
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
augroup END

" -----------------------------------------------------------------------------
" Auto-reload files changed on disk (e.g. by Claude Code in another tmux pane)
" -----------------------------------------------------------------------------
" 'autoread' is already set by vim-sensible; these make it actually fire in a
" terminal by polling on focus / buffer-enter / cursor-hold.
augroup AutoReloadDisk
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !=# 'c' && getcmdwintype() ==# '' | checktime | endif
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo 'File reloaded from disk' | echohl None
augroup END

" -----------------------------------------------------------------------------
" 9. LOCAL
" -----------------------------------------------------------------------------

" Load local overides and extensions
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

