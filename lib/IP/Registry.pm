package IP::Registry;
use strict;
use Carp;
use Socket;
use Fcntl;

use vars qw ( $VERSION );
$VERSION = '211.002'; # NOV 2002, version 0.02
BEGIN { @AnyDBM_File::ISA = qw(NDBM_File GDBM_File SDBM_File DB_File) }
use AnyDBM_File;

my $singleton = undef;
my %mask = ( 
	     4 => pack("B32", '11111111111111111111111111110000'),
	     5 => pack("B32", '11111111111111111111111111100000'),
	     6 => pack("B32", '11111111111111111111111111000000'),
	     7 => pack("B32", '11111111111111111111111110000000'),
	     8 => pack("B32", '11111111111111111111111100000000'),
	     9 => pack("B32", '11111111111111111111111000000000'),
	     10 => pack("B32",'11111111111111111111110000000000'),
	     11 => pack("B32",'11111111111111111111100000000000'),
	     12 => pack("B32",'11111111111111111111000000000000'),
	     13 => pack("B32",'11111111111111111110000000000000'),
	     14 => pack("B32",'11111111111111111100000000000000'),
	     15 => pack("B32",'11111111111111111000000000000000'),
	     16 => pack("B32",'11111111111111110000000000000000'),
	     17 => pack("B32",'11111111111111100000000000000000'),
	     18 => pack("B32",'11111111111111000000000000000000'),
	     19 => pack("B32",'11111111111110000000000000000000'),
	     20 => pack("B32",'11111111111100000000000000000000'),
	     21 => pack("B32",'11111111111000000000000000000000'),
	     22 => pack("B32",'11111111110000000000000000000000'),
	     23 => pack("B32",'11111111100000000000000000000000'),
	     24 => pack("B32",'11111111000000000000000000000000')
	     );

my %packed_range = (
		    4 => pack("C",4),
		    5 => pack("C",5),
		    6 => pack("C",6),
		    7 => pack("C",7),
		    8 => pack("C",8),
		    9 => pack("C",9),
		    10=> pack("C",10),
		    11=> pack("C",11),
		    12=> pack("C",12),
		    13=> pack("C",13),
		    14=> pack("C",14),
		    15=> pack("C",15),
		    16=> pack("C",16),
		    17=> pack("C",17),
		    18=> pack("C",18),
		    19=> pack("C",19),
		    20=> pack("C",20),
		    21=> pack("C",21),
		    22=> pack("C",22),
		    23=> pack("C",23),
		    24=> pack("C",24)
		    );

sub new
{
    my $caller = shift;
    unless (defined $singleton){
        my $class = ref($caller) || $caller;
	(my $module_dir = $INC{'IP/Registry.pm'}) =~ s/\.pm$//;
	my %hash;
	tie (%hash,'AnyDBM_File',"$module_dir/data",O_RDONLY, 0666)
	    or die ("couldn't open registry database: $!");
	$singleton = bless \%hash, $class;
    }
    return $singleton;
}

sub inet_atocc
{
    my ($self,$inet_a) = @_;
    my $inet_n = inet_aton($inet_a)
	or return undef;
    return $self->inet_ntocc($inet_n);
}

sub inet_ntocc
{
    my ($self,$inet_n) = @_;
    croak('not a valid IP address as might be returned by Socket::inet_aton()')
	unless (length $inet_n == 4);
    for (my $range=24; $range>=4; $range--)
    {
	if (my $cc = $self->_get_cc($inet_n,$range)){
	    return $cc;
	}
    }
}

sub _get_cc ($$$)
{
    my ($self,$inet_n,$range) = @_;
    
    my $inet_n = $inet_n & $mask{$range};
    my %registry = %$self;
    return $registry{$inet_n.$packed_range{$range}};
}



1;
__END__

=head1 NAME

IP::Registry - lookup country codes by IP address

=head1 SYNOPSIS

  use IP::Registry;

=head1 DESCRIPTION

Finding the home country of a client using only the IP address can be difficult.
Looking up the domain name associated with that address can provide some help,
but many IP address are not reverse mapped to any useful domain, and the
most common domain (.com) offers no help when looking for country.

This module comes bundled with a database of countries where various IP addresses
have been assigned. Although the country of assignment will probably be the
country associated with a large ISP rather than the client herself, this is
probably good enough for most log analysis applications.

This module will probably be most useful when used after domain lookup has failed,
or when it has returned a non-useful TLD (.com, .net, etc.).

=head1 CONSTRUCTOR

The constructor takes no arguments.

  use IP::Registry;
  my $reg = IP::Registry->new();

=head1 OBJECT METHODS

All object methods are designed to be used in an object-oriented fashion.

  $result = $object->foo_method($bar,$baz);

Using the module in a procedural fashion (without the arrow syntax) won't work.

=over 4

=item $cc = $reg-E<gt>inet_atocc(HOSTNAME)

Takes a string giving the name of a host, and translates that to an
two-letter country code. Takes arguments of both the 'rtfm.mit.edu' 
type and '18.181.0.24'. If the host name cannot be resolved, returns undef. 
If the resolved IP address is not contained within the database, returns undef.
For multi-homed hosts (hosts with more than one address), the first 
address found is returned.

=item $cc = $reg-E<gt>inet_ntocc(IP_ADDRESS)

Takes a string (an opaque string as returned by Socket::inet_aton()) 
and translates it into a two-letter country code. If the IP address is 
not contained within the database, returns undef.

=back

=head1 COPYRIGHT

Copyright (C) 2002 Nigel Wetters. All Rights Reserved.

NO WARRANTY. This module is free software; you can redistribute 
it and/or modify it under the same terms as Perl itself.

Some parts of this software distribution are derived from the APNIC,
ARIN and RIPE databases (copyright details below). The author of
this module makes no claims of ownership on those parts.

=head1 APNIC conditions of use

The files are freely available for download and use on the condition 
that APNIC will not be held responsible for any loss or damage 
arising from the application of the information contained in these 
reports.

APNIC endeavours to the best of its ability to ensure the accuracy 
of these reports; however, APNIC makes no guarantee in this regard.

In particular, it should be noted that these reports seek to 
indicate the country where resources were first allocated or 
assigned. It is not intended that these reports be considered 
as an authoritative statement of the location in which any specific 
resource may currently be in use.

=head1 ARIN database copyright

Copyright (c) American Registry for Internet Numbers. All rights reserved.

=head1 RIPE database copyright

The information in the RIPE Database is available to the public 
for agreed Internet operation purposes, but is under copyright.
The copyright statement is:

"Except for agreed Internet operational purposes, no part of this 
publication may be reproduced, stored in a retrieval system, or transmitted, 
in any form or by any means, electronic, mechanical, recording, or 
otherwise, without prior permission of the RIPE NCC on behalf of the 
copyright holders. Any use of this material to target advertising 
or similar activities is explicitly forbidden and may be prosecuted. 
The RIPE NCC requests to be notified of any such activities or 
suspicions thereof."

=cut
