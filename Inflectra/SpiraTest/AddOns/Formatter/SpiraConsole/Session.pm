package Inflectra::SpiraTest::Addons::Formatter::SpiraConsole::Session;

use strict;
use TAP::Formatter::Console::Session;

use vars qw($VERSION @ISA);

@ISA = qw(TAP::Formatter::Console::Session);

sub _output_test_failure
{
  print ("HELLO\n");
}
1;
