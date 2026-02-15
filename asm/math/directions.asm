
bounce_from_south_edge:
    cmp #$80
    bne :+
    lda #0
    RTS
:
    eor #$7f
    clc
    adc #1
    RTS

bounce_from_north_edge:
    cmp #0
    bne :+
    lda #$80
    RTS
:
    eor #$7f
    clc
    adc #1
    RTS
