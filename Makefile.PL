use ExtUtils::MakeMaker;
WriteMakefile(
	      NAME            => 'IP::Registry',
	      VERSION_FROM    => 'lib/IP/Registry.pm',
	      PREREQ_PM       => {
		  'IP::Country::Fast' => '212.005'
		  },
	      AUTHOR          => 'Nigel Wetters <nwetters@cpan.org>'
	      );

