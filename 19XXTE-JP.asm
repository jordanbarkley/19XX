// 19XXTE-JP.asm
// JP (NTSC-J) entry point for 19XXTE.

define __TE__()
define REGION_JP()
include "19XXCE.asm"

// change ROM name
origin  0x00000020
db  "19XXTEJ 1.6"
fill 0x34 - origin(), 0x20
