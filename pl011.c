#include "pl011.h"

pl011_T* const UART0 = (pl011_T *)0x4000C000;
pl011_T* const UART1 = (pl011_T *)0x4000D000;
pl011_T* const UART2 = (pl011_T *)0x4000E000;
 
int putchar(int c)
{
    return putc(DEFAULT_UART, c);
}

int putc(pl011_T* const uart, int c)
{
    if (uart->FR & TXFF)
        return EOF;
    uart->DR = c;
    return c;
}

int getchar()
{
    return getc(DEFAULT_UART);
}

int getc(pl011_T* const uart)
{
    if ((uart->FR & RXFE) == 0)
    {
        return uart->DR;
    }
    return EOF;
}
