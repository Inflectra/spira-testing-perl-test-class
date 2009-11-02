#!/usr/bin/perl -w

use Inflectra::SpiraTest::Addons::SpiraHarness::Harness;

#instantiate the harness
my $harness = Inflectra::SpiraTest::Addons::SpiraHarness::Harness->new;

#specify the spiratest custom harness properties
$spira_args = {};
$spira_args->{"base_url"} = "http://localhost/SmarteQM";
$spira_args->{"user_name"} = "fredbloggs";
$spira_args->{"password"} = "fredbloggs";
$spira_args->{"project_id"} = 1;
$spira_args->{"release_id"} = 1;
$spira_args->{"test_set_id"} = 1;
$harness->{"spira_args"} = $spira_args;

#define the list of tests and their SpiraTest Mapping
#Hash is of the format: TestFile => Test Case ID
my $tests = {};
$tests->{"SampleTest1.pl"} = 2;
$tests->{"SampleTest2.pl"} = 3;

$harness->runtests($tests);
