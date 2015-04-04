struct t_gpio{
    long *get, set, clr;
    long adr;
}

void gpioinit(struct t_gpio);
void enableok(struct t_gpio);
void okon(struct t_gpio);
void okoff(struct t_gpio);
void loop (long);
