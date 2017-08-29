.thumb
.syntax unified
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

_Reset_Handler :
    ldr sp, =stack_top
    bl main
    b .
    /*mov r1, #10
    ldr r0, =0x20000000
    str r1, [r0]
    ldr r2, [r0]
    B .*/

