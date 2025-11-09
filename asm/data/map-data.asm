
map_row_length: ; in tiles aka double characters
    .byte  6,  11, 14, 17
    .byte 18, 19, 18
    .byte 17, 14,  11,  6
map_rows_total_count = * - map_row_length

map_row_offset: ; single character spaces
    .byte 14, 9, 6, 3
    .byte 2, 1, 2
    .byte 3, 6, 9, 14
map_rows_offsets_total = * - map_row_offset

map_tiles_total_count = (6 + 11 + 14 + 17 + 18) *2 + 19
.out .sprintf("map_tiles_total_count = %d", map_tiles_total_count)

.assert map_rows_offsets_total = map_rows_total_count, error, "exactly 1 offset per map tile row"

map_level_colors:
    .byte 6, 14, 13, 5, 8, 10, 12, 15
map_level_colors_total_count = * - map_level_colors

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

map_tile_heights = bss
map_tile_heights_end = bss + map_tiles_total_count

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
