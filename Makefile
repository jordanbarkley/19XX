FILENAME=19XX

all:
	# assemble rom
	tools/_bass -o $(FILENAME).z64 $(FILENAME).asm -sym
	
	# update checksum
	tools/chksum64 $(FILENAME).z64 > chksum64.log
	
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
	rm -rf $(FILENAME).z64

	# remove log files
	rm -rf *.log
	
	# remove patch files
	rm -rf $(FILENAME).patch

	# remove bass github repository
	rm -rf tools/bass

	# remove executables
	rm -rf tools/*.exe
	rm -rf tools/_bass
	rm -rf tools/chksum64