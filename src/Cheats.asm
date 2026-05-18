// Cheats.asm
if !{defined __CHEATS__} {
define __CHEATS__()
print "included Cheats.asm\n"

// @ Description
// This file contains a list of permanent, random patches to make SSB better.

include "OS.asm"

scope Cheats {
    // @ Description
    // Unlocks everything
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00042EA2, 0x800A1DC2)
    } else {
    OS.patch_start(0x00042B3A, 0x800A3DEA)
    }
    dw 0x007F0C90
    OS.patch_end()

    // @ Description
    // This alters an f3dex2 display list builder function to disable anti-aliasing.
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00033BD8, 0x80032FD8)
    } else {
    OS.patch_start(0x000337F8, 0x80032BF8)
    }
    // ori     t2, r0, 0x0212
    OS.patch_end()

    // @ Description
    // The following code enables Widescreen [Danny_SsB]. I have no iddea how it works
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x000AA2BC, 0x00000000)
    } else {
    OS.patch_start(0x000AA37C, 0x00000000)
    }
    dw      0x3FEF311A
    OS.patch_end()

    // second widescreen float lives in a constant pool; on JP that pool sits
    // 0x230 bytes later -- US 0x51C80 maps to a jump-table entry on JP, so
    // patching there clobbered a function pointer (PC crash at 0x3FEF311A).
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00051EB0, 0x00000000)
    } else {
    OS.patch_start(0x00051C80, 0x00000000)
    }
    dw      0x3FEF311A
    OS.patch_end()

    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00089154, 0x8010B5C4)
    } else {
    OS.patch_start(0x000891B4, 0x8010D9B4)
    }
    // nop
    OS.patch_end()

    // @ Description
    // This makes it so that stock value is always displayed as a number.
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x0008B074, 0x8010D4E4)
    } else {
    OS.patch_start(0x0008B0D4, 0x8010F8D4)
    }
    // slti    at, s1, 0x0001          // default value is 7
    OS.patch_end()

    // @ Descritpion
    // (I don't remember how this works)
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x000813A8, 0x80103818)
    } else {
    OS.patch_start(0x00081408, 0x80105C08)
    }
    // nop
    OS.patch_end()

    // @ Description
    // disable music by disable write
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x0002149C, 0x8002089C)
    } else {
    OS.patch_start(0x000216FC, 0x80020AFC)
    }
    // nop
    OS.patch_end()

    // @ Description
    // This allows multiple players to be the same color by bypassing the check.
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00136FF8, 0x80135AE8)
    b       0x80135B00
    } else {
    OS.patch_start(0x001361C8, 0x80137F48)
    b       0x80137F60
    }
    OS.patch_end()
}

} // __CHEATS__
