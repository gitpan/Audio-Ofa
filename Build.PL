use strict;
use warnings;
use Module::Build;

eval { require ExtUtils::PkgConfig; } or
   die "OS unsupported - no ExtUtils::PkgConfig\n";

eval { ExtUtils::PkgConfig->find('libofa'); } or
   die "libofa not found with pkg-config\n";

my $cflags   = ExtUtils::PkgConfig->cflags('libofa');
my $libflags = ExtUtils::PkgConfig->libs('libofa');

my $builder = Module::Build->new(
    create_readme               => 1,
    create_makefile_pl          => 'small',
    #create_makefile_pl          => 'traditional',
    module_name                 => 'Audio::Ofa',
    dist_author                 => 'Christoph Bussenius <pepe@cpan.org>',
    dist_abstract               => 'Bindings for libofa',
    dist_version_from           => 'lib/Audio/Ofa.pm',
    build_requires              => {
        'Module::Build' => 0, # important if we are run through the generated
                              # Makefile.PL
        'Test::More'    => 0,
        'Compress::Zlib' => 0,
        'ExtUtils::PkgConfig' => 0,
    },
    extra_compiler_flags        => [
                  '-Wall',
                  (map /\S+/g, grep defined, $ENV{EXTRACFLAGS}),
                  split ' ', $cflags,
    ],
    extra_linker_flags          => [
                  split ' ', $libflags,
    ],
    license => 'gpl',
);



$builder->create_build_script();
