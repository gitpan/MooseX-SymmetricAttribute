
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'MooseX::SymmetricAttribute',
                       'DISTNAME' => 'MooseX-SymmetricAttribute',
                       'AUTHOR' => 'Gerhard Gossen',
                       'ABSTRACT' => 'Symmetric Moose Attributes -- automatically update inverse attribute',
                       'EXE_FILES' => [],
                       'VERSION' => '0.001',
                       'LICENSE' => 'perl',
                       'PREREQ_PM' => {
                                        'ExtUtils::MakeMaker' => '6.11',
                                        'MooseX::Role::Parameterized' => '0.16'
                                      }
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



