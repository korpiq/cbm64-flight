get_random_byte:
    lda #1
    jsr $E09A
    lda $63
    RTS
