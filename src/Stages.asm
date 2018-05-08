// Stages.asm

scope Stages {
	//macro Stage(id, preview, type, franchise, name)

	scope getPreview_: {
	//	OS.pat

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
	lb 		v0, 0x0000(t2) 					// load custom byte from stage table
	lui 	s1, 0x800A 						// ~
	sb 		v0, 0x4ADF(s1) 					// store custom byte
	OS.patch_end()

	OS.patch_start(0x0014DFFC, 0x00000000)
	lb 		v0, 0x0003(t2) 					// modified stage load instruction
	OS.patch_end()

	OS.patch_start(0x0014F7A4, 0x80133C34)
	sb 		v0, 0x4B11(s1) 					// remember sss cursor
	OS.patch_end()

	OS.patch_start(0x0014F7C4, 0x00000000)
	sb 		v0, 0x4B12(s1) 					// [tehz]
	OS.patch_end()

	// @ Description
	// This is a fix written by tehz to update the cursor based on stage id instead of in a static
	// table. It's very nice.
	// @ TODO
	// document the function
	OS.patch_start(0x0014E02C, 0x00000000)
	lui 	at, 0x8013
	ori 	at, at, 0x4644
	or 		v0, r0, r0

	_loop:
	lbu 	t6, 0x0003(at)
	beq 	t6, a0, _end

	_check:
	ori	 	t6, r0, 0x0008
	beq 	t6, v0, _loop


	_loopInc:
	addiu 	v0, v0, 0x0001
	beq 	r0, r0, _loop
	addiu 	at, at, 0x0004

	_end:
	jr 		ra
	nop

	_fail:
	jr 		ra
	or 		v0, r0, r0
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
	sll 	s0, s0, 0x0002
	addu 	s0, ra, s0
	b 		0x80133C14
	lb 		v0, 0x0A5C(s0)
	OS.patch_end()


	// @ Description
	// This updates a table of floats for the stage previews.
	OS.patch_start(0x001503CC, 0x00000000)
	float32 0.5
	OS.patch_end()

	OS.patch_start(0x001503E8, 0x00000000) 
	float32 0.5
	OS.patch_end()
}