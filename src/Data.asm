// Data.asm
if !{defined __DATA__} {
define __DATA__()
if !{defined __TE__} {

// @ Description
// This file contains binary data such as images and stage files. It all gets dumped to expansion
// RAM. This data is only available in 19XXCE.

scope Data {

    pushvar origin
    pushvar base
    origin  0x01400000
    base    0x80400000

    // SSS Textures
    insert icon_peachs_castle, "../textures/icon_peachs_castle.rgba5551"
    insert icon_sector_z, "../textures/icon_sector_z.rgba5551"
    insert icon_congo_jungle, "../textures/icon_congo_jungle.rgba5551"
    insert icon_planet_zebes, "../textures/icon_planet_zebes.rgba5551"
    insert icon_hyrule_castle, "../textures/icon_hyrule_castle.rgba5551"
    insert icon_yoshis_island, "../textures/icon_yoshis_island.rgba5551"
    insert icon_dream_land, "../textures/icon_dream_land.rgba5551"
    insert icon_saffron_city, "../textures/icon_saffron_city.rgba5551"
    insert icon_mushroom_kingdom, "../textures/icon_mushroom_kingdom.rgba5551"
    insert icon_dream_land_beta_1, "../textures/icon_dream_land_beta_1.rgba5551"
    insert icon_dream_land_beta_2, "../textures/icon_dream_land_beta_2.rgba5551"
    insert icon_how_to_play, "../textures/icon_how_to_play.rgba5551"
    insert icon_yoshis_island_cloudless, "../textures/icon_yoshis_island.rgba5551"
    insert icon_metal_cavern, "../textures/icon_metal_cavern.rgba5551"
    insert icon_battlefield, "../textures/icon_battlefield.rgba5551"
    insert icon_final_destination, "../textures/icon_final_destination.rgba5551"
    insert icon_random, "../textures/icon_random.rgba5551"

    display_list:
    fill 0x10000
    
    pullvar base
    pullvar origin
}

}
}