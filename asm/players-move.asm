
.feature c_comments

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
    lda #$02 ; turn right
    jmp @change_direction
@turn_left:
    lda #$fe
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
    inc $d000 + 8, x
    inc $d000, x
    bne @after_x_increased
    lda sprite_bits_by_double_index, x
    eor $d010
    sta $d010
    txa
@after_x_increased:
    lsr
    tax
    jmp @x_done

@decrease_x:
    adc #$01 ; -1 = 0 so west is west and north is north
    clc
    adc plane_x_fragment, x
    sta plane_x_fragment, x
    bcs @x_done
    txa
    asl
    tax
    dec $d000 + 8, x
    dec $d000, x
    bne @after_x_decreased
    lda sprite_bits_by_double_index, x
    eor $d010
    sta $d010
    txa
@after_x_decreased:
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
    sta plane_dx, x
    tya
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative: go north
    sta plane_dy, x
    RTS

@south_east: ; 40-7f
    and #$3f
    tay
    lda coordinate_of_angle, y
    sta plane_dy, x
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
    eor #$ff ; negative: go north
    sta plane_dy, x
    tya
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative: go west
    sta plane_dx, x
    RTS
