package MooseX::SymmetricAttribute;
our $VERSION = '0.002';
# ABSTRACT: Symmetric Moose Attributes -- automatically update inverse attribute
use MooseX::Role::Parameterized;
use Scalar::Util 'blessed';
use List::Util 'first';

parameter 'attributes' => (
    is => 'ro',
    isa => 'HashRef[Str]',
    required => 1,
);

role {
    my $p = shift;

    foreach my $attribute ( keys %{ $p->attributes } ) {
	my $inverse_attribute = $p->attributes->{$attribute};
	after $attribute => sub {
	    my ($self, $other) = @_;
	    return unless defined $other;

	    if ( blessed ( $other ) && $other->can( $inverse_attribute ) ) {
		my $attribute = $other->meta->get_attribute( $inverse_attribute );
		my $constraint = $attribute->type_constraint;
		if ( $constraint->is_subtype_of( 'Set::Object' ) 
		    || $constraint->is_subtype_of( 'KiokuDB::Set' ) ) {
		    unless ( $attribute->get_value( $other )->contains( $self ) ) {
			$attribute->get_value( $other )->insert( $self );
		    }
		} elsif ( $constraint->is_subtype_of( 'ArrayRef' ) ) {
		    unless ( _contains( $attribute->get_value( $other ), $self ) ) {
			push @{ $attribute->get_value( $other ) }, $self;
		    }
		} else {
		    $attribute->set_value( $other, $self );
		}
	    }
	}
    }
};

sub _contains {
    my ( $ary_ref, $value ) = @_;
    return defined first { $_ == $value } @$ary_ref;
}

no Moose::Role;
1;



=pod

=head1 NAME

MooseX::SymmetricAttribute - Symmetric Moose Attributes -- automatically update inverse attribute

=head1 VERSION

version 0.002

=head1 Synopsis

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

    package main;
    my $bar = Bar->new;
    my $foo = Foo->new;

    $foo->bar( $bar );

    $bar->foo == $foo # true

=head1 Usage

Use this role to update both attributes in a symmetric relationship by setting
one value.

To use it, compose the role into your class like this:

 with 'MooseX::SymmetricAttribute' => {
     attributes => {
	 my_attribute_name_1 => foreign_attribute_name_1,
	 my_attribute_name_2 => foreign_attribute_name_2,
     }
 };

If the foreign attribute is an ArrayRef or a Set::Object, the new value will 
be appended.

=head1 Warning

This is alpha quality software. There may be some bugs lingering in here, 
probably some race conditions too. Patches and tests are very welcome!

=head1 AUTHOR

  Gerhard Gossen

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Gerhard Gossen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

