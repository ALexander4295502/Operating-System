#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
  int wakeNUM=wakeall();
  printf(1,"there are %d process waking up\n",wakeNUM);
  exit();
}
