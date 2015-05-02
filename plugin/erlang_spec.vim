" erlang_spec.vim - Generate specs for your Erlang functions
" Author:       Anton Kalyaev <http://homeonrails.com/about/>
" Version:      0.2
" License:      Same as Vim itself.  See :help license
" GetLatestVimScripts: XXXX 1 :AutoInstall: erlang_spec.vim

if exists("g:loaded_erlang_spec") || &cp
  finish
endif
let g:loaded_erlang_spec = 1

function! s:insert_spec()"{{{
  norm! m'

  let stopline = s:first_line_of_function()
  let above_and_current = reverse(s:search_clauses("bc", stopline))

  norm! ''
  norm! m'

  let stopline = s:last_line_of_function()

  norm! ''
  norm! m'

  let below = s:search_clauses("", stopline)

  let all = above_and_current + below
  if all == []
    return
  endif

  let spec = s:generate_spec_for(all)

  call cursor(all[0], 1)
  for s in reverse(spec)
    norm! O
    call setline(line('.'), s)
  endfor

  call s:set_cursor_to_first_argument(getline('.'))
endfunction"}}}

" Returns line numbers for all clauses, which it will be able to find until
" the stopline.
function! s:search_clauses(flags, stopline)"{{{
  let declarations = []

  let pos = s:search_clause(a:flags, a:stopline)

  while pos != 0
    " we must move cursor in order to declarations above
    if a:flags == ""
      call cursor(pos+1, 1)
    else
      call cursor(pos-1, 1)
    endif
    call add(declarations, pos)
    let pos = s:search_clause(a:flags, a:stopline)
  endwhile

  return declarations
endfunction"}}}

function! s:search_clause(flags, stopline)"{{{
  let pattern = '^[0-9A-Za-z_]\+('
  return search(pattern, a:flags, a:stopline)
endfunction"}}}

function! s:generate_spec_for(clauses)"{{{
  if len(a:clauses) > 1
    return s:multi_line_spec(a:clauses)
  else
    return s:one_line_spec(a:clauses[0])
  endif
endfunction"}}}

function! s:multi_line_spec(clauses)"{{{
  let spec = []
  let i = 0
  for line_number in a:clauses
    let clause_head = matchstr(getline(line_number), ".*->")
    if i == 0
      call add(spec, '-spec '.clause_head.' any()')
    else
      let s = ';     '.clause_head.' any()'
      if i == len(a:clauses)-1
        let s .= '.'
      endif
      call add(spec, s)
    endif
    let i += 1
  endfor
  return spec
endfunction"}}}

function! s:one_line_spec(line_number)"{{{
  let clause_head = matchstr(getline(a:line_number), ".*->")
  let s = '-spec '.clause_head.' any().'
  return [s]
endfunction"}}}

function! s:first_line_of_function()"{{{
  let l = search('\(\.\|\%^\)\_s*\(%.*\n\|\_s\)*\n*\_^\s*\zs[a-z][a-zA-Z_0-9]*(', 'Wbnc')
  if l == 0
    let l = 1
  endif
  return l
endfunction"}}}

function! s:last_line_of_function()"{{{
  let pattern = '\.\w\@!'

  let l = search(pattern, 'Wc')
  while l != 0 && s:synname() =~# 'erlangComment\|erlangString\|erlangSkippableAttributeDeclaration'
    let l = search(pattern, 'W')
  endwhile

  if l == 0
    let l = line('$')
  endif

  return l
endfunction"}}}

function! s:synname()
  return join(map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")'), ' ')
endfunction

function! s:set_cursor_to_first_argument(line)"{{{
  let first_argument_ends_at = matchend(a:line, '^[^A-Z]\+[A-Z]\+\C')
  if first_argument_ends_at != -1
    call cursor(line('.'), first_argument_ends_at)
    norm! viw
  endif
endfunction"}}}

nnoremap <silent> <Plug>ErlangSpec :<C-U>call <SID>insert_spec()<CR>
if !exists(':ErlangSpec')
  command ErlangSpec silent call s:insert_spec()
endif

" vim:set ft=vim sw=2 sts=2 et:
