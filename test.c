#include "pl011.h"

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
    puts("mon> ");
    for (;;)
    {
        int tmp = getchar();
        if (tmp != EOF)
        {
            if (putchar(tmp) == EOF)
                return EOF;
            if ((tmp >= 'a') && (tmp <= 'z'))
                tmp = tmp - 'a' + 'A';
            if (putc(UART1, tmp) == EOF)
                return EOF;
            if (tmp == '\r')
            {
                if (putchar('\n') == EOF || putc(UART1, '\n') == EOF)
                    return EOF;
            }
        }
    }
    return 0;
}
