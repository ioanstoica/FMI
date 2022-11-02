#include <stdio.h>
#include <stdlib.h>

int main()
{
    printf("Hello world!\n");
    int input = 10;
    int n=input/2;
    int v[100] = {0};
    v[1] = 1;
    v[2] = 2;
    v[3] = 4;

    for(int i=4;i<=n;i++)
        v[i] = v[i-1] + v[i-2] + v[i-3];

    printf("%d", v[n]);
    return 0;
}
