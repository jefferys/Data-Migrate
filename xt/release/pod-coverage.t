#! /usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Test::Pod::Coverage 1.08;    # Implements pod coverage testing.
use Pod::Coverage::TrustPod;     # Enable identifying skipped subs with =for.

all_pod_coverage_ok( { coverage_class => 'Pod::Coverage::TrustPod' } );

__END__

=head1 NAME

xt/release/pod-coverage.t - All subs have pod documentation?

=head1 PURPOSE

=head2 What code?

All source code (lib directory).

=head2 When?

At release time. This is a QA test, runtime behavior is not affected.

=head2 Purpose?

Ensure all subroutines in all source code have pod documentation.

=head2 Why?

Most functions have a short comment about what they do and/or how they work.
Why not make that pod instead of a comment. If a function really should not be
documented, can add a line to indicate that:

    =for Pod::Coverage sub_name

Good candidates for no pod subs are inherited subs that are over-ridden

=cut
