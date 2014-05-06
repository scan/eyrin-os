#include <stdint.h>
#include <postman.h>

#define UNUSED(x) (void)(x)

const char hello[] = "\r\nHello World\r\n";
const char halting[] = "\r\n*** system halting ***";

int main(long r0, long r1, long atags) {
    UNUSED(r0);
    UNUSED(r1);
    UNUSED(atags);

    return 0;
}
