----Project 3B-------

  NAME            WUSTL Key(ID)
Zheng Yuan        yuanzheng(452091)
Bowen Wang        bowenwang(443953)


About Project
<1> Edited files
    Makefile, defs.h, proc.c, proc.h syscall.c, syscall.h, sysproc.c, syscall.h, sysproc.c, threads.c, threads.h, threadtest.c, user.h, usys.S 
<2> Details about threads.c
    add_thread() : add the thread to the thread table
    remove_thread() : remove the thread from the thread table
    thread_create() : create a new thread (initialize the thread table with zeros if this function is called for the first time)
    thread_join()   : waits for the thread to terminate and remove the thread from the thread table
    lock_acquire(), lock_release(), lock_init() : use x86 atomic exchange to built the spin lock, and these are the functions related to the lock.
