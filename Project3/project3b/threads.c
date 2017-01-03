#include "threads.h"

//add thread to thread table
void add_thread(int *pid, void *ustack){
	int c;
	for(c=0; c < NPROC; c++){
		if(threads[c].used == 0){
			threads[c].pid = *pid;
			threads[c].ustack = ustack;
			threads[c].used = 1;
		}
	}
}

// remove thread to thread table
void remove_thread(int *pid){
	int c;
	void *ustack;
	for(c = 0; c < NPROC; c++){
		if(threads[c].used && threads[c].pid == *pid){
			ustack = threads[c].ustack;
			free(ustack);
			threads[c].pid = 0;
			threads[c].ustack = 0;
			threads[c].used = 0;
			break;
		}
	}
}

int thread_create(void (*start_routine)(void*), void *arg){
	//if first time running any threads, initialize thread table with zeros
	if(init_threads_table != 0){
		int c;
		for(c = 0; c < NPROC; c++){
			threads[c].pid = 0;
			threads[c].ustack = 0;
			threads[c].used = 0;
		}
		init_threads_table = 1;
	}

	int pid;
	void *new_stack = malloc(KSTACKSIZE); // allocate one page for user stack
	pid = clone((void*)start_routine, (void*)arg, (void*)new_stack); // system call for kernel thread
	add_thread(&pid, new_stack); // save new thread to thread table
	return pid;
}

int thread_join(void){
	int c,p;
	for(c = 0; c < NPROC; c++){
		if(threads[c].used == 1){
			p = join(&threads[c].ustack);
			if(p>0){
				remove_thread(&p);
				break;
			}
		}
	}
	return p;
}

void lock_acquire(struct __lock_t *lock){
	volatile uint one = (uint) 1;
	while (xchg(&lock->flag, one) == one)
		; // spin wait
}

void lock_release(struct __lock_t *lock){
	lock->flag = 0;
}

void lock_init(struct __lock_t *lock){
	// 0 means lock is available 1 means lock is held
	lock->flag = 0;
}
