// Data.asm
if !{defined __DATA__} {
define __DATA__()

// @ Description
// This file contains binary data such as images and stage files. It must be loaded dynamically
// using Memory.allocate_*

include "Texture.asm"

scope Data {

    // SSS Textures
    icon_peachs_castle:
    Texture.info(48, 36)
    insert "../textures/icon_peachs_castle.rgba5551"

    icon_sector_z:
    Texture.info(48, 36)
    insert "../textures/icon_sector_z.rgba5551"

    icon_congo_jungle:
    Texture.info(48, 36)
    insert "../textures/icon_congo_jungle.rgba5551"

    icon_planet_zebes:
    Texture.info(48, 36)
    insert "../textures/icon_planet_zebes.rgba5551"

    icon_hyrule_castle:
    Texture.info(48, 36)
    insert "../textures/icon_hyrule_castle.rgba5551"

    icon_yoshis_island:
    Texture.info(48, 36)
    insert "../textures/icon_yoshis_island.rgba5551"

    icon_dream_land:
    Texture.info(48, 36)
    insert "../textures/icon_dream_land.rgba5551"

    icon_saffron_city:
    Texture.info(48, 36)
    insert "../textures/icon_saffron_city.rgba5551"

    icon_mushroom_kingdom:
    Texture.info(48, 36)
    insert "../textures/icon_mushroom_kingdom.rgba5551"

    icon_dream_land_beta_1:
    Texture.info(48, 36)
    insert "../textures/icon_dream_land_beta_1.rgba5551"

    icon_dream_land_beta_2:
    Texture.info(48, 36)
    insert "../textures/icon_dream_land_beta_2.rgba5551"

    icon_how_to_play:
    Texture.info(48, 36)
    insert "../textures/icon_how_to_play.rgba5551"

    icon_yoshis_island_cloudless:
    Texture.info(48, 36)
    insert "../textures/icon_yoshis_island.rgba5551"

    icon_metal_cavern:
    Texture.info(48, 36)
    insert "../textures/icon_metal_cavern.rgba5551"

    icon_battlefield:
    Texture.info(48, 36)
    insert "../textures/icon_battlefield.rgba5551"

    icon_final_destination:
    Texture.info(48, 36)
    insert "../textures/icon_final_destination.rgba5551"
}

}