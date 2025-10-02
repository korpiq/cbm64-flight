
sound_init:
    lda #0
    tax
@loop:
    sta $d400, x
    inx
    cpx #$25
    bne @loop
    rts
