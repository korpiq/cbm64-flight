
chars_init:
    ldx #0
:
    lda charset_map_data, x
    sta charset_map, x
    lda charset_map_data + $100, x
    sta charset_map + $100, x
    inx
    bne :-
    lda $d018
    and #240
    ora #12
    sta $d018

    RTS
