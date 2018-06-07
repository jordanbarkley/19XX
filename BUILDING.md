# Building


## Prequesites
### `gcc`, `git`, and `make`
For Linux and macOS, these are built-in (`clang` is fine for `gcc`). For Windows 10 users, the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) is recommended. To install for previous Windows versions, see [MSYS2](https://www.msys2.org/), [Cygwin](https://www.cygwin.com/), or [MinGW](http://www.mingw.org/). 

### `xdelta3`
The easiest way to install `xdelta3` is to use your package manager.
#### Linux (and Windows Subsystem for Linux)
```
$   apt-get xdelta3
```

#### macOS
```
$   brew xdelta
```

#### Windows (using pacman)
```
$   pacman -S xdelta3
```

## 19XX
1. In a terminal of your choice, navigate to your desired path.
2. Clone this repository.
```
$   git clone https://github.com/jordanbarkley/19XX
```
3. Navigate to the 19XX directory.
```
$   cd 19XX
```

4. Build assembly tools.
```
$   make build
```

5. Copy your vanilla, NTSC-U, big-endian (.z64) ROM titled "original.z64" into the roms folder.
```
$   cp <rom_path> ./roms/original.z64
```

6. Build 19XXTE and 19XXCE
```
$   make
```
