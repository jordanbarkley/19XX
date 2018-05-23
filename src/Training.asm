// Training.asm
if !{defined __TRAINING__} {
define __TRAINING__()

// @ Descirption
// This file include enhancements for training purposes.

include "Global.asm"
include "OS.asm"

scope Training {

    // @ Descirption
    // This function flashes when a z-cancel is successful [bit]
    scope flash_on_z_cancel_: {
        constant Z_CACNEL_WINDOW(10)

        OS.patch_start(0x000CB528, 0x80150AE8)
        jal     flash_on_z_cancel_
        nop
        OS.patch_end()

//      jal     0x80142D9C                  // original line 1
//      nop                                 // original line 2
        Menu.toggle_guard(Menu.entry_flash_on_z_cancel, 0x80142D9C)

        addiu   sp, sp, -0x0018             // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~        
        sw      v1, 0x000C(sp)              // ~
        sw      ra, 0x0014(sp)              // save registers

        jal     0x80142D9C                  // original line 1
        nop                                 // original line 2
        lw      v1, 0x000C(sp)              // restore v1
        lw      t0, 0x0160(v1)              // t0 = frame pressed
        slti    t1, t0, Z_CACNEL_WINDOW + 1 // ~
        beqz    t1, _end                    // if within frame window, don't flash
        nop
  
        lw      a0, 0x0004(v1)              // a0 - address of player struct
        lli     a1, 0x0008                  // a1 - flash_id (red from mario's fireball)
        lli     a2, 0x0000                  // a2 - 0
        jal     Global.flash_               // add flash
        nop

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      ra, 0x0014(sp)              // restore registers
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop


    }



}

}