// Menu.asm
if !{defined __MENU__} {
define __MENU__()

include "Color.asm"
include "Global.asm"
include "Joypad.asm"
include "OS.asm"
include "Overlay.asm"

scope Menu {

    constant ROW_HEIGHT(000010)
    constant VALUE_COLUMN(000025)
    constant DEADZONE(000020)
    constant NUM_ENTRIES(000012)

    scope type {
        constant U8(0x0000)                 // 08 bit integer (unsigned)
        constant U16(0x0001)                // 16 bit integer (unsigned)
        constant U32(0x0002)                // 32 bit integer (unsigned)
        constant S8(0x0003)                 // 08 bit integer (signed, not supported) 
        constant S16(0x0004)                // 16 bit integer (signed, not supported)
        constant S32(0x0005)                // 32 bit integer (signed, not supported)
        constant BOOL(0x0006)               // bool
        constant TITLE(0x0007)              // has no value on the right
    }

    // @ Description
    // Struct for menu entries
    macro entry(title, type, default, min, max, function_address, string_table, edit_address, next) {
        dw {type}                           // 0x0000 - type (int, bool, etc.)
        dw {default}                        // 0x0004 - current value
        dw {min}                            // 0x0008 - minimum value
        dw {max}                            // 0x000C - maximum value
        dw {function_address}               // 0x0010 - if (!null), function ran when A is pressed
        dw {string_table}                   // 0x0014 - if (!null), use table of string pointers
        dw {edit_address}                   // 0x0018 - if (!null), write curr to this address
        dw {next}                           // 0x001C - if !(null), address of next entry
        db {title}                          // 0x0020 - title
        db 0x00
        OS.align(4)

        // @ Description
        // signed integers are not supproted yet!
        if {type} >= Menu.type.S8 {
            if {type} <= Menu.type.S32 {
                if {string_address} != OS.NULL {
                    warning "signed integers are not supported (yet)"
                }
            }
        }

        // @ Description
        // warning for strings with a negative index
        if {type} >= Menu.type.S8 {
            if {type} <= Menu.type.S32 {
                if {string_address} != OS.NULL {
                    warning "string index may be less than 0"
                }
            }
        }

        // @ Description
        // size checks
        if {type} == Menu.type.U8 {
            if {max} - {min} > 0xFF {
                warning "integer range is too large for u8
            }
        }

        if {type} == Menu.type.U16 {
            if {max} - {min} > 0xFFFF {
                warning "integer range is too large for u16
            }
        }

        if {type} == Menu.type.U32 {
            if {max} - {min} > 0xFFFFFFFF {
                warning "integer range is too large for u16
            }
        }
    }

    bool_0:; db "OFF", 0x00
    bool_1:; db "ON", 0x00
    OS.align(4)

    bool_string_table:
    dw bool_0
    dw bool_1
    OS.align(4)

    macro entry_bool(title, default, edit_address, next) {
        Menu.entry({title}, Menu.type.BOOL, {default}, 0, 1, OS.NULL, Menu.bool_string_table, {edit_address}, {next})
    }

    // @ Description
    // Draw a menu entry (title, on/off)
    // @ Arguments
    // a0 - entry
    // a1 - ulx
    // a2 - uly
    scope draw_entry_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      s0, 0x0004(sp)              // ~
        sw      s1, 0x0008(sp)              // ~
        sw      s2, 0x000C(sp)              // ~
        sw      t0, 0x0010(sp)              // ~
        sw      t1, 0x0014(sp)              // ~
        sw      ra, 0x0018(sp)              // save registers

        move    s0, a0                      // s0 = entry
        move    s1, a1                      // s1 = ulx
        move    s2, a2                      // s2 = uly

        move    a0, s1                      // a1 - ulx
        move    a1, s2                      // a1 - uly
        addiu   a2, s0, 0x0020              // a2 - address of string (title = entry + 0x0020)
        jal     Overlay.draw_string_
        nop

        lw      t0, 0x0014(s0)              // at = entry.string_table
        bnez    t0, _string                 // if (entry.string_table != null), skip
        nop                                 // else, continue

        _number:
        lw      a0, 0x0004(s0)              // a0 - (int) current value
        jal     OS.int_to_string_           // v0 = (string) current value
        nop
        addiu   a0, s1, (8 * VALUE_COLUMN)  // a0 - ulx
        move    a1, s2                      // a1 - uly
        move    a2, v0                      // a2 - address of string
        jal     Overlay.draw_string_        // draw value
        nop
        b       _end                        // skip draw string
        nop

        _string:
        lw      t1, 0x0004(s0)              // at =  (int) current value
        sll     t1, t1, 0x0002              // t1 = curr * sizeof(string pointer)
        addu    a2, t0, t1                  // ~
        lw      a2, 0x0000(a2)              // a2 - address of string
        addiu   a0, s1, (8 * VALUE_COLUMN)  // a0 - ulx
        move    a1, s2                      // a1 - uly
        jal     Overlay.draw_string_        // draw string
        nop

        _end:
        lw      s0, 0x0004(sp)              // ~
        lw      s1, 0x0008(sp)              // ~
        lw      s2, 0x000C(sp)              // ~
        lw      t0, 0x0010(sp)              // ~
        lw      t1, 0x0014(sp)              // ~
        lw      ra, 0x0018(sp)              // restore registers
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra
        nop
    }

    // @ Description
    // Draw linked list of menu entries
    // @ Arguments
    // a0 - address of head_entry
    // a1 - ulx
    // a2 - uly
    // a3 - address of selection
    scope draw_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      s0, 0x0004(sp)              // ~
        sw      t0, 0x0008(sp)              // ~
        sw      ra, 0x000C(sp)              // ~
        sw      a0, 0x0010(sp)              // ~
        sw      a1, 0x0014(sp)              // ~
        sw      a2, 0x0018(sp)              // ~
        sw      a3, 0x001C(sp)              // save registers

        // draw first entry
//      move    a0, a0                      // a0 - entry
//      move    a1, a1                      // a1 - ulx
//      move    a2, a2                      // a2 - uly
        jal     draw_entry_                 // draw first entry
        nop

        // draw following entries
        lw      s0, 0x0010(sp)              // s0 = entry_head
        lw      t0, 0x0018(sp)              // t0 = uly

        _loop:
        lw      s0, 0x001C(s0)              // s0 = entry->next
        beqz    s0, _end                    // if (entry->next == NULL), end
        nop
        addiu   t0, t0, ROW_HEIGHT          // increment height
        move    a0, s0                      // a0 - entry
        lw      a1, 0x0014(sp)              // a1 - ulx
        move    a2, t0                      // a2 - uly
        jal     draw_entry_
        nop
        b       _loop
        nop

        _end:
        // draw ">"
        lw      t0, 0x001C(sp)              // t0 = address of selection
        lw      t0, 0x0000(t0)              // t0 = selection
        addiu   t0, t0, 0x0002              // t0 = selection + 2
        lli     s0, ROW_HEIGHT              // ~
        mult    t0, s0                      // ~
        mflo    a1                          // s0 = height of row

        lw      a0, 0x0014(sp)              // ~
        addiu   a0, a0,-0x0008              // a0 - ulx
//      or      a1, a1, r0                  // a1 - uly
        lli     a2, '>'                     // a2 - char
        jal     Overlay.draw_char_          // draw '>'
        nop

        lw      s0, 0x0004(sp)              // ~
        lw      t0, 0x0008(sp)              // ~
        lw      ra, 0x000C(sp)              // ~
        lw      a0, 0x0010(sp)              // ~
        lw      a1, 0x0014(sp)              // ~
        lw      a2, 0x0018(sp)              // ~
        lw      a3, 0x001C(sp)              // restore registers
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Checks for various button presses and updates the menu accordingly
    // @ Arguments
    // a0 - address of entry_linked_list head
    // a1 - address of selection
    scope update_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      ra, 0x000C(sp)              // ~ 
        sw      at, 0x0010(sp)              // ~
        sw      a0, 0x0014(sp)              // ~ 
        sw      a1, 0x0018(sp)              // save registers

        _down:
        lli     a0, -DEADZONE               // a0 - min coordinate (deadzone)
        jal     Joypad.check_stick_down_    // check if stick pressed down
        nop
        beqz    v0, _up                     // if not pressed, check c-up
        nop
        lw      t0, 0x0018(sp)              // t0 = address of selection
        lw      t1, 0x0000(t0)              // t1 = selection
        lw      a0, 0x0014(sp)              // a0 - head
        jal     get_num_entries_            // v0 = num_entries
        nop        
        addiu   v0, v0,-0x0001              // v0 = num_entries - 1
        sltu    at, t1, v0                  // ~
        beqz    at, _wrap_down              // if (selection == (num_entries - 1), wrap
        nop
        addiu   t1, t1, 0x0001              // t1 = selection++
        sw      t1, 0x0000(t0)              // update selection
        b       _end                        // only allow one update
        nop

        _wrap_down:
        sw      r0, 0x0000(t0)              // update selction
        b       _end                        // exit
        nop

        _up:
        lli     a0, DEADZONE               // a0 - min coordinate (deadzone)
        jal     Joypad.check_stick_up_      // check if stick pressed up
        nop
        beqz    v0, _right                  // if not pressed, check right
        nop
        lw      t0, 0x0018(sp)              // t0 = address of selection
        lw      t1, 0x0000(t0)              // t1 = selection
        beqz    t1, _wrap_up                // if (selection == 0), go to bottom option
        nop
        addiu   t1, t1,-0x0001              // t1 = selection--
        sw      t1, 0x0000(t0)              // update selection
        b       _end                        // only allow one update
        nop

        _wrap_up:
        lw      a0, 0x0014(sp)              // a0 - head
        jal     get_num_entries_            // v0 = num_entries
        nop
        addiu   v0, v0,-0x0001              // ~
        sw      v0, 0x0000(t0)              // update selection to bottom option
        b       _end                        // exit
        nop

        _right:
        lli     a0, DEADZONE               // a0 - min coordinate (deadzone)
        jal     Joypad.check_stick_right_ // check if stick pressed right
        nop
        beqz    v0, _left                   // if not pressed, check left
        nop
        lw      a0, 0x0014(sp)              // a0 - head
        lw      a1, 0x0018(sp)              // a1 = address of selection
        jal     get_selected_entry_         // v0 = selected entry
        nop
        lw      t0, 0x0004(v0)              // t0 = entry.current_value
        lw      t1, 0x000C(v0)              // t1 = entry.max_value
        sltu    at, t0, t1                  // if (entry.current_value < entry.max_value)
        beqz    at, _end                    // then, skip
        nop                                 // else, continue
        addiu   t0, t0, 0x0001              // ~
        sw      t0, 0x0004(v0)              // entry.current_value++
        b       _end                        // only allow one update
        nop

        _left:
        lli     a0, -DEADZONE               // a0 - min coordinate (deadzone)
        jal     Joypad.check_stick_left_    // check if stick pressed left
        nop
        beqz    v0, _end                    // if not pressed, end
        nop
        lw      a0, 0x0014(sp)              // a0 - head
        lw      a1, 0x0018(sp)              // a1 = address of selection
        jal     get_selected_entry_         // v0 = selected entry
        nop
        lw      t0, 0x0004(v0)              // t0 = entry.current_value
        lw      t1, 0x0008(v0)              // t1 = entry.min_value
        sltu    at, t1, t0                  // if (entry.min_value < entry.curr_value)
        beqz    at, _end                    // then, skip
        nop                                 // else, continue
        addiu   t0, t0,-0x0001              // ~
        sw      t0, 0x0004(v0)              // entry.current_value--
        b       _end                        // only allow one update
        nop

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      ra, 0x000C(sp)              // ~
        lw      at, 0x0010(sp)              // ~
        lw      a0, 0x0014(sp)              // ~ 
        lw      a1, 0x0018(sp)              // restore registers
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Gets an entry based on selection. Helper function
    // @ Arguments
    // a0 - head
    // a1 - address of selection
    // @ Returns
    // v0 - address of entry
    scope get_selected_entry_: {
        addiu   sp, sp,-0x0010              // alloc stack space
        sw      at, 0x0004(sp)              // ~
        sw      t0, 0x0008(sp)              // save registers

        // init
        lli     at, 0x0000                  // at = i = 0
        lw      t0, 0x0000(a1)              // t0 = selection

        _loop:
        beqz    a0, _fail                   // if (entry = null), end
        nop
        beq     at, t0, _end                // if (i == selection), end loop
        nop
        lw      a0, 0x001C(a0)              // a0 = entry->next
        addiu   at, at, 0x0001              // increment i 
        b       _loop                       // check again
        nop

        _end:
        lw      at, 0x0004(sp)              // ~
        lw      t0, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        or      v0, a0, r0                  // v0 = ret = entry
        jr      ra                          // return
        nop

        _fail:
        break                               // halt execution
    }

    // @ Description
    // This function will chnage the currently loaded SSB screen
    // @ Arguments
    // a0 - int next_screen
    scope change_screen_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // save registers

        li      t0, Global.current_screen   // ~
        lb      t1, 0x0000(t0)              // t1 = current_screen
        sb      t1, 0x0001(t0)              // update previous_screen to current_screen
        sb      a0, 0x0000(t0)              // update current_screen to next_screen
        li      t0, Global.screen_interrupt // ~
        lli     t1, 0x0001                  // ~
        sw      t1, 0x0000(t0)              // generate screen_interrupt

        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // allocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Returns the number of entires for a menu
    // @ Arguments
    // a0 - head
    // @ Returns
    // v0 - num_entries
    scope get_num_entries_: {
        lli     v0, 0x0000                  // ret = 0
        
        _loop:
        beqz    a0, _end                    // if (entry = null), end
        nop
        lw      a0, 0x001C(a0)              // a0 = entry->next
        addiu   v0, v0, 0x0001              // increment ret
        b       _loop                       // check again
        nop

        _end:
        jr      ra
        nop
    }

}

}