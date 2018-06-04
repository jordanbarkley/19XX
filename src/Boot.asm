// Boot.asm
if !{defined __BOOT__} {
define __BOOT__()

// @ Description
// This file loads 19XX data into RAM.

include "OS.asm"
include "Global.asm"

scope Boot {
    // @ Description
    // Originally, this instruction performed one DMA as part of the boot sequence. It now branches
    // to unsused space in the boot sequence and transfers 0x10000 bytes to 0x80380000
    OS.patch_start(0x00001234, 0x80000634)
    j       0x80000438
    nop
    OS.patch_end()

    OS.patch_start(0x00001038, 0x80000438)
    jal     Global.dma_copy_        // original line 1
    addiu   a2, r0, 0x0100          // original line 2
    lui     a0, 0x0100              // load rom address (0x01000000)
    lui     a1, 0x8038              // load ram address (0x80380000)
    jal     Global.dma_copy_        // add custom functions
    lui     a2, 0x0001              // load length of 0x100000
    j       0x80000638              // return
    nop
    OS.patch_end()

    // @ Description
    // This shrinks Sakurai's heap equivalent for the main heap (0x8013XXXX - 0x8039XXXX)
    // @ Argument
    // a0 - pointer to heap struct
    // a1 - heap id
    // a2 - start of heap
    // a3 - size of heap
    // @ a0 heap struct
    // 0x0000 - heap id
    // 0x0004 - start of heap
    // 0x0008 - end of heap
    // 0x000C - heap address
    scope shrink_heap_: {
        OS.patch_start(0x00007954, 0x80006D54)
        j       shrink_heap_
        nop
        _shrink_heap_return:
        OS.patch_end()

        addu    t6, a2, a3                  // original line 1 (t6 = end of "heap")git
        sw      a1, 0x0000(a0)              // original line 2

        addiu   sp, sp,-0x0008              // allocate stack space
        sw      at, 0x0004(sp)              // save at

        lui     at, 0x8038                  // a1 = 0x80300000
        sltu    at, at, t6                  // if (0x80380000 < end of heap)
        beqz    at, _end                    //
        nop
        lui      t6, 0x8038                  // t6 = new heap end

        _end:
        lw      at, 0x0004(sp)              // restore at
        addiu   sp, sp, 0x0008              // deallocate stack space
        j       _shrink_heap_return         // return
        nop
    }

}

}