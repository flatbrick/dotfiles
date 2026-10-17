#!/bin/sh
# Normalize the comment alignment of the "仓库结构" tree block in README.md.
# Usage: ./scripts/readme-tree.sh [--check] [README.md]
set -eu

exec perl - "$@" <<'PERL'
use strict;
use warnings;
use utf8;

my $check = 0;
if (@ARGV && $ARGV[0] eq '--check') {
	$check = 1;
	shift @ARGV;
}
my $file = shift @ARGV // 'README.md';

open(my $in, '<:encoding(UTF-8)', $file) or die "$file: $!\n";
my @lines = <$in>;
close $in;
chomp @lines;

my ($in_section, $in_block, $start, $end);
for my $i (0 .. $#lines) {
	my $l = $lines[$i];
	if (!$in_section && $l =~ /^##\s*仓库结构\s*$/) { $in_section = 1; next }
	if ($in_section && !$in_block && $l =~ /^```text\s*$/) { $in_block = 1; $start = $i; next }
	if ($in_block && $l =~ /^```\s*$/) { $in_block = 0; $in_section = 0; $end = $i; next }
}
die "$file: 未找到「仓库结构」代码块\n" unless defined $start && defined $end;

my $width = 0;
for my $i ($start + 1 .. $end - 1) {
	my $l = $lines[$i];
	next unless index($l, '#') >= 0;
	my $p = substr($l, 0, index($l, '#'));
	$p =~ s/\s+$//;
	$width = length($p) if length($p) > $width;
}

my @out = @lines;
for my $i ($start + 1 .. $end - 1) {
	my $l = $lines[$i];
	next unless index($l, '#') >= 0;
	my $at = index($l, '#');
	my $p = substr($l, 0, $at);
	$p =~ s/\s+$//;
	$out[$i] = $p . (' ' x ($width - length($p) + 1)) . substr($l, $at);
}

my $old = join("\n", @lines) . "\n";
my $new = join("\n", @out) . "\n";

if ($old eq $new) {
	print "README tree is aligned.\n";
	exit 0;
}

if ($check) {
	print STDERR "README tree comments are misaligned; run ./scripts/readme-tree.sh\n";
	exit 1;
}

open(my $out_fh, '>:encoding(UTF-8)', $file) or die "$file: $!\n";
print {$out_fh} $new;
close $out_fh;
print "README tree realigned.\n";
PERL
