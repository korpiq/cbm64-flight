#!/usr/bin/perl -wn

use strict;

our @b=(0x80, 0x40, 0x20, 0x10, 8, 4, 2, 1);
our $i=0;
our (@bytes, @bitmap, $x, $y);

sub reset_row_data () {
    @bytes=();
    @bitmap=();
    $x=$y=0;
}

sub print_row () {
        printf "%04x", $i;
        printf " %02x", $_ for @bytes;
        printf "  %s\n", join "", @bitmap;
}

for (split"") {
    my $b = ord;
    if (!$i/64) {
        print_row();
        printf "Sprite # %02x\n", $i/64;
        reset_row_data();
    }
    push @bytes, $b;
    push @bitmap, ($_?"#":".") for map { $b & $_ } @b;
    push @bitmap, ' ';
    if (++$x>2) {
        print_row();
        reset_row_data();
    }
    ++$i;
}
