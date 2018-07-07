// Character.asm
if !{defined __CHARACTER__} {
define __CHARACTER__()

// @ Description
// This file contains character related information, constants, and functions

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
            constatn JIGGLYPUFF(0x0A)
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
    constant add_percent_(0x800EA248)

}

}