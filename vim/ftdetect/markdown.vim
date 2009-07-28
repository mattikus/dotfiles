" Markdown Filetypes, works with the syntax file.  Grab it at:
" http://www.vim.org/scripts/script.php?script_id=1242
augroup filetypedetect
  au! BufRead,BufNewFile *.mkd           set filetype=markdown
  au! BufRead,BufNewFile *.md            set filetype=markdown
  au! BufRead,BufNewFile *.markdown      set filetype=markdown
augroup END

