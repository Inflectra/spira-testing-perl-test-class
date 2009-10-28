package Inflectra::SpiraTest::Addons::Formatter::SpiraConsole;

use strict;
use TAP::Formatter::Console ();
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


sub open_test {
    my ( $self, $test, $parser ) = @_;

    my $class
      = $self->jobs > 1
      ? 'TAP::Formatter::Console::ParallelSession'
      : 'Inflectra::SpiraTest::Addons::Formatter::SpiraConsole::Session';

    eval "require $class";
    $self->_croak($@) if $@;

    my $session = $class->new(
        {   name       => $test,
            formatter  => $self,
            parser     => $parser,
            show_count => $self->show_count,
        }
    );

    $session->header;

    return $session;
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