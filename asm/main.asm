; flight.asm
.feature pc_assignment

; zeropage resources
screen_drawing_round_counter = 2
sprite_tmp = $2a
sound_buffer = $52
swap = 3
multiplication_lo = 3
multiplication_factor = 4
joysticks = $FB
joystick_switch_bit = 5
map_tile_pointer = 5

start:
    lda #$9b             ; grey
    jsr $ffd2
    lda #$93             ; clear screen
    jsr $ffd2
    lda #0
    sta $d020
    sta $d021
    sta $cc ; show cursor
input_planet_name:
    ldx #10
    ldy #2
    clc
    jsr $e50a
    lda #<planet_name_prompt
    ldy #>planet_name_prompt
    jsr $ab1e ; print prompt
    lda #<planet_name
    ldy #>planet_name
    jsr $ab1e ; print input
input_character:
    jsr $f13e
    beq input_character
    cmp #$0d
    beq input_complete
    cmp #$14
    bne check_input_character
erase_last_character:
    ldy planet_name_length
    beq input_character
    dey
    sty planet_name_length
    lda #0
    sta planet_name, y
    lda #$14
    jsr $ffd2 ; backspace
    jmp input_planet_name
check_input_character:
    cmp #$5b
    bcs input_character
    cmp #$41
    bcs input_character_ok
    cmp #$3a
    bcs squash_input_character
    cmp #$30
    bcs input_character_ok
squash_input_character:
    ldy planet_name_length
    beq input_character ; not as first letter
    dey
    ldx planet_name, y
    cpx #$30
    bcc input_character ; no multiple dashes
    lda #$20
input_character_ok:
    ldy planet_name_length
    cpy #planet_name_max_length
    bcs input_character
    sta planet_name, y
    inc planet_name_length
    jmp input_planet_name
input_complete:
    ldy planet_name_length
    beq input_character
    dey
    lda planet_name, y
    cmp #$30
    bcc erase_last_character
    sta $cc ; hide cursor

    lda #$90             ; black
    jsr $ffd2
    lda #$93             ; clear screen
    jsr $ffd2

    jsr chars_init
    jsr map_init
    jsr joys_init
    jsr planes_init
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
    jsr sound_explosion
    RTS
debug_loop:
    lda #$13             ; home
    jsr $ffd2
    ldx #$00
    ldy #$00
@print_4_hex_row:
    lda #$9a             ; light blue
    jsr $ffd2
    lda debug_data, x
    jsr print_hex
    inx
    lda #$96             ; pink
    jsr $ffd2
    lda debug_data, x
    jsr print_hex
    inx
    lda #$99             ; light green
    jsr $ffd2
    lda debug_data, x
    jsr print_hex
    inx
    lda #$9e             ; yellow
    jsr $ffd2
    lda debug_data, x
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

    lda debug_names_hi, y ; was this the last debug line to print?
    bne @print_4_hex_row
    lda sound_buffer
    jsr print_hex
    lda screen_drawing_round_counter
@wait_for_next_screen_draw:
    cmp screen_drawing_round_counter
    beq @wait_for_next_screen_draw
    jmp debug_loop
    rts

joys_irq:
    lda $d020
    pha
    lda #4
    ldx $d012
@wait_for_next_raster_line_1:
    cpx $d012
    beq @wait_for_next_raster_line_1
    sta $d020

    cld
    jsr joys_read
    jsr players_move
    jsr check_deaths
    jsr update_plane_sounds

    inc screen_drawing_round_counter

    pla
    ldx $d012
@wait_for_next_raster_line_2:
    cpx $d012
    beq @wait_for_next_raster_line_2
    sta $d020

    ASL $D019            ; acknowledge the interrupt by clearing the VIC's interrupt flag
    JMP $EA31            ; jump into KERNAL's standard interrupt service routine to handle keyboard scan, cursor display etc.

; include independent support files before files that depend on them
.include "sound/all.asm"
.include "math/all.asm"
.include "chars.asm"
.include "map.asm"
.include "joysticks-cga.asm"
.include "players-move.asm"
.include "death.asm"
.include "plane-sprites.asm"
.include "print.asm"

.include "data/all.asm"
.include "../graphics/all.asm"

bss:
.bss

; each written data area consecutively after loaded file
map_tile_heights = bss

currently_used_bss_end = bss + map_tiles_total_count ; next data area can start here
