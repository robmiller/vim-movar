if exists('g:loaded_movar') || &cp
	finish
endif
let g:loaded_movar = 1

function! SelectDollarVar()
	" Move forward, then back to the $. This ensures we capture a) the
	" current variable, even if the cursor is on the $; and b) the whole
	" of the variable.
	normal! eF$
	" Now, find the end of the variable. We need to match both $foo and
	" $foo['bar'].
	let [lnum, col] = searchpos("\\s\\|,\\|;\\|=\\|(\\|)", "W", line("."))
	" One character back from the search result will be the end of the
	" variable.
	call cursor(lnum, col - 1)
	" That's it; select back to the $ to select the whole variable.
	normal! vF$
endfunction

" 'Bare' variables are ones that aren't prefixed, in languages like Ruby
" or Javascript.
function! SelectBareVar()
	" Move forward, in case we're at the first character of the
	" variable.
	normal! e
	" Now, we need to get back to the start of the variable. Unlike in
	" prefixed variables, as in PHP, we don't have any sigil-type
	" character to go on; so, we should look for the first character,
	" working backwards, that can't be part of a variable.
	let [start_lnum, start_col] = searchpos("\\s\\|^\\|(", "b", line("."))
	" Now, we need to find the end of the variable.
	let [end_lnum, end_col] = searchpos("\\s\\|,\\|;\\|=\\|)\\|(", "W", line("."))
	let length = end_col - start_col - 2
	" Move the cursor to the start of the variable...
	if start_col == 1
		call cursor(start_lnum, 1)
		let length = length + 1
	else
		call cursor(start_lnum, start_col + 1)
	endif
	" ...and now select through to the end.
	execute "normal! v" . length . "l"
endfunction

" For variables that have sigil characters — e.g. PHP's $, Ruby's @ and
" $ — this will change the name of the variable while leaving the sigil
" intact, for slightly less typing.
function! SelectInnerVar()
	" Move forward.
	normal! e
	" Search for the sigil at the start of the variable.
	let [sigil_lnum, sigil_col] = searchpos("\\$\\|@", "b", line("."))
	" And now, find the end of the variable.
	let [end_lnum, end_col] = searchpos("\\s\\|,\\|;\\|=\\|)\\|(", "W", line("."))
	let length = end_col - sigil_col - 2
	" Move to the first character after the sigil...
	call cursor(sigil_lnum, sigil_col + 1)
	" ...and then select through to the end.
	execute "normal! v" . length . "l"
endfunction

augroup Movar
	autocmd!
	autocmd FileType php             onoremap <buffer> av :<c-u>call SelectDollarVar()<CR>
	autocmd FileType php             vnoremap <buffer> av :<c-u>call SelectDollarVar()<CR>

	autocmd FileType javascript,ruby onoremap <buffer> av :<c-u>call SelectBareVar()<CR>
	autocmd FileType javascript,ruby vnoremap <buffer> av :<c-u>call SelectBareVar()<CR>

	autocmd FileType php,ruby        onoremap <buffer> iv :<c-u>call SelectInnerVar()<CR>
	autocmd FileType php,ruby        vnoremap <buffer> iv :<c-u>call SelectInnerVar()<CR>
augroup END
