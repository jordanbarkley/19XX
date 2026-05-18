// Timeouts.asm (additional timeouts found by bit)
if !{defined __TIMEOUTS__} {
define __TIMEOUTS__()
print "included Timeouts.asm\n"

// @ Description
// The following patches disable a conditional check with each screen frame counter. Typically,
// the number of frames ran on the current screen is compared with 18000 frames (5 minutes). Then,
// a conditional branch to a function that changes screens is called. The conditional branch (bne)
// been replaced by a branch always (b) so that the change screen function is never called.

include "OS.asm"

scope Timeouts {

    // Mode select screen
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x0011D650, 0x80130500)
    b 0x80130520
    } else {
    OS.patch_start(0x0011D5B0, 0x80132620)
    b 0x80132640
    }
    OS.patch_end()

    // 1P menu screen
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x0011ED54, 0x80130734)
    b 0x80130754
    } else {
    OS.patch_start(0x0011EB1C, 0x80132A0C)
    b 0x80132A2C
    }
    OS.patch_end()

    // Option screen
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00120A4C, 0x80130BFC)
    b 0x80130C24
    } else {
    OS.patch_start(0x00120658, 0x80132EA8)
    b 0x80132ED0
    }
    OS.patch_end()

    // Data screen
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x001221D8, 0x80130528)
    b 0x80130548
    } else {
    OS.patch_start(0x00121D20, 0x801328D0)
    b 0x801328F0
    }
    OS.patch_end()

    // Versus menu screen
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00124EA8, 0x80131BE8)
    b 0x80131C10
    } else {
    OS.patch_start(0x001245A0, 0x80133BF0)
    b 0x80133C18
    }
    OS.patch_end()

    // Versus options screen
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00127EDC, 0x8013197C)
    b 0x801319AC
    } else {
    OS.patch_start(0x00127284, 0x80133AA4)
    b 0x80133AD4
    }
    OS.patch_end()

    // Versus css
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00139A6C, 0x8013855C)
    b 0x80138584
    } else {
    OS.patch_start(0x00138BDC, 0x8013A95C)
    b 0x8013A984
    }
    OS.patch_end()

    // 1P css
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x001410E4, 0x80135BF4)
    b 0x80135C24
    } else {
    OS.patch_start(0x001401F4, 0x80137FF4)
    b 0x80138024
    }
    OS.patch_end()

    // Training css
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00147C58, 0x80135328)
    b 0x80135358
    } else {
    OS.patch_start(0x00146D08, 0x80137728)
    b 0x80137758
    }
    OS.patch_end()

    // Bonus practice css
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x0014DA38, 0x80134658)
    b 0x80134688
    } else {
    OS.patch_start(0x0014CA28, 0x801369F8)
    b 0x80136A28
    }
    OS.patch_end()

    // Stage selection screen
    // @region:SYM
    if {defined REGION_JP} {
    OS.patch_start(0x00150AF8, 0x80131B18)
    b 0x80131B40
    } else {
    OS.patch_start(0x0014F928, 0x80133DB8)
    b 0x80133DE0
    }
    OS.patch_end()
}

} // __TIMEOUTS__
