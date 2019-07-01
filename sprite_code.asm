macro a()
	lda $15
	and #$01
	beq +
	stz $157C,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $157C,x
++	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts
endmacro

handle_sprites:
	ldx !hat_index
	lda !hat_sprite
	dec
	jsl !execute_pointer
	dw .koopa
	dw .banzai
	dw .rex
	dw .chuck
	dw .jumping_piranha
	dw .monty_mole
	dw .paratroopas
	dw .jumping_paratroopa
	dw .xy_move
	dw .jumping_fish
	dw .water_fishes
	dw .surface_fish
	dw .floating
	dw .blurp
	dw .rip_van_fish
	dw .climb_green
	dw .climb_red
	dw .super_koopa_floor
	dw .super_koopa_fly
	dw .swooper
	dw .boo
	dw .eerie
	dw .thwimp
	dw .thwomp
	dw .ballnchain
	dw .drybones
	dw .lineguide
	dw .wallfollow
	dw .wiggler
	dw .urchin
	dw .lakitu_cloud
	dw .bubble
	dw .rihno

.rihno
	lda $15
	and #$01
	beq +
	stz $157C,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $157C,x
++	
	lda $C2,x
	bne +
	lda $16
	bpl ++
	lda #$03
	sta $C2,x
	bra +
++	
	cmp #$40
	bne +
	lda #$01
	sta $C2,x
+	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts

.bubble
	lda $1534,x
	bne +

	lda #$40
	sta $1497
	stz $78
	ldy #$F0
	lda !hat_dir
	beq ++
	ldy #$10
++	
	sty $7B
	lda #$90
	sta $7D
	stz !hat_gfx
	stz !hat_throw
	stz !hat_transition
	stz !hat_anim
	stz !hat_gfx
	stz !hat_jump
	stz !hat_dir
	stz !hat_disable_barrier
	lda #$FF
	sta !hat_sprite
	sta !hat_index
	lda !hat_interaction
	and.b #%11000011
	sta $5B
	stz !hat_interaction
	stz !hat_spr_interact
	lda #$02
	sta $1DFC
	lda #$01
	sta $1DFA
	rts
+	
	lda $15
	and #$01
	beq +
	stz $157C,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $157C,x
++	
	lda $15
	and #$04
	beq +
	stz  $151C,x
	bra ++
+	
	lda $15
	and #$08
	beq ++
	lda #$01
	sta $151C,x
++	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
.lakitu_cloud
	lda $15
	and #$08
	beq +
	lda $AA,x
	bpl +++
	cmp #$E0
	bcc ++
+++	
	dec $AA,x
	bra ++
+	
	lda $15
	and #$04
	beq +
	lda $AA,x
	bmi +++
	cmp #$20
	bcs ++
+++	
	inc $AA,x
	bra ++
+	
	stz $AA,x
++	
	lda $15
	and #$01
	beq +
	lda $B6,x
	bmi +++
	cmp #$1C
	bcs ++
+++	
	inc $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq +
	lda $B6,x
	bpl +++
	cmp #$E4
	bcc ++
+++	
	dec $B6,x
	bra ++
+	
	stz $B6,x
++	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts

.urchin
	lda $15
	and #$01
	beq +
	lda $B6,x
	bpl +
	eor #$FF
	inc 
	sta $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda $B6,x
	bmi ++
	eor #$FF
	inc
	sta $B6,x
++	
	lda $15
	and #$04
	beq +
	lda $AA,x
	bpl +
	eor #$FF
	inc 
	sta $AA,x
	bra ++
+	
	lda $15
	and #$08
	beq ++
	lda $AA,x
	bmi ++
	eor #$FF
	inc
	sta $AA,x
++	
	lda #$02
	sta !hat_gfx
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts
.wiggler
	lda $15
	and #$01
	beq +
	stz $157C,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $157C,x
++	
	lda $1588,x
	and #$04
	beq +
	lda $16
	bpl +
	lda #$DC
	sta $AA,x
	lda #$01
	sta $1DFA
+	

	lda #$08
	sta $154C,x
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$08
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts

.wallfollow
	lda $16
	and #$01
	beq +
	lda $C2,x
	and #$03
	sta $C2,x
	lda #$00
	sta !hat_dir
	bra ++
+	
	lda $16
	and #$02
	beq ++
	lda $C2,x
	ora #$04
	sta $C2,x
	lda #$01
	sta !hat_dir
++	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts
.lineguide
	lda #$01
	sta $C2,x
	stz $1626,x
	lda $16
	and #$01
	beq +
	stz $157C,x
	bra ++
+	
	lda $16
	and #$02
	beq ++
	lda #$01
	sta $157C,x
++	
	lda $15
	and #$40
	beq +
	lda #$01
	sta $187B,x
	bra ++
+	
	lda $15
	and #$80
	beq ++
	stz $187B,x
++	
	rts
.drybones
	lda $15
	and #$01
	beq +
	stz $157C,x
	lda #$10
	sta $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $157C,x
	lda #$F0
	sta $B6,x
++	
	lda $1588,x
	and #$04
	beq +
	lda $16
	bpl +
	lda #$B4
	sta $AA,x
	lda #$01
	sta $1DFA
+	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts
	
.ballnchain
	lda $15
	and #$08
	beq +
	lda $D8,x
	sec
	sbc #$01
	sta $D8,x
	lda $14D4,x
	sbc #$00
	sta $14D4,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $D8,x
	clc
	adc #$01
	sta $D8,x
	lda $14D4,x
	adc #$00
	sta $14D4,x
++	
	lda $15
	and #$01
	beq +
	lda $E4,x
	clc
	adc #$01
	sta $E4,x
	lda $14E0,x
	adc #$00
	sta $14E0,x
+	
	lda $15
	and #$02
	beq ++
	lda $E4,x
	sec
	sbc #$01
	sta $E4,x
	lda $14E0,x
	sbc #$00
	sta $14E0,x
++	
	stz !hat_gfx
	rts
.thwimp	
	lda $1588,x
	and #$04
	beq ++
	lda $16
	bpl ++
	lda #$A0
	sta $AA,x
	inc $C2,x
	lda $C2,x
	lsr 
	lda #$10
	bcc +
	lda #$F0
+	
	sta $B6,x
++	
	lda $15
	and #$02
	beq +
	stz $C2,x
	bra ..nothing
+	
	lda $15
	and #$01
	beq ..nothing
	lda #$01
	sta $C2,x
	
..nothing
	lda #$08
	sta !hat_gfx
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts
.thwomp	
	lda #$08
	sta !hat_gfx
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	lda $E4,x
	sec
	sbc #$04
	sta !hat_x_lo
	lda $14E0,x
	sbc #$00
	sta !hat_x_hi

	lda $15
	and #$08
	beq +
	lda $D8,x
	sec
	sbc #$01
	sta $D8,x
	lda $14D4,x
	sbc #$00
	sta $14D4,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $D8,x
	clc
	adc #$01
	sta $D8,x
	lda $14D4,x
	adc #$00
	sta $14D4,x
++	
	lda $15
	and #$01
	beq +
	lda $E4,x
	clc
	adc #$01
	sta $E4,x
	lda $14E0,x
	adc #$00
	sta $14E0,x
+	
	lda $15
	and #$02
	beq ++
	lda $E4,x
	sec
	sbc #$01
	sta $E4,x
	lda $14E0,x
	sbc #$00
	sta $14E0,x
++	
	rts

.eerie

	lda $15
	and #$01
	beq +
	stz $157C,x
	lda #$10
	sta $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $157C,x
	lda #$F0
	sta $B6,x
++	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$07
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts
	
	
.boo
	stz $C2,x
	lda $15
	and #$08
	beq +
	lda $AA,x
	bpl +++
	cmp #$B0
	bcc ++
+++	
	dec $AA,x
	bra ++
+	
	lda $15
	and #$04
	beq +
	lda $AA,x
	bmi +++
	cmp #$50
	bcs ++
+++	
	inc $AA,x
	bra ++
+	
	stz $AA,x
++	
	lda $15
	and #$01
	beq +
	stz $157C,x
	lda $B6,x
	bmi +++
	cmp #$18
	bcs ++
+++	
	inc $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq +
	lda #$01
	sta $157C,x
	lda $B6,x
	bpl +++
	cmp #$E8
	bcc ++
+++	
	dec $B6,x
	bra ++
+	
	stz $B6,x
++	
	stz !hat_gfx
	ldy #$00
	lda $157C,x
	bne +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	ldy $9E,x
	cpy #$28
	beq ..big
	sec
	sbc #$05
	bra +
..big	
	pha
	lda $E4,x
	clc
	adc #$18
	sta !hat_x_lo
	lda $14E0,x
	adc #$00
	sta !hat_x_hi
	pla
	sec
	sbc #$06
+	
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts

.swooper
	lda #$02
	sta $C2,x
	lda $15
	and #$08
	beq +
	lda $AA,x
	bpl +++
	cmp #$F8
	bcc ++
+++	
	dec $AA,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $AA,x
	bmi +++
	cmp #$09
	bcs ++
+++	
	inc $AA,x
++	
	lda $15
	and #$01
	beq +
	stz $157C,x
	lda $B6,x
	bmi +++
	cmp #$11
	bcs ++
+++	
	inc $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $157C,x
	lda $B6,x
	bpl +++
	cmp #$EF
	bcc ++
+++	
	dec $B6,x
++	
	lda #$08
	sta !hat_gfx
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts
	
.super_koopa_floor
	lda #$02
	cmp $C2,x
	beq .super_koopa_fly
	sta $C2,x
	inc $1602,x
	dec $9E,x
	stz $AA,x
.super_koopa_fly
	ldy #$00
	lda $157C,x
	bne +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$03
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	stz !hat_gfx
	lda $15
	and #$01
	beq +
	stz $157C,x
+	
	lda $15
	and #$02
	beq +
	lda #$01
	sta $157C,x
+	
	lda $15
	and #$08
	beq +
	lda $AA,x
	cmp #$FA
	beq ++
	dec $AA,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $AA,x
	cmp #$06
	beq ++
	inc $AA,x
++	
	rts
.climb_red
	ldy #$01
	bra +
.climb_green
	ldy #$00
+	
	lda #$02
	sta !hat_gfx
	lda $1540,x
	bne +
	lda $C2,x
	bne ++
	
	lda $15
	bit #$01
	bne ..right
	bit #$02
	bne ..left
	rts
++	
	lda $15
	bit #$04
	bne ..down
	bit #$08
	bne ..up
+	
	rts
..up	
	lda #$00
	sta $157C,x
	lda #$01
;	jsr ..swap
	lda #$F8
	cpy #$00
	beq +
	lda #$F0
+	
	sta $AA,x
	rts

..down
	lda #$01
	sta $157C,x
	lda #$01
;	jsr ..swap
	lda #$08
	cpy #$00
	beq +
	lda #$10
+	
	sta $AA,x
	rts
	
..left	
	lda #$01
	sta $157C,x
	lda #$00
;	jsr ..swap
	lda #$F8
	cpy #$00
	beq +
	lda #$F0
+	
	sta $B6,x
	bra ++

..right
	lda #$00
	sta $157C,x
	lda #$00
;	jsr ..swap
	lda #$08
	cpy #$00
	beq +
	lda #$10
+	
	sta $B6,x
++	
	jsl !update_x_pos
	rts

..swap	
	sta $C2,x
	lda $AA,x
	pha
	lda $B6,x
	sta $AA,x
	pla
	sta $B6,x
	rts


.rip_van_fish
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$08
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi

	lda $C2,x
	bne ..swim
	lda $15
	and #$0F
	beq +
	lda #$01
	sta $C2,x
+	
	rts
..swim	
	lda #$40
	sta $151C,x
	
	lda $15
	and #$02
	beq +
	lda #$F0
	sta $B6,x
	bra ++
+	
	lda $15
	and #$01
	beq ++
	lda #$10
	sta $B6,x
++	
	lda $15
	and #$04
	beq +
	lda #$08
	sta $AA,x
	bra ++
+	
	lda $15
	and #$08
	beq ++
	lda #$F8
	sta $AA,x
++	
	rts

.water_fishes
	stz !hat_gfx
	ldy #$00
	lda $157C,x
	bne +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi

	
	lda $164A,x
	bne +
	rts
+
	lda #$80
	sta $1540,x

	lda $151C,x
	beq ..horz
..vert	
	lda $15
	and #$04
	beq +
	stz $C2,x
	bra ++
+	
	lda $15
	and #$08
	beq ++
	lda #$01
	sta $C2,x
++	
	lda $15
	and #$02
	beq +
	lda #$F8
	sta $B6,x
	lda #$01
	sta $157C,x
	bra ++
+	
	lda $15
	and #$01
	beq ++
	lda #$08
	sta $B6,x
	stz $157C,x
++	
	jsl !update_x_pos
	rts
..horz	
	stz $151C,x
	lda $15
	and #$01
	beq +
	stz $C2,x
	stz $157C,x
	lda #$08
	sta $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $C2,x
	sta $157C,x
	lda #$F8
	sta $B6,x
++	
	jsl !update_x_pos

	lda $15
	and #$08
	beq +
	lda $AA,x
	cmp #$F8
	beq ++
	dec $AA,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $AA,x
	cmp #$08
	beq ++
	inc $AA,x
++	
	rts
.blurp
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi

	stz $151C,x
	lda $15
	and #$01
	beq +
	stz $157C,x
	lda #$08
	sta $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda #$01
	sta $157C,x
	lda #$F8
	sta $B6,x
++	
	jsl !update_x_pos
	stz !hat_gfx
	ldy #$00
	lda $157C,x
	bne +
	iny
+	
	sty.w !hat_dir
	rts

.surface_fish
..swim	
	lda $164A,x
	bne +
	rts
+
	lda $15
	and #$01
	beq +
	lda $157C,x
	beq +
	lda $B6,x
	eor #$FF
	inc 
	sta $B6,x
	stz $157C,x
+	
	lda $15
	and #$02
	beq +
	lda $157C,x
	bne +
	lda $B6,x
	eor #$FF
	inc 
	sta $B6,x
	lda #$01
	sta $157C,x
+	
	lda $16
	bpl +
++	
	lda #$03
	sta $C2,x
	lda #$B0
	sta $AA,x
	lda #$10
	sta $1540,x
	lda $164A,x
	sta $151C,x
	stz $164A,x
+	
	rts

.floating
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	lda $E4,x
	clc
	adc #$18
	sta !hat_x_lo
	lda $14E0,x
	adc #$00
	sta !hat_x_hi
	
	lda $15
	and #$01
	beq +
	lda $E4,x
	clc
	adc #$01
	sta $E4,x
	lda $14E0,x
	adc #$00
	sta $14E0,x
+	
	lda $15
	and #$02
	beq ++
	lda $E4,x
	sec
	sbc #$01
	sta $E4,x
	lda $14E0,x
	sbc #$00
	sta $14E0,x
++	
	rts
	
.jumping_fish
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	
	lda $C2,x
	and #$01
	beq ..swim
	lda $15
	and #$01
	beq +
	lda $E4,x
	clc
	adc #$01
	sta $E4,x
	lda $14E0,x
	adc #$00
	sta $14E0,x
+	
	lda $15
	and #$02
	beq ++
	lda $E4,x
	sec
	sbc #$01
	sta $E4,x
	lda $14E0,x
	sbc #$00
	sta $14E0,x
++	
	rts
..swim	
	lda $15
	and #$01
	beq +
	lda $157C,x
	beq +
	lda $B6,x
	eor #$FF
	inc 
	sta $B6,x
	stz $157C,x
	lda $1570,x
	inc
	cmp #$04
	beq ++
	sta $1570,x
+	
	lda $15
	and #$02
	beq +
	lda $157C,x
	bne +
	lda $B6,x
	eor #$FF
	inc 
	sta $B6,x
	lda #$01
	sta $157C,x
	lda $1570,x
	inc
	cmp #$04
	beq ++
	sta $1570,x
+	
	lda $15
	and #$08
	beq +
++	
	inc $C2,x
	lda #$80
	sta $1540,x
	lda #$A0
	sta $AA,x
	stz $1570,x
+	
	rts

.xy_move
	lda $15
	and #$08
	beq +
	lda $D8,x
	sec
	sbc #$02
	sta $D8,x
	lda $14D4,x
	sbc #$00
	sta $14D4,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $D8,x
	clc
	adc #$02
	sta $D8,x
	lda $14D4,x
	adc #$00
	sta $14D4,x
++	
	lda $15
	and #$01
	beq +
	lda $E4,x
	clc
	adc #$02
	sta $E4,x
	lda $14E0,x
	adc #$00
	sta $14E0,x
+	
	lda $15
	and #$02
	beq ++
	lda $E4,x
	sec
	sbc #$02
	sta $E4,x
	lda $14E0,x
	sbc #$00
	sta $14E0,x
++	
	stz !hat_gfx
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts	

.jumping_paratroopa
	lda $15
	and #$01
	beq +
	lda $157C,x
	beq +
	lda $B6,x
	eor #$FF
	inc 
	sta $B6,x
	stz $157C,x
+	
	lda $15
	and #$02
	beq +
	lda $157C,x
	bne +
	lda $B6,x
	eor #$FF
	inc 
	sta $B6,x
	lda #$01
	sta $157C,x
+	
	lda $15
	and #$08
	beq +
	lda $AA,x
	cmp #$FA
	beq ++
	dec $AA,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $AA,x
	cmp #$06
	beq ++
	inc $AA,x
	bra ++
++	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$14
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts
.paratroopas
	lda $15
	and #$08
	beq +
	lda $AA,x
	cmp #$FC
	beq ++
	dec $AA,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $AA,x
	cmp #$04
	beq ++
	inc $AA,x
	bra ++
++	
	lda $15
	and #$01
	beq +
	lda $B6,x
	bmi +++
	cmp #$0E
	bcs ++
+++	
	inc $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda $B6,x
	bpl +++
	cmp #$F2
	bcc ++
+++	
	dec $B6,x
++	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts

.monty_mole
	lda $C2,x
	cmp #$03
	beq ..same
	rts
..same	
	lda $15
	and #$01
	beq +
	lda $B6,x
	bmi +++
	cmp #$14
	bcs ++
+++	
	inc $B6,x
	;inc $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda $B6,x
	bpl +++
	cmp #$EC
	bcc ++
+++	
	dec $B6,x
++	
	lda #$01
	ldy $B6,x
	bmi +
	lda #$00
+	
	sta $157C,x
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi

	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	rts
	
.jumping_piranha
	lda #$02
	sta !hat_gfx

	lda $D8,x
	sec
	sbc #$02
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	
	lda $C2,x
	beq ..ground

	lda $15
	and #$01
	beq +
	lda $B6,x
	bmi +++
	cmp #$08
	bcs ++
+++	
	inc $B6,x
	;inc $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda $B6,x
	bpl +++
	cmp #$F8
	bcc ++
+++	
	dec $B6,x
++

	jsl !update_x_pos
	rts
..ground
	stz $B6,x
	jsl !update_x_pos
	lda $15
	and #$08
	beq +
	lda #$C0
	sta $AA,x
	inc $C2,x
+
	rts
.banzai
	lda $15
	and #$08
	beq +
	lda $AA,x
	cmp #$FA
	beq ++
	dec $AA,x
	bra ++
+	
	lda $15
	and #$04
	beq ++
	lda $AA,x
	cmp #$06
	beq ++
	inc $AA,x
	bra ++
++	
	lda $15
	and #$01
	beq +
	lda $B6,x
	bmi +++
	cmp #$20
	bcs ++
+++	
	inc $B6,x
	inc $B6,x
	bra ++
+	
	lda $15
	and #$02
	beq ++
	lda $B6,x
	bpl +++
	cmp #$E2
	bcc ++
+++	
	dec $B6,x
	dec $B6,x
++	
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	lda $9E,x
	cmp #$1C
	beq +
	lda $E4,x
	clc
	adc #$18
	sta !hat_x_lo
	lda $14E0,x
	adc #$00
	sta !hat_x_hi
+	
	lda $D8,x
	sec
	sbc #$06
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	rts

.chuck
	stz !hat_gfx
	lda $D8,x
	sec
	sbc #$0D
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	ldy #$00
	lda $157C,x
	bne +
	iny
+
	sty.w !hat_dir

	lda $C2,x
	cmp #$02
	bcs ..return
	cmp #$01
	beq ..running
..sit	
	lda $15
	and #$01
	bne ..right
	lda $15
	and #$02
	bne ..left
	lda #$20
	sta $1540,x	
	bra ..extra_buttons
..return	
	rts
..left	
	lda #$01
	bra +
..right 
	lda #$00
+	
	sta $157C,x
	asl #2
	sta $151C,x
	lda #$01
	sta $C2,x
	bra ..run_speed
..running
	lda $15
	and #$01
	bne ...right
	lda $15
	and #$02
	bne ...left
	stz $C2,x
	lda #$20
	sta $1540,x
	bra ..extra_buttons
...left
	lda #$01
	bra +
...right
	lda #$00
+
	sta $157C,x
	asl #2
	asl $151C,x
	lda #$05
	sta $1540,x
..run_speed
	lda $15
	and #$40
	bne ..high_speed
	stz $187B,x
	bra ..extra_buttons
..high_speed
	lda #$20
	sta $187B,x
..extra_buttons
	rts
	
.rex	
	lda $15
	and #$01
	beq +
	stz $157C,x
+	
	lda $15
	and #$02
	beq +
	lda #$01
	sta $157C,x
+
	lda $1588,x
	and #$04
	beq +
	lda $16
	bpl +
	lda #$B4
	sta $AA,x
	lda #$01
	sta $1DFA
+	
	lda $D8,x
	ldy $C2,x
	bne +
	sec
	sbc #$16
	bra ++
+	
	sec
	sbc #$06
++	
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	rts
.koopa
	lda $15
	and #$01
	beq +
	stz $157C,x
+	
	lda $15
	and #$02
	beq +
	lda #$01
	sta $157C,x
+	
	lda $1588,x
	and #$04
	beq +
	lda $16
	bpl +
	lda #$B4
	sta $AA,x
	lda #$01
	sta $1DFA
	lda $9E,x
	cmp #$05
	beq ++
	cmp #$06
	bne +++
++	
	lda $157C,x
	eor #$01
	sta $157C,x
	stz $15AC,x
	lda $B6,x
	eor #$FF
	inc
	sta $B6,x
+++	
+	
	lda $D8,x
	ldy.w $9E,x
	cpy #$05
	bcc +++
++	
	cpy #$0D
	bcs +++
-	
	sec
	sbc #$12
	bra +
+++	
	cpy #$0D
	bcc -
	sec
	sbc #$06
+	
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi

	stz !hat_gfx
	ldy #$00
	lda $B6,x
	bmi +
	iny
+	
	sty.w !hat_dir
	rts
