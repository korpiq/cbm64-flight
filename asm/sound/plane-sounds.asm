
start_plane_sounds:
    lda #$0f
    sta $d418
    lda #$4a
    sta $d405 ; Attack&Decay
    lda #$24
    sta $d406 ; Sustain&Release
    lda #$10
    sta $d401
    lda #$81
    sta $d404 ; turn on the noise
    rts

update_plane_sounds:
    ldx #$03
    lda #$0
@loop:
    adc joysticks, x
    dex
    bpl @loop
    asl
    asl
    asl
    sta $d401
    rts
