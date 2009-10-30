#!/usr/bin/perl -w

use TAP::Harness;
#use Inflectra::SpiraTest::Addons::SpiraHarness::Harness;
use Inflectra::SpiraTest::Addons::Formatter::SpiraConsole ;
use Inflectra::SpiraTest::Addons::Aggregator::SpiraAggregator ;

#instantiate the harness
$formatter = Inflectra::SpiraTest::Addons::Formatter::SpiraConsole -> new;
#my $harness = Inflectra::SpiraTest::Addons::SpiraHarness::Harness->new({ formatter => $formatter });
my $harness = TAP::Harness->new({ formatter => $formatter, aggregator_class => "Inflectra::SpiraTest::Addons::Aggregator::SpiraAggregator" });

#define the list of tests
@test_files = ("SampleTest1.pl", "SampleTest2.pl");
$harness->runtests(@test_files);
