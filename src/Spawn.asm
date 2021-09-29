// Spawn.asm
if !{defined __SPAWN__} {
define __SPAWN__()
print "included Spawn.asm\n"

// @ Description
// This file alters spawn position for different circumstances such as Neutral Spawns.

include "Global.asm"
include "OS.asm"
include "Toggles.asm"
include "Stages.asm"

scope Spawn {

    // @ Description
    // hook to load respawn point. This fixes the lack of respawn points on the beta stages.
if {defined __CE__} {
    scope load_respawn_point_: {
        OS.patch_start(0x000780B0, 0x800FC8B0)
        j       load_respawn_point_
        nop
        _load_respawn_point_return:
        OS.patch_end()

        addiu   sp, sp,-0x0010              // allocate stack space
        sw      at, 0x0004(sp)              // ~
        sw      t0, 0x0008(sp)              // save registers

        // this block gets stage_id (mode dependent)
        li      at, Global.match_info       // ~
        lw      at, 0x0000(at)              // at = address of match info
        lbu     at, 0x0001(at)              // at = stage_id

        // this block checks for dream land beta 1 and 2
        lli     t0, Stages.id.DREAM_LAND_BETA_1
        beq     t0, at, _fix
        nop
        lli     t0, Stages.id.DREAM_LAND_BETA_2
        beq     t0, at, _fix
        nop

        _original:
        lh      t8, 0x0002(t7)              // original line 1
        mtc1    r0, f16                     // original line 2
        lw      at, 0x0004(sp)              // ~
        lw      t0, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        j       _load_respawn_point_return  // return
        nop

        _fix:
        sw      r0, 0x0000(a1)              // update x
        li      t0, 0x451DE000              // t0 = (float) 2526, from dream land
        sw      t0, 0x0004(a1)              // update y
        lw      at, 0x0004(sp)              // ~
        lw      t0, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // scrap the rest of the function
        nop

    }
} // __CE__

    // Neutral Spawns (2 or 3 plat stages)

    //                   ________
    //
    //        ___S1___             ___S2___
    // 
    //  _________S3___________________S4_________
    //  \_______________________________________/

    
    // Neutral Spawns (other stages)

    //
    //
    //
    // 
    //  ______S1______S3_________S4______S2______
    //  \_______________________________________/

    scope load_spawn_: {
        // a0 holds player
        // a1 holds table
        // 0x0000(a1) holds x
        // 0x0004(a1) holds y

        OS.patch_start(0x00076764, 0x800FAF64)
        j       Spawn.load_spawn_
        nop
        _load_spawn_return:
        OS.patch_end()

        addiu   sp, sp,-0x0020              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // ~
        sw      t2, 0x000C(sp)              // ~
        sw      t3, 0x0010(sp)              // ~
        sw      a0, 0x0014(sp)              // ~
        sw      v0, 0x0018(sp)              // ~
        sw      ra, 0x001C(sp)              // save registers
        
if {defined __CE__} {
        // this block checks if we're in training mode
        li      t0, Global.current_screen
        lbu     t0, 0x0000(t0)              // t0 = screen_id
        ori     t1, r0, 0x0036              // ~
        bne     t0, t1, _check_versus       // branch if screen_id != training mode
        nop

        // since we're in training mode, this block determines if we'll use original spawn
        // or the custom spawn in the training struct
        li      t0, Training.struct.table   // t0 = training mode struct table address
        sll     t1, a0, 0x2                 // t1 = offset (port * 4)
        add     t1, t1, t0                  // t1 = struct table + offset
        lw      t3, 0x0000(t1)              // t3 = port struct address
        lw      a0, 0x0010(t3)              // a0 = spawn_id
        slti    t2, a0, 0x4                 // t2 = 1 if spawn_id > 0x4; else t2 = 0
        li      t0, original_table          // t0 = spawn table
        li      t1, Training.stage          // t1 = training mode stage address
        bnez    t2, _load_spawn             // branch if t2 != 0 (load original spawn for training stage)
        nop
        addiu   t0, t3, 0x0014              // t0 = spawn_pos address
        j       _set_spawn                  // set spawn to spawn in table
        nop 
} // __CE__
        
        // at this point we know we're not in training mode
        // this block checks if we're in vs mode
        // if we're not in versus mode, we'll get an original spawn
        _check_versus:
        li      t0, Global.current_screen   // ~
        lbu     t0, 0x0000(t0)              // t0 = screen_id
        ori     t1, r0, 0x0016              // ~
        bne     t0, t1, _original_method    // branch if screen_id != vs mode (use original method of finding spawns)
        nop

        // at this point, we are sure we are in versus or training
        // the following toggle guard determines whether or not there is
        // a chance of getting a neutral spawn
        // (the branch to _guard and _toggle_off label allows bass to jump 
        // forward on failure)
        b       _guard
        nop
        _toggle_off:
        b       _load_original
        nop

        _guard:
        // Neutral spawns are always enabled in TE. They are toggleable in CE.
if {defined __CE__} {
        Toggles.guard(Toggles.entry_neutral_spawns, _toggle_off)
} // __CE__

        _setup:
        li      t0, team_table              // t0 = team_table
        li      t1, type_table              // t1 = typeTable

        // the following block get's the team of every player (if applicable)
        // as well as the type (0 = man, 1 = cpu, 2 = n/a) of each player
        // and stores them in a table
        _p1:
        li      t2, Global.vs.p1            // ~
        lb      t3, 0x0004(t2)              // t3 = team
        sb      t3, 0x0000(t0)              // store team
        lb      t3, 0x0002(t2)              // t3 = type
        sb      t3, 0x0000(t1)              // store type
        _p2:
        li      t2, Global.vs.p2            // ~
        lb      t3, 0x0004(t2)              // t3 = team
        sb      t3, 0x0001(t0)              // store team
        lb      t3, 0x0002(t2)              // t3 = type
        sb      t3, 0x0001(t1)              // store type
        _p3:
        li      t2, Global.vs.p3            // ~
        lb      t3, 0x0004(t2)              // t3 = team
        sb      t3, 0x0002(t0)              // store team
        lb      t3, 0x0002(t2)              // t3 = type
        sb      t3, 0x0002(t1)              // store type
        _p4:
        li      t2, Global.vs.p4            // ~
        lb      t3, 0x0004(t2)              // t3 = team
        sb      t3, 0x0003(t0)              // store team
        lb      t3, 0x0002(t2)              // t3 = type
        sb      t3, 0x0003(t1)              // store type

        // this block checks if we're in teams
        // if not, we skip all teams related functions
        _doubles:
        li      t0, Global.vs.teams         // ~
        lb      t0, 0x0000(t0)              // t0 = teams
        beqz    t0, _singles                // if (!teams), skip
        nop

        // setup for teams loop
        li      t0, valid_teams             // t0 = valid_teams table
        li      t1, team_table              // t1 = team_table
        lw      t1, 0x0000(t1)              // t1 = teams
        
        // this block loops through to see if a valid team combination
        // has been found. if so, we'll get a neutral spawn. otherwise,
        // we'll get an original spawn
        _teams_loop:
        lw      t2, 0x0000(t0)              // t2 = team_setup
        beqz    t2, _load_original          // exit if combo not found
        nop
        bnel    t1, t2, _teams_loop         // if (not a match), skip
        addiu   t0, t0, 0x0008              // t0 = team_table++
        add     t0, t0, a0                  // t0 = valid_team + playerOffset
        lb      a0, 0x0004(t0)              // a0 = update_player
        b       _load_neutral
        nop

        // setup for singles loop 
        // it's only checking for active vs inactive (cpu/player not important)
        _singles:
        li      t0, valid_singles           // t0 = valid_singles table
        li      t1, type_table              // t1 = type_table
        lw      t1, 0x0000(t1)              // t1 = teams
        li      t2, 0x02020202              // ~
        and     t1, t1, t2                  // mask so 0 = 0, 1 = 0, 2 = 2 

        // this block checks if we're in a 1v1
        // if not, we will just load an original spawn
        _singles_loop:
        lw      t2, 0x0000(t0)              // t2 = single_setup
        beqz    t2, _load_original          // exit if combo not found
        nop
        bnel    t1, t2, _singles_loop       // ~
        addiu   t0, t0, 0x0008              // ~
        add     t0, t0, a0                  // ~
        lb      a0, 0x0004(t0)              // a0 = updatedPlayer

        // load neutral spawn for versus stage
        _load_neutral:
        li      t0, neutral_table           // t0 = neutral_table
        li      t1, Global.vs.stage         // t1 = address of stageID
        b       _load_spawn                 // don't get original table
        nop

        // load neutral spawn for versus stage
        _load_original:
        li      t0, original_table          // t0 = original_table
        li      t1, Global.vs.stage         // t1 = address of stageId

        _load_spawn:
        lb      t1, 0x0000(t1)              // t1 = stageID
        sll     t1, t1, 0x0005              // t0 = stage offset
        add     t0, t0, t1                  // t0 = table + stage offset
        sll     t1, a0, 0x0003              // t1 = player offset
        add     t0, t0, t1                  // t1 = spawn to load address

        _set_spawn:
        lw      t1, 0x0000(t0)              // t1 = (int) xpos
        sw      t1, 0x0000(a1)              // update xpos
        lw      t1, 0x0004(t0)              // t1 = (int) xpos
        sw      t1, 0x0004(a1)              // update ypos

        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      t2, 0x000C(sp)              // ~
        lw      t3, 0x0010(sp)              // ~
        lw      a0, 0x0014(sp)              // ~
        lw      v0, 0x0018(sp)              // ~
        lw      ra, 0x001C(sp)              // restore registers
        addiu   sp, sp, 0x0020              // deallocate stack space
        jr      ra                          // return (we scrap the original function)
        nop

        _original_method:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // ~
        lw      t2, 0x000C(sp)              // ~
        lw      t3, 0x0010(sp)              // ~
        lw      a0, 0x0014(sp)              // ~
        lw      v0, 0x0018(sp)              // ~
        lw      ra, 0x001C(sp)              // restore registers
        addiu   sp, sp, 0x0020              // deallocate stack space
        lui     t6, 0x8013                  // original line 1
        j       _load_spawn_return          // use in game method for everything but VS. and training
        lw      t6, 0x1368(t6)              // original line 2

        team_table:
        db 0x00                             // p1 team
        db 0x00                             // p2 team
        db 0x00                             // p3 team
        db 0x00                             // p4 team

        type_table:
        db 0x00                             // p1 type
        db 0x00                             // p2 type
        db 0x00                             // p3 type
        db 0x00                             // p4 type

        // All possible team combinations (assumes two teams)
        // 0000
        // 0001
        // 0010
        // 0011 (valid)
        // 0100
        // 0101 (valid)
        // 0110 (valid)
        // 0111
        // 1000
        // 1001 (valid)
        // 1010 (valid)
        // 1011
        // 1100 (valid)
        // 1101
        // 1110
        // 1111

        valid_teams:
        // team 0 = spawns 00 and 02
        // team 1 = spawns 01 and 03

        // red vs blue
        dw 0x00000101, 0x00020103
        dw 0x00010001, 0x00010203
        dw 0x00010100, 0x00010302
        dw 0x01010000, 0x00020103
        dw 0x01000100, 0x00010203
        dw 0x01000001, 0x00010302

        // red vs green
        dw 0x00000202, 0x00020103
        dw 0x00020002, 0x00010203
        dw 0x00020200, 0x00010302
        dw 0x02020000, 0x00020103
        dw 0x02000200, 0x00010203
        dw 0x02000002, 0x00010302

        // blue vs green
        dw 0x01010202, 0x00020103
        dw 0x01020102, 0x00010203
        dw 0x01020201, 0x00010302
        dw 0x02020101, 0x00020103
        dw 0x02000201, 0x00010203
        dw 0x02010102, 0x00010302

        // null terminator
        dw 0x00000000, 0x00000000

        valid_singles:
        // pX vs pY
        dw 0x00000202, 0x0001FFFF
        dw 0x00020002, 0x00FF01FF
        dw 0x00020200, 0x00FFFF01
        dw 0x02020000, 0xFFFF0001
        dw 0x02000200, 0xFF00FF01
        dw 0x02000002, 0xFF0001FF

        // null terminator
        dw 0x00000000, 0x00000000

    }



    original_table:
    // 00 - Peach's Castle
    float32 -0210,  1574
    float32  0765,  1563
    float32  0300,  1515
    float32 -0840,  1526

    // 01 - Sector Z
    float32 -3301,  1869
    float32 -2094,  1708
    float32 -0898,  1593
    float32  0296,  1739

    // 02 - Kongo Jungle
    float32 -1739,  0002
    float32 -0630, -0210
    float32  0630, -0210
    float32  1739,  0002

    // 03 - Planet Zebes
    float32 -2556,  0572
    float32 -1137,  0011
    float32  0000,  0314
    float32  1745, -0262

    // 04 - Hyrule Castle
    float32 -2400,  1042
    float32 -1110,  1039
    float32  0240,  1042
    float32  1500,  1042

    // 05 - Yoshi's Island
    float32  0629, -0096
    float32  0090,  2409
    float32  0756,  1513
    float32 -0990,  1032

    // 06 - Dream Land
    float32  0000,  0006
    float32 -1397,  0906
    float32  0001,  1545
    float32  1421,  0909

    // 07 - Saffron City
    float32  1200,  0810
    float32 -0660, -0270
    float32  0510,  0090
    float32 -1200, -0270

    // 08 - Classic Mushroom Kingdom
    float32 -1800,  1318
    float32  1500,  0962
    float32 -1500,  0152
    float32  1800,  1807

    // 09 - Dream Land Beta 1
    float32  0954,  0150
    float32  1006,  0930
    float32 -0892,  0927
    float32 -0912,  0150

    // 0A - Dream Land Beta 2
    float32 -0450,  0150
    float32  0450,  0150
    float32  0000,  1701
    float32  1522,  0930

    // 0B - How to Play Stage
    float32  0660,  0000
    float32  1440,  0000
    float32 -0660,  0000                    // missing from stage file 
    float32 -1440,  0000                    // missing from stage file

    // 0C - Yoshi's Island (1P)
    float32  0629, -0180
    float32  0090,  2085
    float32  0900,  1140
    float32 -0990,  0828

    // 0D - Meta Crystal
    float32 -0960,  0135
    float32 -0330,  0045
    float32  0525,  0030
    float32  1545,  0315

    // 0E - Battlefield
    float32  0000,  0003
    float32  0000,  1803
    float32 -1170,  1022
    float32  1200,  1022

    // 0F - Race to the Finish (placeholder)
    float32  0000,  0000
    float32  0000,  0000
    float32  0000,  0000
    float32  0000,  0000

    // 10 - Final Destination
    float32 -0900,  0001
    float32  0900,  0001
    float32 -0600,  0001
    float32  0600,  0001

    neutral_table:
    // 00 - Peach's Castle
    float32 -0210,  1574
    float32  0765,  1563
    float32  0300,  1515
    float32 -0840,  1526

    // 01 - Sector Z
    float32 -3301,  1869
    float32 -2094,  1708
    float32 -0898,  1593
    float32  0296,  1739

    // 02 - Kongo Jungle
    float32 -1739,  0002
    float32 -0630, -0210
    float32  0630, -0210
    float32  1739,  0002

    // 03 - Planet Zebes
    float32 -2556,  0572
    float32 -1137,  0011
    float32  0000,  0314
    float32  1745, -0262

    // 04 - Hyrule Castle
    float32 -2400,  1042
    float32 -1110,  1039
    float32  0240,  1042
    float32  1500,  1042

    // 05 - Yoshi's Island
    float32  0629, -0096
    float32  0090,  2409
    float32  0756,  1513
    float32 -0990,  1032

    // 06 - Dream Land
    float32 -1400,  0910
    float32  1400,  0910
    float32 -1400,  0005
    float32  1400,  0005

    // 07 - Saffron City
    float32  1200,  0810
    float32 -0660, -0270
    float32  0510,  0090
    float32 -1200, -0270

    // 08 - Classic Mushroom Kingdom
    float32 -1800,  1318
    float32  1500,  0962
    float32 -1500,  0152
    float32  1800,  1807

    // 09 - Dream Land Beta 1
    float32  0954,  0150
    float32  1006,  0930
    float32 -0892,  0927
    float32 -0912,  0150

    // 0A - Dream Land Beta 2
    float32 -0450,  0150
    float32  0450,  0150
    float32  0000,  1701
    float32  1522,  0930

    // 0B - How to Play Stage
    float32  0660,  0000
    float32  1440,  0000
    float32 -0660,  0000
    float32 -1440,  0000

    // 0C - Yoshi's Island (1P)
    float32  0629, -0180
    float32  0090,  2085
    float32  0900,  1140
    float32 -0990,  0828

    // 0D - Meta Crystal
    float32 -0960,  0135
    float32 -0330,  0045
    float32  0525,  0030
    float32  1545,  0315

    // 0E - Battlefield
    float32 -1200,  1025
    float32  1200,  1025
    float32 -1200,  0005
    float32  1200,  0005

    // 0F - Race to the Finish (placeholder)
    float32  0000,  0000
    float32  0000,  0000
    float32  0000,  0000
    float32  0000,  0000

    // 10 - Final Destination
    float32 -1800,  0005
    float32  1800,  0005
    float32 -0900,  0005
    float32  0900,  0005
}

} // __SPAWN__
