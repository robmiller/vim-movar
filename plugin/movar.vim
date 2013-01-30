if exists('g:loaded_movar') || &cp
	finish
endif
let g:loaded_movar = 1

function! SelectPHPVar()
	" Move forward, then back to the $. This ensures we capture a) the
	" current variable, even if the cursor is on the $; and b) the whole
	" of the variable.
	execute "normal! eF$"
	" Now, find the end of the variable. We need to match both $foo and
	" $foo['bar'].
	let [lnum, col] = searchpos("\\s\\|,\\|;\\|=\\|)")
	" One character back from the search result will be the end of the
	" variable.
	call cursor(lnum, col - 1)
	" That's it; select back to the $ to select the whole variable.
	execute "normal! vF$"
endfunction

augroup Movar
	autocmd! FileType php onoremap <buffer> av :<c-u>call SelectPHPVar()<CR>
augroup END
