.feature pc_assignment, string_escapes

.export start_tests
; program file
*=$0801
.word * ; first two bytes of a PRG file: starting memory address to load rest of the file at
*=$0801
.byte 11, 8, 221, 49, 158, 50, 48, 54, 49, 0, 0, 0 ; SYS2061
*=2061

start_tests:
    lda #<string_tests_starting
    ldy #>string_tests_starting
    jsr $ab1e

    jsr test_tile_addressing

    lda #<string_tests_done
    ldy #>string_tests_done
    jsr $ab1e
    RTS

string_tests_starting: .byte "starting tests\n", 0
string_tests_done: .byte "tests done\n", 0

.include "tile-addressing-test.asm"
.include "../asm/main.asm"
