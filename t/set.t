use strict;
use warnings;

use Test::More;
eval { require Set::Object; };
plan skip_all => 'Set::Object is not installed' if $@;

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
	isa => 'Set::Object',
	default => sub { Set::Object->new },
	lazy => 1,
    );
}

ok my $bar = Bar->new, "Can create Bar";
ok my $foo = Foo->new, "Can create Foo";
ok $foo->bar( $bar ), "can set Foo::bar";
is $foo->bar, $bar, "result is correct";
ok $bar->foos->contains( $foo ), '$foo was added to $bar->foos';

ok $foo->bar( $bar ), "can set Foo::bar again";
ok $bar->foos->contains( $foo ), '$foo is still in $bar->foos';
is $bar->foos->size, 1, '$foo was added only once';
done_testing;
