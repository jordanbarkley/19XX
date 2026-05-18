// Global.asm
if !{defined __GLOBAL__} {
define __GLOBAL__()
print "included Global.asm\n"

// @ Description
// This file enumerates several of SSB's global variables.

scope Global {
    // @ Description
    // Original SSB function. It move nBytes from the given ROM address to the given RAM address
    // @ Arguments
    // a0 - ROM address | 0x00FFFFFF
    // a1 - RAM vAddress
    // a2 - nBytes 
    // @region:SYM
    if {defined REGION_JP} {
    constant dma_copy_(0x80002A80)
    } else {
    constant dma_copy_(0x80002CA0)
    }

    // @ Description
    // Writing 0x00000001 to this word will load the screen at current_screen.
    // @region:SYM
    if {defined REGION_JP} {
    constant screen_interrupt(0x800465C0)
    } else {
    constant screen_interrupt(0x800465D0)
    }
    
    // @ Description
    // Gets a random int from (0, N-1)
    // @ Arguments
    // a0 - N 
    // @region:SYM
    if {defined REGION_JP} {
    constant get_random_int_(0x80018734)
    } else {
    constant get_random_int_(0x80018994)
    }
    
    // @ Description
    // Byte, Current screen value is here (CSS = 0x10, Debug = 0x03/0x04)
    // @region:SYM
    if {defined REGION_JP} {
    constant current_screen(0x800A2A90)
    } else {
    constant current_screen(0x800A4AD0)
    }

    // @ Description
    // Byte, previous screen value is here
    // @region:SYM
    if {defined REGION_JP} {
    constant previous_screen(0x800A2A91)
    } else {
    constant previous_screen(0x800A4AD1)
    }

    // @ Description
    // SCKind screen IDs that 19XX hooks.  The JP SCKind enum omits
    // nSCKindStartup and nSCKindCongra, so every scene ID after
    // nSCKindCharacters shifts down vs US (training -1, option -2).
    if {defined REGION_JP} {
    constant SCREEN_TRAINING(0x35)      // nSCKind1PTrainingMode (US 0x36)
    constant SCREEN_OPTION(0x37)        // nSCKindOption         (US 0x39)
    } else {
    constant SCREEN_TRAINING(0x36)
    constant SCREEN_OPTION(0x39)
    }

    // @ Description
    scope vs {
        // @ Description
        // Byte, contains the versus stage stage id
        // @region:SYM
        if {defined REGION_JP} {
        constant stage(0x800A2CC9) 
        } else {
        constant stage(0x800A4D09) 
        }

        // @ Description
        // Byte, boolean for if teams are enabled, 0 = off, 1 = on
        // @region:SYM
        if {defined REGION_JP} {
        constant teams(0x800A2CCA) 
        } else {
        constant teams(0x800A4D0A) 
        }

        // @ Description
        // Byte, 1 = time, 2 = stock, 3 = both
        // @region:SYM
        if {defined REGION_JP} {
        constant game_mode(0x800A2CCB)
        } else {
        constant game_mode(0x800A4D0B)
        }

        // @ Description
        // Byte, 2 = 2 min, 100 = infinite
        // @region:SYM
        if {defined REGION_JP} {
        constant time(0x800A2CCE)
        } else {
        constant time(0x800A4D0E)
        }

        // @ Description
        // Byte, 0 = 1 stock
        // @region:SYM
        if {defined REGION_JP} {
        constant stocks(0x800A2CCF)
        } else {
        constant stocks(0x800A4D0F)
        }

        // @ Description
        // Byte, 0 = off, 1 = on, 2 = auto
        // @region:SYM
        if {defined REGION_JP} {
        constant handicap(0x800A2CD0)
        } else {
        constant handicap(0x800A4D10)
        }

        // @ Description
        // Byte, 0 = off, 1 = on
        // @region:SYM
        if {defined REGION_JP} {
        constant team_attack(0x800A2CD1)
        } else {
        constant team_attack(0x800A4D11)
        }

        // @ Description
        // Byte, 0 = off, 1 = on
        // @region:SYM
        if {defined REGION_JP} {
        constant stage_select(0x800A2CD2)
        } else {
        constant stage_select(0x800A4D12)
        }

        // @ Description
        // Byte, 50 = 50%, 200 = 200%
        // @region:SYM
        if {defined REGION_JP} {
        constant damage(0x800A2CD3)
        } else {
        constant damage(0x800A4D13)
        }

        // @ Description
        // Word, timer in second
        // @region:SYM
        if {defined REGION_JP} {
        constant timer(0x800A2CDC)
        } else {
        constant timer(0x800A4D1C)
        }

        // @ Description
        // Byte, 0 = none, 5 = high
        // @region:SYM
        if {defined REGION_JP} {
        constant item_frequency(0x800A2CE4)
        } else {
        constant item_frequency(0x800A4D24)
        }

        // @ Description
        // Pointer to player structs on versus screen
        constant P_OFFSET(0x20)
        constant P_DIFF(0x74)
        // @region:SYM
        if {defined REGION_JP} {
        constant p1(0x800A2CE8)
        constant p2(0x800A2D5C)
        constant p3(0x800A2DD0)
        constant p4(0x800A2E44)
        } else {
        constant p1(0x800A4D28)
        constant p2(0x800A4D9C)
        constant p3(0x800A4E10)
        constant p4(0x800A4E84)
        }
    }

    // @ Description
    // Pointer to match setting. For versus, (0x0000(this) == 0x800A4D08) which is the address of
    // the above vs scope.
    // @region:SYM
    if {defined REGION_JP} {
    constant match_info(0x800A30A8)
    } else {
    constant match_info(0x800A50E8)
    }


    // @ Description
    // list of files loaded in the game
    // @ Fomrat
    // 0x0000 - file
    // 0x0004 - address
    // @region:SYM
    if {defined REGION_JP} {
    constant files_loaded(0x800D41A0)
    } else {
    constant files_loaded(0x800D6300)
    }

    // @ Description
    // Puts a flashing overlay on a player (found by [bit])
    // @ Arguments
    // a0 - address of player struct
    // a1 - flash_id
    // a2 - 0 (?)
    // @region:SYM
    if {defined REGION_JP} {
    constant flash_(0x800E7624)
    } else {
    constant flash_(0x800E9814)
    }

    // @ Description
    // player struct list head
    // @region:SYM
    if {defined REGION_JP} {
    constant p_struct_head(0x8012E914)
    } else {
    constant p_struct_head(0x80130D84)
    }
    constant P_STRUCT_LENGTH(0x0B50)
}

} // __GLOBAL__
