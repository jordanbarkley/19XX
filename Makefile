############ Targets and Source Files ############
BUILD_DIR := build

PROGRAM_BASE_NAME := 19XX
TE := $(PROGRAM_BASE_NAME)TE
TE_MAIN := $(TE).asm
TE_ROM  := $(BUILD_DIR)/$(TE).z64

CE := $(PROGRAM_BASE_NAME)CE
CE_MAIN := $(CE).asm
CE_ROM  := $(BUILD_DIR)/$(CE).z64

ASM_DIRS := src
ASM_FILES := $(foreach dir,$(ASM_DIRS),$(wildcard $(dir)/*.asm))

# Eventually, this patch should be generated from the input textures
TEX_DIR := textures
TEX_PATCH := $(TEX_DIR)/textures.xdelta
TEXTURED_ROM := $(BUILD_DIR)/textured_temp.z64

############ Initial ROM Info ############
ROM_DIR := roms
ORG_ROM := $(ROM_DIR)/original.z64

############ Assembler Options ############
AS := bass
ASFLAGS := -create

############ Patcher Options ############
PATCHER := xdelta3
PATCHFLAGS := -f

############ Other Tools ############
TOOLS_DIR := tools
N64CRC := $(TOOLS_DIR)/n64crc

default: all

all: CE TE

release: all
	$(PATCHER) -e $(PATCHFLAGS) -s $(ORG_ROM) $(CE_ROM) $(CE_ROM:.z64=.xdelta)
	$(PATCHER) -e $(PATCHFLAGS) -s $(ORG_ROM) $(TE_ROM) $(TE_ROM:.z64=.xdelta)

CE: $(CE_ROM)

TE: $(TE_ROM)

clean:
	$(RM) -r $(BUILD_DIR)

# remove patches only
scrub:
	$(RM) $(CE_ROM:.z64=.xdelta) $(TE_ROM:.z64=.xdelta)

$(CE_ROM): $(TEXTURED_ROM) $(CE_MAIN) $(ASM_FILES)
	$(AS) $(ASFLAGS) $(CE_MAIN) -o $(CE_ROM) -d __BASEROM="$(TEXTURED_ROM)" -sym $(CE_ROM:.z64=.log)
	$(N64CRC) $(CE_ROM)

$(TE_ROM): $(TEXTURED_ROM) $(TE_MAIN) $(ASM_FILES)
	$(AS) $(ASFLAGS) $(TE_MAIN) -o $(TE_ROM) -d __BASEROM="$(TEXTURED_ROM)" -sym $(TE_ROM:.z64=.log)
	$(N64CRC) $(TE_ROM)

$(TEXTURED_ROM): $(TEX_PATCH) $(ORG_ROM) | $(BUILD_DIR) 
	$(PATCHER) -d $(PATCH_FLAGS) -s $(ORG_ROM) $(TEX_PATCH) $(TEXTURED_ROM)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

.PHONY: default all release CE TE clean scrub
