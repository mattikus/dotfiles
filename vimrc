set background=dark 
set ruler 
set mouse=a 
set showmatch
set backspace=indent,eol,start
set nowrap 
set t_md="" "turn of bold chars in terminal
set nohlsearch 
set incsearch 
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab 
set autoindent 
set smartindent 
set ignorecase
set smartcase
set wrapscan
set number
set title
set wildmenu
set wildmode=list:longest
set scrolloff=3
set shortmess=atTIs
set verbose=0

"set leaders
let mapleader=','
let maplocalleader=';'

"set xml.vim settings
let xml_use_xhtml=1

"Don't leave .swp files littered about
set backupdir=~/tmp,/var/tmp,/tmp
set directory=~/tmp,/var/tmp,/tmp

" No Help, please
nmap <F1> <Esc>

" NERDTree Options
map <leader>d :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeIgnore=['\.pyc$', '\~$', '.svn', '.git', '.hg', 'CVSROOT']

"Match more than just braces
runtime macros/matchit.vim

"stuff for vim 7
if version > 700
  "set autochdir
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
    "autocmd VimEnter * let &co+=(&nuw + 1)
    "autocmd VimLeave * let &co-=(&nuw + 1)
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

"turn on filetype matching
filetype plugin indent on
"pretty colors
syntax enable
"highlight characters past col 80
hi OverLength cterm=reverse
match OverLength "\%81v.*"
