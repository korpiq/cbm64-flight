
map_init:
    lda #map_background_color_blue
    sta $d021
    lda #map_background_color_green
    sta $d022
    lda #map_background_color_brown
    sta $d023
    lda #map_background_color_gray
    sta $d024
    ldy #0
:
    lda #$20
    sta $0400, y
    sta $0500, y
    sta $0600, y
    sta $0700, y
    lda #0
    sta $d800, y
    sta $d900, y
    sta $da00, y
    sta $db00, y
    iny
    bne :-
; character set at $3000
    lda $d011
    ora #$40
    sta $d011

; print planet name at top
    lda #40
    sec
    sbc planet_name_length
    lsr
    tay
    ldx #0
    clc
    jsr $e50a ; center planet name on top of screen
    lda #<planet_name
    ldy #>planet_name
    jsr $ab1e ; print planet name
    lda #$0d
    jsr $ffd2

    ldy #27
:
    lda $0400, y
    ora #$c0 ; use top bg color
    sta $0400, y
    dey
    bne :-

    ldy #0
    ldx #1
    clc
    jsr $e50a ; print at start of second row
    lda #$0
:
    pha
    tax
    lda random_mantissa, x
    jsr print_hex
    pla
    adc #1
    cmp #4
    bne :-

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
    dey
:
    lda #$80 ; prefill map with unused value to differentiate ungenerated from generated tiles
    sta (map_tile_pointer), y
    dey
    bne :-
    lda #0
    sta (map_tile_pointer), y
    pla
    tay
    dey
    bpl @fill_tile_row

; go by x and y to fill each tile to match its neighbors
    ldy #map_rows_total_count
    dey
:
    ldx map_row_length, y
    dex
:
    jsr define_map_tile_height
    ldy temp_y
    ldx temp_x
    dex
    bpl :-
    dey
    bpl :--

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
    lda #$20 ; no rivers etc yet
    jsr fill_map_tile_at_x_y
    lda #$d4 ; from screen chars to color memory
    clc
    adc map_tile_pointer + 1
    sta map_tile_pointer + 1
    pla
    tax
    pla
    tay
    pha
    txa
    pha
    jsr get_tile_height_at_x_y
    tax
    lda map_level_colors, x
    sta swap
    pla
    tax
    pla
    tay
    pha
    txa
    pha
    lda swap
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

get_tile_x_y_north_east: ; y = tile row #; a = tile # on that row from left
    cpy #0
    beq get_tile_x_y_over_map_pole
    cpy #(map_rows_total_count / 2 + 1)
    bcc :+
    ; Southern side, so NorthEast is X + offset of old row + 1
    clc
    adc map_row_offset, y ; X += offset of old row
    dey ; 1 row North
    jmp get_tile_x_y_east ; X += 1
:
    ; Northern side, so NorthEast is X - offset of new row
    dey ; 1 row North
    sec
    sbc map_row_offset, y
    bpl :+
    lda #0 ; off tile top on western edge lands on western edge of new row
    RTS
:
    cmp map_row_length, y ; off eastern edge?
    bcs get_tile_x_on_eastern_edge
    RTS

get_tile_x_y_north_west: ; y = tile row #; a = tile # on that row from left
    cpy #0
    beq get_tile_x_y_over_map_pole
    cpy #(map_rows_total_count / 2 + 1)
    bcc :+
    ; Southern side, so NorthWest is X + offset of old row; always lands on map
    clc
    adc map_row_offset, y
    dey ; 1 row North
    RTS
:
    ; Northern side, so NorthWest is X - offset of new row - 1
    dey ; 1 row North
    sec
    sbc #1 ; X -= 1
    bmi get_tile_x_on_eastern_edge ; off tile top western corner lands to eastern edge
    sec
    sbc map_row_offset, y ; X -= offset of new row
    bpl :+
    lda #0 ; off tile top on western edge lands on western edge of new row
:
    RTS

get_tile_x_y_over_map_pole:
    ; go over North/South pole to its other side
    cmp #map_row_at_pole_half_length
    bcc :+
    sbc #map_row_at_pole_half_length
    RTS
:
    adc #map_row_at_pole_half_length
    RTS

get_tile_x_y_east: ; y = tile row #; a = tile # on that row from left
    clc
    adc #1
    cmp map_row_length, y
    bcc :+
    lda #0
:
    RTS

get_tile_x_y_west: ; y = tile row #; a = tile # on that row from left
    cmp #0
    bne :+
get_tile_x_on_eastern_edge: ; 
    lda map_row_length, y
:
    sec
    sbc #1
    RTS

get_tile_x_y_south_east: ; y = tile row #; a = tile # on that row from left
    cpy #(map_rows_total_count - 1)
    bcs get_tile_x_y_over_map_pole
    cpy #(map_rows_total_count / 2)
    bcs :+
    ; Northern side, so SouthEast is X + offset of old row + 1; always lands on map
    adc map_row_offset, y ; X += offset of old row
    iny ; 1 row South
    jmp get_tile_x_y_east ; X += 1
:
    ; Southern side, so SouthEast is X - offset of new row
    iny ; 1 row South
    sbc map_row_offset, y ; X -= offset of old row
    bcs :+
    lda #0
:
    RTS

get_tile_x_y_south_west: ; y = tile row #; a = tile # on that row from left
    cpy #(map_rows_total_count - 1)
    beq get_tile_x_y_over_map_pole
    cpy #(map_rows_total_count / 2)
    bcs :+
    ; Northern side, so SouthWest is X + offset of old row; always lands on map
    adc map_row_offset, y
    iny ; 1 row South
    RTS
:
    ; Southern side, so SouthWest is X - offset of new row - 1
    iny ; 1 row South
    sbc #1 ; X -= 1
    bmi get_tile_x_on_eastern_edge ; off tile top western corner lands to eastern edge
    sec
    sbc map_row_offset, y ; X -= offset of new row
    bpl :+
    lda #0 ; off tile top on western edge lands on western edge of new row
:
    RTS

define_map_tile_height: ; y = map tile row#, x = tile # on that row from left => a = map tile height

; load_current_tile_neighbor_heights:
    sty temp_y
    stx temp_x
    lda temp_y
    jsr print_hex
    lda temp_x
    jsr print_hex
    ldx #0
    stx temp_offset
    ldy temp_y
    lda temp_x
    jsr get_tile_x_y_north_east
    jsr get_tile_height_at_x_y
    cmp #$80
    bcs :+
    jsr @store_tile_neighbor_height
:
    ldy temp_y
    lda temp_x
    jsr get_tile_x_y_east
    jsr get_tile_height_at_x_y
    cmp #$80
    bcs :+
    jsr @store_tile_neighbor_height
:
    ldy temp_y
    lda temp_x
    jsr get_tile_x_y_south_east
    jsr get_tile_height_at_x_y
    cmp #$80
    bcs :+
    jsr @store_tile_neighbor_height
:
    ldy temp_y
    lda temp_x
    jsr get_tile_x_y_south_west
    jsr get_tile_height_at_x_y
    cmp #$80
    bcs :+
    jsr @store_tile_neighbor_height
:
    ldy temp_y
    lda temp_x
    jsr get_tile_x_y_west
    jsr get_tile_height_at_x_y
    cmp #$80
    bcs :+
    jsr @store_tile_neighbor_height
:
    ldy temp_y
    lda temp_x
    jsr get_tile_x_y_north_west
    jsr get_tile_height_at_x_y
    cmp #$80
    bcs :+
    jsr @store_tile_neighbor_height
:
; take random neighbor's height
    lda temp_offset
    jsr get_random_below_a
    sta current_map_tile_bag
    tay
    lda tile_bags, y
    sta temp_offset ; height proposed by existing tile
    clc
    adc #2
    jsr get_random_below_a
    cmp temp_offset
    beq @take_lower_tile
    bcs @take_higher_tile
@set_proposed_tile_height: ; temp_offset = proposed tile height, (temp_x, temp_y) = location on map
    ldx temp_offset
    dec tile_bags, x
    lda temp_x
    ldy temp_y
    clc
    adc map_tile_row_offsets, y
    tay
    txa
    sta map_tile_heights, y

    RTS

@store_tile_neighbor_height:
    ldy temp_offset
    sta map_current_tile_neighbors, y
    inc temp_offset
    RTS

@take_lower_tile:
    ldy current_map_tile_bag
    dey
    bpl :+
    ldy #7
:
    lda tile_bags, y
    sta temp_offset ; height proposed by existing tile
    clc
    adc #1
    jsr get_random_below_a
    cmp temp_offset
    bcc @set_proposed_tile_height
    bcs @take_lower_tile

@take_higher_tile:
    ldy current_map_tile_bag
    iny
    cpy #8
    bcc :+
    ldy #0
:
    lda tile_bags, y
    sta temp_offset ; height proposed by existing tile
    clc
    adc #1
    jsr get_random_below_a
    cmp temp_offset
    bcc @set_proposed_tile_height
    bcs @take_higher_tile
