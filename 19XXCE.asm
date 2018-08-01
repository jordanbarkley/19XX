// 19XXCE.asm
if !{defined __TE__} {
    define __CE__()
}

// copy fresh rom
origin  0x00000000
insert  "roms/original.z64"

// change ROM name
origin  0x00000020
db  "19XXCE"
db  0x00

// static
origin  0x01000000
base    0x80380000
variable start(pc())
include "src/AI.asm"
include "src/BGM.asm"
include "src/Boot.asm"
include "src/Camera.asm"
include "src/Character.asm"
include "src/Cheats.asm"
include "src/Color.asm"
include "src/Combo.asm"
include "src/Costumes.asm"
include "src/FD.asm"
include "src/FGM.asm"
include "src/GameEnd.asm"
include "src/Global.asm"
include "src/Handicap.asm"
include "src/Hazards.asm"
include "src/Joypad.asm"
include "src/Menu.asm"
include "src/OS.asm"
include "src/Overlay.asm"
include "src/Pause.asm"
include "src/Practice.asm"
include "src/RCP.asm"
include "src/Settings.asm"
include "src/Shield.asm"
include "src/Spawn.asm"
include "src/SRAM.asm"
include "src/Stages.asm"
include "src/String.asm"
include "src/Texture.asm"
include "src/TimedStock.asm"
include "src/Timeouts.asm"
include "src/Toggles.asm"
include "src/Training.asm"
variable end(pc())
variable size(end - start)

if size > 65536 {
    // 0x10000 = 65536
    print "needed heap space "
    print size
    print " is greater than max heap space (65536)\n"
    warning "not enough heap space"
} else {
    print "heap space used: "
    print size
    print "/65536\n"
}

// extend ROM to 32 MBs
origin  0x1FFFFFF
db 0x00
