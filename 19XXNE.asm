// 19XXNE.asm
define __NE__()
include "19XXCE.asm"

// change ROM name
origin  0x00000020
db  "19XXNE 1.6"
fill 0x34 - origin(), 0x20
