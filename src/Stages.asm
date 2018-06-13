// Stages.asm
if !{defined __STAGES__} {
define __STAGES__()

include "Color.asm"
include "Data.asm"
include "OS.asm"
include "Overlay.asm"
include "Texture.asm"

// @ Descirption
// This file expands the stage select screen to 18 stages.

// PAGE 1
// [00] [01] [02] [03] [04]
// [05] [06] [07] [08] [RR]

// PAGE 2
// [09] [0A] [0B] [0C] [0D]
// [0E] [0F] [10] [11] [RR]

// Viable Stage (Most Viable at the Top)
// 00 - Dream Land
// 01 - Battlefield
// 02 - Pokemon Stadium (Dream Land Beta 1)
// 03 - Smashville (How to Play)
// 04 - Final Destination
// Somewhat Viable Stages (Most Viable at the Top)
// 05 - Wario Ware
// 06 - Lylatt
// 07 - Metal Cavern
// 08 - Peach's Castle

// Alphabetical
// 09 - Congo Jungle
// 0A - Dream Land Beta 2
// 0B - Hyrule Castle
// 0C - Planet Zebes
// 0D - Mushroom Kingdom
// 0E - Saffron City
// 0F - Sector Z
// 10 - Yoshi's Island
// 11 - Yoshi's Island (Cloudless)

include "OS.asm"

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

    // @ Descirption
    // Variable for which page the SSS is on
    page:
    dw 0x00000000

    // @ Descirption
    // Coordinates of stage icons in vanilla Super Smash Bros.
    position_table:
    // row1
    dw 030, 030
    dw 080, 030
    dw 130, 030
    dw 180, 030
    dw 380, 030

    // row2
    dw 030, 030
    dw 080, 030
    dw 130, 030
    dw 180, 030
    dw 380, 030

    // sorted by stage id
    icon_table:
    dw OS.NULL                              // 0x0000 - Peach's Castle
    dw OS.NULL                              // 0x0004 - Sector Z
    dw OS.NULL                              // 0x0008 - Congo Jungle
    dw OS.NULL                              // 0x000C - Hyrule Castle
    dw OS.NULL                              // 0x0010 - Yoshi's Island
    dw OS.NULL                              // 0x0014 - Dream Land
    dw OS.NULL                              // 0x0018 - Saffron City
    dw OS.NULL                              // 0x001C - Musrhoom Kingdom
    dw OS.NULL                              // 0x0020 - Dream Land Beta 1
    dw OS.NULL                              // 0x0024 - Dream Land Beta 2
    dw OS.NULL                              // 0x0028 - How to Play
    dw OS.NULL                              // 0x002C - Yoshi's Island Cloudless
    dw OS.NULL                              // 0x0030 - Metal Cavern
    dw OS.NULL                              // 0x0034 - Battlefield
    dw 0xFFFFFFFF                           // 0x0038 - Race to the Finish (Placeholder)
    dw OS.NULL                              // 0x003C - Final Deestination

    // @ Descirption
    // Puts stage icons into RAM
    scope allocate_icons_: {
        addiu   sp, sp,-0x0008              // allocate stack sapce
        sw      t0, 0x0000(sp)              // save t0
        sw      ra, 0x0004(sp)              // save ra

        li      t0, icon_table              // t0 = address of icon_table

        li      a0, Data.icon_peachs_castle // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0000(t0)              // store icon address

        li      a0, Data.icon_sector_z      // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0004(t0)              // store icon address

        li      a0, Data.icon_congo_jungle  // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0008(t0)              // store icon address

        li      a0, Data.icon_hyrule_castle // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x000C(t0)              // store icon address

        li      a0, Data.icon_yoshis_island // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0010(t0)              // store icon address

        li      a0, Data.icon_dream_land    // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0014(t0)              // store icon address

        li      a0, Data.icon_saffron_city  // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0018(t0)              // store icon address

        li      a0, Data.icon_mushroom_kingdom
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x001C(t0)              // store icon address

        li      a0, Data.icon_dream_land_beta_1
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0020(t0)              // store icon address

        li      a0, Data.icon_dream_land_beta_2
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0024(t0)              // store icon address

        li      a0, Data.icon_how_to_play   // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0028(t0)              // store icon address

        li      a0, Data.icon_yoshis_island_cloudless
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x002C(t0)              // store icon address

        li      a0, Data.icon_metal_cavern  // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0030(t0)              // store icon address

        li      a0, Data.icon_battlefield   // a0 - texture struct
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x0034(t0)              // store icon address

        li      a0, Data.icon_final_destination
        jal     Texture.allocate_           // put icon into RAM
        nop
        sw      v0, 0x003C(t0)              // store icon address

        lw      t0, 0x0000(sp)              // restore t0
        lw      ra, 0x0004(sp)              // restore ra
        addiu   sp, sp, 0x0008              // allocate stack sapce
        jr      ra
        nop
    }

    // @ Descirption
    // Draw stage icons to the screen
    scope draw_icons_: {



    }

    scope get_preview_: {
        OS.patch_start(0x0014E704, 0x80132B94)

        OS.patch_end()
    }

    scope get_type_: {
        OS.patch_start(0x0014E704, 0x80132B94)

        OS.patch_end()
    }

    scope get_franchise_: {
        OS.patch_start(0x0014E4C0, 0x80132950)

        OS.patch_end()
    }

    scope get_name_: {
        OS.patch_start(0x0014E2F8, 0x80132788)

        OS.patch_end()
    }

    // SSS Start
    // a0 = stage id
    // a1 = cursor id
    //801328A8

    // OLD
    // @ Description
    // The following patches modify the stage loading instructions to allow for stage not usually
    // in versus to be loaded.
    // @ TODO
    // Update this...
    OS.patch_start(0x0014F77C, 0x80130D0C)
    lb      v0, 0x0000(t2)                  // load custom byte from stage table
    lui     s1, 0x800A                      // ~
    sb      v0, 0x4ADF(s1)                  // store custom byte
    OS.patch_end()

    OS.patch_start(0x0014DFFC, 0x00000000)
    lb      v0, 0x0003(t2)                  // modified stage load instruction
    OS.patch_end()

    OS.patch_start(0x0014F7A4, 0x80133C34)
    sb      v0, 0x4B11(s1)                  // remember sss cursor
    OS.patch_end()

    OS.patch_start(0x0014F7C4, 0x00000000)
    sb      v0, 0x4B12(s1)                  // [tehz]
    OS.patch_end()

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


    _loopInc:
    addiu   v0, v0, 0x0001
    beq     r0, r0, _loop
    addiu   at, at, 0x0004

    _end:
    jr      ra
    nop

    _fail:
    jr      ra
    or      v0, r0, r0
    OS.patch_end()

    // @ Description
    // This
    OS.patch_start(0x001501B4, 0x00000000)
    dw 0x00000000
    dw 0x02000002
    dw 0x04000004
    dw 0x0D000003
    dw 0x10000008
    dw 0x0C000005
    dw 0x06000006
    dw 0x0e000001
    dw 0x07000007
    OS.patch_end()

    // @ Description
    // This table includes <stage_file_id> and <type> where 
    OS.patch_start(0x00150054, 0x00000000)
    dw 0x00000103, 0x00000014
    dw 0x0000010C, 0x00000014
    dw 0x00000105, 0x00000014
    dw 0x0000010D, 0x00000014
    dw 0x00000109, 0x00000014
    dw 0x00000107, 0x00000014
    dw 0x000000FF, 0x00000014
    dw 0x00000108, 0x00000014
    dw 0x0000010A, 0x00000000
    OS.patch_end()

    // @ Descirption
    // This is a bug fix for the current stage table.
    OS.patch_start(0x0014F764, 0x80133BF4)
    sll     s0, s0, 0x0002
    addu    s0, ra, s0
    b       0x80133C14
    lb      v0, 0x0A5C(s0)
    OS.patch_end()


    // @ Description
    // This updates a table of floats for the stage previews.
    OS.patch_start(0x001503CC, 0x00000000)
    float32 0.5
    OS.patch_end()

    OS.patch_start(0x001503E8, 0x00000000)
    float32 0.5
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