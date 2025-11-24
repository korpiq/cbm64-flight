
test_tile_addressing:
    ldy #(map_rows_total_count / 2) ; y = middle row
    sty buffer_test_tile_address_y
    lda map_row_length, y
    lsr ; a = middle of middle row
    sta buffer_test_tile_address_x
    jsr print_test_tile_address
    jsr get_tile_x_y_north_east
    sty buffer_test_tile_address_y
    sta buffer_test_tile_address_x
    jsr print_test_tile_address
    jsr get_tile_x_y_south_west
    sty buffer_test_tile_address_y
    sta buffer_test_tile_address_x
    jsr print_test_tile_address
    jsr get_tile_x_y_south_west
    sty buffer_test_tile_address_y
    sta buffer_test_tile_address_x
    jsr print_test_tile_address
    jsr get_tile_x_y_north_east
    sty buffer_test_tile_address_y
    sta buffer_test_tile_address_x
    jsr print_test_tile_address
    RTS

print_test_tile_address:
    lda buffer_test_tile_address_x
    jsr print_hex
    lda buffer_test_tile_address_y
    jsr print_hex
    lda #<string_test_tile_address
    ldy #>string_test_tile_address
    jsr $ab1e
    lda buffer_test_tile_address_x
    ldy buffer_test_tile_address_y
    RTS

buffer_test_tile_address_x: .byte 0
buffer_test_tile_address_y: .byte 0
string_test_tile_address: .byte "tile address\n", 0
