// 19XXCE.asm

// copy fresh rom
origin  0x00000000
insert  "roms/original.z64"

// change ROM name
origin  0x00000020
db  "19XXCE"
db  0x00

// extended asm
origin  0x01000000
base    0x80380000
variable start(pc())
include "src/AI.asm"
include "src/Boot.asm"
include "src/BGM.asm"
include "src/Camera.asm"
include "src/Cheats.asm"
include "src/Color.asm"
include "src/Combo.asm"
include "src/Costumes.asm"
include "src/FD.asm"
include "src/GameEnd.asm"
include "src/Global.asm"
include "src/Handicap.asm"
include "src/Joypad.asm"
include "src/Menu.asm"
include "src/OS.asm"
include "src/Overlay.asm"
include "src/Pause.asm"
include "src/RCP.asm"
include "src/Settings.asm"
include "src/Shield.asm"
include "src/Spawn.asm"
include "src/Stages.asm"
include "src/TimedStock.asm"
include "src/Timeouts.asm"
include "src/Training.asm"
variable end(pc())
variable size(end - start)


if size > 65536 {
    // 0x10000 = 65536
    print "needed RAM space "
    print size
    print " is greater than max RAM space (65536)\n"
    warning "not enough RAM space"
} else {
    print "RAM space used: "
    print size
    print "\n"
}

// extend ROM to 32 MBs
fill    0x2000000 - origin()
