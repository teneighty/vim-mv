" mv.vim - Move or rename a buffer
" Maintainer:  Tim Horton <tmhorton@gmail.com>
" Version:     0.1

if exists("g:loaded_mv")
  finish
endif
let g:loaded_mv = 1

function! s:error(msg)
  echohl Error | echo a:msg | echohl None
endfunction

function! s:rename(name, bang)
  let oldfile = expand('%:p')
  exe 'saveas' . a:bang . ' ' . a:name
  if filereadable(oldfile) && (!filewritable(oldfile) || delete(oldfile) != 0)
      call s:error('Unable to delete ' . oldfile)
  endif
  if bufexists(oldfile) | exe 'bw '. bufnr(oldfile) | endif
endfunction

function! s:renameOrMove(name, bang)
  let n = a:name
  if isdirectory(n)
    let n = substitute(n . '/' . expand('%:t'), '//\+', '/', 'g')
  endif
  if filereadable(n) && empty(a:bang)
    call s:error('A file with that name already exists (use ! to override).')
  else
    call s:rename(n, a:bang)
  endif
endfunction

command! -bar -bang -nargs=1 -complete=file Mv :call <SID>renameOrMove(<q-args>, '<bang>')
