// OS.asm
if !{defined __OS__} {
define __OS__()

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

}