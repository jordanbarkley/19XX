// Overlay.asm
if !{defined __OVERLAY__} {
define __OVERLAY__()

// @ Description
// The framebuffer overlay is implemented in this file.
// @ Note
// This file only support rgba5551

include "OS.asm"
include "RCP.asm"

scope Overlay {

    macro texture(variable width, variable height) {
        dw width                            // 0x0000 - width of texture
        dw height                           // 0x0004 - height of texture
        dw pc() + 4                         // 0x0008 - pointer to image data
    }

    texture_battlefield:
    texture(48, 36)
    insert "../textures/battlefield.rgba5551"

    texture_background:
    texture(320, 240)
    insert "../textures/background.rgba5551"


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
        li      a0, 00
        li      a1, 00
        li      a2, 320
        li      a3, 240
        jal     draw_rectangle_             // draw rectangle
        nop

        // draw texture
        li      a0, 10                      // a0 - ulx
        li      a1, 60                      // a1 - uly
        li      a2, texture_battlefield     // a2 - address of texture struct 
        jal     draw_texture_
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
    // Adds f3dex2 to draw a solid rectangle to the framebuffer (of current fill color).
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
    // Adds f3dex2 to draw a textured rectangle to the framebuffer.
    // @ Arguments
    // a0 - ulx
    // a1 - uly
    // a2 - address of texture struct 
    // @ Note
    // This can only handle textures <= 4096 bytes in size
    // draw_texture_big_ handles the larger textures
    scope draw_texture_: {
        // order from SSB
        // 1. set other modes copy
        // 2. set texture image
        // 3. set tile
        // 4. load sync
        // 5. load block 
        // 6. pipe sync
        // 7. set tile
        // 8. set tile size
        // 9. texture rectangle
        // 0. pipe sync

        addiu   sp, sp,-0x0028              // allocate stack space
        sw      s0, 0x0004(sp)              // ~
        sw      s1, 0x0008(sp)              // ~
        sw      s2, 0x000C(sp)              // ~
        sw      ra, 0x0010(sp)              // ~
        sw      a0, 0x0014(sp)              // ~
        sw      a1, 0x0018(sp)              // ~ 
        sw      a2, 0x001C(sp)              // ~ 
        sw      a3, 0x0020(sp)              // save registers

        or      s0, a0, r0                  // s0 = copy of a0
        or      s1, a1, r0                  // s1 = copy of a1
        or      s2, a2, r0                  // s2 = copy of a2

        jal     RCP.set_other_modes_copy_   // append dlist
        nop

        lw      a0, 0x0008(s2)              // a0 - RAM address [a]
        li      a1, RCP.G_IM_FMT_RGBA       // a1 - color format [f]
        li      a2, RCP.G_IM_SIZ_16b        // a2 - color size [s]
        jal     RCP.set_texture_image_      // append dlist
        nop

        lw      a0, 0x0000(s2)              // a0 = width 
        li      a1, RCP.G_IM_FMT_RGBA       // a1 - color format [f]
        li      a2, RCP.G_IM_SIZ_16b        // a2 - color size [s]
        jal     RCP.set_tile_               // append dlist
        nop

        jal     RCP.load_sync_              // append dlist
        nop

        lw      a0, 0x0000(s2)              // a0 - width
        lw      a1, 0x0004(s2)              // a1 - height
        jal     RCP.load_block_             // append dlist
        nop

        jal     RCP.pipe_sync_              // append dlist
        nop

        lw      a0, 0x0000(s2)              // a0 = width 
        li      a1, RCP.G_IM_FMT_RGBA       // a1 - color format [f]
        li      a2, RCP.G_IM_SIZ_16b        // a2 - color size [s]
        jal     RCP.set_tile_               // append dlist
        nop

        lw      a0, 0x0000(s2)              // a0 - width
        lw      a1, 0x0004(s2)              // a1 - height
        jal     RCP.set_tile_size_          // append dlist
        nop

        or      a0, s0, r0                  // a0 - ulx
        or      a1, s1, r0                  // a1 - uly
        lw      a2, 0x0000(s2)              // a2 - width
        lw      a3, 0x0004(s2)              // a3 - height
        jal     RCP.texture_rectangle_wh_    // append dlist
        nop

        jal     RCP.pipe_sync_              // sync
        nop

        lw      s0, 0x0004(sp)              // ~
        lw      s1, 0x0008(sp)              // ~
        lw      s2, 0x000C(sp)              // ~
        lw      ra, 0x0010(sp)              // ~
        lw      a0, 0x0014(sp)              // ~
        lw      a1, 0x0018(sp)              // ~ 
        lw      a2, 0x001C(sp)              // ~ 
        lw      a3, 0x0020(sp)              // restore registers
        addiu   sp, sp, 0x0028              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Adds f3dex2 to end a display list.
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