// TimedStock.asm (original by Danny_SsB and Mada0)
if !{defined __TIMED_STOCK__} {
define __TIMED_STOCK__()
print "included TimedStock.asm\n"

// @ Description
// SSB uses a bitwise behavior for time and stock so (mode 1 = time, mode 2 = stock, 1 & 2 = both).
// Timed stock matches were likely planned but cut during development. This file replaces stock
// matches with timed stock matches.

include "OS.asm"
include "Global.asm"

scope TimedStock {
    // @region:SYM
    if {defined REGION_JP} {
    constant calculate_time_score_(0x80134F94)
    constant calculate_stock_score_(0x80134F6C)
    } else {
    constant calculate_time_score_(0x801373F4)
    constant calculate_stock_score_(0x801373CC)
    }

    // @ Description
    // Enable TimedStock scoring for FFA (mode = 2 to mode = 3)
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00124AA8, 0x801317E8)
    } else {
    OS.patch_start(0x001241A0, 0x801337F0)
    }
    ori     t8, r0, 0x0003                  // t8 = (stock & time)
    OS.patch_end()

    // @ Description
    // Enable TimedStock scoring for Teams (mode = 2 to mode = 3)
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00124ABC, 0x801317FC)
    } else {
    OS.patch_start(0x001241B4, 0x80133804)
    }
    ori     t9, r0, 0x0003                  // t9 = (stock & time)
    OS.patch_end()

    // @ Description
    // This block originally used a bitwise and for time (mode & 1) but now checks against time to 
    // determine whether or not to display stock_number of stock icons.
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00139888, 0x80138378)
    } else {
    OS.patch_start(0x001389F8, 0x8013A778)
    }
    lli     t6, 0x0001
    // @region:SYM
    if {defined REGION_JP} {
    bnel    t6, t5, 0x80138390
    } else {
    bnel    t6, t5, 0x8013A790
    }
    OS.patch_end()

    // @ Description
    // Correct scoring. The check usually checks against 0x02 (stock) but the mode will always be
    // 1 or 3. The simple fix is to change 2 to 3
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00157730, 0x80134F60)
    } else {
    OS.patch_start(0x00156560, 0x801373C0)
    }
    addiu   at, r0, 0x0003
    OS.patch_end()

    // @ Description
    // Correct scoring for matches with timer [bit]
    // This hook is used any time there the timer reachs 0. Score is adjusted
    // to (KOs - deaths) for Time and (stock setting - deaths) for Stock
    // @ Arguments
    // a0 = player
    // @ Returns
    // v0 - score
    // @ Free Registers
    // t6, t7
    scope score_fix_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x00156F78, 0x801347A8)
        } else {
        OS.patch_start(0x155DA8, 0x80136C08)
        }
        j   score_fix_
        nop
        OS.patch_end()

        li      t6, Global.vs.game_mode     // t6 = address of vs game_mode
        lbu     t6, 0x0000(t6)              // t6 = vs game_mode ( 1 = time, 2 = stock, 3 = both)
        lli     t7, 0x0001                  // t7 = stock
        beq     t6, t7, _time               // branch if timer is enabled
        nop

        _stock:
        sll     v1, a0, 0x0002              // (original) v1 = offset = player * 4 
        if {defined REGION_JP} {
        lui     t6, 0x8013                  // (original) t6 = address of ? (JP)
        } else {
        lui     t6, 0x8014                  // (original) t6 = address of ? (US)
        }
        addu    t6, t6, v1                  // (original) t6 = address of ? + offset
        if {defined REGION_JP} {
        lw      t6, 0x7730(t6)              // (original) t6 = deaths (JP)
        } else {
        lw      t6, 0x9B90 (t6)             // (original) t6 = deaths (US)
        }
        li      t7, Global.vs.stocks        // t7 = address of stocks_setting
        lbu     t7, 0x0000(t7)              // t7 = stocks_setting
        subu    v0, t6, t7                  // v0 = score = stocks_setting - deaths
        b       _end
        nop
        
        _time:
        sll     v1, a0, 0x0002              // (original) v1 = offset = player * 4 
        if {defined REGION_JP} {
        lui     t6, 0x8013                  // (original) t6 = address of ? (JP)
        } else {
        lui     t6, 0x8014                  // (original) t6 = address of ? (US)
        }
        addu    t6, t6, v1                  // (original) t6 = address of ? + offset
        if {defined REGION_JP} {
        lw      t7, 0x7730(t6)              // (original) t7 = deaths (JP)
        lw      t6, 0x7720(t6)              // (original) t6 = KOs (JP)
        } else {
        lw      t7, 0x9B90(t6)              // (original) t7 = deaths (US)
        lw      t6, 0x9B80(t6)              // (original) t6 = KOs (US)
        }
        subu    v0, t6, t7                  // (original) v0 = score = KOs - deaths
    
        _end:
        jr      ra 
        nop
    }


    // @ Description
    // Correct scoring (time/stock mode update) [bit]
    scope pick_scoring_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x00157734, 0x80134F64)
        } else {
        OS.patch_start(0x156564, 0x801373C4)
        }
        j   pick_scoring_ 
        OS.patch_end()

        lli     t0, 0x0001              // t1 = time
        beq     t6, t0, _time           // if mode == time, branch to time
        nop
        li      t0, Global.vs.timer     // t0 = address of timer
        lw      t0, 0x0000(t0)          // t0 = timer
        beqz    t0, _time               // if timer at 0, use time scoring hook
        nop

        _stock:
        j       calculate_stock_score_
        nop

        _time:
        j       calculate_time_score_
        nop
    }

    // Prevent sudden death [bit]
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x0010A1FC, 0x8018AF6C)
    } else {
    OS.patch_start(0x10A4EC, 0x8018D5FC)
    }
    lbu     t6, 0x0003(t5)
    lui     a0, 0x800A
    // a0 = gSCManagerVSBattleState -- region-specific low half
    if {defined REGION_JP} {
    addiu   a0, a0, 0x2EB8
    } else {
    addiu   a0, a0, 0x4EF8
    }
    lli     t7, 0x0001
    // @region:SYM
    if {defined REGION_JP} {
    beq     t6, t7, 0x8018AF8C
    } else {
    beq     t6, t7, 0x8018D61C
    }
    OS.patch_end()

    // Always view full results screen [bit]
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00157A5C, 0x8013528C)
    } else {
    OS.patch_start(0x15688C, 0x801376EC)
    }
    nop
    OS.patch_end()
}

} // __TIMED_STOCK__
