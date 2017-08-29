/**
 * A simple test program that reads characters from UART0, echos them back to the UART and sends
 * them to UART1 in uppercase.
 */
#include "pl011.h"

/**
 * Just put all characters in a string to UART0
 */
int puts(const char* s)
{
    while (*s)
    {
        if (putchar(*s) == EOF)
            return EOF;
        s++;
    }
    return 0;
}

int main()
{
    /* Prompts are nice so we know we're ready to go */
    puts("mon> ");
    /* Never stop... */
    for (;;)
    {
        /* This will return EOF until there's a character waiting. */
        int tmp = getchar();
        if (tmp != EOF)
        {
            /* echo */
            if (putchar(tmp) == EOF)
                return EOF;
            /* capitalize */
            if ((tmp >= 'a') && (tmp <= 'z'))
                tmp = tmp - 'a' + 'A';
            /* write it to UART1 */
            if (putc(UART1, tmp) == EOF)
                return EOF;
            /* if we get a carriage return, add a line feed so it displays properly */
            if (tmp == '\r')
            {
                if (putchar('\n') == EOF || putc(UART1, '\n') == EOF)
                    return EOF;
            }
        }
    }
    /* That's it. This is unreachable, but we return success anyway so the compiler won't complain */
    return 0;
}
