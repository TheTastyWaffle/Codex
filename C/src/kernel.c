#include <stdlib.h>
#include <stdio.h>
#include "gpio.h"
#include "uart.h"
#include "mailbox.h"
#include "frameBuffer.h"


void wait(){
    volatile int wait = $3F000;

    while(wait != 0)
        wait--;
}

int main(){
    int flag = 0;
    t_mb *mb;
    long width, height;

    struct t_gpio gp;
    gpioinit(gp);
    enableok(gp);
    uartinit(gp);
    struct t_mb mb;
    mailboxinit(gp);

    //mb->data = *($1000);

    mb->data[0] = 8*4;
    mb->data[1] = 0;
    mb->data[2] = $40003;
    mb->data[3] = 8;
    mb->data[4] = 0;
    mb->data[5] = 0;
    mb->data[6] = 0;
    mb->data[7] = 0;

    mailboxwrite(mb, 8, $1000);

    width = mb->data[5];
    height = mb->data[6];

    okon(gp);

    /*frameBufferinit();
    frameBufferfill();

    while(flag)
    {
        uart_puts("resolution");
        uart_puts(to_hex(width));
        uart_puts("|");
        uart_puts(to_hex(height));
        uart_puts("end resolution");

        frameBufferdebug();
    }*/

    return 0;
}

