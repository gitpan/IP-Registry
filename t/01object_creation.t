use Test::More tests => 2;
use strict;
use warnings;
use IP::Registry;

my $reg;
ok($reg = IP::Registry->new(),'object creates ok');
is($reg->inet_atocc('194.70.219.253'),'UK','well-known address works');
