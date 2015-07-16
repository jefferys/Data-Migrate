package Data::Migrate;

# ABSTRACT: Tools to support data migration on unix systems

#pod =head1 SYNOPSIS
#pod
#pod     use Data::Migrate;
#pod
#pod     # Construct a Data::Migrate object instance
#pod     my $migrator = Data::Migrate->new();
#pod
#pod =cut

#pod =head1 DESCRIPTION
#pod
#pod Base object for doing data migration. Functions are object methods,
#pod generally, so they can use data from $self.
#pod
#pod =cut

use 5.010;       # Be specific
use strict;      # Be correct
use warnings;    # Be careful

# Version changes based on semantic versioning, managed externally.
our $VERSION = '0.1.0';    # VERSION

# Errors from caller context.
use Carp;

# Declare constants.
use Readonly;

# Allow for subroutine param checking.
use Params::Check qw[check last_error];
$Params::Check::ALLOW_UNKNOWN         = 1;
$Params::Check::PRESERVE_CASE         = 1;
$Params::Check::VERBOSE               = 0;
$Params::Check::SANITY_CHECK_TEMPLATE = 0;

# Declare constants
# Declare $CLASS to be this class, for use when calling class methods
Readonly::Scalar my $CLASS => 'Data::Migrate';

#pod =classMethod new()
#pod
#pod       my $migrator = Data::Migrate->new();
#pod
#pod DESC:
#pod
#pod Creates and returns a Data::Migrate object.
#pod
#pod PARAM: N/A
#pod
#pod RETURNS: $obj
#pod
#pod =cut

sub new {

   if ( scalar @_ < 1 ) {
      ## no critic (ValuesAndExpressions::RequireInterpolationOfMetachars)
      croak( "$CLASS"
           . '::new was called incorrectly.' . ' Use '
           . $CLASS
           . '->new().\n' );
      ## use critic
   }
   my $class = shift;

   my $self = {};
   bless $self, $class;

   return $self;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Migrate - Tools to support data migration on unix systems

=head1 SYNOPSIS

    use Data::Migrate;

    # Construct a Data::Migrate object instance
    my $migrator = Data::Migrate->new();

=head1 DESCRIPTION

Base object for doing data migration. Functions are object methods,
generally, so they can use data from $self.

=head1 CLASS METHODS

=head2 new()

      my $migrator = Data::Migrate->new();

DESC:

Creates and returns a Data::Migrate object.

PARAM: N/A

RETURNS: $obj

=head1 INSTALLATION

=head2 Current Version

You can install the latest release of this module directly from github using

   $ cpanm git://github.com/Jefferys/Data-Migrate.git@release

=head2 Older Versions

Older versions can be downloaded from the archive like:

     $ cpanm git://github.com/Jefferys/Data-Migrate.git@v0.1.0

but replacing the version string after the @ with the release's tag name.

=head2 Manual installation

You can also install manually by selecting and downloading the *.tar.gz package
for any release on github, i.e. for

=over 4

L<https://github.com/Jefferys/Data-Migrate/releases>

=back

Installing is then a matter of unzipping this, changing into the unzipped
directory, and then executing the normal (C>ExtUtill::MakeMaker>) incantation:

     perl Build.PL
     make
     make test
     make install

after which you are free to delete both the folder and the zipped file.

=head1 BUGS AND SUPPORT

No known bugs are present in this release. Unknown bugs are a virtual
certainty. Please report bugs (and feature requests) though the
Github issue tracker associated with the development repository, at:

L<https://github.com/Jefferys/Data-Migrate/issues>

Note: you must have a GitHub account to submit issues, but they are free.

=head1 DEVELOPMENT & CONTRIBUTION

This module is developed and hosted on GitHub, at
L<https://github.com/Jefferys/Data-Migrate>. Development
is done using Dist Zilla, but releases to github are made to both a master and
a release branch, with the master branch building using dzil, while the release
branch uses only the Core perl build system (ExtUtil::MakeMaker).

See "development.md" for more details

=head1 AUTHOR

Stuart R. Jefferys <srjefferys@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2015 by Stuart R. Jefferys.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
