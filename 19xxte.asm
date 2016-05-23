// 19XXTE - A ROM Hack by Jorgasms
/* 
Features:
Updated Title (0.10 Dev)
Updated Stage Select Screen (Battlefield, Final Destination, Metal Cavern, Yoshi's Island w/o Clouds)
Tournament Settings On Boot 
All Stages Unlocked 
All Characters Unlocked 
Timed Stock Matches
Use CLeft and CRight to cycle through ALL costume colors
Play As Polygon Fighters (Note: They don't have special moves or grabs. This is not a bug)
Boot to CSS Menu [Mada0]
All CPUs are Level 9 By Default [Mada0]
Play as Fighting Polygons [Jorgasms, tehz]
19XX Toggles (vs options menu)
    Tournament Mode (placeholder)
    Widescreen [Danny_SsB]
    Hitboxes
    Skip Results
	Random Music
	Play Music
Anti-Aliasing Disabled
Japanese Hit Sounds
Salty Runback
*/

.org 	0x20
.asciiz "0.10 Dev"		; update title

.incASM "cheats.asm"	; random changes, implemented gs
.incASM "stages.asm"	; update stage list
.incASM "timestock.asm"	; adds timer to stock matches
.incASM "dma.asm"		; load injection routine
.incASM "injections.asm"; houses injections