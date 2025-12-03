; $0061-$0065 (97-101) FAC, arithmetic register #1 (5 bytes).
; $0066 (102) Sign of FAC. Bits: Bit #7: 0 = Positive; 1 = Negative.
; $008B-$008F (139-143) Previous result of RND().

random_byte_address = $8f

get_random_byte:
    jsr $E0BE ; get next number in RND() sequence ; https://skoolkid.github.io/sk6502/c64rom/asm/E097.html
    lda random_byte_address
    RTS

get_random_below_a: ; a = max -> 0 <= a < max
    pha
    jsr $E0BE
    pla
:
    cmp random_byte_address
    bcc :+
    lsr random_byte_address ; squeeze it shorter until it fits :P ain't nobody got time to modulo
    bne :-
:
    lda random_byte_address
    RTS
