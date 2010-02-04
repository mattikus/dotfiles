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
set textwidth=78

"fix highlighting on some shell stuffs
let g:is_posix=1

"set leaders
let mapleader=','
let maplocalleader=','

" Shortcut to rapidly toggle `set list`
nmap <leader>L :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬,trail:·,nbsp:·

"set xml.vim settings
let xml_use_xhtml=1            

"Don't leave .swp files littered about
set backupdir=~/tmp,/var/tmp,/tmp   
set directory=~/tmp,/var/tmp,/tmp

" No Help, please
nmap <F1> <Esc>

map Q gq

" Fix :W to be :w
command! W :w


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

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  
endif


"turn off folds by default
set nofoldenable

if &t_Co > 16
  colorscheme zenburn
else
  colorscheme desert
endif

" ======================
" FuzzyFinder Stuffs
" ======================
"let g:FuzzyFinderOptions.Base.ignore_case = 1
let g:fuzzy_ignore='*.pyc, *.tmp'
let g:fuzzy_ceiling=10000
let g:fuzzy_matching_limit=100
let g:fuzzy_path_display='abbr'
nnoremap <silent> <leader>t :FuzzyFinderTextMate<CR>
nnoremap <silent> <leader>o :FuzzyFinderTextMateRefreshFiles<CR>
" ======================

"turn on filetype matching
filetype plugin indent on
"pretty colors
syntax enable

"highlight characters past col 80
"hi OverLength cterm=reverse
"match OverLength "\%81v.*"

"LaTeX stuffs
let g:tex_flavor="latex"

"==========
"VimClojure
"==========
"let g:vimclojure#NailgunClient = "/Users/matt/bin/ng"
let g:clj_want_gorilla = 1
""let g:clj_paren_rainbow = 1
let g:clj_highlight_contrib = 1

let g:ScreenImpl="Tmux"
