ROMStart	equ $F600
RAMStart	equ $0080
Vectores	equ $FFF8

;;divide two bytes 
;;result expressed in quotient and rest 

A equ $A2 ;;dividend
B equ $03 ;;divisor 

	org RAMStart
	
C ds 1 ;;quotient
R ds 1 ;;rest

;;aux addresses 
minuendo ds 1
sustraendo ds 1
resultado ds 1

	org ROMStart
	
Inicio

	lda #A
	sta resultado
	lda #B
	sta sustraendo
	clr C
	clr R
		
mloop 

	jsr RESTA 
	BCS SUMA
	lda C
	inca
	sta C 
	bra mloop
	

SUMA
	
	lda resultado
	add #B 
	sta R 
	bra fin 
	
	
RESTA

	lda resultado
	sub sustraendo 
	sta resultado
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
