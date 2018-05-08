# Style and Taxonomy 
The purpose of this file is to define a general set of coding standards for myself as well as any future contributors. Following the standards in this file will ensure maintainability, readability, and usability of code. 

## Section I: Bass Variables
Bass variables can only be declared once but can be changed during the assembly process. Bass variables allow for if/then statements during the assembly process among other things that make assembly easy.

**Rules**
1. Variables use underscore_casing.
2. Variables start with letters
3. Numbers at the end of variables should be preceded by an underscore.

**Good**
```
variable ret_value(0)
variable texels(0)
variable numeric_example_0()
```

**Bad**
```
variable _badStart(0)           // starts with an underscore
variable camelCasing(0)         // wrong casing
variable Upper(0)               // starts with uppercase letter
variable ilIMatic(0)            // highlighting the li1I issue
variable numeric_example0(0)    // 0 not preceded  with underscore
```

## Section II: Bass Constants 
Bass constants can only be declared once and cannot be changed during the assembly process. They
serve two purposes for 19XX developers.

### Purpose 1: Standard Programming Constants
Remember, DREAM_LAND_STAGE_ID is significantly more informative than 5. Use constants in your code.

**Rules**
1. Constants use UPPERCASE_NOTATION.
2. Constants start with letters.
3. Numbers at the end of constants should be preceded  by an underscore.
4. Constants may contain common acronyms although this is discouraged.
5. Words are separated by underscores.

**Acceptable**
```
constant TRUE(1)
constant FALSE(0)
constant NULL(0)
constant DREAM_LAND_STAGE_ID(5)
constant DEBUG_MODE(0)
constant RCP_CONSTANT_0(0)
```

**Unacceptable**
```
constant dream_land_stage_id(5)     // wrong case
constant DREAMLANDSTAGEID(5)        // not separated by underscore
constant DreamLandStageID(5)        // ^
constant RCPCOSNTANT0(0)            // ^
constant _NOT_A_CONSTANT(0)         // starts with an underscore
```

### Purpose 2: Declaring Addresses in Vanilla Super Smash Bros.
While this is an atypical use of constants, it makes code easy to read.

**Rules**
1. Follow the rules of the given type (variable or function). 
2. Include documentation (discussed below).

## Section III: Bass Macros
Bass macros can do many things such as create c structs, advance the program counter for alignment, simple conversions, etc. Due to their versatility, usage will not be defined here.

**Rules**
1. Follow the rules of variables.
2. Document heavily at declaration. Include usage, pc/base changes, etc.
3. Always ensure that the result of a macro is 32 bit aligned (achieved using OS.align(4)).

**Acceptable**
```
// @ Description
// This macro will pad memory with null chars  until (pc() % size == 0). It is typically used for
// 32 bit alignment/padding after data structures, arrays, and tables.
macro align(size) {
    while (pc() % {size}) {
        db 0x00
    }
}
```

**Unacceptable**
```
macro _alignPc(size) {
    while (pc() % {size}) {
        db 0x00
    }
}

// undocumented, does not follow rules of variable
```

## Section 5: Outer Scopes (Pseudo Classes)
Scoping in Bass allows macros, defines, variables and constants with common named such as "loop" to be reused. 19XX developers will capitalize on this functionality to develop a pseudo class system for easy organization.

**Rules**
1. Outer scope names use ProperCamelCasing.
2. Outer scope names may also be common acronyms such as RCP although this is discouraged.
3. Outer scope names using more than two words are discouraged.
4. File name and scope name are to be equivalent.

**Acceptable**
```
scope Example {}
scope Music {}
scope BGM {}
scope TwoWords {}
```

**Unacceptable**
```
scope RCPTest {}            // includes an acronym AND word
scope className {}          // first word is lower cased
scope MoreThanTwoWords {}   // too many words
```


## Section V: Nested Scopes as Functions
Bass allows for scopes within scopes.

```
scope Outer {
    scope Inner {
        constant X(0)       // accessed using Outer.Inner.X
    }
}
```

In order to make code easy to read, 19XX developers will use function syntax that resembles Java's static method calls.

**Java**
```
public class Example {
    public float intToFloat(int val) {
        return (float) val;                 // return val as a float
    }
}
```

**bass**
```
scope Example {
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
        jr      ra                          // return float through v0
        nop
    }
}
```

**Rules**
1. Function names use this_underscore_casing_
2. Function names start with letters.
3. Function names end with underscores. (Followed by semicolon)
4. Function names should be concise. 

**Acceptable**
```
scope Math {
    scope int_to_float_: {}
    scope add_: {}
}
```

**Unacceptable**
```
scope Math {
    scope intToFloat_: {}        // wrong casing
    scope int_to_float: {}       // does not end with an underscore
    scope add_numbers_: {}       // method name is not concise
}
```

# Section VI: Labels Within Functions
To control the flow of execution, assembly programmers use labels.

**Rules**
1. Label names use _that_underscore_casing
2. Label names start with underscores.
3. Numbers at the end of labels should be preceded  by an underscore (this is discouraged).
4. Label names should be concise. 

**Example**
```
scope label_example_: {
    addiu   sp, sp,-0x0008                  // allocate stack space 
    sw      at, 0x0004(sp)                  // save at
    ori     at, r0, 0x0004                  // declare loop counter

    _loop:
    beqz     at, _exit                      // loop termination check (when at == 0)
    nop                                     // nop
    
    // some code here

    b       _loop                           // loop
    addiu   at, at,-0x0001                  // decrement loop counter

    _exit:
    lw      at, 0x0004(sp)                  // restore at
    addiu   sp, sp, 0x0008                  // deallocate stack space
    jr      ra                              // return
    nop                                     // nop
}
```

## Section VI: Documentation
Comment and document all of your code. The worst thing a developer can do to an open source project (outside of break functionality) is keep information in their own head.

**Rules**
1. Document every function, macro, and Super Smash Bros. constant.
2. Comment every line of assembly code. If multiple lines do one thing, a tilde (~) should be placed in the above lines.

**Function Example**
```
// @ Description
// This function takes an integer and return a float. v0 is not conserved.
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
    jr      ra                          // return float through v0
    nop
}
```


## Section VII: Miscellaneous
**Rules**
1. Indent using 4 spaces. Do not use tabs.
2. Avoid duplicate code. Create functions.
3. Avoid unnecessary redundancy. (prefer Math.add_ over Math.add_numbers_).
4. Be consistent.
5. Delete unused code.

## Section IX: MIPS
The following rules are even more arbitrary than the above. Please stick with them.

**Rules**
1. MIPS instructions lower case.
2. Use the 4 space tab following the longest MIPS instruction, `addiu`, for spacing.
3. Avoid `li` for bytes and halfwords. Use `lli` and `ori` instead.
4. Always use 6 digits for numbers (dec uses 00 prefix, hex uses 0x).

**Spacing Example**
```
addiu   t0, t0, 0x0004
sw      t0, 0x0000(t1)
addiu   t0, t0,-000004
j       some_return_address_
nop
```
