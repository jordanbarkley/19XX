// Graphics.asm

scope Graphics {

    test_string:
    db "CYJORG"
    db 0x00
    OS.align(4)

    test_palette:
    db 0xFF, 0xA5, 0x00
    db 0xFF, 0xA5, 0x00
    OS.align(4)

    // @ Description
    OS.patch_start(0x0015310C, 0x80133F6C)
    sw      a0, 0x0010(sp)
    li      a0, test_string
    li      a1, 100
    li      a2, 100
    li      a3, test_palette
    j       print_string_
    nop
    OS.patch_end()

    // @ Description
    // Found by [tehz]
    // This function is the print string function on the results screen. It has been ripped from
    // the ROM and put here for global use. The function has been slightly modified.
    // 1. The jal to a helper function has been removed and the helper function has been lazily
    //    inserted into the main function.
    // 2. The x scaler (0x0010(sp)) now scale y as well (allowing for small font).
    // 3. The function now expects an int for both x and y coordinates.
    // 4. The palette address is passed directly instead of using a table index.
    // @ Arguments
    // a0 - address of string to print
    // a1 - (int) x coordinate of string
    // a2 - (int) y cooddinate of string
    // a3 - address of palette (palette is 2 colors, 6 bytes, R1 G1 B1 R2 G1 G2)
    // sp + 0x10 - (float) string scale (overidden)
    scope print_string_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // ~
        sw      a0, 0x000C(sp)              // ~
        sw      v0, 0x0010(sp)              // save registers

        li      t0, 0x3E800000              // float for .25
        sw      t0, 0x0028(sp)              // save scaler

        or      a0, a1, r0                  // a0 = (int) xpos
        jal     OS.int_to_float_            // ~
        nop                                 // ~
        or      a1, v0, r0                  // a1 = (float) xpos 

        or      a0, a2, r0                  // a0 = (int) xpos
        jal     OS.int_to_float_            // ~
        nop                                 // ~
        or      a2, v0, r0                  // a2 = (float) xpos 
        

        lw      t0, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // ~
        lw      a0, 0x000C(sp)              // ~
        lw      v0, 0x0010(sp)              // restore registers
        addiu   sp, sp, 0x0018              // deallocate stack space
        

        insert "print_string_.bin"
    }



}