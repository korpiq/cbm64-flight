
map_row_length: ; in tiles aka double characters
    .byte  6,  11, 14, 17
    .byte 18, 19, 18
    .byte 17, 14,  11,  6
map_row_length_end:

map_row_offset: ; single character spaces
    .byte 14, 9, 6, 3
    .byte 2, 1, 2
    .byte 3, 6, 9, 14

map_level_colors:
    .byte 6, 14, 13, 5, 8, 10, 12, 15

map_special_color = 0
map_river_color = 6
map_cliff_color = 9
map_snow_color = 1

; FIXME: these are from default charset unavailable in ext color with only 6 lowest bits = $40 characters
landscape_flat = $e0
landscape_river_up = $83
landscape_river_down = $af
landscape_river_left = $aa
landscape_river_right = $a7

landscape_river_upright = $d0
landscape_river_upleft = $cf
landscape_river_downleft = $cc
landscape_river_downright = $fa

charset_map = $3000
