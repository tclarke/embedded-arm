/**
 * QEMU lm3s6965evb ARM Cortex-M3 board
 */

ENTRY(_Reset)
MEMORY
{
    flash (rx) : ORIGIN = 0x00000000, LENGTH = 256K
    ram  (rwx) : ORIGIN = 0x20000000, LENGTH =  64K
}
SECTIONS
{
    .text : {
        startup.o (INTERRUPT_VECTOR)
        * (.text)
    }>ram
    .data : { * (.data) }>ram
    .bss : { * (.bss COMMON) }>ram
    . = ALIGN(8);
    . = . + 0x1000;     /* 4kb stack */
    stack_top = .;
}
