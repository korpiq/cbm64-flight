
map_init:
    lda #map_background_color_blue
    sta $d021
    lda #map_background_color_green
    sta $d022
    lda #map_background_color_brown
    sta $d023
    lda #map_background_color_gray
    sta $d024
; character set at $3000
    lda $d011
    ora #$40
    sta $d011

; generate height for each map tile
    lda #>(map_tile_heights)
    sta map_tile_pointer + 1
    ldy #map_rows_total_count
    dey
@fill_tile_row:
    lda map_tile_row_offsets, y
    sta map_tile_pointer
    tya
    pha
    lda map_row_length, y
    tay
    dey
    lda #0 ; prefill map border with sea
    sta (map_tile_pointer), y
    lda #$8 ; prefill map with unused value to differentiate ungenerated from generated tiles
:
    tya
    pha
    txa
    pha
    jsr get_random_byte ; start with random height – later only for map center row edges, rest weighed by neighbors and bags
    pla
    tax
    pla
    tay
    lda random_byte_address
    and #7
    sta (map_tile_pointer), y
    dey
    bne :-
    lda #0
    sta (map_tile_pointer), y
    pla
    tay
    dey
    bpl @fill_tile_row

; draw map
    ldy #(map_rows_total_count) ; how many rows in map
    dey
@draw_row:
    ldx map_row_length, y
    dex
@draw_tile:
    tya
    pha
    txa
    pha
    jsr get_tile_height_at_x_y
    sta swap
    pla
    tax
    pla
    tay
    pha
    txa
    pha
    lda swap
    asl
    asl
    asl
    asl
    asl
    asl
    clc
    adc #$20
    jsr fill_map_tile_at_x_y
    lda #$d4 ; from screen chars to color memory
    adc map_tile_pointer + 1
    sta map_tile_pointer + 1
    pla
    pha
    lsr
    lsr
    tax
    lda map_level_colors, x
    jsr color_map_tile_pointed
    pla
    tax
    pla
    tay
    dex
    bpl @draw_tile
    dey
    bpl @draw_row

    RTS

point_at_map_tile: ; a = screen address hi byte (e.g. $d8 = color map); y = tile row from top; x = tile from left
    sta map_tile_pointer + 1
    lda map_screen_row_offsets, y
    clc
    adc #40 ; leave one row empty at top
    bcc :+
    inc map_tile_pointer + 1
:
    dey
    bmi @y_added
    clc
    adc #80 ; go two rows down per y since each tile is 2 high
    bcc :-
    inc map_tile_pointer + 1
    bne :-

@y_added:
    sta map_tile_pointer
    txa
    asl
    clc
    adc map_tile_pointer
    bcc @x_added
    inc map_tile_pointer + 1

@x_added:
    sta map_tile_pointer
    RTS

color_map_tile_at_x_y: ; a = color; y = tile row from top; x = tile from left
    pha
    lda #$d8
    sta map_tile_pointer
    jsr point_at_map_tile
    pla

color_map_tile_pointed: ; a = color; address at map_tile_pointer
    ldy #0
    sta (5), y
    iny
    sta (5), y
    ldy #40
    sta (5), y
    iny
    sta (5), y

    RTS

fill_map_tile_at_x_y: ; a = color; y = tile row from top; x = tile from left
    pha
    lda #4
    sta map_tile_pointer
    jsr point_at_map_tile
    pla

fill_map_tile_pointed: ; a = color; address at map_tile_pointer
    ldy #0
    sta (5), y
    iny
    sta (5), y
    ldy #40
    sta (5), y
    iny
    sta (5), y

    RTS

get_tile_height_at_x_y: ; y = tile row #; a = tile # on row from left => a = height; y its offset
    clc
    adc map_tile_row_offsets, y
    tay
    lda map_tile_heights, y

    RTS

