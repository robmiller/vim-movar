var foo = 'bar';
foo.bar = 'baz';
foo();
foo(foo);
foo(bar());
foo(foo.bar());
foo['bar'] = 'baz';
foo['bar'] = bar;
