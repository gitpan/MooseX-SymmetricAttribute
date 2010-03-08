package MooseX::SymmetricAttribute;
our $VERSION = '0.001';
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
