; .align $40 – once we load directly into correct memory area, bank#1, ~$4000
.include "balls.asm"
plane_sprites:
.incbin "plane-sprites.bin"

; .align $800 – once we load directly into correct memory area, bank#1, ~$4000
charset_map_data:
.incbin "charset-map.bin"
