
check_deaths:
    ldy #$03
@next_primary_plane:
    lda plane_alive, y
    beq @primary_checked
    tya
    tax
    dex
@check_primary_vs_secondary_plane:
    lda plane_alive, x
    beq @checked
; check vertical proximity
    lda plane_y, y
    sec
    sbc plane_y, x
    bcs :+
    eor #$ff
:
    lsr
    lsr
    lsr
    bne @checked ; not within +/- 8 pixels vertically
; check horizontal proximity
    lda plane_x_lo, y
    sec
    sbc plane_x_lo, x
    bcs :+
    eor #$ff
:
    lsr
    lsr
    lsr
    bne @checked ; not within +/- 8 pixels horizontally
; check depth proximity
    lda plane_z, y
    sec
    sbc plane_z, x
    bcs :+
    eor #$ff
:
    lsr
    lsr
    lsr
    bne @checked ; not within +/- 8 pixels in depth
@collision:
    tya
    pha
    jsr plane_explode
    pla
    tax
    jsr plane_explode
@checked:
    dex
    bpl @check_primary_vs_secondary_plane
@primary_checked:
    dey
    bne @next_primary_plane
    RTS

plane_explode:
    lda #0
    sta plane_alive, x
    sta $D027, x
    jmp sound_explosion
