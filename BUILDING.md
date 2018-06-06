# Building 19XX

0. Requires `gcc`, `git`, `make`, `bass`, and `xdelta3`
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
5. Copy your vanilla, NTSC-U, big-endian (.z64) ROM titled "original.z64" into the roms folder.
   ```
   $   cp <rom_path> ./roms/original.z64s
   ```
6. Build 19XX.
   ```
   $   make
   ```
   This will create both `19XXTE.z64` and `19XXCE.z64` versions of the hack, and place them into the created `build/` subdirectory.
   If you want to create `xdelta` patches for other people to apply, run `make release`.

# Getting Prerequisites
## `gcc`, `git`, and `make`
## ARM9's Modified `bass` Assembler
The latest version (`v14`) of ARM9's N64-modified `bass` is required to assemble 19XX.

Vist https://github.com/ARM9/bass and follow build instructions to install
## `xdelta3`
The easiest way to install `xdelta3` is to use your package manager:
```
brew xdelta
apt-get xdelta
etc.
```
Alternatively, you can build from source: https://github.com/jmacd/xdelta/releases/tag/v3.1.0
