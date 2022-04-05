ROMStart	equ $F600
RAMStart	equ $0080
Vectores	equ $FFF8

;;se pierde A, se sobreescribe con el resultado PROMEDIO

;;ingreso como nums de 4 bytes 
AH equ $0007
AL equ $E2B5
BH equ $003F
BL equ $FFFF

		org RAMStart

RESHH ds 1 ;(0080) este es 0000
RESHL ds 1 ;(0081) tercer byte
RESLH ds 1 ;(0082) segundo byte
RESLL ds 1 ;(0083) lsb
BHH ds 1
BHL ds 1
BLH ds 1
BLL ds 1



	org ROMStart

Inicio

	ldhx #AH					;cargo la parte alta de A, osea 00 y el terce bit	
	sthx RESHH				;guardo  		
	ldhx #AL					;cargo la parte baja de A, los dos bytes lsb
	sthx RESLH 				;guardo
    ldhx #BH
    sthx BHH
    ldhx #BL
    sthx BLH
	jsr SUMA
    asr RESHL
    ror RESLH
    ror RESLL
    bra fin


SUMA
	
    clc 
	lda RESLL
	add BLL
	sta RESLL
	lda RESLH
	adc BLH
	sta RESLH
    lda RESHL
    adc BHL
    sta RESHL
    lda RESHH
    adc BHH
    sta RESHH
	rts


fin 
		bra fin

Vacio

	 	rti
		org  Vectores  

    dw   Vacio     
    dw   Vacio
    dw   Vacio            
    dw   Inicio          
