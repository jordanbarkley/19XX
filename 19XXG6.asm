// 19XXG6.asm
define __G6__()
define __TE__()
include "19XXCE.asm"

// change ROM name
origin  0x00000020
db  "19XXG6 1.6"
fill 0x34 - origin(), 0x20
