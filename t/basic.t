use strict;
use warnings;

use Test::More;

{
    package Foo;
    use Moose;

    has bar => (
	is => 'rw',
	isa => 'Bar',
    );

    with 'MooseX::SymmetricAttribute' => {
	attributes => {
	    bar => 'foo'
	}
    };

    package Bar;
    use Moose;

    has foo => (
	is => 'rw',
	isa => 'Foo',
    );
}

ok my $bar = Bar->new, "Can create Bar";
ok my $foo = Foo->new( bar => $bar ), "Can create Foo";
ok $foo->bar( $bar ), "can set Foo::bar";
is $foo->bar, $bar, "result is correct";
is $bar->foo, $foo, '$bar->foo is set';

done_testing;
