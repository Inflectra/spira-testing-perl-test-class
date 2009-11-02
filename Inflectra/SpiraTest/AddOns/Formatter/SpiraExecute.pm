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
  
  #instantiate the SOAP::lite class
  my $soap = SOAP::Lite
    -> uri (WEB_SERVICE_NAMESPACE)
    -> on_action(sub{sprintf '%s%s', @_ })
    ->use_prefix(0)
    -> proxy ($wsdl_url);
  
  #create the SOAP parameter data
  my $params = SOAP::Data->value(
    SOAP::Data->name("userName" => $self->{"user_name"}),
    SOAP::Data->name("password" => $self->{"password"}),
    SOAP::Data->name("projectId" => $self->{"project_id"}),
    SOAP::Data->name("testerUserId" => -1),
    SOAP::Data->name("testCaseId" => $test_case_id),
    SOAP::Data->name("releaseId" => $self->{"release_id"}),
    SOAP::Data->name("testSetId" => $self->{"test_set_id"}),
    SOAP::Data->name("startDate" => "2008-04-28T08:00:00"),
    SOAP::Data->name("endDate" => "2008-04-28T08:00:00"),
    SOAP::Data->name("executionStatusId" => $execution_status),
    SOAP::Data->name("runnerName" => "Perl::TAP"),
    SOAP::Data->name("runnerTestName" => "test1"),
    SOAP::Data->name("runnerAssertCount" => 0),
    SOAP::Data->name("runnerMessage"  => "test2"),
    SOAP::Data->name("runnerStackTrace" => "test3"));
  
  #call the soap method passing the parameters
  my $test_run_id = $soap->TestRun_RecordAutomated2( $params );
  print("Successfully recorded test run TR000$test_run_id for test case TC000$test_case_id\n");
  return $test_run_id;
}