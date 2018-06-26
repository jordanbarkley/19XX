// Camera.asm
if !{defined __CAMERA__} {
define __CAMERA__()
if !{defined __TE___} {

// @ Description
// This file disables the cinematic introduction before VS. matches.

include "Global.asm"
include "Menu.asm"
include "OS.asm"

scope Camera {

    // @ Description
    // This replaces a call to Global.random_int_. Usually, when 0 is returned, the cinematic entry
    // does not play. Here, v0 is always set to 0. 
    scope disable_cinematic_: {
        OS.patch_start(0x0008E250, 0x80112A50)
        j       disable_cinematic_
        nop
        _disable_cinematic_return:
        OS.patch_end()

        jal     Global.get_random_int_      // original line 1
        lli     a0, 0x0003                  // original line 2
        Menu.toggle_guard(Menu.entry_disable_cinematic_camera, _disable_cinematic_return)

        lli     v0, OS.FALSE                // v0 = not cinematic camera
        j       _disable_cinematic_return   // return
        nop

    }
}

}
}