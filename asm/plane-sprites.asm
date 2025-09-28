
.code

planes_init:

    lda #$00  ; set bits off
    sta $d010 ; x high bit
    sta $d017 ; y expansion
    sta $d01b ; behind text
    sta $d01c ; multicolor
    sta $d01d ; x expansion

    ldx #$00
@sprite_shapes_loop: ; sprites must begin at $40 boundary
    lda plane_sprites, x
    sta planes_shapes_data, x
    lda plane_sprites + $0100, x
    sta planes_shapes_data + $0100, x
    lda plane_sprites + $0200, x
    sta planes_shapes_data + $0200, x
    lda plane_sprites + $0300, x
    sta planes_shapes_data + $0300, x
    inx
    bne @sprite_shapes_loop

    ldx #$07
@loop8: ; set for VIC-II sprite locations, colors, and shape pointers
    lda planes_init_loc, x
    sta $d000, x
    lda plane_shadows_init_loc, x
    sta $d000 + 8, x
    lda planes_init_color, x
    sta $d027, x
    lda planes_init_shape_ptr, x
    sta $07f8, x
    txa
    pha
    lda plane_direction, x
    jsr set_plane_direction
    pla
    tax
    dex
    bpl @loop8

    lda #$ff  ; set bits on
    sta $d015 ; enabled

    RTS
