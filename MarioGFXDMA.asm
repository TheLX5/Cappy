header : lorom

!Tile = $0C		;Tile where the extended tiles will be loaded to. Takes up 2 8x8's
			;located in SP1


org $00A300
autoclean JML BEGINDMA

org $00F691
ADC.w #BEGINXTND

org $00E1D4+$2B
db $00,$8C,$14,$14,$2E
db $00,$CA,$16,$16,$2E
db $00,$8E,$18,$18,$2E
db $00,$EB,$1A,$1A,$2E
db $04,$ED,$1C,$1C

org $00DF1A
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00

db $00,$00,$00,$00,$00,$00,$28,$00
db $00

db $00,$00,$00,$00,$82,$82,$82,$00
db $00,$00,$00,$00,$84,$00,$00,$00
db $00,$86,$86,$86,$00,$00,$88,$88
db $8A,$8A,$8C,$8C,$00,$00,$90,$00
db $00,$00,$00,$8E,$00,$00,$00,$00
db $92,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00

db $00,$00,$00,$00,$82,$82,$82,$00
db $00,$00,$00,$00,$84,$00,$00,$00
db $00,$86,$86,$86,$00,$00,$88,$88
db $8A,$8A,$8C,$8C,$00,$00,$90,$00
db $00,$00,$00,$8E,$00,$00,$00,$00
db $92,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00

org $00E3B1
JSR chartilehijack

org $00E40D
JSR capetilehijack

org $00DFDA
db $00,$02,$80,$80		;[00-03]
db $00,$02,!Tile,!Tile+$1	;[04-07]
chartilehijack:
LDA $DF1A,y
BPL +
AND #$7F
STA $0D
LDA #$04
+
RTS
capetilehijack:
LDA $0D
CPX #$2B
BCC +
CPX #$40
BCS +
LDA $E1D7,x
+
RTS
db $FF,$FF			;[22-23]
db $FF,$FF,$FF,$FF		;[24-27]
db $00,$02,$02,$80		;[28-2B]	Balloon Mario
db $04				;[2C]		Cape
db !Tile,!Tile+$1		;[2D-2E]	Random Gliding tiles
db $FF,$FF,$FF			;[2F-31]

org $00F649
	adc #$8000
org $00F667
	adc #$8000
org $00F67C
	adc #$8000

 
freedata
prot hat,hatless


BEGINDMA:
REP #$20
LDX #$02
LDY $0D84
BNE +
JMP .skipall
+


!hat_gfx		= $5C

	ldy $0100
	cpy #$07
	beq .do
	cpy #$13
	beq .do
	cpy #$14
	beq .do
	bra .dont
.do	
	lda.w #($0A<<4)|$6000
	sta $2116
	lda !hat_gfx-1
	and #$FF00
	lsr #3
	clc
	adc #hat_gfx
	sta $4312
	pha
	ldy #hat_gfx>>16
	sty $4314
	lda #$0040
	sta $4315
	stx $420B

	lda.w #($1A<<4)|$6000
	sta $2116
	pla
	clc
	adc #$0200
	sta $4312
	lda #$0040
	sta $4315
	stx $420B

.dont

;;
;Mario's Palette
;;

LDY #$86
STY $2121
LDA #$2200
STA $4310
TAY
LDA $0D82
STA $4312
STY $4314
LDA #$0014
STA $4315
STX $420B

LDY #$80
STY $2115
LDA #$1801
STA $4310
LDY #$7E
STY $4314

;;
;Misc top tiles (mario, cape, yoshi, podoboo)
;;

!hat_throw		= $58

LDA #$6000
STA $2116
TAY
-
cpy #$06
bcs .yoshi
phx
ldx !hat_throw
lda.l table,x
tax 
stx $4314
plx
lda $0D85,y
bra +
.yoshi
phx
ldx #$7E
stx $4314
plx
lda $0D85,y
+
STA $4312
LDA #$0040
STA $4315
STX $420B
INY #2
CPY $0D84
BCC -

;;
;Misc bottom tiles (mario, cape, yoshi, podoboo)
;;
LDA #$6100
STA $2116
TAY
-
cpy #$06
bcs .yoshi_2
phx
ldx !hat_throw
lda.l table,x
tax 
stx $4314
plx
lda $0D8F,y
bra +
.yoshi_2
phx
ldx #$7E
stx $4314
plx
lda $0D8F,y
+
STA $4312
LDA #$0040
STA $4315
STX $420B
INY #2
CPY $0D84
BCC -

;;
;Mario's 8x8 tiles
;;
LDY $0D9B
CPY #$02
BEQ .skipall

LDA.w #!Tile<<4|$6000
STA $2116
LDA $0D99
STA $4312
LDY.b #BEGINXTND>>16
STY $4314
LDA #$0040
STA $4315
STX $420B

.skipall
SEP #$20
JML $00A38F

table:
db hat/$10000
db hatless/$10000

BEGINXTND:
incbin ExtendGFX.bin

hat_gfx:
incbin hat.bin

freedata align
hat:
	incbin hat_gfx.bin
freedata align
hatless:
	incbin hatless_gfx.bin