#!/usr/bin/perl -w

use TAP::Harness;

#instantiate the harness
my %hash_args = ();
$hash_args {"formatter_class"} = "Inflectra::SpiraTest::Addons::PerlExtension::SpiraConsoleFormatter";
my $harness = TAP::Harness->new( $hash_args );

#define the list of tests
@test_files = ("SampleTests.pl");
 $harness->runtests(@test_files);

