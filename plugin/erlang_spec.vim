" erlang_spec.vim - Generate specs for your Erlang functions
" Author:       Anton Kalyaev <http://homeonrails.com/about/>
" Version:      0.2
" License:      Same as Vim itself.  See :help license
" GetLatestVimScripts: XXXX 1 :AutoInstall: erlang_spec.vim

" if exists("g:loaded_erlang_spec") || &cp
"   finish
" endif
" let g:loaded_erlang_spec = 1

function! InsertSpec()"{{{
  norm! m'

  let stopline = FirstLineOfFunction()
  let above_and_current = reverse(SearchDeclarations("bc", stopline))

  norm! ''
  norm! m'

  let stopline = LastLineOfFunction()

  norm! ''
  norm! m'

  let below = SearchDeclarations("", stopline)

  let all = above_and_current + below
  if all == []
    return
  endif

  let spec = GenerateSpecFor(all)

  call cursor(all[0], 1)
  for s in reverse(spec)
    norm! O
    call setline(line('.'), s)
  endfor
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
  let pattern = '^[0-9A-Za-z_]\+('
  return search(pattern, a:flags, a:stopline)
endfunction"}}}

function! GenerateSpecFor(declarations)"{{{
  if len(a:declarations) > 1
    return MultiLineSpec(a:declarations)
  else
    return OneLineSpec(a:declarations[0])
  endif

endfunction"}}}

function! MultiLineSpec(declarations)"{{{
  let spec = []
  let i = 0
  for d in a:declarations
    let current_line = getline(d)
    if i == 0
      call add(spec, '-spec '.current_line.' any()')
    else
      let s = ';     '.current_line.' any()'
      if i == len(a:declarations)-1
        let s .= '.'
      endif
      call add(spec, s)
    endif
    let i += 1
  endfor
  return spec
endfunction"}}}

function! OneLineSpec(declaration)"{{{
  let current_line = getline(a:declaration)
  let s = '-spec '.current_line.' any().'
  return [s]
endfunction"}}}

function! FirstLineOfFunction()"{{{
  let l = search('\(\.\|\%^\)\_s*\(%.*\n\|\_s\)*\n*\_^\s*\zs[a-z][a-zA-Z_0-9]*(', 'Wbnc')
  if l == 0
    let l = 1
  endif
  return l
endfunction"}}}

function! LastLineOfFunction()"{{{
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

" nnoremap <silent> <Plug>Spec :<C-U>call <SID>insertspec()<CR>

" vim:set ft=vim sw=2 sts=2 et:
