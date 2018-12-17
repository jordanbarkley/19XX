// FD.asm
if !{defined __FD__} {
define __FD__()
print "included FD.asm\n"

// @ Description
// This file makes Final Destination playable in VS. mode.

include "OS.asm"
scope FD {

    // @ Description
    // Makes Final Destination playables in VS. mode by skipping a jal to code only available in 
    // in singleplayer
    OS.patch_start(0x00080484 , 0x80104C84)
    nop                                     // jal 0x80192764
    OS.patch_end()

    // @ Description
    // Sets track to 0x18 (FD battle music)
    OS.patch_start(0x640CD2, 0x00000000)
    dh 0xC33E
    OS.patch_end()
}

}