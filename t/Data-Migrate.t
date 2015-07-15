#! /usr/bin/env perl
use 5.010;
use strict;
use warnings;


use Readonly;      # Declare constants
use Try::Tiny;     # Better than eval for error handling
use Test::More 'tests' => 1 + 3; # Main testing module, with test count

BEGIN {
   use_ok('Data::Migrate');
}

Readonly::Scalar my $CLASS => 'Data::Migrate';

subtest( 'Data-Migrate.t Helpers'                        => \&testHelpersT );
subtest( 'Data-Migrate.t Unit Tests (Normal Behavior)'   => \&testOkT );
subtest( 'Data-Migrate.t Unit tests (Excetion Handling)' => \&testBadT );

# Self-testing the helper functions in *this* test file.
# Done first as errors here hide other errors. There are no sub tests
# for these as they should be bog-simple functions. More complex helpers should
# be factored out into separate test utilities
sub testHelpersT {
   plan( tests => 2 );

   subtest( 'provideDefaultParamsHR()' => \&provideDefaultParamsHRT );
   subtest( 'provideDefaultObj()'      => \&provideDefaultObjT );
   return 1;
}

# Unit testing the normal (non-exceptional) behavior of the subs in the
# associated module.
sub testOkT {
   plan( tests => 2 );

   subtest( 'newOk()'       => \&newOkT );
   subtest( 'fieldNameOk()' => \&fieldNameOkT );
   return 1;
}

# Additional unit testing of subs in the associated module that can throw
# exceptions.
sub testBadT {
   plan( tests => 1 );

   subtest( 'newBad()' => \&newBadT );
   return 1;
}

#
# Self-testing.
#

sub provideDefaultParamsHRT {
   plan( tests => 7 );
   my $theHR = provideDefaultParamsHR();
   {
      ok( $theHR, 'Default parameter provided.' );
   }
   {
      my $want = 'HASH';
      my $got  = ref $theHR;
      is( $got, $want, 'Provided a hash reference' );
   }
   {
      my $want = 'HASH';
      my $got  = ref $theHR;
      is( $got, $want, 'Provided a hash reference' );
   }
   {
      # [FIXME] Assumes 'fieldName' is real parameter.
      ok( exists $theHR->{'fieldName'},
         'Provides real parameter "fieldName" as a key' );
   }
   {
      ok( exists $theHR->{'ignoreMe'},
         'Provides unused parameter "ignoreMe" as a key' );
   }
   {
      # [FIXME] Assumes 'fieldName' is real parameter.
      my $want = 'Some value';
      my $got  = $theHR->{'fieldName'};
      is( $got, $want, 'Value of key "fieldName" set correctly.' );
   }
   {
      # [FIXME] Assumes 'fieldName' is real parameter.
      my $want = { 'k1' => 'v1', 'k2' => 'v2' };
      my $got = $theHR->{'ignoreMe'};
      is_deeply( $got, $want, 'Value of key "ignoreMe" set correctly.' );
   }
   return 1;
}

sub provideDefaultObjT {
   plan( tests => 3 );

   my $defaultObj = provideDefaultObj();
   {
      ok( $defaultObj, "Create default testable $CLASS object" );
   }
   {
      ok( $defaultObj->isa($CLASS),
         "Default testable $CLASS object is correct class" );
   }
   {
      my $want = provideDefaultParamsHR();
      my %got  = %{$defaultObj};
      is_deeply( \%got, $want,
         "Default testable $CLASS object has expected content" );
   }
   return 1;
}

#
# Module unit tests for subroutines
#

sub newOkT {
   plan( tests => 2 );

   {
      my $defaultObj = $CLASS->new( { 'fieldName' => 10 } );
      ok( $defaultObj, 'Object constructor smoke test.' );
   }
   {
      my $paramHR    = provideDefaultParamsHR();
      my $defaultObj = $CLASS->new($paramHR);
      my $want       = provideDefaultParamsHR();    # new copy
      my $got        = $paramHR;                    # after pass
      is_deeply( $got, $want, 'No change to params by call' );
   }
   return 1;
}

sub newBadT {
   plan( tests => 4 );

   my $fieldNameMissingRE =
     qr/^Required option \'fieldName\' is not provided for Data::Migrate::new/;
   my $newCalledWrongRE =
     qr/^Data::Migrate::new was called incorrectly. It is a class method with one param./;

   my $noErrorError = 'This should fail.';
   {
      try {
         Data::Migrate::new( provideDefaultParamsHR() );
         fail($noErrorError);
      }
      catch {
         my $got  = $_;
         my $want = $newCalledWrongRE;
         like( $got, $want, 'Error if not called as object' );
      };
   }
   {
      try {
         $CLASS->new();
         fail($noErrorError);
      }
      catch {
         my $got  = $_;
         my $want = $newCalledWrongRE;
         like( $got, $want, 'Error with no param' );
      };
   }
   {
      try {
         $CLASS->new( {} );
         fail($noErrorError);
      }
      catch {
         my $got  = $_;
         my $want = $fieldNameMissingRE;
         like( $got, $want, 'Error with empty param' );
      };
   }
   {
      try {
         $CLASS->new( { ignoredMe => { 'k1' => 'v1', 'k2' => 'v2', }, } );
         fail($noErrorError);
      }
      catch {
         my $got  = $_;
         my $want = $fieldNameMissingRE;
         like( $got, $want, 'Error with missing "fieldName" param' );
      };
   }
   return 1;
}

sub fieldNameOkT {
   plan( tests => 4 );
   {
      my $defaultObj = provideDefaultObj();
      my $want       = provideDefaultParamsHR()->{'fieldName'};
      my $got        = $defaultObj->fieldName();
      is( $got, $want, 'fieldName as getter returns the correct value.' );
   }
   {
      my $defaultObj = provideDefaultObj();
      my $want       = provideDefaultParamsHR()->{'fieldName'};
      my $got        = $defaultObj->fieldName('A New Value');
      is( $got, $want, 'fieldName as setter returns the correct value.' );
   }
   {
      my $defaultObj = provideDefaultObj();
      my $newValue   = 'A New Value';
      $defaultObj->fieldName($newValue);
      my $want = $newValue;
      my $got  = $defaultObj->fieldName();
      is( $got, $want, 'fieldName as setter sets a new value.' );
   }
   {
      my $defaultObj = provideDefaultObj();
      my $newValue   = 'A New Value';
      $defaultObj->fieldName($newValue);
      my $want = 'A New Value';    # New copy of param
      my $got  = $newValue;        # Param after call
      is( $got, $want, 'fieldName as setter does not change parameter' );
   }
   return 1;
}

#
# Data providers
#

# [FIXME] Assumes 'fieldName' is real parameter.
sub provideDefaultParamsHR {
   my $ignoredParamHR = {
      'k1' => 'v1',
      'k2' => 'v2',
   };
   my $initParamHR = {
      'fieldName' => 'Some value',
      'ignoreMe'  => $ignoredParamHR,
   };
   return $initParamHR;
}

sub provideDefaultObj {
   my $defaultObj = $CLASS->new( provideDefaultParamsHR() );
   return $defaultObj;
}

__END__

=head1 NAME

t/Data-Migrate.t - Unit tests for Data::Migrate

=head1 PURPOSE

=head2 What code?

Test the subroutines in the main module.

=head2 When?

At test time. This contains the core unit tests for subroutines in
the main distriburion.

=head2 Purpose?

Unit test all subroutines in the main module.

=head2 Why?

Unit tests are organized with one test file matching each code file
in the main distribuion.

=cut

=head1 DEVELOPMENT & CONTRIBUTION

This module is developed and hosted on GitHub, at
L<https://github.com/Jefferys/Data-Migrate>. Development
is done using Dist Zilla, but releases to github are made to both a master and
a release branch, with the master branch building using dzil, while the release
branch uses only the Core perl build system (ExtUtil::MakeMaker).

=cut

=head2 Conventions

=cut

=head3 Testing

=over 4

=item filenames

I name all test files ".t". Test files run by users at installation are put in
the t/ directory of the distibution. Test files to be run only by
authors or developers go in the xt/ directory of the distribution in the
development repository. These are not needed by users and are *not* copied into
the distro.

This is a more rigorous separation of concerns than is usually maintianed with
perl distributions. With the prevelance of github and similar source
repositories taking up the load of supporting scm histories, it no longer makes
sense for cpan to be used as a "development repository without history". It
still has a critical role as a centralized module source, and still needs
extensive meta-data provided to describe a distro and where to find the
development repository. The presence of xt ditectories in install tarballs is
an un-needed historic artifact. It is unfortunate that build tools such as dzil
appear unable to do this easily.

=back

=cut
