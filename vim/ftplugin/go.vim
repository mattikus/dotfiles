setlocal noexpandtab
setlocal tabstop=2
setlocal shiftwidth=2
setlocal smartindent
setlocal formatprg=gofmt


augroup golang
  autocmd!
  if executable('gofmtwrapper') 
      autocmd BufRead,BufWrite *.go 
          \ execute 'normal mx' | 
          \ execute 'silent %!gofmtwrapper' | 
          \ execute 'normal `x' 
  endif 
augroup END
