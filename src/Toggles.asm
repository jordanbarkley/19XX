// Toggles.asm
if !{defined __TOGGLES__} {
define __TOGGLES__()

include "Color.asm"
include "Menu.asm"
include "OS.asm"

scope Toggles {

    
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

    if {defined __CE__} {
        // @ Description
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
        li      a0, info
        jal     Menu.update_                // check for updates
        nop

        // draw menu
        li      a0, info                    // a0 - info
        jal     Menu.draw_                  // draw menu
        nop

        // check for exit
        lli     a0, Joypad.B                // a0 - button_mask
        lli     a1, 000069                  // a1 - whatever you like!
        lli     a2, Joypad.PRESSED          // a2 - type
        jal     Joypad.check_buttons_all_   // check if B pressed
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

    macro set_info_head(address_of_head) {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // save t0
        sw      t1, 0x0008(sp)              // save t1

        li      t0, info                    // t0 = info
        li      t1, {address_of_head}       // t1 = address of head
        sw      t1, 0x0000(t0)              // update info.head

        lw      t0, 0x0004(sp)              // restore t0
        lw      t1, 0x0008(sp)              // restore t1
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    } 

    // @ Description
    // Functions to change the menu currently displayed.
    set_info_1:; set_info_head(head_super_menu)
    set_info_2:; set_info_head(head_19xx_settings)
    set_info_3:; set_info_head(head_random_music_settings)
    set_info_4:; set_info_head(head_random_stage_settings)

    info:
    Menu.info(head_super_menu, 20, 30, Color.low.BLACK, 32)

    // @ Description
    // Contains list of submenus.
    head_super_menu:
    Menu.entry_title("19XX SETTINGS", OS.NULL, pc() + 20)
    Menu.entry_title("RANDOM MUSIC SETTINGS", OS.NULL, pc() + 28)
    Menu.entry_title("RANDOM STAGE SETTINGS", OS.NULL, OS.NULL)

    // @ Description 
    // Miscellaneous Toggles
    head_19xx_settings:
    entry_practice_overlay:;            Menu.entry_bool("COLOR OVERLAYS", OS.FALSE, entry_disable_cinematic_camera)
    entry_disable_cinematic_camera:;    Menu.entry_bool("DISABLE CINEMATIC CAMERA", OS.FALSE, entry_flash_on_z_cancel)
    entry_flash_on_z_cancel:;           Menu.entry_bool("FLASH ON Z-CANCEL", OS.FALSE, entry_hold_to_pause)
    entry_hold_to_pause:;               Menu.entry_bool("HOLD TO PAUSE", OS.TRUE, entry_improved_combo_meter)
    entry_improved_combo_meter:;        Menu.entry_bool("IMPROVED COMBO METER", OS.TRUE, entry_improved_ai)
    entry_improved_ai:;                 Menu.entry_bool("IMPROVED AI", OS.TRUE, entry_neutral_spawns)
    entry_neutral_spawns:;              Menu.entry_bool("NEUTRAL SPAWNS", OS.TRUE, entry_skip_results_screen)
    entry_skip_results_screen:;         Menu.entry_bool("SKIP RESULTS SCREEN", OS.FALSE, entry_stereo_sound)
    entry_stereo_sound:;                Menu.entry_bool("STEREO SOUND", OS.TRUE, entry_stock_handicap)
    entry_stock_handicap:;              Menu.entry_bool("STOCK HANDICAP", OS.TRUE, entry_salty_runback)
    entry_salty_runback:;               Menu.entry_bool("SALTY RUNBACK", OS.TRUE, OS.NULL)

    // @ Description
    // Random Music Toggles
    head_random_music_settings:
    entry_random_music:
    Menu.entry_bool("RANDOM MUSIC", OS.FALSE, pc() + 20)
    Menu.entry_bool("BATTLEFIELD", OS.TRUE, pc() + 16)
    Menu.entry_bool("CONGO JUNGLE", OS.TRUE, pc() + 20)
    Menu.entry_bool("DATA", OS.TRUE, pc() + 12)
    Menu.entry_bool("DREAM LAND", OS.TRUE, pc() + 16)
    Menu.entry_bool("FINAL DESTINATION", OS.TRUE, pc() + 24)
    Menu.entry_bool("HOW TO PLAY", OS.TRUE, pc() + 16)
    Menu.entry_bool("HYRULE CASTLE", OS.TRUE, pc() + 20)
    Menu.entry_bool("META CRYSTAL", OS.TRUE, pc() + 20)
    Menu.entry_bool("MUSHROOM KINGDOM", OS.TRUE, pc() + 24)
    Menu.entry_bool("PEACH'S CASTLE", OS.TRUE, pc() + 20)
    Menu.entry_bool("PLANET ZEBES", OS.TRUE, pc() + 20)
    Menu.entry_bool("SAFFRON CITY", OS.TRUE, pc() + 20)
    Menu.entry_bool("SECTOR Z", OS.TRUE, pc() + 16)
    Menu.entry_bool("YOSHI'S ISLAND", OS.TRUE, OS.NULL)


    // @ Description
    // Random Stage Toggles
    head_random_stage_settings:
    if {defined __TE__} {
        Menu.entry_bool("BATTLEFIELD", OS.TRUE, pc() + 16)
        Menu.entry_bool("CONGO JUNGLE", OS.TRUE, pc() + 20)
        Menu.entry_bool("DREAM LAND", OS.TRUE, pc() + 16)
        Menu.entry_bool("FINAL DESTINATION", OS.TRUE, pc() + 24)
        Menu.entry_bool("HYRULE CASTLE", OS.TRUE, pc() + 20)
        Menu.entry_bool("MUSHROOM KINGDOM", OS.TRUE, pc() + 24)
        Menu.entry_bool("PEACH'S CASTLE", OS.TRUE, pc() + 20)
        Menu.entry_bool("PLANET ZEBES", OS.TRUE, pc() + 20)
        Menu.entry_bool("SAFFRON CITY", OS.TRUE, pc() + 20)
        Menu.entry_bool("SECTOR Z", OS.TRUE, pc() + 16)
        Menu.entry_bool("YOSHI'S ISLAND", OS.TRUE, OS.NULL)
    }

    if {defined __CE__} {
        Menu.entry_bool("BATTLEFIELD", OS.TRUE, pc() + 16)
        Menu.entry_bool("CONGO JUNGLE", OS.TRUE, pc() + 20)
        Menu.entry_bool("DREAM LAND", OS.TRUE, pc() + 16)
        Menu.entry_bool("DREAM LAND BETA 1", OS.TRUE, pc() + 24)
        Menu.entry_bool("DREAM LAND BETA 2", OS.TRUE, pc() + 24)
        Menu.entry_bool("FINAL DESTINATION", OS.TRUE, pc() + 24)
        Menu.entry_bool("HOW TO PLAY", OS.TRUE, pc() + 16)
        Menu.entry_bool("HYRULE CASTLE", OS.TRUE, pc() + 20)
        Menu.entry_bool("META CRYSTAL", OS.TRUE, pc() + 20)
        Menu.entry_bool("MUSHROOM KINGDOM", OS.TRUE, pc() + 24)
        Menu.entry_bool("PEACH'S CASTLE", OS.TRUE, pc() + 20)
        Menu.entry_bool("PLANET ZEBES", OS.TRUE, pc() + 20)
        Menu.entry_bool("SAFFRON CITY", OS.TRUE, pc() + 20)
        Menu.entry_bool("SECTOR Z", OS.TRUE, pc() + 16)
        Menu.entry_bool("YOSHI'S ISLAND", OS.TRUE, pc() + 20)
        Menu.entry_bool("YOSHI'S ISLAND CLOUDLESS", OS.TRUE, OS.NULL)
    }
}


}