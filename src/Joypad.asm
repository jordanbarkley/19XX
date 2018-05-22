// Joypad.asm
if !{defined __JOYPAD__} {
define __JOYPAD__()

scope Joypad {
    // @ Description
    // Button masks
    constant A(0x8000)
    constant B(0x4000)
    constant Z(0x2000)
    constant START(0x1000)
    constant DU(0x0800)
    constant DD(0x0400)
    constant DL(0x0200)
    constant DR(0x0100)
    constant CU(0x0008)
    constant L(0x0020)
    constant R(0x0010)
    constant CD(0x0004)
    constant CL(0x0002)
    constant CR(0x0001)
    constant NONE(0x0000)

    // @ Description
    // This is the controller struct that game reads from. It's 10 bytes in size (per player)
    // @ Fields
    // 0x0000 - half - is_held  - check for is_held
    // 0x0002 - half - pressed  - check for !is_held -> is_held
    // 0x0004 - half - turbo    - is_held but continually goes on and off
    // 0x0006 - half - released - check for is_held -> !is_held
    // 0x0008 - byte - xpos
    // 0x0009 - byte - ypos
    // what is the difference between 0x0004 and 0x0006?
    constant struct(0x80045228)

    // @ Description
    // Types
    constant HELD(0x0000)
    constant PRESSED(0x0002)
    constant TURBO(0x0004)
    constant RELEASED(0x0006)

    // @ Description
    // Determine whether a button or button combination (type) or not.
    // @ Arguments
    // a0 - button_mask
    // a1 - player (p1 = 0, p4 = 3)
    // a2 - type
    // @ Returns
    // v0 - bool
    scope check_buttons_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // save registers

        lli     at, 000010                  // ~
        mult    a1, at                      // ~
        mflo    at                          // at = offset
        li      t0, struct                  // t0 = struct
        addu    t0, t0, at                  // t0 = struct + offset
        addu    t0, t0, a2                  // t0 = struct + offset + type
        lhu     t0, 0x0000(t0)              // t0 = type
        lli     v0, OS.FALSE                // v0 = false
        bne     t0, a0, _end                // if (mask != button_mask), skip
        nop
        lli     v0, OS.TRUE

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Determine if a button is held or not
    // @ Arguments
    // a0 - button_mask
    // a1 - player (p1 = 0, p4 = 3)
    // @  Returns
    // v0 - bool
    scope is_held_: {
        lli     a2, HELD
        j       check_buttons_
        nop
    }

    // @ Description
    // Determine if a button was pressed
    // @ Arguments
    // a0 - button_mask
    // a1 - player (p1 = 0, p4 = 3)
    // @  Returns
    // v0 - bool
    scope was_pressed_: {
        lli     a2, PRESSED
        j       check_buttons_
        nop
    }

    // @ Description
    // Determines if a button was released
    // @ Arguments
    // a0 - button_mask
    // a1 - player (p1 = 0, p4 = 3)
    // @  Returns
    // v0 - bool
    scope was_released_: {
        lli     a2, RELEASED
        j       check_buttons_
        nop
    }






}

}