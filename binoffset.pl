#!/usr/bin/perl
use strict;
use autodie;
use bignum;

@ARGV == 3 or die "Usage: $0 FILE OFFSET LENGTH\n";

my $file = $ARGV[0];
my $offset = $ARGV[1];
my $length = $ARGV[2];

my $offset_bit = $offset % 8;
my $offset_byte = ($offset - $offset_bit) / 8;

open my $fh, "<:raw", $file;
seek $fh, $offset_byte, 0;
my $bytes_read = read $fh, my $str, 8;
close $fh;

my $bitstr = unpack "b" . $bytes_read * 8, $str;
$bitstr = substr $bitstr, $offset_bit, $length;

my $rev = reverse $bitstr;
my $int = Math::BigInt->from_bin("0b" . $rev);
printf <<EOT, $bitstr, $rev, $int, $int->as_hex();
lower to higher: %s
reversed:        %s
  as int:        %s
  as hex:        %s
EOT
