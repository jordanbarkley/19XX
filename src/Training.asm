// Training.asm (functions by Fray, menu implementation by Cyjorg)
if !{defined __TRAINING__} {
define __TRAINING__()
if {defined __CE__} {

// @ Description
// This file contains functions and defines structs intended to assist training mode modifications.

include "Character.asm"
include "Color.asm"
include "Global.asm"
include "Joypad.asm"
include "Menu.asm"
include "OS.asm"
include "Overlay.asm"

scope Training {
    // @ Description
    // Byte, determines whether the player is able to control the training mode menu, regardless of
    // if it is currently being displayed. 01 = disable control, 02 = enable control
    constant toggle_menu(0x80190979)
    constant BOTH_DOWN(0x01)
    constant SSB_UP(0x02)
    constant CUSTOM_UP(0x03)
    
    // @ Description
    // Byte, contains the training mode stage id
    constant stage(0x80190969)
    
    // @ Description
    // Contains game settings, as well as information and properties for each port.
    // PORT STRUCT INFO
    // @ ID         [read/write]
    // Contains character ID, see character.asm for list.
    // @ type       [read/write]
    // 0x00 = MAN, 0x01 = COM, 0x02 = NOT
    // @ costume    [read/write]
    // Contains the costume ID.
    // @ percent    [read only]
    // Contains the current percentage.
    // Read only. Use Character.add_percent_ and Training.reset_percent_ to write.
    // @ spawn_id    [read/write]
    // Contains the player's spawn id.
    // 0x00 = port 1, 0x01 = port 2, 0x02 = port 3, 0x03 = port 4, 0x04 = custom
    // @ spawn_pos
    // Contains custom spawn position.
    // float32 xpos, float32 ypos
    // @ spawn_dir
    // Contains custom spawn direction.
    constant FACE_LEFT(0xFFFFFFFF)
    constant FACE_RIGHT(0x00000001)
    // 0xFFFFFFFF = left, 0x00000001 = right
    scope struct {
        scope main: {
            // @ Description
            // stage id, see stages.asm for list
            stage:
            dw OS.NULL
        }
        scope port_1: {
            ID:
            dw OS.NULL
            type:
            dw OS.NULL
            costume:
            dw OS.NULL
            percent:
            dw OS.NULL
            spawn_id:
            dw OS.NULL
            spawn_pos:
            float32 0,0
            spawn_dir:
            dw FACE_LEFT
        }
        scope port_2: {
            ID:
            dw OS.NULL
            type:
            dw OS.NULL
            costume:
            dw OS.NULL
            percent:
            dw OS.NULL
            spawn_id:
            dw OS.NULL
            spawn_pos:
            float32 0,0
            spawn_dir:
            dw FACE_LEFT
        }
        scope port_3: {
            ID:
            dw OS.NULL
            type:
            dw OS.NULL
            costume:
            dw OS.NULL
            percent:
            dw OS.NULL
            spawn_id:
            dw OS.NULL
            spawn_pos:
            float32 0,0
            spawn_dir:
            dw FACE_LEFT
        }
        scope port_4: {
            ID:
            dw OS.NULL
            type:
            dw OS.NULL
            costume:
            dw OS.NULL
            percent:
            dw OS.NULL
            spawn_id:
            dw OS.NULL
            spawn_pos:
            float32 0,0
            spawn_dir:
            dw FACE_LEFT
        }
        
        // @ Description
        // table of pointers to each port struct
        table:
        dw port_1
        dw port_2
        dw port_3
        dw port_4
    }

    // @ Description
    // This function loads various character properties when training mode is loaded
    scope load_character_: {
        OS.patch_start(0x00116AA0, 0x80190280)
        jal load_character_
        nop
        OS.patch_end()
        
        addiu   sp, sp,-0x0018              // allocate stack space
        sw      ra, 0x0004(sp)              // ~
        sw      t0, 0x0008(sp)              // ~
        sw      t1, 0x000C(sp)              // ~
        sw      t2, 0x0010(sp)              // ~
        sw      t3, 0x0014(sp)              // store ra, t0-t3
        
        li      t0, Global.match_info       // ~
        lw      t0, 0x0000(t0)              // t1 = match info address
        li      t1, reset_counter           // t1 = reset counter
        lw      t1, 0x0000(t1)              // t1 = reset counter value
        beq     t1, r0, _initialize_p1      // initialize values if load from sss is detected
        ori     t3, r0, Character.id.NONE   // t3 = character id: NONE
        
        _load_p1:
        addiu   t0, Global.vs.P_OFFSET      // t0 = p1 info
        li      t1, struct.port_1.ID        // ~
        lw      t1, 0x0000(t1)              // t1 = port 1 char id
        sb      t1, 0x0003(t0)              // store char id
        li      t1, struct.port_1.type      // ~
        lw      t1, 0x0000(t1)              // t1 = port 1 type
        sb      t1, 0x0002(t0)              // store type
        li      t1, struct.port_1.costume   // ~
        lw      t1, 0x0000(t1)              // t1 = port 1 costume
        sb      t1, 0x0006(t0)              // store costume
        _load_p2:
        addiu   t0, Global.vs.P_DIFF        // t0 = p2 info
        li      t1, struct.port_2.ID        // ~
        lw      t1, 0x0000(t1)              // t1 = port 2 char id
        sb      t1, 0x0003(t0)              // store char id
        li      t1, struct.port_2.type      // ~
        lw      t1, 0x0000(t1)              // t1 = port 2 type
        sb      t1, 0x0002(t0)              // store type
        li      t1, struct.port_2.costume   // ~
        lw      t1, 0x0000(t1)              // t1 = port 2 costume
        sb      t1, 0x0006(t0)              // store costume
        _load_p3:
        addiu   t0, Global.vs.P_DIFF        // t0 = p3 info
        li      t1, struct.port_3.ID        // ~
        lw      t1, 0x0000(t1)              // t1 = port 3 char id
        sb      t1, 0x0003(t0)              // store char id
        li      t1, struct.port_3.type      // ~
        lw      t1, 0x0000(t1)              // t1 = port 3 type
        sb      t1, 0x0002(t0)              // store type
        li      t1, struct.port_3.costume   // ~
        lw      t1, 0x0000(t1)              // t1 = port 3 costume
        sb      t1, 0x0006(t0)              // store costume
        _load_p4:
        addiu   t0, Global.vs.P_DIFF        // t0 = p4 info
        li      t1, struct.port_4.ID        // ~
        lw      t1, 0x0000(t1)              // t1 = port 4 char id
        sb      t1, 0x0003(t0)              // store char id
        li      t1, struct.port_4.type      // ~
        lw      t1, 0x0000(t1)              // t1 = port 4 type
        sb      t1, 0x0002(t0)              // store type
        li      t1, struct.port_4.costume   // ~
        lw      t1, 0x0000(t1)              // t1 = port 4 costume
        sb      t1, 0x0006(t0)              // store costume
        j       _end                        // jump to end
        nop
        
        _initialize_p1:
        addiu   t0, Global.vs.P_OFFSET      // t0 = p1 info
        lbu     t1, 0x0003(t0)              // t1 = char id
        li      t2, struct.port_1.ID        // t2 = struct id pointer
        bnel    t1, t3, _initialize_p1+0x18 // ~
        sw      t1, 0x0000(t2)              // if id != NONE, store in struct
        lbu     t1, 0x0002(t0)              // t1 = type
        li      t2, struct.port_1.type      // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store type in struct
        lbu     t1, 0x0006(t0)              // t1 = costume id
        li      t2, struct.port_1.costume   // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store costume id in struct
        _initialize_p2:
        addiu   t0, Global.vs.P_DIFF        // t0 = p2 info
        lbu     t1, 0x0003(t0)              // t1 = char id
        li      t2, struct.port_2.ID        // t2 = struct id pointer
        bnel    t1, t3, _initialize_p2+0x18 // ~
        sw      t1, 0x0000(t2)              // if id != NONE, store in struct
        lbu     t1, 0x0002(t0)              // t1 = type
        li      t2, struct.port_2.type      // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store type in struct
        lbu     t1, 0x0006(t0)              // t1 = costume id
        li      t2, struct.port_2.costume   // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store costume id in struct
        _initialize_p3:
        addiu   t0, Global.vs.P_DIFF        // t0 = p3 info
        lbu     t1, 0x0003(t0)              // t1 = char id
        li      t2, struct.port_3.ID        // t2 = struct id pointer
        bnel    t1, t3, _initialize_p3+0x18 // ~
        sw      t1, 0x0000(t2)              // if id != NONE, store in struct
        lbu     t1, 0x0002(t0)              // t1 = type
        li      t2, struct.port_3.type      // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store type in struct
        lbu     t1, 0x0006(t0)              // t1 = costume id
        li      t2, struct.port_3.costume   // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store costume id in struct
        _initialize_p4:
        addiu   t0, Global.vs.P_DIFF        // t0 = p4 info
        lbu     t1, 0x0003(t0)              // t1 = char id
        li      t2, struct.port_4.ID        // t2 = struct id pointer
        bnel    t1, t3, _initialize_p4+0x18 // ~
        sw      t1, 0x0000(t2)              // if id != NONE, store in struct
        lbu     t1, 0x0002(t0)              // t1 = type
        li      t2, struct.port_4.type      // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store type in struct
        lbu     t1, 0x0006(t0)              // t1 = costume id
        li      t2, struct.port_4.costume   // t2 = struct type pointer
        sw      t1, 0x0000(t2)              // store costume id in struct
        
        _end:
        lw      t0, 0x0008(sp)              // ~
        lw      t1, 0x000C(sp)              // ~
        lw      t2, 0x0010(sp)              // ~
        lw      t3, 0x0014(sp)              // load t0-t3
        jal     0x801906D0                  // original line 1
        nop                                 // original line 2
        lw      ra, 0x0004(sp)              // load ra
        addiu   sp, sp, 0x0018              // deallocate stack space
        jr      ra                          // return
        nop
    }    
    
    // @ Description
    // This function loads the facing direction when a custom spawn position is used
    // v1 = player struct address
    scope load_spawn_dir_: {
        OS.patch_start(0x00053210, 0x800D7A10)
        j   load_spawn_dir_
        nop
        _load_spawn_dir_return:
        OS.patch_end()
        lw      t7, 0x0024(a1)              // original line 1
        or      s0, a0, r0                  // original line 2
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // store t0, t1
        li      t0, struct.table            // t0 = struct table
        lbu     t1, 0x000D(v1)              // ~
        sll     t1, t1, 0x2                 // t1 = offset (player port * 4)
        add     t0, t0, t1                  // t0 = struct table + offset
        lw      t0, 0x0000(t0)              // t0 = port struct address
        lw      t1, 0x0010(t0)              // ~
        slti    t1, t1, 0x4                 // t1 = 1 if spawn_id > 0x4; else t1 = 0
        bnez    t1, _end                    // skip if spawn_id != custom
        nop
        lw      t1, 0x001C(t0)              // t1 = spawn_dir
        sw      t1, 0x0044(v1)              // player facing direction = spawn_dir
        
        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space       
        j       _load_spawn_dir_return
        nop
        }
    
    // @ Description
    // This function runs once per frame, per character. Can be used to update character info
    // s0 = player struct address
    scope update_character_: {
        OS.patch_start(0x000621B4, 0x800E69B4)
        j   update_character_
        nop
        _update_character_return:
        OS.patch_end()
        _update_percent:
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // store t0, t1
        li      t0, Global.current_screen   // ~
        lbu     t0, 0x0000(t0)              // t0 = screen_id
        ori     t1, r0, 0x0036              // ~
        bne     t0, t1, _end                // skip if screen_id != training mode
        nop
        li      t0, struct.table            // t0 = struct table
        lbu     t1, 0x000D(s0)              // ~
        sll     t1, t1, 0x2                 // t1 = offset (player port * 4)
        add     t0, t0, t1                  // t0 = struct table + offset
        lw      t0, 0x0000(t0)              // t0 = port struct address
        lhu     t1, 0x002E(s0)              // t1 = current percentage
        sw      t1, 0x000C(t0)              // save percentage to struct
        
        ///////DPAD DOWN to call custom spawn function (used for testing)///////
        //lbu     t0, 0x01BE(s0)              // t0 = dpad_pressed adress
        //andi    t0, t0, 0x0008              // ~
        //beq     t0, r0, _end                // skip if dpad up is not being pressed
        //nop
        //addiu   sp, sp,-0x000C              // allocate stack space
        //sw      a0, 0x0004(sp)              // ~
        //sw      ra, 0x0008(sp)              // store a0, ra
        //or      a0, s0, r0                  // a0 = struct address
        //jal     set_custom_spawn_           // set custom spawn position
        //nop
        //lw      a0, 0x0004(sp)              // ~
        //lw      ra, 0x0008(sp)              // load a0, ra
        //addiu   sp, sp, 0x000C              // deallocate stack space
        
        _end:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space
        lw      s0, 0x0020(sp)              // original line 1
        addiu   sp, sp, 0x00A0              // original line 2
        j       _update_character_return
        nop
    }
    
    // @ Description
    // This function runs when training is loaded from stage select, but not when reset is used
    scope load_from_sss_: {
        OS.patch_start(0x00116E20, 0x80190600)
        j   load_from_sss_
        nop
        _load_from_sss_return:
        OS.patch_end()
        
        addiu   t6, t6, 0x5240              // original line 1
        addiu   a0, a0, 0x0870              // original line 2
        
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // store t0, t1
        
        li      t0, reset_counter           // t0 = reset_counter
        sw      r0, 0x0000(t0)              // reset reset_counter value
        
        _initialize_spawns:
        li      t0, struct.port_1.spawn_id  // t0 = port 1 spawn id address
        or      t1, r0, r0                  // t1 = port 1 id
        sw      t1, 0x0000(t0)              // save port id as spawn id
        li      t0, struct.port_2.spawn_id  // t0 = port 2 spawn id address
        addiu   t1, t1, 0x0001              // t1 = port 2 id
        sw      t1, 0x0000(t0)              // save port id as spawn id
        li      t0, struct.port_3.spawn_id  // t0 = port 3 spawn id address
        addiu   t1, t1, 0x0001              // t1 = port 3 id
        sw      t1, 0x0000(t0)              // save port id as spawn id
        li      t0, struct.port_4.spawn_id  // t0 = port 4 spawn id address
        addiu   t1, t1, 0x0001              // t1 = port 4 id
        sw      t1, 0x0000(t0)              // save port id as spawn id
        
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space
        j       _load_from_sss_return
        nop
    }
    
    // @ Description
    // This function runs when training is loaded from reset, but not from the stage select screen
    // it also runs when training mode exit is used
    scope load_from_reset_: {
        OS.patch_start(0x00116E88, 0x80190668)
        j   load_from_reset_
        nop
        _exit_game:
        OS.patch_end()
        
        // the original code: resets the game when the branch is taken, exits otherwise
        // bnez    t2, 0x80190654           // original line 1
        // nop                              // original line 2
        
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        sw      t1, 0x0008(sp)              // store t0, t1
        
        li      t0, reset_counter           // t0 = reset_counter
        lw      t1, 0x0000(t0)              // t1 = reset_counter value
        addiu   t1, t1, 0x00001             // t1 = reset counter value + 1
        sw      t1, 0x0000(t0)              // store reset_counter value
        bnez    t2, _reset_game             // modified original branch
        nop
        
        sw      r0, 0x0000(t0)              // reset reset_counter value
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space
        j       _exit_game
        nop
        
        _reset_game:
        lw      t0, 0x0004(sp)              // ~
        lw      t1, 0x0008(sp)              // load t0, t1
        addiu   sp, sp, 0x000C              // deallocate stack space
        j       0x80190654
        nop
    }
    
    // @ Description
    // This function will reset the player's % to 0
    // @ Arguments
    // a0 - address of the player struct
    // CURRENTLY UNTESTED
    scope reset_percent_: {
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      a1, 0x0004(sp)              // ~
        sw      ra, 0x0008(sp)              // store a1, ra
        lw      a1, 0x002C(a0)              // a1 = percentage
        sub     a1, r0, a1                  // a1 = 0 - percentage
        jal     Character.add_percent_      // subtract current percentage from itself
        nop
        lw      a1, 0x0004(sp)              // ~
        lw      ra, 0x0008(sp)              // load a1, ra
        addiu   sp, sp, 0x000C              // deallocate stack space
        jr      ra                          // return
        nop
    }
    
    // @ Description
    // This function will copy the player's current position to Training.struct.port_x.spawn_pos
    // as well as copying the player's facing direction to Training.struct.port_x.spawn_dir
    // @ Arguments
    // a0 - address of the player struct
    // CURRENTLY UNTESTED
    scope set_custom_spawn_: {
        addiu   sp, sp,-0x000C              // allocate stack space
        sw      t0, 0x0000(sp)              // ~
        sw      t1, 0x0004(sp)              // ~
        sw      t2, 0x0008(sp)              // store t0-t2
        lw      t0, 0x0024(a0)              // t0 = current action id
        ori     t1, r0, 0x000A              // t1 = standing action id
        bne     t0, t1, _end                // skip if current action id != standing
        nop
        
        li      t2, struct.table            // t2 = struct table address
        lbu     t0, 0x000D(a0)              // ~
        sll     t0, t0, 0x2                 // t0 = offset (player port * 4)
        add     t2, t2, t0                  // t2 = struct table + offset
        lw      t2, 0x0000(t2)              // t2 = port struct address
        lw      t0, 0x0078(a0)              // t0 = player position address
        lw      t1, 0x0000(t0)              // t1 = player x position
        sw      t1, 0x0014(t2)              // save player x position to struct
        lw      t1, 0x0004(t0)              // t1 = player y position
        sw      t1, 0x0018(t2)              // save player y position to struct
        lw      t1, 0x0044(a0)              // t1 = player facing direction
        sw      t1, 0x001C(t2)              // save player facing direction to struct
    
        _end:
        lw      t0, 0x0000(sp)              // ~
        lw      t1, 0x0004(sp)              // ~
        lw      t2, 0x0008(sp)              // load t0-t2, a0
        addiu   sp, sp, 0x000C              // deallocate stack space
        jr      ra                          // return
        nop
    }
    
    // @ Description
    // A counter that tracks how many times the current training mode session has been reset.
    // This could be displayed on-screen, but is also useful for differentiating between loads from
    // stage select and loads from the reset function
    reset_counter:
    dw OS.NULL

    // @ Description
    // Runs the menu
    scope run_: {
        OS.save_registers()

        li      t0, toggle_menu             // t0 = address of toggle_menu
        lbu     t0, 0x0000(t0)              // t0 = toggle_menu

        // check if the ssb menu is up
        lli     t1, SSB_UP                  // t1 = ssb menu is up
        beq     t0, t1, _ssb_up             // branch accordingly
        nop
        
        // check if the custom menu is up
        lli     t1, CUSTOM_UP               // t1 = custom menu is up
        beq     t0, t1, _custom_up          // branch accordingly
        nop

        // otherwise skip
        b       _end
        nop

        _custom_up:
        // the first option in the custom training menu has it's next pointer modified for the
        // rest of the option based on the value it holds. this block updates the next pointer
        li      t0, info                    // t0 = info
        lw      t0, 0x0000(t0)              // t0 = address of head (entry)
        lw      t1, 0x0004(t0)              // t1 = entry.curr
        addiu   t1, t1,-0x0001              // t1 = entry.curr-- (p1 = 0, p2 = 1 etc.)
        sll     t1, t1, 0x0002              // t1 = offset
        li      t2, tail_table              // t2 = address of tail_table
        addu    t2, t2, t1                  // t2 = address of tail_table + offset
        lw      t2, 0x0000(t2)              // t2 = address of tail
        sw      t2, 0x001C(t0)              // entry.next = address of head

        // update menu
        li      a0, info                    // a0 - address of Menu.info()
        jal     Menu.update_                // check for updates
        nop

        // draw menu
        li      a0, info                    // a0 - address of Menu.inf()
        jal     Menu.draw_                  // draw menu
        nop

        // check for b press
        lli     a0, Joypad.B                // a0 - button_mask
        lli     a1, 000069                  // a1 - whatever you like!
        lli     a2, Joypad.PRESSED          // a2 - type
        jal     Joypad.check_buttons_all_   // v0 - bool z_pressed
        nop
        beqz    v0, _end                    // if (!z_pressed), end
        nop
        li      t0, toggle_menu             // t0 = toggle_menu
        lli     t1, SSB_UP                  // ~
        sb      t1, 0x0000(t0)              // toggle menu = SSB_UP
        b       _end                        // end execution
        nop

        _ssb_up:
        // tell the user they can bring up the custom menu
        lli     a0, 000068                  // a0 - ulx
        lli     a1, 000050                  // a1 - uly
        li      a2, press_z                 // a2 - address of string
        jal     Overlay.draw_string_        // draw custom menu instructions
        nop

        // check for z press
        lli     a0, Joypad.Z                // a0 - button_mask
        lli     a1, 000069                  // a1 - whatever you like!
        lli     a2, Joypad.PRESSED          // a2 - type
        jal     Joypad.check_buttons_all_   // v0 - bool z_pressed
        nop
        beqz    v0, _end                    // if (!z_pressed), end
        nop
        li      t0, toggle_menu             // t0 = toggle_menu
        lli     t1, CUSTOM_UP               // ~
        sb      t1, 0x0000(t0)              // toggle menu = CUSTOM_UP

        _end:
        OS.restore_registers()
        jr      ra
        nop
    }

    // @ Description
    // Message/visual indicator to press Z for custom menu
    press_z:; db "PRESS Z FOR CUSTOM MENU", 0x00

    // @ Description
    // Type strings
    type_1:; db "HUMAN", 0x00
    type_2:; db "CPU", 0x00
    type_3:; db "DISABLED", 0x00
    OS.align(4)

    string_table_type:
    dw type_1
    dw type_2
    dw type_3

    // @ Description
    // Character Strings
    char_1:;  db "MARIO" , 0x00
    char_2:;  db "FOX", 0x00
    char_3:;  db "DK", 0x00
    char_4:;  db "SAMUS", 0x00
    char_5:;  db "LUIGI", 0x00
    char_6:;  db "LINK", 0x00
    char_7:;  db "YOSHI", 0x00
    char_8:;  db "C. FALCON", 0x00
    char_9:;  db "KIRBY", 0x00
    char_10:; db "PIKACHU", 0x00
    char_11:; db "JIGGLYPUFF", 0x00
    char_12:; db "NESS", 0x00
    OS.align(4)

    string_table_char:
    dw char_1
    dw char_2
    dw char_3
    dw char_4
    dw char_5
    dw char_6
    dw char_7
    dw char_8
    dw char_9
    dw char_10
    dw char_11
    dw char_12

    // @ Description 
    // Spawn Position Strings
    spawn_1:; db "PORT 1", 0x00
    spawn_2:; db "PORT 2", 0x00
    spawn_3:; db "PORT 3", 0x00
    spawn_4:; db "PORT 4", 0x00
    spawn_5:; db "CUSTOM", 0x00
    OS.align(4)

    string_table_spawn:
    dw spawn_1
    dw spawn_2
    dw spawn_3
    dw spawn_4
    dw spawn_5

    info:
    Menu.info(head, 62, 50, Color.low.GREY, 24)

    update_: {

    }

    macro tail_px(player) {
        define character(Training.struct.port_{player}.ID)
        define costume(Training.struct.port_{player}.costume)
        define type(Training.struct.port_{player}.type)
        define damage(Training.struct.port_{player}.percent)

        Menu.entry("CHARACTER", Menu.type.U8, 0, 0, Character.id.NESS, OS.NULL, string_table_char, {character}, pc() + 16)
        Menu.entry("COSTUME", Menu.type.U8, 0, 0, 3, OS.NULL, OS.NULL, {costume}, pc() + 12)
        Menu.entry("TYPE", Menu.type.U8, 0, 0, 2, OS.NULL, string_table_type, {type}, pc() + 12)
        Menu.entry("DAMAGE", Menu.type.U16, 0, 0, 999, OS.NULL, OS.NULL, {damage}, OS.NULL)
    }

    tail_p1:; tail_px(1)
    tail_p2:; tail_px(2)
    tail_p3:; tail_px(3)
    tail_p4:; tail_px(4)

    tail_table:
    dw tail_p1
    dw tail_p2
    dw tail_p3
    dw tail_p4

    head:
    entry_port_x:
    Menu.entry("PORT", Menu.type.U8, 1, 1, 4, OS.NULL, OS.NULL, OS.NULL, tail_p1)







}

}
}

// To-Do List
// create functions:
// set custom spawn position (if player state = standing, set custom spawn to current x,y position)
// freeze % toggle?

// End Goal
// create an additional menu that can be easily accessed within training mode
// allowing players to control all of the properties that have been set up in this file
