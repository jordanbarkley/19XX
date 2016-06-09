// dma.asm
[len]: $00010000			; arbitrary length
[ram]: $80380000			; free ram space (?)
[rom]: $10f60000			; free rom space
/*
For expansion pak (if necessary)
[len]: $000a0000			; max length 
[ram]: $80400000			; free ram space
*/

/*
DMA RAM Address 		@ A4600000 
DMA ROM Address 		@ A4600004
ROM to RAM Length-1 	@ A460000C
DMA Status      		@ A4600010
	1 = IO operation occuring
	2 = DMA is happening
	0 = Not busy (when value at (A4600010 & 3) = 0)
*/
	
// Hook
.org	0x35898
/*
beq		r0, r0, 0x80034CB8	; always branch, good return point
sw		t9, 0x000C(t0)		; store DMA length, begin DMA
*/
j		0x800321D8
sw		t9, 0x000C(t0)		; store DMA length, begin DMA

// DMA Function
.org	0x32DD0				; @ 800321D0, osWritebackDCache
j		0x80039160			; jump to osWritebacDCachekAll
nop

Setup:
nop ; j 0x80034CB8			; return after first run
nop
mthi	t9					; save t9 (just in case)
mtlo	t0					; save t0 (just in case)
lui		t0, $A460			; load DMA registers

Busy_Test1:
lw		t9, 0x10(t0)		; get DMA status
bne		t9, r0, Busy_Test1	; if busy, loop
nop

Start_DMA:
lui		t9, @rom			; ~
ori		t9, t9, @rom		; load rom address
sw		t9, 0x4(t0)			; store rom address

lui		t9, @ram			; ~
ori		t9, t9, @ram		; load RAM destination
sll		t9, t9, $8			; ~
srl		t9, t9, $8			; get rid of "80"
sw		t9, 0x0(t0)			; store ram destination

lui		t9, @len			; ~
ori		t9, t9, @len		; load length
addiu	t9, t9, $ffff		; subtract 1 (0xC = len - 1)
sw		t9, 0xC(t0)			; store DMA length, begin DMA

Busy_Test9:
lw		t9, 0x10(t0)		; get DMA status
bne		t9, r0, Busy_Test9	; if busy, loop
nop

Write_Jump:
lui		t9, $0800
ori		t9, t9, $D32E
lui		t0, $8003
sw		t9, 0x21D8(t0)

Return:
mflo	t0					; restore t0 (just in case)
j 		0x80034CB8			; return
mfhi	t9					; restore t9 (just in case)							




