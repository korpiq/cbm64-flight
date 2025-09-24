; flight.asm
.feature pc_assignment

.export start

*=$0801
.word * ; first two bytes of a PRG file: starting memory address to load rest of the file at
*=$0801
.byte 11, 8, 221, 49, 158, 50, 48, 54, 49, 0, 0, 0 ; SYS2061
*=2061
start:
    jsr planes_init
    jsr joys_init
    sei ; avoid blinking caused by interrupts
    LDA #%01111111
    STA $DC0D            ; switch off interrupt signals from CIA-1
    AND $D011            ; clear most significant bit of VIC's raster register
    STA $D011
    STA $DC0D            ; acknowledge pending interrupts from CIA-1
    STA $DD0D            ; acknowledge pending interrupts from CIA-2
    LDA #$A0             ; set rasterline where interrupt shall occur
    STA $D012
    lda #<joys_irq       ; set interrupt vectors
    sta $0314
    lda #>joys_irq
    sta $0315
    LDA #%00000001       ; enable raster interrupt signals from VIC
    STA $D01A
    cli
    rts

joys_irq:
    ; black line where our irq is called
    ldy $d020
    ldx #$00
    lda $d012
@wait1:
    cmp $d012
    beq @wait1
    stx $d020
    lda $d012
@wait2:
    cmp $d012
    beq @wait2
    sty $d020

    cld
    jsr joys_read
    jsr players_move

    ; black line where our irq is called
    ldy $d020
    ldx #$00
    lda $d012
@wait3:
    cmp $d012
    beq @wait3
    stx $d020
    lda $d012
@wait4:
    cmp $d012
    beq @wait4
    sty $d020

    ASL $D019            ; acknowledge the interrupt by clearing the VIC's interrupt flag
    JMP $EA31            ; jump into KERNAL's standard interrupt service routine to handle keyboard scan, cursor display etc.

.include "joysticks-cga.asm"
.include "players-move.asm"
.include "plane-sprites.asm"

.include "data/all.asm"
.bss
