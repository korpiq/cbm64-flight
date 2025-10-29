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

.byte $8d, $8a, $82, $86
.byte $8d, $8a, $82, $86

sprite_pointers = $07f8

sprites_data = $2000 ; sprite shapes copied to $40-byte boundary

fire_colors:
    .byte 7, 8, 10, 14
