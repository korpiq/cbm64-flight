
sound_explosion:
    lda #0
    sta $D40B ; turn sound#2 off
    lda #$0c
    sta $D40C ; attack+decay
    lda #0
    sta $D40D ; sustain+release
    lda #0
    sta $D407
    lda #6
    sta $d408
    lda #$81
    sta $D40B ; turn sound#2 on

    RTS
