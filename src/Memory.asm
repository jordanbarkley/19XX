// Textures.asm
if !{defined __MEMORY__} {
define __MEMORY__()

// @ Description
// This file allows for "dynamic" loading of memory into the third framebuffer (0x803DA800). This
// space is only used during the introduction video which has been disabled during for 19XX
// functions.

include "OS.asm"

scope Memory {

    // @ Description
    // size of framebuffer is 320 * 230 * sizeof(rgba5551)
    constant SIZE(320 * 230 * 2)
    constant START(0x803DA800)

    // @ Description
    // Keeps track of location of memory.
    macro info() {
        dw START                            // 0x0000 - start
        dw START                            // 0x0004 - current
        dw START + SIZE                     // 0x0008  - end
    }

    info:
    info()

    // @ Description
    // Resets Info.curr to START
    scope reset_: {
        addiu   sp, sp,-0x0008              // allocate stack space
        sw      t0, 0x0000(sp)              // save t0
        sw      t1, 0x0004(sp)              // save t1

        li      t0, info                    // t0 = address of info struct
        li      t1, START                   // ~
        sw      t1, 0x0004(t0)              // current = start

        lw      t0, 0x0000(sp)              // save t0
        lw      t1, 0x0004(sp)              // save t1
        addiu   sp, sp, 0x0008              // deallocate stack space
        jr      ra                          // restore
        nop
    }

    // @ Description
    // Allocates memory for data from ROM
    // @ Arguments
    // a0 - ROM address
    // a1 - size
    // @ Returns
    // v0 - address or OS.NULL if there is not enough space
    scope allococate_rom_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0000(sp)              // save t0
        sw      t1, 0x0004(sp)              // save t1
        sw      at, 0x0008(sp)              // save at
        sw      ra, 0x000C(sp)              // save ra

        // check if there is enough space for the allocation
        li      t0, info                    // ~
        lw      t1, 0x0004(t0)              // t1 = current
        add     t1, t1, a1                  // t1 = current + size
        lw      t0, 0x0008(t0)              // t0 = end
        sltu    at, t1, t0                  // ~
        beqz    at, _return                 // if ((current + size) < end), continue, else return
        lli     v0, OS.NULL                 // v0 = ret = OS.NULL

        // copy adddress
        li      t0, info                    // t0 = address of info
//      move    a0, a0                      // a0 - ROM address | 0x00FFFFFF
        move    a2, a1                      // a2 - nBytes 
        lw      a1, 0x0004(t0)              // a1 - RAM vAddress
        move    v0, a1                      // v0 = ret = RAM address
        sw      t1, 0x0004(t0)              // increment RAM address for next time
        jal     Global.dma_copy_            // copy contents
        nop

        _return:
        lw      t0, 0x0000(sp)              // restore t0
        lw      t1, 0x0004(sp)              // restore t1
        lw      at, 0x0008(sp)              // restore at
        lw      ra, 0x000C(sp)              // restore ra
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Allocates memory for data from RAM. This method is very slow.
    scope allocate_ram_: {

    }

}

}