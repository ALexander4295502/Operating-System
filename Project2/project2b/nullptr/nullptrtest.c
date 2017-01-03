#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
		int *p1;
		int a;
		int b;
		a = 5;
		p1 = &a;
		b = *p1;
		printf(1,"Value pointed by p1: %d\n\n", b);
		int *p2;
		p2 = 0;
		b = *p2;
		printf(1,"Value pointed by p2: %d\n\n", b);
exit();
}
