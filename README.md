# cbm64-flight

Learning to create a game where 4 players can fly their own planes on the same immobile screen.

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

