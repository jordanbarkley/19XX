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
include "src/Joypad.asm"
include "src/Menu.asm"
include "src/OS.asm"
include "src/Overlay.asm"
include "src/Pause.asm"
include "src/RCP.asm"
include "src/Results.asm"
include "src/Settings.asm"
include "src/Shield.asm"
include "src/Spawn.asm"
include "src/Stages.asm"
include "src/TimedStock.asm"
include "src/Timeouts.asm"

// Extend ROM to 32 MBs
fill    0x2000000 - origin()
