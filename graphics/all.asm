; .align $40 ; once we load directly into correct memory area, bank#1, ~$4000
; .byte 0
sprites_balls:
.include "balls.asm"
.out .sprintf("sprites_balls = %d - %d", sprites_balls, *)
plane_sprites:
.incbin "plane-sprites.bin"
.out .sprintf("plane_sprites = %d - %d", plane_sprites, *)

; .byte 0
charset_map_data:
.incbin "charset.bin"
.out .sprintf("charset_map_data = %d - %d", charset_map_data, *)
