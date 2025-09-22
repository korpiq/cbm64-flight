planes_init_loc: ; initial sprite coordinates for $d000-

.byte $80, $60
.byte $80, $A0
.byte $C0, $60
.byte $C0, $A0

plane_shadows_init_loc:

.byte $80, $68
.byte $80, $a8
.byte $C0, $68
.byte $C0, $a8

planes_init_color: ; sprite colors for $d027 -

.byte $0E, $0A, $0D, $08
.byte 0, 0, 0, 0

planes_init_shape_ptr: ; sprite shapes for $07f8 -

.byte $8d, $8a, $82, $86
.byte $8d, $8a, $82, $86

planes_shapes_data = $2000 ; sprite shapes copied to $40-byte boundary

.include "../../sprites/plane.asm"
