use ExtUtils::MakeMaker;
WriteMakefile(
	      NAME            => 'IP::Registry',
	      VERSION_FROM    => 'lib/IP/Registry.pm',
	      PREREQ_PM       => {
		  'IP::Country::Fast' => '211.008'
		  },
	      AUTHOR          => 'Nigel Wetters <nwetters@cpan.org>',
	      ABSTRACT_FROM   => 'lib/IP/Registry.pm'
	      );

