package Inflectra::SpiraTest::Addons::Formatter::SpiraConsole;

use strict;
use Inflectra::SpiraTest::Addons::Formatter::SpiraExecute;
use base qw(TAP::Formatter::Console);
use POSIX qw(strftime);

use vars qw($VERSION @ISA);

@ISA = qw(TAP::Formatter::Console);

=head1 NAME

Inflectra::SpiraTest::Addons::Formatter::SpiraConsole - Extends the built-in console formatter to also report the results back to SpiraTest via. web service

=head1 VERSION

Version 2.3.0

=cut

$VERSION = '2.3.0';

=head1 DESCRIPTION

Extends the built-in console formatter to also report the results back to SpiraTest via. web service

=head1 SYNOPSIS

 use Inflectra::SpiraTest::Addons::Formatter::SpiraConsole;
 my $harness = Inflectra::SpiraTest::Addons::Formatter::SpiraConsole->new( \%args );

=head2 C<< open_test >>

See L<TAP::Formatter::Console>

=cut

#Constructor
sub new 
{
    my( $self, @args ) = @_;
    
    $self->SUPER::new( @args );
}

sub open_test {
    my ( $self, $test, $parser ) = @_;

    my $class
      = "Inflectra::SpiraTest::Addons::Formatter::Console::Session";

    eval "require $class";
    $self->_croak($@) if $@;

    my $session = $class->new(
        {  name       => $test,
            formatter  => $self,
            parser     => $parser,
            show_count => $self->show_count,
        }
    );

    $session->header;

    return $session;
}

#sends the results to SpiraTest when the execution is finished
sub summary
{
  my ( $self, $aggregate ) = @_;
  
  #first run the superclass functionality
  $self->SUPER::summary($aggregate);
  
  #Now we need to send the results to SpiraTest
  $self->_output("\nSending Results to SpiraTest\n");
  $self->_output("----------------------------\n");
  
  #get the reference to the test case id lookup hashref and the custom args
  my $test_reference = $self->{"test_reference"};
  my $spira_args = $self->{"spira_args"};
  
  #instantiate the spiratest execute object
  my $spira_test_execute = Inflectra::SpiraTest::Addons::Formatter::SpiraExecute->new($spira_args);

  #iterate through all the results from the SpiraTest dictionary
  my $test_statuses = $aggregate->{"testStatuses"};
  while ( my ($test_name, $execution_status) = each(%$test_statuses))
  {
    #get the test case id from the test reference hashref
    my $test_case_id = $test_reference->{$test_name};
    $self->_output("Test Case TC000$test_case_id has status = $execution_status\n");
    my $test_run_id = $spira_test_execute->record_test_run($test_case_id, $execution_status);
  }
}

1;