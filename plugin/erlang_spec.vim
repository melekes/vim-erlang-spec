" erlang_spec.vim - Generate specs for your Erlang functions
" Author:       Anton Kalyaev <http://homeonrails.com/about/>
" Version:      0.1
" License:      Same as Vim itself.  See :help license
" GetLatestVimScripts: XXXX 1 :AutoInstall: erlang_spec.vim

" if exists("g:loaded_erlang_spec") || &cp
"   finish
" endif
" let g:loaded_erlang_spec = 1

function! InsertSpec()"{{{
  call GoToDeclaration()
  let spec = GenerateSpec()
  norm! O
  call setline(line('.'), spec)
endfunction"}}}

function! GoToDeclaration()"{{{
  norm! m'
  let pattern = '\(\.\|\%^\)\_s*\(%.*\n\|\_s\)*\n*\_^\s*\zs[a-z][a-zA-Z_0-9]*('
  let pos = search(pattern,'Wbc')
  echom pos
  if pos != 0
    let line = line('.')
    call cursor(line,1)
  endif
endfunction"}}}

function! GenerateSpec()"{{{
  let current_line = getline('.')
  " let function = strpart(current_line, 0, stridx(current_line, '('))
  return '-spec '.current_line.' term().'
endfunction"}}}

" nnoremap <silent> <Plug>Spec :<C-U>call <SID>insertspec()<CR>

" vim:set ft=vim sw=2 sts=2 et:
