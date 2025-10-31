
plane_directions_initial:
    .byte $e0,$20,$a0,$60

debug_data:
plane_alive:
    .byte 1,1,1,1
plane_alive_initial = 1
plane_speed: ; unsigned
    .byte $80,$80,$80,$80
plane_speed_initial = $80

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
plane_z_initial = $48

joystick_pressing_ticks:
; 4 joystick directions + 1 button, each for each 4 players
joystick_pressing_ticks_up:
    .dword 0
joystick_pressing_ticks_down:
    .dword 0
joystick_pressing_ticks_left:
    .dword 0
joystick_pressing_ticks_right:
    .dword 0
joystick_pressing_ticks_button:
    .dword 0

joystick_last_pressed_ticks:
; 4 joystick directions + 1 button, each for each 4 players
joystick_last_pressed_ticks_up:
    .dword 0
joystick_last_pressed_ticks_down:
    .dword 0
joystick_last_pressed_ticks_left:
    .dword 0
joystick_last_pressed_ticks_right:
    .dword 0
joystick_last_pressed_ticks_button:
    .dword 0
