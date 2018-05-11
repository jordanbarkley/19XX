// Stages.asm

scope Stages {
    //macro Stage(id, preview, type, franchise, name)

    scope getPreview_: {
    //  OS.pat

    }

    // preview
    //SSS2
    //.org    0x14E704                ; @ 80132B94

    // type (0x00 or 0x14)
    //SSS3
    //.org    0x14E71C                ; @ 80132BAC

    // franchise
    //SSS4
    //.org    0x14E4C0                ; @ 80132950

    // stage name
    //SSS5
    //.org    0x14E2F8                ; @ 80132788


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
    // This table includes <stage_file_id> and <type> where type controls a branch that
    // executes code for single player modes when 0x00 or skips that entirely for 0x14.
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
        db 0x00                              // Peach's Castle
        db 0x01                              // Sector Z
        db 0x02                              // Kongo Jungle
        db 0x03                              // Planet Zebes
        db 0x04                              // Hyrule Castle
        db 0x05                              // Yoshi's Island
        db 0x06                              // Dream Land
        db 0x07                              // Saffron City
        db 0x08                              // Mushroom Kingdom
        db 0x06                              // Dream Land Beta 1
        db 0x06                              // Dream Land Beta 2
        db 0x06                              // How to Play
        db 0x05                              // Yoshi's Island (1P)
        db 0x01                              // Metal Cavern
        db 0x01                              // Batlefield
        db 0xFF                              // Race to the Finish (Placeholder)
        db 0x01                              // Final Destination
        OS.align(4)
    }
}