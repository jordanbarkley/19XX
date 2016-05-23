// stages.asm

// Stage Load Changes
// http://smashboards.com/threads/19xxte-ssb64-rom-hack-updated-6-30-2015.402248/#post-19189294

// Update Stage Loading ASM
.org	0x14F77C			; @ 80130D0C
lb		v0, 0x0(t2)			; load custom byte from stage table
lui 	s1, $800A			; get s1 address
sb  	v0, 0x4adf(s1)		; store custom byte

.org	0x14DFFC			; @ 80133C14
lb		v0, 0x3(t2)			; modified stage load instruction

.org	0x14f7a4			; @ 80133C34
sb  	v0, 0x4b11(s1)		; remember sss cursor

.org	0x0014F7C4			; another use of s1 [tehz]
sb  	v0, 0x4B12(s1)

// Replace Cursor "Table" w/ Function [tehz]
.org	0x14E02C
fnInitialize:
lui     at, 0x8013
ori     at, at, 0x4644		; stage table pointer
or		v0, r0, r0			; i=0

loop:
lbu     t6, 0x0003(at)		; stage index (unchanged byte)
beq     t6, a0, end 		; compare to saved index

failCheck:
ori     t6, r0, 0x0008 		; load delay; set limit for loop
beq     t6, v0, fail		; if 8th go, we're done.

loopInc:
addiu   v0, v0, 0x1			; i++
beq     r0, r0, loop		; branch back to loop
addiu   at, at, 0x4			; change stage pointer

end:
jr		RA   				; return, cursor is in v0
nop

fail:
jr		RA
ori		v0, r0, 0x0			; return cursor position of 0


/* Stage Table
[1] [2] [3] [4] [5]
[6] [7] [8] [9] [r]

Stage IDs
00 - peach's castle
01 - sector z
02 - congo jungle
03 - planet zebes
04 - hyrule castle
05 - yoshi's island
06 - dreamland
07 - safron city
08 - mushroom kingdom
09 - dreamland beta 1
0a - dreamland beta 2
0b - dreamland beta 3 (tutorial stage)
0c - yoshi's island (no clouds)
0d - metal cavern
0e - battlefield
0f - race to the finish
10 - final destination (only works with fixes)
*/


// Update Stage Table
.org	0x1501B4 				
hex		{ 00000000 }		; slot 1
hex		{ 02000002 }		; slot 2
hex		{ 04000004 }		; slot 3
hex		{ 0D000003 }		; slot 4
hex		{ 10000008 }		; slot 5
hex		{ 0C000005 }		; slot 6
hex		{ 06000006 }		; slot 7
hex		{ 0e000001 }		; slot 8
hex		{ 07000007 }		; slot 9

// Change Previews
.org	0x150050				
hex		{ 0000001A00000103 }
hex		{ 000000140000010C }
hex		{ 0000001400000105 }
hex		{ 000000140000010D }
hex		{ 0000001400000109 }
hex		{ 0000001400000107 }
hex		{ 00000014000000FF }
hex		{ 0000001400000108 }

// Preview Zoom Fixes
.org	0x001503CC			; battlefield
hex		{ 3F19999A }

.org	0x001503E8 			; mushroom kingdom
hex		{ 30000000 }

// Random Function Fix
.org	0x14F764			; @ 80133BF4
sll  	s0, s0, $2			; multiply s0 ($0 - $8) by $4
addu	s0, rA, s0			; add rA (880133BE8) to s0
hex		{ 10000004 }		; beq  r0, r0, 0x80133C14
lb		v0, 0x0A5C(s0)		; load from stage table

// FD is Playable
.org	0x80414

addiu	V0, R0, $E
.org	0x189E2B
hex		{ 18 }

.org	0x640CD2
hex		{ C33E }
