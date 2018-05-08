// Camera.asm

scope Camera {

	// @ Description
	// This replaces a call to Global.random_int_. Usually, when 0 is returned, the cinematic entry
	// does not play. Here, v0 is always set to 0. 
	// @ Warning
	// This is not a function and should not be called.
	scope disable_cinematic_: {
		OS.patchStart(0x0008E250, 0x80112A50)
		or 			v0, r0, r0
		nop
		OS.patchEnd()
	
		break 								// breka execution in case this gets called
	}
}


