
players_move:
    ldx #$03

@each_player:
    lda joysticks,x
    eor #$1f
    and #$0c                ; 4 = left; 8 = right
    beq @straight_ahead     ; direction did not change
; change direction
    and #$08
    beq @turn_left
    lda #$04 ; turn right
    jmp @change_direction
@turn_left:
    lda #$fc
@change_direction:
    clc
    adc plane_direction,x
    jsr set_plane_direction

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
    inc $d000 + 8, x
    lsr
    tax
    jmp @x_done

@decrease_x:
    adc plane_x_fragment, x
    sta plane_x_fragment, x
    bcs @x_done
    txa
    asl
    tax
    dec $d000, x
    dec $d000 + 8, x
    lsr
    tax

@x_done:
    clc
    lda plane_dy, x
    bmi @decrease_y
; increase y
    adc plane_y_fragment, x
    sta plane_y_fragment, x
    bcc @y_done
    txa
    asl
    tax
    inc $d001, x
    inc $d001 + 8, x
    lsr
    tax
    jmp @y_done

@decrease_y:
    adc plane_y_fragment, x
    sta plane_y_fragment, x
    bcs @y_done
    txa
    asl
    tax
    dec $d001, x
    dec $d001 + 8, x
    lsr
    tax

@y_done:
    dex
    bmi @all_done
    jmp @each_player

@all_done:
    RTS

set_plane_direction: ; x = plane number 0-3; a = new direction 0 (North) - FF (1 degree West of North)
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
    bcs @west; 0-$7f = "East"
    cmp #$40
    bcs @south_east; 0-3f = "NorthEast"
; "NorthEast"
    tay
    lda coordinate_of_angle, y
    sta plane_dx, x ; as is: the more off of north, the faster we go east
    tya
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative opposite: we go north the slower the faster we go east
    sta plane_dy, x
    RTS

@south_east: ; 40-7f
    and #$3f
    tay
    lda coordinate_of_angle, y
    sta plane_dy, x ; as is: the more toward south, the faster we go south
    tya
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    sta plane_dx, x
    RTS

@west:
    cmp #$c0
    bcs @north_west
; 80-9f = "SouthWest"
    and #$3f
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative: go west
    sta plane_dx, x
    tya
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    sta plane_dy, x
    RTS

@north_west: ; a0-ff
    and #$3f
    tay
    lda coordinate_of_angle, y
    eor #$80 ; negative opposite: the more toward north, the slower we go west
    sta plane_dx, x
    tya
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    eor #$80 ; negative opposite: the more toward north, the faster we go north
    sta plane_dy, x
    RTS
