package Inflectra::SpiraTest::Addons::Samples::TestMe;

use strict;
use warnings;
our $VERSION = '1.00';
use base 'Exporter';
our @EXPORT = qw( add subtract multiply );

#The addition function
sub add
{
  my ($num1,  $num2) = @_;
  return $num1 + $num2;
}

#The subtraction function
sub subtract
{
  my ($num1,  $num2) = @_;
  return $num1 - $num2;
}

#The multiplication function
sub multiply
{
  my ($num1,  $num2) = @_;
  return $num1 * $num2;
}