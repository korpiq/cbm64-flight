
players_move:
    ldx #$03
@each_player:
    lda joysticks,x
    eor #$0f
    and #$0c
    beq @straight_ahead
    asl
    sbc #$0c
    adc plane_direction,x
    sta plane_direction,x

; set plane and shadow sprites point to correct direction
    lsr
    lsr
    lsr
    lsr
    ora #$80
    sta sprite_pointers, x
    sta sprite_pointers + 4, x

@straight_ahead:
    dex
    bpl @each_player

    RTS
