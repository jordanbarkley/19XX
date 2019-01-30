// Stages.asm
if !{defined __STAGES__} {
define __STAGES__()
print "included Stages.asm\n"

// @ Descirption
// This file expands the stage select screen.

include "Color.asm"
include "Data.asm"
include "FGM.asm"
include "Global.asm"
include "OS.asm"
include "Overlay.asm"
include "String.asm"
include "Texture.asm"

scope Stages {

    // @ Descirption
    // Stage ID's. Used in various loading sequences.
    scope id {
        constant PEACHS_CASTLE(0x00)
        constant SECTOR_Z(0x01)
        constant CONGO_JUNGLE(0x02)
        constant PLANET_ZEBES(0x03)
        constant HYRULE_CASTLE(0x04)
        constant YOSHIS_ISLAND(0x05)
        constant DREAM_LAND(0x06)
        constant SAFFRON_CITY(0x07)
        constant MUSHROOM_KINGDOM(0x08)
        constant DREAM_LAND_BETA_1(0x09)
        constant DREAM_LAND_BETA_2(0x0A)
        constant HOW_TO_PLAY(0x0B)
        constant MINI_YOSHIS_ISLAND(0x0C)
        constant META_CRYSTAL(0x0D)
        constant BATTLEFIELD(0x0E)
        constant RACE_TO_THE_FINISH(0x0F)
        constant FINAL_DESTINATION(0x10)
        constant RANDOM(0xDE)               // not an actual id, arbitary number used by Sakurai
    }

    // @ Descirption
    // type controls a branch that executes code for single player modes when 0x00 or skips that 
    // entirely for 0x14. This branch can be found at 0x(TODO). (pulled from table @ 0xA7D20)
    scope type {
        constant PEACHS_CASTLE(0x14)
        constant SECTOR_Z(0x14)
        constant CONGO_JUNGLE(0x14)
        constant PLANET_ZEBES(0x14)
        constant HYRULE_CASTLE(0x14)
        constant YOSHIS_ISLAND(0x14)
        constant DREAM_LAND(0x14)
        constant SAFFRON_CITY(0x14)
        constant MUSHROOM_KINGDOM(0x14)
        constant DREAM_LAND_BETA_1(0x14)
        constant DREAM_LAND_BETA_2(0x14)
        constant HOW_TO_PLAY(0x00)
        constant MINI_YOSHIS_ISLAND(0x14)
        constant META_CRYSTAL(0x14)
        constant BATTLEFIELD(0x14)
        constant RACE_TO_THE_FINISH(0x00)
        constant FINAL_DESTINATION(0x00)
    }

    // @ Descirption
    // File id for each stage (pulled from table @ 0xA7D20)
    scope file {
        constant PEACHS_CASTLE(0x0103)
        constant SECTOR_Z(0x0106)
        constant CONGO_JUNGLE(0x0105)
        constant PLANET_ZEBES(0x0101)
        constant HYRULE_CASTLE(0x0109)
        constant YOSHIS_ISLAND(0x0107)
        constant DREAM_LAND(0x00FF)
        constant SAFFRON_CITY(0x0108)
        constant MUSHROOM_KINGDOM(0x104)
        constant DREAM_LAND_BETA_1(0x0100)
        constant DREAM_LAND_BETA_2(0x0102)
        constant HOW_TO_PLAY(0x010B)
        constant MINI_YOSHIS_ISLAND(0x010E)
        constant META_CRYSTAL(0x10D)
        constant BATTLEFIELD(0x010C)
        constant RACE_TO_THE_FINISH(0x0127)
        constant FINAL_DESTINATION(0x010A)
    }

    constant ICON_WIDTH(40)
    constant ICON_HEIGHT(30)

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // TE STAGE SELECT SCREEN
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Layout
    // [00] [01] [02] [03] [04] [05]
    // [06] [07] [08] [09] [0A] [RR]

if {defined __TE__} {
    constant NUM_ROWS(2)
    constant NUM_COLUMNS(6)
    constant NUM_ICONS(NUM_ROWS * NUM_COLUMNS)
    constant LEFT_RANDOM_INDEX(0x0B)
    constant RIGHT_RANDOM_INDEX(0x0B)

    // @ Descirption
    // Stage IDs in order
    // Viable Stage (Most Viable at the Top)
    stage_table:
    db id.PEACHS_CASTLE                     // 00
    db id.CONGO_JUNGLE                      // 01
    db id.HYRULE_CASTLE                     // 02
    db id.PLANET_ZEBES                      // 03
    db id.MUSHROOM_KINGDOM                  // 04
    db id.BATTLEFIELD                       // 05

    // Genesis 6 will be using cloudless yoshi's island
    if !{defined __G6__} {
    db id.YOSHIS_ISLAND                     // 06
    }

    if {defined __G6__} {
    db id.MINI_YOSHIS_ISLAND                // 06
    }    

    db id.DREAM_LAND                        // 07
    db id.SECTOR_Z                          // 08
    db id.SAFFRON_CITY                      // 09
    db id.FINAL_DESTINATION                 // 0A
    db id.RANDOM                            // RR
    OS.align(4)
    
    insert icon_peachs_castle, "../textures/icon_peachs_castle.rgba5551"
    insert icon_sector_z, "../textures/icon_sector_z.rgba5551"
    insert icon_congo_jungle, "../textures/icon_congo_jungle.rgba5551"
    insert icon_planet_zebes, "../textures/icon_planet_zebes.rgba5551"
    insert icon_hyrule_castle, "../textures/icon_hyrule_castle.rgba5551"
    insert icon_yoshis_island, "../textures/icon_yoshis_island.rgba5551"
    insert icon_dream_land, "../textures/icon_dream_land.rgba5551"
    insert icon_saffron_city, "../textures/icon_saffron_city.rgba5551"
    insert icon_mushroom_kingdom, "../textures/icon_mushroom_kingdom.rgba5551"
    insert icon_battlefield, "../textures/icon_battlefield.rgba5551"
    insert icon_final_destination, "../textures/icon_final_destination.rgba5551"
    insert icon_random_, "../textures/icon_random.rgba5551"

    // sorted by stage id
    icon_table:
    dw icon_peachs_castle
    dw icon_sector_z
    dw icon_congo_jungle
    dw icon_planet_zebes
    dw icon_hyrule_castle
    dw icon_yoshis_island
    dw icon_dream_land
    dw icon_saffron_city
    dw icon_mushroom_kingdom
    dw OS.NULL                              // Dream Land Beta 1
    dw OS.NULL                              // Dream Land Beta 2
    dw OS.NULL                              // How To Play
    dw icon_yoshis_island                   // Mini Yoshi's Island
    dw OS.NULL                              // Meta Crystal
    dw icon_battlefield
    dw OS.NULL                              // Race to the Finish (Placeholder)
    dw icon_final_destination

    icon_random:
    dw icon_random_

    position_table:
    // row 0
    dw 033, 030                             // 00
    dw 075, 030                             // 01
    dw 117, 030                             // 02
    dw 159, 030                             // 03
    dw 201, 030                             // 04
    dw 243, 030                             // 05

    // row 1
    dw 033, 062                             // 06
    dw 075, 062                             // 07
    dw 117, 062                             // 08
    dw 159, 062                             // 09
    dw 201, 062                             // 0A
    dw 243, 062                             // 0B

} // __TE__

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // CE STAGE SELECT SCREEN
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Layout
    // [00] [01] [02] [03] [04] [05]
    // [06] [07] [08] [09] [0A] [0B]
    // [RR] [0C] [0D] [0E] [0F] [RR]

if {defined __CE__} {
    constant NUM_ROWS(3)
    constant NUM_COLUMNS(6)
    constant NUM_ICONS(NUM_ROWS * NUM_COLUMNS)
    constant LEFT_RANDOM_INDEX(12)
    constant RIGHT_RANDOM_INDEX(17)

    // @ Descirption
    // Stage IDs in order
    // Viable Stage (Most Viable at the Top)
    stage_table:
    db id.PEACHS_CASTLE                     // 00
    db id.CONGO_JUNGLE                      // 01
    db id.HYRULE_CASTLE                     // 02
    db id.PLANET_ZEBES                      // 03
    db id.MUSHROOM_KINGDOM                  // 04
    db id.BATTLEFIELD                       // 05
    db id.YOSHIS_ISLAND                     // 06
    db id.DREAM_LAND                        // 07
    db id.SECTOR_Z                          // 08
    db id.SAFFRON_CITY                      // 09
    db id.FINAL_DESTINATION                 // 0A
    db id.META_CRYSTAL                      // 0B
    db id.RANDOM                            // RR
    db id.DREAM_LAND_BETA_1                 // 0C
    db id.DREAM_LAND_BETA_2                 // 0D
    db id.HOW_TO_PLAY                       // 0E
    db id.MINI_YOSHIS_ISLAND                // 0F
    db id.RANDOM                            // RR
    OS.align(4)

    // @ Descirption
    // Coordinates of stage icons in vanilla Super Smash Bros.
    position_table:
    // row 0
    dw 033, 020                             // 00
    dw 075, 020                             // 01
    dw 117, 020                             // 02
    dw 159, 020                             // 03
    dw 201, 020                             // 04
    dw 243, 020                             // 05

    // row 1
    dw 033, 052                             // 06
    dw 075, 052                             // 07
    dw 117, 052                             // 08
    dw 159, 052                             // 09
    dw 201, 052                             // 0A
    dw 243, 052                             // 0B

    // row 2
    dw 033, 084                             // RR
    dw 075, 084                             // 0C
    dw 117, 084                             // 0D
    dw 159, 084                             // 0E
    dw 201, 084                             // 0F
    dw 243, 084                             // RR
    
    // sorted by stage id
    icon_table:
    dw Data.icon_peachs_castle
    dw Data.icon_sector_z
    dw Data.icon_congo_jungle
    dw Data.icon_planet_zebes
    dw Data.icon_hyrule_castle
    dw Data.icon_yoshis_island
    dw Data.icon_dream_land
    dw Data.icon_saffron_city
    dw Data.icon_mushroom_kingdom
    dw Data.icon_dream_land_beta_1
    dw Data.icon_dream_land_beta_2
    dw Data.icon_how_to_play
    dw Data.icon_mini_yoshis_island
    dw Data.icon_meta_crystal
    dw Data.icon_battlefield
    dw OS.NULL                              // Race to the Finish (Placeholder)
    dw Data.icon_final_destination

    icon_random:
    dw Data.icon_random

} // __CE__

    ////////////////////////////////////////////////////////////////////////////////////////////////
    // Logic for Both
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // @ Descirption
    // Row the cursor is on
    row:
    dw 0

    // @ Descirption
    // column the cursor is on
    column:
    dw 0

    // @ Descirption
    // Toggle for frozen mode.
    frozen_mode:
    dw OS.FALSE

    // @ Descirption
    // Prevents series logo from being drawn on wood circle
    OS.patch_start(0x0014E418, 0x801328A8)
    jr      ra                              // return immediately
    nop
    OS.patch_end()

    // @ Description
    // Prevents the drawing of defaults icons
    OS.patch_start(0x0014E098, 0x80132528)
    jr      ra                              // return
    nop
    OS.patch_end()

    // @ Descirption
    // Prevents "Stage Select" texture from being drawn.
    OS.patch_start(0x0014DDF8, 0x80132288)
    jr      ra                              // return immediately
    nop
    OS.patch_end()

    // @ Descirption
    // Prevents the wooden circle from being drawn.
    OS.patch_start(0x0014DBB8, 0x80132048)
    //jr      ra                              // return immediately
    //nop
    OS.patch_end()

    // @ Descirption
    // Prevents stage name text from being drawn.
    OS.patch_start(0x0014E2A8, 0x80132738)
    jr      ra                              // return immediately
    nop
    OS.patch_end()

    // Modifies the x/y position of the models on the stage select screen.
    OS.patch_start(0x0014F514, 0x801339A4)
//  lwc1    f16,0x0000(v0)                  // original line 1 (f16 = (float) x)
//  swc1    f16,0x0048(a0)                  // original line 2
//  lwc1    f18,0x0004(v0)                  // original line 3 (f18 = (float) y)
//  swc1    f18,0x004C(a0)                  // original line 4
    lui     t8, 0x44C8                      // t8 = (float) 1600S
    sw      t8, 0x0048(a0)                  // x = 1600
    sw      t8, 0x004C(a0)                  // y = 1600
    nop
    OS.patch_end()

    // @ Descirption
    // These following functions are designed to fix get_preview for RANDOM.
    scope random_fix_1_: {
        OS.patch_start(0x0014EF2C, 0x801333BC)
        j       random_fix_1_
        nop
        _random_fix_1_return:
        OS.patch_end()

        addiu   at, r0, 0x00DE                  // original line 1
        or      s0, a0, r0                      // original line 2

        addiu   sp, sp,-0x0010                  // allocate stack space
        sw      v0, 0x0004(sp)                  // ~
        sw      ra, 0x0008(sp)                  // restore registers

        jal     get_stage_id_                   // v0 = stage_id
        nop
        move    a0, v0                          // a0 = stage_id

        lw      v0, 0x0004(sp)                  // ~
        lw      ra, 0x0008(sp)                  // restore registers
        addiu   sp, sp, 0x0010                  // deallocate stack space
        j       _random_fix_1_return            // return
        nop
    }

    scope random_fix_2_: {
        OS.patch_start(0x0014EFA4, 0x80133434)
        j       random_fix_2_
        nop
        _random_fix_2_return:
        OS.patch_end()

//      lli     at, 0x00DE                      // original line 1
//      beq     s0, at, 0x80133464              // original line 2
        
        addiu   sp, sp,-0x0010                  // allocate stack space
        sw      ra, 0x0004(sp)                  // ~
        sw      v0, 0x0008(sp)                  // save registers

        jal     get_stage_id_                   // v0 = stage_id
        nop
        lli     at, 0x00DE
        beq     at, v0, _take_branch
        nop

        _default:
        lw      ra, 0x0004(sp)                  // ~
        lw      v0, 0x0008(sp)                  // restore registers
        addiu   sp, sp, 0x0010                  // deallocate stack
        j       _random_fix_2_return
        nop

        _take_branch:
        lw      ra, 0x0004(sp)                  // ~
        lw      v0, 0x0008(sp)                  // restore registers
        addiu   sp, sp, 0x0010                  // deallocate stack
        j       0x80133464                      // (from original line 2)
        nop
    }

    scope random_fix_3_: {
        OS.patch_start(0x0014E950, 0x80132DE0)
        j       random_fix_3_
        nop
        _random_fix_3_return:
        OS.patch_end()

//      bne     v1, at, 0x80132E18              // original line 1
//      lui     t0, 0x8013                      // original line 2

        addiu   sp, sp,-0x0010                  // allocate stack space
        sw      ra, 0x0004(sp)                  // ~
        sw      v0, 0x0008(sp)                  // save registers

        jal     get_stage_id_                   // v0 = stage_id
        nop
        bne     at, v0, _take_branch
        nop

        _default:
        lw      ra, 0x0004(sp)                  // ~
        lw      v0, 0x0008(sp)                  // restore registers
        addiu   sp, sp, 0x0010                  // deallocate stack
        j       _random_fix_3_return            // return
        nop

        _take_branch:
        lw      ra, 0x0004(sp)                  // ~
        lw      v0, 0x0008(sp)                  // restore registers
        addiu   sp, sp, 0x0010                  // deallocate stack
        j       0x80132E18                      // (from original line 1)
        nop
    }

    // @ Descirption
    // Modifies the zoom of the model previews.
    scope set_zoom_: {
        OS.patch_start(0x0014ECE4, 0x80133174)
//      lwc1    f4, 0x0000(v1)              // original line 1
        j       set_zoom_
        or      v0, s0, r0                  // original line 2
        _set_zoom_return:
        OS.patch_end()

        addiu   sp, sp,-0x00010             // allocate stack space
        sw      ra, 0x0004(sp)              // ~
        sw      v0, 0x0008(sp)              // ~
        sw      t0, 0x000C(sp)              // save registesr

        jal     get_stage_id_               // v0 = stage_id
        nop
        sll     v0, v0, 0x0002              // v0 = stage_id * sizeof(word)
        li      t0, zoom_table              // ~
        addu    t0, t0, v0                  // t0 = address of zoom
        lw      t0, 0x0000(t0)              // t0 = zoom
        mtc1    t0, f4                      // f4 = zoom
        swc1    f4, 0x0000(v1)              // update all zoom

        lw      ra, 0x0004(sp)              // ~
        lw      v0, 0x0008(sp)              // ~
        lw      t0, 0x000C(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        j       _set_zoom_return
        nop
    }

    // @ Descirption
    // This functions modifies which preview file is drawn based on stage_table
    scope get_preview_: {
        OS.patch_start(0x0014E708, 0x80132B98)
        j       get_preview_
        nop
        _get_preview_return:
        OS.patch_end()

        addiu   sp, sp,-0x0010                  // allocate stack space
        sw      ra, 0x0004(sp)                  // ~
        sw      t0, 0x0008(sp)                  // ~
        sw      v0, 0x000C(sp)                  // save registers

        jal     get_stage_id_                   // v0 = stage_id
        nop
        sll     v0, v0, 0x0002                  // t0 = offset << 2 (offset * 4)
        li      t0, preview_table               // ~
        addu    t0, v0, t0                      // t0 = address of file/preview

        addu    v1, t6, t7                      // original line 1
//      lw      a0, 0x0000(v1)                  // original line 2 
        lw      a0, 0x0000(t0)                  // a0 - file preview id

        lw      ra, 0x0004(sp)                  // ~
        lw      t0, 0x0008(sp)                  // ~
        lw      v0, 0x000C(sp)                  // resore registers
        addiu   sp, sp, 0x0010                  // deallocate stack space
        j       _get_preview_return             // return
        nop
    }

    // @ Descirption
    // This functions modifies which preview type is used based on stage_table
    scope get_type_: {
        OS.patch_start(0x0014E720, 0x80132BB0)
        j       get_type_
        nop
        _get_type_return:
        OS.patch_end()

        addiu   sp, sp,-0x0010                  // allocate stack space
        sw      ra, 0x0004(sp)                  // ~
        sw      t0, 0x0008(sp)                  // ~
        sw      v0, 0x000C(sp)                  // save registers

        jal     get_stage_id_                   // v0 = stage_id
        nop
        sll     v0, v0, 0x0002                  // t0 = offset << 2 (offset * 4)
        li      t0, type_table                  // ~
        addu    t0, v0, t0                      // t0 = address of file/preview
        lw      t8, 0x0000(t0)                  // t8 = type

        lw      ra, 0x0004(sp)                  // ~
        lw      t0, 0x0008(sp)                  // ~
        lw      v0, 0x000C(sp)                  // resore registers
        addiu   sp, sp, 0x0010                  // deallocate stack space
        lui     at, 0x8013                      // original line 1
//      lw      t8, 0x0004(v1)                  // original line 2
        j       _get_type_return                // return
        nop
    }

    // @ Descirption
    // Draw stage icons to the screen
    scope draw_icons_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      t2, 0x000C(sp)              // ~
        sw      t3, 0x0010(sp)              // ~
        sw      t4, 0x0014(sp)              // ~
        sw      ra, 0x0018(sp)              // ~
        sw      at, 0x001C(sp)              // save registers

        _setup:
        lli     at, NUM_ICONS               // at = number of icons to draw
        li      t0, icon_table              // t0 = address of icon_table
        li      t1, position_table          // t1 = address of position_table
        lli     t2, 0x0000                  // t2 = index
        li      t3, stage_table             // t3 = address of stage_table

        _draw_icon:
        sltiu   at, t2, NUM_ICONS           // ~
        beqz    at, _end                     // check to stop drawing stage icons
        nop
        lw      a0, 0x0000(t1)              // a0 - ulx
        lw      a1, 0x0004(t1)              // a1 - uly
        addu    t4, t3, t2                  // t4 = address of stage_table[index]
        lbu     t4, 0x0000(t4)              // t4 = stage_id

        // this intereupts flow to check for random
        lli     at, id.RANDOM               // at = id.RANDOM
        bne     t4, at, _not_random         // if (stage_id != id.RANDOM), skip
        nop
        li      t4, icon_random             // ~
        lw      t4, 0x0000(t4)              // t4 = icon_random image address
        b       _continue
        nop

        _not_random:
        sll     t4, t4, 0x0002              // t4 = stage_id * 4 (aka stage_id * sizeof(void *))
        addu    t4, t0, t4                  // t4 = address of icon_table + offset
        lw      t4, 0x0000(t4)              // t4 = address of image data

        _continue:
        li      a2, info                    // a2 - address of texture struct
        sw      t4, 0x00008(a2)             // update info image data
        jal     Overlay.draw_texture_       // draw icon
        nop

        _increment:
        addiu   t1, t1, 0x0008              // increment position_table
        addiu   t2, t2, 0x0001              // increment index
        b       _draw_icon                  // draw next icon
        nop

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      t2, 0x000C(sp)              // ~
        lw      t3, 0x0010(sp)              // ~
        lw      t4, 0x0014(sp)              // ~
        lw      ra, 0x0018(sp)              // ~
        lw      at, 0x001C(sp)              // restore registers
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop

        info:
        Texture.info(ICON_WIDTH, ICON_HEIGHT)
    }

    // @ Descirption
    // This replaces the previous the original draw cursor function. The new function draws based on
    // the Stages.row and Stages.column variables as well as the position_table. It also replaces
    // the cursor itself with a filled rectangle
    scope draw_cursor_: {

        // @ Descirption
        // Set original cursor position.
        OS.patch_start(0x0014E5C8, 0x80132A58)
        // not used, for documentation only
        OS.patch_end()

        // @ Descirption
        // (part of set cursor position)
        OS.patch_start(0x0014E5F4, 0x80132A84)
//      lui     at, 0x41B8                  // original line (at = (float cursor y))
        lui     at, 0xC800                  // at =  a very negative float
        OS.patch_end()

        // @ Descirption
        // (part of set cursor position)
        OS.patch_start(0x0014E62C, 0x80132ABC)
//      lui     at, 0x4274                  // original line (at = (float cursor y))
        lui     at, 0xC800                  // at =  a very negative float
        OS.patch_end()

        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // save registesr

        // this block gets the position
        jal     get_index_                  // v0 = index
        nop
        sll     v0, v0, 0x0003              // v0 = index *= sizeof(position_table entry) = offset
        li      t0, position_table          // ~
        addu    t0, t0, v0                  // t0 = position_table + offset

        // this block selects color based of rectangle (based on frozen mode)
        li      at, frozen_mode             // ~
        lw      at, 0x0000(at)              // t0 = frozen mode
        beqz    at, _skip
        lli     a0, Color.low.RED           // a0 - fill color
        lli     a0, Color.low.BLUE          // a0 - fill color

        _skip:
        // this block draws the cursor (with a border of 2)
        jal     Overlay.set_color_          // fill color = RED
        nop
        lw      a0, 0x0000(t0)              // a0 - ulx
        addiu   a0, a0,-0x0002              // decrement ulx
        lw      a1, 0x0004(t0)              // a1 - uly
        addiu   a1, a1,-0x0002              // decrement uly
        lli     a2, ICON_WIDTH + 4          // a2 - width
        lli     a3, ICON_HEIGHT + 4         // a3 - height
        jal     Overlay.draw_rectangle_     // draw curso
        nop

        lw      t0, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack sapce
        jr      ra                          // return
        nop
    }

    scope draw_names_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      a0, 0x0004(sp)              // ~
        sw      a1, 0x0008(sp)              // ~
        sw      a2, 0x000C(sp)              // ~
        sw      v0, 0x0010(sp)              // ~
        sw      ra, 0x0014(sp)              // save registers

        // this block draws "19XX <version>"
        lli     a0, 194                     // a0 - ulx
        lli     a1, 130                     // a1 - uly
        li      a2, string_title            // a2 - address of string
        jal     Overlay.draw_string_        // draw string
        nop

        // this block draws "<stage_name>"
        jal     get_stage_id_               // v0 = stage_id
        nop
        lli     a0, id.RANDOM               // a0 = random
        beq     a0, v0, _end                // don't draw RANDOM
        nop
        sll     v0, v0, 0x0002              // v0 = offset = stage_id * 4
        li      a0, string_x_pos_table      // a0 = address of string_x_pos_table
        addu    a0, a0, v0                  // a0 = address of string_x_pos_table + offset
        lw      a0, 0x0000(a0)              // a0 - ulx
        lli     a1, 195                     // a1 - uly
        li      a2, string_table            // a2 = address of string_table
        addu    a2, a2, v0                  // a2 = address of string_table + offset
        lw      a2, 0x0000(a2)              // a2 - adress of string
        jal     Overlay.draw_string_        // draw string
        nop

        _end:
        lw      a0, 0x0004(sp)              // ~
        lw      a1, 0x0008(sp)              // ~
        lw      a2, 0x000C(sp)              // ~
        lw      v0, 0x0010(sp)              // ~
        lw      ra, 0x0014(sp)              // restore registers
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop

        if !{defined __G6__} {
        string_title:
        String.insert("19XX 1.2")
        }

        if {defined __G6__} {
        string_title:
        String.insert("G6 READY")
        }
    }

    // @ Descirption
    // Returns an index based on column and row
    // @ Returns
    // v0 - index
    scope get_index_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      t2, 0x000C(sp)              // save registers

        li      t0, row                     // ~
        lw      t0, 0x0000(t0)              // t0 = row
        li      t1, column                  // ~
        lw      t1, 0x0000(t1)              // t1 = column
        lli     t2, NUM_COLUMNS             // t2 = NUM_COLUMNS
        multu   t0, t2                      // ~
        mflo    v0                          // v0 = row * NUM_COLUMNS
        addu    v0, v0, t1                  // v0 = row * NUM_COLUMNS + column

        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      t2, 0x000C(sp)              // restre registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra
        nop
    }

    // @ Descirption
    // returns a stage id based on cursor position
    // @ Returns
    // v0 - stage_id
    scope get_stage_id_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // save registers

        jal     get_index_                  // v0 = index
        nop
        li      t0, stage_table             // t0 = address of stage table
        addu    t0, t0, v0                  // t0 = address of stage table + offset
        lbu     v0, 0x0000(t0)              // v0 = ret = stage_id

        lw      t0, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Descirption
    // This is what Overlay.HOOKS_GO_HERE_ calls. It is the main() of Stages.asm
    scope run_: {
        addiu   sp, sp,-0x0020              // allocate stack space
        sw      ra, 0x0004(sp)              // ~
        sw      a0, 0x0008(sp)              // ~
        sw      a1, 0x000C(sp)              // ~
        sw      a2, 0x0010(sp)              // ~
        sw      v0, 0x0014(sp)              // ~
        sw      t0, 0x0018(sp)              // ~
        sw      t1, 0x001C(sp)              // save registers

        // check for z/r press to toggle frozen mode
        li      a0, Joypad.Z                // a0 - button mask
        li      a2, Joypad.PRESSED          // a2 - type
        jal     Joypad.check_buttons_all_   // v0 = l/r pressed
        nop
        beqz    v0, _draw                   // if not pressed, skip
        nop
        li      t0, frozen_mode             // t0 = address of frozen mode
        lw      t1, 0x0000(t0)              // t1 = frozen_mode
        xori    t1, t1, 0x0001              // 0 -> 1 or 1 -> 0
        sw      t1, 0x0000(t0)
        lli     a0, FGM.menu.TOGGLE         // a0 - fgm_id
        jal     FGM.play_                   // play menu sound
        nop

        _draw:
        jal     draw_cursor_                // draw selection cursor
        nop

        jal     draw_icons_                 // draw stage icons
        nop

        jal     draw_names_                 // draw stage names
        nop

        lw      ra, 0x0004(sp)              // ~
        lw      a0, 0x0008(sp)              // ~
        lw      a1, 0x000C(sp)              // ~
        lw      a2, 0x0010(sp)              // ~
        lw      v0, 0x0014(sp)              // ~
        lw      t0, 0x0018(sp)              // ~
        lw      t1, 0x001C(sp)              // restore registers
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Descirption
    // Equivalent of _update_right_return.
    constant update_(0x80134210)

    // @ Descirption
    // The following update_<direction>_ functions update Stages.row/Stages.column. Thee functions
    // use in game hooks (play_sound_ is conserved). The original cursor_id is set to 1 when
    // going left or right to avoid bugs with RANDOM.
    scope update_right_: {
        OS.patch_start(0x0014FD78, 0x80134208)
        j       update_right_
        nop
        _update_right_return:
//      lw      v1, 0x0000(a1)              // original line 3
        lli     v1, 0x0001                  // v1 = spoofed cursor id
        OS.patch_end()

        lui     a1, 0x8013                  // original line 1
        addiu   a1, a1, 0x4BD8              // original line 2

        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      at, 0x000C(sp)              // save registers

        // check bounds
        li      t0, column                  // ~
        lw      t1, 0x0000(t0)              // t1 = column
        slti    at, t1, NUM_COLUMNS - 1     // if (column < NUM_COLUMNS - 1)
        bnez    at, _normal                 // then go to next colum
        nop

        // update cursor (go to first column)
        sw      r0, 0x0000(t0)              // else go to first column
        b       _end                        // skip to end
        nop

        // update cursor (go right one)
        _normal:
        addi    t1, t1, 0x0001              // t1 = column++
        sw      t1, 0x0000(t0)              // update column

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      at, 0x000C(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack sapce
        j       _update_right_return        // return
        nop
    }

    scope update_left_: {
        OS.patch_start(0x0014FC74, 0x80134104)
        j       update_left_
        nop
        _update_left_return:
//      lw      v1, 0x0000(a1)              // original line 3
        lli     v1, 0x0001                  // v1 = spoofed cursor id
        OS.patch_end()

        lui     a1, 0x8013                  // original line 1
        addiu   a1, a1, 0x4BD8              // original line 2

        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      at, 0x000C(sp)              // save registers

        // check bounds
        li      t0, column                  // ~
        lw      t1, 0x0000(t0)              // t1 = column
        bnez    t1, _normal                 // if (!first_column)
        nop

        // update cursor (go to last column)
        lli     t1, NUM_COLUMNS - 1         // ~
        sw      t1, 0x0000(t0)              // else go to last column
        b       _end                        // skip to end
        nop

        // update cursor (go left one)
        _normal:
        addi    t1, t1,-0x0001              // t1 = column--
        sw      t1, 0x0000(t0)              // update column

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      at, 0x000C(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack sapce
        j       _update_left_return         // return
        nop
    }

    scope update_down_: {
        OS.patch_start(0x0014FBA4, 0x80134034)
        j       update_down_
        nop
        _update_down_return:
        OS.patch_end()

        lui     v1, 0x8013                  // original line 1
        lw      v1, 0x4BD8(v1)              // original line 2

        lui     a1, 0x8013                  // original line 1 (update_right_)
        addiu   a1, a1, 0x4BD8              // original line 2 (update_right_)
        
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      at, 0x000C(sp)              // save registers

        // check bounds
        li      t0, row                     // ~
        lw      t1, 0x0000(t0)              // t1 = row
        slti    at, t1, NUM_ROWS - 1        // if (row < NUM_ROWS - 1)
        bnez    at, _normal                 // then go to next colum
        nop

        // update cursor (go to first row)
        sw      r0, 0x0000(t0)              // else go to first column
        b       _end                        // skip to end
        nop

        // update cursor (go down one)
        _normal:
        addi    t1, t1, 0x0001              // t1 = row++
        sw      t1, 0x0000(t0)              // update row

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      at, 0x000C(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack sapce
        j       update_                     // (go to right update bc down update sucks)
        nop
    }

    scope update_up_: {
        OS.patch_start(0x0014FAD0, 0x80133F60)
        j       update_up_
        nop
        _update_up_return:
        OS.patch_end()

        lui     v1, 0x8013                  // original line 1
        lw      v1, 0x4BD8(v1)              // original line 2
        
        lui     a1, 0x8013                  // original line 1 (update_right_)
        addiu   a1, a1, 0x4BD8              // original line 2 (update_right_)

        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      at, 0x000C(sp)              // save registers

        // check bounds
        li      t0, row                     // ~
        lw      t1, 0x0000(t0)              // t1 = row
        bnez    t1, _normal                 // if (!first_row)
        nop

        // update cursor (go to last row)
        lli     t1, NUM_ROWS - 1            // ~
        sw      t1, 0x0000(t0)              // else go to last row
        b       _end                        // skip to end
        nop

        // update cursor (go up one)
        _normal:
        addi    t1, t1,-0x0001              // t1 = row--
        sw      t1, 0x0000(t0)              // update row

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      at, 0x000C(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack sapce
        j       update_                     // (go to right update bc up update sucks)
        nop
    }

    // @ Descirption
    // Adds a stage to the random list if it's toggled on.
    // @ Arguments
    // a0 - address of entry (random stage entry)
    // a1 - stage id to add
    // @ Returns
    // v0 - bool was_added?
    // v1 - num_stages
    scope add_stage_to_random_list_: {
        addiu   sp, sp,-0x0010              // allocate stack sapce
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // save registers

        // this block checks to see if a stage should be added to the table. 
        _check_add:
        lli     v0, OS.FALSE                // v0 = false
        beqz    a0, _continue               // if entry is NULL, add stage
        lli     t0, OS.TRUE                 // set curr_value to true
        lw      t0, 0x0004(a0)              // t0 = curr_value
        
        _continue:
        li      v1, random_count            // ~
        lw      v1, 0x0000(v1)              // v1 = random_count
        beqz    t0, _end                    // end, return false and count
        nop

        // if the stage should be added, it is added here. count is also incremented here
        li      t0, random_count            // t0 = address of random_count
        lw      v1, 0x0000(t0)              // v1 = random_count
        sll     t1, v1, 0x0002              // t1 = offset = random_count * 4
        addiu   v1, v1, 0x0001              // v1 = random_count++
        sw      v1, 0x0000(t0)              // update random_count
        li      t0, random_table            // t0 = address of random_table
        addu    t0, t0, t1                  // t0 = random_table + offset
        sw      a1, 0x0000(t0)              // add stage
        lli     v0, OS.TRUE                 // v0 = true

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack sapce
        jr      ra                          // return
        nop
    }

    // @ Descirption
    // Macro to (maybe) add a stage to the random list.
    macro add_to_list(entry, stage_id) {
        li      a0, {entry}                 // a0 - address of entry
        lli     a1, {stage_id}              // a1 - stage id to add
        jal     add_stage_to_random_list_   // add stage
        nop
    }

    // @ Descirption
    // This function replaces the logic to convert the default cursor_id to a stage_id.
    // @ Returns
    // v0 - stage_id
    scope swap_stage_: {
        OS.patch_start(0x0014F774, 0x80133C04)
//      jal     0x80132430                  // original line 1
//      nop                                 // original line 2
        jal     swap_stage_
        nop
        OS.patch_end()

        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // ~
        sw      at, 0x000C(sp)              // save registers

        jal     get_stage_id_               // v0 = stage_id
        nop

        // this block checks if random is selected (if not stage_id is returned)
        _check_random:
        lli     t0, id.RANDOM               // t0 = id.RANDOM
        bne     v0, t0, _end                // if (stage_id != id.RANDOM), end
        nop

        li      t0, random_count            // ~
        sw      r0, 0x0000(t0)              // reset count

if {defined __TE__} {
        add_to_list(OS.NULL, id.PEACHS_CASTLE)
        add_to_list(OS.NULL, id.SECTOR_Z)
        add_to_list(OS.NULL, id.CONGO_JUNGLE)
        add_to_list(OS.NULL, id.PLANET_ZEBES)
        add_to_list(OS.NULL, id.HYRULE_CASTLE)
        add_to_list(OS.NULL, id.YOSHIS_ISLAND)
        add_to_list(OS.NULL, id.DREAM_LAND)
        add_to_list(OS.NULL, id.SAFFRON_CITY)
        add_to_list(OS.NULL, id.MUSHROOM_KINGDOM)
        add_to_list(OS.NULL, id.BATTLEFIELD)
        add_to_list(OS.NULL, id.FINAL_DESTINATION)
} // __TE__
        
if {defined __CE__} {
        add_to_list(Toggles.entry_random_stage_peachs_castle, id.PEACHS_CASTLE)
        add_to_list(Toggles.entry_random_stage_sector_z, id.SECTOR_Z)
        add_to_list(Toggles.entry_random_stage_congo_jungle, id.CONGO_JUNGLE)
        add_to_list(Toggles.entry_random_stage_planet_zebes, id.PLANET_ZEBES)
        add_to_list(Toggles.entry_random_stage_hyrule_castle, id.HYRULE_CASTLE)
        add_to_list(Toggles.entry_random_stage_yoshis_island, id.YOSHIS_ISLAND)
        add_to_list(Toggles.entry_random_stage_dream_land, id.DREAM_LAND)
        add_to_list(Toggles.entry_random_stage_saffron_city, id.SAFFRON_CITY)
        add_to_list(Toggles.entry_random_stage_mushroom_kingdom, id.MUSHROOM_KINGDOM)
        add_to_list(Toggles.entry_random_stage_battlefield, id.BATTLEFIELD)
        add_to_list(Toggles.entry_random_stage_final_destination, id.FINAL_DESTINATION)
        add_to_list(Toggles.entry_random_stage_dream_land_beta_1, id.DREAM_LAND_BETA_1)
        add_to_list(Toggles.entry_random_stage_dream_land_beta_2, id.DREAM_LAND_BETA_2)
        add_to_list(Toggles.entry_random_stage_how_to_play, id.HOW_TO_PLAY)
        add_to_list(Toggles.entry_random_stage_mini_yoshis_island, id.MINI_YOSHIS_ISLAND)
        add_to_list(Toggles.entry_random_stage_meta_crystal, id.META_CRYSTAL)
} // __CE__

        // this block loads from the random list using a random int
        move    a0, v1                      // a0 - range (0, N-1)
        jal     Global.get_random_int_      // v0 = (0, N-1)
        nop
        li      t0, random_table            // t0 = random_table
        sll     v0, v0, 0x0002              // v0 = offset = random_int * 4
        addu    t0, t0, v0                  // t0 = random_table + offset
        lw      v0, 0x0000(t0)              // v0 = stage_id
        b       _end                        // get a new stage id based off of random offset
        nop

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // ~
        lw      at, 0x000C(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Descirption
    // Table of stage IDs (as words, 32 bit values)
    random_table:
    fill 4 * 32                             // assumes there will never be more than 32 stages

    // @ Descirption
    // number of stages in random_table.
    random_count:
    dw 0

    // @ Description
    // This function fixes a bug that does not allow single player stages to be loaded in training.
    // SSB typically uses *0x800A50E8 to get the stage id. The stage id is then used to find the bg
    // file. This function switches gets a working stage id based on *0x800A50E8 and stores it in
    // expansion memory. That value is read from in two places
    scope training_id_fix_: {
        OS.patch_start(0x001145D0, 0x8018DDB0)
        addiu   sp, sp, 0xFFE8              // original line 3
        sw      ra, 0x0014(sp)              // original line 4
        jal     training_id_fix_
        nop
        OS.patch_end()

        OS.patch_start(0x0011462C, 0x8018DE0C)
        jal     training_id_fix_
        nop
        lui     t5, 0x8019                  // original line 3
        lui     t7, 0x8019                  // original line 4
        lbu     t3, 0x0001(t6)              // original line 5 modified
        OS.patch_end()

        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      t2, 0x000C(sp)              // save registers

        li      t0, 0x800A50E8              // ~
        lw      t0, 0x0000(t0)              // t0 = dereference 0x800A50E8
        lbu     t0, 0x0001(t0)              // t0 =  stage id
        li      t1, background_table        // t1 = stage id table (offset)
        addu    t1, t1, t0                  // t1 = stage id table + offset
        lbu     t0, 0x0000(t1)              // t0 = new working stage id
        li      t2, id                      // t2 = id
        sb      t0, 0x0000(t2)              // update stage id to working stage id

        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      t2, 0x000C(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        li      t6, id - 1                  // original line 1/2 modified
        jr      ra                          // return
        nop

        id:
        db 0x00                             // holds new stage id
        OS.align(4)
    }

    zoom_table:
    float32 0.4                         // Peach's Castle
    float32 0.2                         // Sector Z
    float32 0.5                         // Congo Jungle
    float32 0.4                         // Planet Zebes
    float32 0.3                         // Hyrule Castle
    float32 0.5                         // Yoshi's Island
    float32 0.4                         // Dream Land
    float32 0.4                         // Saffron City
    float32 0.2                         // Musrhoom Kingdom
    float32 0.5                         // Dream Land Beta 1
    float32 0.3                         // Dream Land Beta 2
    float32 0.5                         // How to Play
    float32 0.5                         // Mini Yoshi's Island
    float32 0.5                         // Meta Crystal
    float32 0.5                         // Battlefield
    float32 0.5                         // Race to the Finish (Placeholder)
    float32 0.5                         // Final Deestination

    background_table:
    db id.PEACHS_CASTLE                 // Peach's Castle
    db id.SECTOR_Z                      // Sector Z
    db id.CONGO_JUNGLE                  // Congo Jungle
    db id.PLANET_ZEBES                  // Planet Zebes
    db id.HYRULE_CASTLE                 // Hyrule Castle
    db id.YOSHIS_ISLAND                 // Yoshi's Island
    db id.DREAM_LAND                    // Dream Land
    db id.SAFFRON_CITY                  // Saffron City
    db id.MUSHROOM_KINGDOM              // Mushroom Kingdom
    db id.DREAM_LAND                    // Dream Land Beta 1
    db id.DREAM_LAND                    // Dream Land Beta 2
    db id.DREAM_LAND                    // How to Play
    db id.YOSHIS_ISLAND                 // Yoshi's Island (1P)
    db id.SECTOR_Z                      // Meta Crystal
    db id.SECTOR_Z                      // Batlefield
    db 0xFF                             // Race to the Finish (Placeholder)
    db id.SECTOR_Z                      // Final Destination
    OS.align(4)

    preview_table:
    dw file.PEACHS_CASTLE
    dw file.SECTOR_Z
    dw file.CONGO_JUNGLE
    dw file.PLANET_ZEBES
    dw file.HYRULE_CASTLE
    dw file.YOSHIS_ISLAND
    dw file.DREAM_LAND
    dw file.SAFFRON_CITY
    dw file.MUSHROOM_KINGDOM
    dw file.DREAM_LAND_BETA_1
    dw file.DREAM_LAND_BETA_2
    dw file.HOW_TO_PLAY
    dw file.MINI_YOSHIS_ISLAND
    dw file.META_CRYSTAL
    dw file.BATTLEFIELD
    dw file.RACE_TO_THE_FINISH
    dw file.FINAL_DESTINATION

    type_table:
    dw type.PEACHS_CASTLE
    dw type.SECTOR_Z
    dw type.CONGO_JUNGLE
    dw type.PLANET_ZEBES
    dw type.HYRULE_CASTLE
    dw type.YOSHIS_ISLAND
    dw type.DREAM_LAND
    dw type.SAFFRON_CITY
    dw type.MUSHROOM_KINGDOM
    dw type.DREAM_LAND_BETA_1
    dw type.DREAM_LAND_BETA_2
    dw type.HOW_TO_PLAY
    dw type.MINI_YOSHIS_ISLAND
    dw type.META_CRYSTAL
    dw type.BATTLEFIELD
    dw type.RACE_TO_THE_FINISH
    dw type.FINAL_DESTINATION

    string_peachs_castle:;          String.insert("Peach's Castle")
    string_sector_z:;               String.insert("Sector Z")
    string_congo_jungle:;           String.insert("Congo Jungle")
    string_planet_zebes:;           String.insert("Planet Zebes")
    string_hyrule_castle:;          String.insert("Hyrule Castle")
    string_yoshis_island:;          String.insert("Yoshi's Island")
    string_dream_land:;             String.insert("Dream Land")
    string_saffron_city:;           String.insert("Saffron City")
    string_mushroom_kingdom:;       String.insert("Mushroom Kingdom")
    string_dream_land_beta_1:;      String.insert("Dream Land Beta 1")
    string_dream_land_beta_2:;      String.insert("Dream Land Beta 2")
    string_how_to_play:;            String.insert("How to Play")
    string_mini_yoshis_island:;     String.insert("Mini Yoshi's Island")
    string_meta_crystal:;           String.insert("Meta Crystal")
    string_battlefield:;            String.insert("Battlefield")
    string_final_destination:;      String.insert("Final Destination")

    string_table:
    dw string_peachs_castle
    dw string_sector_z
    dw string_congo_jungle
    dw string_planet_zebes
    dw string_hyrule_castle
    dw string_yoshis_island
    dw string_dream_land
    dw string_saffron_city
    dw string_mushroom_kingdom
    dw string_dream_land_beta_1
    dw string_dream_land_beta_2
    dw string_how_to_play
    dw string_mini_yoshis_island
    dw string_meta_crystal
    dw string_battlefield
    dw string_dream_land                    // Race to the Finish (Placeholder)
    dw string_final_destination

    string_x_pos_table:
    dw 174                              // Peach's Castle
    dw 194                              // Sector Z
    dw 182                              // Congo Jungle
    dw 182                              // Planet Zebes
    dw 178                              // Hyrule Castle
    dw 174                              // Yoshi's Island
    dw 190                              // Dream Land
    dw 182                              // Saffron City
    dw 166                              // Mushroom Kingdom
    dw 162                              // Dream Land Beta 1
    dw 162                              // Dream Land Beta 2
    dw 186                              // How to Play
    dw 158                              // Mini Yoshi's Island
    dw 182                              // Meta Crystal
    dw 186                              // Battlefield
    dw 190                              // Dream Land (Race to the Finish Placeholder)
    dw 162                              // Final Destination
}

} // __STAGES__