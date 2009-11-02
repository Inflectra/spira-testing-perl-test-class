#!/usr/bin/perl -w

use Inflectra::SpiraTest::Addons::SpiraHarness::Harness;

#instantiate the harness
my $harness = Inflectra::SpiraTest::Addons::SpiraHarness::Harness->new;

#specify the spiratest custom harness properties
$harness->{'base_url'} = "http://localhost/SmarteQM";
$harness->{'user_name'} = "fredbloggs";
$harness->{'password'} = "fredbloggs";
$harness->{'project_id'} = 1;
$harness->{'release_id'} = 1;
$harness->{'test_set_id'} = 1;

#define the list of tests and their SpiraTest Mapping
#Hash is of the format: TestFile => Test Case ID
my $tests = {};
$tests->{"SampleTest1.pl"} = 2;
$tests->{"SampleTest2.pl"} = 3;

$harness->runtests($tests);
