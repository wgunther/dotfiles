#!/usr/bin/env perl

use strict;
use warnings;
# use threads;

# my $forward_pid = undef;
# my $poll        = 1;

# END {
#   if ($forward_pid) {
#     kill_forwards();
#   }
# }

my $cmd = shift || "";

if ($cmd eq 'refresh') {
  print `gh codespace ssh --config > ~/.ssh/codespaces`;
  exit(0);
}

if ($cmd eq 'forward') {
  my @ports = split ',', shift || "";
  push @ports, 5000, 9090;
  print 'gh codespace ports ' . join(' ', map { "$_:$_" } @ports);
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

# sub spawn_task {
#   if ($forward_pid) {
#     kill_forwards();
#     die "Trying to spawn task while still have one";
#   }
#   my $command = shift;
#   my $pid     = fork();
#   if ($pid == 0) {
#
#     # clear the forward_pid in the child.
#     $forward_pid = undef;
#     system($command);
#     exit(0);
#   } else {
#     $forward_pid = $pid;
#     system("echo $forward_pid >> ./log");
#   }
# }
#
# sub kill_forwards {
#   if ($forward_pid) {
#     system("echo killing $forward_pid >> ./log");
#     kill 'TERM', $forward_pid;
#     waitpid($forward_pid, 0);
#     $forward_pid = undef;
#   }
# }
#
# sub poll_ports {
#   my $repo = shift;
#   my $ports;
#   while ($poll) {
#     my $port_output = join " ", map { "$_:$_" }
#       map { $_ =~ /^\s*(\d+)/ }
#       split("\n", `gh codespace ports -c $repo->{full_name}`);
#     if ($ports ne $port_output) {
#       kill_forwards();
#       warn("gh codespace ports forward $port_output");
#       my $pid = spawn_task(
#         "gh codespace ports forward $port_output -c $repo->{full_name}");
#       $ports = $port_output;
#     }
#     sleep(10);
#   }
# }
#
# my $thr  = threads->new(\&poll_ports, $repo);

my $repo = shift @results;
system("gh codespace ssh -c $repo->{full_name}");

# $poll = 0;
# $thr->join();
# kill_forwards();
