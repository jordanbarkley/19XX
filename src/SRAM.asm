// SRAM.asm (read/write fround by bit)
if !{defined __SRAM__} {
define __SRAM__()

// @ Description
// SRAM = Static RAM. This file controls saving/loading.

scope SRAM {
    // @ Description
    // Variable to hold current SRAM address. SSB only used 0x05EC bytes out of 0x8000 available.
    // address starts at 0x1000 for simplicity.
    variable address(0x1000)

    // @ Description
    // Struct that holds information for a block of save data. 
    macro block(ram_address, size) {
        dw SRAM.address
        dw {ram_address}
        dw {size}
        SRAM.address = SRAM.address + {size}
    }

    // @ Description
    // Read from SRAM (load)
    // @ Arguments
    // a0 - SRAM source
    // a1 - RAM destination
    // a2 - size
    constant read_(0x80002DA4)

    // @ Description
    // Write to SRAM (save)
    // @ Arguments
    // a0 - RAM source
    // a1 - SRAM destination
    // a2 - size
    constant write_(0x80002DE0)
}

}
