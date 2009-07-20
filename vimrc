"set nocompatible 

filetype on 
filetype plugin on
filetype indent on

set background=dark 
set ruler 
set mouse=a 
set report=0 
set showmatch
set bs=indent,eol,start
set nowrap 
set t_md= 
set nohlsearch 
set incsearch 
set foldmethod=indent
set et
set softtabstop=2
set ts=2
set sw=2
set smarttab 
set smartindent 
set autoindent 
set ignorecase
set smartcase
set wrapscan
syn on
set nu
set cpo+=|
set title
set wildmenu
"set wildmode=list:longest
set scrolloff=3
set shortmess=atTIs
set verbose=0
set grepprg="ack"
set grepformat=%f:%l:%m
let mapleader=','

"Don't leave .swp files littered about
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" No Help, please
nmap <F1> <Esc>

map <leader>d :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeIgnore=['\.pyc$', '\~$', '.svn', '.git', '.hg', 'CVSROOT']

runtime macros/matchit.vim "Match more than just braces

"set tags+=~/.vim/tags/python.ctags
"set tags+=~/.vim/tags/systags

"stuff for vim 7
if version > 700
  set autochdir
  set completeopt=menuone,longest,preview
  set nuw=3
  set ve=onemore 
  if &t_Co > 16
    set cul 
  endif
  "remap ctrl-space to omnicomplete
  inoremap <Nul> <C-x><C-o>

  "close the help preview window if moving in or leaving insert mode
  autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
  autocmd InsertLeave * if pumvisible() == 0|pclose|endif 

  "Fix problems created by previous command in command window
  autocmd CmdWinEnter * set ei+=CursorMovedI,InsertLeave
  autocmd CmdWinLeave * set ei-=CursorMovedI,InsertLeave

  autocmd Filetype *
      \   if &omnifunc == "" |
      \           setlocal omnifunc=syntaxcomplete#Complete |
      \   endif

  "set omnicomplete to be default for supertab
  let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
  
  if $TERM != "linux" && $TERM != "screen" && ! has('gui_running')
    " Stretches the term window by the width of the number column width
    let old_col=&co
    autocmd VimEnter * let &co = (&co + &nuw + 1)
    autocmd VimLeave * let &co = old_col
  endif 
endif


setlocal indentkeys=!^F,o,O,<:>,0),0],0},=elif,=except,0#
set nofoldenable

if &t_Co > 16
  colorscheme zenburn
else
  colorscheme desert
endif

" ======================
" Clojure Stuffs
" ======================
let clj_highlight_builtins = 1
let clj_highlight_contrib = 1
let clj_paren_rainbow = 1
let clj_want_gorilla = 1
let vimclojure#NailgunClient = "/Users/mkemp/bin/ng"
" ======================

" ======================
" FuzzyFinder Stuffs
" ======================
"let g:FuzzyFinderOptions.Base.ignore_case = 1
let g:fuzzy_ignore='*.pyc, *.tmp'
let g:fuzzy_ceiling=20000
let g:fuzzy_matching_limit=100
let g:fuzzy_path_display='abbr'
nnoremap <silent> <leader>t :FuzzyFinderTextMate<CR>
nnoremap <silent> <leader>o  :FuzzyFinderTextMateRefreshFiles<CR>
" ======================
