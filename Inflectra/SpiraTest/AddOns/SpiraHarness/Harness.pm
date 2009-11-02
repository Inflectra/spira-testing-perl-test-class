package Inflectra::SpiraTest::Addons::SpiraHarness::Harness;

use strict;
use base qw(TAP::Harness);
use Inflectra::SpiraTest::Addons::Formatter::SpiraConsole ;
use POSIX qw(strftime);

use vars qw($VERSION @ISA);

@ISA = qw(TAP::Harness);

=head1 NAME

Inflectra::SpiraTest::Addons::SpiraHarness::Harness - Extends the built-in harness class to also report the results back to SpiraTest via. web service

=head1 VERSION

Version 2.3.0

=cut

$VERSION = '2.3.0';

sub _initialize
{
  my ($self, $arg_for) = @_;
  
  #automatically add the Spira Test formatter and aggregator
  my $formatter = Inflectra::SpiraTest::Addons::Formatter::SpiraConsole -> new;
  $arg_for->{"formatter"} = $formatter;
  $arg_for->{"aggregator_class"} = "Inflectra::SpiraTest::Addons::Aggregator::SpiraAggregator";
  $self->SUPER::_initialize($arg_for);
}

sub runtests
{
  my ( $self, $test_hashref ) = @_;

  #convert the hash of spiratest test cases to a plain array that the TAP framework expects
  my @tests = ();
  my $test_file;
  foreach $test_file (keys %$test_hashref) 
  {
    push(@tests, $test_file);
  }
  
  #add a copy of the test hashref to the formatter
  my $formatter = $self->{"formatter"};
  $formatter->{"test_reference"} = $test_hashref;
  
  #pass the custom spiratest parameters to the formatter
  my $spira_args = $self->{"spira_args"};
  $formatter->{"spira_args"} = $spira_args;

  #now call the base-class functionality
  my $aggregate = $self->SUPER::runtests(@tests);
  return $aggregate;
}

1;
