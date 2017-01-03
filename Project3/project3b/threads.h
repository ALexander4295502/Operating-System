#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "x86.h"
#include "param.h"

struct user_thread{
	int pid;
	void *ustack;
	int used;	
};

int init_threads_table = 0; //denotes whether thread table has been initialized
struct user_thread threads[64]; //thread table
