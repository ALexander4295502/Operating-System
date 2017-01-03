
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 2e 10 80       	mov    $0x80102e50,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80100046:	c7 44 24 04 80 6e 10 	movl   $0x80106e80,0x4(%esp)
8010004d:	80 
8010004e:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100055:	e8 a6 41 00 00       	call   80104200 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
8010005a:	b9 e4 f4 10 80       	mov    $0x8010f4e4,%ecx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010005f:	b8 14 b6 10 80       	mov    $0x8010b614,%eax

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100064:	c7 05 f0 f4 10 80 e4 	movl   $0x8010f4e4,0x8010f4f0
8010006b:	f4 10 80 
  bcache.head.next = &bcache.head;
8010006e:	c7 05 f4 f4 10 80 e4 	movl   $0x8010f4e4,0x8010f4f4
80100075:	f4 10 80 
80100078:	eb 0a                	jmp    80100084 <binit+0x44>
8010007a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100080:	89 c1                	mov    %eax,%ecx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 d0                	mov    %edx,%eax
    b->next = bcache.head.next;
80100084:	89 48 10             	mov    %ecx,0x10(%eax)
    b->prev = &bcache.head;
80100087:	c7 40 0c e4 f4 10 80 	movl   $0x8010f4e4,0xc(%eax)
    b->dev = -1;
8010008e:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
80100095:	8b 15 f4 f4 10 80    	mov    0x8010f4f4,%edx
8010009b:	89 42 0c             	mov    %eax,0xc(%edx)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	8d 90 18 02 00 00    	lea    0x218(%eax),%edx
801000a4:	81 fa e4 f4 10 80    	cmp    $0x8010f4e4,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000aa:	a3 f4 f4 10 80       	mov    %eax,0x8010f4f4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000af:	75 cf                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    
801000b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801000b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000c0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	57                   	push   %edi
801000c4:	56                   	push   %esi
801000c5:	53                   	push   %ebx
801000c6:	83 ec 1c             	sub    $0x1c,%esp
801000c9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000cc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
}

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000d6:	e8 a5 41 00 00       	call   80104280 <acquire>

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000db:	8b 1d f4 f4 10 80    	mov    0x8010f4f4,%ebx
801000e1:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
801000e7:	75 12                	jne    801000fb <bread+0x3b>
801000e9:	eb 35                	jmp    80100120 <bread+0x60>
801000eb:	90                   	nop
801000ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000f0:	8b 5b 10             	mov    0x10(%ebx),%ebx
801000f3:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
801000f9:	74 25                	je     80100120 <bread+0x60>
    if(b->dev == dev && b->blockno == blockno){
801000fb:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fe:	75 f0                	jne    801000f0 <bread+0x30>
80100100:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100103:	75 eb                	jne    801000f0 <bread+0x30>
      if(!(b->flags & B_BUSY)){
80100105:	8b 03                	mov    (%ebx),%eax
80100107:	a8 01                	test   $0x1,%al
80100109:	74 64                	je     8010016f <bread+0xaf>
        b->flags |= B_BUSY;
        release(&bcache.lock);
        return b;
      }
      sleep(b, &bcache.lock);
8010010b:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
80100112:	80 
80100113:	89 1c 24             	mov    %ebx,(%esp)
80100116:	e8 95 3d 00 00       	call   80103eb0 <sleep>
8010011b:	eb be                	jmp    801000db <bread+0x1b>
8010011d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d f0 f4 10 80    	mov    0x8010f4f0,%ebx
80100126:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x7b>
8010012e:	eb 52                	jmp    80100182 <bread+0xc2>
80100130:	8b 5b 0c             	mov    0xc(%ebx),%ebx
80100133:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
80100139:	74 47                	je     80100182 <bread+0xc2>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010013b:	f6 03 05             	testb  $0x5,(%ebx)
8010013e:	75 f0                	jne    80100130 <bread+0x70>
      b->dev = dev;
80100140:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100143:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = B_BUSY;
80100146:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      release(&bcache.lock);
8010014c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100153:	e8 58 42 00 00       	call   801043b0 <release>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100158:	f6 03 02             	testb  $0x2,(%ebx)
8010015b:	75 08                	jne    80100165 <bread+0xa5>
    iderw(b);
8010015d:	89 1c 24             	mov    %ebx,(%esp)
80100160:	e8 ab 1f 00 00       	call   80102110 <iderw>
  }
  return b;
}
80100165:	83 c4 1c             	add    $0x1c,%esp
80100168:	89 d8                	mov    %ebx,%eax
8010016a:	5b                   	pop    %ebx
8010016b:	5e                   	pop    %esi
8010016c:	5f                   	pop    %edi
8010016d:	5d                   	pop    %ebp
8010016e:	c3                   	ret    
 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      if(!(b->flags & B_BUSY)){
        b->flags |= B_BUSY;
8010016f:	83 c8 01             	or     $0x1,%eax
80100172:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
80100174:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010017b:	e8 30 42 00 00       	call   801043b0 <release>
80100180:	eb d6                	jmp    80100158 <bread+0x98>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100182:	c7 04 24 87 6e 10 80 	movl   $0x80106e87,(%esp)
80100189:	e8 a2 01 00 00       	call   80100330 <panic>
8010018e:	66 90                	xchg   %ax,%ax

80100190 <bwrite>:
}

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
80100190:	55                   	push   %ebp
80100191:	89 e5                	mov    %esp,%ebp
80100193:	83 ec 18             	sub    $0x18,%esp
80100196:	8b 45 08             	mov    0x8(%ebp),%eax
  if((b->flags & B_BUSY) == 0)
80100199:	8b 10                	mov    (%eax),%edx
8010019b:	f6 c2 01             	test   $0x1,%dl
8010019e:	74 0e                	je     801001ae <bwrite+0x1e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001a0:	83 ca 04             	or     $0x4,%edx
801001a3:	89 10                	mov    %edx,(%eax)
  iderw(b);
801001a5:	89 45 08             	mov    %eax,0x8(%ebp)
}
801001a8:	c9                   	leave  
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001a9:	e9 62 1f 00 00       	jmp    80102110 <iderw>
// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
801001ae:	c7 04 24 98 6e 10 80 	movl   $0x80106e98,(%esp)
801001b5:	e8 76 01 00 00       	call   80100330 <panic>
801001ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001c0 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c0:	55                   	push   %ebp
801001c1:	89 e5                	mov    %esp,%ebp
801001c3:	53                   	push   %ebx
801001c4:	83 ec 14             	sub    $0x14,%esp
801001c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
801001ca:	f6 03 01             	testb  $0x1,(%ebx)
801001cd:	74 57                	je     80100226 <brelse+0x66>
    panic("brelse");

  acquire(&bcache.lock);
801001cf:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801001d6:	e8 a5 40 00 00       	call   80104280 <acquire>

  b->next->prev = b->prev;
801001db:	8b 43 10             	mov    0x10(%ebx),%eax
801001de:	8b 53 0c             	mov    0xc(%ebx),%edx
801001e1:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
801001e4:	8b 43 0c             	mov    0xc(%ebx),%eax
801001e7:	8b 53 10             	mov    0x10(%ebx),%edx
801001ea:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
801001ed:	a1 f4 f4 10 80       	mov    0x8010f4f4,%eax
  b->prev = &bcache.head;
801001f2:	c7 43 0c e4 f4 10 80 	movl   $0x8010f4e4,0xc(%ebx)

  acquire(&bcache.lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bcache.head.next;
801001f9:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
801001fc:	a1 f4 f4 10 80       	mov    0x8010f4f4,%eax
80100201:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
80100204:	89 1d f4 f4 10 80    	mov    %ebx,0x8010f4f4

  b->flags &= ~B_BUSY;
8010020a:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
8010020d:	89 1c 24             	mov    %ebx,(%esp)
80100210:	e8 3b 3e 00 00       	call   80104050 <wakeup>

  release(&bcache.lock);
80100215:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010021c:	83 c4 14             	add    $0x14,%esp
8010021f:	5b                   	pop    %ebx
80100220:	5d                   	pop    %ebp
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  wakeup(b);

  release(&bcache.lock);
80100221:	e9 8a 41 00 00       	jmp    801043b0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
80100226:	c7 04 24 9f 6e 10 80 	movl   $0x80106e9f,(%esp)
8010022d:	e8 fe 00 00 00       	call   80100330 <panic>
80100232:	66 90                	xchg   %ax,%ax
80100234:	66 90                	xchg   %ax,%ax
80100236:	66 90                	xchg   %ax,%ax
80100238:	66 90                	xchg   %ax,%ax
8010023a:	66 90                	xchg   %ax,%ax
8010023c:	66 90                	xchg   %ax,%ax
8010023e:	66 90                	xchg   %ax,%ax

80100240 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100240:	55                   	push   %ebp
80100241:	89 e5                	mov    %esp,%ebp
80100243:	57                   	push   %edi
80100244:	56                   	push   %esi
80100245:	53                   	push   %ebx
80100246:	83 ec 1c             	sub    $0x1c,%esp
80100249:	8b 7d 08             	mov    0x8(%ebp),%edi
8010024c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010024f:	89 3c 24             	mov    %edi,(%esp)
80100252:	e8 f9 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100257:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010025e:	e8 1d 40 00 00       	call   80104280 <acquire>
  while(n > 0){
80100263:	8b 55 10             	mov    0x10(%ebp),%edx
80100266:	85 d2                	test   %edx,%edx
80100268:	0f 8e bc 00 00 00    	jle    8010032a <consoleread+0xea>
8010026e:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100271:	eb 26                	jmp    80100299 <consoleread+0x59>
80100273:	90                   	nop
80100274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(proc->killed){
80100278:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010027e:	8b 40 24             	mov    0x24(%eax),%eax
80100281:	85 c0                	test   %eax,%eax
80100283:	75 73                	jne    801002f8 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100285:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
8010028c:	80 
8010028d:	c7 04 24 80 f7 10 80 	movl   $0x8010f780,(%esp)
80100294:	e8 17 3c 00 00       	call   80103eb0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100299:	a1 80 f7 10 80       	mov    0x8010f780,%eax
8010029e:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
801002a4:	74 d2                	je     80100278 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002a6:	8d 50 01             	lea    0x1(%eax),%edx
801002a9:	89 15 80 f7 10 80    	mov    %edx,0x8010f780
801002af:	89 c2                	mov    %eax,%edx
801002b1:	83 e2 7f             	and    $0x7f,%edx
801002b4:	0f b6 8a 00 f7 10 80 	movzbl -0x7fef0900(%edx),%ecx
801002bb:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002be:	83 fa 04             	cmp    $0x4,%edx
801002c1:	74 56                	je     80100319 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002c3:	83 c6 01             	add    $0x1,%esi
    --n;
801002c6:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002c9:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002cc:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002cf:	74 52                	je     80100323 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
801002d1:	85 db                	test   %ebx,%ebx
801002d3:	75 c4                	jne    80100299 <consoleread+0x59>
801002d5:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
801002d8:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801002e2:	e8 c9 40 00 00       	call   801043b0 <release>
  ilock(ip);
801002e7:	89 3c 24             	mov    %edi,(%esp)
801002ea:	e8 51 13 00 00       	call   80101640 <ilock>
801002ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
801002f2:	eb 1d                	jmp    80100311 <consoleread+0xd1>
801002f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
801002f8:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002ff:	e8 ac 40 00 00       	call   801043b0 <release>
        ilock(ip);
80100304:	89 3c 24             	mov    %edi,(%esp)
80100307:	e8 34 13 00 00       	call   80101640 <ilock>
        return -1;
8010030c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100311:	83 c4 1c             	add    $0x1c,%esp
80100314:	5b                   	pop    %ebx
80100315:	5e                   	pop    %esi
80100316:	5f                   	pop    %edi
80100317:	5d                   	pop    %ebp
80100318:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100319:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010031c:	76 05                	jbe    80100323 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010031e:	a3 80 f7 10 80       	mov    %eax,0x8010f780
80100323:	8b 45 10             	mov    0x10(%ebp),%eax
80100326:	29 d8                	sub    %ebx,%eax
80100328:	eb ae                	jmp    801002d8 <consoleread+0x98>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010032a:	31 c0                	xor    %eax,%eax
8010032c:	eb aa                	jmp    801002d8 <consoleread+0x98>
8010032e:	66 90                	xchg   %ax,%ax

80100330 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100330:	55                   	push   %ebp
80100331:	89 e5                	mov    %esp,%ebp
80100333:	56                   	push   %esi
80100334:	53                   	push   %ebx
80100335:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100338:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100339:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010033f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100342:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100349:	00 00 00 
8010034c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010034f:	0f b6 00             	movzbl (%eax),%eax
80100352:	c7 04 24 a6 6e 10 80 	movl   $0x80106ea6,(%esp)
80100359:	89 44 24 04          	mov    %eax,0x4(%esp)
8010035d:	e8 be 02 00 00       	call   80100620 <cprintf>
  cprintf(s);
80100362:	8b 45 08             	mov    0x8(%ebp),%eax
80100365:	89 04 24             	mov    %eax,(%esp)
80100368:	e8 b3 02 00 00       	call   80100620 <cprintf>
  cprintf("\n");
8010036d:	c7 04 24 c6 73 10 80 	movl   $0x801073c6,(%esp)
80100374:	e8 a7 02 00 00       	call   80100620 <cprintf>
  getcallerpcs(&s, pcs);
80100379:	8d 45 08             	lea    0x8(%ebp),%eax
8010037c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100380:	89 04 24             	mov    %eax,(%esp)
80100383:	e8 98 3e 00 00       	call   80104220 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
80100388:	8b 03                	mov    (%ebx),%eax
8010038a:	83 c3 04             	add    $0x4,%ebx
8010038d:	c7 04 24 c2 6e 10 80 	movl   $0x80106ec2,(%esp)
80100394:	89 44 24 04          	mov    %eax,0x4(%esp)
80100398:	e8 83 02 00 00       	call   80100620 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
8010039d:	39 f3                	cmp    %esi,%ebx
8010039f:	75 e7                	jne    80100388 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003a1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003a8:	00 00 00 
801003ab:	eb fe                	jmp    801003ab <panic+0x7b>
801003ad:	8d 76 00             	lea    0x0(%esi),%esi

801003b0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003b0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003b6:	85 d2                	test   %edx,%edx
801003b8:	74 06                	je     801003c0 <consputc+0x10>
801003ba:	fa                   	cli    
801003bb:	eb fe                	jmp    801003bb <consputc+0xb>
801003bd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003c0:	55                   	push   %ebp
801003c1:	89 e5                	mov    %esp,%ebp
801003c3:	57                   	push   %edi
801003c4:	56                   	push   %esi
801003c5:	53                   	push   %ebx
801003c6:	89 c3                	mov    %eax,%ebx
801003c8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003cb:	3d 00 01 00 00       	cmp    $0x100,%eax
801003d0:	0f 84 ac 00 00 00    	je     80100482 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
801003d6:	89 04 24             	mov    %eax,(%esp)
801003d9:	e8 02 56 00 00       	call   801059e0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003de:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003e3:	b8 0e 00 00 00       	mov    $0xe,%eax
801003e8:	89 fa                	mov    %edi,%edx
801003ea:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003eb:	be d5 03 00 00       	mov    $0x3d5,%esi
801003f0:	89 f2                	mov    %esi,%edx
801003f2:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
801003f3:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003f6:	89 fa                	mov    %edi,%edx
801003f8:	c1 e1 08             	shl    $0x8,%ecx
801003fb:	b8 0f 00 00 00       	mov    $0xf,%eax
80100400:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100401:	89 f2                	mov    %esi,%edx
80100403:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100404:	0f b6 c0             	movzbl %al,%eax
80100407:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100409:	83 fb 0a             	cmp    $0xa,%ebx
8010040c:	0f 84 0d 01 00 00    	je     8010051f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100412:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100418:	0f 84 e8 00 00 00    	je     80100506 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010041e:	0f b6 db             	movzbl %bl,%ebx
80100421:	80 cf 07             	or     $0x7,%bh
80100424:	8d 79 01             	lea    0x1(%ecx),%edi
80100427:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010042e:	80 

  if(pos < 0 || pos > 25*80)
8010042f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100435:	0f 87 bf 00 00 00    	ja     801004fa <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010043b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100441:	7f 68                	jg     801004ab <consputc+0xfb>
80100443:	89 f8                	mov    %edi,%eax
80100445:	89 fb                	mov    %edi,%ebx
80100447:	c1 e8 08             	shr    $0x8,%eax
8010044a:	89 c6                	mov    %eax,%esi
8010044c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100453:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100458:	b8 0e 00 00 00       	mov    $0xe,%eax
8010045d:	89 fa                	mov    %edi,%edx
8010045f:	ee                   	out    %al,(%dx)
80100460:	89 f0                	mov    %esi,%eax
80100462:	b2 d5                	mov    $0xd5,%dl
80100464:	ee                   	out    %al,(%dx)
80100465:	b8 0f 00 00 00       	mov    $0xf,%eax
8010046a:	89 fa                	mov    %edi,%edx
8010046c:	ee                   	out    %al,(%dx)
8010046d:	89 d8                	mov    %ebx,%eax
8010046f:	b2 d5                	mov    $0xd5,%dl
80100471:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
80100472:	b8 20 07 00 00       	mov    $0x720,%eax
80100477:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
8010047a:	83 c4 1c             	add    $0x1c,%esp
8010047d:	5b                   	pop    %ebx
8010047e:	5e                   	pop    %esi
8010047f:	5f                   	pop    %edi
80100480:	5d                   	pop    %ebp
80100481:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100482:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100489:	e8 52 55 00 00       	call   801059e0 <uartputc>
8010048e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100495:	e8 46 55 00 00       	call   801059e0 <uartputc>
8010049a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004a1:	e8 3a 55 00 00       	call   801059e0 <uartputc>
801004a6:	e9 33 ff ff ff       	jmp    801003de <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004ab:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004b2:	00 
    pos -= 80;
801004b3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004b6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004bd:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004be:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004c5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004cc:	e8 cf 3f 00 00       	call   801044a0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004d1:	b8 d0 07 00 00       	mov    $0x7d0,%eax
801004d6:	29 f8                	sub    %edi,%eax
801004d8:	01 c0                	add    %eax,%eax
801004da:	89 34 24             	mov    %esi,(%esp)
801004dd:	89 44 24 08          	mov    %eax,0x8(%esp)
801004e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801004e8:	00 
801004e9:	e8 12 3f 00 00       	call   80104400 <memset>
801004ee:	89 f1                	mov    %esi,%ecx
801004f0:	be 07 00 00 00       	mov    $0x7,%esi
801004f5:	e9 59 ff ff ff       	jmp    80100453 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
801004fa:	c7 04 24 c6 6e 10 80 	movl   $0x80106ec6,(%esp)
80100501:	e8 2a fe ff ff       	call   80100330 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100506:	85 c9                	test   %ecx,%ecx
80100508:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010050b:	0f 85 1e ff ff ff    	jne    8010042f <consputc+0x7f>
80100511:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100516:	31 db                	xor    %ebx,%ebx
80100518:	31 f6                	xor    %esi,%esi
8010051a:	e9 34 ff ff ff       	jmp    80100453 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010051f:	89 c8                	mov    %ecx,%eax
80100521:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100526:	f7 ea                	imul   %edx
80100528:	c1 ea 05             	shr    $0x5,%edx
8010052b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010052e:	c1 e0 04             	shl    $0x4,%eax
80100531:	8d 78 50             	lea    0x50(%eax),%edi
80100534:	e9 f6 fe ff ff       	jmp    8010042f <consputc+0x7f>
80100539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100540 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100540:	55                   	push   %ebp
80100541:	89 e5                	mov    %esp,%ebp
80100543:	57                   	push   %edi
80100544:	56                   	push   %esi
80100545:	89 d6                	mov    %edx,%esi
80100547:	53                   	push   %ebx
80100548:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010054b:	85 c9                	test   %ecx,%ecx
8010054d:	74 61                	je     801005b0 <printint+0x70>
8010054f:	85 c0                	test   %eax,%eax
80100551:	79 5d                	jns    801005b0 <printint+0x70>
    x = -xx;
80100553:	f7 d8                	neg    %eax
80100555:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010055a:	31 c9                	xor    %ecx,%ecx
8010055c:	eb 04                	jmp    80100562 <printint+0x22>
8010055e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100560:	89 d9                	mov    %ebx,%ecx
80100562:	31 d2                	xor    %edx,%edx
80100564:	f7 f6                	div    %esi
80100566:	8d 59 01             	lea    0x1(%ecx),%ebx
80100569:	0f b6 92 f1 6e 10 80 	movzbl -0x7fef910f(%edx),%edx
  }while((x /= base) != 0);
80100570:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
80100572:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100576:	75 e8                	jne    80100560 <printint+0x20>

  if(sign)
80100578:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
8010057a:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
8010057c:	74 08                	je     80100586 <printint+0x46>
    buf[i++] = '-';
8010057e:	8d 59 02             	lea    0x2(%ecx),%ebx
80100581:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
80100586:	83 eb 01             	sub    $0x1,%ebx
80100589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
80100590:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100595:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
80100598:	e8 13 fe ff ff       	call   801003b0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010059d:	83 fb ff             	cmp    $0xffffffff,%ebx
801005a0:	75 ee                	jne    80100590 <printint+0x50>
    consputc(buf[i]);
}
801005a2:	83 c4 1c             	add    $0x1c,%esp
801005a5:	5b                   	pop    %ebx
801005a6:	5e                   	pop    %esi
801005a7:	5f                   	pop    %edi
801005a8:	5d                   	pop    %ebp
801005a9:	c3                   	ret    
801005aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005b0:	31 ff                	xor    %edi,%edi
801005b2:	eb a6                	jmp    8010055a <printint+0x1a>
801005b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005c0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005c0:	55                   	push   %ebp
801005c1:	89 e5                	mov    %esp,%ebp
801005c3:	57                   	push   %edi
801005c4:	56                   	push   %esi
801005c5:	53                   	push   %ebx
801005c6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005cc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005cf:	89 04 24             	mov    %eax,(%esp)
801005d2:	e8 79 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
801005d7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005de:	e8 9d 3c 00 00       	call   80104280 <acquire>
801005e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
801005e6:	85 f6                	test   %esi,%esi
801005e8:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801005eb:	7e 12                	jle    801005ff <consolewrite+0x3f>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
801005f0:	0f b6 07             	movzbl (%edi),%eax
801005f3:	83 c7 01             	add    $0x1,%edi
801005f6:	e8 b5 fd ff ff       	call   801003b0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
801005fb:	39 df                	cmp    %ebx,%edi
801005fd:	75 f1                	jne    801005f0 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
801005ff:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100606:	e8 a5 3d 00 00       	call   801043b0 <release>
  ilock(ip);
8010060b:	8b 45 08             	mov    0x8(%ebp),%eax
8010060e:	89 04 24             	mov    %eax,(%esp)
80100611:	e8 2a 10 00 00       	call   80101640 <ilock>

  return n;
}
80100616:	83 c4 1c             	add    $0x1c,%esp
80100619:	89 f0                	mov    %esi,%eax
8010061b:	5b                   	pop    %ebx
8010061c:	5e                   	pop    %esi
8010061d:	5f                   	pop    %edi
8010061e:	5d                   	pop    %ebp
8010061f:	c3                   	ret    

80100620 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100629:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010062e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100630:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100633:	0f 85 27 01 00 00    	jne    80100760 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100639:	8b 45 08             	mov    0x8(%ebp),%eax
8010063c:	85 c0                	test   %eax,%eax
8010063e:	89 c1                	mov    %eax,%ecx
80100640:	0f 84 2b 01 00 00    	je     80100771 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100646:	0f b6 00             	movzbl (%eax),%eax
80100649:	31 db                	xor    %ebx,%ebx
8010064b:	89 cf                	mov    %ecx,%edi
8010064d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100650:	85 c0                	test   %eax,%eax
80100652:	75 4c                	jne    801006a0 <cprintf+0x80>
80100654:	eb 5f                	jmp    801006b5 <cprintf+0x95>
80100656:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100658:	83 c3 01             	add    $0x1,%ebx
8010065b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010065f:	85 d2                	test   %edx,%edx
80100661:	74 52                	je     801006b5 <cprintf+0x95>
      break;
    switch(c){
80100663:	83 fa 70             	cmp    $0x70,%edx
80100666:	74 72                	je     801006da <cprintf+0xba>
80100668:	7f 66                	jg     801006d0 <cprintf+0xb0>
8010066a:	83 fa 25             	cmp    $0x25,%edx
8010066d:	8d 76 00             	lea    0x0(%esi),%esi
80100670:	0f 84 a2 00 00 00    	je     80100718 <cprintf+0xf8>
80100676:	83 fa 64             	cmp    $0x64,%edx
80100679:	75 7d                	jne    801006f8 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
8010067b:	8d 46 04             	lea    0x4(%esi),%eax
8010067e:	b9 01 00 00 00       	mov    $0x1,%ecx
80100683:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100686:	8b 06                	mov    (%esi),%eax
80100688:	ba 0a 00 00 00       	mov    $0xa,%edx
8010068d:	e8 ae fe ff ff       	call   80100540 <printint>
80100692:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100695:	83 c3 01             	add    $0x1,%ebx
80100698:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010069c:	85 c0                	test   %eax,%eax
8010069e:	74 15                	je     801006b5 <cprintf+0x95>
    if(c != '%'){
801006a0:	83 f8 25             	cmp    $0x25,%eax
801006a3:	74 b3                	je     80100658 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006a5:	e8 06 fd ff ff       	call   801003b0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006aa:	83 c3 01             	add    $0x1,%ebx
801006ad:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006b1:	85 c0                	test   %eax,%eax
801006b3:	75 eb                	jne    801006a0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006b8:	85 c0                	test   %eax,%eax
801006ba:	74 0c                	je     801006c8 <cprintf+0xa8>
    release(&cons.lock);
801006bc:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006c3:	e8 e8 3c 00 00       	call   801043b0 <release>
}
801006c8:	83 c4 1c             	add    $0x1c,%esp
801006cb:	5b                   	pop    %ebx
801006cc:	5e                   	pop    %esi
801006cd:	5f                   	pop    %edi
801006ce:	5d                   	pop    %ebp
801006cf:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
801006d0:	83 fa 73             	cmp    $0x73,%edx
801006d3:	74 53                	je     80100728 <cprintf+0x108>
801006d5:	83 fa 78             	cmp    $0x78,%edx
801006d8:	75 1e                	jne    801006f8 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801006da:	8d 46 04             	lea    0x4(%esi),%eax
801006dd:	31 c9                	xor    %ecx,%ecx
801006df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006e2:	8b 06                	mov    (%esi),%eax
801006e4:	ba 10 00 00 00       	mov    $0x10,%edx
801006e9:	e8 52 fe ff ff       	call   80100540 <printint>
801006ee:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
801006f1:	eb a2                	jmp    80100695 <cprintf+0x75>
801006f3:	90                   	nop
801006f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100700:	e8 ab fc ff ff       	call   801003b0 <consputc>
      consputc(c);
80100705:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100708:	89 d0                	mov    %edx,%eax
8010070a:	e8 a1 fc ff ff       	call   801003b0 <consputc>
8010070f:	eb 99                	jmp    801006aa <cprintf+0x8a>
80100711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100718:	b8 25 00 00 00       	mov    $0x25,%eax
8010071d:	e8 8e fc ff ff       	call   801003b0 <consputc>
      break;
80100722:	e9 6e ff ff ff       	jmp    80100695 <cprintf+0x75>
80100727:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100728:	8d 46 04             	lea    0x4(%esi),%eax
8010072b:	8b 36                	mov    (%esi),%esi
8010072d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100730:	b8 d9 6e 10 80       	mov    $0x80106ed9,%eax
80100735:	85 f6                	test   %esi,%esi
80100737:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010073a:	0f be 06             	movsbl (%esi),%eax
8010073d:	84 c0                	test   %al,%al
8010073f:	74 16                	je     80100757 <cprintf+0x137>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100748:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010074b:	e8 60 fc ff ff       	call   801003b0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100750:	0f be 06             	movsbl (%esi),%eax
80100753:	84 c0                	test   %al,%al
80100755:	75 f1                	jne    80100748 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100757:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010075a:	e9 36 ff ff ff       	jmp    80100695 <cprintf+0x75>
8010075f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100760:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100767:	e8 14 3b 00 00       	call   80104280 <acquire>
8010076c:	e9 c8 fe ff ff       	jmp    80100639 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
80100771:	c7 04 24 e0 6e 10 80 	movl   $0x80106ee0,(%esp)
80100778:	e8 b3 fb ff ff       	call   80100330 <panic>
8010077d:	8d 76 00             	lea    0x0(%esi),%esi

80100780 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100780:	55                   	push   %ebp
80100781:	89 e5                	mov    %esp,%ebp
80100783:	57                   	push   %edi
80100784:	56                   	push   %esi
  int c, doprocdump = 0;
80100785:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100787:	53                   	push   %ebx
80100788:	83 ec 1c             	sub    $0x1c,%esp
8010078b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
8010078e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100795:	e8 e6 3a 00 00       	call   80104280 <acquire>
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007a0:	ff d3                	call   *%ebx
801007a2:	85 c0                	test   %eax,%eax
801007a4:	89 c7                	mov    %eax,%edi
801007a6:	78 48                	js     801007f0 <consoleintr+0x70>
    switch(c){
801007a8:	83 ff 10             	cmp    $0x10,%edi
801007ab:	0f 84 2f 01 00 00    	je     801008e0 <consoleintr+0x160>
801007b1:	7e 5d                	jle    80100810 <consoleintr+0x90>
801007b3:	83 ff 15             	cmp    $0x15,%edi
801007b6:	0f 84 d4 00 00 00    	je     80100890 <consoleintr+0x110>
801007bc:	83 ff 7f             	cmp    $0x7f,%edi
801007bf:	90                   	nop
801007c0:	75 53                	jne    80100815 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007c2:	a1 88 f7 10 80       	mov    0x8010f788,%eax
801007c7:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
801007cd:	74 d1                	je     801007a0 <consoleintr+0x20>
        input.e--;
801007cf:	83 e8 01             	sub    $0x1,%eax
801007d2:	a3 88 f7 10 80       	mov    %eax,0x8010f788
        consputc(BACKSPACE);
801007d7:	b8 00 01 00 00       	mov    $0x100,%eax
801007dc:	e8 cf fb ff ff       	call   801003b0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801007e1:	ff d3                	call   *%ebx
801007e3:	85 c0                	test   %eax,%eax
801007e5:	89 c7                	mov    %eax,%edi
801007e7:	79 bf                	jns    801007a8 <consoleintr+0x28>
801007e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
801007f0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007f7:	e8 b4 3b 00 00       	call   801043b0 <release>
  if(doprocdump) {
801007fc:	85 f6                	test   %esi,%esi
801007fe:	0f 85 ec 00 00 00    	jne    801008f0 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100804:	83 c4 1c             	add    $0x1c,%esp
80100807:	5b                   	pop    %ebx
80100808:	5e                   	pop    %esi
80100809:	5f                   	pop    %edi
8010080a:	5d                   	pop    %ebp
8010080b:	c3                   	ret    
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100810:	83 ff 08             	cmp    $0x8,%edi
80100813:	74 ad                	je     801007c2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100815:	85 ff                	test   %edi,%edi
80100817:	74 87                	je     801007a0 <consoleintr+0x20>
80100819:	a1 88 f7 10 80       	mov    0x8010f788,%eax
8010081e:	89 c2                	mov    %eax,%edx
80100820:	2b 15 80 f7 10 80    	sub    0x8010f780,%edx
80100826:	83 fa 7f             	cmp    $0x7f,%edx
80100829:	0f 87 71 ff ff ff    	ja     801007a0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010082f:	8d 50 01             	lea    0x1(%eax),%edx
80100832:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100835:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100838:	89 15 88 f7 10 80    	mov    %edx,0x8010f788
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010083e:	0f 84 b8 00 00 00    	je     801008fc <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100844:	89 f9                	mov    %edi,%ecx
80100846:	88 88 00 f7 10 80    	mov    %cl,-0x7fef0900(%eax)
        consputc(c);
8010084c:	89 f8                	mov    %edi,%eax
8010084e:	e8 5d fb ff ff       	call   801003b0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100853:	83 ff 04             	cmp    $0x4,%edi
80100856:	a1 88 f7 10 80       	mov    0x8010f788,%eax
8010085b:	74 19                	je     80100876 <consoleintr+0xf6>
8010085d:	83 ff 0a             	cmp    $0xa,%edi
80100860:	74 14                	je     80100876 <consoleintr+0xf6>
80100862:	8b 0d 80 f7 10 80    	mov    0x8010f780,%ecx
80100868:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010086e:	39 d0                	cmp    %edx,%eax
80100870:	0f 85 2a ff ff ff    	jne    801007a0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
80100876:	c7 04 24 80 f7 10 80 	movl   $0x8010f780,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
8010087d:	a3 84 f7 10 80       	mov    %eax,0x8010f784
          wakeup(&input.r);
80100882:	e8 c9 37 00 00       	call   80104050 <wakeup>
80100887:	e9 14 ff ff ff       	jmp    801007a0 <consoleintr+0x20>
8010088c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100890:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100895:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
8010089b:	75 2b                	jne    801008c8 <consoleintr+0x148>
8010089d:	e9 fe fe ff ff       	jmp    801007a0 <consoleintr+0x20>
801008a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008a8:	a3 88 f7 10 80       	mov    %eax,0x8010f788
        consputc(BACKSPACE);
801008ad:	b8 00 01 00 00       	mov    $0x100,%eax
801008b2:	e8 f9 fa ff ff       	call   801003b0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008b7:	a1 88 f7 10 80       	mov    0x8010f788,%eax
801008bc:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
801008c2:	0f 84 d8 fe ff ff    	je     801007a0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008c8:	83 e8 01             	sub    $0x1,%eax
801008cb:	89 c2                	mov    %eax,%edx
801008cd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008d0:	80 ba 00 f7 10 80 0a 	cmpb   $0xa,-0x7fef0900(%edx)
801008d7:	75 cf                	jne    801008a8 <consoleintr+0x128>
801008d9:	e9 c2 fe ff ff       	jmp    801007a0 <consoleintr+0x20>
801008de:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
801008e0:	be 01 00 00 00       	mov    $0x1,%esi
801008e5:	e9 b6 fe ff ff       	jmp    801007a0 <consoleintr+0x20>
801008ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
801008f0:	83 c4 1c             	add    $0x1c,%esp
801008f3:	5b                   	pop    %ebx
801008f4:	5e                   	pop    %esi
801008f5:	5f                   	pop    %edi
801008f6:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
801008f7:	e9 34 38 00 00       	jmp    80104130 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
801008fc:	c6 80 00 f7 10 80 0a 	movb   $0xa,-0x7fef0900(%eax)
        consputc(c);
80100903:	b8 0a 00 00 00       	mov    $0xa,%eax
80100908:	e8 a3 fa ff ff       	call   801003b0 <consputc>
8010090d:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100912:	e9 5f ff ff ff       	jmp    80100876 <consoleintr+0xf6>
80100917:	89 f6                	mov    %esi,%esi
80100919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100920 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100926:	c7 44 24 04 e9 6e 10 	movl   $0x80106ee9,0x4(%esp)
8010092d:	80 
8010092e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100935:	e8 c6 38 00 00       	call   80104200 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010093a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100941:	c7 05 4c 01 11 80 c0 	movl   $0x801005c0,0x8011014c
80100948:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010094b:	c7 05 48 01 11 80 40 	movl   $0x80100240,0x80110148
80100952:	02 10 80 
  cons.locking = 1;
80100955:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
8010095c:	00 00 00 

  picenable(IRQ_KBD);
8010095f:	e8 8c 28 00 00       	call   801031f0 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100964:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010096b:	00 
8010096c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100973:	e8 28 19 00 00       	call   801022a0 <ioapicenable>
}
80100978:	c9                   	leave  
80100979:	c3                   	ret    
8010097a:	66 90                	xchg   %ax,%ax
8010097c:	66 90                	xchg   %ax,%ax
8010097e:	66 90                	xchg   %ax,%ax

80100980 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100980:	55                   	push   %ebp
80100981:	89 e5                	mov    %esp,%ebp
80100983:	57                   	push   %edi
80100984:	56                   	push   %esi
80100985:	53                   	push   %ebx
80100986:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
8010098c:	e8 ef 21 00 00       	call   80102b80 <begin_op>
  if((ip = namei(path)) == 0){
80100991:	8b 45 08             	mov    0x8(%ebp),%eax
80100994:	89 04 24             	mov    %eax,(%esp)
80100997:	e8 44 15 00 00       	call   80101ee0 <namei>
8010099c:	85 c0                	test   %eax,%eax
8010099e:	89 c3                	mov    %eax,%ebx
801009a0:	74 37                	je     801009d9 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
801009a2:	89 04 24             	mov    %eax,(%esp)
801009a5:	e8 96 0c 00 00       	call   80101640 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
801009aa:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009b0:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009b7:	00 
801009b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009bf:	00 
801009c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801009c4:	89 1c 24             	mov    %ebx,(%esp)
801009c7:	e8 74 0f 00 00       	call   80101940 <readi>
801009cc:	83 f8 33             	cmp    $0x33,%eax
801009cf:	77 1f                	ja     801009f0 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
801009d1:	89 1c 24             	mov    %ebx,(%esp)
801009d4:	e8 17 0f 00 00       	call   801018f0 <iunlockput>
    end_op();
801009d9:	e8 12 22 00 00       	call   80102bf0 <end_op>
  }
  return -1;
801009de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801009e3:	81 c4 1c 01 00 00    	add    $0x11c,%esp
801009e9:	5b                   	pop    %ebx
801009ea:	5e                   	pop    %esi
801009eb:	5f                   	pop    %edi
801009ec:	5d                   	pop    %ebp
801009ed:	c3                   	ret    
801009ee:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
801009f0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801009f7:	45 4c 46 
801009fa:	75 d5                	jne    801009d1 <exec+0x51>
    goto bad;

  if((pgdir = setupkvm()) == 0)
801009fc:	e8 5f 5e 00 00       	call   80106860 <setupkvm>
80100a01:	85 c0                	test   %eax,%eax
80100a03:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a09:	74 c6                	je     801009d1 <exec+0x51>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a0b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a12:	00 
80100a13:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a19:	0f 84 cc 02 00 00    	je     80100ceb <exec+0x36b>

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a1f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a26:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a29:	31 ff                	xor    %edi,%edi
80100a2b:	eb 18                	jmp    80100a45 <exec+0xc5>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi
80100a30:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a37:	83 c7 01             	add    $0x1,%edi
80100a3a:	83 c6 20             	add    $0x20,%esi
80100a3d:	39 f8                	cmp    %edi,%eax
80100a3f:	0f 8e be 00 00 00    	jle    80100b03 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a45:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a4b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a52:	00 
80100a53:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a57:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a5b:	89 1c 24             	mov    %ebx,(%esp)
80100a5e:	e8 dd 0e 00 00       	call   80101940 <readi>
80100a63:	83 f8 20             	cmp    $0x20,%eax
80100a66:	0f 85 84 00 00 00    	jne    80100af0 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a6c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a73:	75 bb                	jne    80100a30 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100a75:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a7b:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a81:	72 6d                	jb     80100af0 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a83:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a89:	72 65                	jb     80100af0 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80100a8f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a95:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a99:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a9f:	89 04 24             	mov    %eax,(%esp)
80100aa2:	e8 59 60 00 00       	call   80106b00 <allocuvm>
80100aa7:	85 c0                	test   %eax,%eax
80100aa9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aaf:	74 3f                	je     80100af0 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ab1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ab7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100abc:	75 32                	jne    80100af0 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100abe:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100ace:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100ad2:	89 54 24 10          	mov    %edx,0x10(%esp)
80100ad6:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100adc:	89 04 24             	mov    %eax,(%esp)
80100adf:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100ae3:	e8 58 5f 00 00       	call   80106a40 <loaduvm>
80100ae8:	85 c0                	test   %eax,%eax
80100aea:	0f 89 40 ff ff ff    	jns    80100a30 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100af0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100af6:	89 04 24             	mov    %eax,(%esp)
80100af9:	e8 12 61 00 00       	call   80106c10 <freevm>
80100afe:	e9 ce fe ff ff       	jmp    801009d1 <exec+0x51>
80100b03:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b09:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100b0f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100b15:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b1b:	89 1c 24             	mov    %ebx,(%esp)
80100b1e:	e8 cd 0d 00 00       	call   801018f0 <iunlockput>
  end_op();
80100b23:	e8 c8 20 00 00       	call   80102bf0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b28:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
80100b32:	89 74 24 04          	mov    %esi,0x4(%esp)
80100b36:	89 04 24             	mov    %eax,(%esp)
80100b39:	e8 c2 5f 00 00       	call   80106b00 <allocuvm>
80100b3e:	85 c0                	test   %eax,%eax
80100b40:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b46:	75 18                	jne    80100b60 <exec+0x1e0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b48:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b4e:	89 04 24             	mov    %eax,(%esp)
80100b51:	e8 ba 60 00 00       	call   80106c10 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b5b:	e9 83 fe ff ff       	jmp    801009e3 <exec+0x63>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b60:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100b66:	89 d8                	mov    %ebx,%eax
80100b68:	2d 00 20 00 00       	sub    $0x2000,%eax
80100b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b71:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b77:	89 04 24             	mov    %eax,(%esp)
80100b7a:	e8 11 61 00 00       	call   80106c90 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b82:	8b 00                	mov    (%eax),%eax
80100b84:	85 c0                	test   %eax,%eax
80100b86:	0f 84 6b 01 00 00    	je     80100cf7 <exec+0x377>
80100b8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b8f:	31 f6                	xor    %esi,%esi
80100b91:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100b94:	83 c1 04             	add    $0x4,%ecx
80100b97:	eb 0f                	jmp    80100ba8 <exec+0x228>
80100b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ba0:	83 c1 04             	add    $0x4,%ecx
    if(argc >= MAXARG)
80100ba3:	83 fe 20             	cmp    $0x20,%esi
80100ba6:	74 a0                	je     80100b48 <exec+0x1c8>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ba8:	89 04 24             	mov    %eax,(%esp)
80100bab:	89 8d f0 fe ff ff    	mov    %ecx,-0x110(%ebp)
80100bb1:	e8 6a 3a 00 00       	call   80104620 <strlen>
80100bb6:	f7 d0                	not    %eax
80100bb8:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bba:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bbc:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bbf:	89 04 24             	mov    %eax,(%esp)
80100bc2:	e8 59 3a 00 00       	call   80104620 <strlen>
80100bc7:	83 c0 01             	add    $0x1,%eax
80100bca:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bce:	8b 07                	mov    (%edi),%eax
80100bd0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100bd4:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bd8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bde:	89 04 24             	mov    %eax,(%esp)
80100be1:	e8 0a 62 00 00       	call   80106df0 <copyout>
80100be6:	85 c0                	test   %eax,%eax
80100be8:	0f 88 5a ff ff ff    	js     80100b48 <exec+0x1c8>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bee:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bf4:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bfa:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c01:	83 c6 01             	add    $0x1,%esi
80100c04:	8b 01                	mov    (%ecx),%eax
80100c06:	89 cf                	mov    %ecx,%edi
80100c08:	85 c0                	test   %eax,%eax
80100c0a:	75 94                	jne    80100ba0 <exec+0x220>
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c0c:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c13:	89 d9                	mov    %ebx,%ecx
80100c15:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c17:	83 c0 0c             	add    $0xc,%eax
80100c1a:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c1c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c26:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c2e:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c35:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c39:	89 04 24             	mov    %eax,(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c3c:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c43:	ff ff ff 
  ustack[1] = argc;
80100c46:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c4c:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c52:	e8 99 61 00 00       	call   80106df0 <copyout>
80100c57:	85 c0                	test   %eax,%eax
80100c59:	0f 88 e9 fe ff ff    	js     80100b48 <exec+0x1c8>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80100c62:	0f b6 10             	movzbl (%eax),%edx
80100c65:	84 d2                	test   %dl,%dl
80100c67:	74 19                	je     80100c82 <exec+0x302>
80100c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c6c:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100c6f:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c72:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100c75:	0f 44 c8             	cmove  %eax,%ecx
80100c78:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c7b:	84 d2                	test   %dl,%dl
80100c7d:	75 f0                	jne    80100c6f <exec+0x2ef>
80100c7f:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100c82:	8b 45 08             	mov    0x8(%ebp),%eax
80100c85:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100c8c:	00 
80100c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c97:	83 c0 6c             	add    $0x6c,%eax
80100c9a:	89 04 24             	mov    %eax,(%esp)
80100c9d:	e8 3e 39 00 00       	call   801045e0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ca2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ca8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cae:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100cb1:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
80100cb4:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cba:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100cbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cc2:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cc8:	8b 50 18             	mov    0x18(%eax),%edx
80100ccb:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100cce:	8b 50 18             	mov    0x18(%eax),%edx
80100cd1:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100cd4:	89 04 24             	mov    %eax,(%esp)
80100cd7:	e8 44 5c 00 00       	call   80106920 <switchuvm>
  freevm(oldpgdir);
80100cdc:	89 34 24             	mov    %esi,(%esp)
80100cdf:	e8 2c 5f 00 00       	call   80106c10 <freevm>
  return 0;
80100ce4:	31 c0                	xor    %eax,%eax
80100ce6:	e9 f8 fc ff ff       	jmp    801009e3 <exec+0x63>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ceb:	bf 00 20 00 00       	mov    $0x2000,%edi
80100cf0:	31 f6                	xor    %esi,%esi
80100cf2:	e9 24 fe ff ff       	jmp    80100b1b <exec+0x19b>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf7:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100cfd:	31 f6                	xor    %esi,%esi
80100cff:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d05:	e9 02 ff ff ff       	jmp    80100c0c <exec+0x28c>
80100d0a:	66 90                	xchg   %ax,%ax
80100d0c:	66 90                	xchg   %ax,%ax
80100d0e:	66 90                	xchg   %ax,%ax

80100d10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d10:	55                   	push   %ebp
80100d11:	89 e5                	mov    %esp,%ebp
80100d13:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d16:	c7 44 24 04 02 6f 10 	movl   $0x80106f02,0x4(%esp)
80100d1d:	80 
80100d1e:	c7 04 24 a0 f7 10 80 	movl   $0x8010f7a0,(%esp)
80100d25:	e8 d6 34 00 00       	call   80104200 <initlock>
}
80100d2a:	c9                   	leave  
80100d2b:	c3                   	ret    
80100d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d34:	bb d4 f7 10 80       	mov    $0x8010f7d4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d39:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d3c:	c7 04 24 a0 f7 10 80 	movl   $0x8010f7a0,(%esp)
80100d43:	e8 38 35 00 00       	call   80104280 <acquire>
80100d48:	eb 11                	jmp    80100d5b <filealloc+0x2b>
80100d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d50:	83 c3 18             	add    $0x18,%ebx
80100d53:	81 fb 34 01 11 80    	cmp    $0x80110134,%ebx
80100d59:	74 25                	je     80100d80 <filealloc+0x50>
    if(f->ref == 0){
80100d5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d5e:	85 c0                	test   %eax,%eax
80100d60:	75 ee                	jne    80100d50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d62:	c7 04 24 a0 f7 10 80 	movl   $0x8010f7a0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d69:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d70:	e8 3b 36 00 00       	call   801043b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d75:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100d78:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d7a:	5b                   	pop    %ebx
80100d7b:	5d                   	pop    %ebp
80100d7c:	c3                   	ret    
80100d7d:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100d80:	c7 04 24 a0 f7 10 80 	movl   $0x8010f7a0,(%esp)
80100d87:	e8 24 36 00 00       	call   801043b0 <release>
  return 0;
}
80100d8c:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100d8f:	31 c0                	xor    %eax,%eax
}
80100d91:	5b                   	pop    %ebx
80100d92:	5d                   	pop    %ebp
80100d93:	c3                   	ret    
80100d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100da0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
80100da4:	83 ec 14             	sub    $0x14,%esp
80100da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100daa:	c7 04 24 a0 f7 10 80 	movl   $0x8010f7a0,(%esp)
80100db1:	e8 ca 34 00 00       	call   80104280 <acquire>
  if(f->ref < 1)
80100db6:	8b 43 04             	mov    0x4(%ebx),%eax
80100db9:	85 c0                	test   %eax,%eax
80100dbb:	7e 1a                	jle    80100dd7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dbd:	83 c0 01             	add    $0x1,%eax
80100dc0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100dc3:	c7 04 24 a0 f7 10 80 	movl   $0x8010f7a0,(%esp)
80100dca:	e8 e1 35 00 00       	call   801043b0 <release>
  return f;
}
80100dcf:	83 c4 14             	add    $0x14,%esp
80100dd2:	89 d8                	mov    %ebx,%eax
80100dd4:	5b                   	pop    %ebx
80100dd5:	5d                   	pop    %ebp
80100dd6:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100dd7:	c7 04 24 09 6f 10 80 	movl   $0x80106f09,(%esp)
80100dde:	e8 4d f5 ff ff       	call   80100330 <panic>
80100de3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100df0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	57                   	push   %edi
80100df4:	56                   	push   %esi
80100df5:	53                   	push   %ebx
80100df6:	83 ec 1c             	sub    $0x1c,%esp
80100df9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100dfc:	c7 04 24 a0 f7 10 80 	movl   $0x8010f7a0,(%esp)
80100e03:	e8 78 34 00 00       	call   80104280 <acquire>
  if(f->ref < 1)
80100e08:	8b 57 04             	mov    0x4(%edi),%edx
80100e0b:	85 d2                	test   %edx,%edx
80100e0d:	0f 8e 89 00 00 00    	jle    80100e9c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e13:	83 ea 01             	sub    $0x1,%edx
80100e16:	85 d2                	test   %edx,%edx
80100e18:	89 57 04             	mov    %edx,0x4(%edi)
80100e1b:	74 13                	je     80100e30 <fileclose+0x40>
    release(&ftable.lock);
80100e1d:	c7 45 08 a0 f7 10 80 	movl   $0x8010f7a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e24:	83 c4 1c             	add    $0x1c,%esp
80100e27:	5b                   	pop    %ebx
80100e28:	5e                   	pop    %esi
80100e29:	5f                   	pop    %edi
80100e2a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e2b:	e9 80 35 00 00       	jmp    801043b0 <release>
    return;
  }
  ff = *f;
80100e30:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e34:	8b 37                	mov    (%edi),%esi
80100e36:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e39:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e3f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e42:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e45:	c7 04 24 a0 f7 10 80 	movl   $0x8010f7a0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e4f:	e8 5c 35 00 00       	call   801043b0 <release>

  if(ff.type == FD_PIPE)
80100e54:	83 fe 01             	cmp    $0x1,%esi
80100e57:	74 0f                	je     80100e68 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e59:	83 fe 02             	cmp    $0x2,%esi
80100e5c:	74 22                	je     80100e80 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e5e:	83 c4 1c             	add    $0x1c,%esp
80100e61:	5b                   	pop    %ebx
80100e62:	5e                   	pop    %esi
80100e63:	5f                   	pop    %edi
80100e64:	5d                   	pop    %ebp
80100e65:	c3                   	ret    
80100e66:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e68:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e6c:	89 1c 24             	mov    %ebx,(%esp)
80100e6f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e73:	e8 28 25 00 00       	call   801033a0 <pipeclose>
80100e78:	eb e4                	jmp    80100e5e <fileclose+0x6e>
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100e80:	e8 fb 1c 00 00       	call   80102b80 <begin_op>
    iput(ff.ip);
80100e85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e88:	89 04 24             	mov    %eax,(%esp)
80100e8b:	e8 10 09 00 00       	call   801017a0 <iput>
    end_op();
  }
}
80100e90:	83 c4 1c             	add    $0x1c,%esp
80100e93:	5b                   	pop    %ebx
80100e94:	5e                   	pop    %esi
80100e95:	5f                   	pop    %edi
80100e96:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100e97:	e9 54 1d 00 00       	jmp    80102bf0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100e9c:	c7 04 24 11 6f 10 80 	movl   $0x80106f11,(%esp)
80100ea3:	e8 88 f4 ff ff       	call   80100330 <panic>
80100ea8:	90                   	nop
80100ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100eb0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 14             	sub    $0x14,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eba:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ebd:	75 31                	jne    80100ef0 <filestat+0x40>
    ilock(f->ip);
80100ebf:	8b 43 10             	mov    0x10(%ebx),%eax
80100ec2:	89 04 24             	mov    %eax,(%esp)
80100ec5:	e8 76 07 00 00       	call   80101640 <ilock>
    stati(f->ip, st);
80100eca:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ed1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ed4:	89 04 24             	mov    %eax,(%esp)
80100ed7:	e8 34 0a 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100edc:	8b 43 10             	mov    0x10(%ebx),%eax
80100edf:	89 04 24             	mov    %eax,(%esp)
80100ee2:	e8 69 08 00 00       	call   80101750 <iunlock>
    return 0;
  }
  return -1;
}
80100ee7:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100eea:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100eec:	5b                   	pop    %ebx
80100eed:	5d                   	pop    %ebp
80100eee:	c3                   	ret    
80100eef:	90                   	nop
80100ef0:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100ef3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ef8:	5b                   	pop    %ebx
80100ef9:	5d                   	pop    %ebp
80100efa:	c3                   	ret    
80100efb:	90                   	nop
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 1c             	sub    $0x1c,%esp
80100f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f12:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f16:	74 68                	je     80100f80 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f18:	8b 03                	mov    (%ebx),%eax
80100f1a:	83 f8 01             	cmp    $0x1,%eax
80100f1d:	74 49                	je     80100f68 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f1f:	83 f8 02             	cmp    $0x2,%eax
80100f22:	75 63                	jne    80100f87 <fileread+0x87>
    ilock(f->ip);
80100f24:	8b 43 10             	mov    0x10(%ebx),%eax
80100f27:	89 04 24             	mov    %eax,(%esp)
80100f2a:	e8 11 07 00 00       	call   80101640 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f2f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f33:	8b 43 14             	mov    0x14(%ebx),%eax
80100f36:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f3a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f3e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f41:	89 04 24             	mov    %eax,(%esp)
80100f44:	e8 f7 09 00 00       	call   80101940 <readi>
80100f49:	85 c0                	test   %eax,%eax
80100f4b:	89 c6                	mov    %eax,%esi
80100f4d:	7e 03                	jle    80100f52 <fileread+0x52>
      f->off += r;
80100f4f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f52:	8b 43 10             	mov    0x10(%ebx),%eax
80100f55:	89 04 24             	mov    %eax,(%esp)
80100f58:	e8 f3 07 00 00       	call   80101750 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f5f:	83 c4 1c             	add    $0x1c,%esp
80100f62:	5b                   	pop    %ebx
80100f63:	5e                   	pop    %esi
80100f64:	5f                   	pop    %edi
80100f65:	5d                   	pop    %ebp
80100f66:	c3                   	ret    
80100f67:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f68:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f6b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f6e:	83 c4 1c             	add    $0x1c,%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f75:	e9 d6 25 00 00       	jmp    80103550 <piperead>
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f85:	eb d8                	jmp    80100f5f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100f87:	c7 04 24 1b 6f 10 80 	movl   $0x80106f1b,(%esp)
80100f8e:	e8 9d f3 ff ff       	call   80100330 <panic>
80100f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fa0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	57                   	push   %edi
80100fa4:	56                   	push   %esi
80100fa5:	53                   	push   %ebx
80100fa6:	83 ec 2c             	sub    $0x2c,%esp
80100fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fac:	8b 7d 08             	mov    0x8(%ebp),%edi
80100faf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fb5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fbc:	0f 84 ae 00 00 00    	je     80101070 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100fc2:	8b 07                	mov    (%edi),%eax
80100fc4:	83 f8 01             	cmp    $0x1,%eax
80100fc7:	0f 84 c2 00 00 00    	je     8010108f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fcd:	83 f8 02             	cmp    $0x2,%eax
80100fd0:	0f 85 d7 00 00 00    	jne    801010ad <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100fd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fd9:	31 db                	xor    %ebx,%ebx
80100fdb:	85 c0                	test   %eax,%eax
80100fdd:	7f 31                	jg     80101010 <filewrite+0x70>
80100fdf:	e9 9c 00 00 00       	jmp    80101080 <filewrite+0xe0>
80100fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100fe8:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100feb:	01 47 14             	add    %eax,0x14(%edi)
80100fee:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80100ff1:	89 0c 24             	mov    %ecx,(%esp)
80100ff4:	e8 57 07 00 00       	call   80101750 <iunlock>
      end_op();
80100ff9:	e8 f2 1b 00 00       	call   80102bf0 <end_op>
80100ffe:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101001:	39 f0                	cmp    %esi,%eax
80101003:	0f 85 98 00 00 00    	jne    801010a1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101009:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010100b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010100e:	7e 70                	jle    80101080 <filewrite+0xe0>
      int n1 = n - i;
80101010:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101013:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101018:	29 de                	sub    %ebx,%esi
8010101a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101020:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101023:	e8 58 1b 00 00       	call   80102b80 <begin_op>
      ilock(f->ip);
80101028:	8b 47 10             	mov    0x10(%edi),%eax
8010102b:	89 04 24             	mov    %eax,(%esp)
8010102e:	e8 0d 06 00 00       	call   80101640 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101033:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101037:	8b 47 14             	mov    0x14(%edi),%eax
8010103a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010103e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101041:	01 d8                	add    %ebx,%eax
80101043:	89 44 24 04          	mov    %eax,0x4(%esp)
80101047:	8b 47 10             	mov    0x10(%edi),%eax
8010104a:	89 04 24             	mov    %eax,(%esp)
8010104d:	e8 ee 09 00 00       	call   80101a40 <writei>
80101052:	85 c0                	test   %eax,%eax
80101054:	7f 92                	jg     80100fe8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101056:	8b 4f 10             	mov    0x10(%edi),%ecx
80101059:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010105c:	89 0c 24             	mov    %ecx,(%esp)
8010105f:	e8 ec 06 00 00       	call   80101750 <iunlock>
      end_op();
80101064:	e8 87 1b 00 00       	call   80102bf0 <end_op>

      if(r < 0)
80101069:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010106c:	85 c0                	test   %eax,%eax
8010106e:	74 91                	je     80101001 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101070:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
80101073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101078:	5b                   	pop    %ebx
80101079:	5e                   	pop    %esi
8010107a:	5f                   	pop    %edi
8010107b:	5d                   	pop    %ebp
8010107c:	c3                   	ret    
8010107d:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101080:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101083:	89 d8                	mov    %ebx,%eax
80101085:	75 e9                	jne    80101070 <filewrite+0xd0>
  }
  panic("filewrite");
}
80101087:	83 c4 2c             	add    $0x2c,%esp
8010108a:	5b                   	pop    %ebx
8010108b:	5e                   	pop    %esi
8010108c:	5f                   	pop    %edi
8010108d:	5d                   	pop    %ebp
8010108e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010108f:	8b 47 0c             	mov    0xc(%edi),%eax
80101092:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101095:	83 c4 2c             	add    $0x2c,%esp
80101098:	5b                   	pop    %ebx
80101099:	5e                   	pop    %esi
8010109a:	5f                   	pop    %edi
8010109b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010109c:	e9 8f 23 00 00       	jmp    80103430 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010a1:	c7 04 24 24 6f 10 80 	movl   $0x80106f24,(%esp)
801010a8:	e8 83 f2 ff ff       	call   80100330 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ad:	c7 04 24 2a 6f 10 80 	movl   $0x80106f2a,(%esp)
801010b4:	e8 77 f2 ff ff       	call   80100330 <panic>
801010b9:	66 90                	xchg   %ax,%ax
801010bb:	66 90                	xchg   %ax,%ax
801010bd:	66 90                	xchg   %ax,%ax
801010bf:	90                   	nop

801010c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 2c             	sub    $0x2c,%esp
801010c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010cc:	a1 a0 01 11 80       	mov    0x801101a0,%eax
801010d1:	85 c0                	test   %eax,%eax
801010d3:	0f 84 8c 00 00 00    	je     80101165 <balloc+0xa5>
801010d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801010e0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801010e3:	89 f0                	mov    %esi,%eax
801010e5:	c1 f8 0c             	sar    $0xc,%eax
801010e8:	03 05 b8 01 11 80    	add    0x801101b8,%eax
801010ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801010f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010f5:	89 04 24             	mov    %eax,(%esp)
801010f8:	e8 c3 ef ff ff       	call   801000c0 <bread>
801010fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101100:	a1 a0 01 11 80       	mov    0x801101a0,%eax
80101105:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101108:	31 c0                	xor    %eax,%eax
8010110a:	eb 33                	jmp    8010113f <balloc+0x7f>
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101110:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101113:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101115:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101117:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010111a:	83 e1 07             	and    $0x7,%ecx
8010111d:	bf 01 00 00 00       	mov    $0x1,%edi
80101122:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101124:	0f b6 5c 13 18       	movzbl 0x18(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101129:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010112b:	0f b6 fb             	movzbl %bl,%edi
8010112e:	85 cf                	test   %ecx,%edi
80101130:	74 46                	je     80101178 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101132:	83 c0 01             	add    $0x1,%eax
80101135:	83 c6 01             	add    $0x1,%esi
80101138:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010113d:	74 05                	je     80101144 <balloc+0x84>
8010113f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101142:	72 cc                	jb     80101110 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101147:	89 04 24             	mov    %eax,(%esp)
8010114a:	e8 71 f0 ff ff       	call   801001c0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010114f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101156:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101159:	3b 05 a0 01 11 80    	cmp    0x801101a0,%eax
8010115f:	0f 82 7b ff ff ff    	jb     801010e0 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101165:	c7 04 24 34 6f 10 80 	movl   $0x80106f34,(%esp)
8010116c:	e8 bf f1 ff ff       	call   80100330 <panic>
80101171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101178:	09 d9                	or     %ebx,%ecx
8010117a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010117d:	88 4c 13 18          	mov    %cl,0x18(%ebx,%edx,1)
        log_write(bp);
80101181:	89 1c 24             	mov    %ebx,(%esp)
80101184:	e8 97 1b 00 00       	call   80102d20 <log_write>
        brelse(bp);
80101189:	89 1c 24             	mov    %ebx,(%esp)
8010118c:	e8 2f f0 ff ff       	call   801001c0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101191:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101194:	89 74 24 04          	mov    %esi,0x4(%esp)
80101198:	89 04 24             	mov    %eax,(%esp)
8010119b:	e8 20 ef ff ff       	call   801000c0 <bread>
  memset(bp->data, 0, BSIZE);
801011a0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011a7:	00 
801011a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011af:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011b0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011b2:	8d 40 18             	lea    0x18(%eax),%eax
801011b5:	89 04 24             	mov    %eax,(%esp)
801011b8:	e8 43 32 00 00       	call   80104400 <memset>
  log_write(bp);
801011bd:	89 1c 24             	mov    %ebx,(%esp)
801011c0:	e8 5b 1b 00 00       	call   80102d20 <log_write>
  brelse(bp);
801011c5:	89 1c 24             	mov    %ebx,(%esp)
801011c8:	e8 f3 ef ff ff       	call   801001c0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011cd:	83 c4 2c             	add    $0x2c,%esp
801011d0:	89 f0                	mov    %esi,%eax
801011d2:	5b                   	pop    %ebx
801011d3:	5e                   	pop    %esi
801011d4:	5f                   	pop    %edi
801011d5:	5d                   	pop    %ebp
801011d6:	c3                   	ret    
801011d7:	89 f6                	mov    %esi,%esi
801011d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	89 c7                	mov    %eax,%edi
801011e6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011e7:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011e9:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011ea:	bb f4 01 11 80       	mov    $0x801101f4,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011ef:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011f2:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011fc:	e8 7f 30 00 00       	call   80104280 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101201:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101204:	eb 11                	jmp    80101217 <iget+0x37>
80101206:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101208:	85 f6                	test   %esi,%esi
8010120a:	74 3c                	je     80101248 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120c:	83 c3 50             	add    $0x50,%ebx
8010120f:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
80101215:	74 41                	je     80101258 <iget+0x78>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101217:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010121a:	85 c9                	test   %ecx,%ecx
8010121c:	7e ea                	jle    80101208 <iget+0x28>
8010121e:	39 3b                	cmp    %edi,(%ebx)
80101220:	75 e6                	jne    80101208 <iget+0x28>
80101222:	39 53 04             	cmp    %edx,0x4(%ebx)
80101225:	75 e1                	jne    80101208 <iget+0x28>
      ip->ref++;
80101227:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010122a:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010122c:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101233:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101236:	e8 75 31 00 00       	call   801043b0 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010123b:	83 c4 1c             	add    $0x1c,%esp
8010123e:	89 f0                	mov    %esi,%eax
80101240:	5b                   	pop    %ebx
80101241:	5e                   	pop    %esi
80101242:	5f                   	pop    %edi
80101243:	5d                   	pop    %ebp
80101244:	c3                   	ret    
80101245:	8d 76 00             	lea    0x0(%esi),%esi
80101248:	85 c9                	test   %ecx,%ecx
8010124a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124d:	83 c3 50             	add    $0x50,%ebx
80101250:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
80101256:	75 bf                	jne    80101217 <iget+0x37>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101258:	85 f6                	test   %esi,%esi
8010125a:	74 29                	je     80101285 <iget+0xa5>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
8010125c:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010125e:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101261:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101268:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
8010126f:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101276:	e8 35 31 00 00       	call   801043b0 <release>

  return ip;
}
8010127b:	83 c4 1c             	add    $0x1c,%esp
8010127e:	89 f0                	mov    %esi,%eax
80101280:	5b                   	pop    %ebx
80101281:	5e                   	pop    %esi
80101282:	5f                   	pop    %edi
80101283:	5d                   	pop    %ebp
80101284:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101285:	c7 04 24 4a 6f 10 80 	movl   $0x80106f4a,(%esp)
8010128c:	e8 9f f0 ff ff       	call   80100330 <panic>
80101291:	eb 0d                	jmp    801012a0 <bmap>
80101293:	90                   	nop
80101294:	90                   	nop
80101295:	90                   	nop
80101296:	90                   	nop
80101297:	90                   	nop
80101298:	90                   	nop
80101299:	90                   	nop
8010129a:	90                   	nop
8010129b:	90                   	nop
8010129c:	90                   	nop
8010129d:	90                   	nop
8010129e:	90                   	nop
8010129f:	90                   	nop

801012a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	89 c3                	mov    %eax,%ebx
801012a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012ab:	83 fa 0b             	cmp    $0xb,%edx
801012ae:	77 18                	ja     801012c8 <bmap+0x28>
801012b0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012b3:	8b 46 1c             	mov    0x1c(%esi),%eax
801012b6:	85 c0                	test   %eax,%eax
801012b8:	74 66                	je     80101320 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ba:	83 c4 1c             	add    $0x1c,%esp
801012bd:	5b                   	pop    %ebx
801012be:	5e                   	pop    %esi
801012bf:	5f                   	pop    %edi
801012c0:	5d                   	pop    %ebp
801012c1:	c3                   	ret    
801012c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012c8:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801012cb:	83 fe 7f             	cmp    $0x7f,%esi
801012ce:	77 74                	ja     80101344 <bmap+0xa4>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012d0:	8b 40 4c             	mov    0x4c(%eax),%eax
801012d3:	85 c0                	test   %eax,%eax
801012d5:	74 61                	je     80101338 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801012db:	8b 03                	mov    (%ebx),%eax
801012dd:	89 04 24             	mov    %eax,(%esp)
801012e0:	e8 db ed ff ff       	call   801000c0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801012e5:	8d 54 b0 18          	lea    0x18(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012e9:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801012eb:	8b 32                	mov    (%edx),%esi
801012ed:	85 f6                	test   %esi,%esi
801012ef:	75 19                	jne    8010130a <bmap+0x6a>
      a[bn] = addr = balloc(ip->dev);
801012f1:	8b 03                	mov    (%ebx),%eax
801012f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801012f6:	e8 c5 fd ff ff       	call   801010c0 <balloc>
801012fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012fe:	89 02                	mov    %eax,(%edx)
80101300:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 16 1a 00 00       	call   80102d20 <log_write>
    }
    brelse(bp);
8010130a:	89 3c 24             	mov    %edi,(%esp)
8010130d:	e8 ae ee ff ff       	call   801001c0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101312:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101315:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret    
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101320:	8b 03                	mov    (%ebx),%eax
80101322:	e8 99 fd ff ff       	call   801010c0 <balloc>
80101327:	89 46 1c             	mov    %eax,0x1c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010132a:	83 c4 1c             	add    $0x1c,%esp
8010132d:	5b                   	pop    %ebx
8010132e:	5e                   	pop    %esi
8010132f:	5f                   	pop    %edi
80101330:	5d                   	pop    %ebp
80101331:	c3                   	ret    
80101332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101338:	8b 03                	mov    (%ebx),%eax
8010133a:	e8 81 fd ff ff       	call   801010c0 <balloc>
8010133f:	89 43 4c             	mov    %eax,0x4c(%ebx)
80101342:	eb 93                	jmp    801012d7 <bmap+0x37>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101344:	c7 04 24 5a 6f 10 80 	movl   $0x80106f5a,(%esp)
8010134b:	e8 e0 ef ff ff       	call   80100330 <panic>

80101350 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	56                   	push   %esi
80101354:	53                   	push   %ebx
80101355:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101358:	8b 45 08             	mov    0x8(%ebp),%eax
8010135b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101362:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101363:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101366:	89 04 24             	mov    %eax,(%esp)
80101369:	e8 52 ed ff ff       	call   801000c0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010136e:	89 34 24             	mov    %esi,(%esp)
80101371:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101378:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
80101379:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010137b:	8d 40 18             	lea    0x18(%eax),%eax
8010137e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101382:	e8 19 31 00 00       	call   801044a0 <memmove>
  brelse(bp);
80101387:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010138a:	83 c4 10             	add    $0x10,%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101390:	e9 2b ee ff ff       	jmp    801001c0 <brelse>
80101395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	89 d7                	mov    %edx,%edi
801013a6:	56                   	push   %esi
801013a7:	53                   	push   %ebx
801013a8:	89 c3                	mov    %eax,%ebx
801013aa:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013ad:	89 04 24             	mov    %eax,(%esp)
801013b0:	c7 44 24 04 a0 01 11 	movl   $0x801101a0,0x4(%esp)
801013b7:	80 
801013b8:	e8 93 ff ff ff       	call   80101350 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013bd:	89 fa                	mov    %edi,%edx
801013bf:	c1 ea 0c             	shr    $0xc,%edx
801013c2:	03 15 b8 01 11 80    	add    0x801101b8,%edx
801013c8:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
801013cb:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801013d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801013d4:	e8 e7 ec ff ff       	call   801000c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013d9:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
801013db:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
801013e1:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
801013e3:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801013e6:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801013e9:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
801013eb:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
801013ed:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801013f2:	0f b6 c8             	movzbl %al,%ecx
801013f5:	85 d9                	test   %ebx,%ecx
801013f7:	74 20                	je     80101419 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013f9:	f7 d3                	not    %ebx
801013fb:	21 c3                	and    %eax,%ebx
801013fd:	88 5c 16 18          	mov    %bl,0x18(%esi,%edx,1)
  log_write(bp);
80101401:	89 34 24             	mov    %esi,(%esp)
80101404:	e8 17 19 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101409:	89 34 24             	mov    %esi,(%esp)
8010140c:	e8 af ed ff ff       	call   801001c0 <brelse>
}
80101411:	83 c4 1c             	add    $0x1c,%esp
80101414:	5b                   	pop    %ebx
80101415:	5e                   	pop    %esi
80101416:	5f                   	pop    %edi
80101417:	5d                   	pop    %ebp
80101418:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101419:	c7 04 24 6d 6f 10 80 	movl   $0x80106f6d,(%esp)
80101420:	e8 0b ef ff ff       	call   80100330 <panic>
80101425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	83 ec 28             	sub    $0x28,%esp
  initlock(&icache.lock, "icache");
80101436:	c7 44 24 04 80 6f 10 	movl   $0x80106f80,0x4(%esp)
8010143d:	80 
8010143e:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101445:	e8 b6 2d 00 00       	call   80104200 <initlock>
  readsb(dev, &sb);
8010144a:	8b 45 08             	mov    0x8(%ebp),%eax
8010144d:	c7 44 24 04 a0 01 11 	movl   $0x801101a0,0x4(%esp)
80101454:	80 
80101455:	89 04 24             	mov    %eax,(%esp)
80101458:	e8 f3 fe ff ff       	call   80101350 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010145d:	a1 b8 01 11 80       	mov    0x801101b8,%eax
80101462:	c7 04 24 e0 6f 10 80 	movl   $0x80106fe0,(%esp)
80101469:	89 44 24 1c          	mov    %eax,0x1c(%esp)
8010146d:	a1 b4 01 11 80       	mov    0x801101b4,%eax
80101472:	89 44 24 18          	mov    %eax,0x18(%esp)
80101476:	a1 b0 01 11 80       	mov    0x801101b0,%eax
8010147b:	89 44 24 14          	mov    %eax,0x14(%esp)
8010147f:	a1 ac 01 11 80       	mov    0x801101ac,%eax
80101484:	89 44 24 10          	mov    %eax,0x10(%esp)
80101488:	a1 a8 01 11 80       	mov    0x801101a8,%eax
8010148d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101491:	a1 a4 01 11 80       	mov    0x801101a4,%eax
80101496:	89 44 24 08          	mov    %eax,0x8(%esp)
8010149a:	a1 a0 01 11 80       	mov    0x801101a0,%eax
8010149f:	89 44 24 04          	mov    %eax,0x4(%esp)
801014a3:	e8 78 f1 ff ff       	call   80100620 <cprintf>
          inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014a8:	c9                   	leave  
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014b0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	53                   	push   %ebx
801014b6:	83 ec 2c             	sub    $0x2c,%esp
801014b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014bc:	83 3d a8 01 11 80 01 	cmpl   $0x1,0x801101a8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014c3:	8b 7d 08             	mov    0x8(%ebp),%edi
801014c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014c9:	0f 86 a2 00 00 00    	jbe    80101571 <ialloc+0xc1>
801014cf:	be 01 00 00 00       	mov    $0x1,%esi
801014d4:	bb 01 00 00 00       	mov    $0x1,%ebx
801014d9:	eb 1a                	jmp    801014f5 <ialloc+0x45>
801014db:	90                   	nop
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014e0:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014e3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014e6:	e8 d5 ec ff ff       	call   801001c0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014eb:	89 de                	mov    %ebx,%esi
801014ed:	3b 1d a8 01 11 80    	cmp    0x801101a8,%ebx
801014f3:	73 7c                	jae    80101571 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
801014f5:	89 f0                	mov    %esi,%eax
801014f7:	c1 e8 03             	shr    $0x3,%eax
801014fa:	03 05 b4 01 11 80    	add    0x801101b4,%eax
80101500:	89 3c 24             	mov    %edi,(%esp)
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 b4 eb ff ff       	call   801000c0 <bread>
8010150c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010150e:	89 f0                	mov    %esi,%eax
80101510:	83 e0 07             	and    $0x7,%eax
80101513:	c1 e0 06             	shl    $0x6,%eax
80101516:	8d 4c 02 18          	lea    0x18(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010151a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010151e:	75 c0                	jne    801014e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101520:	89 0c 24             	mov    %ecx,(%esp)
80101523:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010152a:	00 
8010152b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101532:	00 
80101533:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101536:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101539:	e8 c2 2e 00 00       	call   80104400 <memset>
      dip->type = type;
8010153e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101542:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
80101545:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101548:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
8010154b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010154e:	89 14 24             	mov    %edx,(%esp)
80101551:	e8 ca 17 00 00       	call   80102d20 <log_write>
      brelse(bp);
80101556:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101559:	89 14 24             	mov    %edx,(%esp)
8010155c:	e8 5f ec ff ff       	call   801001c0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101561:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101564:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101566:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101567:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101569:	5e                   	pop    %esi
8010156a:	5f                   	pop    %edi
8010156b:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010156c:	e9 6f fc ff ff       	jmp    801011e0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101571:	c7 04 24 87 6f 10 80 	movl   $0x80106f87,(%esp)
80101578:	e8 b3 ed ff ff       	call   80100330 <panic>
8010157d:	8d 76 00             	lea    0x0(%esi),%esi

80101580 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	56                   	push   %esi
80101584:	53                   	push   %ebx
80101585:	83 ec 10             	sub    $0x10,%esp
80101588:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010158b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010158e:	83 c3 1c             	add    $0x1c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101591:	c1 e8 03             	shr    $0x3,%eax
80101594:	03 05 b4 01 11 80    	add    0x801101b4,%eax
8010159a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010159e:	8b 43 e4             	mov    -0x1c(%ebx),%eax
801015a1:	89 04 24             	mov    %eax,(%esp)
801015a4:	e8 17 eb ff ff       	call   801000c0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015a9:	8b 53 e8             	mov    -0x18(%ebx),%edx
801015ac:	83 e2 07             	and    $0x7,%edx
801015af:	c1 e2 06             	shl    $0x6,%edx
801015b2:	8d 54 10 18          	lea    0x18(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b6:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
801015b8:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015bc:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
801015bf:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
801015c3:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
801015c7:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
801015cb:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
801015cf:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
801015d3:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
801015d7:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
801015db:	8b 43 fc             	mov    -0x4(%ebx),%eax
801015de:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015e1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801015e5:	89 14 24             	mov    %edx,(%esp)
801015e8:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801015ef:	00 
801015f0:	e8 ab 2e 00 00       	call   801044a0 <memmove>
  log_write(bp);
801015f5:	89 34 24             	mov    %esi,(%esp)
801015f8:	e8 23 17 00 00       	call   80102d20 <log_write>
  brelse(bp);
801015fd:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101600:	83 c4 10             	add    $0x10,%esp
80101603:	5b                   	pop    %ebx
80101604:	5e                   	pop    %esi
80101605:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101606:	e9 b5 eb ff ff       	jmp    801001c0 <brelse>
8010160b:	90                   	nop
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	53                   	push   %ebx
80101614:	83 ec 14             	sub    $0x14,%esp
80101617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010161a:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101621:	e8 5a 2c 00 00       	call   80104280 <acquire>
  ip->ref++;
80101626:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010162a:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101631:	e8 7a 2d 00 00       	call   801043b0 <release>
  return ip;
}
80101636:	83 c4 14             	add    $0x14,%esp
80101639:	89 d8                	mov    %ebx,%eax
8010163b:	5b                   	pop    %ebx
8010163c:	5d                   	pop    %ebp
8010163d:	c3                   	ret    
8010163e:	66 90                	xchg   %ax,%ax

80101640 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	83 ec 10             	sub    $0x10,%esp
80101648:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010164b:	85 db                	test   %ebx,%ebx
8010164d:	0f 84 ed 00 00 00    	je     80101740 <ilock+0x100>
80101653:	8b 43 08             	mov    0x8(%ebx),%eax
80101656:	85 c0                	test   %eax,%eax
80101658:	0f 8e e2 00 00 00    	jle    80101740 <ilock+0x100>
    panic("ilock");

  acquire(&icache.lock);
8010165e:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101665:	e8 16 2c 00 00       	call   80104280 <acquire>
  while(ip->flags & I_BUSY)
8010166a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010166d:	a8 01                	test   $0x1,%al
8010166f:	74 1e                	je     8010168f <ilock+0x4f>
80101671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
80101678:	c7 44 24 04 c0 01 11 	movl   $0x801101c0,0x4(%esp)
8010167f:	80 
80101680:	89 1c 24             	mov    %ebx,(%esp)
80101683:	e8 28 28 00 00       	call   80103eb0 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101688:	8b 43 0c             	mov    0xc(%ebx),%eax
8010168b:	a8 01                	test   $0x1,%al
8010168d:	75 e9                	jne    80101678 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010168f:	83 c8 01             	or     $0x1,%eax
80101692:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
80101695:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
8010169c:	e8 0f 2d 00 00       	call   801043b0 <release>

  if(!(ip->flags & I_VALID)){
801016a1:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
801016a5:	74 09                	je     801016b0 <ilock+0x70>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016a7:	83 c4 10             	add    $0x10,%esp
801016aa:	5b                   	pop    %ebx
801016ab:	5e                   	pop    %esi
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	c1 e8 03             	shr    $0x3,%eax
801016b6:	03 05 b4 01 11 80    	add    0x801101b4,%eax
801016bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801016c0:	8b 03                	mov    (%ebx),%eax
801016c2:	89 04 24             	mov    %eax,(%esp)
801016c5:	e8 f6 e9 ff ff       	call   801000c0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ca:	8b 53 04             	mov    0x4(%ebx),%edx
801016cd:	83 e2 07             	and    $0x7,%edx
801016d0:	c1 e2 06             	shl    $0x6,%edx
801016d3:	8d 54 10 18          	lea    0x18(%eax,%edx,1),%edx
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016d9:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c2 0c             	add    $0xc,%edx
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016df:	66 89 43 10          	mov    %ax,0x10(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
801016e7:	66 89 43 12          	mov    %ax,0x12(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
801016ef:	66 89 43 14          	mov    %ax,0x14(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
801016f7:	66 89 43 16          	mov    %ax,0x16(%ebx)
    ip->size = dip->size;
801016fb:	8b 42 fc             	mov    -0x4(%edx),%eax
801016fe:	89 43 18             	mov    %eax,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	8d 43 1c             	lea    0x1c(%ebx),%eax
80101704:	89 54 24 04          	mov    %edx,0x4(%esp)
80101708:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010170f:	00 
80101710:	89 04 24             	mov    %eax,(%esp)
80101713:	e8 88 2d 00 00       	call   801044a0 <memmove>
    brelse(bp);
80101718:	89 34 24             	mov    %esi,(%esp)
8010171b:	e8 a0 ea ff ff       	call   801001c0 <brelse>
    ip->flags |= I_VALID;
80101720:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
80101724:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
80101729:	0f 85 78 ff ff ff    	jne    801016a7 <ilock+0x67>
      panic("ilock: no type");
8010172f:	c7 04 24 9f 6f 10 80 	movl   $0x80106f9f,(%esp)
80101736:	e8 f5 eb ff ff       	call   80100330 <panic>
8010173b:	90                   	nop
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101740:	c7 04 24 99 6f 10 80 	movl   $0x80106f99,(%esp)
80101747:	e8 e4 eb ff ff       	call   80100330 <panic>
8010174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101750 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 14             	sub    $0x14,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
8010175a:	85 db                	test   %ebx,%ebx
8010175c:	74 36                	je     80101794 <iunlock+0x44>
8010175e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
80101762:	74 30                	je     80101794 <iunlock+0x44>
80101764:	8b 43 08             	mov    0x8(%ebx),%eax
80101767:	85 c0                	test   %eax,%eax
80101769:	7e 29                	jle    80101794 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
8010176b:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101772:	e8 09 2b 00 00       	call   80104280 <acquire>
  ip->flags &= ~I_BUSY;
80101777:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
8010177b:	89 1c 24             	mov    %ebx,(%esp)
8010177e:	e8 cd 28 00 00       	call   80104050 <wakeup>
  release(&icache.lock);
80101783:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010178a:	83 c4 14             	add    $0x14,%esp
8010178d:	5b                   	pop    %ebx
8010178e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
8010178f:	e9 1c 2c 00 00       	jmp    801043b0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
80101794:	c7 04 24 ae 6f 10 80 	movl   $0x80106fae,(%esp)
8010179b:	e8 90 eb ff ff       	call   80100330 <panic>

801017a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 1c             	sub    $0x1c,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
801017ac:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
801017b3:	e8 c8 2a 00 00       	call   80104280 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017b8:	8b 46 08             	mov    0x8(%esi),%eax
801017bb:	83 f8 01             	cmp    $0x1,%eax
801017be:	0f 85 a1 00 00 00    	jne    80101865 <iput+0xc5>
801017c4:	8b 56 0c             	mov    0xc(%esi),%edx
801017c7:	f6 c2 02             	test   $0x2,%dl
801017ca:	0f 84 95 00 00 00    	je     80101865 <iput+0xc5>
801017d0:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
801017d5:	0f 85 8a 00 00 00    	jne    80101865 <iput+0xc5>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
801017db:	f6 c2 01             	test   $0x1,%dl
801017de:	0f 85 fa 00 00 00    	jne    801018de <iput+0x13e>
      panic("iput busy");
    ip->flags |= I_BUSY;
801017e4:	83 ca 01             	or     $0x1,%edx
801017e7:	89 f3                	mov    %esi,%ebx
801017e9:	89 56 0c             	mov    %edx,0xc(%esi)
801017ec:	8d 7e 30             	lea    0x30(%esi),%edi
    release(&icache.lock);
801017ef:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
801017f6:	e8 b5 2b 00 00       	call   801043b0 <release>
801017fb:	eb 0a                	jmp    80101807 <iput+0x67>
801017fd:	8d 76 00             	lea    0x0(%esi),%esi
80101800:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101803:	39 fb                	cmp    %edi,%ebx
80101805:	74 1c                	je     80101823 <iput+0x83>
    if(ip->addrs[i]){
80101807:	8b 53 1c             	mov    0x1c(%ebx),%edx
8010180a:	85 d2                	test   %edx,%edx
8010180c:	74 f2                	je     80101800 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010180e:	8b 06                	mov    (%esi),%eax
80101810:	83 c3 04             	add    $0x4,%ebx
80101813:	e8 88 fb ff ff       	call   801013a0 <bfree>
      ip->addrs[i] = 0;
80101818:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010181f:	39 fb                	cmp    %edi,%ebx
80101821:	75 e4                	jne    80101807 <iput+0x67>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101823:	8b 46 4c             	mov    0x4c(%esi),%eax
80101826:	85 c0                	test   %eax,%eax
80101828:	75 56                	jne    80101880 <iput+0xe0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010182a:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
80101831:	89 34 24             	mov    %esi,(%esp)
80101834:	e8 47 fd ff ff       	call   80101580 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
80101839:	31 c0                	xor    %eax,%eax
8010183b:	66 89 46 10          	mov    %ax,0x10(%esi)
    iupdate(ip);
8010183f:	89 34 24             	mov    %esi,(%esp)
80101842:	e8 39 fd ff ff       	call   80101580 <iupdate>
    acquire(&icache.lock);
80101847:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
8010184e:	e8 2d 2a 00 00       	call   80104280 <acquire>
    ip->flags = 0;
80101853:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
8010185a:	89 34 24             	mov    %esi,(%esp)
8010185d:	e8 ee 27 00 00       	call   80104050 <wakeup>
80101862:	8b 46 08             	mov    0x8(%esi),%eax
  }
  ip->ref--;
80101865:	83 e8 01             	sub    $0x1,%eax
80101868:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
8010186b:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
80101872:	83 c4 1c             	add    $0x1c,%esp
80101875:	5b                   	pop    %ebx
80101876:	5e                   	pop    %esi
80101877:	5f                   	pop    %edi
80101878:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags = 0;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
80101879:	e9 32 2b 00 00       	jmp    801043b0 <release>
8010187e:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101880:	89 44 24 04          	mov    %eax,0x4(%esp)
80101884:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101886:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101888:	89 04 24             	mov    %eax,(%esp)
8010188b:	e8 30 e8 ff ff       	call   801000c0 <bread>
80101890:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101893:	8d 78 18             	lea    0x18(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
80101896:	31 c0                	xor    %eax,%eax
80101898:	eb 13                	jmp    801018ad <iput+0x10d>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018a0:	83 c3 01             	add    $0x1,%ebx
801018a3:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018a9:	89 d8                	mov    %ebx,%eax
801018ab:	74 10                	je     801018bd <iput+0x11d>
      if(a[j])
801018ad:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018b0:	85 d2                	test   %edx,%edx
801018b2:	74 ec                	je     801018a0 <iput+0x100>
        bfree(ip->dev, a[j]);
801018b4:	8b 06                	mov    (%esi),%eax
801018b6:	e8 e5 fa ff ff       	call   801013a0 <bfree>
801018bb:	eb e3                	jmp    801018a0 <iput+0x100>
    }
    brelse(bp);
801018bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018c0:	89 04 24             	mov    %eax,(%esp)
801018c3:	e8 f8 e8 ff ff       	call   801001c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018c8:	8b 56 4c             	mov    0x4c(%esi),%edx
801018cb:	8b 06                	mov    (%esi),%eax
801018cd:	e8 ce fa ff ff       	call   801013a0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018d2:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018d9:	e9 4c ff ff ff       	jmp    8010182a <iput+0x8a>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
      panic("iput busy");
801018de:	c7 04 24 b6 6f 10 80 	movl   $0x80106fb6,(%esp)
801018e5:	e8 46 ea ff ff       	call   80100330 <panic>
801018ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 14             	sub    $0x14,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	89 1c 24             	mov    %ebx,(%esp)
801018fd:	e8 4e fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101902:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101905:	83 c4 14             	add    $0x14,%esp
80101908:	5b                   	pop    %ebx
80101909:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 91 fe ff ff       	jmp    801017a0 <iput>
8010190f:	90                   	nop

80101910 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 18             	mov    0x18(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 2c             	sub    $0x2c,%esp
80101949:	8b 45 0c             	mov    0xc(%ebp),%eax
8010194c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
80101952:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101955:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101958:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010195d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101960:	0f 84 aa 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101966:	8b 47 18             	mov    0x18(%edi),%eax
80101969:	39 f0                	cmp    %esi,%eax
8010196b:	0f 82 c7 00 00 00    	jb     80101a38 <readi+0xf8>
80101971:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101974:	89 da                	mov    %ebx,%edx
80101976:	01 f2                	add    %esi,%edx
80101978:	0f 82 ba 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010197e:	89 c1                	mov    %eax,%ecx
80101980:	29 f1                	sub    %esi,%ecx
80101982:	39 d0                	cmp    %edx,%eax
80101984:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101987:	31 c0                	xor    %eax,%eax
80101989:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198e:	74 70                	je     80101a00 <readi+0xc0>
80101990:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101993:	89 c7                	mov    %eax,%edi
80101995:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101998:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010199b:	89 f2                	mov    %esi,%edx
8010199d:	c1 ea 09             	shr    $0x9,%edx
801019a0:	89 d8                	mov    %ebx,%eax
801019a2:	e8 f9 f8 ff ff       	call   801012a0 <bmap>
801019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019ab:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ad:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b2:	89 04 24             	mov    %eax,(%esp)
801019b5:	e8 06 e7 ff ff       	call   801000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019bd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	89 f0                	mov    %esi,%eax
801019c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019c8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ca:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019ce:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	01 df                	add    %ebx,%edi
801019e0:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019e5:	89 04 24             	mov    %eax,(%esp)
801019e8:	e8 b3 2a 00 00       	call   801044a0 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 c8 e7 ff ff       	call   801001c0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019fe:	77 98                	ja     80101998 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a03:	83 c4 2c             	add    $0x2c,%esp
80101a06:	5b                   	pop    %ebx
80101a07:	5e                   	pop    %esi
80101a08:	5f                   	pop    %edi
80101a09:	5d                   	pop    %ebp
80101a0a:	c3                   	ret    
80101a0b:	90                   	nop
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 47 12          	movswl 0x12(%edi),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 40 01 11 80 	mov    -0x7feefec0(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a28:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a2b:	83 c4 2c             	add    $0x2c,%esp
80101a2e:	5b                   	pop    %ebx
80101a2f:	5e                   	pop    %esi
80101a30:	5f                   	pop    %edi
80101a31:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a32:	ff e0                	jmp    *%eax
80101a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c4                	jmp    80101a03 <readi+0xc3>
80101a3f:	90                   	nop

80101a40 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 2c             	sub    $0x2c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a60:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 18             	cmp    %esi,0x18(%eax)
80101a6f:	0f 82 e3 00 00 00    	jb     80101b58 <writei+0x118>
80101a75:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a78:	89 c8                	mov    %ecx,%eax
80101a7a:	01 f0                	add    %esi,%eax
80101a7c:	0f 82 d6 00 00 00    	jb     80101b58 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a82:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a87:	0f 87 cb 00 00 00    	ja     80101b58 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8d:	85 c9                	test   %ecx,%ecx
80101a8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a96:	74 77                	je     80101b0f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a98:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a9b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa2:	c1 ea 09             	shr    $0x9,%edx
80101aa5:	89 f8                	mov    %edi,%eax
80101aa7:	e8 f4 f7 ff ff       	call   801012a0 <bmap>
80101aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ab0:	8b 07                	mov    (%edi),%eax
80101ab2:	89 04 24             	mov    %eax,(%esp)
80101ab5:	e8 06 e6 ff ff       	call   801000c0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101abd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ac0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac5:	89 f0                	mov    %esi,%eax
80101ac7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101acc:	29 c3                	sub    %eax,%ebx
80101ace:	39 cb                	cmp    %ecx,%ebx
80101ad0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad3:	8d 44 07 18          	lea    0x18(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101add:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ae1:	89 04 24             	mov    %eax,(%esp)
80101ae4:	e8 b7 29 00 00       	call   801044a0 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 2f 12 00 00       	call   80102d20 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 c7 e6 ff ff       	call   801001c0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101aff:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b02:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b05:	77 91                	ja     80101a98 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b07:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0a:	39 70 18             	cmp    %esi,0x18(%eax)
80101b0d:	72 39                	jb     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b12:	83 c4 2c             	add    $0x2c,%esp
80101b15:	5b                   	pop    %ebx
80101b16:	5e                   	pop    %esi
80101b17:	5f                   	pop    %edi
80101b18:	5d                   	pop    %ebp
80101b19:	c3                   	ret    
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 2e                	ja     80101b58 <writei+0x118>
80101b2a:	8b 04 c5 44 01 11 80 	mov    -0x7feefebc(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 23                	je     80101b58 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	83 c4 2c             	add    $0x2c,%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4b:	89 70 18             	mov    %esi,0x18(%eax)
    iupdate(ip);
80101b4e:	89 04 24             	mov    %eax,(%esp)
80101b51:	e8 2a fa ff ff       	call   80101580 <iupdate>
80101b56:	eb b7                	jmp    80101b0f <writei+0xcf>
  }
  return n;
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b60:	5b                   	pop    %ebx
80101b61:	5e                   	pop    %esi
80101b62:	5f                   	pop    %edi
80101b63:	5d                   	pop    %ebp
80101b64:	c3                   	ret    
80101b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b79:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b80:	00 
80101b81:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	89 04 24             	mov    %eax,(%esp)
80101b8b:	e8 90 29 00 00       	call   80104520 <strncmp>
}
80101b90:	c9                   	leave  
80101b91:	c3                   	ret    
80101b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 2c             	sub    $0x2c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80101bb1:	0f 85 97 00 00 00    	jne    80101c4e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 18             	mov    0x18(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 73                	jmp    80101c38 <dirlookup+0x98>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 18             	cmp    %edi,0x18(%ebx)
80101bce:	76 68                	jbe    80101c38 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bd7:	00 
80101bd8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bdc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101be0:	89 1c 24             	mov    %ebx,(%esp)
80101be3:	e8 58 fd ff ff       	call   80101940 <readi>
80101be8:	83 f8 10             	cmp    $0x10,%eax
80101beb:	75 55                	jne    80101c42 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101bed:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bf2:	74 d4                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bf4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bfe:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c05:	00 
80101c06:	89 04 24             	mov    %eax,(%esp)
80101c09:	e8 12 29 00 00       	call   80104520 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c0e:	85 c0                	test   %eax,%eax
80101c10:	75 b6                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c12:	8b 45 10             	mov    0x10(%ebp),%eax
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 05                	je     80101c1e <dirlookup+0x7e>
        *poff = off;
80101c19:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c1e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c22:	8b 03                	mov    (%ebx),%eax
80101c24:	e8 b7 f5 ff ff       	call   801011e0 <iget>
    }
  }

  return 0;
}
80101c29:	83 c4 2c             	add    $0x2c,%esp
80101c2c:	5b                   	pop    %ebx
80101c2d:	5e                   	pop    %esi
80101c2e:	5f                   	pop    %edi
80101c2f:	5d                   	pop    %ebp
80101c30:	c3                   	ret    
80101c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c38:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c3b:	31 c0                	xor    %eax,%eax
}
80101c3d:	5b                   	pop    %ebx
80101c3e:	5e                   	pop    %esi
80101c3f:	5f                   	pop    %edi
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c42:	c7 04 24 d2 6f 10 80 	movl   $0x80106fd2,(%esp)
80101c49:	e8 e2 e6 ff ff       	call   80100330 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c4e:	c7 04 24 c0 6f 10 80 	movl   $0x80106fc0,(%esp)
80101c55:	e8 d6 e6 ff ff       	call   80100330 <panic>
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	89 cf                	mov    %ecx,%edi
80101c66:	56                   	push   %esi
80101c67:	53                   	push   %ebx
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c73:	0f 84 51 01 00 00    	je     80101dca <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101c7f:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c82:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101c89:	e8 f2 25 00 00       	call   80104280 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101c99:	e8 12 27 00 00       	call   801043b0 <release>
80101c9e:	eb 03                	jmp    80101ca3 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ca0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101ca3:	0f b6 03             	movzbl (%ebx),%eax
80101ca6:	3c 2f                	cmp    $0x2f,%al
80101ca8:	74 f6                	je     80101ca0 <namex+0x40>
    path++;
  if(*path == 0)
80101caa:	84 c0                	test   %al,%al
80101cac:	0f 84 ed 00 00 00    	je     80101d9f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb2:	0f b6 03             	movzbl (%ebx),%eax
80101cb5:	89 da                	mov    %ebx,%edx
80101cb7:	84 c0                	test   %al,%al
80101cb9:	0f 84 b1 00 00 00    	je     80101d70 <namex+0x110>
80101cbf:	3c 2f                	cmp    $0x2f,%al
80101cc1:	75 0f                	jne    80101cd2 <namex+0x72>
80101cc3:	e9 a8 00 00 00       	jmp    80101d70 <namex+0x110>
80101cc8:	3c 2f                	cmp    $0x2f,%al
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cd0:	74 0a                	je     80101cdc <namex+0x7c>
    path++;
80101cd2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cd5:	0f b6 02             	movzbl (%edx),%eax
80101cd8:	84 c0                	test   %al,%al
80101cda:	75 ec                	jne    80101cc8 <namex+0x68>
80101cdc:	89 d1                	mov    %edx,%ecx
80101cde:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ce0:	83 f9 0d             	cmp    $0xd,%ecx
80101ce3:	0f 8e 8f 00 00 00    	jle    80101d78 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ce9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101ced:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101cf4:	00 
80101cf5:	89 3c 24             	mov    %edi,(%esp)
80101cf8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cfb:	e8 a0 27 00 00       	call   801044a0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d03:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d05:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d08:	75 0e                	jne    80101d18 <namex+0xb8>
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	89 34 24             	mov    %esi,(%esp)
80101d1b:	e8 20 f9 ff ff       	call   80101640 <ilock>
    if(ip->type != T_DIR){
80101d20:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80101d25:	0f 85 85 00 00 00    	jne    80101db0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d2e:	85 d2                	test   %edx,%edx
80101d30:	74 09                	je     80101d3b <namex+0xdb>
80101d32:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d35:	0f 84 a5 00 00 00    	je     80101de0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d42:	00 
80101d43:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d47:	89 34 24             	mov    %esi,(%esp)
80101d4a:	e8 51 fe ff ff       	call   80101ba0 <dirlookup>
80101d4f:	85 c0                	test   %eax,%eax
80101d51:	74 5d                	je     80101db0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d53:	89 34 24             	mov    %esi,(%esp)
80101d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d59:	e8 f2 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 3a fa ff ff       	call   801017a0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	89 c6                	mov    %eax,%esi
80101d6b:	e9 33 ff ff ff       	jmp    80101ca3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d70:	31 c9                	xor    %ecx,%ecx
80101d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d7c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d80:	89 3c 24             	mov    %edi,(%esp)
80101d83:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d86:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d89:	e8 12 27 00 00       	call   801044a0 <memmove>
    name[len] = 0;
80101d8e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d94:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d98:	89 d3                	mov    %edx,%ebx
80101d9a:	e9 66 ff ff ff       	jmp    80101d05 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101da2:	85 c0                	test   %eax,%eax
80101da4:	75 4c                	jne    80101df2 <namex+0x192>
80101da6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101da8:	83 c4 2c             	add    $0x2c,%esp
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
80101daf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101db0:	89 34 24             	mov    %esi,(%esp)
80101db3:	e8 98 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101db8:	89 34 24             	mov    %esi,(%esp)
80101dbb:	e8 e0 f9 ff ff       	call   801017a0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dc3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc5:	5b                   	pop    %ebx
80101dc6:	5e                   	pop    %esi
80101dc7:	5f                   	pop    %edi
80101dc8:	5d                   	pop    %ebp
80101dc9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dca:	ba 01 00 00 00       	mov    $0x1,%edx
80101dcf:	b8 01 00 00 00       	mov    $0x1,%eax
80101dd4:	e8 07 f4 ff ff       	call   801011e0 <iget>
80101dd9:	89 c6                	mov    %eax,%esi
80101ddb:	e9 c3 fe ff ff       	jmp    80101ca3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 68 f9 ff ff       	call   80101750 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101deb:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ded:	5b                   	pop    %ebx
80101dee:	5e                   	pop    %esi
80101def:	5f                   	pop    %edi
80101df0:	5d                   	pop    %ebp
80101df1:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101df2:	89 34 24             	mov    %esi,(%esp)
80101df5:	e8 a6 f9 ff ff       	call   801017a0 <iput>
    return 0;
80101dfa:	31 c0                	xor    %eax,%eax
80101dfc:	eb aa                	jmp    80101da8 <namex+0x148>
80101dfe:	66 90                	xchg   %ax,%ax

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 2c             	sub    $0x2c,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e16:	00 
80101e17:	89 1c 24             	mov    %ebx,(%esp)
80101e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e1e:	e8 7d fd ff ff       	call   80101ba0 <dirlookup>
80101e23:	85 c0                	test   %eax,%eax
80101e25:	0f 85 8b 00 00 00    	jne    80101eb6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e2b:	8b 43 18             	mov    0x18(%ebx),%eax
80101e2e:	31 ff                	xor    %edi,%edi
80101e30:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e33:	85 c0                	test   %eax,%eax
80101e35:	75 13                	jne    80101e4a <dirlink+0x4a>
80101e37:	eb 35                	jmp    80101e6e <dirlink+0x6e>
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e40:	8d 57 10             	lea    0x10(%edi),%edx
80101e43:	39 53 18             	cmp    %edx,0x18(%ebx)
80101e46:	89 d7                	mov    %edx,%edi
80101e48:	76 24                	jbe    80101e6e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e4a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e51:	00 
80101e52:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e56:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e5a:	89 1c 24             	mov    %ebx,(%esp)
80101e5d:	e8 de fa ff ff       	call   80101940 <readi>
80101e62:	83 f8 10             	cmp    $0x10,%eax
80101e65:	75 5e                	jne    80101ec5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e67:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6c:	75 d2                	jne    80101e40 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e71:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e78:	00 
80101e79:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e80:	89 04 24             	mov    %eax,(%esp)
80101e83:	e8 08 27 00 00       	call   80104590 <strncpy>
  de.inum = inum;
80101e88:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e92:	00 
80101e93:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e97:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e9e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea2:	e8 99 fb ff ff       	call   80101a40 <writei>
80101ea7:	83 f8 10             	cmp    $0x10,%eax
80101eaa:	75 25                	jne    80101ed1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101eac:	31 c0                	xor    %eax,%eax
}
80101eae:	83 c4 2c             	add    $0x2c,%esp
80101eb1:	5b                   	pop    %ebx
80101eb2:	5e                   	pop    %esi
80101eb3:	5f                   	pop    %edi
80101eb4:	5d                   	pop    %ebp
80101eb5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101eb6:	89 04 24             	mov    %eax,(%esp)
80101eb9:	e8 e2 f8 ff ff       	call   801017a0 <iput>
    return -1;
80101ebe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec3:	eb e9                	jmp    80101eae <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ec5:	c7 04 24 d2 6f 10 80 	movl   $0x80106fd2,(%esp)
80101ecc:	e8 5f e4 ff ff       	call   80100330 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ed1:	c7 04 24 96 76 10 80 	movl   $0x80107696,(%esp)
80101ed8:	e8 53 e4 ff ff       	call   80100330 <panic>
80101edd:	8d 76 00             	lea    0x0(%esi),%esi

80101ee0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	56                   	push   %esi
80101f24:	89 c6                	mov    %eax,%esi
80101f26:	53                   	push   %ebx
80101f27:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f2a:	85 c0                	test   %eax,%eax
80101f2c:	0f 84 99 00 00 00    	je     80101fcb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f32:	8b 48 08             	mov    0x8(%eax),%ecx
80101f35:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f3b:	0f 87 7e 00 00 00    	ja     80101fbf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f41:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f49:	83 e0 c0             	and    $0xffffffc0,%eax
80101f4c:	3c 40                	cmp    $0x40,%al
80101f4e:	75 f8                	jne    80101f48 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f50:	31 db                	xor    %ebx,%ebx
80101f52:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f57:	89 d8                	mov    %ebx,%eax
80101f59:	ee                   	out    %al,(%dx)
80101f5a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f5f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f64:	ee                   	out    %al,(%dx)
80101f65:	0f b6 c1             	movzbl %cl,%eax
80101f68:	b2 f3                	mov    $0xf3,%dl
80101f6a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f6b:	89 c8                	mov    %ecx,%eax
80101f6d:	b2 f4                	mov    $0xf4,%dl
80101f6f:	c1 f8 08             	sar    $0x8,%eax
80101f72:	ee                   	out    %al,(%dx)
80101f73:	b2 f5                	mov    $0xf5,%dl
80101f75:	89 d8                	mov    %ebx,%eax
80101f77:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f78:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f7c:	b2 f6                	mov    $0xf6,%dl
80101f7e:	83 e0 01             	and    $0x1,%eax
80101f81:	c1 e0 04             	shl    $0x4,%eax
80101f84:	83 c8 e0             	or     $0xffffffe0,%eax
80101f87:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f88:	f6 06 04             	testb  $0x4,(%esi)
80101f8b:	75 13                	jne    80101fa0 <idestart+0x80>
80101f8d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f92:	b8 20 00 00 00       	mov    $0x20,%eax
80101f97:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f98:	83 c4 10             	add    $0x10,%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5d                   	pop    %ebp
80101f9e:	c3                   	ret    
80101f9f:	90                   	nop
80101fa0:	b2 f7                	mov    $0xf7,%dl
80101fa2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fa7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fa8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fad:	83 c6 18             	add    $0x18,%esi
80101fb0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fb5:	fc                   	cld    
80101fb6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fbf:	c7 04 24 45 70 10 80 	movl   $0x80107045,(%esp)
80101fc6:	e8 65 e3 ff ff       	call   80100330 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fcb:	c7 04 24 3c 70 10 80 	movl   $0x8010703c,(%esp)
80101fd2:	e8 59 e3 ff ff       	call   80100330 <panic>
80101fd7:	89 f6                	mov    %esi,%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80101fe6:	c7 44 24 04 57 70 10 	movl   $0x80107057,0x4(%esp)
80101fed:	80 
80101fee:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80101ff5:	e8 06 22 00 00       	call   80104200 <initlock>
  picenable(IRQ_IDE);
80101ffa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102001:	e8 ea 11 00 00       	call   801031f0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102006:	a1 c0 18 11 80       	mov    0x801118c0,%eax
8010200b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102012:	83 e8 01             	sub    $0x1,%eax
80102015:	89 44 24 04          	mov    %eax,0x4(%esp)
80102019:	e8 82 02 00 00       	call   801022a0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010201e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102023:	90                   	nop
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102028:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102035:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203a:	ee                   	out    %al,(%dx)
8010203b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	eb 09                	jmp    8010204d <ideinit+0x6d>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102048:	83 e9 01             	sub    $0x1,%ecx
8010204b:	74 0f                	je     8010205c <ideinit+0x7c>
8010204d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010204e:	84 c0                	test   %al,%al
80102050:	74 f6                	je     80102048 <ideinit+0x68>
      havedisk1 = 1;
80102052:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102059:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010205c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102061:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102066:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102079:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102080:	e8 fb 21 00 00       	call   80104280 <acquire>
  if((b = idequeue) == 0){
80102085:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010208b:	85 db                	test   %ebx,%ebx
8010208d:	74 30                	je     801020bf <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
8010208f:	8b 43 14             	mov    0x14(%ebx),%eax
80102092:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102097:	8b 33                	mov    (%ebx),%esi
80102099:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010209f:	74 37                	je     801020d8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020a1:	83 e6 fb             	and    $0xfffffffb,%esi
801020a4:	83 ce 02             	or     $0x2,%esi
801020a7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020a9:	89 1c 24             	mov    %ebx,(%esp)
801020ac:	e8 9f 1f 00 00       	call   80104050 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020b1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	74 05                	je     801020bf <ideintr+0x4f>
    idestart(idequeue);
801020ba:	e8 61 fe ff ff       	call   80101f20 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801020bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c6:	e8 e5 22 00 00       	call   801043b0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020cb:	83 c4 1c             	add    $0x1c,%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	90                   	nop
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c1                	mov    %eax,%ecx
801020e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020e6:	80 f9 40             	cmp    $0x40,%cl
801020e9:	75 f5                	jne    801020e0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020eb:	a8 21                	test   $0x21,%al
801020ed:	75 b2                	jne    801020a1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ef:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fc:	fc                   	cld    
801020fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ff:	8b 33                	mov    (%ebx),%esi
80102101:	eb 9e                	jmp    801020a1 <ideintr+0x31>
80102103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 14             	sub    $0x14,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
8010211a:	8b 03                	mov    (%ebx),%eax
8010211c:	a8 01                	test   $0x1,%al
8010211e:	0f 84 9f 00 00 00    	je     801021c3 <iderw+0xb3>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102124:	83 e0 06             	and    $0x6,%eax
80102127:	83 f8 02             	cmp    $0x2,%eax
8010212a:	0f 84 ab 00 00 00    	je     801021db <iderw+0xcb>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102130:	8b 53 04             	mov    0x4(%ebx),%edx
80102133:	85 d2                	test   %edx,%edx
80102135:	74 0d                	je     80102144 <iderw+0x34>
80102137:	a1 60 a5 10 80       	mov    0x8010a560,%eax
8010213c:	85 c0                	test   %eax,%eax
8010213e:	0f 84 8b 00 00 00    	je     801021cf <iderw+0xbf>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102144:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
8010214b:	e8 30 21 00 00       	call   80104280 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102150:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102155:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215c:	85 c0                	test   %eax,%eax
8010215e:	75 0a                	jne    8010216a <iderw+0x5a>
80102160:	eb 51                	jmp    801021b3 <iderw+0xa3>
80102162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102168:	89 d0                	mov    %edx,%eax
8010216a:	8b 50 14             	mov    0x14(%eax),%edx
8010216d:	85 d2                	test   %edx,%edx
8010216f:	75 f7                	jne    80102168 <iderw+0x58>
80102171:	83 c0 14             	add    $0x14,%eax
    ;
  *pp = b;
80102174:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102176:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010217c:	74 3c                	je     801021ba <iderw+0xaa>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 e0 06             	and    $0x6,%eax
80102183:	83 f8 02             	cmp    $0x2,%eax
80102186:	74 1a                	je     801021a2 <iderw+0x92>
    sleep(b, &idelock);
80102188:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
8010218f:	80 
80102190:	89 1c 24             	mov    %ebx,(%esp)
80102193:	e8 18 1d 00 00       	call   80103eb0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102198:	8b 13                	mov    (%ebx),%edx
8010219a:	83 e2 06             	and    $0x6,%edx
8010219d:	83 fa 02             	cmp    $0x2,%edx
801021a0:	75 e6                	jne    80102188 <iderw+0x78>
    sleep(b, &idelock);
  }

  release(&idelock);
801021a2:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021a9:	83 c4 14             	add    $0x14,%esp
801021ac:	5b                   	pop    %ebx
801021ad:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801021ae:	e9 fd 21 00 00       	jmp    801043b0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021b3:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021b8:	eb ba                	jmp    80102174 <iderw+0x64>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021ba:	89 d8                	mov    %ebx,%eax
801021bc:	e8 5f fd ff ff       	call   80101f20 <idestart>
801021c1:	eb bb                	jmp    8010217e <iderw+0x6e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
801021c3:	c7 04 24 5b 70 10 80 	movl   $0x8010705b,(%esp)
801021ca:	e8 61 e1 ff ff       	call   80100330 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021cf:	c7 04 24 84 70 10 80 	movl   $0x80107084,(%esp)
801021d6:	e8 55 e1 ff ff       	call   80100330 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021db:	c7 04 24 6f 70 10 80 	movl   $0x8010706f,(%esp)
801021e2:	e8 49 e1 ff ff       	call   80100330 <panic>
801021e7:	66 90                	xchg   %ax,%ax
801021e9:	66 90                	xchg   %ax,%ax
801021eb:	66 90                	xchg   %ax,%ax
801021ed:	66 90                	xchg   %ax,%ax
801021ef:	90                   	nop

801021f0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021f0:	a1 c4 12 11 80       	mov    0x801112c4,%eax
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 9b 00 00 00    	je     80102298 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fd:	55                   	push   %ebp
801021fe:	89 e5                	mov    %esp,%ebp
80102200:	56                   	push   %esi
80102201:	53                   	push   %ebx
80102202:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102205:	c7 05 94 11 11 80 00 	movl   $0xfec00000,0x80111194
8010220c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010220f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102216:	00 00 00 
  return ioapic->data;
80102219:	8b 15 94 11 11 80    	mov    0x80111194,%edx
8010221f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102222:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102228:	8b 1d 94 11 11 80    	mov    0x80111194,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222e:	0f b6 15 c0 12 11 80 	movzbl 0x801112c0,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102235:	c1 e8 10             	shr    $0x10,%eax
80102238:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223b:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
8010223e:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102241:	39 c2                	cmp    %eax,%edx
80102243:	74 12                	je     80102257 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102245:	c7 04 24 a4 70 10 80 	movl   $0x801070a4,(%esp)
8010224c:	e8 cf e3 ff ff       	call   80100620 <cprintf>
80102251:	8b 1d 94 11 11 80    	mov    0x80111194,%ebx
80102257:	ba 10 00 00 00       	mov    $0x10,%edx
8010225c:	31 c0                	xor    %eax,%eax
8010225e:	eb 02                	jmp    80102262 <ioapicinit+0x72>
80102260:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102262:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102264:	8b 1d 94 11 11 80    	mov    0x80111194,%ebx
8010226a:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010226d:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102273:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102276:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102279:	8d 4a 01             	lea    0x1(%edx),%ecx
8010227c:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227f:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102281:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102287:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102289:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102290:	7d ce                	jge    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102292:	83 c4 10             	add    $0x10,%esp
80102295:	5b                   	pop    %ebx
80102296:	5e                   	pop    %esi
80102297:	5d                   	pop    %ebp
80102298:	f3 c3                	repz ret 
8010229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022a0:	8b 15 c4 12 11 80    	mov    0x801112c4,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022a6:	55                   	push   %ebp
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022ac:	85 d2                	test   %edx,%edx
801022ae:	74 29                	je     801022d9 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022b0:	8d 48 20             	lea    0x20(%eax),%ecx
801022b3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b7:	a1 94 11 11 80       	mov    0x80111194,%eax
801022bc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022be:	a1 94 11 11 80       	mov    0x80111194,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c3:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c6:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022cc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022ce:	a1 94 11 11 80       	mov    0x80111194,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d3:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d6:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d9:	5d                   	pop    %ebp
801022da:	c3                   	ret    
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb 68 40 11 80    	cmp    $0x80114068,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 e1 20 00 00       	call   80104400 <memset>

  if(kmem.use_lock)
8010231f:	8b 15 d4 11 11 80    	mov    0x801111d4,%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 37                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102329:	a1 d8 11 11 80       	mov    0x801111d8,%eax
8010232e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102330:	a1 d4 11 11 80       	mov    0x801111d4,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102335:	89 1d d8 11 11 80    	mov    %ebx,0x801111d8
  if(kmem.use_lock)
8010233b:	85 c0                	test   %eax,%eax
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102348:	c7 45 08 a0 11 11 80 	movl   $0x801111a0,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102354:	e9 57 20 00 00       	jmp    801043b0 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	c7 04 24 a0 11 11 80 	movl   $0x801111a0,(%esp)
80102367:	e8 14 1f 00 00       	call   80104280 <acquire>
8010236c:	eb bb                	jmp    80102329 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010236e:	c7 04 24 d6 70 10 80 	movl   $0x801070d6,(%esp)
80102375:	e8 b6 df ff ff       	call   80100330 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 de                	cmp    %ebx,%esi
801023a2:	73 08                	jae    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023db:	c7 44 24 04 dc 70 10 	movl   $0x801070dc,0x4(%esp)
801023e2:	80 
801023e3:	c7 04 24 a0 11 11 80 	movl   $0x801111a0,(%esp)
801023ea:	e8 11 1e 00 00       	call   80104200 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f2:	c7 05 d4 11 11 80 00 	movl   $0x0,0x801111d4
801023f9:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102408:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010240e:	39 de                	cmp    %ebx,%esi
80102410:	73 0a                	jae    8010241c <kinit1+0x4c>
80102412:	eb 1a                	jmp    8010242e <kinit1+0x5e>
80102414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 bc fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 c6                	cmp    %eax,%esi
8010242c:	73 ea                	jae    80102418 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 08                	jae    8010246c <kinit2+0x2c>
80102464:	eb 18                	jmp    8010247e <kinit2+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 6c fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010247e:	c7 05 d4 11 11 80 01 	movl   $0x1,0x801111d4
80102485:	00 00 00 
}
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret    
8010248f:	90                   	nop

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 d4 11 11 80       	mov    0x801111d4,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d d8 11 11 80    	mov    0x801111d8,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 08                	je     801024b2 <kalloc+0x22>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 d8 11 11 80    	mov    %edx,0x801111d8
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 0c                	je     801024c2 <kalloc+0x32>
    release(&kmem.lock);
801024b6:	c7 04 24 a0 11 11 80 	movl   $0x801111a0,(%esp)
801024bd:	e8 ee 1e 00 00       	call   801043b0 <release>
  return (char*)r;
}
801024c2:	83 c4 14             	add    $0x14,%esp
801024c5:	89 d8                	mov    %ebx,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5d                   	pop    %ebp
801024c9:	c3                   	ret    
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	c7 04 24 a0 11 11 80 	movl   $0x801111a0,(%esp)
801024d7:	e8 a4 1d 00 00       	call   80104280 <acquire>
801024dc:	a1 d4 11 11 80       	mov    0x801111d4,%eax
801024e1:	eb bd                	jmp    801024a0 <kalloc+0x10>
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba 64 00 00 00       	mov    $0x64,%edx
801024f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f6:	a8 01                	test   $0x1,%al
801024f8:	0f 84 ba 00 00 00    	je     801025b8 <kbdgetc+0xc8>
801024fe:	b2 60                	mov    $0x60,%dl
80102500:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102501:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102504:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010250a:	0f 84 88 00 00 00    	je     80102598 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102510:	84 c0                	test   %al,%al
80102512:	79 2c                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010251a:	f6 c2 40             	test   $0x40,%dl
8010251d:	75 05                	jne    80102524 <kbdgetc+0x34>
8010251f:	89 c1                	mov    %eax,%ecx
80102521:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102524:	0f b6 81 20 72 10 80 	movzbl -0x7fef8de0(%ecx),%eax
8010252b:	83 c8 40             	or     $0x40,%eax
8010252e:	0f b6 c0             	movzbl %al,%eax
80102531:	f7 d0                	not    %eax
80102533:	21 d0                	and    %edx,%eax
80102535:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253a:	31 c0                	xor    %eax,%eax
8010253c:	c3                   	ret    
8010253d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010254a:	f6 c3 40             	test   $0x40,%bl
8010254d:	74 09                	je     80102558 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102552:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102558:	0f b6 91 20 72 10 80 	movzbl -0x7fef8de0(%ecx),%edx
  shift ^= togglecode[data];
8010255f:	0f b6 81 20 71 10 80 	movzbl -0x7fef8ee0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102566:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102568:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256a:	89 d0                	mov    %edx,%eax
8010256c:	83 e0 03             	and    $0x3,%eax
8010256f:	8b 04 85 00 71 10 80 	mov    -0x7fef8f00(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102576:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010257c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102583:	74 0b                	je     80102590 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102585:	8d 50 9f             	lea    -0x61(%eax),%edx
80102588:	83 fa 19             	cmp    $0x19,%edx
8010258b:	77 1b                	ja     801025a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010258d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102590:	5b                   	pop    %ebx
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	90                   	nop
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102598:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010259f:	31 c0                	xor    %eax,%eax
801025a1:	c3                   	ret    
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025ab:	8d 50 20             	lea    0x20(%eax),%edx
801025ae:	83 f9 19             	cmp    $0x19,%ecx
801025b1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025b4:	eb da                	jmp    80102590 <kbdgetc+0xa0>
801025b6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax

801025c0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025c6:	c7 04 24 f0 24 10 80 	movl   $0x801024f0,(%esp)
801025cd:	e8 ae e1 ff ff       	call   80100780 <consoleintr>
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025e0:	55                   	push   %ebp
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ea:	53                   	push   %ebx
801025eb:	31 c0                	xor    %eax,%eax
801025ed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	bb 71 00 00 00       	mov    $0x71,%ebx
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801025f6:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 01                	mov    %eax,(%ecx)
801025fd:	b8 02 00 00 00       	mov    $0x2,%eax
80102602:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 41 04             	mov    %eax,0x4(%ecx)
8010260e:	b8 04 00 00 00       	mov    $0x4,%eax
80102613:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102614:	89 da                	mov    %ebx,%edx
80102616:	ec                   	in     (%dx),%al
80102617:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	b2 70                	mov    $0x70,%dl
8010261c:	89 41 08             	mov    %eax,0x8(%ecx)
8010261f:	b8 07 00 00 00       	mov    $0x7,%eax
80102624:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102625:	89 da                	mov    %ebx,%edx
80102627:	ec                   	in     (%dx),%al
80102628:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262b:	b2 70                	mov    $0x70,%dl
8010262d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102630:	b8 08 00 00 00       	mov    $0x8,%eax
80102635:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102636:	89 da                	mov    %ebx,%edx
80102638:	ec                   	in     (%dx),%al
80102639:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263c:	b2 70                	mov    $0x70,%dl
8010263e:	89 41 10             	mov    %eax,0x10(%ecx)
80102641:	b8 09 00 00 00       	mov    $0x9,%eax
80102646:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102647:	89 da                	mov    %ebx,%edx
80102649:	ec                   	in     (%dx),%al
8010264a:	0f b6 d8             	movzbl %al,%ebx
8010264d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102650:	5b                   	pop    %ebx
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 dc 11 11 80       	mov    0x801111dc,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c0 00 00 00    	je     80102730 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 6f                	ja     80102738 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102718:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010271e:	80 e6 10             	and    $0x10,%dh
80102721:	75 f5                	jne    80102718 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102723:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102730:	5d                   	pop    %ebp
80102731:	c3                   	ret    
80102732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102738:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010273f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102742:	8b 50 20             	mov    0x20(%eax),%edx
80102745:	eb 82                	jmp    801026c9 <lapicinit+0x69>
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	56                   	push   %esi
80102754:	53                   	push   %ebx
80102755:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102758:	9c                   	pushf  
80102759:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010275a:	f6 c4 02             	test   $0x2,%ah
8010275d:	74 12                	je     80102771 <cpunum+0x21>
    static int n;
    if(n++ == 0)
8010275f:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80102764:	8d 50 01             	lea    0x1(%eax),%edx
80102767:	85 c0                	test   %eax,%eax
80102769:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
8010276f:	74 4a                	je     801027bb <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102771:	a1 dc 11 11 80       	mov    0x801111dc,%eax
80102776:	85 c0                	test   %eax,%eax
80102778:	74 5d                	je     801027d7 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
8010277a:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010277d:	8b 35 c0 18 11 80    	mov    0x801118c0,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102783:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102786:	85 f6                	test   %esi,%esi
80102788:	7e 56                	jle    801027e0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
8010278a:	0f b6 05 e0 12 11 80 	movzbl 0x801112e0,%eax
80102791:	39 d8                	cmp    %ebx,%eax
80102793:	74 42                	je     801027d7 <cpunum+0x87>
80102795:	ba 9c 13 11 80       	mov    $0x8011139c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
8010279a:	31 c0                	xor    %eax,%eax
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a0:	83 c0 01             	add    $0x1,%eax
801027a3:	39 f0                	cmp    %esi,%eax
801027a5:	74 39                	je     801027e0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027a7:	0f b6 0a             	movzbl (%edx),%ecx
801027aa:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801027b0:	39 d9                	cmp    %ebx,%ecx
801027b2:	75 ec                	jne    801027a0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801027b4:	83 c4 10             	add    $0x10,%esp
801027b7:	5b                   	pop    %ebx
801027b8:	5e                   	pop    %esi
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
801027bb:	8b 45 04             	mov    0x4(%ebp),%eax
801027be:	c7 04 24 20 73 10 80 	movl   $0x80107320,(%esp)
801027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801027c9:	e8 52 de ff ff       	call   80100620 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
801027ce:	a1 dc 11 11 80       	mov    0x801111dc,%eax
801027d3:	85 c0                	test   %eax,%eax
801027d5:	75 a3                	jne    8010277a <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027d7:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
801027da:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027dc:	5b                   	pop    %ebx
801027dd:	5e                   	pop    %esi
801027de:	5d                   	pop    %ebp
801027df:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
801027e0:	c7 04 24 4c 73 10 80 	movl   $0x8010734c,(%esp)
801027e7:	e8 44 db ff ff       	call   80100330 <panic>
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027f0:	a1 dc 11 11 80       	mov    0x801111dc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027f8:	85 c0                	test   %eax,%eax
801027fa:	74 0d                	je     80102809 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102803:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
}
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret    
80102815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102820:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	ba 70 00 00 00       	mov    $0x70,%edx
80102826:	89 e5                	mov    %esp,%ebp
80102828:	b8 0f 00 00 00       	mov    $0xf,%eax
8010282d:	53                   	push   %ebx
8010282e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102834:	ee                   	out    %al,(%dx)
80102835:	b8 0a 00 00 00       	mov    $0xa,%eax
8010283a:	b2 71                	mov    $0x71,%dl
8010283c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010283d:	31 c0                	xor    %eax,%eax
8010283f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102845:	89 d8                	mov    %ebx,%eax
80102847:	c1 e8 04             	shr    $0x4,%eax
8010284a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102850:	a1 dc 11 11 80       	mov    0x801111dc,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102855:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102858:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102861:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102864:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010286b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102871:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102878:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102887:	89 da                	mov    %ebx,%edx
80102889:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102892:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102895:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028a7:	5b                   	pop    %ebx
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028b0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028b0:	55                   	push   %ebp
801028b1:	ba 70 00 00 00       	mov    $0x70,%edx
801028b6:	89 e5                	mov    %esp,%ebp
801028b8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028bd:	57                   	push   %edi
801028be:	56                   	push   %esi
801028bf:	53                   	push   %ebx
801028c0:	83 ec 4c             	sub    $0x4c,%esp
801028c3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	b2 71                	mov    $0x71,%dl
801028c6:	ec                   	in     (%dx),%al
801028c7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028ca:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028cd:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028d1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028dd:	89 d8                	mov    %ebx,%eax
801028df:	e8 fc fc ff ff       	call   801025e0 <fill_rtcdate>
801028e4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028e9:	89 f2                	mov    %esi,%edx
801028eb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	ba 71 00 00 00       	mov    $0x71,%edx
801028f1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028f2:	84 c0                	test   %al,%al
801028f4:	78 e7                	js     801028dd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028f6:	89 f8                	mov    %edi,%eax
801028f8:	e8 e3 fc ff ff       	call   801025e0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028fd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102904:	00 
80102905:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102909:	89 1c 24             	mov    %ebx,(%esp)
8010290c:	e8 3f 1b 00 00       	call   80104450 <memcmp>
80102911:	85 c0                	test   %eax,%eax
80102913:	75 c3                	jne    801028d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102915:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102919:	75 78                	jne    80102993 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010291b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010291e:	89 c2                	mov    %eax,%edx
80102920:	83 e0 0f             	and    $0xf,%eax
80102923:	c1 ea 04             	shr    $0x4,%edx
80102926:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102929:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010292f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102932:	89 c2                	mov    %eax,%edx
80102934:	83 e0 0f             	and    $0xf,%eax
80102937:	c1 ea 04             	shr    $0x4,%edx
8010293a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102940:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102943:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102946:	89 c2                	mov    %eax,%edx
80102948:	83 e0 0f             	and    $0xf,%eax
8010294b:	c1 ea 04             	shr    $0x4,%edx
8010294e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102951:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102954:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102957:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295a:	89 c2                	mov    %eax,%edx
8010295c:	83 e0 0f             	and    $0xf,%eax
8010295f:	c1 ea 04             	shr    $0x4,%edx
80102962:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102965:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102968:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010296b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010296e:	89 c2                	mov    %eax,%edx
80102970:	83 e0 0f             	and    $0xf,%eax
80102973:	c1 ea 04             	shr    $0x4,%edx
80102976:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102979:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010297f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102982:	89 c2                	mov    %eax,%edx
80102984:	83 e0 0f             	and    $0xf,%eax
80102987:	c1 ea 04             	shr    $0x4,%edx
8010298a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102990:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102993:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102996:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102999:	89 01                	mov    %eax,(%ecx)
8010299b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010299e:	89 41 04             	mov    %eax,0x4(%ecx)
801029a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a4:	89 41 08             	mov    %eax,0x8(%ecx)
801029a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029aa:	89 41 0c             	mov    %eax,0xc(%ecx)
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 41 10             	mov    %eax,0x10(%ecx)
801029b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029b9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029c0:	83 c4 4c             	add    $0x4c,%esp
801029c3:	5b                   	pop    %ebx
801029c4:	5e                   	pop    %esi
801029c5:	5f                   	pop    %edi
801029c6:	5d                   	pop    %ebp
801029c7:	c3                   	ret    
801029c8:	66 90                	xchg   %ax,%ax
801029ca:	66 90                	xchg   %ax,%ax
801029cc:	66 90                	xchg   %ax,%ax
801029ce:	66 90                	xchg   %ax,%ax

801029d0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	57                   	push   %edi
801029d4:	56                   	push   %esi
801029d5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029d6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029d8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029db:	a1 28 12 11 80       	mov    0x80111228,%eax
801029e0:	85 c0                	test   %eax,%eax
801029e2:	7e 78                	jle    80102a5c <install_trans+0x8c>
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029e8:	a1 14 12 11 80       	mov    0x80111214,%eax
801029ed:	01 d8                	add    %ebx,%eax
801029ef:	83 c0 01             	add    $0x1,%eax
801029f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f6:	a1 24 12 11 80       	mov    0x80111224,%eax
801029fb:	89 04 24             	mov    %eax,(%esp)
801029fe:	e8 bd d6 ff ff       	call   801000c0 <bread>
80102a03:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a05:	8b 04 9d 2c 12 11 80 	mov    -0x7feeedd4(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a0c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a13:	a1 24 12 11 80       	mov    0x80111224,%eax
80102a18:	89 04 24             	mov    %eax,(%esp)
80102a1b:	e8 a0 d6 ff ff       	call   801000c0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a20:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a27:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a28:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a2a:	8d 47 18             	lea    0x18(%edi),%eax
80102a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a31:	8d 46 18             	lea    0x18(%esi),%eax
80102a34:	89 04 24             	mov    %eax,(%esp)
80102a37:	e8 64 1a 00 00       	call   801044a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a3c:	89 34 24             	mov    %esi,(%esp)
80102a3f:	e8 4c d7 ff ff       	call   80100190 <bwrite>
    brelse(lbuf);
80102a44:	89 3c 24             	mov    %edi,(%esp)
80102a47:	e8 74 d7 ff ff       	call   801001c0 <brelse>
    brelse(dbuf);
80102a4c:	89 34 24             	mov    %esi,(%esp)
80102a4f:	e8 6c d7 ff ff       	call   801001c0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	39 1d 28 12 11 80    	cmp    %ebx,0x80111228
80102a5a:	7f 8c                	jg     801029e8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a5c:	83 c4 1c             	add    $0x1c,%esp
80102a5f:	5b                   	pop    %ebx
80102a60:	5e                   	pop    %esi
80102a61:	5f                   	pop    %edi
80102a62:	5d                   	pop    %ebp
80102a63:	c3                   	ret    
80102a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	83 ec 10             	sub    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a78:	a1 14 12 11 80       	mov    0x80111214,%eax
80102a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a81:	a1 24 12 11 80       	mov    0x80111224,%eax
80102a86:	89 04 24             	mov    %eax,(%esp)
80102a89:	e8 32 d6 ff ff       	call   801000c0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a8e:	31 d2                	xor    %edx,%edx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a90:	89 c6                	mov    %eax,%esi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a92:	a1 28 12 11 80       	mov    0x80111228,%eax
80102a97:	8d 5e 18             	lea    0x18(%esi),%ebx
80102a9a:	89 46 18             	mov    %eax,0x18(%esi)
  for (i = 0; i < log.lh.n; i++) {
80102a9d:	a1 28 12 11 80       	mov    0x80111228,%eax
80102aa2:	85 c0                	test   %eax,%eax
80102aa4:	7e 18                	jle    80102abe <write_head+0x4e>
80102aa6:	66 90                	xchg   %ax,%ax
    hb->block[i] = log.lh.block[i];
80102aa8:	8b 0c 95 2c 12 11 80 	mov    -0x7feeedd4(,%edx,4),%ecx
80102aaf:	89 4c 93 04          	mov    %ecx,0x4(%ebx,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ab3:	83 c2 01             	add    $0x1,%edx
80102ab6:	39 15 28 12 11 80    	cmp    %edx,0x80111228
80102abc:	7f ea                	jg     80102aa8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102abe:	89 34 24             	mov    %esi,(%esp)
80102ac1:	e8 ca d6 ff ff       	call   80100190 <bwrite>
  brelse(buf);
80102ac6:	89 34 24             	mov    %esi,(%esp)
80102ac9:	e8 f2 d6 ff ff       	call   801001c0 <brelse>
}
80102ace:	83 c4 10             	add    $0x10,%esp
80102ad1:	5b                   	pop    %ebx
80102ad2:	5e                   	pop    %esi
80102ad3:	5d                   	pop    %ebp
80102ad4:	c3                   	ret    
80102ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	83 ec 30             	sub    $0x30,%esp
80102ae8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aeb:	c7 44 24 04 5c 73 10 	movl   $0x8010735c,0x4(%esp)
80102af2:	80 
80102af3:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102afa:	e8 01 17 00 00       	call   80104200 <initlock>
  readsb(dev, &sb);
80102aff:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b06:	89 1c 24             	mov    %ebx,(%esp)
80102b09:	e8 42 e8 ff ff       	call   80101350 <readsb>
  log.start = sb.logstart;
80102b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b11:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b14:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b17:	89 1d 24 12 11 80    	mov    %ebx,0x80111224

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b1d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b21:	89 15 18 12 11 80    	mov    %edx,0x80111218
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b27:	a3 14 12 11 80       	mov    %eax,0x80111214

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b2c:	e8 8f d5 ff ff       	call   801000c0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b31:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b33:	8b 58 18             	mov    0x18(%eax),%ebx
80102b36:	8d 70 18             	lea    0x18(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b39:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b3b:	89 1d 28 12 11 80    	mov    %ebx,0x80111228
  for (i = 0; i < log.lh.n; i++) {
80102b41:	7e 17                	jle    80102b5a <initlog+0x7a>
80102b43:	90                   	nop
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b48:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b4c:	89 0c 95 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b53:	83 c2 01             	add    $0x1,%edx
80102b56:	39 da                	cmp    %ebx,%edx
80102b58:	75 ee                	jne    80102b48 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b5a:	89 04 24             	mov    %eax,(%esp)
80102b5d:	e8 5e d6 ff ff       	call   801001c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b62:	e8 69 fe ff ff       	call   801029d0 <install_trans>
  log.lh.n = 0;
80102b67:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102b6e:	00 00 00 
  write_head(); // clear the log
80102b71:	e8 fa fe ff ff       	call   80102a70 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b76:	83 c4 30             	add    $0x30,%esp
80102b79:	5b                   	pop    %ebx
80102b7a:	5e                   	pop    %esi
80102b7b:	5d                   	pop    %ebp
80102b7c:	c3                   	ret    
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b86:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102b8d:	e8 ee 16 00 00       	call   80104280 <acquire>
80102b92:	eb 18                	jmp    80102bac <begin_op+0x2c>
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b98:	c7 44 24 04 e0 11 11 	movl   $0x801111e0,0x4(%esp)
80102b9f:	80 
80102ba0:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102ba7:	e8 04 13 00 00       	call   80103eb0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bac:	a1 20 12 11 80       	mov    0x80111220,%eax
80102bb1:	85 c0                	test   %eax,%eax
80102bb3:	75 e3                	jne    80102b98 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bb5:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102bba:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102bc0:	83 c0 01             	add    $0x1,%eax
80102bc3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bc6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bc9:	83 fa 1e             	cmp    $0x1e,%edx
80102bcc:	7f ca                	jg     80102b98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bce:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102bd5:	a3 1c 12 11 80       	mov    %eax,0x8011121c
      release(&log.lock);
80102bda:	e8 d1 17 00 00       	call   801043b0 <release>
      break;
    }
  }
}
80102bdf:	c9                   	leave  
80102be0:	c3                   	ret    
80102be1:	eb 0d                	jmp    80102bf0 <end_op>
80102be3:	90                   	nop
80102be4:	90                   	nop
80102be5:	90                   	nop
80102be6:	90                   	nop
80102be7:	90                   	nop
80102be8:	90                   	nop
80102be9:	90                   	nop
80102bea:	90                   	nop
80102beb:	90                   	nop
80102bec:	90                   	nop
80102bed:	90                   	nop
80102bee:	90                   	nop
80102bef:	90                   	nop

80102bf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	57                   	push   %edi
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bf9:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102c00:	e8 7b 16 00 00       	call   80104280 <acquire>
  log.outstanding -= 1;
80102c05:	a1 1c 12 11 80       	mov    0x8011121c,%eax
  if(log.committing)
80102c0a:	8b 15 20 12 11 80    	mov    0x80111220,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c10:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c13:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c15:	a3 1c 12 11 80       	mov    %eax,0x8011121c
  if(log.committing)
80102c1a:	0f 85 f3 00 00 00    	jne    80102d13 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c20:	85 c0                	test   %eax,%eax
80102c22:	0f 85 cb 00 00 00    	jne    80102cf3 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c28:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c2f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c31:	c7 05 20 12 11 80 01 	movl   $0x1,0x80111220
80102c38:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c3b:	e8 70 17 00 00       	call   801043b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c40:	a1 28 12 11 80       	mov    0x80111228,%eax
80102c45:	85 c0                	test   %eax,%eax
80102c47:	0f 8e 90 00 00 00    	jle    80102cdd <end_op+0xed>
80102c4d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c50:	a1 14 12 11 80       	mov    0x80111214,%eax
80102c55:	01 d8                	add    %ebx,%eax
80102c57:	83 c0 01             	add    $0x1,%eax
80102c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c5e:	a1 24 12 11 80       	mov    0x80111224,%eax
80102c63:	89 04 24             	mov    %eax,(%esp)
80102c66:	e8 55 d4 ff ff       	call   801000c0 <bread>
80102c6b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c6d:	8b 04 9d 2c 12 11 80 	mov    -0x7feeedd4(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c74:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c77:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c7b:	a1 24 12 11 80       	mov    0x80111224,%eax
80102c80:	89 04 24             	mov    %eax,(%esp)
80102c83:	e8 38 d4 ff ff       	call   801000c0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c8f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c90:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c92:	8d 40 18             	lea    0x18(%eax),%eax
80102c95:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c99:	8d 46 18             	lea    0x18(%esi),%eax
80102c9c:	89 04 24             	mov    %eax,(%esp)
80102c9f:	e8 fc 17 00 00       	call   801044a0 <memmove>
    bwrite(to);  // write the log
80102ca4:	89 34 24             	mov    %esi,(%esp)
80102ca7:	e8 e4 d4 ff ff       	call   80100190 <bwrite>
    brelse(from);
80102cac:	89 3c 24             	mov    %edi,(%esp)
80102caf:	e8 0c d5 ff ff       	call   801001c0 <brelse>
    brelse(to);
80102cb4:	89 34 24             	mov    %esi,(%esp)
80102cb7:	e8 04 d5 ff ff       	call   801001c0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cbc:	3b 1d 28 12 11 80    	cmp    0x80111228,%ebx
80102cc2:	7c 8c                	jl     80102c50 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cc4:	e8 a7 fd ff ff       	call   80102a70 <write_head>
    install_trans(); // Now install writes to home locations
80102cc9:	e8 02 fd ff ff       	call   801029d0 <install_trans>
    log.lh.n = 0;
80102cce:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102cd5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cd8:	e8 93 fd ff ff       	call   80102a70 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cdd:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102ce4:	e8 97 15 00 00       	call   80104280 <acquire>
    log.committing = 0;
80102ce9:	c7 05 20 12 11 80 00 	movl   $0x0,0x80111220
80102cf0:	00 00 00 
    wakeup(&log);
80102cf3:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102cfa:	e8 51 13 00 00       	call   80104050 <wakeup>
    release(&log.lock);
80102cff:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102d06:	e8 a5 16 00 00       	call   801043b0 <release>
  }
}
80102d0b:	83 c4 1c             	add    $0x1c,%esp
80102d0e:	5b                   	pop    %ebx
80102d0f:	5e                   	pop    %esi
80102d10:	5f                   	pop    %edi
80102d11:	5d                   	pop    %ebp
80102d12:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d13:	c7 04 24 60 73 10 80 	movl   $0x80107360,(%esp)
80102d1a:	e8 11 d6 ff ff       	call   80100330 <panic>
80102d1f:	90                   	nop

80102d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d27:	a1 28 12 11 80       	mov    0x80111228,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d2f:	83 f8 1d             	cmp    $0x1d,%eax
80102d32:	0f 8f 98 00 00 00    	jg     80102dd0 <log_write+0xb0>
80102d38:	8b 0d 18 12 11 80    	mov    0x80111218,%ecx
80102d3e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d41:	39 d0                	cmp    %edx,%eax
80102d43:	0f 8d 87 00 00 00    	jge    80102dd0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d49:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	0f 8e 86 00 00 00    	jle    80102ddc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d56:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102d5d:	e8 1e 15 00 00       	call   80104280 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d62:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102d68:	83 fa 00             	cmp    $0x0,%edx
80102d6b:	7e 54                	jle    80102dc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d6d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d70:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d72:	39 0d 2c 12 11 80    	cmp    %ecx,0x8011122c
80102d78:	75 0f                	jne    80102d89 <log_write+0x69>
80102d7a:	eb 3c                	jmp    80102db8 <log_write+0x98>
80102d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d80:	39 0c 85 2c 12 11 80 	cmp    %ecx,-0x7feeedd4(,%eax,4)
80102d87:	74 2f                	je     80102db8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	39 d0                	cmp    %edx,%eax
80102d8e:	75 f0                	jne    80102d80 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d90:	89 0c 95 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d97:	83 c2 01             	add    $0x1,%edx
80102d9a:	89 15 28 12 11 80    	mov    %edx,0x80111228
  b->flags |= B_DIRTY; // prevent eviction
80102da0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102da3:	c7 45 08 e0 11 11 80 	movl   $0x801111e0,0x8(%ebp)
}
80102daa:	83 c4 14             	add    $0x14,%esp
80102dad:	5b                   	pop    %ebx
80102dae:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102daf:	e9 fc 15 00 00       	jmp    801043b0 <release>
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db8:	89 0c 85 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%eax,4)
80102dbf:	eb df                	jmp    80102da0 <log_write+0x80>
80102dc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dc4:	a3 2c 12 11 80       	mov    %eax,0x8011122c
  if (i == log.lh.n)
80102dc9:	75 d5                	jne    80102da0 <log_write+0x80>
80102dcb:	eb ca                	jmp    80102d97 <log_write+0x77>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dd0:	c7 04 24 6f 73 10 80 	movl   $0x8010736f,(%esp)
80102dd7:	e8 54 d5 ff ff       	call   80100330 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ddc:	c7 04 24 85 73 10 80 	movl   $0x80107385,(%esp)
80102de3:	e8 48 d5 ff ff       	call   80100330 <panic>
80102de8:	66 90                	xchg   %ax,%ax
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102df6:	e8 55 f9 ff ff       	call   80102750 <cpunum>
80102dfb:	c7 04 24 a0 73 10 80 	movl   $0x801073a0,(%esp)
80102e02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e06:	e8 15 d8 ff ff       	call   80100620 <cprintf>
  idtinit();       // load idt register
80102e0b:	e8 00 29 00 00       	call   80105710 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e10:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e17:	b8 01 00 00 00       	mov    $0x1,%eax
80102e1c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e23:	e8 c8 0b 00 00       	call   801039f0 <scheduler>
80102e28:	90                   	nop
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e30 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e36:	e8 c5 3a 00 00       	call   80106900 <switchkvm>
  seginit();
80102e3b:	e8 e0 38 00 00       	call   80106720 <seginit>
  lapicinit();
80102e40:	e8 1b f8 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102e45:	e8 a6 ff ff ff       	call   80102df0 <mpmain>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 e4 f0             	and    $0xfffffff0,%esp
80102e57:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e5a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e61:	80 
80102e62:	c7 04 24 68 40 11 80 	movl   $0x80114068,(%esp)
80102e69:	e8 62 f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e6e:	e8 6d 3a 00 00       	call   801068e0 <kvmalloc>
  mpinit();        // detect other processors
80102e73:	e8 a8 01 00 00       	call   80103020 <mpinit>
  lapicinit();     // interrupt controller
80102e78:	e8 e3 f7 ff ff       	call   80102660 <lapicinit>
80102e7d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102e80:	e8 9b 38 00 00       	call   80106720 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102e85:	e8 c6 f8 ff ff       	call   80102750 <cpunum>
80102e8a:	c7 04 24 b1 73 10 80 	movl   $0x801073b1,(%esp)
80102e91:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e95:	e8 86 d7 ff ff       	call   80100620 <cprintf>
  picinit();       // another interrupt controller
80102e9a:	e8 81 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102e9f:	e8 4c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ea4:	e8 77 da ff ff       	call   80100920 <consoleinit>
  uartinit();      // serial port
80102ea9:	e8 82 2b 00 00       	call   80105a30 <uartinit>
80102eae:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102eb0:	e8 6b 08 00 00       	call   80103720 <pinit>
  tvinit();        // trap vectors
80102eb5:	e8 b6 27 00 00       	call   80105670 <tvinit>
  binit();         // buffer cache
80102eba:	e8 81 d1 ff ff       	call   80100040 <binit>
80102ebf:	90                   	nop
  fileinit();      // file table
80102ec0:	e8 4b de ff ff       	call   80100d10 <fileinit>
  ideinit();       // disk
80102ec5:	e8 16 f1 ff ff       	call   80101fe0 <ideinit>
  if(!ismp)
80102eca:	a1 c4 12 11 80       	mov    0x801112c4,%eax
80102ecf:	85 c0                	test   %eax,%eax
80102ed1:	0f 84 ca 00 00 00    	je     80102fa1 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ed7:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102ede:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102edf:	bb e0 12 11 80       	mov    $0x801112e0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ee4:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102eeb:	80 
80102eec:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ef3:	e8 a8 15 00 00       	call   801044a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ef8:	69 05 c0 18 11 80 bc 	imul   $0xbc,0x801118c0,%eax
80102eff:	00 00 00 
80102f02:	05 e0 12 11 80       	add    $0x801112e0,%eax
80102f07:	39 d8                	cmp    %ebx,%eax
80102f09:	76 78                	jbe    80102f83 <main+0x133>
80102f0b:	90                   	nop
80102f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f10:	e8 3b f8 ff ff       	call   80102750 <cpunum>
80102f15:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f1b:	05 e0 12 11 80       	add    $0x801112e0,%eax
80102f20:	39 c3                	cmp    %eax,%ebx
80102f22:	74 46                	je     80102f6a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f24:	e8 67 f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f29:	c7 05 f8 6f 00 80 30 	movl   $0x80102e30,0x80006ff8
80102f30:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f33:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f3a:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f3d:	05 00 10 00 00       	add    $0x1000,%eax
80102f42:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f47:	0f b6 03             	movzbl (%ebx),%eax
80102f4a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f51:	00 
80102f52:	89 04 24             	mov    %eax,(%esp)
80102f55:	e8 c6 f8 ff ff       	call   80102820 <lapicstartap>
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f60:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102f66:	85 c0                	test   %eax,%eax
80102f68:	74 f6                	je     80102f60 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f6a:	69 05 c0 18 11 80 bc 	imul   $0xbc,0x801118c0,%eax
80102f71:	00 00 00 
80102f74:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102f7a:	05 e0 12 11 80       	add    $0x801112e0,%eax
80102f7f:	39 c3                	cmp    %eax,%ebx
80102f81:	72 8d                	jb     80102f10 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f83:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f8a:	8e 
80102f8b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f92:	e8 a9 f4 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102f97:	e8 a4 07 00 00       	call   80103740 <userinit>
  mpmain();        // finish this processor's setup
80102f9c:	e8 4f fe ff ff       	call   80102df0 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102fa1:	e8 6a 26 00 00       	call   80105610 <timerinit>
80102fa6:	e9 2c ff ff ff       	jmp    80102ed7 <main+0x87>
80102fab:	66 90                	xchg   %ax,%ax
80102fad:	66 90                	xchg   %ax,%ax
80102faf:	90                   	nop

80102fb0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fb4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fba:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fbb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fbe:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fc1:	39 de                	cmp    %ebx,%esi
80102fc3:	73 3c                	jae    80103001 <mpsearch1+0x51>
80102fc5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fcf:	00 
80102fd0:	c7 44 24 04 c8 73 10 	movl   $0x801073c8,0x4(%esp)
80102fd7:	80 
80102fd8:	89 34 24             	mov    %esi,(%esp)
80102fdb:	e8 70 14 00 00       	call   80104450 <memcmp>
80102fe0:	85 c0                	test   %eax,%eax
80102fe2:	75 16                	jne    80102ffa <mpsearch1+0x4a>
80102fe4:	31 c9                	xor    %ecx,%ecx
80102fe6:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fe8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fec:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102fef:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102ff1:	83 fa 10             	cmp    $0x10,%edx
80102ff4:	75 f2                	jne    80102fe8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff6:	84 c9                	test   %cl,%cl
80102ff8:	74 10                	je     8010300a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102ffa:	83 c6 10             	add    $0x10,%esi
80102ffd:	39 f3                	cmp    %esi,%ebx
80102fff:	77 c7                	ja     80102fc8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103001:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103004:	31 c0                	xor    %eax,%eax
}
80103006:	5b                   	pop    %ebx
80103007:	5e                   	pop    %esi
80103008:	5d                   	pop    %ebp
80103009:	c3                   	ret    
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	89 f0                	mov    %esi,%eax
8010300f:	5b                   	pop    %ebx
80103010:	5e                   	pop    %esi
80103011:	5d                   	pop    %ebp
80103012:	c3                   	ret    
80103013:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103020 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	57                   	push   %edi
80103024:	56                   	push   %esi
80103025:	53                   	push   %ebx
80103026:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103029:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103030:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103037:	c1 e0 08             	shl    $0x8,%eax
8010303a:	09 d0                	or     %edx,%eax
8010303c:	c1 e0 04             	shl    $0x4,%eax
8010303f:	85 c0                	test   %eax,%eax
80103041:	75 1b                	jne    8010305e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103043:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010304a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103051:	c1 e0 08             	shl    $0x8,%eax
80103054:	09 d0                	or     %edx,%eax
80103056:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103059:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010305e:	ba 00 04 00 00       	mov    $0x400,%edx
80103063:	e8 48 ff ff ff       	call   80102fb0 <mpsearch1>
80103068:	85 c0                	test   %eax,%eax
8010306a:	89 c7                	mov    %eax,%edi
8010306c:	0f 84 4e 01 00 00    	je     801031c0 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103072:	8b 77 04             	mov    0x4(%edi),%esi
80103075:	85 f6                	test   %esi,%esi
80103077:	0f 84 ce 00 00 00    	je     8010314b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010307d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103083:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010308a:	00 
8010308b:	c7 44 24 04 cd 73 10 	movl   $0x801073cd,0x4(%esp)
80103092:	80 
80103093:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103096:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103099:	e8 b2 13 00 00       	call   80104450 <memcmp>
8010309e:	85 c0                	test   %eax,%eax
801030a0:	0f 85 a5 00 00 00    	jne    8010314b <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030a6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801030ad:	3c 04                	cmp    $0x4,%al
801030af:	0f 85 29 01 00 00    	jne    801031de <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030b5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030bc:	85 c0                	test   %eax,%eax
801030be:	74 1d                	je     801030dd <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
801030c0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801030c2:	31 d2                	xor    %edx,%edx
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030c8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801030cf:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030d0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030d3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030d5:	39 d0                	cmp    %edx,%eax
801030d7:	7f ef                	jg     801030c8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030d9:	84 c9                	test   %cl,%cl
801030db:	75 6e                	jne    8010314b <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801030e0:	85 db                	test   %ebx,%ebx
801030e2:	74 67                	je     8010314b <mpinit+0x12b>
    return;
  ismp = 1;
801030e4:	c7 05 c4 12 11 80 01 	movl   $0x1,0x801112c4
801030eb:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801030ee:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801030f4:	a3 dc 11 11 80       	mov    %eax,0x801111dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f9:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103100:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103106:	01 d9                	add    %ebx,%ecx
80103108:	39 c8                	cmp    %ecx,%eax
8010310a:	0f 83 90 00 00 00    	jae    801031a0 <mpinit+0x180>
    switch(*p){
80103110:	80 38 04             	cmpb   $0x4,(%eax)
80103113:	77 7b                	ja     80103190 <mpinit+0x170>
80103115:	0f b6 10             	movzbl (%eax),%edx
80103118:	ff 24 95 d4 73 10 80 	jmp    *-0x7fef8c2c(,%edx,4)
8010311f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103120:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103123:	39 c1                	cmp    %eax,%ecx
80103125:	77 e9                	ja     80103110 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103127:	a1 c4 12 11 80       	mov    0x801112c4,%eax
8010312c:	85 c0                	test   %eax,%eax
8010312e:	75 70                	jne    801031a0 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103130:	c7 05 c0 18 11 80 01 	movl   $0x1,0x801118c0
80103137:	00 00 00 
    lapic = 0;
8010313a:	c7 05 dc 11 11 80 00 	movl   $0x0,0x801111dc
80103141:	00 00 00 
    ioapicid = 0;
80103144:	c6 05 c0 12 11 80 00 	movb   $0x0,0x801112c0
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010314b:	83 c4 1c             	add    $0x1c,%esp
8010314e:	5b                   	pop    %ebx
8010314f:	5e                   	pop    %esi
80103150:	5f                   	pop    %edi
80103151:	5d                   	pop    %ebp
80103152:	c3                   	ret    
80103153:	90                   	nop
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103158:	8b 15 c0 18 11 80    	mov    0x801118c0,%edx
8010315e:	83 fa 07             	cmp    $0x7,%edx
80103161:	7f 17                	jg     8010317a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103163:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103167:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
8010316d:	83 05 c0 18 11 80 01 	addl   $0x1,0x801118c0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103174:	88 9a e0 12 11 80    	mov    %bl,-0x7feeed20(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010317a:	83 c0 14             	add    $0x14,%eax
      continue;
8010317d:	eb a4                	jmp    80103123 <mpinit+0x103>
8010317f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103180:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103184:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103187:	88 15 c0 12 11 80    	mov    %dl,0x801112c0
      p += sizeof(struct mpioapic);
      continue;
8010318d:	eb 94                	jmp    80103123 <mpinit+0x103>
8010318f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103190:	c7 05 c4 12 11 80 00 	movl   $0x0,0x801112c4
80103197:	00 00 00 
      break;
8010319a:	eb 87                	jmp    80103123 <mpinit+0x103>
8010319c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801031a0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031a4:	74 a5                	je     8010314b <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a6:	ba 22 00 00 00       	mov    $0x22,%edx
801031ab:	b8 70 00 00 00       	mov    $0x70,%eax
801031b0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b1:	b2 23                	mov    $0x23,%dl
801031b3:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b4:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b7:	ee                   	out    %al,(%dx)
  }
}
801031b8:	83 c4 1c             	add    $0x1c,%esp
801031bb:	5b                   	pop    %ebx
801031bc:	5e                   	pop    %esi
801031bd:	5f                   	pop    %edi
801031be:	5d                   	pop    %ebp
801031bf:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ca:	e8 e1 fd ff ff       	call   80102fb0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031cf:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031d1:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031d3:	0f 85 99 fe ff ff    	jne    80103072 <mpinit+0x52>
801031d9:	e9 6d ff ff ff       	jmp    8010314b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031de:	3c 01                	cmp    $0x1,%al
801031e0:	0f 84 cf fe ff ff    	je     801030b5 <mpinit+0x95>
801031e6:	e9 60 ff ff ff       	jmp    8010314b <mpinit+0x12b>
801031eb:	66 90                	xchg   %ax,%ax
801031ed:	66 90                	xchg   %ax,%ax
801031ef:	90                   	nop

801031f0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801031f0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
801031f1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801031f6:	89 e5                	mov    %esp,%ebp
801031f8:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
801031fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103200:	d3 c0                	rol    %cl,%eax
80103202:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103209:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010320f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103210:	66 c1 e8 08          	shr    $0x8,%ax
80103214:	b2 a1                	mov    $0xa1,%dl
80103216:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103217:	5d                   	pop    %ebp
80103218:	c3                   	ret    
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103220 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	89 e5                	mov    %esp,%ebp
80103228:	57                   	push   %edi
80103229:	56                   	push   %esi
8010322a:	53                   	push   %ebx
8010322b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103230:	89 da                	mov    %ebx,%edx
80103232:	ee                   	out    %al,(%dx)
80103233:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103238:	89 ca                	mov    %ecx,%edx
8010323a:	ee                   	out    %al,(%dx)
8010323b:	bf 11 00 00 00       	mov    $0x11,%edi
80103240:	be 20 00 00 00       	mov    $0x20,%esi
80103245:	89 f8                	mov    %edi,%eax
80103247:	89 f2                	mov    %esi,%edx
80103249:	ee                   	out    %al,(%dx)
8010324a:	b8 20 00 00 00       	mov    $0x20,%eax
8010324f:	89 da                	mov    %ebx,%edx
80103251:	ee                   	out    %al,(%dx)
80103252:	b8 04 00 00 00       	mov    $0x4,%eax
80103257:	ee                   	out    %al,(%dx)
80103258:	b8 03 00 00 00       	mov    $0x3,%eax
8010325d:	ee                   	out    %al,(%dx)
8010325e:	b3 a0                	mov    $0xa0,%bl
80103260:	89 f8                	mov    %edi,%eax
80103262:	89 da                	mov    %ebx,%edx
80103264:	ee                   	out    %al,(%dx)
80103265:	b8 28 00 00 00       	mov    $0x28,%eax
8010326a:	89 ca                	mov    %ecx,%edx
8010326c:	ee                   	out    %al,(%dx)
8010326d:	b8 02 00 00 00       	mov    $0x2,%eax
80103272:	ee                   	out    %al,(%dx)
80103273:	b8 03 00 00 00       	mov    $0x3,%eax
80103278:	ee                   	out    %al,(%dx)
80103279:	bf 68 00 00 00       	mov    $0x68,%edi
8010327e:	89 f2                	mov    %esi,%edx
80103280:	89 f8                	mov    %edi,%eax
80103282:	ee                   	out    %al,(%dx)
80103283:	b9 0a 00 00 00       	mov    $0xa,%ecx
80103288:	89 c8                	mov    %ecx,%eax
8010328a:	ee                   	out    %al,(%dx)
8010328b:	89 f8                	mov    %edi,%eax
8010328d:	89 da                	mov    %ebx,%edx
8010328f:	ee                   	out    %al,(%dx)
80103290:	89 c8                	mov    %ecx,%eax
80103292:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103293:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010329a:	66 83 f8 ff          	cmp    $0xffff,%ax
8010329e:	74 0a                	je     801032aa <picinit+0x8a>
801032a0:	b2 21                	mov    $0x21,%dl
801032a2:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801032a3:	66 c1 e8 08          	shr    $0x8,%ax
801032a7:	b2 a1                	mov    $0xa1,%dl
801032a9:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
801032aa:	5b                   	pop    %ebx
801032ab:	5e                   	pop    %esi
801032ac:	5f                   	pop    %edi
801032ad:	5d                   	pop    %ebp
801032ae:	c3                   	ret    
801032af:	90                   	nop

801032b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
801032b5:	53                   	push   %ebx
801032b6:	83 ec 1c             	sub    $0x1c,%esp
801032b9:	8b 75 08             	mov    0x8(%ebp),%esi
801032bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801032c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032cb:	e8 60 da ff ff       	call   80100d30 <filealloc>
801032d0:	85 c0                	test   %eax,%eax
801032d2:	89 06                	mov    %eax,(%esi)
801032d4:	0f 84 a4 00 00 00    	je     8010337e <pipealloc+0xce>
801032da:	e8 51 da ff ff       	call   80100d30 <filealloc>
801032df:	85 c0                	test   %eax,%eax
801032e1:	89 03                	mov    %eax,(%ebx)
801032e3:	0f 84 87 00 00 00    	je     80103370 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032e9:	e8 a2 f1 ff ff       	call   80102490 <kalloc>
801032ee:	85 c0                	test   %eax,%eax
801032f0:	89 c7                	mov    %eax,%edi
801032f2:	74 7c                	je     80103370 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801032f4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032fb:	00 00 00 
  p->writeopen = 1;
801032fe:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103305:	00 00 00 
  p->nwrite = 0;
80103308:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010330f:	00 00 00 
  p->nread = 0;
80103312:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103319:	00 00 00 
  initlock(&p->lock, "pipe");
8010331c:	89 04 24             	mov    %eax,(%esp)
8010331f:	c7 44 24 04 e8 73 10 	movl   $0x801073e8,0x4(%esp)
80103326:	80 
80103327:	e8 d4 0e 00 00       	call   80104200 <initlock>
  (*f0)->type = FD_PIPE;
8010332c:	8b 06                	mov    (%esi),%eax
8010332e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103334:	8b 06                	mov    (%esi),%eax
80103336:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103345:	8b 03                	mov    (%ebx),%eax
80103347:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010334d:	8b 03                	mov    (%ebx),%eax
8010334f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103353:	8b 03                	mov    (%ebx),%eax
80103355:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103359:	8b 03                	mov    (%ebx),%eax
  return 0;
8010335b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010335d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103360:	83 c4 1c             	add    $0x1c,%esp
80103363:	89 d8                	mov    %ebx,%eax
80103365:	5b                   	pop    %ebx
80103366:	5e                   	pop    %esi
80103367:	5f                   	pop    %edi
80103368:	5d                   	pop    %ebp
80103369:	c3                   	ret    
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103370:	8b 06                	mov    (%esi),%eax
80103372:	85 c0                	test   %eax,%eax
80103374:	74 08                	je     8010337e <pipealloc+0xce>
    fileclose(*f0);
80103376:	89 04 24             	mov    %eax,(%esp)
80103379:	e8 72 da ff ff       	call   80100df0 <fileclose>
  if(*f1)
8010337e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103380:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103385:	85 c0                	test   %eax,%eax
80103387:	74 d7                	je     80103360 <pipealloc+0xb0>
    fileclose(*f1);
80103389:	89 04 24             	mov    %eax,(%esp)
8010338c:	e8 5f da ff ff       	call   80100df0 <fileclose>
  return -1;
}
80103391:	83 c4 1c             	add    $0x1c,%esp
80103394:	89 d8                	mov    %ebx,%eax
80103396:	5b                   	pop    %ebx
80103397:	5e                   	pop    %esi
80103398:	5f                   	pop    %edi
80103399:	5d                   	pop    %ebp
8010339a:	c3                   	ret    
8010339b:	90                   	nop
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	56                   	push   %esi
801033a4:	53                   	push   %ebx
801033a5:	83 ec 10             	sub    $0x10,%esp
801033a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033ae:	89 1c 24             	mov    %ebx,(%esp)
801033b1:	e8 ca 0e 00 00       	call   80104280 <acquire>
  if(writable){
801033b6:	85 f6                	test   %esi,%esi
801033b8:	74 3e                	je     801033f8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ba:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801033c0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033c7:	00 00 00 
    wakeup(&p->nread);
801033ca:	89 04 24             	mov    %eax,(%esp)
801033cd:	e8 7e 0c 00 00       	call   80104050 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033d2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033d8:	85 d2                	test   %edx,%edx
801033da:	75 0a                	jne    801033e6 <pipeclose+0x46>
801033dc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033e2:	85 c0                	test   %eax,%eax
801033e4:	74 32                	je     80103418 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	5b                   	pop    %ebx
801033ed:	5e                   	pop    %esi
801033ee:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ef:	e9 bc 0f 00 00       	jmp    801043b0 <release>
801033f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801033f8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801033fe:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103405:	00 00 00 
    wakeup(&p->nwrite);
80103408:	89 04 24             	mov    %eax,(%esp)
8010340b:	e8 40 0c 00 00       	call   80104050 <wakeup>
80103410:	eb c0                	jmp    801033d2 <pipeclose+0x32>
80103412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103418:	89 1c 24             	mov    %ebx,(%esp)
8010341b:	e8 90 0f 00 00       	call   801043b0 <release>
    kfree((char*)p);
80103420:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103423:	83 c4 10             	add    $0x10,%esp
80103426:	5b                   	pop    %ebx
80103427:	5e                   	pop    %esi
80103428:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103429:	e9 b2 ee ff ff       	jmp    801022e0 <kfree>
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 1c             	sub    $0x1c,%esp
80103439:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010343c:	89 3c 24             	mov    %edi,(%esp)
8010343f:	e8 3c 0e 00 00       	call   80104280 <acquire>
  for(i = 0; i < n; i++){
80103444:	8b 45 10             	mov    0x10(%ebp),%eax
80103447:	85 c0                	test   %eax,%eax
80103449:	0f 8e c2 00 00 00    	jle    80103511 <pipewrite+0xe1>
8010344f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103452:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103458:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
8010345e:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103467:	03 45 10             	add    0x10(%ebp),%eax
8010346a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010346d:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103473:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103479:	39 d1                	cmp    %edx,%ecx
8010347b:	0f 85 c4 00 00 00    	jne    80103545 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
80103481:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103487:	85 d2                	test   %edx,%edx
80103489:	0f 84 a1 00 00 00    	je     80103530 <pipewrite+0x100>
8010348f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103496:	8b 42 24             	mov    0x24(%edx),%eax
80103499:	85 c0                	test   %eax,%eax
8010349b:	74 22                	je     801034bf <pipewrite+0x8f>
8010349d:	e9 8e 00 00 00       	jmp    80103530 <pipewrite+0x100>
801034a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034a8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801034ae:	85 c0                	test   %eax,%eax
801034b0:	74 7e                	je     80103530 <pipewrite+0x100>
801034b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801034b8:	8b 48 24             	mov    0x24(%eax),%ecx
801034bb:	85 c9                	test   %ecx,%ecx
801034bd:	75 71                	jne    80103530 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034bf:	89 34 24             	mov    %esi,(%esp)
801034c2:	e8 89 0b 00 00       	call   80104050 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801034cb:	89 1c 24             	mov    %ebx,(%esp)
801034ce:	e8 dd 09 00 00       	call   80103eb0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d3:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034d9:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801034df:	05 00 02 00 00       	add    $0x200,%eax
801034e4:	39 c2                	cmp    %eax,%edx
801034e6:	74 c0                	je     801034a8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034eb:	8d 4a 01             	lea    0x1(%edx),%ecx
801034ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034f4:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801034fa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801034fe:	0f b6 00             	movzbl (%eax),%eax
80103501:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103508:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010350b:	0f 85 5c ff ff ff    	jne    8010346d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103511:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103517:	89 14 24             	mov    %edx,(%esp)
8010351a:	e8 31 0b 00 00       	call   80104050 <wakeup>
  release(&p->lock);
8010351f:	89 3c 24             	mov    %edi,(%esp)
80103522:	e8 89 0e 00 00       	call   801043b0 <release>
  return n;
80103527:	8b 45 10             	mov    0x10(%ebp),%eax
8010352a:	eb 11                	jmp    8010353d <pipewrite+0x10d>
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103530:	89 3c 24             	mov    %edi,(%esp)
80103533:	e8 78 0e 00 00       	call   801043b0 <release>
        return -1;
80103538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010353d:	83 c4 1c             	add    $0x1c,%esp
80103540:	5b                   	pop    %ebx
80103541:	5e                   	pop    %esi
80103542:	5f                   	pop    %edi
80103543:	5d                   	pop    %ebp
80103544:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103545:	89 ca                	mov    %ecx,%edx
80103547:	eb 9f                	jmp    801034e8 <pipewrite+0xb8>
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103550 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
80103555:	53                   	push   %ebx
80103556:	83 ec 1c             	sub    $0x1c,%esp
80103559:	8b 75 08             	mov    0x8(%ebp),%esi
8010355c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010355f:	89 34 24             	mov    %esi,(%esp)
80103562:	e8 19 0d 00 00       	call   80104280 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103567:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010356d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103573:	75 5b                	jne    801035d0 <piperead+0x80>
80103575:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010357b:	85 db                	test   %ebx,%ebx
8010357d:	74 51                	je     801035d0 <piperead+0x80>
8010357f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103585:	eb 25                	jmp    801035ac <piperead+0x5c>
80103587:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103588:	89 74 24 04          	mov    %esi,0x4(%esp)
8010358c:	89 1c 24             	mov    %ebx,(%esp)
8010358f:	e8 1c 09 00 00       	call   80103eb0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103594:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010359a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035a0:	75 2e                	jne    801035d0 <piperead+0x80>
801035a2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a8:	85 d2                	test   %edx,%edx
801035aa:	74 24                	je     801035d0 <piperead+0x80>
    if(proc->killed){
801035ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035b2:	8b 48 24             	mov    0x24(%eax),%ecx
801035b5:	85 c9                	test   %ecx,%ecx
801035b7:	74 cf                	je     80103588 <piperead+0x38>
      release(&p->lock);
801035b9:	89 34 24             	mov    %esi,(%esp)
801035bc:	e8 ef 0d 00 00       	call   801043b0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c1:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801035c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c9:	5b                   	pop    %ebx
801035ca:	5e                   	pop    %esi
801035cb:	5f                   	pop    %edi
801035cc:	5d                   	pop    %ebp
801035cd:	c3                   	ret    
801035ce:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801035d3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d5:	85 d2                	test   %edx,%edx
801035d7:	7f 2b                	jg     80103604 <piperead+0xb4>
801035d9:	eb 31                	jmp    8010360c <piperead+0xbc>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035e0:	8d 48 01             	lea    0x1(%eax),%ecx
801035e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801035e8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801035ee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801035f3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f6:	83 c3 01             	add    $0x1,%ebx
801035f9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801035fc:	74 0e                	je     8010360c <piperead+0xbc>
    if(p->nread == p->nwrite)
801035fe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103604:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010360a:	75 d4                	jne    801035e0 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103612:	89 04 24             	mov    %eax,(%esp)
80103615:	e8 36 0a 00 00       	call   80104050 <wakeup>
  release(&p->lock);
8010361a:	89 34 24             	mov    %esi,(%esp)
8010361d:	e8 8e 0d 00 00       	call   801043b0 <release>
  return i;
}
80103622:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103625:	89 d8                	mov    %ebx,%eax
}
80103627:	5b                   	pop    %ebx
80103628:	5e                   	pop    %esi
80103629:	5f                   	pop    %edi
8010362a:	5d                   	pop    %ebp
8010362b:	c3                   	ret    
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <allocproc>:
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103634:	bb 14 19 11 80       	mov    $0x80111914,%ebx
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
80103639:	83 ec 14             	sub    $0x14,%esp
8010363c:	eb 0d                	jmp    8010364b <allocproc+0x1b>
8010363e:	66 90                	xchg   %ax,%ax
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103640:	83 c3 7c             	add    $0x7c,%ebx
80103643:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
80103649:	74 6d                	je     801036b8 <allocproc+0x88>
    if(p->state == UNUSED)
8010364b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010364e:	85 c0                	test   %eax,%eax
80103650:	75 ee                	jne    80103640 <allocproc+0x10>
      goto found;
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103652:	a1 08 a0 10 80       	mov    0x8010a008,%eax
    if(p->state == UNUSED)
      goto found;
  return 0;

found:
  p->state = EMBRYO;
80103657:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010365e:	8d 50 01             	lea    0x1(%eax),%edx
80103661:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
80103667:	89 43 10             	mov    %eax,0x10(%ebx)

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010366a:	e8 21 ee ff ff       	call   80102490 <kalloc>
8010366f:	85 c0                	test   %eax,%eax
80103671:	89 43 08             	mov    %eax,0x8(%ebx)
80103674:	74 4a                	je     801036c0 <allocproc+0x90>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103676:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010367c:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103681:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103684:	c7 40 14 60 56 10 80 	movl   $0x80105660,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010368b:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103692:	00 
80103693:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010369a:	00 
8010369b:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010369e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036a1:	e8 5a 0d 00 00       	call   80104400 <memset>
  p->context->eip = (uint)forkret;
801036a6:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036a9:	c7 40 10 d0 36 10 80 	movl   $0x801036d0,0x10(%eax)

  return p;
801036b0:	89 d8                	mov    %ebx,%eax
}
801036b2:	83 c4 14             	add    $0x14,%esp
801036b5:	5b                   	pop    %ebx
801036b6:	5d                   	pop    %ebp
801036b7:	c3                   	ret    
801036b8:	83 c4 14             	add    $0x14,%esp
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  return 0;
801036bb:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801036bd:	5b                   	pop    %ebx
801036be:	5d                   	pop    %ebp
801036bf:	c3                   	ret    
  p->state = EMBRYO;
  p->pid = nextpid++;

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801036c0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036c7:	eb e9                	jmp    801036b2 <allocproc+0x82>
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036d6:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801036dd:	e8 ce 0c 00 00       	call   801043b0 <release>

  if (first) {
801036e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801036e7:	85 c0                	test   %eax,%eax
801036e9:	75 05                	jne    801036f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036eb:	c9                   	leave  
801036ec:	c3                   	ret    
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801036f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801036f7:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
801036fe:	00 00 00 
    iinit(ROOTDEV);
80103701:	e8 2a dd ff ff       	call   80101430 <iinit>
    initlog(ROOTDEV);
80103706:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010370d:	e8 ce f3 ff ff       	call   80102ae0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103712:	c9                   	leave  
80103713:	c3                   	ret    
80103714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010371a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103720 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103726:	c7 44 24 04 ed 73 10 	movl   $0x801073ed,0x4(%esp)
8010372d:	80 
8010372e:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103735:	e8 c6 0a 00 00       	call   80104200 <initlock>
}
8010373a:	c9                   	leave  
8010373b:	c3                   	ret    
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103740 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	53                   	push   %ebx
80103744:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  acquire(&ptable.lock);
80103747:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
8010374e:	e8 2d 0b 00 00       	call   80104280 <acquire>

  p = allocproc();
80103753:	e8 d8 fe ff ff       	call   80103630 <allocproc>
80103758:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010375a:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
8010375f:	e8 fc 30 00 00       	call   80106860 <setupkvm>
80103764:	85 c0                	test   %eax,%eax
80103766:	89 43 04             	mov    %eax,0x4(%ebx)
80103769:	0f 84 c8 00 00 00    	je     80103837 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010376f:	89 04 24             	mov    %eax,(%esp)
80103772:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
80103779:	00 
8010377a:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103781:	80 
80103782:	e8 39 32 00 00       	call   801069c0 <inituvm>
  p->sz = PGSIZE;
80103787:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010378d:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103794:	00 
80103795:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010379c:	00 
8010379d:	8b 43 18             	mov    0x18(%ebx),%eax
801037a0:	89 04 24             	mov    %eax,(%esp)
801037a3:	e8 58 0c 00 00       	call   80104400 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037a8:	8b 43 18             	mov    0x18(%ebx),%eax
801037ab:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037b0:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037b5:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037b9:	8b 43 18             	mov    0x18(%ebx),%eax
801037bc:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037c0:	8b 43 18             	mov    0x18(%ebx),%eax
801037c3:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037c7:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801037cb:	8b 43 18             	mov    0x18(%ebx),%eax
801037ce:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037d2:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037d6:	8b 43 18             	mov    0x18(%ebx),%eax
801037d9:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037e0:	8b 43 18             	mov    0x18(%ebx),%eax
801037e3:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037ea:	8b 43 18             	mov    0x18(%ebx),%eax
801037ed:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801037f4:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037f7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037fe:	00 
801037ff:	c7 44 24 04 0d 74 10 	movl   $0x8010740d,0x4(%esp)
80103806:	80 
80103807:	89 04 24             	mov    %eax,(%esp)
8010380a:	e8 d1 0d 00 00       	call   801045e0 <safestrcpy>
  p->cwd = namei("/");
8010380f:	c7 04 24 16 74 10 80 	movl   $0x80107416,(%esp)
80103816:	e8 c5 e6 ff ff       	call   80101ee0 <namei>

  p->state = RUNNABLE;
8010381b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
80103822:	89 43 68             	mov    %eax,0x68(%ebx)

  p->state = RUNNABLE;

  release(&ptable.lock);
80103825:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
8010382c:	e8 7f 0b 00 00       	call   801043b0 <release>
}
80103831:	83 c4 14             	add    $0x14,%esp
80103834:	5b                   	pop    %ebx
80103835:	5d                   	pop    %ebp
80103836:	c3                   	ret    
  acquire(&ptable.lock);

  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103837:	c7 04 24 f4 73 10 80 	movl   $0x801073f4,(%esp)
8010383e:	e8 ed ca ff ff       	call   80100330 <panic>
80103843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103850 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
80103856:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010385d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
80103860:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103862:	83 f9 00             	cmp    $0x0,%ecx
80103865:	7e 39                	jle    801038a0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103867:	01 c1                	add    %eax,%ecx
80103869:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010386d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103871:	8b 42 04             	mov    0x4(%edx),%eax
80103874:	89 04 24             	mov    %eax,(%esp)
80103877:	e8 84 32 00 00       	call   80106b00 <allocuvm>
8010387c:	85 c0                	test   %eax,%eax
8010387e:	74 40                	je     801038c0 <growproc+0x70>
80103880:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103887:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103889:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010388f:	89 04 24             	mov    %eax,(%esp)
80103892:	e8 89 30 00 00       	call   80106920 <switchuvm>
  return 0;
80103897:	31 c0                	xor    %eax,%eax
}
80103899:	c9                   	leave  
8010389a:	c3                   	ret    
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038a0:	74 e5                	je     80103887 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801038a2:	01 c1                	add    %eax,%ecx
801038a4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801038a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801038ac:	8b 42 04             	mov    0x4(%edx),%eax
801038af:	89 04 24             	mov    %eax,(%esp)
801038b2:	e8 39 33 00 00       	call   80106bf0 <deallocuvm>
801038b7:	85 c0                	test   %eax,%eax
801038b9:	75 c5                	jne    80103880 <growproc+0x30>
801038bb:	90                   	nop
801038bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
801038c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
801038c5:	c9                   	leave  
801038c6:	c3                   	ret    
801038c7:	89 f6                	mov    %esi,%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  acquire(&ptable.lock);
801038d9:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801038e0:	e8 9b 09 00 00       	call   80104280 <acquire>

  // Allocate process.
  if((np = allocproc()) == 0){
801038e5:	e8 46 fd ff ff       	call   80103630 <allocproc>
801038ea:	85 c0                	test   %eax,%eax
801038ec:	89 c3                	mov    %eax,%ebx
801038ee:	0f 84 e6 00 00 00    	je     801039da <fork+0x10a>
    release(&ptable.lock);
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801038f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801038fa:	8b 10                	mov    (%eax),%edx
801038fc:	89 54 24 04          	mov    %edx,0x4(%esp)
80103900:	8b 40 04             	mov    0x4(%eax),%eax
80103903:	89 04 24             	mov    %eax,(%esp)
80103906:	e8 b5 33 00 00       	call   80106cc0 <copyuvm>
8010390b:	85 c0                	test   %eax,%eax
8010390d:	89 43 04             	mov    %eax,0x4(%ebx)
80103910:	0f 84 ab 00 00 00    	je     801039c1 <fork+0xf1>
    np->kstack = 0;
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  np->sz = proc->sz;
80103916:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
8010391c:	b9 13 00 00 00       	mov    $0x13,%ecx
80103921:	8b 7b 18             	mov    0x18(%ebx),%edi
    np->kstack = 0;
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  np->sz = proc->sz;
80103924:	8b 00                	mov    (%eax),%eax
80103926:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103928:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010392e:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103931:	8b 70 18             	mov    0x18(%eax),%esi
80103934:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103936:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103938:	8b 43 18             	mov    0x18(%ebx),%eax
8010393b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103942:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103950:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103954:	85 c0                	test   %eax,%eax
80103956:	74 13                	je     8010396b <fork+0x9b>
      np->ofile[i] = filedup(proc->ofile[i]);
80103958:	89 04 24             	mov    %eax,(%esp)
8010395b:	e8 40 d4 ff ff       	call   80100da0 <filedup>
80103960:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103964:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010396b:	83 c6 01             	add    $0x1,%esi
8010396e:	83 fe 10             	cmp    $0x10,%esi
80103971:	75 dd                	jne    80103950 <fork+0x80>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103973:	8b 42 68             	mov    0x68(%edx),%eax
80103976:	89 04 24             	mov    %eax,(%esp)
80103979:	e8 92 dc ff ff       	call   80101610 <idup>
8010397e:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103981:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103987:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010398e:	00 
8010398f:	83 c0 6c             	add    $0x6c,%eax
80103992:	89 44 24 04          	mov    %eax,0x4(%esp)
80103996:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103999:	89 04 24             	mov    %eax,(%esp)
8010399c:	e8 3f 0c 00 00       	call   801045e0 <safestrcpy>

  pid = np->pid;
801039a1:	8b 73 10             	mov    0x10(%ebx),%esi

  np->state = RUNNABLE;
801039a4:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801039ab:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801039b2:	e8 f9 09 00 00       	call   801043b0 <release>

  return pid;
801039b7:	89 f0                	mov    %esi,%eax
}
801039b9:	83 c4 1c             	add    $0x1c,%esp
801039bc:	5b                   	pop    %ebx
801039bd:	5e                   	pop    %esi
801039be:	5f                   	pop    %edi
801039bf:	5d                   	pop    %ebp
801039c0:	c3                   	ret    
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
801039c1:	8b 43 08             	mov    0x8(%ebx),%eax
801039c4:	89 04 24             	mov    %eax,(%esp)
801039c7:	e8 14 e9 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
801039cc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801039d3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    release(&ptable.lock);
801039da:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801039e1:	e8 ca 09 00 00       	call   801043b0 <release>
    return -1;
801039e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039eb:	eb cc                	jmp    801039b9 <fork+0xe9>
801039ed:	8d 76 00             	lea    0x0(%esi),%esi

801039f0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	53                   	push   %ebx
801039f4:	83 ec 14             	sub    $0x14,%esp
801039f7:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
801039f8:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039f9:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a00:	bb 14 19 11 80       	mov    $0x80111914,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a05:	e8 76 08 00 00       	call   80104280 <acquire>
80103a0a:	eb 0f                	jmp    80103a1b <scheduler+0x2b>
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a10:	83 c3 7c             	add    $0x7c,%ebx
80103a13:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
80103a19:	74 55                	je     80103a70 <scheduler+0x80>
      if(p->state != RUNNABLE)
80103a1b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a1f:	75 ef                	jne    80103a10 <scheduler+0x20>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103a21:	89 1c 24             	mov    %ebx,(%esp)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103a24:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a2b:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103a2e:	e8 ed 2e 00 00       	call   80106920 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103a33:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a36:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&cpu->scheduler, p->context);
80103a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a41:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a47:	83 c0 04             	add    $0x4,%eax
80103a4a:	89 04 24             	mov    %eax,(%esp)
80103a4d:	e8 ea 0b 00 00       	call   8010463c <swtch>
      switchkvm();
80103a52:	e8 a9 2e 00 00       	call   80106900 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a57:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103a5d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103a64:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a68:	75 b1                	jne    80103a1b <scheduler+0x2b>
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103a70:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103a77:	e8 34 09 00 00       	call   801043b0 <release>

  }
80103a7c:	e9 77 ff ff ff       	jmp    801039f8 <scheduler+0x8>
80103a81:	eb 0d                	jmp    80103a90 <wakeall>
80103a83:	90                   	nop
80103a84:	90                   	nop
80103a85:	90                   	nop
80103a86:	90                   	nop
80103a87:	90                   	nop
80103a88:	90                   	nop
80103a89:	90                   	nop
80103a8a:	90                   	nop
80103a8b:	90                   	nop
80103a8c:	90                   	nop
80103a8d:	90                   	nop
80103a8e:	90                   	nop
80103a8f:	90                   	nop

80103a90 <wakeall>:
}


int wakeall(void)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
 struct proc *p;
 int sleeptowakeNUM=0;
80103a94:	31 db                	xor    %ebx,%ebx
  }
}


int wakeall(void)
{
80103a96:	83 ec 14             	sub    $0x14,%esp
 struct proc *p;
 int sleeptowakeNUM=0;
 acquire(&ptable.lock);
80103a99:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103aa0:	e8 db 07 00 00       	call   80104280 <acquire>
 for(p = ptable.proc; p<&ptable.proc[NPROC];p++) {
80103aa5:	ba 14 19 11 80       	mov    $0x80111914,%edx
80103aaa:	eb 0f                	jmp    80103abb <wakeall+0x2b>
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ab0:	83 c2 7c             	add    $0x7c,%edx
80103ab3:	81 fa 14 38 11 80    	cmp    $0x80113814,%edx
80103ab9:	74 1b                	je     80103ad6 <wakeall+0x46>
   if(p->state == SLEEPING){
80103abb:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103abf:	75 ef                	jne    80103ab0 <wakeall+0x20>
   sleeptowakeNUM++; 
   p->state = RUNNABLE;
80103ac1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
int wakeall(void)
{
 struct proc *p;
 int sleeptowakeNUM=0;
 acquire(&ptable.lock);
 for(p = ptable.proc; p<&ptable.proc[NPROC];p++) {
80103ac8:	83 c2 7c             	add    $0x7c,%edx
   if(p->state == SLEEPING){
   sleeptowakeNUM++; 
80103acb:	83 c3 01             	add    $0x1,%ebx
int wakeall(void)
{
 struct proc *p;
 int sleeptowakeNUM=0;
 acquire(&ptable.lock);
 for(p = ptable.proc; p<&ptable.proc[NPROC];p++) {
80103ace:	81 fa 14 38 11 80    	cmp    $0x80113814,%edx
80103ad4:	75 e5                	jne    80103abb <wakeall+0x2b>
   if(p->state == SLEEPING){
   sleeptowakeNUM++; 
   p->state = RUNNABLE;
   }
 }
 release(&ptable.lock);
80103ad6:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103add:	e8 ce 08 00 00       	call   801043b0 <release>
 return sleeptowakeNUM;
}
80103ae2:	83 c4 14             	add    $0x14,%esp
80103ae5:	89 d8                	mov    %ebx,%eax
80103ae7:	5b                   	pop    %ebx
80103ae8:	5d                   	pop    %ebp
80103ae9:	c3                   	ret    
80103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103af0 <translate>:

//Translate syscall_____YZ____

int translate(void* vaddr,int procpid)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	57                   	push   %edi
80103af4:	56                   	push   %esi
 struct proc *p; 
 pte_t *pgtab;
 pde_t *pde;
 pte_t *pte;
 int paddr = 0;
 pde_t *pgdir = (void*)0;
80103af5:	31 f6                	xor    %esi,%esi
}

//Translate syscall_____YZ____

int translate(void* vaddr,int procpid)
{
80103af7:	53                   	push   %ebx
 pte_t *pte;
 int paddr = 0;
 pde_t *pgdir = (void*)0;
 cprintf("vaddr = %p\n",vaddr);
 acquire(&ptable.lock);
 for(p = ptable.proc; p<&ptable.proc[NPROC];p++){
80103af8:	bb 14 19 11 80       	mov    $0x80111914,%ebx
}

//Translate syscall_____YZ____

int translate(void* vaddr,int procpid)
{
80103afd:	83 ec 1c             	sub    $0x1c,%esp
 pte_t *pgtab;
 pde_t *pde;
 pte_t *pte;
 int paddr = 0;
 pde_t *pgdir = (void*)0;
 cprintf("vaddr = %p\n",vaddr);
80103b00:	8b 45 08             	mov    0x8(%ebp),%eax
80103b03:	c7 04 24 18 74 10 80 	movl   $0x80107418,(%esp)
}

//Translate syscall_____YZ____

int translate(void* vaddr,int procpid)
{
80103b0a:	8b 7d 0c             	mov    0xc(%ebp),%edi
 pte_t *pgtab;
 pde_t *pde;
 pte_t *pte;
 int paddr = 0;
 pde_t *pgdir = (void*)0;
 cprintf("vaddr = %p\n",vaddr);
80103b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b11:	e8 0a cb ff ff       	call   80100620 <cprintf>
 acquire(&ptable.lock);
80103b16:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103b1d:	e8 5e 07 00 00       	call   80104280 <acquire>
80103b22:	eb 0f                	jmp    80103b33 <translate+0x43>
80103b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 for(p = ptable.proc; p<&ptable.proc[NPROC];p++){
80103b28:	83 c3 7c             	add    $0x7c,%ebx
80103b2b:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
80103b31:	74 25                	je     80103b58 <translate+0x68>
  if(p->pid == procpid){
80103b33:	39 7b 10             	cmp    %edi,0x10(%ebx)
80103b36:	75 f0                	jne    80103b28 <translate+0x38>
   pgdir = p->pgdir; 
80103b38:	8b 73 04             	mov    0x4(%ebx),%esi
 pte_t *pte;
 int paddr = 0;
 pde_t *pgdir = (void*)0;
 cprintf("vaddr = %p\n",vaddr);
 acquire(&ptable.lock);
 for(p = ptable.proc; p<&ptable.proc[NPROC];p++){
80103b3b:	83 c3 7c             	add    $0x7c,%ebx
  if(p->pid == procpid){
   pgdir = p->pgdir; 
   cprintf("in proc.c the pid is: %d\n",p->pid); 
80103b3e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80103b42:	c7 04 24 24 74 10 80 	movl   $0x80107424,(%esp)
80103b49:	e8 d2 ca ff ff       	call   80100620 <cprintf>
 pte_t *pte;
 int paddr = 0;
 pde_t *pgdir = (void*)0;
 cprintf("vaddr = %p\n",vaddr);
 acquire(&ptable.lock);
 for(p = ptable.proc; p<&ptable.proc[NPROC];p++){
80103b4e:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
80103b54:	75 dd                	jne    80103b33 <translate+0x43>
80103b56:	66 90                	xchg   %ax,%ax
 // int map_err = mappages(pgdir, ptr, sizeof(ptr), paddr, PTE_U|PTE_P);
 // if(map_err<0){
  
 //pgdir = cpu->ts.cr3;
// cprintf("get pgdir!!!!!!!!!!!!!!!\n");
 cprintf("page directory base is: %p\n",pgdir);
80103b58:	89 74 24 04          	mov    %esi,0x4(%esp)
80103b5c:	c7 04 24 3e 74 10 80 	movl   $0x8010743e,(%esp)
80103b63:	e8 b8 ca ff ff       	call   80100620 <cprintf>
 pde = &pgdir[PDX(vaddr)];
80103b68:	8b 45 08             	mov    0x8(%ebp),%eax
80103b6b:	c1 e8 16             	shr    $0x16,%eax
// cprintf("get pde!!!!!!!!!!!!!!!\n");
 if((*pde & PTE_P)&&(*pde & PTE_U)){
80103b6e:	8b 1c 86             	mov    (%esi,%eax,4),%ebx
80103b71:	89 d8                	mov    %ebx,%eax
80103b73:	83 e0 05             	and    $0x5,%eax
80103b76:	83 f8 05             	cmp    $0x5,%eax
80103b79:	0f 85 89 00 00 00    	jne    80103c08 <translate+0x118>
 pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
 cprintf("get pgtab!!!!!!!!!!!!!\n");
80103b7f:	c7 04 24 5a 74 10 80 	movl   $0x8010745a,(%esp)
// cprintf("get pgdir!!!!!!!!!!!!!!!\n");
 cprintf("page directory base is: %p\n",pgdir);
 pde = &pgdir[PDX(vaddr)];
// cprintf("get pde!!!!!!!!!!!!!!!\n");
 if((*pde & PTE_P)&&(*pde & PTE_U)){
 pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80103b86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
 cprintf("get pgtab!!!!!!!!!!!!!\n");
80103b8c:	e8 8f ca ff ff       	call   80100620 <cprintf>
 cprintf("pde = %d\n",*pde);
 cprintf("PTE_P = %d\n",PTE_P);
 cprintf("pte not present\n");
 return -1;
 }
 pte = &pgtab[PTX(vaddr)];
80103b91:	8b 45 08             	mov    0x8(%ebp),%eax
80103b94:	c1 e8 0c             	shr    $0xc,%eax
80103b97:	25 ff 03 00 00       	and    $0x3ff,%eax
// cprintf("get pte!!!!!!!!!!!!!\n");
 if((*pte & PTE_U)&&(*pte & PTE_P)){
80103b9c:	8b 84 83 00 00 00 80 	mov    -0x80000000(%ebx,%eax,4),%eax
80103ba3:	89 c2                	mov    %eax,%edx
80103ba5:	83 e2 05             	and    $0x5,%edx
80103ba8:	83 fa 05             	cmp    $0x5,%edx
80103bab:	74 46                	je     80103bf3 <translate+0x103>

 struct proc *p; 
 pte_t *pgtab;
 pde_t *pde;
 pte_t *pte;
 int paddr = 0;
80103bad:	31 f6                	xor    %esi,%esi
// cprintf("get pte!!!!!!!!!!!!!\n");
 if((*pte & PTE_U)&&(*pte & PTE_P)){
 paddr = PTE_ADDR(*pte); 
 cprintf("get paddr!!!!!!!!!!!!!\n");
  }
  int poffset = (uint)vaddr & 0xfff;
80103baf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  paddr = paddr | poffset;
  cprintf("the virtual address is %p\n",vaddr);
80103bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb5:	c7 04 24 b1 74 10 80 	movl   $0x801074b1,(%esp)
// cprintf("get pte!!!!!!!!!!!!!\n");
 if((*pte & PTE_U)&&(*pte & PTE_P)){
 paddr = PTE_ADDR(*pte); 
 cprintf("get paddr!!!!!!!!!!!!!\n");
  }
  int poffset = (uint)vaddr & 0xfff;
80103bbc:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  paddr = paddr | poffset;
  cprintf("the virtual address is %p\n",vaddr);
80103bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
 if((*pte & PTE_U)&&(*pte & PTE_P)){
 paddr = PTE_ADDR(*pte); 
 cprintf("get paddr!!!!!!!!!!!!!\n");
  }
  int poffset = (uint)vaddr & 0xfff;
  paddr = paddr | poffset;
80103bc6:	09 f3                	or     %esi,%ebx
  cprintf("the virtual address is %p\n",vaddr);
80103bc8:	e8 53 ca ff ff       	call   80100620 <cprintf>
  cprintf("the physical address is %d\n",paddr);
80103bcd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103bd1:	c7 04 24 cc 74 10 80 	movl   $0x801074cc,(%esp)
80103bd8:	e8 43 ca ff ff       	call   80100620 <cprintf>
 // }else{
 // cprintf("the paddr of the pointer is %d\n",paddr);
 // }
 release(&ptable.lock);
80103bdd:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103be4:	e8 c7 07 00 00       	call   801043b0 <release>
  return 0;

}
80103be9:	83 c4 1c             	add    $0x1c,%esp
  cprintf("the physical address is %d\n",paddr);
 // }else{
 // cprintf("the paddr of the pointer is %d\n",paddr);
 // }
 release(&ptable.lock);
  return 0;
80103bec:	31 c0                	xor    %eax,%eax

}
80103bee:	5b                   	pop    %ebx
80103bef:	5e                   	pop    %esi
80103bf0:	5f                   	pop    %edi
80103bf1:	5d                   	pop    %ebp
80103bf2:	c3                   	ret    
 return -1;
 }
 pte = &pgtab[PTX(vaddr)];
// cprintf("get pte!!!!!!!!!!!!!\n");
 if((*pte & PTE_U)&&(*pte & PTE_P)){
 paddr = PTE_ADDR(*pte); 
80103bf3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
 cprintf("get paddr!!!!!!!!!!!!!\n");
80103bf8:	c7 04 24 99 74 10 80 	movl   $0x80107499,(%esp)
 return -1;
 }
 pte = &pgtab[PTX(vaddr)];
// cprintf("get pte!!!!!!!!!!!!!\n");
 if((*pte & PTE_U)&&(*pte & PTE_P)){
 paddr = PTE_ADDR(*pte); 
80103bff:	89 c6                	mov    %eax,%esi
 cprintf("get paddr!!!!!!!!!!!!!\n");
80103c01:	e8 1a ca ff ff       	call   80100620 <cprintf>
80103c06:	eb a7                	jmp    80103baf <translate+0xbf>
// cprintf("get pde!!!!!!!!!!!!!!!\n");
 if((*pde & PTE_P)&&(*pde & PTE_U)){
 pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
 cprintf("get pgtab!!!!!!!!!!!!!\n");
 }else{
 cprintf("pde = %d\n",*pde);
80103c08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103c0c:	c7 04 24 72 74 10 80 	movl   $0x80107472,(%esp)
80103c13:	e8 08 ca ff ff       	call   80100620 <cprintf>
 cprintf("PTE_P = %d\n",PTE_P);
80103c18:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103c1f:	00 
80103c20:	c7 04 24 7c 74 10 80 	movl   $0x8010747c,(%esp)
80103c27:	e8 f4 c9 ff ff       	call   80100620 <cprintf>
 cprintf("pte not present\n");
80103c2c:	c7 04 24 88 74 10 80 	movl   $0x80107488,(%esp)
80103c33:	e8 e8 c9 ff ff       	call   80100620 <cprintf>
 // cprintf("the paddr of the pointer is %d\n",paddr);
 // }
 release(&ptable.lock);
  return 0;

}
80103c38:	83 c4 1c             	add    $0x1c,%esp
 cprintf("get pgtab!!!!!!!!!!!!!\n");
 }else{
 cprintf("pde = %d\n",*pde);
 cprintf("PTE_P = %d\n",PTE_P);
 cprintf("pte not present\n");
 return -1;
80103c3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 // cprintf("the paddr of the pointer is %d\n",paddr);
 // }
 release(&ptable.lock);
  return 0;

}
80103c40:	5b                   	pop    %ebx
80103c41:	5e                   	pop    %esi
80103c42:	5f                   	pop    %edi
80103c43:	5d                   	pop    %ebp
80103c44:	c3                   	ret    
80103c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c50 <runnable>:


//Runnable syscall_____YZ____

int runnable(void)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	53                   	push   %ebx
  struct proc *p;
  int runbleNUM = 0;
80103c54:	31 db                	xor    %ebx,%ebx


//Runnable syscall_____YZ____

int runnable(void)
{
80103c56:	83 ec 14             	sub    $0x14,%esp
   // //  p->state = RUNNABLE;
   //   }
   // }
   // release(&ptable.lock);

    acquire(&ptable.lock);
80103c59:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103c60:	e8 1b 06 00 00       	call   80104280 <acquire>
    for(p = ptable.proc; p< &ptable.proc[NPROC]; p++){
80103c65:	ba 14 19 11 80       	mov    $0x80111914,%edx
80103c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->state == RUNNABLE){
      runbleNUM++;
80103c70:	31 c0                	xor    %eax,%eax
80103c72:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103c76:	0f 94 c0             	sete   %al
   //   }
   // }
   // release(&ptable.lock);

    acquire(&ptable.lock);
    for(p = ptable.proc; p< &ptable.proc[NPROC]; p++){
80103c79:	83 c2 7c             	add    $0x7c,%edx
      if(p->state == RUNNABLE){
      runbleNUM++;
80103c7c:	01 c3                	add    %eax,%ebx
   //   }
   // }
   // release(&ptable.lock);

    acquire(&ptable.lock);
    for(p = ptable.proc; p< &ptable.proc[NPROC]; p++){
80103c7e:	81 fa 14 38 11 80    	cmp    $0x80113814,%edx
80103c84:	75 ea                	jne    80103c70 <runnable+0x20>
      runningNUM++;
      }else if(p->state == ZOMBIE){
      zombieNUM++;
      }
    }
    release(&ptable.lock);
80103c86:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103c8d:	e8 1e 07 00 00       	call   801043b0 <release>
  //cprintf("There are %d process sleeping\n",sleepNUM);
  //cprintf("There are %d process unused\n",unusedNUM);
  //cprintf("There are %d process zombie\n",zombieNUM);
  //cprintf("-------------Scan finished------------\n");
  return runbleNUM;
}
80103c92:	83 c4 14             	add    $0x14,%esp
80103c95:	89 d8                	mov    %ebx,%eax
80103c97:	5b                   	pop    %ebx
80103c98:	5d                   	pop    %ebp
80103c99:	c3                   	ret    
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ca0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	53                   	push   %ebx
80103ca4:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80103ca7:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103cae:	e8 5d 06 00 00       	call   80104310 <holding>
80103cb3:	85 c0                	test   %eax,%eax
80103cb5:	74 4d                	je     80103d04 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103cb7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103cbd:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103cc4:	75 62                	jne    80103d28 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
80103cc6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103ccd:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103cd1:	74 49                	je     80103d1c <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cd3:	9c                   	pushf  
80103cd4:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103cd5:	80 e5 02             	and    $0x2,%ch
80103cd8:	75 36                	jne    80103d10 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
80103cda:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
80103ce0:	83 c2 1c             	add    $0x1c,%edx
80103ce3:	8b 40 04             	mov    0x4(%eax),%eax
80103ce6:	89 14 24             	mov    %edx,(%esp)
80103ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ced:	e8 4a 09 00 00       	call   8010463c <swtch>
  cpu->intena = intena;
80103cf2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103cf8:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103cfe:	83 c4 14             	add    $0x14,%esp
80103d01:	5b                   	pop    %ebx
80103d02:	5d                   	pop    %ebp
80103d03:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103d04:	c7 04 24 e8 74 10 80 	movl   $0x801074e8,(%esp)
80103d0b:	e8 20 c6 ff ff       	call   80100330 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103d10:	c7 04 24 14 75 10 80 	movl   $0x80107514,(%esp)
80103d17:	e8 14 c6 ff ff       	call   80100330 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103d1c:	c7 04 24 06 75 10 80 	movl   $0x80107506,(%esp)
80103d23:	e8 08 c6 ff ff       	call   80100330 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103d28:	c7 04 24 fa 74 10 80 	movl   $0x801074fa,(%esp)
80103d2f:	e8 fc c5 ff ff       	call   80100330 <panic>
80103d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d40 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103d45:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d47:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80103d4a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103d51:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
80103d57:	0f 84 01 01 00 00    	je     80103e5e <exit+0x11e>
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103d60:	8d 73 08             	lea    0x8(%ebx),%esi
80103d63:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103d67:	85 c0                	test   %eax,%eax
80103d69:	74 17                	je     80103d82 <exit+0x42>
      fileclose(proc->ofile[fd]);
80103d6b:	89 04 24             	mov    %eax,(%esp)
80103d6e:	e8 7d d0 ff ff       	call   80100df0 <fileclose>
      proc->ofile[fd] = 0;
80103d73:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103d7a:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103d81:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103d82:	83 c3 01             	add    $0x1,%ebx
80103d85:	83 fb 10             	cmp    $0x10,%ebx
80103d88:	75 d6                	jne    80103d60 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103d8a:	e8 f1 ed ff ff       	call   80102b80 <begin_op>
  iput(proc->cwd);
80103d8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d95:	8b 40 68             	mov    0x68(%eax),%eax
80103d98:	89 04 24             	mov    %eax,(%esp)
80103d9b:	e8 00 da ff ff       	call   801017a0 <iput>
  end_op();
80103da0:	e8 4b ee ff ff       	call   80102bf0 <end_op>
  proc->cwd = 0;
80103da5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dab:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103db2:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103db9:	e8 c2 04 00 00       	call   80104280 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103dbe:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc5:	b8 14 19 11 80       	mov    $0x80111914,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103dca:	8b 51 14             	mov    0x14(%ecx),%edx
80103dcd:	eb 0b                	jmp    80103dda <exit+0x9a>
80103dcf:	90                   	nop
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd0:	83 c0 7c             	add    $0x7c,%eax
80103dd3:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80103dd8:	74 1c                	je     80103df6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103dda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dde:	75 f0                	jne    80103dd0 <exit+0x90>
80103de0:	3b 50 20             	cmp    0x20(%eax),%edx
80103de3:	75 eb                	jne    80103dd0 <exit+0x90>
      p->state = RUNNABLE;
80103de5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dec:	83 c0 7c             	add    $0x7c,%eax
80103def:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80103df4:	75 e4                	jne    80103dda <exit+0x9a>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103df6:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103dfc:	ba 14 19 11 80       	mov    $0x80111914,%edx
80103e01:	eb 10                	jmp    80103e13 <exit+0xd3>
80103e03:	90                   	nop
80103e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e08:	83 c2 7c             	add    $0x7c,%edx
80103e0b:	81 fa 14 38 11 80    	cmp    $0x80113814,%edx
80103e11:	74 33                	je     80103e46 <exit+0x106>
    if(p->parent == proc){
80103e13:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103e16:	75 f0                	jne    80103e08 <exit+0xc8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103e18:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103e1c:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e1f:	75 e7                	jne    80103e08 <exit+0xc8>
80103e21:	b8 14 19 11 80       	mov    $0x80111914,%eax
80103e26:	eb 0a                	jmp    80103e32 <exit+0xf2>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e28:	83 c0 7c             	add    $0x7c,%eax
80103e2b:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80103e30:	74 d6                	je     80103e08 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103e32:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e36:	75 f0                	jne    80103e28 <exit+0xe8>
80103e38:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e3b:	75 eb                	jne    80103e28 <exit+0xe8>
      p->state = RUNNABLE;
80103e3d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e44:	eb e2                	jmp    80103e28 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103e46:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103e4d:	e8 4e fe ff ff       	call   80103ca0 <sched>
  panic("zombie exit");
80103e52:	c7 04 24 35 75 10 80 	movl   $0x80107535,(%esp)
80103e59:	e8 d2 c4 ff ff       	call   80100330 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103e5e:	c7 04 24 28 75 10 80 	movl   $0x80107528,(%esp)
80103e65:	e8 c6 c4 ff ff       	call   80100330 <panic>
80103e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e70 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e76:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103e7d:	e8 fe 03 00 00       	call   80104280 <acquire>
  proc->state = RUNNABLE;
80103e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e88:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103e8f:	e8 0c fe ff ff       	call   80103ca0 <sched>
  release(&ptable.lock);
80103e94:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103e9b:	e8 10 05 00 00       	call   801043b0 <release>
}
80103ea0:	c9                   	leave  
80103ea1:	c3                   	ret    
80103ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
80103eb5:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80103eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103ebe:	8b 75 08             	mov    0x8(%ebp),%esi
80103ec1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103ec4:	85 c0                	test   %eax,%eax
80103ec6:	0f 84 8b 00 00 00    	je     80103f57 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
80103ecc:	85 db                	test   %ebx,%ebx
80103ece:	74 7b                	je     80103f4b <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ed0:	81 fb e0 18 11 80    	cmp    $0x801118e0,%ebx
80103ed6:	74 50                	je     80103f28 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ed8:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103edf:	e8 9c 03 00 00       	call   80104280 <acquire>
    release(lk);
80103ee4:	89 1c 24             	mov    %ebx,(%esp)
80103ee7:	e8 c4 04 00 00       	call   801043b0 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ef2:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103ef5:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103efc:	e8 9f fd ff ff       	call   80103ca0 <sched>

  // Tidy up.
  proc->chan = 0;
80103f01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f07:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103f0e:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103f15:	e8 96 04 00 00       	call   801043b0 <release>
    acquire(lk);
80103f1a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
80103f1d:	83 c4 10             	add    $0x10,%esp
80103f20:	5b                   	pop    %ebx
80103f21:	5e                   	pop    %esi
80103f22:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103f23:	e9 58 03 00 00       	jmp    80104280 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103f28:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103f2b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103f32:	e8 69 fd ff ff       	call   80103ca0 <sched>

  // Tidy up.
  proc->chan = 0;
80103f37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f3d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103f44:	83 c4 10             	add    $0x10,%esp
80103f47:	5b                   	pop    %ebx
80103f48:	5e                   	pop    %esi
80103f49:	5d                   	pop    %ebp
80103f4a:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103f4b:	c7 04 24 47 75 10 80 	movl   $0x80107547,(%esp)
80103f52:	e8 d9 c3 ff ff       	call   80100330 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103f57:	c7 04 24 41 75 10 80 	movl   $0x80107541,(%esp)
80103f5e:	e8 cd c3 ff ff       	call   80100330 <panic>
80103f63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
80103f75:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103f78:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103f7f:	e8 fc 02 00 00       	call   80104280 <acquire>
80103f84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80103f8a:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f8c:	bb 14 19 11 80       	mov    $0x80111914,%ebx
80103f91:	eb 10                	jmp    80103fa3 <wait+0x33>
80103f93:	90                   	nop
80103f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f98:	83 c3 7c             	add    $0x7c,%ebx
80103f9b:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
80103fa1:	74 1d                	je     80103fc0 <wait+0x50>
      if(p->parent != proc)
80103fa3:	39 43 14             	cmp    %eax,0x14(%ebx)
80103fa6:	75 f0                	jne    80103f98 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103fa8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fac:	74 2f                	je     80103fdd <wait+0x6d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fae:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103fb1:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb6:	81 fb 14 38 11 80    	cmp    $0x80113814,%ebx
80103fbc:	75 e5                	jne    80103fa3 <wait+0x33>
80103fbe:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103fc0:	85 d2                	test   %edx,%edx
80103fc2:	74 6e                	je     80104032 <wait+0xc2>
80103fc4:	8b 50 24             	mov    0x24(%eax),%edx
80103fc7:	85 d2                	test   %edx,%edx
80103fc9:	75 67                	jne    80104032 <wait+0xc2>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103fcb:	c7 44 24 04 e0 18 11 	movl   $0x801118e0,0x4(%esp)
80103fd2:	80 
80103fd3:	89 04 24             	mov    %eax,(%esp)
80103fd6:	e8 d5 fe ff ff       	call   80103eb0 <sleep>
  }
80103fdb:	eb a7                	jmp    80103f84 <wait+0x14>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103fdd:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103fe0:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fe3:	89 04 24             	mov    %eax,(%esp)
80103fe6:	e8 f5 e2 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103feb:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103fee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ff5:	89 04 24             	mov    %eax,(%esp)
80103ff8:	e8 13 2c 00 00       	call   80106c10 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103ffd:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80104004:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010400b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104012:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104016:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010401d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104024:	e8 87 03 00 00       	call   801043b0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104029:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
8010402c:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010402e:	5b                   	pop    %ebx
8010402f:	5e                   	pop    %esi
80104030:	5d                   	pop    %ebp
80104031:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80104032:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80104039:	e8 72 03 00 00       	call   801043b0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010403e:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80104041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104046:	5b                   	pop    %ebx
80104047:	5e                   	pop    %esi
80104048:	5d                   	pop    %ebp
80104049:	c3                   	ret    
8010404a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104050 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 14             	sub    $0x14,%esp
80104057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010405a:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80104061:	e8 1a 02 00 00       	call   80104280 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104066:	b8 14 19 11 80       	mov    $0x80111914,%eax
8010406b:	eb 0d                	jmp    8010407a <wakeup+0x2a>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi
80104070:	83 c0 7c             	add    $0x7c,%eax
80104073:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80104078:	74 1e                	je     80104098 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
8010407a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010407e:	75 f0                	jne    80104070 <wakeup+0x20>
80104080:	3b 58 20             	cmp    0x20(%eax),%ebx
80104083:	75 eb                	jne    80104070 <wakeup+0x20>
      p->state = RUNNABLE;
80104085:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010408c:	83 c0 7c             	add    $0x7c,%eax
8010408f:	3d 14 38 11 80       	cmp    $0x80113814,%eax
80104094:	75 e4                	jne    8010407a <wakeup+0x2a>
80104096:	66 90                	xchg   %ax,%ax
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104098:	c7 45 08 e0 18 11 80 	movl   $0x801118e0,0x8(%ebp)
}
8010409f:	83 c4 14             	add    $0x14,%esp
801040a2:	5b                   	pop    %ebx
801040a3:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801040a4:	e9 07 03 00 00       	jmp    801043b0 <release>
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	53                   	push   %ebx
801040b4:	83 ec 14             	sub    $0x14,%esp
801040b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040ba:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801040c1:	e8 ba 01 00 00       	call   80104280 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c6:	b8 14 19 11 80       	mov    $0x80111914,%eax
801040cb:	eb 0d                	jmp    801040da <kill+0x2a>
801040cd:	8d 76 00             	lea    0x0(%esi),%esi
801040d0:	83 c0 7c             	add    $0x7c,%eax
801040d3:	3d 14 38 11 80       	cmp    $0x80113814,%eax
801040d8:	74 36                	je     80104110 <kill+0x60>
    if(p->pid == pid){
801040da:	39 58 10             	cmp    %ebx,0x10(%eax)
801040dd:	75 f1                	jne    801040d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040df:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801040e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040ea:	74 14                	je     80104100 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
801040ec:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
801040f3:	e8 b8 02 00 00       	call   801043b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801040f8:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
801040fb:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040fd:	5b                   	pop    %ebx
801040fe:	5d                   	pop    %ebp
801040ff:	c3                   	ret    
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104100:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104107:	eb e3                	jmp    801040ec <kill+0x3c>
80104109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104110:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80104117:	e8 94 02 00 00       	call   801043b0 <release>
  return -1;
}
8010411c:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
8010411f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104124:	5b                   	pop    %ebx
80104125:	5d                   	pop    %ebp
80104126:	c3                   	ret    
80104127:	89 f6                	mov    %esi,%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	56                   	push   %esi
80104135:	53                   	push   %ebx
80104136:	bb 80 19 11 80       	mov    $0x80111980,%ebx
8010413b:	83 ec 4c             	sub    $0x4c,%esp
8010413e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104141:	eb 20                	jmp    80104163 <procdump+0x33>
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104148:	c7 04 24 c6 73 10 80 	movl   $0x801073c6,(%esp)
8010414f:	e8 cc c4 ff ff       	call   80100620 <cprintf>
80104154:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104157:	81 fb 80 38 11 80    	cmp    $0x80113880,%ebx
8010415d:	0f 84 8d 00 00 00    	je     801041f0 <procdump+0xc0>
    if(p->state == UNUSED)
80104163:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104166:	85 c0                	test   %eax,%eax
80104168:	74 ea                	je     80104154 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010416a:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
8010416d:	ba 58 75 10 80       	mov    $0x80107558,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104172:	77 11                	ja     80104185 <procdump+0x55>
80104174:	8b 14 85 90 75 10 80 	mov    -0x7fef8a70(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010417b:	b8 58 75 10 80       	mov    $0x80107558,%eax
80104180:	85 d2                	test   %edx,%edx
80104182:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104185:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104188:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010418c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104190:	c7 04 24 5c 75 10 80 	movl   $0x8010755c,(%esp)
80104197:	89 44 24 04          	mov    %eax,0x4(%esp)
8010419b:	e8 80 c4 ff ff       	call   80100620 <cprintf>
    if(p->state == SLEEPING){
801041a0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801041a4:	75 a2                	jne    80104148 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801041ad:	8b 43 b0             	mov    -0x50(%ebx),%eax
801041b0:	8d 7d c0             	lea    -0x40(%ebp),%edi
801041b3:	8b 40 0c             	mov    0xc(%eax),%eax
801041b6:	83 c0 08             	add    $0x8,%eax
801041b9:	89 04 24             	mov    %eax,(%esp)
801041bc:	e8 5f 00 00 00       	call   80104220 <getcallerpcs>
801041c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801041c8:	8b 17                	mov    (%edi),%edx
801041ca:	85 d2                	test   %edx,%edx
801041cc:	0f 84 76 ff ff ff    	je     80104148 <procdump+0x18>
        cprintf(" %p", pc[i]);
801041d2:	89 54 24 04          	mov    %edx,0x4(%esp)
801041d6:	83 c7 04             	add    $0x4,%edi
801041d9:	c7 04 24 c2 6e 10 80 	movl   $0x80106ec2,(%esp)
801041e0:	e8 3b c4 ff ff       	call   80100620 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801041e5:	39 f7                	cmp    %esi,%edi
801041e7:	75 df                	jne    801041c8 <procdump+0x98>
801041e9:	e9 5a ff ff ff       	jmp    80104148 <procdump+0x18>
801041ee:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801041f0:	83 c4 4c             	add    $0x4c,%esp
801041f3:	5b                   	pop    %ebx
801041f4:	5e                   	pop    %esi
801041f5:	5f                   	pop    %edi
801041f6:	5d                   	pop    %ebp
801041f7:	c3                   	ret    
801041f8:	66 90                	xchg   %ax,%ax
801041fa:	66 90                	xchg   %ax,%ax
801041fc:	66 90                	xchg   %ax,%ax
801041fe:	66 90                	xchg   %ax,%ax

80104200 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104206:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010420f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104212:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104219:	5d                   	pop    %ebp
8010421a:	c3                   	ret    
8010421b:	90                   	nop
8010421c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104220 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104223:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104229:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010422a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010422d:	31 c0                	xor    %eax,%eax
8010422f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104230:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104236:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010423c:	77 1a                	ja     80104258 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010423e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104241:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104244:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104247:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104249:	83 f8 0a             	cmp    $0xa,%eax
8010424c:	75 e2                	jne    80104230 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010424e:	5b                   	pop    %ebx
8010424f:	5d                   	pop    %ebp
80104250:	c3                   	ret    
80104251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104258:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010425f:	83 c0 01             	add    $0x1,%eax
80104262:	83 f8 0a             	cmp    $0xa,%eax
80104265:	74 e7                	je     8010424e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104267:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010426e:	83 c0 01             	add    $0x1,%eax
80104271:	83 f8 0a             	cmp    $0xa,%eax
80104274:	75 e2                	jne    80104258 <getcallerpcs+0x38>
80104276:	eb d6                	jmp    8010424e <getcallerpcs+0x2e>
80104278:	90                   	nop
80104279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104280 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	83 ec 18             	sub    $0x18,%esp
80104286:	9c                   	pushf  
80104287:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104288:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104289:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010428f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104295:	85 d2                	test   %edx,%edx
80104297:	75 0c                	jne    801042a5 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
80104299:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010429f:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801042a5:	83 c2 01             	add    $0x1,%edx
801042a8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801042ae:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801042b1:	8b 0a                	mov    (%edx),%ecx
801042b3:	85 c9                	test   %ecx,%ecx
801042b5:	74 05                	je     801042bc <acquire+0x3c>
801042b7:	3b 42 08             	cmp    0x8(%edx),%eax
801042ba:	74 3c                	je     801042f8 <acquire+0x78>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801042bc:	b9 01 00 00 00       	mov    $0x1,%ecx
801042c1:	eb 08                	jmp    801042cb <acquire+0x4b>
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c8:	8b 55 08             	mov    0x8(%ebp),%edx
801042cb:	89 c8                	mov    %ecx,%eax
801042cd:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801042d0:	85 c0                	test   %eax,%eax
801042d2:	75 f4                	jne    801042c8 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801042d4:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801042d7:	8b 45 08             	mov    0x8(%ebp),%eax
801042da:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
801042e1:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801042e4:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
801042e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801042eb:	8d 45 08             	lea    0x8(%ebp),%eax
801042ee:	89 04 24             	mov    %eax,(%esp)
801042f1:	e8 2a ff ff ff       	call   80104220 <getcallerpcs>
}
801042f6:	c9                   	leave  
801042f7:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801042f8:	c7 04 24 a8 75 10 80 	movl   $0x801075a8,(%esp)
801042ff:	e8 2c c0 ff ff       	call   80100330 <panic>
80104304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010430a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104310 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104310:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80104311:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104313:	89 e5                	mov    %esp,%ebp
80104315:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104318:	8b 0a                	mov    (%edx),%ecx
8010431a:	85 c9                	test   %ecx,%ecx
8010431c:	74 0f                	je     8010432d <holding+0x1d>
8010431e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104324:	39 42 08             	cmp    %eax,0x8(%edx)
80104327:	0f 94 c0             	sete   %al
8010432a:	0f b6 c0             	movzbl %al,%eax
}
8010432d:	5d                   	pop    %ebp
8010432e:	c3                   	ret    
8010432f:	90                   	nop

80104330 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104333:	9c                   	pushf  
80104334:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104335:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104336:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010433c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104342:	85 d2                	test   %edx,%edx
80104344:	75 0c                	jne    80104352 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
80104346:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010434c:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104352:	83 c2 01             	add    $0x1,%edx
80104355:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
8010435b:	5d                   	pop    %ebp
8010435c:	c3                   	ret    
8010435d:	8d 76 00             	lea    0x0(%esi),%esi

80104360 <popcli>:

void
popcli(void)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104366:	9c                   	pushf  
80104367:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104368:	f6 c4 02             	test   $0x2,%ah
8010436b:	75 34                	jne    801043a1 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010436d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104373:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
80104379:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010437c:	85 d2                	test   %edx,%edx
8010437e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104384:	78 0f                	js     80104395 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80104386:	75 0b                	jne    80104393 <popcli+0x33>
80104388:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010438e:	85 c0                	test   %eax,%eax
80104390:	74 01                	je     80104393 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104392:	fb                   	sti    
    sti();
}
80104393:	c9                   	leave  
80104394:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
80104395:	c7 04 24 c7 75 10 80 	movl   $0x801075c7,(%esp)
8010439c:	e8 8f bf ff ff       	call   80100330 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801043a1:	c7 04 24 b0 75 10 80 	movl   $0x801075b0,(%esp)
801043a8:	e8 83 bf ff ff       	call   80100330 <panic>
801043ad:	8d 76 00             	lea    0x0(%esi),%esi

801043b0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	83 ec 18             	sub    $0x18,%esp
801043b6:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801043b9:	8b 10                	mov    (%eax),%edx
801043bb:	85 d2                	test   %edx,%edx
801043bd:	74 0c                	je     801043cb <release+0x1b>
801043bf:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801043c6:	39 50 08             	cmp    %edx,0x8(%eax)
801043c9:	74 0d                	je     801043d8 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801043cb:	c7 04 24 ce 75 10 80 	movl   $0x801075ce,(%esp)
801043d2:	e8 59 bf ff ff       	call   80100330 <panic>
801043d7:	90                   	nop

  lk->pcs[0] = 0;
801043d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801043df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both to not re-order.
  __sync_synchronize();
801043e6:	0f ae f0             	mfence 

  // Release the lock.
  lk->locked = 0;
801043e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
801043ef:	c9                   	leave  
  __sync_synchronize();

  // Release the lock.
  lk->locked = 0;

  popcli();
801043f0:	e9 6b ff ff ff       	jmp    80104360 <popcli>
801043f5:	66 90                	xchg   %ax,%ax
801043f7:	66 90                	xchg   %ax,%ax
801043f9:	66 90                	xchg   %ax,%ax
801043fb:	66 90                	xchg   %ax,%ax
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 55 08             	mov    0x8(%ebp),%edx
80104406:	57                   	push   %edi
80104407:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010440a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010440b:	f6 c2 03             	test   $0x3,%dl
8010440e:	75 05                	jne    80104415 <memset+0x15>
80104410:	f6 c1 03             	test   $0x3,%cl
80104413:	74 13                	je     80104428 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104415:	89 d7                	mov    %edx,%edi
80104417:	8b 45 0c             	mov    0xc(%ebp),%eax
8010441a:	fc                   	cld    
8010441b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010441d:	5b                   	pop    %ebx
8010441e:	89 d0                	mov    %edx,%eax
80104420:	5f                   	pop    %edi
80104421:	5d                   	pop    %ebp
80104422:	c3                   	ret    
80104423:	90                   	nop
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104428:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010442c:	c1 e9 02             	shr    $0x2,%ecx
8010442f:	89 f8                	mov    %edi,%eax
80104431:	89 fb                	mov    %edi,%ebx
80104433:	c1 e0 18             	shl    $0x18,%eax
80104436:	c1 e3 10             	shl    $0x10,%ebx
80104439:	09 d8                	or     %ebx,%eax
8010443b:	09 f8                	or     %edi,%eax
8010443d:	c1 e7 08             	shl    $0x8,%edi
80104440:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104442:	89 d7                	mov    %edx,%edi
80104444:	fc                   	cld    
80104445:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104447:	5b                   	pop    %ebx
80104448:	89 d0                	mov    %edx,%eax
8010444a:	5f                   	pop    %edi
8010444b:	5d                   	pop    %ebp
8010444c:	c3                   	ret    
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	8b 45 10             	mov    0x10(%ebp),%eax
80104456:	57                   	push   %edi
80104457:	56                   	push   %esi
80104458:	8b 75 0c             	mov    0xc(%ebp),%esi
8010445b:	53                   	push   %ebx
8010445c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010445f:	85 c0                	test   %eax,%eax
80104461:	8d 78 ff             	lea    -0x1(%eax),%edi
80104464:	74 26                	je     8010448c <memcmp+0x3c>
    if(*s1 != *s2)
80104466:	0f b6 03             	movzbl (%ebx),%eax
80104469:	31 d2                	xor    %edx,%edx
8010446b:	0f b6 0e             	movzbl (%esi),%ecx
8010446e:	38 c8                	cmp    %cl,%al
80104470:	74 16                	je     80104488 <memcmp+0x38>
80104472:	eb 24                	jmp    80104498 <memcmp+0x48>
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104478:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010447d:	83 c2 01             	add    $0x1,%edx
80104480:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104484:	38 c8                	cmp    %cl,%al
80104486:	75 10                	jne    80104498 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104488:	39 fa                	cmp    %edi,%edx
8010448a:	75 ec                	jne    80104478 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010448c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010448d:	31 c0                	xor    %eax,%eax
}
8010448f:	5e                   	pop    %esi
80104490:	5f                   	pop    %edi
80104491:	5d                   	pop    %ebp
80104492:	c3                   	ret    
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104498:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104499:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010449b:	5e                   	pop    %esi
8010449c:	5f                   	pop    %edi
8010449d:	5d                   	pop    %ebp
8010449e:	c3                   	ret    
8010449f:	90                   	nop

801044a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	8b 45 08             	mov    0x8(%ebp),%eax
801044a7:	56                   	push   %esi
801044a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044ab:	53                   	push   %ebx
801044ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801044af:	39 c6                	cmp    %eax,%esi
801044b1:	73 35                	jae    801044e8 <memmove+0x48>
801044b3:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801044b6:	39 c8                	cmp    %ecx,%eax
801044b8:	73 2e                	jae    801044e8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
801044ba:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
801044bc:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
801044bf:	8d 53 ff             	lea    -0x1(%ebx),%edx
801044c2:	74 1b                	je     801044df <memmove+0x3f>
801044c4:	f7 db                	neg    %ebx
801044c6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
801044c9:	01 fb                	add    %edi,%ebx
801044cb:	90                   	nop
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801044d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044d4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801044d7:	83 ea 01             	sub    $0x1,%edx
801044da:	83 fa ff             	cmp    $0xffffffff,%edx
801044dd:	75 f1                	jne    801044d0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801044df:	5b                   	pop    %ebx
801044e0:	5e                   	pop    %esi
801044e1:	5f                   	pop    %edi
801044e2:	5d                   	pop    %ebp
801044e3:	c3                   	ret    
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044e8:	31 d2                	xor    %edx,%edx
801044ea:	85 db                	test   %ebx,%ebx
801044ec:	74 f1                	je     801044df <memmove+0x3f>
801044ee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801044f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801044f7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044fa:	39 da                	cmp    %ebx,%edx
801044fc:	75 f2                	jne    801044f0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801044fe:	5b                   	pop    %ebx
801044ff:	5e                   	pop    %esi
80104500:	5f                   	pop    %edi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
80104503:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104510 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104513:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104514:	e9 87 ff ff ff       	jmp    801044a0 <memmove>
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	8b 75 10             	mov    0x10(%ebp),%esi
80104527:	53                   	push   %ebx
80104528:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010452b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010452e:	85 f6                	test   %esi,%esi
80104530:	74 30                	je     80104562 <strncmp+0x42>
80104532:	0f b6 01             	movzbl (%ecx),%eax
80104535:	84 c0                	test   %al,%al
80104537:	74 2f                	je     80104568 <strncmp+0x48>
80104539:	0f b6 13             	movzbl (%ebx),%edx
8010453c:	38 d0                	cmp    %dl,%al
8010453e:	75 46                	jne    80104586 <strncmp+0x66>
80104540:	8d 51 01             	lea    0x1(%ecx),%edx
80104543:	01 ce                	add    %ecx,%esi
80104545:	eb 14                	jmp    8010455b <strncmp+0x3b>
80104547:	90                   	nop
80104548:	0f b6 02             	movzbl (%edx),%eax
8010454b:	84 c0                	test   %al,%al
8010454d:	74 31                	je     80104580 <strncmp+0x60>
8010454f:	0f b6 19             	movzbl (%ecx),%ebx
80104552:	83 c2 01             	add    $0x1,%edx
80104555:	38 d8                	cmp    %bl,%al
80104557:	75 17                	jne    80104570 <strncmp+0x50>
    n--, p++, q++;
80104559:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010455b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010455d:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104560:	75 e6                	jne    80104548 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104562:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104563:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104565:	5e                   	pop    %esi
80104566:	5d                   	pop    %ebp
80104567:	c3                   	ret    
80104568:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010456b:	31 c0                	xor    %eax,%eax
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104570:	0f b6 d3             	movzbl %bl,%edx
80104573:	29 d0                	sub    %edx,%eax
}
80104575:	5b                   	pop    %ebx
80104576:	5e                   	pop    %esi
80104577:	5d                   	pop    %ebp
80104578:	c3                   	ret    
80104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104580:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104584:	eb ea                	jmp    80104570 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104586:	89 d3                	mov    %edx,%ebx
80104588:	eb e6                	jmp    80104570 <strncmp+0x50>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	8b 45 08             	mov    0x8(%ebp),%eax
80104596:	56                   	push   %esi
80104597:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010459a:	53                   	push   %ebx
8010459b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010459e:	89 c2                	mov    %eax,%edx
801045a0:	eb 19                	jmp    801045bb <strncpy+0x2b>
801045a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045a8:	83 c3 01             	add    $0x1,%ebx
801045ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801045af:	83 c2 01             	add    $0x1,%edx
801045b2:	84 c9                	test   %cl,%cl
801045b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801045b7:	74 09                	je     801045c2 <strncpy+0x32>
801045b9:	89 f1                	mov    %esi,%ecx
801045bb:	85 c9                	test   %ecx,%ecx
801045bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801045c0:	7f e6                	jg     801045a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801045c2:	31 c9                	xor    %ecx,%ecx
801045c4:	85 f6                	test   %esi,%esi
801045c6:	7e 0f                	jle    801045d7 <strncpy+0x47>
    *s++ = 0;
801045c8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801045cc:	89 f3                	mov    %esi,%ebx
801045ce:	83 c1 01             	add    $0x1,%ecx
801045d1:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801045d3:	85 db                	test   %ebx,%ebx
801045d5:	7f f1                	jg     801045c8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
801045d7:	5b                   	pop    %ebx
801045d8:	5e                   	pop    %esi
801045d9:	5d                   	pop    %ebp
801045da:	c3                   	ret    
801045db:	90                   	nop
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045e6:	56                   	push   %esi
801045e7:	8b 45 08             	mov    0x8(%ebp),%eax
801045ea:	53                   	push   %ebx
801045eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801045ee:	85 c9                	test   %ecx,%ecx
801045f0:	7e 26                	jle    80104618 <safestrcpy+0x38>
801045f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801045f6:	89 c1                	mov    %eax,%ecx
801045f8:	eb 17                	jmp    80104611 <safestrcpy+0x31>
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104600:	83 c2 01             	add    $0x1,%edx
80104603:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104607:	83 c1 01             	add    $0x1,%ecx
8010460a:	84 db                	test   %bl,%bl
8010460c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010460f:	74 04                	je     80104615 <safestrcpy+0x35>
80104611:	39 f2                	cmp    %esi,%edx
80104613:	75 eb                	jne    80104600 <safestrcpy+0x20>
    ;
  *s = 0;
80104615:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104618:	5b                   	pop    %ebx
80104619:	5e                   	pop    %esi
8010461a:	5d                   	pop    %ebp
8010461b:	c3                   	ret    
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104620 <strlen>:

int
strlen(const char *s)
{
80104620:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104621:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104623:	89 e5                	mov    %esp,%ebp
80104625:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104628:	80 3a 00             	cmpb   $0x0,(%edx)
8010462b:	74 0c                	je     80104639 <strlen+0x19>
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
80104630:	83 c0 01             	add    $0x1,%eax
80104633:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104637:	75 f7                	jne    80104630 <strlen+0x10>
    ;
  return n;
}
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret    
8010463b:	90                   	nop

8010463c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010463c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104640:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104644:	55                   	push   %ebp
  pushl %ebx
80104645:	53                   	push   %ebx
  pushl %esi
80104646:	56                   	push   %esi
  pushl %edi
80104647:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104648:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010464a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010464c:	5f                   	pop    %edi
  popl %esi
8010464d:	5e                   	pop    %esi
  popl %ebx
8010464e:	5b                   	pop    %ebx
  popl %ebp
8010464f:	5d                   	pop    %ebp
  ret
80104650:	c3                   	ret    
80104651:	66 90                	xchg   %ax,%ax
80104653:	66 90                	xchg   %ax,%ax
80104655:	66 90                	xchg   %ax,%ax
80104657:	66 90                	xchg   %ax,%ax
80104659:	66 90                	xchg   %ax,%ax
8010465b:	66 90                	xchg   %ax,%ax
8010465d:	66 90                	xchg   %ax,%ax
8010465f:	90                   	nop

80104660 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104660:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104667:	55                   	push   %ebp
80104668:	89 e5                	mov    %esp,%ebp
8010466a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010466d:	8b 12                	mov    (%edx),%edx
8010466f:	39 c2                	cmp    %eax,%edx
80104671:	76 15                	jbe    80104688 <fetchint+0x28>
80104673:	8d 48 04             	lea    0x4(%eax),%ecx
80104676:	39 ca                	cmp    %ecx,%edx
80104678:	72 0e                	jb     80104688 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
8010467a:	8b 10                	mov    (%eax),%edx
8010467c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010467f:	89 10                	mov    %edx,(%eax)
  return 0;
80104681:	31 c0                	xor    %eax,%eax
}
80104683:	5d                   	pop    %ebp
80104684:	c3                   	ret    
80104685:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010468d:	5d                   	pop    %ebp
8010468e:	c3                   	ret    
8010468f:	90                   	nop

80104690 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104690:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104696:	55                   	push   %ebp
80104697:	89 e5                	mov    %esp,%ebp
80104699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
8010469c:	39 08                	cmp    %ecx,(%eax)
8010469e:	76 2c                	jbe    801046cc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801046a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801046a3:	89 c8                	mov    %ecx,%eax
801046a5:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801046a7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046ae:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801046b0:	39 d1                	cmp    %edx,%ecx
801046b2:	73 18                	jae    801046cc <fetchstr+0x3c>
    if(*s == 0)
801046b4:	80 39 00             	cmpb   $0x0,(%ecx)
801046b7:	75 0c                	jne    801046c5 <fetchstr+0x35>
801046b9:	eb 1d                	jmp    801046d8 <fetchstr+0x48>
801046bb:	90                   	nop
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046c0:	80 38 00             	cmpb   $0x0,(%eax)
801046c3:	74 13                	je     801046d8 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801046c5:	83 c0 01             	add    $0x1,%eax
801046c8:	39 c2                	cmp    %eax,%edx
801046ca:	77 f4                	ja     801046c0 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
801046cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
801046d1:	5d                   	pop    %ebp
801046d2:	c3                   	ret    
801046d3:	90                   	nop
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
801046d8:	29 c8                	sub    %ecx,%eax
  return -1;
}
801046da:	5d                   	pop    %ebp
801046db:	c3                   	ret    
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046e0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801046e7:	55                   	push   %ebp
801046e8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046ed:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046f0:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801046f2:	8b 40 44             	mov    0x44(%eax),%eax
801046f5:	8d 04 88             	lea    (%eax,%ecx,4),%eax
801046f8:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801046fb:	39 d1                	cmp    %edx,%ecx
801046fd:	73 19                	jae    80104718 <argint+0x38>
801046ff:	8d 48 08             	lea    0x8(%eax),%ecx
80104702:	39 ca                	cmp    %ecx,%edx
80104704:	72 12                	jb     80104718 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104706:	8b 50 04             	mov    0x4(%eax),%edx
80104709:	8b 45 0c             	mov    0xc(%ebp),%eax
8010470c:	89 10                	mov    %edx,(%eax)
  return 0;
8010470e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104710:	5d                   	pop    %ebp
80104711:	c3                   	ret    
80104712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010471d:	5d                   	pop    %ebp
8010471e:	c3                   	ret    
8010471f:	90                   	nop

80104720 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104720:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104726:	55                   	push   %ebp
80104727:	89 e5                	mov    %esp,%ebp
80104729:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010472a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010472d:	8b 50 18             	mov    0x18(%eax),%edx
80104730:	8b 52 44             	mov    0x44(%edx),%edx
80104733:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104736:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80104738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010473d:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104740:	39 d3                	cmp    %edx,%ebx
80104742:	73 1e                	jae    80104762 <argptr+0x42>
80104744:	8d 59 08             	lea    0x8(%ecx),%ebx
80104747:	39 da                	cmp    %ebx,%edx
80104749:	72 17                	jb     80104762 <argptr+0x42>
    return -1;
  *ip = *(int*)(addr);
8010474b:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010474e:	39 d1                	cmp    %edx,%ecx
80104750:	73 10                	jae    80104762 <argptr+0x42>
80104752:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104755:	01 cb                	add    %ecx,%ebx
80104757:	39 d3                	cmp    %edx,%ebx
80104759:	77 07                	ja     80104762 <argptr+0x42>
    return -1;
  *pp = (char*)i;
8010475b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010475e:	89 08                	mov    %ecx,(%eax)
  return 0;
80104760:	31 c0                	xor    %eax,%eax
}
80104762:	5b                   	pop    %ebx
80104763:	5d                   	pop    %ebp
80104764:	c3                   	ret    
80104765:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104770:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104776:	55                   	push   %ebp
80104777:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104779:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010477c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010477f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104781:	8b 52 44             	mov    0x44(%edx),%edx
80104784:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104787:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010478a:	39 c1                	cmp    %eax,%ecx
8010478c:	73 07                	jae    80104795 <argstr+0x25>
8010478e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104791:	39 c8                	cmp    %ecx,%eax
80104793:	73 0b                	jae    801047a0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
8010479a:	5d                   	pop    %ebp
8010479b:	c3                   	ret    
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801047a0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801047a3:	39 c1                	cmp    %eax,%ecx
801047a5:	73 ee                	jae    80104795 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
801047a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801047aa:	89 c8                	mov    %ecx,%eax
801047ac:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801047ae:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047b5:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801047b7:	39 d1                	cmp    %edx,%ecx
801047b9:	73 da                	jae    80104795 <argstr+0x25>
    if(*s == 0)
801047bb:	80 39 00             	cmpb   $0x0,(%ecx)
801047be:	75 12                	jne    801047d2 <argstr+0x62>
801047c0:	eb 1e                	jmp    801047e0 <argstr+0x70>
801047c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047c8:	80 38 00             	cmpb   $0x0,(%eax)
801047cb:	90                   	nop
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047d0:	74 0e                	je     801047e0 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801047d2:	83 c0 01             	add    $0x1,%eax
801047d5:	39 c2                	cmp    %eax,%edx
801047d7:	77 ef                	ja     801047c8 <argstr+0x58>
801047d9:	eb ba                	jmp    80104795 <argstr+0x25>
801047db:	90                   	nop
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
801047e0:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801047e2:	5d                   	pop    %ebp
801047e3:	c3                   	ret    
801047e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801047f0 <syscall>:
[SYS_translate] sys_translate,
};

void
syscall(void)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801047f7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047fe:	8b 5a 18             	mov    0x18(%edx),%ebx
80104801:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104804:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104807:	83 f9 1a             	cmp    $0x1a,%ecx
8010480a:	77 1c                	ja     80104828 <syscall+0x38>
8010480c:	8b 0c 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%ecx
80104813:	85 c9                	test   %ecx,%ecx
80104815:	74 11                	je     80104828 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104817:	ff d1                	call   *%ecx
80104819:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
8010481c:	83 c4 14             	add    $0x14,%esp
8010481f:	5b                   	pop    %ebx
80104820:	5d                   	pop    %ebp
80104821:	c3                   	ret    
80104822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104828:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
8010482c:	8d 42 6c             	lea    0x6c(%edx),%eax
8010482f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104833:	8b 42 10             	mov    0x10(%edx),%eax
80104836:	c7 04 24 d6 75 10 80 	movl   $0x801075d6,(%esp)
8010483d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104841:	e8 da bd ff ff       	call   80100620 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104846:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010484c:	8b 40 18             	mov    0x18(%eax),%eax
8010484f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104856:	83 c4 14             	add    $0x14,%esp
80104859:	5b                   	pop    %ebx
8010485a:	5d                   	pop    %ebp
8010485b:	c3                   	ret    
8010485c:	66 90                	xchg   %ax,%ax
8010485e:	66 90                	xchg   %ax,%ax

80104860 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	56                   	push   %esi
80104865:	53                   	push   %ebx
80104866:	83 ec 4c             	sub    $0x4c,%esp
80104869:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010486c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010486f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104872:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104876:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104879:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010487c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010487f:	e8 7c d6 ff ff       	call   80101f00 <nameiparent>
80104884:	85 c0                	test   %eax,%eax
80104886:	89 c7                	mov    %eax,%edi
80104888:	0f 84 da 00 00 00    	je     80104968 <create+0x108>
    return 0;
  ilock(dp);
8010488e:	89 04 24             	mov    %eax,(%esp)
80104891:	e8 aa cd ff ff       	call   80101640 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104896:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104899:	89 44 24 08          	mov    %eax,0x8(%esp)
8010489d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801048a1:	89 3c 24             	mov    %edi,(%esp)
801048a4:	e8 f7 d2 ff ff       	call   80101ba0 <dirlookup>
801048a9:	85 c0                	test   %eax,%eax
801048ab:	89 c6                	mov    %eax,%esi
801048ad:	74 41                	je     801048f0 <create+0x90>
    iunlockput(dp);
801048af:	89 3c 24             	mov    %edi,(%esp)
801048b2:	e8 39 d0 ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
801048b7:	89 34 24             	mov    %esi,(%esp)
801048ba:	e8 81 cd ff ff       	call   80101640 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801048bf:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801048c4:	75 12                	jne    801048d8 <create+0x78>
801048c6:	66 83 7e 10 02       	cmpw   $0x2,0x10(%esi)
801048cb:	89 f0                	mov    %esi,%eax
801048cd:	75 09                	jne    801048d8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048cf:	83 c4 4c             	add    $0x4c,%esp
801048d2:	5b                   	pop    %ebx
801048d3:	5e                   	pop    %esi
801048d4:	5f                   	pop    %edi
801048d5:	5d                   	pop    %ebp
801048d6:	c3                   	ret    
801048d7:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801048d8:	89 34 24             	mov    %esi,(%esp)
801048db:	e8 10 d0 ff ff       	call   801018f0 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048e0:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801048e3:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048e5:	5b                   	pop    %ebx
801048e6:	5e                   	pop    %esi
801048e7:	5f                   	pop    %edi
801048e8:	5d                   	pop    %ebp
801048e9:	c3                   	ret    
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801048f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801048f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801048f8:	8b 07                	mov    (%edi),%eax
801048fa:	89 04 24             	mov    %eax,(%esp)
801048fd:	e8 ae cb ff ff       	call   801014b0 <ialloc>
80104902:	85 c0                	test   %eax,%eax
80104904:	89 c6                	mov    %eax,%esi
80104906:	0f 84 bf 00 00 00    	je     801049cb <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
8010490c:	89 04 24             	mov    %eax,(%esp)
8010490f:	e8 2c cd ff ff       	call   80101640 <ilock>
  ip->major = major;
80104914:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104918:	66 89 46 12          	mov    %ax,0x12(%esi)
  ip->minor = minor;
8010491c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104920:	66 89 46 14          	mov    %ax,0x14(%esi)
  ip->nlink = 1;
80104924:	b8 01 00 00 00       	mov    $0x1,%eax
80104929:	66 89 46 16          	mov    %ax,0x16(%esi)
  iupdate(ip);
8010492d:	89 34 24             	mov    %esi,(%esp)
80104930:	e8 4b cc ff ff       	call   80101580 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104935:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010493a:	74 34                	je     80104970 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010493c:	8b 46 04             	mov    0x4(%esi),%eax
8010493f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104943:	89 3c 24             	mov    %edi,(%esp)
80104946:	89 44 24 08          	mov    %eax,0x8(%esp)
8010494a:	e8 b1 d4 ff ff       	call   80101e00 <dirlink>
8010494f:	85 c0                	test   %eax,%eax
80104951:	78 6c                	js     801049bf <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104953:	89 3c 24             	mov    %edi,(%esp)
80104956:	e8 95 cf ff ff       	call   801018f0 <iunlockput>

  return ip;
}
8010495b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010495e:	89 f0                	mov    %esi,%eax
}
80104960:	5b                   	pop    %ebx
80104961:	5e                   	pop    %esi
80104962:	5f                   	pop    %edi
80104963:	5d                   	pop    %ebp
80104964:	c3                   	ret    
80104965:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104968:	31 c0                	xor    %eax,%eax
8010496a:	e9 60 ff ff ff       	jmp    801048cf <create+0x6f>
8010496f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104970:	66 83 47 16 01       	addw   $0x1,0x16(%edi)
    iupdate(dp);
80104975:	89 3c 24             	mov    %edi,(%esp)
80104978:	e8 03 cc ff ff       	call   80101580 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010497d:	8b 46 04             	mov    0x4(%esi),%eax
80104980:	c7 44 24 04 8c 76 10 	movl   $0x8010768c,0x4(%esp)
80104987:	80 
80104988:	89 34 24             	mov    %esi,(%esp)
8010498b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010498f:	e8 6c d4 ff ff       	call   80101e00 <dirlink>
80104994:	85 c0                	test   %eax,%eax
80104996:	78 1b                	js     801049b3 <create+0x153>
80104998:	8b 47 04             	mov    0x4(%edi),%eax
8010499b:	c7 44 24 04 8b 76 10 	movl   $0x8010768b,0x4(%esp)
801049a2:	80 
801049a3:	89 34 24             	mov    %esi,(%esp)
801049a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801049aa:	e8 51 d4 ff ff       	call   80101e00 <dirlink>
801049af:	85 c0                	test   %eax,%eax
801049b1:	79 89                	jns    8010493c <create+0xdc>
      panic("create dots");
801049b3:	c7 04 24 7f 76 10 80 	movl   $0x8010767f,(%esp)
801049ba:	e8 71 b9 ff ff       	call   80100330 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801049bf:	c7 04 24 8e 76 10 80 	movl   $0x8010768e,(%esp)
801049c6:	e8 65 b9 ff ff       	call   80100330 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801049cb:	c7 04 24 70 76 10 80 	movl   $0x80107670,(%esp)
801049d2:	e8 59 b9 ff ff       	call   80100330 <panic>
801049d7:	89 f6                	mov    %esi,%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	89 c6                	mov    %eax,%esi
801049e6:	53                   	push   %ebx
801049e7:	89 d3                	mov    %edx,%ebx
801049e9:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801049f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049fa:	e8 e1 fc ff ff       	call   801046e0 <argint>
801049ff:	85 c0                	test   %eax,%eax
80104a01:	78 35                	js     80104a38 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104a03:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104a06:	83 f9 0f             	cmp    $0xf,%ecx
80104a09:	77 2d                	ja     80104a38 <argfd.constprop.0+0x58>
80104a0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a11:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80104a15:	85 c0                	test   %eax,%eax
80104a17:	74 1f                	je     80104a38 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104a19:	85 f6                	test   %esi,%esi
80104a1b:	74 02                	je     80104a1f <argfd.constprop.0+0x3f>
    *pfd = fd;
80104a1d:	89 0e                	mov    %ecx,(%esi)
  if(pf)
80104a1f:	85 db                	test   %ebx,%ebx
80104a21:	74 0d                	je     80104a30 <argfd.constprop.0+0x50>
    *pf = f;
80104a23:	89 03                	mov    %eax,(%ebx)
  return 0;
80104a25:	31 c0                	xor    %eax,%eax
}
80104a27:	83 c4 20             	add    $0x20,%esp
80104a2a:	5b                   	pop    %ebx
80104a2b:	5e                   	pop    %esi
80104a2c:	5d                   	pop    %ebp
80104a2d:	c3                   	ret    
80104a2e:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104a30:	31 c0                	xor    %eax,%eax
80104a32:	eb f3                	jmp    80104a27 <argfd.constprop.0+0x47>
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a3d:	eb e8                	jmp    80104a27 <argfd.constprop.0+0x47>
80104a3f:	90                   	nop

80104a40 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104a40:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a41:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	53                   	push   %ebx
80104a46:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a49:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a4c:	e8 8f ff ff ff       	call   801049e0 <argfd.constprop.0>
80104a51:	85 c0                	test   %eax,%eax
80104a53:	78 1b                	js     80104a70 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a55:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104a58:	31 db                	xor    %ebx,%ebx
80104a5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
80104a60:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104a64:	85 c9                	test   %ecx,%ecx
80104a66:	74 18                	je     80104a80 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104a68:	83 c3 01             	add    $0x1,%ebx
80104a6b:	83 fb 10             	cmp    $0x10,%ebx
80104a6e:	75 f0                	jne    80104a60 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a70:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a78:	5b                   	pop    %ebx
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret    
80104a7b:	90                   	nop
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104a80:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104a84:	89 14 24             	mov    %edx,(%esp)
80104a87:	e8 14 c3 ff ff       	call   80100da0 <filedup>
  return fd;
}
80104a8c:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104a8f:	89 d8                	mov    %ebx,%eax
}
80104a91:	5b                   	pop    %ebx
80104a92:	5d                   	pop    %ebp
80104a93:	c3                   	ret    
80104a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104aa0 <sys_read>:

int
sys_read(void)
{
80104aa0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104aa1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104aa8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104aab:	e8 30 ff ff ff       	call   801049e0 <argfd.constprop.0>
80104ab0:	85 c0                	test   %eax,%eax
80104ab2:	78 54                	js     80104b08 <sys_read+0x68>
80104ab4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104abb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ac2:	e8 19 fc ff ff       	call   801046e0 <argint>
80104ac7:	85 c0                	test   %eax,%eax
80104ac9:	78 3d                	js     80104b08 <sys_read+0x68>
80104acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ace:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ad9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ae0:	e8 3b fc ff ff       	call   80104720 <argptr>
80104ae5:	85 c0                	test   %eax,%eax
80104ae7:	78 1f                	js     80104b08 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aec:	89 44 24 08          	mov    %eax,0x8(%esp)
80104af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104afa:	89 04 24             	mov    %eax,(%esp)
80104afd:	e8 fe c3 ff ff       	call   80100f00 <fileread>
}
80104b02:	c9                   	leave  
80104b03:	c3                   	ret    
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104b0d:	c9                   	leave  
80104b0e:	c3                   	ret    
80104b0f:	90                   	nop

80104b10 <sys_write>:

int
sys_write(void)
{
80104b10:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b11:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b1b:	e8 c0 fe ff ff       	call   801049e0 <argfd.constprop.0>
80104b20:	85 c0                	test   %eax,%eax
80104b22:	78 54                	js     80104b78 <sys_write+0x68>
80104b24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b27:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b2b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b32:	e8 a9 fb ff ff       	call   801046e0 <argint>
80104b37:	85 c0                	test   %eax,%eax
80104b39:	78 3d                	js     80104b78 <sys_write+0x68>
80104b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b45:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b50:	e8 cb fb ff ff       	call   80104720 <argptr>
80104b55:	85 c0                	test   %eax,%eax
80104b57:	78 1f                	js     80104b78 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b5c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b63:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b6a:	89 04 24             	mov    %eax,(%esp)
80104b6d:	e8 2e c4 ff ff       	call   80100fa0 <filewrite>
}
80104b72:	c9                   	leave  
80104b73:	c3                   	ret    
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b7d:	c9                   	leave  
80104b7e:	c3                   	ret    
80104b7f:	90                   	nop

80104b80 <sys_close>:

int
sys_close(void)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b8c:	e8 4f fe ff ff       	call   801049e0 <argfd.constprop.0>
80104b91:	85 c0                	test   %eax,%eax
80104b93:	78 23                	js     80104bb8 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
80104b95:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b9e:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ba5:	00 
  fileclose(f);
80104ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba9:	89 04 24             	mov    %eax,(%esp)
80104bac:	e8 3f c2 ff ff       	call   80100df0 <fileclose>
  return 0;
80104bb1:	31 c0                	xor    %eax,%eax
}
80104bb3:	c9                   	leave  
80104bb4:	c3                   	ret    
80104bb5:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104bb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104bbd:	c9                   	leave  
80104bbe:	c3                   	ret    
80104bbf:	90                   	nop

80104bc0 <sys_fstat>:

int
sys_fstat(void)
{
80104bc0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104bc1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104bc8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104bcb:	e8 10 fe ff ff       	call   801049e0 <argfd.constprop.0>
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	78 34                	js     80104c08 <sys_fstat+0x48>
80104bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bd7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104bde:	00 
80104bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bea:	e8 31 fb ff ff       	call   80104720 <argptr>
80104bef:	85 c0                	test   %eax,%eax
80104bf1:	78 15                	js     80104c08 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bfd:	89 04 24             	mov    %eax,(%esp)
80104c00:	e8 ab c2 ff ff       	call   80100eb0 <filestat>
}
80104c05:	c9                   	leave  
80104c06:	c3                   	ret    
80104c07:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104c0d:	c9                   	leave  
80104c0e:	c3                   	ret    
80104c0f:	90                   	nop

80104c10 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	57                   	push   %edi
80104c14:	56                   	push   %esi
80104c15:	53                   	push   %ebx
80104c16:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c19:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c27:	e8 44 fb ff ff       	call   80104770 <argstr>
80104c2c:	85 c0                	test   %eax,%eax
80104c2e:	0f 88 e6 00 00 00    	js     80104d1a <sys_link+0x10a>
80104c34:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c42:	e8 29 fb ff ff       	call   80104770 <argstr>
80104c47:	85 c0                	test   %eax,%eax
80104c49:	0f 88 cb 00 00 00    	js     80104d1a <sys_link+0x10a>
    return -1;

  begin_op();
80104c4f:	e8 2c df ff ff       	call   80102b80 <begin_op>
  if((ip = namei(old)) == 0){
80104c54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c57:	89 04 24             	mov    %eax,(%esp)
80104c5a:	e8 81 d2 ff ff       	call   80101ee0 <namei>
80104c5f:	85 c0                	test   %eax,%eax
80104c61:	89 c3                	mov    %eax,%ebx
80104c63:	0f 84 ac 00 00 00    	je     80104d15 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104c69:	89 04 24             	mov    %eax,(%esp)
80104c6c:	e8 cf c9 ff ff       	call   80101640 <ilock>
  if(ip->type == T_DIR){
80104c71:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104c76:	0f 84 91 00 00 00    	je     80104d0d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c7c:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c81:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c84:	89 1c 24             	mov    %ebx,(%esp)
80104c87:	e8 f4 c8 ff ff       	call   80101580 <iupdate>
  iunlock(ip);
80104c8c:	89 1c 24             	mov    %ebx,(%esp)
80104c8f:	e8 bc ca ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c94:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c97:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c9b:	89 04 24             	mov    %eax,(%esp)
80104c9e:	e8 5d d2 ff ff       	call   80101f00 <nameiparent>
80104ca3:	85 c0                	test   %eax,%eax
80104ca5:	89 c6                	mov    %eax,%esi
80104ca7:	74 4f                	je     80104cf8 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104ca9:	89 04 24             	mov    %eax,(%esp)
80104cac:	e8 8f c9 ff ff       	call   80101640 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104cb1:	8b 03                	mov    (%ebx),%eax
80104cb3:	39 06                	cmp    %eax,(%esi)
80104cb5:	75 39                	jne    80104cf0 <sys_link+0xe0>
80104cb7:	8b 43 04             	mov    0x4(%ebx),%eax
80104cba:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104cbe:	89 34 24             	mov    %esi,(%esp)
80104cc1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cc5:	e8 36 d1 ff ff       	call   80101e00 <dirlink>
80104cca:	85 c0                	test   %eax,%eax
80104ccc:	78 22                	js     80104cf0 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104cce:	89 34 24             	mov    %esi,(%esp)
80104cd1:	e8 1a cc ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80104cd6:	89 1c 24             	mov    %ebx,(%esp)
80104cd9:	e8 c2 ca ff ff       	call   801017a0 <iput>

  end_op();
80104cde:	e8 0d df ff ff       	call   80102bf0 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104ce3:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104ce6:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104ce8:	5b                   	pop    %ebx
80104ce9:	5e                   	pop    %esi
80104cea:	5f                   	pop    %edi
80104ceb:	5d                   	pop    %ebp
80104cec:	c3                   	ret    
80104ced:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104cf0:	89 34 24             	mov    %esi,(%esp)
80104cf3:	e8 f8 cb ff ff       	call   801018f0 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104cf8:	89 1c 24             	mov    %ebx,(%esp)
80104cfb:	e8 40 c9 ff ff       	call   80101640 <ilock>
  ip->nlink--;
80104d00:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104d05:	89 1c 24             	mov    %ebx,(%esp)
80104d08:	e8 73 c8 ff ff       	call   80101580 <iupdate>
  iunlockput(ip);
80104d0d:	89 1c 24             	mov    %ebx,(%esp)
80104d10:	e8 db cb ff ff       	call   801018f0 <iunlockput>
  end_op();
80104d15:	e8 d6 de ff ff       	call   80102bf0 <end_op>
  return -1;
}
80104d1a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104d1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d22:	5b                   	pop    %ebx
80104d23:	5e                   	pop    %esi
80104d24:	5f                   	pop    %edi
80104d25:	5d                   	pop    %ebp
80104d26:	c3                   	ret    
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	53                   	push   %ebx
80104d36:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d39:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d47:	e8 24 fa ff ff       	call   80104770 <argstr>
80104d4c:	85 c0                	test   %eax,%eax
80104d4e:	0f 88 76 01 00 00    	js     80104eca <sys_unlink+0x19a>
    return -1;

  begin_op();
80104d54:	e8 27 de ff ff       	call   80102b80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d59:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104d5c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d63:	89 04 24             	mov    %eax,(%esp)
80104d66:	e8 95 d1 ff ff       	call   80101f00 <nameiparent>
80104d6b:	85 c0                	test   %eax,%eax
80104d6d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d70:	0f 84 4f 01 00 00    	je     80104ec5 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104d76:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d79:	89 34 24             	mov    %esi,(%esp)
80104d7c:	e8 bf c8 ff ff       	call   80101640 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d81:	c7 44 24 04 8c 76 10 	movl   $0x8010768c,0x4(%esp)
80104d88:	80 
80104d89:	89 1c 24             	mov    %ebx,(%esp)
80104d8c:	e8 df cd ff ff       	call   80101b70 <namecmp>
80104d91:	85 c0                	test   %eax,%eax
80104d93:	0f 84 21 01 00 00    	je     80104eba <sys_unlink+0x18a>
80104d99:	c7 44 24 04 8b 76 10 	movl   $0x8010768b,0x4(%esp)
80104da0:	80 
80104da1:	89 1c 24             	mov    %ebx,(%esp)
80104da4:	e8 c7 cd ff ff       	call   80101b70 <namecmp>
80104da9:	85 c0                	test   %eax,%eax
80104dab:	0f 84 09 01 00 00    	je     80104eba <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104db1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104db4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104db8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104dbc:	89 34 24             	mov    %esi,(%esp)
80104dbf:	e8 dc cd ff ff       	call   80101ba0 <dirlookup>
80104dc4:	85 c0                	test   %eax,%eax
80104dc6:	89 c3                	mov    %eax,%ebx
80104dc8:	0f 84 ec 00 00 00    	je     80104eba <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104dce:	89 04 24             	mov    %eax,(%esp)
80104dd1:	e8 6a c8 ff ff       	call   80101640 <ilock>

  if(ip->nlink < 1)
80104dd6:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
80104ddb:	0f 8e 24 01 00 00    	jle    80104f05 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104de1:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104de6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104de9:	74 7d                	je     80104e68 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104deb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104df2:	00 
80104df3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104dfa:	00 
80104dfb:	89 34 24             	mov    %esi,(%esp)
80104dfe:	e8 fd f5 ff ff       	call   80104400 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e03:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104e06:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e0d:	00 
80104e0e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e12:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e16:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e19:	89 04 24             	mov    %eax,(%esp)
80104e1c:	e8 1f cc ff ff       	call   80101a40 <writei>
80104e21:	83 f8 10             	cmp    $0x10,%eax
80104e24:	0f 85 cf 00 00 00    	jne    80104ef9 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104e2a:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104e2f:	0f 84 a3 00 00 00    	je     80104ed8 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e35:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e38:	89 04 24             	mov    %eax,(%esp)
80104e3b:	e8 b0 ca ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
80104e40:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104e45:	89 1c 24             	mov    %ebx,(%esp)
80104e48:	e8 33 c7 ff ff       	call   80101580 <iupdate>
  iunlockput(ip);
80104e4d:	89 1c 24             	mov    %ebx,(%esp)
80104e50:	e8 9b ca ff ff       	call   801018f0 <iunlockput>

  end_op();
80104e55:	e8 96 dd ff ff       	call   80102bf0 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e5a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104e5d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e5f:	5b                   	pop    %ebx
80104e60:	5e                   	pop    %esi
80104e61:	5f                   	pop    %edi
80104e62:	5d                   	pop    %ebp
80104e63:	c3                   	ret    
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e68:	83 7b 18 20          	cmpl   $0x20,0x18(%ebx)
80104e6c:	0f 86 79 ff ff ff    	jbe    80104deb <sys_unlink+0xbb>
80104e72:	bf 20 00 00 00       	mov    $0x20,%edi
80104e77:	eb 15                	jmp    80104e8e <sys_unlink+0x15e>
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e80:	8d 57 10             	lea    0x10(%edi),%edx
80104e83:	3b 53 18             	cmp    0x18(%ebx),%edx
80104e86:	0f 83 5f ff ff ff    	jae    80104deb <sys_unlink+0xbb>
80104e8c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e8e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e95:	00 
80104e96:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104e9a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e9e:	89 1c 24             	mov    %ebx,(%esp)
80104ea1:	e8 9a ca ff ff       	call   80101940 <readi>
80104ea6:	83 f8 10             	cmp    $0x10,%eax
80104ea9:	75 42                	jne    80104eed <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104eab:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104eb0:	74 ce                	je     80104e80 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104eb2:	89 1c 24             	mov    %ebx,(%esp)
80104eb5:	e8 36 ca ff ff       	call   801018f0 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104eba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ebd:	89 04 24             	mov    %eax,(%esp)
80104ec0:	e8 2b ca ff ff       	call   801018f0 <iunlockput>
  end_op();
80104ec5:	e8 26 dd ff ff       	call   80102bf0 <end_op>
  return -1;
}
80104eca:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104ecd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ed2:	5b                   	pop    %ebx
80104ed3:	5e                   	pop    %esi
80104ed4:	5f                   	pop    %edi
80104ed5:	5d                   	pop    %ebp
80104ed6:	c3                   	ret    
80104ed7:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ed8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104edb:	66 83 68 16 01       	subw   $0x1,0x16(%eax)
    iupdate(dp);
80104ee0:	89 04 24             	mov    %eax,(%esp)
80104ee3:	e8 98 c6 ff ff       	call   80101580 <iupdate>
80104ee8:	e9 48 ff ff ff       	jmp    80104e35 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104eed:	c7 04 24 b0 76 10 80 	movl   $0x801076b0,(%esp)
80104ef4:	e8 37 b4 ff ff       	call   80100330 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104ef9:	c7 04 24 c2 76 10 80 	movl   $0x801076c2,(%esp)
80104f00:	e8 2b b4 ff ff       	call   80100330 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104f05:	c7 04 24 9e 76 10 80 	movl   $0x8010769e,(%esp)
80104f0c:	e8 1f b4 ff ff       	call   80100330 <panic>
80104f11:	eb 0d                	jmp    80104f20 <sys_open>
80104f13:	90                   	nop
80104f14:	90                   	nop
80104f15:	90                   	nop
80104f16:	90                   	nop
80104f17:	90                   	nop
80104f18:	90                   	nop
80104f19:	90                   	nop
80104f1a:	90                   	nop
80104f1b:	90                   	nop
80104f1c:	90                   	nop
80104f1d:	90                   	nop
80104f1e:	90                   	nop
80104f1f:	90                   	nop

80104f20 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
80104f26:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f29:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f37:	e8 34 f8 ff ff       	call   80104770 <argstr>
80104f3c:	85 c0                	test   %eax,%eax
80104f3e:	0f 88 81 00 00 00    	js     80104fc5 <sys_open+0xa5>
80104f44:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f47:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f52:	e8 89 f7 ff ff       	call   801046e0 <argint>
80104f57:	85 c0                	test   %eax,%eax
80104f59:	78 6a                	js     80104fc5 <sys_open+0xa5>
    return -1;

  begin_op();
80104f5b:	e8 20 dc ff ff       	call   80102b80 <begin_op>

  if(omode & O_CREATE){
80104f60:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f64:	75 72                	jne    80104fd8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f69:	89 04 24             	mov    %eax,(%esp)
80104f6c:	e8 6f cf ff ff       	call   80101ee0 <namei>
80104f71:	85 c0                	test   %eax,%eax
80104f73:	89 c7                	mov    %eax,%edi
80104f75:	74 49                	je     80104fc0 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
80104f77:	89 04 24             	mov    %eax,(%esp)
80104f7a:	e8 c1 c6 ff ff       	call   80101640 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f7f:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
80104f84:	0f 84 ae 00 00 00    	je     80105038 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f8a:	e8 a1 bd ff ff       	call   80100d30 <filealloc>
80104f8f:	85 c0                	test   %eax,%eax
80104f91:	89 c6                	mov    %eax,%esi
80104f93:	74 23                	je     80104fb8 <sys_open+0x98>
80104f95:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104f9c:	31 db                	xor    %ebx,%ebx
80104f9e:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80104fa0:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80104fa4:	85 c0                	test   %eax,%eax
80104fa6:	74 50                	je     80104ff8 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104fa8:	83 c3 01             	add    $0x1,%ebx
80104fab:	83 fb 10             	cmp    $0x10,%ebx
80104fae:	75 f0                	jne    80104fa0 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104fb0:	89 34 24             	mov    %esi,(%esp)
80104fb3:	e8 38 be ff ff       	call   80100df0 <fileclose>
    iunlockput(ip);
80104fb8:	89 3c 24             	mov    %edi,(%esp)
80104fbb:	e8 30 c9 ff ff       	call   801018f0 <iunlockput>
    end_op();
80104fc0:	e8 2b dc ff ff       	call   80102bf0 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fc5:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fcd:	5b                   	pop    %ebx
80104fce:	5e                   	pop    %esi
80104fcf:	5f                   	pop    %edi
80104fd0:	5d                   	pop    %ebp
80104fd1:	c3                   	ret    
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fdb:	31 c9                	xor    %ecx,%ecx
80104fdd:	ba 02 00 00 00       	mov    $0x2,%edx
80104fe2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fe9:	e8 72 f8 ff ff       	call   80104860 <create>
    if(ip == 0){
80104fee:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104ff0:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80104ff2:	75 96                	jne    80104f8a <sys_open+0x6a>
80104ff4:	eb ca                	jmp    80104fc0 <sys_open+0xa0>
80104ff6:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104ff8:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104ffc:	89 3c 24             	mov    %edi,(%esp)
80104fff:	e8 4c c7 ff ff       	call   80101750 <iunlock>
  end_op();
80105004:	e8 e7 db ff ff       	call   80102bf0 <end_op>

  f->type = FD_INODE;
80105009:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010500f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105012:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105015:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
8010501c:	89 d0                	mov    %edx,%eax
8010501e:	83 e0 01             	and    $0x1,%eax
80105021:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105024:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105027:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
8010502a:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010502c:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80105030:	83 c4 2c             	add    $0x2c,%esp
80105033:	5b                   	pop    %ebx
80105034:	5e                   	pop    %esi
80105035:	5f                   	pop    %edi
80105036:	5d                   	pop    %ebp
80105037:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105038:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010503b:	85 d2                	test   %edx,%edx
8010503d:	0f 84 47 ff ff ff    	je     80104f8a <sys_open+0x6a>
80105043:	e9 70 ff ff ff       	jmp    80104fb8 <sys_open+0x98>
80105048:	90                   	nop
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105050 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105056:	e8 25 db ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010505b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010505e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105069:	e8 02 f7 ff ff       	call   80104770 <argstr>
8010506e:	85 c0                	test   %eax,%eax
80105070:	78 2e                	js     801050a0 <sys_mkdir+0x50>
80105072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105075:	31 c9                	xor    %ecx,%ecx
80105077:	ba 01 00 00 00       	mov    $0x1,%edx
8010507c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105083:	e8 d8 f7 ff ff       	call   80104860 <create>
80105088:	85 c0                	test   %eax,%eax
8010508a:	74 14                	je     801050a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010508c:	89 04 24             	mov    %eax,(%esp)
8010508f:	e8 5c c8 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105094:	e8 57 db ff ff       	call   80102bf0 <end_op>
  return 0;
80105099:	31 c0                	xor    %eax,%eax
}
8010509b:	c9                   	leave  
8010509c:	c3                   	ret    
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801050a0:	e8 4b db ff ff       	call   80102bf0 <end_op>
    return -1;
801050a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801050aa:	c9                   	leave  
801050ab:	c3                   	ret    
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050b0 <sys_mknod>:

int
sys_mknod(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801050b6:	e8 c5 da ff ff       	call   80102b80 <begin_op>
  if((argstr(0, &path)) < 0 ||
801050bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050be:	89 44 24 04          	mov    %eax,0x4(%esp)
801050c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050c9:	e8 a2 f6 ff ff       	call   80104770 <argstr>
801050ce:	85 c0                	test   %eax,%eax
801050d0:	78 5e                	js     80105130 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801050d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801050d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050e0:	e8 fb f5 ff ff       	call   801046e0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801050e5:	85 c0                	test   %eax,%eax
801050e7:	78 47                	js     80105130 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801050e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801050f7:	e8 e4 f5 ff ff       	call   801046e0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801050fc:	85 c0                	test   %eax,%eax
801050fe:	78 30                	js     80105130 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105100:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105104:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105109:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010510d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105110:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105113:	e8 48 f7 ff ff       	call   80104860 <create>
80105118:	85 c0                	test   %eax,%eax
8010511a:	74 14                	je     80105130 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010511c:	89 04 24             	mov    %eax,(%esp)
8010511f:	e8 cc c7 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105124:	e8 c7 da ff ff       	call   80102bf0 <end_op>
  return 0;
80105129:	31 c0                	xor    %eax,%eax
}
8010512b:	c9                   	leave  
8010512c:	c3                   	ret    
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105130:	e8 bb da ff ff       	call   80102bf0 <end_op>
    return -1;
80105135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010513a:	c9                   	leave  
8010513b:	c3                   	ret    
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105140 <sys_chdir>:

int
sys_chdir(void)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	53                   	push   %ebx
80105144:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105147:	e8 34 da ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010514c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010514f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010515a:	e8 11 f6 ff ff       	call   80104770 <argstr>
8010515f:	85 c0                	test   %eax,%eax
80105161:	78 5a                	js     801051bd <sys_chdir+0x7d>
80105163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105166:	89 04 24             	mov    %eax,(%esp)
80105169:	e8 72 cd ff ff       	call   80101ee0 <namei>
8010516e:	85 c0                	test   %eax,%eax
80105170:	89 c3                	mov    %eax,%ebx
80105172:	74 49                	je     801051bd <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
80105174:	89 04 24             	mov    %eax,(%esp)
80105177:	e8 c4 c4 ff ff       	call   80101640 <ilock>
  if(ip->type != T_DIR){
8010517c:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
    iunlockput(ip);
80105181:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
80105184:	75 32                	jne    801051b8 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105186:	e8 c5 c5 ff ff       	call   80101750 <iunlock>
  iput(proc->cwd);
8010518b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105191:	8b 40 68             	mov    0x68(%eax),%eax
80105194:	89 04 24             	mov    %eax,(%esp)
80105197:	e8 04 c6 ff ff       	call   801017a0 <iput>
  end_op();
8010519c:	e8 4f da ff ff       	call   80102bf0 <end_op>
  proc->cwd = ip;
801051a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a7:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
801051aa:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
801051ad:	31 c0                	xor    %eax,%eax
}
801051af:	5b                   	pop    %ebx
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801051b8:	e8 33 c7 ff ff       	call   801018f0 <iunlockput>
    end_op();
801051bd:	e8 2e da ff ff       	call   80102bf0 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
801051c2:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
801051c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
801051ca:	5b                   	pop    %ebx
801051cb:	5d                   	pop    %ebp
801051cc:	c3                   	ret    
801051cd:	8d 76 00             	lea    0x0(%esi),%esi

801051d0 <sys_exec>:

int
sys_exec(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	56                   	push   %esi
801051d5:	53                   	push   %ebx
801051d6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801051dc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801051e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051ed:	e8 7e f5 ff ff       	call   80104770 <argstr>
801051f2:	85 c0                	test   %eax,%eax
801051f4:	0f 88 84 00 00 00    	js     8010527e <sys_exec+0xae>
801051fa:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105200:	89 44 24 04          	mov    %eax,0x4(%esp)
80105204:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010520b:	e8 d0 f4 ff ff       	call   801046e0 <argint>
80105210:	85 c0                	test   %eax,%eax
80105212:	78 6a                	js     8010527e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105214:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010521a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010521c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105223:	00 
80105224:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010522a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105231:	00 
80105232:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105238:	89 04 24             	mov    %eax,(%esp)
8010523b:	e8 c0 f1 ff ff       	call   80104400 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105240:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105246:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010524a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010524d:	89 04 24             	mov    %eax,(%esp)
80105250:	e8 0b f4 ff ff       	call   80104660 <fetchint>
80105255:	85 c0                	test   %eax,%eax
80105257:	78 25                	js     8010527e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105259:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010525f:	85 c0                	test   %eax,%eax
80105261:	74 2d                	je     80105290 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105263:	89 74 24 04          	mov    %esi,0x4(%esp)
80105267:	89 04 24             	mov    %eax,(%esp)
8010526a:	e8 21 f4 ff ff       	call   80104690 <fetchstr>
8010526f:	85 c0                	test   %eax,%eax
80105271:	78 0b                	js     8010527e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105273:	83 c3 01             	add    $0x1,%ebx
80105276:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105279:	83 fb 20             	cmp    $0x20,%ebx
8010527c:	75 c2                	jne    80105240 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010527e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105289:	5b                   	pop    %ebx
8010528a:	5e                   	pop    %esi
8010528b:	5f                   	pop    %edi
8010528c:	5d                   	pop    %ebp
8010528d:	c3                   	ret    
8010528e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105290:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105296:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801052a0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801052a7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801052ab:	89 04 24             	mov    %eax,(%esp)
801052ae:	e8 cd b6 ff ff       	call   80100980 <exec>
}
801052b3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801052b9:	5b                   	pop    %ebx
801052ba:	5e                   	pop    %esi
801052bb:	5f                   	pop    %edi
801052bc:	5d                   	pop    %ebp
801052bd:	c3                   	ret    
801052be:	66 90                	xchg   %ax,%ax

801052c0 <sys_pipe>:

int
sys_pipe(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
801052c5:	53                   	push   %ebx
801052c6:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801052c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
801052cc:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801052d3:	00 
801052d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801052d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052df:	e8 3c f4 ff ff       	call   80104720 <argptr>
801052e4:	85 c0                	test   %eax,%eax
801052e6:	78 7a                	js     80105362 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801052e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
801052f2:	89 04 24             	mov    %eax,(%esp)
801052f5:	e8 b6 df ff ff       	call   801032b0 <pipealloc>
801052fa:	85 c0                	test   %eax,%eax
801052fc:	78 64                	js     80105362 <sys_pipe+0xa2>
801052fe:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105305:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105307:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
8010530a:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010530e:	85 d2                	test   %edx,%edx
80105310:	74 16                	je     80105328 <sys_pipe+0x68>
80105312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105318:	83 c0 01             	add    $0x1,%eax
8010531b:	83 f8 10             	cmp    $0x10,%eax
8010531e:	74 2f                	je     8010534f <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
80105320:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105324:	85 d2                	test   %edx,%edx
80105326:	75 f0                	jne    80105318 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
8010532b:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010532e:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105330:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
80105334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105338:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
8010533d:	74 31                	je     80105370 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010533f:	83 c2 01             	add    $0x1,%edx
80105342:	83 fa 10             	cmp    $0x10,%edx
80105345:	75 f1                	jne    80105338 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
80105347:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
8010534e:	00 
    fileclose(rf);
8010534f:	89 1c 24             	mov    %ebx,(%esp)
80105352:	e8 99 ba ff ff       	call   80100df0 <fileclose>
    fileclose(wf);
80105357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010535a:	89 04 24             	mov    %eax,(%esp)
8010535d:	e8 8e ba ff ff       	call   80100df0 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105362:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010536a:	5b                   	pop    %ebx
8010536b:	5e                   	pop    %esi
8010536c:	5f                   	pop    %edi
8010536d:	5d                   	pop    %ebp
8010536e:	c3                   	ret    
8010536f:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105370:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105374:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105377:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105379:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010537c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010537f:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105382:	31 c0                	xor    %eax,%eax
}
80105384:	5b                   	pop    %ebx
80105385:	5e                   	pop    %esi
80105386:	5f                   	pop    %edi
80105387:	5d                   	pop    %ebp
80105388:	c3                   	ret    
80105389:	66 90                	xchg   %ax,%ax
8010538b:	66 90                	xchg   %ax,%ax
8010538d:	66 90                	xchg   %ax,%ax
8010538f:	90                   	nop

80105390 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105393:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105394:	e9 37 e5 ff ff       	jmp    801038d0 <fork>
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_exit>:
}

int
sys_exit(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801053a6:	e8 95 e9 ff ff       	call   80103d40 <exit>
  return 0;  // not reached
}
801053ab:	31 c0                	xor    %eax,%eax
801053ad:	c9                   	leave  
801053ae:	c3                   	ret    
801053af:	90                   	nop

801053b0 <sys_wait>:

int
sys_wait(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801053b3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801053b4:	e9 b7 eb ff ff       	jmp    80103f70 <wait>
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_kill>:
}

int
sys_kill(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801053c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801053cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053d4:	e8 07 f3 ff ff       	call   801046e0 <argint>
801053d9:	85 c0                	test   %eax,%eax
801053db:	78 13                	js     801053f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801053dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e0:	89 04 24             	mov    %eax,(%esp)
801053e3:	e8 c8 ec ff ff       	call   801040b0 <kill>
}
801053e8:	c9                   	leave  
801053e9:	c3                   	ret    
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    
801053f7:	89 f6                	mov    %esi,%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105400 <sys_wakeall>:

int
sys_wakeall(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp

return wakeall();

}
80105403:	5d                   	pop    %ebp

int
sys_wakeall(void)
{

return wakeall();
80105404:	e9 87 e6 ff ff       	jmp    80103a90 <wakeall>
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_runnable>:


//YYYYYYYYYYuanZZZZZZZZZZZheng___RUNNABLE
int
sys_runnable(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp

return runnable();

}
80105413:	5d                   	pop    %ebp
//YYYYYYYYYYuanZZZZZZZZZZZheng___RUNNABLE
int
sys_runnable(void)
{

return runnable();
80105414:	e9 37 e8 ff ff       	jmp    80103c50 <runnable>
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_translate>:

}

int
sys_translate(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 28             	sub    $0x28,%esp
int vaddr;
int procpid;
if(argint(0, &vaddr)<0)
80105426:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105429:	89 44 24 04          	mov    %eax,0x4(%esp)
8010542d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105434:	e8 a7 f2 ff ff       	call   801046e0 <argint>
80105439:	85 c0                	test   %eax,%eax
8010543b:	78 73                	js     801054b0 <sys_translate+0x90>
{ 
  cprintf("this  is in sysproc.c return-1!!\n");
  return -1;
}

if(argint(1,&procpid)<0)
8010543d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105440:	89 44 24 04          	mov    %eax,0x4(%esp)
80105444:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010544b:	e8 90 f2 ff ff       	call   801046e0 <argint>
80105450:	85 c0                	test   %eax,%eax
80105452:	78 4c                	js     801054a0 <sys_translate+0x80>
{
  cprintf("this is in sysproc.c pid<0\n");
}

cprintf("this is in sysproc.c\n");
80105454:	c7 04 24 12 77 10 80 	movl   $0x80107712,(%esp)
8010545b:	e8 c0 b1 ff ff       	call   80100620 <cprintf>
cprintf("argint vaddr is: %p\n",vaddr);
80105460:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105463:	c7 04 24 28 77 10 80 	movl   $0x80107728,(%esp)
8010546a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010546e:	e8 ad b1 ff ff       	call   80100620 <cprintf>
cprintf("argint pid is %d\n",procpid);
80105473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105476:	c7 04 24 3d 77 10 80 	movl   $0x8010773d,(%esp)
8010547d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105481:	e8 9a b1 ff ff       	call   80100620 <cprintf>
return translate((void*)vaddr,procpid);
80105486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105489:	89 44 24 04          	mov    %eax,0x4(%esp)
8010548d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105490:	89 04 24             	mov    %eax,(%esp)
80105493:	e8 58 e6 ff ff       	call   80103af0 <translate>

}
80105498:	c9                   	leave  
80105499:	c3                   	ret    
8010549a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
}

if(argint(1,&procpid)<0)
{
  cprintf("this is in sysproc.c pid<0\n");
801054a0:	c7 04 24 f6 76 10 80 	movl   $0x801076f6,(%esp)
801054a7:	e8 74 b1 ff ff       	call   80100620 <cprintf>
801054ac:	eb a6                	jmp    80105454 <sys_translate+0x34>
801054ae:	66 90                	xchg   %ax,%ax
{
int vaddr;
int procpid;
if(argint(0, &vaddr)<0)
{ 
  cprintf("this  is in sysproc.c return-1!!\n");
801054b0:	c7 04 24 d4 76 10 80 	movl   $0x801076d4,(%esp)
801054b7:	e8 64 b1 ff ff       	call   80100620 <cprintf>
  return -1;
801054bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
cprintf("this is in sysproc.c\n");
cprintf("argint vaddr is: %p\n",vaddr);
cprintf("argint pid is %d\n",procpid);
return translate((void*)vaddr,procpid);

}
801054c1:	c9                   	leave  
801054c2:	c3                   	ret    
801054c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054d0 <sys_getpid>:


int
sys_getpid(void)
{
  return proc->pid;
801054d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax



int
sys_getpid(void)
{
801054d6:	55                   	push   %ebp
801054d7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
801054d9:	5d                   	pop    %ebp


int
sys_getpid(void)
{
  return proc->pid;
801054da:	8b 40 10             	mov    0x10(%eax),%eax
}
801054dd:	c3                   	ret    
801054de:	66 90                	xchg   %ax,%ax

801054e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	53                   	push   %ebx
801054e4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801054ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054f5:	e8 e6 f1 ff ff       	call   801046e0 <argint>
801054fa:	85 c0                	test   %eax,%eax
801054fc:	78 22                	js     80105520 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
801054fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105507:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105509:	89 14 24             	mov    %edx,(%esp)
8010550c:	e8 3f e3 ff ff       	call   80103850 <growproc>
80105511:	85 c0                	test   %eax,%eax
80105513:	78 0b                	js     80105520 <sys_sbrk+0x40>
    return -1;
  return addr;
80105515:	89 d8                	mov    %ebx,%eax
}
80105517:	83 c4 24             	add    $0x24,%esp
8010551a:	5b                   	pop    %ebx
8010551b:	5d                   	pop    %ebp
8010551c:	c3                   	ret    
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105525:	eb f0                	jmp    80105517 <sys_sbrk+0x37>
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	53                   	push   %ebx
80105534:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105537:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010553e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105545:	e8 96 f1 ff ff       	call   801046e0 <argint>
8010554a:	85 c0                	test   %eax,%eax
8010554c:	78 7e                	js     801055cc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010554e:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80105555:	e8 26 ed ff ff       	call   80104280 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010555a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010555d:	8b 1d 60 40 11 80    	mov    0x80114060,%ebx
  while(ticks - ticks0 < n){
80105563:	85 d2                	test   %edx,%edx
80105565:	75 29                	jne    80105590 <sys_sleep+0x60>
80105567:	eb 4f                	jmp    801055b8 <sys_sleep+0x88>
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105570:	c7 44 24 04 20 38 11 	movl   $0x80113820,0x4(%esp)
80105577:	80 
80105578:	c7 04 24 60 40 11 80 	movl   $0x80114060,(%esp)
8010557f:	e8 2c e9 ff ff       	call   80103eb0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105584:	a1 60 40 11 80       	mov    0x80114060,%eax
80105589:	29 d8                	sub    %ebx,%eax
8010558b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010558e:	73 28                	jae    801055b8 <sys_sleep+0x88>
    if(proc->killed){
80105590:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105596:	8b 40 24             	mov    0x24(%eax),%eax
80105599:	85 c0                	test   %eax,%eax
8010559b:	74 d3                	je     80105570 <sys_sleep+0x40>
      release(&tickslock);
8010559d:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
801055a4:	e8 07 ee ff ff       	call   801043b0 <release>
      return -1;
801055a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801055ae:	83 c4 24             	add    $0x24,%esp
801055b1:	5b                   	pop    %ebx
801055b2:	5d                   	pop    %ebp
801055b3:	c3                   	ret    
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801055b8:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
801055bf:	e8 ec ed ff ff       	call   801043b0 <release>
  return 0;
}
801055c4:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
801055c7:	31 c0                	xor    %eax,%eax
}
801055c9:	5b                   	pop    %ebx
801055ca:	5d                   	pop    %ebp
801055cb:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801055cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d1:	eb db                	jmp    801055ae <sys_sleep+0x7e>
801055d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	53                   	push   %ebx
801055e4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801055e7:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
801055ee:	e8 8d ec ff ff       	call   80104280 <acquire>
  xticks = ticks;
801055f3:	8b 1d 60 40 11 80    	mov    0x80114060,%ebx
  release(&tickslock);
801055f9:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80105600:	e8 ab ed ff ff       	call   801043b0 <release>
  return xticks;
}
80105605:	83 c4 14             	add    $0x14,%esp
80105608:	89 d8                	mov    %ebx,%eax
8010560a:	5b                   	pop    %ebx
8010560b:	5d                   	pop    %ebp
8010560c:	c3                   	ret    
8010560d:	66 90                	xchg   %ax,%ax
8010560f:	90                   	nop

80105610 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105610:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105611:	ba 43 00 00 00       	mov    $0x43,%edx
80105616:	89 e5                	mov    %esp,%ebp
80105618:	b8 34 00 00 00       	mov    $0x34,%eax
8010561d:	83 ec 18             	sub    $0x18,%esp
80105620:	ee                   	out    %al,(%dx)
80105621:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105626:	b2 40                	mov    $0x40,%dl
80105628:	ee                   	out    %al,(%dx)
80105629:	b8 2e 00 00 00       	mov    $0x2e,%eax
8010562e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
8010562f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105636:	e8 b5 db ff ff       	call   801031f0 <picenable>
}
8010563b:	c9                   	leave  
8010563c:	c3                   	ret    
8010563d:	66 90                	xchg   %ax,%ax
8010563f:	90                   	nop

80105640 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105640:	1e                   	push   %ds
  pushl %es
80105641:	06                   	push   %es
  pushl %fs
80105642:	0f a0                	push   %fs
  pushl %gs
80105644:	0f a8                	push   %gs
  pushal
80105646:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105647:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010564b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010564d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010564f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105653:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105655:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105657:	54                   	push   %esp
  call trap
80105658:	e8 e3 00 00 00       	call   80105740 <trap>
  addl $4, %esp
8010565d:	83 c4 04             	add    $0x4,%esp

80105660 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105660:	61                   	popa   
  popl %gs
80105661:	0f a9                	pop    %gs
  popl %fs
80105663:	0f a1                	pop    %fs
  popl %es
80105665:	07                   	pop    %es
  popl %ds
80105666:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105667:	83 c4 08             	add    $0x8,%esp
  iret
8010566a:	cf                   	iret   
8010566b:	66 90                	xchg   %ax,%ax
8010566d:	66 90                	xchg   %ax,%ax
8010566f:	90                   	nop

80105670 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105670:	31 c0                	xor    %eax,%eax
80105672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105678:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010567f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105684:	66 89 0c c5 62 38 11 	mov    %cx,-0x7feec79e(,%eax,8)
8010568b:	80 
8010568c:	c6 04 c5 64 38 11 80 	movb   $0x0,-0x7feec79c(,%eax,8)
80105693:	00 
80105694:	c6 04 c5 65 38 11 80 	movb   $0x8e,-0x7feec79b(,%eax,8)
8010569b:	8e 
8010569c:	66 89 14 c5 60 38 11 	mov    %dx,-0x7feec7a0(,%eax,8)
801056a3:	80 
801056a4:	c1 ea 10             	shr    $0x10,%edx
801056a7:	66 89 14 c5 66 38 11 	mov    %dx,-0x7feec79a(,%eax,8)
801056ae:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056af:	83 c0 01             	add    $0x1,%eax
801056b2:	3d 00 01 00 00       	cmp    $0x100,%eax
801056b7:	75 bf                	jne    80105678 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056b9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056ba:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056bf:	89 e5                	mov    %esp,%ebp
801056c1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056c4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
801056c9:	c7 44 24 04 4f 77 10 	movl   $0x8010774f,0x4(%esp)
801056d0:	80 
801056d1:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056d8:	66 89 15 62 3a 11 80 	mov    %dx,0x80113a62
801056df:	66 a3 60 3a 11 80    	mov    %ax,0x80113a60
801056e5:	c1 e8 10             	shr    $0x10,%eax
801056e8:	c6 05 64 3a 11 80 00 	movb   $0x0,0x80113a64
801056ef:	c6 05 65 3a 11 80 ef 	movb   $0xef,0x80113a65
801056f6:	66 a3 66 3a 11 80    	mov    %ax,0x80113a66

  initlock(&tickslock, "time");
801056fc:	e8 ff ea ff ff       	call   80104200 <initlock>
}
80105701:	c9                   	leave  
80105702:	c3                   	ret    
80105703:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105710 <idtinit>:

void
idtinit(void)
{
80105710:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105711:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105716:	89 e5                	mov    %esp,%ebp
80105718:	83 ec 10             	sub    $0x10,%esp
8010571b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010571f:	b8 60 38 11 80       	mov    $0x80113860,%eax
80105724:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105728:	c1 e8 10             	shr    $0x10,%eax
8010572b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010572f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105732:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105735:	c9                   	leave  
80105736:	c3                   	ret    
80105737:	89 f6                	mov    %esi,%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105740 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	57                   	push   %edi
80105744:	56                   	push   %esi
80105745:	53                   	push   %ebx
80105746:	83 ec 2c             	sub    $0x2c,%esp
80105749:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010574c:	8b 43 30             	mov    0x30(%ebx),%eax
8010574f:	83 f8 40             	cmp    $0x40,%eax
80105752:	0f 84 00 01 00 00    	je     80105858 <trap+0x118>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105758:	83 e8 20             	sub    $0x20,%eax
8010575b:	83 f8 1f             	cmp    $0x1f,%eax
8010575e:	77 60                	ja     801057c0 <trap+0x80>
80105760:	ff 24 85 f8 77 10 80 	jmp    *-0x7fef8808(,%eax,4)
80105767:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105768:	e8 e3 cf ff ff       	call   80102750 <cpunum>
8010576d:	85 c0                	test   %eax,%eax
8010576f:	90                   	nop
80105770:	0f 84 d2 01 00 00    	je     80105948 <trap+0x208>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105776:	e8 75 d0 ff ff       	call   801027f0 <lapiceoi>
8010577b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105781:	85 c0                	test   %eax,%eax
80105783:	74 2d                	je     801057b2 <trap+0x72>
80105785:	8b 50 24             	mov    0x24(%eax),%edx
80105788:	85 d2                	test   %edx,%edx
8010578a:	0f 85 9c 00 00 00    	jne    8010582c <trap+0xec>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105790:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105794:	0f 84 86 01 00 00    	je     80105920 <trap+0x1e0>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010579a:	8b 40 24             	mov    0x24(%eax),%eax
8010579d:	85 c0                	test   %eax,%eax
8010579f:	74 11                	je     801057b2 <trap+0x72>
801057a1:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057a5:	83 e0 03             	and    $0x3,%eax
801057a8:	66 83 f8 03          	cmp    $0x3,%ax
801057ac:	0f 84 d0 00 00 00    	je     80105882 <trap+0x142>
    exit();
}
801057b2:	83 c4 2c             	add    $0x2c,%esp
801057b5:	5b                   	pop    %ebx
801057b6:	5e                   	pop    %esi
801057b7:	5f                   	pop    %edi
801057b8:	5d                   	pop    %ebp
801057b9:	c3                   	ret    
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801057c0:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
801057c7:	85 c9                	test   %ecx,%ecx
801057c9:	0f 84 a9 01 00 00    	je     80105978 <trap+0x238>
801057cf:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801057d3:	0f 84 9f 01 00 00    	je     80105978 <trap+0x238>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057d9:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057dc:	8b 73 38             	mov    0x38(%ebx),%esi
801057df:	e8 6c cf ff ff       	call   80102750 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801057e4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057eb:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
801057ef:	89 74 24 18          	mov    %esi,0x18(%esp)
801057f3:	89 44 24 14          	mov    %eax,0x14(%esp)
801057f7:	8b 43 34             	mov    0x34(%ebx),%eax
801057fa:	89 44 24 10          	mov    %eax,0x10(%esp)
801057fe:	8b 43 30             	mov    0x30(%ebx),%eax
80105801:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105805:	8d 42 6c             	lea    0x6c(%edx),%eax
80105808:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010580c:	8b 42 10             	mov    0x10(%edx),%eax
8010580f:	c7 04 24 b4 77 10 80 	movl   $0x801077b4,(%esp)
80105816:	89 44 24 04          	mov    %eax,0x4(%esp)
8010581a:	e8 01 ae ff ff       	call   80100620 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
8010581f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105825:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010582c:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105830:	83 e2 03             	and    $0x3,%edx
80105833:	66 83 fa 03          	cmp    $0x3,%dx
80105837:	0f 85 53 ff ff ff    	jne    80105790 <trap+0x50>
    exit();
8010583d:	e8 fe e4 ff ff       	call   80103d40 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105842:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105848:	85 c0                	test   %eax,%eax
8010584a:	0f 85 40 ff ff ff    	jne    80105790 <trap+0x50>
80105850:	e9 5d ff ff ff       	jmp    801057b2 <trap+0x72>
80105855:	8d 76 00             	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105858:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010585e:	8b 70 24             	mov    0x24(%eax),%esi
80105861:	85 f6                	test   %esi,%esi
80105863:	0f 85 a7 00 00 00    	jne    80105910 <trap+0x1d0>
      exit();
    proc->tf = tf;
80105869:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010586c:	e8 7f ef ff ff       	call   801047f0 <syscall>
    if(proc->killed)
80105871:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105877:	8b 58 24             	mov    0x24(%eax),%ebx
8010587a:	85 db                	test   %ebx,%ebx
8010587c:	0f 84 30 ff ff ff    	je     801057b2 <trap+0x72>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105882:	83 c4 2c             	add    $0x2c,%esp
80105885:	5b                   	pop    %ebx
80105886:	5e                   	pop    %esi
80105887:	5f                   	pop    %edi
80105888:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105889:	e9 b2 e4 ff ff       	jmp    80103d40 <exit>
8010588e:	66 90                	xchg   %ax,%ax
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105890:	e8 2b cd ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80105895:	e8 56 cf ff ff       	call   801027f0 <lapiceoi>
8010589a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801058a0:	e9 dc fe ff ff       	jmp    80105781 <trap+0x41>
801058a5:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801058a8:	e8 c3 c7 ff ff       	call   80102070 <ideintr>
    lapiceoi();
801058ad:	e8 3e cf ff ff       	call   801027f0 <lapiceoi>
801058b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801058b8:	e9 c4 fe ff ff       	jmp    80105781 <trap+0x41>
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801058c0:	e8 1b 02 00 00       	call   80105ae0 <uartintr>
    lapiceoi();
801058c5:	e8 26 cf ff ff       	call   801027f0 <lapiceoi>
801058ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801058d0:	e9 ac fe ff ff       	jmp    80105781 <trap+0x41>
801058d5:	8d 76 00             	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801058d8:	8b 7b 38             	mov    0x38(%ebx),%edi
801058db:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801058df:	e8 6c ce ff ff       	call   80102750 <cpunum>
801058e4:	c7 04 24 5c 77 10 80 	movl   $0x8010775c,(%esp)
801058eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801058ef:	89 74 24 08          	mov    %esi,0x8(%esp)
801058f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801058f7:	e8 24 ad ff ff       	call   80100620 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
801058fc:	e8 ef ce ff ff       	call   801027f0 <lapiceoi>
80105901:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105907:	e9 75 fe ff ff       	jmp    80105781 <trap+0x41>
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105910:	e8 2b e4 ff ff       	call   80103d40 <exit>
80105915:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010591b:	e9 49 ff ff ff       	jmp    80105869 <trap+0x129>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105920:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105924:	0f 85 70 fe ff ff    	jne    8010579a <trap+0x5a>
    yield();
8010592a:	e8 41 e5 ff ff       	call   80103e70 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010592f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105935:	85 c0                	test   %eax,%eax
80105937:	0f 85 5d fe ff ff    	jne    8010579a <trap+0x5a>
8010593d:	e9 70 fe ff ff       	jmp    801057b2 <trap+0x72>
80105942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105948:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
8010594f:	e8 2c e9 ff ff       	call   80104280 <acquire>
      ticks++;
      wakeup(&ticks);
80105954:	c7 04 24 60 40 11 80 	movl   $0x80114060,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
8010595b:	83 05 60 40 11 80 01 	addl   $0x1,0x80114060
      wakeup(&ticks);
80105962:	e8 e9 e6 ff ff       	call   80104050 <wakeup>
      release(&tickslock);
80105967:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
8010596e:	e8 3d ea ff ff       	call   801043b0 <release>
80105973:	e9 fe fd ff ff       	jmp    80105776 <trap+0x36>
80105978:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010597b:	8b 73 38             	mov    0x38(%ebx),%esi
8010597e:	e8 cd cd ff ff       	call   80102750 <cpunum>
80105983:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105987:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010598b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010598f:	8b 43 30             	mov    0x30(%ebx),%eax
80105992:	c7 04 24 80 77 10 80 	movl   $0x80107780,(%esp)
80105999:	89 44 24 04          	mov    %eax,0x4(%esp)
8010599d:	e8 7e ac ff ff       	call   80100620 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
801059a2:	c7 04 24 54 77 10 80 	movl   $0x80107754,(%esp)
801059a9:	e8 82 a9 ff ff       	call   80100330 <panic>
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059b0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801059b5:	55                   	push   %ebp
801059b6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059b8:	85 c0                	test   %eax,%eax
801059ba:	74 14                	je     801059d0 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059bc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801059c1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801059c2:	a8 01                	test   $0x1,%al
801059c4:	74 0a                	je     801059d0 <uartgetc+0x20>
801059c6:	b2 f8                	mov    $0xf8,%dl
801059c8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801059c9:	0f b6 c0             	movzbl %al,%eax
}
801059cc:	5d                   	pop    %ebp
801059cd:	c3                   	ret    
801059ce:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801059d5:	5d                   	pop    %ebp
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801059e0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
801059e5:	85 c0                	test   %eax,%eax
801059e7:	74 3f                	je     80105a28 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
801059e9:	55                   	push   %ebp
801059ea:	89 e5                	mov    %esp,%ebp
801059ec:	56                   	push   %esi
801059ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801059f2:	53                   	push   %ebx
  int i;

  if(!uart)
801059f3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
801059f8:	83 ec 10             	sub    $0x10,%esp
801059fb:	eb 14                	jmp    80105a11 <uartputc+0x31>
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a00:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105a07:	e8 04 ce ff ff       	call   80102810 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a0c:	83 eb 01             	sub    $0x1,%ebx
80105a0f:	74 07                	je     80105a18 <uartputc+0x38>
80105a11:	89 f2                	mov    %esi,%edx
80105a13:	ec                   	in     (%dx),%al
80105a14:	a8 20                	test   $0x20,%al
80105a16:	74 e8                	je     80105a00 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105a18:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a1c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a21:	ee                   	out    %al,(%dx)
}
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	5b                   	pop    %ebx
80105a26:	5e                   	pop    %esi
80105a27:	5d                   	pop    %ebp
80105a28:	f3 c3                	repz ret 
80105a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a30 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105a30:	55                   	push   %ebp
80105a31:	31 c9                	xor    %ecx,%ecx
80105a33:	89 e5                	mov    %esp,%ebp
80105a35:	89 c8                	mov    %ecx,%eax
80105a37:	57                   	push   %edi
80105a38:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105a3d:	56                   	push   %esi
80105a3e:	89 fa                	mov    %edi,%edx
80105a40:	53                   	push   %ebx
80105a41:	83 ec 1c             	sub    $0x1c,%esp
80105a44:	ee                   	out    %al,(%dx)
80105a45:	be fb 03 00 00       	mov    $0x3fb,%esi
80105a4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a4f:	89 f2                	mov    %esi,%edx
80105a51:	ee                   	out    %al,(%dx)
80105a52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a57:	b2 f8                	mov    $0xf8,%dl
80105a59:	ee                   	out    %al,(%dx)
80105a5a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105a5f:	89 c8                	mov    %ecx,%eax
80105a61:	89 da                	mov    %ebx,%edx
80105a63:	ee                   	out    %al,(%dx)
80105a64:	b8 03 00 00 00       	mov    $0x3,%eax
80105a69:	89 f2                	mov    %esi,%edx
80105a6b:	ee                   	out    %al,(%dx)
80105a6c:	b2 fc                	mov    $0xfc,%dl
80105a6e:	89 c8                	mov    %ecx,%eax
80105a70:	ee                   	out    %al,(%dx)
80105a71:	b8 01 00 00 00       	mov    $0x1,%eax
80105a76:	89 da                	mov    %ebx,%edx
80105a78:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a79:	b2 fd                	mov    $0xfd,%dl
80105a7b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105a7c:	3c ff                	cmp    $0xff,%al
80105a7e:	74 52                	je     80105ad2 <uartinit+0xa2>
    return;
  uart = 1;
80105a80:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105a87:	00 00 00 
80105a8a:	89 fa                	mov    %edi,%edx
80105a8c:	ec                   	in     (%dx),%al
80105a8d:	b2 f8                	mov    $0xf8,%dl
80105a8f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105a90:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a97:	bb 78 78 10 80       	mov    $0x80107878,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105a9c:	e8 4f d7 ff ff       	call   801031f0 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105aa1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105aa8:	00 
80105aa9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105ab0:	e8 eb c7 ff ff       	call   801022a0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105ab5:	b8 78 00 00 00       	mov    $0x78,%eax
80105aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
80105ac0:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105ac3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105ac6:	e8 15 ff ff ff       	call   801059e0 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105acb:	0f be 03             	movsbl (%ebx),%eax
80105ace:	84 c0                	test   %al,%al
80105ad0:	75 ee                	jne    80105ac0 <uartinit+0x90>
    uartputc(*p);
}
80105ad2:	83 c4 1c             	add    $0x1c,%esp
80105ad5:	5b                   	pop    %ebx
80105ad6:	5e                   	pop    %esi
80105ad7:	5f                   	pop    %edi
80105ad8:	5d                   	pop    %ebp
80105ad9:	c3                   	ret    
80105ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ae0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105ae6:	c7 04 24 b0 59 10 80 	movl   $0x801059b0,(%esp)
80105aed:	e8 8e ac ff ff       	call   80100780 <consoleintr>
}
80105af2:	c9                   	leave  
80105af3:	c3                   	ret    

80105af4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105af4:	6a 00                	push   $0x0
  pushl $0
80105af6:	6a 00                	push   $0x0
  jmp alltraps
80105af8:	e9 43 fb ff ff       	jmp    80105640 <alltraps>

80105afd <vector1>:
.globl vector1
vector1:
  pushl $0
80105afd:	6a 00                	push   $0x0
  pushl $1
80105aff:	6a 01                	push   $0x1
  jmp alltraps
80105b01:	e9 3a fb ff ff       	jmp    80105640 <alltraps>

80105b06 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b06:	6a 00                	push   $0x0
  pushl $2
80105b08:	6a 02                	push   $0x2
  jmp alltraps
80105b0a:	e9 31 fb ff ff       	jmp    80105640 <alltraps>

80105b0f <vector3>:
.globl vector3
vector3:
  pushl $0
80105b0f:	6a 00                	push   $0x0
  pushl $3
80105b11:	6a 03                	push   $0x3
  jmp alltraps
80105b13:	e9 28 fb ff ff       	jmp    80105640 <alltraps>

80105b18 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b18:	6a 00                	push   $0x0
  pushl $4
80105b1a:	6a 04                	push   $0x4
  jmp alltraps
80105b1c:	e9 1f fb ff ff       	jmp    80105640 <alltraps>

80105b21 <vector5>:
.globl vector5
vector5:
  pushl $0
80105b21:	6a 00                	push   $0x0
  pushl $5
80105b23:	6a 05                	push   $0x5
  jmp alltraps
80105b25:	e9 16 fb ff ff       	jmp    80105640 <alltraps>

80105b2a <vector6>:
.globl vector6
vector6:
  pushl $0
80105b2a:	6a 00                	push   $0x0
  pushl $6
80105b2c:	6a 06                	push   $0x6
  jmp alltraps
80105b2e:	e9 0d fb ff ff       	jmp    80105640 <alltraps>

80105b33 <vector7>:
.globl vector7
vector7:
  pushl $0
80105b33:	6a 00                	push   $0x0
  pushl $7
80105b35:	6a 07                	push   $0x7
  jmp alltraps
80105b37:	e9 04 fb ff ff       	jmp    80105640 <alltraps>

80105b3c <vector8>:
.globl vector8
vector8:
  pushl $8
80105b3c:	6a 08                	push   $0x8
  jmp alltraps
80105b3e:	e9 fd fa ff ff       	jmp    80105640 <alltraps>

80105b43 <vector9>:
.globl vector9
vector9:
  pushl $0
80105b43:	6a 00                	push   $0x0
  pushl $9
80105b45:	6a 09                	push   $0x9
  jmp alltraps
80105b47:	e9 f4 fa ff ff       	jmp    80105640 <alltraps>

80105b4c <vector10>:
.globl vector10
vector10:
  pushl $10
80105b4c:	6a 0a                	push   $0xa
  jmp alltraps
80105b4e:	e9 ed fa ff ff       	jmp    80105640 <alltraps>

80105b53 <vector11>:
.globl vector11
vector11:
  pushl $11
80105b53:	6a 0b                	push   $0xb
  jmp alltraps
80105b55:	e9 e6 fa ff ff       	jmp    80105640 <alltraps>

80105b5a <vector12>:
.globl vector12
vector12:
  pushl $12
80105b5a:	6a 0c                	push   $0xc
  jmp alltraps
80105b5c:	e9 df fa ff ff       	jmp    80105640 <alltraps>

80105b61 <vector13>:
.globl vector13
vector13:
  pushl $13
80105b61:	6a 0d                	push   $0xd
  jmp alltraps
80105b63:	e9 d8 fa ff ff       	jmp    80105640 <alltraps>

80105b68 <vector14>:
.globl vector14
vector14:
  pushl $14
80105b68:	6a 0e                	push   $0xe
  jmp alltraps
80105b6a:	e9 d1 fa ff ff       	jmp    80105640 <alltraps>

80105b6f <vector15>:
.globl vector15
vector15:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $15
80105b71:	6a 0f                	push   $0xf
  jmp alltraps
80105b73:	e9 c8 fa ff ff       	jmp    80105640 <alltraps>

80105b78 <vector16>:
.globl vector16
vector16:
  pushl $0
80105b78:	6a 00                	push   $0x0
  pushl $16
80105b7a:	6a 10                	push   $0x10
  jmp alltraps
80105b7c:	e9 bf fa ff ff       	jmp    80105640 <alltraps>

80105b81 <vector17>:
.globl vector17
vector17:
  pushl $17
80105b81:	6a 11                	push   $0x11
  jmp alltraps
80105b83:	e9 b8 fa ff ff       	jmp    80105640 <alltraps>

80105b88 <vector18>:
.globl vector18
vector18:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $18
80105b8a:	6a 12                	push   $0x12
  jmp alltraps
80105b8c:	e9 af fa ff ff       	jmp    80105640 <alltraps>

80105b91 <vector19>:
.globl vector19
vector19:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $19
80105b93:	6a 13                	push   $0x13
  jmp alltraps
80105b95:	e9 a6 fa ff ff       	jmp    80105640 <alltraps>

80105b9a <vector20>:
.globl vector20
vector20:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $20
80105b9c:	6a 14                	push   $0x14
  jmp alltraps
80105b9e:	e9 9d fa ff ff       	jmp    80105640 <alltraps>

80105ba3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $21
80105ba5:	6a 15                	push   $0x15
  jmp alltraps
80105ba7:	e9 94 fa ff ff       	jmp    80105640 <alltraps>

80105bac <vector22>:
.globl vector22
vector22:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $22
80105bae:	6a 16                	push   $0x16
  jmp alltraps
80105bb0:	e9 8b fa ff ff       	jmp    80105640 <alltraps>

80105bb5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $23
80105bb7:	6a 17                	push   $0x17
  jmp alltraps
80105bb9:	e9 82 fa ff ff       	jmp    80105640 <alltraps>

80105bbe <vector24>:
.globl vector24
vector24:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $24
80105bc0:	6a 18                	push   $0x18
  jmp alltraps
80105bc2:	e9 79 fa ff ff       	jmp    80105640 <alltraps>

80105bc7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $25
80105bc9:	6a 19                	push   $0x19
  jmp alltraps
80105bcb:	e9 70 fa ff ff       	jmp    80105640 <alltraps>

80105bd0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $26
80105bd2:	6a 1a                	push   $0x1a
  jmp alltraps
80105bd4:	e9 67 fa ff ff       	jmp    80105640 <alltraps>

80105bd9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $27
80105bdb:	6a 1b                	push   $0x1b
  jmp alltraps
80105bdd:	e9 5e fa ff ff       	jmp    80105640 <alltraps>

80105be2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $28
80105be4:	6a 1c                	push   $0x1c
  jmp alltraps
80105be6:	e9 55 fa ff ff       	jmp    80105640 <alltraps>

80105beb <vector29>:
.globl vector29
vector29:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $29
80105bed:	6a 1d                	push   $0x1d
  jmp alltraps
80105bef:	e9 4c fa ff ff       	jmp    80105640 <alltraps>

80105bf4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $30
80105bf6:	6a 1e                	push   $0x1e
  jmp alltraps
80105bf8:	e9 43 fa ff ff       	jmp    80105640 <alltraps>

80105bfd <vector31>:
.globl vector31
vector31:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $31
80105bff:	6a 1f                	push   $0x1f
  jmp alltraps
80105c01:	e9 3a fa ff ff       	jmp    80105640 <alltraps>

80105c06 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $32
80105c08:	6a 20                	push   $0x20
  jmp alltraps
80105c0a:	e9 31 fa ff ff       	jmp    80105640 <alltraps>

80105c0f <vector33>:
.globl vector33
vector33:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $33
80105c11:	6a 21                	push   $0x21
  jmp alltraps
80105c13:	e9 28 fa ff ff       	jmp    80105640 <alltraps>

80105c18 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $34
80105c1a:	6a 22                	push   $0x22
  jmp alltraps
80105c1c:	e9 1f fa ff ff       	jmp    80105640 <alltraps>

80105c21 <vector35>:
.globl vector35
vector35:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $35
80105c23:	6a 23                	push   $0x23
  jmp alltraps
80105c25:	e9 16 fa ff ff       	jmp    80105640 <alltraps>

80105c2a <vector36>:
.globl vector36
vector36:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $36
80105c2c:	6a 24                	push   $0x24
  jmp alltraps
80105c2e:	e9 0d fa ff ff       	jmp    80105640 <alltraps>

80105c33 <vector37>:
.globl vector37
vector37:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $37
80105c35:	6a 25                	push   $0x25
  jmp alltraps
80105c37:	e9 04 fa ff ff       	jmp    80105640 <alltraps>

80105c3c <vector38>:
.globl vector38
vector38:
  pushl $0
80105c3c:	6a 00                	push   $0x0
  pushl $38
80105c3e:	6a 26                	push   $0x26
  jmp alltraps
80105c40:	e9 fb f9 ff ff       	jmp    80105640 <alltraps>

80105c45 <vector39>:
.globl vector39
vector39:
  pushl $0
80105c45:	6a 00                	push   $0x0
  pushl $39
80105c47:	6a 27                	push   $0x27
  jmp alltraps
80105c49:	e9 f2 f9 ff ff       	jmp    80105640 <alltraps>

80105c4e <vector40>:
.globl vector40
vector40:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $40
80105c50:	6a 28                	push   $0x28
  jmp alltraps
80105c52:	e9 e9 f9 ff ff       	jmp    80105640 <alltraps>

80105c57 <vector41>:
.globl vector41
vector41:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $41
80105c59:	6a 29                	push   $0x29
  jmp alltraps
80105c5b:	e9 e0 f9 ff ff       	jmp    80105640 <alltraps>

80105c60 <vector42>:
.globl vector42
vector42:
  pushl $0
80105c60:	6a 00                	push   $0x0
  pushl $42
80105c62:	6a 2a                	push   $0x2a
  jmp alltraps
80105c64:	e9 d7 f9 ff ff       	jmp    80105640 <alltraps>

80105c69 <vector43>:
.globl vector43
vector43:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $43
80105c6b:	6a 2b                	push   $0x2b
  jmp alltraps
80105c6d:	e9 ce f9 ff ff       	jmp    80105640 <alltraps>

80105c72 <vector44>:
.globl vector44
vector44:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $44
80105c74:	6a 2c                	push   $0x2c
  jmp alltraps
80105c76:	e9 c5 f9 ff ff       	jmp    80105640 <alltraps>

80105c7b <vector45>:
.globl vector45
vector45:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $45
80105c7d:	6a 2d                	push   $0x2d
  jmp alltraps
80105c7f:	e9 bc f9 ff ff       	jmp    80105640 <alltraps>

80105c84 <vector46>:
.globl vector46
vector46:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $46
80105c86:	6a 2e                	push   $0x2e
  jmp alltraps
80105c88:	e9 b3 f9 ff ff       	jmp    80105640 <alltraps>

80105c8d <vector47>:
.globl vector47
vector47:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $47
80105c8f:	6a 2f                	push   $0x2f
  jmp alltraps
80105c91:	e9 aa f9 ff ff       	jmp    80105640 <alltraps>

80105c96 <vector48>:
.globl vector48
vector48:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $48
80105c98:	6a 30                	push   $0x30
  jmp alltraps
80105c9a:	e9 a1 f9 ff ff       	jmp    80105640 <alltraps>

80105c9f <vector49>:
.globl vector49
vector49:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $49
80105ca1:	6a 31                	push   $0x31
  jmp alltraps
80105ca3:	e9 98 f9 ff ff       	jmp    80105640 <alltraps>

80105ca8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ca8:	6a 00                	push   $0x0
  pushl $50
80105caa:	6a 32                	push   $0x32
  jmp alltraps
80105cac:	e9 8f f9 ff ff       	jmp    80105640 <alltraps>

80105cb1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $51
80105cb3:	6a 33                	push   $0x33
  jmp alltraps
80105cb5:	e9 86 f9 ff ff       	jmp    80105640 <alltraps>

80105cba <vector52>:
.globl vector52
vector52:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $52
80105cbc:	6a 34                	push   $0x34
  jmp alltraps
80105cbe:	e9 7d f9 ff ff       	jmp    80105640 <alltraps>

80105cc3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $53
80105cc5:	6a 35                	push   $0x35
  jmp alltraps
80105cc7:	e9 74 f9 ff ff       	jmp    80105640 <alltraps>

80105ccc <vector54>:
.globl vector54
vector54:
  pushl $0
80105ccc:	6a 00                	push   $0x0
  pushl $54
80105cce:	6a 36                	push   $0x36
  jmp alltraps
80105cd0:	e9 6b f9 ff ff       	jmp    80105640 <alltraps>

80105cd5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $55
80105cd7:	6a 37                	push   $0x37
  jmp alltraps
80105cd9:	e9 62 f9 ff ff       	jmp    80105640 <alltraps>

80105cde <vector56>:
.globl vector56
vector56:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $56
80105ce0:	6a 38                	push   $0x38
  jmp alltraps
80105ce2:	e9 59 f9 ff ff       	jmp    80105640 <alltraps>

80105ce7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $57
80105ce9:	6a 39                	push   $0x39
  jmp alltraps
80105ceb:	e9 50 f9 ff ff       	jmp    80105640 <alltraps>

80105cf0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $58
80105cf2:	6a 3a                	push   $0x3a
  jmp alltraps
80105cf4:	e9 47 f9 ff ff       	jmp    80105640 <alltraps>

80105cf9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $59
80105cfb:	6a 3b                	push   $0x3b
  jmp alltraps
80105cfd:	e9 3e f9 ff ff       	jmp    80105640 <alltraps>

80105d02 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $60
80105d04:	6a 3c                	push   $0x3c
  jmp alltraps
80105d06:	e9 35 f9 ff ff       	jmp    80105640 <alltraps>

80105d0b <vector61>:
.globl vector61
vector61:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $61
80105d0d:	6a 3d                	push   $0x3d
  jmp alltraps
80105d0f:	e9 2c f9 ff ff       	jmp    80105640 <alltraps>

80105d14 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $62
80105d16:	6a 3e                	push   $0x3e
  jmp alltraps
80105d18:	e9 23 f9 ff ff       	jmp    80105640 <alltraps>

80105d1d <vector63>:
.globl vector63
vector63:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $63
80105d1f:	6a 3f                	push   $0x3f
  jmp alltraps
80105d21:	e9 1a f9 ff ff       	jmp    80105640 <alltraps>

80105d26 <vector64>:
.globl vector64
vector64:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $64
80105d28:	6a 40                	push   $0x40
  jmp alltraps
80105d2a:	e9 11 f9 ff ff       	jmp    80105640 <alltraps>

80105d2f <vector65>:
.globl vector65
vector65:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $65
80105d31:	6a 41                	push   $0x41
  jmp alltraps
80105d33:	e9 08 f9 ff ff       	jmp    80105640 <alltraps>

80105d38 <vector66>:
.globl vector66
vector66:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $66
80105d3a:	6a 42                	push   $0x42
  jmp alltraps
80105d3c:	e9 ff f8 ff ff       	jmp    80105640 <alltraps>

80105d41 <vector67>:
.globl vector67
vector67:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $67
80105d43:	6a 43                	push   $0x43
  jmp alltraps
80105d45:	e9 f6 f8 ff ff       	jmp    80105640 <alltraps>

80105d4a <vector68>:
.globl vector68
vector68:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $68
80105d4c:	6a 44                	push   $0x44
  jmp alltraps
80105d4e:	e9 ed f8 ff ff       	jmp    80105640 <alltraps>

80105d53 <vector69>:
.globl vector69
vector69:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $69
80105d55:	6a 45                	push   $0x45
  jmp alltraps
80105d57:	e9 e4 f8 ff ff       	jmp    80105640 <alltraps>

80105d5c <vector70>:
.globl vector70
vector70:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $70
80105d5e:	6a 46                	push   $0x46
  jmp alltraps
80105d60:	e9 db f8 ff ff       	jmp    80105640 <alltraps>

80105d65 <vector71>:
.globl vector71
vector71:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $71
80105d67:	6a 47                	push   $0x47
  jmp alltraps
80105d69:	e9 d2 f8 ff ff       	jmp    80105640 <alltraps>

80105d6e <vector72>:
.globl vector72
vector72:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $72
80105d70:	6a 48                	push   $0x48
  jmp alltraps
80105d72:	e9 c9 f8 ff ff       	jmp    80105640 <alltraps>

80105d77 <vector73>:
.globl vector73
vector73:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $73
80105d79:	6a 49                	push   $0x49
  jmp alltraps
80105d7b:	e9 c0 f8 ff ff       	jmp    80105640 <alltraps>

80105d80 <vector74>:
.globl vector74
vector74:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $74
80105d82:	6a 4a                	push   $0x4a
  jmp alltraps
80105d84:	e9 b7 f8 ff ff       	jmp    80105640 <alltraps>

80105d89 <vector75>:
.globl vector75
vector75:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $75
80105d8b:	6a 4b                	push   $0x4b
  jmp alltraps
80105d8d:	e9 ae f8 ff ff       	jmp    80105640 <alltraps>

80105d92 <vector76>:
.globl vector76
vector76:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $76
80105d94:	6a 4c                	push   $0x4c
  jmp alltraps
80105d96:	e9 a5 f8 ff ff       	jmp    80105640 <alltraps>

80105d9b <vector77>:
.globl vector77
vector77:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $77
80105d9d:	6a 4d                	push   $0x4d
  jmp alltraps
80105d9f:	e9 9c f8 ff ff       	jmp    80105640 <alltraps>

80105da4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $78
80105da6:	6a 4e                	push   $0x4e
  jmp alltraps
80105da8:	e9 93 f8 ff ff       	jmp    80105640 <alltraps>

80105dad <vector79>:
.globl vector79
vector79:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $79
80105daf:	6a 4f                	push   $0x4f
  jmp alltraps
80105db1:	e9 8a f8 ff ff       	jmp    80105640 <alltraps>

80105db6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $80
80105db8:	6a 50                	push   $0x50
  jmp alltraps
80105dba:	e9 81 f8 ff ff       	jmp    80105640 <alltraps>

80105dbf <vector81>:
.globl vector81
vector81:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $81
80105dc1:	6a 51                	push   $0x51
  jmp alltraps
80105dc3:	e9 78 f8 ff ff       	jmp    80105640 <alltraps>

80105dc8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $82
80105dca:	6a 52                	push   $0x52
  jmp alltraps
80105dcc:	e9 6f f8 ff ff       	jmp    80105640 <alltraps>

80105dd1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $83
80105dd3:	6a 53                	push   $0x53
  jmp alltraps
80105dd5:	e9 66 f8 ff ff       	jmp    80105640 <alltraps>

80105dda <vector84>:
.globl vector84
vector84:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $84
80105ddc:	6a 54                	push   $0x54
  jmp alltraps
80105dde:	e9 5d f8 ff ff       	jmp    80105640 <alltraps>

80105de3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $85
80105de5:	6a 55                	push   $0x55
  jmp alltraps
80105de7:	e9 54 f8 ff ff       	jmp    80105640 <alltraps>

80105dec <vector86>:
.globl vector86
vector86:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $86
80105dee:	6a 56                	push   $0x56
  jmp alltraps
80105df0:	e9 4b f8 ff ff       	jmp    80105640 <alltraps>

80105df5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $87
80105df7:	6a 57                	push   $0x57
  jmp alltraps
80105df9:	e9 42 f8 ff ff       	jmp    80105640 <alltraps>

80105dfe <vector88>:
.globl vector88
vector88:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $88
80105e00:	6a 58                	push   $0x58
  jmp alltraps
80105e02:	e9 39 f8 ff ff       	jmp    80105640 <alltraps>

80105e07 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $89
80105e09:	6a 59                	push   $0x59
  jmp alltraps
80105e0b:	e9 30 f8 ff ff       	jmp    80105640 <alltraps>

80105e10 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $90
80105e12:	6a 5a                	push   $0x5a
  jmp alltraps
80105e14:	e9 27 f8 ff ff       	jmp    80105640 <alltraps>

80105e19 <vector91>:
.globl vector91
vector91:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $91
80105e1b:	6a 5b                	push   $0x5b
  jmp alltraps
80105e1d:	e9 1e f8 ff ff       	jmp    80105640 <alltraps>

80105e22 <vector92>:
.globl vector92
vector92:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $92
80105e24:	6a 5c                	push   $0x5c
  jmp alltraps
80105e26:	e9 15 f8 ff ff       	jmp    80105640 <alltraps>

80105e2b <vector93>:
.globl vector93
vector93:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $93
80105e2d:	6a 5d                	push   $0x5d
  jmp alltraps
80105e2f:	e9 0c f8 ff ff       	jmp    80105640 <alltraps>

80105e34 <vector94>:
.globl vector94
vector94:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $94
80105e36:	6a 5e                	push   $0x5e
  jmp alltraps
80105e38:	e9 03 f8 ff ff       	jmp    80105640 <alltraps>

80105e3d <vector95>:
.globl vector95
vector95:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $95
80105e3f:	6a 5f                	push   $0x5f
  jmp alltraps
80105e41:	e9 fa f7 ff ff       	jmp    80105640 <alltraps>

80105e46 <vector96>:
.globl vector96
vector96:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $96
80105e48:	6a 60                	push   $0x60
  jmp alltraps
80105e4a:	e9 f1 f7 ff ff       	jmp    80105640 <alltraps>

80105e4f <vector97>:
.globl vector97
vector97:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $97
80105e51:	6a 61                	push   $0x61
  jmp alltraps
80105e53:	e9 e8 f7 ff ff       	jmp    80105640 <alltraps>

80105e58 <vector98>:
.globl vector98
vector98:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $98
80105e5a:	6a 62                	push   $0x62
  jmp alltraps
80105e5c:	e9 df f7 ff ff       	jmp    80105640 <alltraps>

80105e61 <vector99>:
.globl vector99
vector99:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $99
80105e63:	6a 63                	push   $0x63
  jmp alltraps
80105e65:	e9 d6 f7 ff ff       	jmp    80105640 <alltraps>

80105e6a <vector100>:
.globl vector100
vector100:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $100
80105e6c:	6a 64                	push   $0x64
  jmp alltraps
80105e6e:	e9 cd f7 ff ff       	jmp    80105640 <alltraps>

80105e73 <vector101>:
.globl vector101
vector101:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $101
80105e75:	6a 65                	push   $0x65
  jmp alltraps
80105e77:	e9 c4 f7 ff ff       	jmp    80105640 <alltraps>

80105e7c <vector102>:
.globl vector102
vector102:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $102
80105e7e:	6a 66                	push   $0x66
  jmp alltraps
80105e80:	e9 bb f7 ff ff       	jmp    80105640 <alltraps>

80105e85 <vector103>:
.globl vector103
vector103:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $103
80105e87:	6a 67                	push   $0x67
  jmp alltraps
80105e89:	e9 b2 f7 ff ff       	jmp    80105640 <alltraps>

80105e8e <vector104>:
.globl vector104
vector104:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $104
80105e90:	6a 68                	push   $0x68
  jmp alltraps
80105e92:	e9 a9 f7 ff ff       	jmp    80105640 <alltraps>

80105e97 <vector105>:
.globl vector105
vector105:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $105
80105e99:	6a 69                	push   $0x69
  jmp alltraps
80105e9b:	e9 a0 f7 ff ff       	jmp    80105640 <alltraps>

80105ea0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $106
80105ea2:	6a 6a                	push   $0x6a
  jmp alltraps
80105ea4:	e9 97 f7 ff ff       	jmp    80105640 <alltraps>

80105ea9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $107
80105eab:	6a 6b                	push   $0x6b
  jmp alltraps
80105ead:	e9 8e f7 ff ff       	jmp    80105640 <alltraps>

80105eb2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $108
80105eb4:	6a 6c                	push   $0x6c
  jmp alltraps
80105eb6:	e9 85 f7 ff ff       	jmp    80105640 <alltraps>

80105ebb <vector109>:
.globl vector109
vector109:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $109
80105ebd:	6a 6d                	push   $0x6d
  jmp alltraps
80105ebf:	e9 7c f7 ff ff       	jmp    80105640 <alltraps>

80105ec4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $110
80105ec6:	6a 6e                	push   $0x6e
  jmp alltraps
80105ec8:	e9 73 f7 ff ff       	jmp    80105640 <alltraps>

80105ecd <vector111>:
.globl vector111
vector111:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $111
80105ecf:	6a 6f                	push   $0x6f
  jmp alltraps
80105ed1:	e9 6a f7 ff ff       	jmp    80105640 <alltraps>

80105ed6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $112
80105ed8:	6a 70                	push   $0x70
  jmp alltraps
80105eda:	e9 61 f7 ff ff       	jmp    80105640 <alltraps>

80105edf <vector113>:
.globl vector113
vector113:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $113
80105ee1:	6a 71                	push   $0x71
  jmp alltraps
80105ee3:	e9 58 f7 ff ff       	jmp    80105640 <alltraps>

80105ee8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $114
80105eea:	6a 72                	push   $0x72
  jmp alltraps
80105eec:	e9 4f f7 ff ff       	jmp    80105640 <alltraps>

80105ef1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $115
80105ef3:	6a 73                	push   $0x73
  jmp alltraps
80105ef5:	e9 46 f7 ff ff       	jmp    80105640 <alltraps>

80105efa <vector116>:
.globl vector116
vector116:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $116
80105efc:	6a 74                	push   $0x74
  jmp alltraps
80105efe:	e9 3d f7 ff ff       	jmp    80105640 <alltraps>

80105f03 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $117
80105f05:	6a 75                	push   $0x75
  jmp alltraps
80105f07:	e9 34 f7 ff ff       	jmp    80105640 <alltraps>

80105f0c <vector118>:
.globl vector118
vector118:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $118
80105f0e:	6a 76                	push   $0x76
  jmp alltraps
80105f10:	e9 2b f7 ff ff       	jmp    80105640 <alltraps>

80105f15 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $119
80105f17:	6a 77                	push   $0x77
  jmp alltraps
80105f19:	e9 22 f7 ff ff       	jmp    80105640 <alltraps>

80105f1e <vector120>:
.globl vector120
vector120:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $120
80105f20:	6a 78                	push   $0x78
  jmp alltraps
80105f22:	e9 19 f7 ff ff       	jmp    80105640 <alltraps>

80105f27 <vector121>:
.globl vector121
vector121:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $121
80105f29:	6a 79                	push   $0x79
  jmp alltraps
80105f2b:	e9 10 f7 ff ff       	jmp    80105640 <alltraps>

80105f30 <vector122>:
.globl vector122
vector122:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $122
80105f32:	6a 7a                	push   $0x7a
  jmp alltraps
80105f34:	e9 07 f7 ff ff       	jmp    80105640 <alltraps>

80105f39 <vector123>:
.globl vector123
vector123:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $123
80105f3b:	6a 7b                	push   $0x7b
  jmp alltraps
80105f3d:	e9 fe f6 ff ff       	jmp    80105640 <alltraps>

80105f42 <vector124>:
.globl vector124
vector124:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $124
80105f44:	6a 7c                	push   $0x7c
  jmp alltraps
80105f46:	e9 f5 f6 ff ff       	jmp    80105640 <alltraps>

80105f4b <vector125>:
.globl vector125
vector125:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $125
80105f4d:	6a 7d                	push   $0x7d
  jmp alltraps
80105f4f:	e9 ec f6 ff ff       	jmp    80105640 <alltraps>

80105f54 <vector126>:
.globl vector126
vector126:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $126
80105f56:	6a 7e                	push   $0x7e
  jmp alltraps
80105f58:	e9 e3 f6 ff ff       	jmp    80105640 <alltraps>

80105f5d <vector127>:
.globl vector127
vector127:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $127
80105f5f:	6a 7f                	push   $0x7f
  jmp alltraps
80105f61:	e9 da f6 ff ff       	jmp    80105640 <alltraps>

80105f66 <vector128>:
.globl vector128
vector128:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $128
80105f68:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105f6d:	e9 ce f6 ff ff       	jmp    80105640 <alltraps>

80105f72 <vector129>:
.globl vector129
vector129:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $129
80105f74:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105f79:	e9 c2 f6 ff ff       	jmp    80105640 <alltraps>

80105f7e <vector130>:
.globl vector130
vector130:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $130
80105f80:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105f85:	e9 b6 f6 ff ff       	jmp    80105640 <alltraps>

80105f8a <vector131>:
.globl vector131
vector131:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $131
80105f8c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105f91:	e9 aa f6 ff ff       	jmp    80105640 <alltraps>

80105f96 <vector132>:
.globl vector132
vector132:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $132
80105f98:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105f9d:	e9 9e f6 ff ff       	jmp    80105640 <alltraps>

80105fa2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $133
80105fa4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105fa9:	e9 92 f6 ff ff       	jmp    80105640 <alltraps>

80105fae <vector134>:
.globl vector134
vector134:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $134
80105fb0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105fb5:	e9 86 f6 ff ff       	jmp    80105640 <alltraps>

80105fba <vector135>:
.globl vector135
vector135:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $135
80105fbc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105fc1:	e9 7a f6 ff ff       	jmp    80105640 <alltraps>

80105fc6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $136
80105fc8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105fcd:	e9 6e f6 ff ff       	jmp    80105640 <alltraps>

80105fd2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $137
80105fd4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105fd9:	e9 62 f6 ff ff       	jmp    80105640 <alltraps>

80105fde <vector138>:
.globl vector138
vector138:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $138
80105fe0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105fe5:	e9 56 f6 ff ff       	jmp    80105640 <alltraps>

80105fea <vector139>:
.globl vector139
vector139:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $139
80105fec:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105ff1:	e9 4a f6 ff ff       	jmp    80105640 <alltraps>

80105ff6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $140
80105ff8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105ffd:	e9 3e f6 ff ff       	jmp    80105640 <alltraps>

80106002 <vector141>:
.globl vector141
vector141:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $141
80106004:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106009:	e9 32 f6 ff ff       	jmp    80105640 <alltraps>

8010600e <vector142>:
.globl vector142
vector142:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $142
80106010:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106015:	e9 26 f6 ff ff       	jmp    80105640 <alltraps>

8010601a <vector143>:
.globl vector143
vector143:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $143
8010601c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106021:	e9 1a f6 ff ff       	jmp    80105640 <alltraps>

80106026 <vector144>:
.globl vector144
vector144:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $144
80106028:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010602d:	e9 0e f6 ff ff       	jmp    80105640 <alltraps>

80106032 <vector145>:
.globl vector145
vector145:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $145
80106034:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106039:	e9 02 f6 ff ff       	jmp    80105640 <alltraps>

8010603e <vector146>:
.globl vector146
vector146:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $146
80106040:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106045:	e9 f6 f5 ff ff       	jmp    80105640 <alltraps>

8010604a <vector147>:
.globl vector147
vector147:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $147
8010604c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106051:	e9 ea f5 ff ff       	jmp    80105640 <alltraps>

80106056 <vector148>:
.globl vector148
vector148:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $148
80106058:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010605d:	e9 de f5 ff ff       	jmp    80105640 <alltraps>

80106062 <vector149>:
.globl vector149
vector149:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $149
80106064:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106069:	e9 d2 f5 ff ff       	jmp    80105640 <alltraps>

8010606e <vector150>:
.globl vector150
vector150:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $150
80106070:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106075:	e9 c6 f5 ff ff       	jmp    80105640 <alltraps>

8010607a <vector151>:
.globl vector151
vector151:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $151
8010607c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106081:	e9 ba f5 ff ff       	jmp    80105640 <alltraps>

80106086 <vector152>:
.globl vector152
vector152:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $152
80106088:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010608d:	e9 ae f5 ff ff       	jmp    80105640 <alltraps>

80106092 <vector153>:
.globl vector153
vector153:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $153
80106094:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106099:	e9 a2 f5 ff ff       	jmp    80105640 <alltraps>

8010609e <vector154>:
.globl vector154
vector154:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $154
801060a0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801060a5:	e9 96 f5 ff ff       	jmp    80105640 <alltraps>

801060aa <vector155>:
.globl vector155
vector155:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $155
801060ac:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801060b1:	e9 8a f5 ff ff       	jmp    80105640 <alltraps>

801060b6 <vector156>:
.globl vector156
vector156:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $156
801060b8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801060bd:	e9 7e f5 ff ff       	jmp    80105640 <alltraps>

801060c2 <vector157>:
.globl vector157
vector157:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $157
801060c4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801060c9:	e9 72 f5 ff ff       	jmp    80105640 <alltraps>

801060ce <vector158>:
.globl vector158
vector158:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $158
801060d0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801060d5:	e9 66 f5 ff ff       	jmp    80105640 <alltraps>

801060da <vector159>:
.globl vector159
vector159:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $159
801060dc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801060e1:	e9 5a f5 ff ff       	jmp    80105640 <alltraps>

801060e6 <vector160>:
.globl vector160
vector160:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $160
801060e8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801060ed:	e9 4e f5 ff ff       	jmp    80105640 <alltraps>

801060f2 <vector161>:
.globl vector161
vector161:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $161
801060f4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801060f9:	e9 42 f5 ff ff       	jmp    80105640 <alltraps>

801060fe <vector162>:
.globl vector162
vector162:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $162
80106100:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106105:	e9 36 f5 ff ff       	jmp    80105640 <alltraps>

8010610a <vector163>:
.globl vector163
vector163:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $163
8010610c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106111:	e9 2a f5 ff ff       	jmp    80105640 <alltraps>

80106116 <vector164>:
.globl vector164
vector164:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $164
80106118:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010611d:	e9 1e f5 ff ff       	jmp    80105640 <alltraps>

80106122 <vector165>:
.globl vector165
vector165:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $165
80106124:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106129:	e9 12 f5 ff ff       	jmp    80105640 <alltraps>

8010612e <vector166>:
.globl vector166
vector166:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $166
80106130:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106135:	e9 06 f5 ff ff       	jmp    80105640 <alltraps>

8010613a <vector167>:
.globl vector167
vector167:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $167
8010613c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106141:	e9 fa f4 ff ff       	jmp    80105640 <alltraps>

80106146 <vector168>:
.globl vector168
vector168:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $168
80106148:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010614d:	e9 ee f4 ff ff       	jmp    80105640 <alltraps>

80106152 <vector169>:
.globl vector169
vector169:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $169
80106154:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106159:	e9 e2 f4 ff ff       	jmp    80105640 <alltraps>

8010615e <vector170>:
.globl vector170
vector170:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $170
80106160:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106165:	e9 d6 f4 ff ff       	jmp    80105640 <alltraps>

8010616a <vector171>:
.globl vector171
vector171:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $171
8010616c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106171:	e9 ca f4 ff ff       	jmp    80105640 <alltraps>

80106176 <vector172>:
.globl vector172
vector172:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $172
80106178:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010617d:	e9 be f4 ff ff       	jmp    80105640 <alltraps>

80106182 <vector173>:
.globl vector173
vector173:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $173
80106184:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106189:	e9 b2 f4 ff ff       	jmp    80105640 <alltraps>

8010618e <vector174>:
.globl vector174
vector174:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $174
80106190:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106195:	e9 a6 f4 ff ff       	jmp    80105640 <alltraps>

8010619a <vector175>:
.globl vector175
vector175:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $175
8010619c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801061a1:	e9 9a f4 ff ff       	jmp    80105640 <alltraps>

801061a6 <vector176>:
.globl vector176
vector176:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $176
801061a8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801061ad:	e9 8e f4 ff ff       	jmp    80105640 <alltraps>

801061b2 <vector177>:
.globl vector177
vector177:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $177
801061b4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801061b9:	e9 82 f4 ff ff       	jmp    80105640 <alltraps>

801061be <vector178>:
.globl vector178
vector178:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $178
801061c0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801061c5:	e9 76 f4 ff ff       	jmp    80105640 <alltraps>

801061ca <vector179>:
.globl vector179
vector179:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $179
801061cc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801061d1:	e9 6a f4 ff ff       	jmp    80105640 <alltraps>

801061d6 <vector180>:
.globl vector180
vector180:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $180
801061d8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801061dd:	e9 5e f4 ff ff       	jmp    80105640 <alltraps>

801061e2 <vector181>:
.globl vector181
vector181:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $181
801061e4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801061e9:	e9 52 f4 ff ff       	jmp    80105640 <alltraps>

801061ee <vector182>:
.globl vector182
vector182:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $182
801061f0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801061f5:	e9 46 f4 ff ff       	jmp    80105640 <alltraps>

801061fa <vector183>:
.globl vector183
vector183:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $183
801061fc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106201:	e9 3a f4 ff ff       	jmp    80105640 <alltraps>

80106206 <vector184>:
.globl vector184
vector184:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $184
80106208:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010620d:	e9 2e f4 ff ff       	jmp    80105640 <alltraps>

80106212 <vector185>:
.globl vector185
vector185:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $185
80106214:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106219:	e9 22 f4 ff ff       	jmp    80105640 <alltraps>

8010621e <vector186>:
.globl vector186
vector186:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $186
80106220:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106225:	e9 16 f4 ff ff       	jmp    80105640 <alltraps>

8010622a <vector187>:
.globl vector187
vector187:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $187
8010622c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106231:	e9 0a f4 ff ff       	jmp    80105640 <alltraps>

80106236 <vector188>:
.globl vector188
vector188:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $188
80106238:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010623d:	e9 fe f3 ff ff       	jmp    80105640 <alltraps>

80106242 <vector189>:
.globl vector189
vector189:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $189
80106244:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106249:	e9 f2 f3 ff ff       	jmp    80105640 <alltraps>

8010624e <vector190>:
.globl vector190
vector190:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $190
80106250:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106255:	e9 e6 f3 ff ff       	jmp    80105640 <alltraps>

8010625a <vector191>:
.globl vector191
vector191:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $191
8010625c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106261:	e9 da f3 ff ff       	jmp    80105640 <alltraps>

80106266 <vector192>:
.globl vector192
vector192:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $192
80106268:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010626d:	e9 ce f3 ff ff       	jmp    80105640 <alltraps>

80106272 <vector193>:
.globl vector193
vector193:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $193
80106274:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106279:	e9 c2 f3 ff ff       	jmp    80105640 <alltraps>

8010627e <vector194>:
.globl vector194
vector194:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $194
80106280:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106285:	e9 b6 f3 ff ff       	jmp    80105640 <alltraps>

8010628a <vector195>:
.globl vector195
vector195:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $195
8010628c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106291:	e9 aa f3 ff ff       	jmp    80105640 <alltraps>

80106296 <vector196>:
.globl vector196
vector196:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $196
80106298:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010629d:	e9 9e f3 ff ff       	jmp    80105640 <alltraps>

801062a2 <vector197>:
.globl vector197
vector197:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $197
801062a4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801062a9:	e9 92 f3 ff ff       	jmp    80105640 <alltraps>

801062ae <vector198>:
.globl vector198
vector198:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $198
801062b0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801062b5:	e9 86 f3 ff ff       	jmp    80105640 <alltraps>

801062ba <vector199>:
.globl vector199
vector199:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $199
801062bc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801062c1:	e9 7a f3 ff ff       	jmp    80105640 <alltraps>

801062c6 <vector200>:
.globl vector200
vector200:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $200
801062c8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801062cd:	e9 6e f3 ff ff       	jmp    80105640 <alltraps>

801062d2 <vector201>:
.globl vector201
vector201:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $201
801062d4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801062d9:	e9 62 f3 ff ff       	jmp    80105640 <alltraps>

801062de <vector202>:
.globl vector202
vector202:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $202
801062e0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801062e5:	e9 56 f3 ff ff       	jmp    80105640 <alltraps>

801062ea <vector203>:
.globl vector203
vector203:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $203
801062ec:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801062f1:	e9 4a f3 ff ff       	jmp    80105640 <alltraps>

801062f6 <vector204>:
.globl vector204
vector204:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $204
801062f8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801062fd:	e9 3e f3 ff ff       	jmp    80105640 <alltraps>

80106302 <vector205>:
.globl vector205
vector205:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $205
80106304:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106309:	e9 32 f3 ff ff       	jmp    80105640 <alltraps>

8010630e <vector206>:
.globl vector206
vector206:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $206
80106310:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106315:	e9 26 f3 ff ff       	jmp    80105640 <alltraps>

8010631a <vector207>:
.globl vector207
vector207:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $207
8010631c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106321:	e9 1a f3 ff ff       	jmp    80105640 <alltraps>

80106326 <vector208>:
.globl vector208
vector208:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $208
80106328:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010632d:	e9 0e f3 ff ff       	jmp    80105640 <alltraps>

80106332 <vector209>:
.globl vector209
vector209:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $209
80106334:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106339:	e9 02 f3 ff ff       	jmp    80105640 <alltraps>

8010633e <vector210>:
.globl vector210
vector210:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $210
80106340:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106345:	e9 f6 f2 ff ff       	jmp    80105640 <alltraps>

8010634a <vector211>:
.globl vector211
vector211:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $211
8010634c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106351:	e9 ea f2 ff ff       	jmp    80105640 <alltraps>

80106356 <vector212>:
.globl vector212
vector212:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $212
80106358:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010635d:	e9 de f2 ff ff       	jmp    80105640 <alltraps>

80106362 <vector213>:
.globl vector213
vector213:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $213
80106364:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106369:	e9 d2 f2 ff ff       	jmp    80105640 <alltraps>

8010636e <vector214>:
.globl vector214
vector214:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $214
80106370:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106375:	e9 c6 f2 ff ff       	jmp    80105640 <alltraps>

8010637a <vector215>:
.globl vector215
vector215:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $215
8010637c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106381:	e9 ba f2 ff ff       	jmp    80105640 <alltraps>

80106386 <vector216>:
.globl vector216
vector216:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $216
80106388:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010638d:	e9 ae f2 ff ff       	jmp    80105640 <alltraps>

80106392 <vector217>:
.globl vector217
vector217:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $217
80106394:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106399:	e9 a2 f2 ff ff       	jmp    80105640 <alltraps>

8010639e <vector218>:
.globl vector218
vector218:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $218
801063a0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801063a5:	e9 96 f2 ff ff       	jmp    80105640 <alltraps>

801063aa <vector219>:
.globl vector219
vector219:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $219
801063ac:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801063b1:	e9 8a f2 ff ff       	jmp    80105640 <alltraps>

801063b6 <vector220>:
.globl vector220
vector220:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $220
801063b8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801063bd:	e9 7e f2 ff ff       	jmp    80105640 <alltraps>

801063c2 <vector221>:
.globl vector221
vector221:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $221
801063c4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801063c9:	e9 72 f2 ff ff       	jmp    80105640 <alltraps>

801063ce <vector222>:
.globl vector222
vector222:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $222
801063d0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801063d5:	e9 66 f2 ff ff       	jmp    80105640 <alltraps>

801063da <vector223>:
.globl vector223
vector223:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $223
801063dc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801063e1:	e9 5a f2 ff ff       	jmp    80105640 <alltraps>

801063e6 <vector224>:
.globl vector224
vector224:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $224
801063e8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801063ed:	e9 4e f2 ff ff       	jmp    80105640 <alltraps>

801063f2 <vector225>:
.globl vector225
vector225:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $225
801063f4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801063f9:	e9 42 f2 ff ff       	jmp    80105640 <alltraps>

801063fe <vector226>:
.globl vector226
vector226:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $226
80106400:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106405:	e9 36 f2 ff ff       	jmp    80105640 <alltraps>

8010640a <vector227>:
.globl vector227
vector227:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $227
8010640c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106411:	e9 2a f2 ff ff       	jmp    80105640 <alltraps>

80106416 <vector228>:
.globl vector228
vector228:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $228
80106418:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010641d:	e9 1e f2 ff ff       	jmp    80105640 <alltraps>

80106422 <vector229>:
.globl vector229
vector229:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $229
80106424:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106429:	e9 12 f2 ff ff       	jmp    80105640 <alltraps>

8010642e <vector230>:
.globl vector230
vector230:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $230
80106430:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106435:	e9 06 f2 ff ff       	jmp    80105640 <alltraps>

8010643a <vector231>:
.globl vector231
vector231:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $231
8010643c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106441:	e9 fa f1 ff ff       	jmp    80105640 <alltraps>

80106446 <vector232>:
.globl vector232
vector232:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $232
80106448:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010644d:	e9 ee f1 ff ff       	jmp    80105640 <alltraps>

80106452 <vector233>:
.globl vector233
vector233:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $233
80106454:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106459:	e9 e2 f1 ff ff       	jmp    80105640 <alltraps>

8010645e <vector234>:
.globl vector234
vector234:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $234
80106460:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106465:	e9 d6 f1 ff ff       	jmp    80105640 <alltraps>

8010646a <vector235>:
.globl vector235
vector235:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $235
8010646c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106471:	e9 ca f1 ff ff       	jmp    80105640 <alltraps>

80106476 <vector236>:
.globl vector236
vector236:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $236
80106478:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010647d:	e9 be f1 ff ff       	jmp    80105640 <alltraps>

80106482 <vector237>:
.globl vector237
vector237:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $237
80106484:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106489:	e9 b2 f1 ff ff       	jmp    80105640 <alltraps>

8010648e <vector238>:
.globl vector238
vector238:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $238
80106490:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106495:	e9 a6 f1 ff ff       	jmp    80105640 <alltraps>

8010649a <vector239>:
.globl vector239
vector239:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $239
8010649c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801064a1:	e9 9a f1 ff ff       	jmp    80105640 <alltraps>

801064a6 <vector240>:
.globl vector240
vector240:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $240
801064a8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801064ad:	e9 8e f1 ff ff       	jmp    80105640 <alltraps>

801064b2 <vector241>:
.globl vector241
vector241:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $241
801064b4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801064b9:	e9 82 f1 ff ff       	jmp    80105640 <alltraps>

801064be <vector242>:
.globl vector242
vector242:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $242
801064c0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801064c5:	e9 76 f1 ff ff       	jmp    80105640 <alltraps>

801064ca <vector243>:
.globl vector243
vector243:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $243
801064cc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801064d1:	e9 6a f1 ff ff       	jmp    80105640 <alltraps>

801064d6 <vector244>:
.globl vector244
vector244:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $244
801064d8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801064dd:	e9 5e f1 ff ff       	jmp    80105640 <alltraps>

801064e2 <vector245>:
.globl vector245
vector245:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $245
801064e4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801064e9:	e9 52 f1 ff ff       	jmp    80105640 <alltraps>

801064ee <vector246>:
.globl vector246
vector246:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $246
801064f0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801064f5:	e9 46 f1 ff ff       	jmp    80105640 <alltraps>

801064fa <vector247>:
.globl vector247
vector247:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $247
801064fc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106501:	e9 3a f1 ff ff       	jmp    80105640 <alltraps>

80106506 <vector248>:
.globl vector248
vector248:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $248
80106508:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010650d:	e9 2e f1 ff ff       	jmp    80105640 <alltraps>

80106512 <vector249>:
.globl vector249
vector249:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $249
80106514:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106519:	e9 22 f1 ff ff       	jmp    80105640 <alltraps>

8010651e <vector250>:
.globl vector250
vector250:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $250
80106520:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106525:	e9 16 f1 ff ff       	jmp    80105640 <alltraps>

8010652a <vector251>:
.globl vector251
vector251:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $251
8010652c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106531:	e9 0a f1 ff ff       	jmp    80105640 <alltraps>

80106536 <vector252>:
.globl vector252
vector252:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $252
80106538:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010653d:	e9 fe f0 ff ff       	jmp    80105640 <alltraps>

80106542 <vector253>:
.globl vector253
vector253:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $253
80106544:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106549:	e9 f2 f0 ff ff       	jmp    80105640 <alltraps>

8010654e <vector254>:
.globl vector254
vector254:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $254
80106550:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106555:	e9 e6 f0 ff ff       	jmp    80105640 <alltraps>

8010655a <vector255>:
.globl vector255
vector255:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $255
8010655c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106561:	e9 da f0 ff ff       	jmp    80105640 <alltraps>
80106566:	66 90                	xchg   %ax,%ax
80106568:	66 90                	xchg   %ax,%ax
8010656a:	66 90                	xchg   %ax,%ax
8010656c:	66 90                	xchg   %ax,%ax
8010656e:	66 90                	xchg   %ax,%ax

80106570 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	56                   	push   %esi
80106575:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106577:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010657a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010657b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010657e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106581:	8b 1f                	mov    (%edi),%ebx
80106583:	f6 c3 01             	test   $0x1,%bl
80106586:	74 28                	je     801065b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106588:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010658e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106594:	c1 ee 0a             	shr    $0xa,%esi
}
80106597:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010659a:	89 f2                	mov    %esi,%edx
8010659c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801065a2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801065a5:	5b                   	pop    %ebx
801065a6:	5e                   	pop    %esi
801065a7:	5f                   	pop    %edi
801065a8:	5d                   	pop    %ebp
801065a9:	c3                   	ret    
801065aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801065b0:	85 c9                	test   %ecx,%ecx
801065b2:	74 34                	je     801065e8 <walkpgdir+0x78>
801065b4:	e8 d7 be ff ff       	call   80102490 <kalloc>
801065b9:	85 c0                	test   %eax,%eax
801065bb:	89 c3                	mov    %eax,%ebx
801065bd:	74 29                	je     801065e8 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801065bf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801065c6:	00 
801065c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065ce:	00 
801065cf:	89 04 24             	mov    %eax,(%esp)
801065d2:	e8 29 de ff ff       	call   80104400 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801065d7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801065dd:	83 c8 07             	or     $0x7,%eax
801065e0:	89 07                	mov    %eax,(%edi)
801065e2:	eb b0                	jmp    80106594 <walkpgdir+0x24>
801065e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
801065e8:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801065eb:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801065ed:	5b                   	pop    %ebx
801065ee:	5e                   	pop    %esi
801065ef:	5f                   	pop    %edi
801065f0:	5d                   	pop    %ebp
801065f1:	c3                   	ret    
801065f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106600 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
80106605:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106606:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106608:	83 ec 1c             	sub    $0x1c,%esp
8010660b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010660e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106614:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106617:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010661b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010661e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106622:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106629:	29 df                	sub    %ebx,%edi
8010662b:	eb 18                	jmp    80106645 <mappages+0x45>
8010662d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106630:	f6 00 01             	testb  $0x1,(%eax)
80106633:	75 3d                	jne    80106672 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106635:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106638:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010663b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010663d:	74 29                	je     80106668 <mappages+0x68>
      break;
    a += PGSIZE;
8010663f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106645:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106648:	b9 01 00 00 00       	mov    $0x1,%ecx
8010664d:	89 da                	mov    %ebx,%edx
8010664f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106652:	e8 19 ff ff ff       	call   80106570 <walkpgdir>
80106657:	85 c0                	test   %eax,%eax
80106659:	75 d5                	jne    80106630 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010665b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010665e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106663:	5b                   	pop    %ebx
80106664:	5e                   	pop    %esi
80106665:	5f                   	pop    %edi
80106666:	5d                   	pop    %ebp
80106667:	c3                   	ret    
80106668:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010666b:	31 c0                	xor    %eax,%eax
}
8010666d:	5b                   	pop    %ebx
8010666e:	5e                   	pop    %esi
8010666f:	5f                   	pop    %edi
80106670:	5d                   	pop    %ebp
80106671:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106672:	c7 04 24 80 78 10 80 	movl   $0x80107880,(%esp)
80106679:	e8 b2 9c ff ff       	call   80100330 <panic>
8010667e:	66 90                	xchg   %ax,%ax

80106680 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	57                   	push   %edi
80106684:	89 c7                	mov    %eax,%edi
80106686:	56                   	push   %esi
80106687:	89 d6                	mov    %edx,%esi
80106689:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010668a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106690:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106693:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106699:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010669b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010669e:	72 3b                	jb     801066db <deallocuvm.part.0+0x5b>
801066a0:	eb 5e                	jmp    80106700 <deallocuvm.part.0+0x80>
801066a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
801066a8:	8b 10                	mov    (%eax),%edx
801066aa:	f6 c2 01             	test   $0x1,%dl
801066ad:	74 22                	je     801066d1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801066af:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801066b5:	74 54                	je     8010670b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801066b7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801066bd:	89 14 24             	mov    %edx,(%esp)
801066c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066c3:	e8 18 bc ff ff       	call   801022e0 <kfree>
      *pte = 0;
801066c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066d7:	39 f3                	cmp    %esi,%ebx
801066d9:	73 25                	jae    80106700 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801066db:	31 c9                	xor    %ecx,%ecx
801066dd:	89 da                	mov    %ebx,%edx
801066df:	89 f8                	mov    %edi,%eax
801066e1:	e8 8a fe ff ff       	call   80106570 <walkpgdir>
    if(!pte)
801066e6:	85 c0                	test   %eax,%eax
801066e8:	75 be                	jne    801066a8 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
801066ea:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066f6:	39 f3                	cmp    %esi,%ebx
801066f8:	72 e1                	jb     801066db <deallocuvm.part.0+0x5b>
801066fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106700:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106703:	83 c4 1c             	add    $0x1c,%esp
80106706:	5b                   	pop    %ebx
80106707:	5e                   	pop    %esi
80106708:	5f                   	pop    %edi
80106709:	5d                   	pop    %ebp
8010670a:	c3                   	ret    
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010670b:	c7 04 24 d6 70 10 80 	movl   $0x801070d6,(%esp)
80106712:	e8 19 9c ff ff       	call   80100330 <panic>
80106717:	89 f6                	mov    %esi,%esi
80106719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106720 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106726:	e8 25 c0 ff ff       	call   80102750 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010672b:	31 c9                	xor    %ecx,%ecx
8010672d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106732:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106738:	05 e0 12 11 80       	add    $0x801112e0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010673d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106741:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106746:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010674a:	31 c9                	xor    %ecx,%ecx
8010674c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106753:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106758:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010675f:	31 c9                	xor    %ecx,%ecx
80106761:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106768:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010676d:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106774:	31 c9                	xor    %ecx,%ecx
80106776:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010677d:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106783:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010678a:	31 c9                	xor    %ecx,%ecx
8010678c:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
80106793:	89 d1                	mov    %edx,%ecx
80106795:	c1 e9 10             	shr    $0x10,%ecx
80106798:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
8010679f:	c1 ea 18             	shr    $0x18,%edx
801067a2:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801067a8:	b9 37 00 00 00       	mov    $0x37,%ecx
801067ad:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801067b3:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067b6:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
801067ba:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067be:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
801067c5:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067cc:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
801067d3:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067da:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
801067e1:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801067e8:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
801067ef:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
801067f6:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
801067fa:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801067fe:	c1 ea 10             	shr    $0x10,%edx
80106801:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106805:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106808:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010680c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106810:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106817:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010681e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80106825:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010682c:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80106833:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
8010683a:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
8010683d:	ba 18 00 00 00       	mov    $0x18,%edx
80106842:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106844:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010684b:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
8010684f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
80106855:	c9                   	leave  
80106856:	c3                   	ret    
80106857:	89 f6                	mov    %esi,%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106860 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	56                   	push   %esi
80106864:	53                   	push   %ebx
80106865:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106868:	e8 23 bc ff ff       	call   80102490 <kalloc>
8010686d:	85 c0                	test   %eax,%eax
8010686f:	89 c6                	mov    %eax,%esi
80106871:	74 55                	je     801068c8 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106873:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010687a:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010687b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106880:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106887:	00 
80106888:	89 04 24             	mov    %eax,(%esp)
8010688b:	e8 70 db ff ff       	call   80104400 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106890:	8b 53 0c             	mov    0xc(%ebx),%edx
80106893:	8b 43 04             	mov    0x4(%ebx),%eax
80106896:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106899:	89 54 24 04          	mov    %edx,0x4(%esp)
8010689d:	8b 13                	mov    (%ebx),%edx
8010689f:	89 04 24             	mov    %eax,(%esp)
801068a2:	29 c1                	sub    %eax,%ecx
801068a4:	89 f0                	mov    %esi,%eax
801068a6:	e8 55 fd ff ff       	call   80106600 <mappages>
801068ab:	85 c0                	test   %eax,%eax
801068ad:	78 19                	js     801068c8 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801068af:	83 c3 10             	add    $0x10,%ebx
801068b2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801068b8:	72 d6                	jb     80106890 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801068ba:	83 c4 10             	add    $0x10,%esp
801068bd:	89 f0                	mov    %esi,%eax
801068bf:	5b                   	pop    %ebx
801068c0:	5e                   	pop    %esi
801068c1:	5d                   	pop    %ebp
801068c2:	c3                   	ret    
801068c3:	90                   	nop
801068c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068c8:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801068cb:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801068cd:	5b                   	pop    %ebx
801068ce:	5e                   	pop    %esi
801068cf:	5d                   	pop    %ebp
801068d0:	c3                   	ret    
801068d1:	eb 0d                	jmp    801068e0 <kvmalloc>
801068d3:	90                   	nop
801068d4:	90                   	nop
801068d5:	90                   	nop
801068d6:	90                   	nop
801068d7:	90                   	nop
801068d8:	90                   	nop
801068d9:	90                   	nop
801068da:	90                   	nop
801068db:	90                   	nop
801068dc:	90                   	nop
801068dd:	90                   	nop
801068de:	90                   	nop
801068df:	90                   	nop

801068e0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801068e6:	e8 75 ff ff ff       	call   80106860 <setupkvm>
801068eb:	a3 64 40 11 80       	mov    %eax,0x80114064
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068f0:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068f5:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
801068f8:	c9                   	leave  
801068f9:	c3                   	ret    
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106900 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106900:	a1 64 40 11 80       	mov    0x80114064,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106905:	55                   	push   %ebp
80106906:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106908:	05 00 00 00 80       	add    $0x80000000,%eax
8010690d:	0f 22 d8             	mov    %eax,%cr3
}
80106910:	5d                   	pop    %ebp
80106911:	c3                   	ret    
80106912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106920 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	53                   	push   %ebx
80106924:	83 ec 14             	sub    $0x14,%esp
80106927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010692a:	e8 01 da ff ff       	call   80104330 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010692f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106935:	b9 67 00 00 00       	mov    $0x67,%ecx
8010693a:	8d 50 08             	lea    0x8(%eax),%edx
8010693d:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106944:	89 d1                	mov    %edx,%ecx
80106946:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
8010694d:	c1 ea 18             	shr    $0x18,%edx
80106950:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106956:	ba 10 00 00 00       	mov    $0x10,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010695b:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
80106962:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
80106965:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010696c:	66 89 50 10          	mov    %dx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106970:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106977:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
8010697d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106982:	8b 52 08             	mov    0x8(%edx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106985:	66 89 48 6e          	mov    %cx,0x6e(%eax)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106989:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010698f:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106992:	b8 30 00 00 00       	mov    $0x30,%eax
80106997:	0f 00 d8             	ltr    %ax
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
8010699a:	8b 43 04             	mov    0x4(%ebx),%eax
8010699d:	85 c0                	test   %eax,%eax
8010699f:	74 12                	je     801069b3 <switchuvm+0x93>
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
801069a1:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069a6:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801069a9:	83 c4 14             	add    $0x14,%esp
801069ac:	5b                   	pop    %ebx
801069ad:	5d                   	pop    %ebp
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801069ae:	e9 ad d9 ff ff       	jmp    80104360 <popcli>
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801069b3:	c7 04 24 86 78 10 80 	movl   $0x80107886,(%esp)
801069ba:	e8 71 99 ff ff       	call   80100330 <panic>
801069bf:	90                   	nop

801069c0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 1c             	sub    $0x1c,%esp
801069c9:	8b 75 10             	mov    0x10(%ebp),%esi
801069cc:	8b 45 08             	mov    0x8(%ebp),%eax
801069cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801069d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801069db:	77 54                	ja     80106a31 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
801069dd:	e8 ae ba ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
801069e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069e9:	00 
801069ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069f1:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801069f2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801069f4:	89 04 24             	mov    %eax,(%esp)
801069f7:	e8 04 da ff ff       	call   80104400 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801069fc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a02:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a07:	89 04 24             	mov    %eax,(%esp)
80106a0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a0d:	31 d2                	xor    %edx,%edx
80106a0f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106a16:	00 
80106a17:	e8 e4 fb ff ff       	call   80106600 <mappages>
  memmove(mem, init, sz);
80106a1c:	89 75 10             	mov    %esi,0x10(%ebp)
80106a1f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a22:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a25:	83 c4 1c             	add    $0x1c,%esp
80106a28:	5b                   	pop    %ebx
80106a29:	5e                   	pop    %esi
80106a2a:	5f                   	pop    %edi
80106a2b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a2c:	e9 6f da ff ff       	jmp    801044a0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a31:	c7 04 24 9a 78 10 80 	movl   $0x8010789a,(%esp)
80106a38:	e8 f3 98 ff ff       	call   80100330 <panic>
80106a3d:	8d 76 00             	lea    0x0(%esi),%esi

80106a40 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
80106a46:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106a49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a50:	0f 85 98 00 00 00    	jne    80106aee <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106a56:	8b 75 18             	mov    0x18(%ebp),%esi
80106a59:	31 db                	xor    %ebx,%ebx
80106a5b:	85 f6                	test   %esi,%esi
80106a5d:	75 1a                	jne    80106a79 <loaduvm+0x39>
80106a5f:	eb 77                	jmp    80106ad8 <loaduvm+0x98>
80106a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a77:	76 5f                	jbe    80106ad8 <loaduvm+0x98>
80106a79:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a7c:	31 c9                	xor    %ecx,%ecx
80106a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a81:	01 da                	add    %ebx,%edx
80106a83:	e8 e8 fa ff ff       	call   80106570 <walkpgdir>
80106a88:	85 c0                	test   %eax,%eax
80106a8a:	74 56                	je     80106ae2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a8c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106a8e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106a93:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106a9b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106aa1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106aa4:	05 00 00 00 80       	add    $0x80000000,%eax
80106aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aad:	8b 45 10             	mov    0x10(%ebp),%eax
80106ab0:	01 d9                	add    %ebx,%ecx
80106ab2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106ab6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106aba:	89 04 24             	mov    %eax,(%esp)
80106abd:	e8 7e ae ff ff       	call   80101940 <readi>
80106ac2:	39 f8                	cmp    %edi,%eax
80106ac4:	74 a2                	je     80106a68 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106ac6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ace:	5b                   	pop    %ebx
80106acf:	5e                   	pop    %esi
80106ad0:	5f                   	pop    %edi
80106ad1:	5d                   	pop    %ebp
80106ad2:	c3                   	ret    
80106ad3:	90                   	nop
80106ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ad8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106adb:	31 c0                	xor    %eax,%eax
}
80106add:	5b                   	pop    %ebx
80106ade:	5e                   	pop    %esi
80106adf:	5f                   	pop    %edi
80106ae0:	5d                   	pop    %ebp
80106ae1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106ae2:	c7 04 24 b4 78 10 80 	movl   $0x801078b4,(%esp)
80106ae9:	e8 42 98 ff ff       	call   80100330 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106aee:	c7 04 24 58 79 10 80 	movl   $0x80107958,(%esp)
80106af5:	e8 36 98 ff ff       	call   80100330 <panic>
80106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b00 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	57                   	push   %edi
80106b04:	56                   	push   %esi
80106b05:	53                   	push   %ebx
80106b06:	83 ec 1c             	sub    $0x1c,%esp
80106b09:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106b0c:	85 ff                	test   %edi,%edi
80106b0e:	0f 88 7e 00 00 00    	js     80106b92 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106b14:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106b1a:	72 78                	jb     80106b94 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b1c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b22:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b28:	39 df                	cmp    %ebx,%edi
80106b2a:	77 4a                	ja     80106b76 <allocuvm+0x76>
80106b2c:	eb 72                	jmp    80106ba0 <allocuvm+0xa0>
80106b2e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b30:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b37:	00 
80106b38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b3f:	00 
80106b40:	89 04 24             	mov    %eax,(%esp)
80106b43:	e8 b8 d8 ff ff       	call   80104400 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b48:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b53:	89 04 24             	mov    %eax,(%esp)
80106b56:	8b 45 08             	mov    0x8(%ebp),%eax
80106b59:	89 da                	mov    %ebx,%edx
80106b5b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106b62:	00 
80106b63:	e8 98 fa ff ff       	call   80106600 <mappages>
80106b68:	85 c0                	test   %eax,%eax
80106b6a:	78 44                	js     80106bb0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106b6c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b72:	39 df                	cmp    %ebx,%edi
80106b74:	76 2a                	jbe    80106ba0 <allocuvm+0xa0>
    mem = kalloc();
80106b76:	e8 15 b9 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80106b7b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106b7d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106b7f:	75 af                	jne    80106b30 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106b81:	c7 04 24 d2 78 10 80 	movl   $0x801078d2,(%esp)
80106b88:	e8 93 9a ff ff       	call   80100620 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b8d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b90:	77 48                	ja     80106bda <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106b92:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106b94:	83 c4 1c             	add    $0x1c,%esp
80106b97:	5b                   	pop    %ebx
80106b98:	5e                   	pop    %esi
80106b99:	5f                   	pop    %edi
80106b9a:	5d                   	pop    %ebp
80106b9b:	c3                   	ret    
80106b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ba0:	83 c4 1c             	add    $0x1c,%esp
80106ba3:	89 f8                	mov    %edi,%eax
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106bb0:	c7 04 24 ea 78 10 80 	movl   $0x801078ea,(%esp)
80106bb7:	e8 64 9a ff ff       	call   80100620 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bbc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bbf:	76 0d                	jbe    80106bce <allocuvm+0xce>
80106bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bc4:	89 fa                	mov    %edi,%edx
80106bc6:	8b 45 08             	mov    0x8(%ebp),%eax
80106bc9:	e8 b2 fa ff ff       	call   80106680 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106bce:	89 34 24             	mov    %esi,(%esp)
80106bd1:	e8 0a b7 ff ff       	call   801022e0 <kfree>
      return 0;
80106bd6:	31 c0                	xor    %eax,%eax
80106bd8:	eb ba                	jmp    80106b94 <allocuvm+0x94>
80106bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bdd:	89 fa                	mov    %edi,%edx
80106bdf:	8b 45 08             	mov    0x8(%ebp),%eax
80106be2:	e8 99 fa ff ff       	call   80106680 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106be7:	31 c0                	xor    %eax,%eax
80106be9:	eb a9                	jmp    80106b94 <allocuvm+0x94>
80106beb:	90                   	nop
80106bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106bf0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bfc:	39 d1                	cmp    %edx,%ecx
80106bfe:	73 08                	jae    80106c08 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c00:	5d                   	pop    %ebp
80106c01:	e9 7a fa ff ff       	jmp    80106680 <deallocuvm.part.0>
80106c06:	66 90                	xchg   %ax,%ax
80106c08:	89 d0                	mov    %edx,%eax
80106c0a:	5d                   	pop    %ebp
80106c0b:	c3                   	ret    
80106c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	56                   	push   %esi
80106c14:	53                   	push   %ebx
80106c15:	83 ec 10             	sub    $0x10,%esp
80106c18:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c1b:	85 f6                	test   %esi,%esi
80106c1d:	74 59                	je     80106c78 <freevm+0x68>
80106c1f:	31 c9                	xor    %ecx,%ecx
80106c21:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c26:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c28:	31 db                	xor    %ebx,%ebx
80106c2a:	e8 51 fa ff ff       	call   80106680 <deallocuvm.part.0>
80106c2f:	eb 12                	jmp    80106c43 <freevm+0x33>
80106c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c38:	83 c3 01             	add    $0x1,%ebx
80106c3b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106c41:	74 27                	je     80106c6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106c43:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106c46:	f6 c2 01             	test   $0x1,%dl
80106c49:	74 ed                	je     80106c38 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106c4b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c51:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106c54:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106c5a:	89 14 24             	mov    %edx,(%esp)
80106c5d:	e8 7e b6 ff ff       	call   801022e0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c62:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106c68:	75 d9                	jne    80106c43 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106c6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c6d:	83 c4 10             	add    $0x10,%esp
80106c70:	5b                   	pop    %ebx
80106c71:	5e                   	pop    %esi
80106c72:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106c73:	e9 68 b6 ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106c78:	c7 04 24 06 79 10 80 	movl   $0x80107906,(%esp)
80106c7f:	e8 ac 96 ff ff       	call   80100330 <panic>
80106c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c91:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c93:	89 e5                	mov    %esp,%ebp
80106c95:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9e:	e8 cd f8 ff ff       	call   80106570 <walkpgdir>
  if(pte == 0)
80106ca3:	85 c0                	test   %eax,%eax
80106ca5:	74 05                	je     80106cac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ca7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106caa:	c9                   	leave  
80106cab:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106cac:	c7 04 24 17 79 10 80 	movl   $0x80107917,(%esp)
80106cb3:	e8 78 96 ff ff       	call   80100330 <panic>
80106cb8:	90                   	nop
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106cc0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106cc9:	e8 92 fb ff ff       	call   80106860 <setupkvm>
80106cce:	85 c0                	test   %eax,%eax
80106cd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cd3:	0f 84 b2 00 00 00    	je     80106d8b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cdc:	85 c0                	test   %eax,%eax
80106cde:	0f 84 9c 00 00 00    	je     80106d80 <copyuvm+0xc0>
80106ce4:	31 db                	xor    %ebx,%ebx
80106ce6:	eb 48                	jmp    80106d30 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ce8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106cee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106cf5:	00 
80106cf6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106cfa:	89 04 24             	mov    %eax,(%esp)
80106cfd:	e8 9e d7 ff ff       	call   801044a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d05:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106d0b:	89 14 24             	mov    %edx,(%esp)
80106d0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d13:	89 da                	mov    %ebx,%edx
80106d15:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d1c:	e8 df f8 ff ff       	call   80106600 <mappages>
80106d21:	85 c0                	test   %eax,%eax
80106d23:	78 41                	js     80106d66 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106d25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d2b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106d2e:	76 50                	jbe    80106d80 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106d30:	8b 45 08             	mov    0x8(%ebp),%eax
80106d33:	31 c9                	xor    %ecx,%ecx
80106d35:	89 da                	mov    %ebx,%edx
80106d37:	e8 34 f8 ff ff       	call   80106570 <walkpgdir>
80106d3c:	85 c0                	test   %eax,%eax
80106d3e:	74 5b                	je     80106d9b <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106d40:	8b 30                	mov    (%eax),%esi
80106d42:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106d48:	74 45                	je     80106d8f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106d4a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106d4c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106d52:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106d55:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106d5b:	e8 30 b7 ff ff       	call   80102490 <kalloc>
80106d60:	85 c0                	test   %eax,%eax
80106d62:	89 c6                	mov    %eax,%esi
80106d64:	75 82                	jne    80106ce8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d69:	89 04 24             	mov    %eax,(%esp)
80106d6c:	e8 9f fe ff ff       	call   80106c10 <freevm>
  return 0;
80106d71:	31 c0                	xor    %eax,%eax
}
80106d73:	83 c4 2c             	add    $0x2c,%esp
80106d76:	5b                   	pop    %ebx
80106d77:	5e                   	pop    %esi
80106d78:	5f                   	pop    %edi
80106d79:	5d                   	pop    %ebp
80106d7a:	c3                   	ret    
80106d7b:	90                   	nop
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d83:	83 c4 2c             	add    $0x2c,%esp
80106d86:	5b                   	pop    %ebx
80106d87:	5e                   	pop    %esi
80106d88:	5f                   	pop    %edi
80106d89:	5d                   	pop    %ebp
80106d8a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106d8b:	31 c0                	xor    %eax,%eax
80106d8d:	eb e4                	jmp    80106d73 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106d8f:	c7 04 24 3b 79 10 80 	movl   $0x8010793b,(%esp)
80106d96:	e8 95 95 ff ff       	call   80100330 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106d9b:	c7 04 24 21 79 10 80 	movl   $0x80107921,(%esp)
80106da2:	e8 89 95 ff ff       	call   80100330 <panic>
80106da7:	89 f6                	mov    %esi,%esi
80106da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106db0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106db0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106db1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106db3:	89 e5                	mov    %esp,%ebp
80106db5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106db8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dbe:	e8 ad f7 ff ff       	call   80106570 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106dc3:	8b 00                	mov    (%eax),%eax
80106dc5:	89 c2                	mov    %eax,%edx
80106dc7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106dca:	83 fa 05             	cmp    $0x5,%edx
80106dcd:	75 11                	jne    80106de0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106dcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dd4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106dd9:	c9                   	leave  
80106dda:	c3                   	ret    
80106ddb:	90                   	nop
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106de0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106de2:	c9                   	leave  
80106de3:	c3                   	ret    
80106de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106df0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
80106df9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e02:	85 db                	test   %ebx,%ebx
80106e04:	75 3a                	jne    80106e40 <copyout+0x50>
80106e06:	eb 68                	jmp    80106e70 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106e08:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e0b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106e0d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106e11:	29 ca                	sub    %ecx,%edx
80106e13:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106e19:	39 da                	cmp    %ebx,%edx
80106e1b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106e1e:	29 f1                	sub    %esi,%ecx
80106e20:	01 c8                	add    %ecx,%eax
80106e22:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e26:	89 04 24             	mov    %eax,(%esp)
80106e29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106e2c:	e8 6f d6 ff ff       	call   801044a0 <memmove>
    len -= n;
    buf += n;
80106e31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106e34:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106e3a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106e3c:	29 d3                	sub    %edx,%ebx
80106e3e:	74 30                	je     80106e70 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106e40:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106e43:	89 ce                	mov    %ecx,%esi
80106e45:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106e4b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106e4f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106e52:	89 04 24             	mov    %eax,(%esp)
80106e55:	e8 56 ff ff ff       	call   80106db0 <uva2ka>
    if(pa0 == 0)
80106e5a:	85 c0                	test   %eax,%eax
80106e5c:	75 aa                	jne    80106e08 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106e5e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106e66:	5b                   	pop    %ebx
80106e67:	5e                   	pop    %esi
80106e68:	5f                   	pop    %edi
80106e69:	5d                   	pop    %ebp
80106e6a:	c3                   	ret    
80106e6b:	90                   	nop
80106e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e70:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106e73:	31 c0                	xor    %eax,%eax
}
80106e75:	5b                   	pop    %ebx
80106e76:	5e                   	pop    %esi
80106e77:	5f                   	pop    %edi
80106e78:	5d                   	pop    %ebp
80106e79:	c3                   	ret    
