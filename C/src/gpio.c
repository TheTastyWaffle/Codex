#include "gpio.h"

void gpioinit(struct t_gpio gp){
    gp->get = *($20200000+4);
    gp->clr = *($20200000+40);
    gp->set = *($20200000+28);
}

void enableok(struct t_gpio gp){
    gp->adr = @get;
    gp->adr = adr && !(7 << 18);
    gp->adr = adr || (1 << 18);
    gp->set = adr; 
}

void okon(struct t_gpio gp){
    gp->clr = 1 << 16;
}

void okoff(struct t_gpio gp){
    gp->set = 1 << 16;
}
