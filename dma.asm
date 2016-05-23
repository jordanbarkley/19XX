// dma.asm
[vram]: $00108150
[ram]: $80108150			; zebes acid function plus a bit
[rom]: $10f60000			; base address for ROM injections

// DMA RAM Address 		@ A4600000 
// DMA ROM Address 		@ A4600004
// ROM to RAM Length-1 	@ A460000C
// DMA Status      		@ A4600010
	// 1 = IO operation occuring
	// 2 = DMA is happening
	// Not busy when value at (A4600010 & 3) = 0

// * For Zelda Debug ROM *	
// @ 80006150
// void osInvalICache(void *vaddr, s32 nbytes)
// @ 80006200
// void osInvalDCache(void *vaddr, s32 nbytes)
// @ 800046C0
// void osWritebackDCache(void *vaddr, s32 nbytes)
// @ 80106490
// void osWritebackDCache(void *vaddr, s32 nbytes);

// @ 80039160 in smash RAM - osWritebackAll
// @ 800321D0 in smash RAM - osWritebackDCache 
// @ 800344B0 in smash RAM - osInvalICache (0x350B0)
// @ 80034530 in smash RAM - osInvalDCache
// a0 holds address, a1 holds length

// how to encode cache instructions (search "For a primary cache")
/*
http://www.eecg.toronto.edu/~moshovos/ACA05/doc/MIPSISA.pdf
*/	
	
// .org (something)	
// j	0x801080F0
// ori	gp, r0, (ROM offset - $f60000)
	

.org	 0x838EC 			; @ 801080EC (zebes acid)
Save_Registers:
mthi	gp					; save gp (ROM difference)
mtlo	v0					; save v0 (spare register)

Busy_Test:
lui		v0, $A460			; load PI register
lw		gp, 0x0010(v0)		; get DMA status
bne		gp, r0, Busy_Test	; if busy, try again

Copy_From_ROM_To_RAM:
lui		gp, @vram
ori		gp, gp, @vram		; load RAM Addrdess (without 80)
sw		gp, 0x0000(v0)		; store RAM Address
lui		gp, @rom			; load ROM address (with 10)
mfhi	v0					; get ROM difference
add		gp, gp, v0			; ROM address + ROM difference
lui		v0, $A460			; reload PI register
sw		gp, 0x0004(v0)		; store ROM Address
ori		gp, r0, $ef			; (80108240 - @ram = $f0) 
sw		gp, 0x000C(v0)		; store length (60 free lines!)

DMA_Done:
lw		gp, 0x0010(v0)		; get DMA status
bne		gp, r0, DMA_Done	; if busy, try again
nop

Restore:
mflo	v0					; restore register

Cache_Fix:
mthi	a0					; save a0
mtlo	a1					; save a1
lui		a0, @ram			; ~
ori		a0, a0, @ram		; load RAM address
j		0x800321D8			; jump to osInvalJCache
ori		a1, r0, $3c0		; load nbytes(?) (f0 * 4)
;							  this may be just f0

Function:
break						; overwritten by function

// osInvalJCache Changes
// old regs - a0, a1, at, t0, t1, t2, t3
// new regs - .., .., at, a0, a1, at, at

// assumption: osWritebackAll can replace osWritebackDCache
// change: jals to osWritebackDCache now go to osWritebackAll
	// with a simple jump
// change: jr ras are now just jumps since only I use this

// assumption: t0 = a0
// change: a0 doesn't get transferred to t0, t0 no longer used
// change: cache instruction now uses a0 since t0 is not used

// assumption: t1 = a1 + a0
// change: a1 = a1 + a0, t1 no longer used

// assumption: t2 is tmeporary af
// change: use at instead because it's also temporary

// assumption: length will never be less than 0
// change: removed first two lines

// assumption: t3 does not conflict with at
// change: at replaces t3
// change: added a line to restore at (formerly t3) to 4000 
	// since an sltu instruction turns it to 1 or 0

// change: a jr ra was changed to branch to restore regs

.org	0x32DD0				; osWritebackDCache
j		0x80039160			; jump to osWritebackAll
nop

// @ 800321D8
osInvalJCache:				; modified osInvalICache
ori		at, r0, $4000
sltu	at, a1, at			; if length > $4000, branch
beq		at, r0, Something
ori		at, r0, $4000		; turn modified at back to 4000
addu	a1, a0, a1
sltu	at, a0, a1
beq		at, r0, Return
nop
andi	at, a0, $1f
addiu	a1, a1, $FFE0
subu	a0, a0, at

Back:
hex		{ BC900000 }		; cache	0x10, 0x0(a0)
sltu	at, a0, a1
bnez	at, Back
addiu	a0, a0, $20

Return:
beq		r0, r0, jump_ra
nop	 

Something:
lui		a0, $8000
addu	a1, a0, at
addiu	a1, a1, $FFE0

Loop:
hex 	{ BC800000 }		; cache	0x0,0(a0)
sltu	at, a0, a1
bnez	at, Loop
addiu	a0, a0, $20

jump_ra:
mfhi	a0					; restore a0
j		0x80108150
mflo	a1					; restore a1
nop							; free space (@ 80032244)
nop							; free space
nop							; free space


// osInvalICache
/*
.org	0x350B0
osInvalICache:
blez	a1, Return			; if length <= 0
nop
li		t3, $4000
sltu	at, a1, t3			; if length > $4000, branch
beq		at, r0, Something
nop
or		t0, a0, r0
addu	t1, a0, a1
sltu	at, t0, t1
beq		at, r0, Return
nop
andi	t2, t0, $1f
addiu	t1, t1, $FFE0 // $-20
subu	t0, t0, t2

Back:
//cache	0x10, 0x0(t0)
hex		{ BD100000 }
sltu	at, t0, t1
bnez	at, Back
addiu	t0, t0, $20

Return:
jr		ra
nop							; empty space 

Something:
lui		t0, $8000
addu	t1, t0, t3
addiu	t1, t1, $FFE0

Loop:
//cache	0x0,0(t0)
hex 	{ BD000000 }
sltu	at, t0, t1
bnez	at, Loop
addiu	t0, t0, $20
jr		ra
nop							; empty space  
nop							; empty space
nop							; empty space
nop							; empty space
*/
