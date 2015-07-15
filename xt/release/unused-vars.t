#! /usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::More 0.96 tests => 1;    # Core testing language
my $isFound = eval {
   require Test::Vars;             # Implements test for unsued vars
   1;
};

SKIP: {
   if ( ! $isFound ) {
      skip( 'Test::Vars required for testing for unused vars', 1 );
   }

   Test::Vars->import;

   subtest 'unused vars' => sub {
      all_vars_ok();
   };
}

__END__

=head1 NAME

xt/release/unused-vars.t - All variables used?

=head1 PURPOSE

=head2 What code?

All source code (lib directory).

=head2 When?

At release time. This is a QA test, runtime behavior is not affected.

=head2 Purpose?

Ensure all varialbes are actually used.

=head2 Why?

Unused variables are at best a waste of memory but often represent an error or
misspelling.

This is similar to  Perl::Critic::Policy::Variables::ProhibitUnusedVariables but
uses a different approach that may be more comprehensive than the one used by
perlcritic. It is also probably more expensive.

=cut
