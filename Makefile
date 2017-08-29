TARGET=test.bin
OBJS=test.o startup.o pl011.o
LINK_SCRIPT=qemu.ld

ELF_TARGET=$(subst .bin,,${TARGET})

CFLAGS=-ffreestanding -nostdlib -mcpu=cortex-m3 -g
ASFLAGS=-mcpu=cortex-m3 -g
LDFLAGS=-T ${LINK_SCRIPT} -mcpu=cortex-m3 -ffreestanding -nostdlib -g -Xlinker -Map=test.map
QDEBUG=-s -nographic  -S
QFLAGS= ${QDEBUG} -machine ${RUNTIME_MACHINE} -cpu cortex-m3 -serial mon:stdio -serial telnet:localhost:1235,server -serial telnet:localhost:1236,server

TPREF=arm-none-eabi-
RUNTIME_MACHINE=lm3s6965evb
CC=${TPREF}gcc
AS=${TPREF}as
OBJCOPY=${TPREF}objcopy
GDB=${TPREF}gdb

.PHONY: run debug clean

${TARGET}: ${ELF_TARGET}
	${OBJCOPY} -O binary $< $@

run:
	qemu-system-arm	${QFLAGS} -kernel ${TARGET}

debug:
	${GDB} -eval-command="rl" ${ELF_TARGET}

${ELF_TARGET}: ${OBJS} ${LINK_SCRIPT}

clean:
	-${RM} ${RMFLAGS} ${OBJS} ${TARGET} ${ELF_TARGET} test.map
