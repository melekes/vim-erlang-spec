" erlang_spec.vim - Generate specs for your Erlang functions
" Author:       Anton Kalyaev <http://homeonrails.com/about/>
" Version:      0.1
" GetLatestVimScripts: XXXX 1 :AutoInstall: erlang_spec.vim

if exists("g:loaded_erlang_spec") || &cp
  finish
endif
let g:loaded_erlang_spec = 1

function! s:insertspec()
  norm! O
  return s:beep()
endfunction

nnoremap <silent> <Plug>Spec :<C-U>call <SID>insertspec()<CR>

" vim:set ft=vim sw=2 sts=2 et:
