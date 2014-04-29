#ifndef __MMIO_H__
#define __MMIO_H__

#include <stdint.h>

/**
 * Write to MMIO register.
 */
static inline void mmio_write(uint32_t reg, uint32_t data) {
    uint32_t *ptr = (uint32_t*) reg;
    asm volatile("str %[data], [%[reg]]" : : [reg]"r"(ptr), [data]"r"(data));
}

/**
 * Read from MMIO register
 */
static inline uint32_t mmio_read(uint32_t reg) {
    uint32_t *ptr = (uint32_t*) reg;
    uint32_t data;
    asm volatile("ldr %[data], [%[reg]]" : [data]"=r"(data) : [reg]"r"(ptr));
    return data;
}

#endif
