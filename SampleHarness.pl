#!/usr/bin/perl -w

use Inflectra::SpiraTest::Addons::SpiraHarness::Harness;

#instantiate the harness
$formatter = Inflectra::SpiraTest::Addons::Formatter::SpiraConsole -> new;
my $harness = Inflectra::SpiraTest::Addons::SpiraHarness::Harness->new;

#define the list of tests and their SpiraTest Mapping
#Hash is of the format: TestFile => Test Case ID
my $tests = {};
$tests->{"SampleTest1.pl"} = 2;
$tests->{"SampleTest2.pl"} = 3;

$harness->runtests($tests);
