// BGM.asm
if !{defined __BGM__} {
define __BGM__()

// @ Description
// This file allows BGM (background music) to be played and stopped.

include "Global.asm"
include "Toggles.asm"
include "OS.asm"

scope BGM {

    // @ Description
    // Plays background music until play_ is called again or stop_ is called.
    // @ Arguments
    // a0 - unknown, set to 0
    // a1 - BGM ID
    constant play_(0x80020AB4)

    // @ Description
    // This function is not yet documented.
    constant stop_(0x00000000)

    if {defined __CE__} {
    // @ Description
    // This function implements the mono/stero toggle (boolean stereo_enabled - 0x8003CB24)
    scope get_type_: {
        OS.patch_start(0x00020F1C, 0x8002031C)
        j       get_type_
        nop
        _get_type_return:
        OS.patch_end()

        lw      t8, 0xCB24(t8)              // original line 1 (t8 = stereo_enabled, overwritten.)
        mfhi    s3                          // original line 2

        li      t8, Toggles.entry_stereo_sound // ~
        lw      t8, 0x0000(t8)              // t8 = custom stereo_enabled
        j       _get_type_return            // return
        nop
    }
    } // __CE__

    // @ Description
    // a1 holds BGM_id. This function replaces a1 with a random id from the table
    scope random_music_: {
        OS.patch_start(0x000216F0, 0x80020AF4)
        j       random_music_
        nop
        _random_music_return:
        OS.patch_end()

        constant TABLE_SIZE(13)

        or      v0, a1, r0                  // original line 1
        addu    t3, t1, t2                   // original line 2
        Toggles.guard(Toggles.entry_random_music, _random_music_return)

        addiu   sp, sp,-0x0018              // allocate stack space
        sw      a0, 0x0004(sp)              // ~
        sw      t0, 0x0008(sp)              // ~
        sw      v0, 0x000C(sp)              // ~
        sw      ra, 0x0010(sp)              // save registers 

        li      t0, Global.current_screen   // ~
        lb      t0, 0x0000(t0)              // t0 = current_screen
        lli     v0, 0x0016                  // v0 = FIGHT_SCREEN
        bne     t0, v0, _end                // if not fight screen, end
        nop

        lli     a0, TABLE_SIZE              // ~
        jal     Global.get_random_int_      // v0 = table offset
        nop
        li      t0, table                   // t0 = table
        addu    t0, t0, v0                  // t0 = table + offset
        lb      a1, 0x0000(t0)              // a1 = new_song

        _end:
        lw      a0, 0x0004(sp)              // ~
        lw      t0, 0x0008(sp)              // ~
        lw      v0, 0x000C(sp)              // ~
        lw      ra, 0x0010(sp)              // restore registers 
        addiu   sp, sp, 0x0018              // deallocate stack space
        j       _random_music_return        // return
        nop

        table:
        db stage.DREAM_LAND
        db stage.PLANET_ZEBES
        db stage.MUSHROOM_KINGDOM
        db stage.SECTOR_Z
        db stage.CONGO_JUNGLE
        db stage.PEACHS_CASTLE
        db stage.SAFFRON_CITY
        db stage.YOSHIS_ISLAND
        db stage.HYRULE_CASTLE
        db stage.FINAL_DESTINATION
        db stage.HOW_TO_PLAY
        db stage.BATTLEFIELD
        db stage.META_CRYSTAL
        db menu.DATA
        OS.align(4)
    }

    scope stage {
        constant DREAM_LAND(0)
        constant PLANET_ZEBES(1)
        constant MUSHROOM_KINGDOM(2)
        constant MUSHROOM_KINGDOM_FAST(3)
        constant SECTOR_Z(4)
        constant CONGO_JUNGLE(5)
        constant PEACHS_CASTLE(6)
        constant SAFFRON_CITY(7)
        constant YOSHIS_ISLAND(8)
        constant HYRULE_CASTLE(9)
        constant MASTER_HAND_0(23)
        constant MASTER_HAND_1(24)
        constant MASTER_HAND_2(25)
        constant FINAL_DESTINATION(25)
        constant HOW_TO_PLAY(34)
        constant TUTORIAL(34)
        constant KIRBY_BETA_1(34)
        constant FIGHT_POLYGON_STAGE(36)
        constant BATTLEFIELD(36)
        constant METAL_MARIO(37)
        constant META_CRYSTAL(37)
    }

    scope win {
        constant MARIO(11)
        constant LUIGI(12)
        constant SAMUS(13)
        constant DK(14)
        constant KIRBY(15)
        constant FOX(16)
        constant NESS(17)
        constant YOSHI(18)
        constant FALCO(19)
        constant PIKACHU(20)
        constant JIGGLYPUFF(20)
        constant LINK(21)
    }

    scope menu {
        constant CHARACTER_SELECT(10)
        constant RESULTS(22)
        constant BONUS(26)
        constant STAGE_CLEAR(27)
        constant STAGE_CLEAR_BONUS(28)
        constant STAGE_CLEAR_MASTER_HAND(29)
        constant STAGE_CLEAR_BOSS(29)
        constant STAGE_FAIL(30)
        constant CONTINUE(31)
        constant GAME_OVER(32)
        constant INTRO(33)
        constant SINGLEPLAYER(35)
        constant GAME_COMPLETE(38)
        constant CREDITS(39)
        constant SECRET(40)
        constant HIDDEN_CHARACTER(41)
        constant DATA(43)
        constant MAIN(44)
    }

    scope special {
        constant UNKNOWN(11)
        constant TRAINING(42)
        constant HAMMER(45)
        constant INVINCIBLE(46)
    }

}

}