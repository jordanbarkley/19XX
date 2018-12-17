// OS.asm
if !{defined __OS__} {
define __OS__()
print "included OS.asm\n"

// @ Description
// This file is where bass setup occurs and must be included in all bass projects. It also contains
// useful macros and functions to make assembly easier.

// general setup
arch    n64.cpu
endian  msb

// MIPS GPRs and FPRs (do not follow style guides)
constant r0(0)
constant at(1)
constant v0(2)
constant v1(3)
constant a0(4)
constant a1(5)
constant a2(6)
constant a3(7)
constant t0(8)
constant t1(9)
constant t2(10)
constant t3(11)
constant t4(12)
constant t5(13)
constant t6(14)
constant t7(15)
constant s0(16)
constant s1(17)
constant s2(18)
constant s3(19)
constant s4(20)
constant s5(21)
constant s6(22)
constant s7(23)
constant t8(24)
constant t9(25)
constant k0(26)
constant k1(27)
constant gp(28)
constant sp(29)
constant s8(30)
constant ra(31)
constant f0(0)
constant f1(1)
constant f2(2)
constant f3(3)
constant f4(4)
constant f5(5)
constant f6(6)
constant f7(7)
constant f8(8)
constant f9(9)
constant f10(10)
constant f11(11)
constant f12(12)
constant f13(13)
constant f14(14)
constant f15(15)
constant f16(16)
constant f17(17)
constant f18(18)
constant f19(19)
constant f20(20)
constant f21(21)
constant f22(22)
constant f23(23)
constant f24(24)
constant f25(25)
constant f26(26)
constant f27(27)
constant f28(28)
constant f29(29)
constant f30(30)
constant f31(31)

scope OS {
    constant FALSE(0)
    constant TRUE(1)
    constant NULL(0)

    macro align(size) {
        while (pc() % {size}) {
            db 0x00
        }
    }

    macro patch_start(origin, base) {
        pushvar origin, base
        origin  {origin}
        base    {base}
    }

    macro patch_end() {
        pullvar base, origin
    }

    macro save_registers() {
        addiu   sp, sp,-0x0070              // allocate stack space
        sw      at, 0x0004(sp)              // ~
        sw      v0, 0x0008(sp)              // ~
        sw      v1, 0x000C(sp)              // ~
        sw      a0, 0x0010(sp)              // ~
        sw      a1, 0x0014(sp)              // ~
        sw      a2, 0x0018(sp)              // ~
        sw      a3, 0x001C(sp)              // ~
        sw      t0, 0x0020(sp)              // ~
        sw      t1, 0x0024(sp)              // ~
        sw      t2, 0x0028(sp)              // ~
        sw      t3, 0x002C(sp)              // ~
        sw      t4, 0x0030(sp)              // ~
        sw      t5, 0x0034(sp)              // ~
        sw      t6, 0x0038(sp)              // ~
        sw      t7, 0x003C(sp)              // ~
        sw      t8, 0x0040(sp)              // ~
        sw      t9, 0x0044(sp)              // ~
        sw      s0, 0x0048(sp)              // ~
        sw      s1, 0x004C(sp)              // ~
        sw      s2, 0x0050(sp)              // ~
        sw      s3, 0x0054(sp)              // ~
        sw      s4, 0x0058(sp)              // ~
        sw      s5, 0x005C(sp)              // ~
        sw      s6, 0x0060(sp)              // ~
        sw      s7, 0x0064(sp)              // ~
        sw      s8, 0x0068(sp)              // ~
        sw      ra, 0x006C(sp)              // save registers
    }

    macro restore_registers() {
        lw      at, 0x0004(sp)              // ~
        lw      v0, 0x0008(sp)              // ~
        lw      v1, 0x000C(sp)              // ~
        lw      a0, 0x0010(sp)              // ~
        lw      a1, 0x0014(sp)              // ~
        lw      a2, 0x0018(sp)              // ~
        lw      a3, 0x001C(sp)              // ~
        lw      t0, 0x0020(sp)              // ~
        lw      t1, 0x0024(sp)              // ~
        lw      t2, 0x0028(sp)              // ~
        lw      t3, 0x002C(sp)              // ~
        lw      t4, 0x0030(sp)              // ~
        lw      t5, 0x0034(sp)              // ~
        lw      t6, 0x0038(sp)              // ~
        lw      t7, 0x003C(sp)              // ~
        lw      t8, 0x0040(sp)              // ~
        lw      t9, 0x0044(sp)              // ~
        lw      s0, 0x0048(sp)              // ~
        lw      s1, 0x004C(sp)              // ~
        lw      s2, 0x0050(sp)              // ~
        lw      s3, 0x0054(sp)              // ~
        lw      s4, 0x0058(sp)              // ~
        lw      s5, 0x005C(sp)              // ~
        lw      s6, 0x0060(sp)              // ~
        lw      s7, 0x0064(sp)              // ~
        lw      s8, 0x0068(sp)              // ~
        lw      ra, 0x006C(sp)              // save registers
        addiu   sp, sp, 0x0070              // deallocate stack space
    }

    // @ Description
    // This function takes a float and returns an integer. v0 is not conserved.
    // @ Arguments
    // a0 - float val
    // @ Returns
    // v0 - int val
    scope float_to_int_: {
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        swc1    f0, 0x0008(sp)              // save registers
        
        mtc1    a0, f0                      // move given float to f0
        cvt.w.s f0, f0                      // convert float to int
        mfc1    v0, f0                      // move int to v0

        lw       t0, 0x0004(sp)              // ~
        lwc1    f0, 0x0008(sp)              // save registers
        addiu   sp, sp, 0x0010              // deallocate stack space

        jr      ra                          // return
        nop
    }

    // @ Description
    // This function takes an integer and returns a float. v0 is not conserved.
    // @ Arguments
    // a0 - integer val
    // @ Returns
    // v0 - float val
    scope int_to_float_: {
        
        addiu   sp, sp,-0x0010              // allocate stack space
        sw      t0, 0x0004(sp)              // ~
        swc1    f0, 0x0008(sp)              // save registers
        
        mtc1    a0, f0                      // move given int to f0
        cvt.s.w f0, f0                      // convert int to float
        mfc1    v0, f0                      // move float to v0

        lw      t0, 0x0004(sp)              // ~
        lwc1    f0, 0x0008(sp)              // save registers
        addiu   sp, sp, 0x0010              // deallocate stack space

        jr      ra                          // return
        nop
    }
}

} // __OS__