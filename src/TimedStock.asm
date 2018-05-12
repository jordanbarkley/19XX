// TimedStock.asm
// original by Danny_SsB and Mada0

// SSB uses a bitwise behavior for time and stock so (mode 1 = time, mode 2 = stock, 1 & 2 = both).
// Timed stock matches were likely planned but cut during development. This file replaces stock
// matches with timed stock matches.

scope TimedStock {

    // @ Description
    // Enable TimedStock scoring for FFA (mode = 2 to mode = 3)
    OS.patch_start(0x001241A0, 0x801337F0)
    ori     t8, r0, 0x0003                  // t8 = (stock & time)
    OS.patch_end()

    // @ Description
    // Enable TimedStock scoring for Teams (mode = 2 to mode = 3)
    OS.patch_start(0x001241B4, 0x80133804)
    ori     t9, r0, 0x0003                  // t9 = (stock & time)
    OS.patch_end()

    // @ Description
    // This block originally used a bitwise and for time (mode & 1) but now checks against time to 
    // determine whether or not to display stock_number of stock icons.
    OS.patch_start(0x001389F8, 0x8013A778)
    lli     t6, 0x0001
    bnel    t6, t5, 0x8013A790
    OS.patch_end()

    // @ Description
    // Correct scoring. The check usually checks against 0x02 (stock) but the mode will always be
    // 1 or 3. The simple fix is to change 2 to 3
    OS.patch_start(0x00156560, 0x801373C0)
    addiu   at, r0, 0x0003
    OS.patch_end()

}