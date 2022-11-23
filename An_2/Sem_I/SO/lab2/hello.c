#include <stdio.h>
#include <unistd.h>

int main ()
{
    write(1, "Hei!", 5);
    return 0;
}