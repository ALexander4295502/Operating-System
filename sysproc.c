#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_wakeall(void)
{

return wakeall();

}



//YYYYYYYYYYuanZZZZZZZZZZZheng___RUNNABLE
int
sys_runnable(void)
{

return runnable();

}

int
sys_translate(void)
{
int vaddr;
int procpid;
if(argint(0, &vaddr)<0)
{ 
  cprintf("this  is in sysproc.c return-1!!\n");
  return -1;
}

if(argint(1,&procpid)<0)
{
  cprintf("this is in sysproc.c pid<0\n");
}

cprintf("this is in sysproc.c\n");
cprintf("argint vaddr is: %p\n",vaddr);
cprintf("argint pid is %d\n",procpid);
return translate((void*)vaddr,procpid);

}




int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
