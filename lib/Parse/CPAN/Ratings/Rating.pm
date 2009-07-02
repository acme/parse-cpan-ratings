package Parse::CPAN::Ratings::Rating;
use Moose;
use MooseX::StrictConstructor;

has 'distribution' => ( is => 'ro', isa => 'Str' );
has 'rating'       => ( is => 'ro', isa => 'Num' );
has 'review_count' => ( is => 'ro', isa => 'Int' );

no Moose;

__PACKAGE__->meta->make_immutable;
