#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork ();
    if ( pid < 0)
        return errno ;
    else if ( pid == 0)
    {
         /* child instructions */
        char *argv[] = {"ls" , NULL };
        execve ("/bin/ls" , argv , NULL );
        perror ( NULL );
    }
    else
    {
        /* parent instructions */
        wait ( NULL );
        printf ("My PID = %d  , Child PID = %d \n " , getpid () , pid);
    }
	return 0;
}
