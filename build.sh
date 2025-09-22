mkdir -p build
ca65 -t c64 -l build/flight.lst -o build/flight.o asm/flight.asm
ld65 -C ld65/c64.cfg -o build/flight.prg build/flight.o -m build/flight.map
c1541 -format korpiq-disk,02 d64 korpiq-disk.d64 -attach korpiq-disk.d64 -write build/flight.prg flight
