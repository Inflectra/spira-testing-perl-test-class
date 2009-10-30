#!/usr/bin/perl -w

use TAP::Harness;
use Inflectra::SpiraTest::Addons::Formatter::SpiraConsole ;

#instantiate the harness
$formatter = Inflectra::SpiraTest::Addons::Formatter::SpiraConsole -> new;
my $harness = TAP::Harness->new({ formatter => $formatter, ignore_exit => 1 });

#define the list of tests
@test_files = ("SampleTests.pl");
$harness->runtests(@test_files);
