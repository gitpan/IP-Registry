use Test::More tests => 1024;
use strict;
use warnings;
use IP::Registry;

my $reg = IP::Registry->new();
my $found = 0;
my $t1 = time();
for (my $i=1; $i<=1024; $i++)
{
    my $ip = int(rand(256)).'.'.int(rand(256)).'.'.int(rand(256)).'.'.int(rand(256));
    if ($reg->inet_atocc($ip)){
        $found++;
    }
    ok(1,"random ip lookup number $i of 1024");
}
my $t2 = time();
diag("random find (".int($found * 100 / 1024)."%, ".int(1024/($t2-$t1))." lookups/sec)");

