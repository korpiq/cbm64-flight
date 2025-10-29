
sound_init:
    lda #0
    tax
@loop:
    sta $d400, x
    inx
    cpx #$25
    bne @loop
    lda #$0f
    sta $d418 ; turn volume up to fefeven
    rts
