

plane_speed: ; unsigned
    .byte $80,$80,$80,$80

plane_direction: ; clockwise 256 "degree" compass direction
    .byte $e0,$20,$a0,$60

plane_dx:
    .byte 0,0,0,0

plane_dy:
    .byte 0,0,0,0

plane_dz:
    .byte 0,0,0,0

plane_x_fragment:
    .byte 0,0,0,0

plane_y_fragment:
    .byte 0,0,0,0

plane_z_fragment:
    .byte 0,0,0,0

plane_x_lo:
    .byte 0,0,0,0

plane_x_hi_bit:
    .byte 0,0,0,0

plane_y:
    .byte 0,0,0,0

plane_z:
    .byte $48,$48,$48,$48

