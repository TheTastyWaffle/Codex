#include "gpio.h"
#include "uart.h"

struct t_mb{
    long[8] data;
    long* status, read, write;
    long full, empty, data;
}

void mailboxinit(struct t_mb);
void mailboxwrite(struct t_mb, long, long);
long mailboxread(struct t_mb, long);
