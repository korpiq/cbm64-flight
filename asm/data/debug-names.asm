name_0: .byte "joystick", 0
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

debug_names_lo:
.byte <name_0,<name_1,<name_2,<name_3,<name_4,<name_5,<name_6,<name_7,<name_8,<name_9,<name_a,<name_b,<name_c

debug_names_hi:
.byte >name_0,>name_1,>name_2,>name_3,>name_4,>name_5,>name_6,>name_7,>name_8,>name_9,>name_a,>name_b,>name_c
