#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>     /* malloc, free, rand */


int main (int *argc, char **args)
{
    int fin = open (args[1], O_RDONLY);
    int fout = open (args[2], O_WRONLY);

    ssize_t nread = 1;
    ssize_t nbytes = 5;
    void *buf = malloc(100);
    do 
    {
        nread =  read ( fin, buf , nbytes );
        write(fout, buf, nread);
    }
    while(nread>0);    
    return 0;
}