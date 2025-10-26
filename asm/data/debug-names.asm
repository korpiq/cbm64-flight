name_1: .byte "speed", 0
name_2: .byte "direction", 0
name_3: .byte "dx", 0
name_4: .byte "dy", 0
name_5: .byte "dz", 0
name_6: .byte "x-counter", 0
name_7: .byte "y-counter", 0
name_8: .byte "z-counter", 0
name_9: .byte "x low byte", 0
name_a: .byte "x high bit", 0
name_b: .byte "y position", 0
name_c: .byte "z position", 0
dbg_joy_u: .byte "up", 0
dbg_joy_d: .byte "down", 0
dbg_joy_l: .byte "left", 0
dbg_joy_r: .byte "right", 0
dbg_joy_b: .byte "button", 0
dbg_joy_last_u: .byte "last up", 0
dbg_joy_last_d: .byte "last down", 0
dbg_joy_last_l: .byte "last left", 0
dbg_joy_last_r: .byte "last right", 0
dbg_joy_last_b: .byte "last button", 0

debug_names_lo:
.byte <name_1,<name_2,<name_3,<name_4,<name_5,<name_6,<name_7,<name_8,<name_9,<name_a,<name_b,<name_c
.byte <dbg_joy_u, <dbg_joy_d, <dbg_joy_l, <dbg_joy_r, <dbg_joy_b
.byte <dbg_joy_last_u, <dbg_joy_last_d, <dbg_joy_last_l, <dbg_joy_last_r, <dbg_joy_last_b

debug_names_hi:
.byte >name_1,>name_2,>name_3,>name_4,>name_5,>name_6,>name_7,>name_8,>name_9,>name_a,>name_b,>name_c
.byte >dbg_joy_u, >dbg_joy_d, >dbg_joy_l, >dbg_joy_r, >dbg_joy_b
.byte >dbg_joy_last_u, >dbg_joy_last_d, >dbg_joy_last_l, >dbg_joy_last_r, >dbg_joy_last_b
.byte 0 ; marks last row to print
