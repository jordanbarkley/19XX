// Camera.asm
if !{defined __CAMERA__} {
define __CAMERA__()

include "OS.asm"

scope Camera {

    // @ Description
    // This replaces a call to Global.random_int_. Usually, when 0 is returned, the cinematic entry
    // does not play. Here, v0 is always set to 0. 
    // @ Warning
    // This is not a function and should not be called.
    scope disable_cinematic_: {
        OS.patch_start(0x0008E250, 0x80112A50)
        or      v0, r0, r0
        nop
        OS.patch_end()
    
        break    // break execution in case this gets called
    }
}

}