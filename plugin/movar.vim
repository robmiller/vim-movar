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
	let [lnum, col] = searchpos("\\s\\|,\\|;\\|=\\|(\\|)")
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
	let [start_lnum, start_col] = searchpos("\\s\\|^\\|(", "b")
	" Now, we need to find the end of the variable.
	let [end_lnum, end_col] = searchpos("\\s\\|,\\|;\\|=\\|)\\|(")
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

augroup Movar
	autocmd! FileType php             onoremap <buffer> av :<c-u>call SelectDollarVar()<CR>
	autocmd! FileType ruby,javascript onoremap <buffer> av :<c-u>call SelectBareVar()<CR>
augroup END
