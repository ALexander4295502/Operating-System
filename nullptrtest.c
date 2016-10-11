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

//int *np = NULL;
int b=0;

//b=*np;
printf(1,"b= %p\n",&b);




}
