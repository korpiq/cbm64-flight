#!/bin/bash

NAME=${NAME:-cbm64-flight-4-players}
FILE="build/$NAME.prg"
DISK="build/$NAME.d64"

mkdir -p build
ca65 -t c64 -l build/main.lst -o build/main.o asm/main.asm
ld65 -C ld65/c64.cfg -o "$FILE" build/main.o -m build/main.map
c1541 -format korpiq-flight,kq d64 "$DISK" -attach "$DISK" -write "$FILE" flight
