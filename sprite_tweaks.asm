;shelless koopas

;Banzai Main
org $02D598
	JSR $D288
	JSR $D294
	JSL $01A7DC
Bank2Return:
	RTS

;Banzai Graphics
org $02D5E7
autoclean jml NewBanzaiGraphics
;Banzai Init
org $018390
autoclean jsl BanzaiSetSpeed
	rts
;Chuck running speed
org $02C6D4
	JSR Chuckspeed1
org $02C78E
	JSR Chuckspeed2
org $02C659
	JSR Chuckspeed2
org $02FFE2
Chuckspeed1:
autoclean JML ChuckspeedA
Chuckspeed2:
autoclean JML ChuckspeedB
org $02C79D
autoclean jml chuck_fix
org $01E3A1
autoclean jml monty_fix
org $01E3D8
autoclean jml monty_fix2
org $01C77A
autoclean jml brown_chained_platform_fix
org $01B852
autoclean jml turn_block_bridge_fix
org $02BFF6
	jsr $D288
	jsr $D294
	jsl $019138

org $02CAFA
	db $4B,$0B

org $019032
autoclean jml mass_handle_gravity

org $01ABD8
autoclean jml bank1_update_handle

org $02D294
autoclean jsl bank2_update_handle

freecode

bank1_update_handle:
	cpx #$0C
	beq +
	bcc .wat
+	
	txa
	sec
	sbc #$0B
	cmp !hat_index
	beq .check
	bra .already_ran
.wat	
	cpx !hat_index
	bne .already_ran
.check	
	lda !hat_run
	bne .already_ran
	lda #$01
	sta !hat_run
	jsr handle_sprites
.already_ran
	lda $AA,x
	beq .finish
	jml $01ABDC
.finish
	jml $01AC09

bank2_update_handle:
	cpx #$0C
	bcc .wat
	txa
	sec
	sbc #$0B
	cmp !hat_index
	beq .check
	bra .already_ran
.wat
	cpx !hat_index
	bne .already_ran
.check	
	lda !hat_run
	bne .already_ran
	phx
	lda #$01
	sta !hat_run
	ldx !hat_index
	jsr handle_sprites
	plx
.already_ran
	lda $AA,x
	asl #2
	rtl

mass_handle_gravity:
	cpx !hat_index
	bne .not_same
	jsr handle_sprites
	lda #$01
	sta !hat_run
.not_same
	phk
	pea.w .same-1
	pea $80C9
	jml $01ABD8
.same
	ldy #$00
	jml $019037

incsrc sprite_code.asm

chuck_fix:
	cpx !hat_index
	bne +
	lda !hat_transition
	bne .return
+	
	lda $1564,x
	bne .return
	jml $02C7A2
.return
	jml $02C80F


BanzaiSetSpeed:
	LDA #$09
	STA $1DFC

	LDA #$E8
	STA $B6,X
	LDA #$00
	STA $AA,X
	RTL

	
NewBanzaiGraphics:
	LDA $B6,x
	BPL .right
	PHX
	LDX #$0F
-	LDA $00
	CLC
	ADC.l .BBX,X
	STA $0300,Y
	LDA $01
	CLC
	ADC.l .BBY,X
	STA $0301,Y
	LDA.l .BBT1,X
	STA $0302,Y
	LDA.l .BBP1,X
	STA $0303,Y
	INY
	INY
	INY
	INY
	DEX
	BPL -
	PLX
	LDY #$02
	LDA #$0F
	JML $02B7A7
	
.right
	PHX
	LDX #$0F
-	LDA $00
	CLC
	ADC.l .BBX,X
	STA $0300,Y
	LDA $01
	CLC
	ADC.l .BBY,X
	STA $0301,Y
	LDA.l .BBT2,X
	STA $0302,Y
	LDA.l .BBP2,X
	STA $0303,Y
	INY
	INY
	INY
	INY
	DEX
	BPL -
	PLX
	LDY #$02
	LDA #$0F
	JML $02B7A7
.BBX
	db $00,$10,$20,$30
	db $00,$10,$20,$30
	db $00,$10,$20,$30
	db $00,$10,$20,$30
.BBY
	db $00,$00,$00,$00
	db $10,$10,$10,$10
	db $20,$20,$20,$20
	db $30,$30,$30,$30
.BBT1
	db $80,$82,$84,$86
	db $A0,$88,$CE,$EE
	db $C0,$C2,$CE,$EE
	db $8E,$AE,$84,$86
.BBP1
	db $33,$33,$33,$33
	db $33,$33,$33,$33
	db $33,$33,$33,$33
	db $33,$33,$B3,$B3
.BBT2
	db $86,$84,$82,$80
	db $EE,$CE,$88,$A0
	db $EE,$CE,$C2,$C0
	db $86,$84,$AE,$8E
.BBP2
	db $73,$73,$73,$73
	db $73,$73,$73,$73
	db $73,$73,$73,$73
	db $F3,$F3,$73,$73

ChuckspeedA:
	PHA
	TXA
	CMP !hat_index
	BEQ +
	PLA
	STA $187B,x
	BRA ++
+	PLA
++	JML Bank2Return
ChuckspeedB:
	PHA
	TXA
	CMP !hat_index
	BEQ +
	PLA
	INC $187B,x
	BRA ++
+	PLA
++	JML Bank2Return

brown_chained_platform_fix:
	cpx !hat_index
	bne +
	jsr handle_sprites
	lda $D8,x
	sec
	sbc #$14
	sta $96
	lda $14D4,x
	sbc #$00
	sta $97
+	
	lda $13
	and #$03
	jml $01C77E

monty_fix:
	cpx !hat_index
	beq .fix
	jsl $01ACF9
	jml $01E3A5
.fix	
	jml $01E3C0

monty_fix2:
	cpx !hat_index
	beq +
	sta $B6,x
+	
	lda $1558,x
	jml $01E3DD

pushpc
org $038D6F
	jml info_box_fix
pullpc

info_box_fix:
	cpx !hat_index
	bne .no_control
	lda !hat_transition
	cmp #$01
	bne .no_control
	lda #$01
	sta !hat_run
	jsr handle_sprites
	lda $D8,x
	sec
	sbc #$08
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
	jsl $0190B2
	ldy $15EA,x
	lda #$C0
	sta $0302,y
	jml $038DBA
.no_control
	jsl $01B44F
	jml $038D73

turn_block_bridge_fix:
	cpx !hat_index
	bne .control
	lda !hat_transition
	cmp #$01
	bne .control
	lda #$01
	sta !hat_run
	jsr handle_sprites
	lda $D8,x
	sec
	sbc #$08
	sta !hat_y_lo
	lda $14D4,x
	sbc #$00
	sta !hat_y_hi
.control
	lda $15C4,x
	bne .return
	jml $01B857
.return	
	jml $01B8B1

pushpc
org $0388CB
	jml swooper_fix
pullpc

swooper_fix:
	jsl $018022
	jsl $01801A
	cpx !hat_index
	bne .no_control
	lda !hat_transition
	cmp #$01
	bne .no_control
	lda $14
	and #$04
	lsr #2
	inc
	sta $1602,x
	jml $0388DF
.no_control
	jml $0388D3

pushpc
org $01D755
	jsl line_guide_fix
	nop
pullpc
line_guide_fix:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	lda #$01
	sta !hat_run
	jsr handle_sprites
+	
	lda $9D
	ora $1626,x
	rtl

pushpc
org $02EADA
	jsl warp_hole_fix
pullpc
warp_hole_fix:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	lda #$01
	sta !hat_run
	jsr handle_sprites
+	
	jsl $01A7DC
	rtl

pushpc
org $01F8FC
	jml fix_boo
	nop
pullpc	
fix_boo:
	sta $1540,x
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	jml $01F90C
+	
	lda $C2,x
	jml $01F901

pushpc
org $02F078
	jml fix_wiggler
	nop
org $02F202
	jml fix_wiggler_2
pullpc
fix_wiggler_2:
	lda !hat_transition
	beq +
	jml $02F295
+	
	lda $E4,x
	sta $00
	jml $02F206
fix_wiggler:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	jml $02F086
+	
	lda $1534,x
	and #$3F
	jml $02F07D

pushpc
org $02A3F6
	jml fix_extended_sprites
pullpc
fix_extended_sprites:
	lda !hat_transition
	beq +
	jml $02A468
+	
	lda $13F9
	eor $1779,x
	jml $02A3FC

pushpc
org $02C095
	jml rip_van_fish_fix
org $02BFD8
	jsl rip_van_fish_fix_2
pullpc

rip_van_fish_fix_2:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	lda #$01
	sta !hat_run
	jsr handle_sprites
+	
	jml $01803A
rip_van_fish_fix:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	beq ++
+	
	lda $13
	and #$07
	bne ++
	jml $02C09B
++	
	jml $02C0BB

pushpc
org $018FFE
	jml bullet_bill_fix
	nop
pullpc

bullet_bill_fix:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	jml $019008
+	
	phx
	tyx
	lda.l $018FD7,x
	plx
	sta $B6,x
	jml $019003

pushpc
org $01E9E9
	jml lakitu_fix
pullpc
lakitu_fix:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	lda $18BF
	bne +
	jml $01E9EE
+	
	jml $01E9F9

pushpc
org $039CC9
	jml rihno_fix
org $039D80
	jml rihno_fix_2
pullpc
rihno_fix:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	jml $039CDA
+	
	asl #4
	jml $039CCD

rihno_fix_2:
	cpx !hat_index
	bne +
	lda !hat_transition
	cmp #$01
	bne +
	jml $039D9D
+	
	txa
	eor $13
	and #$03
	jml $039D85