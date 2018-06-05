// 19XXTE.asm

// copy fresh rom
origin  0x00000000
insert  "roms/original.z64"

// change ROM name
origin  0x00000020
db  "19XXTE"
db  0x00

// extended asm
origin  0x01000000
base    0x80380000
include "src/Boot.asm"
include "src/Camera.asm"
include "src/Cheats.asm"
include "src/Costumes.asm"
include "src/FD.asm"
include "src/GameEnd.asm"
include "src/Global.asm"
include "src/Handicap.asm"
include "src/OS.asm"
include "src/Pause.asm"
include "src/Settings.asm"
include "src/Spawn.asm"
include "src/Stages.asm"
include "src/TimedStock.asm"
include "src/Timeouts.asm"

// extend ROM to 32 MBs
fill    0x2000000 - origin()