package Parse::CPAN::Ratings;
use Moose;
use MooseX::StrictConstructor;
use MooseX::Types::Path::Class;
use Parse::CPAN::Ratings::Rating;
use Parse::CSV;
our $VERSION = '0.33';

has 'filename' =>
    ( is => 'ro', isa => 'Path::Class::File', required => 1, coerce => 1 );

has 'db' => (
    is         => 'ro',
    isa        => 'HashRef[Parse::CPAN::Ratings::Rating]',
    lazy_build => 1,
);

no Moose;

__PACKAGE__->meta->make_immutable;

sub _build_db {
    my $self     = shift;
    my $filename = $self->filename;
    my %db;

    my $parser = Parse::CSV->new(
        file   => $filename->stringify,
        fields => 'auto',
    );
    while ( my $rating = $parser->fetch ) {
        $db{ $rating->{distribution} } = Parse::CPAN::Ratings::Rating->new(
            distribution => $rating->{distribution},
            rating       => $rating->{rating},
            review_count => $rating->{review_count},
        );
    }
    if ( $parser->errstr ) {
        confess( "Error parsing CSV: " . $parser->errstr );
    }
    return \%db;
}

sub rating {
    my ( $self, $distribution ) = @_;
    return $self->db->{$distribution};
}

sub ratings {
    my $self = shift;
    return values %{ $self->db };
}
