// Character.asm
if !{defined __CHARACTER__} {
define __CHARACTER__()
print "included Character.asm\n"

// @ Description
// This file contains character related information, constants, and functions

include "Global.asm"
include "OS.asm"

scope Character {
    // @ Description
    // character id constants
    // constant names are loosely based on the debug names for characters
    scope id {
        constant MARIO(0x00)
        constant FOX(0x01)
        constant DONKEY(0x02)
        constant DK(0x02)
        constant DONKEY_KONG(0x02)
        constant SAMUS(0x03)
        constant LUIGI(0x04)
        constant LINK(0x05)
        constant YOSHI(0x06)
        constant CAPTAIN(0x07)
        constant CAPTAIN_FALCON(0x07)
        constant FALCON(0x07)
        constant KIRBY(0x08)
        constant PIKACHU(0x09)
        constant JIGGLY(0x0A)
        constant JIGGLYPUFF(0x0A)
        constant NESS(0x0B)
        constant BOSS(0x0C)
        constant METAL(0x0D)
        constant NMARIO(0x0E)
        constant NFOX(0x0F)
        constant NDONKEY(0x10)
        constant NSAMUS(0x11)
        constant NLUIGI(0x12)
        constant NLINK(0x13)
        constant NYOSHI(0x14)
        constant NCAPTAIN(0x14)
        constant NKIRBY(0x15)
        constant NPIKACHU(0x17)
        constant NJIGGLY(0x18)
        constant NNESS(0x19)
        constant GDONKEY(0x1A)
        constant NONE(0x1C)
    }
    
    // @ Description
    // Adds a 32-bit signed int to the player's percentage
    // the game will crash if the player's % goes below 0
    // @ Arguments
    // a0 - address of the player struct
    // a1 - percentage to add to the player
    // @ Note
    // This function is not safe by STYLE.md conventions so it has been wrapped
    scope add_percent_: {
        OS.save_registers()
        jal     0x800EA248
        nop
        OS.restore_registers()
        jr      ra
        nop
    }
    
    // @ Description
    // Returns the address of the player struct for the given player.
    // @ Arguments 
    // a0 - player (p1 = 0, p4 = 3)
    // @ Returns
    // v0 - address of player X struct
    scope get_struct_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // save registers

        li      t0, Global.p_struct_head    // t0 = address of player struct list head
        lw      t0, 0x0000(t0)              // t0 = address of player 1 struct
        lli     t1, Global.P_STRUCT_LENGTH  // t1 = player struct length
        mult    a0, t1                      // ~
        mflo    t1                          // t1 = offset = player struct length * player
        addu    v0, t0, t1                  // v0 = ret = address of player struct

        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

}

} // __CHARACTER__