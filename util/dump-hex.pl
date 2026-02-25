#!/usr/bin/perl -wn

use strict;

our @b=(0x80, 0x40, 0x20, 0x10, 8, 4, 2, 1);
our $i=0;

for (split"") {
    my $b = ord;
    printf "\$%02x%s", $b, ((++$i % 8) ? ", " : "\n");
}
