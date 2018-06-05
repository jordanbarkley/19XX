PROGRAM_NAME=19XX

all:
	# assemble rom
	tools/_bass -o roms/$(PROGRAM_NAME)CE.z64 $(PROGRAM_NAME)CE.asm -sym bass.log
	tools/_bass -o roms/$(PROGRAM_NAME)TE.z64 $(PROGRAM_NAME)TE.asm -sym bass.log

	# update checksum
	tools/n64crc roms/$(PROGRAM_NAME)CE.z64
	tools/n64crc roms/$(PROGRAM_NAME)TE.z64

	# create patch files
	xdelta3 -e -f -s roms/original.z64 roms/$(PROGRAM_NAME)CE.z64 patches/$(PROGRAM_NAME)CE.xdelta
	xdelta3 -e -f -s roms/original.z64 roms/$(PROGRAM_NAME)TE.z64 patches/$(PROGRAM_NAME)TE.xdelta

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
	cat bass.log

	# show timestamp
	date

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
