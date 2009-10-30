package Inflectra::SpiraTest::Addons::Formatter::SpiraConsole::Session;

use strict;
use TAP::Formatter::Console::Session;

use vars qw($VERSION @ISA);

@ISA = qw(TAP::Formatter::Console::Session);

sub _output_test_failure
{
  my ( $self, $parser ) = @_;
  
      while ( my $result = $parser->next ) {
        print "=";
        print $result->as_string;
        print "\n";
    }

  
  $self->SUPER::_output_test_failure($parser);
  my $x = $parser->tests_run;
  print ("HELLO $x \n");
}
1;
