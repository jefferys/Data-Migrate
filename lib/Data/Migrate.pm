package Data::Migrate;

# ABSTRACT: The author forgot to add an abstract.

=head1 SYNOPSIS

    use Data::Migrate;

    # Construct a Data::Migrate object instance
    # [FIXME] Use a real parameter instead of 'fieldName'.
    my $paramHR = { 'fieldName' => "value", };
    my $obj = Data::Migrate->new( $paramHR );

    # [FIXME] use a real get/set functions instead of 'fieldName()'.
    # Get/Set fieldName
    my $value = $obj->fieldName();
    my $oldValue = $obj->fieldName( $newValue );


=cut

=head1 DESCRIPTION

    [FIXME] Why I exist? Who might use me? To do what?

=cut

use 5.010;
use strict;
use warnings;

# VERSION

# Errors from caller context.
use Carp;

# Declare constants.
use Readonly;

# Subroutine param checking.
use Params::Check qw[check last_error];
$Params::Check::ALLOW_UNKNOWN         = 1;
$Params::Check::PRESERVE_CASE         = 1;
$Params::Check::VERBOSE               = 0;
$Params::Check::SANITY_CHECK_TEMPLATE = 0;


Readonly::Scalar my $CLASS => 'Data::Migrate';

=classMethod new()

    my $obj = Data::Migrate->new( $paramHR );

DESC:
    Creates and returns a Data::Migrate object.

[FIXME] - Real documentation for parameters
PARAM: $paramHR
    Takes one parameter, a mandatory hash.

   'fieldName'     Required
      Need documentation for parameters.

RETURNS: $obj
    The newly constructed object.

=cut

# [FIXME] assumes required parameter of 'fieldName'
sub new {

   if ( scalar @_ != 2 ) {
      croak( "$CLASS"
           . '::new was called incorrectly.'
           . ' It is a class method with one param.' );
   }
   my $class          = shift;
   my $paramsHR       = shift;
   my $validateSpecHR = { fieldName => { required => 1, defined => 1 }, };
   my $okParamsHR     = check( $validateSpecHR, $paramsHR );
   if ( ! $okParamsHR ) {
      croak( last_error() );
   }

   my $self = $okParamsHR;
   bless $self, $class;

   return $self;
}

=method fieldName()

    # [FIXME] - No such parameter, really.
    my $value = $obj->fieldName();
    my $oldValue = $obj->fieldName( $newValue );

DESC:
   Get or set the value of the field 'fieldName'

PARAM: $newValue (optional)
   If provided, fieldname will be set to this value.

RETURNS: $value
   Return the value of fieldname. Returns its old value if changing it.

=cut

sub fieldName {
   my $self     = shift;
   my $newValue = shift;
   my $oldValue = $self->{'fieldName'};
   $self->{'fieldName'} = $newValue;
   return $oldValue;
}

1;

__END__

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

=cut

=head1 BUGS AND SUPPORT

No known bugs are present in this release. Unknown bugs are a virtual
certainty. Please report bugs (and feature requests) though the
Github issue tracker associated with the development repository, at:

L<https://github.com/Jefferys/Data-Migrate/issues>

Note: you must have a GitHub account to submit issues, but they are free.

=cut

=head1 DEVELOPMENT & CONTRIBUTION

This module is developed and hosted on GitHub, at
L<https://github.com/Jefferys/Data-Migrate>. Development
is done using Dist Zilla, but releases to github are made to both a master and
a release branch, with the master branch building using dzil, while the release
branch uses only the Core perl build system (ExtUtil::MakeMaker).

=cut

=head2 Conventions

=head3 Names and Variables

=over 4

=item scalar variable names

I use camel case, starting with lower case. I try to use nouns: $age, $firstName

=item hash and array variable names

I use camel case, starting with lower case. I try to use plural nouns: %params,
@daysOfTheWeek

=item reference variable names

I use came case, starting with lower case and ending with HR for hash-refs,
AR for array-refs, and SR for scalar ref. I try to use nouns, and in general
use plurals for HR and AR, singular for SR. $paramsHR, $listAR,
$bigTextBlockSR. The terminal tag, remeniscent of "Hungarian notation", helps
me in the same way the @ and % sigils do.

=item hash keys

I use camelCase, starting with lower case. I enclose keys in single quotes, but
don't use any keys that are not valid variable names. I make exceptions when the
keys are clearly something else (objects, the strings in a text segment, a
duplicate check mechansim, checksums, uuids, etc).

=item constants

If a variable is used as constant, I use all capital SNAKE_CASE: $PI,
$COLOR_RGB_HR

=item packages and distributions

I use capitalized CamelCase for package names, like: GetOpt::Long.

I name distributions identically to packages, except in spinal-case, like:
GetOpt-Long.

=item subroutines

I name subroutines like scalar variables, in camelCase starting with
lower case. I try to use verbs: doSomething. I never use the & sigil, except
when using a reference to a subroutine: \&someSubName.

Rarely, I may need to pass a subroutine reference in a scalar variable (e.g.
when supply a subroutine to use for sorting, for example.). I still name the
variable like a subroutine, but end it in SUB: $sortSUB, $errorTraceFormatSUB.

=item get/set methods

I use the name of the field being changed as the method name. Without a param,
returns the current value of the field. With a value sets that as the new value
of the field, and returns the old value.

The advantage over separate get* and set* methods is the field name is exactly
used, wihout capitalization issues, and all the code is in one function instead
of two. The only drawback is the inability to set a field to an undefined
value. When needed, I create a separate setter called 'fieldNameClear' which
sets the field to undefined, or its original value, and returns the old value.
This is rarely needed, and its presence in the class API draws attention to the
fact that undefined field values are meaningful.

=back

=head3 Subroutine parameters

=over 4

=item positional parameters

I use positional parameters if a parameter has 0 or 1 parameter, and often if
it has 2 parameters. With 3 or more parameters, or if have 2 or more parameters
and one or more is optional, I use named parameters.

=item named parameters

I use named parameters if a subroutine has 3 or more parameters, or if it
has 2 or more parameters and any are optional. An exception is made if there
is a clear convention for ordering the parameters, like x,y,z points. If it is
not clear which order the parameters for a 2 parameter function should go in,
I might use named parameters even here, but not usually. Although I always have
to look up the parameter names when writing code, but reading cade after the
fact is MUCH easier with named parameters.

I allow and retain extra (unused) parameters to support backwards-compatible
(additive) changes.

I use case-sensitive parameter names to support use of camel case keys.

=item parameter validation

I validate parameters only for externally called subroutines.

I use Params::Check for validation with named parameters. This is in the
core and does not require xs as does Params::Validate. With very complex
interdependent parameters, I might use GetOpt::Long as a possible alternative to
Params::Validate. I will use Params::Validate only if I both have a complex
parameter set and a need for speed. That hasn't happened yet.

For postional parameters, I use manual parameter validation. If there is just
one positional parameter, a hash-ref, that is esentially the same as using
named parameters and can be validated with Params::Check.

=item variable parameters / pass by reference parameters.

Generally, when paramaters are passed to a function, their top-level values are
copied, using something like $someVar = shift; for a single param,
($someVar, $anotherVar) = @_; for positional params, and %params = @_ for named
params. This prevents a subroutine from accidentally modifying these values.
However, bcopying large values is costly, so if my data is large, I
will pass it as a reference so it doesn't get copied. Like all references, the
*reference* is copied, but not its contents. This has the drawback of leaving
the contents open to change, but this is the same as with all structures and
object, so being carefull not to modify internals (should) be second-nature.

A reference to @_ directly, like $_[0], will actually modify the parameters in
the context of the caller. This is opaque and uncommon, so I almost always use
an extra layer and modify the content of a passed in refereced object or
structure, with comments describing the intent. Note: I don't comments about
modifying internals in mutator methods as that is their whole intent.

=back

=cut
