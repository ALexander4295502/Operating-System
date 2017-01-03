#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

#define NULL ((void*)0)


void nullptrtest(void){

int a = 10;
int *b;

b=&a;


printf(1,"a= %d\n",*b);
int *np;

np = 0;


//b=*np;
printf(1,"NULLpointer= %p\n",np);




}
