#! /usr/bin/env perl

use strict;
use warnings;

use Text::Template;    # Treat files as templates.
use Safe;              # Used to make perl execution in template safer.
use Cwd qw(getcwd abs_path);  # Change default dir; Need to compare two paths.

run();

sub run {
   # Parse input parameters
   my $argsHR = parseArgs( @ARGV );

   # Can't get profile directory back from mint, but can get created directory, so
   # afterMint always ends in the profile directory, even though you probably don't
   # want to do anything there. So lets just go to the newly minted dist dir.
   my $originalWorkingDir = getcwd();
   chdir( $argsHR->{'mintToDir'} );

   # Set up file-wide values
   my $distName = $argsHR->{'distName'};
   my $class = distNameToClass( $distName );

   my $template = 't/main.t';
   my $outFile  = 't/' . $distName . '.t';
   my $dataHR   = {
      'CLASS' => $class,
      'DIST'  => $distName,
   };
   doMerge( {
      'template'          => $template,
      'outFile'           => $outFile,
      'dataHR'            => $dataHR,
      'isTemplateDeleted' => 1,
   } );

   chdir( $originalWorkingDir );
}

# USAGE:
#    doMerge( $paramHR );
#
# DESC:
#    Performs a template merge using Text::Template. Most simply one provides a
# list of variables and their values as a hash, and the values will be
# subsituted for the variable in a template fle. A hash with
# 'THE_KEY' => 'some value' will cause every instance of '{<$THE_KEY>}' in the
# template file to be replaced with 'some value'. Note the '$' in addition to
# the delimiters {< and >}. The delimiter surrounded text is
# actually interpreted as perl code, with initial variables and values provided
# by the hash. This allows complex logic to be embedded in the template if
# needed.
#
# PARAM: $paramsHR
#    $paramsHR->{'template'}         = REQUIRED (no default)
# The file name of the template file.
#    $paramsHR->{'outFile'}          = REQUIRED (no default)
# The resulting file after filing in and processed the template.
#    $paramsHR->{'dataHR'}           = {}
# Initializes each code element in the template with these variables, specified
# as {'key' => 'value', ...}. By default nothing is set.
#    $paramsHR->{'isOverwriteOk'}    = 0
# Clobber pre-existing file with output if set. Otherwise trying to output over
# an existing file is a fatal error. It is never possible to overwrite the
# template file with the output file.
#    $paramsHR->{'isLessSafe'}         = 0
# By default, evaluate the perl in a 'Safe' compartment (see the module Safe).
# Set to 1 to just eval the code.
#    $paramHR->{'isTemplateDeleted'} = 0
# You can't name the template and the output file to be the same thing. If you
# want to do an "edit in place" just use a different name for the template and
# delete it by setting this true.

# RETURN: 1
#   Either succeeds and returns 1, or dies with error.
#
# ERRORS:
#   PARAM.outFile: You must specify a file name to create on merge.
#   PARAM.template: You must specify a template to merge to.
#   IO.CREATE: Never allowed to overwrite the template with the output file.
#   IO.CREATE: Output file not allowed to overwrite "<<outFile>>".
#   IO.DELETE: Can't delete "<<file>>": <details>>
#   IO.OPEN: Can't open "<<file>>" for write: <<details>>
#   NEW.Text::Template: Couldn't construct tempate object: <<details>>
#   SUB.Text::Template.fill_in: Couldn't fill in template: <<details>>
# WARN:
#   IO.CLOSE: Failed to close "<<file>>" <<details>>
# TODO:
#   Convert this script to module.
sub doMerge {
   my $paramsHR = shift;

   my $outFile = $paramsHR->{'outFile'};
   if (! $outFile) {
      die "PARAM.outFile: You must specify a file name to create on merge.";
   }
   my $templateFile = $paramsHR->{'template'};
   if (! $templateFile) {
       die "PARAM.template: You must specify a template to merge to.";
   }
   if ( abs_path($outFile) eq abs_path($templateFile) ) {
     die( "IO.CREATE: Never allowed to overwrite the template with the output file." );
   }

   if ( ! $paramsHR->{'isOverwriteOk'} && -e $paramsHR->{'outFile'} ) {
     die( "IO.CREATE: Output file not allowed to overwrite \"$paramsHR->{'outFile'}\"." );
   }

   open(my $outFH, ">", $outFile)
     or die ("IO.OPEN: Can't open \"$outFile\" for write: $!");

   my $template = Text::Template->new(
      'TYPE'       => 'FILE',
      'SOURCE'     => $templateFile,
      'DELIMITERS' => ['{<','>}' ]
   ) or die ("NEW.Text::Template: Couldn't construct tempate object: $Text::Template::ERROR");

   my %fillHR = (
      'OUTPUT' => $outFH,
      'HASH' => $paramsHR->{'dataHR'},
   );
   unless ( $paramsHR->{'isLessSafe'} ) {
     $fillHR{ 'SAFE' } = new Safe;
   }
   $template->fill_in( %fillHR )
     or die ("SUB.Text::Template.fill_in: Couldn't fill in template: $Text::Template::ERROR");

   close($outFH)
     or warn("IO.CLOSE: Failed to close \"$outFile\": $!");

   if ( $paramsHR->{'isTemplateDeleted'} ) {
     unlink($templateFile)
        or die("IO.DELETE: Can't delete \"$templateFile\": $!");
   }

   return 1; # Succeeds or errors out.
}

# USAGE:
#    my $argsHR = parseArgs( @ARGV );
#    my $rootDirOfMintedDist  = $argsHR->{'mintToDir'};
#    my $distNameWithHyphens  = $argsHR->{'distName'};
#
# DESC:
#    Copies the passed in array and parses it assuming it is the expected
# arguments in the expected order. Returns a hash ref with the arguments
# assigned to keys based on position.
#
# PARAM: @argv
#    The argument array as recieved by this script. Assumed to have
# two values:
#    $argv[0] = The directory where the distribution is being minted to.
#    $argv[1] = The name of the distribution, matchng the package, like A-Dist.
#
# RETURN: $argsHR
#   The values from input argv array assigned to the appropriate key:
#   $argsHR->{'mintToDir'} = $argv[0];
#   $argsHR->{'distName'}  = $argv[1];
#
sub parseArgs {
   my @argCopy = @_;
   return {
      'mintToDir' => $argCopy[0],
      'distName'  => $argCopy[1]
   };
}

# USAGE:
#    my class = distNameToClass( 'Some-Dist-Name' );
#
# DESC:
#    Converts a distribution name to a class name, replacing '-' with '::'.
# Assumes the distribution and the class names are equivalent, and that no
# class name component is hyphenated.
#
# PARAM: $ distName
#    The name of a perl module distribution, like 'Some-Dist-Name'.
#
# RETURN: $class
#    The class name matching the provided distribution, like 'Some::Dist::Name'.
#
sub distNameToClass {
   my $distName = shift;
   $distName =~ s/-/::/g;
   return $distName;
}

__END__

=head1 NAME

afterMint.pl - Do stuff after dzil new mints a new distribution

=head1 USAGE

In plugins.ini

    [Run::AfterMint]
    run = afterMint.pl
    eval = unlink afterMint.pl

=head1 DESCRIPTION

This script will be copied to the newly minted distribution alogn with all the
other files. It is assumed the copy is done by gather template, otherwise this
file won't know what the distribution name is. After dzil new is finished,
this script will be called by the Dist::Zilla::Plugin::Run::AfterMint plugin.
After it finishes executing, this script will be deleted from the newly minted
distribution as it will not be used again.

This script performs the following post-mint tasks:

=over 4

=item 1.

Applies Text::Template (required by Dist::Zilla already) to files as specified.

=back
