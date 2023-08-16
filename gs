#!/usr/bin/env perl

use strict;
use warnings;

my $cmd = shift || "";

if ($cmd eq 'refresh') {
  print `gh codespace ssh --config > ~/.ssh/codespaces`;
  exit(0);
}

# wgunther-didactic-umbrella-6pxqjp5vjw24pj5      didactic umbrella       duolingo/tracking-event-schema  wgunther-document       Shutdown        2023-05-26T15:38:00-04:00
my @codespaces;
foreach my $line (split("\n", `gh codespace list`)) {
  chomp($line);
  my ($full_name, $short_name, $repo, $status, $created) = split /\t/, $line;
  push @codespaces,
    {
    full_name  => $full_name,
    short_name => $short_name,
    repo       => $repo,
    status     => $status,
    created    => $created
    };
}

my @results;
foreach my $codespace (@codespaces) {
  if ($codespace->{repo} =~ /$cmd/) {
    push @results, $codespace;
  }
}

if (@results == 0) {
  print "No repo found. The following exist:\n",
    join("\n\t", map { $_->{repo} } @codespaces), "\n";
  exit(1);
} elsif (@results > 1) {
  print "Multiple repos found: \n", join("\n\t", map { $_->{repo} } @results),
    "\n";
  exit(1);
}

my $repo = shift @results;
system("gh codespace ssh -c $repo->{full_name}")
