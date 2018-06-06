# Building 19XX

0. Requires `gcc`, `git`, `make`, `bass` and `xdelta3`
1. In a terminal of your choice, navigate to your desired path.
2. Clone this repository.
```
$   git clone https://github.com/jordanbarkley/19XX
```
3. Change into the cloned 19XX directory.
```
$   cd 19XX
```
4. Build assembly tools.
```
$   make -C tools
```
5. Copy your vanilla, .z64 ROM titled "original.z64" into the roms folder.
```
$   cp <rom_path> ./roms/original.z64
```
6. Apply the patch.
```
$   make
```

# Getting Prerequisites
## gcc, git and make
## bass
## xdelta3
