
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'MooseX::SymmetricAttribute',
                       'DISTNAME' => 'MooseX-SymmetricAttribute',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Gerhard Gossen',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'Symmetric Moose Attributes -- automatically update inverse attribute',
                       'EXE_FILES' => [],
                       'VERSION' => '0.002',
                       'PREREQ_PM' => {
                                        'MooseX::Role::Parameterized' => '0.16'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



