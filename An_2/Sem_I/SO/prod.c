#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <pthread.h>
#include <stdlib.h>

struct matrix
{
    // int m, p, n;
    // int **A;
    // int **B;
    // int l;
    // int c;
    int rez;
};

void *mul(void *mat)
{
    // struct matrix matr= (struct matrix) mat;
    // matr->rez = 5;
    int *rez = (int)malloc(sizeof(int));
    *rez = 5;
    return rez;
}

int main()
{
    // int m=3;
    // int p=3;
    // int n=3;
    // int A[3][3] = {{1,0,0},{0,1,0},{0,0,1}};
    // int B[3][3] = {{1,0,0},{0,1,0},{0,0,1}};
    // int C[10][10];

    struct matrix *mat = (struct matrix *)malloc(sizeof(struct matrix));

    // int *rez =  malloc(sizeof(int));
    void *rez;

    pthread_t thr;
    if (pthread_create(&thr, NULL, mul, mat))
    {
        perror(NULL);
        return errno;
    }
    if (pthread_join(thr, &rez))
    {
        perror(NULL);
        return errno;
    }

    printf("%d\n", ((int)rez));
    // printf("%d\n", mat->rez);

    free(rez);
}