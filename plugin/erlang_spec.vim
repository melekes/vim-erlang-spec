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

  let first_line = s:first_line_of_function()

  let last_line_above = s:last_line_of_function('b')
  norm! ''
  norm! m'

  if last_line_above > 0 && first_line < last_line_above " we are not inside the function
    return
  endif

  let above_and_current = reverse(s:search_clauses("bc", first_line))
  norm! ''
  norm! m'

  if above_and_current == []
    return
  endif

  let last_line = s:last_line_of_function('')
  norm! ''
  norm! m'

  let below = s:search_clauses("", last_line)
  norm! ''
  norm! m'

  let all = above_and_current + below
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
  let spec_prefix = '-spec '
  for line_number in a:clauses
    if i == 0
      let clause_head = matchstr(getline(line_number), "[^(]*([^)]*)")
      call add(spec, spec_prefix.clause_head.' -> any()')
    else
      let clause_head_without_fname = matchstr(getline(line_number), "([^)]*)")
      let empty_spec_plus_fname = repeat(' ', stridx(getline(line_number), '(') + 5) " 5 <= strlen(spec_prefix) - 1
      let s = ';'.empty_spec_plus_fname.clause_head_without_fname.' -> any()'
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

function! s:last_line_of_function(flags)"{{{
  let pattern = '\.\w\@!'

  let l = search(pattern, 'Wc'.a:flags)
  while l != 0 && s:synname() =~# 'erlangComment\|erlangString\|erlangSkippableAttributeDeclaration'
    let l = search(pattern, 'W'.a:flags)
  endwhile

  if l == 0 && a:flags == ''
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
