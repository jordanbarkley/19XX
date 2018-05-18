// Cheats.asm
if !{defined __CHEATS__} {
define __CHEATS__()

include "OS.asm"

scope Cheats {
    // @ Description
    // Unlocks everything
    OS.patch_start(0x00042B3A, 0x800A3DEA)
    dw 0x007F0C90
    OS.patch_end()

    // @ Description
    // Nintendo 64 logo exits to character select screen because t1 contains screen ID 0x0010
    // instead of 0x0004
    OS.patch_start(0x0017EE54, 0x80131C94)
    ori     t1, r0, 0x001C
    OS.patch_end()

    // @ Descritpion
    // Nintendo 64 logo cannot be skipped.
    // Instead of checking for a button press, the check has been disabled.
    OS.patch_start(0x0017EE18, 0x80131C58)
    beq     r0, r0, 0x80131C80
    OS.patch_end()

    // @ Description
    // This alters an f3dex2 display list builder function to disable anti-aliasing.
    OS.patch_start(0x000337F8, 0x80032BF8)
    // ori     t2, r0, 0x0212
    OS.patch_end()

    // @ Description
    // The following code enables Widescreen [Danny_SsB]. I have no iddea how it works
    OS.patch_start(0x000AA37C, 0x00000000)
    dw      0x3FEF311A
    OS.patch_end()

    OS.patch_start(0x00051C80, 0x00000000)
    dw      0x3FEF311A
    OS.patch_end()

    OS.patch_start(0x000891B4, 0x8010D9B4)
    // nop
    OS.patch_end()

    // @ Description
    // This makes it so that stock value is always displayed as a number.
    OS.patch_start(0x0008B0D4, 0x8010F8D4)
    // slti    at, s1, 0x0001          // default value is 7
    OS.patch_end()

    // @ Descritpion
    // (I don't remember how this works)
    OS.patch_start(0x00081408, 0x80105C08)
    // nop
    OS.patch_end()

    // @ Description
    // This loads the character select screen id instead of the results screen id
    OS.patch_start(0x0010B204, 0x8018E314)
    // ori     t6, r0, 0x0010
    OS.patch_end()

    // @ Description
    // disable music by disable write
    OS.patch_start(0x000216fC, 0x80020AFC)
    // nop
    OS.patch_end()


    // @ Description
    // This allows multiple players to be the same color by bypassing the check.
    OS.patch_start(0x001361C8, 0x80137F48) 	
    b       0x80137F60
    OS.patch_end()
}

}