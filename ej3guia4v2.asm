ROMStart	equ $F600
RAMStart	equ $0080
Vectores	equ $FFF8

;;number A is lost in the process
;;it gets overwritten by the result of the operation 

AH1 equ $07
AL1 equ $E2B5
BH1 equ $3F
BL1 equ $FFFF

		org RAMStart

RESHH ds 1 ;;A's most significant byte
RESLH ds 1 ;;A's middle byte
RESLL ds 1 ;;A's least significant byte

BHH ds 1 ;;B's most significant byte
BLH ds 1 ;;B's middle byte
BLL ds 1 ;;B's least significant byte

;;aux registers for sum subroutine 
sumando1 ds 1
sumando2 ds 2
resultado ds 1

	org ROMStart

Inicio

	;;load both numbers on their respective addresses 
	lda #AH1
	sta RESHH	
	ldhx #AL1
	sthx RESLH
    	lda #BH1
    	sta BHH
    	ldhx #BL1
    	sthx BLH
	;;substract least significant byte 
	lda RESLL 
	sta sumando1
	lda BLL
	sta sumando2
	clc
	jsr SUMA
	lda resultado
	sta RESLL 
	;;substract middle byte 
	lda RESLH 
	sta sumando1
	lda BLH
	sta sumando2
	jsr SUMA
	lda resultado
	sta RESLH
	;;substract most significant byte
	lda RESHH 
	sta sumando1
	lda BHH
	sta sumando2
	jsr SUMA
	lda resultado
	sta RESHH
	;;divide by 2 
    	asr RESHH
    	ror RESLH
    	ror RESLL
    	bra fin

SUMA 
	
	lda sumando1
	adc sumando2
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
