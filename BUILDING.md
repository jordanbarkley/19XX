# Building

0. Requires `make` and `xdelta3`
1. In a terminal of your choice, navigate to your desired path.
2. Clone this repository.
```
$   git clone https://github.com/jordanbarkley
```
3. Change direcotories.
```
$   cd 19XX
```

4. Build assembly tools.
```
$   make build
```

5. Copy your vanilla, .z64 ROM titled "original.z64" into the roms folder.
```
$   cp <rom_path> ./roms/original.z64
```

6. Apply the patch.
```
$   make
```
