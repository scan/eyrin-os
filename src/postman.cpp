#include <reg.h>
#include <postman.h>

#define MAIL_BASE 0xb880

#define MAIL_FULL  0x80000000
#define MAIL_EMPTY 0x40000000

#define READ_OFFSET 0x00
#define POLL_OFFSET 0x10
#define SENDER_OFFSET 0x14
#define STATUS_OFFSET 0x18
#define CONFIG_OFFSET 0x1c
#define WRITE_OFFSET 0x20 

uint32_t readMailbox(uint8_t channel) {
    channel &= 0xf;

    for(;;) {
        while((readMemMappedReg<uint32_t>(MAIL_BASE, STATUS_OFFSET) & MAIL_EMPTY) != 0);
        uint32_t data = readMemMappedReg<uint32_t>(MAIL_BASE, READ_OFFSET);
        uint8_t readChannel = data & 0xf;
        data >>= 4;
        if(readChannel == channel) {
            return data;
        }
    }
}

void writeMailbox(uint32_t data, uint8_t channel) {
    while((readMemMappedReg<uint32_t>(MAIL_BASE, STATUS_OFFSET) & MAIL_FULL) != 0);
    writeMemMappedReg<uint32_t>(MAIL_BASE, WRITE_OFFSET, (data << 4) | channel);
}
