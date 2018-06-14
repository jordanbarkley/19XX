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
    // a0 - width
    // a1 - height
    // a2 - ROM address
    // @ Returns
    // v0 - address or OS.NULL if there is not enough space
    scope allocate_: {
        addiu   sp, sp,-0x0008              // allocate stack space
        sw      ra, 0x0004(sp)              // save registers

        // calculate nBytes
        multu   a0, a1                      // ~
        mflo    a1                          // a1 = width * height
        sll     a1, a1, 0x0001              // a1 = width * height * sizeof(rgba5551)

        // attempt allocate memory
        move    a0, a2                      // a0 - ROM address
//      move    a1, a1                      // a1 - size
        jal     Memory.allococate_rom_
        nop

        // return
        lw      ra, 0x0004(sp)              // restore registers
        addiu   sp, sp, 0x0008              // deallocate stack space
        jr      ra                          // return
        nop
    }
}

}