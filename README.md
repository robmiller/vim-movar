# movar

movar is a Vim plugin that adds a couple of movements that make working
with variables easier.

## `av`: around variable

movar adds the movement `av` — "around variable" — which makes it easy
to yank, change, or delete variables in one fell swoop.

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

## `iv`: inner variable

For variables that have sigil characters — e.g. Ruby, which uses `@` for
instance variables and `$` for global variables — movar adds another
movement: `iv`, which matches the name of the variable but leaves the
sigil intact. So, if you have:

	@foo['bar']

…then calling `civ` from anywhere within the variable will change
`foo['bar']` and leave the `@` in place.

## Language support

At the moment, movar supports PHP, Javascript, and Ruby, but it should
be relatively straightforward to add new rules for different languages
in the future.

