#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string.h>

void *hello(void *v)
{
    char *who = (char *)v;
    printf(" Hello , % s !", who);
    return NULL;
}

char *invers(char *v)
{
    int i;
    char *res = malloc(sizeof(char) * 256);
    int n = strlen(v);
    for (int i = 0; i < n; i++)
        res[i] = v[n - i - 1];
    return res;
}

int A[2][3] = {
    {1, 2, 3},
    {4, 5, 6}};

int B[3][2] = {{1, 1}, {1, 1}, {1, 1}};

int C[2][2];

struct coord
{
    int i, j;
};

void *solve_bro(void *position)
{
    struct coord *index = position;
    int i = index->i;
    int j = index->j;
    free(position);
    C[j][i] = 0;
    int k;
    for (k = 0; k < 3; k++)
        C[j][i] += A[j][k] * B[k][i];
    return NULL;
}

int main(int argc, char *argv[])
{
    pthread_t thr;
    char *result = argv[1];
    if (pthread_create(&thr, NULL, invers, result))
    {
        perror(NULL);
        return errno;
    }
    int pthread_join(pthread_t thread, void **value_ptr);
    if (pthread_join(thr, &result))
    {
        perror(NULL);
        return errno;
    }
    else
    {
        pthread_join(thr, &result);
        printf("%s \n", result);
    }
    pthread_t threads[10];
    int threadId = 0;
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 2; j++)
        {
            struct coord *index = malloc(sizeof(struct coord));
            index->i = i;
            index->j = j;
            if (pthread_create(&threads[threadId++], NULL, solve_bro, index))
            {
                perror(NULL);
                return errno;
            }
        }
    for (int i = 0; i < threadId; i++)
    {
        if (pthread_join(threads[i], NULL))
        {
            perror(NULL);
            return errno;
        }
        else
            printf("We are the %d thread \n", i);
    }
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            printf("%d ", C[i][j]);
        }
        printf("\n");
    }
    // printf("%d ", C[i][j]);
    return 0;
}