#include "datatype.h"
#include "stdio.h"
#include "uart.h"

#define SIZE 1024

t_ck_uart_device uart0 = {0xFFFF};

int fputc(int ch, FILE *stream)
{ 
    ck_uart_putc(&uart0, (char)ch);
}

int exe_body(void)
{
    // Initialize two arrays (vectors) with sample values
    float vector1[SIZE], vector2[SIZE], result[SIZE];
    
    // Fill the arrays with some sample data
    for (int i = 0; i < SIZE; i++) {
        vector1[i] = i * 1.0f; // Example: vector1 contains 0.0, 1.0, 2.0, ...
        vector2[i] = (SIZE - i) * 1.0f; // Example: vector2 contains 1024.0, 1023.0, ...
    }
    
    // Perform element-wise multiplication
    for (int i = 0; i < SIZE; i++) {
        result[i] = vector1[i] * vector2[i];
    }
    
    // Print the first few results to verify the output
    printf("First 10 results of vector multiplication:\n");
    for (int i = 0; i < 10; i++) {
        printf("result[%d] = %.2f\n", i, result[i]);
    }
    
    return 0;
}

int main (void)
{
    //--------------------------------------------------------
    // setup uart
    //--------------------------------------------------------
    t_ck_uart_cfig   uart_cfig;
    
    uart_cfig.baudrate = BAUD;       // any integer value is allowed
    uart_cfig.parity = PARITY_NONE;     // PARITY_NONE / PARITY_ODD / PARITY_EVEN
    uart_cfig.stopbit = STOPBIT_1;      // STOPBIT_1 / STOPBIT_2
    uart_cfig.wordsize = WORDSIZE_8;    // from WORDSIZE_5 to WORDSIZE_8
    uart_cfig.txmode = ENABLE;          // ENABLE or DISABLE
    // open UART device with id = 0 (UART0)
    ck_uart_open(&uart0, 0);
    // initialize uart using uart_cfig structure
    ck_uart_init(&uart0, &uart_cfig);
    // function
    exe_body();
    // close uart
    ck_uart_close(&uart0);
    return 0;
}
