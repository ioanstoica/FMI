#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
    pid_t pid = fork ();
    if ( pid < 0)
        return errno ;
    else if ( pid == 0)
    {
         /* child instructions */
        int n = atoi(argv[1]);
        printf("%d: ", n);
        while (n!=1)
        {
            if (n % 2 == 0)
                n = n/2;
            else n = 3*n+1;
            printf("%d ", n);
        }
        printf(".\n");
    }
    else
    {
        /* parent instructions */
        wait ( NULL );
        printf ("Child %d finished\n " , pid);
    }
	return 0;
}
