#! /usr/bin/env perl

use strict;
use warnings;
use 5.010;

# use Test::More       # Doesn't seem needed, so commenting out.
use Test::Pod 1.41;    # Implements pod syntax testing.

all_pod_files_ok();

__END__

=head1 NAME

xt/release/pod-syntax.t - All pod in source files is correctly formatted?

=head1 PURPOSE

=head2 What code?

All source code files (lib directory).

=head2 When?

At release time. This is a QA test, runtime behavior is not affected.

=head2 Purpose?

Ensure pod in all source code files is correctly formatted.

=head2 Why?

Invalidly formatted pod does not necessarily cause compile or run-time failure,
so a separate check is needed to figure out if errors will be generated by
perldoc or other pod readers.

=head1 INTERNALS

Based on the test file generated by Dist::Zilla::Plugin::PodSyntaxTests.

SRJ: The original generated version used Test::More, but I can not figure out
why, so I have commented it out.

=cut
