; from https://www.nesdev.org/wiki/8-bit_Multiply#tepples_unrolled
; @param A one factor
; @param Y another factor
; @return low 8 bits in A; high 8 bits in Y
multiply_a8_y8_to_ay:
    lsr
    sta multiplication_lo
    tya
    beq @done ; y = a = 0
    dey
    sty multiplication_factor
    lda #0
.repeat 8, i
    .if i > 0
        ror multiplication_lo
    .endif
    bcc :+
    adc multiplication_factor
:
    ror
.endrepeat
    tay
    lda multiplication_lo
    ror
@done:
    rts
