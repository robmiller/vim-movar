# movar

movar is a movement for vim that makes working with variables easier.

It adds the movement `av` — "around variable" — which makes it easy to
yank, change, or delete variables in one fell swoop.

It covers a lot of use cases that previously would require several
different movements. For example, with the cursor anywhere in the
variable in the following examples, `cav` would always select the
variable and only the variable:

	if ( $_SERVER['REQUEST_URI'] === '/foo' ) {

(rather than `ciW`)

	if ( isset($_SERVER['REMOTE_ADDR']) ) {

(rather than `ci(`)

As well as some cases not easily covered by existing movements, like:

	$foo->bar("baz")

...where no single movement would allow you to select `$foo->bar` from
within the variable.

At the moment, movar supports PHP, Javascript, and Ruby, but it should
be relatively straightforward to add new rules for different languages
in the future.

