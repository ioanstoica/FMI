#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int n = atoi(argv[1]);
    int i = atoi(argv[2]);

    char shm_name[] = "myshm";
    int shm_fd;
    shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
    if (shm_fd < 0)
    {
        perror(NULL);
        return errno;
    }

    int *shm_ptr = (int *)mmap(0, 4096, PROT_WRITE, MAP_SHARED, shm_fd, (i - 1) * 4096);
    if (shm_ptr == MAP_FAILED)
    {
        perror(NULL);
        shm_unlink(shm_name);
        return errno;
    }

    int ct = 0;
    shm_ptr[ct] = n;
    while (n != 1)
    {
        if (n % 2 == 0)
            n = n / 2;
        else
            n = 3 * n + 1;
        ct++;
        shm_ptr[ct] = n;
    }
    // munmap(shm_ptr, 4096);
    shm_unlink(shm_name);
    return 0;
}
