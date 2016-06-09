// 19XXTE.asm

.org 	0x20
.asciiz "0.11 Dev"		; update title

.incASM "cheats.asm"	; random changes, implemented gs
.incASM "stages.asm"	; update stage list
.incASM "timestock.asm"	; adds timer to stock matches
.incASM "dma.asm"		; load injection routine
.incASM "functions.asm"	; houses custom code