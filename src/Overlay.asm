// Overlay.asm
if !{defined __OVERLAY__} {
define __OVERLAY__()

// @ Description
// The framebuffer overlay is implemented in this file.
// @ Note
// 80005550 - line that writes the last sync full instruction

include "OS.asm"
include "RCP.asm"

scope Overlay {
    macro rgba5551(variable width, variable height, variable type) {
        dw width                            // 0x0000 - width of texture
        dw height                           // 0x0004 - height of texture
        dw pc() + 4                         // 0x0008 - pointer to image data
    }


    scope test_: {
        OS.patch_start(0x00006150, 0x80005550)
        j       test_
        nop
        _test_return:
        OS.patch_end()

        addiu   sp, sp,-0x0020              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      a0, 0x0008(sp)              // ~
        sw      a1, 0x000C(sp)              // ~
        sw      a2, 0x0010(sp)              // ~
        sw      a3, 0x0014(sp)              // ~
        sw      ra, 0x0018(sp)              // ~
        sw      t1, 0x001C(sp)              // save registers

        // init
        li      t0, RCP.display_list_info_p // t0 = display list info pointer 
        li      t1, display_list_info       // t1 = address of display list info
        sw      t1, 0x0000(t0)              // update display list info pointer

        // reset
        li      t0, display_list            // t0 = address of display_list
        li      t1, display_list_info       // t1 = address of display_list_info 
        sw      t0, 0x0000(t1)              // ~
        sw      t0, 0x0004(t1)              // update display list address each frame

        // highjack
        li      t0, 0xDE010000              // ~
        sw      t0, 0x0000(v0)              // ~
        li      t0, display_list            // ~ 
        sw      t0, 0x0004(v0)              // highjack ssb display list

        // draw rectangle
        li      a0, (Color.low.RED << 16) | (Color.low.RED)
        jal     RCP.set_fill_color_         // set fill color to red
        nop
        li      a0, 10
        li      a1, 10
        li      a2, 40
        li      a3, 40
        jal     draw_rectangle_             // draw rectangle
        nop

        // finish
        jal     end_                        // end display list
        nop

        lw      t0, 0x0004(sp)              // ~
        lw      a0, 0x0008(sp)              // ~
        lw      a1, 0x000C(sp)              // ~
        lw      a2, 0x0010(sp)              // ~
        lw      a3, 0x0014(sp)              // ~
        lw      ra, 0x0018(sp)              // ~
        lw      t1, 0x001C(sp)              // restore registers
        addiu   sp, sp, 0x0020              // deallocate stack space
//      sw      t3, 0x0000(v0)              // original line 1
        lw      v0, 0x0000(s0)              // original line 2
        j       _test_return                // return
        nop
    }

    // @ Description
    // Adds f3dex2 to draw a solid rectangle on the screen (of current fill color).
    // @ Arguments
    // a0 - ulx
    // a1 - uly
    // a2 - width 
    // a3 - height
    scope draw_rectangle_: {
        addiu   sp, sp, -0x0008             // allocate stack space
        sw      ra, 0x0004(sp)              // save ra
        jal     RCP.set_other_modes_fill_   // cycle type = fill
        nop
        jal     RCP.fill_rectangle_wh_      // draw rectangle
        nop
        jal     RCP.pipe_sync_              // sync
        nop
        lw      ra, 0x0004(sp)              // restore ra
        addiu   sp, sp, 0x0008              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Adds f3dex2 to end display list.
    scope end_: {
        addiu   sp, sp, -0x0008             // allocate stack space
        sw      ra, 0x0004(sp)              // save ra
        jal     RCP.full_sync_              // sync
        nop
        jal     RCP.end_list_               // end list
        nop
        lw      ra, 0x0004(sp)              // restore ra
        addiu   sp, sp, 0x0008              // deallocate stack space
        jr      ra                          // return
        nop
    }


    // @ Description
    // Custom display list goes here.
    OS.align(16)
    display_list:
    fill 0x10000

    display_list_info:
    RCP.display_list_info(display_list, 0x10000)


}

}