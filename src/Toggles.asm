// Toggles.asm
if !{defined __TOGGLES__} {
define __TOGGLES__()

include "Menu.asm"
include "OS.asm"

scope Toggles {

    selection:
    dw 0x00000000
    
    // @ Description
    // Allows function 
    macro guard(entry_address, exit_address) {
        addiu   sp, sp,-0x0008              // allocate stack space
        sw      at, 0x0004(sp)              // save at
        li      at, {entry_address}         // ~
        lw      at, 0x0004(at)              // at = is_enabled
        bnez    at, pc() + 24               // if (is_enabled), _continue
        nop

        // _end:
        lw      at, 0x0004(sp)              // restore at
        addiu   sp, sp, 0x0008              // deallocate stack space

        // foor hook vs. function
        if ({exit_address} == 0x00000000) {
            jr      ra
        } else {
            j       {exit_address}
        }
        nop

        // _continue:
        lw      at, 0x0004(sp)              // restore at
        addiu   sp, sp, 0x0008              // deallocate stack space
    }

    // @ Description
    if {defined __CE__} {
    // This patch disables functionality on the OPTION screen.
    OS.patch_start(0x001205FC, 0x80132E4C)
    jr      ra
    nop
    OS.patch_end()

    // @ Description
    // This patch disables back (press B) on Main Menu
    OS.patch_start(0x0011D768, 0x801327D8)
    nop
    nop
    nop
    nop
    OS.patch_end()
    }

    scope run_: {
        addiu   sp, sp,-0x0008              // allocate stack space
        sw      ra, 0x0004(sp)              // save ra

        lli     a0, Color.low.BLACK         // a0 - color
        jal     Overlay.set_color_          // set fill color to black
        nop

        lli     a0, 000000                  // a0 - ulx
        lli     a1, 000000                  // a1 - uly
        lli     a2, 000320                  // a2 - width
        lli     a3, 000240                  // a3 - height
        jal     Overlay.draw_rectangle_     // draw black rectangle for background
        nop

        // update menu
        li      a0, head                    // a0 - head
        li      a1, selection               // a1 - address of selection
        jal     Menu.update_                // check for updates
        nop

        // draw menu
        li      a0, head                    // a0 - menu head
        lli     a1, 000028                  // a1 - ulx
        lli     a2, 000020                  // a2 - uly
        li      a3, selection               // a3 - selection
        jal     Menu.draw_                  // draw menu
        nop

        // check for exit
        lli     a0, Joypad.B                // a0 - button_mask
        lli     a1, 0x0000                  // a1 - player
        jal     Joypad.was_pressed_         // check if B pressed
        nop 
        beqz    v0, _end                    // nop
        nop
        lli     a0, 0x0007                  // a0 - screen_id (main menu)
        jal     Menu.change_screen_
        nop

        _end:
        lw      ra, 0x0004(sp)              // restore ra
        addiu   sp, sp, 0x0008              // deallocate stack space
        jr      ra
        nop
    }

    head:
    entry_practice_overlay:
    Menu.entry_bool("COLOR OVERLAYS", OS.FALSE, OS.NULL, entry_disable_cinematic_camera)
    
    entry_disable_cinematic_camera:
    Menu.entry_bool("DISABLE CINEMATIC CAMERA", OS.FALSE, OS.NULL, entry_flash_on_z_cancel)

    entry_flash_on_z_cancel:
    Menu.entry_bool("FLASH ON Z-CANCEL", OS.FALSE, OS.NULL, entry_hold_to_pause)

    entry_hold_to_pause:
    Menu.entry_bool("HOLD TO PAUSE", OS.TRUE, OS.NULL, entry_improved_combo_meter)

    entry_improved_combo_meter:
    Menu.entry_bool("IMPROVED COMBO METER", OS.TRUE, OS.NULL, entry_improved_ai)

    entry_improved_ai:
    Menu.entry_bool("IMPROVED AI", OS.TRUE, OS.NULL, entry_neutral_spawns)

    entry_neutral_spawns:
    Menu.entry_bool("NEUTRAL SPAWNS", OS.TRUE, OS.NULL, entry_random_music)

    entry_random_music:
    Menu.entry_bool("RANDOM MUSIC", OS.FALSE, OS.NULL, entry_skip_results_screen)

    entry_skip_results_screen:
    Menu.entry_bool("SKIP RESULTS SCREEN", OS.FALSE, OS.NULL, entry_stereo_sound)

    entry_stereo_sound:
    Menu.entry_bool("STEREO SOUND", OS.TRUE, OS.NULL, entry_stock_handicap)

    entry_stock_handicap:
    Menu.entry_bool("STOCK HANDICAP", OS.TRUE, OS.NULL, entry_salty_runback)

    entry_salty_runback:
    Menu.entry_bool("SALTY RUNBACK", OS.TRUE, OS.NULL, test)

    test:
    Menu.entry("TEST12345", Menu.type.U8, 2, 0, 4, OS.NULL, OS.NULL, OS.NULL, OS.NULL)
}


}