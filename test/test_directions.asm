
test_directions:
    lda #<@title
    ldy #>@title
    jsr $ab1e

    lda #$80
    jsr @print_a
    jsr bounce_from_south_edge
    ldx #$0
    jsr @check_a_matches_x
    jsr bounce_from_north_edge
    ldx #$80
    jsr @check_a_matches_x

    lda #$81
    jsr @print_a
    jsr bounce_from_south_edge
    ldx #$ff
    jsr @check_a_matches_x
    jsr bounce_from_north_edge
    ldx #$81
    jsr @check_a_matches_x

    lda #$82
    jsr @print_a
    jsr bounce_from_south_edge
    ldx #$fe
    jsr @check_a_matches_x
    jsr bounce_from_north_edge
    ldx #$82
    jsr @check_a_matches_x

    lda #$7f
    jsr @print_a
    jsr bounce_from_south_edge
    ldx #$1
    jsr @check_a_matches_x
    jsr bounce_from_north_edge
    ldx #$7f
    jsr @check_a_matches_x
    RTS

@check_a_matches_x:
    stx @expect
    jsr @print_a_equals_x
    cmp @expect
    bne @fail
    pha
    inc test_number
    lda #<@ok
    ldy #>@ok
    jsr $ab1e
    pla
    RTS

@print_a:
    pha
    jsr print_hex
    lda #<@mirrored
    ldy #>@mirrored
    jsr $ab1e
    pla
    rts

@print_a_equals_x:
    pha
    jsr print_hex
    txa
    pha
    lda #<@equals
    ldy #>@equals
    jsr $ab1e
    pla
    jsr print_hex
    pla
    rts

@fail:
    lda #<@failed
    ldy #>@failed
    jsr $ab1e
    pla
    pla
    RTS

@expect: .byte 0
@mirrored: .byte "mirrored is ", 0
@equals: .byte "= ", 0
@title: .byte "1. test directions:\n- bounce from edges\n", 0
@failed: .byte "test failed\n", 0
@ok: .byte "ok\n", 0
