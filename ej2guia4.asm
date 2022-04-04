RAMStart        equ $0080
ROMStart        equ $F600
;Config11        equ $00F1
VectorStart     equ $FFF8

table1_beg      equ $F800
table1_end      equ $F81F
table2_beg      equ $0087
table2_end      equ $00A6
nofelements     equ !32


        org RAMStart


table1_pointer  ds 2
table2_pointer  ds 2
counter ds 1
regb ds 1


        org ROMStart

inicio


        ldhx #table1_beg
        sthx table1_pointer
        ldhx #table2_beg
        sthx table2_pointer
        clr counter
        clr regb

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
        sta counter
        bra mloop

ordenado

        ldhx #table2_beg
        sthx table2_pointer

compare

        ;cphx $
        lda 0,x
        sta regb
        lda 1,x
        cmpa regb
        bcc swap
        bcs noswap

swap

        ;decx
        sta 0,x
        incx
        sthx table2_pointer
        lda regb
        sta 0,x
        bra averquepasa

noswap

        incx
        sthx table2_pointer
        bra averquepasa


averquepasa

        cphx #table2_end
        beq reset
        bra compare
reset
        ldhx #table2_beg
        sthx table2_pointer
        bra compare


        org table1_beg

        db $F1,$02,$FE,$08,$16,$92,$64,$00,$F0,$12,$24,$E8,$A6,$92,$11,$FF
        db $FA,$25,$65,$D4,$A5,$E2,$22,$76,$84,$9E,$3D,$A2,$F7,$D6,$23,$11


Vacio
        rti
        org  VectorStart   

        dw   Vacio   
        dw   Vacio             
     	dw   Vacio             
    	dw   Inicio
