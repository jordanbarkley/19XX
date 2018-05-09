// TimedStock.asm
// original by Danny_SsB and Mada0

scope TimedStock {

    OS.patch_start(0x001241A0, 0x00000000)
    ori     t8, r0, 0x0003                  // t8 = (stock & time)
    OS.patch_end()

    OS.patch_start(0x001389FC, 0x00000000)
    dh 0x55A8
    OS.patch_end()

    // This has produced "correct" behavior but is inconistent with the winner. Bug fix needed.
    OS.patch_start(0x000B6848, 0x8013BE04)
    ori     t7, r0, 0x0000                  // KOs = 0, winner = least deaths
    OS.patch_end()

    OS.patch_start(0x001241B4, 0x00000000)
    ori     t9, r0, 0x0003                  // t9 = mode = (stock & time) teams
    OS.patch_end()

}