# cbm64-flight

- Try it out with cursor keys as joystick at [https://vc64web.github.io/#openROMS=true#port2=true#https://korpiq.github.io/cbm64/cbm64-flight-4-players.prg](https://vc64web.github.io/#openROMS=true#port2=true#https://korpiq.github.io/cbm64/cbm64-flight-4-players.prg)
- Playable disk image: [https://korpiq.github.io/cbm64/flight-game-4-player.d64](https://korpiq.github.io/cbm64/cbm64-flight-4-players.d64)

Learning to create a game where 4 players can fly their own planes on the same immobile screen.

![Commodore 64 screen full of debug info rows of 4 columns of hexadecimal numbers with titles on the right, 4 small airplane images on top, two of them with black shadows](https://kato.iki.fi/pic/c64-game-4-planes-wip_20251026.png)

Assumes
- common ("CGA") user port joystick expansion

## build and run

```sh
./build.sh
./run.sh
```

Requires
- cc65 development tools
- `x64` from VICE


## used utilities, documentation, code examples

- sprite editor: https://petscii.krissz.hu/
- ca65 compiler: https://cc65.github.io/doc/ca65.html
- user port joysticks: https://www.protovision.games/hardw/build4player.php?language=en#codeit
- raster interrupts basics: https://www.c64-wiki.com/wiki/Raster_interrupt
- memory map: https://sta.c64.org/cbm64mem.html
- machine code instructions: https://www.masswerk.at/6502/6502_instruction_set.html
- 6502 operation: http://www.6502.org/users/obelisk/6502/

## multiplication

## unsigned 8bit x 8bit
  - max 66 cycles with 1k of lookup table data: https://www.txbobsc.com/aal/1986/aal8603.html (scroll to "Fastest 6502 Multiplication Yet")
  - max 120 cycles in 70 bytes of code only: https://www.nesdev.org/wiki/8-bit_Multiply#tepples_unrolled

## signed -64..64
  - -64..64 => -4096..4096, 256B lookup table data: https://www.nesdev.org/wiki/Fast_signed_multiply
