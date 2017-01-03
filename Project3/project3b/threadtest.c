#include "types.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"

int n = 0;

void worker(int *threadArg){
    //printf(1, "this is a test in thread, and threadArg is %s\n", *((int *)threadArg));
    printf(1, "this is a test in thread, and threadArg is %d\n", *threadArg);

    int i=0;

    for(i=0; i<*threadArg; i++){
      n++;
    }
   
    //printf(1, "I am worker the pid is %d\n ",getpid());
    exit();
}

int
main(int argc, char *argv[])
{
 // char *testArg = "----I am childthread---- ";
  int a = 100000;
  int *b = &a;
  printf(1,"-----TEST BEGIN---------\n");

  printf(1,"In the parent process the b is: %d\n",*b);

  int pid1 = thread_create((void *)&worker, b);
  int pid2 = thread_create((void *)&worker, b);

  printf(1, "------call thread_join()--------\n");
  thread_join();
  thread_join();
  printf(1, "after thread, n = %d\n",n);
  printf(1,"the first child thread pid is %d \n",pid1);
  printf(1,"the second child thread pid is %d \n",pid2);
  printf(1,"the parent thread pid is %d \n",getpid());
  exit();
  return 0;


}
