"Set font based on which gui we're running
if has("gui_macvim")
    set gfn=Panic\ Sans:h12
    set antialias
else
    set gfn=Terminus\ 12
    set noantialias
endif
set cul
set nu
set lines=56
set guioptions-=r
set guioptions-=T
set guioptions-=m
set cmdheight=2

" Stretches the term window by the width of the number column width
let &co=(&co + &nuw)

colo twilight

"remap ctrl-space to omnicomplete
inoremap <C-space> <C-x><C-o>

"The following removes bold from all highlighting
"as this is usually rendered badly for me. Note this
"is not done in .vimrc because bold usually makes
"the colour brighter on terminals and most terminals
"allow one to keep the new colour while turning off
"the actual bolding.

" Steve Hall wrote this function for me on vim@vim.org
" See :help attr-list for possible attrs to pass
function! Highlight_remove_attr(attr)
    " save selection registers
    new
    silent! put

    " get current highlight configuration
    redir @x
    silent! highlight
    redir END
    " open temp buffer
    new
    " paste in
    silent! put x

    " convert to vim syntax (from Mkcolorscheme.vim,
    "   http://vim.sourceforge.net/scripts/script.php?script_id=85)
    " delete empty,"links" and "cleared" lines
    silent! g/^$\| links \| cleared/d
    " join any lines wrapped by the highlight command output
    silent! %s/\n \+/ /
    " remove the xxx's
    silent! %s/ xxx / /
    " add highlight commands
    silent! %s/^/highlight /
    " protect spaces in some font names
    silent! %s/font=\(.*\)/font='\1'/

    " substitute bold with "NONE"
    execute 'silent! %s/' . a:attr . '\([\w,]*\)/NONE\1/geI'
    " yank entire buffer
    normal ggVG
    " copy
    silent! normal "xy
    " run
    execute @x

    " remove temp buffer
    bwipeout!

    " restore selection registers
    silent! normal ggVGy
    bwipeout!
endfunction
autocmd BufNewFile,BufRead * call Highlight_remove_attr("bold")
autocmd BufNewFile,BufRead * call Highlight_remove_attr("italic")
" Note adding ,Syntax above messes up the syntax loading
" See :help syntax-loading for more info

