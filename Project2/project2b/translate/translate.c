#include "types.h"
#include "stat.h"
#include "user.h"

#define NULL ((void*)0)

int main(int argc, char* argv[]){

int *b;
b=NULL;
int c= 20;
int *d;
d=&c;

char *f;
f="asdasdasd";
int procpid = getpid();
printf(1,"in the main: procpid = %d\n",procpid);

translate(b,procpid);
printf(1,"in the main: vaddr(b) = %p\n\n", b);
translate(d,procpid);
printf(1,"in the main: vaddr(d) = %p\n\n", d);
d=d+1;

translate(f,procpid);
printf(1,"in the main: vaddr(f) = %p\n\n", f);

//printf(1,"gogogogogogo\n");
while(1);      //cannot let the program really exit, because when the program exit, the OS may take all the resources used by program, so we can't
             //see the correct result in the qemu monitor
exit();

}
