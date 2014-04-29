#ifndef __UART_H__
#define __UART_H__

#include <stdint.h>

/**
 * Initialize UART0.
 */
void uart_init();

/**
 * Transmit a byte via UART0.
 */
void uart_putc(uint8_t byte);

/**
 * Send a string of bytes to UART0, one byte at a time.
 */
void uart_puts(const char *str);

#endif
