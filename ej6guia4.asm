ROMStart	equ $F60
RAMStart	equ $0080
Vectores	equ $FFF8


num	equ $FF

	org RAMStart

RESH ds 1
RESL ds 1
aux ds 1
cont ds 1
AUXH ds 1
AUXL ds 1
VALORH ds 1
VALORL ds 1

	org ROMStart

INICIO 
	clr VALORH
	clr VALORL
	clr AUXH
	clr AUXL
	clr cont 
	clr aux 
	clr RESH 
	lda #num	
	BMI COMPLEMENTO ;;si es negativo 
	sta AUXL
	sta aux
	sta RESL
	bra MLOOP 

COMPLEMENTO 
	
	sta aux
	neg aux
	sta AUXL
	neg AUXL
	sta RESL
	neg RESL
	
MLOOP 

	lda cont 
	inca
	cmpa aux
	beq FIN 
	sta cont 	
	lda RESL 
	sta VALORL 
	lda RESH
	sta VALORH 
	jsr SUMA
	sthx RESH 
	bra MLOOP
	
SUMA
	
	lda VALORL
	add	AUXL
	psha 
	lda VALORH
	adc AUXH
	psha 
	pulh
	pulx
	rts
	
FIN 

	bra FIN

Vacio

	rti
	org  Vectores  

    dw   Vacio     
    dw   Vacio
    dw   Vacio            
    dw   Inicio  
