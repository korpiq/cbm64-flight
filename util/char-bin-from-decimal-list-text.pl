#!/usr/bin/perl -wn

# read list of decimal numbers (each presumably at least 0 and less than 256)
# output a byte for each number

use strict;

chomp;
s/\s+//g;
print pack("C", $_) for grep { $_ >= 0 } split /\D+/;
