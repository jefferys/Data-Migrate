# Development and contributions

This module is developed and hosted on GitHub, at
https://github.com/Jefferys/Data-Migrate. Development
is done using `Dist::Zilla`, but releases to github are made to both a master and
a release branch, with the master branch building using dzil, while the release
branch uses only the Core perl build system (`ExtUtil::MakeMaker`).


Names and Variables
-------------------

### Scalar variable names

I use camel case, starting with lower case. I try to use nouns: `$age`, `$firstName`

### Hash and array variable names

I use camel case, starting with lower case. I try to use plural nouns: `%params`,
`@daysOfTheWeek`

### Reference variable names

I use came case, starting with lower case and ending with HR for hash-refs,
AR for array-refs, and SR for scalar ref. I try to use nouns, and in general
use plurals for HR and AR, singular for SR. `$paramsHR`, `$listAR`,
`$bigTextBlockSR`. The terminal tag, reminiscent of "Hungarian notation", helps
me in the same way the `@` and `%` sigils do.

### Hash keys

I use camelCase, starting with lower case. I enclose keys in single quotes, but
don't use any keys that are not valid variable names. I make exceptions when the
keys are clearly something else (objects, the strings in a text segment, a
duplicate check mechanism, checksums, uuids, etc).

### Constants

If a variable is used as constant, I use all capital SNAKE_CASE: `$PI`,
`$COLOR_RGB_HR`

### Packages and distributions

I use capitalized CamelCase for package names, like: GetOpt::Long.

I name distributions identically to packages, except in spinal-case, like:
`GetOpt-Long`.

### Subroutines

I name subroutines like scalar variables, in camelCase starting with
lower case. I try to use verbs: doSomething. I never use the & sigil, except
when using a reference to a subroutine: `\&someSubName`.

Rarely, I may need to pass a subroutine reference in a scalar variable (e.g.
when supply a subroutine to use for sorting, for example.). I still name the
variable like a subroutine, but end it in `SUB: $sortSUB, $errorTraceFormatSUB`.

### Get/set methods

I use the name of the field being changed as the method name. Without a param,
returns the current value of the field. With a value sets that as the new value
of the field, and returns the old value.

The advantage over separate get* and set* methods is the field name is exactly
used, without capitalization issues, and all the code is in one function instead
of two. The only drawback is the inability to set a field to an undefined
value. When needed, I create a separate setter called 'fieldNameClear' which
sets the field to undefined, or its original value, and returns the old value.
This is rarely needed, and its presence in the class API draws attention to the
fact that undefined field values are meaningful.


Subroutine parameters
---------------------

### Positional parameters

I use positional parameters if a parameter has 0 or 1 parameter, and often if
it has 2 parameters. With 3 or more parameters, or if have 2 or more parameters
and one or more is optional, I use named parameters.

### Named parameters

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

### Parameter validation

I validate parameters only for externally called subroutines.

I use `Params::Check` for validation with named parameters. This is in the
core and does not require xs as does `Params::Validate`. With very complex
interdependent parameters, I might use GetOpt::Long as a possible alternative to
Params::Validate. I will use `Params::Validate` only if I both have a complex
parameter set and a need for speed. That hasn't happened yet.

For positional parameters, I use manual parameter validation. If there is just
one positional parameter, a hash-ref, that is essentially the same as using
named parameters and can be validated with `Params::Check`.

### Variable parameters / pass by reference parameters.

Generally, when parameters are passed to a function, their top-level values are
copied, using something like $someVar = shift; for a single param,
`($someVar, $anotherVar) = @_`; for positional params, and `%params = @_` for named
params. This prevents a subroutine from accidentally modifying these values.
However, copying large values is costly, so if my data is large, I
will pass it as a reference so it doesn't get copied. Like all references, the
*reference* is copied, but not its contents. This has the drawback of leaving
the contents open to change, but this is the same as with all structures and
object, so being careful not to modify internals (should) be second-nature.

A reference to `@_` directly, like `$_[0]`, will actually modify the parameters in
the context of the caller. This is opaque and uncommon, so I almost always use
an extra layer and modify the content of a passed in referenced object or
structure, with comments describing the intent. Note: I don't comments about
modifying internals in mutator methods as that is their whole intent.


Testing
-------

### filenames

I name all test files ".t". Test files run by users at installation are put in
the t/ directory of the distribution. Test files to be run only by
authors or developers go in the xt/ directory of the distribution in the
development repository. These are not needed by users and are *not* copied into
the distro.

(Rant follows...)

This is a more rigorous separation of concerns than is usually maintained with
perl distributions. With the prevalence of github and similar source
repositories taking up the load of supporting scm histories, it no longer makes
sense for CPAN to be used as a "development repository without history". It
still has a critical role as a centralized module source, and still needs
extensive meta-data provided to describe a distro and where to find the
development repository. The presence of xt directories in install tarballs is
an un-needed historic artifact. It is unfortunate that build tools such as dzil
appear unable to do this easily.
