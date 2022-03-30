;;2 bytes to bcd converter

RAMStart	equ $0080 
ROMStart	equ $F600
Config1		equ $00F1 
VectorStart	equ $FFF8 

num_2_convert	equ !60354	;value to convert 

			org RAMStart
		
sustrah	ds 1	;subtrahend MSB
sustral	ds 1 	;subtrahend LSB
sumah	ds 1 	;addend MSB
sumal 	ds 1	;addend LSB
resh	ds 1	;number to convert MSB	
resl	ds 1 	;number to convert LSB

diezk		ds 1	;n5
unk			ds 1	;n4
cien		ds 1	;n3
diez 		ds 1	;n2
unidad		ds 1	;n1
		
		org ROMStart 

Inicio
			lda #$11
			sta Config1
			nop 
			
			;set all counters to $00
			clr diezk	
			clr unk
			clr cien
			clr diez
			clr unidad
			;load number to convert in index reg and store it accordingly 
			;MSB --> resh 
			;LSB --> resl 
			ldhx #num_2_convert 
			sthx resh
mloop 		;main loop 
			ldhx #!10000	
			sthx sustrah	;set subtrahend to 10000
			jsr resta 		;substraction subroutine 
			bcs revert10k 	;if borrow = 1, branch
			lda diezk
			inca 
			sta diezk		;if borrow = 0, increase 10k counter
			bra mloop		;return and substract 10000 again, max 6 times
revert10k	ldhx #!10000 	;if borrow = 1, add 10000 back 
			sthx sumah 
			jsr suma		;addition subroutine
			ldhx #!1000		;after subroutine, now it's time to substract 1000
			sthx sustrah
loop2		jsr resta 		
			bcs revert1k	;if borrow = 1, branch 
			lda unk
			inca
			sta unk			;if borrow = 0, increase 1k counter
			bra loop2 		;return and substract 1000 again, max 5 times 
revert1k	ldhx #!1000		
			sthx sumah	
			jsr suma		;if borrow = 1, add 1000 back 
			ldhx #!100 		;time to substract 100 
			sthx sustrah
loop3		jsr resta
			bcs revert100 	;if borrow = 1, branch
			lda cien
			inca
			sta cien		;if borrow = 0, increase 100 counter, max 5 times 
			bra loop3 		;return and substract 100 again
revert100	ldhx #!100		
			sthx sumah
			jsr suma 		;if borrow = 1, add 100 back
			ldhx #!10		;time to substract 10
			sthx sustrah
loop4		jsr resta
			bcs revert10	;if borrow = 1, branch
			lda diez
			inca
			sta diez		;if borrow = 0, increase 10 counter, max 3 times
			bra loop4		;return and substract 100 again
revert10	ldhx #!10
			sthx sumah
			jsr suma		;if borrow = 1, add 100 back
			lda resl		
			sta unidad		;only units left, store them directly 

resta 
		clc
		sthx sustrah 
		lda resl 
		sub sustral
		sta resl
		lda resh
		sbc sustrah
		sta resh
		rts

suma 
		clc 
		sthx sumah 
		lda resl 
		add sumal
		sta resl
		lda resh
		adc sumah
		sta resh
		rts

		
Vacio
	 	rti
		org  VectorStart   

        dw   Vacio              ;FFF8+FFF9, no usado
        dw   Vacio              ;FFFA+FFFB, (direccion atencion interrupcion por IRQ)
        dw   Vacio              ;FFFC+FFFD, (direccion atencion interrupcion por SWI)
        dw   Inicio             ;FFFE+FFFF, (direccion comienzo del programa)		
		
		
	