use Test;
use strict;
use warnings;
use IP::Registry;
BEGIN { plan tests => 1 }

ok(IP::Registry->new());
