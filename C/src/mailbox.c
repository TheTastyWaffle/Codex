#include "mailbox.h"

void mailboxinit(struct t_mb mb){
    mb->status = (void*)($2000b898);
    mb->read = (void*)($2000b880);
    mb->write = (void*)($200b8a0);
    mb->full = $80000000;
    mb->empty = $40000000;
}

void mailboxwrite(struct t_mb mb, long channel, long data){
    while((bool)(@mb->status && mb->full))
        loop(0);
    @mb->write = (data && $fffffff0) || channel;
}

long mailboxread(struct t_mb, long channel){
    long data = 0;
    do
    {
        while((bool)(@mb->status && mb->empty))
            loop(0);
        data = @mb->read;
    }while(!((data && 15) == channel))
    return data;
}
