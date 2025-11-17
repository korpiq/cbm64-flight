#!/usr/bin/perl -wn

use strict;

our @b=(0x80, 0x40, 0x20, 0x10, 8, 4, 2, 1);
our $i=0;

for (split"") {
    my $b = ord;
    printf "%02x\n", $i/8 unless $i%8;
    printf "%04x %02x ", $i, $b;
    print($_?"#":".") for map { $b & $_ } @b;
    print "\n";
    ++$i;
}
