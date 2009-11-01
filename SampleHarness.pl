#!/usr/bin/perl -w

#use TAP::Harness;
use Inflectra::SpiraTest::Addons::SpiraHarness::Harness;
use Inflectra::SpiraTest::Addons::Formatter::SpiraConsole ;
use Inflectra::SpiraTest::Addons::Aggregator::SpiraAggregator ;

#instantiate the harness
$formatter = Inflectra::SpiraTest::Addons::Formatter::SpiraConsole -> new;
my $harness = Inflectra::SpiraTest::Addons::SpiraHarness::Harness->new({ aggregator_class => "Inflectra::SpiraTest::Addons::Aggregator::SpiraAggregator" });
#my $harness = TAP::Harness->new({ formatter => $formatter, aggregator_class => "Inflectra::SpiraTest::Addons::Aggregator::SpiraAggregator" });

#define the list of tests and their SpiraTest Mapping
#Hash is of the format: TestFile => Test Case ID
my $tests = {};
$tests->{"SampleTest1.pl"} = 2;
$tests->{"SampleTest2.pl"} = 3;

$harness->runtests($tests);
