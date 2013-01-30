# movar

movar is a movement for vim that makes working with variables easier.

It adds the movement `av` — "around variable" — which makes it easy to
yank, change, or delete variables in one fell swoop.

In PHP, for example, you might have the following:

	if ( $_SERVER['REQUEST_URI'] === '/foo' ) {

If you want to change `$_SERVER['REQUEST_URI']` to something else — such
as a function call — that could be a bit tricky; `F$cf]`? It doesn't
exactly roll off the tongue.

But fret not! With movar, just call `cav` — "change around variable"
— and you'll achieve the same end.

At the moment, movar supports PHP and Ruby, but it should be relatively
straightforward to add new rules for different languages in the future.

