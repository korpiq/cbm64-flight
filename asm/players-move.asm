
.feature c_comments

players_move:
    lda #0
    sta $d001 + 2 * 4
    ldx #$03
    ldy #$06

@each_player:
    lda plane_alive, x
    bne @move_player

@next_player:
    dey
    dey
    dex
    bmi @players_moved
    jmp @each_player

@players_moved:
    lda screen_drawing_round_counter
    and #$01
    tax
    ldy #$06
    jsr place_shadow
    lda screen_drawing_round_counter
    and #$01
    ora #$02
    tax
    ldy #$07
    jmp place_shadow

@move_player:
    lda plane_speed, x
    sec
    cmp #$10
    bcc @stalling
    lda joysticks, x
    and #$10
    bne @check_horizontal_activities
; button being pressed
    txa
    and screen_drawing_round_counter
    bne @speed_up
    jsr animate_exhaust
@speed_up:
    inc plane_speed, x
    bne @check_horizontal_activities
    dec plane_speed, x
@check_horizontal_activities:
    lda joysticks, x
    eor #$1f
    and #$0c                          ; 4 = left; 8 = right
    beq @check_vertical_activities    ; horizontal direction did not change
; change direction
    and #$08
    beq @turn_left
    lda #$02 ; turn right
    jmp @change_direction
@turn_left:
    lda #$fe
@change_direction:
    clc
    adc plane_direction, x ; ok to roll around from ff (north-northwest) to 0 (north)
    sta plane_direction, x

@check_vertical_activities:
    lda joystick_last_pressed_ticks_down, x
    beq @check_vertical_direction
; joystick was pressed down and released
    pha
    lda #0
    sta joystick_last_pressed_ticks_down, x
    pla
    and #$f8
    bne @check_vertical_direction
; joystick was tapped down shortly
    lda plane_speed, x
    sbc #$04
    sta plane_speed, x
    jmp @move_ahead

@check_vertical_direction:
    lda joysticks, x
    and #$03
    eor #$03
    beq @halve_vertical_direction ; stick in the middle, so straighten up
    and #$02
    beq @turn_down
; turn up fast until slowing down higher up "in thin athmosphere" to avoid hitting "roof" abruptly
    lda plane_z, x
    cmp #$61
    bmi @turn_up_fast
    cmp #$7e
    bmi @turn_up_slow
 ; "hit roof" – stall "because of going too high"
    lda #$00
    sta plane_speed, x
    lda #$80
    jmp @set_vertical_direction
@turn_up_slow:
    and #$1f
    eor #$1f
    lsr
    jmp @set_vertical_direction
@turn_up_fast:
    lda #$40
    jmp @set_vertical_direction
@turn_down:
    lda #$c0
    jmp @set_vertical_direction

@stalling:
    lda plane_direction, x
    adc #$04
    sta plane_direction, x
    lda joysticks, x
    eor #$1f
    and #$01
    beq @move_ahead ; keep stalling unless turning joystick up = nose down
    lda joysticks, x
    eor #$1f
    and #$0c
    beq @move_ahead ; keep stalling unless turning to side
    lda #$80
    sta plane_speed, x

@halve_vertical_direction:
    lda plane_dz, x
    bmi @halve_vertical_direction_down
    lsr
    jmp @set_vertical_direction
@halve_vertical_direction_down:
    sec
    ror

@set_vertical_direction:
    sta plane_dz, x

@move_ahead:
    jsr set_plane_horizontal_direction
    jsr move_plane_ahead
    jsr move_plane_ahead

; pollute map
    txa
    pha
    tya
    pha
    lda #$d8
    sta map_tile_pointer + 1
    lda plane_y, x
    tay
    lda plane_x_lo, x
    pha
    lda plane_x_hi_bit, x
    tax
    pla
    jsr sprite_char_pos
; check that it points on screen
    lda map_tile_pointer + 1
    cmp #$d8
    bcc @polluted
    cmp #$db
    bcc :+
    bne @polluted
    lda map_tile_pointer
    cmp #$e8
    bcs @polluted
:
    ldx #0
    lda #11
    sta (map_tile_pointer,x)
@polluted:
    pla
    tay
    pla
    tax

    jmp @next_player

place_shadow: ; x = plane number 0-3; y = shadow sprite number 4-7
    lda sprite_pointers, x ; shape
    sta sprite_pointers, y
    lda plane_x_hi_bit, x
    bne @shadow_right
    lda bit_by_index, y
    eor #$ff
    and $d010
    sta $d010
    jmp @set_shadow_position
@shadow_right:
    lda bit_by_index, y
    ora $d010
    sta $d010
@set_shadow_position:
    tya
    asl
    tay
    lda plane_x_lo, x
    sta $d000, y
    lda plane_y, x
    sta $d001, y
    RTS

move_plane_ahead: ; x = plane number 0-3, y = plane sprite offset
    clc
    lda plane_dx, x
    bmi @decrease_x
; increase x
    adc plane_x_fragment, x
    sta plane_x_fragment, x
    bcc @x_done
; move sprite right
    lda plane_x_lo, x
    clc
    adc #$01
    sta plane_x_lo, x
    sta $d000, y
    bcc @x_done
    lda plane_x_hi_bit, x
    eor #$01
    sta plane_x_hi_bit, x
; move plane right over 8 bit boundary
    lda bit_by_index, x
    eor $d010
    sta $d010
    jmp @x_done

@decrease_x:
    adc plane_x_fragment, x
    sta plane_x_fragment, x
    bcs @x_done ; adding to two's complement sets carry unless sum is negative
; move sprite
    lda plane_x_lo, x
    sec
    sbc #$01
    sta plane_x_lo, x
    sta $d000, y
    bcs @set_y_position
    lda plane_x_hi_bit, x
    eor #$01
    sta plane_x_hi_bit, x
; move plane sprite left over 8 bit boundary
    lda bit_by_index, x
    eor $d010
    sta $d010
@x_done:
    clc
    lda plane_dy, x
    bmi @decrease_y
; increase y
    adc plane_y_fragment, x
    sta plane_y_fragment, x
    bcc @set_y_position
    inc plane_y, x
    lda plane_y, x
    cmp #$ef
    bcc @set_y_position
    sbc #$c8
    sta plane_y, x
    bne @set_y_position ; should always jump

@decrease_y:
    adc plane_y_fragment, x
    sta plane_y_fragment, x
    bcs @set_y_position
    dec plane_y, x
    lda plane_y, x
    cmp #$25
    bcs @set_y_position
    adc #$c8
    sta plane_y, x

@set_y_position:    ; always update y position, because height might have changed
    lda plane_z, x
    lsr
    lsr
    lsr
    eor #$ff
    clc
    adc #1
    adc plane_y, x
    sta $d001, y

@y_done:
    lda plane_dz, x
    bmi @decrease_z
; increase z
    clc
    adc plane_z_fragment, x
    sta plane_z_fragment, x
    bcc @end_move
    inc plane_z, x
    dec plane_speed, x ; climbing slows us down
    lda plane_speed, x
    cmp #$10
    bcs @end_move ; not stalling
; starts stalling
    lda #$80
    sta plane_dz, x

    RTS

@decrease_z:
    clc
    adc plane_z_fragment, x
    sta plane_z_fragment, x
    bcs @end_move
    dec plane_z, x
    bne :+
    jmp plane_explode
:
    lda plane_speed, x
    cmp #$10
    bcc @end_move   ; speed does not increase while stalling
    inc plane_speed, x ; descent speeds us up
    bne @end_move
    dec plane_speed, x

@end_move:
    RTS

set_plane_direction: ; initialization for now
set_plane_horizontal_direction: ; x = plane number 0-3; A, Y preserved
    pha
    tya
    pha
    lda plane_direction, x
; set plane and shadow sprites point to correct direction
    tay
    lsr
    lsr
    lsr
    lsr
    clc
    adc #(plane_sprite_number)
    sta sprite_pointers, x
    tya

; update dx and dy according to new direction
    cmp #$80
    bcs @west; 0-$7f = "East"
    cmp #$40
    bcs @south_east; 0-3f = "NorthEast"
; "NorthEast"
    pha
    lda coordinate_of_angle, y
    sta plane_dx_unit, x
    ldy plane_speed, x
    jsr multiply_a8_y8_to_ay
    tya
    sta plane_dx, x
    pla
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative: go north
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dy_unit, x
    lda coordinate_of_angle, y
    ldy plane_speed, x
    jsr multiply_a8_y8_to_ay
    tya
    eor #$ff ; negative: go north
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dy, x
    jmp @done

@south_east: ; 40-7f
    and #$3f
    pha
    tay
    lda coordinate_of_angle, y
    sta plane_dy_unit, x
    ldy plane_speed, x
    jsr multiply_a8_y8_to_ay
    tya
    sta plane_dy, x
    pla
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    sta plane_dx_unit, x
    ldy plane_speed, x
    jsr multiply_a8_y8_to_ay
    tya
    sta plane_dx, x
    jmp @done

@west:
    cmp #$c0
    bcs @north_west
; 80-9f = "SouthWest"
    and #$3f
    pha
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative: go west
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dx_unit, x
    lda coordinate_of_angle, y
    ldy plane_speed, x
    jsr multiply_a8_y8_to_ay
    tya
    eor #$ff ; negative: go west
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dx, x
    pla
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    sta plane_dy_unit, x
    ldy plane_speed, x
    jsr multiply_a8_y8_to_ay
    tya
    sta plane_dy, x
    jmp @done

@north_west: ; a0-ff
    and #$3f
    pha
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative: go north
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dy_unit, x
    lda coordinate_of_angle, y
    ldy plane_speed, x
    jsr multiply_a8_y8_to_ay
    tya
    eor #$ff ; negative: go north
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dy, x
    pla
    eor #$3f ; index of coordinate of opposite angle
    tay
    lda coordinate_of_angle, y
    eor #$ff ; negative: go west
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dx_unit, x
    lda coordinate_of_angle, y
    ldy plane_speed, x
    jsr multiply_a8_y8_to_ay
    tya
    eor #$ff ; negative: go west
    adc #$01 ; range 0..-127 instead of 0..-128
    sta plane_dx, x

@done:
    pla
    tay
    pla
    RTS

animate_exhaust:
    lda plane_dx_unit, x
    bpl @x_positive
    lsr
    lsr
    lsr
    lsr
    eor #$0f
    bpl @add_x
@x_positive:
    lsr
    lsr
    lsr
    lsr
    eor #$ff
@add_x:
    clc
    adc plane_x_lo, x
    sta $d000 + 2 * 4
    lda plane_x_hi_bit, x
    bne @right_side
    lda $d010
    and #$ef
    sta $d010
    jmp @y
@right_side:
    lda $d010
    ora #$10
    sta $d010
@y:
    lda plane_dy_unit, x
    bpl @y_positive
    lsr
    lsr
    lsr
    lsr
    eor #$0f
    bpl @add_y
@y_positive:
    lsr
    lsr
    lsr
    lsr
    eor #$ff
@add_y:
    clc
    adc $d001, y
    sta $d001 + 2 * 4
; color
    txa
    pha
    lda screen_drawing_round_counter
    lsr
    lsr
    and #$03
    tax
    lda fire_colors, x
    sta $d02b
    pla
    tax
    
; sprite ball shape
    lda plane_x_lo, x
    adc plane_y, x
    and #3
    clc
    adc #(ball_sprite_number)
    sta sprite_pointers + 4

    RTS

sprite_char_pos: ;  a = x lo, x = x hi, y = y, map_tile_pointer = start of screen
    clc
    cpx #0
    beq :+
    sec
:
    ror
    lsr
    lsr
    cpx #0
    beq :+
    sec
    sbc #1
    bne @x_added
:
    adc #6
    bne @x_added
@x_added:
    pha
    tya
    lsr
    lsr
    lsr
    sec
    sbc #6
    tay
    pla
    cpy #0
    beq @all_added
@add_row:
    clc
    adc #40
    bcc :+
    inc map_tile_pointer + 1
:
    dey
    bne @add_row
@all_added:
    sta map_tile_pointer
    RTS

