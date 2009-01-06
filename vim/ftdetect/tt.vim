" TinTin++ Filetypes, works with the syntax file.  Grab it at:
" http://www.vim.org/scripts/script.php?script_id=2135
augroup filetypedetect
  au! BufRead,BufNewFile *.tin     set filetype=tt
  au! BufRead,BufNewFile *.tt      set filetype=tt
augroup END

