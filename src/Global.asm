// Global.asm

scope Global {
    // @ Description
    // Original SSB function. It move nBytes from the given ROM address to the given RAM address
    // @ Arguments
    // a0 - ROM address | 0x00FFFFFF
    // a1 - RAM vAddress
    // a2 - nBytes 
    constant dma_copy_(0x80002CA0)

    scope vs {
        // @ Description
        // Byte, contains the versus stage stage id
        constant stage(0x800A4D09) 

        // @ Description
        // Byte, boolean for if teams are enabled, 0 = off, 1 = on
        constant teams(0x800A4D0A) 

        // @ Description
        // Byte, 1 = time, 2 = stock, 3 = both
        constant game_mode(0x800A4D0B)

        // @ Description
        // Byte, 2 = 2 min, 100 = infinite
        constant time(0x800A4D0E)

        // @ Description
        // Byte, 0 = 1 stock
        constant stocks(0x800A4D0F)

        // @ Description
        // Byte, 0 = off, 1 = on, 2 = auto
        constant handicap(0x800A4D10)

        // @ Description
        // Byte, 0 = off, 1 = on
        constant team_attack(0x800A4D11)

        // @ Description
        // Byte, 0 = off, 1 = on
        constant stage_select(0x800A4D12)

        // @ Description
        // Byte, 50 = 50%, 200 = 200%
        constant damage(0x800A4D13)

        // @ Description
        // Byte, 0 = none, 5 = high 						
        constant item_frequency(0x800A4D24)

        // @ Description
        // Pointer to player structs on versus screen
        constant p1(0x800A4D28)
        constant p2(0x800A4D9C)
        constant p3(0x800A4E10)
        constant p4(0x800A4E84)
    }


    // @ Description
    // list of files loaded in the game
    constant files_loaded(0x800D6300)

    // @ Description
    // player struct list head
    constant p_struct_head(0x80130D84)
}
