/* These are necessary for proper function. We are using THUMB2 on the CORTEX M3 and some implementations
 * do not support ARM instructions so you'll see lots of assembly errors without this.
 */
.thumb
.syntax unified

/* Create an executable section for the interrupt vector table. Add a reset handler and setup the other interrupts
 * so they just spin the CPU if they trigger.
 */
.section INTERRUPT_VECTOR, "x"
.global _Reset
_Reset:
    B _Reset_Handler
    B .
    B .
    B .
    B .
    B .
    B .
    B .

/* The reset interrupt handler. It's pretty simple, just load the TOS location into the stack pointer
 * then branch to the main() C function. If we return from main(), spin the CPU
 */
_Reset_Handler :
    ldr sp, =stack_top
    bl main
    b .
