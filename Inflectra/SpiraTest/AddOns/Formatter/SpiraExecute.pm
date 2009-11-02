package Inflectra::SpiraTest::Addons::Formatter::SpiraExecute;

use strict;
use SOAP::Lite +trace => 'all';
use vars qw($VERSION);

#SpiraTest web service constants
use constant WEB_SERVICE_NAMESPACE => "http://www.inflectra.com/SpiraTest/Services/v2.2/";
use constant WEB_SERVICE_URL_SUFFIX => "/Services/v2_2/ImportExport.asmx";

=head1 NAME

nflectra::SpiraTest::Addons::Formatter::SpiraExecute - Provides the Perl facade for accessing the SpiraTest web service for recording automated unit test results

=head1 VERSION

Version 2.3.0

=cut

$VERSION = '2.3.0';

sub new
{
    my $class = shift;
    my $self = bless {}, $class;
    return $self->_initialize(@_);
}

#stores the paramters passed-in containing the information for accessing the SpiraTest server
sub _initialize
{
  my ( $self, $spira_args ) = @_;

  $self->{"base_url"} = $spira_args->{"base_url"};
  $self->{"user_name"} = $spira_args->{"user_name"};
  $self->{"password"} = $spira_args->{"password"};
  $self->{"project_id"} = $spira_args->{"project_id"};
  
  if (defined $spira_args->{"release_id"})
  {
    $self->{"release_id"} = $spira_args->{"release_id"};
  }
  else
  {
    $self->{"release_id"} = -1;
  }
  if (defined $spira_args->{"test_set_id"})
  {
    $self->{"test_set_id"} = $spira_args->{"test_set_id"};
  }
  else
  {
    $self->{"test_set_id"} = -1;
  }

  return $self;
}

#records a single test event
sub record_test_run
{
  my ( $self, $test_case_id, $execution_status ) = @_;

  #create the full url to the web service
  my $wsdl_url = $self->{"base_url"} . WEB_SERVICE_URL_SUFFIX . "?WSDL";
  
  #get the SOAP parameters as local variables
  my $user_name = $self->{"user_name"};
  my $password = $self->{"password"};
  my $project_id = $self->{"project_id"};
  my $tester_user_id = -1;  #use the authenticated user
  my $release_id = $self->{"release_id"};
  my $test_set_id = $self->{"test_set_id"};
  my $start_date = "2008-04-28T08:00:00"; #time;
  my $end_date = "2008-04-28T08:00:00"; #time;
  my $runner_name = "Perl::TAP";
  my $runner_test_name = "test1";
  my $runner_assert_count = 0;
  my $runner_message  = "test2";
  my $runner_stack_trace = "test3";
  
  #call the soap url passing the parameters
  my $test_run_id = SOAP::Lite
    -> uri (WEB_SERVICE_NAMESPACE)
    -> proxy ($wsdl_url)
    -> TestRun_RecordAutomated2(
          $user_name,$password,$project_id,$tester_user_id,$test_case_id,$release_id,$test_set_id,
          $start_date,$end_date,$execution_status,$runner_name,$runner_test_name,
          $runner_assert_count, $runner_message, $runner_stack_trace);
					
  print("Successfully recorded test run TR000$test_run_id for test case TC000$test_case_id\n");
  return $test_run_id;
}