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
	    bar => 'foos'
	}
    };

    package Bar;
    use Moose;

    has foos => (
	is => 'rw',
	isa => 'ArrayRef[Foo]',
	default => sub { [] },
	lazy => 1,
    );
}

ok my $bar = Bar->new, "Can create Bar";
ok my $foo = Foo->new, "Can create Foo";
ok $foo->bar( $bar ), "can set Foo::bar";
is $foo->bar, $bar, "result is correct";
is $bar->foos->[0], $foo, '$foo was added to $bar->foos';

ok $foo->bar( $bar ), "can set Foo::bar again";
is $bar->foos->[0], $foo, '$foo is still in $bar->foos';
is scalar @{ $bar->foos }, 1, '$foo was added only once';
done_testing;
