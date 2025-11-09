
map_init:
    lda #map_special_color
    sta $d021
    lda #map_river_color
    sta $d022
    lda #map_cliff_color
    sta $d023
    lda #map_snow_color
    sta $d024
    lda $d011
    ora #$40
    sta $d011

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
    rol
    rol
    rol
    and #$c7
    ora #$20
    clc
    adc #1
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
    lda map_row_offset, y
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
