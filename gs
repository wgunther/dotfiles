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

sub get_codespace {
  my $search_string = shift;
  my @codespaces;
  foreach my $line (split("\n", `gh codespace list`)) {
    chomp($line);
    my ($full_name, $short_name, $repo, $status, $created) = split /\t/, $line;
    push @codespaces,
      {
      full_name => $full_name,
      short_name => $short_name,
      repo => $repo,
      status => $status,
      created => $created
      };
  }

  my @results;
  foreach my $codespace (@codespaces) {
    if ($codespace->{repo} =~ /$search_string/) {
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

  return $results[0];
}

my $cmd = shift || "";
if ($cmd eq 'refresh') {
  print `gh codespace ssh --config > ~/.ssh/codespaces`;
  exit(0);
} elsif ($cmd eq 'forward') {
  my $search_string = shift;
  my $repo = get_codespace($search_string);
  my @ports = split ',', shift || "";
  push @ports, 5000, 9090;
  system("gh codespace ports forward -c $repo->{full_name} "
      . join(' ', map { "$_:$_" } @ports));
  exit(0);
} else {
  my $repo = get_codespace($cmd);
  system("gh codespace ssh -c $repo->{full_name}");
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

# $poll = 0;
# $thr->join();
# kill_forwards();
