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
  norm! m'

  let stopline = search('^$', 'Wbn')
  if stopline == 0
    let stopline = 1
  endif

  let above_and_current = reverse(SearchDeclarations("bc", stopline))

  norm! ''
  norm! m'

  let stopline = search('^$', 'Wn')
  if stopline == 0
    let stopline = line("$")
  endif

  let below = SearchDeclarations("", stopline)

  let all = above_and_current + below
  if all == []
    return
  endif

  let spec = GenerateSpecFor(all)

  call cursor(all[0], 1)
  norm! O
  call setline(line('.'), spec)
endfunction"}}}

function! SearchDeclarations(flags, stopline)"{{{
  let declarations = []

  let pos = SearchDeclaration(a:flags, a:stopline)

  while pos != 0
    " we must move cursor in order to declarations above
    if a:flags == ""
      call cursor(pos+1, 1)
    else
      call cursor(pos-1, 1)
    endif
    call add(declarations, pos)
    let pos = SearchDeclaration(a:flags, a:stopline)
  endwhile

  return declarations
endfunction"}}}

" Returns line number of the next function declaration above (including current
" line).
function! SearchDeclaration(flags, stopline)"{{{
  let pattern = '^\S\+('
  return search(pattern, a:flags, a:stopline)
endfunction"}}}

function! GenerateSpecFor(declarations)"{{{
  let spec = ""
  let i = 0
  for d in a:declarations
    let current_line = getline(d)
    " let function = strpart(current_line, 0, stridx(current_line, '('))
    if i == 0
      let spec .= '-spec '.current_line.' term().'
    else
      let spec .= current_line.' term().'
    endif
    let i += 1
  endfor
  return spec
endfunction"}}}

" nnoremap <silent> <Plug>Spec :<C-U>call <SID>insertspec()<CR>

" vim:set ft=vim sw=2 sts=2 et:
