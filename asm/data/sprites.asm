planes_init_loc: ; initial sprite coordinates for $d000-

.byte $98, $78
.byte $b8, $78
.byte $98, $98
.byte $b8, $98

plane_shadows_init_loc:

.byte $0, $0
.byte $0, $0
.byte $98, $a0
.byte $b8, $a0

planes_init_color: ; sprite colors for $d027 -

.byte $0E, $0A, $0D, $07
.byte 0, 0, 0, 0

planes_init_shape_ptr: ; sprite shapes for $07f8 -

.byte plane_sprite_number + $d, plane_sprite_number + $a, plane_sprite_number + 2, plane_sprite_number + 6
.byte ball_sprite_number + 7, ball_sprite_number + 5, ball_sprite_number + 3, ball_sprite_number + 1

sprite_pointers = $07f8

sprites_data = $2000 ; sprite shapes copied to $40-byte boundary

ball_sprite_number = plane_sprite_number + 16
plane_sprite_number = <(sprites_data / $40)

fire_colors:
    .byte 7, 8, 10, 14
