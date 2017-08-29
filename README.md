# embedded-arm
Experiments and tutorials with arm cortex microcontrollers and qemu

Each github release builds on the previous ones.

QEMU ARM Getting Started
========================
This tutorial shows you how to get started with cortex M3 emulation in qemu. It creates a basic read-print loop
that mirrors the input to a second UART translating all letters to uppercase. This contains all the basics to get
setup including a link script, startup code, and a Makefile with useful commands.

Prerequisites
-------------
* An arm-none-eabi toolchain. Can usually be installed with apt, yum, brew, etc.
* A recent versuion of QEMU with ARM support enabled. Usually available in your favorite package manager.
* Telnet, netcat, etc. for connecting to the secondary UART devices.

Walkthrough
-----------
The embedded video shows the code executing with telnet access to the secondary UARTS. The primary is multiplexed
with the QEMU monitor. CTRL-A,C to change between the monitor and the UART. More detailed explainations are located
in the code files. tmux is used to separate the various display windows.

1. First, the code is built and converted to the bin format required by QEMU.
1. Next, QEMU is started and waits for connections from the secondard UARTS and GDB.
1. Telnet is used to connect to the secondary UARTS.
1. GDB is connected to the remote debugger interface. It is demonstrated that standard GDB commands like list and break
work as expected. ~/.gdbinit is configured with a command function `rl` which performs `target remote localhost:1234` to connect to the remote debug interface, followed by `load` to load the symbols from the remote process.
1. We type some strings into the primary UART and see that they are echoed.
1. We look at the second UART to see the strings displayed in uppercase.

[![asciicast](https://asciinema.org/a/d1h147knOmPUMve7F0vQwgWee.png)](https://asciinema.org/a/d1h147knOmPUMve7F0vQwgWee)
