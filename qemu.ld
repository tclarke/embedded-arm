/**
 * QEMU lm3s6965evb ARM Cortex-M3 board
 * Linker script designed to layout the executable such that it load in QEMU.
 */

/**
 * We initially execute the reset interrupt. This isn't used by qemu which starts executing at a fixed addess
 * but this provides a hint to gdb.
 */
ENTRY(_Reset)

/**
 * Memory layout. 256k of flash followed by 64k of RAM. Don't worry about the redefinition warnings when compiling.
 */
MEMORY
{
    flash (rx) : ORIGIN = 0x00000000, LENGTH = 256K
    ram  (rwx) : ORIGIN = 0x20000000, LENGTH =  64K
}
SECTIONS
{
    /**
     * .text contains all of our code. We force the INTERRUPT_VECTOR block to come first
     * but after that, the linker can put the rest of the code in any order it wants.
     */
    .text : {
        startup.o (INTERRUPT_VECTOR)
        * (.text)
    }>ram
    
    /**
     * Make sure program data and the bss (global variables) are loaded into RAM or you'll
     * have some weird errors..local variables won't ever change value, etc.
     */
    .data : { * (.data) }>ram
    .bss : { * (.bss COMMON) }>ram

    /**
     * Align everything before we create the stack, then create a 4k stack at the top of the data and bss
     * This probably should go at the top of RAM so it's not quite in danger of clobbering data but this
     * will be fine for now.
     */
    . = ALIGN(8);
    . = . + 0x1000;     /* 4kb stack */
    /* Set the stack_top linker value to the TOS so we can setup the sp in startup.s */
    stack_top = .;
}
