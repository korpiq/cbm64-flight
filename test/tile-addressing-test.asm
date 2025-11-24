
test_tile_addressing:
    lda #<title_test_tile_addressing
    ldy #>title_test_tile_addressing
    jsr $ab1e

    ldy #(map_rows_total_count / 2) ; y = middle row
    lda map_row_length, y
    lsr ; a = middle of middle row
    sty base_test_tile_address_y
    sta base_test_tile_address_x

    jsr print_test_tile_address
    jsr get_tile_x_y_east
    jsr print_test_tile_address
    jsr get_tile_x_y_west
    jsr check_test_tile_address_equals_base
    jsr get_tile_x_y_west
    jsr print_test_tile_address
    jsr get_tile_x_y_east
    jsr check_test_tile_address_equals_base

    jsr get_tile_x_y_north_east
    jsr print_test_tile_address
    jsr get_tile_x_y_south_west
    jsr check_test_tile_address_equals_base
    jsr get_tile_x_y_south_west
    jsr print_test_tile_address
    jsr get_tile_x_y_north_east
    jsr check_test_tile_address_equals_base

    jsr get_tile_x_y_north_west
    jsr print_test_tile_address
    jsr get_tile_x_y_south_east
    jsr check_test_tile_address_equals_base
    jsr get_tile_x_y_south_east
    jsr print_test_tile_address
    jsr get_tile_x_y_north_west
    jsr check_test_tile_address_equals_base
    RTS

print_test_tile_address:
    sty buffer_test_tile_address_y
    sta buffer_test_tile_address_x
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

check_test_tile_address_equals_base:
    jsr print_test_tile_address
    cmp base_test_tile_address_x
    bne fail
    cpy base_test_tile_address_y
    bne fail
    inc test_number
    RTS

fail:
    pla
    pla
    RTS

base_test_tile_address_x: .byte 0
base_test_tile_address_y: .byte 0
buffer_test_tile_address_x: .byte 0
buffer_test_tile_address_y: .byte 0
string_test_tile_address: .byte "tile address\n", 0
title_test_tile_addressing: .byte "1. test tile addressing:\n- from center to each direction and back\n", 0
