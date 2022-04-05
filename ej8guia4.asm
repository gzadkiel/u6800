ROMStart	equ $F600
RAMStart	equ $0080
Vectores	equ $FFF8

	org RAMStart

direccion_valor ds 1	

	org ROMStart
	
Inicio 

	lda #XX
	sta direccion_valor 
	jsr comparacion 
	bra $EEEE
	
	
comparacion 

	cmp #$00 
	beq $AAAA
	cmp #$04 
	beq $BBBB
	cmp #$06
	beq $CCCC
	cmp #$08 
	beq $DDDD 
	rts 