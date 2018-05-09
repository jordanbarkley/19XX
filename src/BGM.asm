// BGM.asm

scope BGM {

    // @ Description
    // Plays background music until play_ is called again or stop_ is called.
    // @ Arguments
    // a0 - unknown, set to 0
    // a1 - BGM ID
    constant play_(0x80020AB4)

    // @ Description
    // this function is not yet documented.
    constant stop_(0x00000000)

    scope stage {
        constant DREAM_LAND(0)
        constant PLANET_ZEBES(1)
        constant MK(2)
        constant MK_FAST(3)
        constant SECTOR_Z(4)
        constant CONGO_JUNGLE(5)
        constant PEACHS_CASTLE(6)
        constant SAFFRON_CITY(7)
        constant YOSHIS_ISLAND(8)
        constant HYRULE(9)
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
        constant METAL_CAVERN(37)
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
        constant 1P(35)
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
