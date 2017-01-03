#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"
#define SIZE 800

#define assert(x) if (x) {} else { \
   printf(1, "%s: %d ", __FILE__, __LINE__); \
   printf(1, "assert failed (%s)\n", # x); \
   printf(1, "TEST FAILED\n"); \
   exit(); \
}


int
main(int argc, char *argv[])
{
   uint *data=(uint *)malloc(SIZE*sizeof(uint));
   uint tempChecksum=0;
   uchar CorrectChecksum=0;
   int fd;
   int r;
   fd = open("out", O_CREATE | O_CHECKED | O_RDWR);

   int i = 0;
   for(i=0;i<SIZE;i++){
    data[i]=i;
    //tempChecksum^=i;
    CorrectChecksum^=(uchar)i;
   }

   r = write(fd, data, SIZE);
   assert(r == SIZE);

   struct stat st;
   fstat(fd, &st);

   CorrectChecksum=(uchar)tempChecksum;
   printf(1, "the correct checksum should be %d\n", CorrectChecksum);
   printf(1, "the file checksum is %d\n", st.checksum);
   r = close(fd);
   assert(r == 0);

   exit();
}
