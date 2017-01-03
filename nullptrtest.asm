
_nullptrtest:     file format elf32-i386


Disassembly of section .text:

00000000 <nullptrtest>:
#include "memlayout.h"

#define NULL ((void*)0)


void nullptrtest(void){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
int *b;

b=&a;


printf(1,"a= %d\n",*b);
   6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
   d:	00 
   e:	c7 44 24 04 26 07 00 	movl   $0x726,0x4(%esp)
  15:	00 
  16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1d:	e8 9e 03 00 00       	call   3c0 <printf>

np = 0;


//b=*np;
printf(1,"NULLpointer= %p\n",np);
  22:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  29:	00 
  2a:	c7 44 24 04 2d 07 00 	movl   $0x72d,0x4(%esp)
  31:	00 
  32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  39:	e8 82 03 00 00       	call   3c0 <printf>




}
  3e:	c9                   	leave  
  3f:	c3                   	ret    

00000040 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	8b 45 08             	mov    0x8(%ebp),%eax
  46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  49:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	89 c2                	mov    %eax,%edx
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  50:	83 c1 01             	add    $0x1,%ecx
  53:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  57:	83 c2 01             	add    $0x1,%edx
  5a:	84 db                	test   %bl,%bl
  5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  5f:	75 ef                	jne    50 <strcpy+0x10>
    ;
  return os;
}
  61:	5b                   	pop    %ebx
  62:	5d                   	pop    %ebp
  63:	c3                   	ret    
  64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	8b 55 08             	mov    0x8(%ebp),%edx
  76:	53                   	push   %ebx
  77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  7a:	0f b6 02             	movzbl (%edx),%eax
  7d:	84 c0                	test   %al,%al
  7f:	74 2d                	je     ae <strcmp+0x3e>
  81:	0f b6 19             	movzbl (%ecx),%ebx
  84:	38 d8                	cmp    %bl,%al
  86:	74 0e                	je     96 <strcmp+0x26>
  88:	eb 2b                	jmp    b5 <strcmp+0x45>
  8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  90:	38 c8                	cmp    %cl,%al
  92:	75 15                	jne    a9 <strcmp+0x39>
    p++, q++;
  94:	89 d9                	mov    %ebx,%ecx
  96:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  99:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  9c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  9f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
  a3:	84 c0                	test   %al,%al
  a5:	75 e9                	jne    90 <strcmp+0x20>
  a7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	29 c8                	sub    %ecx,%eax
}
  ab:	5b                   	pop    %ebx
  ac:	5d                   	pop    %ebp
  ad:	c3                   	ret    
  ae:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  b1:	31 c0                	xor    %eax,%eax
  b3:	eb f4                	jmp    a9 <strcmp+0x39>
  b5:	0f b6 cb             	movzbl %bl,%ecx
  b8:	eb ef                	jmp    a9 <strcmp+0x39>
  ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000c0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 39 00             	cmpb   $0x0,(%ecx)
  c9:	74 12                	je     dd <strlen+0x1d>
  cb:	31 d2                	xor    %edx,%edx
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	83 c2 01             	add    $0x1,%edx
  d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  d7:	89 d0                	mov    %edx,%eax
  d9:	75 f5                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
  dd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
  df:	5d                   	pop    %ebp
  e0:	c3                   	ret    
  e1:	eb 0d                	jmp    f0 <memset>
  e3:	90                   	nop
  e4:	90                   	nop
  e5:	90                   	nop
  e6:	90                   	nop
  e7:	90                   	nop
  e8:	90                   	nop
  e9:	90                   	nop
  ea:	90                   	nop
  eb:	90                   	nop
  ec:	90                   	nop
  ed:	90                   	nop
  ee:	90                   	nop
  ef:	90                   	nop

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
  f6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 d7                	mov    %edx,%edi
  ff:	fc                   	cld    
 100:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 102:	89 d0                	mov    %edx,%eax
 104:	5f                   	pop    %edi
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    
 107:	89 f6                	mov    %esi,%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	53                   	push   %ebx
 117:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 11a:	0f b6 18             	movzbl (%eax),%ebx
 11d:	84 db                	test   %bl,%bl
 11f:	74 1d                	je     13e <strchr+0x2e>
    if(*s == c)
 121:	38 d3                	cmp    %dl,%bl
 123:	89 d1                	mov    %edx,%ecx
 125:	75 0d                	jne    134 <strchr+0x24>
 127:	eb 17                	jmp    140 <strchr+0x30>
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 130:	38 ca                	cmp    %cl,%dl
 132:	74 0c                	je     140 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 134:	83 c0 01             	add    $0x1,%eax
 137:	0f b6 10             	movzbl (%eax),%edx
 13a:	84 d2                	test   %dl,%dl
 13c:	75 f2                	jne    130 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 13e:	31 c0                	xor    %eax,%eax
}
 140:	5b                   	pop    %ebx
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 155:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 157:	53                   	push   %ebx
 158:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 15b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	eb 31                	jmp    191 <gets+0x41>
    cc = read(0, &c, 1);
 160:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 167:	00 
 168:	89 7c 24 04          	mov    %edi,0x4(%esp)
 16c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 173:	e8 04 01 00 00       	call   27c <read>
    if(cc < 1)
 178:	85 c0                	test   %eax,%eax
 17a:	7e 1d                	jle    199 <gets+0x49>
      break;
    buf[i++] = c;
 17c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 182:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 185:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 187:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 18b:	74 0c                	je     199 <gets+0x49>
 18d:	3c 0a                	cmp    $0xa,%al
 18f:	74 08                	je     199 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 191:	8d 5e 01             	lea    0x1(%esi),%ebx
 194:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 197:	7c c7                	jl     160 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1a0:	83 c4 2c             	add    $0x2c,%esp
 1a3:	5b                   	pop    %ebx
 1a4:	5e                   	pop    %esi
 1a5:	5f                   	pop    %edi
 1a6:	5d                   	pop    %ebp
 1a7:	c3                   	ret    
 1a8:	90                   	nop
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <stat>:

int
stat(char *n, struct stat *st)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	56                   	push   %esi
 1b4:	53                   	push   %ebx
 1b5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1c2:	00 
 1c3:	89 04 24             	mov    %eax,(%esp)
 1c6:	e8 d9 00 00 00       	call   2a4 <open>
  if(fd < 0)
 1cb:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1cf:	78 27                	js     1f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	89 1c 24             	mov    %ebx,(%esp)
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	e8 dc 00 00 00       	call   2bc <fstat>
  close(fd);
 1e0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1e3:	89 c6                	mov    %eax,%esi
  close(fd);
 1e5:	e8 a2 00 00 00       	call   28c <close>
  return r;
 1ea:	89 f0                	mov    %esi,%eax
}
 1ec:	83 c4 10             	add    $0x10,%esp
 1ef:	5b                   	pop    %ebx
 1f0:	5e                   	pop    %esi
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	90                   	nop
 1f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 1f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1fd:	eb ed                	jmp    1ec <stat+0x3c>
 1ff:	90                   	nop

00000200 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 4d 08             	mov    0x8(%ebp),%ecx
 206:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 207:	0f be 11             	movsbl (%ecx),%edx
 20a:	8d 42 d0             	lea    -0x30(%edx),%eax
 20d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 20f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 214:	77 17                	ja     22d <atoi+0x2d>
 216:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 218:	83 c1 01             	add    $0x1,%ecx
 21b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 21e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 222:	0f be 11             	movsbl (%ecx),%edx
 225:	8d 5a d0             	lea    -0x30(%edx),%ebx
 228:	80 fb 09             	cmp    $0x9,%bl
 22b:	76 eb                	jbe    218 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 22d:	5b                   	pop    %ebx
 22e:	5d                   	pop    %ebp
 22f:	c3                   	ret    

00000230 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 230:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 231:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 233:	89 e5                	mov    %esp,%ebp
 235:	56                   	push   %esi
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	53                   	push   %ebx
 23a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 23d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 240:	85 db                	test   %ebx,%ebx
 242:	7e 12                	jle    256 <memmove+0x26>
 244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 248:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 24c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 24f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 252:	39 da                	cmp    %ebx,%edx
 254:	75 f2                	jne    248 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 256:	5b                   	pop    %ebx
 257:	5e                   	pop    %esi
 258:	5d                   	pop    %ebp
 259:	c3                   	ret    
 25a:	66 90                	xchg   %ax,%ax

0000025c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 25c:	b8 01 00 00 00       	mov    $0x1,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <exit>:
SYSCALL(exit)
 264:	b8 02 00 00 00       	mov    $0x2,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <wait>:
SYSCALL(wait)
 26c:	b8 03 00 00 00       	mov    $0x3,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <pipe>:
SYSCALL(pipe)
 274:	b8 04 00 00 00       	mov    $0x4,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <read>:
SYSCALL(read)
 27c:	b8 05 00 00 00       	mov    $0x5,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <write>:
SYSCALL(write)
 284:	b8 10 00 00 00       	mov    $0x10,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <close>:
SYSCALL(close)
 28c:	b8 15 00 00 00       	mov    $0x15,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <kill>:
SYSCALL(kill)
 294:	b8 06 00 00 00       	mov    $0x6,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <exec>:
SYSCALL(exec)
 29c:	b8 07 00 00 00       	mov    $0x7,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <open>:
SYSCALL(open)
 2a4:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <mknod>:
SYSCALL(mknod)
 2ac:	b8 11 00 00 00       	mov    $0x11,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <unlink>:
SYSCALL(unlink)
 2b4:	b8 12 00 00 00       	mov    $0x12,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <fstat>:
SYSCALL(fstat)
 2bc:	b8 08 00 00 00       	mov    $0x8,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <link>:
SYSCALL(link)
 2c4:	b8 13 00 00 00       	mov    $0x13,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <mkdir>:
SYSCALL(mkdir)
 2cc:	b8 14 00 00 00       	mov    $0x14,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <chdir>:
SYSCALL(chdir)
 2d4:	b8 09 00 00 00       	mov    $0x9,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <dup>:
SYSCALL(dup)
 2dc:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <getpid>:
SYSCALL(getpid)
 2e4:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <sbrk>:
SYSCALL(sbrk)
 2ec:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <sleep>:
SYSCALL(sleep)
 2f4:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <uptime>:
SYSCALL(uptime)
 2fc:	b8 0e 00 00 00       	mov    $0xe,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <wakeall>:
SYSCALL(wakeall)
 304:	b8 19 00 00 00       	mov    $0x19,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <runnable>:
SYSCALL(runnable)
 30c:	b8 16 00 00 00       	mov    $0x16,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <translate>:
SYSCALL(translate)
 314:	b8 1b 00 00 00       	mov    $0x1b,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    
 31c:	66 90                	xchg   %ax,%ax
 31e:	66 90                	xchg   %ax,%ax

00000320 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	89 c6                	mov    %eax,%esi
 327:	53                   	push   %ebx
 328:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 32b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 32e:	85 db                	test   %ebx,%ebx
 330:	74 09                	je     33b <printint+0x1b>
 332:	89 d0                	mov    %edx,%eax
 334:	c1 e8 1f             	shr    $0x1f,%eax
 337:	84 c0                	test   %al,%al
 339:	75 75                	jne    3b0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 33b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 33d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 344:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 347:	31 ff                	xor    %edi,%edi
 349:	89 ce                	mov    %ecx,%esi
 34b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 34e:	eb 02                	jmp    352 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 350:	89 cf                	mov    %ecx,%edi
 352:	31 d2                	xor    %edx,%edx
 354:	f7 f6                	div    %esi
 356:	8d 4f 01             	lea    0x1(%edi),%ecx
 359:	0f b6 92 45 07 00 00 	movzbl 0x745(%edx),%edx
  }while((x /= base) != 0);
 360:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 362:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 365:	75 e9                	jne    350 <printint+0x30>
  if(neg)
 367:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 36a:	89 c8                	mov    %ecx,%eax
 36c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 36f:	85 d2                	test   %edx,%edx
 371:	74 08                	je     37b <printint+0x5b>
    buf[i++] = '-';
 373:	8d 4f 02             	lea    0x2(%edi),%ecx
 376:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 37b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 37e:	66 90                	xchg   %ax,%ax
 380:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 385:	83 ef 01             	sub    $0x1,%edi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 388:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 38f:	00 
 390:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 394:	89 34 24             	mov    %esi,(%esp)
 397:	88 45 d7             	mov    %al,-0x29(%ebp)
 39a:	e8 e5 fe ff ff       	call   284 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 39f:	83 ff ff             	cmp    $0xffffffff,%edi
 3a2:	75 dc                	jne    380 <printint+0x60>
    putc(fd, buf[i]);
}
 3a4:	83 c4 4c             	add    $0x4c,%esp
 3a7:	5b                   	pop    %ebx
 3a8:	5e                   	pop    %esi
 3a9:	5f                   	pop    %edi
 3aa:	5d                   	pop    %ebp
 3ab:	c3                   	ret    
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3b0:	89 d0                	mov    %edx,%eax
 3b2:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 3b4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 3bb:	eb 87                	jmp    344 <printint+0x24>
 3bd:	8d 76 00             	lea    0x0(%esi),%esi

000003c0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3c4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3c6:	56                   	push   %esi
 3c7:	53                   	push   %ebx
 3c8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ce:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3d1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 3d7:	0f b6 13             	movzbl (%ebx),%edx
 3da:	83 c3 01             	add    $0x1,%ebx
 3dd:	84 d2                	test   %dl,%dl
 3df:	75 39                	jne    41a <printf+0x5a>
 3e1:	e9 c2 00 00 00       	jmp    4a8 <printf+0xe8>
 3e6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3e8:	83 fa 25             	cmp    $0x25,%edx
 3eb:	0f 84 bf 00 00 00    	je     4b0 <printf+0xf0>
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3f1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3fb:	00 
 3fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 400:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 403:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 406:	e8 79 fe ff ff       	call   284 <write>
 40b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 40e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 412:	84 d2                	test   %dl,%dl
 414:	0f 84 8e 00 00 00    	je     4a8 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 41a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 41c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 41f:	74 c7                	je     3e8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 421:	83 ff 25             	cmp    $0x25,%edi
 424:	75 e5                	jne    40b <printf+0x4b>
      if(c == 'd'){
 426:	83 fa 64             	cmp    $0x64,%edx
 429:	0f 84 31 01 00 00    	je     560 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 42f:	25 f7 00 00 00       	and    $0xf7,%eax
 434:	83 f8 70             	cmp    $0x70,%eax
 437:	0f 84 83 00 00 00    	je     4c0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 43d:	83 fa 73             	cmp    $0x73,%edx
 440:	0f 84 a2 00 00 00    	je     4e8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 446:	83 fa 63             	cmp    $0x63,%edx
 449:	0f 84 35 01 00 00    	je     584 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 44f:	83 fa 25             	cmp    $0x25,%edx
 452:	0f 84 e0 00 00 00    	je     538 <printf+0x178>
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 458:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 45b:	83 c3 01             	add    $0x1,%ebx
 45e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 465:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 466:	31 ff                	xor    %edi,%edi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 468:	89 44 24 04          	mov    %eax,0x4(%esp)
 46c:	89 34 24             	mov    %esi,(%esp)
 46f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 472:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 476:	e8 09 fe ff ff       	call   284 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 47b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 47e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 481:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 488:	00 
 489:	89 44 24 04          	mov    %eax,0x4(%esp)
 48d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 490:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 493:	e8 ec fd ff ff       	call   284 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 498:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 49c:	84 d2                	test   %dl,%dl
 49e:	0f 85 76 ff ff ff    	jne    41a <printf+0x5a>
 4a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4a8:	83 c4 3c             	add    $0x3c,%esp
 4ab:	5b                   	pop    %ebx
 4ac:	5e                   	pop    %esi
 4ad:	5f                   	pop    %edi
 4ae:	5d                   	pop    %ebp
 4af:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4b0:	bf 25 00 00 00       	mov    $0x25,%edi
 4b5:	e9 51 ff ff ff       	jmp    40b <printf+0x4b>
 4ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4c3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4d1:	8b 10                	mov    (%eax),%edx
 4d3:	89 f0                	mov    %esi,%eax
 4d5:	e8 46 fe ff ff       	call   320 <printint>
        ap++;
 4da:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4de:	e9 28 ff ff ff       	jmp    40b <printf+0x4b>
 4e3:	90                   	nop
 4e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 4e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 4eb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4ef:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 4f1:	b8 3e 07 00 00       	mov    $0x73e,%eax
 4f6:	85 ff                	test   %edi,%edi
 4f8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 4fb:	0f b6 07             	movzbl (%edi),%eax
 4fe:	84 c0                	test   %al,%al
 500:	74 2a                	je     52c <printf+0x16c>
 502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 508:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 50b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 50e:	83 c7 01             	add    $0x1,%edi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 511:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 518:	00 
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	89 34 24             	mov    %esi,(%esp)
 520:	e8 5f fd ff ff       	call   284 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 525:	0f b6 07             	movzbl (%edi),%eax
 528:	84 c0                	test   %al,%al
 52a:	75 dc                	jne    508 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52c:	31 ff                	xor    %edi,%edi
 52e:	e9 d8 fe ff ff       	jmp    40b <printf+0x4b>
 533:	90                   	nop
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 538:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53b:	31 ff                	xor    %edi,%edi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 544:	00 
 545:	89 44 24 04          	mov    %eax,0x4(%esp)
 549:	89 34 24             	mov    %esi,(%esp)
 54c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 550:	e8 2f fd ff ff       	call   284 <write>
 555:	e9 b1 fe ff ff       	jmp    40b <printf+0x4b>
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 563:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 568:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 56b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 572:	8b 10                	mov    (%eax),%edx
 574:	89 f0                	mov    %esi,%eax
 576:	e8 a5 fd ff ff       	call   320 <printint>
        ap++;
 57b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 57f:	e9 87 fe ff ff       	jmp    40b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 587:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 589:	8b 00                	mov    (%eax),%eax
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 58b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 592:	00 
 593:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 596:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 599:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 59c:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a0:	e8 df fc ff ff       	call   284 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 5a5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5a9:	e9 5d fe ff ff       	jmp    40b <printf+0x4b>
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b1:	a1 c0 09 00 00       	mov    0x9c0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5be:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c3:	39 d0                	cmp    %edx,%eax
 5c5:	72 11                	jb     5d8 <free+0x28>
 5c7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c8:	39 c8                	cmp    %ecx,%eax
 5ca:	72 04                	jb     5d0 <free+0x20>
 5cc:	39 ca                	cmp    %ecx,%edx
 5ce:	72 10                	jb     5e0 <free+0x30>
 5d0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d6:	73 f0                	jae    5c8 <free+0x18>
 5d8:	39 ca                	cmp    %ecx,%edx
 5da:	72 04                	jb     5e0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5dc:	39 c8                	cmp    %ecx,%eax
 5de:	72 f0                	jb     5d0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 5e6:	39 cf                	cmp    %ecx,%edi
 5e8:	74 1e                	je     608 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ea:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ed:	8b 48 04             	mov    0x4(%eax),%ecx
 5f0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5f3:	39 f2                	cmp    %esi,%edx
 5f5:	74 28                	je     61f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5f7:	89 10                	mov    %edx,(%eax)
  freep = p;
 5f9:	a3 c0 09 00 00       	mov    %eax,0x9c0
}
 5fe:	5b                   	pop    %ebx
 5ff:	5e                   	pop    %esi
 600:	5f                   	pop    %edi
 601:	5d                   	pop    %ebp
 602:	c3                   	ret    
 603:	90                   	nop
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 608:	03 71 04             	add    0x4(%ecx),%esi
 60b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 60e:	8b 08                	mov    (%eax),%ecx
 610:	8b 09                	mov    (%ecx),%ecx
 612:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 615:	8b 48 04             	mov    0x4(%eax),%ecx
 618:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 61b:	39 f2                	cmp    %esi,%edx
 61d:	75 d8                	jne    5f7 <free+0x47>
    p->s.size += bp->s.size;
 61f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 622:	a3 c0 09 00 00       	mov    %eax,0x9c0
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 627:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 62a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 62d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 62f:	5b                   	pop    %ebx
 630:	5e                   	pop    %esi
 631:	5f                   	pop    %edi
 632:	5d                   	pop    %ebp
 633:	c3                   	ret    
 634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 63a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 649:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 64c:	8b 1d c0 09 00 00    	mov    0x9c0,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 652:	8d 48 07             	lea    0x7(%eax),%ecx
 655:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 658:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 65a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 65d:	0f 84 9b 00 00 00    	je     6fe <malloc+0xbe>
 663:	8b 13                	mov    (%ebx),%edx
 665:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 668:	39 fe                	cmp    %edi,%esi
 66a:	76 64                	jbe    6d0 <malloc+0x90>
 66c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 673:	bb 00 80 00 00       	mov    $0x8000,%ebx
 678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 67b:	eb 0e                	jmp    68b <malloc+0x4b>
 67d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 680:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 682:	8b 78 04             	mov    0x4(%eax),%edi
 685:	39 fe                	cmp    %edi,%esi
 687:	76 4f                	jbe    6d8 <malloc+0x98>
 689:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 68b:	3b 15 c0 09 00 00    	cmp    0x9c0,%edx
 691:	75 ed                	jne    680 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 696:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 69c:	bf 00 10 00 00       	mov    $0x1000,%edi
 6a1:	0f 43 fe             	cmovae %esi,%edi
 6a4:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6a7:	89 04 24             	mov    %eax,(%esp)
 6aa:	e8 3d fc ff ff       	call   2ec <sbrk>
  if(p == (char*)-1)
 6af:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b2:	74 18                	je     6cc <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6b4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6b7:	83 c0 08             	add    $0x8,%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 ee fe ff ff       	call   5b0 <free>
  return freep;
 6c2:	8b 15 c0 09 00 00    	mov    0x9c0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6c8:	85 d2                	test   %edx,%edx
 6ca:	75 b4                	jne    680 <malloc+0x40>
        return 0;
 6cc:	31 c0                	xor    %eax,%eax
 6ce:	eb 20                	jmp    6f0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6d0:	89 d0                	mov    %edx,%eax
 6d2:	89 da                	mov    %ebx,%edx
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 6d8:	39 fe                	cmp    %edi,%esi
 6da:	74 1c                	je     6f8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6dc:	29 f7                	sub    %esi,%edi
 6de:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 6e1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 6e4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 6e7:	89 15 c0 09 00 00    	mov    %edx,0x9c0
      return (void*)(p + 1);
 6ed:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6f0:	83 c4 1c             	add    $0x1c,%esp
 6f3:	5b                   	pop    %ebx
 6f4:	5e                   	pop    %esi
 6f5:	5f                   	pop    %edi
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6f8:	8b 08                	mov    (%eax),%ecx
 6fa:	89 0a                	mov    %ecx,(%edx)
 6fc:	eb e9                	jmp    6e7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6fe:	c7 05 c0 09 00 00 c4 	movl   $0x9c4,0x9c0
 705:	09 00 00 
    base.s.size = 0;
 708:	ba c4 09 00 00       	mov    $0x9c4,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 70d:	c7 05 c4 09 00 00 c4 	movl   $0x9c4,0x9c4
 714:	09 00 00 
    base.s.size = 0;
 717:	c7 05 c8 09 00 00 00 	movl   $0x0,0x9c8
 71e:	00 00 00 
 721:	e9 46 ff ff ff       	jmp    66c <malloc+0x2c>
