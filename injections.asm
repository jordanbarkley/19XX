// injections.asm

// Note - loads and stores behave strangely on non-aligned
// addresses, not every line of code will make sense - jorg

// Note - it is assumed that the register "gp" is safe to use

/*
Table of Contents

Widescreen and Enable Hitboxes (Toggles)
Skip Results Screen (Toggle)
Music Functions (Toggles)
Enable Polygon Specials
Access All Costumes
Play As Polygon Characters
Polygons Crash Fix (Character Select Screen) [tehz]
Polygons Crash Fix (Results Screen) [tehz]
Item Switch Write

*/

[varspace]: 0x800A4D11			; team attack/stage select

[offset00]: 0x0000				; widescreen/hitboxes
[offset01]: 0x00F0				; skip results/salty runback-
[offset02]: 0x01E0				; music functions
[offset03]: 0x02D0				; enable polygon specials
[offset04]: 0x03C0				; access all costumes
[offset05]: 0x04B0				; play as polygon chars
[offset06]: 0x05A0				; polygon crash fix 1
[offset07]: 0x0690				; polyogn crash fix 2
[offset08]: 0x0780				; item write function
[offset09]: 0x0870				;

[toggle00]: %0000000000000001	; tournament mode (?)
[toggle01]: %0000000000000010	; widescreen
[toggle02]: %0000000000000100	; hitboxes
[toggle03]: %0000000000001000	; skip results
[toggle04]: %0000000000010000	; random music
[toggle05]: %0000000000100000	; play music
[toggle06]: %0000000001000000	; 
[toggle07]: %0000000010000000	;
[toggle08]: %0000000100000000	;
[toggle09]: %0000001000000000	;
[toggle10]: %0000010000000000	;
[toggle11]: %0000100000000000	;
[toggle12]: %0001000000000000	;
[toggle13]: %0010000000000000	;
[toggle14]: %0100000000000000	;
[toggle15]: %1000000000000000	;

//===========================================================
// Widescreen and Enable Hitboxes (Toggle)
//===========================================================

// Hook
.org	0x891B4					; @ 8010D9B4
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset00		; load value (widescreen)

// Functions
.org	0xf60000
Widescreen:
lui 	at, @varspace
ori		at, at, @varspace		; get varspace address
lw		at, 0x0(at)				; get word (should be hword)
andi	gp, at, @toggle00		; check if items on
bgtz	gp, Widescreen_Off		; if items on, end
nop
andi	gp, at, @toggle01		; check if widescreen is on
bgtz 	gp, Hitboxes			; if on, skip line that
;								  disables widescreen
nop
swc1 	f10, 0x24(s1)			; disable widescreen og line

Hitboxes:
andi	gp, at, @toggle02		; check if hitboxes on
blez 	gp, Hitboxes_End		; if off, don't nop branches
lui  	at, $800F
ori  	at, at, $2C04			; character hit boxes
sw   	r0, 0x0(at)				; nop branch
lui  	at, $8016
ori  	at, at, $7578			; projectile hit boxes
sw   	r0, 0x0(at)				; nop branch

Hitboxes_End:
lui 	at,  $8013
lwc1	f16, 0xc50(at)			; original line 2
j 		0x8010D9BC				; return
nop

Widescreen_Off:
lui 	at,  $8013
lwc1	f16, 0xc50(at)			; original line 2

j 		0x8010D9BC				; return
swc1 	f10, 0x24(s1)			; disable widescreen og line

//===========================================================
// Skip Results Screen (Toggle)
//===========================================================

.org	0x10B204 				; @ 8018E314
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset01		; load value (skip results)

.org	0xf600f0
Default_Screen:
addiu 	t6, r0, 0x18			; load results (original)


Salty_Runback:
lui		a0, $8009
ori		a0, a0, $EFA4 			; load base pointer
lui		k1, $ffff				; load unplugged value
ori		k1, k1, $ffff			; k1 isn't even safe but...

SR_P1:
lh		gp, 0x0(a0)				; get p1 buttons
beq		gp, k1, Results			; if controller unplugged
andi	gp, gp, $f				; check if any c buttons held
blez	gp, SR_P2				; if not, check p2
nop
beq		r0, r0, Salty_Runback_End

SR_P2:
lh		gp, 0x8(a0)				; get p2 buttons
beq		gp, k1, Results			; if controller unplugged
andi	gp, gp, $f				; check if any c buttons held
blez	gp, SR_P3				; if not, check p3
nop
beq		r0, r0, Salty_Runback_End

SR_P3:
lh		gp, 0x10(a0)			; get p3 buttons
beq		gp, k1, Results			; if controller unplugged
andi	gp, gp, $f				; check if any c buttons held
blez	gp, SR_P4				; if not, check p4
nop
beq		r0, r0, Salty_Runback_End

SR_P4:
lh		gp, 0x18(a0)			; get p4 buttons
beq		gp, k1, Results			; if controller unplugged
andi	gp, gp, $f				; check if any c buttons held
blez	gp, Results				; if not, go to results
nop
beq		r0, r0, Salty_Runback_End

Results:
lui 	a0, @varspace
ori		a0, a0, @varspace		; get varspace address
lw		a0, 0x0(a0)				; get word (should be hword)
andi	a0, a0, @toggle00		; check if items on

bgtz	a0, Results_End			; if items on, skip
nop

lui   	a0, @varspace
ori		a0, a0, @varspace		; get results address
lw   	a0, 0x0(a0)				; get word (should be hword)
andi	a0, a0, @toggle03		; check if skip results on
blez 	a0, Results_End			; if on, don't load css value
nop
ori   	t6, r0, $10				; load css value

Results_End:
j 		0x8018E31C
sb   	t6, 0x0(v0)				; original line (?)

Salty_Runback_End:
ori		t6, r0, $16				; load "fighting" value
j 		0x8018E31C
sb   	t6, 0x0(v0)				; original line


//===========================================================
// Music Functions
//===========================================================

// Hook
.org	0x216f8					; @ 80020AF8
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset02		; load value (music function)

// Functions
.org	0xf601e0
Skip_Table:
beq		r0, r0, Random_Song
sw 		r0, 0x0(t3)				; clear music address

Random_Song_Table:
hex		 { 00 }					; Dreamland
hex		 { 01 }					; Zebes
hex		 { 02 }					; Mushroom Kingdom
hex		 { 04 }					; Sector Z
hex		 { 05 }					; Congo Jungle
hex		 { 06 }					; Peach's Castle
hex		 { 07 }					; Saffron City
hex		 { 08 }					; Yoshi's Island
hex		 { 09 }					; Hyrule Castle
hex		 { 19 }					; Final Destination
hex		 { 1A }					; Bonus Stages
hex		 { 22 }					; How to Play Stage
hex		 { 24 }					; Battlefield
hex		 { 25 }					; Metal Cavern
hex		 { 27 }					; Credits Music
hex		 { 2A }					; Training Mode music

Random_Song:
lui 	gp, @varspace
ori		gp, gp, @varspace		; get varspace address
lw		gp, 0x0(gp)				; get word (should be hword)
andi	gp, gp, @toggle00		; check if items on
bgtz	gp, Music_End			; if items on, end
nop

lui 	gp, @varspace
ori		gp, gp, @varspace		; get varspace address
lw		gp, 0x0(gp)				; get word (should be hword)
andi	gp, gp, @toggle04		; check random music toggle
blez 	gp, Music				; if off, skip to mute music

li   	gp, $0a					; load choose your character
beq  	gp, a1, Music			; skip if menu music
li   	gp, $2c					; load other menu music
beq  	gp, a1, Music 			; skip if menu music 

lui  	gp, $8010				; load music table offset
ori  	gp, gp, $8158			; load music table offset
//mfc0 	a1, Count				; get "count" register
hex		 { 40054800 }
sll  	a1, a1, $1c				; ~
srl  	a1, a1, $1c				; get rid of leading bits
nop								; a1 now holds 0 - f
add  	gp, gp, a1				; get music table offset
lb   	a1, 0x0(gp)				; get new song

Music:
lui 	gp, @varspace
ori		gp, gp, @varspace		; get varspace address
lw		gp, 0x0(gp)				; get word (should be hword)
andi	gp, gp, @toggle05		; check mute music toggle
bgtz 	gp, Music_End		
li   	gp, $ff					; load "music off"
sb   	gp, 0x0(t3)				; store "music off" byte

Music_End:
jr 		ra
sb   	a1, 0x3(t3)				; store music selection btye

//===========================================================
// Enable Polygon Specials
//===========================================================

// This can be done within character files

// This code also no longer works (?) it's been a long time

/*
.org	0x8EBD4					; @ 801133D4
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset03		; load value (specials)


// injection point where clock starts
// clock @ 800A4D1C (in frames)
// write @ 801133D4 (SW t7, 0x0014(v0))
// write 0x8EBD4

// Player 1 - 80268778 (P1 + B50 * 0)
// Player 2 - 802692C8 (P1 + B50 * 1)
// Player 3 - 80269E18 (P1 + B50 * 2)
// Player 4 - 8026A968 (P1 + B50 * 3)

// see specials.asm for more info

.org 	0xf602d0
Special_Moves:
sw 		t7, 0x0014(v0)		; original line 1
li		at, $3				; load loop count

Special_Address:
lui  	t9, $8026			; ~
ori  	t9, t9, $8778		; load p1 base address
li		t6, $B50			; load the difference
mult	t6, at 				; multiply $B50 by player
mflo	t6					; get result of above
add		t9, t9, t6			; add result to base address

Special_Sanity_Check:
add		t6, t9, r0			; copy t9 into t6
srl		t6, t6, $10			; get rid of bottom half
subi	t6, t6, $4013		; ~
subi	t6, t6, $4013		; subtract 8026
bne		t6, r0, Special_Loop; branch if not 0 (if pX addr
;							; doesn't start with 8026)
lw   	t9, 0x0(t9)			; get the word at pX address
		
Special_Apply:
addi 	t9, t9, $100		; add 100 to it
lui  	t6, $FFFF			; ~
ori  	t6, t6, $FFFF		; load default value
sw  	t6, 0x0(t9)			; store default value

Special_Loop:
subi	at, at, $1			; decrement loop
bgez	at, Special_Address	; branch if p1 or higher
nop

Special_Return:
j 		0x801133DC			; return
lw		t9, 0x0(a1)			; original line 2 
*/

//===========================================================
// Access All Costumes
//===========================================================

// Hook
.org	0x1361B4				; @ 80137F34
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset04		; load value (colors)

/*
8013bad4 - P1 Color Location on CSS
800E9464 - P1 Color Update "store word"
80137F4c - P1 Color Update "load word" (from stack)
80137F3f - P1 Color Update "store word" (to stack) 

8013bb90 - P2 Color Location on CSS
8013BC4c - P3 Color Location on CSS
8013bd08 - P4 Color Location on CSS

player color locations are 0x4C(s0)

p1 when s0 = 8013BA88
p2 when s0 = 8013BB44
p3 when s0 = 8013BC00
p4 when s0 = 8013BCBC
*/

// Function
.org	0xf603C0
Get_Player:
lui    	t0, $8013
ori		t0, t0, $BA88			; load "p1 s0"
li    	t1, $BC
sub   	t0, s0, t0 				; get the difference
div   	t0, t1 					; lo = t0 / t1
mflo  	t0						; t0 = t0 / t1

Load_Buttons: 
sll   	t0, t0, $3				;  difference * 2^3
lui   	t1, $8009	
ori   	t1, t1, $EFA4			; get base button pointer
add   	t1, t0, t1				; get player button pointer
lh    	t1, 0x0(t1)				; get player buttons

Check_Left:
andi   	t0, t1, $2 				; t0 now holds c left
blez  	t0, Check_Right			; if off skip
nop
lw    	v0, 0x4C(s0)			; get current color
addiu  	v0, v0, $FFFF			; subtract 1 from costume
beq   	r0, r0, Costume_Limit
li    	t0, $0

Check_Right:
andi   	t0, t1, $1 				; t0 now holds c left
blez   	t0, Costume_Neither	
nop
lw    	v0, 0x4C(s0)			; get current color
addiu  	v0, v0, $1				; update costume by adding 1
beq   	r0, r0, Costume_Limit
li    	t0, $0

Costume_Neither:
lw    	v0, 0x4C(s0)			; keep color			
li    	t0, $0					; reset register
beq   	r0, r0,Costume_Original	; end
nop

Costume_Limit:
li		t1, $6					; load (highest color + 1)
bne		t1, v0, Costume_Limit_2	; if costume < above, skip
nop

li		v0, $5					; set this back to 5 (from 6)
beq		r0, r0,Costume_Original	; end
nop

Costume_Limit_2:
lui	    t1, $ffff			
ori		t1, t1, $fffe			; load (lowest color - 1) 
bne		t1, v0,Costume_Original	; if costum > above, skip
li		t0, $0					; reset register
lui		v0, $ffff				
ori		v0, v0, $ffff			; set costume to -1 (from -2)

Costume_Original:
lw    	a0, 0x48(s0)			; original line(?)
sw    	v0, 0x24(sp)			; v0 holds costume number
j     	0x80137F3C 
sw    	v0, 0x4C(s0)			; store updated


//===========================================================
// Play As Polygon Characters
//===========================================================

// Hook
.org	0x138974				; @ 8013A6F4
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset05		; load value (polygons)

// Function

// ... t5 holds the costume
// ... t9 holds the character  (800A4D08 + 23 + 74*)

.org	0xf604B0
Polygon_Check:
sb		t4, 0x22(a0)			; original line 1
lui		gp, $FFFF
ori		gp, gp, $FFFF			; load -1
bne   	gp, t5, Polygon_Return	; if costume = -1, continue
nop

Update_Char:
addiu	t9, t9, $e				; add (polygon - char)
li		t5, $0					; update costume

Polygon_Return:	
j 		0x8013A6FC				; return
sb		t9, 0x23(a0)			; original line 2

//===========================================================
// Polygons Crash Fix (Character Select Screen) [tehz]
//===========================================================

// Hook
.org	0x138F44				; @ 8013ACC4
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset06		; load value (tehz fix 1)

// Function
.org	0xf605A0
legalityChecks:
ori		at, r0, 0x0002 			; load 2
beq		a1, at, CSS_return  	; if a1 = 2 (n/a)
ori		at, r0, 0x001C
beq		t0, at, CSS_return		; if t0 = 1C (no character)
sltiu	at, t0, 0x000C
bne		at, r0, CSS_return		; if t0 <= Ness (not polygon)
nop
addiu	t0, t0, 0xFFF2			; else, char is polygon (-$E)

CSS_return:
sw		r0, 0x001C(v0)			; original line 1
sw		r0, 0x0020(v0)			; original line 2
j		0x0013ACCC				; return
sb		t0, 0x0023(v1)			; store character

//===========================================================
// Polygons Crash Fix (Results Screen) [tehz]
//===========================================================

// Hook
.org	0x150DD0				; @ 80131C30
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset07		; load value (tehz fix 2)

// Function
.org	0xf60690
replacedCode:	
addiu	at, r0, 0x003C			; original line 1
lbu		s4, 0x23(v0)			; original line 2

legalityCheck:	
slti	k1,	 s4, 0x000C		
bgtz	k1, Results_return		; if (char id < ness), return
nop
addiu	s4, s4, 0xFFF2			; else, char is polygon (-$E)

Results_return:	
j 		0x80131C38				; return
sb		s4, 0x0023 (v0)			; store character

//===========================================================
// Item Switch Write
//===========================================================

// Hook
.org	0x128D6C				; @ 801327CC
j		0x801080EC				; jump to DMA function
ori		gp, r0, @offset08		; load value (item write)

// Function
.org	0xf60780
Write_Start:
lui   	v1, $8013
ori		v1, v1, $3420			; appearance% address
ori   	a0, r0, $0				; set byte to zer0

Write_Check_1:
lw   	t8, 0x0(v1)				; load appearance%
blez 	t8, Write_Check_2		; if 0, skip
lw   	t8, 0x4(v1)				; load beam sword
addiu 	a0, a0, $1				; add 2^0

Write_Check_2:
blez 	t8, Write_Check_3		; if 0, skip
lw   	t8, 0x8(v1)				; load homerun bat
addiu 	a0, a0, $2				; add 2^1

Write_Check_3:
blez 	t8, Write_Check_4		; if 0, skip
lw   	t8, 0xC(v1)				; load hammer
addiu 	a0, a0, $4				; add 2^2

Write_Check_4:			
blez 	t8, Write_Check_5		; if 0, skip
lw   	t8, 0x10(v1)			; load fan
addiu 	a0, a0, $8				; add 2^3

Write_Check_5:
blez 	t8, Write_Check_6		; if 0, skip
lw   	t8, 0x14(v1)			; load motion sensor
addiu 	a0, a0, $10				; add 2^4

Write_Check_6:
blez 	t8, Write_Check_7		; if 0, skip
lw   	t8, 0x18(v1)			; load bob-omb
addiu 	a0, a0, $20				; add 2^5

Write_Check_7:
blez 	t8, Write_Check_8		; if 0, skip
lw   	t8, 0x1C(v1)			; load bumper
addiu 	a0, a0, $40				; add 2^6

Write_Check_8:
blez 	t8, Write_Check_9		; if 0, skip
lw   	t8, 0x20(v1)			; load shell
addiu 	a0, a0, $80				; add 2^7

Write_Check_9:
blez 	t8, Write_Check_10		; if 0, skip
lw   	t8, 0x24(v1)			; load poke ball
addiu 	a0, a0, $100			; add 2^8

Write_Check_10:
blez 	t8, Write_Check_11		; if 0, skip
lw   	t8, 0x28(v1)			; load ray gun
addiu 	a0, a0, $200			; add 2^9

Write_Check_11:
blez 	t8, Write_Check_12		; if 0, skip
lw   	t8, 0x2C(v1)			; load fire flower
addiu 	a0, a0, $400			; add 2^10

Write_Check_12:
blez 	t8, Write_Check_13		; if 0, skip
lw   	t8, 0x30(v1)			; load star rod
addiu 	a0, a0, $800			; add 2^11

Write_Check_13:
blez 	t8, Write_Check_14		; if 0, skip
lw   	t8, 0x34(v1)			; load maxim tomato
addiu 	a0, a0, $1000			; add 2^12

Write_Check_14:
blez 	t8, Write_Check_15		; if 0, skip
lw   	t8, 0x38(v1)			; load heart
addiu 	a0, a0, $2000			; add 2^13

Write_Check_15:
blez 	t8, Write_Check_16		; if 0, skip
lw   	t8, 0x3C(v1)			; load star
addiu 	a0, a0, $4000			; add 2^14

Write_Check_16:
blez 	t8, Write_End			; if 0, skip
lui   	v1, @varspace			; ~
addiu 	a0, a0, $8000			; add 2^16

Write_End:
ori 	v1, v1, @varspace		; osInvalJCache free space

// sh 	a0, 0x0(v0)(store half is giving strange results)
sb   	a0, 0x1(v1)				; store second half 
srl		a0, a0, $8				; move bits down
sb		a0, 0x0(v1)				; store first half



sb		t6, 0x1c(a1)			; original line 1
j		0x801327D4				; return
lw		t7, 0x3424(t7)			; original line 2

// 59 lines...just made it

// Disable Original Stage Select Option Behavior [pillowhead]
.org	0x138C6C				; @ 8013A9ec
nop
nop

// Disable Write to Team Attack Option
.org	0x127150				; @ 80133970
nop								; disable store

// Disable Write to Stage Select Option
.org	0x127160				; @ 80133980
nop								; disable store

// Disable Read from Stage Select Option
.org	0x127160				; @ 80170658
ori		t4, r0, $1				; always load 1










