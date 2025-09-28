
print_hex:
    pha
    lsr
    lsr
    lsr
    lsr
    jsr print_hex_digit
    pla
    jsr print_hex_digit
    lda #$20
    jmp $ffd2

print_hex_digit:
    and #$0f
    clc
    adc #$30
    cmp #$3A
    bcc :+
    clc
    adc #$07
:
    jmp $ffd2
