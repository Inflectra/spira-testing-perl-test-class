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

  #now perform the base functionality - copied from the original code
  my $aggregate = $self->_construct( $self->aggregator_class );
  $self->_make_callback( 'before_runtests', $aggregate );
  $aggregate->start;
  $self->aggregate_tests( $aggregate, @tests );
  $aggregate->stop;
  $self->summary($aggregate);
  $self->_make_callback( 'after_runtests', $aggregate );

  return $aggregate;
}

sub aggregate_tests
{
    my ( $self, $aggregate, @tests ) = @_;

    my $jobs      = $self->jobs;
    my $scheduler = $self->make_scheduler(@tests);

    # #12458
    local $ENV{HARNESS_IS_VERBOSE} = 1
      if $self->formatter->verbosity > 0;

    # Formatter gets only names.
    $self->formatter->prepare( map { $_->description } $scheduler->get_all );

    if ( $self->jobs > 1 )
    {
        $self->_aggregate_parallel( $aggregate, $scheduler );
    }
    else
    {
        $self->_aggregate_single( $aggregate, $scheduler );
    }

    return;
}

sub _aggregate_parallel
{
    my ( $self, $aggregate, $scheduler ) = @_;

    my $jobs = $self->jobs;
    my $mux  = $self->_construct( $self->multiplexer_class );

    RESULT: {

        # Keep multiplexer topped up
        FILL:
        while ( $mux->parsers < $jobs )
        {
            my $job = $scheduler->get_job;

            # If we hit a spinner stop filling and start running.
            last FILL if !defined $job || $job->is_spinner;

            my ( $parser, $session ) = $self->make_parser($job);
            $mux->add( $parser, [ $session, $job ] );
        }

        if ( my ( $parser, $stash, $result ) = $mux->next )
        {
            my ( $session, $job ) = @$stash;
            if ( defined $result )
            {
                $session->result($result);
                $self->_bailout($result) if $result->is_bailout;
            }
            else
            {
                # End of parser. Automatically removed from the mux.
                $self->finish_parser( $parser, $session );
                $self->_after_test( $aggregate, $job, $parser );
                $job->finish;
            }
            redo RESULT;
        }
    }

    return;
}

sub _aggregate_single
{
    my ( $self, $aggregate, $scheduler ) = @_;

    JOB:
    while ( my $job = $scheduler->get_job )
    {
        next JOB if $job->is_spinner;

        my ( $parser, $session ) = $self->make_parser($job);

        my $stack_traces = $aggregate->{"stackTraces"};
        while ( defined( my $result = $parser->next ) )
        {
            $session->result($result);
            if ( $result->is_bailout )
            {
                # Keep reading until input is exhausted in the hope
                # of allowing any pending diagnostics to show up.
                1 while $parser->next;
                $self->_bailout($result);
            }
            
            #Add the detailed results to the SpiraTest message and stack trace
            my $test_name = $job->filename;
            my $stack_trace = $stack_traces->{$test_name};
            if (defined $stack_trace)
            {
              $stack_trace = $stack_trace . $result->raw . "\n";
            }
            else
            {
              $stack_trace = $result->raw . "\n";
            }
            $stack_traces->{$test_name} = $stack_trace;
        }

        $self->finish_parser( $parser, $session );
        $self->_after_test( $aggregate, $job, $parser );
        $job->finish;
    }

    return;
}

1;
