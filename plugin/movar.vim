if exists('g:loaded_movar') || &cp
	finish
endif
let g:loaded_movar = 1

function! SelectPHPVar()
	" Move forward, then back to the $. This ensures we capture a) the
	" current variable, even if the cursor is on the $; and b) the whole
	" of the variable.
	normal! eF$
	" Now, find the end of the variable. We need to match both $foo and
	" $foo['bar'].
	let [lnum, col] = searchpos("\\s\\|,\\|;\\|=\\|)")
	" One character back from the search result will be the end of the
	" variable.
	call cursor(lnum, col - 1)
	" That's it; select back to the $ to select the whole variable.
	normal! vF$
endfunction

function! SelectRubyVar()
	" Move forward, in case we're at the first character of the
	" variable.
	normal! e
	" Now, we need to get back to the start of the variable. This is
	" slightly harder in Ruby, since variables come in the following
	" forms:
	"     * @foo, @foo['bar']
	"     * $foo, $foo['bar']
	"     * foo, foo['bar']
	" So, instead of moving to the $ as in PHP, we should move to the
	" first character we find moving backwards that can't be part of
	" a variable.
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
	autocmd! FileType php  onoremap <buffer> av :<c-u>call SelectPHPVar()<CR>
	autocmd! FileType ruby onoremap <buffer> av :<c-u>call SelectRubyVar()<CR>
augroup END
