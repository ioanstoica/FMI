#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string.h>

int main(int argc, char *argv[]) {
    char shm_name [] = "myshm";
    int shm_fd ;
    shm_fd = shm_open ( shm_name , O_CREAT | O_RDWR , S_IRUSR | S_IWUSR );
    if ( shm_fd < 0) {
        perror ( NULL );
        return errno ;
    }

    size_t shm_size = 4096 * (argc-1);
    if ( ftruncate ( shm_fd , shm_size ) == -1) {
        perror ( NULL );
        shm_unlink ( shm_name );
        return errno ;
    }

    for (int i=1; i < argc; i++)
    {        
        pid_t pid = fork ();
        if ( pid < 0)
            return errno ;
        else if ( pid == 0)
        {
            /* child instructions */
            char nr[10];
            sprintf(nr, "%d", i);
            char *argv2[] = {"collatz2", argv[i], nr, NULL };
            execve ("/home/ubuntu/dev/SO/collatz2" , argv2 , NULL );
            perror ( NULL );
        }
        else
        {
            /* parent instructions */
            wait ( NULL );
            printf ("Done Parent %d Me %d\n" , getppid(), getpid());

            int *shm_ptr = (int *)mmap (0 ,  shm_size, PROT_READ , MAP_SHARED , shm_fd , 0);
            if ( shm_ptr == MAP_FAILED ) {
                perror ( NULL );
                shm_unlink ( shm_name );
                return errno ;
            }   

            int *answr = shm_ptr + (i-1) * 1024;
            int cnt = 0;
            while(answr[cnt]!= 0)
                printf("%d ", answr[cnt++]);
            munmap(shm_ptr, shm_size);
        }
    }
    shm_unlink(shm_name);
	return 0;
}
