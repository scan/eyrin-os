#include <stdint.h>
#include <uart.h>

#define UNUSED(x) (void)(x)

const char hello[] = "\r\nHello World\r\n";
const char halting[] = "\r\n*** system halting ***";

int main(long r0, long r1, long atags) {
    UNUSED(r0);
    UNUSED(r1);
    UNUSED(atags);

    uart_init();
 
    uart_puts(hello);
 
    // Wait a bit
    for(volatile int i = 0; i < 10000000; ++i) { }
 
    uart_puts(halting);

    return 0;
}
