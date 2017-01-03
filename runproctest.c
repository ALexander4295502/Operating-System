#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"
#define getsmax 80

//Filename: runproctest.c
//Version: 1.0 (maybe 1.0 forever)
//Author: Zheng Yuan

void 
runproctest(void)
{
     int fc=fork();
     if(fc==0){
       char s[80] = "y";
       int answer=0;

       while(1){
if(s[0]=='y'){
  printf(1,"do you want to add a runnable process? (y/n)\n");
 fork();
 answer++;
 gets(s,getsmax);
 while(runnable()==0){} //BUG: it seems that there is sometimes a transition for the state of the process from runnable to sleeping, so we need this loop to avoid this. 
 printf(1,"there should be %d process runnable, and your answer is %d.\n",answer,runnable());  //if your return value of "runnable()" is same to the answer, your function is passed.
}else if(s[0]=='n'){
 break;  //BUG: after you enter n, however the test function will also ADD A RUNNABLE PROCESS AND TEST YOUR "runnable()", which is being corrected.
}else{
 printf(1,"please enter again: \n");
 gets(s,getsmax);  
}
}
 }else if(fc>0){
wait();
}


}

int
main(int argc, char *argv[])
{
  printf(1,"project1tests starting*****\n");

  runproctest();
  
  printf(1,"project1tests finished*****\n");  //BUG: Print twice, fixing on it.
  exit();
}
