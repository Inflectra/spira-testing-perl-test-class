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
  
  #automatically add the Spira Test formatter
  my $formatter = Inflectra::SpiraTest::Addons::Formatter::SpiraConsole -> new;
  $arg_for->{"formatter"} = $formatter;
  $self->SUPER::_initialize($arg_for);
}

sub runtests
{
  my ( $self, $test_hashref ) = @_;

  #convert the hash of spiratest test cases to a plain array that the TAP framework expects
  my @tests = ();
  while ( my ($test_file, $test_case_id) = each(%$test_hashref) )
  {
    push(@tests, $test_file);
  }

  #now call the base-class functionality
  my $aggregate = $self->SUPER::runtests(@tests);
  return $aggregate;
}

sub runtests2
{
    my ( $self, $test_hashref ) = @_;

    #convert the hash of spiratest test cases to a plain array that the TAP framework expects
    my @tests = ();
    while ( my ($test_file, $test_case_id) = each(%$test_hashref) )
    {
        push(@tests, $test_file);
    }

    my $aggregate = $self->SUPER::_construct( $self->aggregator_class );

    $self->SUPER::_make_callback( 'before_runtests', $aggregate );
    $aggregate->start;
    $self->SUPER::aggregate_tests( $aggregate, @tests );
    $aggregate->stop;
    $self->SUPER::summary($aggregate);
    $self->SUPER::_make_callback( 'after_runtests', $aggregate );

    return $aggregate;
}

1;
