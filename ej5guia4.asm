ROMStart	equ $F600
RAMStart	equ $0080
Vectores	equ $FFF8


;; numbers have 47 and 44 bits, therefore i work with them
;; as if they where 48 bits numbers which equals working
;; with 6 byte numbers, that can be represented as 3 
;; memory addresses chained together 


APT1	equ $0000		;;2 msbs of A		
APT2	equ $0000		;;2 mid bytes of A
APT3	equ $00FF		;;2 lsbs of A
BPT1	equ $0000
BPT2	equ $0000
BPT3	equ $0002


	org RAMStart

cocienteHH	ds 1
cocienteHL	ds 1
cocienteMH	ds 1
cocienteML	ds 1
cocienteLH	ds 1
cocienteLL	ds 1
RES1H	ds 1
RES1L	ds 1
RES2H	ds 1
RES2L	ds 1
RES3H	ds 1
RES3L	ds 1 
B1H		ds 1
B1L		ds 1
B2H 	ds 1
B2L 	ds 1
B3H		ds 1
B3L 	ds 1
AUXH	ds 1
AUXL	ds 1 
VALORH	ds 1
VALORL	ds 1


	org ROMStart
	
INICIO

	clr cocienteHH
	clr cocienteHL
	clr cocienteMH
	clr cocienteML
	clr cocienteLH
	clr cocienteLL
	clr AUXH
	clr AUXL
	clr VALORH
	clr VALORL
	ldhx	#APT1
	sthx	RES1H
	ldhx	#APT2
	sthx	RES2H
	ldhx	#APT3
	sthx	RES3H 
	ldhx	#BPT1
	sthx	B1H
	ldhx	#BPT2
	sthx	B2H
	ldhx	#BPT3
	sthx	B3H 
	clc
	
MLOOP 
	
	lda RES3L
	sta VALORL 
	lda B3L
	sta AUXL
	lda RES3H
	sta VALORH 
	lda B3H
	sta AUXH 
	jsr RESTA 
	sthx RES3H
	
	lda RES2L
	sta VALORL 
	lda B2L
	sta AUXL
	lda RES2H
	sta VALORH 
	lda B2H
	sta AUXH
	jsr RESTA 
	sthx RES2H
	
	lda RES1L
	sta VALORL 
	lda B1L
	sta AUXL
	lda RES1H
	sta VALORH 
	lda B1H
	sta AUXH
	jsr RESTA
	sthx RES1H 
	blt REVERT 
	jsr COCIENTE
	bra MLOOP
	
REVERT 
	
	clc
	lda RES3L
	sta VALORL 
	lda B3L
	sta AUXL
	lda RES3H
	sta VALORH 
	lda B3H
	sta AUXH 
	jsr SUMA 
	sthx RES3H
	
	lda RES2L
	sta VALORL 
	lda B2L
	sta AUXL
	lda RES2H
	sta VALORH 
	lda B2H
	sta AUXH
	jsr SUMA 
	sthx RES2H
	
	lda RES1L
	sta VALORL 
	lda B1L
	sta AUXL
	lda RES1H
	sta VALORH 
	lda B1H
	sta AUXH
	jsr SUMA 
	sthx RES1H
	bra FIN
	
COCIENTE
	
	lda cocienteLL
	add #$01 
	sta cocienteLL
	lda cocienteLH
	adc #$00
	sta cocienteLH
	lda cocienteML
	adc #$00
	sta cocienteML
	lda cocienteMH
	adc #$00
	sta cocienteMH
	lda cocienteHL
	adc #$00
	sta cocienteHL
	lda cocienteHH
	adc #$00
	sta cocienteHH 
	rts 
	
RESTA
	
	lda VALORL
	sbc	AUXL
	psha 
	lda VALORH
	sbc AUXH
	psha 
	pulh
	pulx 
	rts 

SUMA
	
	lda VALORL
	adc	AUXL
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
