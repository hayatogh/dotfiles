set encoding=utf-8
set autoread
set backspace=indent
set belloff=backspace,cursor,error,showmatch,esc visualbell
set showbreak= breakindent breakindentopt=shift:2 cpoptions+=n
set ignorecase smartcase
set completeopt=menu,menuone,preview
set cursorline
set diffopt=filler,vertical,closeoff
set display=lastline
set fileencodings=ucs-bom,utf-8,default,euc-jp,cp932
set fileformats=unix,dos
set formatoptions+=mMj
set history=1000
set smartindent autoindent
set list listchars=tab:»-,extends:»,precedes:«,nbsp:◦
set showmatch matchtime=1 matchpairs+=「:」,（:）,『:』,【:】,［:］
set number relativenumber
set scrolloff=3 sidescroll=1 sidescrolloff=10
set shortmess=aoOtT
set splitbelow splitright
set laststatus=2
let g:CRLF = {'unix': 'LF', 'dos': 'CRLF', 'mac': 'CR'}
set statusline=[%f]%<%h%m%r[%{&fileencoding}%{&bomb?'(bomb)':''}][%{g:CRLF[&fileformat]}][%Y][0x%02.4B]%{&paste?'<paste>':''}%=%l,%c%V\ %P\ %LL
set noexpandtab shiftwidth=0 tabstop=8
set virtualedit=block
set wildmenu wildignorecase wildmode=list:longest,full
set wrap
let g:mapleader = ' '

map Y y$
nnoremap <silent> mm :<C-U>nohlsearch<CR>
nmap <Leader>o o<C-\><C-N>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>n :n<CR>
nnoremap <Leader>p :N<CR>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
