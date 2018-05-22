// Menu.asm
if !{defined __MENU__} {
define __MENU__()

include "Global.asm"
include "Joypad.asm"
include "OS.asm"
include "Overlay.asm"

scope Menu {

    test_string:
    db "Cyjorg, you have outdone yourself."
    db 0x00
    OS.align(4)

    texture_battlefield:
    Overlay.texture(48, 36)
    insert "../textures/battlefield.rgba5551"

    texture_background:
    Overlay.texture(320, 240)
    insert "../textures/background.rgba5551"

    macro entry(title, enabled_address, next) {
        dw enabled_address
        dw next
        db {title}
        OS.align(4)
    }

    macro toggle_guard(enabled_address) {
        addiu   sp, sp,-0x0008              // allocate stack space
        sw      at, 0x0004(sp)              // save at
        li      at, {enabled_address}       // ~
        lw      at, 0x0000(at)              // at = is_enabled
        bnez    at, pc() + 24               // if (is_enabled), _continue
        nop

        // _end:
        lw      at, 0x0004(sp)              // restore at
        addiu   sp, sp, 0x0008              // deallocate stack space
        jr      ra
        nop

        // _continue:
        lw      at, 0x0004(sp)              // restore at
        addiu   sp, sp, 0x0008              // deallocate stack space
    }

    // @ Description 
    // This patch disables the menu init on the debug screen 80371414
    OS.patch_start(0x001AC1E8, 0x80369D78)    
    jr      ra
    nop
    OS.patch_end()

    // @ Description
    // This patch changes  the VS. Options screen from loading to the "Exit\n<Stage>" Debug Screen 
    OS.patch_start(0x0012471C, 0x80133D6C)
    lli     t4, 0x0002                      // original - lli t4, 0x000A
    OS.patch_end()

    // @ Description
    // This function will chnage the currently loaded SSB screen
    // @ Arguments
    // a0 - int next_screen
    scope change_screen_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // save registers

        li      t0, Global.current_screen   // ~
        lb      t1, 0x0000(t0)              // t1 = current_screen
        sb      t1, 0x0001(t0)              // update previous_screen to current_screen
        sb      a0, 0x0000(t0)              // update current_screen to next_screen
        li      t0, Global.screen_interrupt // ~
        lli     t1, 0x0001                  // ~
        sw      t1, 0x0000(t0)              // generate screen_interrupt

        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // allocate stack space
        jr      ra                          // return
        nop
    }

    scope run_: {
        addiu   sp, sp,-0x0008              // allocate stack space
        sw      ra, 0x0004(sp)              // save ra

        jal     test_
        nop

        lli     a0, Joypad.A                // a0 - button_mask
        lli     a1, 0x0000                  // a1 - player
        jal     Joypad.is_held_             // check if A held
        nop 
        beqz    v0, _end                    // nop
        nop
        lli     a0, Color.low.GREEN         // a0 = rgba5551 green
        jal     Overlay.set_color_
        nop
        lli     a0, 100                     // a0 - ulx
        lli     a1, 100                     // a1 - uly
        lli     a2, 20                      // a2 - width 
        lli     a3, 20                      // a3 - hgith
        jal     Overlay.draw_rectangle_
        nop

        _end:
        lw      ra, 0x0004(sp)              // restore ra
        addiu   sp, sp, 0x0008              // deallocate stack space
        jr      ra
        nop
    }

    scope test_: {
        addiu   sp, sp,-0x0008              // allocate stack space
        sw      ra, 0x0004(sp)              // save ra
        
        // draw big texture
        li      a0, 0                       // a0 - ulx
        li      a1, 0                       // a1 - uly
        li      a2, texture_background      // a2 - address of texture struct 
        jal     Overlay.draw_texture_big_   // draw bg texture
        nop

        // draw rectangle
        li      a0, (Color.low.RED << 16) | (Color.low.RED)
        jal     RCP.set_fill_color_         // set fill color to red
        nop
        li      a0, 100                     // a0 - ulx
        li      a1, 50                      // a1 - uly
        li      a2, 10                      // a2 - width
        li      a3, 10                      // a3 - height
        jal     Overlay.draw_rectangle_     // draw rectangle
        nop

        // draw texture
        li      a0, 10                     // a0 - ulx
        li      a1, 60                      // a1 - uly
        li      a2, texture_battlefield     // a2 - address of texture struct 
        jal     Overlay.draw_texture_
        nop

        // draw char
        li      a0, 10                      // a0 - ulx
        li      a1, 100                     // a1 - uly
        li      a2, 'J'                     // a2 - char
        jal     Overlay.draw_char_          // draw char
        nop

        // draw string
        li      a0, 10                      // a0 - ulx
        li      a1, 140                     // a1 - uly
        li      a2, test_string             // a2 - address of string
        jal     Overlay.draw_string_        // draw string
        nop

        lw      ra, 0x0004(sp)              // restore ra
        addiu   sp, sp, 0x0008              // deallocate stack space
        jr      ra
        nop
    }

    scope draw_entry_: {

    }

    scope draw_menu_: {

    }
}

}