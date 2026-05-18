// Hazards.asm [bit]
if !{defined __HAZARDS__} {
define __HAZARDS__()
print "included Hazards.asm\n"

// @ Description
// This file contains various functions for disabling stage hazards (when Stages.frozen_mode is on).

include "OS.asm"
include "Stages.asm"

scope Hazards {

    // @ Description
    // Macro for toggling various hazards
    macro hazard_toggle(function_address) {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // save registers

        li      t0, Stages.frozen_mode      // t0 = address of frozen_mode
        lw      t0, 0x0000(t0)              // t0 = frozen_mode
        variable _end(pc() + 4 * 3)
        bnez    t0, _end                    // if frozen_mode enabled, skip original
        nop

        jal     {function_address}          // original line 1
        nop                                 // original line 2

        // _end:
        lw      t0, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

    // @ Description
    // Toggles for Dream Land wind
    scope dream_land_wind_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x000816D4, 0x80103B44)
        } else {
        OS.patch_start(0x00081734, 0x80105F34)
        }
        jal     dream_land_wind_
        nop
        OS.patch_end()

        // @region:SYM
        if {defined REGION_JP} {
        hazard_toggle(0x801037F8)
        } else {
        hazard_toggle(0x80105BE8)
        }
    }

    // @ Description
    // Toggle for Sector Z arwing
    scope sector_z_arwing_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x000835EC, 0x80105A5C)
        } else {
        OS.patch_start(0x0008364C, 0x80107E4C)
        }
        jal     sector_z_arwing_
        nop
        OS.patch_end()

        // @region:SYM
        if {defined REGION_JP} {
        hazard_toggle(0x801046D0)
        } else {
        hazard_toggle(0x80106AC0)
        }
    }

    // @ Description
    // Toggle for Mushroom Kingdom POW blocks.
    scope mushroom_kingdom_pow_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x0008514C, 0x801075BC)
        } else {
        OS.patch_start(0x000851AC, 0x801099AC)
        }
        jal     mushroom_kingdom_pow_
        nop
        OS.patch_end()

        // @region:SYM
        if {defined REGION_JP} {
        hazard_toggle(0x80107498)
        } else {
        hazard_toggle(0x80109888)
        }
    }

    // @ Description
    // Toggle for Mushroom Kingdom Piranha Plants
    scope mushroom_kingdom_piranha_plants_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x000853C4, 0x80107834)
        } else {
        OS.patch_start(0x00085424, 0x80109C24)
        }
        jal     mushroom_kingdom_piranha_plants_
        nop
        OS.patch_end()

        // @region:SYM
        if {defined REGION_JP} {
        hazard_toggle(0x80107384)
        } else {
        hazard_toggle(0x80109774)
        }
    }

    // @ Description
    // Toggle for Planet Zebes acid
    scope planet_zebes_acid_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x00083BB0, 0x80106020)
        } else {
        OS.patch_start(0x00083C10, 0x80108410)
        }
        jal     planet_zebes_acid_
        nop
        OS.patch_end()

        // @region:SYM
        if {defined REGION_JP} {
        hazard_toggle(0x80105EC4)
        } else {
        hazard_toggle(0x801082B4)
        }
    }

    // @ Description
    // Toggle for Hyrule Castle tornadoes
    scope hyrule_castle_tornadoes_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x00086100, 0x80108570)
        } else {
        OS.patch_start(0x00086160, 0x8010A960)
        }
        jal     hyrule_castle_tornadoes_
        nop
        OS.patch_end()

        // @region:SYM
        if {defined REGION_JP} {
        hazard_toggle(0x80107FC4)
        } else {
        hazard_toggle(0x8010A3B4)
        }
    }

    // @ Description
    // Toggle for Congo Jungle barrel
    scope congo_jungle_barrel_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x0008575C, 0x80107BCC)
        } else {
        OS.patch_start(0x000857BC, 0x80109FBC)
        }
        jal     congo_jungle_barrel_
        nop
        OS.patch_end()

        // @region:SYM
        if {defined REGION_JP} {
        hazard_toggle(0x80107A94)
        } else {
        hazard_toggle(0x80109E84)
        }
    }

    // @ Description
    // Toggle for Saffron City Pokemon
    scope saffron_city_pokemon_: {
        // @region:SYM
        if {defined REGION_JP} {
        OS.patch_start(0x00086914, 0x80108D84)
        } else {
        OS.patch_start(0x00086974, 0x8010B174)
        }
        jal     saffron_city_pokemon_
        nop
        nop
        OS.patch_end()

        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // save registers

        li      t0, Stages.frozen_mode      // t0 = address of frozen_mode
        lw      t0, 0x0000(t0)              // t0 = frozen_mode
        bnez    t0, _end                    // if frozen_mode enabled, skip original
        nop

        // @region:SYM
        if {defined REGION_JP} {
        jal     0x80108B58                  // original line 1
        } else {
        jal     0x8010AF48                  // original line 1
        }
        nop                                 // original line 2
        // @region:SYM
        if {defined REGION_JP} {
        jal     0x80108D18                  // original line 3
        } else {
        jal     0x8010B108                  // original line 3
        }
        nop                                 // original line 4

        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // restore registers
        addiu   sp, sp, 0x0010              // deallocate stack space
        jr      ra                          // return
        nop
    }

}


} // __HAZARDS__
