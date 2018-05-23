// Results.asm
if !{defined __RESULTS__} {
define __RESULTS__()

include "Menu.asm"
include "OS.asm"

scope Results {

    // @ Description
    // This function changes the screen_id loaded into t6 if skip results screen is enabled
    scope skip_: {
        OS.patch_start(0x0010B204, 0x8018E314)
        j       skip_
        nop
        _skip_return:
        OS.patch_end()
        lli     t6, 0x0018                  // original line 1
        sb      t6, 0x0000(v0)              // original line 2
        Menu.toggle_guard(Menu.entry_skip_results_screen, _skip_return)

        lli     t6, 0x0010                  // original line 1(modified)
        sb      t6, 0x0000(v0)              // original line 2
        j       _skip_return                // return
        nop

    }


}

}