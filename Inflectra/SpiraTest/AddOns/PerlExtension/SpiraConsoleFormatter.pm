package Inflectra::SpiraTest::Addons::PerlExtension::SpiraConsoleFormatter;

use strict;
use TAP::Formatter::Base ();
use POSIX qw(strftime);

use vars qw($VERSION @ISA);

@ISA = qw(TAP::Formatter::Base);

=head1 NAME

Inflectra::SpiraTest::Addons::PerlExtension::SpiraConsoleFormatter - Replaces the built-in console formatter to also report the results back to SpiraTest via. web service

=head1 VERSION

Version 2.3.0

=cut

$VERSION = '2.3.0';

=head1 DESCRIPTION

Replaces the built-in console formatter to also report the results back to SpiraTest via. web service

=head1 SYNOPSIS

 use Inflectra::SpiraTest::Addons::PerlExtension::SpiraConsoleFormatter;
 my $harness = Inflectra::SpiraTest::Addons::PerlExtension::SpiraConsoleFormatter->new( \%args );

=head2 C<< open_test >>

See L<TAP::Formatter::Console>

=cut

sub open_test {
    my ( $self, $test, $parser ) = @_;
    
    my $class
      = $self->jobs > 1
      ? 'TAP::Formatter::Console::ParallelSession'
      : 'TAP::Formatter::Console::Session';

    eval "require $class";
    $self->_croak($@) if $@;
    
    #send the results to SpiraTest before writing to the console
    #print "SPIRA Test";#=" + $test + "\n";

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

# Use _colorizer delegate to set output color. NOP if we have no delegate
sub _set_colors {
    my ( $self, @colors ) = @_;
    if ( my $colorizer = $self->_colorizer ) {
        my $output_func = $self->{_output_func} ||= sub {
            $self->_output(@_);
        };
        $colorizer->set_color( $output_func, $_ ) for @colors;
    }
}

sub _output_success {
    my ( $self, $msg ) = @_;
    $self->_set_colors('green');
    $self->_output($msg);
    $self->_set_colors('reset');
}

sub _failure_output {
    my $self = shift;
    $self->_set_colors('red');
    my $out = join '', @_;
    my $has_newline = chomp $out;
    $self->_output($out);
    $self->_set_colors('reset');
    $self->_output($/)
      if $has_newline;
}

1;