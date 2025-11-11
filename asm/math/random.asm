random_byte_address = $63

get_random_byte:
    lda #1
    jsr $E09A
    lda random_byte_address
    RTS
