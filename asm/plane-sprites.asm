
.code

planes_init:

    lda #$00  ; set bits off
    sta $d010 ; x high bit
    sta $d017 ; y expansion
    sta $d01b ; behind text
    sta $d01d ; x expansion
    lda #$0f
    sta $d01c ; multicolor
    lda #12
    sta $d025
    lda #15
    sta $d026

    ldx #$00
@sprite_shapes_loop: ; sprites must begin at $40 boundary
    lda plane_sprites, x
    sta sprites_data, x
    lda plane_sprites + $0100, x
    sta sprites_data + $0100, x
    lda plane_sprites + $0200, x
    sta sprites_data + $0200, x
    lda plane_sprites + $0300, x
    sta sprites_data + $0300, x
    lda ball_sprites, x
    sta sprites_data + $0400, x
    lda ball_sprites + $0100, x
    sta sprites_data + $0500, x
    inx
    bne @sprite_shapes_loop
; initialize plane variables
    lda #plane_alive_initial
    ldx #3
:
    sta plane_alive, x
    dex
    bpl :-
    lda #plane_speed_initial
    ldx #3
:
    sta plane_speed, x
    dex
    bpl :-
    lda #plane_z_initial
    ldx #3
:
    sta plane_z, x
    dex
    bpl :-
    ldx #3
:
    lda plane_directions_initial, x
    sta plane_direction, x
    dex
    bpl :-

    ldx #$03
@loop4: ; set plane locations
    txa
    asl
    tay
    lda planes_init_loc, y
    sta plane_x_lo, x
    lda #$00
    sta plane_x_hi_bit, x
    lda planes_init_loc + 1, y
    sta plane_y, x
    dex
    bpl @loop4

    lda #$ff  ; set bits on
    sta $d015 ; enabled

    ldx #$07
@loop8: ; set for VIC-II sprite locations, colors, and shape pointers
    lda planes_init_loc, x
    sta $d000, x
    lda planes_init_color, x
    sta $d027, x
    lda planes_init_shape_ptr, x
    sta sprite_pointers, x
    txa
    pha
    lda plane_direction, x
    jsr set_plane_direction
    pla
    tax
    dex
    bpl @loop8


    RTS
