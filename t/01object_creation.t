use Test::More tests => 1;
use strict;
use warnings;
use IP::Registry;

my $reg;
ok($reg = IP::Registry->new(),'object creates ok');
