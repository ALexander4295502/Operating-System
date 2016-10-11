
_translate:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

#define NULL ((void*)0)

int main(int argc, char* argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 e4 f0             	and    $0xfffffff0,%esp
   8:	83 ec 20             	sub    $0x20,%esp

int *b;
b=NULL;
int c= 20;
   b:	c7 44 24 1c 14 00 00 	movl   $0x14,0x1c(%esp)
  12:	00 
int procpid = getpid();
printf(1,"in the main: procpid = %d\n",procpid);

translate(b,procpid);
printf(1,"in the main: vaddr(b) = %p\n\n", b);
translate(d,procpid);
  13:	8d 74 24 1c          	lea    0x1c(%esp),%esi
int *d;
d=&c;

char *f;
f="asdasdasd";
int procpid = getpid();
  17:	e8 48 03 00 00       	call   364 <getpid>
printf(1,"in the main: procpid = %d\n",procpid);
  1c:	c7 44 24 04 a6 07 00 	movl   $0x7a6,0x4(%esp)
  23:	00 
  24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
int *d;
d=&c;

char *f;
f="asdasdasd";
int procpid = getpid();
  2b:	89 c3                	mov    %eax,%ebx
printf(1,"in the main: procpid = %d\n",procpid);
  2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  31:	e8 0a 04 00 00       	call   440 <printf>

translate(b,procpid);
  36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  41:	e8 4e 03 00 00       	call   394 <translate>
printf(1,"in the main: vaddr(b) = %p\n\n", b);
  46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  4d:	00 
  4e:	c7 44 24 04 c1 07 00 	movl   $0x7c1,0x4(%esp)
  55:	00 
  56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5d:	e8 de 03 00 00       	call   440 <printf>
translate(d,procpid);
  62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  66:	89 34 24             	mov    %esi,(%esp)
  69:	e8 26 03 00 00       	call   394 <translate>
printf(1,"in the main: vaddr(d) = %p\n\n", d);
  6e:	89 74 24 08          	mov    %esi,0x8(%esp)
  72:	c7 44 24 04 de 07 00 	movl   $0x7de,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	e8 ba 03 00 00       	call   440 <printf>
d=d+1;

translate(f,procpid);
  86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8a:	c7 04 24 fb 07 00 00 	movl   $0x7fb,(%esp)
  91:	e8 fe 02 00 00       	call   394 <translate>
printf(1,"in the main: vaddr(f) = %p\n\n", f);
  96:	c7 44 24 08 fb 07 00 	movl   $0x7fb,0x8(%esp)
  9d:	00 
  9e:	c7 44 24 04 05 08 00 	movl   $0x805,0x4(%esp)
  a5:	00 
  a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ad:	e8 8e 03 00 00       	call   440 <printf>

//printf(1,"gogogogogogo\n");
exit();
  b2:	e8 2d 02 00 00       	call   2e4 <exit>
  b7:	90                   	nop
  b8:	66 90                	xchg   %ax,%ax
  ba:	66 90                	xchg   %ax,%ax
  bc:	66 90                	xchg   %ax,%ax
  be:	66 90                	xchg   %ax,%ax

000000c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  c9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ca:	89 c2                	mov    %eax,%edx
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d0:	83 c1 01             	add    $0x1,%ecx
  d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  d7:	83 c2 01             	add    $0x1,%edx
  da:	84 db                	test   %bl,%bl
  dc:	88 5a ff             	mov    %bl,-0x1(%edx)
  df:	75 ef                	jne    d0 <strcpy+0x10>
    ;
  return os;
}
  e1:	5b                   	pop    %ebx
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    
  e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
  f6:	53                   	push   %ebx
  f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  fa:	0f b6 02             	movzbl (%edx),%eax
  fd:	84 c0                	test   %al,%al
  ff:	74 2d                	je     12e <strcmp+0x3e>
 101:	0f b6 19             	movzbl (%ecx),%ebx
 104:	38 d8                	cmp    %bl,%al
 106:	74 0e                	je     116 <strcmp+0x26>
 108:	eb 2b                	jmp    135 <strcmp+0x45>
 10a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 110:	38 c8                	cmp    %cl,%al
 112:	75 15                	jne    129 <strcmp+0x39>
    p++, q++;
 114:	89 d9                	mov    %ebx,%ecx
 116:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 119:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 11c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 11f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 123:	84 c0                	test   %al,%al
 125:	75 e9                	jne    110 <strcmp+0x20>
 127:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 129:	29 c8                	sub    %ecx,%eax
}
 12b:	5b                   	pop    %ebx
 12c:	5d                   	pop    %ebp
 12d:	c3                   	ret    
 12e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 131:	31 c0                	xor    %eax,%eax
 133:	eb f4                	jmp    129 <strcmp+0x39>
 135:	0f b6 cb             	movzbl %bl,%ecx
 138:	eb ef                	jmp    129 <strcmp+0x39>
 13a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000140 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 39 00             	cmpb   $0x0,(%ecx)
 149:	74 12                	je     15d <strlen+0x1d>
 14b:	31 d2                	xor    %edx,%edx
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	83 c2 01             	add    $0x1,%edx
 153:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 157:	89 d0                	mov    %edx,%eax
 159:	75 f5                	jne    150 <strlen+0x10>
    ;
  return n;
}
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 15d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    
 161:	eb 0d                	jmp    170 <memset>
 163:	90                   	nop
 164:	90                   	nop
 165:	90                   	nop
 166:	90                   	nop
 167:	90                   	nop
 168:	90                   	nop
 169:	90                   	nop
 16a:	90                   	nop
 16b:	90                   	nop
 16c:	90                   	nop
 16d:	90                   	nop
 16e:	90                   	nop
 16f:	90                   	nop

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 55 08             	mov    0x8(%ebp),%edx
 176:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld    
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	89 d0                	mov    %edx,%eax
 184:	5f                   	pop    %edi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	89 f6                	mov    %esi,%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	53                   	push   %ebx
 197:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 19a:	0f b6 18             	movzbl (%eax),%ebx
 19d:	84 db                	test   %bl,%bl
 19f:	74 1d                	je     1be <strchr+0x2e>
    if(*s == c)
 1a1:	38 d3                	cmp    %dl,%bl
 1a3:	89 d1                	mov    %edx,%ecx
 1a5:	75 0d                	jne    1b4 <strchr+0x24>
 1a7:	eb 17                	jmp    1c0 <strchr+0x30>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b0:	38 ca                	cmp    %cl,%dl
 1b2:	74 0c                	je     1c0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b4:	83 c0 01             	add    $0x1,%eax
 1b7:	0f b6 10             	movzbl (%eax),%edx
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 1be:	31 c0                	xor    %eax,%eax
}
 1c0:	5b                   	pop    %ebx
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 1d7:	53                   	push   %ebx
 1d8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1db:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	eb 31                	jmp    211 <gets+0x41>
    cc = read(0, &c, 1);
 1e0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1e7:	00 
 1e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1f3:	e8 04 01 00 00       	call   2fc <read>
    if(cc < 1)
 1f8:	85 c0                	test   %eax,%eax
 1fa:	7e 1d                	jle    219 <gets+0x49>
      break;
    buf[i++] = c;
 1fc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 200:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 202:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 205:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 207:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 20b:	74 0c                	je     219 <gets+0x49>
 20d:	3c 0a                	cmp    $0xa,%al
 20f:	74 08                	je     219 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 211:	8d 5e 01             	lea    0x1(%esi),%ebx
 214:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 217:	7c c7                	jl     1e0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 220:	83 c4 2c             	add    $0x2c,%esp
 223:	5b                   	pop    %ebx
 224:	5e                   	pop    %esi
 225:	5f                   	pop    %edi
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    
 228:	90                   	nop
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000230 <stat>:

int
stat(char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
 235:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 242:	00 
 243:	89 04 24             	mov    %eax,(%esp)
 246:	e8 d9 00 00 00       	call   324 <open>
  if(fd < 0)
 24b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 24f:	78 27                	js     278 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 251:	8b 45 0c             	mov    0xc(%ebp),%eax
 254:	89 1c 24             	mov    %ebx,(%esp)
 257:	89 44 24 04          	mov    %eax,0x4(%esp)
 25b:	e8 dc 00 00 00       	call   33c <fstat>
  close(fd);
 260:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 263:	89 c6                	mov    %eax,%esi
  close(fd);
 265:	e8 a2 00 00 00       	call   30c <close>
  return r;
 26a:	89 f0                	mov    %esi,%eax
}
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	5b                   	pop    %ebx
 270:	5e                   	pop    %esi
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    
 273:	90                   	nop
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 27d:	eb ed                	jmp    26c <stat+0x3c>
 27f:	90                   	nop

00000280 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 4d 08             	mov    0x8(%ebp),%ecx
 286:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 11             	movsbl (%ecx),%edx
 28a:	8d 42 d0             	lea    -0x30(%edx),%eax
 28d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 28f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 294:	77 17                	ja     2ad <atoi+0x2d>
 296:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 298:	83 c1 01             	add    $0x1,%ecx
 29b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 29e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a2:	0f be 11             	movsbl (%ecx),%edx
 2a5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2a8:	80 fb 09             	cmp    $0x9,%bl
 2ab:	76 eb                	jbe    298 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 2ad:	5b                   	pop    %ebx
 2ae:	5d                   	pop    %ebp
 2af:	c3                   	ret    

000002b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	56                   	push   %esi
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	53                   	push   %ebx
 2ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c0:	85 db                	test   %ebx,%ebx
 2c2:	7e 12                	jle    2d6 <memmove+0x26>
 2c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2cf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d2:	39 da                	cmp    %ebx,%edx
 2d4:	75 f2                	jne    2c8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5d                   	pop    %ebp
 2d9:	c3                   	ret    
 2da:	66 90                	xchg   %ax,%ax

000002dc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2dc:	b8 01 00 00 00       	mov    $0x1,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <exit>:
SYSCALL(exit)
 2e4:	b8 02 00 00 00       	mov    $0x2,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <wait>:
SYSCALL(wait)
 2ec:	b8 03 00 00 00       	mov    $0x3,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <pipe>:
SYSCALL(pipe)
 2f4:	b8 04 00 00 00       	mov    $0x4,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <read>:
SYSCALL(read)
 2fc:	b8 05 00 00 00       	mov    $0x5,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <write>:
SYSCALL(write)
 304:	b8 10 00 00 00       	mov    $0x10,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <close>:
SYSCALL(close)
 30c:	b8 15 00 00 00       	mov    $0x15,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <kill>:
SYSCALL(kill)
 314:	b8 06 00 00 00       	mov    $0x6,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <exec>:
SYSCALL(exec)
 31c:	b8 07 00 00 00       	mov    $0x7,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <open>:
SYSCALL(open)
 324:	b8 0f 00 00 00       	mov    $0xf,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mknod>:
SYSCALL(mknod)
 32c:	b8 11 00 00 00       	mov    $0x11,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <unlink>:
SYSCALL(unlink)
 334:	b8 12 00 00 00       	mov    $0x12,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <fstat>:
SYSCALL(fstat)
 33c:	b8 08 00 00 00       	mov    $0x8,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <link>:
SYSCALL(link)
 344:	b8 13 00 00 00       	mov    $0x13,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <mkdir>:
SYSCALL(mkdir)
 34c:	b8 14 00 00 00       	mov    $0x14,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <chdir>:
SYSCALL(chdir)
 354:	b8 09 00 00 00       	mov    $0x9,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <dup>:
SYSCALL(dup)
 35c:	b8 0a 00 00 00       	mov    $0xa,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <getpid>:
SYSCALL(getpid)
 364:	b8 0b 00 00 00       	mov    $0xb,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <sbrk>:
SYSCALL(sbrk)
 36c:	b8 0c 00 00 00       	mov    $0xc,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <sleep>:
SYSCALL(sleep)
 374:	b8 0d 00 00 00       	mov    $0xd,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <uptime>:
SYSCALL(uptime)
 37c:	b8 0e 00 00 00       	mov    $0xe,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wakeall>:
SYSCALL(wakeall)
 384:	b8 19 00 00 00       	mov    $0x19,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <runnable>:
SYSCALL(runnable)
 38c:	b8 16 00 00 00       	mov    $0x16,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <translate>:
SYSCALL(translate)
 394:	b8 1b 00 00 00       	mov    $0x1b,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    
 39c:	66 90                	xchg   %ax,%ax
 39e:	66 90                	xchg   %ax,%ax

000003a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	89 c6                	mov    %eax,%esi
 3a7:	53                   	push   %ebx
 3a8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3ae:	85 db                	test   %ebx,%ebx
 3b0:	74 09                	je     3bb <printint+0x1b>
 3b2:	89 d0                	mov    %edx,%eax
 3b4:	c1 e8 1f             	shr    $0x1f,%eax
 3b7:	84 c0                	test   %al,%al
 3b9:	75 75                	jne    430 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3bb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3bd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3c4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3c7:	31 ff                	xor    %edi,%edi
 3c9:	89 ce                	mov    %ecx,%esi
 3cb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3ce:	eb 02                	jmp    3d2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 3d0:	89 cf                	mov    %ecx,%edi
 3d2:	31 d2                	xor    %edx,%edx
 3d4:	f7 f6                	div    %esi
 3d6:	8d 4f 01             	lea    0x1(%edi),%ecx
 3d9:	0f b6 92 29 08 00 00 	movzbl 0x829(%edx),%edx
  }while((x /= base) != 0);
 3e0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3e2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3e5:	75 e9                	jne    3d0 <printint+0x30>
  if(neg)
 3e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3ea:	89 c8                	mov    %ecx,%eax
 3ec:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 3ef:	85 d2                	test   %edx,%edx
 3f1:	74 08                	je     3fb <printint+0x5b>
    buf[i++] = '-';
 3f3:	8d 4f 02             	lea    0x2(%edi),%ecx
 3f6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 3fb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3fe:	66 90                	xchg   %ax,%ax
 400:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 405:	83 ef 01             	sub    $0x1,%edi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 408:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 40f:	00 
 410:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 414:	89 34 24             	mov    %esi,(%esp)
 417:	88 45 d7             	mov    %al,-0x29(%ebp)
 41a:	e8 e5 fe ff ff       	call   304 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 41f:	83 ff ff             	cmp    $0xffffffff,%edi
 422:	75 dc                	jne    400 <printint+0x60>
    putc(fd, buf[i]);
}
 424:	83 c4 4c             	add    $0x4c,%esp
 427:	5b                   	pop    %ebx
 428:	5e                   	pop    %esi
 429:	5f                   	pop    %edi
 42a:	5d                   	pop    %ebp
 42b:	c3                   	ret    
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 430:	89 d0                	mov    %edx,%eax
 432:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 434:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 43b:	eb 87                	jmp    3c4 <printint+0x24>
 43d:	8d 76 00             	lea    0x0(%esi),%esi

00000440 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 444:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 446:	56                   	push   %esi
 447:	53                   	push   %ebx
 448:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 44b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 44e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 451:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 454:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 457:	0f b6 13             	movzbl (%ebx),%edx
 45a:	83 c3 01             	add    $0x1,%ebx
 45d:	84 d2                	test   %dl,%dl
 45f:	75 39                	jne    49a <printf+0x5a>
 461:	e9 c2 00 00 00       	jmp    528 <printf+0xe8>
 466:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 468:	83 fa 25             	cmp    $0x25,%edx
 46b:	0f 84 bf 00 00 00    	je     530 <printf+0xf0>
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 471:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 474:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47b:	00 
 47c:	89 44 24 04          	mov    %eax,0x4(%esp)
 480:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 483:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 486:	e8 79 fe ff ff       	call   304 <write>
 48b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 48e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 492:	84 d2                	test   %dl,%dl
 494:	0f 84 8e 00 00 00    	je     528 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 49a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 49c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 49f:	74 c7                	je     468 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4a1:	83 ff 25             	cmp    $0x25,%edi
 4a4:	75 e5                	jne    48b <printf+0x4b>
      if(c == 'd'){
 4a6:	83 fa 64             	cmp    $0x64,%edx
 4a9:	0f 84 31 01 00 00    	je     5e0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4af:	25 f7 00 00 00       	and    $0xf7,%eax
 4b4:	83 f8 70             	cmp    $0x70,%eax
 4b7:	0f 84 83 00 00 00    	je     540 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4bd:	83 fa 73             	cmp    $0x73,%edx
 4c0:	0f 84 a2 00 00 00    	je     568 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c6:	83 fa 63             	cmp    $0x63,%edx
 4c9:	0f 84 35 01 00 00    	je     604 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4cf:	83 fa 25             	cmp    $0x25,%edx
 4d2:	0f 84 e0 00 00 00    	je     5b8 <printf+0x178>
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4db:	83 c3 01             	add    $0x1,%ebx
 4de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4e5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e6:	31 ff                	xor    %edi,%edi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ec:	89 34 24             	mov    %esi,(%esp)
 4ef:	89 55 d0             	mov    %edx,-0x30(%ebp)
 4f2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 4f6:	e8 09 fe ff ff       	call   304 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4fe:	8d 45 e7             	lea    -0x19(%ebp),%eax
 501:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 508:	00 
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 510:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 513:	e8 ec fd ff ff       	call   304 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 518:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 51c:	84 d2                	test   %dl,%dl
 51e:	0f 85 76 ff ff ff    	jne    49a <printf+0x5a>
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 528:	83 c4 3c             	add    $0x3c,%esp
 52b:	5b                   	pop    %ebx
 52c:	5e                   	pop    %esi
 52d:	5f                   	pop    %edi
 52e:	5d                   	pop    %ebp
 52f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 530:	bf 25 00 00 00       	mov    $0x25,%edi
 535:	e9 51 ff ff ff       	jmp    48b <printf+0x4b>
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 540:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 543:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 548:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 54a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 551:	8b 10                	mov    (%eax),%edx
 553:	89 f0                	mov    %esi,%eax
 555:	e8 46 fe ff ff       	call   3a0 <printint>
        ap++;
 55a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 55e:	e9 28 ff ff ff       	jmp    48b <printf+0x4b>
 563:	90                   	nop
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 56b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 56f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 571:	b8 22 08 00 00       	mov    $0x822,%eax
 576:	85 ff                	test   %edi,%edi
 578:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 57b:	0f b6 07             	movzbl (%edi),%eax
 57e:	84 c0                	test   %al,%al
 580:	74 2a                	je     5ac <printf+0x16c>
 582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 588:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 58b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 58e:	83 c7 01             	add    $0x1,%edi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 591:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 598:	00 
 599:	89 44 24 04          	mov    %eax,0x4(%esp)
 59d:	89 34 24             	mov    %esi,(%esp)
 5a0:	e8 5f fd ff ff       	call   304 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a5:	0f b6 07             	movzbl (%edi),%eax
 5a8:	84 c0                	test   %al,%al
 5aa:	75 dc                	jne    588 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ac:	31 ff                	xor    %edi,%edi
 5ae:	e9 d8 fe ff ff       	jmp    48b <printf+0x4b>
 5b3:	90                   	nop
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5bb:	31 ff                	xor    %edi,%edi
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5bd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c4:	00 
 5c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c9:	89 34 24             	mov    %esi,(%esp)
 5cc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 5d0:	e8 2f fd ff ff       	call   304 <write>
 5d5:	e9 b1 fe ff ff       	jmp    48b <printf+0x4b>
 5da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5e8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5f2:	8b 10                	mov    (%eax),%edx
 5f4:	89 f0                	mov    %esi,%eax
 5f6:	e8 a5 fd ff ff       	call   3a0 <printint>
        ap++;
 5fb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5ff:	e9 87 fe ff ff       	jmp    48b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 604:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 607:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 609:	8b 00                	mov    (%eax),%eax
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 60b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 612:	00 
 613:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 616:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "printf.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 619:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 61c:	89 44 24 04          	mov    %eax,0x4(%esp)
 620:	e8 df fc ff ff       	call   304 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 625:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 629:	e9 5d fe ff ff       	jmp    48b <printf+0x4b>
 62e:	66 90                	xchg   %ax,%ax

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	a1 a4 0a 00 00       	mov    0xaa4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 636:	89 e5                	mov    %esp,%ebp
 638:	57                   	push   %edi
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
 63b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 640:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 643:	39 d0                	cmp    %edx,%eax
 645:	72 11                	jb     658 <free+0x28>
 647:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 648:	39 c8                	cmp    %ecx,%eax
 64a:	72 04                	jb     650 <free+0x20>
 64c:	39 ca                	cmp    %ecx,%edx
 64e:	72 10                	jb     660 <free+0x30>
 650:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 654:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 656:	73 f0                	jae    648 <free+0x18>
 658:	39 ca                	cmp    %ecx,%edx
 65a:	72 04                	jb     660 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65c:	39 c8                	cmp    %ecx,%eax
 65e:	72 f0                	jb     650 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 660:	8b 73 fc             	mov    -0x4(%ebx),%esi
 663:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 666:	39 cf                	cmp    %ecx,%edi
 668:	74 1e                	je     688 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 66a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 66d:	8b 48 04             	mov    0x4(%eax),%ecx
 670:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 673:	39 f2                	cmp    %esi,%edx
 675:	74 28                	je     69f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 677:	89 10                	mov    %edx,(%eax)
  freep = p;
 679:	a3 a4 0a 00 00       	mov    %eax,0xaa4
}
 67e:	5b                   	pop    %ebx
 67f:	5e                   	pop    %esi
 680:	5f                   	pop    %edi
 681:	5d                   	pop    %ebp
 682:	c3                   	ret    
 683:	90                   	nop
 684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 688:	03 71 04             	add    0x4(%ecx),%esi
 68b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 68e:	8b 08                	mov    (%eax),%ecx
 690:	8b 09                	mov    (%ecx),%ecx
 692:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 695:	8b 48 04             	mov    0x4(%eax),%ecx
 698:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 69b:	39 f2                	cmp    %esi,%edx
 69d:	75 d8                	jne    677 <free+0x47>
    p->s.size += bp->s.size;
 69f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6a2:	a3 a4 0a 00 00       	mov    %eax,0xaa4
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6aa:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6ad:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6af:	5b                   	pop    %ebx
 6b0:	5e                   	pop    %esi
 6b1:	5f                   	pop    %edi
 6b2:	5d                   	pop    %ebp
 6b3:	c3                   	ret    
 6b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6cc:	8b 1d a4 0a 00 00    	mov    0xaa4,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d2:	8d 48 07             	lea    0x7(%eax),%ecx
 6d5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 6d8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6da:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 6dd:	0f 84 9b 00 00 00    	je     77e <malloc+0xbe>
 6e3:	8b 13                	mov    (%ebx),%edx
 6e5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6e8:	39 fe                	cmp    %edi,%esi
 6ea:	76 64                	jbe    750 <malloc+0x90>
 6ec:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 6f3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 6f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6fb:	eb 0e                	jmp    70b <malloc+0x4b>
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 700:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 702:	8b 78 04             	mov    0x4(%eax),%edi
 705:	39 fe                	cmp    %edi,%esi
 707:	76 4f                	jbe    758 <malloc+0x98>
 709:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 70b:	3b 15 a4 0a 00 00    	cmp    0xaa4,%edx
 711:	75 ed                	jne    700 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 716:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 71c:	bf 00 10 00 00       	mov    $0x1000,%edi
 721:	0f 43 fe             	cmovae %esi,%edi
 724:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 3d fc ff ff       	call   36c <sbrk>
  if(p == (char*)-1)
 72f:	83 f8 ff             	cmp    $0xffffffff,%eax
 732:	74 18                	je     74c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 734:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 737:	83 c0 08             	add    $0x8,%eax
 73a:	89 04 24             	mov    %eax,(%esp)
 73d:	e8 ee fe ff ff       	call   630 <free>
  return freep;
 742:	8b 15 a4 0a 00 00    	mov    0xaa4,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 748:	85 d2                	test   %edx,%edx
 74a:	75 b4                	jne    700 <malloc+0x40>
        return 0;
 74c:	31 c0                	xor    %eax,%eax
 74e:	eb 20                	jmp    770 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 750:	89 d0                	mov    %edx,%eax
 752:	89 da                	mov    %ebx,%edx
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 758:	39 fe                	cmp    %edi,%esi
 75a:	74 1c                	je     778 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 75c:	29 f7                	sub    %esi,%edi
 75e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 761:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 764:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 767:	89 15 a4 0a 00 00    	mov    %edx,0xaa4
      return (void*)(p + 1);
 76d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 770:	83 c4 1c             	add    $0x1c,%esp
 773:	5b                   	pop    %ebx
 774:	5e                   	pop    %esi
 775:	5f                   	pop    %edi
 776:	5d                   	pop    %ebp
 777:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 778:	8b 08                	mov    (%eax),%ecx
 77a:	89 0a                	mov    %ecx,(%edx)
 77c:	eb e9                	jmp    767 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 77e:	c7 05 a4 0a 00 00 a8 	movl   $0xaa8,0xaa4
 785:	0a 00 00 
    base.s.size = 0;
 788:	ba a8 0a 00 00       	mov    $0xaa8,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 78d:	c7 05 a8 0a 00 00 a8 	movl   $0xaa8,0xaa8
 794:	0a 00 00 
    base.s.size = 0;
 797:	c7 05 ac 0a 00 00 00 	movl   $0x0,0xaac
 79e:	00 00 00 
 7a1:	e9 46 ff ff ff       	jmp    6ec <malloc+0x2c>
