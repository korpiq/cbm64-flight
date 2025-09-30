
.feature c_comments

players_move:
    ldx #$03
    ldy #$06

@each_player:
    stx player_move_counter
    sty player_sprite_offset
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
    ldy player_sprite_offset

@straight_ahead:
    clc
    lda plane_dx, x
    bmi @decrease_x
; increase x
    adc plane_x_fragment, x
    sta plane_x_fragment, x
    bcc @x_done
; move sprite
    inc plane_x_lo, x
    bne :+
    lda plane_x_hi_bit, x
    eor #$01
    sta plane_x_hi_bit, x
:
    lda plane_x_lo, x
    sta $d000, y
    bne @after_x_increased
; move plane and shadow sprites right over 8 bit boundary
    lda sprite_pair_bits_by_index, x
    eor $d010
    sta $d010
@after_x_increased:
    jmp @x_done

@decrease_x:
    clc
    adc plane_x_fragment, x
    sta plane_x_fragment, x
    bcs @x_done ; adding to two's complement sets carry unless sum is negative
; move sprite
    lda plane_x_lo, x
    sec
    sbc #$01
    sta plane_x_lo, x
    bcs @decrease_sprite_x
    lda plane_x_hi_bit, x
    eor #$01
    sta plane_x_hi_bit, x
@decrease_sprite_x:
    lda plane_x_lo, x
    sta $d000, y

    bne @after_x_decreased
; move plane and shadow sprites left over 8 bit boundary
    lda sprite_pair_bits_by_index, x
    eor $d010
    sta $d010
    lda plane_x_hi_bit, x
    eor #$01
    sta plane_x_hi_bit, x
@after_x_decreased:

@x_done:
    clc
    lda plane_dy, x
    bmi @decrease_y
; increase y
    adc plane_y_fragment, x
    sta plane_y_fragment, x
    bcc @y_done
    inc plane_y, x
    lda plane_y, x
    sta $d001, y
    jmp @y_done

@decrease_y:
    adc plane_y_fragment, x
    sta plane_y_fragment, x
    bcs @y_done
    dec plane_y, x
    lda plane_y, x
    sta $d001, y

@y_done:
; place shadow
    lda plane_x_lo, x
    sta $d008, y
    lda plane_y, x
    adc #$08
    sta $d009, y
    dey
    dey
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
    adc #$01 ; range 0..-127 instead of 0..-128
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
    adc #$01 ; range 0..-127 instead of 0..-128
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
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dy, x
    tya
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative: go west
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dx, x
    RTS
