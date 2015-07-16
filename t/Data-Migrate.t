#! /usr/bin/env perl
use 5.010;
use strict;
use warnings;


use Readonly;      # Declare constants
use Try::Tiny;     # Better than eval for error handling
use Test::More 'tests' => 1 + 3; # Main testing module, with test count

# Test that Data::Migrate loads ok as a module. Will fail if contians syntax
# errors or if can't find it.
BEGIN {
   use_ok('Data::Migrate');
}

# Constant defining the class to use for static method calls.
Readonly::Scalar my $CLASS => 'Data::Migrate';

# Group tests into tests for helper functions (functions defined in THIS file,
# tests for normal execution flows, and tests for error conditions or warnings
# from normal execution.)

subtest( 'Data-Migrate.t Helpers'                        => \&testHelpersT );
subtest( 'Data-Migrate.t Unit Tests (Normal Behavior)'   => \&testOkT );
subtest( 'Data-Migrate.t Unit tests (Excetion Handling)' => \&testBadT );


# Self tests:
#
# Test group for self-testing the helper functions in *this* test file.
# Done first as errors here hide other errors. There are no sub tests
# for these as they should be bog-simple functions. More complex helpers should
# be factored out into separate test utilities
sub testHelpersT {
   plan( tests => 1 );

   subtest( 'provideDefaultObj()'      => \&provideDefaultObjT );
   return 1;
}

# Normal execution tests:
#
# Unit testing the normal (non-exceptional) behavior of the subs in the
# associated module.
sub testOkT {
   plan( tests => 1 );

   subtest( 'newOk()'       => \&newOkT );
   return 1;
}

# Exception tests
#
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

   # Accessing internals directly, only for testing - bad use practice
   {
      my $want = {};
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
   plan( tests => 1 );

   {
      my $defaultObj = $CLASS->new();
      ok( $defaultObj, 'Object constructor smoke test.' );
   }
   return 1;
}

sub newBadT {
   plan( tests => 1 );

   my $newCalledWrongRE =
     qr/^Data::Migrate::new was called incorrectly\. Use Data::Migrate->new\(\)/;

   my $noErrorError = 'This should fail.';
   {
      try {
         Data::Migrate::new();
         fail($noErrorError);
      }
      catch {
         my $got  = $_;
         my $want = $newCalledWrongRE;
         like( $got, $want, 'Error with no param' );
      };
   }
   return 1;
}

#
# Data providers
#

# [FIXME] Assumes 'fieldName' is real parameter.

sub provideDefaultObj {
   my $defaultObj = $CLASS->new();
   return $defaultObj;
}

__END__

=head1 NAME

t/Data-Migrate.t - Unit tests for Data::Migrate

=head1 PURPOSE

Unit test all the subroutines in the main module and the data providor
subroutines in this module.

=head1 DESCRIPTION

Contains unit tests that are organized with one test file matching each code
file in the main distribuion, and then within each test file tests are
organized into 4 sub-test testing (1) module loading, (2) helper functions
within the test file, (3) Normal function operations, and (4) exception handling

=head1 RUN

This is intended to be run as part of the test harness. It should be run by
the developer before commiting any new changes and by the user at install time.

=cut

=head1 DEVELOPMENT & CONTRIBUTION

This module is developed and hosted on GitHub, at
L<https://github.com/Jefferys/Data-Migrate>. Development
is done using Dist Zilla, but releases to github are made to both a master and
a release branch, with the master branch building using dzil, while the release
branch uses only the Core perl build system (ExtUtil::MakeMaker).

See devlopment.md for more details.

=cut
