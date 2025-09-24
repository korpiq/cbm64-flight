
players_move:
    ldx #$03

@each_player:
    lda joysticks,x
    eor #$0f
    and #$0c
    beq @straight_ahead ; direction did not change
; change direction
    asl
    sbc #$0c
    adc plane_direction,x
    sta plane_direction,x
; set plane and shadow sprites point to correct direction
    tay
    lsr
    lsr
    lsr
    lsr
    ora #$80
    sta sprite_pointers, x
    sta sprite_pointers + 4, x
    tya

; update dx and dy according to new direction
; (not accommodating speed just yet)
    cmp #$80
    bcc @west; 0-$7f = "East"
    cmp #$40
    bcc @south_east
; "NorthEast"
    and #$3f
    tay
    lda coordinate_of_angle, y
    sta plane_dx, x
    eor #$ff
    sta plane_dy, x
    jmp @delta_done
@south_east:
    cmp #$80
    bcc @west
    and #$3f
    tay
    lda coordinate_of_angle, y
    sta plane_dx, x
    sta plane_dy, x
    jmp @delta_done
@west:
    cmp #$a0
    bcc @north_west
    and #$3f
    tay
    lda coordinate_of_angle, y
    sta plane_dy, x
    eor #$ff
    sta plane_dx, x
    jmp @delta_done
@north_west:
    and #$3f
    tay
    lda coordinate_of_angle, y
    eor #$ff
    sta plane_dx, x
    sta plane_dy, x

@delta_done:

@straight_ahead:
    clc
    lda plane_dx, x
    bmi @decrease_x
; increase x
    adc plane_x_fragment, x
    sta plane_x_fragment, x
    bcc @x_done
    txa
    asl
    tax
    inc $d000, x
    jmp @x_done
@decrease_x:
    adc plane_x_fragment, x
    sta plane_x_fragment, x
    bcs @x_done
    txa
    asl
    tax
    dec $d000, x

@x_done:
; TODO: y
@y_done:
    dex
    bmi @all_done
    jmp @each_player

@all_done:
    RTS
