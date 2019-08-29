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
    constant P1_HIT_COUNT(0x800A4D7C)
    constant P2_HIT_COUNT(0x800A4DF0)
    constant P3_HIT_COUNT(0x800A4E64)
    constant P4_HIT_COUNT(0x800A4ED8)

    //OS.align(32)
    texture_font:
    Texture.info(16, 16)
    insert "../textures/combo_numbers.rgba5551"

    // @ Description
    // This macro draws the given hit count at the specified X coordinate
    macro draw_hit_count(hit_count, player_x_coord, next) {
    	li      a1, {hit_count}             // a1 = address of hit count
        lw      a0, 0x0000(a1)              // a0 = hit count
        sltiu   a2, a0, 0x0002              // if (hit count < 2) then don't draw
        bnez    a2, {next}                  // don't draw: skip to next
        nop
        jal     String.itoa_                // v0 = (string) hit count
        nop
        lli     a0, {player_x_coord}        // a0 - ulx
        lli     a1, COMBO_METER_Y_COORD     // a1 - uly
        li      a2, Data.combo_text_info    // a2 - address of texture struct
        jal     Overlay.draw_texture_big_   // draw combo text texture
        nop
        lli     a0, {player_x_coord} + 64   // a0 = ulx
        lli     a1, COMBO_METER_Y_COORD     // a1 = uly
        move    a2, v0                      // a2 = address of string
        jal     draw_string_                // draw current hit count
        nop
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

        _guard:
        // If combo meter is off, skip to _end and don't draw hit counts
        Toggles.guard(Toggles.entry_vs_mode_combo_meter, _toggle_off)

        _draw_for_p1:
        draw_hit_count(P1_HIT_COUNT, P1_COMBO_METER_X_COORD, _draw_for_p2)

        _draw_for_p2:
        draw_hit_count(P2_HIT_COUNT, P2_COMBO_METER_X_COORD, _draw_for_p3)

        _draw_for_p3:
        draw_hit_count(P3_HIT_COUNT, P3_COMBO_METER_X_COORD, _draw_for_p4)

        _draw_for_p4:
        draw_hit_count(P4_HIT_COUNT, P4_COMBO_METER_X_COORD, _end)

        _end:
        OS.restore_registers()              // restore registers
        jr      ra                          // return
        nop

    }
} // VsCombo
} // __VSCOMBO__
} // __CE__
