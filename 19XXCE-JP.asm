// 19XXCE-JP.asm
// JP (NTSC-J) entry point for 19XXCE.
//
// Defines REGION_JP, then includes the shared 19XXCE.asm.  The src/ files
// contain `if {defined REGION_JP}` guards that select JP addresses; the US
// build is unaffected because REGION_JP is left undefined there.
//
// Build with:  make jp
// Requires:    roms/original.jp.z64  (vanilla NTSC-J ROM,
//              SHA1 4b71f0e01878696733eefa9c80d11c147ecb4984)

define REGION_JP()
include "19XXCE.asm"
