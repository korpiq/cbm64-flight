.feature pc_assignment

.export start
; program file
*=$0801
.word * ; first two bytes of a PRG file: starting memory address to load rest of the file at
*=$0801
.byte 11, 8, 221, 49, 158, 50, 48, 54, 49, 0, 0, 0 ; SYS2061
*=2061

.include "main.asm"

