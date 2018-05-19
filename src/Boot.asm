// Boot.asm
if !{defined __BOOT__} {
define __BOOT__()

// @ Description
// This file loads 19XX data into expansion RAM.

include "OS.asm"
include "Global.asm"

scope Boot {
    // @ Description
    // Originally, this instruction performed one DMA as part of the boot sequence. It now branches
    // to unsused space in the boot sequence and loads an extra 4 MBs into expansion RAM.
    OS.patch_start(0x00001234, 0x80000634)
    j       0x80000438
    nop
    OS.patch_end()

    OS.patch_start(0x00001038, 0x80000438)
    jal     Global.dma_copy_        // original line 1
    addiu   a2, r0, 0x0100          // original line 2
    lui     a0, 0x0100              // load rom address (0x01000000)
    lui     a1, 0x8040              // load ram address (0x80400000)
    jal     Global.dma_copy_        // add custom functions
    lui     a2, 0x0040              // load length of 4 MB
    j       0x80000638              // return
    nop
    OS.patch_end()
}

}