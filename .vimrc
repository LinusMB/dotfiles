" ================================================== 
" Plugin Setup
" ================================================== 

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'fatih/vim-go'
Plug 'prettier/vim-prettier'
Plug 'psf/black'
Plug 'machakann/vim-highlightedyank'
Plug 'godlygeek/tabular'
Plug 'tikhomirov/vim-glsl'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" ================================================== 
" Settings
" ================================================== 

filetype plugin indent on
syntax on

if has('gui_running')
    color default
elseif &t_Co == 256
    hi clear
    set background=dark
    " General
    hi   Normal         ctermfg=252     ctermbg=16        cterm=none
    hi   Comment        ctermfg=246     ctermbg=none      cterm=none
    hi   Constant       ctermfg=182     ctermbg=none      cterm=none
    hi   Identifier     ctermfg=230     ctermbg=none      cterm=none
    hi   Statement      ctermfg=fg      ctermbg=none      cterm=bold
    hi   PreProc        ctermfg=none    ctermbg=none      cterm=none
    hi   Type           ctermfg=none    ctermbg=none      cterm=none
    hi   Special        ctermfg=none    ctermbg=none      cterm=none
    hi   Error          ctermfg=white   ctermbg=red       cterm=none
    hi   Todo           ctermfg=none    ctermbg=none      cterm=none

    " Selection
    hi   Cursor         ctermfg=none    ctermbg=none      cterm=none
    hi   CursorIM       ctermfg=none    ctermbg=none      cterm=none
    hi   CursorColumn   ctermfg=none    ctermbg=none      cterm=none
    hi   CursorLine     ctermfg=none    ctermbg=240       cterm=none
    hi   Visual         ctermfg=none    ctermbg=240       cterm=none
    hi   VisualNOS      ctermfg=none    ctermbg=none      cterm=none
    hi   IncSearch      ctermfg=none    ctermbg=240       cterm=none
    hi   Search         ctermfg=none    ctermbg=none      cterm=none
    hi   MatchParen     ctermfg=none    ctermbg=none      cterm=bold
    hi   Underlined     ctermfg=fg      ctermbg=none      cterm=underline

    " UI
    hi   LineNr         ctermfg=246     ctermbg=none      cterm=none
    hi   CursorLineNr   ctermfg=none    ctermbg=none      cterm=none
    hi   Pmenu          ctermfg=none    ctermbg=none      cterm=none
    hi   PmenuSel       ctermfg=none    ctermbg=none      cterm=none
    hi   PMenuSbar      ctermfg=none    ctermbg=none      cterm=none
    hi   PMenuThumb     ctermfg=none    ctermbg=none      cterm=none
    hi   StatusLine     ctermfg=bg      ctermbg=fg        cterm=bold
    hi   StatusLineNC   ctermfg=bg      ctermbg=fg        cterm=none
    hi   TabLine        ctermfg=none    ctermbg=none      cterm=none
    hi   TabLineFill    ctermfg=none    ctermbg=none      cterm=none
    hi   TabLineSel     ctermfg=none    ctermbg=none      cterm=none
    hi   VertSplit      ctermfg=bg      ctermbg=fg        cterm=none
    hi   Folded         ctermfg=none    ctermbg=none      cterm=none
    hi   FoldColumn     ctermfg=none    ctermbg=none      cterm=none

    hi   SpellBad       ctermfg=none    ctermbg=none      cterm=undercurl
    hi   SpellCap       ctermfg=none    ctermbg=none      cterm=undercurl
    hi   SpellRare      ctermfg=none    ctermbg=none      cterm=undercurl
    hi   SpellLocal     ctermfg=none    ctermbg=none      cterm=undercurl

    hi   DiffAdd        ctermfg=none    ctermbg=none      cterm=none
    hi   DiffChange     ctermfg=none    ctermbg=none      cterm=none
    hi   DiffDelete     ctermfg=none    ctermbg=none      cterm=none
    hi   DiffText       ctermfg=none    ctermbg=none      cterm=none

    hi   Directory      ctermfg=fg      ctermbg=bg        cterm=none
    hi   ErrorMsg       ctermfg=none    ctermbg=none      cterm=none
    hi   SignColumn     ctermfg=none    ctermbg=none      cterm=none
    hi   MoreMsg        ctermfg=none    ctermbg=none      cterm=none
    hi   ModeMsg        ctermfg=none    ctermbg=none      cterm=none
    hi   Question       ctermfg=none    ctermbg=none      cterm=none
    hi   WarningMsg     ctermfg=none    ctermbg=none      cterm=none
    hi   WildMenu       ctermfg=none    ctermbg=none      cterm=none
    hi   ColorColumn    ctermfg=none    ctermbg=none      cterm=none
    hi   Ignore         ctermfg=none
endif

set nocompatible

" tabstop: how many columns are used for displaying tabs
" shiftwidth: how many columns are used for one level of indentation  
" softtabstop: how many columns are inserted/deleted when pressing tab/backspace
" expandtab: when pressing tab insert tab or spaces?
" autoindent: keep indent on new line?
set ts=4 sw=4 et sts=4 ai

set listchars=                " Reset listchars
set listchars+=tab:▸\         " Symbols to use for invisible characters
set listchars+=trail:·        " trailing whitespace
set listchars+=nbsp:•         " non-breaking space
set listchars+=extends:→      " line continues beyond right of the screen
set listchars+=eol:↵
set listchars+=precedes:↶

" laststatus: will the last window have a status line
" statusline: content of statusline
" cmdheight: number of lines for command-line
set ls=2 ch=1

set nosmd
let g:currentmode={
            \ 'n'  : 'NORMAL',
            \ 'v'  : 'VISUAL',
            \ 'V'  : 'V·Line',
            \ '' : 'V·Block',
            \ 'i'  : 'INSERT',
            \ 'R'  : 'Replace',
            \ 'r'  : 'Replace',
            \ 'Rv' : 'V·Replace',
            \ 'c'  : 'Command',
            \ 't'  : 'Terminal',
            \ 's'  : 'Select',
            \ '!'  : 'Shell'
            \}

set stl=
set stl+=\ [%t]                          " File path
set stl+=\ [%{toupper(g:currentmode[mode()])}] " Current mode 
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

set nowrap ss=1 siso=5 scr=3
set smarttab
set ttimeout
set ttimeoutlen=100
set swf dir=/tmp
set shortmess=aoOtTI
set hidden
set nofoldenable
set autoread
set incsearch
set number
set foldcolumn=1
set report=0
set mouse=a
set cb=unnamed
if has("unnamedplus")
    set cb+=unnamedplus
endif

set wildmode=longest,list

let g:netrw_banner = 0
let g:netrw_liststyle = 0

let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

let g:highlightedyank_highlight_duration = 400

if has("unix")
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif

let g:c_syntax_for_h = 1

if 0
    let g:coc_global_extensions = ["coc-tabnine", "coc-clangd", "coc-go", "coc-pyright", "coc-tsserver"]

    call coc#config('suggest.noselect', 'true')
    call coc#config('inlayHint.enable', 'false')
    call coc#config('diagnostic.enable', 'false')

    inoremap <silent><expr> <TAB>
                \ coc#pum#visible() ? coc#pum#next(1) :
                \ CheckBackspace() ? "\<Tab>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-rename)

    nnoremap <silent> K :call ShowDocumentation()<CR>

    function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
        else
            call feedkeys('K', 'in')
        endif
    endfunction
endif


" ================================================== 
" Autocommands
" ================================================== 

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

if executable("clang-format")
    augroup RCClangFormat 
        au!
        au BufWritePost *.cpp,*.hpp,*.c,*.h silent !clang-format -i --style="{BasedOnStyle: GNU, IndentWidth: 4}" %
    augroup END
endif

augroup RCResized
    au!
    au VimResized * wincmd=
    au FileType help wincmd=
augroup END

augroup RCGo
    au!
    au BufNewFile,BufRead *.go call SetupGo()
augroup END

function SetupGo()
    setlocal makeprg=go\ build\ %
    nnoremap <buffer> <F7> :make<cr>
endfunction

" ================================================== 
" Commands
" ================================================== 

function! StatuslineGitBranch()
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

function RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'))
    if new_name != '' && new_name != old_name
        exec 'saveas ' . new_name
        exec 'silent !rm ' . old_name
        redraw!
    endif
endfunction

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

function EchoBuffers()
    " https://github.com/bling/vim-bufferline/blob/master/autoload/bufferline.vim
    let line = ''
    let i = 1
    let last_buffer = bufnr('$')
    let current_buffer = bufnr('%')
    while i <= last_buffer
        if bufexists(i) && buflisted(i)
            let fname = fnamemodify(bufname(i), ':t')
            let name = i . ':' . fname
            if getbufvar(i, '&mod')
                let name .= '+'
            endif
            if current_buffer == i
                let name = '[' . name . ']'
            else
                let name = ' ' . name . ' '
            endif
            let line .= name
        endif
        let i += 1
    endwhile
    echo line . "\n"
endfunction

command! Rename call RenameFile()
command! Replace call GlobalQueryReplace()
command! -nargs=1 Search call GlobalQuickfixGrep(<q-args>)
command! Temp call Newtemp()
command! Fmt normal! gg=G``
command! Make call feedkeys(":setlocal makeprg= | make<left><left><left><left><left><left><left>")

" ================================================== 
" Keybindings
" ================================================== 

let mapleader = "\<space>"

noremap <space> <nop>
noremap <c-s> <nop>
noremap <c-d> <nop>
noremap <c-u> <nop>
noremap <c-a> <nop>
noremap <c-x> <nop>
noremap ^ <nop>
noremap $ <nop>
noremap <Left> <nop>
noremap <Right> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
noremap Q <nop>

inoremap <c-c> <esc>
vnoremap <c-c> <esc>
onoremap <c-c> <esc>

nnoremap <c-s> :w!<cr>

nnoremap <leader>sv :so $MYVIMRC<cr>
nnoremap <leader>ev :e $MYVIMRC<cr>

nnoremap - :Ex<cr>
nnoremap <RightMouse> :Ex<cr>
nnoremap , :call EchoBuffers()<cr>:b<space>

nnoremap Y y$
nmap k gk
nmap j gj
noremap H ^
noremap L $
nnoremap <c-q> yyp

vmap < <gv
vmap > >gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap ]q :cnext<cr>
nnoremap [q :cprevious<cr>
nnoremap [b :bprevious<cr>
nnoremap ]b :bnext<cr>

cnoremap %% <c-r>=expand('%:p:h').'/'<cr>
cmap w!! w !sudo tee >/dev/null %
nmap <c-p> :e %%<c-d>
nnoremap <silent> <c-h> :bp<bar>sp<bar>bn<bar>bd<cr>
nnoremap <leader>c :call setreg('*', expand('%:p:h'))<cr>
nnoremap <leader>p :cexpr system("")<left><left>

nnoremap <c-k> :set paste<cr>m`O<esc>``:set nopaste<cr>
nnoremap <c-j> :set paste<cr>m`o<esc>``:set nopaste<cr>

nnoremap <c-d>% :%s///gc<left><left><left><left>
nnoremap <c-d>$ :.,$s///gc<left><left><left><left>
nnoremap <c-d>. :.s///gc<left><left><left><left>
vnoremap <c-d> :s///gc<left><left><left><left>

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
