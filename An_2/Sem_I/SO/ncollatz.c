#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    
    for (int i=1; i < argc; i++)
    {
        pid_t pid = fork ();
        if ( pid < 0)
            return errno ;
        else if ( pid == 0)
        {
            /* child instructions */
            char *argv2[] = {"collatz", argv[i] , NULL };
            execve ("/home/student/Documents/collatz" , argv2 , NULL );
            perror ( NULL );
        }
        else
        {
            /* parent instructions */
            wait ( NULL );
            printf ("Done Parent %d Me %d\n" , getppid(), getpid());
        }
    }
	return 0;
}
