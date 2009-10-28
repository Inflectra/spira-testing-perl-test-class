#!/usr/bin/perl -w

use TAP::Harness;
use Inflectra::SpiraTest::Addons::PerlExtension::SpiraConsoleFormatter;

#instantiate the harness
$formatter = Inflectra::SpiraTest::Addons::PerlExtension::SpiraConsoleFormatter -> new;
my $harness = TAP::Harness->new({ formatter => $formatter });

#define the list of tests
@test_files = ("SampleTests.pl");
 $harness->runtests(@test_files);
