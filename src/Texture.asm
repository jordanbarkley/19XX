// Texture.asm
if !{defined __TEXTURE__} {
define __TEXTURE__()

include "Memory.asm"
include "OS.asm"

scope Texture {
    macro info(variable width, variable height) {
        dw width                            // 0x0000 - width of texture
        dw height                           // 0x0004 - height of texture
        dw pc() + 8                         // 0x0008 - pointer to image data
        dw 0x1000000 + pc() - 0x80380000 + 4// 0x000C - ROM address (base calculation)
    }

    // @ Description
    // Wrapper to allocate texture
    // @ Arguments
    // a0 - texture struct
    // @ Returns
    // v0 - address or OS.NULL if there is not enough space
    scope allocate_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0000(sp)              // ~
        sw      t1, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // save registers

        // calculate nBytes
        lw      t0, 0x0000(a0)              // t0 = width
        lw      t1, 0x0004(a0)              // t1 = height
        multu   t0, t1                      // ~
        mflo    a1                          // a1 = width * height
        sll     a1, a1, 0x0001              // a1 = width * height * sizeof(rgba5551)

        // attempt allocate memory
        lw      a0, 0x000C(a0)              // a0 - ROM address
//      move    a1, a1                      // a1 - size
        jal     Memory.allococate_rom_
        nop

        // return
        lw      t0, 0x0000(sp)              // ~
        lw      t1, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }
}

}