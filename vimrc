set nocompatible
syntax on
filetype plugin indent on

set termguicolors
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_contrast_light = "hard"
set background=dark
try | colorscheme gruvbox | catch | endtry

augroup RCGetGitBranch
    au!
    au VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

augroup RCPrettier
    au!
    au BufWritePost *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.svelte,*.yaml,*.html silent Prettier
augroup END

augroup RCBlack
    au!
    au BufWritePost *.py silent Black
augroup END

function StatuslineGitBranch()
    let b:gitbranch=""
    if &modifiable
        try
            let l:dir=expand('%:p:h')
            :silent let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
            if !v:shell_error
                let b:gitbranch="(".substitute(l:gitrevparse, '\n', '', 'g').") "
            endif
        catch
        endtry
    endif
endfunction

augroup RCResized
    au!
    au VimResized * wincmd=
    au FileType help wincmd=
augroup END

function Newtemp()
    let tempname = tempname()
    exec "e " . tempname
    exec "w!"
    call feedkeys(":setlocal filetype=")
endfunction

function GlobalQueryReplace()
    let replace_src = input('Replace: ')
    let replace_dst = input('With: ')
    exec 'args `grep -FRl -- ' .
                \ shellescape(replace_src) .
                \ ' ' .
                \ shellescape(expand('%:p:h')) .
                \ '`'
    exec 'argdo %sno/' . replace_src . '/' . replace_dst . '/gc'
    exec 'argdo update'
endfunction

function GlobalQuickfixGrep(search)
    exec 'cexpr system("' .
                \ 'grep -FRni -- ' .
                \ shellescape(a:search) .
                \ ' ' .
                \ shellescape(expand('%:p:h')) .
                \ '")'
endfunction

command! Replace call GlobalQueryReplace()
command! -nargs=1 Search call GlobalQuickfixGrep(<q-args>)
command! Temp call Newtemp()
command! CD cd %:p:h

let mapleader = "\<space>"

noremap <space> <nop>
noremap <c-s> <nop>
noremap <c-d> <nop>
noremap <c-u> <nop>
noremap <c-a> <nop>
noremap <c-x> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
noremap Q <nop>
inoremap <c-c> <esc>
vnoremap <c-c> <esc>
onoremap <c-c> <esc>

cnoremap <expr> %% getcmdtype( ) == ':' ? expand('%:p:h').'/' : '%%'

nmap <c-p> :e %%<c-d>
nnoremap - :Ex<cr>
nnoremap , :ls<cr>:b<space>
nnoremap <c-s> :w!<cr>
nnoremap Y y$
nmap k gk
nmap j gj

vmap < <gv
vmap > >gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap <c-k> :set paste<cr>m`O<esc>``:set nopaste<cr>
nnoremap <c-j> :set paste<cr>m`o<esc>``:set nopaste<cr>

nnoremap <leader>sv :so $MYVIMRC<cr>
nnoremap <leader>ev :e $MYVIMRC<cr>

cnoremap <c-b> <left>
cnoremap <c-f> <right>
cnoremap <c-n> <down>
cnoremap <c-p> <up>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <esc><c-?> <c-w>
cnoremap <esc><c-h> <c-w>
cnoremap <esc>f <c-right>
cnoremap <esc>b <c-left>

inoremap <c-b> <left>
inoremap <c-f> <right>
inoremap <c-n> <down>
inoremap <c-p> <up>
inoremap <c-a> <home>
inoremap <c-e> <end>
inoremap <esc><c-?> <c-w>
inoremap <esc><c-h> <c-w>
inoremap <esc>f <c-right>
inoremap <esc>b <c-left>

let g:netrw_banner = 0
let g:netrw_liststyle = 0
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

if has("unix")
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif

set encoding=utf-8
set fileencoding=utf-8

set laststatus=2 cmdheight=1
set noshowmode
let g:currentmode={
			\ 'n'  : 'NORMAL',
			\ 'no' : 'N·OPERATOR PENDING',
			\ 'v'  : 'VISUAL',
			\ 'V'  : 'V·LINE',
			\ '' : 'V·BLOCK',
			\ 's'  : 'SELECT',
			\ 'S'  : 'S·LINE',
			\ '' : 'S·BLOCK',
			\ 'i'  : 'INSERT',
			\ 'R'  : 'REPLACE',
			\ 'Rv' : 'V·REPLACE',
			\ 'c'  : 'COMMAND',
			\ 'cv' : 'VIM EX',
			\ 'ce' : 'EX',
			\ 'r'  : 'PROMPT',
			\ 'rm' : 'MORE',
			\ 'r?' : 'CONFIRM',
			\ '!'  : 'SHELL',
			\ 't'  : 'TERMINAL'}
set stl=
set stl+=\ [%t]                          " File path
set stl+=\ [%{g:currentmode[mode()]}] " Current mode
set stl+=\ %{exists('b:gitbranch')?b:gitbranch:''}                " Git branch name
set stl+=%m                              " Modified flag
set stl+=%r                              " Readonly flag
set stl+=%h                              " Help file flag
set stl+=%w                              " Preview window flag
set stl+=%y                              " File type
set stl+=\ (%l,%c)                       " Line/Column number
set stl+=%=                              " Left/Right separator
set stl+=[ |
set stl+=%{&ff}                          " File format
set stl+=:
set stl+=%{strlen(&fenc)?&fenc:'none'}   " File encoding
set stl+=]
set stl+=\ (%P)\                         " Percent through file

set expandtab autoindent shiftround tabstop=4 shiftwidth=4 softtabstop=4
set foldmethod=manual nofoldenable
set nobackup noswapfile nowritebackup
set nowrap sidescroll=1 sidescrolloff=5 scroll=3
set noerrorbells vb t_vb=
set ttyfast lazyredraw
set nofixendofline
set number ruler showcmd display=lastline
set ignorecase smartcase matchtime=2 incsearch wrapscan hlsearch
set hidden
set clipboard=unnamed
if has("unnamedplus")
    set clipboard+=unnamedplus
endif
set backspace=indent,eol,start
set autoread
set shortmess=aoOtTI
set mouse=a
set wildmode=longest,list
set title
set history=1000
