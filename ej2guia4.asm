

RAMStart	equ $0080
ROMStart	equ $F600 
Config11	equ $00F1
VectorStart	equ $FFF8 

table1_beg	equ $3000
table1_end	equ $301F
table2_beg	equ $3040
table2_end	equ $305F
nofelements	equ !32 

	org RAMStart 

table1_pointer	ds 2
table2_pointer	ds 2
counter	ds 1

Inicio 
	
	org ROMStart
	
	ldhx #table1_beg
	sthx table1_pointer
	ldhx #table2_beg
	sthx table2_pointer
	clr counter
	
mloop

	ldhx table1_pointer
	lda 0,x 
	incx 
	sthx table1_pointer
	ldhx table2_pointer
	sta 0,x 
	incx
	sthx table2_pointer
	lda counter
	inca 
	cmp #nofelements
	beq ordenado 
	branch mloop

ordenado

	
