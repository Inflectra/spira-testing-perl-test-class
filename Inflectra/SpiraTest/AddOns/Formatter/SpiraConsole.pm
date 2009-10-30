package Inflectra::SpiraTest::Addons::Formatter::SpiraConsole;

use strict;
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
    my( $class, @args ) = @_;
    
    my $self = $class->SUPER::new( @args );
}

sub summary
{
  my ( $self, $aggregate ) = @_;
  
  #first run the superclass functionality
  $self->SUPER::summary($aggregate);
  
  #Now we need to send the results to SpiraTest
  $self->_output("\nSending Results to SpiraTest\n");
  $self->_output("----------------------------\n");
}

# Used for debugging purposes only
sub log
{
    my $self = shift;
    push @_, "\n" unless grep {/\n/} @_;
    $self->_output( @_ );
    return $self;
}


1;