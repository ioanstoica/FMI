#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <pthread.h>

void *rev(void *s)
{
    char *str = (char *)s;
    int n = strlen(s);
    for (int i = 0; i < n / 2; i++)
    {
        char aux = str[i];
        str[i] = str[n - 1 - i];
        str[n - i - 1] = aux;
    }
}

int main(int argc, char **argv)
{
    pthread_t thr;
    if (pthread_create(&thr, NULL, rev, argv[1]))
    {
        perror(NULL);
        return errno;
    }
    if (pthread_join(thr, NULL))
    {
        perror(NULL);
        return errno;
    }

    rev(argv[1]);
    printf("%s\n", argv[1]);
}