/**
 * Basic character I/O support for the PL011 UART that's emulated on our target board.
 */
#include "pl011.h"

/**
 * The base addresses of the three UARTS as specified in http://www.ti.com/lit/ds/symlink/lm3s6965.pdf
 */
pl011_T* const UART0 = (pl011_T *)0x4000C000;
pl011_T* const UART1 = (pl011_T *)0x4000D000;
pl011_T* const UART2 = (pl011_T *)0x4000E000;
 
/**
 * Put a character to the default UART (usually UART0)
 * This functions like the POSIX putchar()
 */
int putchar(int c)
{
    return putc(DEFAULT_UART, c);
}

/**
 * Put a character to the specified UART.
 * Almost POSIX putc() but we use our UART struct instead of FILE*
 * Returns the character put or EOF if the UART TX buffer is full.
 */
int putc(pl011_T* const uart, int c)
{
    if (uart->FR & TXFF)
        return EOF;
    uart->DR = c;
    return c;
}

/**
 * Get a character from the default UART (usuallt UART0)
 * This functions like the POSIX getchar()
 */
int getchar()
{
    return getc(DEFAULT_UART);
}

/**
 * Get a character from the specified UART.
 * Almost POSIX getc() but we use our UART struct instead of FILE*
 * Returns EOF when there are no available characters, instead of blocking.
 */
int getc(pl011_T* const uart)
{
    if ((uart->FR & RXFE) == 0)
    {
        return uart->DR;
    }
    return EOF;
}
