all:
	gcc -O2 -c -fpic mem.c -Wall -Werror
	gcc -O2 -shared -o libmem.so mem.o
	gcc -O2 -lmem -L. -o myprogram mem_rand.c -Wall -Werror
clean:
	rm -rf mem.o
	rm -rf libmem.so
	rm -rf myprogram
