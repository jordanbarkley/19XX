// VsCombo.asm
if {defined __CE__} {
if !{defined __VSCOMBO__} {
define __VSCOMBO__()
print "included VsCombo.asm\n"

// @ Description
// This file ads combo meters to VS. matches.

include "Data.asm"
include "OS.asm"
include "Overlay.asm"
include "String.asm"
include "Toggles.asm"

scope VsCombo {

    // @ Description
    // Display constants for combo/hit meter positioning
    constant COMBO_METER_Y_COORD(167)
    constant P1_COMBO_METER_X_COORD(10)
    constant P2_COMBO_METER_X_COORD(80)
    constant P3_COMBO_METER_X_COORD(150)
    constant P4_COMBO_METER_X_COORD(220)

    // @ Description
    // Player hit count addresses
    constant HIT_COUNT_BASE(0x800A4000)
    constant P1_HIT_COUNT_OFFSET(0x0D7C)
    constant P2_HIT_COUNT_OFFSET(0x0DF0)
    constant P3_HIT_COUNT_OFFSET(0x0E64)
    constant P4_HIT_COUNT_OFFSET(0x0ED8)

    // @ Description
    // Default number of frames to keep a hit count displayed
    constant DEFAULT_FRAME_BUFFER(30)

    // @ Description
    // Player count (stops counting at 3)
    player_count:
    dw 0x00                                 // number of players

    texture_font:
    Texture.info(16, 16)
    insert "../textures/combo_numbers.rgba5551"

    // @ Description
    // This macro draws the given hit count at the specified X coordinate
    scope draw_hit_count_: {
        // a0 = hit_count
        // a1 = player_x_coord
        // a2 = player_offset

        addiu   sp, sp,-0x0020              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      t2, 0x000C(sp)              // ~
        sw      t3, 0x0010(sp)              // ~
        sw      t4, 0x0014(sp)              // ~
        sw      t5, 0x0018(sp)              // ~
        sw      ra, 0x001C(sp)              // save registers

		move    t4, a1                      // t4 = player_x_coord

        // Check if currently in a combo (hit count > 1)
        lli     t0, 0x0001                  // t0 = 1
        sltu    t1, t0, a0                  // if (hit count > 1) then store to display table
        bnez    t1, _in_combo               // skip to store to display table section
        nop

        // Check if frame buffer is active (frame buffer > 0)
        li      t2, frame_buffer_table      // t2 = address of frame_buffer
        addu    t2, t2, a2                  // t2 = address of frame_buffer for this player
        lw      t3, 0x0000(t2)              // t3 = frame_buffer
        bnez    t3, _post_combo             // if (frame buffer > 0) then frame_buffer-- and draw
        nop
        b       _end                        // don't draw - skip to end
        nop

        // Move hit count to display table and restore frame buffer
        _in_combo:
        li      t2, frame_buffer_table      // t2 = address of frame_buffer
        addu    t2, t2, a2                  // t2 = address of frame_buffer for this player
        lli     t3, DEFAULT_FRAME_BUFFER    // t3 = DEFAULT_FRAME_BUFFER
        sll     t1, a0, 0x0002              // t1 = hit_count * 4
        sltiu   t5, t1, 0x0096              // if (hit_count * 4 >= 150) then only add 150 frames
        bnez    t5, _continue_in_combo      // hit_count * 4 is ok to use as an additional frame buffer; skip
        nop
        lli     t1, 0x0096                  // Only add 150 frames

        _continue_in_combo:
        addu    t3, t3, t1                  // t3 = t3 + t1 (add more frames for higher combo values)
        sw      t3, 0x0000(t2)              // frame buffer = DEFAULT_FRAME_BUFFER
        li      t2, display_table           // t2 = address of display_table
        addu    t2, t2, a2                  // t2 = address of display_table for this player
        sw      a0, 0x0000(t2)              // store hit count in display table
        b       _draw                       // skip to draw
        nop

        // Decrease frame buffer
        _post_combo:
        addiu   t3, t3, -0x0001             // frame_buffer--
        sw      t3, 0x0000(t2)              // save new frame buffer
        li      t2, display_table           // t2 = address of display_table
        addu    t2, t2, a2                  // t2 = address of display_table for this player
        lw      a0, 0x0000(t2)              // a0 = hit count from display table

        // Draw combo meter
        _draw:
        jal     String.itoa_                // v0 = (string) hit count
        nop
        move    a0, t4                      // a0 - ulx
        lli     a1, COMBO_METER_Y_COORD     // a1 - uly
        li      a2, Data.combo_text_info    // a2 - address of texture struct
        jal     Overlay.draw_texture_big_   // draw combo text texture
        nop
        move    a0, t4                      // a0 - ulx
        addiu   a0, a0, 64                  // a0 = ulx + 64 pixels
        lli     a1, COMBO_METER_Y_COORD     // a1 = uly
        move    a2, v0                      // a2 = address of string
        jal     draw_string_                // draw current hit count
        nop

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      t2, 0x000C(sp)              // ~
        lw      t3, 0x0010(sp)              // ~
        lw      t4, 0x0014(sp)              // ~
        lw      t5, 0x0018(sp)              // ~
        lw      ra, 0x001C(sp)              // save registers
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop

        frame_buffer_table:
        dw 0x00                             // p1 frame buffer (left player for singles)
        dw 0x00                             // p2 frame buffer (right player for singles)
        dw 0x00                             // p3 frame buffer
        dw 0x00                             // p4 frame buffer

        display_table:
        dw 0x00                             // p1 hit count holder (left player for singles)
        dw 0x00                             // p2 player hit count holder (right player for singles)
        dw 0x00                             // p3 hit count holder
        dw 0x00                             // p4 hit count holder
    }

    // @ Description
    // This macro draws the given hit count at the specified X coordinate...
    // it is a helper that allows passing in immediates
    macro draw_hit_count(hit_count_offset, player_x_coord, player_offset) {
    	li      t0, HIT_COUNT_BASE          // t0 = hit count base address
    	addiu   t0, t0, {hit_count_offset}  // t0 = address of hit_count
        lw      a0, 0x0000(t0)              // a0 = hit_count
        li      a1, {player_x_coord}        // a1 = player_x_coord
        lli     a2, {player_offset}         // a2 = player_offset
        jal     VsCombo.draw_hit_count_     // values now in registers; draw
        nop
    }

    // @ Description
    // This macro helps clear out a 4 word table
    macro clear_array(address_of_table) {
    	li      t2, {address_of_table}
        sw      r0, 0x0000(t2)              // Set table[0] to 0
        sw      r0, 0x0004(t2)              // Set table[1] to 0
        sw      r0, 0x0008(t2)              // Set table[2] to 0
        sw      r0, 0x000C(t2)              // Set table[3] to 0
    }

    // @ Description
    // This macro checks if the given port is a man/cpu and increments player count
    // accordingly. Then it sets up the tables needed for swapping the combo meter
    // in singles or skips to _not_singles once the number of players over 2.
    macro port_check(type_address, next, x_coord, hit_count_offset) {
        // t1 = player_count
        // t8 = x_coord_table
        // t9 = hit_count_table
        li      t2, {type_address}          // address of player type
        lb      t3, 0x0002(t2)              // t3 = type (0 = man, 1 = cpu, 2 = n/a)
        sltiu   t4, t3, 0x0002              // if (p3 = man/cpu) then player_count++
        beqz    t4, {next}                  // not man/cpu so skip
        nop
        addu    t1, t1, t4                  // player_count++
        sw      t1, 0x0000(t0)              // store player count
        li      t5, 0x0003                  // t5 = 3
        beq     t1, t5, _not_singles        // if (>=3 players) then not singles so stop counting
        nop
        lli     t5, {x_coord}               // t5 = x coord for left/right port
        sw      t5, 0x0000(t8)              // store x coord for left/right port
        addiu   t8, t8, 0x0004              // t8 = x_coord_table++
        li      t5, {hit_count_offset}      // t5 = hit count for right/left port
        sw      t5, 0x0000(t9)              // store hit count for right/left port
        addiu   t9, t9, 0x0004              // t9 = hit_count_table++
    }

    // @ Description
    // Adds f3dex2 to draw characters.
    // @ Arguments
    // a0 - ulx
    // a1 - uly
    // a2 - char
    scope draw_char_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      a2, 0x000C(sp)              // ~
        sw      ra, 0x0010(sp)              // save registers

        li      t0, texture_font            // ~
        lw      t0, 0x0008(t0)              // t0 = address of image_data


        addiu   a2, a2, -0x0030             // a2 = char - 48 (we only care about numbers, sprite not padded)
        sll     t1, a2, 0x0009              // t1 = char * width * height * 2 (or char * 512)
        addu    t0, t0, t1                  // t0 = address of char_data
        li      t1, texture                 // ~
        sw      t0, 0x0008(t1)              // texture.data = char_data
        li      a2, texture                 // a2 - texture data
        jal     Overlay.draw_texture_
        nop

        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      a2, 0x000C(sp)              // ~
        lw      ra, 0x0010(sp)              // restore registers
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop

        texture:
        Texture.info(16, 16)
    }

    // @ Description
    // Draws a null terminated string.
    // @ Arguments
    // a0 - ulx
    // a1 - uly
    // a2 - address of string
    scope draw_string_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      s2, 0x0008(sp)              // ~
        sw      ra, 0x000C(sp)              // save registers

        or      s2, a2, r0                  // s2 = copy of a2 (address of string)

        _loop:
        lb      t0, 0x0000(s2)              // t0 = char
        beq     t0, r0, _end                // if (t0 == 0x00), end
        nop
        or      a2, t0, 0x000               // a2 = char
        jal     draw_char_                  // draw character
        nop
        addiu   s2, s2, 0x0001              // s2++
        addiu   a0, a0, 0x0009              // a0 = (ulx + 9)
        b       _loop                       // draw next char
        nop

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      s2, 0x0008(sp)              // ~
        lw      ra, 0x000C(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

    scope run_: {
        OS.save_registers()                 // save registers

		b       _guard                      // check if toggle is on
        nop
        _toggle_off:
        b       _end                        // toggle is off, skip to end
        nop
        _swap_toggle_off:
        b       _not_singles                // 1v1 swap toggle is off, skip to end
        nop

        _guard:
        // If combo meter is off, skip to _end and don't draw hit counts
        Toggles.guard(Toggles.entry_vs_mode_combo_meter, _toggle_off)

        // If 1v1 swap is off, skip to _not_singles
        Toggles.guard(Toggles.entry_1v1_combo_meter_swap, _swap_toggle_off)

        // We swap hit count meter location for 1v1, so the next few blocks check
        // how many players there are and set up tables for the left and right
        // player ports. This is only run once per match.
        _setup:
        li      t0, player_count            // t0 = number of players
        lw      t1, 0x0000(t0)              // t1 = player_count
        bnez    t1, _check_singles          // if (player_count > 0) skip setup
        nop
        li      t8, x_coord_table           // t8 = x_coord_table
        li      t9, hit_count_table         // t9 = hit_count_table

        // Reset variables from previous match
        clear_array(VsCombo.draw_hit_count_.display_table)
        clear_array(VsCombo.draw_hit_count_.frame_buffer_table)

        _p1:
        port_check(Global.vs.p1, _p2, P1_COMBO_METER_X_COORD, P1_HIT_COUNT_OFFSET)

        _p2:
        port_check(Global.vs.p2, _p3, P2_COMBO_METER_X_COORD, P2_HIT_COUNT_OFFSET)

		_p3:
        port_check(Global.vs.p3, _p4, P3_COMBO_METER_X_COORD, P3_HIT_COUNT_OFFSET)

		_p4:
        port_check(Global.vs.p4, _check_singles, P4_COMBO_METER_X_COORD, P4_HIT_COUNT_OFFSET)
        b       _singles                    // we're in singles so skip _check_singles
        nop

        _check_singles:
        li      t5, 0x0002                  // t5 = 2
        bne     t1, t5, _not_singles        // if (player_count != 2) then not singles
        nop

        _singles:
        li      t8, x_coord_table           // t0 = address of x_coord_table
        li      t9, hit_count_table         // t9 = address of hit_count_table
        li      t0, HIT_COUNT_BASE          // t2 = hit count base address

        lw      t1, 0x0004(t9)              // t1 = left player hit_count offset
    	addu    t1, t0, t1                  // t1 = address of left player hit_count
        lw      a0, 0x0000(t1)              // a0 = left player hit_count
        lw      a1, 0x0000(t8)              // a1 = left player x coord
        lli     a2, 0x0000                  // a2 = player_offset
        jal     VsCombo.draw_hit_count_
        nop

        lw      t1, 0x0000(t9)              // t1 = right player hit_count offset
        addu    t1, t0, t1                  // t1 = address of right player hit_count
        lw      a0, 0x0000(t1)              // a0 = right player hit_count
        lw      a1, 0x0004(t8)              // a1 = right player x coord
        lli     a2, 0x0004                  // a2 = player_offset
        jal     VsCombo.draw_hit_count_
        nop
        b       _end                        // no need to draw more; skip to end
        nop

        _not_singles:
        draw_hit_count(P1_HIT_COUNT_OFFSET, P1_COMBO_METER_X_COORD, 0x0000)
        draw_hit_count(P2_HIT_COUNT_OFFSET, P2_COMBO_METER_X_COORD, 0x0004)
        draw_hit_count(P3_HIT_COUNT_OFFSET, P3_COMBO_METER_X_COORD, 0x0008)
        draw_hit_count(P4_HIT_COUNT_OFFSET, P4_COMBO_METER_X_COORD, 0x000C)

        _end:
        OS.restore_registers()              // restore registers
        jr      ra                          // return
        nop

        x_coord_table:
        dw 0x00                             // left player x_coord (singles)
        dw 0x00                             // right player x_coord (singles)

        hit_count_table:
        dw 0x00                             // right player hit count address (singles)
        dw 0x00                             // left player hit count address (singles)

    }
} // VsCombo
} // __VSCOMBO__
} // __CE__
