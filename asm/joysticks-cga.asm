
; from https:;www.protovision.games/hardw/build4player.php?language=en#codeit
; read current state of each of the 4 joysticks (native ports and user port CGA)
; then update tick counters of how long each switch is being pressed and has last been pressed

.code

joys_init:

    LDA #$80
    STA $DD03 ; CIA2 PortB Bit7 as OUT
    LDA $DD01 ; force Clock-Stretching (SuperCPU)
    STA $DD01 ; and release Port
; clear joystick tick counters
    lda #0
    ldy #20
:
    sta joystick_pressing_ticks, y
    sta joystick_last_pressed_ticks, y
    dey
    bpl :-

    RTS

joys_read:

    LDA $DC01 ; read Port1
    AND #$1F
    STA joysticks+$00

    LDA $DC00 ; read Port2
    AND #$1F
    STA joysticks+$01

    LDA $DD01 ; CIA2 PortB Bit7 = 1
    ORA #$80
    STA $DD01

    LDA $DD01 ; read Port3
    AND #$1F
    STA joysticks+$02

    LDA $DD01 ; CIA2 PortB Bit7 = 0
    AND #$7F
    STA $DD01

    LDA $DD01 ; read Port4
    PHA ; Attention: FIRE for Port4 on Bit5, NOT 4!
    AND #$0F
    STA joysticks+$03
    PLA
    AND #$20
    LSR
    ORA joysticks+$03
    STA joysticks+$03

;    RTS

;joys_update_tick_counters:

    lda #$10
    sta joystick_switch_bit ; bit rolls down from $10 to 1 to check each switch separately
    ldx #20 ; runs down to 0; offset of tick counters: 5 switches of 4 joysticks

@read_next_switch_bit:
    ldy #3 ; number of joystick

@read_next_joystick:
    lda joysticks, y
    and joystick_switch_bit
    bne @switch_not_pressed ; switch bit is on in joystick so the switch is not being pressed

; switch is pressed
    inc joystick_pressing_ticks, x ; count ticks the switch has been pressed; nonzero = currently pressed
    bne @end_reading_joy_switch
    dec joystick_pressing_ticks, x ; max out at $ff to keep counter nonzero
    bne @end_reading_joy_switch

@switch_not_pressed:
    lda joystick_pressing_ticks, x
    beq @end_reading_joy_switch

; switch counter is nonzero, so it has just been released; save value to last pressed and clear counter.
    sta joystick_last_pressed_ticks, x
    lda #0
    sta joystick_pressing_ticks, x ; set counter to zero as the switch is no longer being pressed.

@end_reading_joy_switch:
    dex
    dey
    bpl @read_next_joystick ; read same bit of each joystick in turn

    lsr joystick_switch_bit
    bne @read_next_switch_bit ; read next bit of all joysticks

    rts
