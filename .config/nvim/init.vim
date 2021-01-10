map <Space> <leader>
map <Space><Space> <leader><leader>
"nmap <leader>q :b#<bar>bd!#<CR>
map <leader>q :Kwbd<CR>
map <leader>w <C-w>q
map <leader>h :bprevious<CR>
map <leader>l :bnext<CR>
nnoremap <leader><leader> :nohlsearch<CR>

map <C-o> :NERDTreeToggle<CR>

imap jj <Esc>
nmap o o<Esc>
nmap O O<Esc>

nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>

nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" window / pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" terminal
tnoremap jj <C-\><C-n>
" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" options
set autoindent          " set auto indent
set autoread            " Don't bother me hen a file changes
set encoding=utf8       " UTF-8 by default
set expandtab           " use spaces, not tab characters
set fileformats=unix,dos,mac  " Prefer Unix"
set shiftwidth=2
set scrolloff=15        " minimum lines above/below cursor
"set cursorline
set hidden
set showmatch
set ignorecase
set smartcase
set incsearch
set nobackup
set nowritebackup       " No backups made while editing
set noswapfile
set path=$PWD/**
set hlsearch
set backspace=2
set laststatus=2
set linebreak           " Break long lines by word, not char
set matchtime=2         " Tenths of second to hilight matching paren
set softtabstop=2       " Spaces 'feel' like tabs
set tabstop=2           " set indent to 2 spaces
set notitle             " Don't set the title of the Vim window
set wildmenu            " Show possible completions on command line
set wildmode=list:longest,full " List all options and complete
set wildignore=*.class,*.o,*~,*.pyc,.git,node_modules " Ignore certain files in tab-completion

autocmd FileType rust setlocal shiftwidth=4 tabstop=4
autocmd FileType c setlocal shiftwidth=4 tabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4
autocmd FileType cpp setlocal shiftwidth=4 tabstop=4

" for [M|m]akefiles
autocmd FileType make setlocal shiftwidth=4 tabstop=4
autocmd FileType make setlocal noexpandtab

filetype plugin indent on

" Plugin options

command! Scratch vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile

" Lightline
set noshowmode
let g:lightline = {
\ 'colorscheme': 'nord',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly']]
\ },
\ 'component_expand': {
\ },
\ 'component_type': {
\   'readonly': 'error'
\ },
\ }

"let g:lightline.separator = {
"  \   'left': '', 'right': ''
"  \}
"let g:lightline.subseparator = {
"  \   'left': '', 'right': ''
"  \}

" GitGutter styling to use · instead of +/-
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'

let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '>'
let g:ale_sign_warning = '>'
let g:ale_linters = {
\   'python': ['flake8', 'pylint', 'bandit'],
\   'rust': ['cargo'],
\   'elixir': ['credo'],
\   'javascript': ['jshint'],
\   'text': [],
\   'json': ['jq'],
\   'yaml': ['prettier'],
\   'vue': ['prettier'],
\}
let g:ale_fixers = {
\   '*': ['trim_whitespace'],
\   'javascript': ['prettier'],
\   'json': ['prettier'],
\}

let g:closetag_filenames = "*.html,*.jsx"

"let g:netrw_banner=0

" colors
syntax on
colorscheme nord

set splitbelow
set splitright

" helps with slow/laggy vim
set ttyfast
set lazyredraw

" strips trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" terminal emulator
"set shell=/usr/local/bin/zsh


packloadall
silent! helptags ALL




"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
