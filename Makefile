# Include test.c, startup.s, and pl011.c in the final binary
TARGET=test.bin
OBJS=test.o startup.o pl011.o
LINK_SCRIPT=qemu.ld

# We initially build an ELF target and later convert it to bin format. The ELF target is still needed for GDB
ELF_TARGET=$(subst .bin,,${TARGET})

# freestanding and nostdlib ignore all of the default startup code that GCC often includes.
# We need to target the cortex-m3 CPU. During linking we'll also generate a map file.
CFLAGS=-ffreestanding -nostdlib -mcpu=cortex-m3 -g
ASFLAGS=-mcpu=cortex-m3 -g
LDFLAGS=-T ${LINK_SCRIPT} -mcpu=cortex-m3 -ffreestanding -nostdlib -g -Xlinker -Map=test.map

# use the text console (no qemu GUI), pause the CPU immediately, and listen for a remove gdb session
QDEBUG=-s -nographic  -S

# The first -serial multiplexes the monitor and first UART to stdin/stdout. The next two listen for telnet
# connections for the other two UARTS. Select the cortex-m3 CPU and the machine/board configuration
QFLAGS= ${QDEBUG} -machine ${RUNTIME_MACHINE} -cpu cortex-m3 -serial mon:stdio -serial telnet:localhost:1235,server -serial telnet:localhost:1236,server

# The lm3s6965 is a stellaris development board with a cortex m3 based MCU. It's one of a couple available
# in QEMU. It's pretty basic but gets the job done.
RUNTIME_MACHINE=lm3s6965evb

# Setup the toolchain
TPREF=arm-none-eabi-
CC=${TPREF}gcc
AS=${TPREF}as
OBJCOPY=${TPREF}objcopy
GDB=${TPREF}gdb

.PHONY: run debug clean

# Convert the ELF target to bin format
${TARGET}: ${ELF_TARGET}
	${OBJCOPY} -O binary $< $@

# Run qemu with the bin target as the kernel. QEMU was originally designed to run Linux, etc. so bin files
# are specified as the kernel. There's a little bit of bootstrap that kicks off our image but we don't really
# care about most of it since we'll be on bare metal.
run:
	qemu-system-arm	${QFLAGS} -kernel ${TARGET}

# Start gdb and connect to the remove interface. The following is added to ~/.gdbinit so you can reconnect by
# typing "rl" instead of restarting gdb.
# define rl
# target remote localhost:1234
# load
# end
debug:
	${GDB} -eval-command="rl" ${ELF_TARGET}

# Dependencies for the ELF target. GNU make defines all the rules for building
${ELF_TARGET}: ${OBJS} ${LINK_SCRIPT}

# Cleanup intermediate files.
clean:
	-${RM} ${RMFLAGS} ${OBJS} ${TARGET} ${ELF_TARGET} test.map
