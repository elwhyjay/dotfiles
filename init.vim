call plug#begin($HOME . '/.config/nvim/plugged')
" Use release branch
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Or latest tag
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
" Or build from source code by use yarn: https://yarnpkg.com
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'

Plug 'preservim/nerdtree'

Plug 'mattn/emmet-vim'

Plug 'Raimondi/delimitMate'

Plug 'preservim/tagbar'

Plug 'nathanaelkane/vim-indent-guides'

Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'folke/which-key.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'https://github.com/preservim/tagbar'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'junegunn/fzf'
"for fun
Plug 'eandrju/cellular-automaton.nvim'

"lang
Plug 'weirongxu/coc-kotlin', {'do': 'yarn install --frozen-lockfile'}

call plug#end()

set tabstop=4 " Tab width
set shiftwidth=4 " auto indent width
set title
set smartindent
set hlsearch
set ignorecase
set smartindent
set incsearch
set bs=indent,eol,start
set nu
set autoindent
set scrolloff=2
set sts=4
set sw=4
set cindent
set laststatus=2
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\
set encoding=utf-8
set signcolumn=yes
set updatetime =300
set colorcolumn=80

let mapleader = " "
"kotlin
autocmd filetype kotlin setlocal colorcolumn=100


"nerdtree 단축키 설정
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>

nnoremap <C-r> :CellularAutomaton make_it_rain<CR>
nnoremap <C-l> :CellularAutomaton game_of_life<CR>

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
let g:NERDTreeIgnore = ['^node_modules$']

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>


"coc-Node path
"if executable('node')
""	let g:coc_node_path = '/opt/homebrew/bin/node'
"endif

if has('macunix')
  if filereadable('/opt/homebrew/bin/node')
    let g:coc_node_path = '/opt/homebrew/bin/node'
  elseif filereadable('/usr/local/bin/node')
    let g:coc_node_path = '/usr/local/bin/node'
  endif
endif


"Use K to show doc in preview window
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


"devicons for NERDTree
let g:webdevicons_enable_nerdtree = 1

map <leader>D :execute 'normal! a' . system('date -u "+(%Y%m%d-%H%M%S)"')<CR>

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" CP 설정
autocmd FileType c nnoremap <F5> :w<CR>:!gcc -O2 % -o %< -lm && ./%< < input.txt<CR>
autocmd FileType cpp nnoremap <F5> :w<CR>:!g++ -O2 -std=c++17 % -o %< && ./%< < input.txt<CR>


if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

if has("syntax")
	syntax on
endif

" gruvbox set
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='soft'
let g:seoul256_background = 233
colorscheme seoul256
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif


" 마지막으로 수정된 곳에 커서를 위치함
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif



