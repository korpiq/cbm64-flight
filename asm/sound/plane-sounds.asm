
start_plane_sounds:
    lda #$bb
    sta $d405 ; Attack&Decay
    lda #$8b
    sta $d406 ; Sustain&Release
    lda #$10
    sta $d401
    rts

update_plane_sounds:
    ldx #$03
    lda #0
@loop:
    eor joysticks, x
    dex
    bpl @loop
    sta sound_buffer
    cmp #0
    bne @play_sound
    lda #$80
    sta $d404 ; turn off the noise
    rts

@play_sound:
    adc #$40
    sta sound_buffer
    sta $d401
    lda #$81
    sta $d404 ; turn on the noise
    rts
