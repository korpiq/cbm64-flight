
; from https:;www.protovision.games/hardw/build4player.php?language=en#codeit
; read current state of each of the 4 joysticks (native ports and user port CGA)

.code

joys_init:

    LDA #$80
    STA $DD03 ; CIA2 PortB Bit7 as OUT
    LDA $DD01 ; force Clock-Stretching (SuperCPU)
    STA $DD01 ; and release Port
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
    RTS

.data
* = $0400
joysticks:

.byte 0,0,0,0

