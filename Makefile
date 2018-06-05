PROGRAM_NAME=19XX
DATE=`date +%m%d%Y`

all:
	# apply texture patch
	# xdelta3 -d -f -s roms/original.z64 textures/textures.xdelta roms/original_textured.z64

	# temporary
	cp roms/original.z64 roms/original_textured.z64

	# assemble rom
	tools/_bass -o roms/$(PROGRAM_NAME)CE.z64 $(PROGRAM_NAME)CE.asm -sym CE.log
	tools/_bass -o roms/$(PROGRAM_NAME)TE.z64 $(PROGRAM_NAME)TE.asm -sym TE.log

	# update checksum
	tools/n64crc roms/$(PROGRAM_NAME)CE.z64
	tools/n64crc roms/$(PROGRAM_NAME)TE.z64

	# remove original_textured
	rm -rf roms/original_textured.z64

	# show time stamp
	date

build:
	# clean
	make clean

	# build tools
	cd tools; make
	cp tools/bass/bass/bass tools/_bass

	# remove bass git repository
	rm -rf tools/bass

debug:
	# make
	make

	# display file
	cat CE.log

	# show timestamp
	date

scrub:
	# remove patches
	rm -rf patches/*.xdelta

clean:
	# remove roms
	rm -rf roms/$(PROGRAM_NAME)*.z64

	# remove patches
	rm -rf patches/$(PROGRAM_NAME)*.xdelta

	# remove log files
	rm -rf *.log

	# remove bass github repository
	rm -rf tools/bass

	# remove executables
	rm -rf tools/*.exe
	rm -rf tools/_bass
	rm -rf tools/n64crc

	# remove patches
	make scrub

release:
	# create patch files
	xdelta3 -e -f -s roms/original.z64 roms/$(PROGRAM_NAME)CE.z64 patches/$(PROGRAM_NAME)CE_$(DATE).xdelta
	xdelta3 -e -f -s roms/original.z64 roms/$(PROGRAM_NAME)TE.z64 patches/$(PROGRAM_NAME)TE_$(DATE).xdelta