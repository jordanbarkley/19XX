// functions.asm
[ram]: $80380000			; functions location
/*
For expansion pak (if necessary)
[ram]: $80400000			; functions
*/

/*
Spam select characters quick notes
@ 8013A93C
addiu	t7, t6, 0x1 (frame advance)
stores to s0 (8013bdcc), a frame counter
setting having it add 0x30 instead lets you spam chars
*/ 

[toggle01]: $00000080		; Widescreen
[toggle02]: $00000100		; Hitboxes
[toggle03]: $00002000		; Skip Results
[toggle04]: $00000200		; Random Music 
[toggle05]: $00004000		; Play Music
[toggle06]: $00008000		; P1 Derek Stick Fix
[toggle07]: $00010000		; P2 Derek Stick Fix
[toggle08]: $00060000		; P3 Derek Stick Fix
[toggle09]: $00080000		; P4 Derek Stick Fix
[toggle10]: $00000800		; 
[toggle11]: $00001000		; 
[toggle12]: $00000400		; 
[toggle13]: $00000010		; 
[toggle14]: $00000020		; 
[toggle15]: $00000040		; 
[varspace]: $800a4d14		; item address 

/*
Table of Contents
00. Reduced Stick Input (Toggle)
01. Widescreen and Enable Hitboxes (Toggles)
02. Skip Results Screen and Salty Runback (Toggles)
03. Play Music and Random Music (Toggles)
04. (removed)
05. Access All Costumes
06. Play As Polygon Characters
07. Polygons Crash Fix (Character Select Screen) [tehz]
08. Polygons Crash Fix (Results Screen) [tehz]
*/

// 00. Reduced Stick Input (Toggle)
.org	0x32C24					; @ 80032024
mthi	gp						; save gp
j		@ram					; jump to custom function
ori		gp, r0, $0				; load function number	

// 01. Widescreen and Enable Hitboxes (Toggles)
.org	0x891B4					; @ 8010D9B4
mthi	gp						; save gp
j		@ram					; jump to custom function
ori		gp, r0, $1				; load function number		

// 02. Skip Results Screen and Salty Runback (Toggles)
.org	0x10B204 				; @ 8018E314
mthi	gp						; save gp
j		@ram					; jump to custom function
ori		gp, r0, $2				; load function number

// 03. Play Music and Random Music (Toggles)
.org	0x216f4					; @ 80020AF4
mthi	gp						; save gp
j		@ram					; jump to custom function
ori		gp, r0, $3				; load function number

// 05. Access All Costumes
.org	0x1361B4				; @ 80137F34
mthi	gp						; save gp
j		@ram					; jump to custom function
ori		gp, r0, $5				; load function number	

// 06. Play as Polygon Characters
.org	0x138974				; @ 8013A6F4
mthi	gp						; save gp
j		@ram					; jump to custom function
ori		gp, r0, $6				; load function number		

// 07. Polygons Crash Fix (Character Select Screen) [tehz]
.org	0x138F44				; @ 8013ACC4
mthi	gp						; save gp
j		@ram					; jump to custom function
ori		gp, r0, $7				; load function number	

// 08. Polygons Crash Fix (Results Screen) [tehz]
.org	0x150DD0				; @ 80131C30
mthi	gp						; save gp
j		@ram					; jump to custom function
ori		gp, r0, $8				; load function number	

// Functions
.org	0xf60000
Setup:
mtlo	v0						; save v0
lui		v0, @ram				; ~
ori		v0, v0, @ram			; get RAM address
addiu	v0, v0, $24				; add length difference
sll		gp, gp, $3				; multiply function # by 8
add		v0, v0, gp				; get location of branch
mfhi	gp						; restore gp
jr		v0						; jump to correct branch
nop

Table:
// 00. Reduced Stick Input (Toggle)
beq		r0, r0, Reduced_Input_Start
mflo	v0

// 01. Widescreen and Enable Hitboxes (Toggles)
beq		r0, r0, Widescreen_Start
mflo	v0

// 02. Skip Results Screen and Salty Runback (Toggles)
beq		r0, r0, Skip_Results_Start
mflo	v0

// 03. Play Music and Random Music (Toggles)
beq		r0, r0, Random_Song_Start
mflo	v0

// (removed)
nop
nop

// 05. Access All Costumes
beq		r0, r0, Costume_Start
mflo	v0

// 06. Play as Polygon Characters
beq		r0, r0, Polygon_Start
mflo	v0

// 07. Polygons Crash Fix (Character Select Screen) [tehz]
beq		r0, r0, tehz1_Start
mflo	v0

// 08. Polygons Crash Fix (Results Screen) [tehz]
beq		r0, r0, tehz2_Start
mflo	v0

//===========================================================
// 00. Reduced Stick Input (Toggle)
//===========================================================
Reduced_Input_Start:
nop								; naming convention

Reduced_Input_Original:
lwl		t8, 0x4(v0)				; original line 1
lwr		t8, 0x7(v0)				; original line 2

Reduced_Input_Save:
addiu	sp, sp, $FFF4			; allocate stack
sw		gp, 0x0(sp)				; save gp
sw		v0, 0x4(sp)				; save v0
sw		t0, 0x8(sp)				; save t0
ori		t0, r0, $0				; set t0 = 0

/*
p1 when v0 = 8009EFA0
p2 when v1 = 8009EFA8
p3 when v2 = 8009EFB0
p4 when v3 = 8009EFB8
*/

Reduced_Input_Player1:
lui		gp, $8009				; ~
ori 	gp, gp, $EFA0			; load player 1 address
bne		gp, v0, Reduced_Input_Player2
nop								; if not p1, check p2
lui		gp, @varspace			; ~
ori		gp, gp, @varspace		; get toggle address
lw		gp, 0x0(gp)				; get that word
andi	gp, gp, @toggle12		; check if toggle on
blez	gp, Reduced_Input_Complete
nop								; return
beq		r0, r0, Reduced_Input_Y
nop								; begin reduction

Reduced_Input_Player2:
lui		gp, $8009				; ~
ori 	gp, gp, $EFA8			; load player 2 address
bne		gp, v0, Reduced_Input_Player3
nop								; if not p2, check p3
lui		gp, @varspace			; ~
ori		gp, gp, @varspace		; get toggle address
lw		gp, 0x0(gp)				; get that word
andi	gp, gp, @toggle13		; check if toggle on
blez	gp, Reduced_Input_Complete
nop								; return
beq		r0, r0, Reduced_Input_Y
nop								; begin reduction

Reduced_Input_Player3:
lui		gp, $8009				; ~
ori 	gp, gp, $EFB0			; load player 3 address
bne		gp, v0, Reduced_Input_Player4
nop								; if not p3, check p4
lui		gp, @varspace			; ~
ori		gp, gp, @varspace		; get toggle address
lw		gp, 0x0(gp)				; get that word
andi	gp, gp, @toggle14		; check if toggle on
blez	gp, Reduced_Input_Complete
nop								; return
beq		r0, r0, Reduced_Input_Y
nop								; begin reduction

Reduced_Input_Player4:
lui		gp, $8009				; ~
ori 	gp, gp, $EFA8			; load player 4 address
bne		gp, v0, Reduced_Input_Complete
nop								; if not p4, (is this possible)
lui		gp, @varspace			; ~
ori		gp, gp, @varspace		; get toggle address
lw		gp, 0x0(gp)				; get that word
andi	gp, gp, @toggle15		; check if toggle on
blez	gp, Reduced_Input_Complete
nop								; return
beq		r0, r0, Reduced_Input_Y
nop								; begin reduction

// $00 - $7F = Up  , 01	= +1, 02 = +2...
// $80 - $FF = Down, FF = -1, FE = -2...
Reduced_Input_Y:
andi	gp, t8, $00FF			; get rid of everything but y
sltiu	v0, gp, $80				; if gp < 80, v0 = 1 (up) 
bne		v0, r0, Reduced_Input_PY; input is positive
nop
beq		r0, r0, Reduced_Input_NY; input is negative
nop

Reduced_Input_PY:
ori		v0, r0, $2				; ~
mult	gp, v0					; ~
mflo	gp						; ~
ori		v0, r0, $4				; ~
div		gp, v0					; ~
mflo	gp						; multiply y input by 2/3
or		t0, t0, gp				; save new y in t0

beq		r0, r0, Reduced_Input_X
nop								; skip negative script

Reduced_Input_NY:
lui		v0, $ffff				; ~
ori		v0, v0, $ffff			; ~
mult	gp, v0					; ~		
mflo	gp						; ~
andi	gp, gp, $00FF			; ~ get the positive version
ori		v0, r0, $2				; ~
mult	gp, v0					; ~
mflo	gp						; ~
ori		v0, r0, $4				; ~
div		gp, v0					; ~
mflo	gp						; multiply y input by 2/3
lui		v0, $ffff				; ~
ori		v0, v0, $ffff			; ~
mult	gp, v0					; ~		
mflo	gp						; ~
andi	gp, gp, $00FF			; get the negative version
or		t0, t0, gp				; save new y in t0

// $00 - $7F = Right, 01 = +1, 02 = +2...
// $80 - $FF = Left , FF = -1, FE = -2...
Reduced_Input_X:
andi	gp, t8, $FF00			; get rid of everything but x
srl		gp, gp, $8				; shift x right (for ease)
sltiu	v0, gp, $80				; if gp < 80, v0 = 1 (right) 
bne		v0, r0, Reduced_Input_PX; input is positive
nop
beq		r0, r0, Reduced_Input_NX; input is negative
nop

Reduced_Input_PX:
ori		v0, r0, $2				; ~
mult	gp, v0					; ~
mflo	gp						; ~
ori		v0, r0, $4				; ~
div		gp, v0					; ~
mflo	gp						; multiply x by 2/3
sll		gp, gp, $8				; shift x left (restore)
or		t0, t0, gp				; save new x in t0
beq		r0, r0, Reduced_Input_Return
nop								; skip negative script

Reduced_Input_NX:
lui		v0, $ffff				; ~
ori		v0, v0, $ffff			; ~
mult	gp, v0					; ~		
mflo	gp						; ~
andi	gp, gp, $00FF			; ~ get the positive version
ori		v0, r0, $2				; ~
mult	gp, v0					; ~
mflo	gp						; ~
ori		v0, r0, $4				; ~
div		gp, v0					; ~
mflo	gp						; multiply y input by 2/3
lui		v0, $ffff				; ~
ori		v0, v0, $ffff			; ~
mult	gp, v0					; ~		
mflo	gp						; ~
andi	gp, gp, $00FF			; get the negative version
sll		gp, gp, $8				; shift x left (restore)
or		t0, t0, gp				; save new x in t0

Reduced_Input_Return:
srl		t8, t8, $10				; ~
sll		t8, t8, $10				; get rid of xxyy
or		t8, t8, t0				; insert new xxyy

Reduced_Input_Complete:
lw		gp, 0x0(sp)				; restore gp
lw		v0, 0x4(sp)				; restore v0
lw		t0, 0x8(sp)				; restore t0
addiu	sp, sp, 0xC				; trash stack
j		0x80032030				; return
sw		t8, 0x4(a2)				; original line 3
*/
//=============================================================
// 01. Widescreen and Enable Hitboxes (Toggles)
//=============================================================
Widescreen_Start:
nop								; naming convention

Widescreen:
mthi	gp
lui 	at, @varspace
ori		at, at, @varspace		; get varspace address
lw		at, 0x0(at)				; get that word
andi	gp, at, @toggle01		; check if widescreen is on
bgtz 	gp, Hitboxes			; if on, skip line that
;								  disables widescreen
nop
swc1 	f10, 0x24(s1)			; original line 1

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
mfhi	gp						; restore gp
lwc1	f16, 0xc50(at)			; original line 2
j 		0x8010D9C0				; return
swc1	f18, 0x0(v0)			; original line 3

//============================================================
// 02. Skip Results Screen and Salty Runback (Toggles)
//============================================================
Skip_Results_Start:
nop								; naming convention

Default_Screen:
addiu 	t6, r0, 0x18			; original line 1(load results)

SR:
mthi	gp						; save gp
mtlo	v0						; save v0
lui		a0, $8009				; ~
ori		a0, a0, $EFA4 			; load base pointer
lui		v0, $ffff				; ~
ori		v0, v0, $ffff			; load unplugged value

SR_P1:
lh		gp, 0x0(a0)				; get p1 buttons
beq		gp, v0, SR_P2			; if controller unplugged
andi	gp, gp, $f				; check if any c buttons held
blez	gp, SR_P2				; if not, check p2
nop
beq		r0, r0, SR_End

SR_P2:
lh		gp, 0x8(a0)				; get p2 buttons
beq		gp, v0, SR_P3			; if controller unplugged
andi	gp, gp, $f				; check if any c buttons held
blez	gp, SR_P3				; if not, check p3
nop
beq		r0, r0, SR_End

SR_P3:
lh		gp, 0x10(a0)			; get p3 buttons
beq		gp, v0, SR_P4			; if controller unplugged
andi	gp, gp, $f				; check if any c buttons held
blez	gp, SR_P4				; if not, check p4
nop
beq		r0, r0, SR_End

SR_P4:
lh		gp, 0x18(a0)			; get p4 buttons
beq		gp, v0, Results			; if controller unplugged
andi	gp, gp, $f				; check if any c buttons held
blez	gp, Results				; if not, go to results
nop
beq		r0, r0, SR_End

Results:
lui   	a0, @varspace			
ori		a0, a0, @varspace		; load variable address
lw   	a0, 0x0(a0)				; get that word
andi	a0, a0, @toggle03		; check if skip results on
blez 	a0, Results_End			; if off, don't load css value
nop
ori   	t6, r0, $10				; load css value

Results_End:
mfhi	gp						; restore gp
mflo	v0						; restore v0
sb   	t6, 0x0(v0)				; original line 2 (store value)
j 		0x8018E320				; return
addiu	sp, sp, $18				; original line 3

SR_End:
mfhi	gp						; restore gp
mflo	v0						; restore v0
ori		t6, r0, $16				; load "fighting" value
sb   	t6, 0x0(v0)				; original line 2 (store value)
j 		0x8018E320				; return
addiu	sp, sp, $18				; original line 3

//=============================================================
// 03. Play Music and Random Music (Toggles)
//=============================================================
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

Random_Song_Start:
addu	t3, t1, t2				; original line 1
sw 		r0, 0x0(t3)				; clear music address
mthi	gp						; save gp
lui 	gp, @varspace
ori		gp, gp, @varspace		; get varspace address
lw		gp, 0x0(gp)				; get word (should be hword)
andi	gp, gp, @toggle04		; check random music toggle
blez 	gp, Music				; if off, skip to mute music

li   	gp, $0a					; load choose your character
beq  	gp, a1, Music			; skip if menu music
li   	gp, $2c					; load other menu music
beq  	gp, a1, Music 			; skip if menu music 
nop

Random_Music_Get_Address:
mtlo	ra						; save ra
jal		0x80020B00				; jump to jr ra
nop
or		gp, r0, ra				; copy ra to gp
addiu 	gp, gp, $FFB0			; subtract above lines
mflo	ra						; restore ra

Random_Music_Generate_Random:
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
mfhi	gp						; restore gp
jr 		ra
sb   	a1, 0x3(t3)				; store music selection btye


//=============================================================
// 05. Access All Costumes
//=============================================================
Costume_Start:
nop								; naming convention

Costume_Get_Player:
lui    	t0, $8013
ori		t0, t0, $BA88			; load "p1 s0"
li    	t1, $BC
sub   	t0, s0, t0 				; get the difference
div   	t0, t1 					; lo = t0 / t1
mflo  	t0						; t0 = t0 / t1

Costume_Load_Buttons: 
sll   	t0, t0, $3				;  difference * 2^3
lui   	t1, $8009	
ori   	t1, t1, $EFA4			; get base button pointer
add   	t1, t0, t1				; get player button pointer
lh    	t1, 0x0(t1)				; get player buttons

Costume_Check_Left:
andi   	t0, t1, $2 				; t0 now holds c left
blez  	t0, Costume_Check_Right	; if off skip
nop
lw    	v0, 0x4C(s0)			; get current color
addiu  	v0, v0, $FFFF			; subtract 1 from costume
beq   	r0, r0, Costume_Limit
li    	t0, $0

Costume_Check_Right:
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
sw    	v0, 0x24(sp)			; v0 holds costume (original)
lw    	a0, 0x48(s0)			; original line 2
lw		a1, 0x28(sp)			; original line 3
j     	0x80137F40 
sw    	v0, 0x4C(s0)			; store updated

//=============================================================
// 06. Play As Polygon Characters
//=============================================================
// t5 holds the costume
// t9 holds the character  (800A4D08 + 23 + 74*)
Polygon_Start:
nop								; naming convention

Polygon_Check:
sb		t4, 0x22(a0)			; original line 1
lui		gp, $FFFF				; ~
ori		gp, gp, $FFFF			; load -1
bne   	gp, t5, Polygon_Return	; if costume = -1, continue
nop

Polygon_Update_Char:
addiu	t9, t9, $e				; add (polygon - char)
li		t5, $0					; update costume

Polygon_Return:	
sb		t9, 0x23(a0)			; original line 2
j 		0x8013A700				; return
sb		t5, 0x26(a0)			; original line 3

/*
Hint hint hint hint hint hint xD

// Disable Animation Changes On CSS
.org	0x132C98
nop

// 80134A18 - jal to getAnimations
// 801348EC - location of jal 
.org	0x132B6C
jr		ra
nop
hex 	{fedc98ba}


// set animation
.org	0x107BAC
jr		ra
nop
hex 	{fedc98ba}

// (003905CC in debug menu)
 
// Change Mario, Kirby, Pikachu and Puff's Animation
.org	0x132BB0				; @ 80134930
lui		v0, $2
jr		ra
ori		v0, v0, $9
*/

//=============================================================
// 07. Polygons Crash Fix (Character Select Screen) [tehz]
//=============================================================
tehz1_Start:
nop								; naming convention

tehz1_legalityChecks:
ori		at, r0, 0x0002 			; load 2
beq		a1, at, tehz1_return  	; if a1 = 2 (n/a)
ori		at, r0, 0x001C
beq		t0, at, tehz1_return	; if t0 = 1C (no character)
sltiu	at, t0, 0x000C
bne		at, r0, tehz1_return	; if t0 <= Ness (not polygon)
nop
addiu	t0, t0, 0xFFF2			; else, char is polygon (-$E)

tehz1_return:
sw		r0, 0x001C(v0)			; original line 1
sw		r0, 0x0020(v0)			; original line 2
sw		r0, 0x0024(v0)			; original line 3
j		0x0013ACD0				; return
sb		t0, 0x0023(v1)			; store character

//===========================================================
// 08. Polygons Crash Fix (Results Screen) [tehz]
//===========================================================
tehz2_Start:
nop								; naming convention

tehz2_replacedCode:	
lbu		s4, 0x23(v0)			; original line 2

tehz2_legalityCheck:	
slti	at,	 s4, 0x000C			; k1 isn't safe, tehz
bgtz	at, tehz2_return		; if (char id < ness), return
nop
addiu	s4, s4, 0xFFF2			; else, char is polygon (-$E)

tehz2_return:	
addiu	at, r0, 0x003C			; original line 1
divu	t7, at					; original line 3
j 		0x80131C3C				; return
sb		s4, 0x0023 (v0)			; store character



