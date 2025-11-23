#!/bin/bash

set -e

NAME=${NAME:-cbm64-flight-4-players}
FILE="build/test.prg"

mkdir -p build
ca65 -t c64 -l build/test.lst -o build/test.o test/test.asm
ld65 -C ld65/c64.cfg -o "$FILE" build/test.o -m build/test.map
x64 "$FILE"
