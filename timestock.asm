// timestock.asm

// 800a4d38 - player 1 deaths
// 800a4d3c - player 1 KOs
// 8013BE04 - mips line to add 1 to score

// Time Stock [Danny_SsB, Mada0]
.org	0x001241a0
hex		{ 24180003 }
.org	0x001389FC 
hex		{ 55A8 }
.org	0x42D1B
hex		{ 03 }

// Results Screen Fix
.org	0xB6848			; @ 8013BE04
li		t7, $0			; KOs always = 0, winner = least deaths

// Team Timed Stock Matches (If changed in Vs. Options Menu)
.org	0x1241b4
li		t9, $3

/* Sudden Death Test
Action			P1 P2
P1 Suicide		-1 +0
P1 Suicide		-2 +0
P1 Kill			-1 -1
P1 Kill			+0 -2
P2 Kill			-1 -1