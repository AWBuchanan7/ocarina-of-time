# The Legend of Zelda: Ocarina of Time

This is a disassembly of The Legend of Zelda: Ocarina of Time 1.0.

### Requirements

* Linux or Windows 10 with Windows Subsystem for Linux.
* GCC and GNU Make
* Python 2.x or 3.x (for extracting the baserom files)
* An existing copy of the v1.0 ROM named `baserom.z64` in the repository directory.
* GNU binutils compiled for the `mips64-elf` target
* The IRIS Development Option 5.3 C compiler
* [irixemu](https://github.com/camthesaxman/irixemu) This is a special modified version of QEMU meant for running IRIX executables on Linux.

### Setting up and building

If you plan to get started by using Windows 10 and the Windows Subsystem for Linux, see the section below this for more detailed guidance.

* Download the freeware IDO 5.3 compiler, and extract it.
* Build the tools with `make -C tools`
* Run `python extract_baserom.py` to extract files from baserom.z64
* Set the following environment variables:
  - `MIPS_BINUTILS` - path to mips64-elf binutils.
  - `QEMU_IRIX` - path to the irixemu `qemu-mips` binary.
  - `IRIX_ROOT` - directory where you extracted the IDO 5.3 compiler. This directory should contain `usr` and `lib` subdirectories.
* Build the ROM by running `make`, alternatively on a Windows system you can use build.ps1.

### Using Windows 10 with WSL (For Beginners)

Before you get started, know that you MUST have an `Ocarina of Time v1.0.z64` ROM already. We need to have the base ROM to extract files from that we'll then use to build the ROM ourselves.  Once you have the ROM, rename it to `baserom.z64` and place it in the root directory of the repository.

First you will need to install [WSL (Windows Subsystem for Linux)](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

Within WSL, install GCC, GNU Make, and Python. This is as simple as running the following commands:
```
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install build-essential python
```

You'll next need [GNU binutils](https://mirror.its.dal.ca/gnu/binutils/). Download, extract, and build binutils for the target `mips64-elf`. I recommend placing the built binutils files in the `./tools/` directory such that your end result should produce: `./tools/binutils/bin`. Roughly, this process looks something like this:
```
$ mkdir ./tools/binutils
$ cd ./tools/binutils
$ ../binutils-2.32/configure --target=mips64-elf
$ make all
$ make install
```
