; flight.asm
.feature pc_assignment

.export start

; zeropage resources
screen_drawing_round_counter = $02
player_sprite_offset = $03
sound_buffer = $04

*=$0801
.word * ; first two bytes of a PRG file: starting memory address to load rest of the file at
*=$0801
.byte 11, 8, 221, 49, 158, 50, 48, 54, 49, 0, 0, 0 ; SYS2061
*=2061
start:
    jsr planes_init
    jsr joys_init
    jsr sound_init
    jsr start_plane_sounds
    sei ; avoid blinking caused by interrupts
    LDA #%01111111
    STA $DC0D            ; switch off interrupt signals from CIA-1
    AND $D011            ; clear most significant bit of VIC's raster register
    STA $D011
    STA $DC0D            ; acknowledge pending interrupts from CIA-1
    STA $DD0D            ; acknowledge pending interrupts from CIA-2
    LDA #$FF             ; set rasterline where interrupt shall occur
    STA $D012
    lda #<joys_irq       ; set interrupt vectors
    sta $0314
    lda #>joys_irq
    sta $0315
    LDA #%00000001       ; enable raster interrupt signals from VIC
    STA $D01A
    cli
    lda #$93             ; home
    jsr $ffd2
debug_loop:
    lda #$13             ; home
    jsr $ffd2
    ldx #$00
    ldy #$00
@print_4_hex_row:
    lda #$9a             ; light blue
    jsr $ffd2
    lda joysticks, x
    jsr print_hex
    inx
    lda #$96             ; pink
    jsr $ffd2
    lda joysticks, x
    jsr print_hex
    inx
    lda #$99             ; light green
    jsr $ffd2
    lda joysticks, x
    jsr print_hex
    inx
    lda #$9e             ; yellow
    jsr $ffd2
    lda joysticks, x
    jsr print_hex
    inx

    ; next we print title of this debug data row
    lda #$9b             ; grey
    jsr $ffd2
    txa
    pha ; save X until string printed
    tya
    pha ; save Y until string printed
    lda debug_names_lo, y
    pha
    lda debug_names_hi, y
    tay
    pla
    jsr $ab1e ; print debug name of row
    lda #$0d ; newline
    jsr $ffd2
    pla ; restore y after printing
    tay
    iny
    pla ; restore x after printing
    tax

    cpy #$0d
    bne @print_4_hex_row
    lda sound_buffer
    jsr print_hex
@wait_for_next_screen_draw:
    lda $d012
    bne @wait_for_next_screen_draw
    lda $d011
    and #$80
    bne @wait_for_next_screen_draw
    jmp debug_loop
    rts

joys_irq:
    ; black line where our irq is called
    lda $d020
    pha
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
    lda #$0f
    sta $d020

    cld
    jsr joys_read
    jsr players_move
    jsr update_plane_sounds

    inc screen_drawing_round_counter

    ; black line where our irq is called
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
    pla
    sta $d020

    ASL $D019            ; acknowledge the interrupt by clearing the VIC's interrupt flag
    JMP $EA31            ; jump into KERNAL's standard interrupt service routine to handle keyboard scan, cursor display etc.

.include "joysticks-cga.asm"
.include "players-move.asm"
.include "plane-sprites.asm"
.include "print.asm"
.include "sound/all.asm"

.include "data/all.asm"
.bss
