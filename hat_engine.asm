!hat_x_lo		= $60
!hat_x_hi		= $61
!hat_y_lo		= $62
!hat_y_hi		= $63
!hat_gfx		= $5C
!hat_throw		= $58
!hat_x_speed		= $79
!hat_y_speed		= $7C
!hat_timer		= $87
!hat_x_fraction		= $0F5E
!hat_y_fraction		= $0F5F
!hat_sprite		= $0F60
!hat_index		= $0F61
!hat_jump		= $0F62
!hat_dir		= $0F63
!hat_anim		= $0F64
!hat_transition		= $0F65
!hat_interaction	= $0F66
!hat_spr_interact	= $0F67
!hat_disable_barrier	= $0F68
!hat_run		= $0F69
!hat_return		= $0F6A
!execute_pointer	= $0086DF
!get_sprite_clip_a	= $03B69F
!get_sprite_clip_b	= $03B6E5
!get_mario_clip		= $03B664
!get_contact		= $03B72B
!update_y_pos		= $01801A
!update_x_pos		= $018022

org $00A2E6
autoclean jsl hat_main
org $00CDF6
	db $80
org $01A7E4
autoclean jml sprite_interact
	nop
org $00E942
autoclean jml layer_interact
org $00E98C
autoclean jml disable_barrier
org $00F595
autoclean jml disable_bottom_top
org $00D062
autoclean jml disable_powerups
org $009F6F
autoclean jml clear_ram

freecode

layer_interact:
	sta $8F
	lda !hat_transition
	bne .end
	lda $5B
	jml $00E946
.end	
	jml $00E978

clear_ram:
	stz !hat_x_lo
	stz !hat_x_hi
	stz !hat_y_lo
	stz !hat_y_hi
	stz !hat_gfx
	stz !hat_throw
	stz !hat_x_speed
	stz !hat_y_speed
	stz !hat_timer
	stz !hat_x_fraction
	stz !hat_y_fraction
	stz !hat_jump
	stz !hat_dir
	stz !hat_anim
	stz !hat_transition
	stz !hat_interaction
	stz !hat_spr_interact
	stz !hat_disable_barrier
	stz !hat_run
	lda #$FF
	sta !hat_sprite
	sta !hat_index
	dec $0DB1
	bpl .end
	jml $009F74
.end	
	jml $009F6E

disable_powerups:
	lda !hat_transition
	bne +
	lda $19
	cmp #$02
	jml $00D066
+	
	jml $00D080

disable_barrier:
	lda !hat_disable_barrier
	beq .nope
	jml $00E9FB
.nope	
	lda $1B96
	beq .barrier
	jml $00E991
.barrier
	jml $00E9A1

disable_bottom_top:
	lda !hat_disable_barrier
	beq .nope
	jml $00F5B6
.nope
	rep #$20
	lda #$FF80
	jml $00F59A	

sprite_interact:
	lda !hat_spr_interact
	bne .disable
	lda $167A,x
	and #$20
	jml $01A7E9
.disable
	jml $01A7F5

hat_main:
	phb
	phk
	plb
	jsr hat_code
	plb
	rtl

hat_code: 
	jsl $028AB1
	lda !hat_throw
	beq +
	stz $00
	lda !hat_x_lo
	sec
	sbc $1A
	sta $02F8
	lda !hat_x_hi
	sbc $1B
	beq $02
	inc $00
	lda !hat_y_lo
	sec
	sbc $1C
	sta $02F9
	lda !hat_y_hi
	sbc $1D
	beq ++
	lda #$F0
	sta $02F9
	bra +
++	
	lda !hat_dir
	ror #3
	ora $64
	sta $02FB
	lda #$0A
	sta $02FA
	lda #$02
	ora $00
	sta $045E
+	
	lda !hat_transition
	beq .throw
	cmp #$02
	beq .transition
	jmp .on_sprite
.throw
	lda !hat_throw
	beq ..on_mario
	jmp .controlling
..on_mario
	jmp .on_mario
.transition
	inc !hat_anim
	lda !hat_anim
	lsr #2
	and #$03
	tax
	lda.l .frames,x
	sta !hat_gfx
	jsr .glitter

	lda !hat_return
	dec
	beq ..return_mario
	sta !hat_return
	ldx !hat_index
	lda $14C8,x
	cmp #$08
	bne ..return_mario
	jsr .prepare_aim_sprite
	lda #$32
	jsr .aiming
	lda $00
	sta $7B
	lda $02
	sta $7D

	lda $E4,x
	sta !hat_x_lo
	lda $14E0,x
	sta !hat_x_hi
	lda $D8,x
;	sec
;	sbc #$10
	sta !hat_y_lo
	lda $14D4,x
;	sbc #$00
	sta !hat_y_hi

	lda #$80
	sta $1406
	jsl !get_sprite_clip_a
	jsr .get_mario_clip
	jsl !get_contact
	bcc ..return
	dec !hat_transition
	lda #$FF
	sta $78
	lda $E4,x
	sta $94
	lda $14E0,x
	sta $95
	lda $D8,x
	sta $96
	lda $14D4,x
	sta $97
	rts
..return
	rts
...mario
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
	lda #$2A
	sta $1DFC
	rts

.on_mario
	lda $18
	and #$30
	beq ..no_throw
	inc !hat_throw
	lda #$06
	sta $1DFC
	stz $00
	ldx $76
	lda ..x_speed,x
	sta !hat_x_speed
	stz !hat_y_speed
	stz !hat_y_fraction
	stz !hat_x_fraction
	stz !hat_jump
	stz !hat_run
	lda #$FF
	sta !hat_sprite
	sta !hat_index
	lda #$68
	sta !hat_timer
	txa
	asl
	tax
	rep #$20
	lda $94
	clc
	adc.l ..x_disp,x
	sta !hat_x_lo
	lda $96
	clc
	adc #$000A
	sta !hat_y_lo
	sep #$20
	stz !hat_gfx
	lda $76
	sta !hat_dir
..no_throw
	rts

..x_disp
	dw $FFF8,$0008
..x_speed
	db $CC,$34

.glitter
	lda $13
	and #$0F
	bne ..ret
	jsl $01ACF9
	and #$0F
	clc
	ldy #$00
	adc #$FC
	bpl $01
	dey
	clc
	adc !hat_x_lo
	sta $02
	tya
	adc !hat_x_hi
	pha
	lda $02
	cmp $1A
	pla
	sbc $1B
	bne ..ret
	lda $148E
	and #$0F
	clc
	adc #$FE
	adc !hat_y_lo
	sta $00
	lda !hat_y_hi
	adc #$00
	sta $01
	jsl $0285BA
..ret
	rts

.frames
	db $00,$02,$04,$06
.controlling
	lda $9D
	bne ..freeze
	jsr .glitter
	lda !hat_timer
	beq ..return_to_mario
	dec !hat_timer
	lda $14
	lsr
	beq ..boing
	lda !hat_x_speed
	beq ..boing
	bpl $02
	inc
	inc
	dec
	sta !hat_x_speed
..boing
	jmp ..do_boing
..return
	jsr .sprite
	inc !hat_anim
	lda !hat_anim
	lsr #2
	and #$03
	tax
	lda.l .frames,x
	sta !hat_gfx
	jsr .update_hat_pos
..freeze
	rts

..return_to_mario
	jsr .prepare_aim
	lda #$44
	jsr .aiming
	lda $00
	sta !hat_x_speed
	lda $02
	sta !hat_y_speed
	lda !hat_timer
	cmp #$40
	bcs ..return
	jsr .get_hat_clip
	jsl !get_mario_clip
	jsl !get_contact
	bcc ..return
	lda !hat_jump
	bne ..same
	jsr .get_hat_clip_top
	jsl !get_mario_clip
	jsl !get_contact
	bcc ..same
	jsl $01AA33
	jsl $01AB99
	inc !hat_jump
	lda #$08
	sta $1DFC
	jmp ..return
..same	
	stz !hat_throw
	lda #$0D
	sta $1DF9
	jmp ..return

..do_boing
	lda !hat_timer
	cmp #$40
	bcs ...return
	jsr .get_hat_clip
	jsl !get_mario_clip
	jsl !get_contact
	bcc ...return
	lda !hat_jump
	bne ...return
	jsr .get_hat_clip_top
	jsl !get_mario_clip
	jsl !get_contact
	bcc ...return
	jsl $01AA33
	jsl $01AB99
	inc !hat_jump
	lda #$08
	sta $1DFC
...return
	jmp ..return

.sprite	
	ldx #$0B
..loop	
	lda $14C8,x
	cmp #$08
	bne ..try_again
	lda $167A,x
	and #$20
	bne ..process_interact
	txa
	eor $13
	and #$01
	ora $15A0,x
	beq ..process_interact
..try_again
	dex
	bpl ..loop
	rts

..process_interact
	lda !hat_x_lo
	sec
	sbc $E4,x
	clc
	adc #$50
	cmp #$A0
	bcs ..try_again
	lda !hat_y_lo
	sec
	sbc $D8,x
	clc
	adc #$60
	cmp #$C0
	bcs ..try_again
	jsr .get_hat_clip
	jsl !get_sprite_clip_b
	jsl !get_contact
	bcc ..try_again
	ldy.w $9E,x
	lda.w enable_sprite,y
	beq ..try_again
..init
	stx !hat_index
	sta !hat_sprite
	lda #$80
	sta $1406
	lda #$40
	sta !hat_return
	lda #$02
	sta !hat_transition
	lda #$01
	sta !hat_spr_interact
	sta !hat_disable_barrier
	lda $5B
	sta !hat_interaction
	ora #$40
	sta $5B
	lda #$40
	sta $1497
	lda #$10
	sta $1DF9
	lda $E4,x
	sta !hat_x_lo
	lda $14E0,x
	sta !hat_x_hi
	lda $D8,x
	sta !hat_y_lo
	lda $14D4,x
	sta !hat_y_hi
	rts 

.on_sprite
	jsr .glitter
	lda #$80
	sta $1406
	stz !hat_run
	ldx !hat_index
	lda $E4,x
	sta !hat_x_lo
	sta $94
	lda $14E0,x
	sta !hat_x_hi
	sta $95
	lda $D8,x
	sta !hat_y_lo
	sec
	sbc #$10
	sta $96
	lda $14D4,x
	sta !hat_y_hi
	sbc #$00
	sta $97
	sta $1497
	stz $7B
	stz $7D
	stz $1713
	stz $1714
	stz $148F
	stz $1470

	lda $1DFC
	cmp #$06
	bne ..no_mute
	stz $1DFC
..no_mute
	lda $1DF9
	cmp #$02
	beq ..mute_1DF9
	cmp #$0E
	beq ..mute_1DF9
	cmp #$0F
	bne ..no_mute_1DF9
..mute_1DF9
	stz $1DF9
..no_mute_1DF9

	lda #$FF
	sta $78
	lda $14C8,x
	cmp #$08
	bne ..get_out
	lda $18
	and #$30
	beq ..keep
..get_out
	lda #$40
	sta $1497
	stz $78
	ldy #$F0
	lda !hat_dir
	beq +
	ldy #$10
+	
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
..keep	
	rts


.get_mario_clip
	lda $94
	clc
	adc #$06
	sta $00
	lda $95
	adc #$00
	sta $08
	lda $96
	sec
	sbc #$04
	sta $01
	lda $97
	sbc #$00
	sta $09
	lda #$04
	sta $02
	lda #$28
	sta $03
	rts

.get_hat_clip
	lda !hat_x_lo
	sec
	sbc #$02
	sta $04
	lda !hat_x_hi
	sbc #$00
	sta $0A
	lda !hat_y_lo
	sec
	sbc #$02
	sta $05
	lda !hat_y_hi
	sbc #$00
	sta $0B
	lda #$14
	sta $06
	sta $07
	rts
..top
	lda !hat_x_lo
	sec
	sbc #$02
	sta $04
	lda !hat_x_hi
	sbc #$00
	sta $0A
	lda !hat_y_lo
	sec
	sbc #$02
	sta $05
	lda !hat_y_hi
	sbc #$00
	sta $0B
	lda #$14
	sta $06
	lda #$04
	sta $07
	rts

.update_hat_pos
	lda !hat_y_speed
	beq ..no_y
	asl #4
	clc
	adc !hat_y_fraction
	sta !hat_y_fraction
	php
	ldy #$00
	lda !hat_y_speed
	lsr #4
	cmp #$08
	bcc $03
	ora #$F0
	dey
	plp
	adc !hat_y_lo
	sta !hat_y_lo
	tya
	adc !hat_y_hi
	sta !hat_y_hi
..no_y	
	lda !hat_x_speed
	beq ..no_x
	asl #4
	clc
	adc !hat_x_fraction
	sta !hat_x_fraction
	php
	ldy #$00
	lda !hat_x_speed
	lsr #4
	cmp #$08
	bcc $03
	ora #$F0
	dey
	plp
	adc !hat_x_lo
	sta !hat_x_lo
	tya
	adc !hat_x_hi
	sta !hat_x_hi
..no_x	
	rts

.prepare_aim
	REP #$20			;\horizontal for $00 (signed, $00 = negative if mario is right)
	LDA !hat_x_lo			;|
	SEC				;|
	SBC $94				;|
	STA $00				;/
	LDA !hat_y_lo			;\vertical for $02 (signed, $02 =  negative if mario is lower)
	SEC				;|
	SBC #$0006			;|\Don't aim for mario's upper half
	SEC				;|/
	SBC $96				;|
	STA $02				;/
	LDA $00				;\Absolute value for horizontal distance in $04
	BPL ..PositiveH			;|
	EOR #$FFFF			;|
	INC				;|
..PositiveH				;|
	STA $04				;/
	LDA $02				;\Absolute value for vertical distance in $06
	BPL ..PositiveV			;|Same reason as above.
	EOR #$FFFF			;|
	INC				;|
..PositiveV				;|
	STA $06				;/

	LDA $04				;\If horizontal distance exceed #$0100, reduce X:Y ratio
	CMP #$0100			;|by dividing both by 2.
	BCS ..DivideXYBy2		;/
	LDA $06				;\Otherwise check vertical distance
	CMP #$0100			;|
	BCS ..DivideXYBy2		;/
	SEP #$20
	rts
..DivideXYBy2
	LDA $04				;\Divide and store half of unsigned x distance in $04
	LSR A				;|(rounded half up).
	ADC #$0000			;|
	STA $04				;/
	LDA $06				;\Divide and store half of unsigned y distance in $06
	LSR A				;|(rounded half up)
	ADC #$0000			;|
	STA $06				;/

	LDY #$02			;>index, use as a loop to handle x and y distance all in one block.
-
	LDA.w $00,y			;\convert half horiz and vertical distance to signed horiz and vert distance
	BMI ..MarioRightDown		;|
	LDA.w $04,y			;|
	BRA +				;|
..MarioRightDown				;|
	LDA.w $04,y			;|
	EOR #$FFFF			;|
	INC				;|
+	STA.w $00,y			;|
	DEY				;|
	DEY				;|
	BPL -				;/
	SEP #$20			;>Phew, now its done.
	rts

.prepare_aim_sprite
	
	REP #$20			;\horizontal for $00 (signed, $00 = negative if mario is right)
	LDA $94				;|
	SEC				;|
	SBC !hat_x_lo			;|
	STA $00				;/
	LDA $96				;\vertical for $02 (signed, $02 =  negative if mario is lower)
;	SEC				;|
;	SBC #$0010			;|\Don't aim for mario's upper half
	SEC				;|/
	SBC !hat_y_lo			;|
	STA $02				;/
	LDA $00				;\Absolute value for horizontal distance in $04
	BPL ..PositiveH			;|
	EOR #$FFFF			;|
	INC				;|
..PositiveH				;|
	STA $04				;/
	LDA $02				;\Absolute value for vertical distance in $06
	BPL ..PositiveV			;|Same reason as above.
	EOR #$FFFF			;|
	INC				;|
..PositiveV				;|
	STA $06				;/

	LDA $04				;\If horizontal distance exceed #$0100, reduce X:Y ratio
	CMP #$0100			;|by dividing both by 2.
	BCS ..DivideXYBy2		;/
	LDA $06				;\Otherwise check vertical distance
	CMP #$0100			;|
	BCS ..DivideXYBy2		;/
	SEP #$20
	rts
..DivideXYBy2
	LDA $04				;\Divide and store half of unsigned x distance in $04
	LSR A				;|(rounded half up).
	ADC #$0000			;|
	STA $04				;/
	LDA $06				;\Divide and store half of unsigned y distance in $06
	LSR A				;|(rounded half up)
	ADC #$0000			;|
	STA $06				;/

	LDY #$02			;>index, use as a loop to handle x and y distance all in one block.
-
	LDA.w $00,y			;\convert half horiz and vertical distance to signed horiz and vert distance
	BMI ..MarioRightDown		;|
	LDA.w $04,y			;|
	BRA +				;|
..MarioRightDown				;|
	LDA.w $04,y			;|
	EOR #$FFFF			;|
	INC				;|
+	STA.w $00,y			;|
	DEY				;|
	DEY				;|
	BPL -				;/
	SEP #$20			;>Phew, now its done.
	rts

.aiming
		PHX
		PHY
		PHP
		SEP #$30
		STA $0F
		
		LDX #$00
		REP #$20
		LDA $00
		BPL ..pos_dx
		EOR #$FFFF
		INC
		INX
		INX
		STA $00
..pos_dx
		SEP #$20
		STA $4202
		STA $4203
		
		NOP
		NOP
		NOP
		REP #$20
		LDA $4216
		STA $04
		LDA $02
		BPL ..pos_dy
		EOR #$FFFF
		INC
		INX
		STA $02
..pos_dy
		SEP #$20
		STA $4202
		STA $4203
		STX $0E
		
		REP #$30
		LDA $04
		CLC
		ADC $4216
		LDY #$0000
		BCC ..loop
		INY
		ROR
		LSR
..loop
		CMP #$0100
		BCC +
		INY
		LSR
		LSR
		BRA ..loop
	+	CLC
		ASL
		TAX
		LDA ..recip_sqrt_lookup,x
	-	DEY
		BMI +
		LSR
		BRA -
	+	SEP #$30
		
		STA $4202
		LDA $0F
		STA $4203
		NOP
		STZ $05
		STZ $07
		LDA $4217
		STA $04
		XBA
		STA $4202
		LDA $0F
		STA $4203
		
		REP #$20
		LDA $04
		CLC
		ADC $4216
		STA $04
		SEP #$20
		
		LDX #$02
	-	LDA $04
		STA $4202
		LDA $00,x
		STA $4203
		
		NOP
		NOP
		NOP
		NOP
		
		LDA $4217
		STA $06
		LDA $05
		STA $4202
		LDA $00,x
		STA $4203

		REP #$20
		LDA $06
		CLC
		ADC $4216
		SEP #$20
		
		LSR $0E
		BCS +
		EOR #$FF
		INC
	+	STA $00,x
		DEX
		DEX
		BPL -
		
		PLP
		PLY
		PLX
		RTs
		
	
..recip_sqrt_lookup:
		dw $0000,$FFFF,$B505,$93CD,$8000,$727D,$6883,$60C2
		dw $5A82,$5555,$50F4,$4D30,$49E7,$4700,$446B,$4219
		dw $4000,$3E17,$3C57,$3ABB,$393E,$37DD,$3694,$3561
		dw $3441,$3333,$3235,$3144,$3061,$2F8A,$2EBD,$2DFB
		dw $2D41,$2C90,$2BE7,$2B46,$2AAB,$2A16,$2987,$28FE
		dw $287A,$27FB,$2780,$270A,$2698,$262A,$25BF,$2557
		dw $24F3,$2492,$2434,$23D9,$2380,$232A,$22D6,$2285
		dw $2236,$21E8,$219D,$2154,$210D,$20C7,$2083,$2041
		dw $2000,$1FC1,$1F83,$1F46,$1F0B,$1ED2,$1E99,$1E62
		dw $1E2B,$1DF6,$1DC2,$1D8F,$1D5D,$1D2D,$1CFC,$1CCD
		dw $1C9F,$1C72,$1C45,$1C1A,$1BEF,$1BC4,$1B9B,$1B72
		dw $1B4A,$1B23,$1AFC,$1AD6,$1AB1,$1A8C,$1A68,$1A44
		dw $1A21,$19FE,$19DC,$19BB,$199A,$1979,$1959,$1939
		dw $191A,$18FC,$18DD,$18C0,$18A2,$1885,$1869,$184C
		dw $1831,$1815,$17FA,$17DF,$17C5,$17AB,$1791,$1778
		dw $175F,$1746,$172D,$1715,$16FD,$16E6,$16CE,$16B7
		dw $16A1,$168A,$1674,$165E,$1648,$1633,$161D,$1608
		dw $15F4,$15DF,$15CB,$15B7,$15A3,$158F,$157C,$1568
		dw $1555,$1542,$1530,$151D,$150B,$14F9,$14E7,$14D5
		dw $14C4,$14B2,$14A1,$1490,$147F,$146E,$145E,$144D
		dw $143D,$142D,$141D,$140D,$13FE,$13EE,$13DF,$13CF
		dw $13C0,$13B1,$13A2,$1394,$1385,$1377,$1368,$135A
		dw $134C,$133E,$1330,$1322,$1315,$1307,$12FA,$12ED
		dw $12DF,$12D2,$12C5,$12B8,$12AC,$129F,$1292,$1286
		dw $127A,$126D,$1261,$1255,$1249,$123D,$1231,$1226
		dw $121A,$120F,$1203,$11F8,$11EC,$11E1,$11D6,$11CB
		dw $11C0,$11B5,$11AA,$11A0,$1195,$118A,$1180,$1176
		dw $116B,$1161,$1157,$114D,$1142,$1138,$112E,$1125
		dw $111B,$1111,$1107,$10FE,$10F4,$10EB,$10E1,$10D8
		dw $10CF,$10C5,$10BC,$10B3,$10AA,$10A1,$1098,$108F
		dw $1086,$107E,$1075,$106C,$1064,$105B,$1052,$104A
		dw $1042,$1039,$1031,$1029,$1020,$1018,$1010,$1008

;01 basic
;02 banzai
;03 rex
;04 chucks
;05 jumping piranhas
;06 monty moles
;07 paratroopas (FIXME)
;08 jumping paratroopas (FIXME)
;09 platforms basic movement
;0a jumping fish
;0b water fishes
;0c surface fish
;0d floating stuff
;0e blurp
;0f rip van fish FIXME
;10 climbing green koopa
;11 climbing red koopa
;12 super koopa floor
;13 super koopa flying
;14 swooper
;15 boo
;16 eerie
;17 thwimp
;18 thwomp
;19 ballnchain
;1a dry bones
;1b line guided stuff (FIXME)
;1c wall followers
;1D wiggler
;1E urchin
;1F lakitu cloud
;20 bubble
;21 rihnos

enable_sprite:
	db $01,$01,$01,$01,$01,$01,$01,$01	;00-07
	db $07,$08,$07,$07,$01,$01,$01,$01	;08-0F
	db $01,$01,$01,$01,$01,$0B,$0B,$00	;10-17
	db $0C,$00,$00,$00,$02,$00,$00,$00	;18-1F
	db $00,$09,$10,$11,$10,$11,$18,$17	;20-27
	db $15,$00,$00,$00,$00,$00,$1C,$00	;28-2F
	db $00,$00,$1A,$00,$00,$00,$00,$15	;30-37
	db $16,$16,$1E,$1E,$1C,$0F,$09,$00	;38-3F
	db $00,$09,$09,$09,$00,$00,$04,$0A	;40-47
	db $00,$00,$00,$00,$00,$06,$06,$05	;48-4F
	db $05,$00,$00,$00,$00,$09,$09,$09	;50-57
	db $09,$09,$09,$09,$09,$09,$09,$09	;58-5F
	db $09,$09,$1B,$1B,$1B,$1B,$1B,$1B	;60-67
	db $1B,$00,$00,$09,$09,$09,$21,$21	;68-6F
	db $00,$13,$13,$12,$09,$09,$09,$09	;70-77
	db $09,$00,$00,$09,$00,$09,$00,$00	;78-7F
	db $09,$09,$00,$09,$09,$00,$1D,$1F	;80-87
	db $00,$00,$00,$00,$00,$00,$09,$09	;88-8F
	db $09,$04,$04,$04,$04,$04,$04,$04	;90-97
	db $04,$00,$00,$00,$09,$20,$19,$02	;98-9F
	db $09,$09,$00,$09,$0D,$1C,$1C,$00	;A0-A7
	db $00,$00,$00,$03,$09,$09,$00,$15	;A8-AF
	db $00,$09,$00,$00,$00,$00,$00,$09	;B0-B7
	db $09,$09,$09,$09,$00,$00,$14,$00	;B8-BF
	db $09,$09,$0E,$00,$09,$00,$09,$09	;C0-C7
	db $09,$00,$00,$00,$00,$00,$00,$00	;C8-CF
	db $00,$00,$00,$00,$00,$00,$00,$00	;D0-D7
	db $00,$00,$00,$00,$00,$00,$00,$00	;D8-DF
	db $00,$00,$00,$00,$00,$00,$00,$00	;E0-E7
	db $00,$00,$00,$00,$00,$00,$00,$00	;E8-EF
	db $00,$00,$00,$00,$00,$00,$00,$00	;F0-F7
	db $00,$00,$00,$00,$00,$00,$00,$00	;F8-FF
	
incsrc MarioGFXDMA.asm
incsrc sprite_tweaks.asm
