/**
 * Basic character I/O support for the PL011 UART that's emulated on our target board.
 */

#ifndef PL011_H__
#define PL011_H__

#include <stdint.h>
 
/**
 * Struct specifying the memory layout of the UART registers as defined in http://www.ti.com/lit/ds/symlink/lm3s6965.pdf
 */
typedef volatile struct {
    uint32_t DR;
    uint32_t RSR_ECR;
    uint8_t reserved1[0x10];
    const uint32_t FR;
    uint8_t reserved2[0x4];
    uint32_t LPR;
    uint32_t IBRD;
    uint32_t FBRD;
    uint32_t LCR_H;
    uint32_t CR;
    uint32_t IFLS;
    uint32_t IMSC;
    const uint32_t RIS;
    const uint32_t MIS;
    uint32_t ICR;
    uint32_t DMACR;
} pl011_T;
 
/**
 * Status word values
 */
enum {
    RXFE = 0x10,
    TXFF = 0x20,
};
 
/**
 * The three UARTS on the target board.
 */
extern pl011_T* const UART0;
extern pl011_T* const UART1;
extern pl011_T* const UART2;

/**
 * UART0 is attached to stdio so it's our default UART
 */
#define DEFAULT_UART UART0
#define EOF -1

extern int putchar(int c);
extern int putc(pl011_T* const uart, int c);
extern int getchar();
extern int getc(pl011_T* const uart);

#endif
