package IP::Registry;
use IP::Country::Fast;
use vars qw ( $VERSION @ISA );
$VERSION = '9999.9999';
push @ISA, 'IP::Country::Fast';

BEGIN
{
    warn('IP::Registry has been deprecated, please use IP::Country::Fast');
}

1;
__END__

=head1 NAME

IP::Registry - deprecated, use IP::Country::Fast

=cut
