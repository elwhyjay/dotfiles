scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp949,default,latin1
set shell=/bin/bash
set diffopt+=iwhite,vertical
set pastetoggle=<F8>
set scrolloff=3
set switchbuf+=usetab,split
set startofline
set splitbelow
set nobackup
set nowritebackup
set nocompatible
set nofoldenable
set noshowmode
set noswapfile
set nowrap
set updatetime=300
set termguicolors
set mouse=
set title
set laststatus=2

" History
if has('persistent_undo')
  set undofile
  let &undodir = $HOME . '/.vim/undodir'
  silent! call mkdir(undodir, 'p')
endif

" Indentation
set cindent
set autoindent
set smartindent

" Tab
set tabstop=4
set softtabstop=2
set shiftwidth=2
set expandtab

" Searching
set incsearch
set ignorecase
set smartcase
set hlsearch | nohlsearch
set nowrapscan

" Line number column
set number
set cursorline
" 80th column color
set textwidth=80
set formatoptions-=t
set colorcolumn=+1,+2
" Listchars
set list
let &listchars = 'tab:› ,trail:-,extends:»,precedes:«,nbsp:.'
" Pair matching
set matchpairs+=<:>
set showmatch
" Wildmenu
set wildmode=longest,full

" Completion
set completeopt=preview,menuone,noinsert,noselect
set shortmess+=c
set signcolumn=yes

" Filetype
autocmd FileType kotlin setlocal colorcolumn=100


"
" Key mappings
"
let g:mapleader = ','

" Easy file save without switching IME
cabbrev ㅈ w
cabbrev ㅂ q
cabbrev ㅈㅂ wq

" Easy command-line mode
nnoremap ; :
" Easy home/end
inoremap <C-a> <ESC>I
inoremap <C-e> <End>
nnoremap <C-a> ^
nnoremap <C-e> $
vnoremap <C-a> ^
vnoremap <C-e> $
" Easy horizontal scrolling
noremap <esc>l 3zl
noremap <esc>h 3zh
noremap <a-l> 3zl
noremap <a-h> 3zh
" Easy delete key
vnoremap <backspace> "_d
" Easy file save
nnoremap <silent> <C-s>      :update<CR>
inoremap <silent> <C-s> <ESC>:update<CR>
vnoremap <silent> <C-s> <ESC>:update<CR>
" Easy indentation
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" Easy splitting & resizing
nnoremap <silent> <esc>- :split<CR>
nnoremap <silent> <esc>\ :vertical split<CR>
nnoremap <silent> <esc>h :vertical resize -5<CR>
nnoremap <silent> <esc>j :resize -3<CR>
nnoremap <silent> <esc>k :resize +3<CR>
nnoremap <silent> <esc>l :vertical resize +5<CR>
nnoremap <silent> <a--> :split<CR>
nnoremap <silent> <a-\> :vertical split<CR>
nnoremap <silent> <a-h> :vertical resize -5<CR>
nnoremap <silent> <a-j> :resize -3<CR>
nnoremap <silent> <a-k> :resize +3<CR>
nnoremap <silent> <a-l> :vertical resize +5<CR>
" Tab navigations
nnoremap <esc>t :tabnew<CR>
nnoremap <esc>T :-tabnew<CR>
nnoremap <esc>1 1gt
nnoremap <esc>2 2gt
nnoremap <esc>3 3gt
nnoremap <esc>4 4gt
nnoremap <esc>5 5gt
nnoremap <esc>6 6gt
nnoremap <esc>7 7gt
nnoremap <esc>8 8gt
nnoremap <esc>9 9gt
nnoremap <a-t> :tabnew<CR>
nnoremap <a-T> :-tabnew<CR>
nnoremap <a-1> 1gt
nnoremap <a-2> 2gt
nnoremap <a-3> 3gt
nnoremap <a-4> 4gt
nnoremap <a-5> 5gt
nnoremap <a-6> 6gt
nnoremap <a-7> 7gt
nnoremap <a-8> 8gt
nnoremap <a-9> 9gt
" Insert date
map <leader>D :execute 'normal! a' . system('date -u "+(%Y%m%d-%H%M%S)"')<CR>

" Easy newline insert
function! s:CustomEnter()
  if &modifiable
    normal! o
  else
    " Exception for quickfix buffer and other unmodifiable buffers.
    " See https://vi.stackexchange.com/a/3129
    execute 'normal! \<CR>'
  endif
endfunction
nnoremap <CR> :call <SID>CustomEnter()<CR>

" Easy drag select
function! s:DragSelectMode()
  if &signcolumn != 'no'
    " Enable DragSelectMode
    let s:previous_scl = &signcolumn
    set signcolumn=no
    set nonumber
    call nvim_buf_clear_namespace(0, -1, 0, -1)
    if s:use_coc
      call coc#config('git', {'addGBlameToVirtualText': 0})
    endif
  else
    " Disable DragSelectMode
    let &signcolumn = s:previous_scl
    set number
    if s:use_coc
      call coc#config('git', {'addGBlameToVirtualText': 1})
    endif
  endif
endfunction
nnoremap <F7> :call <SID>DragSelectMode()<CR>

" CP 설정
autocmd FileType c nnoremap <F5> :w<CR>:!gcc -O2 % -o %< -lm && ./%< < input.txt<CR>
autocmd FileType cpp nnoremap <F5> :w<CR>:!g++ -O2 -std=c++17 % -o %< && ./%< < input.txt<CR>


"
" coc.nvim node path (macOS)
"
if has('macunix')
  if filereadable('/opt/homebrew/bin/node')
    let g:coc_node_path = '/opt/homebrew/bin/node'
  elseif filereadable('/usr/local/bin/node')
    let g:coc_node_path = '/usr/local/bin/node'
  endif
endif


"
" List of plugins
"
let s:use_coc = has('nvim-0.3.2') && executable('yarn')
try
  call plug#begin('~/.config/nvim/plugged')

  " Configs
  Plug 'tpope/vim-sensible'

  " IDE
  if s:use_coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-stylelint', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-sources', {'do': 'yarn install --frozen-lockfile', 'rtp': 'packages/emoji'}
    if executable('clangd')
      Plug 'clangd/coc-clangd', {'do': 'yarn install --frozen-lockfile'}
    endif
    if executable('go')
      Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
    endif
    Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}
    Plug 'weirongxu/coc-kotlin', {'do': 'yarn install --frozen-lockfile'}
    Plug 'junegunn/fzf'
  endif

  " Neovim plugins
  if has('nvim-0.7')
    Plug 'github/copilot.vim'
    Plug 'folke/which-key.nvim'
    Plug 'NvChad/nvim-colorizer.lua'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  endif

  " File browsing
  Plug 'justinmk/vim-dirvish'
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'preservim/tagbar'

  " Visual
  Plug 'vim-airline/vim-airline'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'rebelot/kanagawa.nvim'

  " Syntax
  let g:polyglot_disabled = ['sensible', 'v'] | Plug 'sheerun/vim-polyglot'
  Plug 'wuelnerdotexe/vim-astro'

  " Language
  Plug 'mattn/emmet-vim'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

  " Format
  Plug 'sgur/vim-editorconfig'
  Plug 'Raimondi/delimitMate'

  " Cursor navigation
  Plug 'farmergreg/vim-lastplace'
  Plug 'rhysd/clever-f.vim'
  Plug 'haya14busa/is.vim'

  " Util
  Plug 'simnalamburt/vim-mundo'
  if has('mac')
    Plug 'simnalamburt/vim-tiny-ime', { 'do' : './build' }
  endif
  Plug 'godlygeek/tabular'

  " Fun
  Plug 'eandrju/cellular-automaton.nvim'

  call plug#end()


  "
  " Configs for plugins
  "
  if s:use_coc
    " coc.nvim
    let g:coc_disable_startup_warning = 1

    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " coc completion mappings
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    inoremap <silent><expr> <c-space> coc#refresh()

    " coc-highlight
    augroup vimrc_highlight
      autocmd!
      autocmd CursorHold * silent call <SID>highlight()
    augroup END
    function! s:highlight()
      if exists('*CocActionAsync')
        call CocActionAsync('highlight')
      endif
    endfunction

    " coc-prettier
    command! -nargs=0 Prettier :CocCommand prettier.formatFile

    " fzf lsp menu
    nnoremap <leader>f :call <SID>lsp_menu()<CR>
    function! s:lsp_menu()
      call fzf#run({
      \ 'source': [
      \   'rename',
      \   'jumpDefinition',
      \   'jumpDeclaration',
      \   'jumpImplementation',
      \   'jumpTypeDefinition',
      \   'jumpReferences',
      \   'diagnosticInfo',
      \   'diagnosticNext',
      \   'diagnosticPrevious',
      \   'format',
      \   'openLink',
      \   'doQuickfix',
      \   'doHover',
      \   'refactor',
      \ ],
      \ 'sink': function('CocActionAsync'),
      \ 'options': '+m',
      \ 'down': 10 })
    endfunction
  endif

  " Neovim plugins
  if has('nvim-0.7')
    try
      lua require('which-key').setup()
      lua require('colorizer').setup()
    catch /^Vim\%((\a\+)\)\=:E5108/
    endtry
  endif

  " nerdtree
  noremap <silent> <leader>n :NERDTreeToggle<CR>
  let g:NERDTreeIgnore = ['^node_modules$']
  let g:webdevicons_enable_nerdtree = 1
  function! s:nerdtree_startup()
    if exists('s:std_in') || argc() != 1 || !isdirectory(argv()[0])
      return
    endif
    execute 'NERDTree' argv()[0]
    wincmd p
    enew
    execute 'cd '.argv()[0]
    NERDTreeFocus
  endfunction
  augroup vimrc_nerdtree
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * call s:nerdtree_startup()
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END

  " tagbar
  nmap <F8> :TagbarToggle<CR>

  " vim-indent-guides
  nmap <leader>i <Plug>IndentGuidesToggle
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 0
  let g:indent_guides_guide_size = 1
  let g:indent_guides_start_level = 2
  let g:indent_guides_default_mapping = 0

  " vim-terraform
  let g:terraform_fmt_on_save=1

  " vim-astro
  let g:astro_typescript = 'enable'

  " clever-f.vim
  let g:clever_f_across_no_line = 1
  let g:clever_f_smart_case = 1

  " mundo.vim
  let g:mundo_right = 1
  nnoremap <leader>g :MundoToggle<CR>

  " cellular-automaton
  nnoremap <leader>r :CellularAutomaton make_it_rain<CR>

catch /^Vim\%((\a\+)\)\=:E117/
endtry


"
" Theme
"
try
  colorscheme kanagawa
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme elflord
endtry


"
" Augroup
"
augroup vimrc
  autocmd!
  " Vim automatic reload
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
  autocmd FileChangedShellPost *
    \ echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None
augroup END


"
" Local configs
"
if filereadable($HOME . '/.vimrc.local')
  source $HOME/.vimrc.local
endif
