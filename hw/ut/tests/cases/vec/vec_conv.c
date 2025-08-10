#include "datatype.h"
#include "stdio.h"
#include "uart.h"

#define INPUT_SIZE 5
#define KERNEL_SIZE 3
#define OUTPUT_SIZE (INPUT_SIZE - KERNEL_SIZE + 1)

t_ck_uart_device uart0 = {0xFFFF};

int fputc(int ch, FILE *stream)
{ 
    ck_uart_putc(&uart0, (char)ch);
}

void convolution2D(float input[INPUT_SIZE][INPUT_SIZE], 
                   float kernel[KERNEL_SIZE][KERNEL_SIZE], 
                   float output[OUTPUT_SIZE][OUTPUT_SIZE]) {
    // Perform the 2D convolution
    for (int i = 0; i < OUTPUT_SIZE; i++) {
        for (int j = 0; j < OUTPUT_SIZE; j++) {
            float sum = 0.0f;
            for (int ki = 0; ki < KERNEL_SIZE; ki++) {
                for (int kj = 0; kj < KERNEL_SIZE; kj++) {
                    sum += input[i + ki][j + kj] * kernel[ki][kj];
                }
            }
            output[i][j] = sum;
        }
    }
}

int exe_body(void)
{
    // Initialize a simple 5x5 input matrix
    float input[INPUT_SIZE][INPUT_SIZE] = {
        {1, 2, 3, 4, 5},
        {6, 7, 8, 9, 10},
        {11, 12, 13, 14, 15},
        {16, 17, 18, 19, 20},
        {21, 22, 23, 24, 25}
    };

    // Initialize a simple 3x3 kernel (filter)
    float kernel[KERNEL_SIZE][KERNEL_SIZE] = {
        {1, 0, -1},
        {1, 0, -1},
        {1, 0, -1}
    };

    // Define the output matrix
    float output[OUTPUT_SIZE][OUTPUT_SIZE] = {0};

    // Perform the convolution
    convolution2D(input, kernel, output);

    // Print the output matrix
    printf("Output matrix:\n");
    for (int i = 0; i < OUTPUT_SIZE; i++) {
        for (int j = 0; j < OUTPUT_SIZE; j++) {
            printf("%.2f ", output[i][j]);
        }
        printf("\n");
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
