use Test;
use strict;
use warnings;
use IP::Registry;
BEGIN { plan tests => 1 }

my $reg = IP::Registry->new();
my $iter = 65535;
my $found = 0;
my $t1 = time();;
for (my $i=1; $i<=$iter; $i++)
{
    my $ip = int(rand(256)).'.'.int(rand(256)).'.'.int(rand(256)).'.'.int(rand(256));
    if ($reg->inet_atocc($ip)){
        $found++;
    }
}
my $delta = (time() - $t1) || 1; # avoid zero division
ok(1);
print STDERR (" # random find (".int($found * 100/$iter)."%, ".int($iter/$delta)." lookups/sec)\n");

