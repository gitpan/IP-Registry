package IP::Registry;
use strict;

use IP::Country::Fast;

use vars qw ( $VERSION @ISA );
$VERSION = '211.008'; # NOV 2002, version 0.08
push @ISA, 'IP::Country::Fast';

1;
__END__

=head1 NAME

IP::Registry - deprecated, use IP::Country::Fast

=cut
