// 19XX.asm

// copy fresh rom
origin  0x00000000
insert  "roms/original.z64"

// change ROM name
origin  0x00000020
db  "19XX"
db  0x00

// extended asm
origin  0x01000000
base    0x80400000
include "src/Boot.asm"
include "src/BGM.asm"
include "src/Camera.asm"
include "src/Cheats.asm"
include "src/Color.asm"
include "src/Costumes.asm"
include "src/FD.asm"
include "src/Global.asm"
include "src/Graphics.asm"
include "src/OS.asm"
include "src/Pause.asm"
include "src/RCP.asm"
include "src/Settings.asm"
include "src/Shield.asm"
include "src/Spawn.asm"
include "src/Stages.asm"
include "src/TimedStock.asm"
include "src/Timeouts.asm"

fill 	0x2000000 - origin() 	// Extend ROM to 32 MBs

include "src/OS.asm"
// disable menu init on debug screen 80371414
base    0x80369D78
origin  0x001AC1E8
jr      ra 
nop

// hook for menu
base    0x800D64A0
origin  0x00119E00
addiu 	sp, sp,-0x0008
sw 		ra, 0x0004(sp)
//jal     main
nop
lw 		ra, 0x0004(sp)
addiu 	sp, sp, 0x0008
jr 		ra
nop




