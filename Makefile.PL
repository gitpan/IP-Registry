# A template for Makefile.PL used by Arena Networks.
# - Set the $PACKAGE variable to the name of your module.
# - Set $LAST_API_CHANGE to reflect the last version you changed the API 
#   of your module.
# - Fill in your dependencies in PREREQ_PM
# Alternatively, you can say the hell with this and use h2xs.
use ExtUtils::MakeMaker;
use strict;
use Fcntl;
use Socket;

BEGIN { @AnyDBM_File::ISA = qw(NDBM_File GDBM_File SDBM_File DB_File) }
use AnyDBM_File;

my $PACKAGE = 'IP::Registry';
(my $PACKAGE_FILE = $PACKAGE) =~ s|::|/|g;
my $LAST_API_CHANGE = 211.001;
my $CURR_VERSION;
eval "require $PACKAGE;\n\$CURR_VERSION = \$$PACKAGE"."::VERSION;";

unless ($@) { # Make sure we did find the module.
    if( $CURR_VERSION < $LAST_API_CHANGE ) {
        print "-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-\n".
	    "NOTE: There have been API changes between this version and any older\n".
	    "      than version $LAST_API_CHANGE! It seems that you have a copy\n".
	    "      of this software installed with a version number of $CURR_VERSION.\n".
	    "      Please read the CHANGES file if you have been building software\n".
	    "      that relies on a previous version of this software.\n".
	    "-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-\n";
        sleep 5;
    }
}

print "Building registry... this will take a moment...\n";

# cached packed IP ranges
my $log2 = log(2);
my %packed_size;

# this is our database
my %ip;
tie (%ip,'AnyDBM_File','lib/IP/Registry/data',O_RDWR|O_CREAT, 0666)
    or die ("couldn't create registry database: $!");

# and these are our raw files that will combine to form the database
my @reg_files = ('apnic-2002-11-01', 'arin.20021101', 'ripencc.20021101');
foreach my $reg (@reg_files){
    process_reg_file($reg);
}

untie %ip;

# if everything works, we can build our makefile
WriteMakefile(
	      NAME            => $PACKAGE,
	      VERSION_FROM    => "lib/$PACKAGE_FILE.pm", # finds $VERSION
	      PREREQ_PM       => {
		  'Test::More' => undef
	      },
	      AUTHOR          => 'Nigel Wetters <nwetters@cpan.org>'
	      );

sub process_reg_file
{
    my $reg = shift;
    open (REG, "< $reg") || die("can't open $reg: $!");
    while (my $line = <REG>){
	chomp $line;
	next unless $line =~ /^([^\|]+)\|(..)\|ipv4\|([^\|]+)\|(\d+)\|/;
	my ($auth,$cc,$ip,$size) = ($1,$2,$3,$4);
	next if ($auth eq 'iana'); # ipv6 and private IP ranges

	unless (exists $packed_size{$size}){
	    # this rounds weird network ranges down
	    # to the nearest power of 2 - which is necessary
	    # if we're going to have fast lookups for assignments
	    # such as 24.24.0.0, which has a range of 393216 IPs,
	    # [in this example, it is rounded down to a range of 
	    # 262144 (2**18), which means that one third of the
	    # IPs in this range will be missed.
	    # Sorry, such is life! IP to CC tanslation isn't exact anyway.
	    $packed_size{$size} = pack("C", int(log($size)/$log2));
	}
	my $packed_ip = inet_aton($ip);
	$ip{$packed_ip.$packed_size{$size}} = $cc;
    }
    close REG || warn("can't close $reg, but continuing: $!");
}
