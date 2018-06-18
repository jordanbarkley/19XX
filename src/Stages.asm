// Stages.asm
if !{defined __STAGES__} {
define __STAGES__()

// @ Descirption
// This file expands the stage select screen to 16 stages.


// Example
// [00] [01] [02] [03] [04] [05]
// [06] [07] [08] [09] [0A] [0B]
// [RR] [0C] [0D] [0E] [0F] [RR]

// Viable Stage (Most Viable at the Top)
// 00 - Dream Land
// 01 - Battlefield
// 02 - Pokemon Stadium (Dream Land Beta 1)
// 03 - Smashville (How to Play)
// 04 - Final Destination
// 05 - Wario Ware (Dream Land Beta 2)

// Somewhat Viable Stages (Most Viable at the Top)
// 06 - Peach's Castle
// 07 - Congo Jungle
// 08 - Metal Cavern
// 09 - Hyrule Castle
// 0A - Yoshi's Island (Cloudless)
// 0B - Saffron City

// Alphabetical
// 0C - Planet Zebes
// 0D - Mushroom Kingdom
// 0E - Sector Z
// 0F - Yoshi's Island

include "Color.asm"
include "Data.asm"
include "Memory.asm"
include "OS.asm"
include "Overlay.asm"
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
        constant YOSHIS_ISLAND_CLOUDLESS(0x0C)
        constant METAL_CAVERN(0x0D)
        constant BATTLEFIELD(0x0E)
        constant RACE_TO_THE_FINISH(0x0F)
        constant FINAL_DESTINATION(0x10)
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
        constant YOSHIS_ISLAND_CLOUDLESS(0x14)
        constant METAL_CAVERN(0x14)
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
        constant YOSHIS_ISLAND_CLOUDLESS(0x010E)
        constant METAL_CAVERN(0x10D)
        constant BATTLEFIELD(0x010C)
        constant RACE_TO_THE_FINISH(0x0127)
        constant FINAL_DESTINATION(0x010A)
    }

    constant ICON_WIDTH(48)
    constant ICON_HEIGHT(36)
    constant NUM_ICONS(16)

    // @ Descirption
    // Coordinates of stage icons in vanilla Super Smash Bros.
    position_table:
    // row 0
    dw 013, 117
    dw 062, 117
    dw 111, 117
    dw 161, 117
    dw 210, 117
    dw 259, 117

    // row 1
    dw 013, 154
    dw 062, 154
    dw 111, 154
    dw 161, 154
    dw 210, 154
    dw 259, 154

    // row 2
    // dw 013, 191
    dw 062, 191
    dw 111, 191
    dw 161, 191
    dw 210, 191
    // dw 259, 191


    // sorted by stage id
    icon_table:
    dw OS.NULL                              // 0x0000 - Peach's Castle
    dw OS.NULL                              // 0x0004 - Sector Z
    dw OS.NULL                              // 0x0008 - Congo Jungle
    dw OS.NULL                              // 0x000C - Planet Zebes
    dw OS.NULL                              // 0x0010 - Hyrule Castle
    dw OS.NULL                              // 0x0014 - Yoshi's Island
    dw OS.NULL                              // 0x0018 - Dream Land
    dw OS.NULL                              // 0x001C - Saffron City
    dw OS.NULL                              // 0x0020 - Musrhoom Kingdom
    dw OS.NULL                              // 0x0024 - Dream Land Beta 1
    dw OS.NULL                              // 0x0028 - Dream Land Beta 2
    dw OS.NULL                              // 0x002C - How to Play
    dw OS.NULL                              // 0x0030 - Yoshi's Island Cloudless
    dw OS.NULL                              // 0x0034 - Metal Cavern
    dw OS.NULL                              // 0x0038 - Battlefield
    dw OS.NULL                              // 0x003C - Race to the Finish (Placeholder)
    dw OS.NULL                              // 0x0040 - Final Deestination

    // @ Descirption
    // Puts stage icons into RAM
    scope allocate_icons_: {
        addiu   sp, sp,-0x0010              // allocate stack sapce
        sw      t0, 0x0008(sp)              // save t0
        sw      ra, 0x0004(sp)              // save ra

        li      t0, icon_table              // t0 = address of icon_table

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_peachs_castle // a2 - ROM
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0000(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_sector_z      // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0004(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_congo_jungle  // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0008(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_planet_zebes  // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x000C(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_hyrule_castle // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0010(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_yoshis_island // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0014(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_dream_land    // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0018(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_saffron_city  // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x001C(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_mushroom_kingdom
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0020(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_dream_land_beta_1
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0024(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_dream_land_beta_2
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0028(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_how_to_play   // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x002C(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_yoshis_island_cloudless
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0030(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_metal_cavern  // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0034(t0)              // store icon address

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_battlefield   // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0038(t0)              // store icon address

        // Race to the Finish Not Included

        lli     a0, ICON_WIDTH              // a0 - width
        lli     a1, ICON_HEIGHT             // a1 - height
        li      a2, Data.icon_final_destination
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0040(t0)              // store icon address

        lw      t0, 0x0008(sp)              // restore t0
        lw      ra, 0x0004(sp)              // restore ra
        addiu   sp, sp, 0x0010              // allocate stack sapce
        jr      ra
        nop
    }

    // @ Description
    // Prevents the drawing of defaults icons and allocates our own instead
    OS.patch_start(0x0014E098, 0x80132528)
    addiu   sp, sp,-0x0008                  // allocate stack space
    sw      ra, 0x0004(sp)                  // save ra

    jal     Memory.reset_                   // reset memory
    nop

    jal     allocate_icons_
    nop

    lw      ra, 0x0004(sp)                  // restore ra
    addiu   sp, sp, 0x0008                  // deallocate stack sapce
    jr      ra                              // return
    nop
    OS.patch_end()

    // @ Descirption
    // Draw stage icons to the screen
    scope draw_icons_: {
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      t2, 0x000C(sp)              // ~
        sw      ra, 0x0010(sp)              // ~
        sw      at, 0x0014(sp)              // save registers


        _setup:
        lli     at, NUM_ICONS               // at = number of icons to draw
        li      t0, icon_table              // t0 = address of icon_table
        li      t1, position_table          // t1 = address of position_table

        _draw_icon:
        beqz    at, _end                    // check to stop drawing
        nop
        lw      a0, 0x0000(t1)              // a0 - ulx
        lw      a1, 0x0004(t1)              // a1 - uly
        lw      t2, 0x0000(t0)              // t2 = image data
        li      a2, info                    // a2 - address of texture struct
        sw      t2, 0x00008(a2)             // update info image data
        jal     Overlay.draw_texture_       // draw icon
        nop

        _increment:
        addiu   t0, t0, 0x0004              // increment icon table
        addiu   t1, t1, 0x0008              // increment position_table
        addiu   at, at,-0x0001              // decrement number of icons to draw
        b       _draw_icon                  // draw next icon
        nop

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      t2, 0x000C(sp)              // ~
        lw      ra, 0x0010(sp)              // ~
        lw      at, 0x0014(sp)              // restore registers
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop

        info:
        Texture.info(48, 36)
    }

    // @ Descirption
    // Disables the function that draw the preview model
    scope disable_model_: {
        OS.patch_start(0x0014EF24, 0x801333B4)
        jr      ra                          // return immediately
        nop
        OS.patch_end()
    }

    // @ Descirption
    // Prevents series logo from being drawn on wood circle
    OS.patch_start(0x0014E418, 0x801328A8)
    jr      ra                          // return immediately
    nop
    OS.patch_end()

    // @ Descirption
    // Prevents stage name text from being drawn.
    OS.patch_start(0x0014E2A8, 0x80132738)
    jr      ra                          // return immediately
    nop
    OS.patch_end()

    // @ Descirption
    // Prevents "Stage Select" texture from being drawn.
    OS.patch_start(0x0014DDF8, 0x80132288)
    jr      ra                          // return immediately
    nop
    OS.patch_end()

    // @ Descirption
    // Prevents the wooden circle from being drawn.
    OS.patch_start(0x0014DBB8, 0x80132048)
    jr      ra                          // return immediately
    nop
    OS.patch_end()


    scope get_name_: {
        OS.patch_start(0x0014E2F8, 0x80132788)

        OS.patch_end()
    }

    // SSS Start
    // a0 = stage id
    // a1 = cursor id
    // 801328A8

    // Draw Cursor
    // 80132ADC

    // @ Description
    // This is a fix written by tehz to update the cursor based on stage id instead of in a static
    // table. It's very nice.
    // @ TODO
    // document the function
    OS.patch_start(0x0014E02C, 0x00000000)
    lui     at, 0x8013
    ori     at, at, 0x4644
    or      v0, r0, r0

    _loop:
    lbu     t6, 0x0003(at)
    beq     t6, a0, _end

    _check:
    ori     t6, r0, 0x0008
    beq     t6, v0, _loop
    addiu   v0, v0, 0x0001
    beq     r0, r0, _loop
    addiu   at, at, 0x0004

    _end:
    jr      ra
    nop

    _fail:
    jr      ra
    or      v0, r0, r0

    _find:
    dw 0xFEDC98BA
    OS.patch_end()

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
        li      t1, table                   // t1 = stage id table (offset)
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

        table:
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
        db id.SECTOR_Z                      // Metal Cavern
        db id.SECTOR_Z                      // Batlefield
        db 0xFF                             // Race to the Finish (Placeholder)
        db id.SECTOR_Z                      // Final Destination
        OS.align(4)
    }
}

}