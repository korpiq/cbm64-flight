map_row_length: ; in tiles aka double characters
    .byte  6,  11, 14, 17
    .byte 18, 19, 18
    .byte 17, 14,  11,  6
map_rows_total_count = <(* - map_row_length)

.out .sprintf("map_rows_total_count = %d", map_rows_total_count)

map_screen_row_offsets: ; single character spaces
    .byte 14, 9, 6, 3
    .byte 2, 1, 2
    .byte 3, 6, 9, 14
.assert * - map_screen_row_offsets = map_rows_total_count,  error, .sprintf("map_screen_row_offsets (%d) should equal map_rows_total_count", * - map_screen_row_offsets)

map_tile_row_offsets:
    .byte 0
    .byte 6
    .byte 6 + 11
    .byte 6 + 11 + 14
    .byte 6 + 11 + 14 + 17
    .byte 6 + 11 + 14 + 17 + 18
    .byte 6 + 11 + 14 + 17 + 18 + 19
    .byte 6 + 11 + 14 + 17 + 18 + 19 + 18
    .byte 6 + 11 + 14 + 17 + 18 + 19 + 18 + 17
    .byte 6 + 11 + 14 + 17 + 18 + 19 + 18 + 17 + 14
    .byte 6 + 11 + 14 + 17 + 18 + 19 + 18 + 17 + 14 + 11
    .byte 6 + 11 + 14 + 17 + 18 + 19 + 18 + 17 + 14 + 11 + 6 ; end of table
.assert * - map_tile_row_offsets = map_rows_total_count + 1,  error, .sprintf("map_tile_row_offsets (%d) should equal map_rows_total_count + 1", * - map_tile_row_offsets)

map_tiles_total_count = (6 + 11 + 14 + 17 + 18) *2 + 19
.out .sprintf("map_tiles_total_count = %d", map_tiles_total_count)

map_level_colors:
    .byte 6, 14, 13, 5, 8, 10, 12, 15
map_level_colors_total_count = * - map_level_colors

map_background_color_blue = 14
map_background_color_green = 5
map_background_color_brown = 9
map_background_color_gray = 11

map_background_colors:
    .byte map_background_color_blue, map_background_color_green, map_background_color_brown, map_background_color_gray

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

; tiles available for creating map

tiles_per_type = map_tiles_total_count / map_level_colors_total_count + map_level_colors_total_count

tile_bags:
.repeat map_level_colors_total_count, i
.byte tiles_per_type
.endrep

.assert * - tile_bags = map_level_colors_total_count, error, "one bag per tile type"
total_tiles_left:
.byte map_tiles_total_count

.out .sprintf("tiles_per_type = %d", tiles_per_type);
.out .sprintf("tiles in bags total = %d", tiles_per_type * map_level_colors_total_count);
