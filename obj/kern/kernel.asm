
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start-0xc>:
.long MULTIBOOT_HEADER_FLAGS
.long CHECKSUM

.globl		_start
_start:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fb                   	sti    
f0100009:	4f                   	dec    %edi
f010000a:	52                   	push   %edx
f010000b:	e4 66                	in     $0x66,%al

f010000c <_start>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 

	# Establish our own GDT in place of the boot loader's temporary GDT.
	lgdt	RELOC(mygdtdesc)		# load descriptor table
f0100015:	0f 01 15 18 d0 11 00 	lgdtl  0x11d018

	# Immediately reload all segment registers (including CS!)
	# with segment selectors from the new GDT.
	movl	$DATA_SEL, %eax			# Data segment selector
f010001c:	b8 10 00 00 00       	mov    $0x10,%eax
	movw	%ax,%ds				# -> DS: Data Segment
f0100021:	8e d8                	mov    %eax,%ds
	movw	%ax,%es				# -> ES: Extra Segment
f0100023:	8e c0                	mov    %eax,%es
	movw	%ax,%ss				# -> SS: Stack Segment
f0100025:	8e d0                	mov    %eax,%ss
	ljmp	$CODE_SEL,$relocated		# reload CS by jumping
f0100027:	ea 2e 00 10 f0 08 00 	ljmp   $0x8,$0xf010002e

f010002e <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002e:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Leave a few words on the stack for the user trap frame
	movl	$(bootstacktop-SIZEOF_STRUCT_TRAPFRAME),%esp
f0100033:	bc bc cf 11 f0       	mov    $0xf011cfbc,%esp

	# now to C code
	call	i386_init
f0100038:	e8 a7 00 00 00       	call   f01000e4 <i386_init>

f010003d <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003d:	eb fe                	jmp    f010003d <spin>
	...

f0100040 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 14             	sub    $0x14,%esp
		monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
f0100047:	8d 5d 14             	lea    0x14(%ebp),%ebx
{
	va_list ap;

	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d: ", file, line);
f010004a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010004d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100051:	8b 45 08             	mov    0x8(%ebp),%eax
f0100054:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100058:	c7 04 24 80 57 10 f0 	movl   $0xf0105780,(%esp)
f010005f:	e8 03 29 00 00       	call   f0102967 <cprintf>
	vcprintf(fmt, ap);
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 c1 28 00 00       	call   f0102934 <vcprintf>
	cprintf("\n");
f0100073:	c7 04 24 62 5c 10 f0 	movl   $0xf0105c62,(%esp)
f010007a:	e8 e8 28 00 00       	call   f0102967 <cprintf>
	va_end(ap);
}
f010007f:	83 c4 14             	add    $0x14,%esp
f0100082:	5b                   	pop    %ebx
f0100083:	5d                   	pop    %ebp
f0100084:	c3                   	ret    

f0100085 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100085:	55                   	push   %ebp
f0100086:	89 e5                	mov    %esp,%ebp
f0100088:	56                   	push   %esi
f0100089:	53                   	push   %ebx
f010008a:	83 ec 10             	sub    $0x10,%esp
f010008d:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100090:	83 3d 00 33 3c f0 00 	cmpl   $0x0,0xf03c3300
f0100097:	75 3d                	jne    f01000d6 <_panic+0x51>
		goto dead;
	panicstr = fmt;
f0100099:	89 35 00 33 3c f0    	mov    %esi,0xf03c3300

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f010009f:	fa                   	cli    
f01000a0:	fc                   	cld    
/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
f01000a1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");

	va_start(ap, fmt);
	cprintf("kernel panic at %s:%d: ", file, line);
f01000a4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01000a7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
f01000b2:	c7 04 24 9a 57 10 f0 	movl   $0xf010579a,(%esp)
f01000b9:	e8 a9 28 00 00       	call   f0102967 <cprintf>
	vcprintf(fmt, ap);
f01000be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000c2:	89 34 24             	mov    %esi,(%esp)
f01000c5:	e8 6a 28 00 00       	call   f0102934 <vcprintf>
	cprintf("\n");
f01000ca:	c7 04 24 62 5c 10 f0 	movl   $0xf0105c62,(%esp)
f01000d1:	e8 91 28 00 00       	call   f0102967 <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000dd:	e8 0a 08 00 00       	call   f01008ec <monitor>
f01000e2:	eb f2                	jmp    f01000d6 <_panic+0x51>

f01000e4 <i386_init>:
#include <kern/pci.h>


void
i386_init(void)
{
f01000e4:	55                   	push   %ebp
f01000e5:	89 e5                	mov    %esp,%ebp
f01000e7:	83 ec 18             	sub    $0x18,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f01000ea:	b8 88 8a 3c f0       	mov    $0xf03c8a88,%eax
f01000ef:	2d ff 32 3c f0       	sub    $0xf03c32ff,%eax
f01000f4:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01000ff:	00 
f0100100:	c7 04 24 ff 32 3c f0 	movl   $0xf03c32ff,(%esp)
f0100107:	e8 2a 45 00 00       	call   f0104636 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010010c:	e8 b4 04 00 00       	call   f01005c5 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100111:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f0100118:	00 
f0100119:	c7 04 24 b2 57 10 f0 	movl   $0xf01057b2,(%esp)
f0100120:	e8 42 28 00 00       	call   f0102967 <cprintf>
	cprintf(" end = %x \n", end);
f0100125:	c7 44 24 04 88 8a 3c 	movl   $0xf03c8a88,0x4(%esp)
f010012c:	f0 
f010012d:	c7 04 24 cd 57 10 f0 	movl   $0xf01057cd,(%esp)
f0100134:	e8 2e 28 00 00       	call   f0102967 <cprintf>

	// Lab 2 memory management initialization functions
	i386_detect_memory();
f0100139:	e8 25 16 00 00       	call   f0101763 <i386_detect_memory>
	i386_vm_init();
f010013e:	e8 e1 16 00 00       	call   f0101824 <i386_vm_init>

	// Lab 3 user environment initialization functions
	env_init();
f0100143:	e8 0b 20 00 00       	call   f0102153 <env_init>
	idt_init();
f0100148:	e8 53 28 00 00       	call   f01029a0 <idt_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f010014d:	8d 76 00             	lea    0x0(%esi),%esi
f0100150:	e8 53 27 00 00       	call   f01028a8 <pic_init>
	kclock_init();
f0100155:	e8 7a 26 00 00       	call   f01027d4 <kclock_init>

	time_init();
f010015a:	e8 4d 53 00 00       	call   f01054ac <time_init>
	pci_init();
f010015f:	90                   	nop
f0100160:	e8 73 50 00 00       	call   f01051d8 <pci_init>

	// Should always have an idle process as first one.
	ENV_CREATE(user_idle);
f0100165:	c7 44 24 04 61 42 01 	movl   $0x14261,0x4(%esp)
f010016c:	00 
f010016d:	c7 04 24 3b 36 13 f0 	movl   $0xf013363b,(%esp)
f0100174:	e8 f7 24 00 00       	call   f0102670 <env_create>

	// Start fs.
	ENV_CREATE(fs_fs);
f0100179:	c7 44 24 04 02 d9 01 	movl   $0x1d902,0x4(%esp)
f0100180:	00 
f0100181:	c7 04 24 42 7e 32 f0 	movl   $0xf0327e42,(%esp)
f0100188:	e8 e3 24 00 00       	call   f0102670 <env_create>

#if !defined(TEST_NO_NS)
	// Start ns.
	ENV_CREATE(net_ns);
f010018d:	c7 44 24 04 f8 02 05 	movl   $0x502f8,0x4(%esp)
f0100194:	00 
f0100195:	c7 04 24 07 30 37 f0 	movl   $0xf0373007,(%esp)
f010019c:	e8 cf 24 00 00       	call   f0102670 <env_create>
	// ENV_CREATE(user_faultread);
	// ENV_CREATE(user_faultdie);
	// ENV_CREATE(user_faultalloc);
	// ENV_CREATE(user_faultallocbad);
	// ENV_CREATE(user_pingpong);
	 ENV_CREATE(user_testsimplefork);
f01001a1:	c7 44 24 04 44 53 01 	movl   $0x15344,0x4(%esp)
f01001a8:	00 
f01001a9:	c7 04 24 fb 07 1b f0 	movl   $0xf01b07fb,(%esp)
f01001b0:	e8 bb 24 00 00       	call   f0102670 <env_create>
	// ENV_CREATE(user_icode);
	// ENV_CREATE(user_testsimple);
#endif // TEST*

	// Should not be necessary - drains keyboard because interrupt has given up.
	kbd_intr();
f01001b5:	e8 78 00 00 00       	call   f0100232 <kbd_intr>

	// Schedule and run the first user environment!
	sched_yield();
f01001ba:	e8 f1 2e 00 00       	call   f01030b0 <sched_yield>
	...

f01001c0 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f01001c0:	55                   	push   %ebp
f01001c1:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01001c3:	ba 84 00 00 00       	mov    $0x84,%edx
f01001c8:	ec                   	in     (%dx),%al
f01001c9:	ec                   	in     (%dx),%al
f01001ca:	ec                   	in     (%dx),%al
f01001cb:	ec                   	in     (%dx),%al
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f01001cc:	5d                   	pop    %ebp
f01001cd:	c3                   	ret    

f01001ce <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f01001ce:	55                   	push   %ebp
f01001cf:	89 e5                	mov    %esp,%ebp
f01001d1:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01001d6:	ec                   	in     (%dx),%al
f01001d7:	89 c2                	mov    %eax,%edx
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01001d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01001de:	f6 c2 01             	test   $0x1,%dl
f01001e1:	74 09                	je     f01001ec <serial_proc_data+0x1e>
f01001e3:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01001e8:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01001e9:	0f b6 c0             	movzbl %al,%eax
}
f01001ec:	5d                   	pop    %ebp
f01001ed:	c3                   	ret    

f01001ee <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01001ee:	55                   	push   %ebp
f01001ef:	89 e5                	mov    %esp,%ebp
f01001f1:	57                   	push   %edi
f01001f2:	56                   	push   %esi
f01001f3:	53                   	push   %ebx
f01001f4:	83 ec 0c             	sub    $0xc,%esp
f01001f7:	89 c6                	mov    %eax,%esi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f01001f9:	bb 44 35 3c f0       	mov    $0xf03c3544,%ebx
f01001fe:	bf 40 33 3c f0       	mov    $0xf03c3340,%edi
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f0100203:	eb 1e                	jmp    f0100223 <cons_intr+0x35>
		if (c == 0)
f0100205:	85 c0                	test   %eax,%eax
f0100207:	74 1a                	je     f0100223 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
f0100209:	8b 13                	mov    (%ebx),%edx
f010020b:	88 04 17             	mov    %al,(%edi,%edx,1)
f010020e:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
f0100211:	3d 00 02 00 00       	cmp    $0x200,%eax
			cons.wpos = 0;
f0100216:	0f 94 c2             	sete   %dl
f0100219:	0f b6 d2             	movzbl %dl,%edx
f010021c:	83 ea 01             	sub    $0x1,%edx
f010021f:	21 d0                	and    %edx,%eax
f0100221:	89 03                	mov    %eax,(%ebx)
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f0100223:	ff d6                	call   *%esi
f0100225:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100228:	75 db                	jne    f0100205 <cons_intr+0x17>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f010022a:	83 c4 0c             	add    $0xc,%esp
f010022d:	5b                   	pop    %ebx
f010022e:	5e                   	pop    %esi
f010022f:	5f                   	pop    %edi
f0100230:	5d                   	pop    %ebp
f0100231:	c3                   	ret    

f0100232 <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f0100232:	55                   	push   %ebp
f0100233:	89 e5                	mov    %esp,%ebp
f0100235:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100238:	b8 ca 04 10 f0       	mov    $0xf01004ca,%eax
f010023d:	e8 ac ff ff ff       	call   f01001ee <cons_intr>
}
f0100242:	c9                   	leave  
f0100243:	c3                   	ret    

f0100244 <serial_intr>:
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f0100244:	55                   	push   %ebp
f0100245:	89 e5                	mov    %esp,%ebp
f0100247:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
f010024a:	83 3d 24 33 3c f0 00 	cmpl   $0x0,0xf03c3324
f0100251:	74 0a                	je     f010025d <serial_intr+0x19>
		cons_intr(serial_proc_data);
f0100253:	b8 ce 01 10 f0       	mov    $0xf01001ce,%eax
f0100258:	e8 91 ff ff ff       	call   f01001ee <cons_intr>
}
f010025d:	c9                   	leave  
f010025e:	c3                   	ret    

f010025f <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f010025f:	55                   	push   %ebp
f0100260:	89 e5                	mov    %esp,%ebp
f0100262:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f0100265:	e8 da ff ff ff       	call   f0100244 <serial_intr>
	kbd_intr();
f010026a:	e8 c3 ff ff ff       	call   f0100232 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f010026f:	8b 15 40 35 3c f0    	mov    0xf03c3540,%edx
f0100275:	b8 00 00 00 00       	mov    $0x0,%eax
f010027a:	3b 15 44 35 3c f0    	cmp    0xf03c3544,%edx
f0100280:	74 21                	je     f01002a3 <cons_getc+0x44>
		c = cons.buf[cons.rpos++];
f0100282:	0f b6 82 40 33 3c f0 	movzbl -0xfc3ccc0(%edx),%eax
f0100289:	83 c2 01             	add    $0x1,%edx
		if (cons.rpos == CONSBUFSIZE)
f010028c:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.rpos = 0;
f0100292:	0f 94 c1             	sete   %cl
f0100295:	0f b6 c9             	movzbl %cl,%ecx
f0100298:	83 e9 01             	sub    $0x1,%ecx
f010029b:	21 ca                	and    %ecx,%edx
f010029d:	89 15 40 35 3c f0    	mov    %edx,0xf03c3540
		return c;
	}
	return 0;
}
f01002a3:	c9                   	leave  
f01002a4:	c3                   	ret    

f01002a5 <getchar>:
	cons_putc(c);
}

int
getchar(void)
{
f01002a5:	55                   	push   %ebp
f01002a6:	89 e5                	mov    %esp,%ebp
f01002a8:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01002ab:	e8 af ff ff ff       	call   f010025f <cons_getc>
f01002b0:	85 c0                	test   %eax,%eax
f01002b2:	74 f7                	je     f01002ab <getchar+0x6>
		/* do nothing */;
	return c;
}
f01002b4:	c9                   	leave  
f01002b5:	c3                   	ret    

f01002b6 <iscons>:

int
iscons(int fdnum)
{
f01002b6:	55                   	push   %ebp
f01002b7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01002b9:	b8 01 00 00 00       	mov    $0x1,%eax
f01002be:	5d                   	pop    %ebp
f01002bf:	c3                   	ret    

f01002c0 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01002c0:	55                   	push   %ebp
f01002c1:	89 e5                	mov    %esp,%ebp
f01002c3:	57                   	push   %edi
f01002c4:	56                   	push   %esi
f01002c5:	53                   	push   %ebx
f01002c6:	83 ec 2c             	sub    $0x2c,%esp
f01002c9:	89 c7                	mov    %eax,%edi
f01002cb:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002d0:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01002d1:	a8 20                	test   $0x20,%al
f01002d3:	75 21                	jne    f01002f6 <cons_putc+0x36>
f01002d5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01002da:	be fd 03 00 00       	mov    $0x3fd,%esi
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f01002df:	e8 dc fe ff ff       	call   f01001c0 <delay>
f01002e4:	89 f2                	mov    %esi,%edx
f01002e6:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01002e7:	a8 20                	test   $0x20,%al
f01002e9:	75 0b                	jne    f01002f6 <cons_putc+0x36>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
f01002eb:	83 c3 01             	add    $0x1,%ebx
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01002ee:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f01002f4:	75 e9                	jne    f01002df <cons_putc+0x1f>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
	
	outb(COM1 + COM_TX, c);
f01002f6:	89 fa                	mov    %edi,%edx
f01002f8:	89 f8                	mov    %edi,%eax
f01002fa:	88 55 e7             	mov    %dl,-0x19(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002fd:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100302:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100303:	b2 79                	mov    $0x79,%dl
f0100305:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100306:	84 c0                	test   %al,%al
f0100308:	78 21                	js     f010032b <cons_putc+0x6b>
f010030a:	bb 00 00 00 00       	mov    $0x0,%ebx
f010030f:	be 79 03 00 00       	mov    $0x379,%esi
		delay();
f0100314:	e8 a7 fe ff ff       	call   f01001c0 <delay>
f0100319:	89 f2                	mov    %esi,%edx
f010031b:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010031c:	84 c0                	test   %al,%al
f010031e:	78 0b                	js     f010032b <cons_putc+0x6b>
f0100320:	83 c3 01             	add    $0x1,%ebx
f0100323:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f0100329:	75 e9                	jne    f0100314 <cons_putc+0x54>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010032b:	ba 78 03 00 00       	mov    $0x378,%edx
f0100330:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100334:	ee                   	out    %al,(%dx)
f0100335:	b2 7a                	mov    $0x7a,%dl
f0100337:	b8 0d 00 00 00       	mov    $0xd,%eax
f010033c:	ee                   	out    %al,(%dx)
f010033d:	b8 08 00 00 00       	mov    $0x8,%eax
f0100342:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f0100343:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f0100349:	75 06                	jne    f0100351 <cons_putc+0x91>
		c |= 0x0700;	// Most significant nibble is for background color and the next one is for text or foreground color
f010034b:	81 cf 00 07 00 00    	or     $0x700,%edi

	switch (c & 0xff) {
f0100351:	89 f8                	mov    %edi,%eax
f0100353:	25 ff 00 00 00       	and    $0xff,%eax
f0100358:	83 f8 09             	cmp    $0x9,%eax
f010035b:	0f 84 83 00 00 00    	je     f01003e4 <cons_putc+0x124>
f0100361:	83 f8 09             	cmp    $0x9,%eax
f0100364:	7f 0c                	jg     f0100372 <cons_putc+0xb2>
f0100366:	83 f8 08             	cmp    $0x8,%eax
f0100369:	0f 85 a9 00 00 00    	jne    f0100418 <cons_putc+0x158>
f010036f:	90                   	nop
f0100370:	eb 18                	jmp    f010038a <cons_putc+0xca>
f0100372:	83 f8 0a             	cmp    $0xa,%eax
f0100375:	8d 76 00             	lea    0x0(%esi),%esi
f0100378:	74 40                	je     f01003ba <cons_putc+0xfa>
f010037a:	83 f8 0d             	cmp    $0xd,%eax
f010037d:	8d 76 00             	lea    0x0(%esi),%esi
f0100380:	0f 85 92 00 00 00    	jne    f0100418 <cons_putc+0x158>
f0100386:	66 90                	xchg   %ax,%ax
f0100388:	eb 38                	jmp    f01003c2 <cons_putc+0x102>
	case '\b':
		if (crt_pos > 0) {
f010038a:	0f b7 05 30 33 3c f0 	movzwl 0xf03c3330,%eax
f0100391:	66 85 c0             	test   %ax,%ax
f0100394:	0f 84 e8 00 00 00    	je     f0100482 <cons_putc+0x1c2>
			crt_pos--;
f010039a:	83 e8 01             	sub    $0x1,%eax
f010039d:	66 a3 30 33 3c f0    	mov    %ax,0xf03c3330
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01003a3:	0f b7 c0             	movzwl %ax,%eax
f01003a6:	66 81 e7 00 ff       	and    $0xff00,%di
f01003ab:	83 cf 20             	or     $0x20,%edi
f01003ae:	8b 15 2c 33 3c f0    	mov    0xf03c332c,%edx
f01003b4:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01003b8:	eb 7b                	jmp    f0100435 <cons_putc+0x175>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f01003ba:	66 83 05 30 33 3c f0 	addw   $0x50,0xf03c3330
f01003c1:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f01003c2:	0f b7 05 30 33 3c f0 	movzwl 0xf03c3330,%eax
f01003c9:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01003cf:	c1 e8 10             	shr    $0x10,%eax
f01003d2:	66 c1 e8 06          	shr    $0x6,%ax
f01003d6:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01003d9:	c1 e0 04             	shl    $0x4,%eax
f01003dc:	66 a3 30 33 3c f0    	mov    %ax,0xf03c3330
f01003e2:	eb 51                	jmp    f0100435 <cons_putc+0x175>
		break;
	case '\t':
		cons_putc(' ');
f01003e4:	b8 20 00 00 00       	mov    $0x20,%eax
f01003e9:	e8 d2 fe ff ff       	call   f01002c0 <cons_putc>
		cons_putc(' ');
f01003ee:	b8 20 00 00 00       	mov    $0x20,%eax
f01003f3:	e8 c8 fe ff ff       	call   f01002c0 <cons_putc>
		cons_putc(' ');
f01003f8:	b8 20 00 00 00       	mov    $0x20,%eax
f01003fd:	e8 be fe ff ff       	call   f01002c0 <cons_putc>
		cons_putc(' ');
f0100402:	b8 20 00 00 00       	mov    $0x20,%eax
f0100407:	e8 b4 fe ff ff       	call   f01002c0 <cons_putc>
		cons_putc(' ');
f010040c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100411:	e8 aa fe ff ff       	call   f01002c0 <cons_putc>
f0100416:	eb 1d                	jmp    f0100435 <cons_putc+0x175>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f0100418:	0f b7 05 30 33 3c f0 	movzwl 0xf03c3330,%eax
f010041f:	0f b7 c8             	movzwl %ax,%ecx
f0100422:	8b 15 2c 33 3c f0    	mov    0xf03c332c,%edx
f0100428:	66 89 3c 4a          	mov    %di,(%edx,%ecx,2)
f010042c:	83 c0 01             	add    $0x1,%eax
f010042f:	66 a3 30 33 3c f0    	mov    %ax,0xf03c3330
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f0100435:	66 81 3d 30 33 3c f0 	cmpw   $0x7cf,0xf03c3330
f010043c:	cf 07 
f010043e:	76 42                	jbe    f0100482 <cons_putc+0x1c2>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100440:	a1 2c 33 3c f0       	mov    0xf03c332c,%eax
f0100445:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f010044c:	00 
f010044d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100453:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100457:	89 04 24             	mov    %eax,(%esp)
f010045a:	e8 36 42 00 00       	call   f0104695 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f010045f:	8b 15 2c 33 3c f0    	mov    0xf03c332c,%edx
f0100465:	b8 80 07 00 00       	mov    $0x780,%eax
f010046a:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100470:	83 c0 01             	add    $0x1,%eax
f0100473:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100478:	75 f0                	jne    f010046a <cons_putc+0x1aa>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f010047a:	66 83 2d 30 33 3c f0 	subw   $0x50,0xf03c3330
f0100481:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f0100482:	8b 0d 28 33 3c f0    	mov    0xf03c3328,%ecx
f0100488:	89 cb                	mov    %ecx,%ebx
f010048a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010048f:	89 ca                	mov    %ecx,%edx
f0100491:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100492:	0f b7 35 30 33 3c f0 	movzwl 0xf03c3330,%esi
f0100499:	83 c1 01             	add    $0x1,%ecx
f010049c:	89 f0                	mov    %esi,%eax
f010049e:	66 c1 e8 08          	shr    $0x8,%ax
f01004a2:	89 ca                	mov    %ecx,%edx
f01004a4:	ee                   	out    %al,(%dx)
f01004a5:	b8 0f 00 00 00       	mov    $0xf,%eax
f01004aa:	89 da                	mov    %ebx,%edx
f01004ac:	ee                   	out    %al,(%dx)
f01004ad:	89 f0                	mov    %esi,%eax
f01004af:	89 ca                	mov    %ecx,%edx
f01004b1:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01004b2:	83 c4 2c             	add    $0x2c,%esp
f01004b5:	5b                   	pop    %ebx
f01004b6:	5e                   	pop    %esi
f01004b7:	5f                   	pop    %edi
f01004b8:	5d                   	pop    %ebp
f01004b9:	c3                   	ret    

f01004ba <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01004ba:	55                   	push   %ebp
f01004bb:	89 e5                	mov    %esp,%ebp
f01004bd:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01004c0:	8b 45 08             	mov    0x8(%ebp),%eax
f01004c3:	e8 f8 fd ff ff       	call   f01002c0 <cons_putc>
}
f01004c8:	c9                   	leave  
f01004c9:	c3                   	ret    

f01004ca <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f01004ca:	55                   	push   %ebp
f01004cb:	89 e5                	mov    %esp,%ebp
f01004cd:	53                   	push   %ebx
f01004ce:	83 ec 14             	sub    $0x14,%esp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004d1:	ba 64 00 00 00       	mov    $0x64,%edx
f01004d6:	ec                   	in     (%dx),%al
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f01004d7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01004dc:	a8 01                	test   $0x1,%al
f01004de:	0f 84 d9 00 00 00    	je     f01005bd <kbd_proc_data+0xf3>
f01004e4:	b2 60                	mov    $0x60,%dl
f01004e6:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f01004e7:	3c e0                	cmp    $0xe0,%al
f01004e9:	75 11                	jne    f01004fc <kbd_proc_data+0x32>
		// E0 escape character
		shift |= E0ESC;
f01004eb:	83 0d 20 33 3c f0 40 	orl    $0x40,0xf03c3320
f01004f2:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f01004f7:	e9 c1 00 00 00       	jmp    f01005bd <kbd_proc_data+0xf3>
	} else if (data & 0x80) {
f01004fc:	84 c0                	test   %al,%al
f01004fe:	79 32                	jns    f0100532 <kbd_proc_data+0x68>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f0100500:	8b 15 20 33 3c f0    	mov    0xf03c3320,%edx
f0100506:	f6 c2 40             	test   $0x40,%dl
f0100509:	75 03                	jne    f010050e <kbd_proc_data+0x44>
f010050b:	83 e0 7f             	and    $0x7f,%eax
		shift &= ~(shiftcode[data] | E0ESC);
f010050e:	0f b6 c0             	movzbl %al,%eax
f0100511:	0f b6 80 20 58 10 f0 	movzbl -0xfefa7e0(%eax),%eax
f0100518:	83 c8 40             	or     $0x40,%eax
f010051b:	0f b6 c0             	movzbl %al,%eax
f010051e:	f7 d0                	not    %eax
f0100520:	21 c2                	and    %eax,%edx
f0100522:	89 15 20 33 3c f0    	mov    %edx,0xf03c3320
f0100528:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f010052d:	e9 8b 00 00 00       	jmp    f01005bd <kbd_proc_data+0xf3>
	} else if (shift & E0ESC) {
f0100532:	8b 15 20 33 3c f0    	mov    0xf03c3320,%edx
f0100538:	f6 c2 40             	test   $0x40,%dl
f010053b:	74 0c                	je     f0100549 <kbd_proc_data+0x7f>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f010053d:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
f0100540:	83 e2 bf             	and    $0xffffffbf,%edx
f0100543:	89 15 20 33 3c f0    	mov    %edx,0xf03c3320
	}

	shift |= shiftcode[data];
f0100549:	0f b6 c0             	movzbl %al,%eax
	shift ^= togglecode[data];
f010054c:	0f b6 90 20 58 10 f0 	movzbl -0xfefa7e0(%eax),%edx
f0100553:	0b 15 20 33 3c f0    	or     0xf03c3320,%edx
f0100559:	0f b6 88 20 59 10 f0 	movzbl -0xfefa6e0(%eax),%ecx
f0100560:	31 ca                	xor    %ecx,%edx
f0100562:	89 15 20 33 3c f0    	mov    %edx,0xf03c3320

	c = charcode[shift & (CTL | SHIFT)][data];
f0100568:	89 d1                	mov    %edx,%ecx
f010056a:	83 e1 03             	and    $0x3,%ecx
f010056d:	8b 0c 8d 20 5a 10 f0 	mov    -0xfefa5e0(,%ecx,4),%ecx
f0100574:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
	if (shift & CAPSLOCK) {
f0100578:	f6 c2 08             	test   $0x8,%dl
f010057b:	74 1a                	je     f0100597 <kbd_proc_data+0xcd>
		if ('a' <= c && c <= 'z')
f010057d:	89 d9                	mov    %ebx,%ecx
f010057f:	8d 43 9f             	lea    -0x61(%ebx),%eax
f0100582:	83 f8 19             	cmp    $0x19,%eax
f0100585:	77 05                	ja     f010058c <kbd_proc_data+0xc2>
			c += 'A' - 'a';
f0100587:	83 eb 20             	sub    $0x20,%ebx
f010058a:	eb 0b                	jmp    f0100597 <kbd_proc_data+0xcd>
		else if ('A' <= c && c <= 'Z')
f010058c:	83 e9 41             	sub    $0x41,%ecx
f010058f:	83 f9 19             	cmp    $0x19,%ecx
f0100592:	77 03                	ja     f0100597 <kbd_proc_data+0xcd>
			c += 'a' - 'A';
f0100594:	83 c3 20             	add    $0x20,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100597:	f7 d2                	not    %edx
f0100599:	f6 c2 06             	test   $0x6,%dl
f010059c:	75 1f                	jne    f01005bd <kbd_proc_data+0xf3>
f010059e:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f01005a4:	75 17                	jne    f01005bd <kbd_proc_data+0xf3>
		cprintf("Rebooting!\n");
f01005a6:	c7 04 24 d9 57 10 f0 	movl   $0xf01057d9,(%esp)
f01005ad:	e8 b5 23 00 00       	call   f0102967 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01005b2:	ba 92 00 00 00       	mov    $0x92,%edx
f01005b7:	b8 03 00 00 00       	mov    $0x3,%eax
f01005bc:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f01005bd:	89 d8                	mov    %ebx,%eax
f01005bf:	83 c4 14             	add    $0x14,%esp
f01005c2:	5b                   	pop    %ebx
f01005c3:	5d                   	pop    %ebp
f01005c4:	c3                   	ret    

f01005c5 <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f01005c5:	55                   	push   %ebp
f01005c6:	89 e5                	mov    %esp,%ebp
f01005c8:	57                   	push   %edi
f01005c9:	56                   	push   %esi
f01005ca:	53                   	push   %ebx
f01005cb:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01005ce:	b8 00 80 0b f0       	mov    $0xf00b8000,%eax
f01005d3:	0f b7 10             	movzwl (%eax),%edx
	*cp = (uint16_t) 0xA55A;
f01005d6:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
	if (*cp != 0xA55A) {
f01005db:	0f b7 00             	movzwl (%eax),%eax
f01005de:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005e2:	74 11                	je     f01005f5 <cons_init+0x30>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f01005e4:	c7 05 28 33 3c f0 b4 	movl   $0x3b4,0xf03c3328
f01005eb:	03 00 00 
f01005ee:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f01005f3:	eb 16                	jmp    f010060b <cons_init+0x46>
	} else {
		*cp = was;
f01005f5:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01005fc:	c7 05 28 33 3c f0 d4 	movl   $0x3d4,0xf03c3328
f0100603:	03 00 00 
f0100606:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
f010060b:	8b 0d 28 33 3c f0    	mov    0xf03c3328,%ecx
f0100611:	89 cb                	mov    %ecx,%ebx
f0100613:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100618:	89 ca                	mov    %ecx,%edx
f010061a:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010061b:	83 c1 01             	add    $0x1,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010061e:	89 ca                	mov    %ecx,%edx
f0100620:	ec                   	in     (%dx),%al
f0100621:	0f b6 f8             	movzbl %al,%edi
f0100624:	c1 e7 08             	shl    $0x8,%edi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100627:	b8 0f 00 00 00       	mov    $0xf,%eax
f010062c:	89 da                	mov    %ebx,%edx
f010062e:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010062f:	89 ca                	mov    %ecx,%edx
f0100631:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f0100632:	89 35 2c 33 3c f0    	mov    %esi,0xf03c332c
	crt_pos = pos;
f0100638:	0f b6 c8             	movzbl %al,%ecx
f010063b:	09 cf                	or     %ecx,%edi
f010063d:	66 89 3d 30 33 3c f0 	mov    %di,0xf03c3330

static void
kbd_init(void)
{
	// Drain the kbd buffer so that Bochs generates interrupts.
	kbd_intr();
f0100644:	e8 e9 fb ff ff       	call   f0100232 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f0100649:	0f b7 05 58 d3 11 f0 	movzwl 0xf011d358,%eax
f0100650:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100655:	89 04 24             	mov    %eax,(%esp)
f0100658:	e8 da 21 00 00       	call   f0102837 <irq_setmask_8259A>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010065d:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f0100662:	b8 00 00 00 00       	mov    $0x0,%eax
f0100667:	89 da                	mov    %ebx,%edx
f0100669:	ee                   	out    %al,(%dx)
f010066a:	b2 fb                	mov    $0xfb,%dl
f010066c:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100671:	ee                   	out    %al,(%dx)
f0100672:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
f0100677:	b8 0c 00 00 00       	mov    $0xc,%eax
f010067c:	89 ca                	mov    %ecx,%edx
f010067e:	ee                   	out    %al,(%dx)
f010067f:	b2 f9                	mov    $0xf9,%dl
f0100681:	b8 00 00 00 00       	mov    $0x0,%eax
f0100686:	ee                   	out    %al,(%dx)
f0100687:	b2 fb                	mov    $0xfb,%dl
f0100689:	b8 03 00 00 00       	mov    $0x3,%eax
f010068e:	ee                   	out    %al,(%dx)
f010068f:	b2 fc                	mov    $0xfc,%dl
f0100691:	b8 00 00 00 00       	mov    $0x0,%eax
f0100696:	ee                   	out    %al,(%dx)
f0100697:	b2 f9                	mov    $0xf9,%dl
f0100699:	b8 01 00 00 00       	mov    $0x1,%eax
f010069e:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010069f:	b2 fd                	mov    $0xfd,%dl
f01006a1:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01006a2:	3c ff                	cmp    $0xff,%al
f01006a4:	0f 95 c0             	setne  %al
f01006a7:	0f b6 f0             	movzbl %al,%esi
f01006aa:	89 35 24 33 3c f0    	mov    %esi,0xf03c3324
f01006b0:	89 da                	mov    %ebx,%edx
f01006b2:	ec                   	in     (%dx),%al
f01006b3:	89 ca                	mov    %ecx,%edx
f01006b5:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f01006b6:	85 f6                	test   %esi,%esi
f01006b8:	74 1d                	je     f01006d7 <cons_init+0x112>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f01006ba:	0f b7 05 58 d3 11 f0 	movzwl 0xf011d358,%eax
f01006c1:	25 ef ff 00 00       	and    $0xffef,%eax
f01006c6:	89 04 24             	mov    %eax,(%esp)
f01006c9:	e8 69 21 00 00       	call   f0102837 <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01006ce:	83 3d 24 33 3c f0 00 	cmpl   $0x0,0xf03c3324
f01006d5:	75 0c                	jne    f01006e3 <cons_init+0x11e>
		cprintf("Serial port does not exist!\n");
f01006d7:	c7 04 24 e5 57 10 f0 	movl   $0xf01057e5,(%esp)
f01006de:	e8 84 22 00 00       	call   f0102967 <cprintf>
}
f01006e3:	83 c4 1c             	add    $0x1c,%esp
f01006e6:	5b                   	pop    %ebx
f01006e7:	5e                   	pop    %esi
f01006e8:	5f                   	pop    %edi
f01006e9:	5d                   	pop    %ebp
f01006ea:	c3                   	ret    
f01006eb:	00 00                	add    %al,(%eax)
f01006ed:	00 00                	add    %al,(%eax)
	...

f01006f0 <read_eip>:
// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
f01006f0:	55                   	push   %ebp
f01006f1:	89 e5                	mov    %esp,%ebp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f01006f3:	8b 45 04             	mov    0x4(%ebp),%eax
	return callerpc;
}
f01006f6:	5d                   	pop    %ebp
f01006f7:	c3                   	ret    

f01006f8 <string_to_hex>:

uintptr_t string_to_hex (char *p)
{
f01006f8:	55                   	push   %ebp
f01006f9:	89 e5                	mov    %esp,%ebp
f01006fb:	56                   	push   %esi
f01006fc:	53                   	push   %ebx
f01006fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	uintptr_t res = 0;
	int i=2;
	int x;
	if ((p[0] != '0') | (p[1] != 'x'))
f0100700:	80 39 30             	cmpb   $0x30,(%ecx)
f0100703:	0f 85 c9 00 00 00    	jne    f01007d2 <string_to_hex+0xda>
f0100709:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f010070d:	0f 85 bf 00 00 00    	jne    f01007d2 <string_to_hex+0xda>
		return -1;
	while (p[i] != '\0')
f0100713:	0f b6 51 02          	movzbl 0x2(%ecx),%edx
f0100717:	b8 00 00 00 00       	mov    $0x0,%eax
	{
		switch(p[i])
f010071c:	bb 40 5a 10 f0       	mov    $0xf0105a40,%ebx
			case '9': x = 9; break;
			case 'a': x = 10; break;
			case 'b': x = 11; break;	
			case 'c': x = 12; break;
			case 'd': x = 13; break;
			case 'e': x = 14; break;
f0100721:	be 0f 00 00 00       	mov    $0xf,%esi
	uintptr_t res = 0;
	int i=2;
	int x;
	if ((p[0] != '0') | (p[1] != 'x'))
		return -1;
	while (p[i] != '\0')
f0100726:	84 d2                	test   %dl,%dl
f0100728:	0f 84 a9 00 00 00    	je     f01007d7 <string_to_hex+0xdf>
	{
		switch(p[i])
f010072e:	83 ea 30             	sub    $0x30,%edx
f0100731:	80 fa 36             	cmp    $0x36,%dl
f0100734:	0f 87 98 00 00 00    	ja     f01007d2 <string_to_hex+0xda>
f010073a:	0f b6 d2             	movzbl %dl,%edx
f010073d:	ff 24 93             	jmp    *(%ebx,%edx,4)
f0100740:	ba 01 00 00 00       	mov    $0x1,%edx
f0100745:	eb 74                	jmp    f01007bb <string_to_hex+0xc3>
f0100747:	ba 00 00 00 00       	mov    $0x0,%edx
f010074c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100750:	eb 69                	jmp    f01007bb <string_to_hex+0xc3>
f0100752:	ba 02 00 00 00       	mov    $0x2,%edx
		{
			case '0': x = 0; break;
			case '1': x = 1; break;
			case '2': x = 2; break;
f0100757:	eb 62                	jmp    f01007bb <string_to_hex+0xc3>
f0100759:	ba 03 00 00 00       	mov    $0x3,%edx
			case '3': x = 3; break;
f010075e:	66 90                	xchg   %ax,%ax
f0100760:	eb 59                	jmp    f01007bb <string_to_hex+0xc3>
f0100762:	ba 04 00 00 00       	mov    $0x4,%edx
			case '4': x = 4; break;
f0100767:	eb 52                	jmp    f01007bb <string_to_hex+0xc3>
f0100769:	ba 05 00 00 00       	mov    $0x5,%edx
			case '5': x = 5; break;
f010076e:	66 90                	xchg   %ax,%ax
f0100770:	eb 49                	jmp    f01007bb <string_to_hex+0xc3>
f0100772:	ba 06 00 00 00       	mov    $0x6,%edx
			case '6': x = 6; break;
f0100777:	eb 42                	jmp    f01007bb <string_to_hex+0xc3>
f0100779:	ba 07 00 00 00       	mov    $0x7,%edx
			case '7': x = 7; break;
f010077e:	66 90                	xchg   %ax,%ax
f0100780:	eb 39                	jmp    f01007bb <string_to_hex+0xc3>
f0100782:	ba 08 00 00 00       	mov    $0x8,%edx
			case '8': x = 8; break;
f0100787:	eb 32                	jmp    f01007bb <string_to_hex+0xc3>
f0100789:	ba 09 00 00 00       	mov    $0x9,%edx
			case '9': x = 9; break;
f010078e:	66 90                	xchg   %ax,%ax
f0100790:	eb 29                	jmp    f01007bb <string_to_hex+0xc3>
f0100792:	ba 0a 00 00 00       	mov    $0xa,%edx
			case 'a': x = 10; break;
f0100797:	eb 22                	jmp    f01007bb <string_to_hex+0xc3>
f0100799:	ba 0b 00 00 00       	mov    $0xb,%edx
			case 'b': x = 11; break;	
f010079e:	66 90                	xchg   %ax,%ax
f01007a0:	eb 19                	jmp    f01007bb <string_to_hex+0xc3>
f01007a2:	ba 0c 00 00 00       	mov    $0xc,%edx
			case 'c': x = 12; break;
f01007a7:	eb 12                	jmp    f01007bb <string_to_hex+0xc3>
f01007a9:	ba 0d 00 00 00       	mov    $0xd,%edx
			case 'd': x = 13; break;
f01007ae:	66 90                	xchg   %ax,%ax
f01007b0:	eb 09                	jmp    f01007bb <string_to_hex+0xc3>
f01007b2:	ba 0e 00 00 00       	mov    $0xe,%edx
			case 'e': x = 14; break;
f01007b7:	eb 02                	jmp    f01007bb <string_to_hex+0xc3>
f01007b9:	89 f2                	mov    %esi,%edx
			case 'f': x = 15; break;
			default: return -1;
		}
		res = 16*res + x;	
f01007bb:	c1 e0 04             	shl    $0x4,%eax
f01007be:	8d 04 02             	lea    (%edx,%eax,1),%eax
	uintptr_t res = 0;
	int i=2;
	int x;
	if ((p[0] != '0') | (p[1] != 'x'))
		return -1;
	while (p[i] != '\0')
f01007c1:	0f b6 51 03          	movzbl 0x3(%ecx),%edx
f01007c5:	83 c1 01             	add    $0x1,%ecx
f01007c8:	84 d2                	test   %dl,%dl
f01007ca:	0f 85 5e ff ff ff    	jne    f010072e <string_to_hex+0x36>
f01007d0:	eb 05                	jmp    f01007d7 <string_to_hex+0xdf>
f01007d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		}
		res = 16*res + x;	
		i++;	
	}
	return res;
}
f01007d7:	5b                   	pop    %ebx
f01007d8:	5e                   	pop    %esi
f01007d9:	5d                   	pop    %ebp
f01007da:	c3                   	ret    

f01007db <show_perm>:

char * show_perm (int p)
{
f01007db:	55                   	push   %ebp
f01007dc:	89 e5                	mov    %esp,%ebp
f01007de:	8b 55 08             	mov    0x8(%ebp),%edx
f01007e1:	b8 a0 5b 10 f0       	mov    $0xf0105ba0,%eax
f01007e6:	83 fa 07             	cmp    $0x7,%edx
f01007e9:	77 07                	ja     f01007f2 <show_perm+0x17>
f01007eb:	8b 04 95 80 5b 10 f0 	mov    -0xfefa480(,%edx,4),%eax
		case 7: return "PTE_P | PTE_W | PTE_U"; break;
		default: return "Permissions unexplored !!"; break;
	}


}
f01007f2:	5d                   	pop    %ebp
f01007f3:	c3                   	ret    

f01007f4 <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01007f4:	55                   	push   %ebp
f01007f5:	89 e5                	mov    %esp,%ebp
f01007f7:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01007fa:	c7 04 24 ba 5b 10 f0 	movl   $0xf0105bba,(%esp)
f0100801:	e8 61 21 00 00       	call   f0102967 <cprintf>
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
f0100806:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f010080d:	00 
f010080e:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f0100815:	f0 
f0100816:	c7 04 24 84 5d 10 f0 	movl   $0xf0105d84,(%esp)
f010081d:	e8 45 21 00 00       	call   f0102967 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100822:	c7 44 24 08 75 57 10 	movl   $0x105775,0x8(%esp)
f0100829:	00 
f010082a:	c7 44 24 04 75 57 10 	movl   $0xf0105775,0x4(%esp)
f0100831:	f0 
f0100832:	c7 04 24 a8 5d 10 f0 	movl   $0xf0105da8,(%esp)
f0100839:	e8 29 21 00 00       	call   f0102967 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010083e:	c7 44 24 08 ff 32 3c 	movl   $0x3c32ff,0x8(%esp)
f0100845:	00 
f0100846:	c7 44 24 04 ff 32 3c 	movl   $0xf03c32ff,0x4(%esp)
f010084d:	f0 
f010084e:	c7 04 24 cc 5d 10 f0 	movl   $0xf0105dcc,(%esp)
f0100855:	e8 0d 21 00 00       	call   f0102967 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010085a:	c7 44 24 08 88 8a 3c 	movl   $0x3c8a88,0x8(%esp)
f0100861:	00 
f0100862:	c7 44 24 04 88 8a 3c 	movl   $0xf03c8a88,0x4(%esp)
f0100869:	f0 
f010086a:	c7 04 24 f0 5d 10 f0 	movl   $0xf0105df0,(%esp)
f0100871:	e8 f1 20 00 00       	call   f0102967 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100876:	b8 87 8e 3c f0       	mov    $0xf03c8e87,%eax
f010087b:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f0100880:	89 c2                	mov    %eax,%edx
f0100882:	c1 fa 1f             	sar    $0x1f,%edx
f0100885:	c1 ea 16             	shr    $0x16,%edx
f0100888:	8d 04 02             	lea    (%edx,%eax,1),%eax
f010088b:	c1 f8 0a             	sar    $0xa,%eax
f010088e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100892:	c7 04 24 14 5e 10 f0 	movl   $0xf0105e14,(%esp)
f0100899:	e8 c9 20 00 00       	call   f0102967 <cprintf>
		(end-_start+1023)/1024);
	return 0;
}
f010089e:	b8 00 00 00 00       	mov    $0x0,%eax
f01008a3:	c9                   	leave  
f01008a4:	c3                   	ret    

f01008a5 <mon_help>:
}

 
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01008a5:	55                   	push   %ebp
f01008a6:	89 e5                	mov    %esp,%ebp
f01008a8:	57                   	push   %edi
f01008a9:	56                   	push   %esi
f01008aa:	53                   	push   %ebx
f01008ab:	83 ec 1c             	sub    $0x1c,%esp
f01008ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	*/



	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01008b3:	be 24 5b 10 f0       	mov    $0xf0105b24,%esi
f01008b8:	bf 20 5b 10 f0       	mov    $0xf0105b20,%edi
f01008bd:	8b 04 1e             	mov    (%esi,%ebx,1),%eax
f01008c0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008c4:	8b 04 1f             	mov    (%edi,%ebx,1),%eax
f01008c7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008cb:	c7 04 24 d3 5b 10 f0 	movl   $0xf0105bd3,(%esp)
f01008d2:	e8 90 20 00 00       	call   f0102967 <cprintf>
f01008d7:	83 c3 0c             	add    $0xc,%ebx
	cprintf("\n x=%d y=%d \n",4);
	*/



	for (i = 0; i < NCOMMANDS; i++)
f01008da:	83 fb 60             	cmp    $0x60,%ebx
f01008dd:	75 de                	jne    f01008bd <mon_help+0x18>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}
f01008df:	b8 00 00 00 00       	mov    $0x0,%eax
f01008e4:	83 c4 1c             	add    $0x1c,%esp
f01008e7:	5b                   	pop    %ebx
f01008e8:	5e                   	pop    %esi
f01008e9:	5f                   	pop    %edi
f01008ea:	5d                   	pop    %ebp
f01008eb:	c3                   	ret    

f01008ec <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01008ec:	55                   	push   %ebp
f01008ed:	89 e5                	mov    %esp,%ebp
f01008ef:	57                   	push   %edi
f01008f0:	56                   	push   %esi
f01008f1:	53                   	push   %ebx
f01008f2:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01008f5:	c7 04 24 40 5e 10 f0 	movl   $0xf0105e40,(%esp)
f01008fc:	e8 66 20 00 00       	call   f0102967 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100901:	c7 04 24 64 5e 10 f0 	movl   $0xf0105e64,(%esp)
f0100908:	e8 5a 20 00 00       	call   f0102967 <cprintf>

	if (tf != NULL)
f010090d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100911:	74 0b                	je     f010091e <monitor+0x32>
		print_trapframe(tf);
f0100913:	8b 45 08             	mov    0x8(%ebp),%eax
f0100916:	89 04 24             	mov    %eax,(%esp)
f0100919:	e8 dd 22 00 00       	call   f0102bfb <print_trapframe>

	while (1) {
		buf = readline("K> ");
f010091e:	c7 04 24 dc 5b 10 f0 	movl   $0xf0105bdc,(%esp)
f0100925:	e8 76 3a 00 00       	call   f01043a0 <readline>
f010092a:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f010092c:	85 c0                	test   %eax,%eax
f010092e:	74 ee                	je     f010091e <monitor+0x32>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100930:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f0100937:	be 00 00 00 00       	mov    $0x0,%esi
f010093c:	eb 06                	jmp    f0100944 <monitor+0x58>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f010093e:	c6 03 00             	movb   $0x0,(%ebx)
f0100941:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100944:	0f b6 03             	movzbl (%ebx),%eax
f0100947:	84 c0                	test   %al,%al
f0100949:	74 6a                	je     f01009b5 <monitor+0xc9>
f010094b:	0f be c0             	movsbl %al,%eax
f010094e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100952:	c7 04 24 e0 5b 10 f0 	movl   $0xf0105be0,(%esp)
f0100959:	e8 80 3c 00 00       	call   f01045de <strchr>
f010095e:	85 c0                	test   %eax,%eax
f0100960:	75 dc                	jne    f010093e <monitor+0x52>
			*buf++ = 0;
		if (*buf == 0)
f0100962:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100965:	74 4e                	je     f01009b5 <monitor+0xc9>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100967:	83 fe 0f             	cmp    $0xf,%esi
f010096a:	75 16                	jne    f0100982 <monitor+0x96>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f010096c:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100973:	00 
f0100974:	c7 04 24 e5 5b 10 f0 	movl   $0xf0105be5,(%esp)
f010097b:	e8 e7 1f 00 00       	call   f0102967 <cprintf>
f0100980:	eb 9c                	jmp    f010091e <monitor+0x32>
			return 0;
		}
		argv[argc++] = buf;
f0100982:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100986:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f0100989:	0f b6 03             	movzbl (%ebx),%eax
f010098c:	84 c0                	test   %al,%al
f010098e:	75 0c                	jne    f010099c <monitor+0xb0>
f0100990:	eb b2                	jmp    f0100944 <monitor+0x58>
			buf++;
f0100992:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100995:	0f b6 03             	movzbl (%ebx),%eax
f0100998:	84 c0                	test   %al,%al
f010099a:	74 a8                	je     f0100944 <monitor+0x58>
f010099c:	0f be c0             	movsbl %al,%eax
f010099f:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009a3:	c7 04 24 e0 5b 10 f0 	movl   $0xf0105be0,(%esp)
f01009aa:	e8 2f 3c 00 00       	call   f01045de <strchr>
f01009af:	85 c0                	test   %eax,%eax
f01009b1:	74 df                	je     f0100992 <monitor+0xa6>
f01009b3:	eb 8f                	jmp    f0100944 <monitor+0x58>
			buf++;
	}
	argv[argc] = 0;
f01009b5:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01009bc:	00 

	// Lookup and invoke the command
	if (argc == 0)
f01009bd:	85 f6                	test   %esi,%esi
f01009bf:	90                   	nop
f01009c0:	0f 84 58 ff ff ff    	je     f010091e <monitor+0x32>
f01009c6:	bb 20 5b 10 f0       	mov    $0xf0105b20,%ebx
f01009cb:	bf 00 00 00 00       	mov    $0x0,%edi
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f01009d0:	8b 03                	mov    (%ebx),%eax
f01009d2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009d6:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01009d9:	89 04 24             	mov    %eax,(%esp)
f01009dc:	e8 88 3b 00 00       	call   f0104569 <strcmp>
f01009e1:	85 c0                	test   %eax,%eax
f01009e3:	75 23                	jne    f0100a08 <monitor+0x11c>
			return commands[i].func(argc, argv, tf);
f01009e5:	6b ff 0c             	imul   $0xc,%edi,%edi
f01009e8:	8b 45 08             	mov    0x8(%ebp),%eax
f01009eb:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009ef:	8d 45 a8             	lea    -0x58(%ebp),%eax
f01009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009f6:	89 34 24             	mov    %esi,(%esp)
f01009f9:	ff 97 28 5b 10 f0    	call   *-0xfefa4d8(%edi)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f01009ff:	85 c0                	test   %eax,%eax
f0100a01:	78 28                	js     f0100a2b <monitor+0x13f>
f0100a03:	e9 16 ff ff ff       	jmp    f010091e <monitor+0x32>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0100a08:	83 c7 01             	add    $0x1,%edi
f0100a0b:	83 c3 0c             	add    $0xc,%ebx
f0100a0e:	83 ff 08             	cmp    $0x8,%edi
f0100a11:	75 bd                	jne    f01009d0 <monitor+0xe4>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a13:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100a16:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a1a:	c7 04 24 02 5c 10 f0 	movl   $0xf0105c02,(%esp)
f0100a21:	e8 41 1f 00 00       	call   f0102967 <cprintf>
f0100a26:	e9 f3 fe ff ff       	jmp    f010091e <monitor+0x32>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100a2b:	83 c4 5c             	add    $0x5c,%esp
f0100a2e:	5b                   	pop    %ebx
f0100a2f:	5e                   	pop    %esi
f0100a30:	5f                   	pop    %edi
f0100a31:	5d                   	pop    %ebp
f0100a32:	c3                   	ret    

f0100a33 <mon_backtrace>:
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100a33:	55                   	push   %ebp
f0100a34:	89 e5                	mov    %esp,%ebp
f0100a36:	57                   	push   %edi
f0100a37:	56                   	push   %esi
f0100a38:	53                   	push   %ebx
f0100a39:	83 ec 6c             	sub    $0x6c,%esp
	// Your code here.
	unsigned int  eip = read_eip();
f0100a3c:	e8 af fc ff ff       	call   f01006f0 <read_eip>
f0100a41:	89 c7                	mov    %eax,%edi
	unsigned int  * ebp = (unsigned int *) read_ebp();
f0100a43:	89 eb                	mov    %ebp,%ebx
	char a[50];
	int ret;
	
	struct Eipdebuginfo *edi = NULL; 

	cprintf("Stack backtrace:\n");
f0100a45:	c7 04 24 18 5c 10 f0 	movl   $0xf0105c18,(%esp)
f0100a4c:	e8 16 1f 00 00       	call   f0102967 <cprintf>
	
	while (ebp != 0x0){
f0100a51:	85 db                	test   %ebx,%ebx
f0100a53:	0f 84 e4 00 00 00    	je     f0100b3d <mon_backtrace+0x10a>
	
	memset(edi, 0, sizeof(struct Eipdebuginfo));
f0100a59:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
f0100a60:	00 
f0100a61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100a68:	00 
f0100a69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100a70:	e8 c1 3b 00 00       	call   f0104636 <memset>
	ret = debuginfo_eip(eip , edi);
f0100a75:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100a7c:	00 
f0100a7d:	89 3c 24             	mov    %edi,(%esp)
f0100a80:	e8 69 30 00 00       	call   f0103aee <debuginfo_eip>
	if (ret == -1)
f0100a85:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100a88:	75 16                	jne    f0100aa0 <mon_backtrace+0x6d>
	{
		cprintf("\n Debuginfo_eip threw an error !!!\n");
f0100a8a:	c7 04 24 8c 5e 10 f0 	movl   $0xf0105e8c,(%esp)
f0100a91:	e8 d1 1e 00 00       	call   f0102967 <cprintf>
f0100a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		return -1;
f0100a9b:	e9 5e 01 00 00       	jmp    f0100bfe <mon_backtrace+0x1cb>
	}
	
	strncpy (a, edi->eip_fn_name, edi->eip_fn_namelen);
f0100aa0:	be 00 00 00 00       	mov    $0x0,%esi
f0100aa5:	8b 56 0c             	mov    0xc(%esi),%edx
f0100aa8:	8b 46 08             	mov    0x8(%esi),%eax
f0100aab:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ab3:	8d 45 b6             	lea    -0x4a(%ebp),%eax
f0100ab6:	89 04 24             	mov    %eax,(%esp)
f0100ab9:	e8 3c 3a 00 00       	call   f01044fa <strncpy>
	a[edi->eip_fn_namelen] = '\0';
f0100abe:	8b 46 0c             	mov    0xc(%esi),%eax
f0100ac1:	c6 44 05 b6 00       	movb   $0x0,-0x4a(%ebp,%eax,1)

	cprintf("ebp %08x eip %08x ", ebp, eip);
f0100ac6:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0100aca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100ace:	c7 04 24 2a 5c 10 f0 	movl   $0xf0105c2a,(%esp)
f0100ad5:	e8 8d 1e 00 00       	call   f0102967 <cprintf>
	cprintf("args %08x %08x %08x %08x %08x \n", *(ebp+2), *(ebp+3),*(ebp+4),*(ebp+5),*(ebp+6));
f0100ada:	8b 43 18             	mov    0x18(%ebx),%eax
f0100add:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100ae1:	8b 43 14             	mov    0x14(%ebx),%eax
f0100ae4:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100ae8:	8b 43 10             	mov    0x10(%ebx),%eax
f0100aeb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100aef:	8b 43 0c             	mov    0xc(%ebx),%eax
f0100af2:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100af6:	8b 43 08             	mov    0x8(%ebx),%eax
f0100af9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100afd:	c7 04 24 b0 5e 10 f0 	movl   $0xf0105eb0,(%esp)
f0100b04:	e8 5e 1e 00 00       	call   f0102967 <cprintf>
	cprintf("%s:%d: %s+%d \n",edi->eip_file, edi->eip_line, a,eip - edi->eip_fn_addr); 
f0100b09:	8b 56 04             	mov    0x4(%esi),%edx
f0100b0c:	8b 06                	mov    (%esi),%eax
f0100b0e:	2b 7e 10             	sub    0x10(%esi),%edi
f0100b11:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0100b15:	8d 4d b6             	lea    -0x4a(%ebp),%ecx
f0100b18:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0100b1c:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b24:	c7 04 24 3d 5c 10 f0 	movl   $0xf0105c3d,(%esp)
f0100b2b:	e8 37 1e 00 00       	call   f0102967 <cprintf>
	
	eip = (unsigned int) *(ebp+1);
f0100b30:	8b 7b 04             	mov    0x4(%ebx),%edi
	ebp = (unsigned int *) *ebp;
f0100b33:	8b 1b                	mov    (%ebx),%ebx
	
	struct Eipdebuginfo *edi = NULL; 

	cprintf("Stack backtrace:\n");
	
	while (ebp != 0x0){
f0100b35:	85 db                	test   %ebx,%ebx
f0100b37:	0f 85 1c ff ff ff    	jne    f0100a59 <mon_backtrace+0x26>
	cprintf("%s:%d: %s+%d \n",edi->eip_file, edi->eip_line, a,eip - edi->eip_fn_addr); 
	
	eip = (unsigned int) *(ebp+1);
	ebp = (unsigned int *) *ebp;
	}
	memset(edi, 0, sizeof(struct Eipdebuginfo));
f0100b3d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
f0100b44:	00 
f0100b45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100b4c:	00 
f0100b4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100b54:	e8 dd 3a 00 00       	call   f0104636 <memset>
	debuginfo_eip(eip , edi);
f0100b59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100b60:	00 
f0100b61:	89 3c 24             	mov    %edi,(%esp)
f0100b64:	e8 85 2f 00 00       	call   f0103aee <debuginfo_eip>
	
	strncpy (a, edi->eip_fn_name, edi->eip_fn_namelen);
f0100b69:	be 00 00 00 00       	mov    $0x0,%esi
f0100b6e:	8b 56 0c             	mov    0xc(%esi),%edx
f0100b71:	8b 46 08             	mov    0x8(%esi),%eax
f0100b74:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100b78:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b7c:	8d 45 b6             	lea    -0x4a(%ebp),%eax
f0100b7f:	89 04 24             	mov    %eax,(%esp)
f0100b82:	e8 73 39 00 00       	call   f01044fa <strncpy>
	a[edi->eip_fn_namelen] = '\0';
f0100b87:	8b 46 0c             	mov    0xc(%esi),%eax
f0100b8a:	c6 44 05 b6 00       	movb   $0x0,-0x4a(%ebp,%eax,1)

	cprintf("ebp %08x eip %08x ", ebp, eip);
f0100b8f:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0100b93:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100b97:	c7 04 24 2a 5c 10 f0 	movl   $0xf0105c2a,(%esp)
f0100b9e:	e8 c4 1d 00 00       	call   f0102967 <cprintf>
	cprintf("args %08x %08x %08x %08x %08x \n", *(ebp+2), *(ebp+3),*(ebp+4),*(ebp+5),*(ebp+6));
f0100ba3:	8b 43 18             	mov    0x18(%ebx),%eax
f0100ba6:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100baa:	8b 43 14             	mov    0x14(%ebx),%eax
f0100bad:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100bb1:	8b 43 10             	mov    0x10(%ebx),%eax
f0100bb4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100bb8:	8b 43 0c             	mov    0xc(%ebx),%eax
f0100bbb:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100bbf:	8b 43 08             	mov    0x8(%ebx),%eax
f0100bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bc6:	c7 04 24 b0 5e 10 f0 	movl   $0xf0105eb0,(%esp)
f0100bcd:	e8 95 1d 00 00       	call   f0102967 <cprintf>
	cprintf("%s:%d: %s+%d \n",edi->eip_file, edi->eip_line, a,eip - edi->eip_fn_addr); 
f0100bd2:	8b 56 04             	mov    0x4(%esi),%edx
f0100bd5:	8b 06                	mov    (%esi),%eax
f0100bd7:	2b 7e 10             	sub    0x10(%esi),%edi
f0100bda:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0100bde:	8d 4d b6             	lea    -0x4a(%ebp),%ecx
f0100be1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0100be5:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100be9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bed:	c7 04 24 3d 5c 10 f0 	movl   $0xf0105c3d,(%esp)
f0100bf4:	e8 6e 1d 00 00       	call   f0102967 <cprintf>
f0100bf9:	b8 00 00 00 00       	mov    $0x0,%eax
	
	return 0;
}
f0100bfe:	83 c4 6c             	add    $0x6c,%esp
f0100c01:	5b                   	pop    %ebx
f0100c02:	5e                   	pop    %esi
f0100c03:	5f                   	pop    %edi
f0100c04:	5d                   	pop    %ebp
f0100c05:	c3                   	ret    

f0100c06 <mon_showmappings>:
	*pte = *pte | perm;			// set the new permissions
	return 0;
}
int 
mon_showmappings(int argc, char **argv, struct Trapframe *tf)
{
f0100c06:	55                   	push   %ebp
f0100c07:	89 e5                	mov    %esp,%ebp
f0100c09:	57                   	push   %edi
f0100c0a:	56                   	push   %esi
f0100c0b:	53                   	push   %ebx
f0100c0c:	83 ec 1c             	sub    $0x1c,%esp
f0100c0f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (argc != 3)
f0100c12:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100c16:	74 11                	je     f0100c29 <mon_showmappings+0x23>
	{	
		cprintf("\n Invalid no. of arguments !! \n");
f0100c18:	c7 04 24 d0 5e 10 f0 	movl   $0xf0105ed0,(%esp)
f0100c1f:	e8 43 1d 00 00       	call   f0102967 <cprintf>
		return 0;
f0100c24:	e9 96 00 00 00       	jmp    f0100cbf <mon_showmappings+0xb9>
	}	
	uintptr_t va_start = string_to_hex(argv[1]);
f0100c29:	8b 43 04             	mov    0x4(%ebx),%eax
f0100c2c:	89 04 24             	mov    %eax,(%esp)
f0100c2f:	e8 c4 fa ff ff       	call   f01006f8 <string_to_hex>
f0100c34:	89 c7                	mov    %eax,%edi
	uintptr_t va_end = string_to_hex(argv[2]);
f0100c36:	8b 43 08             	mov    0x8(%ebx),%eax
f0100c39:	89 04 24             	mov    %eax,(%esp)
f0100c3c:	e8 b7 fa ff ff       	call   f01006f8 <string_to_hex>
f0100c41:	89 c6                	mov    %eax,%esi
	if ((va_start < 0) | (va_end < 0) | (va_start > va_end))
	{	
		cprintf("\n Invalid input !! \n");
		return 0;
f0100c43:	89 fb                	mov    %edi,%ebx
		cprintf("\n Invalid no. of arguments !! \n");
		return 0;
	}	
	uintptr_t va_start = string_to_hex(argv[1]);
	uintptr_t va_end = string_to_hex(argv[2]);
	if ((va_start < 0) | (va_end < 0) | (va_start > va_end))
f0100c45:	39 c7                	cmp    %eax,%edi
f0100c47:	76 0e                	jbe    f0100c57 <mon_showmappings+0x51>
	{	
		cprintf("\n Invalid input !! \n");
f0100c49:	c7 04 24 4c 5c 10 f0 	movl   $0xf0105c4c,(%esp)
f0100c50:	e8 12 1d 00 00       	call   f0102967 <cprintf>
		return 0;
f0100c55:	eb 68                	jmp    f0100cbf <mon_showmappings+0xb9>
	uintptr_t i;
	physaddr_t p;
	pte_t *pte;
	for (i = va_start; i <= va_end ; i = i+PGSIZE)
	{
		pte = pgdir_walk(boot_pgdir, (const void *)i, 0);
f0100c57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100c5e:	00 
f0100c5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100c63:	a1 28 8a 3c f0       	mov    0xf03c8a28,%eax
f0100c68:	89 04 24             	mov    %eax,(%esp)
f0100c6b:	e8 19 07 00 00       	call   f0101389 <pgdir_walk>
		if (pte == NULL)
f0100c70:	85 c0                	test   %eax,%eax
f0100c72:	75 0e                	jne    f0100c82 <mon_showmappings+0x7c>
		{
			cprintf("\n Error!! Page Table does not exist !!\n");
f0100c74:	c7 04 24 f0 5e 10 f0 	movl   $0xf0105ef0,(%esp)
f0100c7b:	e8 e7 1c 00 00       	call   f0102967 <cprintf>
			return 0;
f0100c80:	eb 3d                	jmp    f0100cbf <mon_showmappings+0xb9>
		}
		p = (physaddr_t)*pte;
f0100c82:	8b 00                	mov    (%eax),%eax
		cprintf("\n Virtual address = %x, Physical Address mapped = %x, Permission bits = %x", i, PTE_ADDR(p), p & 0xFFF);
f0100c84:	89 c2                	mov    %eax,%edx
f0100c86:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f0100c8c:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100c90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100c95:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100c99:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100c9d:	c7 04 24 18 5f 10 f0 	movl   $0xf0105f18,(%esp)
f0100ca4:	e8 be 1c 00 00       	call   f0102967 <cprintf>
		return 0;
	}
	uintptr_t i;
	physaddr_t p;
	pte_t *pte;
	for (i = va_start; i <= va_end ; i = i+PGSIZE)
f0100ca9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100caf:	39 de                	cmp    %ebx,%esi
f0100cb1:	73 a4                	jae    f0100c57 <mon_showmappings+0x51>
			return 0;
		}
		p = (physaddr_t)*pte;
		cprintf("\n Virtual address = %x, Physical Address mapped = %x, Permission bits = %x", i, PTE_ADDR(p), p & 0xFFF);
	}
	cprintf("\n\n");
f0100cb3:	c7 04 24 61 5c 10 f0 	movl   $0xf0105c61,(%esp)
f0100cba:	e8 a8 1c 00 00       	call   f0102967 <cprintf>
	return 0;
}
f0100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
f0100cc4:	83 c4 1c             	add    $0x1c,%esp
f0100cc7:	5b                   	pop    %ebx
f0100cc8:	5e                   	pop    %esi
f0100cc9:	5f                   	pop    %edi
f0100cca:	5d                   	pop    %ebp
f0100ccb:	c3                   	ret    

f0100ccc <mon_changeperm>:
	}	
}

int 
mon_changeperm(int argc, char **argv, struct Trapframe *tf)
{
f0100ccc:	55                   	push   %ebp
f0100ccd:	89 e5                	mov    %esp,%ebp
f0100ccf:	83 ec 18             	sub    $0x18,%esp
f0100cd2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0100cd5:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0100cd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (argc != 3)
f0100cdb:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
f0100cdf:	74 0e                	je     f0100cef <mon_changeperm+0x23>
	{	
		cprintf("\n Invalid no. of arguments !! \n");
f0100ce1:	c7 04 24 d0 5e 10 f0 	movl   $0xf0105ed0,(%esp)
f0100ce8:	e8 7a 1c 00 00       	call   f0102967 <cprintf>
		return 0;
f0100ced:	eb 63                	jmp    f0100d52 <mon_changeperm+0x86>
	}	
	uintptr_t va = string_to_hex(argv[1]);
f0100cef:	8b 43 04             	mov    0x4(%ebx),%eax
f0100cf2:	89 04 24             	mov    %eax,(%esp)
f0100cf5:	e8 fe f9 ff ff       	call   f01006f8 <string_to_hex>
f0100cfa:	89 c6                	mov    %eax,%esi
	int perm = (int)string_to_hex (argv[2]);
f0100cfc:	8b 43 08             	mov    0x8(%ebx),%eax
f0100cff:	89 04 24             	mov    %eax,(%esp)
f0100d02:	e8 f1 f9 ff ff       	call   f01006f8 <string_to_hex>
f0100d07:	89 c3                	mov    %eax,%ebx
	if ((va < 0) | (perm < 0))
f0100d09:	85 c0                	test   %eax,%eax
f0100d0b:	79 0e                	jns    f0100d1b <mon_changeperm+0x4f>
	{	
		cprintf("\n Invalid input !! \n");
f0100d0d:	c7 04 24 4c 5c 10 f0 	movl   $0xf0105c4c,(%esp)
f0100d14:	e8 4e 1c 00 00       	call   f0102967 <cprintf>
		return 0;
f0100d19:	eb 37                	jmp    f0100d52 <mon_changeperm+0x86>
	}
	pte_t *pte = pgdir_walk(boot_pgdir, (const void*)va, 0);
f0100d1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100d22:	00 
f0100d23:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100d27:	a1 28 8a 3c f0       	mov    0xf03c8a28,%eax
f0100d2c:	89 04 24             	mov    %eax,(%esp)
f0100d2f:	e8 55 06 00 00       	call   f0101389 <pgdir_walk>
	if (pte == NULL)
f0100d34:	85 c0                	test   %eax,%eax
f0100d36:	75 0e                	jne    f0100d46 <mon_changeperm+0x7a>
	{
		cprintf("\n Error!! Page Table does not exist !!\n");
f0100d38:	c7 04 24 f0 5e 10 f0 	movl   $0xf0105ef0,(%esp)
f0100d3f:	e8 23 1c 00 00       	call   f0102967 <cprintf>
		return 0;
f0100d44:	eb 0c                	jmp    f0100d52 <mon_changeperm+0x86>
	}
	physaddr_t p = (physaddr_t)*pte;
	*pte = *pte & (~0xFFF); 		// clear the existing permissions
	*pte = *pte | perm;			// set the new permissions
f0100d46:	8b 10                	mov    (%eax),%edx
f0100d48:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100d4e:	09 d3                	or     %edx,%ebx
f0100d50:	89 18                	mov    %ebx,(%eax)
	return 0;
}
f0100d52:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d57:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100d5a:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0100d5d:	89 ec                	mov    %ebp,%esp
f0100d5f:	5d                   	pop    %ebp
f0100d60:	c3                   	ret    

f0100d61 <mon_allocpage>:
	return 0;
}	
	
int 
mon_allocpage(int argc, char **argv, struct Trapframe *tf)
{
f0100d61:	55                   	push   %ebp
f0100d62:	89 e5                	mov    %esp,%ebp
f0100d64:	83 ec 28             	sub    $0x28,%esp
	if (argc != 1)
f0100d67:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
f0100d6b:	74 0e                	je     f0100d7b <mon_allocpage+0x1a>
	{	
		cprintf("\n Invalid no. of arguments !! \n");
f0100d6d:	c7 04 24 d0 5e 10 f0 	movl   $0xf0105ed0,(%esp)
f0100d74:	e8 ee 1b 00 00       	call   f0102967 <cprintf>
		return 0;
f0100d79:	eb 4b                	jmp    f0100dc6 <mon_allocpage+0x65>
	}	
	struct Page *p;
	int ret = page_alloc(&p);
f0100d7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100d7e:	89 04 24             	mov    %eax,(%esp)
f0100d81:	e8 a4 05 00 00       	call   f010132a <page_alloc>
	if (ret == -4)
f0100d86:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0100d89:	75 0e                	jne    f0100d99 <mon_allocpage+0x38>
	{
		cprintf("\n No memory to allocate a page !! \n");
f0100d8b:	c7 04 24 64 5f 10 f0 	movl   $0xf0105f64,(%esp)
f0100d92:	e8 d0 1b 00 00       	call   f0102967 <cprintf>
		return 0;
f0100d97:	eb 2d                	jmp    f0100dc6 <mon_allocpage+0x65>
	}	
	else 
	{
		p->pp_ref++;
f0100d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100d9c:	66 83 40 08 01       	addw   $0x1,0x8(%eax)
		cprintf("\n Page allocated: %x !! \n", PTE_ADDR(page2pa(p)));
f0100da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100da4:	2b 05 2c 8a 3c f0    	sub    0xf03c8a2c,%eax
f0100daa:	c1 f8 02             	sar    $0x2,%eax
f0100dad:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100db3:	c1 e0 0c             	shl    $0xc,%eax
f0100db6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100dba:	c7 04 24 64 5c 10 f0 	movl   $0xf0105c64,(%esp)
f0100dc1:	e8 a1 1b 00 00       	call   f0102967 <cprintf>
		return 0;
	}	
}
f0100dc6:	b8 00 00 00 00       	mov    $0x0,%eax
f0100dcb:	c9                   	leave  
f0100dcc:	c3                   	ret    

f0100dcd <mon_freepage>:
		cprintf("\n allocated\n");
	return 0;
}
int 
mon_freepage(int argc, char **argv, struct Trapframe *tf)
{
f0100dcd:	55                   	push   %ebp
f0100dce:	89 e5                	mov    %esp,%ebp
f0100dd0:	53                   	push   %ebx
f0100dd1:	83 ec 14             	sub    $0x14,%esp
	if (argc != 2)
f0100dd4:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100dd8:	74 0e                	je     f0100de8 <mon_freepage+0x1b>
	{	
		cprintf("\n Invalid no. of arguments !! \n");
f0100dda:	c7 04 24 d0 5e 10 f0 	movl   $0xf0105ed0,(%esp)
f0100de1:	e8 81 1b 00 00       	call   f0102967 <cprintf>
		return 0;
f0100de6:	eb 56                	jmp    f0100e3e <mon_freepage+0x71>
	}
	uintptr_t pa = string_to_hex(argv[1]);
f0100de8:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100deb:	8b 40 04             	mov    0x4(%eax),%eax
f0100dee:	89 04 24             	mov    %eax,(%esp)
f0100df1:	e8 02 f9 ff ff       	call   f01006f8 <string_to_hex>
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f0100df6:	c1 e8 0c             	shr    $0xc,%eax
f0100df9:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f0100dff:	72 1c                	jb     f0100e1d <mon_freepage+0x50>
		panic("pa2page called with invalid pa");
f0100e01:	c7 44 24 08 88 5f 10 	movl   $0xf0105f88,0x8(%esp)
f0100e08:	f0 
f0100e09:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
f0100e10:	00 
f0100e11:	c7 04 24 7e 5c 10 f0 	movl   $0xf0105c7e,(%esp)
f0100e18:	e8 68 f2 ff ff       	call   f0100085 <_panic>
	return &pages[PPN(pa)];
f0100e1d:	8d 1c 40             	lea    (%eax,%eax,2),%ebx
f0100e20:	c1 e3 02             	shl    $0x2,%ebx
f0100e23:	03 1d 2c 8a 3c f0    	add    0xf03c8a2c,%ebx
	struct Page *p = pa2page(pa);
	if (p->pp_ref == 0)
f0100e29:	66 83 7b 08 00       	cmpw   $0x0,0x8(%ebx)
f0100e2e:	74 0e                	je     f0100e3e <mon_freepage+0x71>
		return 0;
	page_free(p);
f0100e30:	89 1c 24             	mov    %ebx,(%esp)
f0100e33:	e8 bb 00 00 00       	call   f0100ef3 <page_free>
	p->pp_ref = 0;
f0100e38:	66 c7 43 08 00 00    	movw   $0x0,0x8(%ebx)
	return 0;
}	
f0100e3e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e43:	83 c4 14             	add    $0x14,%esp
f0100e46:	5b                   	pop    %ebx
f0100e47:	5d                   	pop    %ebp
f0100e48:	c3                   	ret    

f0100e49 <mon_statuspage>:
char * show_perm (int p);

/***** Implementations of basic kernel monitor commands *****/
int 
mon_statuspage(int argc, char **argv, struct Trapframe *tf)
{
f0100e49:	55                   	push   %ebp
f0100e4a:	89 e5                	mov    %esp,%ebp
f0100e4c:	83 ec 18             	sub    $0x18,%esp
	if (argc != 2)
f0100e4f:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
f0100e53:	74 0e                	je     f0100e63 <mon_statuspage+0x1a>
	{	
		cprintf("\n Invalid no. of arguments !! \n");
f0100e55:	c7 04 24 d0 5e 10 f0 	movl   $0xf0105ed0,(%esp)
f0100e5c:	e8 06 1b 00 00       	call   f0102967 <cprintf>
		return 0;
f0100e61:	eb 5f                	jmp    f0100ec2 <mon_statuspage+0x79>
	}
	uintptr_t pa = string_to_hex(argv[1]);
f0100e63:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100e66:	8b 40 04             	mov    0x4(%eax),%eax
f0100e69:	89 04 24             	mov    %eax,(%esp)
f0100e6c:	e8 87 f8 ff ff       	call   f01006f8 <string_to_hex>
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f0100e71:	c1 e8 0c             	shr    $0xc,%eax
f0100e74:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f0100e7a:	72 1c                	jb     f0100e98 <mon_statuspage+0x4f>
		panic("pa2page called with invalid pa");
f0100e7c:	c7 44 24 08 88 5f 10 	movl   $0xf0105f88,0x8(%esp)
f0100e83:	f0 
f0100e84:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
f0100e8b:	00 
f0100e8c:	c7 04 24 7e 5c 10 f0 	movl   $0xf0105c7e,(%esp)
f0100e93:	e8 ed f1 ff ff       	call   f0100085 <_panic>
	struct Page *p = pa2page(pa);
	if (p->pp_ref == 0)
f0100e98:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100e9b:	a1 2c 8a 3c f0       	mov    0xf03c8a2c,%eax
f0100ea0:	66 83 7c 90 08 00    	cmpw   $0x0,0x8(%eax,%edx,4)
f0100ea6:	75 0e                	jne    f0100eb6 <mon_statuspage+0x6d>
		cprintf("\n free\n");
f0100ea8:	c7 04 24 8c 5c 10 f0 	movl   $0xf0105c8c,(%esp)
f0100eaf:	e8 b3 1a 00 00       	call   f0102967 <cprintf>
f0100eb4:	eb 0c                	jmp    f0100ec2 <mon_statuspage+0x79>
	else
		cprintf("\n allocated\n");
f0100eb6:	c7 04 24 94 5c 10 f0 	movl   $0xf0105c94,(%esp)
f0100ebd:	e8 a5 1a 00 00       	call   f0102967 <cprintf>
	return 0;
}
f0100ec2:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ec7:	c9                   	leave  
f0100ec8:	c3                   	ret    
f0100ec9:	00 00                	add    %al,(%eax)
f0100ecb:	00 00                	add    %al,(%eax)
f0100ecd:	00 00                	add    %al,(%eax)
	...

f0100ed0 <page_alloc_high>:
	}
}

int
page_alloc_high(struct Page **pp_store, int i)
{
f0100ed0:	55                   	push   %ebp
f0100ed1:	89 e5                	mov    %esp,%ebp
	// cprintf("\n Starting page_alloc_high()\n");
	*pp_store = &pages[npage-i];
f0100ed3:	a1 20 8a 3c f0       	mov    0xf03c8a20,%eax
f0100ed8:	2b 45 0c             	sub    0xc(%ebp),%eax
f0100edb:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100ede:	c1 e2 02             	shl    $0x2,%edx
f0100ee1:	03 15 2c 8a 3c f0    	add    0xf03c8a2c,%edx
f0100ee7:	8b 45 08             	mov    0x8(%ebp),%eax
f0100eea:	89 10                	mov    %edx,(%eax)
	// cprintf("\n In middle of page_alloc_high()\n");
	// LIST_REMOVE(*pp_store, pp_link);
	// cprintf("\n Ending page_alloc_high()\n");
	return 0;
}
f0100eec:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ef1:	5d                   	pop    %ebp
f0100ef2:	c3                   	ret    

f0100ef3 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct Page *pp)
{
f0100ef3:	55                   	push   %ebp
f0100ef4:	89 e5                	mov    %esp,%ebp
f0100ef6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Page *p;
	int size;
	// Fill this function in
	// Code added by Swastika / Sandeep
	LIST_INSERT_HEAD(&page_free_list, pp, pp_link);
f0100ef9:	8b 15 58 35 3c f0    	mov    0xf03c3558,%edx
f0100eff:	89 10                	mov    %edx,(%eax)
f0100f01:	85 d2                	test   %edx,%edx
f0100f03:	74 09                	je     f0100f0e <page_free+0x1b>
f0100f05:	8b 15 58 35 3c f0    	mov    0xf03c3558,%edx
f0100f0b:	89 42 04             	mov    %eax,0x4(%edx)
f0100f0e:	a3 58 35 3c f0       	mov    %eax,0xf03c3558
f0100f13:	c7 40 04 58 35 3c f0 	movl   $0xf03c3558,0x4(%eax)
	LIST_GET_SIZE(size, p, &page_free_list, pp_link);
f0100f1a:	a1 58 35 3c f0       	mov    0xf03c3558,%eax
f0100f1f:	85 c0                	test   %eax,%eax
f0100f21:	74 06                	je     f0100f29 <page_free+0x36>
f0100f23:	8b 00                	mov    (%eax),%eax
f0100f25:	85 c0                	test   %eax,%eax
f0100f27:	75 fa                	jne    f0100f23 <page_free+0x30>
	// cprintf("[page_free] %08x (# free pages = %d)\n", pp, size);

}
f0100f29:	5d                   	pop    %ebp
f0100f2a:	c3                   	ret    

f0100f2b <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct Page* pp)
{
f0100f2b:	55                   	push   %ebp
f0100f2c:	89 e5                	mov    %esp,%ebp
f0100f2e:	83 ec 04             	sub    $0x4,%esp
f0100f31:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0100f34:	0f b7 50 08          	movzwl 0x8(%eax),%edx
f0100f38:	83 ea 01             	sub    $0x1,%edx
f0100f3b:	66 89 50 08          	mov    %dx,0x8(%eax)
f0100f3f:	66 85 d2             	test   %dx,%dx
f0100f42:	75 08                	jne    f0100f4c <page_decref+0x21>
		page_free(pp);
f0100f44:	89 04 24             	mov    %eax,(%esp)
f0100f47:	e8 a7 ff ff ff       	call   f0100ef3 <page_free>
}
f0100f4c:	c9                   	leave  
f0100f4d:	c3                   	ret    

f0100f4e <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0100f4e:	55                   	push   %ebp
f0100f4f:	89 e5                	mov    %esp,%ebp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0100f51:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0100f56:	85 c0                	test   %eax,%eax
f0100f58:	74 08                	je     f0100f62 <tlb_invalidate+0x14>
f0100f5a:	8b 55 08             	mov    0x8(%ebp),%edx
f0100f5d:	39 50 5c             	cmp    %edx,0x5c(%eax)
f0100f60:	75 06                	jne    f0100f68 <tlb_invalidate+0x1a>
}

static __inline void 
invlpg(void *addr)
{ 
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0100f62:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100f65:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f0100f68:	5d                   	pop    %ebp
f0100f69:	c3                   	ret    

f0100f6a <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f0100f6a:	55                   	push   %ebp
f0100f6b:	89 e5                	mov    %esp,%ebp
f0100f6d:	57                   	push   %edi
f0100f6e:	56                   	push   %esi
f0100f6f:	53                   	push   %ebx
f0100f70:	83 ec 2c             	sub    $0x2c,%esp
	// Code added by Sandeep / Swastika
	int i, u, v, perm_flag = 1;
	uintptr_t pdeno, pteno;
	pte_t *pt = NULL;

	u = (int) va;
f0100f73:	8b 45 0c             	mov    0xc(%ebp),%eax
	v = (int)(va + len);
f0100f76:	8b 55 10             	mov    0x10(%ebp),%edx
f0100f79:	01 c2                	add    %eax,%edx
f0100f7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (; u < v; u++)
f0100f7e:	39 d0                	cmp    %edx,%eax
f0100f80:	0f 8d de 00 00 00    	jge    f0101064 <user_mem_check+0xfa>
	{
		pdeno = PDX(u);
f0100f86:	89 c1                	mov    %eax,%ecx
		pteno = PTX(u);
		if ((env->env_pgdir[pdeno] & (perm | PTE_P)) != (perm | PTE_P))
f0100f88:	8b 55 08             	mov    0x8(%ebp),%edx
f0100f8b:	8b 72 5c             	mov    0x5c(%edx),%esi
f0100f8e:	89 c2                	mov    %eax,%edx
f0100f90:	c1 ea 16             	shr    $0x16,%edx
f0100f93:	8b 1c 96             	mov    (%esi,%edx,4),%ebx
f0100f96:	8b 55 14             	mov    0x14(%ebp),%edx
f0100f99:	83 ca 01             	or     $0x1,%edx
f0100f9c:	89 df                	mov    %ebx,%edi
f0100f9e:	21 d7                	and    %edx,%edi
f0100fa0:	39 fa                	cmp    %edi,%edx
f0100fa2:	75 2d                	jne    f0100fd1 <user_mem_check+0x67>
		#ifdef HIGHMEM	
			pt = (pte_t*) kmap(PTE_ADDR(env->env_pgdir[pdeno])); 
			if (pt < 0)
				return -E_HIGHMEM;
		#else
			pt = (pte_t*) KADDR (PTE_ADDR(env->env_pgdir[pdeno]));
f0100fa4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0100faa:	8b 3d 20 8a 3c f0    	mov    0xf03c8a20,%edi
f0100fb0:	89 7d e0             	mov    %edi,-0x20(%ebp)
f0100fb3:	89 df                	mov    %ebx,%edi
f0100fb5:	c1 ef 0c             	shr    $0xc,%edi
f0100fb8:	3b 7d e0             	cmp    -0x20(%ebp),%edi
f0100fbb:	72 61                	jb     f010101e <user_mem_check+0xb4>
f0100fbd:	eb 3f                	jmp    f0100ffe <user_mem_check+0x94>
f0100fbf:	89 c1                	mov    %eax,%ecx
	v = (int)(va + len);
	for (; u < v; u++)
	{
		pdeno = PDX(u);
		pteno = PTX(u);
		if ((env->env_pgdir[pdeno] & (perm | PTE_P)) != (perm | PTE_P))
f0100fc1:	89 c3                	mov    %eax,%ebx
f0100fc3:	c1 eb 16             	shr    $0x16,%ebx
f0100fc6:	8b 1c 9e             	mov    (%esi,%ebx,4),%ebx
f0100fc9:	89 df                	mov    %ebx,%edi
f0100fcb:	21 d7                	and    %edx,%edi
f0100fcd:	39 d7                	cmp    %edx,%edi
f0100fcf:	74 10                	je     f0100fe1 <user_mem_check+0x77>
		{
			user_mem_check_addr = u;
f0100fd1:	89 0d 5c 35 3c f0    	mov    %ecx,0xf03c355c
f0100fd7:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
			perm_flag = 0;
			break;
f0100fdc:	e9 88 00 00 00       	jmp    f0101069 <user_mem_check+0xff>
		#ifdef HIGHMEM	
			pt = (pte_t*) kmap(PTE_ADDR(env->env_pgdir[pdeno])); 
			if (pt < 0)
				return -E_HIGHMEM;
		#else
			pt = (pte_t*) KADDR (PTE_ADDR(env->env_pgdir[pdeno]));
f0100fe1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0100fe7:	89 df                	mov    %ebx,%edi
f0100fe9:	c1 ef 0c             	shr    $0xc,%edi
f0100fec:	3b 7d e0             	cmp    -0x20(%ebp),%edi
f0100fef:	73 0d                	jae    f0100ffe <user_mem_check+0x94>
	u = (int) va;
	v = (int)(va + len);
	for (; u < v; u++)
	{
		pdeno = PDX(u);
		pteno = PTX(u);
f0100ff1:	89 c7                	mov    %eax,%edi
f0100ff3:	c1 ef 0c             	shr    $0xc,%edi
f0100ff6:	81 e7 ff 03 00 00    	and    $0x3ff,%edi
f0100ffc:	eb 2b                	jmp    f0101029 <user_mem_check+0xbf>
		#ifdef HIGHMEM	
			pt = (pte_t*) kmap(PTE_ADDR(env->env_pgdir[pdeno])); 
			if (pt < 0)
				return -E_HIGHMEM;
		#else
			pt = (pte_t*) KADDR (PTE_ADDR(env->env_pgdir[pdeno]));
f0100ffe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0101002:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f0101009:	f0 
f010100a:	c7 44 24 04 2d 04 00 	movl   $0x42d,0x4(%esp)
f0101011:	00 
f0101012:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101019:	e8 67 f0 ff ff       	call   f0100085 <_panic>
	u = (int) va;
	v = (int)(va + len);
	for (; u < v; u++)
	{
		pdeno = PDX(u);
		pteno = PTX(u);
f010101e:	89 c7                	mov    %eax,%edi
f0101020:	c1 ef 0c             	shr    $0xc,%edi
f0101023:	81 e7 ff 03 00 00    	and    $0x3ff,%edi
			if (pt < 0)
				return -E_HIGHMEM;
		#else
			pt = (pte_t*) KADDR (PTE_ADDR(env->env_pgdir[pdeno]));
		#endif	
		if ((pt[pteno] & (perm | PTE_P)) != (perm | PTE_P))
f0101029:	8b 9c bb 00 00 00 f0 	mov    -0x10000000(%ebx,%edi,4),%ebx
f0101030:	21 d3                	and    %edx,%ebx
f0101032:	39 da                	cmp    %ebx,%edx
f0101034:	74 0d                	je     f0101043 <user_mem_check+0xd9>
		{
			user_mem_check_addr = u;
f0101036:	89 0d 5c 35 3c f0    	mov    %ecx,0xf03c355c
f010103c:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
			perm_flag = 0;
			break;
f0101041:	eb 26                	jmp    f0101069 <user_mem_check+0xff>
		}	
		if (u >= ULIM)
f0101043:	81 f9 ff ff 7f ef    	cmp    $0xef7fffff,%ecx
f0101049:	76 0d                	jbe    f0101058 <user_mem_check+0xee>
		{
			user_mem_check_addr = u;
f010104b:	89 0d 5c 35 3c f0    	mov    %ecx,0xf03c355c
f0101051:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
			perm_flag = 0;
			break;
f0101056:	eb 11                	jmp    f0101069 <user_mem_check+0xff>
	uintptr_t pdeno, pteno;
	pte_t *pt = NULL;

	u = (int) va;
	v = (int)(va + len);
	for (; u < v; u++)
f0101058:	83 c0 01             	add    $0x1,%eax
f010105b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f010105e:	0f 8f 5b ff ff ff    	jg     f0100fbf <user_mem_check+0x55>
f0101064:	b8 00 00 00 00       	mov    $0x0,%eax

	if (perm_flag == 0)
		return -E_FAULT;
	else 
		return 0;
}
f0101069:	83 c4 2c             	add    $0x2c,%esp
f010106c:	5b                   	pop    %ebx
f010106d:	5e                   	pop    %esi
f010106e:	5f                   	pop    %edi
f010106f:	5d                   	pop    %ebp
f0101070:	c3                   	ret    

f0101071 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0101071:	55                   	push   %ebp
f0101072:	89 e5                	mov    %esp,%ebp
f0101074:	53                   	push   %ebx
f0101075:	83 ec 14             	sub    $0x14,%esp
f0101078:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f010107b:	8b 45 14             	mov    0x14(%ebp),%eax
f010107e:	83 c8 04             	or     $0x4,%eax
f0101081:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101085:	8b 45 10             	mov    0x10(%ebp),%eax
f0101088:	89 44 24 08          	mov    %eax,0x8(%esp)
f010108c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010108f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101093:	89 1c 24             	mov    %ebx,(%esp)
f0101096:	e8 cf fe ff ff       	call   f0100f6a <user_mem_check>
f010109b:	85 c0                	test   %eax,%eax
f010109d:	79 24                	jns    f01010c3 <user_mem_assert+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
f010109f:	a1 5c 35 3c f0       	mov    0xf03c355c,%eax
f01010a4:	89 44 24 08          	mov    %eax,0x8(%esp)
f01010a8:	8b 43 4c             	mov    0x4c(%ebx),%eax
f01010ab:	89 44 24 04          	mov    %eax,0x4(%esp)
f01010af:	c7 04 24 24 61 10 f0 	movl   $0xf0106124,(%esp)
f01010b6:	e8 ac 18 00 00       	call   f0102967 <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f01010bb:	89 1c 24             	mov    %ebx,(%esp)
f01010be:	e8 ef 12 00 00       	call   f01023b2 <env_destroy>
	}
}
f01010c3:	83 c4 14             	add    $0x14,%esp
f01010c6:	5b                   	pop    %ebx
f01010c7:	5d                   	pop    %ebp
f01010c8:	c3                   	ret    

f01010c9 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f01010c9:	55                   	push   %ebp
f01010ca:	89 e5                	mov    %esp,%ebp
f01010cc:	56                   	push   %esi
f01010cd:	53                   	push   %ebx
f01010ce:	83 ec 10             	sub    $0x10,%esp
	//     in physical memory?  Which pages are already in use for
	//     page tables and other data structures?
	//
	// Change the code to reflect this.
	int i, last_used_page;
	LIST_INIT(&page_free_list);
f01010d1:	c7 05 58 35 3c f0 00 	movl   $0x0,0xf03c3558
f01010d8:	00 00 00 
        int c_free = 0;
	
	// Code added by Sandeep / Swastika
	
	// Step 1
	pages[0].pp_ref = 1; 
f01010db:	a1 2c 8a 3c f0       	mov    0xf03c8a2c,%eax
f01010e0:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)
	
	#ifndef HIGHMEM
	// Step 2
	for (i = 1; i < (basemem / PGSIZE); i++){
f01010e6:	a1 4c 35 3c f0       	mov    0xf03c354c,%eax
f01010eb:	c1 e8 0c             	shr    $0xc,%eax
f01010ee:	b9 00 00 00 00       	mov    $0x0,%ecx
f01010f3:	83 f8 01             	cmp    $0x1,%eax
f01010f6:	76 61                	jbe    f0101159 <page_init+0x90>
// After this is done, NEVER use boot_alloc again.  ONLY use the page
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
f01010f8:	89 c1                	mov    %eax,%ecx
f01010fa:	b8 01 00 00 00       	mov    $0x1,%eax
f01010ff:	ba 01 00 00 00       	mov    $0x1,%edx
	pages[0].pp_ref = 1; 
	
	#ifndef HIGHMEM
	// Step 2
	for (i = 1; i < (basemem / PGSIZE); i++){
		pages[i].pp_ref = 0;
f0101104:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0101107:	c1 e0 02             	shl    $0x2,%eax
f010110a:	8b 1d 2c 8a 3c f0    	mov    0xf03c8a2c,%ebx
f0101110:	66 c7 44 03 08 00 00 	movw   $0x0,0x8(%ebx,%eax,1)
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
f0101117:	8b 1d 58 35 3c f0    	mov    0xf03c3558,%ebx
f010111d:	8b 35 2c 8a 3c f0    	mov    0xf03c8a2c,%esi
f0101123:	89 1c 06             	mov    %ebx,(%esi,%eax,1)
f0101126:	85 db                	test   %ebx,%ebx
f0101128:	74 11                	je     f010113b <page_init+0x72>
f010112a:	89 c6                	mov    %eax,%esi
f010112c:	03 35 2c 8a 3c f0    	add    0xf03c8a2c,%esi
f0101132:	8b 1d 58 35 3c f0    	mov    0xf03c3558,%ebx
f0101138:	89 73 04             	mov    %esi,0x4(%ebx)
f010113b:	03 05 2c 8a 3c f0    	add    0xf03c8a2c,%eax
f0101141:	a3 58 35 3c f0       	mov    %eax,0xf03c3558
f0101146:	c7 40 04 58 35 3c f0 	movl   $0xf03c3558,0x4(%eax)
	// Step 1
	pages[0].pp_ref = 1; 
	
	#ifndef HIGHMEM
	// Step 2
	for (i = 1; i < (basemem / PGSIZE); i++){
f010114d:	83 c2 01             	add    $0x1,%edx
f0101150:	89 d0                	mov    %edx,%eax
f0101152:	39 ca                	cmp    %ecx,%edx
f0101154:	75 ae                	jne    f0101104 <page_init+0x3b>
f0101156:	83 e9 01             	sub    $0x1,%ecx
f0101159:	b8 80 07 00 00       	mov    $0x780,%eax
	#endif
	
	// Step 3
	for (i = (IOPHYSMEM / PGSIZE); i < (EXTPHYSMEM / PGSIZE); i++)
	{
		pages[i].pp_ref = 1;
f010115e:	8b 15 2c 8a 3c f0    	mov    0xf03c8a2c,%edx
f0101164:	66 c7 44 02 08 01 00 	movw   $0x1,0x8(%edx,%eax,1)
f010116b:	83 c0 0c             	add    $0xc,%eax
		c_free++;
	}
	#endif
	
	// Step 3
	for (i = (IOPHYSMEM / PGSIZE); i < (EXTPHYSMEM / PGSIZE); i++)
f010116e:	3d 00 0c 00 00       	cmp    $0xc00,%eax
f0101173:	75 e9                	jne    f010115e <page_init+0x95>
	{
		pages[i].pp_ref = 1;
	}
 	
	// Step 4
	for (i = (EXTPHYSMEM / PGSIZE); i <= PADDR(boot_freemem)/PGSIZE ; i++)
f0101175:	a1 54 35 3c f0       	mov    0xf03c3554,%eax
f010117a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010117f:	76 2b                	jbe    f01011ac <page_init+0xe3>
f0101181:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
f0101187:	c1 ee 0c             	shr    $0xc,%esi
f010118a:	81 fe ff 00 00 00    	cmp    $0xff,%esi
f0101190:	76 3e                	jbe    f01011d0 <page_init+0x107>
	{
		pages[i].pp_ref = 1;
f0101192:	a1 2c 8a 3c f0       	mov    0xf03c8a2c,%eax
f0101197:	66 c7 80 08 0c 00 00 	movw   $0x1,0xc08(%eax)
f010119e:	01 00 
f01011a0:	ba 01 01 00 00       	mov    $0x101,%edx
f01011a5:	b8 01 01 00 00       	mov    $0x101,%eax
f01011aa:	eb 20                	jmp    f01011cc <page_init+0x103>
	{
		pages[i].pp_ref = 1;
	}
 	
	// Step 4
	for (i = (EXTPHYSMEM / PGSIZE); i <= PADDR(boot_freemem)/PGSIZE ; i++)
f01011ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01011b0:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f01011b7:	f0 
f01011b8:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
f01011bf:	00 
f01011c0:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f01011c7:	e8 b9 ee ff ff       	call   f0100085 <_panic>
f01011cc:	39 f0                	cmp    %esi,%eax
f01011ce:	76 7c                	jbe    f010124c <page_init+0x183>
		pages[i].pp_ref = 1;
	}
	
	#ifndef HIGHMEM
	// mark the rest of the pages as free
	for (i = PADDR(boot_freemem)/PGSIZE; i < npage; i++) {
f01011d0:	89 f2                	mov    %esi,%edx
f01011d2:	89 f0                	mov    %esi,%eax
f01011d4:	39 35 20 8a 3c f0    	cmp    %esi,0xf03c8a20
f01011da:	76 59                	jbe    f0101235 <page_init+0x16c>
		pages[i].pp_ref = 0;
f01011dc:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01011df:	c1 e0 02             	shl    $0x2,%eax
f01011e2:	8b 1d 2c 8a 3c f0    	mov    0xf03c8a2c,%ebx
f01011e8:	66 c7 44 03 08 00 00 	movw   $0x0,0x8(%ebx,%eax,1)
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
f01011ef:	8b 1d 58 35 3c f0    	mov    0xf03c3558,%ebx
f01011f5:	8b 35 2c 8a 3c f0    	mov    0xf03c8a2c,%esi
f01011fb:	89 1c 06             	mov    %ebx,(%esi,%eax,1)
f01011fe:	85 db                	test   %ebx,%ebx
f0101200:	74 11                	je     f0101213 <page_init+0x14a>
f0101202:	89 c6                	mov    %eax,%esi
f0101204:	03 35 2c 8a 3c f0    	add    0xf03c8a2c,%esi
f010120a:	8b 1d 58 35 3c f0    	mov    0xf03c3558,%ebx
f0101210:	89 73 04             	mov    %esi,0x4(%ebx)
f0101213:	03 05 2c 8a 3c f0    	add    0xf03c8a2c,%eax
f0101219:	a3 58 35 3c f0       	mov    %eax,0xf03c3558
f010121e:	c7 40 04 58 35 3c f0 	movl   $0xf03c3558,0x4(%eax)
		c_free++;
f0101225:	83 c1 01             	add    $0x1,%ecx
		pages[i].pp_ref = 1;
	}
	
	#ifndef HIGHMEM
	// mark the rest of the pages as free
	for (i = PADDR(boot_freemem)/PGSIZE; i < npage; i++) {
f0101228:	83 c2 01             	add    $0x1,%edx
f010122b:	89 d0                	mov    %edx,%eax
f010122d:	3b 15 20 8a 3c f0    	cmp    0xf03c8a20,%edx
f0101233:	72 a7                	jb     f01011dc <page_init+0x113>
		pages[i].pp_ref = 0;
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
		c_free++;
	}
	#endif
	cprintf("\n Count of free pages: %d\n", c_free);
f0101235:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0101239:	c7 04 24 c3 62 10 f0 	movl   $0xf01062c3,(%esp)
f0101240:	e8 22 17 00 00       	call   f0102967 <cprintf>

}
f0101245:	83 c4 10             	add    $0x10,%esp
f0101248:	5b                   	pop    %ebx
f0101249:	5e                   	pop    %esi
f010124a:	5d                   	pop    %ebp
f010124b:	c3                   	ret    
	}
 	
	// Step 4
	for (i = (EXTPHYSMEM / PGSIZE); i <= PADDR(boot_freemem)/PGSIZE ; i++)
	{
		pages[i].pp_ref = 1;
f010124c:	8d 1c 40             	lea    (%eax,%eax,2),%ebx
f010124f:	a1 2c 8a 3c f0       	mov    0xf03c8a2c,%eax
f0101254:	66 c7 44 98 08 01 00 	movw   $0x1,0x8(%eax,%ebx,4)
	{
		pages[i].pp_ref = 1;
	}
 	
	// Step 4
	for (i = (EXTPHYSMEM / PGSIZE); i <= PADDR(boot_freemem)/PGSIZE ; i++)
f010125b:	83 c2 01             	add    $0x1,%edx
f010125e:	89 d0                	mov    %edx,%eax
f0101260:	e9 67 ff ff ff       	jmp    f01011cc <page_init+0x103>

f0101265 <boot_alloc>:
// This function may ONLY be used during initialization,
// before the page_free_list has been set up.
// 
static void*
boot_alloc(uint32_t n, uint32_t align)
{
f0101265:	55                   	push   %ebp
f0101266:	89 e5                	mov    %esp,%ebp
f0101268:	83 ec 28             	sub    $0x28,%esp
f010126b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f010126e:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0101271:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0101274:	89 c3                	mov    %eax,%ebx
f0101276:	89 d7                	mov    %edx,%edi
	// Initialize boot_freemem if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment -
	// i.e., the first virtual address that the linker
	// did _not_ assign to any kernel code or global variables.
	if (boot_freemem == 0)
f0101278:	83 3d 54 35 3c f0 00 	cmpl   $0x0,0xf03c3554
f010127f:	75 0a                	jne    f010128b <boot_alloc+0x26>
		boot_freemem = end;
f0101281:	c7 05 54 35 3c f0 88 	movl   $0xf03c8a88,0xf03c3554
f0101288:	8a 3c f0 
	//	Step 3: increase boot_freemem to record allocation
	//	Step 4: return allocated chunk
	
	// Code for Steps 1-4 
	// Added by Sandeep / Swastika
	boot_freemem = ROUNDUP(boot_freemem, align);
f010128b:	a1 54 35 3c f0       	mov    0xf03c3554,%eax
f0101290:	8d 4c 38 ff          	lea    -0x1(%eax,%edi,1),%ecx
f0101294:	89 c8                	mov    %ecx,%eax
f0101296:	ba 00 00 00 00       	mov    $0x0,%edx
f010129b:	f7 f7                	div    %edi
f010129d:	89 c8                	mov    %ecx,%eax
f010129f:	29 d0                	sub    %edx,%eax
f01012a1:	a3 54 35 3c f0       	mov    %eax,0xf03c3554
	v = boot_freemem;
	if (PADDR(boot_freemem + n) > maxpa)
f01012a6:	8d 14 18             	lea    (%eax,%ebx,1),%edx
f01012a9:	89 d1                	mov    %edx,%ecx
f01012ab:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01012b1:	77 20                	ja     f01012d3 <boot_alloc+0x6e>
f01012b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01012b7:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f01012be:	f0 
f01012bf:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
f01012c6:	00 
f01012c7:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f01012ce:	e8 b2 ed ff ff       	call   f0100085 <_panic>
f01012d3:	8b 35 48 35 3c f0    	mov    0xf03c3548,%esi
f01012d9:	81 c1 00 00 00 10    	add    $0x10000000,%ecx
f01012df:	39 f1                	cmp    %esi,%ecx
f01012e1:	76 34                	jbe    f0101317 <boot_alloc+0xb2>
	{
		cprintf("\n boot_freemem = %x, n = %d, maxpa = %x\n", boot_freemem, n, maxpa);
f01012e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01012e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01012eb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01012ef:	c7 04 24 80 61 10 f0 	movl   $0xf0106180,(%esp)
f01012f6:	e8 6c 16 00 00       	call   f0102967 <cprintf>
		panic("Out of memory !! boot_alloc panics !! \n");
f01012fb:	c7 44 24 08 ac 61 10 	movl   $0xf01061ac,0x8(%esp)
f0101302:	f0 
f0101303:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
f010130a:	00 
f010130b:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101312:	e8 6e ed ff ff       	call   f0100085 <_panic>
		return NULL;
	}
	else	
	{
		boot_freemem = boot_freemem +  n;
f0101317:	89 15 54 35 3c f0    	mov    %edx,0xf03c3554
		return v;
	}

}
f010131d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0101320:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0101323:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0101326:	89 ec                	mov    %ebp,%esp
f0101328:	5d                   	pop    %ebp
f0101329:	c3                   	ret    

f010132a <page_alloc>:
//   -E_NO_MEM -- otherwise 
//
// Hint: use LIST_FIRST, LIST_REMOVE, and page_initpp
int
page_alloc(struct Page **pp_store)
{
f010132a:	55                   	push   %ebp
f010132b:	89 e5                	mov    %esp,%ebp
f010132d:	83 ec 18             	sub    $0x18,%esp
f0101330:	8b 4d 08             	mov    0x8(%ebp),%ecx
	struct Page *p;
	int size;
	// Fill this function in
	// Code added by Sandeep / Swastika
	*pp_store = LIST_FIRST(&page_free_list);
f0101333:	8b 15 58 35 3c f0    	mov    0xf03c3558,%edx
f0101339:	89 11                	mov    %edx,(%ecx)
	if(*pp_store != NULL)
f010133b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101340:	85 d2                	test   %edx,%edx
f0101342:	74 43                	je     f0101387 <page_alloc+0x5d>
	{
		LIST_REMOVE(*pp_store, pp_link);
f0101344:	8b 02                	mov    (%edx),%eax
f0101346:	85 c0                	test   %eax,%eax
f0101348:	74 06                	je     f0101350 <page_alloc+0x26>
f010134a:	8b 52 04             	mov    0x4(%edx),%edx
f010134d:	89 50 04             	mov    %edx,0x4(%eax)
f0101350:	8b 01                	mov    (%ecx),%eax
f0101352:	8b 50 04             	mov    0x4(%eax),%edx
f0101355:	8b 00                	mov    (%eax),%eax
f0101357:	89 02                	mov    %eax,(%edx)
// Note that the corresponding physical page is NOT initialized!
//
static void
page_initpp(struct Page *pp)
{
	memset(pp, 0, sizeof(*pp));
f0101359:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
f0101360:	00 
f0101361:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101368:	00 
f0101369:	8b 01                	mov    (%ecx),%eax
f010136b:	89 04 24             	mov    %eax,(%esp)
f010136e:	e8 c3 32 00 00       	call   f0104636 <memset>
	*pp_store = LIST_FIRST(&page_free_list);
	if(*pp_store != NULL)
	{
		LIST_REMOVE(*pp_store, pp_link);
		page_initpp(*pp_store);
		LIST_GET_SIZE(size, p, &page_free_list, pp_link)
f0101373:	a1 58 35 3c f0       	mov    0xf03c3558,%eax
f0101378:	85 c0                	test   %eax,%eax
f010137a:	74 06                	je     f0101382 <page_alloc+0x58>
f010137c:	8b 00                	mov    (%eax),%eax
f010137e:	85 c0                	test   %eax,%eax
f0101380:	75 fa                	jne    f010137c <page_alloc+0x52>
f0101382:	b8 00 00 00 00       	mov    $0x0,%eax
	}	
	else
	{
		return -E_NO_MEM;
	}
}
f0101387:	c9                   	leave  
f0101388:	c3                   	ret    

f0101389 <pgdir_walk>:
// Hint 2: the x86 MMU checks permission bits in both the page directory
// and the page table, so it's safe to leave permissions in the page
// more permissive than strictly necessary.
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f0101389:	55                   	push   %ebp
f010138a:	89 e5                	mov    %esp,%ebp
f010138c:	83 ec 28             	sub    $0x28,%esp
f010138f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0101392:	89 75 fc             	mov    %esi,-0x4(%ebp)
	// Fill this function in
	
	// Code added by Swastika / Sandeep
	// Walk the two-level page table structure in a bid to locate the page table entry (PTE) for linear address va

	int pdx = PDX (va);	
f0101395:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int ptx = PTX (va);
	int perm;

	pde_t *  pgdir_now =  &pgdir[pdx];
f0101398:	89 de                	mov    %ebx,%esi
f010139a:	c1 ee 16             	shr    $0x16,%esi
f010139d:	c1 e6 02             	shl    $0x2,%esi
f01013a0:	03 75 08             	add    0x8(%ebp),%esi
	struct Page *pp_store;
	pte_t * ptdir;

	// changed lab2 here
	if (*pgdir_now & PTE_P)		// relevant page table exists
f01013a3:	8b 06                	mov    (%esi),%eax
f01013a5:	a8 01                	test   $0x1,%al
f01013a7:	74 40                	je     f01013e9 <pgdir_walk+0x60>
			// call kmap  instead of KADDR 
			ptdir = (pte_t *)kmap(PTE_ADDR(*pgdir_now));
			if (ptdir < 0)
				return NULL;	
		#else 
			ptdir = (pte_t *)KADDR(PTE_ADDR(*pgdir_now));	
f01013a9:	89 c6                	mov    %eax,%esi
f01013ab:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f01013b1:	89 f0                	mov    %esi,%eax
f01013b3:	c1 e8 0c             	shr    $0xc,%eax
f01013b6:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f01013bc:	72 20                	jb     f01013de <pgdir_walk+0x55>
f01013be:	89 74 24 0c          	mov    %esi,0xc(%esp)
f01013c2:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f01013c9:	f0 
f01013ca:	c7 44 24 04 03 03 00 	movl   $0x303,0x4(%esp)
f01013d1:	00 
f01013d2:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f01013d9:	e8 a7 ec ff ff       	call   f0100085 <_panic>
f01013de:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f01013e4:	e9 b0 00 00 00       	jmp    f0101499 <pgdir_walk+0x110>
		#endif
	}
	else 				// relevant page table doesn't exist
	{
		if (create == 0)
f01013e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01013ed:	0f 84 b5 00 00 00    	je     f01014a8 <pgdir_walk+0x11f>
			return NULL;	// do not create a new page table entry
		// allocate a new page
		if (page_alloc(&pp_store) == -E_NO_MEM)	//page allocation failed
f01013f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01013f6:	89 04 24             	mov    %eax,(%esp)
f01013f9:	e8 2c ff ff ff       	call   f010132a <page_alloc>
f01013fe:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101401:	0f 84 a1 00 00 00    	je     f01014a8 <pgdir_walk+0x11f>
		{
			// cprintf("\n In pgdir_walk: no memory !!\n");
			return NULL;	
		}		
		pp_store->pp_ref = 1; 	// set pp_ref for the new page table
f0101407:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010140a:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)
		
		*pgdir_now = PTE_ADDR(page2pa(pp_store));	// convert Page* address to physical
f0101410:	8b 55 f4             	mov    -0xc(%ebp),%edx


static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101413:	8b 0d 2c 8a 3c f0    	mov    0xf03c8a2c,%ecx
		if ((uintptr_t)va > ULIM)
f0101419:	b8 03 00 00 00       	mov    $0x3,%eax
f010141e:	81 fb 00 00 80 ef    	cmp    $0xef800000,%ebx
f0101424:	77 0e                	ja     f0101434 <pgdir_walk+0xab>
			perm = PTE_P | PTE_W;
		else if ((uintptr_t)va > UTOP)
f0101426:	81 fb 01 00 c0 ee    	cmp    $0xeec00001,%ebx
f010142c:	19 c0                	sbb    %eax,%eax
f010142e:	83 e0 02             	and    $0x2,%eax
f0101431:	83 c0 05             	add    $0x5,%eax
			perm = PTE_P | PTE_U;
		else
			perm = PTE_P | PTE_U | PTE_W;	

		*pgdir_now = *pgdir_now | perm;	// set perms
f0101434:	29 ca                	sub    %ecx,%edx
f0101436:	c1 fa 02             	sar    $0x2,%edx
f0101439:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f010143f:	c1 e2 0c             	shl    $0xc,%edx
f0101442:	09 d0                	or     %edx,%eax
f0101444:	89 06                	mov    %eax,(%esi)
			// call kmap  instead of KADDR
			ptdir = (pte_t *)kmap(PTE_ADDR(*pgdir_now));	
			if (ptdir < 0)
				return NULL;	
		#else 
			ptdir = (pte_t *)KADDR(PTE_ADDR(*pgdir_now));	
f0101446:	89 c6                	mov    %eax,%esi
f0101448:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
f010144e:	89 f0                	mov    %esi,%eax
f0101450:	c1 e8 0c             	shr    $0xc,%eax
f0101453:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f0101459:	72 20                	jb     f010147b <pgdir_walk+0xf2>
f010145b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010145f:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f0101466:	f0 
f0101467:	c7 44 24 04 25 03 00 	movl   $0x325,0x4(%esp)
f010146e:	00 
f010146f:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101476:	e8 0a ec ff ff       	call   f0100085 <_panic>
f010147b:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
		#endif

		memset (ptdir, 0, PGSIZE);	// clear the new page table
f0101481:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101488:	00 
f0101489:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101490:	00 
f0101491:	89 34 24             	mov    %esi,(%esp)
f0101494:	e8 9d 31 00 00       	call   f0104636 <memset>
	} 		 	
	return &ptdir[ptx];		// return pointer to page table entry
f0101499:	c1 eb 0a             	shr    $0xa,%ebx
f010149c:	89 d8                	mov    %ebx,%eax
f010149e:	25 fc 0f 00 00       	and    $0xffc,%eax
f01014a3:	8d 04 06             	lea    (%esi,%eax,1),%eax
f01014a6:	eb 05                	jmp    f01014ad <pgdir_walk+0x124>
f01014a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01014ad:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f01014b0:	8b 75 fc             	mov    -0x4(%ebp),%esi
f01014b3:	89 ec                	mov    %ebp,%esp
f01014b5:	5d                   	pop    %ebp
f01014b6:	c3                   	ret    

f01014b7 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct Page *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f01014b7:	55                   	push   %ebp
f01014b8:	89 e5                	mov    %esp,%ebp
f01014ba:	53                   	push   %ebx
f01014bb:	83 ec 14             	sub    $0x14,%esp
f01014be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// Fill this function in
	// Code added by Swastika / Sandeep
	struct Page *p;
	pte_t *table_entry = pgdir_walk(pgdir, va, 0);
f01014c1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01014c8:	00 
f01014c9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01014cc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01014d0:	8b 45 08             	mov    0x8(%ebp),%eax
f01014d3:	89 04 24             	mov    %eax,(%esp)
f01014d6:	e8 ae fe ff ff       	call   f0101389 <pgdir_walk>
	
	// pgdir_walk() might have resulted in a high memory mapping, but we cannot remove the mapping just yet
	// this is because the calling function will access this data using pte_store
	// so, we ensure the function calling page_lookup removes the mapping  
	
	if (table_entry == NULL)
f01014db:	85 c0                	test   %eax,%eax
f01014dd:	74 42                	je     f0101521 <page_lookup+0x6a>
		return NULL;
	if (*table_entry == 0)
f01014df:	83 38 00             	cmpl   $0x0,(%eax)
f01014e2:	74 3d                	je     f0101521 <page_lookup+0x6a>
		return NULL;
	if (pte_store != 0)
f01014e4:	85 db                	test   %ebx,%ebx
f01014e6:	74 02                	je     f01014ea <page_lookup+0x33>
	{
		*pte_store = table_entry;
f01014e8:	89 03                	mov    %eax,(%ebx)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f01014ea:	8b 00                	mov    (%eax),%eax
f01014ec:	c1 e8 0c             	shr    $0xc,%eax
f01014ef:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f01014f5:	72 1c                	jb     f0101513 <page_lookup+0x5c>
		panic("pa2page called with invalid pa");
f01014f7:	c7 44 24 08 88 5f 10 	movl   $0xf0105f88,0x8(%esp)
f01014fe:	f0 
f01014ff:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
f0101506:	00 
f0101507:	c7 04 24 7e 5c 10 f0 	movl   $0xf0105c7e,(%esp)
f010150e:	e8 72 eb ff ff       	call   f0100085 <_panic>
	return &pages[PPN(pa)];
f0101513:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0101516:	c1 e0 02             	shl    $0x2,%eax
f0101519:	03 05 2c 8a 3c f0    	add    0xf03c8a2c,%eax
	}
	
	p = pa2page(*table_entry);	
	return p;
f010151f:	eb 05                	jmp    f0101526 <page_lookup+0x6f>
f0101521:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101526:	83 c4 14             	add    $0x14,%esp
f0101529:	5b                   	pop    %ebx
f010152a:	5d                   	pop    %ebp
f010152b:	c3                   	ret    

f010152c <boot_map_segment>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm)
{
f010152c:	55                   	push   %ebp
f010152d:	89 e5                	mov    %esp,%ebp
f010152f:	57                   	push   %edi
f0101530:	56                   	push   %esi
f0101531:	53                   	push   %ebx
f0101532:	83 ec 2c             	sub    $0x2c,%esp
f0101535:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0101538:	89 d3                	mov    %edx,%ebx
f010153a:	8b 7d 08             	mov    0x8(%ebp),%edi
	// Fill this function in
	// Code added by Swastika / Sandeep
	int n = size / PGSIZE;			// no. of page frames to be mapped
f010153d:	c1 e9 0c             	shr    $0xc,%ecx
f0101540:	89 4d e0             	mov    %ecx,-0x20(%ebp)
	int i;
	pte_t * table_entry;
	
	for (i = 0; i<n; i++)
f0101543:	85 c9                	test   %ecx,%ecx
f0101545:	7e 46                	jle    f010158d <boot_map_segment+0x61>
f0101547:	be 00 00 00 00       	mov    $0x0,%esi
	{	
		table_entry = pgdir_walk(pgdir,(const void *) (la + (i*PGSIZE)), 1);
		*table_entry = PTE_ADDR(pa + (i*PGSIZE));
		*table_entry = *table_entry | (perm | PTE_P);
f010154c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010154f:	83 c8 01             	or     $0x1,%eax
f0101552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int i;
	pte_t * table_entry;
	
	for (i = 0; i<n; i++)
	{	
		table_entry = pgdir_walk(pgdir,(const void *) (la + (i*PGSIZE)), 1);
f0101555:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010155c:	00 
f010155d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101561:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101564:	89 04 24             	mov    %eax,(%esp)
f0101567:	e8 1d fe ff ff       	call   f0101389 <pgdir_walk>
		*table_entry = PTE_ADDR(pa + (i*PGSIZE));
		*table_entry = *table_entry | (perm | PTE_P);
f010156c:	89 fa                	mov    %edi,%edx
f010156e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101574:	0b 55 e4             	or     -0x1c(%ebp),%edx
f0101577:	89 10                	mov    %edx,(%eax)
	// Code added by Swastika / Sandeep
	int n = size / PGSIZE;			// no. of page frames to be mapped
	int i;
	pte_t * table_entry;
	
	for (i = 0; i<n; i++)
f0101579:	83 c6 01             	add    $0x1,%esi
f010157c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101582:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0101588:	39 75 e0             	cmp    %esi,-0x20(%ebp)
f010158b:	7f c8                	jg     f0101555 <boot_map_segment+0x29>
		#ifdef HIGHMEM
			// we might have mapped a page table in the high memory, unmap it 
			kunmap_high((void*)PTE_ADDR(table_entry));
		#endif
	}	
}
f010158d:	83 c4 2c             	add    $0x2c,%esp
f0101590:	5b                   	pop    %ebx
f0101591:	5e                   	pop    %esi
f0101592:	5f                   	pop    %edi
f0101593:	5d                   	pop    %ebp
f0101594:	c3                   	ret    

f0101595 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0101595:	55                   	push   %ebp
f0101596:	89 e5                	mov    %esp,%ebp
f0101598:	83 ec 38             	sub    $0x38,%esp
f010159b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f010159e:	89 75 f8             	mov    %esi,-0x8(%ebp)
f01015a1:	89 7d fc             	mov    %edi,-0x4(%ebp)
f01015a4:	8b 7d 08             	mov    0x8(%ebp),%edi
f01015a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// Fill this function in
	// Code added by Swastika / Sandeep
	pte_t * ptep = NULL;
f01015aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	uintptr_t * page;
	struct Page *pp = page_lookup (pgdir, va, &ptep);	// Look-up the page
f01015b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01015b4:	89 44 24 08          	mov    %eax,0x8(%esp)
f01015b8:	89 74 24 04          	mov    %esi,0x4(%esp)
f01015bc:	89 3c 24             	mov    %edi,(%esp)
f01015bf:	e8 f3 fe ff ff       	call   f01014b7 <page_lookup>
f01015c4:	89 c3                	mov    %eax,%ebx
	if (pp == NULL)
f01015c6:	85 c0                	test   %eax,%eax
f01015c8:	74 78                	je     f0101642 <page_remove+0xad>
		return;			// Silently do nothing if no physical page is mapped at va
	
	page_decref (pp);		// Decrement the reference count and free the page if the count reaches 0
f01015ca:	89 04 24             	mov    %eax,(%esp)
f01015cd:	e8 59 f9 ff ff       	call   f0100f2b <page_decref>
	if (pp->pp_ref == 0)
f01015d2:	66 83 7b 08 00       	cmpw   $0x0,0x8(%ebx)
f01015d7:	75 54                	jne    f010162d <page_remove+0x98>
			page = (uintptr_t *) kmap(PTE_ADDR(*ptep));
			// The following won't hurt us even after we ensure kmap never returns a NULL
			if (page < 0)
				return;
		#else
			page = (uintptr_t *) KADDR(PTE_ADDR(*ptep));
f01015d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01015dc:	8b 00                	mov    (%eax),%eax
f01015de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01015e3:	89 c2                	mov    %eax,%edx
f01015e5:	c1 ea 0c             	shr    $0xc,%edx
f01015e8:	3b 15 20 8a 3c f0    	cmp    0xf03c8a20,%edx
f01015ee:	72 20                	jb     f0101610 <page_remove+0x7b>
f01015f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01015f4:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f01015fb:	f0 
f01015fc:	c7 44 24 04 e1 03 00 	movl   $0x3e1,0x4(%esp)
f0101603:	00 
f0101604:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f010160b:	e8 75 ea ff ff       	call   f0100085 <_panic>
		#endif	

		memset (page, 0, PGSIZE);
f0101610:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101617:	00 
f0101618:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010161f:	00 
f0101620:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101625:	89 04 24             	mov    %eax,(%esp)
f0101628:	e8 09 30 00 00       	call   f0104636 <memset>
		// we have used "page"; unmap it 
		#ifdef HIGHMEM
			kunmap_high(page);
		#endif
	}
	*ptep = 0x0;				// clear the page table entry
f010162d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	tlb_invalidate (pgdir, va);		// still confused !!! 
f0101636:	89 74 24 04          	mov    %esi,0x4(%esp)
f010163a:	89 3c 24             	mov    %edi,(%esp)
f010163d:	e8 0c f9 ff ff       	call   f0100f4e <tlb_invalidate>
	#ifdef HIGHMEM
		kunmap_high((void*)ptep);
	#endif
}
f0101642:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0101645:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0101648:	8b 7d fc             	mov    -0x4(%ebp),%edi
f010164b:	89 ec                	mov    %ebp,%esp
f010164d:	5d                   	pop    %ebp
f010164e:	c3                   	ret    

f010164f <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct Page *pp, void *va, int perm) 
{
f010164f:	55                   	push   %ebp
f0101650:	89 e5                	mov    %esp,%ebp
f0101652:	83 ec 28             	sub    $0x28,%esp
f0101655:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0101658:	89 75 f8             	mov    %esi,-0x8(%ebp)
f010165b:	89 7d fc             	mov    %edi,-0x4(%ebp)
f010165e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// Fill this function in
	// Code added by Sandeep / Swastika
	// pte_t * table_entry = pgdir_walk (pgdir, va, 0);
	pte_t * table_entry = pgdir_walk (pgdir, va, 1);
f0101661:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0101668:	00 
f0101669:	8b 45 10             	mov    0x10(%ebp),%eax
f010166c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101670:	8b 45 08             	mov    0x8(%ebp),%eax
f0101673:	89 04 24             	mov    %eax,(%esp)
f0101676:	e8 0e fd ff ff       	call   f0101389 <pgdir_walk>
f010167b:	89 c3                	mov    %eax,%ebx
		if (table_entry == NULL)
			return -E_NO_MEM;

	}*/

	if (table_entry == NULL)
f010167d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101682:	85 db                	test   %ebx,%ebx
f0101684:	0f 84 9a 00 00 00    	je     f0101724 <page_insert+0xd5>
		return -E_NO_MEM;
	else					// page table exists 
	{	
		// check the corner-case: same pp is re-inserted
		if (PTE_ADDR(*table_entry)  == PTE_ADDR(page2pa(pp)))
f010168a:	8b 03                	mov    (%ebx),%eax


static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f010168c:	89 f7                	mov    %esi,%edi
f010168e:	89 f2                	mov    %esi,%edx
f0101690:	2b 15 2c 8a 3c f0    	sub    0xf03c8a2c,%edx
f0101696:	c1 fa 02             	sar    $0x2,%edx
f0101699:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f010169f:	c1 e2 0c             	shl    $0xc,%edx
f01016a2:	31 c2                	xor    %eax,%edx
f01016a4:	f7 c2 00 f0 ff ff    	test   $0xfffff000,%edx
f01016aa:	75 2a                	jne    f01016d6 <page_insert+0x87>
		{
			tlb_invalidate(pgdir, va);
f01016ac:	8b 45 10             	mov    0x10(%ebp),%eax
f01016af:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016b3:	8b 45 08             	mov    0x8(%ebp),%eax
f01016b6:	89 04 24             	mov    %eax,(%esp)
f01016b9:	e8 90 f8 ff ff       	call   f0100f4e <tlb_invalidate>
			*table_entry = (*table_entry & ~0xfff) | (perm | PTE_P); 	// ((perm | PTE_P) & 0xFFF);	
f01016be:	8b 55 14             	mov    0x14(%ebp),%edx
f01016c1:	83 ca 01             	or     $0x1,%edx
f01016c4:	8b 03                	mov    (%ebx),%eax
f01016c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01016cb:	09 d0                	or     %edx,%eax
f01016cd:	89 03                	mov    %eax,(%ebx)
f01016cf:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
f01016d4:	eb 4e                	jmp    f0101724 <page_insert+0xd5>
		}		
		if (((*table_entry) & PTE_P) == PTE_P)
f01016d6:	a8 01                	test   $0x1,%al
f01016d8:	74 24                	je     f01016fe <page_insert+0xaf>
		{
			// remove the existing physical page using page_remove()
			//cprintf("[page_insert] address already allocated\n");
			page_remove(pgdir, va);		
f01016da:	8b 45 10             	mov    0x10(%ebp),%eax
f01016dd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01016e4:	89 04 24             	mov    %eax,(%esp)
f01016e7:	e8 a9 fe ff ff       	call   f0101595 <page_remove>
			// invalidate the TLB
			tlb_invalidate (pgdir, va);
f01016ec:	8b 45 10             	mov    0x10(%ebp),%eax
f01016ef:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016f3:	8b 45 08             	mov    0x8(%ebp),%eax
f01016f6:	89 04 24             	mov    %eax,(%esp)
f01016f9:	e8 50 f8 ff ff       	call   f0100f4e <tlb_invalidate>
		}
	}
	// set the page table entry to point to this physical page pp
	*table_entry = PTE_ADDR(page2pa(pp));
	*table_entry = *table_entry | (perm | PTE_P); 	// ((perm | PTE_P) & 0xFFF);	
f01016fe:	8b 45 14             	mov    0x14(%ebp),%eax
f0101701:	83 c8 01             	or     $0x1,%eax
f0101704:	2b 3d 2c 8a 3c f0    	sub    0xf03c8a2c,%edi
f010170a:	c1 ff 02             	sar    $0x2,%edi
f010170d:	69 ff ab aa aa aa    	imul   $0xaaaaaaab,%edi,%edi
f0101713:	c1 e7 0c             	shl    $0xc,%edi
f0101716:	09 c7                	or     %eax,%edi
f0101718:	89 3b                	mov    %edi,(%ebx)

	// cprintf("page insert pp=%08x\n", pp);
	// insertion successful ; increment pp_ref
	pp->pp_ref++;
f010171a:	66 83 46 08 01       	addw   $0x1,0x8(%esi)
f010171f:	b8 00 00 00 00       	mov    $0x0,%eax
	#endif


	return 0;

}
f0101724:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0101727:	8b 75 f8             	mov    -0x8(%ebp),%esi
f010172a:	8b 7d fc             	mov    -0x4(%ebp),%edi
f010172d:	89 ec                	mov    %ebp,%esp
f010172f:	5d                   	pop    %ebp
f0101730:	c3                   	ret    

f0101731 <nvram_read>:
	sizeof(gdt) - 1, (unsigned long) gdt
};

static int
nvram_read(int r)
{
f0101731:	55                   	push   %ebp
f0101732:	89 e5                	mov    %esp,%ebp
f0101734:	83 ec 18             	sub    $0x18,%esp
f0101737:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f010173a:	89 75 fc             	mov    %esi,-0x4(%ebp)
f010173d:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f010173f:	89 04 24             	mov    %eax,(%esp)
f0101742:	e8 65 10 00 00       	call   f01027ac <mc146818_read>
f0101747:	89 c6                	mov    %eax,%esi
f0101749:	83 c3 01             	add    $0x1,%ebx
f010174c:	89 1c 24             	mov    %ebx,(%esp)
f010174f:	e8 58 10 00 00       	call   f01027ac <mc146818_read>
f0101754:	c1 e0 08             	shl    $0x8,%eax
f0101757:	09 f0                	or     %esi,%eax
}
f0101759:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f010175c:	8b 75 fc             	mov    -0x4(%ebp),%esi
f010175f:	89 ec                	mov    %ebp,%esp
f0101761:	5d                   	pop    %ebp
f0101762:	c3                   	ret    

f0101763 <i386_detect_memory>:

void
i386_detect_memory(void)
{
f0101763:	55                   	push   %ebp
f0101764:	89 e5                	mov    %esp,%ebp
f0101766:	83 ec 18             	sub    $0x18,%esp
	// CMOS tells us how many kilobytes there are
	basemem = ROUNDDOWN(nvram_read(NVRAM_BASELO)*1024, PGSIZE);
f0101769:	b8 15 00 00 00       	mov    $0x15,%eax
f010176e:	e8 be ff ff ff       	call   f0101731 <nvram_read>
f0101773:	c1 e0 0a             	shl    $0xa,%eax
f0101776:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010177b:	a3 4c 35 3c f0       	mov    %eax,0xf03c354c
	extmem = ROUNDDOWN(nvram_read(NVRAM_EXTLO)*1024, PGSIZE);
f0101780:	b8 17 00 00 00       	mov    $0x17,%eax
f0101785:	e8 a7 ff ff ff       	call   f0101731 <nvram_read>
f010178a:	c1 e0 0a             	shl    $0xa,%eax
f010178d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101792:	a3 50 35 3c f0       	mov    %eax,0xf03c3550

	// Calculate the maximum physical address based on whether
	// or not there is any extended memory.  See comment in <inc/mmu.h>.
	if (extmem)
f0101797:	85 c0                	test   %eax,%eax
f0101799:	74 18                	je     f01017b3 <i386_detect_memory+0x50>
	{
		extmem += 0x40000000 - EXTPHYSMEM;	// hack: change extmem forcibly
f010179b:	8d 90 00 00 f0 3f    	lea    0x3ff00000(%eax),%edx
f01017a1:	89 15 50 35 3c f0    	mov    %edx,0xf03c3550
		maxpa = EXTPHYSMEM + extmem;
f01017a7:	05 00 00 00 40       	add    $0x40000000,%eax
f01017ac:	a3 48 35 3c f0       	mov    %eax,0xf03c3548
f01017b1:	eb 0a                	jmp    f01017bd <i386_detect_memory+0x5a>
	}
	else
		maxpa = basemem;
f01017b3:	a1 4c 35 3c f0       	mov    0xf03c354c,%eax
f01017b8:	a3 48 35 3c f0       	mov    %eax,0xf03c3548

	npage = maxpa / PGSIZE;
f01017bd:	a1 48 35 3c f0       	mov    0xf03c3548,%eax
f01017c2:	89 c2                	mov    %eax,%edx
f01017c4:	c1 ea 0c             	shr    $0xc,%edx
f01017c7:	89 15 20 8a 3c f0    	mov    %edx,0xf03c8a20

	cprintf("Physical memory: %dK available, ", (int)(maxpa/1024));
f01017cd:	c1 e8 0a             	shr    $0xa,%eax
f01017d0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01017d4:	c7 04 24 d4 61 10 f0 	movl   $0xf01061d4,(%esp)
f01017db:	e8 87 11 00 00       	call   f0102967 <cprintf>
	cprintf("base = %dK, extended = %dK\n", (int)(basemem/1024), (int)(extmem/1024));
f01017e0:	a1 50 35 3c f0       	mov    0xf03c3550,%eax
f01017e5:	c1 e8 0a             	shr    $0xa,%eax
f01017e8:	89 44 24 08          	mov    %eax,0x8(%esp)
f01017ec:	a1 4c 35 3c f0       	mov    0xf03c354c,%eax
f01017f1:	c1 e8 0a             	shr    $0xa,%eax
f01017f4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01017f8:	c7 04 24 de 62 10 f0 	movl   $0xf01062de,(%esp)
f01017ff:	e8 63 11 00 00       	call   f0102967 <cprintf>
	cprintf("maxpa = %x, Pages available : %d ", maxpa, (int)(npage));
f0101804:	a1 20 8a 3c f0       	mov    0xf03c8a20,%eax
f0101809:	89 44 24 08          	mov    %eax,0x8(%esp)
f010180d:	a1 48 35 3c f0       	mov    0xf03c3548,%eax
f0101812:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101816:	c7 04 24 f8 61 10 f0 	movl   $0xf01061f8,(%esp)
f010181d:	e8 45 11 00 00       	call   f0102967 <cprintf>
}
f0101822:	c9                   	leave  
f0101823:	c3                   	ret    

f0101824 <i386_vm_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read (or write). 
void
i386_vm_init(void)
{
f0101824:	55                   	push   %ebp
f0101825:	89 e5                	mov    %esp,%ebp
f0101827:	57                   	push   %edi
f0101828:	56                   	push   %esi
f0101829:	53                   	push   %ebx
f010182a:	83 ec 3c             	sub    $0x3c,%esp
	// Delete this line:
	// panic("i386_vm_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	pgdir = boot_alloc(PGSIZE, PGSIZE);
f010182d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101832:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101837:	e8 29 fa ff ff       	call   f0101265 <boot_alloc>
f010183c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	memset(pgdir, 0, PGSIZE);
f010183f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101846:	00 
f0101847:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010184e:	00 
f010184f:	89 04 24             	mov    %eax,(%esp)
f0101852:	e8 df 2d 00 00       	call   f0104636 <memset>
	boot_pgdir = pgdir;
f0101857:	8b 45 cc             	mov    -0x34(%ebp),%eax
f010185a:	a3 28 8a 3c f0       	mov    %eax,0xf03c8a28
	boot_cr3 = PADDR(pgdir);
f010185f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101864:	77 20                	ja     f0101886 <i386_vm_init+0x62>
f0101866:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010186a:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0101871:	f0 
f0101872:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
f0101879:	00 
f010187a:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101881:	e8 ff e7 ff ff       	call   f0100085 <_panic>
f0101886:	05 00 00 00 10       	add    $0x10000000,%eax
f010188b:	a3 24 8a 3c f0       	mov    %eax,0xf03c8a24
	// a virtual page table at virtual address VPT.
	// (For now, you don't have understand the greater purpose of the
	// following two lines.)

	// Permissions: kernel RW, user NONE
	pgdir[PDX(VPT)] = PADDR(pgdir)|PTE_W|PTE_P;
f0101890:	89 c2                	mov    %eax,%edx
f0101892:	83 ca 03             	or     $0x3,%edx
f0101895:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101898:	89 91 fc 0e 00 00    	mov    %edx,0xefc(%ecx)

	// same for UVPT
	// Permissions: kernel R, user R 
	pgdir[PDX(UVPT)] = PADDR(pgdir)|PTE_U|PTE_P;
f010189e:	83 c8 05             	or     $0x5,%eax
f01018a1:	89 81 f4 0e 00 00    	mov    %eax,0xef4(%ecx)
	// User-level programs will get read-only access to the array as well.
	// Your code goes here:
	

	// Code added by Sandeep / Swastika
	pages = (struct Page*) boot_alloc (npage*sizeof(struct Page), PGSIZE);
f01018a7:	a1 20 8a 3c f0       	mov    0xf03c8a20,%eax
f01018ac:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01018af:	c1 e0 02             	shl    $0x2,%eax
f01018b2:	ba 00 10 00 00       	mov    $0x1000,%edx
f01018b7:	e8 a9 f9 ff ff       	call   f0101265 <boot_alloc>
f01018bc:	a3 2c 8a 3c f0       	mov    %eax,0xf03c8a2c
	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	
	// Code added by Swastika / Sandeep
	envs = (struct Env*) boot_alloc (NENV*sizeof(struct Env), PGSIZE); 
f01018c1:	ba 00 10 00 00       	mov    $0x1000,%edx
f01018c6:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01018cb:	e8 95 f9 ff ff       	call   f0101265 <boot_alloc>
f01018d0:	a3 60 35 3c f0       	mov    %eax,0xf03c3560
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_segment or page_insert
	
	page_init();
f01018d5:	e8 ef f7 ff ff       	call   f01010c9 <page_init>

	// if there's a page that shouldn't be on
	// the free list, try to make sure it
	// eventually causes trouble.
	int i = 0;
	LIST_FOREACH(pp0, &page_free_list, pp_link)
f01018da:	a1 58 35 3c f0       	mov    0xf03c3558,%eax
f01018df:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01018e2:	85 c0                	test   %eax,%eax
f01018e4:	0f 84 89 00 00 00    	je     f0101973 <i386_vm_init+0x14f>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f01018ea:	2b 05 2c 8a 3c f0    	sub    0xf03c8a2c,%eax
f01018f0:	c1 f8 02             	sar    $0x2,%eax
f01018f3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f01018f9:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f01018fc:	89 c2                	mov    %eax,%edx
f01018fe:	c1 ea 0c             	shr    $0xc,%edx
f0101901:	3b 15 20 8a 3c f0    	cmp    0xf03c8a20,%edx
f0101907:	72 41                	jb     f010194a <i386_vm_init+0x126>
f0101909:	eb 1f                	jmp    f010192a <i386_vm_init+0x106>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f010190b:	2b 05 2c 8a 3c f0    	sub    0xf03c8a2c,%eax
f0101911:	c1 f8 02             	sar    $0x2,%eax
f0101914:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f010191a:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f010191d:	89 c2                	mov    %eax,%edx
f010191f:	c1 ea 0c             	shr    $0xc,%edx
f0101922:	3b 15 20 8a 3c f0    	cmp    0xf03c8a20,%edx
f0101928:	72 20                	jb     f010194a <i386_vm_init+0x126>
f010192a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010192e:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f0101935:	f0 
f0101936:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
f010193d:	00 
f010193e:	c7 04 24 7e 5c 10 f0 	movl   $0xf0105c7e,(%esp)
f0101945:	e8 3b e7 ff ff       	call   f0100085 <_panic>
	{
		memset(page2kva(pp0), 0x97, 128);
f010194a:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f0101951:	00 
f0101952:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0101959:	00 
f010195a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010195f:	89 04 24             	mov    %eax,(%esp)
f0101962:	e8 cf 2c 00 00       	call   f0104636 <memset>

	// if there's a page that shouldn't be on
	// the free list, try to make sure it
	// eventually causes trouble.
	int i = 0;
	LIST_FOREACH(pp0, &page_free_list, pp_link)
f0101967:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010196a:	8b 00                	mov    (%eax),%eax
f010196c:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010196f:	85 c0                	test   %eax,%eax
f0101971:	75 98                	jne    f010190b <i386_vm_init+0xe7>
	{
		memset(page2kva(pp0), 0x97, 128);
	}

	LIST_FOREACH(pp0, &page_free_list, pp_link) {
f0101973:	a1 58 35 3c f0       	mov    0xf03c3558,%eax
f0101978:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010197b:	85 c0                	test   %eax,%eax
f010197d:	0f 84 e7 01 00 00    	je     f0101b6a <i386_vm_init+0x346>
		// check that we didn't corrupt the free list itself
		assert(pp0 >= pages);
f0101983:	8b 1d 2c 8a 3c f0    	mov    0xf03c8a2c,%ebx
f0101989:	39 c3                	cmp    %eax,%ebx
f010198b:	77 5d                	ja     f01019ea <i386_vm_init+0x1c6>
		assert(pp0 < pages + npage);
f010198d:	8b 35 20 8a 3c f0    	mov    0xf03c8a20,%esi
f0101993:	8d 14 76             	lea    (%esi,%esi,2),%edx
f0101996:	8d 3c 93             	lea    (%ebx,%edx,4),%edi
f0101999:	39 f8                	cmp    %edi,%eax
f010199b:	73 75                	jae    f0101a12 <i386_vm_init+0x1ee>


static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f010199d:	89 5d d0             	mov    %ebx,-0x30(%ebp)
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f01019a0:	89 c2                	mov    %eax,%edx
f01019a2:	29 da                	sub    %ebx,%edx
f01019a4:	c1 fa 02             	sar    $0x2,%edx
f01019a7:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f01019ad:	c1 e2 0c             	shl    $0xc,%edx

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp0) != 0);
f01019b0:	85 d2                	test   %edx,%edx
f01019b2:	0f 84 93 00 00 00    	je     f0101a4b <i386_vm_init+0x227>
		assert(page2pa(pp0) != IOPHYSMEM);
f01019b8:	81 fa 00 00 0a 00    	cmp    $0xa0000,%edx
f01019be:	0f 84 b3 00 00 00    	je     f0101a77 <i386_vm_init+0x253>
		assert(page2pa(pp0) != EXTPHYSMEM - PGSIZE);
f01019c4:	81 fa 00 f0 0f 00    	cmp    $0xff000,%edx
f01019ca:	0f 84 d3 00 00 00    	je     f0101aa3 <i386_vm_init+0x27f>
		assert(page2pa(pp0) != EXTPHYSMEM);
f01019d0:	81 fa 00 00 10 00    	cmp    $0x100000,%edx
f01019d6:	0f 85 17 01 00 00    	jne    f0101af3 <i386_vm_init+0x2cf>
f01019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01019e0:	e9 ea 00 00 00       	jmp    f0101acf <i386_vm_init+0x2ab>
		memset(page2kva(pp0), 0x97, 128);
	}

	LIST_FOREACH(pp0, &page_free_list, pp_link) {
		// check that we didn't corrupt the free list itself
		assert(pp0 >= pages);
f01019e5:	39 c3                	cmp    %eax,%ebx
f01019e7:	90                   	nop
f01019e8:	76 24                	jbe    f0101a0e <i386_vm_init+0x1ea>
f01019ea:	c7 44 24 0c fa 62 10 	movl   $0xf01062fa,0xc(%esp)
f01019f1:	f0 
f01019f2:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f01019f9:	f0 
f01019fa:	c7 44 24 04 98 01 00 	movl   $0x198,0x4(%esp)
f0101a01:	00 
f0101a02:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101a09:	e8 77 e6 ff ff       	call   f0100085 <_panic>
		assert(pp0 < pages + npage);
f0101a0e:	39 f8                	cmp    %edi,%eax
f0101a10:	72 24                	jb     f0101a36 <i386_vm_init+0x212>
f0101a12:	c7 44 24 0c 1c 63 10 	movl   $0xf010631c,0xc(%esp)
f0101a19:	f0 
f0101a1a:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101a21:	f0 
f0101a22:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
f0101a29:	00 
f0101a2a:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101a31:	e8 4f e6 ff ff       	call   f0100085 <_panic>
f0101a36:	89 c2                	mov    %eax,%edx
f0101a38:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101a3b:	c1 fa 02             	sar    $0x2,%edx
f0101a3e:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0101a44:	c1 e2 0c             	shl    $0xc,%edx

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp0) != 0);
f0101a47:	85 d2                	test   %edx,%edx
f0101a49:	75 24                	jne    f0101a6f <i386_vm_init+0x24b>
f0101a4b:	c7 44 24 0c 30 63 10 	movl   $0xf0106330,0xc(%esp)
f0101a52:	f0 
f0101a53:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101a5a:	f0 
f0101a5b:	c7 44 24 04 9c 01 00 	movl   $0x19c,0x4(%esp)
f0101a62:	00 
f0101a63:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101a6a:	e8 16 e6 ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp0) != IOPHYSMEM);
f0101a6f:	81 fa 00 00 0a 00    	cmp    $0xa0000,%edx
f0101a75:	75 24                	jne    f0101a9b <i386_vm_init+0x277>
f0101a77:	c7 44 24 0c 42 63 10 	movl   $0xf0106342,0xc(%esp)
f0101a7e:	f0 
f0101a7f:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101a86:	f0 
f0101a87:	c7 44 24 04 9d 01 00 	movl   $0x19d,0x4(%esp)
f0101a8e:	00 
f0101a8f:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101a96:	e8 ea e5 ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp0) != EXTPHYSMEM - PGSIZE);
f0101a9b:	81 fa 00 f0 0f 00    	cmp    $0xff000,%edx
f0101aa1:	75 24                	jne    f0101ac7 <i386_vm_init+0x2a3>
f0101aa3:	c7 44 24 0c 1c 62 10 	movl   $0xf010621c,0xc(%esp)
f0101aaa:	f0 
f0101aab:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101ab2:	f0 
f0101ab3:	c7 44 24 04 9e 01 00 	movl   $0x19e,0x4(%esp)
f0101aba:	00 
f0101abb:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101ac2:	e8 be e5 ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp0) != EXTPHYSMEM);
f0101ac7:	81 fa 00 00 10 00    	cmp    $0x100000,%edx
f0101acd:	75 36                	jne    f0101b05 <i386_vm_init+0x2e1>
f0101acf:	c7 44 24 0c 5c 63 10 	movl   $0xf010635c,0xc(%esp)
f0101ad6:	f0 
f0101ad7:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101ade:	f0 
f0101adf:	c7 44 24 04 9f 01 00 	movl   $0x19f,0x4(%esp)
f0101ae6:	00 
f0101ae7:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101aee:	e8 92 e5 ff ff       	call   f0100085 <_panic>
		assert(page2kva(pp0) != ROUNDDOWN(boot_freemem - 1, PGSIZE));
f0101af3:	8b 0d 54 35 3c f0    	mov    0xf03c3554,%ecx
f0101af9:	83 e9 01             	sub    $0x1,%ecx
f0101afc:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0101b02:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0101b05:	89 d1                	mov    %edx,%ecx
f0101b07:	c1 e9 0c             	shr    $0xc,%ecx
f0101b0a:	39 ce                	cmp    %ecx,%esi
f0101b0c:	77 20                	ja     f0101b2e <i386_vm_init+0x30a>
f0101b0e:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0101b12:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f0101b19:	f0 
f0101b1a:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
f0101b21:	00 
f0101b22:	c7 04 24 7e 5c 10 f0 	movl   $0xf0105c7e,(%esp)
f0101b29:	e8 57 e5 ff ff       	call   f0100085 <_panic>
f0101b2e:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0101b34:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f0101b37:	75 24                	jne    f0101b5d <i386_vm_init+0x339>
f0101b39:	c7 44 24 0c 40 62 10 	movl   $0xf0106240,0xc(%esp)
f0101b40:	f0 
f0101b41:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101b48:	f0 
f0101b49:	c7 44 24 04 a0 01 00 	movl   $0x1a0,0x4(%esp)
f0101b50:	00 
f0101b51:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101b58:	e8 28 e5 ff ff       	call   f0100085 <_panic>
	LIST_FOREACH(pp0, &page_free_list, pp_link)
	{
		memset(page2kva(pp0), 0x97, 128);
	}

	LIST_FOREACH(pp0, &page_free_list, pp_link) {
f0101b5d:	8b 00                	mov    (%eax),%eax
f0101b5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101b62:	85 c0                	test   %eax,%eax
f0101b64:	0f 85 7b fe ff ff    	jne    f01019e5 <i386_vm_init+0x1c1>
		assert(page2pa(pp0) != EXTPHYSMEM);
		assert(page2kva(pp0) != ROUNDDOWN(boot_freemem - 1, PGSIZE));
	}

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0101b6a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0101b71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0101b78:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	assert(page_alloc(&pp0) == 0);
f0101b7f:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0101b82:	89 04 24             	mov    %eax,(%esp)
f0101b85:	e8 a0 f7 ff ff       	call   f010132a <page_alloc>
f0101b8a:	85 c0                	test   %eax,%eax
f0101b8c:	74 24                	je     f0101bb2 <i386_vm_init+0x38e>
f0101b8e:	c7 44 24 0c 77 63 10 	movl   $0xf0106377,0xc(%esp)
f0101b95:	f0 
f0101b96:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101b9d:	f0 
f0101b9e:	c7 44 24 04 a5 01 00 	movl   $0x1a5,0x4(%esp)
f0101ba5:	00 
f0101ba6:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101bad:	e8 d3 e4 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp1) == 0);
f0101bb2:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0101bb5:	89 04 24             	mov    %eax,(%esp)
f0101bb8:	e8 6d f7 ff ff       	call   f010132a <page_alloc>
f0101bbd:	85 c0                	test   %eax,%eax
f0101bbf:	74 24                	je     f0101be5 <i386_vm_init+0x3c1>
f0101bc1:	c7 44 24 0c 8d 63 10 	movl   $0xf010638d,0xc(%esp)
f0101bc8:	f0 
f0101bc9:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101bd0:	f0 
f0101bd1:	c7 44 24 04 a6 01 00 	movl   $0x1a6,0x4(%esp)
f0101bd8:	00 
f0101bd9:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101be0:	e8 a0 e4 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp2) == 0);
f0101be5:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0101be8:	89 04 24             	mov    %eax,(%esp)
f0101beb:	e8 3a f7 ff ff       	call   f010132a <page_alloc>
f0101bf0:	85 c0                	test   %eax,%eax
f0101bf2:	74 24                	je     f0101c18 <i386_vm_init+0x3f4>
f0101bf4:	c7 44 24 0c a3 63 10 	movl   $0xf01063a3,0xc(%esp)
f0101bfb:	f0 
f0101bfc:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101c03:	f0 
f0101c04:	c7 44 24 04 a7 01 00 	movl   $0x1a7,0x4(%esp)
f0101c0b:	00 
f0101c0c:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101c13:	e8 6d e4 ff ff       	call   f0100085 <_panic>

	assert(pp0);
f0101c18:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101c1b:	85 d2                	test   %edx,%edx
f0101c1d:	75 24                	jne    f0101c43 <i386_vm_init+0x41f>
f0101c1f:	c7 44 24 0c c7 63 10 	movl   $0xf01063c7,0xc(%esp)
f0101c26:	f0 
f0101c27:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101c2e:	f0 
f0101c2f:	c7 44 24 04 a9 01 00 	movl   $0x1a9,0x4(%esp)
f0101c36:	00 
f0101c37:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101c3e:	e8 42 e4 ff ff       	call   f0100085 <_panic>
	assert(pp1 && pp1 != pp0);
f0101c43:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101c46:	85 c0                	test   %eax,%eax
f0101c48:	74 04                	je     f0101c4e <i386_vm_init+0x42a>
f0101c4a:	39 c2                	cmp    %eax,%edx
f0101c4c:	75 24                	jne    f0101c72 <i386_vm_init+0x44e>
f0101c4e:	c7 44 24 0c b9 63 10 	movl   $0xf01063b9,0xc(%esp)
f0101c55:	f0 
f0101c56:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101c5d:	f0 
f0101c5e:	c7 44 24 04 aa 01 00 	movl   $0x1aa,0x4(%esp)
f0101c65:	00 
f0101c66:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101c6d:	e8 13 e4 ff ff       	call   f0100085 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c72:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0101c75:	85 c9                	test   %ecx,%ecx
f0101c77:	74 09                	je     f0101c82 <i386_vm_init+0x45e>
f0101c79:	39 c8                	cmp    %ecx,%eax
f0101c7b:	74 05                	je     f0101c82 <i386_vm_init+0x45e>
f0101c7d:	39 ca                	cmp    %ecx,%edx
f0101c7f:	90                   	nop
f0101c80:	75 24                	jne    f0101ca6 <i386_vm_init+0x482>
f0101c82:	c7 44 24 0c 78 62 10 	movl   $0xf0106278,0xc(%esp)
f0101c89:	f0 
f0101c8a:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101c91:	f0 
f0101c92:	c7 44 24 04 ab 01 00 	movl   $0x1ab,0x4(%esp)
f0101c99:	00 
f0101c9a:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101ca1:	e8 df e3 ff ff       	call   f0100085 <_panic>


static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101ca6:	8b 35 2c 8a 3c f0    	mov    0xf03c8a2c,%esi
	assert(page2pa(pp0) < npage*PGSIZE);
f0101cac:	8b 1d 20 8a 3c f0    	mov    0xf03c8a20,%ebx
f0101cb2:	c1 e3 0c             	shl    $0xc,%ebx
f0101cb5:	29 f2                	sub    %esi,%edx
f0101cb7:	c1 fa 02             	sar    $0x2,%edx
f0101cba:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0101cc0:	c1 e2 0c             	shl    $0xc,%edx
f0101cc3:	39 da                	cmp    %ebx,%edx
f0101cc5:	72 24                	jb     f0101ceb <i386_vm_init+0x4c7>
f0101cc7:	c7 44 24 0c cb 63 10 	movl   $0xf01063cb,0xc(%esp)
f0101cce:	f0 
f0101ccf:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101cd6:	f0 
f0101cd7:	c7 44 24 04 ac 01 00 	movl   $0x1ac,0x4(%esp)
f0101cde:	00 
f0101cdf:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101ce6:	e8 9a e3 ff ff       	call   f0100085 <_panic>
	assert(page2pa(pp1) < npage*PGSIZE);
f0101ceb:	29 f0                	sub    %esi,%eax
f0101ced:	c1 f8 02             	sar    $0x2,%eax
f0101cf0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0101cf6:	c1 e0 0c             	shl    $0xc,%eax
f0101cf9:	39 c3                	cmp    %eax,%ebx
f0101cfb:	77 24                	ja     f0101d21 <i386_vm_init+0x4fd>
f0101cfd:	c7 44 24 0c e7 63 10 	movl   $0xf01063e7,0xc(%esp)
f0101d04:	f0 
f0101d05:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101d0c:	f0 
f0101d0d:	c7 44 24 04 ad 01 00 	movl   $0x1ad,0x4(%esp)
f0101d14:	00 
f0101d15:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101d1c:	e8 64 e3 ff ff       	call   f0100085 <_panic>
	assert(page2pa(pp2) < npage*PGSIZE);
f0101d21:	29 f1                	sub    %esi,%ecx
f0101d23:	c1 f9 02             	sar    $0x2,%ecx
f0101d26:	69 c1 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%eax
f0101d2c:	c1 e0 0c             	shl    $0xc,%eax
f0101d2f:	39 c3                	cmp    %eax,%ebx
f0101d31:	77 24                	ja     f0101d57 <i386_vm_init+0x533>
f0101d33:	c7 44 24 0c 03 64 10 	movl   $0xf0106403,0xc(%esp)
f0101d3a:	f0 
f0101d3b:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101d42:	f0 
f0101d43:	c7 44 24 04 ae 01 00 	movl   $0x1ae,0x4(%esp)
f0101d4a:	00 
f0101d4b:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101d52:	e8 2e e3 ff ff       	call   f0100085 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101d57:	8b 1d 58 35 3c f0    	mov    0xf03c3558,%ebx
	LIST_INIT(&page_free_list);
f0101d5d:	c7 05 58 35 3c f0 00 	movl   $0x0,0xf03c3558
f0101d64:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101d67:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101d6a:	89 04 24             	mov    %eax,(%esp)
f0101d6d:	e8 b8 f5 ff ff       	call   f010132a <page_alloc>
f0101d72:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101d75:	74 24                	je     f0101d9b <i386_vm_init+0x577>
f0101d77:	c7 44 24 0c 1f 64 10 	movl   $0xf010641f,0xc(%esp)
f0101d7e:	f0 
f0101d7f:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101d86:	f0 
f0101d87:	c7 44 24 04 b5 01 00 	movl   $0x1b5,0x4(%esp)
f0101d8e:	00 
f0101d8f:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101d96:	e8 ea e2 ff ff       	call   f0100085 <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101d9e:	89 04 24             	mov    %eax,(%esp)
f0101da1:	e8 4d f1 ff ff       	call   f0100ef3 <page_free>
	page_free(pp1);
f0101da6:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101da9:	89 04 24             	mov    %eax,(%esp)
f0101dac:	e8 42 f1 ff ff       	call   f0100ef3 <page_free>
	page_free(pp2);
f0101db1:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101db4:	89 04 24             	mov    %eax,(%esp)
f0101db7:	e8 37 f1 ff ff       	call   f0100ef3 <page_free>
	pp0 = pp1 = pp2 = 0;
f0101dbc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0101dc3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f0101dca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	assert(page_alloc(&pp0) == 0);
f0101dd1:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0101dd4:	89 04 24             	mov    %eax,(%esp)
f0101dd7:	e8 4e f5 ff ff       	call   f010132a <page_alloc>
f0101ddc:	85 c0                	test   %eax,%eax
f0101dde:	74 24                	je     f0101e04 <i386_vm_init+0x5e0>
f0101de0:	c7 44 24 0c 77 63 10 	movl   $0xf0106377,0xc(%esp)
f0101de7:	f0 
f0101de8:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101def:	f0 
f0101df0:	c7 44 24 04 bc 01 00 	movl   $0x1bc,0x4(%esp)
f0101df7:	00 
f0101df8:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101dff:	e8 81 e2 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp1) == 0);
f0101e04:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0101e07:	89 04 24             	mov    %eax,(%esp)
f0101e0a:	e8 1b f5 ff ff       	call   f010132a <page_alloc>
f0101e0f:	85 c0                	test   %eax,%eax
f0101e11:	74 24                	je     f0101e37 <i386_vm_init+0x613>
f0101e13:	c7 44 24 0c 8d 63 10 	movl   $0xf010638d,0xc(%esp)
f0101e1a:	f0 
f0101e1b:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101e22:	f0 
f0101e23:	c7 44 24 04 bd 01 00 	movl   $0x1bd,0x4(%esp)
f0101e2a:	00 
f0101e2b:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101e32:	e8 4e e2 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp2) == 0);
f0101e37:	8d 45 d8             	lea    -0x28(%ebp),%eax
f0101e3a:	89 04 24             	mov    %eax,(%esp)
f0101e3d:	e8 e8 f4 ff ff       	call   f010132a <page_alloc>
f0101e42:	85 c0                	test   %eax,%eax
f0101e44:	74 24                	je     f0101e6a <i386_vm_init+0x646>
f0101e46:	c7 44 24 0c a3 63 10 	movl   $0xf01063a3,0xc(%esp)
f0101e4d:	f0 
f0101e4e:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101e55:	f0 
f0101e56:	c7 44 24 04 be 01 00 	movl   $0x1be,0x4(%esp)
f0101e5d:	00 
f0101e5e:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101e65:	e8 1b e2 ff ff       	call   f0100085 <_panic>
	assert(pp0);
f0101e6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101e6d:	85 d2                	test   %edx,%edx
f0101e6f:	75 24                	jne    f0101e95 <i386_vm_init+0x671>
f0101e71:	c7 44 24 0c c7 63 10 	movl   $0xf01063c7,0xc(%esp)
f0101e78:	f0 
f0101e79:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101e80:	f0 
f0101e81:	c7 44 24 04 bf 01 00 	movl   $0x1bf,0x4(%esp)
f0101e88:	00 
f0101e89:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101e90:	e8 f0 e1 ff ff       	call   f0100085 <_panic>
	assert(pp1 && pp1 != pp0);
f0101e95:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0101e98:	85 c9                	test   %ecx,%ecx
f0101e9a:	74 04                	je     f0101ea0 <i386_vm_init+0x67c>
f0101e9c:	39 ca                	cmp    %ecx,%edx
f0101e9e:	75 24                	jne    f0101ec4 <i386_vm_init+0x6a0>
f0101ea0:	c7 44 24 0c b9 63 10 	movl   $0xf01063b9,0xc(%esp)
f0101ea7:	f0 
f0101ea8:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101eaf:	f0 
f0101eb0:	c7 44 24 04 c0 01 00 	movl   $0x1c0,0x4(%esp)
f0101eb7:	00 
f0101eb8:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101ebf:	e8 c1 e1 ff ff       	call   f0100085 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101ec4:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101ec7:	85 c0                	test   %eax,%eax
f0101ec9:	74 08                	je     f0101ed3 <i386_vm_init+0x6af>
f0101ecb:	39 c1                	cmp    %eax,%ecx
f0101ecd:	74 04                	je     f0101ed3 <i386_vm_init+0x6af>
f0101ecf:	39 c2                	cmp    %eax,%edx
f0101ed1:	75 24                	jne    f0101ef7 <i386_vm_init+0x6d3>
f0101ed3:	c7 44 24 0c 78 62 10 	movl   $0xf0106278,0xc(%esp)
f0101eda:	f0 
f0101edb:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101ee2:	f0 
f0101ee3:	c7 44 24 04 c1 01 00 	movl   $0x1c1,0x4(%esp)
f0101eea:	00 
f0101eeb:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101ef2:	e8 8e e1 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101ef7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101efa:	89 04 24             	mov    %eax,(%esp)
f0101efd:	e8 28 f4 ff ff       	call   f010132a <page_alloc>
f0101f02:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101f05:	74 24                	je     f0101f2b <i386_vm_init+0x707>
f0101f07:	c7 44 24 0c 1f 64 10 	movl   $0xf010641f,0xc(%esp)
f0101f0e:	f0 
f0101f0f:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0101f16:	f0 
f0101f17:	c7 44 24 04 c2 01 00 	movl   $0x1c2,0x4(%esp)
f0101f1e:	00 
f0101f1f:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101f26:	e8 5a e1 ff ff       	call   f0100085 <_panic>

	// give free list back
	page_free_list = fl;
f0101f2b:	89 1d 58 35 3c f0    	mov    %ebx,0xf03c3558

	// free the pages we took
	page_free(pp0);
f0101f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101f34:	89 04 24             	mov    %eax,(%esp)
f0101f37:	e8 b7 ef ff ff       	call   f0100ef3 <page_free>
	page_free(pp1);
f0101f3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101f3f:	89 04 24             	mov    %eax,(%esp)
f0101f42:	e8 ac ef ff ff       	call   f0100ef3 <page_free>
	page_free(pp2);
f0101f47:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101f4a:	89 04 24             	mov    %eax,(%esp)
f0101f4d:	e8 a1 ef ff ff       	call   f0100ef3 <page_free>

	cprintf("check_page_alloc() succeeded!\n");
f0101f52:	c7 04 24 98 62 10 f0 	movl   $0xf0106298,(%esp)
f0101f59:	e8 09 0a 00 00       	call   f0102967 <cprintf>
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
	
	// Code added by Sandeep / Swastika
	boot_map_segment(boot_pgdir,(uintptr_t)UPAGES, (size_t)(ROUNDUP(npage*sizeof(struct Page), PGSIZE)), (physaddr_t)PADDR(pages), PTE_P | PTE_U);
f0101f5e:	a1 2c 8a 3c f0       	mov    0xf03c8a2c,%eax
f0101f63:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101f68:	77 20                	ja     f0101f8a <i386_vm_init+0x766>
f0101f6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101f6e:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0101f75:	f0 
f0101f76:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
f0101f7d:	00 
f0101f7e:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101f85:	e8 fb e0 ff ff       	call   f0100085 <_panic>
f0101f8a:	8b 15 20 8a 3c f0    	mov    0xf03c8a20,%edx
f0101f90:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0101f93:	8d 0c 95 ff 0f 00 00 	lea    0xfff(,%edx,4),%ecx
f0101f9a:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0101fa0:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f0101fa7:	00 
f0101fa8:	05 00 00 00 10       	add    $0x10000000,%eax
f0101fad:	89 04 24             	mov    %eax,(%esp)
f0101fb0:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0101fb5:	a1 28 8a 3c f0       	mov    0xf03c8a28,%eax
f0101fba:	e8 6d f5 ff ff       	call   f010152c <boot_map_segment>
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
	// Code added by Sandeep / Swastika
	boot_map_segment(boot_pgdir,(uintptr_t)UENVS, (size_t)(ROUNDUP(NENV*sizeof(struct Env), PGSIZE)), (physaddr_t)PADDR(envs), PTE_P | PTE_U);
f0101fbf:	a1 60 35 3c f0       	mov    0xf03c3560,%eax
f0101fc4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101fc9:	77 20                	ja     f0101feb <i386_vm_init+0x7c7>
f0101fcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101fcf:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0101fd6:	f0 
f0101fd7:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
f0101fde:	00 
f0101fdf:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0101fe6:	e8 9a e0 ff ff       	call   f0100085 <_panic>
f0101feb:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f0101ff2:	00 
f0101ff3:	05 00 00 00 10       	add    $0x10000000,%eax
f0101ff8:	89 04 24             	mov    %eax,(%esp)
f0101ffb:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f0102000:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102005:	a1 28 8a 3c f0       	mov    0xf03c8a28,%eax
f010200a:	e8 1d f5 ff ff       	call   f010152c <boot_map_segment>
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:

	// Code added by Sandeep / Swastika
	boot_map_segment(boot_pgdir,(uintptr_t)(KSTACKTOP - KSTKSIZE), (size_t)(KSTKSIZE), (physaddr_t)PADDR(bootstack), PTE_P | PTE_W);
f010200f:	b8 00 50 11 f0       	mov    $0xf0115000,%eax
f0102014:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102019:	77 20                	ja     f010203b <i386_vm_init+0x817>
f010201b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010201f:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0102026:	f0 
f0102027:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
f010202e:	00 
f010202f:	c7 04 24 b7 62 10 f0 	movl   $0xf01062b7,(%esp)
f0102036:	e8 4a e0 ff ff       	call   f0100085 <_panic>
f010203b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0102042:	00 
f0102043:	05 00 00 00 10       	add    $0x10000000,%eax
f0102048:	89 04 24             	mov    %eax,(%esp)
f010204b:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102050:	ba 00 80 bf ef       	mov    $0xefbf8000,%edx
f0102055:	a1 28 8a 3c f0       	mov    0xf03c8a28,%eax
f010205a:	e8 cd f4 ff ff       	call   f010152c <boot_map_segment>

	
	#ifdef HIGHMEM
		boot_map_segment(boot_pgdir,(uintptr_t)KERNBASE, (size_t)(HIGHMEM - KERNBASE + 1), (physaddr_t)(0x0), PTE_P | PTE_W);
	#else
	 	boot_map_segment(boot_pgdir,(uintptr_t)KERNBASE, (size_t)(0x10000000), (physaddr_t)(0x0), PTE_P | PTE_W);
f010205f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0102066:	00 
f0102067:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010206e:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102073:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102078:	a1 28 8a 3c f0       	mov    0xf03c8a28,%eax
f010207d:	e8 aa f4 ff ff       	call   f010152c <boot_map_segment>
	// mapping, even though we are turning on paging and reconfiguring
	// segmentation.

	// Map VA 0:4MB same as VA KERNBASE, i.e. to PA 0:4MB.
	// (Limits our kernel to <4MB)
	pgdir[0] = pgdir[PDX(KERNBASE)];
f0102082:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0102085:	8b 82 00 0f 00 00    	mov    0xf00(%edx),%eax
f010208b:	89 02                	mov    %eax,(%edx)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010208d:	a1 24 8a 3c f0       	mov    0xf03c8a24,%eax
f0102092:	0f 22 d8             	mov    %eax,%cr3

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0102095:	0f 20 c0             	mov    %cr0,%eax
	// Install page table.
	lcr3(boot_cr3);

	// Turn on paging.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_TS|CR0_EM|CR0_MP;
f0102098:	0d 2f 00 05 80       	or     $0x8005002f,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f010209d:	83 e0 f3             	and    $0xfffffff3,%eax
f01020a0:	0f 22 c0             	mov    %eax,%cr0

	// Current mapping: KERNBASE+x => x => x.
	// (x < 4MB so uses paging pgdir[0])

	// Reload all segment registers.
	asm volatile("lgdt gdt_pd");
f01020a3:	0f 01 15 50 d3 11 f0 	lgdtl  0xf011d350
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f01020aa:	b8 23 00 00 00       	mov    $0x23,%eax
f01020af:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f01020b1:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f01020b3:	b0 10                	mov    $0x10,%al
f01020b5:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f01020b7:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f01020b9:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));  // reload cs
f01020bb:	ea c2 20 10 f0 08 00 	ljmp   $0x8,$0xf01020c2
	asm volatile("lldt %%ax" :: "a" (0));
f01020c2:	b0 00                	mov    $0x0,%al
f01020c4:	0f 00 d0             	lldt   %ax

	// Final mapping: KERNBASE+x => KERNBASE+x => x.

	// This mapping was only used after paging was turned on but
	// before the segment registers were reloaded.
	pgdir[0] = 0;
f01020c7:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f01020cd:	a1 24 8a 3c f0       	mov    0xf03c8a24,%eax
f01020d2:	0f 22 d8             	mov    %eax,%cr3
		}
	}
	#endif


}
f01020d5:	83 c4 3c             	add    $0x3c,%esp
f01020d8:	5b                   	pop    %ebx
f01020d9:	5e                   	pop    %esi
f01020da:	5f                   	pop    %edi
f01020db:	5d                   	pop    %ebp
f01020dc:	c3                   	ret    
f01020dd:	00 00                	add    %al,(%eax)
	...

f01020e0 <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f01020e0:	55                   	push   %ebp
f01020e1:	89 e5                	mov    %esp,%ebp
f01020e3:	53                   	push   %ebx
f01020e4:	8b 45 08             	mov    0x8(%ebp),%eax
f01020e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f01020ea:	85 c0                	test   %eax,%eax
f01020ec:	75 0e                	jne    f01020fc <envid2env+0x1c>
		*env_store = curenv;
f01020ee:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01020f3:	89 01                	mov    %eax,(%ecx)
f01020f5:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
f01020fa:	eb 54                	jmp    f0102150 <envid2env+0x70>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f01020fc:	89 c2                	mov    %eax,%edx
f01020fe:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0102104:	6b d2 7c             	imul   $0x7c,%edx,%edx
f0102107:	03 15 60 35 3c f0    	add    0xf03c3560,%edx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f010210d:	83 7a 54 00          	cmpl   $0x0,0x54(%edx)
f0102111:	74 05                	je     f0102118 <envid2env+0x38>
f0102113:	39 42 4c             	cmp    %eax,0x4c(%edx)
f0102116:	74 0d                	je     f0102125 <envid2env+0x45>
		*env_store = 0;
f0102118:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f010211e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return -E_BAD_ENV;
f0102123:	eb 2b                	jmp    f0102150 <envid2env+0x70>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0102125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0102129:	74 1e                	je     f0102149 <envid2env+0x69>
f010212b:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102130:	39 c2                	cmp    %eax,%edx
f0102132:	74 15                	je     f0102149 <envid2env+0x69>
f0102134:	8b 5a 50             	mov    0x50(%edx),%ebx
f0102137:	3b 58 4c             	cmp    0x4c(%eax),%ebx
f010213a:	74 0d                	je     f0102149 <envid2env+0x69>
		*env_store = 0;
f010213c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0102142:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return -E_BAD_ENV;
f0102147:	eb 07                	jmp    f0102150 <envid2env+0x70>
	}

	*env_store = e;
f0102149:	89 11                	mov    %edx,(%ecx)
f010214b:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
f0102150:	5b                   	pop    %ebx
f0102151:	5d                   	pop    %ebp
f0102152:	c3                   	ret    

f0102153 <env_init>:
// Insert in reverse order, so that the first call to env_alloc()
// returns envs[0].
//
void
env_init(void)
{
f0102153:	55                   	push   %ebp
f0102154:	89 e5                	mov    %esp,%ebp
f0102156:	b8 84 ef 01 00       	mov    $0x1ef84,%eax
	// LAB 3: Your code here.
	// Code added by Swastika / Sandeep
	int i;
	for (i = NENV-1; i>=0; i--)
	{	
		envs[i].env_id = 0;
f010215b:	8b 15 60 35 3c f0    	mov    0xf03c3560,%edx
f0102161:	c7 44 02 4c 00 00 00 	movl   $0x0,0x4c(%edx,%eax,1)
f0102168:	00 
		LIST_INSERT_HEAD(&env_free_list, &envs[i], env_link);
f0102169:	8b 15 68 35 3c f0    	mov    0xf03c3568,%edx
f010216f:	8b 0d 60 35 3c f0    	mov    0xf03c3560,%ecx
f0102175:	89 54 01 44          	mov    %edx,0x44(%ecx,%eax,1)
f0102179:	85 d2                	test   %edx,%edx
f010217b:	74 14                	je     f0102191 <env_init+0x3e>
f010217d:	89 c1                	mov    %eax,%ecx
f010217f:	03 0d 60 35 3c f0    	add    0xf03c3560,%ecx
f0102185:	83 c1 44             	add    $0x44,%ecx
f0102188:	8b 15 68 35 3c f0    	mov    0xf03c3568,%edx
f010218e:	89 4a 48             	mov    %ecx,0x48(%edx)
f0102191:	89 c2                	mov    %eax,%edx
f0102193:	03 15 60 35 3c f0    	add    0xf03c3560,%edx
f0102199:	89 15 68 35 3c f0    	mov    %edx,0xf03c3568
f010219f:	c7 42 48 68 35 3c f0 	movl   $0xf03c3568,0x48(%edx)
f01021a6:	83 e8 7c             	sub    $0x7c,%eax
env_init(void)
{
	// LAB 3: Your code here.
	// Code added by Swastika / Sandeep
	int i;
	for (i = NENV-1; i>=0; i--)
f01021a9:	83 f8 84             	cmp    $0xffffff84,%eax
f01021ac:	75 ad                	jne    f010215b <env_init+0x8>
	{	
		envs[i].env_id = 0;
		LIST_INSERT_HEAD(&env_free_list, &envs[i], env_link);
	}
}
f01021ae:	5d                   	pop    %ebp
f01021af:	c3                   	ret    

f01021b0 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f01021b0:	55                   	push   %ebp
f01021b1:	89 e5                	mov    %esp,%ebp
f01021b3:	83 ec 18             	sub    $0x18,%esp
	__asm __volatile("movl %0,%%esp\n"
f01021b6:	8b 65 08             	mov    0x8(%ebp),%esp
f01021b9:	61                   	popa   
f01021ba:	07                   	pop    %es
f01021bb:	1f                   	pop    %ds
f01021bc:	83 c4 08             	add    $0x8,%esp
f01021bf:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01021c0:	c7 44 24 08 3c 64 10 	movl   $0xf010643c,0x8(%esp)
f01021c7:	f0 
f01021c8:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
f01021cf:	00 
f01021d0:	c7 04 24 48 64 10 f0 	movl   $0xf0106448,(%esp)
f01021d7:	e8 a9 de ff ff       	call   f0100085 <_panic>

f01021dc <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01021dc:	55                   	push   %ebp
f01021dd:	89 e5                	mov    %esp,%ebp
f01021df:	83 ec 18             	sub    $0x18,%esp
f01021e2:	8b 45 08             	mov    0x8(%ebp),%eax
	// LAB 3: Your code here.
	// Code added by Swastika / Sandeep
	//panic("env_run not yet implemented");
	
	// Step 1:
	if (curenv != e)		// context switch needs to happen
f01021e5:	39 05 64 35 3c f0    	cmp    %eax,0xf03c3564
f01021eb:	74 0f                	je     f01021fc <env_run+0x20>
	{
		curenv = e;
f01021ed:	a3 64 35 3c f0       	mov    %eax,0xf03c3564
		e->env_runs++;
f01021f2:	83 40 58 01          	addl   $0x1,0x58(%eax)
f01021f6:	8b 50 60             	mov    0x60(%eax),%edx
f01021f9:	0f 22 da             	mov    %edx,%cr3
		lcr3(e->env_cr3);
	}
	
	// Step 2:
	env_pop_tf(&e->env_tf);		
f01021fc:	89 04 24             	mov    %eax,(%esp)
f01021ff:	e8 ac ff ff ff       	call   f01021b0 <env_pop_tf>

f0102204 <env_free>:
//
// Frees env e and all memory it uses.
// 
void
env_free(struct Env *e)
{
f0102204:	55                   	push   %ebp
f0102205:	89 e5                	mov    %esp,%ebp
f0102207:	57                   	push   %edi
f0102208:	56                   	push   %esi
f0102209:	53                   	push   %ebx
f010220a:	83 ec 2c             	sub    $0x2c,%esp
f010220d:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;
	
	// If freeing the current environment, switch to boot_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0102210:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102215:	39 c7                	cmp    %eax,%edi
f0102217:	75 09                	jne    f0102222 <env_free+0x1e>
f0102219:	8b 15 24 8a 3c f0    	mov    0xf03c8a24,%edx
f010221f:	0f 22 da             	mov    %edx,%cr3
		lcr3(boot_cr3);

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0102222:	8b 4f 4c             	mov    0x4c(%edi),%ecx
f0102225:	ba 00 00 00 00       	mov    $0x0,%edx
f010222a:	85 c0                	test   %eax,%eax
f010222c:	74 03                	je     f0102231 <env_free+0x2d>
f010222e:	8b 50 4c             	mov    0x4c(%eax),%edx
f0102231:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0102235:	89 54 24 04          	mov    %edx,0x4(%esp)
f0102239:	c7 04 24 53 64 10 f0 	movl   $0xf0106453,(%esp)
f0102240:	e8 22 07 00 00       	call   f0102967 <cprintf>
f0102245:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010224c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010224f:	c1 e0 02             	shl    $0x2,%eax
f0102252:	89 45 d8             	mov    %eax,-0x28(%ebp)
	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0102255:	8b 47 5c             	mov    0x5c(%edi),%eax
f0102258:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010225b:	8b 34 10             	mov    (%eax,%edx,1),%esi
f010225e:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0102264:	0f 84 bb 00 00 00    	je     f0102325 <env_free+0x121>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f010226a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
		#ifdef HIGHMEM
			pt = (pte_t*) kmap(pa);
		#else
			pt = (pte_t*) KADDR(pa);
f0102270:	89 f0                	mov    %esi,%eax
f0102272:	c1 e8 0c             	shr    $0xc,%eax
f0102275:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0102278:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f010227e:	72 20                	jb     f01022a0 <env_free+0x9c>
f0102280:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0102284:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f010228b:	f0 
f010228c:	c7 44 24 04 a4 01 00 	movl   $0x1a4,0x4(%esp)
f0102293:	00 
f0102294:	c7 04 24 48 64 10 f0 	movl   $0xf0106448,(%esp)
f010229b:	e8 e5 dd ff ff       	call   f0100085 <_panic>

		// unmap all PTEs in this page table
		for (pteno = 0; pteno < NPTENTRIES; pteno++) {
		//	cprintf("\n pteno = %d, pt[pteno] = %x\n",pteno, pt[pteno]);
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01022a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01022a3:	c1 e2 16             	shl    $0x16,%edx
f01022a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01022a9:	bb 00 00 00 00       	mov    $0x0,%ebx
			cprintf("\n After kmap() in env_free()\n");

		// unmap all PTEs in this page table
		for (pteno = 0; pteno < NPTENTRIES; pteno++) {
		//	cprintf("\n pteno = %d, pt[pteno] = %x\n",pteno, pt[pteno]);
			if (pt[pteno] & PTE_P)
f01022ae:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f01022b5:	01 
f01022b6:	74 17                	je     f01022cf <env_free+0xcb>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01022b8:	89 d8                	mov    %ebx,%eax
f01022ba:	c1 e0 0c             	shl    $0xc,%eax
f01022bd:	0b 45 e4             	or     -0x1c(%ebp),%eax
f01022c0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01022c4:	8b 47 5c             	mov    0x5c(%edi),%eax
f01022c7:	89 04 24             	mov    %eax,(%esp)
f01022ca:	e8 c6 f2 ff ff       	call   f0101595 <page_remove>

		if (debug)
			cprintf("\n After kmap() in env_free()\n");

		// unmap all PTEs in this page table
		for (pteno = 0; pteno < NPTENTRIES; pteno++) {
f01022cf:	83 c3 01             	add    $0x1,%ebx
f01022d2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f01022d8:	75 d4                	jne    f01022ae <env_free+0xaa>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f01022da:	8b 47 5c             	mov    0x5c(%edi),%eax
f01022dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01022e0:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f01022e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01022ea:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f01022f0:	72 1c                	jb     f010230e <env_free+0x10a>
		panic("pa2page called with invalid pa");
f01022f2:	c7 44 24 08 88 5f 10 	movl   $0xf0105f88,0x8(%esp)
f01022f9:	f0 
f01022fa:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
f0102301:	00 
f0102302:	c7 04 24 7e 5c 10 f0 	movl   $0xf0105c7e,(%esp)
f0102309:	e8 77 dd ff ff       	call   f0100085 <_panic>
		page_decref(pa2page(pa));
f010230e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0102311:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0102314:	c1 e0 02             	shl    $0x2,%eax
f0102317:	03 05 2c 8a 3c f0    	add    0xf03c8a2c,%eax
f010231d:	89 04 24             	mov    %eax,(%esp)
f0102320:	e8 06 ec ff ff       	call   f0100f2b <page_decref>
	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0102325:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0102329:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0102330:	0f 85 16 ff ff ff    	jne    f010224c <env_free+0x48>
			kunmap_high((void*)pt);
		#endif
	}

	// free the page directory
	pa = e->env_cr3;
f0102336:	8b 47 60             	mov    0x60(%edi),%eax

	#ifdef HIGHMEM
		kunmap_high(e->env_pgdir);
	#endif

	e->env_pgdir = 0;
f0102339:	c7 47 5c 00 00 00 00 	movl   $0x0,0x5c(%edi)
	e->env_cr3 = 0;
f0102340:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f0102347:	c1 e8 0c             	shr    $0xc,%eax
f010234a:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f0102350:	72 1c                	jb     f010236e <env_free+0x16a>
		panic("pa2page called with invalid pa");
f0102352:	c7 44 24 08 88 5f 10 	movl   $0xf0105f88,0x8(%esp)
f0102359:	f0 
f010235a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
f0102361:	00 
f0102362:	c7 04 24 7e 5c 10 f0 	movl   $0xf0105c7e,(%esp)
f0102369:	e8 17 dd ff ff       	call   f0100085 <_panic>
	page_decref(pa2page(pa));
f010236e:	6b c0 0c             	imul   $0xc,%eax,%eax
f0102371:	03 05 2c 8a 3c f0    	add    0xf03c8a2c,%eax
f0102377:	89 04 24             	mov    %eax,(%esp)
f010237a:	e8 ac eb ff ff       	call   f0100f2b <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f010237f:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	LIST_INSERT_HEAD(&env_free_list, e, env_link);
f0102386:	a1 68 35 3c f0       	mov    0xf03c3568,%eax
f010238b:	89 47 44             	mov    %eax,0x44(%edi)
f010238e:	85 c0                	test   %eax,%eax
f0102390:	74 0b                	je     f010239d <env_free+0x199>
f0102392:	8d 57 44             	lea    0x44(%edi),%edx
f0102395:	a1 68 35 3c f0       	mov    0xf03c3568,%eax
f010239a:	89 50 48             	mov    %edx,0x48(%eax)
f010239d:	89 3d 68 35 3c f0    	mov    %edi,0xf03c3568
f01023a3:	c7 47 48 68 35 3c f0 	movl   $0xf03c3568,0x48(%edi)
	if (debug)
		cprintf("\n Env_free() completed !! \n");
}
f01023aa:	83 c4 2c             	add    $0x2c,%esp
f01023ad:	5b                   	pop    %ebx
f01023ae:	5e                   	pop    %esi
f01023af:	5f                   	pop    %edi
f01023b0:	5d                   	pop    %ebp
f01023b1:	c3                   	ret    

f01023b2 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e) 
{
f01023b2:	55                   	push   %ebp
f01023b3:	89 e5                	mov    %esp,%ebp
f01023b5:	53                   	push   %ebx
f01023b6:	83 ec 14             	sub    $0x14,%esp
f01023b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	env_free(e);
f01023bc:	89 1c 24             	mov    %ebx,(%esp)
f01023bf:	e8 40 fe ff ff       	call   f0102204 <env_free>

	if (curenv == e) {
f01023c4:	39 1d 64 35 3c f0    	cmp    %ebx,0xf03c3564
f01023ca:	75 0f                	jne    f01023db <env_destroy+0x29>
		curenv = NULL;
f01023cc:	c7 05 64 35 3c f0 00 	movl   $0x0,0xf03c3564
f01023d3:	00 00 00 
		sched_yield();
f01023d6:	e8 d5 0c 00 00       	call   f01030b0 <sched_yield>
	}
	if (debug)
		cprintf("\n Env_destroy() completed !! \n");
}
f01023db:	83 c4 14             	add    $0x14,%esp
f01023de:	5b                   	pop    %ebx
f01023df:	5d                   	pop    %ebp
f01023e0:	c3                   	ret    

f01023e1 <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f01023e1:	55                   	push   %ebp
f01023e2:	89 e5                	mov    %esp,%ebp
f01023e4:	56                   	push   %esi
f01023e5:	53                   	push   %ebx
f01023e6:	83 ec 20             	sub    $0x20,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = LIST_FIRST(&env_free_list)))
f01023e9:	8b 1d 68 35 3c f0    	mov    0xf03c3568,%ebx
f01023ef:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01023f4:	85 db                	test   %ebx,%ebx
f01023f6:	0f 84 aa 01 00 00    	je     f01025a6 <env_alloc+0x1c5>
//
static int
env_setup_vm(struct Env *e)
{
	int i, r;
	struct Page *p = NULL;
f01023fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	physaddr_t pa;
	pde_t *pgdir;
	
	// Allocate a page for the page directory
	if ((r = page_alloc(&p)) < 0)
f0102403:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0102406:	89 04 24             	mov    %eax,(%esp)
f0102409:	e8 1c ef ff ff       	call   f010132a <page_alloc>
f010240e:	85 c0                	test   %eax,%eax
f0102410:	0f 88 90 01 00 00    	js     f01025a6 <env_alloc+0x1c5>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f0102416:	8b 75 f4             	mov    -0xc(%ebp),%esi
f0102419:	2b 35 2c 8a 3c f0    	sub    0xf03c8a2c,%esi
f010241f:	c1 fe 02             	sar    $0x2,%esi
f0102422:	69 f6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%esi
f0102428:	c1 e6 0c             	shl    $0xc,%esi

	// LAB 3: Your code here.
	// Code added by Swastika / Sandeep

	pa = page2pa(p);
	e->env_cr3 = pa;
f010242b:	89 73 60             	mov    %esi,0x60(%ebx)
	
	#ifdef HIGHMEM	
		pgdir = (pde_t*)kmap(pa);
	#else
		pgdir = (pde_t*)KADDR(pa);
f010242e:	89 f0                	mov    %esi,%eax
f0102430:	c1 e8 0c             	shr    $0xc,%eax
f0102433:	3b 05 20 8a 3c f0    	cmp    0xf03c8a20,%eax
f0102439:	72 20                	jb     f010245b <env_alloc+0x7a>
f010243b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010243f:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f0102446:	f0 
f0102447:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
f010244e:	00 
f010244f:	c7 04 24 48 64 10 f0 	movl   $0xf0106448,(%esp)
f0102456:	e8 2a dc ff ff       	call   f0100085 <_panic>
f010245b:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
	#endif

	memset(pgdir, 0, PGSIZE);
f0102461:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102468:	00 
f0102469:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102470:	00 
f0102471:	89 34 24             	mov    %esi,(%esp)
f0102474:	e8 bd 21 00 00       	call   f0104636 <memset>
	e->env_pgdir = pgdir;
f0102479:	89 73 5c             	mov    %esi,0x5c(%ebx)
	
	p->pp_ref++;		// increment env_pgdir's pp_ref for env_free to work
f010247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010247f:	66 83 40 08 01       	addw   $0x1,0x8(%eax)
f0102484:	b8 ec 0e 00 00       	mov    $0xeec,%eax
	
	// Initialize the kernel portion of the address space
	// This is being done by initializing the page directory entries for env_pgdir
	// for the kernel portion to values same as corresponding entries in boot_pgdir
	for (i = PDX(UTOP); i < NPDENTRIES; i++)
		e->env_pgdir[i] = boot_pgdir[i];
f0102489:	8b 53 5c             	mov    0x5c(%ebx),%edx
f010248c:	8b 0d 28 8a 3c f0    	mov    0xf03c8a28,%ecx
f0102492:	8b 0c 01             	mov    (%ecx,%eax,1),%ecx
f0102495:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f0102498:	83 c0 04             	add    $0x4,%eax
	p->pp_ref++;		// increment env_pgdir's pp_ref for env_free to work
	
	// Initialize the kernel portion of the address space
	// This is being done by initializing the page directory entries for env_pgdir
	// for the kernel portion to values same as corresponding entries in boot_pgdir
	for (i = PDX(UTOP); i < NPDENTRIES; i++)
f010249b:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01024a0:	75 e7                	jne    f0102489 <env_alloc+0xa8>
		e->env_pgdir[i] = boot_pgdir[i];

	// VPT and UVPT map the env's own page table, with
	// different permissions.
	e->env_pgdir[PDX(VPT)]  = e->env_cr3 | PTE_P | PTE_W;
f01024a2:	8b 43 5c             	mov    0x5c(%ebx),%eax
f01024a5:	8b 53 60             	mov    0x60(%ebx),%edx
f01024a8:	83 ca 03             	or     $0x3,%edx
f01024ab:	89 90 fc 0e 00 00    	mov    %edx,0xefc(%eax)
	e->env_pgdir[PDX(UVPT)] = e->env_cr3 | PTE_P | PTE_U;
f01024b1:	8b 43 5c             	mov    0x5c(%ebx),%eax
f01024b4:	8b 53 60             	mov    0x60(%ebx),%edx
f01024b7:	83 ca 05             	or     $0x5,%edx
f01024ba:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01024c0:	8b 43 4c             	mov    0x4c(%ebx),%eax
f01024c3:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f01024c8:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f01024cd:	7f 05                	jg     f01024d4 <env_alloc+0xf3>
f01024cf:	b8 00 10 00 00       	mov    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
	e->env_id = generation | (e - envs);
f01024d4:	89 da                	mov    %ebx,%edx
f01024d6:	2b 15 60 35 3c f0    	sub    0xf03c3560,%edx
f01024dc:	c1 fa 02             	sar    $0x2,%edx
f01024df:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01024e5:	09 d0                	or     %edx,%eax
f01024e7:	89 43 4c             	mov    %eax,0x4c(%ebx)
	
	// Set the basic status variables.
	e->env_parent_id = parent_id;
f01024ea:	8b 45 0c             	mov    0xc(%ebp),%eax
f01024ed:	89 43 50             	mov    %eax,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01024f0:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
	e->env_runs = 0;
f01024f7:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01024fe:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0102505:	00 
f0102506:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010250d:	00 
f010250e:	89 1c 24             	mov    %ebx,(%esp)
f0102511:	e8 20 21 00 00       	call   f0104636 <memset>
	// Set up appropriate initial values for the segment registers.
	// GD_UD is the user data segment selector in the GDT, and 
	// GD_UT is the user text segment selector (see inc/memlayout.h).
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.
	e->env_tf.tf_ds = GD_UD | 3;
f0102516:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f010251c:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0102522:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0102528:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f010252f:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags = e->env_tf.tf_eflags | FL_IF;		
f0102535:	8b 53 38             	mov    0x38(%ebx),%edx
f0102538:	80 ce 02             	or     $0x2,%dh
f010253b:	89 53 38             	mov    %edx,0x38(%ebx)

	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f010253e:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0102545:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

	// If this is the file server (e == &envs[1]) give it I/O privileges.
	// LAB 5: Your code here.
	if(e==&envs[1])
f010254c:	a1 60 35 3c f0       	mov    0xf03c3560,%eax
f0102551:	83 c0 7c             	add    $0x7c,%eax
f0102554:	39 d8                	cmp    %ebx,%eax
f0102556:	75 06                	jne    f010255e <env_alloc+0x17d>
		e->env_tf.tf_eflags = e->env_tf.tf_eflags | FL_IOPL_MASK;
f0102558:	80 ce 30             	or     $0x30,%dh
f010255b:	89 50 38             	mov    %edx,0x38(%eax)
	// commit the allocation
	LIST_REMOVE(e, env_link);
f010255e:	8b 43 44             	mov    0x44(%ebx),%eax
f0102561:	85 c0                	test   %eax,%eax
f0102563:	74 06                	je     f010256b <env_alloc+0x18a>
f0102565:	8b 53 48             	mov    0x48(%ebx),%edx
f0102568:	89 50 48             	mov    %edx,0x48(%eax)
f010256b:	8b 43 48             	mov    0x48(%ebx),%eax
f010256e:	8b 53 44             	mov    0x44(%ebx),%edx
f0102571:	89 10                	mov    %edx,(%eax)
	*newenv_store = e;
f0102573:	8b 45 08             	mov    0x8(%ebp),%eax
f0102576:	89 18                	mov    %ebx,(%eax)

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0102578:	8b 4b 4c             	mov    0x4c(%ebx),%ecx
f010257b:	8b 15 64 35 3c f0    	mov    0xf03c3564,%edx
f0102581:	b8 00 00 00 00       	mov    $0x0,%eax
f0102586:	85 d2                	test   %edx,%edx
f0102588:	74 03                	je     f010258d <env_alloc+0x1ac>
f010258a:	8b 42 4c             	mov    0x4c(%edx),%eax
f010258d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0102591:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102595:	c7 04 24 69 64 10 f0 	movl   $0xf0106469,(%esp)
f010259c:	e8 c6 03 00 00       	call   f0102967 <cprintf>
f01025a1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (debug)
		cprintf("\n Env_alloc() completed !! \n");
	return 0;
}
f01025a6:	83 c4 20             	add    $0x20,%esp
f01025a9:	5b                   	pop    %ebx
f01025aa:	5e                   	pop    %esi
f01025ab:	5d                   	pop    %ebp
f01025ac:	c3                   	ret    

f01025ad <segment_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
segment_alloc(struct Env *e, void *va, size_t len)
{
f01025ad:	55                   	push   %ebp
f01025ae:	89 e5                	mov    %esp,%ebp
f01025b0:	57                   	push   %edi
f01025b1:	56                   	push   %esi
f01025b2:	53                   	push   %ebx
f01025b3:	83 ec 3c             	sub    $0x3c,%esp
f01025b6:	89 c6                	mov    %eax,%esi
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.

	// Code added by Swastika / Sandeep
	int r;
	int u = (int)ROUNDDOWN (va,PGSIZE); 
f01025b8:	89 d3                	mov    %edx,%ebx
f01025ba:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int v = (int)ROUNDUP (va+len, PGSIZE);
f01025c0:	8d 84 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%eax
f01025c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01025cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	struct Page *p = NULL;
	for (; u < v; u = u + PGSIZE)
f01025cf:	39 c3                	cmp    %eax,%ebx
f01025d1:	0f 8d 91 00 00 00    	jge    f0102668 <segment_alloc+0xbb>

	// Code added by Swastika / Sandeep
	int r;
	int u = (int)ROUNDDOWN (va,PGSIZE); 
	int v = (int)ROUNDUP (va+len, PGSIZE);
	struct Page *p = NULL;
f01025d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (; u < v; u = u + PGSIZE)
	{
		// Allocate a physical page, panic if error
		if ((r = page_alloc(&p)) == -E_NO_MEM)
f01025de:	8d 7d e4             	lea    -0x1c(%ebp),%edi
f01025e1:	89 3c 24             	mov    %edi,(%esp)
f01025e4:	e8 41 ed ff ff       	call   f010132a <page_alloc>
f01025e9:	83 f8 fc             	cmp    $0xfffffffc,%eax
f01025ec:	75 24                	jne    f0102612 <segment_alloc+0x65>
			panic("\n Panic in segment_alloc: %e \n", r);
f01025ee:	c7 44 24 0c fc ff ff 	movl   $0xfffffffc,0xc(%esp)
f01025f5:	ff 
f01025f6:	c7 44 24 08 94 64 10 	movl   $0xf0106494,0x8(%esp)
f01025fd:	f0 
f01025fe:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
f0102605:	00 
f0102606:	c7 04 24 48 64 10 f0 	movl   $0xf0106448,(%esp)
f010260d:	e8 73 da ff ff       	call   f0100085 <_panic>

		// Insert the page at the virtual address 'u'; panic if error in inserting	
		if ((r = page_insert(e->env_pgdir, p, (void*)u, PTE_P | PTE_U | PTE_W)) == -E_NO_MEM)
f0102612:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0102619:	00 
f010261a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010261e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102621:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102625:	8b 46 5c             	mov    0x5c(%esi),%eax
f0102628:	89 04 24             	mov    %eax,(%esp)
f010262b:	e8 1f f0 ff ff       	call   f010164f <page_insert>
f0102630:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0102633:	75 24                	jne    f0102659 <segment_alloc+0xac>
			panic("\n Panic in segment_alloc: %e \n", r);
f0102635:	c7 44 24 0c fc ff ff 	movl   $0xfffffffc,0xc(%esp)
f010263c:	ff 
f010263d:	c7 44 24 08 94 64 10 	movl   $0xf0106494,0x8(%esp)
f0102644:	f0 
f0102645:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
f010264c:	00 
f010264d:	c7 04 24 48 64 10 f0 	movl   $0xf0106448,(%esp)
f0102654:	e8 2c da ff ff       	call   f0100085 <_panic>
	// Code added by Swastika / Sandeep
	int r;
	int u = (int)ROUNDDOWN (va,PGSIZE); 
	int v = (int)ROUNDUP (va+len, PGSIZE);
	struct Page *p = NULL;
	for (; u < v; u = u + PGSIZE)
f0102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010265f:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0102662:	0f 8f 79 ff ff ff    	jg     f01025e1 <segment_alloc+0x34>
			panic("\n Panic in segment_alloc: %e \n", r);
	}
	if (debug)
		cprintf("\n segment_alloc() completed !! \n");
				
}
f0102668:	83 c4 3c             	add    $0x3c,%esp
f010266b:	5b                   	pop    %ebx
f010266c:	5e                   	pop    %esi
f010266d:	5f                   	pop    %edi
f010266e:	5d                   	pop    %ebp
f010266f:	c3                   	ret    

f0102670 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, size_t size)
{
f0102670:	55                   	push   %ebp
f0102671:	89 e5                	mov    %esp,%ebp
f0102673:	57                   	push   %edi
f0102674:	56                   	push   %esi
f0102675:	53                   	push   %ebx
f0102676:	83 ec 3c             	sub    $0x3c,%esp
	// LAB 3: Your code here.
	// Code added by Swastika / Sandeep
	struct Env *e;
	int r;
	if((r = env_alloc(&e, 0)) < 0)
f0102679:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102680:	00 
f0102681:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0102684:	89 04 24             	mov    %eax,(%esp)
f0102687:	e8 55 fd ff ff       	call   f01023e1 <env_alloc>
f010268c:	85 c0                	test   %eax,%eax
f010268e:	79 20                	jns    f01026b0 <env_create+0x40>
		panic ("\n Panic in env_create... !! %e", r);
f0102690:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102694:	c7 44 24 08 b4 64 10 	movl   $0xf01064b4,0x8(%esp)
f010269b:	f0 
f010269c:	c7 44 24 04 7e 01 00 	movl   $0x17e,0x4(%esp)
f01026a3:	00 
f01026a4:	c7 04 24 48 64 10 f0 	movl   $0xf0106448,(%esp)
f01026ab:	e8 d5 d9 ff ff       	call   f0100085 <_panic>
	load_icode(e, binary, size);
f01026b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	//  to make sure that the environment starts executing there.
	//  What?  (See env_run() and env_pop_tf() below.)

	// LAB 3: Your code here.
	// Code added by Swastika / Sandeep
	struct Elf *elfhdr = (struct Elf*) binary;
f01026b3:	8b 45 08             	mov    0x8(%ebp),%eax
f01026b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (elfhdr->e_magic != ELF_MAGIC)
f01026b9:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f01026bf:	74 1c                	je     f01026dd <env_create+0x6d>
		panic ("\n Bad ELF Magic !!");
f01026c1:	c7 44 24 08 7e 64 10 	movl   $0xf010647e,0x8(%esp)
f01026c8:	f0 
f01026c9:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
f01026d0:	00 
f01026d1:	c7 04 24 48 64 10 f0 	movl   $0xf0106448,(%esp)
f01026d8:	e8 a8 d9 ff ff       	call   f0100085 <_panic>
f01026dd:	8b 47 60             	mov    0x60(%edi),%eax
f01026e0:	0f 22 d8             	mov    %eax,%cr3
	int i;
	pte_t* pte;
	
	lcr3(e->env_cr3);	

	ph = (struct Proghdr *) (binary + elfhdr->e_phoff);
f01026e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01026e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f01026e9:	03 5a 1c             	add    0x1c(%edx),%ebx
	eph = ph + elfhdr->e_phnum;	
f01026ec:	0f b7 72 2c          	movzwl 0x2c(%edx),%esi
f01026f0:	c1 e6 05             	shl    $0x5,%esi
f01026f3:	8d 34 33             	lea    (%ebx,%esi,1),%esi
	for (; ph < eph; ph++)
f01026f6:	39 f3                	cmp    %esi,%ebx
f01026f8:	0f 83 89 00 00 00    	jae    f0102787 <env_create+0x117>
	{
		if (ph->p_type == ELF_PROG_LOAD)
f01026fe:	83 3b 01             	cmpl   $0x1,(%ebx)
f0102701:	75 79                	jne    f010277c <env_create+0x10c>
		{
			if (ph->p_filesz > ph->p_memsz)
f0102703:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0102706:	39 4b 10             	cmp    %ecx,0x10(%ebx)
f0102709:	76 1c                	jbe    f0102727 <env_create+0xb7>
				panic ("\n Panic in load_icode... ph->p_filesz > ph->p_memsz !!!");
f010270b:	c7 44 24 08 d4 64 10 	movl   $0xf01064d4,0x8(%esp)
f0102712:	f0 
f0102713:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
f010271a:	00 
f010271b:	c7 04 24 48 64 10 f0 	movl   $0xf0106448,(%esp)
f0102722:	e8 5e d9 ff ff       	call   f0100085 <_panic>
			segment_alloc(e,(void*) ph->p_va, ph->p_memsz);
f0102727:	8b 53 08             	mov    0x8(%ebx),%edx
f010272a:	89 f8                	mov    %edi,%eax
f010272c:	e8 7c fe ff ff       	call   f01025ad <segment_alloc>
			memset((void*)ROUNDDOWN(ph->p_va, PGSIZE), 0, ROUNDUP(ph->p_va+ph->p_memsz,PGSIZE) - ROUNDDOWN(ph->p_va, PGSIZE)); 
f0102731:	8b 43 08             	mov    0x8(%ebx),%eax
f0102734:	89 c2                	mov    %eax,%edx
f0102736:	03 53 14             	add    0x14(%ebx),%edx
f0102739:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f010273f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102744:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010274a:	29 c2                	sub    %eax,%edx
f010274c:	89 54 24 08          	mov    %edx,0x8(%esp)
f0102750:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102757:	00 
f0102758:	89 04 24             	mov    %eax,(%esp)
f010275b:	e8 d6 1e 00 00       	call   f0104636 <memset>
			memmove ((void*)ph->p_va,(void*) (binary+ph->p_offset),(size_t) ph->p_filesz );
f0102760:	8b 43 10             	mov    0x10(%ebx),%eax
f0102763:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102767:	8b 45 08             	mov    0x8(%ebp),%eax
f010276a:	03 43 04             	add    0x4(%ebx),%eax
f010276d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102771:	8b 43 08             	mov    0x8(%ebx),%eax
f0102774:	89 04 24             	mov    %eax,(%esp)
f0102777:	e8 19 1f 00 00       	call   f0104695 <memmove>
	
	lcr3(e->env_cr3);	

	ph = (struct Proghdr *) (binary + elfhdr->e_phoff);
	eph = ph + elfhdr->e_phnum;	
	for (; ph < eph; ph++)
f010277c:	83 c3 20             	add    $0x20,%ebx
f010277f:	39 de                	cmp    %ebx,%esi
f0102781:	0f 87 77 ff ff ff    	ja     f01026fe <env_create+0x8e>
			memmove ((void*)ph->p_va,(void*) (binary+ph->p_offset),(size_t) ph->p_filesz );
		}
	}

	// Do "something" with program's entry point !! 
	e->env_tf.tf_eip = elfhdr->e_entry; 	
f0102787:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010278a:	8b 42 18             	mov    0x18(%edx),%eax
f010278d:	89 47 30             	mov    %eax,0x30(%edi)
	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.
	
	// LAB 3: Your code here.
	// Code added by Sandeep / Swastika
	segment_alloc(e, (void*) (USTACKTOP - PGSIZE), PGSIZE); 
f0102790:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0102795:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f010279a:	89 f8                	mov    %edi,%eax
f010279c:	e8 0c fe ff ff       	call   f01025ad <segment_alloc>
	if((r = env_alloc(&e, 0)) < 0)
		panic ("\n Panic in env_create... !! %e", r);
	load_icode(e, binary, size);
	if (debug)
		cprintf("\n Env_create() completed !! \n");
}
f01027a1:	83 c4 3c             	add    $0x3c,%esp
f01027a4:	5b                   	pop    %ebx
f01027a5:	5e                   	pop    %esi
f01027a6:	5f                   	pop    %edi
f01027a7:	5d                   	pop    %ebp
f01027a8:	c3                   	ret    
f01027a9:	00 00                	add    %al,(%eax)
	...

f01027ac <mc146818_read>:
#include <kern/picirq.h>


unsigned
mc146818_read(unsigned reg)
{
f01027ac:	55                   	push   %ebp
f01027ad:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01027af:	ba 70 00 00 00       	mov    $0x70,%edx
f01027b4:	8b 45 08             	mov    0x8(%ebp),%eax
f01027b7:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01027b8:	b2 71                	mov    $0x71,%dl
f01027ba:	ec                   	in     (%dx),%al
f01027bb:	0f b6 c0             	movzbl %al,%eax
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
}
f01027be:	5d                   	pop    %ebp
f01027bf:	c3                   	ret    

f01027c0 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01027c0:	55                   	push   %ebp
f01027c1:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01027c3:	ba 70 00 00 00       	mov    $0x70,%edx
f01027c8:	8b 45 08             	mov    0x8(%ebp),%eax
f01027cb:	ee                   	out    %al,(%dx)
f01027cc:	b2 71                	mov    $0x71,%dl
f01027ce:	8b 45 0c             	mov    0xc(%ebp),%eax
f01027d1:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01027d2:	5d                   	pop    %ebp
f01027d3:	c3                   	ret    

f01027d4 <kclock_init>:


void
kclock_init(void)
{
f01027d4:	55                   	push   %ebp
f01027d5:	89 e5                	mov    %esp,%ebp
f01027d7:	83 ec 18             	sub    $0x18,%esp
f01027da:	ba 43 00 00 00       	mov    $0x43,%edx
f01027df:	b8 34 00 00 00       	mov    $0x34,%eax
f01027e4:	ee                   	out    %al,(%dx)
f01027e5:	b2 40                	mov    $0x40,%dl
f01027e7:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
f01027ec:	ee                   	out    %al,(%dx)
f01027ed:	b8 2e 00 00 00       	mov    $0x2e,%eax
f01027f2:	ee                   	out    %al,(%dx)
	/* initialize 8253 clock to interrupt 100 times/sec */
	outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
	outb(IO_TIMER1, TIMER_DIV(100) % 256);
	outb(IO_TIMER1, TIMER_DIV(100) / 256);
	cprintf("	Setup timer interrupts via 8259A\n");
f01027f3:	c7 04 24 0c 65 10 f0 	movl   $0xf010650c,(%esp)
f01027fa:	e8 68 01 00 00       	call   f0102967 <cprintf>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<0));
f01027ff:	0f b7 05 58 d3 11 f0 	movzwl 0xf011d358,%eax
f0102806:	25 fe ff 00 00       	and    $0xfffe,%eax
f010280b:	89 04 24             	mov    %eax,(%esp)
f010280e:	e8 24 00 00 00       	call   f0102837 <irq_setmask_8259A>
	cprintf("	unmasked timer interrupt\n");
f0102813:	c7 04 24 2f 65 10 f0 	movl   $0xf010652f,(%esp)
f010281a:	e8 48 01 00 00       	call   f0102967 <cprintf>
}
f010281f:	c9                   	leave  
f0102820:	c3                   	ret    
f0102821:	00 00                	add    %al,(%eax)
	...

f0102824 <irq_eoi>:
	cprintf("\n");
}

void
irq_eoi(void)
{
f0102824:	55                   	push   %ebp
f0102825:	89 e5                	mov    %esp,%ebp
f0102827:	ba 20 00 00 00       	mov    $0x20,%edx
f010282c:	b8 20 00 00 00       	mov    $0x20,%eax
f0102831:	ee                   	out    %al,(%dx)
f0102832:	b2 a0                	mov    $0xa0,%dl
f0102834:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0102835:	5d                   	pop    %ebp
f0102836:	c3                   	ret    

f0102837 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0102837:	55                   	push   %ebp
f0102838:	89 e5                	mov    %esp,%ebp
f010283a:	56                   	push   %esi
f010283b:	53                   	push   %ebx
f010283c:	83 ec 10             	sub    $0x10,%esp
f010283f:	8b 45 08             	mov    0x8(%ebp),%eax
f0102842:	89 c6                	mov    %eax,%esi
	int i;
	irq_mask_8259A = mask;
f0102844:	66 a3 58 d3 11 f0    	mov    %ax,0xf011d358
	if (!didinit)
f010284a:	83 3d 6c 35 3c f0 00 	cmpl   $0x0,0xf03c356c
f0102851:	74 4e                	je     f01028a1 <irq_setmask_8259A+0x6a>
f0102853:	ba 21 00 00 00       	mov    $0x21,%edx
f0102858:	ee                   	out    %al,(%dx)
f0102859:	89 f0                	mov    %esi,%eax
f010285b:	66 c1 e8 08          	shr    $0x8,%ax
f010285f:	b2 a1                	mov    $0xa1,%dl
f0102861:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
f0102862:	c7 04 24 4a 65 10 f0 	movl   $0xf010654a,(%esp)
f0102869:	e8 f9 00 00 00       	call   f0102967 <cprintf>
f010286e:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
f0102873:	0f b7 f6             	movzwl %si,%esi
f0102876:	f7 d6                	not    %esi
f0102878:	0f a3 de             	bt     %ebx,%esi
f010287b:	73 10                	jae    f010288d <irq_setmask_8259A+0x56>
			cprintf(" %d", i);
f010287d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102881:	c7 04 24 fb 69 10 f0 	movl   $0xf01069fb,(%esp)
f0102888:	e8 da 00 00 00       	call   f0102967 <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f010288d:	83 c3 01             	add    $0x1,%ebx
f0102890:	83 fb 10             	cmp    $0x10,%ebx
f0102893:	75 e3                	jne    f0102878 <irq_setmask_8259A+0x41>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f0102895:	c7 04 24 62 5c 10 f0 	movl   $0xf0105c62,(%esp)
f010289c:	e8 c6 00 00 00       	call   f0102967 <cprintf>
}
f01028a1:	83 c4 10             	add    $0x10,%esp
f01028a4:	5b                   	pop    %ebx
f01028a5:	5e                   	pop    %esi
f01028a6:	5d                   	pop    %ebp
f01028a7:	c3                   	ret    

f01028a8 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f01028a8:	55                   	push   %ebp
f01028a9:	89 e5                	mov    %esp,%ebp
f01028ab:	83 ec 18             	sub    $0x18,%esp
	didinit = 1;
f01028ae:	c7 05 6c 35 3c f0 01 	movl   $0x1,0xf03c356c
f01028b5:	00 00 00 
f01028b8:	ba 21 00 00 00       	mov    $0x21,%edx
f01028bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01028c2:	ee                   	out    %al,(%dx)
f01028c3:	b2 a1                	mov    $0xa1,%dl
f01028c5:	ee                   	out    %al,(%dx)
f01028c6:	b2 20                	mov    $0x20,%dl
f01028c8:	b8 11 00 00 00       	mov    $0x11,%eax
f01028cd:	ee                   	out    %al,(%dx)
f01028ce:	b2 21                	mov    $0x21,%dl
f01028d0:	b8 20 00 00 00       	mov    $0x20,%eax
f01028d5:	ee                   	out    %al,(%dx)
f01028d6:	b8 04 00 00 00       	mov    $0x4,%eax
f01028db:	ee                   	out    %al,(%dx)
f01028dc:	b8 03 00 00 00       	mov    $0x3,%eax
f01028e1:	ee                   	out    %al,(%dx)
f01028e2:	b2 a0                	mov    $0xa0,%dl
f01028e4:	b8 11 00 00 00       	mov    $0x11,%eax
f01028e9:	ee                   	out    %al,(%dx)
f01028ea:	b2 a1                	mov    $0xa1,%dl
f01028ec:	b8 28 00 00 00       	mov    $0x28,%eax
f01028f1:	ee                   	out    %al,(%dx)
f01028f2:	b8 02 00 00 00       	mov    $0x2,%eax
f01028f7:	ee                   	out    %al,(%dx)
f01028f8:	b8 01 00 00 00       	mov    $0x1,%eax
f01028fd:	ee                   	out    %al,(%dx)
f01028fe:	b2 20                	mov    $0x20,%dl
f0102900:	b8 68 00 00 00       	mov    $0x68,%eax
f0102905:	ee                   	out    %al,(%dx)
f0102906:	b8 0a 00 00 00       	mov    $0xa,%eax
f010290b:	ee                   	out    %al,(%dx)
f010290c:	b2 a0                	mov    $0xa0,%dl
f010290e:	b8 68 00 00 00       	mov    $0x68,%eax
f0102913:	ee                   	out    %al,(%dx)
f0102914:	b8 0a 00 00 00       	mov    $0xa,%eax
f0102919:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f010291a:	0f b7 05 58 d3 11 f0 	movzwl 0xf011d358,%eax
f0102921:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f0102925:	74 0b                	je     f0102932 <pic_init+0x8a>
		irq_setmask_8259A(irq_mask_8259A);
f0102927:	0f b7 c0             	movzwl %ax,%eax
f010292a:	89 04 24             	mov    %eax,(%esp)
f010292d:	e8 05 ff ff ff       	call   f0102837 <irq_setmask_8259A>
}
f0102932:	c9                   	leave  
f0102933:	c3                   	ret    

f0102934 <vcprintf>:
	*cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
f0102934:	55                   	push   %ebp
f0102935:	89 e5                	mov    %esp,%ebp
f0102937:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f010293a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0102941:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102944:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102948:	8b 45 08             	mov    0x8(%ebp),%eax
f010294b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010294f:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0102952:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102956:	c7 04 24 81 29 10 f0 	movl   $0xf0102981,(%esp)
f010295d:	e8 7b 15 00 00       	call   f0103edd <vprintfmt>
	return cnt;
}
f0102962:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102965:	c9                   	leave  
f0102966:	c3                   	ret    

f0102967 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0102967:	55                   	push   %ebp
f0102968:	89 e5                	mov    %esp,%ebp
f010296a:	83 ec 18             	sub    $0x18,%esp
	vprintfmt((void*)putch, &cnt, fmt, ap);
	return cnt;
}

int
cprintf(const char *fmt, ...)
f010296d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
f0102970:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102974:	8b 45 08             	mov    0x8(%ebp),%eax
f0102977:	89 04 24             	mov    %eax,(%esp)
f010297a:	e8 b5 ff ff ff       	call   f0102934 <vcprintf>
	va_end(ap);

	return cnt;
}
f010297f:	c9                   	leave  
f0102980:	c3                   	ret    

f0102981 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0102981:	55                   	push   %ebp
f0102982:	89 e5                	mov    %esp,%ebp
f0102984:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f0102987:	8b 45 08             	mov    0x8(%ebp),%eax
f010298a:	89 04 24             	mov    %eax,(%esp)
f010298d:	e8 28 db ff ff       	call   f01004ba <cputchar>
	*cnt++;
}
f0102992:	c9                   	leave  
f0102993:	c3                   	ret    
	...

f01029a0 <idt_init>:
}


void
idt_init(void)
{
f01029a0:	55                   	push   %ebp
f01029a1:	89 e5                	mov    %esp,%ebp
	extern struct Segdesc gdt[];
	
	// LAB 3a: Your code here.
	// Code added by Sandeep / Swastika	

	SETGATE(idt[T_DIVIDE], 0, GD_KT, hndl_div_by_zero, 0 );
f01029a3:	b8 6c 30 10 f0       	mov    $0xf010306c,%eax
f01029a8:	66 a3 80 35 3c f0    	mov    %ax,0xf03c3580
f01029ae:	66 c7 05 82 35 3c f0 	movw   $0x8,0xf03c3582
f01029b5:	08 00 
f01029b7:	c6 05 84 35 3c f0 00 	movb   $0x0,0xf03c3584
f01029be:	c6 05 85 35 3c f0 8e 	movb   $0x8e,0xf03c3585
f01029c5:	c1 e8 10             	shr    $0x10,%eax
f01029c8:	66 a3 86 35 3c f0    	mov    %ax,0xf03c3586
	SETGATE(idt[T_GPFLT], 0, GD_KT, hndl_general_protection, 0);
f01029ce:	b8 72 30 10 f0       	mov    $0xf0103072,%eax
f01029d3:	66 a3 e8 35 3c f0    	mov    %ax,0xf03c35e8
f01029d9:	66 c7 05 ea 35 3c f0 	movw   $0x8,0xf03c35ea
f01029e0:	08 00 
f01029e2:	c6 05 ec 35 3c f0 00 	movb   $0x0,0xf03c35ec
f01029e9:	c6 05 ed 35 3c f0 8e 	movb   $0x8e,0xf03c35ed
f01029f0:	c1 e8 10             	shr    $0x10,%eax
f01029f3:	66 a3 ee 35 3c f0    	mov    %ax,0xf03c35ee
	SETGATE(idt[T_PGFLT], 0, GD_KT, hndl_page_fault, 0);
f01029f9:	b8 76 30 10 f0       	mov    $0xf0103076,%eax
f01029fe:	66 a3 f0 35 3c f0    	mov    %ax,0xf03c35f0
f0102a04:	66 c7 05 f2 35 3c f0 	movw   $0x8,0xf03c35f2
f0102a0b:	08 00 
f0102a0d:	c6 05 f4 35 3c f0 00 	movb   $0x0,0xf03c35f4
f0102a14:	c6 05 f5 35 3c f0 8e 	movb   $0x8e,0xf03c35f5
f0102a1b:	c1 e8 10             	shr    $0x10,%eax
f0102a1e:	66 a3 f6 35 3c f0    	mov    %ax,0xf03c35f6
	SETGATE(idt[T_BRKPT], 0, GD_KT, hndl_breakpoint, 3);
f0102a24:	b8 7a 30 10 f0       	mov    $0xf010307a,%eax
f0102a29:	66 a3 98 35 3c f0    	mov    %ax,0xf03c3598
f0102a2f:	66 c7 05 9a 35 3c f0 	movw   $0x8,0xf03c359a
f0102a36:	08 00 
f0102a38:	c6 05 9c 35 3c f0 00 	movb   $0x0,0xf03c359c
f0102a3f:	c6 05 9d 35 3c f0 ee 	movb   $0xee,0xf03c359d
f0102a46:	c1 e8 10             	shr    $0x10,%eax
f0102a49:	66 a3 9e 35 3c f0    	mov    %ax,0xf03c359e
	SETGATE(idt[T_SYSCALL], 0, GD_KT, hndl_syscall, 3);
f0102a4f:	b8 80 30 10 f0       	mov    $0xf0103080,%eax
f0102a54:	66 a3 00 37 3c f0    	mov    %ax,0xf03c3700
f0102a5a:	66 c7 05 02 37 3c f0 	movw   $0x8,0xf03c3702
f0102a61:	08 00 
f0102a63:	c6 05 04 37 3c f0 00 	movb   $0x0,0xf03c3704
f0102a6a:	c6 05 05 37 3c f0 ee 	movb   $0xee,0xf03c3705
f0102a71:	c1 e8 10             	shr    $0x10,%eax
f0102a74:	66 a3 06 37 3c f0    	mov    %ax,0xf03c3706
	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER], 0, GD_KT, hndl_interrupt_timer, 0);
f0102a7a:	b8 86 30 10 f0       	mov    $0xf0103086,%eax
f0102a7f:	66 a3 80 36 3c f0    	mov    %ax,0xf03c3680
f0102a85:	66 c7 05 82 36 3c f0 	movw   $0x8,0xf03c3682
f0102a8c:	08 00 
f0102a8e:	c6 05 84 36 3c f0 00 	movb   $0x0,0xf03c3684
f0102a95:	c6 05 85 36 3c f0 8e 	movb   $0x8e,0xf03c3685
f0102a9c:	c1 e8 10             	shr    $0x10,%eax
f0102a9f:	66 a3 86 36 3c f0    	mov    %ax,0xf03c3686
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD], 0, GD_KT, hndl_interrupt_kbd, 0);
f0102aa5:	b8 8c 30 10 f0       	mov    $0xf010308c,%eax
f0102aaa:	66 a3 88 36 3c f0    	mov    %ax,0xf03c3688
f0102ab0:	66 c7 05 8a 36 3c f0 	movw   $0x8,0xf03c368a
f0102ab7:	08 00 
f0102ab9:	c6 05 8c 36 3c f0 00 	movb   $0x0,0xf03c368c
f0102ac0:	c6 05 8d 36 3c f0 8e 	movb   $0x8e,0xf03c368d
f0102ac7:	c1 e8 10             	shr    $0x10,%eax
f0102aca:	66 a3 8e 36 3c f0    	mov    %ax,0xf03c368e
	SETGATE(idt[IRQ_OFFSET+IRQ_SERIAL], 0, GD_KT, hndl_interrupt_serial, 0);
f0102ad0:	b8 92 30 10 f0       	mov    $0xf0103092,%eax
f0102ad5:	66 a3 a0 36 3c f0    	mov    %ax,0xf03c36a0
f0102adb:	66 c7 05 a2 36 3c f0 	movw   $0x8,0xf03c36a2
f0102ae2:	08 00 
f0102ae4:	c6 05 a4 36 3c f0 00 	movb   $0x0,0xf03c36a4
f0102aeb:	c6 05 a5 36 3c f0 8e 	movb   $0x8e,0xf03c36a5
f0102af2:	c1 e8 10             	shr    $0x10,%eax
f0102af5:	66 a3 a6 36 3c f0    	mov    %ax,0xf03c36a6

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f0102afb:	c7 05 84 3d 3c f0 00 	movl   $0xefc00000,0xf03c3d84
f0102b02:	00 c0 ef 
	ts.ts_ss0 = GD_KD;
f0102b05:	66 c7 05 88 3d 3c f0 	movw   $0x10,0xf03c3d88
f0102b0c:	10 00 

	// Initialize the TSS field of the gdt.
	gdt[GD_TSS >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f0102b0e:	66 c7 05 48 d3 11 f0 	movw   $0x68,0xf011d348
f0102b15:	68 00 
f0102b17:	b8 80 3d 3c f0       	mov    $0xf03c3d80,%eax
f0102b1c:	66 a3 4a d3 11 f0    	mov    %ax,0xf011d34a
f0102b22:	89 c2                	mov    %eax,%edx
f0102b24:	c1 ea 10             	shr    $0x10,%edx
f0102b27:	88 15 4c d3 11 f0    	mov    %dl,0xf011d34c
f0102b2d:	c6 05 4e d3 11 f0 40 	movb   $0x40,0xf011d34e
f0102b34:	c1 e8 18             	shr    $0x18,%eax
f0102b37:	a2 4f d3 11 f0       	mov    %al,0xf011d34f
					sizeof(struct Taskstate), 0);
	gdt[GD_TSS >> 3].sd_s = 0;
f0102b3c:	c6 05 4d d3 11 f0 89 	movb   $0x89,0xf011d34d
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f0102b43:	b8 28 00 00 00       	mov    $0x28,%eax
f0102b48:	0f 00 d8             	ltr    %ax

	// Load the TSS
	ltr(GD_TSS);

	// Load the IDT
	asm volatile("lidt idt_pd");
f0102b4b:	0f 01 1d 5c d3 11 f0 	lidtl  0xf011d35c
}
f0102b52:	5d                   	pop    %ebp
f0102b53:	c3                   	ret    

f0102b54 <print_regs>:
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
}

void
print_regs(struct PushRegs *regs)
{
f0102b54:	55                   	push   %ebp
f0102b55:	89 e5                	mov    %esp,%ebp
f0102b57:	53                   	push   %ebx
f0102b58:	83 ec 14             	sub    $0x14,%esp
f0102b5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0102b5e:	8b 03                	mov    (%ebx),%eax
f0102b60:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102b64:	c7 04 24 5e 65 10 f0 	movl   $0xf010655e,(%esp)
f0102b6b:	e8 f7 fd ff ff       	call   f0102967 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0102b70:	8b 43 04             	mov    0x4(%ebx),%eax
f0102b73:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102b77:	c7 04 24 6d 65 10 f0 	movl   $0xf010656d,(%esp)
f0102b7e:	e8 e4 fd ff ff       	call   f0102967 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0102b83:	8b 43 08             	mov    0x8(%ebx),%eax
f0102b86:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102b8a:	c7 04 24 7c 65 10 f0 	movl   $0xf010657c,(%esp)
f0102b91:	e8 d1 fd ff ff       	call   f0102967 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0102b96:	8b 43 0c             	mov    0xc(%ebx),%eax
f0102b99:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102b9d:	c7 04 24 8b 65 10 f0 	movl   $0xf010658b,(%esp)
f0102ba4:	e8 be fd ff ff       	call   f0102967 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0102ba9:	8b 43 10             	mov    0x10(%ebx),%eax
f0102bac:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102bb0:	c7 04 24 9a 65 10 f0 	movl   $0xf010659a,(%esp)
f0102bb7:	e8 ab fd ff ff       	call   f0102967 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0102bbc:	8b 43 14             	mov    0x14(%ebx),%eax
f0102bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102bc3:	c7 04 24 a9 65 10 f0 	movl   $0xf01065a9,(%esp)
f0102bca:	e8 98 fd ff ff       	call   f0102967 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0102bcf:	8b 43 18             	mov    0x18(%ebx),%eax
f0102bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102bd6:	c7 04 24 b8 65 10 f0 	movl   $0xf01065b8,(%esp)
f0102bdd:	e8 85 fd ff ff       	call   f0102967 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0102be2:	8b 43 1c             	mov    0x1c(%ebx),%eax
f0102be5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102be9:	c7 04 24 c7 65 10 f0 	movl   $0xf01065c7,(%esp)
f0102bf0:	e8 72 fd ff ff       	call   f0102967 <cprintf>
}
f0102bf5:	83 c4 14             	add    $0x14,%esp
f0102bf8:	5b                   	pop    %ebx
f0102bf9:	5d                   	pop    %ebp
f0102bfa:	c3                   	ret    

f0102bfb <print_trapframe>:
	asm volatile("lidt idt_pd");
}

void
print_trapframe(struct Trapframe *tf)
{
f0102bfb:	55                   	push   %ebp
f0102bfc:	89 e5                	mov    %esp,%ebp
f0102bfe:	53                   	push   %ebx
f0102bff:	83 ec 14             	sub    $0x14,%esp
f0102c02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p\n", tf);
f0102c05:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102c09:	c7 04 24 d6 65 10 f0 	movl   $0xf01065d6,(%esp)
f0102c10:	e8 52 fd ff ff       	call   f0102967 <cprintf>
	print_regs(&tf->tf_regs);
f0102c15:	89 1c 24             	mov    %ebx,(%esp)
f0102c18:	e8 37 ff ff ff       	call   f0102b54 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0102c1d:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0102c21:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102c25:	c7 04 24 e8 65 10 f0 	movl   $0xf01065e8,(%esp)
f0102c2c:	e8 36 fd ff ff       	call   f0102967 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f0102c31:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0102c35:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102c39:	c7 04 24 fb 65 10 f0 	movl   $0xf01065fb,(%esp)
f0102c40:	e8 22 fd ff ff       	call   f0102967 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0102c45:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0102c48:	83 f8 13             	cmp    $0x13,%eax
f0102c4b:	77 09                	ja     f0102c56 <print_trapframe+0x5b>
		return excnames[trapno];
f0102c4d:	8b 14 85 20 69 10 f0 	mov    -0xfef96e0(,%eax,4),%edx
f0102c54:	eb 1c                	jmp    f0102c72 <print_trapframe+0x77>
	if (trapno == T_SYSCALL)
f0102c56:	ba 0e 66 10 f0       	mov    $0xf010660e,%edx
f0102c5b:	83 f8 30             	cmp    $0x30,%eax
f0102c5e:	74 12                	je     f0102c72 <print_trapframe+0x77>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0102c60:	8d 48 e0             	lea    -0x20(%eax),%ecx
f0102c63:	ba 29 66 10 f0       	mov    $0xf0106629,%edx
f0102c68:	83 f9 0f             	cmp    $0xf,%ecx
f0102c6b:	76 05                	jbe    f0102c72 <print_trapframe+0x77>
f0102c6d:	ba 1a 66 10 f0       	mov    $0xf010661a,%edx
{
	cprintf("TRAP frame at %p\n", tf);
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0102c72:	89 54 24 08          	mov    %edx,0x8(%esp)
f0102c76:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102c7a:	c7 04 24 3c 66 10 f0 	movl   $0xf010663c,(%esp)
f0102c81:	e8 e1 fc ff ff       	call   f0102967 <cprintf>
	cprintf("  err  0x%08x\n", tf->tf_err);
f0102c86:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0102c89:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102c8d:	c7 04 24 4e 66 10 f0 	movl   $0xf010664e,(%esp)
f0102c94:	e8 ce fc ff ff       	call   f0102967 <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0102c99:	8b 43 30             	mov    0x30(%ebx),%eax
f0102c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102ca0:	c7 04 24 5d 66 10 f0 	movl   $0xf010665d,(%esp)
f0102ca7:	e8 bb fc ff ff       	call   f0102967 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0102cac:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0102cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102cb4:	c7 04 24 6c 66 10 f0 	movl   $0xf010666c,(%esp)
f0102cbb:	e8 a7 fc ff ff       	call   f0102967 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0102cc0:	8b 43 38             	mov    0x38(%ebx),%eax
f0102cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102cc7:	c7 04 24 7f 66 10 f0 	movl   $0xf010667f,(%esp)
f0102cce:	e8 94 fc ff ff       	call   f0102967 <cprintf>
	cprintf("  esp  0x%08x\n", tf->tf_esp);
f0102cd3:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0102cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102cda:	c7 04 24 8e 66 10 f0 	movl   $0xf010668e,(%esp)
f0102ce1:	e8 81 fc ff ff       	call   f0102967 <cprintf>
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0102ce6:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0102cea:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102cee:	c7 04 24 9d 66 10 f0 	movl   $0xf010669d,(%esp)
f0102cf5:	e8 6d fc ff ff       	call   f0102967 <cprintf>
}
f0102cfa:	83 c4 14             	add    $0x14,%esp
f0102cfd:	5b                   	pop    %ebx
f0102cfe:	5d                   	pop    %ebp
f0102cff:	c3                   	ret    

f0102d00 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0102d00:	55                   	push   %ebp
f0102d01:	89 e5                	mov    %esp,%ebp
f0102d03:	83 ec 58             	sub    $0x58,%esp
f0102d06:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0102d09:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0102d0c:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0102d0f:	8b 5d 08             	mov    0x8(%ebp),%ebx

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0102d12:	0f 20 d6             	mov    %cr2,%esi

	// Handle kernel-mode page faults.	
	// LAB 3b: Your code here.
	// Code added by Sandeep / Swastika

	if (tf->tf_cs == GD_KT)
f0102d15:	66 83 7b 34 08       	cmpw   $0x8,0x34(%ebx)
f0102d1a:	75 28                	jne    f0102d44 <page_fault_handler+0x44>
	{
		print_trapframe(tf);
f0102d1c:	89 1c 24             	mov    %ebx,(%esp)
f0102d1f:	e8 d7 fe ff ff       	call   f0102bfb <print_trapframe>
		panic ("\n Page fault in Kernel Mode (%08x) !!\n", fault_va);
f0102d24:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0102d28:	c7 44 24 08 90 68 10 	movl   $0xf0106890,0x8(%esp)
f0102d2f:	f0 
f0102d30:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
f0102d37:	00 
f0102d38:	c7 04 24 b0 66 10 f0 	movl   $0xf01066b0,(%esp)
f0102d3f:	e8 41 d3 ff ff       	call   f0100085 <_panic>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	// Code added by Swastika / Sandeep
	if (curenv->env_pgfault_upcall !=0 )		// page fault upcall exists
f0102d44:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102d49:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0102d4d:	0f 84 28 01 00 00    	je     f0102e7b <page_fault_handler+0x17b>
	{
		// Check if the environment has access to its user exception stack
		// This function destroys the environment if there is an error in perms
		user_mem_assert(curenv, (void *)(UXSTACKTOP-4),4 , PTE_U | PTE_P | PTE_W);
f0102d53:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0102d5a:	00 
f0102d5b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0102d62:	00 
f0102d63:	c7 44 24 04 fc ff bf 	movl   $0xeebffffc,0x4(%esp)
f0102d6a:	ee 
f0102d6b:	89 04 24             	mov    %eax,(%esp)
f0102d6e:	e8 fe e2 ff ff       	call   f0101071 <user_mem_assert>
		// prepare the user trapframe structure to be pushed
		struct UTrapframe user_tf;
		struct UTrapframe *u;
		uintptr_t var_esp;		

		user_tf.utf_err = tf->tf_err;
f0102d73:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0102d76:	89 45 b8             	mov    %eax,-0x48(%ebp)
		user_tf.utf_fault_va = fault_va;
		user_tf.utf_regs = tf->tf_regs;
f0102d79:	8b 43 1c             	mov    0x1c(%ebx),%eax
f0102d7c:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0102d7f:	8b 43 18             	mov    0x18(%ebx),%eax
f0102d82:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0102d85:	8b 43 14             	mov    0x14(%ebx),%eax
f0102d88:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102d8b:	8b 43 10             	mov    0x10(%ebx),%eax
f0102d8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102d91:	8b 43 0c             	mov    0xc(%ebx),%eax
f0102d94:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102d97:	8b 43 08             	mov    0x8(%ebx),%eax
f0102d9a:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0102d9d:	8b 43 04             	mov    0x4(%ebx),%eax
f0102da0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102da3:	8b 03                	mov    (%ebx),%eax
f0102da5:	89 45 c0             	mov    %eax,-0x40(%ebp)
		user_tf.utf_eip = tf->tf_eip;
f0102da8:	8b 43 30             	mov    0x30(%ebx),%eax
f0102dab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		user_tf.utf_eflags = tf->tf_eflags;
f0102dae:	8b 43 38             	mov    0x38(%ebx),%eax
f0102db1:	89 45 bc             	mov    %eax,-0x44(%ebp)
		user_tf.utf_esp = tf->tf_esp;
f0102db4:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0102db7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		// prepare var_esp for the point where user trapframe will be inserted
		if (tf->tf_esp < UXSTACKTOP && tf->tf_esp >= (UXSTACKTOP - PGSIZE))
f0102dba:	05 00 10 40 11       	add    $0x11401000,%eax
f0102dbf:	bf cb ff bf ee       	mov    $0xeebfffcb,%edi
f0102dc4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f0102dc9:	77 46                	ja     f0102e11 <page_fault_handler+0x111>
			var_esp = tf->tf_esp - 4; 		// recursive call, leave scratch space
		else
			var_esp = UXSTACKTOP - 1;		// non-recursive. initialize

		var_esp = var_esp - sizeof(struct UTrapframe);
f0102dcb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0102dce:	83 ef 38             	sub    $0x38,%edi
		
		// check for user exception stack overflow
		if (var_esp < (UXSTACKTOP - PGSIZE))
f0102dd1:	81 ff ff ef bf ee    	cmp    $0xeebfefff,%edi
f0102dd7:	77 38                	ja     f0102e11 <page_fault_handler+0x111>
		{
			// Stack overflow
			cprintf("[%08x] user exception stack overflow va %08x ip %08x\n",
f0102dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102ddc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102de0:	89 74 24 08          	mov    %esi,0x8(%esp)
f0102de4:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102de9:	8b 40 4c             	mov    0x4c(%eax),%eax
f0102dec:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102df0:	c7 04 24 b8 68 10 f0 	movl   $0xf01068b8,(%esp)
f0102df7:	e8 6b fb ff ff       	call   f0102967 <cprintf>
				curenv->env_id, fault_va, tf->tf_eip);
			print_trapframe(tf);
f0102dfc:	89 1c 24             	mov    %ebx,(%esp)
f0102dff:	e8 f7 fd ff ff       	call   f0102bfb <print_trapframe>
			env_destroy(curenv);
f0102e04:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102e09:	89 04 24             	mov    %eax,(%esp)
f0102e0c:	e8 a1 f5 ff ff       	call   f01023b2 <env_destroy>
		}
		
		// insert the user trap frame on the user exception stack
		u = (struct UTrapframe*)(var_esp);
		*u = user_tf;
f0102e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102e14:	89 47 30             	mov    %eax,0x30(%edi)
f0102e17:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0102e1a:	89 47 2c             	mov    %eax,0x2c(%edi)
f0102e1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102e20:	89 47 28             	mov    %eax,0x28(%edi)
f0102e23:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0102e26:	89 47 24             	mov    %eax,0x24(%edi)
f0102e29:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0102e2c:	89 47 20             	mov    %eax,0x20(%edi)
f0102e2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102e32:	89 47 1c             	mov    %eax,0x1c(%edi)
f0102e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0102e38:	89 47 18             	mov    %eax,0x18(%edi)
f0102e3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102e3e:	89 47 14             	mov    %eax,0x14(%edi)
f0102e41:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0102e44:	89 47 10             	mov    %eax,0x10(%edi)
f0102e47:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0102e4a:	89 47 0c             	mov    %eax,0xc(%edi)
f0102e4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0102e50:	89 47 08             	mov    %eax,0x8(%edi)
f0102e53:	89 37                	mov    %esi,(%edi)
f0102e55:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0102e58:	89 47 04             	mov    %eax,0x4(%edi)

		// run the page fault upcall 
		curenv->env_tf.tf_esp = var_esp;
f0102e5b:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102e60:	89 78 3c             	mov    %edi,0x3c(%eax)
		curenv->env_tf.tf_eip = (uintptr_t)curenv->env_pgfault_upcall;
f0102e63:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102e68:	8b 50 64             	mov    0x64(%eax),%edx
f0102e6b:	89 50 30             	mov    %edx,0x30(%eax)
		env_run(curenv);		
f0102e6e:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102e73:	89 04 24             	mov    %eax,(%esp)
f0102e76:	e8 61 f3 ff ff       	call   f01021dc <env_run>
	}	
	else
	{
		// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
f0102e7b:	8b 53 30             	mov    0x30(%ebx),%edx
f0102e7e:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0102e82:	89 74 24 08          	mov    %esi,0x8(%esp)
f0102e86:	8b 40 4c             	mov    0x4c(%eax),%eax
f0102e89:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102e8d:	c7 04 24 f0 68 10 f0 	movl   $0xf01068f0,(%esp)
f0102e94:	e8 ce fa ff ff       	call   f0102967 <cprintf>
			curenv->env_id, fault_va, tf->tf_eip);
		print_trapframe(tf);
f0102e99:	89 1c 24             	mov    %ebx,(%esp)
f0102e9c:	e8 5a fd ff ff       	call   f0102bfb <print_trapframe>
		env_destroy(curenv);
f0102ea1:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102ea6:	89 04 24             	mov    %eax,(%esp)
f0102ea9:	e8 04 f5 ff ff       	call   f01023b2 <env_destroy>
	}
}
f0102eae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0102eb1:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0102eb4:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0102eb7:	89 ec                	mov    %ebp,%esp
f0102eb9:	5d                   	pop    %ebp
f0102eba:	c3                   	ret    

f0102ebb <trap>:

}

void
trap(struct Trapframe *tf)
{
f0102ebb:	55                   	push   %ebp
f0102ebc:	89 e5                	mov    %esp,%ebp
f0102ebe:	57                   	push   %edi
f0102ebf:	56                   	push   %esi
f0102ec0:	83 ec 20             	sub    $0x20,%esp
f0102ec3:	8b 75 08             	mov    0x8(%ebp),%esi
	
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f0102ec6:	fc                   	cld    

static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
f0102ec7:	9c                   	pushf  
f0102ec8:	58                   	pop    %eax

	
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0102ec9:	f6 c4 02             	test   $0x2,%ah
f0102ecc:	74 24                	je     f0102ef2 <trap+0x37>
f0102ece:	c7 44 24 0c bc 66 10 	movl   $0xf01066bc,0xc(%esp)
f0102ed5:	f0 
f0102ed6:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0102edd:	f0 
f0102ede:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
f0102ee5:	00 
f0102ee6:	c7 04 24 b0 66 10 f0 	movl   $0xf01066b0,(%esp)
f0102eed:	e8 93 d1 ff ff       	call   f0100085 <_panic>

	if ((tf->tf_cs & 3) == 3) {
f0102ef2:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0102ef6:	83 e0 03             	and    $0x3,%eax
f0102ef9:	83 f8 03             	cmp    $0x3,%eax
f0102efc:	75 3c                	jne    f0102f3a <trap+0x7f>
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
f0102efe:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0102f03:	85 c0                	test   %eax,%eax
f0102f05:	75 24                	jne    f0102f2b <trap+0x70>
f0102f07:	c7 44 24 0c d5 66 10 	movl   $0xf01066d5,0xc(%esp)
f0102f0e:	f0 
f0102f0f:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0102f16:	f0 
f0102f17:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
f0102f1e:	00 
f0102f1f:	c7 04 24 b0 66 10 f0 	movl   $0xf01066b0,(%esp)
f0102f26:	e8 5a d1 ff ff       	call   f0100085 <_panic>
		curenv->env_tf = *tf;
f0102f2b:	b9 11 00 00 00       	mov    $0x11,%ecx
f0102f30:	89 c7                	mov    %eax,%edi
f0102f32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0102f34:	8b 35 64 35 3c f0    	mov    0xf03c3564,%esi
	// LAB 3: Your code here.
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep
	uint32_t  ret;	

	if (tf->tf_trapno == T_PGFLT)
f0102f3a:	8b 46 28             	mov    0x28(%esi),%eax
f0102f3d:	83 f8 0e             	cmp    $0xe,%eax
f0102f40:	75 19                	jne    f0102f5b <trap+0xa0>
	{
		page_fault_handler(tf);
f0102f42:	89 34 24             	mov    %esi,(%esp)
f0102f45:	e8 b6 fd ff ff       	call   f0102d00 <page_fault_handler>
		cprintf("\n Dispatch-ing PageFault !!!");
f0102f4a:	c7 04 24 dc 66 10 f0 	movl   $0xf01066dc,(%esp)
f0102f51:	e8 11 fa ff ff       	call   f0102967 <cprintf>
f0102f56:	e9 f5 00 00 00       	jmp    f0103050 <trap+0x195>
	}
	else if (tf->tf_trapno == T_BRKPT)
f0102f5b:	83 f8 03             	cmp    $0x3,%eax
f0102f5e:	75 1e                	jne    f0102f7e <trap+0xc3>
	{
		monitor(tf);
f0102f60:	89 34 24             	mov    %esi,(%esp)
f0102f63:	90                   	nop
f0102f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0102f68:	e8 7f d9 ff ff       	call   f01008ec <monitor>
		cprintf("\n Dispatch-ing Breakpoint !!!");
f0102f6d:	c7 04 24 f9 66 10 f0 	movl   $0xf01066f9,(%esp)
f0102f74:	e8 ee f9 ff ff       	call   f0102967 <cprintf>
f0102f79:	e9 d2 00 00 00       	jmp    f0103050 <trap+0x195>
	}
	else if (tf->tf_trapno == T_SYSCALL)
f0102f7e:	83 f8 30             	cmp    $0x30,%eax
f0102f81:	75 35                	jne    f0102fb8 <trap+0xfd>
	{
		ret = syscall (tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);	
f0102f83:	8b 46 04             	mov    0x4(%esi),%eax
f0102f86:	89 44 24 14          	mov    %eax,0x14(%esp)
f0102f8a:	8b 06                	mov    (%esi),%eax
f0102f8c:	89 44 24 10          	mov    %eax,0x10(%esp)
f0102f90:	8b 46 10             	mov    0x10(%esi),%eax
f0102f93:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102f97:	8b 46 18             	mov    0x18(%esi),%eax
f0102f9a:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102f9e:	8b 46 14             	mov    0x14(%esi),%eax
f0102fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102fa5:	8b 46 1c             	mov    0x1c(%esi),%eax
f0102fa8:	89 04 24             	mov    %eax,(%esp)
f0102fab:	e8 30 02 00 00       	call   f01031e0 <syscall>
				
		tf->tf_regs.reg_eax = ret;
f0102fb0:	89 46 1c             	mov    %eax,0x1c(%esi)
f0102fb3:	e9 98 00 00 00       	jmp    f0103050 <trap+0x195>
	}
	
	// Add time tick increment to clock interrupts.
	// LAB 6: Your code here.
	else if (tf->tf_trapno == (IRQ_OFFSET + IRQ_TIMER))
f0102fb8:	83 f8 20             	cmp    $0x20,%eax
f0102fbb:	75 0d                	jne    f0102fca <trap+0x10f>
	{
		time_tick();
f0102fbd:	8d 76 00             	lea    0x0(%esi),%esi
f0102fc0:	e8 05 25 00 00       	call   f01054ca <time_tick>
f0102fc5:	e9 86 00 00 00       	jmp    f0103050 <trap+0x195>
	{
		sched_yield();		
	}
	// Handle keyboard and serial interrupts.
	// LAB 7: Your code here.
	else if (tf->tf_trapno == (IRQ_OFFSET + IRQ_KBD))
f0102fca:	83 f8 21             	cmp    $0x21,%eax
f0102fcd:	8d 76 00             	lea    0x0(%esi),%esi
f0102fd0:	75 10                	jne    f0102fe2 <trap+0x127>
	{
		kbd_intr();		
f0102fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0102fd8:	e8 55 d2 ff ff       	call   f0100232 <kbd_intr>
f0102fdd:	8d 76 00             	lea    0x0(%esi),%esi
f0102fe0:	eb 6e                	jmp    f0103050 <trap+0x195>
	}
	else if (tf->tf_trapno == (IRQ_OFFSET + IRQ_SERIAL))
f0102fe2:	83 f8 24             	cmp    $0x24,%eax
f0102fe5:	75 10                	jne    f0102ff7 <trap+0x13c>
	{
		serial_intr();		
f0102fe7:	89 f6                	mov    %esi,%esi
f0102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0102ff0:	e8 4f d2 ff ff       	call   f0100244 <serial_intr>
f0102ff5:	eb 59                	jmp    f0103050 <trap+0x195>
	}

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	else if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0102ff7:	83 f8 27             	cmp    $0x27,%eax
f0102ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0103000:	75 16                	jne    f0103018 <trap+0x15d>
		cprintf("Spurious interrupt on irq 7\n");
f0103002:	c7 04 24 17 67 10 f0 	movl   $0xf0106717,(%esp)
f0103009:	e8 59 f9 ff ff       	call   f0102967 <cprintf>
		print_trapframe(tf);
f010300e:	89 34 24             	mov    %esi,(%esp)
f0103011:	e8 e5 fb ff ff       	call   f0102bfb <print_trapframe>
f0103016:	eb 38                	jmp    f0103050 <trap+0x195>
		return;
	}
	else
	{	
		// Unexpected trap: The user process or the kernel has a bug.
		print_trapframe(tf);
f0103018:	89 34 24             	mov    %esi,(%esp)
f010301b:	e8 db fb ff ff       	call   f0102bfb <print_trapframe>
		if (tf->tf_cs == GD_KT)
f0103020:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0103025:	75 1c                	jne    f0103043 <trap+0x188>
			panic("unhandled trap in kernel");
f0103027:	c7 44 24 08 34 67 10 	movl   $0xf0106734,0x8(%esp)
f010302e:	f0 
f010302f:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
f0103036:	00 
f0103037:	c7 04 24 b0 66 10 f0 	movl   $0xf01066b0,(%esp)
f010303e:	e8 42 d0 ff ff       	call   f0100085 <_panic>
		else {
			env_destroy(curenv);
f0103043:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103048:	89 04 24             	mov    %eax,(%esp)
f010304b:	e8 62 f3 ff ff       	call   f01023b2 <env_destroy>
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
f0103050:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103055:	85 c0                	test   %eax,%eax
f0103057:	74 0e                	je     f0103067 <trap+0x1ac>
f0103059:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010305d:	75 08                	jne    f0103067 <trap+0x1ac>
		env_run(curenv);
f010305f:	89 04 24             	mov    %eax,(%esp)
f0103062:	e8 75 f1 ff ff       	call   f01021dc <env_run>
	else
		sched_yield();
f0103067:	e8 44 00 00 00       	call   f01030b0 <sched_yield>

f010306c <hndl_div_by_zero>:

/*
 * Lab 3a: Your code here for generating entry points for the different traps.
 */
	/* Code added by Swastika / Sandeep */
	TRAPHANDLER_NOEC (hndl_div_by_zero, T_DIVIDE);
f010306c:	6a 00                	push   $0x0
f010306e:	6a 00                	push   $0x0
f0103070:	eb 26                	jmp    f0103098 <_alltraps>

f0103072 <hndl_general_protection>:
	TRAPHANDLER (hndl_general_protection, T_GPFLT);
f0103072:	6a 0d                	push   $0xd
f0103074:	eb 22                	jmp    f0103098 <_alltraps>

f0103076 <hndl_page_fault>:
	TRAPHANDLER (hndl_page_fault, T_PGFLT);
f0103076:	6a 0e                	push   $0xe
f0103078:	eb 1e                	jmp    f0103098 <_alltraps>

f010307a <hndl_breakpoint>:
	TRAPHANDLER_NOEC (hndl_breakpoint, T_BRKPT);
f010307a:	6a 00                	push   $0x0
f010307c:	6a 03                	push   $0x3
f010307e:	eb 18                	jmp    f0103098 <_alltraps>

f0103080 <hndl_syscall>:
	TRAPHANDLER_NOEC (hndl_syscall, T_SYSCALL);
f0103080:	6a 00                	push   $0x0
f0103082:	6a 30                	push   $0x30
f0103084:	eb 12                	jmp    f0103098 <_alltraps>

f0103086 <hndl_interrupt_timer>:
	TRAPHANDLER_NOEC (hndl_interrupt_timer, IRQ_OFFSET + IRQ_TIMER);
f0103086:	6a 00                	push   $0x0
f0103088:	6a 20                	push   $0x20
f010308a:	eb 0c                	jmp    f0103098 <_alltraps>

f010308c <hndl_interrupt_kbd>:
	TRAPHANDLER_NOEC (hndl_interrupt_kbd, IRQ_OFFSET + IRQ_KBD);
f010308c:	6a 00                	push   $0x0
f010308e:	6a 21                	push   $0x21
f0103090:	eb 06                	jmp    f0103098 <_alltraps>

f0103092 <hndl_interrupt_serial>:
	TRAPHANDLER_NOEC (hndl_interrupt_serial, IRQ_OFFSET + IRQ_SERIAL);
f0103092:	6a 00                	push   $0x0
f0103094:	6a 24                	push   $0x24
f0103096:	eb 00                	jmp    f0103098 <_alltraps>

f0103098 <_alltraps>:

/*
 * Lab 3a: Your code here for _alltraps
 */
_alltraps:
	pushl %ds;		/* Push ds*/				\
f0103098:	1e                   	push   %ds
f0103099:	06                   	push   %es
f010309a:	60                   	pusha  
f010309b:	b8 10 00 00 00       	mov    $0x10,%eax
	pushl %es;		/* Push es*/				\
	pushal;			/* Push flags*/				\
	movl $GD_KD, %eax;
	movl %eax, %ds;		/*Load ds*/
f01030a0:	8e d8                	mov    %eax,%ds
	movl %eax, %es;		/* Load es*/
f01030a2:	8e c0                	mov    %eax,%es
	pushl %esp;		/* Push esp value in the stack*/
f01030a4:	54                   	push   %esp
	call trap		/* Call trap function */
f01030a5:	e8 11 fe ff ff       	call   f0102ebb <trap>
f01030aa:	00 00                	add    %al,(%eax)
f01030ac:	00 00                	add    %al,(%eax)
	...

f01030b0 <sched_yield>:


// Choose a user environment to run and run it.
void
sched_yield(void)
{
f01030b0:	55                   	push   %ebp
f01030b1:	89 e5                	mov    %esp,%ebp
f01030b3:	53                   	push   %ebx
f01030b4:	83 ec 14             	sub    $0x14,%esp

	// LAB 4: Your code here.
	// Code added by Sandeep / Swastika 	
	
	int i, j, next_found = 0;
	if (curenv)
f01030b7:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01030bc:	85 c0                	test   %eax,%eax
f01030be:	0f 84 8f 00 00 00    	je     f0103153 <sched_yield+0xa3>
	{ 
		i  = ENVX(curenv->env_id);		// current running envs[]
f01030c4:	8b 48 4c             	mov    0x4c(%eax),%ecx
f01030c7:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
		j = (i + 1) % NENV;			// next-to-run envs[]
f01030cd:	8d 51 01             	lea    0x1(%ecx),%edx
f01030d0:	bb 00 04 00 00       	mov    $0x400,%ebx
f01030d5:	89 d0                	mov    %edx,%eax
f01030d7:	c1 fa 1f             	sar    $0x1f,%edx
f01030da:	f7 fb                	idiv   %ebx
		while (j!=i)
f01030dc:	39 d1                	cmp    %edx,%ecx
f01030de:	0f 84 c3 00 00 00    	je     f01031a7 <sched_yield+0xf7>
		{
			if (j!=0 && envs[j].env_status == ENV_RUNNABLE)
f01030e4:	8b 1d 60 35 3c f0    	mov    0xf03c3560,%ebx
f01030ea:	85 d2                	test   %edx,%edx
f01030ec:	74 0a                	je     f01030f8 <sched_yield+0x48>
f01030ee:	6b c2 7c             	imul   $0x7c,%edx,%eax
f01030f1:	83 7c 18 54 01       	cmpl   $0x1,0x54(%eax,%ebx,1)
f01030f6:	74 1e                	je     f0103116 <sched_yield+0x66>
			{
				next_found = 1;
				break;
			}
			j = (j+1) % NENV;
f01030f8:	83 c2 01             	add    $0x1,%edx
f01030fb:	89 d0                	mov    %edx,%eax
f01030fd:	c1 f8 1f             	sar    $0x1f,%eax
f0103100:	c1 e8 16             	shr    $0x16,%eax
f0103103:	01 c2                	add    %eax,%edx
f0103105:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f010310b:	29 c2                	sub    %eax,%edx
	int i, j, next_found = 0;
	if (curenv)
	{ 
		i  = ENVX(curenv->env_id);		// current running envs[]
		j = (i + 1) % NENV;			// next-to-run envs[]
		while (j!=i)
f010310d:	39 d1                	cmp    %edx,%ecx
f010310f:	75 d9                	jne    f01030ea <sched_yield+0x3a>
f0103111:	e9 91 00 00 00       	jmp    f01031a7 <sched_yield+0xf7>
				break;
			}
			j = (j+1) % NENV;
		}
		if (next_found == 1)
			env_run(&envs[j]);
f0103116:	6b d2 7c             	imul   $0x7c,%edx,%edx
f0103119:	01 d3                	add    %edx,%ebx
f010311b:	89 1c 24             	mov    %ebx,(%esp)
f010311e:	e8 b9 f0 ff ff       	call   f01021dc <env_run>
		else if (envs[i].env_status == ENV_RUNNABLE)
			env_run(&envs[i]); 
f0103123:	89 14 24             	mov    %edx,(%esp)
f0103126:	e8 b1 f0 ff ff       	call   f01021dc <env_run>
		// Run the special idle environment when nothing else is runnable.
		else if (envs[0].env_status == ENV_RUNNABLE)
f010312b:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010312f:	75 08                	jne    f0103139 <sched_yield+0x89>
			env_run(&envs[0]);
f0103131:	89 04 24             	mov    %eax,(%esp)
f0103134:	e8 a3 f0 ff ff       	call   f01021dc <env_run>
		else {
			cprintf("Destroyed all environments - nothing more to do!\n");
f0103139:	c7 04 24 70 69 10 f0 	movl   $0xf0106970,(%esp)
f0103140:	e8 22 f8 ff ff       	call   f0102967 <cprintf>
			while (1)
				monitor(NULL);
f0103145:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010314c:	e8 9b d7 ff ff       	call   f01008ec <monitor>
f0103151:	eb f2                	jmp    f0103145 <sched_yield+0x95>
		}
	}
	else
	{
		for (j =1; j<NENV; j++)
			if (envs[j].env_status == ENV_RUNNABLE)
f0103153:	a1 60 35 3c f0       	mov    0xf03c3560,%eax
f0103158:	89 c1                	mov    %eax,%ecx
f010315a:	ba 01 00 00 00       	mov    $0x1,%edx
f010315f:	83 b9 d0 00 00 00 01 	cmpl   $0x1,0xd0(%ecx)
f0103166:	74 10                	je     f0103178 <sched_yield+0xc8>
				monitor(NULL);
		}
	}
	else
	{
		for (j =1; j<NENV; j++)
f0103168:	83 c2 01             	add    $0x1,%edx
f010316b:	83 c1 7c             	add    $0x7c,%ecx
f010316e:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f0103174:	75 e9                	jne    f010315f <sched_yield+0xaf>
f0103176:	eb 49                	jmp    f01031c1 <sched_yield+0x111>
			{
				next_found ++;
				break;
			}
		if (next_found == 1)
			env_run(&envs[j]);	
f0103178:	6b d2 7c             	imul   $0x7c,%edx,%edx
f010317b:	01 d0                	add    %edx,%eax
f010317d:	89 04 24             	mov    %eax,(%esp)
f0103180:	e8 57 f0 ff ff       	call   f01021dc <env_run>
		else if (envs[0].env_status == ENV_RUNNABLE)
			env_run(&envs[0]);
f0103185:	89 04 24             	mov    %eax,(%esp)
f0103188:	e8 4f f0 ff ff       	call   f01021dc <env_run>
		else {
			cprintf("Destroyed all environments - nothing more to do!\n");
f010318d:	c7 04 24 70 69 10 f0 	movl   $0xf0106970,(%esp)
f0103194:	e8 ce f7 ff ff       	call   f0102967 <cprintf>
			while (1)
				monitor(NULL);
f0103199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01031a0:	e8 47 d7 ff ff       	call   f01008ec <monitor>
f01031a5:	eb f2                	jmp    f0103199 <sched_yield+0xe9>
			}
			j = (j+1) % NENV;
		}
		if (next_found == 1)
			env_run(&envs[j]);
		else if (envs[i].env_status == ENV_RUNNABLE)
f01031a7:	a1 60 35 3c f0       	mov    0xf03c3560,%eax
f01031ac:	6b d1 7c             	imul   $0x7c,%ecx,%edx
f01031af:	8d 14 10             	lea    (%eax,%edx,1),%edx
f01031b2:	83 7a 54 01          	cmpl   $0x1,0x54(%edx)
f01031b6:	0f 85 6f ff ff ff    	jne    f010312b <sched_yield+0x7b>
f01031bc:	e9 62 ff ff ff       	jmp    f0103123 <sched_yield+0x73>
				next_found ++;
				break;
			}
		if (next_found == 1)
			env_run(&envs[j]);	
		else if (envs[0].env_status == ENV_RUNNABLE)
f01031c1:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01031c5:	75 c6                	jne    f010318d <sched_yield+0xdd>
f01031c7:	89 f6                	mov    %esi,%esi
f01031c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f01031d0:	eb b3                	jmp    f0103185 <sched_yield+0xd5>
	...

f01031e0 <syscall>:
 

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01031e0:	55                   	push   %ebp
f01031e1:	89 e5                	mov    %esp,%ebp
f01031e3:	57                   	push   %edi
f01031e4:	56                   	push   %esi
f01031e5:	53                   	push   %ebx
f01031e6:	83 ec 3c             	sub    $0x3c,%esp
f01031e9:	8b 45 08             	mov    0x8(%ebp),%eax
f01031ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01031ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01031f2:	8b 55 1c             	mov    0x1c(%ebp),%edx
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3b: Your code here.

	//	panic("syscall not implemented");
	if (syscallno == SYS_cputs)
f01031f5:	85 c0                	test   %eax,%eax
f01031f7:	75 3b                	jne    f0103234 <syscall+0x54>
	// Destroy the environment if not.
	
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep
	
	user_mem_assert(curenv, (void*)s,len,4);
f01031f9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0103200:	00 
f0103201:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0103205:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0103209:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f010320e:	89 04 24             	mov    %eax,(%esp)
f0103211:	e8 5b de ff ff       	call   f0101071 <user_mem_assert>
	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0103216:	89 7c 24 08          	mov    %edi,0x8(%esp)
f010321a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010321e:	c7 04 24 a2 69 10 f0 	movl   $0xf01069a2,(%esp)
f0103225:	e8 3d f7 ff ff       	call   f0102967 <cprintf>
f010322a:	be 00 00 00 00       	mov    $0x0,%esi
f010322f:	e9 76 07 00 00       	jmp    f01039aa <syscall+0x7ca>
	if (syscallno == SYS_cputs)
	{
		sys_cputs((const char *)a1, (size_t)a2);
		return 0;
	}
	else if (syscallno == SYS_cgetc)
f0103234:	83 f8 01             	cmp    $0x1,%eax
f0103237:	75 13                	jne    f010324c <syscall+0x6c>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0103240:	e8 1a d0 ff ff       	call   f010025f <cons_getc>
f0103245:	89 c6                	mov    %eax,%esi
		sys_cputs((const char *)a1, (size_t)a2);
		return 0;
	}
	else if (syscallno == SYS_cgetc)
	{
		return (int32_t)sys_cgetc();
f0103247:	e9 5e 07 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_getenvid)
f010324c:	83 f8 02             	cmp    $0x2,%eax
f010324f:	90                   	nop
f0103250:	75 0d                	jne    f010325f <syscall+0x7f>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f0103252:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103257:	8b 70 4c             	mov    0x4c(%eax),%esi
	{
		return (int32_t)sys_cgetc();
	}
	else if (syscallno == SYS_getenvid)
	{
		return (int32_t)sys_getenvid();
f010325a:	e9 4b 07 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_env_destroy)
f010325f:	83 f8 03             	cmp    $0x3,%eax
f0103262:	75 36                	jne    f010329a <syscall+0xba>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0103264:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010326b:	00 
f010326c:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010326f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103273:	89 3c 24             	mov    %edi,(%esp)
f0103276:	e8 65 ee ff ff       	call   f01020e0 <envid2env>
f010327b:	89 c6                	mov    %eax,%esi
f010327d:	85 c0                	test   %eax,%eax
f010327f:	0f 88 25 07 00 00    	js     f01039aa <syscall+0x7ca>
		return r;
	env_destroy(e);
f0103285:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103288:	89 04 24             	mov    %eax,(%esp)
f010328b:	e8 22 f1 ff ff       	call   f01023b2 <env_destroy>
f0103290:	be 00 00 00 00       	mov    $0x0,%esi
f0103295:	e9 10 07 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_env_destroy)
	{
		return (int32_t)sys_env_destroy((envid_t)a1);
	}
	else if (syscallno == SYS_yield)
f010329a:	83 f8 0b             	cmp    $0xb,%eax
f010329d:	75 06                	jne    f01032a5 <syscall+0xc5>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f010329f:	90                   	nop
f01032a0:	e8 0b fe ff ff       	call   f01030b0 <sched_yield>
	else if (syscallno == SYS_yield)
	{
		sys_yield();
		return 0;
	}
	else if (syscallno == SYS_exofork)
f01032a5:	83 f8 07             	cmp    $0x7,%eax
f01032a8:	0f 85 44 01 00 00    	jne    f01033f2 <syscall+0x212>
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.
	// panic("sys_exofork not implemented");
	struct Env *new_env = NULL;
f01032ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	int r;
	r = env_alloc (&new_env, curenv->env_id);
f01032b5:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01032ba:	8b 40 4c             	mov    0x4c(%eax),%eax
f01032bd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01032c1:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01032c4:	89 04 24             	mov    %eax,(%esp)
f01032c7:	e8 15 f1 ff ff       	call   f01023e1 <env_alloc>
f01032cc:	89 c6                	mov    %eax,%esi
	if (r < 0)
f01032ce:	85 c0                	test   %eax,%eax
f01032d0:	0f 88 d4 06 00 00    	js     f01039aa <syscall+0x7ca>
		return (envid_t)r;				// this takes care of -E_NO_MEM and -E_NO_FREE_ENV	
	new_env->env_status = ENV_NOT_RUNNABLE; 			// set this as not runnable	
f01032d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01032d9:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	new_env->env_tf.tf_regs = curenv->env_tf.tf_regs; 		// copy the register set	
f01032e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01032e3:	8b 15 64 35 3c f0    	mov    0xf03c3564,%edx
f01032e9:	8b 0a                	mov    (%edx),%ecx
f01032eb:	89 08                	mov    %ecx,(%eax)
f01032ed:	8b 4a 04             	mov    0x4(%edx),%ecx
f01032f0:	89 48 04             	mov    %ecx,0x4(%eax)
f01032f3:	8b 4a 08             	mov    0x8(%edx),%ecx
f01032f6:	89 48 08             	mov    %ecx,0x8(%eax)
f01032f9:	8b 4a 0c             	mov    0xc(%edx),%ecx
f01032fc:	89 48 0c             	mov    %ecx,0xc(%eax)
f01032ff:	8b 4a 10             	mov    0x10(%edx),%ecx
f0103302:	89 48 10             	mov    %ecx,0x10(%eax)
f0103305:	8b 4a 14             	mov    0x14(%edx),%ecx
f0103308:	89 48 14             	mov    %ecx,0x14(%eax)
f010330b:	8b 4a 18             	mov    0x18(%edx),%ecx
f010330e:	89 48 18             	mov    %ecx,0x18(%eax)
f0103311:	8b 52 1c             	mov    0x1c(%edx),%edx
f0103314:	89 50 1c             	mov    %edx,0x1c(%eax)
	new_env->env_tf.tf_regs.reg_eax = 0;				// tweak for child process
f0103317:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010331a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	new_env->env_tf.tf_es = curenv->env_tf.tf_es;
f0103321:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103326:	0f b7 50 20          	movzwl 0x20(%eax),%edx
f010332a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010332d:	66 89 50 20          	mov    %dx,0x20(%eax)
	new_env->env_tf.tf_padding1 = curenv->env_tf.tf_padding1;
f0103331:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103336:	0f b7 50 22          	movzwl 0x22(%eax),%edx
f010333a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010333d:	66 89 50 22          	mov    %dx,0x22(%eax)
	new_env->env_tf.tf_ds = curenv->env_tf.tf_ds;
f0103341:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103346:	0f b7 50 24          	movzwl 0x24(%eax),%edx
f010334a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010334d:	66 89 50 24          	mov    %dx,0x24(%eax)
	new_env->env_tf.tf_padding2 = curenv->env_tf.tf_padding2;
f0103351:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103356:	0f b7 50 26          	movzwl 0x26(%eax),%edx
f010335a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010335d:	66 89 50 26          	mov    %dx,0x26(%eax)
	new_env->env_tf.tf_trapno = curenv->env_tf.tf_trapno;
f0103361:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103366:	8b 50 28             	mov    0x28(%eax),%edx
f0103369:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010336c:	89 50 28             	mov    %edx,0x28(%eax)
	new_env->env_tf.tf_err = curenv->env_tf.tf_err;
f010336f:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103374:	8b 50 2c             	mov    0x2c(%eax),%edx
f0103377:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010337a:	89 50 2c             	mov    %edx,0x2c(%eax)
	new_env->env_tf.tf_eip = curenv->env_tf.tf_eip;
f010337d:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103382:	8b 50 30             	mov    0x30(%eax),%edx
f0103385:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103388:	89 50 30             	mov    %edx,0x30(%eax)
	new_env->env_tf.tf_cs = curenv->env_tf.tf_cs;
f010338b:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103390:	0f b7 50 34          	movzwl 0x34(%eax),%edx
f0103394:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103397:	66 89 50 34          	mov    %dx,0x34(%eax)
	new_env->env_tf.tf_padding3 = curenv->env_tf.tf_padding3;
f010339b:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01033a0:	0f b7 50 36          	movzwl 0x36(%eax),%edx
f01033a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01033a7:	66 89 50 36          	mov    %dx,0x36(%eax)
	new_env->env_tf.tf_eflags = curenv->env_tf.tf_eflags;
f01033ab:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01033b0:	8b 50 38             	mov    0x38(%eax),%edx
f01033b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01033b6:	89 50 38             	mov    %edx,0x38(%eax)
	new_env->env_tf.tf_esp = curenv->env_tf.tf_esp;
f01033b9:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01033be:	8b 50 3c             	mov    0x3c(%eax),%edx
f01033c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01033c4:	89 50 3c             	mov    %edx,0x3c(%eax)
	new_env->env_tf.tf_ss = curenv->env_tf.tf_ss;
f01033c7:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01033cc:	0f b7 50 40          	movzwl 0x40(%eax),%edx
f01033d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01033d3:	66 89 50 40          	mov    %dx,0x40(%eax)
	new_env->env_tf.tf_padding4 = curenv->env_tf.tf_padding4;
f01033d7:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01033dc:	0f b7 50 42          	movzwl 0x42(%eax),%edx
f01033e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01033e3:	66 89 50 42          	mov    %dx,0x42(%eax)
	return (new_env->env_id);
f01033e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01033ea:	8b 70 4c             	mov    0x4c(%eax),%esi
f01033ed:	e9 b8 05 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_exofork)
	{
		return (int32_t)sys_exofork();
	}
	else if (syscallno == SYS_env_set_status)
f01033f2:	83 f8 08             	cmp    $0x8,%eax
f01033f5:	75 46                	jne    f010343d <syscall+0x25d>
	// envid's status.

	// LAB 4: Your code here.
	// panic("sys_env_set_status not implemented");

	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
f01033f7:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01033fa:	83 f8 01             	cmp    $0x1,%eax
f01033fd:	76 0a                	jbe    f0103409 <syscall+0x229>
f01033ff:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0103404:	e9 a1 05 00 00       	jmp    f01039aa <syscall+0x7ca>
		return -E_INVAL;
	struct Env *e;
	if (envid2env(envid, &e, 1) < 0)
f0103409:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0103410:	00 
f0103411:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0103414:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103418:	89 3c 24             	mov    %edi,(%esp)
f010341b:	e8 c0 ec ff ff       	call   f01020e0 <envid2env>
f0103420:	be fe ff ff ff       	mov    $0xfffffffe,%esi
f0103425:	85 c0                	test   %eax,%eax
f0103427:	0f 88 7d 05 00 00    	js     f01039aa <syscall+0x7ca>
		return -E_BAD_ENV;
	e->env_status = status;
f010342d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103430:	89 58 54             	mov    %ebx,0x54(%eax)
f0103433:	be 00 00 00 00       	mov    $0x0,%esi
f0103438:	e9 6d 05 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_env_set_status)
	{
		return (int32_t)sys_env_set_status((envid_t)a1, (int)a2);
	}
	else if (syscallno == SYS_page_alloc)
f010343d:	83 f8 04             	cmp    $0x4,%eax
f0103440:	0f 85 1a 01 00 00    	jne    f0103560 <syscall+0x380>
	{
		return (int32_t)sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
f0103446:	8b 45 14             	mov    0x14(%ebp),%eax
f0103449:	89 45 d0             	mov    %eax,-0x30(%ebp)
	struct Page *p;
	struct Env *e;
	int r;
	void* p_va;
	
	if (!(perm & PTE_P) | !(perm & PTE_U) | (perm & ~PTE_USER))
f010344c:	a9 f8 f1 ff ff       	test   $0xfffff1f8,%eax
f0103451:	0f 85 ff 00 00 00    	jne    f0103556 <syscall+0x376>
f0103457:	83 e0 05             	and    $0x5,%eax
f010345a:	83 f8 05             	cmp    $0x5,%eax
f010345d:	0f 85 f3 00 00 00    	jne    f0103556 <syscall+0x376>
	{
		return (int32_t)sys_env_set_status((envid_t)a1, (int)a2);
	}
	else if (syscallno == SYS_page_alloc)
	{
		return (int32_t)sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
f0103463:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	int r;
	void* p_va;
	
	if (!(perm & PTE_P) | !(perm & PTE_U) | (perm & ~PTE_USER))
		return -E_INVAL;
	if (((int)va >= UTOP) | ((int)va & 0xFFF))
f0103466:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f010346c:	0f 85 e4 00 00 00    	jne    f0103556 <syscall+0x376>
f0103472:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103478:	0f 87 d8 00 00 00    	ja     f0103556 <syscall+0x376>
		return -E_INVAL;


	if ((r=envid2env(envid, &e, 1)) < 0)	// checkperm flag is set to 1, to force permission checks !	
f010347e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0103485:	00 
f0103486:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103489:	89 44 24 04          	mov    %eax,0x4(%esp)
f010348d:	89 3c 24             	mov    %edi,(%esp)
f0103490:	e8 4b ec ff ff       	call   f01020e0 <envid2env>
f0103495:	89 c6                	mov    %eax,%esi
f0103497:	85 c0                	test   %eax,%eax
f0103499:	0f 88 0b 05 00 00    	js     f01039aa <syscall+0x7ca>
		return r;			// -E_BAD_ENV
	if ((r = page_alloc(&p)) < 0)
f010349f:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01034a2:	89 04 24             	mov    %eax,(%esp)
f01034a5:	e8 80 de ff ff       	call   f010132a <page_alloc>
f01034aa:	89 c6                	mov    %eax,%esi
f01034ac:	85 c0                	test   %eax,%eax
f01034ae:	0f 88 f6 04 00 00    	js     f01039aa <syscall+0x7ca>
f01034b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01034b7:	2b 05 2c 8a 3c f0    	sub    0xf03c8a2c,%eax
f01034bd:	c1 f8 02             	sar    $0x2,%eax
f01034c0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f01034c6:	c1 e0 0c             	shl    $0xc,%eax
		return r;			// -E_NO_MEM
	// cprintf("\n [sys_page_alloc]: page's pa: %x\n", page2pa(p));
	#ifdef HIGHMEM
		p_va = (void*)kmap(page2pa(p));
	#else
		p_va = KADDR(page2pa(p));
f01034c9:	89 c2                	mov    %eax,%edx
f01034cb:	c1 ea 0c             	shr    $0xc,%edx
f01034ce:	3b 15 20 8a 3c f0    	cmp    0xf03c8a20,%edx
f01034d4:	72 20                	jb     f01034f6 <syscall+0x316>
f01034d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01034da:	c7 44 24 08 00 61 10 	movl   $0xf0106100,0x8(%esp)
f01034e1:	f0 
f01034e2:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
f01034e9:	00 
f01034ea:	c7 04 24 a7 69 10 f0 	movl   $0xf01069a7,(%esp)
f01034f1:	e8 8f cb ff ff       	call   f0100085 <_panic>
	#endif
	// cprintf("\n after kmap()\n");
	
	memset(p_va, 0, PGSIZE);
f01034f6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01034fd:	00 
f01034fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103505:	00 
f0103506:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010350b:	89 04 24             	mov    %eax,(%esp)
f010350e:	e8 23 11 00 00       	call   f0104636 <memset>

	#ifdef HIGHMEM
		kunmap_high(p_va);
	#endif
	// cprintf("\n after kunmap_high()\n");
	if ((r = page_insert(e->env_pgdir, p, va, perm)) < 0)
f0103513:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0103516:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010351a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010351d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103521:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103524:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010352b:	8b 40 5c             	mov    0x5c(%eax),%eax
f010352e:	89 04 24             	mov    %eax,(%esp)
f0103531:	e8 19 e1 ff ff       	call   f010164f <page_insert>
f0103536:	89 c6                	mov    %eax,%esi
f0103538:	85 c0                	test   %eax,%eax
f010353a:	78 0a                	js     f0103546 <syscall+0x366>
f010353c:	be 00 00 00 00       	mov    $0x0,%esi
f0103541:	e9 64 04 00 00       	jmp    f01039aa <syscall+0x7ca>
	{
		page_free(p);
f0103546:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103549:	89 04 24             	mov    %eax,(%esp)
f010354c:	e8 a2 d9 ff ff       	call   f0100ef3 <page_free>
f0103551:	e9 54 04 00 00       	jmp    f01039aa <syscall+0x7ca>
f0103556:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f010355b:	e9 4a 04 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_page_alloc)
	{
		return (int32_t)sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
	}
	else if (syscallno == SYS_page_map)
f0103560:	83 f8 05             	cmp    $0x5,%eax
f0103563:	90                   	nop
f0103564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0103568:	0f 85 f9 00 00 00    	jne    f0103667 <syscall+0x487>
	{
		return (int32_t)sys_page_map((envid_t)a1, (void *)a2, (envid_t)a3, (void *)a4, (int)a5);
f010356e:	89 55 cc             	mov    %edx,-0x34(%ebp)
	// panic("sys_page_map not implemented");

	struct Page *p;
	struct Env *srcenv, *dstenv;
	int r;
	pte_t * srcva_pte = NULL;
f0103571:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

	if (!(perm & PTE_P) | !(perm & PTE_U) | (perm & ~PTE_USER))
f0103578:	f7 c2 f8 f1 ff ff    	test   $0xfffff1f8,%edx
f010357e:	0f 85 d9 00 00 00    	jne    f010365d <syscall+0x47d>
f0103584:	83 e2 05             	and    $0x5,%edx
f0103587:	83 fa 05             	cmp    $0x5,%edx
f010358a:	0f 85 cd 00 00 00    	jne    f010365d <syscall+0x47d>
	{
		return (int32_t)sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
	}
	else if (syscallno == SYS_page_map)
	{
		return (int32_t)sys_page_map((envid_t)a1, (void *)a2, (envid_t)a3, (void *)a4, (int)a5);
f0103590:	89 5d c8             	mov    %ebx,-0x38(%ebp)
	int r;
	pte_t * srcva_pte = NULL;

	if (!(perm & PTE_P) | !(perm & PTE_U) | (perm & ~PTE_USER))
		return -E_INVAL;
	if (((int)srcva >= UTOP) | ((int)srcva & 0xFFF))
f0103593:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f0103599:	0f 85 be 00 00 00    	jne    f010365d <syscall+0x47d>
f010359f:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f01035a5:	0f 87 b2 00 00 00    	ja     f010365d <syscall+0x47d>
	{
		return (int32_t)sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
	}
	else if (syscallno == SYS_page_map)
	{
		return (int32_t)sys_page_map((envid_t)a1, (void *)a2, (envid_t)a3, (void *)a4, (int)a5);
f01035ab:	8b 5d 18             	mov    0x18(%ebp),%ebx

	if (!(perm & PTE_P) | !(perm & PTE_U) | (perm & ~PTE_USER))
		return -E_INVAL;
	if (((int)srcva >= UTOP) | ((int)srcva & 0xFFF))
		return -E_INVAL;
	if (((int)dstva >= UTOP) | ((int)dstva & 0xFFF))
f01035ae:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f01035b4:	0f 85 a3 00 00 00    	jne    f010365d <syscall+0x47d>
f01035ba:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f01035c0:	0f 87 97 00 00 00    	ja     f010365d <syscall+0x47d>
		return -E_INVAL;
	
	
	if ((r=envid2env(srcenvid, &srcenv, 1)) < 0)	// checkperm flag is set to 1, to force permission checks !	
f01035c6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01035cd:	00 
f01035ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01035d1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01035d5:	89 3c 24             	mov    %edi,(%esp)
f01035d8:	e8 03 eb ff ff       	call   f01020e0 <envid2env>
f01035dd:	89 c6                	mov    %eax,%esi
f01035df:	85 c0                	test   %eax,%eax
f01035e1:	0f 88 c3 03 00 00    	js     f01039aa <syscall+0x7ca>
		return r;			// -E_BAD_ENV
	if ((r=envid2env(dstenvid, &dstenv, 1)) < 0)	// checkperm flag is set to 1, to force permission checks !	
f01035e7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01035ee:	00 
f01035ef:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01035f2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01035f6:	8b 55 14             	mov    0x14(%ebp),%edx
f01035f9:	89 14 24             	mov    %edx,(%esp)
f01035fc:	e8 df ea ff ff       	call   f01020e0 <envid2env>
f0103601:	89 c6                	mov    %eax,%esi
f0103603:	85 c0                	test   %eax,%eax
f0103605:	0f 88 9f 03 00 00    	js     f01039aa <syscall+0x7ca>
		return r;			// -E_BAD_ENV
	p = page_lookup (srcenv->env_pgdir, srcva, &srcva_pte);
f010360b:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010360e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103612:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0103615:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010361c:	8b 40 5c             	mov    0x5c(%eax),%eax
f010361f:	89 04 24             	mov    %eax,(%esp)
f0103622:	e8 90 de ff ff       	call   f01014b7 <page_lookup>
	if (p == NULL)
f0103627:	85 c0                	test   %eax,%eax
f0103629:	74 32                	je     f010365d <syscall+0x47d>
		return -E_INVAL;		// srcva is not mapped in srcenvid's address space 
	if ((perm & PTE_W) && !((int)(*srcva_pte) & PTE_W))
f010362b:	f6 45 cc 02          	testb  $0x2,-0x34(%ebp)
f010362f:	74 08                	je     f0103639 <syscall+0x459>
f0103631:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103634:	f6 02 02             	testb  $0x2,(%edx)
f0103637:	74 24                	je     f010365d <syscall+0x47d>
		return -E_INVAL;
	r = page_insert(dstenv->env_pgdir, p, dstva, perm);
f0103639:	8b 55 cc             	mov    -0x34(%ebp),%edx
f010363c:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103640:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0103644:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103648:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010364b:	8b 40 5c             	mov    0x5c(%eax),%eax
f010364e:	89 04 24             	mov    %eax,(%esp)
f0103651:	e8 f9 df ff ff       	call   f010164f <page_insert>
f0103656:	89 c6                	mov    %eax,%esi
f0103658:	e9 4d 03 00 00       	jmp    f01039aa <syscall+0x7ca>
f010365d:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0103662:	e9 43 03 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_page_map)
	{
		return (int32_t)sys_page_map((envid_t)a1, (void *)a2, (envid_t)a3, (void *)a4, (int)a5);
	}
	else if (syscallno == SYS_page_unmap)
f0103667:	83 f8 06             	cmp    $0x6,%eax
f010366a:	75 60                	jne    f01036cc <syscall+0x4ec>
	{
		return (int32_t)sys_page_unmap((envid_t)a1, (void *)a2);
f010366c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
	// panic("sys_page_unmap not implemented");
	
	struct Env *e;
	int r;
	
	if (((int)va >= UTOP) | ((int)va & 0xFFF))
f010366f:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f0103675:	75 0b                	jne    f0103682 <syscall+0x4a2>
f0103677:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f010367d:	8d 76 00             	lea    0x0(%esi),%esi
f0103680:	76 0a                	jbe    f010368c <syscall+0x4ac>
f0103682:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0103687:	e9 1e 03 00 00       	jmp    f01039aa <syscall+0x7ca>
		return -E_INVAL;
	if ((r=envid2env(envid, &e, 1)) < 0)	// checkperm flag is set to 1, to force permission checks !	
f010368c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0103693:	00 
f0103694:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0103697:	89 44 24 04          	mov    %eax,0x4(%esp)
f010369b:	89 3c 24             	mov    %edi,(%esp)
f010369e:	e8 3d ea ff ff       	call   f01020e0 <envid2env>
f01036a3:	89 c6                	mov    %eax,%esi
f01036a5:	85 c0                	test   %eax,%eax
f01036a7:	0f 88 fd 02 00 00    	js     f01039aa <syscall+0x7ca>
		return r;			// -E_BAD_ENV
	page_remove(e->env_pgdir, va);
f01036ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01036b0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01036b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01036b7:	8b 40 5c             	mov    0x5c(%eax),%eax
f01036ba:	89 04 24             	mov    %eax,(%esp)
f01036bd:	e8 d3 de ff ff       	call   f0101595 <page_remove>
f01036c2:	be 00 00 00 00       	mov    $0x0,%esi
f01036c7:	e9 de 02 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_page_unmap)
	{
		return (int32_t)sys_page_unmap((envid_t)a1, (void *)a2);
	}
	else if (syscallno == SYS_env_set_pgfault_upcall)
f01036cc:	83 f8 0a             	cmp    $0xa,%eax
f01036cf:	75 53                	jne    f0103724 <syscall+0x544>
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	// panic("sys_env_set_pgfault_upcall not implemented");
	struct Env *e;
	if (envid2env(envid, &e, 1) < 0)		// force permission check by putting checkperm as 1
f01036d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01036d8:	00 
f01036d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01036dc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01036e0:	89 3c 24             	mov    %edi,(%esp)
f01036e3:	e8 f8 e9 ff ff       	call   f01020e0 <envid2env>
f01036e8:	be fe ff ff ff       	mov    $0xfffffffe,%esi
f01036ed:	85 c0                	test   %eax,%eax
f01036ef:	0f 88 b5 02 00 00    	js     f01039aa <syscall+0x7ca>
		return -E_BAD_ENV;
	user_mem_assert (e, (void*)func, 1, PTE_U);
f01036f5:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f01036fc:	00 
f01036fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0103704:	00 
f0103705:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103709:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010370c:	89 04 24             	mov    %eax,(%esp)
f010370f:	e8 5d d9 ff ff       	call   f0101071 <user_mem_assert>
	e->env_pgfault_upcall = func;
f0103714:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103717:	89 58 64             	mov    %ebx,0x64(%eax)
f010371a:	be 00 00 00 00       	mov    $0x0,%esi
f010371f:	e9 86 02 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_env_set_pgfault_upcall)
	{
		return (int32_t)sys_env_set_pgfault_upcall((envid_t)a1, (void *)a2);
	}
	else if (syscallno == SYS_ipc_try_send)
f0103724:	83 f8 0c             	cmp    $0xc,%eax
f0103727:	0f 85 22 01 00 00    	jne    f010384f <syscall+0x66f>
	// panic("sys_ipc_try_send not implemented");
	
	struct Page *p;
	struct Env *env;
	int r;
	pte_t * srcva_pte = NULL;
f010372d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	
	if ((r=envid2env(envid, &env, 0)) < 0)	// checkperm flag is set to 1, to force permission checks !
f0103734:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010373b:	00 
f010373c:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010373f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103743:	89 3c 24             	mov    %edi,(%esp)
f0103746:	e8 95 e9 ff ff       	call   f01020e0 <envid2env>
f010374b:	89 c6                	mov    %eax,%esi
f010374d:	85 c0                	test   %eax,%eax
f010374f:	0f 88 55 02 00 00    	js     f01039aa <syscall+0x7ca>
		return r;			// -E_BAD_ENV	
	if (env->env_ipc_recving != 1)
f0103755:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103758:	be f9 ff ff ff       	mov    $0xfffffff9,%esi
f010375d:	83 78 68 01          	cmpl   $0x1,0x68(%eax)
f0103761:	0f 85 43 02 00 00    	jne    f01039aa <syscall+0x7ca>
		return -E_IPC_NOT_RECV;
	if ((int)srcva < UTOP)
f0103767:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f010376e:	77 62                	ja     f01037d2 <syscall+0x5f2>
	{
		return (int32_t)sys_env_set_pgfault_upcall((envid_t)a1, (void *)a2);
	}
	else if (syscallno == SYS_ipc_try_send)
	{
		return (int32_t)sys_ipc_try_send((envid_t)a1, (int)a2, (void *)a3, (unsigned)a4);
f0103770:	8b 45 14             	mov    0x14(%ebp),%eax
		return r;			// -E_BAD_ENV	
	if (env->env_ipc_recving != 1)
		return -E_IPC_NOT_RECV;
	if ((int)srcva < UTOP)
	{
		if ((int)srcva & 0xFFF)
f0103773:	a9 ff 0f 00 00       	test   $0xfff,%eax
f0103778:	0f 85 c7 00 00 00    	jne    f0103845 <syscall+0x665>
			return -E_INVAL;
		if (!(perm & PTE_P) | !(perm & PTE_U) | (perm & ~PTE_USER))
f010377e:	8b 55 18             	mov    0x18(%ebp),%edx
f0103781:	83 e2 05             	and    $0x5,%edx
f0103784:	83 fa 05             	cmp    $0x5,%edx
f0103787:	0f 85 b8 00 00 00    	jne    f0103845 <syscall+0x665>
f010378d:	f7 45 18 f8 f1 ff ff 	testl  $0xfffff1f8,0x18(%ebp)
f0103794:	0f 85 ab 00 00 00    	jne    f0103845 <syscall+0x665>
			return -E_INVAL;
		p = page_lookup (curenv->env_pgdir, srcva, &srcva_pte);
f010379a:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010379d:	89 54 24 08          	mov    %edx,0x8(%esp)
f01037a1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01037a5:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f01037aa:	8b 40 5c             	mov    0x5c(%eax),%eax
f01037ad:	89 04 24             	mov    %eax,(%esp)
f01037b0:	e8 02 dd ff ff       	call   f01014b7 <page_lookup>
		if (p == NULL)
f01037b5:	85 c0                	test   %eax,%eax
f01037b7:	0f 84 88 00 00 00    	je     f0103845 <syscall+0x665>
			return -E_INVAL;		// srcva is not mapped in current environment's address space 
		if ((perm & PTE_W) && !((int)(*srcva_pte) & PTE_W))
f01037bd:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f01037c1:	74 18                	je     f01037db <syscall+0x5fb>
f01037c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01037c6:	f6 02 02             	testb  $0x2,(%edx)
f01037c9:	75 10                	jne    f01037db <syscall+0x5fb>
f01037cb:	90                   	nop
f01037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01037d0:	eb 73                	jmp    f0103845 <syscall+0x665>
			kunmap_high((void*)srcva_pte);
		#endif
	}
	else 
	{
		env->env_ipc_perm = 0;			// page was not transferred
f01037d2:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
f01037d9:	eb 38                	jmp    f0103813 <syscall+0x633>
	}
	if (((int)srcva < UTOP) && ((int)env->env_ipc_dstva < UTOP))
f01037db:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01037de:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f01037e1:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f01037e7:	77 2a                	ja     f0103813 <syscall+0x633>
	{
		if ((r = page_insert(env->env_pgdir, p, env->env_ipc_dstva, perm)) < 0)
f01037e9:	8b 7d 18             	mov    0x18(%ebp),%edi
f01037ec:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01037f0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01037f4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01037f8:	8b 42 5c             	mov    0x5c(%edx),%eax
f01037fb:	89 04 24             	mov    %eax,(%esp)
f01037fe:	e8 4c de ff ff       	call   f010164f <page_insert>
f0103803:	89 c6                	mov    %eax,%esi
f0103805:	85 c0                	test   %eax,%eax
f0103807:	0f 88 9d 01 00 00    	js     f01039aa <syscall+0x7ca>
			return r;			// -E_NO_MEM on failure
		env->env_ipc_perm = perm;		// page was transferred
f010380d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103810:	89 78 78             	mov    %edi,0x78(%eax)
	}
	env->env_ipc_recving = 0;	
f0103813:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103816:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
	env->env_ipc_from = curenv->env_id;
f010381d:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103822:	8b 50 4c             	mov    0x4c(%eax),%edx
f0103825:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103828:	89 50 74             	mov    %edx,0x74(%eax)
	env->env_ipc_value = value;
f010382b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010382e:	89 58 70             	mov    %ebx,0x70(%eax)
	env->env_status = ENV_RUNNABLE;
f0103831:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103834:	c7 40 54 01 00 00 00 	movl   $0x1,0x54(%eax)
f010383b:	be 00 00 00 00       	mov    $0x0,%esi
f0103840:	e9 65 01 00 00       	jmp    f01039aa <syscall+0x7ca>
f0103845:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f010384a:	e9 5b 01 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_ipc_try_send)
	{
		return (int32_t)sys_ipc_try_send((envid_t)a1, (int)a2, (void *)a3, (unsigned)a4);
	}
	else if (syscallno == SYS_ipc_recv)
f010384f:	83 f8 0d             	cmp    $0xd,%eax
f0103852:	75 43                	jne    f0103897 <syscall+0x6b7>
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
	// panic("sys_ipc_recv not implemented");
	if ((int)dstva < UTOP)
f0103854:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f010385a:	77 11                	ja     f010386d <syscall+0x68d>
	{
		if ((int)dstva & 0xFFF)
f010385c:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0103861:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0103867:	0f 85 3d 01 00 00    	jne    f01039aa <syscall+0x7ca>
		{
			// dstva is not page-aligned
			return -E_INVAL;
		}
	}
	curenv->env_ipc_recving = 1;
f010386d:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103872:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0103879:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f010387e:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0103881:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103886:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f010388d:	be 00 00 00 00       	mov    $0x0,%esi
f0103892:	e9 13 01 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_ipc_recv)
	{
		return (int32_t)sys_ipc_recv((void *)a1);
	}
	else if (syscallno == SYS_env_set_trapframe)
f0103897:	83 f8 09             	cmp    $0x9,%eax
f010389a:	75 4b                	jne    f01038e7 <syscall+0x707>
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	// panic("sys_env_set_trapframe not implemented");
	struct Env *e;
	if (envid2env(envid, &e, 1) < 0)
f010389c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01038a3:	00 
f01038a4:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01038a7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01038ab:	89 3c 24             	mov    %edi,(%esp)
f01038ae:	e8 2d e8 ff ff       	call   f01020e0 <envid2env>
f01038b3:	be fe ff ff ff       	mov    $0xfffffffe,%esi
f01038b8:	85 c0                	test   %eax,%eax
f01038ba:	0f 88 ea 00 00 00    	js     f01039aa <syscall+0x7ca>
		return -E_BAD_ENV;
	if ((tf->tf_eflags & FL_IF) == FL_IF)
f01038c0:	be 00 00 00 00       	mov    $0x0,%esi
f01038c5:	f6 43 39 02          	testb  $0x2,0x39(%ebx)
f01038c9:	0f 84 db 00 00 00    	je     f01039aa <syscall+0x7ca>
		e->env_tf = *tf;
f01038cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01038d2:	b9 11 00 00 00       	mov    $0x11,%ecx
f01038d7:	89 c7                	mov    %eax,%edi
f01038d9:	89 de                	mov    %ebx,%esi
f01038db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01038dd:	be 00 00 00 00       	mov    $0x0,%esi
f01038e2:	e9 c3 00 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_env_set_trapframe)
	{
		return (int32_t)sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);
	}
	else if (syscallno == SYS_time_msec)
f01038e7:	83 f8 0e             	cmp    $0xe,%eax
f01038ea:	75 0c                	jne    f01038f8 <syscall+0x718>
// Return the current time.
static int
sys_time_msec(void) 
{
	// LAB 6: Your code here.
	return time_msec();
f01038ec:	e8 ca 1b 00 00       	call   f01054bb <time_msec>
f01038f1:	89 c6                	mov    %eax,%esi
	{
		return (int32_t)sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);
	}
	else if (syscallno == SYS_time_msec)
	{
		return (int32_t)sys_time_msec();
f01038f3:	e9 b2 00 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_transmit_packet)
f01038f8:	83 f8 0f             	cmp    $0xf,%eax
f01038fb:	75 13                	jne    f0103910 <syscall+0x730>
// LAB 6
// Network Card
static int
sys_transmit_packet(void* data, uint32_t len)
{
	return transmit_packet(data, len);
f01038fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103901:	89 3c 24             	mov    %edi,(%esp)
f0103904:	e8 e8 11 00 00       	call   f0104af1 <transmit_packet>
f0103909:	89 c6                	mov    %eax,%esi
	{
		return (int32_t)sys_time_msec();
	}
	else if (syscallno == SYS_transmit_packet)
	{
		return (int32_t)sys_transmit_packet((void*)a1, (uint32_t)a2);
f010390b:	e9 9a 00 00 00       	jmp    f01039aa <syscall+0x7ca>
	}
	else if (syscallno == SYS_receive_packet)
f0103910:	83 f8 10             	cmp    $0x10,%eax
f0103913:	75 10                	jne    f0103925 <syscall+0x745>
// LAB 6
// Network Card
static int
sys_receive_packet(void* buffer)
{
	return receive_packet(buffer);
f0103915:	89 3c 24             	mov    %edi,(%esp)
f0103918:	e8 cc 12 00 00       	call   f0104be9 <receive_packet>
f010391d:	89 c6                	mov    %eax,%esi
	{
		return (int32_t)sys_transmit_packet((void*)a1, (uint32_t)a2);
	}
	else if (syscallno == SYS_receive_packet)
	{
		return (int32_t)sys_receive_packet((void*)a1);
f010391f:	90                   	nop
f0103920:	e9 85 00 00 00       	jmp    f01039aa <syscall+0x7ca>
	}	
	else if (syscallno == SYS_page_waste)
f0103925:	83 f8 11             	cmp    $0x11,%eax
f0103928:	75 2a                	jne    f0103954 <syscall+0x774>

static int
sys_page_waste(struct Page **p, int n)
{
	int r, i;
	cprintf("\n Leaking pages... Please wait...\n");
f010392a:	c7 04 24 b8 69 10 f0 	movl   $0xf01069b8,(%esp)
f0103931:	e8 31 f0 ff ff       	call   f0102967 <cprintf>
	for (i = 0; i<n; i++)
f0103936:	be 00 00 00 00       	mov    $0x0,%esi
f010393b:	85 db                	test   %ebx,%ebx
f010393d:	7e 6b                	jle    f01039aa <syscall+0x7ca>
	{
		if ((r = page_alloc(p)) < 0)
f010393f:	89 3c 24             	mov    %edi,(%esp)
f0103942:	e8 e3 d9 ff ff       	call   f010132a <page_alloc>
f0103947:	85 c0                	test   %eax,%eax
f0103949:	78 5f                	js     f01039aa <syscall+0x7ca>
static int
sys_page_waste(struct Page **p, int n)
{
	int r, i;
	cprintf("\n Leaking pages... Please wait...\n");
	for (i = 0; i<n; i++)
f010394b:	83 c6 01             	add    $0x1,%esi
f010394e:	39 f3                	cmp    %esi,%ebx
f0103950:	7f ed                	jg     f010393f <syscall+0x75f>
f0103952:	eb 56                	jmp    f01039aa <syscall+0x7ca>
	}	
	else if (syscallno == SYS_page_waste)
	{
		return (int32_t)sys_page_waste((struct Page**)a1, (int)a2);
	}
	else if (syscallno == SYS_page_insert)
f0103954:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0103959:	83 f8 12             	cmp    $0x12,%eax
f010395c:	75 4c                	jne    f01039aa <syscall+0x7ca>
sys_page_insert(envid_t envid, void* va, struct Page *p, int perm)
{

	int r;
	struct Env *e;
	if ((r=envid2env(envid, &e, 1)) < 0)	// checkperm flag is set to 1, to force permission checks !	
f010395e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0103965:	00 
f0103966:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0103969:	89 44 24 04          	mov    %eax,0x4(%esp)
f010396d:	89 3c 24             	mov    %edi,(%esp)
f0103970:	e8 6b e7 ff ff       	call   f01020e0 <envid2env>
f0103975:	89 c6                	mov    %eax,%esi
f0103977:	85 c0                	test   %eax,%eax
f0103979:	78 2f                	js     f01039aa <syscall+0x7ca>
		return r;			// -E_BAD_ENV
	if ((r = page_insert(e->env_pgdir,  p, va, perm)) < 0)
f010397b:	8b 55 18             	mov    0x18(%ebp),%edx
f010397e:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103982:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0103986:	8b 45 14             	mov    0x14(%ebp),%eax
f0103989:	89 44 24 04          	mov    %eax,0x4(%esp)
f010398d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103990:	8b 40 5c             	mov    0x5c(%eax),%eax
f0103993:	89 04 24             	mov    %eax,(%esp)
f0103996:	e8 b4 dc ff ff       	call   f010164f <page_insert>
f010399b:	85 c0                	test   %eax,%eax
f010399d:	0f 9f c2             	setg   %dl
f01039a0:	0f b6 d2             	movzbl %dl,%edx
f01039a3:	83 ea 01             	sub    $0x1,%edx
f01039a6:	89 c6                	mov    %eax,%esi
f01039a8:	21 d6                	and    %edx,%esi
		return (int32_t)sys_page_insert((envid_t)a1, (void *)a2, (struct Page*)a3, (int)a4);
	}
	else
		return -E_INVAL;	
	
}
f01039aa:	89 f0                	mov    %esi,%eax
f01039ac:	83 c4 3c             	add    $0x3c,%esp
f01039af:	5b                   	pop    %ebx
f01039b0:	5e                   	pop    %esi
f01039b1:	5f                   	pop    %edi
f01039b2:	5d                   	pop    %ebp
f01039b3:	c3                   	ret    
	...

f01039c0 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f01039c0:	55                   	push   %ebp
f01039c1:	89 e5                	mov    %esp,%ebp
f01039c3:	57                   	push   %edi
f01039c4:	56                   	push   %esi
f01039c5:	53                   	push   %ebx
f01039c6:	83 ec 14             	sub    $0x14,%esp
f01039c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01039cc:	89 55 e8             	mov    %edx,-0x18(%ebp)
f01039cf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01039d2:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f01039d5:	8b 1a                	mov    (%edx),%ebx
f01039d7:	8b 01                	mov    (%ecx),%eax
f01039d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	while (l <= r) {
f01039dc:	39 c3                	cmp    %eax,%ebx
f01039de:	0f 8f 9c 00 00 00    	jg     f0103a80 <stab_binsearch+0xc0>
f01039e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		int true_m = (l + r) / 2, m = true_m;
f01039eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01039ee:	01 d8                	add    %ebx,%eax
f01039f0:	89 c7                	mov    %eax,%edi
f01039f2:	c1 ef 1f             	shr    $0x1f,%edi
f01039f5:	01 c7                	add    %eax,%edi
f01039f7:	d1 ff                	sar    %edi
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f01039f9:	39 df                	cmp    %ebx,%edi
f01039fb:	7c 33                	jl     f0103a30 <stab_binsearch+0x70>
f01039fd:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0103a00:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0103a03:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0103a08:	39 f0                	cmp    %esi,%eax
f0103a0a:	0f 84 bc 00 00 00    	je     f0103acc <stab_binsearch+0x10c>
f0103a10:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
f0103a14:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
f0103a18:	89 f8                	mov    %edi,%eax
			m--;
f0103a1a:	83 e8 01             	sub    $0x1,%eax
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0103a1d:	39 d8                	cmp    %ebx,%eax
f0103a1f:	7c 0f                	jl     f0103a30 <stab_binsearch+0x70>
f0103a21:	0f b6 0a             	movzbl (%edx),%ecx
f0103a24:	83 ea 0c             	sub    $0xc,%edx
f0103a27:	39 f1                	cmp    %esi,%ecx
f0103a29:	75 ef                	jne    f0103a1a <stab_binsearch+0x5a>
f0103a2b:	e9 9e 00 00 00       	jmp    f0103ace <stab_binsearch+0x10e>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0103a30:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0103a33:	eb 3c                	jmp    f0103a71 <stab_binsearch+0xb1>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0103a35:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0103a38:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
f0103a3a:	8d 5f 01             	lea    0x1(%edi),%ebx
f0103a3d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0103a44:	eb 2b                	jmp    f0103a71 <stab_binsearch+0xb1>
		} else if (stabs[m].n_value > addr) {
f0103a46:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0103a49:	76 14                	jbe    f0103a5f <stab_binsearch+0x9f>
			*region_right = m - 1;
f0103a4b:	83 e8 01             	sub    $0x1,%eax
f0103a4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0103a51:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103a54:	89 02                	mov    %eax,(%edx)
f0103a56:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0103a5d:	eb 12                	jmp    f0103a71 <stab_binsearch+0xb1>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0103a5f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0103a62:	89 01                	mov    %eax,(%ecx)
			l = m;
			addr++;
f0103a64:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0103a68:	89 c3                	mov    %eax,%ebx
f0103a6a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
	
	while (l <= r) {
f0103a71:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f0103a74:	0f 8d 71 ff ff ff    	jge    f01039eb <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0103a7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0103a7e:	75 0f                	jne    f0103a8f <stab_binsearch+0xcf>
		*region_right = *region_left - 1;
f0103a80:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0103a83:	8b 03                	mov    (%ebx),%eax
f0103a85:	83 e8 01             	sub    $0x1,%eax
f0103a88:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103a8b:	89 02                	mov    %eax,(%edx)
f0103a8d:	eb 57                	jmp    f0103ae6 <stab_binsearch+0x126>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0103a8f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103a92:	8b 01                	mov    (%ecx),%eax
		     l > *region_left && stabs[l].n_type != type;
f0103a94:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0103a97:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0103a99:	39 c1                	cmp    %eax,%ecx
f0103a9b:	7d 28                	jge    f0103ac5 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0103a9d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0103aa0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f0103aa3:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f0103aa8:	39 f2                	cmp    %esi,%edx
f0103aaa:	74 19                	je     f0103ac5 <stab_binsearch+0x105>
f0103aac:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
f0103ab0:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
		     l--)
f0103ab4:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0103ab7:	39 c1                	cmp    %eax,%ecx
f0103ab9:	7d 0a                	jge    f0103ac5 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f0103abb:	0f b6 1a             	movzbl (%edx),%ebx
f0103abe:	83 ea 0c             	sub    $0xc,%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0103ac1:	39 f3                	cmp    %esi,%ebx
f0103ac3:	75 ef                	jne    f0103ab4 <stab_binsearch+0xf4>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f0103ac5:	8b 55 e8             	mov    -0x18(%ebp),%edx
f0103ac8:	89 02                	mov    %eax,(%edx)
f0103aca:	eb 1a                	jmp    f0103ae6 <stab_binsearch+0x126>
	}
}
f0103acc:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0103ace:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0103ad1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0103ad4:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0103ad8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0103adb:	0f 82 54 ff ff ff    	jb     f0103a35 <stab_binsearch+0x75>
f0103ae1:	e9 60 ff ff ff       	jmp    f0103a46 <stab_binsearch+0x86>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0103ae6:	83 c4 14             	add    $0x14,%esp
f0103ae9:	5b                   	pop    %ebx
f0103aea:	5e                   	pop    %esi
f0103aeb:	5f                   	pop    %edi
f0103aec:	5d                   	pop    %ebp
f0103aed:	c3                   	ret    

f0103aee <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0103aee:	55                   	push   %ebp
f0103aef:	89 e5                	mov    %esp,%ebp
f0103af1:	83 ec 58             	sub    $0x58,%esp
f0103af4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0103af7:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0103afa:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0103afd:	8b 75 08             	mov    0x8(%ebp),%esi
f0103b00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0103b03:	c7 03 db 69 10 f0    	movl   $0xf01069db,(%ebx)
	info->eip_line = 0;
f0103b09:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0103b10:	c7 43 08 db 69 10 f0 	movl   $0xf01069db,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0103b17:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0103b1e:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0103b21:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0103b28:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0103b2e:	76 1f                	jbe    f0103b4f <debuginfo_eip+0x61>
f0103b30:	bf cc 45 11 f0       	mov    $0xf01145cc,%edi
f0103b35:	c7 45 c4 15 0b 11 f0 	movl   $0xf0110b15,-0x3c(%ebp)
f0103b3c:	c7 45 bc 14 0b 11 f0 	movl   $0xf0110b14,-0x44(%ebp)
f0103b43:	c7 45 c0 b0 6f 10 f0 	movl   $0xf0106fb0,-0x40(%ebp)
f0103b4a:	e9 a0 00 00 00       	jmp    f0103bef <debuginfo_eip+0x101>
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, (void*) usd, sizeof(struct UserStabData*), 4) < 0)
f0103b4f:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0103b56:	00 
f0103b57:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0103b5e:	00 
f0103b5f:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f0103b66:	00 
f0103b67:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103b6c:	89 04 24             	mov    %eax,(%esp)
f0103b6f:	e8 f6 d3 ff ff       	call   f0100f6a <user_mem_check>
f0103b74:	85 c0                	test   %eax,%eax
f0103b76:	0f 88 da 01 00 00    	js     f0103d56 <debuginfo_eip+0x268>
			return -1;

		stabs = usd->stabs;
f0103b7c:	b8 00 00 20 00       	mov    $0x200000,%eax
f0103b81:	8b 10                	mov    (%eax),%edx
f0103b83:	89 55 c0             	mov    %edx,-0x40(%ebp)
		stab_end = usd->stab_end;
f0103b86:	8b 48 04             	mov    0x4(%eax),%ecx
f0103b89:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stabstr = usd->stabstr;
f0103b8c:	8b 50 08             	mov    0x8(%eax),%edx
f0103b8f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
		stabstr_end = usd->stabstr_end;
f0103b92:	8b 78 0c             	mov    0xc(%eax),%edi

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if (user_mem_check(curenv, (void*) stabs, ((int)stab_end - (int)stabs), 4) < 0)
f0103b95:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0103b9c:	00 
f0103b9d:	89 c8                	mov    %ecx,%eax
f0103b9f:	2b 45 c0             	sub    -0x40(%ebp),%eax
f0103ba2:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103ba6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0103ba9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0103bad:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103bb2:	89 04 24             	mov    %eax,(%esp)
f0103bb5:	e8 b0 d3 ff ff       	call   f0100f6a <user_mem_check>
f0103bba:	85 c0                	test   %eax,%eax
f0103bbc:	0f 88 94 01 00 00    	js     f0103d56 <debuginfo_eip+0x268>
			return -1;
		if (user_mem_check(curenv, (void*) stabstr, ((int)stabstr_end - (int)stabstr), 4) < 0)
f0103bc2:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0103bc9:	00 
f0103bca:	89 f8                	mov    %edi,%eax
f0103bcc:	2b 45 c4             	sub    -0x3c(%ebp),%eax
f0103bcf:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103bd3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0103bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103bda:	a1 64 35 3c f0       	mov    0xf03c3564,%eax
f0103bdf:	89 04 24             	mov    %eax,(%esp)
f0103be2:	e8 83 d3 ff ff       	call   f0100f6a <user_mem_check>
f0103be7:	85 c0                	test   %eax,%eax
f0103be9:	0f 88 67 01 00 00    	js     f0103d56 <debuginfo_eip+0x268>
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0103bef:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
f0103bf2:	0f 83 5e 01 00 00    	jae    f0103d56 <debuginfo_eip+0x268>
f0103bf8:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
f0103bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0103c00:	0f 85 50 01 00 00    	jne    f0103d56 <debuginfo_eip+0x268>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0103c06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0103c0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0103c10:	2b 45 c0             	sub    -0x40(%ebp),%eax
f0103c13:	c1 f8 02             	sar    $0x2,%eax
f0103c16:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0103c1c:	83 e8 01             	sub    $0x1,%eax
f0103c1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0103c22:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0103c25:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0103c28:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103c2c:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0103c33:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103c36:	e8 85 fd ff ff       	call   f01039c0 <stab_binsearch>
	if (lfile == 0)
f0103c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103c3e:	85 c0                	test   %eax,%eax
f0103c40:	0f 84 10 01 00 00    	je     f0103d56 <debuginfo_eip+0x268>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0103c46:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0103c49:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103c4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0103c4f:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0103c52:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0103c55:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103c59:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0103c60:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103c63:	e8 58 fd ff ff       	call   f01039c0 <stab_binsearch>

	if (lfun <= rfun) {
f0103c68:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103c6b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0103c6e:	7f 35                	jg     f0103ca5 <debuginfo_eip+0x1b7>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0103c70:	6b c0 0c             	imul   $0xc,%eax,%eax
f0103c73:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0103c76:	8b 04 10             	mov    (%eax,%edx,1),%eax
f0103c79:	89 fa                	mov    %edi,%edx
f0103c7b:	2b 55 c4             	sub    -0x3c(%ebp),%edx
f0103c7e:	39 d0                	cmp    %edx,%eax
f0103c80:	73 06                	jae    f0103c88 <debuginfo_eip+0x19a>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0103c82:	03 45 c4             	add    -0x3c(%ebp),%eax
f0103c85:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0103c88:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103c8b:	6b c2 0c             	imul   $0xc,%edx,%eax
f0103c8e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0103c91:	8b 44 08 08          	mov    0x8(%eax,%ecx,1),%eax
f0103c95:	89 43 10             	mov    %eax,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0103c98:	29 c6                	sub    %eax,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0103c9a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		rline = rfun;
f0103c9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103ca0:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103ca3:	eb 0f                	jmp    f0103cb4 <debuginfo_eip+0x1c6>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0103ca5:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0103ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103cab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0103cae:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103cb1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0103cb4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0103cbb:	00 
f0103cbc:	8b 43 08             	mov    0x8(%ebx),%eax
f0103cbf:	89 04 24             	mov    %eax,(%esp)
f0103cc2:	e8 44 09 00 00       	call   f010460b <strfind>
f0103cc7:	2b 43 08             	sub    0x8(%ebx),%eax
f0103cca:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0103ccd:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0103cd0:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0103cd3:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103cd7:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0103cde:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0103ce1:	e8 da fc ff ff       	call   f01039c0 <stab_binsearch>
	if (rline == 0)
f0103ce6:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103ce9:	85 c0                	test   %eax,%eax
f0103ceb:	74 69                	je     f0103d56 <debuginfo_eip+0x268>
		return -1;	
	info->eip_line = rline;
f0103ced:	89 43 04             	mov    %eax,0x4(%ebx)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0103cf0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0103cf3:	eb 06                	jmp    f0103cfb <debuginfo_eip+0x20d>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0103cf5:	83 e8 01             	sub    $0x1,%eax
f0103cf8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0103cfb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0103cfe:	39 f0                	cmp    %esi,%eax
f0103d00:	7c 25                	jl     f0103d27 <debuginfo_eip+0x239>
	       && stabs[lline].n_type != N_SOL
f0103d02:	6b d0 0c             	imul   $0xc,%eax,%edx
f0103d05:	03 55 c0             	add    -0x40(%ebp),%edx
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0103d08:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0103d0c:	80 f9 84             	cmp    $0x84,%cl
f0103d0f:	74 5e                	je     f0103d6f <debuginfo_eip+0x281>
f0103d11:	80 f9 64             	cmp    $0x64,%cl
f0103d14:	75 df                	jne    f0103cf5 <debuginfo_eip+0x207>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0103d16:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
f0103d1a:	74 d9                	je     f0103cf5 <debuginfo_eip+0x207>
f0103d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0103d20:	eb 4d                	jmp    f0103d6f <debuginfo_eip+0x281>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;
f0103d22:	03 45 c4             	add    -0x3c(%ebp),%eax
f0103d25:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0103d27:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103d2a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0103d2d:	7d 2e                	jge    f0103d5d <debuginfo_eip+0x26f>
		for (lline = lfun + 1;
f0103d2f:	83 c0 01             	add    $0x1,%eax
f0103d32:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0103d35:	eb 08                	jmp    f0103d3f <debuginfo_eip+0x251>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0103d37:	83 43 14 01          	addl   $0x1,0x14(%ebx)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0103d3b:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0103d3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0103d42:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0103d45:	7d 16                	jge    f0103d5d <debuginfo_eip+0x26f>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0103d47:	6b c0 0c             	imul   $0xc,%eax,%eax
f0103d4a:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0103d4d:	80 7c 10 04 a0       	cmpb   $0xa0,0x4(%eax,%edx,1)
f0103d52:	74 e3                	je     f0103d37 <debuginfo_eip+0x249>
f0103d54:	eb 07                	jmp    f0103d5d <debuginfo_eip+0x26f>
f0103d56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103d5b:	eb 05                	jmp    f0103d62 <debuginfo_eip+0x274>
f0103d5d:	b8 00 00 00 00       	mov    $0x0,%eax
		     lline++)
			info->eip_fn_narg++;
	
	return 0;
}
f0103d62:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0103d65:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0103d68:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0103d6b:	89 ec                	mov    %ebp,%esp
f0103d6d:	5d                   	pop    %ebp
f0103d6e:	c3                   	ret    
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0103d6f:	6b c0 0c             	imul   $0xc,%eax,%eax
f0103d72:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0103d75:	8b 04 08             	mov    (%eax,%ecx,1),%eax
f0103d78:	2b 7d c4             	sub    -0x3c(%ebp),%edi
f0103d7b:	39 f8                	cmp    %edi,%eax
f0103d7d:	72 a3                	jb     f0103d22 <debuginfo_eip+0x234>
f0103d7f:	eb a6                	jmp    f0103d27 <debuginfo_eip+0x239>
	...

f0103d90 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0103d90:	55                   	push   %ebp
f0103d91:	89 e5                	mov    %esp,%ebp
f0103d93:	57                   	push   %edi
f0103d94:	56                   	push   %esi
f0103d95:	53                   	push   %ebx
f0103d96:	83 ec 4c             	sub    $0x4c,%esp
f0103d99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0103d9c:	89 d6                	mov    %edx,%esi
f0103d9e:	8b 45 08             	mov    0x8(%ebp),%eax
f0103da1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103da4:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103da7:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0103daa:	8b 45 10             	mov    0x10(%ebp),%eax
f0103dad:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0103db0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0103db3:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103db6:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103dbb:	39 d1                	cmp    %edx,%ecx
f0103dbd:	72 15                	jb     f0103dd4 <printnum+0x44>
f0103dbf:	77 07                	ja     f0103dc8 <printnum+0x38>
f0103dc1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103dc4:	39 d0                	cmp    %edx,%eax
f0103dc6:	76 0c                	jbe    f0103dd4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0103dc8:	83 eb 01             	sub    $0x1,%ebx
f0103dcb:	85 db                	test   %ebx,%ebx
f0103dcd:	8d 76 00             	lea    0x0(%esi),%esi
f0103dd0:	7f 61                	jg     f0103e33 <printnum+0xa3>
f0103dd2:	eb 70                	jmp    f0103e44 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0103dd4:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0103dd8:	83 eb 01             	sub    $0x1,%ebx
f0103ddb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0103ddf:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103de3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0103de7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
f0103deb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0103dee:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0103df1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0103df4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0103df8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0103dff:	00 
f0103e00:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103e03:	89 04 24             	mov    %eax,(%esp)
f0103e06:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103e09:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103e0d:	e8 fe 16 00 00       	call   f0105510 <__udivdi3>
f0103e12:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0103e15:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0103e18:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0103e1c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0103e20:	89 04 24             	mov    %eax,(%esp)
f0103e23:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103e27:	89 f2                	mov    %esi,%edx
f0103e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103e2c:	e8 5f ff ff ff       	call   f0103d90 <printnum>
f0103e31:	eb 11                	jmp    f0103e44 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0103e33:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103e37:	89 3c 24             	mov    %edi,(%esp)
f0103e3a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0103e3d:	83 eb 01             	sub    $0x1,%ebx
f0103e40:	85 db                	test   %ebx,%ebx
f0103e42:	7f ef                	jg     f0103e33 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0103e44:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103e48:	8b 74 24 04          	mov    0x4(%esp),%esi
f0103e4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103e4f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103e53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0103e5a:	00 
f0103e5b:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103e5e:	89 14 24             	mov    %edx,(%esp)
f0103e61:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103e64:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0103e68:	e8 d3 17 00 00       	call   f0105640 <__umoddi3>
f0103e6d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103e71:	0f be 80 e5 69 10 f0 	movsbl -0xfef961b(%eax),%eax
f0103e78:	89 04 24             	mov    %eax,(%esp)
f0103e7b:	ff 55 e4             	call   *-0x1c(%ebp)
}
f0103e7e:	83 c4 4c             	add    $0x4c,%esp
f0103e81:	5b                   	pop    %ebx
f0103e82:	5e                   	pop    %esi
f0103e83:	5f                   	pop    %edi
f0103e84:	5d                   	pop    %ebp
f0103e85:	c3                   	ret    

f0103e86 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0103e86:	55                   	push   %ebp
f0103e87:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0103e89:	83 fa 01             	cmp    $0x1,%edx
f0103e8c:	7e 0e                	jle    f0103e9c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f0103e8e:	8b 10                	mov    (%eax),%edx
f0103e90:	8d 4a 08             	lea    0x8(%edx),%ecx
f0103e93:	89 08                	mov    %ecx,(%eax)
f0103e95:	8b 02                	mov    (%edx),%eax
f0103e97:	8b 52 04             	mov    0x4(%edx),%edx
f0103e9a:	eb 22                	jmp    f0103ebe <getuint+0x38>
	else if (lflag)
f0103e9c:	85 d2                	test   %edx,%edx
f0103e9e:	74 10                	je     f0103eb0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0103ea0:	8b 10                	mov    (%eax),%edx
f0103ea2:	8d 4a 04             	lea    0x4(%edx),%ecx
f0103ea5:	89 08                	mov    %ecx,(%eax)
f0103ea7:	8b 02                	mov    (%edx),%eax
f0103ea9:	ba 00 00 00 00       	mov    $0x0,%edx
f0103eae:	eb 0e                	jmp    f0103ebe <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0103eb0:	8b 10                	mov    (%eax),%edx
f0103eb2:	8d 4a 04             	lea    0x4(%edx),%ecx
f0103eb5:	89 08                	mov    %ecx,(%eax)
f0103eb7:	8b 02                	mov    (%edx),%eax
f0103eb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103ebe:	5d                   	pop    %ebp
f0103ebf:	c3                   	ret    

f0103ec0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0103ec0:	55                   	push   %ebp
f0103ec1:	89 e5                	mov    %esp,%ebp
f0103ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0103ec6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0103eca:	8b 10                	mov    (%eax),%edx
f0103ecc:	3b 50 04             	cmp    0x4(%eax),%edx
f0103ecf:	73 0a                	jae    f0103edb <sprintputch+0x1b>
		*b->buf++ = ch;
f0103ed1:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103ed4:	88 0a                	mov    %cl,(%edx)
f0103ed6:	83 c2 01             	add    $0x1,%edx
f0103ed9:	89 10                	mov    %edx,(%eax)
}
f0103edb:	5d                   	pop    %ebp
f0103edc:	c3                   	ret    

f0103edd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0103edd:	55                   	push   %ebp
f0103ede:	89 e5                	mov    %esp,%ebp
f0103ee0:	57                   	push   %edi
f0103ee1:	56                   	push   %esi
f0103ee2:	53                   	push   %ebx
f0103ee3:	83 ec 5c             	sub    $0x5c,%esp
f0103ee6:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103ee9:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f0103eef:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f0103ef6:	eb 11                	jmp    f0103f09 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0103ef8:	85 c0                	test   %eax,%eax
f0103efa:	0f 84 ec 03 00 00    	je     f01042ec <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
f0103f00:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103f04:	89 04 24             	mov    %eax,(%esp)
f0103f07:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0103f09:	0f b6 03             	movzbl (%ebx),%eax
f0103f0c:	83 c3 01             	add    $0x1,%ebx
f0103f0f:	83 f8 25             	cmp    $0x25,%eax
f0103f12:	75 e4                	jne    f0103ef8 <vprintfmt+0x1b>
f0103f14:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
f0103f18:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0103f1f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0103f26:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f0103f2d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103f32:	eb 06                	jmp    f0103f3a <vprintfmt+0x5d>
f0103f34:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0103f38:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0103f3a:	0f b6 13             	movzbl (%ebx),%edx
f0103f3d:	0f b6 c2             	movzbl %dl,%eax
f0103f40:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0103f43:	8d 43 01             	lea    0x1(%ebx),%eax
f0103f46:	83 ea 23             	sub    $0x23,%edx
f0103f49:	80 fa 55             	cmp    $0x55,%dl
f0103f4c:	0f 87 7d 03 00 00    	ja     f01042cf <vprintfmt+0x3f2>
f0103f52:	0f b6 d2             	movzbl %dl,%edx
f0103f55:	ff 24 95 20 6b 10 f0 	jmp    *-0xfef94e0(,%edx,4)
f0103f5c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0103f60:	eb d6                	jmp    f0103f38 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0103f62:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0103f65:	83 ea 30             	sub    $0x30,%edx
f0103f68:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
f0103f6b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
f0103f6e:	8d 5a d0             	lea    -0x30(%edx),%ebx
f0103f71:	83 fb 09             	cmp    $0x9,%ebx
f0103f74:	77 4c                	ja     f0103fc2 <vprintfmt+0xe5>
f0103f76:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0103f79:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0103f7c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
f0103f7f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
f0103f82:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
f0103f86:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
f0103f89:	8d 5a d0             	lea    -0x30(%edx),%ebx
f0103f8c:	83 fb 09             	cmp    $0x9,%ebx
f0103f8f:	76 eb                	jbe    f0103f7c <vprintfmt+0x9f>
f0103f91:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0103f94:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103f97:	eb 29                	jmp    f0103fc2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0103f99:	8b 55 14             	mov    0x14(%ebp),%edx
f0103f9c:	8d 5a 04             	lea    0x4(%edx),%ebx
f0103f9f:	89 5d 14             	mov    %ebx,0x14(%ebp)
f0103fa2:	8b 12                	mov    (%edx),%edx
f0103fa4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
f0103fa7:	eb 19                	jmp    f0103fc2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
f0103fa9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103fac:	c1 fa 1f             	sar    $0x1f,%edx
f0103faf:	f7 d2                	not    %edx
f0103fb1:	21 55 e4             	and    %edx,-0x1c(%ebp)
f0103fb4:	eb 82                	jmp    f0103f38 <vprintfmt+0x5b>
f0103fb6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
f0103fbd:	e9 76 ff ff ff       	jmp    f0103f38 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
f0103fc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0103fc6:	0f 89 6c ff ff ff    	jns    f0103f38 <vprintfmt+0x5b>
f0103fcc:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0103fcf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0103fd2:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0103fd5:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0103fd8:	e9 5b ff ff ff       	jmp    f0103f38 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0103fdd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
f0103fe0:	e9 53 ff ff ff       	jmp    f0103f38 <vprintfmt+0x5b>
f0103fe5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0103fe8:	8b 45 14             	mov    0x14(%ebp),%eax
f0103feb:	8d 50 04             	lea    0x4(%eax),%edx
f0103fee:	89 55 14             	mov    %edx,0x14(%ebp)
f0103ff1:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103ff5:	8b 00                	mov    (%eax),%eax
f0103ff7:	89 04 24             	mov    %eax,(%esp)
f0103ffa:	ff d7                	call   *%edi
f0103ffc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f0103fff:	e9 05 ff ff ff       	jmp    f0103f09 <vprintfmt+0x2c>
f0104004:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
f0104007:	8b 45 14             	mov    0x14(%ebp),%eax
f010400a:	8d 50 04             	lea    0x4(%eax),%edx
f010400d:	89 55 14             	mov    %edx,0x14(%ebp)
f0104010:	8b 00                	mov    (%eax),%eax
f0104012:	89 c2                	mov    %eax,%edx
f0104014:	c1 fa 1f             	sar    $0x1f,%edx
f0104017:	31 d0                	xor    %edx,%eax
f0104019:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
f010401b:	83 f8 0f             	cmp    $0xf,%eax
f010401e:	7f 0b                	jg     f010402b <vprintfmt+0x14e>
f0104020:	8b 14 85 80 6c 10 f0 	mov    -0xfef9380(,%eax,4),%edx
f0104027:	85 d2                	test   %edx,%edx
f0104029:	75 20                	jne    f010404b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
f010402b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010402f:	c7 44 24 08 f6 69 10 	movl   $0xf01069f6,0x8(%esp)
f0104036:	f0 
f0104037:	89 74 24 04          	mov    %esi,0x4(%esp)
f010403b:	89 3c 24             	mov    %edi,(%esp)
f010403e:	e8 31 03 00 00       	call   f0104374 <printfmt>
f0104043:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
f0104046:	e9 be fe ff ff       	jmp    f0103f09 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f010404b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010404f:	c7 44 24 08 19 63 10 	movl   $0xf0106319,0x8(%esp)
f0104056:	f0 
f0104057:	89 74 24 04          	mov    %esi,0x4(%esp)
f010405b:	89 3c 24             	mov    %edi,(%esp)
f010405e:	e8 11 03 00 00       	call   f0104374 <printfmt>
f0104063:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0104066:	e9 9e fe ff ff       	jmp    f0103f09 <vprintfmt+0x2c>
f010406b:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010406e:	89 c3                	mov    %eax,%ebx
f0104070:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104076:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0104079:	8b 45 14             	mov    0x14(%ebp),%eax
f010407c:	8d 50 04             	lea    0x4(%eax),%edx
f010407f:	89 55 14             	mov    %edx,0x14(%ebp)
f0104082:	8b 00                	mov    (%eax),%eax
f0104084:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104087:	85 c0                	test   %eax,%eax
f0104089:	75 07                	jne    f0104092 <vprintfmt+0x1b5>
f010408b:	c7 45 e0 ff 69 10 f0 	movl   $0xf01069ff,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
f0104092:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
f0104096:	7e 06                	jle    f010409e <vprintfmt+0x1c1>
f0104098:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f010409c:	75 13                	jne    f01040b1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010409e:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01040a1:	0f be 02             	movsbl (%edx),%eax
f01040a4:	85 c0                	test   %eax,%eax
f01040a6:	0f 85 99 00 00 00    	jne    f0104145 <vprintfmt+0x268>
f01040ac:	e9 86 00 00 00       	jmp    f0104137 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01040b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01040b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01040b8:	89 0c 24             	mov    %ecx,(%esp)
f01040bb:	e8 eb 03 00 00       	call   f01044ab <strnlen>
f01040c0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01040c3:	29 c2                	sub    %eax,%edx
f01040c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01040c8:	85 d2                	test   %edx,%edx
f01040ca:	7e d2                	jle    f010409e <vprintfmt+0x1c1>
					putch(padc, putdat);
f01040cc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
f01040d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f01040d3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
f01040d6:	89 d3                	mov    %edx,%ebx
f01040d8:	89 74 24 04          	mov    %esi,0x4(%esp)
f01040dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01040df:	89 04 24             	mov    %eax,(%esp)
f01040e2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01040e4:	83 eb 01             	sub    $0x1,%ebx
f01040e7:	85 db                	test   %ebx,%ebx
f01040e9:	7f ed                	jg     f01040d8 <vprintfmt+0x1fb>
f01040eb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f01040ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01040f5:	eb a7                	jmp    f010409e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01040f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01040fb:	74 18                	je     f0104115 <vprintfmt+0x238>
f01040fd:	8d 50 e0             	lea    -0x20(%eax),%edx
f0104100:	83 fa 5e             	cmp    $0x5e,%edx
f0104103:	76 10                	jbe    f0104115 <vprintfmt+0x238>
					putch('?', putdat);
f0104105:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104109:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f0104110:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0104113:	eb 0a                	jmp    f010411f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
f0104115:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104119:	89 04 24             	mov    %eax,(%esp)
f010411c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010411f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0104123:	0f be 03             	movsbl (%ebx),%eax
f0104126:	85 c0                	test   %eax,%eax
f0104128:	74 05                	je     f010412f <vprintfmt+0x252>
f010412a:	83 c3 01             	add    $0x1,%ebx
f010412d:	eb 29                	jmp    f0104158 <vprintfmt+0x27b>
f010412f:	89 fe                	mov    %edi,%esi
f0104131:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104134:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0104137:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010413b:	7f 2e                	jg     f010416b <vprintfmt+0x28e>
f010413d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0104140:	e9 c4 fd ff ff       	jmp    f0103f09 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104145:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104148:	83 c2 01             	add    $0x1,%edx
f010414b:	89 7d e0             	mov    %edi,-0x20(%ebp)
f010414e:	89 f7                	mov    %esi,%edi
f0104150:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0104153:	89 5d d0             	mov    %ebx,-0x30(%ebp)
f0104156:	89 d3                	mov    %edx,%ebx
f0104158:	85 f6                	test   %esi,%esi
f010415a:	78 9b                	js     f01040f7 <vprintfmt+0x21a>
f010415c:	83 ee 01             	sub    $0x1,%esi
f010415f:	79 96                	jns    f01040f7 <vprintfmt+0x21a>
f0104161:	89 fe                	mov    %edi,%esi
f0104163:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104166:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0104169:	eb cc                	jmp    f0104137 <vprintfmt+0x25a>
f010416b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
f010416e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0104171:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104175:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f010417c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f010417e:	83 eb 01             	sub    $0x1,%ebx
f0104181:	85 db                	test   %ebx,%ebx
f0104183:	7f ec                	jg     f0104171 <vprintfmt+0x294>
f0104185:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f0104188:	e9 7c fd ff ff       	jmp    f0103f09 <vprintfmt+0x2c>
f010418d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0104190:	83 f9 01             	cmp    $0x1,%ecx
f0104193:	7e 16                	jle    f01041ab <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
f0104195:	8b 45 14             	mov    0x14(%ebp),%eax
f0104198:	8d 50 08             	lea    0x8(%eax),%edx
f010419b:	89 55 14             	mov    %edx,0x14(%ebp)
f010419e:	8b 10                	mov    (%eax),%edx
f01041a0:	8b 48 04             	mov    0x4(%eax),%ecx
f01041a3:	89 55 d8             	mov    %edx,-0x28(%ebp)
f01041a6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01041a9:	eb 32                	jmp    f01041dd <vprintfmt+0x300>
	else if (lflag)
f01041ab:	85 c9                	test   %ecx,%ecx
f01041ad:	74 18                	je     f01041c7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
f01041af:	8b 45 14             	mov    0x14(%ebp),%eax
f01041b2:	8d 50 04             	lea    0x4(%eax),%edx
f01041b5:	89 55 14             	mov    %edx,0x14(%ebp)
f01041b8:	8b 00                	mov    (%eax),%eax
f01041ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01041bd:	89 c1                	mov    %eax,%ecx
f01041bf:	c1 f9 1f             	sar    $0x1f,%ecx
f01041c2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01041c5:	eb 16                	jmp    f01041dd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
f01041c7:	8b 45 14             	mov    0x14(%ebp),%eax
f01041ca:	8d 50 04             	lea    0x4(%eax),%edx
f01041cd:	89 55 14             	mov    %edx,0x14(%ebp)
f01041d0:	8b 00                	mov    (%eax),%eax
f01041d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01041d5:	89 c2                	mov    %eax,%edx
f01041d7:	c1 fa 1f             	sar    $0x1f,%edx
f01041da:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f01041dd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f01041e0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f01041e3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f01041e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01041ec:	0f 89 9b 00 00 00    	jns    f010428d <vprintfmt+0x3b0>
				putch('-', putdat);
f01041f2:	89 74 24 04          	mov    %esi,0x4(%esp)
f01041f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01041fd:	ff d7                	call   *%edi
				num = -(long long) num;
f01041ff:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0104202:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0104205:	f7 d9                	neg    %ecx
f0104207:	83 d3 00             	adc    $0x0,%ebx
f010420a:	f7 db                	neg    %ebx
f010420c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104211:	eb 7a                	jmp    f010428d <vprintfmt+0x3b0>
f0104213:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0104216:	89 ca                	mov    %ecx,%edx
f0104218:	8d 45 14             	lea    0x14(%ebp),%eax
f010421b:	e8 66 fc ff ff       	call   f0103e86 <getuint>
f0104220:	89 c1                	mov    %eax,%ecx
f0104222:	89 d3                	mov    %edx,%ebx
f0104224:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
f0104229:	eb 62                	jmp    f010428d <vprintfmt+0x3b0>
f010422b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
f010422e:	89 ca                	mov    %ecx,%edx
f0104230:	8d 45 14             	lea    0x14(%ebp),%eax
f0104233:	e8 4e fc ff ff       	call   f0103e86 <getuint>
f0104238:	89 c1                	mov    %eax,%ecx
f010423a:	89 d3                	mov    %edx,%ebx
f010423c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
f0104241:	eb 4a                	jmp    f010428d <vprintfmt+0x3b0>
f0104243:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
f0104246:	89 74 24 04          	mov    %esi,0x4(%esp)
f010424a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0104251:	ff d7                	call   *%edi
			putch('x', putdat);
f0104253:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104257:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f010425e:	ff d7                	call   *%edi
			num = (unsigned long long)
f0104260:	8b 45 14             	mov    0x14(%ebp),%eax
f0104263:	8d 50 04             	lea    0x4(%eax),%edx
f0104266:	89 55 14             	mov    %edx,0x14(%ebp)
f0104269:	8b 08                	mov    (%eax),%ecx
f010426b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104270:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f0104275:	eb 16                	jmp    f010428d <vprintfmt+0x3b0>
f0104277:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f010427a:	89 ca                	mov    %ecx,%edx
f010427c:	8d 45 14             	lea    0x14(%ebp),%eax
f010427f:	e8 02 fc ff ff       	call   f0103e86 <getuint>
f0104284:	89 c1                	mov    %eax,%ecx
f0104286:	89 d3                	mov    %edx,%ebx
f0104288:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
f010428d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
f0104291:	89 54 24 10          	mov    %edx,0x10(%esp)
f0104295:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104298:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010429c:	89 44 24 08          	mov    %eax,0x8(%esp)
f01042a0:	89 0c 24             	mov    %ecx,(%esp)
f01042a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01042a7:	89 f2                	mov    %esi,%edx
f01042a9:	89 f8                	mov    %edi,%eax
f01042ab:	e8 e0 fa ff ff       	call   f0103d90 <printnum>
f01042b0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01042b3:	e9 51 fc ff ff       	jmp    f0103f09 <vprintfmt+0x2c>
f01042b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01042bb:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f01042be:	89 74 24 04          	mov    %esi,0x4(%esp)
f01042c2:	89 14 24             	mov    %edx,(%esp)
f01042c5:	ff d7                	call   *%edi
f01042c7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
f01042ca:	e9 3a fc ff ff       	jmp    f0103f09 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f01042cf:	89 74 24 04          	mov    %esi,0x4(%esp)
f01042d3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f01042da:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01042dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01042df:	80 38 25             	cmpb   $0x25,(%eax)
f01042e2:	0f 84 21 fc ff ff    	je     f0103f09 <vprintfmt+0x2c>
f01042e8:	89 c3                	mov    %eax,%ebx
f01042ea:	eb f0                	jmp    f01042dc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
f01042ec:	83 c4 5c             	add    $0x5c,%esp
f01042ef:	5b                   	pop    %ebx
f01042f0:	5e                   	pop    %esi
f01042f1:	5f                   	pop    %edi
f01042f2:	5d                   	pop    %ebp
f01042f3:	c3                   	ret    

f01042f4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01042f4:	55                   	push   %ebp
f01042f5:	89 e5                	mov    %esp,%ebp
f01042f7:	83 ec 28             	sub    $0x28,%esp
f01042fa:	8b 45 08             	mov    0x8(%ebp),%eax
f01042fd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
f0104300:	85 c0                	test   %eax,%eax
f0104302:	74 04                	je     f0104308 <vsnprintf+0x14>
f0104304:	85 d2                	test   %edx,%edx
f0104306:	7f 07                	jg     f010430f <vsnprintf+0x1b>
f0104308:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010430d:	eb 3b                	jmp    f010434a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
f010430f:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104312:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f0104316:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104319:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0104320:	8b 45 14             	mov    0x14(%ebp),%eax
f0104323:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104327:	8b 45 10             	mov    0x10(%ebp),%eax
f010432a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010432e:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0104331:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104335:	c7 04 24 c0 3e 10 f0 	movl   $0xf0103ec0,(%esp)
f010433c:	e8 9c fb ff ff       	call   f0103edd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0104341:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104344:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f010434a:	c9                   	leave  
f010434b:	c3                   	ret    

f010434c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010434c:	55                   	push   %ebp
f010434d:	89 e5                	mov    %esp,%ebp
f010434f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
f0104352:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
f0104355:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104359:	8b 45 10             	mov    0x10(%ebp),%eax
f010435c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104360:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104363:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104367:	8b 45 08             	mov    0x8(%ebp),%eax
f010436a:	89 04 24             	mov    %eax,(%esp)
f010436d:	e8 82 ff ff ff       	call   f01042f4 <vsnprintf>
	va_end(ap);

	return rc;
}
f0104372:	c9                   	leave  
f0104373:	c3                   	ret    

f0104374 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0104374:	55                   	push   %ebp
f0104375:	89 e5                	mov    %esp,%ebp
f0104377:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
f010437a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
f010437d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104381:	8b 45 10             	mov    0x10(%ebp),%eax
f0104384:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104388:	8b 45 0c             	mov    0xc(%ebp),%eax
f010438b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010438f:	8b 45 08             	mov    0x8(%ebp),%eax
f0104392:	89 04 24             	mov    %eax,(%esp)
f0104395:	e8 43 fb ff ff       	call   f0103edd <vprintfmt>
	va_end(ap);
}
f010439a:	c9                   	leave  
f010439b:	c3                   	ret    
f010439c:	00 00                	add    %al,(%eax)
	...

f01043a0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01043a0:	55                   	push   %ebp
f01043a1:	89 e5                	mov    %esp,%ebp
f01043a3:	57                   	push   %edi
f01043a4:	56                   	push   %esi
f01043a5:	53                   	push   %ebx
f01043a6:	83 ec 1c             	sub    $0x1c,%esp
f01043a9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f01043ac:	85 c0                	test   %eax,%eax
f01043ae:	74 10                	je     f01043c0 <readline+0x20>
		cprintf("%s", prompt);
f01043b0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01043b4:	c7 04 24 19 63 10 f0 	movl   $0xf0106319,(%esp)
f01043bb:	e8 a7 e5 ff ff       	call   f0102967 <cprintf>
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f01043c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01043c7:	e8 ea be ff ff       	call   f01002b6 <iscons>
f01043cc:	89 c7                	mov    %eax,%edi
f01043ce:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
f01043d3:	e8 cd be ff ff       	call   f01002a5 <getchar>
f01043d8:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01043da:	85 c0                	test   %eax,%eax
f01043dc:	79 25                	jns    f0104403 <readline+0x63>
			if (c != -E_EOF)
f01043de:	b8 00 00 00 00       	mov    $0x0,%eax
f01043e3:	83 fb f8             	cmp    $0xfffffff8,%ebx
f01043e6:	0f 84 96 00 00 00    	je     f0104482 <readline+0xe2>
				cprintf("read error: %e\n", c);
f01043ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01043f0:	c7 04 24 df 6c 10 f0 	movl   $0xf0106cdf,(%esp)
f01043f7:	e8 6b e5 ff ff       	call   f0102967 <cprintf>
f01043fc:	b8 00 00 00 00       	mov    $0x0,%eax
f0104401:	eb 7f                	jmp    f0104482 <readline+0xe2>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0104403:	83 f8 08             	cmp    $0x8,%eax
f0104406:	74 0a                	je     f0104412 <readline+0x72>
f0104408:	83 f8 7f             	cmp    $0x7f,%eax
f010440b:	90                   	nop
f010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104410:	75 19                	jne    f010442b <readline+0x8b>
f0104412:	85 f6                	test   %esi,%esi
f0104414:	7e 15                	jle    f010442b <readline+0x8b>
			if (echoing)
f0104416:	85 ff                	test   %edi,%edi
f0104418:	74 0c                	je     f0104426 <readline+0x86>
				cputchar('\b');
f010441a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0104421:	e8 94 c0 ff ff       	call   f01004ba <cputchar>
			i--;
f0104426:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0104429:	eb a8                	jmp    f01043d3 <readline+0x33>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
f010442b:	83 fb 1f             	cmp    $0x1f,%ebx
f010442e:	66 90                	xchg   %ax,%ax
f0104430:	7e 26                	jle    f0104458 <readline+0xb8>
f0104432:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0104438:	7f 1e                	jg     f0104458 <readline+0xb8>
			if (echoing)
f010443a:	85 ff                	test   %edi,%edi
f010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104440:	74 08                	je     f010444a <readline+0xaa>
				cputchar(c);
f0104442:	89 1c 24             	mov    %ebx,(%esp)
f0104445:	e8 70 c0 ff ff       	call   f01004ba <cputchar>
			buf[i++] = c;
f010444a:	88 9e 00 3e 3c f0    	mov    %bl,-0xfc3c200(%esi)
f0104450:	83 c6 01             	add    $0x1,%esi
f0104453:	e9 7b ff ff ff       	jmp    f01043d3 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0104458:	83 fb 0a             	cmp    $0xa,%ebx
f010445b:	74 09                	je     f0104466 <readline+0xc6>
f010445d:	83 fb 0d             	cmp    $0xd,%ebx
f0104460:	0f 85 6d ff ff ff    	jne    f01043d3 <readline+0x33>
			if (echoing)
f0104466:	85 ff                	test   %edi,%edi
f0104468:	74 0c                	je     f0104476 <readline+0xd6>
				cputchar('\n');
f010446a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f0104471:	e8 44 c0 ff ff       	call   f01004ba <cputchar>
			buf[i] = 0;
f0104476:	c6 86 00 3e 3c f0 00 	movb   $0x0,-0xfc3c200(%esi)
f010447d:	b8 00 3e 3c f0       	mov    $0xf03c3e00,%eax
			return buf;
		}
	}
}
f0104482:	83 c4 1c             	add    $0x1c,%esp
f0104485:	5b                   	pop    %ebx
f0104486:	5e                   	pop    %esi
f0104487:	5f                   	pop    %edi
f0104488:	5d                   	pop    %ebp
f0104489:	c3                   	ret    
f010448a:	00 00                	add    %al,(%eax)
f010448c:	00 00                	add    %al,(%eax)
	...

f0104490 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0104490:	55                   	push   %ebp
f0104491:	89 e5                	mov    %esp,%ebp
f0104493:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0104496:	b8 00 00 00 00       	mov    $0x0,%eax
f010449b:	80 3a 00             	cmpb   $0x0,(%edx)
f010449e:	74 09                	je     f01044a9 <strlen+0x19>
		n++;
f01044a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f01044a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01044a7:	75 f7                	jne    f01044a0 <strlen+0x10>
		n++;
	return n;
}
f01044a9:	5d                   	pop    %ebp
f01044aa:	c3                   	ret    

f01044ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01044ab:	55                   	push   %ebp
f01044ac:	89 e5                	mov    %esp,%ebp
f01044ae:	53                   	push   %ebx
f01044af:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01044b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01044b5:	85 c9                	test   %ecx,%ecx
f01044b7:	74 19                	je     f01044d2 <strnlen+0x27>
f01044b9:	80 3b 00             	cmpb   $0x0,(%ebx)
f01044bc:	74 14                	je     f01044d2 <strnlen+0x27>
f01044be:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
f01044c3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01044c6:	39 c8                	cmp    %ecx,%eax
f01044c8:	74 0d                	je     f01044d7 <strnlen+0x2c>
f01044ca:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f01044ce:	75 f3                	jne    f01044c3 <strnlen+0x18>
f01044d0:	eb 05                	jmp    f01044d7 <strnlen+0x2c>
f01044d2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f01044d7:	5b                   	pop    %ebx
f01044d8:	5d                   	pop    %ebp
f01044d9:	c3                   	ret    

f01044da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01044da:	55                   	push   %ebp
f01044db:	89 e5                	mov    %esp,%ebp
f01044dd:	53                   	push   %ebx
f01044de:	8b 45 08             	mov    0x8(%ebp),%eax
f01044e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01044e4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f01044e9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f01044ed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f01044f0:	83 c2 01             	add    $0x1,%edx
f01044f3:	84 c9                	test   %cl,%cl
f01044f5:	75 f2                	jne    f01044e9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f01044f7:	5b                   	pop    %ebx
f01044f8:	5d                   	pop    %ebp
f01044f9:	c3                   	ret    

f01044fa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01044fa:	55                   	push   %ebp
f01044fb:	89 e5                	mov    %esp,%ebp
f01044fd:	56                   	push   %esi
f01044fe:	53                   	push   %ebx
f01044ff:	8b 45 08             	mov    0x8(%ebp),%eax
f0104502:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104505:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0104508:	85 f6                	test   %esi,%esi
f010450a:	74 18                	je     f0104524 <strncpy+0x2a>
f010450c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f0104511:	0f b6 1a             	movzbl (%edx),%ebx
f0104514:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0104517:	80 3a 01             	cmpb   $0x1,(%edx)
f010451a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f010451d:	83 c1 01             	add    $0x1,%ecx
f0104520:	39 ce                	cmp    %ecx,%esi
f0104522:	77 ed                	ja     f0104511 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0104524:	5b                   	pop    %ebx
f0104525:	5e                   	pop    %esi
f0104526:	5d                   	pop    %ebp
f0104527:	c3                   	ret    

f0104528 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0104528:	55                   	push   %ebp
f0104529:	89 e5                	mov    %esp,%ebp
f010452b:	56                   	push   %esi
f010452c:	53                   	push   %ebx
f010452d:	8b 75 08             	mov    0x8(%ebp),%esi
f0104530:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104533:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0104536:	89 f0                	mov    %esi,%eax
f0104538:	85 c9                	test   %ecx,%ecx
f010453a:	74 27                	je     f0104563 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
f010453c:	83 e9 01             	sub    $0x1,%ecx
f010453f:	74 1d                	je     f010455e <strlcpy+0x36>
f0104541:	0f b6 1a             	movzbl (%edx),%ebx
f0104544:	84 db                	test   %bl,%bl
f0104546:	74 16                	je     f010455e <strlcpy+0x36>
			*dst++ = *src++;
f0104548:	88 18                	mov    %bl,(%eax)
f010454a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f010454d:	83 e9 01             	sub    $0x1,%ecx
f0104550:	74 0e                	je     f0104560 <strlcpy+0x38>
			*dst++ = *src++;
f0104552:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0104555:	0f b6 1a             	movzbl (%edx),%ebx
f0104558:	84 db                	test   %bl,%bl
f010455a:	75 ec                	jne    f0104548 <strlcpy+0x20>
f010455c:	eb 02                	jmp    f0104560 <strlcpy+0x38>
f010455e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
f0104560:	c6 00 00             	movb   $0x0,(%eax)
f0104563:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
f0104565:	5b                   	pop    %ebx
f0104566:	5e                   	pop    %esi
f0104567:	5d                   	pop    %ebp
f0104568:	c3                   	ret    

f0104569 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0104569:	55                   	push   %ebp
f010456a:	89 e5                	mov    %esp,%ebp
f010456c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010456f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0104572:	0f b6 01             	movzbl (%ecx),%eax
f0104575:	84 c0                	test   %al,%al
f0104577:	74 15                	je     f010458e <strcmp+0x25>
f0104579:	3a 02                	cmp    (%edx),%al
f010457b:	75 11                	jne    f010458e <strcmp+0x25>
		p++, q++;
f010457d:	83 c1 01             	add    $0x1,%ecx
f0104580:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0104583:	0f b6 01             	movzbl (%ecx),%eax
f0104586:	84 c0                	test   %al,%al
f0104588:	74 04                	je     f010458e <strcmp+0x25>
f010458a:	3a 02                	cmp    (%edx),%al
f010458c:	74 ef                	je     f010457d <strcmp+0x14>
f010458e:	0f b6 c0             	movzbl %al,%eax
f0104591:	0f b6 12             	movzbl (%edx),%edx
f0104594:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0104596:	5d                   	pop    %ebp
f0104597:	c3                   	ret    

f0104598 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0104598:	55                   	push   %ebp
f0104599:	89 e5                	mov    %esp,%ebp
f010459b:	53                   	push   %ebx
f010459c:	8b 55 08             	mov    0x8(%ebp),%edx
f010459f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01045a2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
f01045a5:	85 c0                	test   %eax,%eax
f01045a7:	74 23                	je     f01045cc <strncmp+0x34>
f01045a9:	0f b6 1a             	movzbl (%edx),%ebx
f01045ac:	84 db                	test   %bl,%bl
f01045ae:	74 24                	je     f01045d4 <strncmp+0x3c>
f01045b0:	3a 19                	cmp    (%ecx),%bl
f01045b2:	75 20                	jne    f01045d4 <strncmp+0x3c>
f01045b4:	83 e8 01             	sub    $0x1,%eax
f01045b7:	74 13                	je     f01045cc <strncmp+0x34>
		n--, p++, q++;
f01045b9:	83 c2 01             	add    $0x1,%edx
f01045bc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f01045bf:	0f b6 1a             	movzbl (%edx),%ebx
f01045c2:	84 db                	test   %bl,%bl
f01045c4:	74 0e                	je     f01045d4 <strncmp+0x3c>
f01045c6:	3a 19                	cmp    (%ecx),%bl
f01045c8:	74 ea                	je     f01045b4 <strncmp+0x1c>
f01045ca:	eb 08                	jmp    f01045d4 <strncmp+0x3c>
f01045cc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01045d1:	5b                   	pop    %ebx
f01045d2:	5d                   	pop    %ebp
f01045d3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01045d4:	0f b6 02             	movzbl (%edx),%eax
f01045d7:	0f b6 11             	movzbl (%ecx),%edx
f01045da:	29 d0                	sub    %edx,%eax
f01045dc:	eb f3                	jmp    f01045d1 <strncmp+0x39>

f01045de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01045de:	55                   	push   %ebp
f01045df:	89 e5                	mov    %esp,%ebp
f01045e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01045e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01045e8:	0f b6 10             	movzbl (%eax),%edx
f01045eb:	84 d2                	test   %dl,%dl
f01045ed:	74 15                	je     f0104604 <strchr+0x26>
		if (*s == c)
f01045ef:	38 ca                	cmp    %cl,%dl
f01045f1:	75 07                	jne    f01045fa <strchr+0x1c>
f01045f3:	eb 14                	jmp    f0104609 <strchr+0x2b>
f01045f5:	38 ca                	cmp    %cl,%dl
f01045f7:	90                   	nop
f01045f8:	74 0f                	je     f0104609 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f01045fa:	83 c0 01             	add    $0x1,%eax
f01045fd:	0f b6 10             	movzbl (%eax),%edx
f0104600:	84 d2                	test   %dl,%dl
f0104602:	75 f1                	jne    f01045f5 <strchr+0x17>
f0104604:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
f0104609:	5d                   	pop    %ebp
f010460a:	c3                   	ret    

f010460b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010460b:	55                   	push   %ebp
f010460c:	89 e5                	mov    %esp,%ebp
f010460e:	8b 45 08             	mov    0x8(%ebp),%eax
f0104611:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0104615:	0f b6 10             	movzbl (%eax),%edx
f0104618:	84 d2                	test   %dl,%dl
f010461a:	74 18                	je     f0104634 <strfind+0x29>
		if (*s == c)
f010461c:	38 ca                	cmp    %cl,%dl
f010461e:	75 0a                	jne    f010462a <strfind+0x1f>
f0104620:	eb 12                	jmp    f0104634 <strfind+0x29>
f0104622:	38 ca                	cmp    %cl,%dl
f0104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104628:	74 0a                	je     f0104634 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f010462a:	83 c0 01             	add    $0x1,%eax
f010462d:	0f b6 10             	movzbl (%eax),%edx
f0104630:	84 d2                	test   %dl,%dl
f0104632:	75 ee                	jne    f0104622 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f0104634:	5d                   	pop    %ebp
f0104635:	c3                   	ret    

f0104636 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0104636:	55                   	push   %ebp
f0104637:	89 e5                	mov    %esp,%ebp
f0104639:	83 ec 0c             	sub    $0xc,%esp
f010463c:	89 1c 24             	mov    %ebx,(%esp)
f010463f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104643:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0104647:	8b 7d 08             	mov    0x8(%ebp),%edi
f010464a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010464d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0104650:	85 c9                	test   %ecx,%ecx
f0104652:	74 30                	je     f0104684 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0104654:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010465a:	75 25                	jne    f0104681 <memset+0x4b>
f010465c:	f6 c1 03             	test   $0x3,%cl
f010465f:	75 20                	jne    f0104681 <memset+0x4b>
		c &= 0xFF;
f0104661:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0104664:	89 d3                	mov    %edx,%ebx
f0104666:	c1 e3 08             	shl    $0x8,%ebx
f0104669:	89 d6                	mov    %edx,%esi
f010466b:	c1 e6 18             	shl    $0x18,%esi
f010466e:	89 d0                	mov    %edx,%eax
f0104670:	c1 e0 10             	shl    $0x10,%eax
f0104673:	09 f0                	or     %esi,%eax
f0104675:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
f0104677:	09 d8                	or     %ebx,%eax
f0104679:	c1 e9 02             	shr    $0x2,%ecx
f010467c:	fc                   	cld    
f010467d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f010467f:	eb 03                	jmp    f0104684 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0104681:	fc                   	cld    
f0104682:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0104684:	89 f8                	mov    %edi,%eax
f0104686:	8b 1c 24             	mov    (%esp),%ebx
f0104689:	8b 74 24 04          	mov    0x4(%esp),%esi
f010468d:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0104691:	89 ec                	mov    %ebp,%esp
f0104693:	5d                   	pop    %ebp
f0104694:	c3                   	ret    

f0104695 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0104695:	55                   	push   %ebp
f0104696:	89 e5                	mov    %esp,%ebp
f0104698:	83 ec 08             	sub    $0x8,%esp
f010469b:	89 34 24             	mov    %esi,(%esp)
f010469e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01046a2:	8b 45 08             	mov    0x8(%ebp),%eax
f01046a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f01046a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f01046ab:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f01046ad:	39 c6                	cmp    %eax,%esi
f01046af:	73 35                	jae    f01046e6 <memmove+0x51>
f01046b1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01046b4:	39 d0                	cmp    %edx,%eax
f01046b6:	73 2e                	jae    f01046e6 <memmove+0x51>
		s += n;
		d += n;
f01046b8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01046ba:	f6 c2 03             	test   $0x3,%dl
f01046bd:	75 1b                	jne    f01046da <memmove+0x45>
f01046bf:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01046c5:	75 13                	jne    f01046da <memmove+0x45>
f01046c7:	f6 c1 03             	test   $0x3,%cl
f01046ca:	75 0e                	jne    f01046da <memmove+0x45>
			asm volatile("std; rep movsl\n"
f01046cc:	83 ef 04             	sub    $0x4,%edi
f01046cf:	8d 72 fc             	lea    -0x4(%edx),%esi
f01046d2:	c1 e9 02             	shr    $0x2,%ecx
f01046d5:	fd                   	std    
f01046d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01046d8:	eb 09                	jmp    f01046e3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f01046da:	83 ef 01             	sub    $0x1,%edi
f01046dd:	8d 72 ff             	lea    -0x1(%edx),%esi
f01046e0:	fd                   	std    
f01046e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f01046e3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
f01046e4:	eb 20                	jmp    f0104706 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01046e6:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01046ec:	75 15                	jne    f0104703 <memmove+0x6e>
f01046ee:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01046f4:	75 0d                	jne    f0104703 <memmove+0x6e>
f01046f6:	f6 c1 03             	test   $0x3,%cl
f01046f9:	75 08                	jne    f0104703 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
f01046fb:	c1 e9 02             	shr    $0x2,%ecx
f01046fe:	fc                   	cld    
f01046ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104701:	eb 03                	jmp    f0104706 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0104703:	fc                   	cld    
f0104704:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0104706:	8b 34 24             	mov    (%esp),%esi
f0104709:	8b 7c 24 04          	mov    0x4(%esp),%edi
f010470d:	89 ec                	mov    %ebp,%esp
f010470f:	5d                   	pop    %ebp
f0104710:	c3                   	ret    

f0104711 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f0104711:	55                   	push   %ebp
f0104712:	89 e5                	mov    %esp,%ebp
f0104714:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0104717:	8b 45 10             	mov    0x10(%ebp),%eax
f010471a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010471e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104721:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104725:	8b 45 08             	mov    0x8(%ebp),%eax
f0104728:	89 04 24             	mov    %eax,(%esp)
f010472b:	e8 65 ff ff ff       	call   f0104695 <memmove>
}
f0104730:	c9                   	leave  
f0104731:	c3                   	ret    

f0104732 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0104732:	55                   	push   %ebp
f0104733:	89 e5                	mov    %esp,%ebp
f0104735:	57                   	push   %edi
f0104736:	56                   	push   %esi
f0104737:	53                   	push   %ebx
f0104738:	8b 75 08             	mov    0x8(%ebp),%esi
f010473b:	8b 7d 0c             	mov    0xc(%ebp),%edi
f010473e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0104741:	85 c9                	test   %ecx,%ecx
f0104743:	74 36                	je     f010477b <memcmp+0x49>
		if (*s1 != *s2)
f0104745:	0f b6 06             	movzbl (%esi),%eax
f0104748:	0f b6 1f             	movzbl (%edi),%ebx
f010474b:	38 d8                	cmp    %bl,%al
f010474d:	74 20                	je     f010476f <memcmp+0x3d>
f010474f:	eb 14                	jmp    f0104765 <memcmp+0x33>
f0104751:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
f0104756:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
f010475b:	83 c2 01             	add    $0x1,%edx
f010475e:	83 e9 01             	sub    $0x1,%ecx
f0104761:	38 d8                	cmp    %bl,%al
f0104763:	74 12                	je     f0104777 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
f0104765:	0f b6 c0             	movzbl %al,%eax
f0104768:	0f b6 db             	movzbl %bl,%ebx
f010476b:	29 d8                	sub    %ebx,%eax
f010476d:	eb 11                	jmp    f0104780 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010476f:	83 e9 01             	sub    $0x1,%ecx
f0104772:	ba 00 00 00 00       	mov    $0x0,%edx
f0104777:	85 c9                	test   %ecx,%ecx
f0104779:	75 d6                	jne    f0104751 <memcmp+0x1f>
f010477b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
f0104780:	5b                   	pop    %ebx
f0104781:	5e                   	pop    %esi
f0104782:	5f                   	pop    %edi
f0104783:	5d                   	pop    %ebp
f0104784:	c3                   	ret    

f0104785 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0104785:	55                   	push   %ebp
f0104786:	89 e5                	mov    %esp,%ebp
f0104788:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f010478b:	89 c2                	mov    %eax,%edx
f010478d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0104790:	39 d0                	cmp    %edx,%eax
f0104792:	73 15                	jae    f01047a9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f0104794:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f0104798:	38 08                	cmp    %cl,(%eax)
f010479a:	75 06                	jne    f01047a2 <memfind+0x1d>
f010479c:	eb 0b                	jmp    f01047a9 <memfind+0x24>
f010479e:	38 08                	cmp    %cl,(%eax)
f01047a0:	74 07                	je     f01047a9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f01047a2:	83 c0 01             	add    $0x1,%eax
f01047a5:	39 c2                	cmp    %eax,%edx
f01047a7:	77 f5                	ja     f010479e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f01047a9:	5d                   	pop    %ebp
f01047aa:	c3                   	ret    

f01047ab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01047ab:	55                   	push   %ebp
f01047ac:	89 e5                	mov    %esp,%ebp
f01047ae:	57                   	push   %edi
f01047af:	56                   	push   %esi
f01047b0:	53                   	push   %ebx
f01047b1:	83 ec 04             	sub    $0x4,%esp
f01047b4:	8b 55 08             	mov    0x8(%ebp),%edx
f01047b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01047ba:	0f b6 02             	movzbl (%edx),%eax
f01047bd:	3c 20                	cmp    $0x20,%al
f01047bf:	74 04                	je     f01047c5 <strtol+0x1a>
f01047c1:	3c 09                	cmp    $0x9,%al
f01047c3:	75 0e                	jne    f01047d3 <strtol+0x28>
		s++;
f01047c5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01047c8:	0f b6 02             	movzbl (%edx),%eax
f01047cb:	3c 20                	cmp    $0x20,%al
f01047cd:	74 f6                	je     f01047c5 <strtol+0x1a>
f01047cf:	3c 09                	cmp    $0x9,%al
f01047d1:	74 f2                	je     f01047c5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
f01047d3:	3c 2b                	cmp    $0x2b,%al
f01047d5:	75 0c                	jne    f01047e3 <strtol+0x38>
		s++;
f01047d7:	83 c2 01             	add    $0x1,%edx
f01047da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f01047e1:	eb 15                	jmp    f01047f8 <strtol+0x4d>
	else if (*s == '-')
f01047e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f01047ea:	3c 2d                	cmp    $0x2d,%al
f01047ec:	75 0a                	jne    f01047f8 <strtol+0x4d>
		s++, neg = 1;
f01047ee:	83 c2 01             	add    $0x1,%edx
f01047f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01047f8:	85 db                	test   %ebx,%ebx
f01047fa:	0f 94 c0             	sete   %al
f01047fd:	74 05                	je     f0104804 <strtol+0x59>
f01047ff:	83 fb 10             	cmp    $0x10,%ebx
f0104802:	75 18                	jne    f010481c <strtol+0x71>
f0104804:	80 3a 30             	cmpb   $0x30,(%edx)
f0104807:	75 13                	jne    f010481c <strtol+0x71>
f0104809:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f010480d:	8d 76 00             	lea    0x0(%esi),%esi
f0104810:	75 0a                	jne    f010481c <strtol+0x71>
		s += 2, base = 16;
f0104812:	83 c2 02             	add    $0x2,%edx
f0104815:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010481a:	eb 15                	jmp    f0104831 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f010481c:	84 c0                	test   %al,%al
f010481e:	66 90                	xchg   %ax,%ax
f0104820:	74 0f                	je     f0104831 <strtol+0x86>
f0104822:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0104827:	80 3a 30             	cmpb   $0x30,(%edx)
f010482a:	75 05                	jne    f0104831 <strtol+0x86>
		s++, base = 8;
f010482c:	83 c2 01             	add    $0x1,%edx
f010482f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0104831:	b8 00 00 00 00       	mov    $0x0,%eax
f0104836:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0104838:	0f b6 0a             	movzbl (%edx),%ecx
f010483b:	89 cf                	mov    %ecx,%edi
f010483d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0104840:	80 fb 09             	cmp    $0x9,%bl
f0104843:	77 08                	ja     f010484d <strtol+0xa2>
			dig = *s - '0';
f0104845:	0f be c9             	movsbl %cl,%ecx
f0104848:	83 e9 30             	sub    $0x30,%ecx
f010484b:	eb 1e                	jmp    f010486b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
f010484d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f0104850:	80 fb 19             	cmp    $0x19,%bl
f0104853:	77 08                	ja     f010485d <strtol+0xb2>
			dig = *s - 'a' + 10;
f0104855:	0f be c9             	movsbl %cl,%ecx
f0104858:	83 e9 57             	sub    $0x57,%ecx
f010485b:	eb 0e                	jmp    f010486b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
f010485d:	8d 5f bf             	lea    -0x41(%edi),%ebx
f0104860:	80 fb 19             	cmp    $0x19,%bl
f0104863:	77 15                	ja     f010487a <strtol+0xcf>
			dig = *s - 'A' + 10;
f0104865:	0f be c9             	movsbl %cl,%ecx
f0104868:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f010486b:	39 f1                	cmp    %esi,%ecx
f010486d:	7d 0b                	jge    f010487a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
f010486f:	83 c2 01             	add    $0x1,%edx
f0104872:	0f af c6             	imul   %esi,%eax
f0104875:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f0104878:	eb be                	jmp    f0104838 <strtol+0x8d>
f010487a:	89 c1                	mov    %eax,%ecx

	if (endptr)
f010487c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0104880:	74 05                	je     f0104887 <strtol+0xdc>
		*endptr = (char *) s;
f0104882:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104885:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f0104887:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f010488b:	74 04                	je     f0104891 <strtol+0xe6>
f010488d:	89 c8                	mov    %ecx,%eax
f010488f:	f7 d8                	neg    %eax
}
f0104891:	83 c4 04             	add    $0x4,%esp
f0104894:	5b                   	pop    %ebx
f0104895:	5e                   	pop    %esi
f0104896:	5f                   	pop    %edi
f0104897:	5d                   	pop    %ebp
f0104898:	c3                   	ret    
f0104899:	00 00                	add    %al,(%eax)
	...

f010489c <check_rfd>:
	ru_ind_last = RFD_BUFFERS - 1;
	return 0;
}

int check_rfd (struct rfd *ptr)
{
f010489c:	55                   	push   %ebp
f010489d:	89 e5                	mov    %esp,%ebp
	if(ptr->cb.status & CB_STATUS_C)
f010489f:	8b 45 08             	mov    0x8(%ebp),%eax
f01048a2:	0f b7 00             	movzwl (%eax),%eax
f01048a5:	98                   	cwtl   
f01048a6:	c1 e8 1f             	shr    $0x1f,%eax
	{
		return 1;
	}
	
	return 0;
} 
f01048a9:	5d                   	pop    %ebp
f01048aa:	c3                   	ret    

f01048ab <clear_rfd>:

void clear_rfd (struct rfd* ptr)
{
f01048ab:	55                   	push   %ebp
f01048ac:	89 e5                	mov    %esp,%ebp
f01048ae:	8b 45 08             	mov    0x8(%ebp),%eax
	ptr->cb.status = 0x0;
f01048b1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	ptr->cb.cmd |= CB_EL;
f01048b6:	66 81 48 02 00 80    	orw    $0x8000,0x2(%eax)
	ptr->reserved = 0xffffffff;
f01048bc:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
	ptr->actual_count = 0x0;
f01048c3:	66 c7 40 0c 00 00    	movw   $0x0,0xc(%eax)
	ptr->size = PACKET_MAX_SIZE;
f01048c9:	66 c7 40 0e ee 05    	movw   $0x5ee,0xe(%eax)
}
f01048cf:	5d                   	pop    %ebp
f01048d0:	c3                   	ret    

f01048d1 <alloc_tcb_ring>:
	return count;
}	

// construct a control DMA ring for the CU to use
int alloc_tcb_ring (void)
{
f01048d1:	55                   	push   %ebp
f01048d2:	89 e5                	mov    %esp,%ebp
f01048d4:	57                   	push   %edi
f01048d5:	56                   	push   %esi
f01048d6:	53                   	push   %ebx
f01048d7:	bb 22 42 3c f0       	mov    $0xf03c4222,%ebx
f01048dc:	b8 00 00 00 00       	mov    $0x0,%eax
	int i,j;
	for (i = 0; i < TCB_BUFFERS; i++)
	{
		j = ((i+1)%TCB_BUFFERS);
		ring_tcb[i].cb.status = 0x0;
f01048e1:	be 20 42 3c f0       	mov    $0xf03c4220,%esi
		ring_tcb[i].cb.cmd = 0x0;
		ring_tcb[i].cb.link = j * sizeof (struct tcb);
f01048e6:	bf ab aa aa 2a       	mov    $0x2aaaaaab,%edi
int alloc_tcb_ring (void)
{
	int i,j;
	for (i = 0; i < TCB_BUFFERS; i++)
	{
		j = ((i+1)%TCB_BUFFERS);
f01048eb:	8d 48 01             	lea    0x1(%eax),%ecx
		ring_tcb[i].cb.status = 0x0;
f01048ee:	69 c0 fe 05 00 00    	imul   $0x5fe,%eax,%eax
f01048f4:	66 c7 04 30 00 00    	movw   $0x0,(%eax,%esi,1)
		ring_tcb[i].cb.cmd = 0x0;
f01048fa:	66 c7 03 00 00       	movw   $0x0,(%ebx)
		ring_tcb[i].cb.link = j * sizeof (struct tcb);
f01048ff:	89 c8                	mov    %ecx,%eax
f0104901:	f7 ef                	imul   %edi
f0104903:	89 c8                	mov    %ecx,%eax
f0104905:	c1 f8 1f             	sar    $0x1f,%eax
f0104908:	29 c2                	sub    %eax,%edx
f010490a:	8d 04 52             	lea    (%edx,%edx,2),%eax
f010490d:	01 c0                	add    %eax,%eax
f010490f:	89 ca                	mov    %ecx,%edx
f0104911:	29 c2                	sub    %eax,%edx
f0104913:	69 c2 fe 05 00 00    	imul   $0x5fe,%edx,%eax
f0104919:	89 43 02             	mov    %eax,0x2(%ebx)
f010491c:	81 c3 fe 05 00 00    	add    $0x5fe,%ebx
f0104922:	89 c8                	mov    %ecx,%eax

// construct a control DMA ring for the CU to use
int alloc_tcb_ring (void)
{
	int i,j;
	for (i = 0; i < TCB_BUFFERS; i++)
f0104924:	83 f9 06             	cmp    $0x6,%ecx
f0104927:	75 c2                	jne    f01048eb <alloc_tcb_ring+0x1a>
		ring_tcb[i].cb.status = 0x0;
		ring_tcb[i].cb.cmd = 0x0;
		ring_tcb[i].cb.link = j * sizeof (struct tcb);
		//ring_tcb[i].cb.link = PADDR(&ring_tcb[j]);
	}
	cu_ind = 0;
f0104929:	c7 05 00 42 3c f0 00 	movl   $0x0,0xf03c4200
f0104930:	00 00 00 
	return 0;
}
f0104933:	b0 00                	mov    $0x0,%al
f0104935:	5b                   	pop    %ebx
f0104936:	5e                   	pop    %esi
f0104937:	5f                   	pop    %edi
f0104938:	5d                   	pop    %ebp
f0104939:	c3                   	ret    

f010493a <check_tcb>:

int check_tcb (struct tcb *ptr)
{
f010493a:	55                   	push   %ebp
f010493b:	89 e5                	mov    %esp,%ebp
f010493d:	8b 45 08             	mov    0x8(%ebp),%eax
f0104940:	66 83 78 02 00       	cmpw   $0x0,0x2(%eax)
f0104945:	0f 94 c0             	sete   %al
f0104948:	0f b6 c0             	movzbl %al,%eax
	// determines if the tcb buffer is available to  be used by the driver 
	if (ptr->cb.cmd)
		return 0;
	else 
		return 1;
}
f010494b:	5d                   	pop    %ebp
f010494c:	c3                   	ret    

f010494d <reclaim_buffers>:

void reclaim_buffers()
{
f010494d:	55                   	push   %ebp
f010494e:	89 e5                	mov    %esp,%ebp
f0104950:	56                   	push   %esi
f0104951:	53                   	push   %ebx
f0104952:	b9 22 42 3c f0       	mov    $0xf03c4222,%ecx
f0104957:	b8 00 00 00 00       	mov    $0x0,%eax
	// function to reclaim transmitted buffers
	int i;
	for (i=0; i < TCB_BUFFERS; i++)
	{
		if (ring_tcb[i].cb.status & CB_STATUS_C)
f010495c:	ba 20 42 3c f0       	mov    $0xf03c4220,%edx
f0104961:	69 d8 fe 05 00 00    	imul   $0x5fe,%eax,%ebx
f0104967:	0f b7 1c 13          	movzwl (%ebx,%edx,1),%ebx
f010496b:	66 85 db             	test   %bx,%bx
f010496e:	79 15                	jns    f0104985 <reclaim_buffers+0x38>
		{
			// check the OK bit for an error
			if (!(ring_tcb[i].cb.status & CB_STATUS_OK))
f0104970:	69 d8 fe 05 00 00    	imul   $0x5fe,%eax,%ebx
f0104976:	0f b7 34 13          	movzwl (%ebx,%edx,1),%esi
			{
				// there was an error
				// do something
			}
			// reclaim the buffer anyways
			ring_tcb[i].cb.status = 0x0;
f010497a:	66 c7 04 13 00 00    	movw   $0x0,(%ebx,%edx,1)
			ring_tcb[i].cb.cmd = 0x0;
f0104980:	66 c7 01 00 00       	movw   $0x0,(%ecx)

void reclaim_buffers()
{
	// function to reclaim transmitted buffers
	int i;
	for (i=0; i < TCB_BUFFERS; i++)
f0104985:	83 c0 01             	add    $0x1,%eax
f0104988:	81 c1 fe 05 00 00    	add    $0x5fe,%ecx
f010498e:	83 f8 06             	cmp    $0x6,%eax
f0104991:	75 ce                	jne    f0104961 <reclaim_buffers+0x14>
			// reclaim the buffer anyways
			ring_tcb[i].cb.status = 0x0;
			ring_tcb[i].cb.cmd = 0x0;
		}
	}
}
f0104993:	5b                   	pop    %ebx
f0104994:	5e                   	pop    %esi
f0104995:	5d                   	pop    %ebp
f0104996:	c3                   	ret    

f0104997 <alloc_rfd_ring>:
        return 0;
}

// construct a DMA ring for RU to use	
int alloc_rfd_ring (void)
{
f0104997:	55                   	push   %ebp
f0104998:	89 e5                	mov    %esp,%ebp
f010499a:	57                   	push   %edi
f010499b:	56                   	push   %esi
f010499c:	53                   	push   %ebx
f010499d:	83 ec 1c             	sub    $0x1c,%esp
	int i,j;
	for (i=0; i < RFD_BUFFERS; i++)
	{
		j = ((i+1)%RFD_BUFFERS);
		ring_rfd[i].cb.status = 0x0;
f01049a0:	66 c7 05 20 66 3c f0 	movw   $0x0,0xf03c6620
f01049a7:	00 00 
		ring_rfd[i].cb.cmd = 0x0;
f01049a9:	66 c7 05 22 66 3c f0 	movw   $0x0,0xf03c6622
f01049b0:	00 00 
		ring_rfd[i].reserved = 0xffffffff;
f01049b2:	c7 05 28 66 3c f0 ff 	movl   $0xffffffff,0xf03c6628
f01049b9:	ff ff ff 
		// ring_rfd[i].cb.link = j * sizeof (struct rfd);
		ring_rfd[i].cb.link = PADDR(&ring_rfd[j]);
f01049bc:	b8 1e 6c 3c f0       	mov    $0xf03c6c1e,%eax
f01049c1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01049c6:	0f 87 b2 00 00 00    	ja     f0104a7e <alloc_rfd_ring+0xe7>
f01049cc:	eb 43                	jmp    f0104a11 <alloc_rfd_ring+0x7a>
f01049ce:	89 d8                	mov    %ebx,%eax
int alloc_rfd_ring (void)
{
	int i,j;
	for (i=0; i < RFD_BUFFERS; i++)
	{
		j = ((i+1)%RFD_BUFFERS);
f01049d0:	8d 58 01             	lea    0x1(%eax),%ebx
		ring_rfd[i].cb.status = 0x0;
f01049d3:	69 c0 fe 05 00 00    	imul   $0x5fe,%eax,%eax
f01049d9:	66 c7 04 30 00 00    	movw   $0x0,(%eax,%esi,1)
		ring_rfd[i].cb.cmd = 0x0;
f01049df:	66 c7 01 00 00       	movw   $0x0,(%ecx)
		ring_rfd[i].reserved = 0xffffffff;
f01049e4:	c7 41 06 ff ff ff ff 	movl   $0xffffffff,0x6(%ecx)
		// ring_rfd[i].cb.link = j * sizeof (struct rfd);
		ring_rfd[i].cb.link = PADDR(&ring_rfd[j]);
f01049eb:	89 d8                	mov    %ebx,%eax
f01049ed:	f7 ef                	imul   %edi
f01049ef:	89 d8                	mov    %ebx,%eax
f01049f1:	c1 f8 1f             	sar    $0x1f,%eax
f01049f4:	29 c2                	sub    %eax,%edx
f01049f6:	8d 04 52             	lea    (%edx,%edx,2),%eax
f01049f9:	01 c0                	add    %eax,%eax
f01049fb:	89 da                	mov    %ebx,%edx
f01049fd:	29 c2                	sub    %eax,%edx
f01049ff:	69 c2 fe 05 00 00    	imul   $0x5fe,%edx,%eax
f0104a05:	05 20 66 3c f0       	add    $0xf03c6620,%eax
f0104a0a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104a0f:	77 20                	ja     f0104a31 <alloc_rfd_ring+0x9a>
f0104a11:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104a15:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0104a1c:	f0 
f0104a1d:	c7 44 24 04 4e 00 00 	movl   $0x4e,0x4(%esp)
f0104a24:	00 
f0104a25:	c7 04 24 ef 6c 10 f0 	movl   $0xf0106cef,(%esp)
f0104a2c:	e8 54 b6 ff ff       	call   f0100085 <_panic>
f0104a31:	05 00 00 00 10       	add    $0x10000000,%eax
f0104a36:	89 41 02             	mov    %eax,0x2(%ecx)
		ring_rfd[i].actual_count = 0x0;
f0104a39:	66 c7 41 0a 00 00    	movw   $0x0,0xa(%ecx)
		ring_rfd[i].size = PACKET_MAX_SIZE;
f0104a3f:	66 c7 41 0c ee 05    	movw   $0x5ee,0xc(%ecx)
f0104a45:	81 c1 fe 05 00 00    	add    $0x5fe,%ecx

// construct a DMA ring for RU to use	
int alloc_rfd_ring (void)
{
	int i,j;
	for (i=0; i < RFD_BUFFERS; i++)
f0104a4b:	83 fb 06             	cmp    $0x6,%ebx
f0104a4e:	0f 85 7a ff ff ff    	jne    f01049ce <alloc_rfd_ring+0x37>
		ring_rfd[i].actual_count = 0x0;
		ring_rfd[i].size = PACKET_MAX_SIZE;
	}

	// intially mark the EL flag for the last buffer
	ring_rfd[RFD_BUFFERS - 1].cb.cmd |= CB_EL;		
f0104a54:	66 81 0d 18 84 3c f0 	orw    $0x8000,0xf03c8418
f0104a5b:	00 80 
	
	ru_ind = 0;	
f0104a5d:	c7 05 04 42 3c f0 00 	movl   $0x0,0xf03c4204
f0104a64:	00 00 00 
	ru_ind_last = RFD_BUFFERS - 1;
f0104a67:	c7 05 08 42 3c f0 05 	movl   $0x5,0xf03c4208
f0104a6e:	00 00 00 
	return 0;
}
f0104a71:	b8 00 00 00 00       	mov    $0x0,%eax
f0104a76:	83 c4 1c             	add    $0x1c,%esp
f0104a79:	5b                   	pop    %ebx
f0104a7a:	5e                   	pop    %esi
f0104a7b:	5f                   	pop    %edi
f0104a7c:	5d                   	pop    %ebp
f0104a7d:	c3                   	ret    
		j = ((i+1)%RFD_BUFFERS);
		ring_rfd[i].cb.status = 0x0;
		ring_rfd[i].cb.cmd = 0x0;
		ring_rfd[i].reserved = 0xffffffff;
		// ring_rfd[i].cb.link = j * sizeof (struct rfd);
		ring_rfd[i].cb.link = PADDR(&ring_rfd[j]);
f0104a7e:	05 00 00 00 10       	add    $0x10000000,%eax
f0104a83:	a3 24 66 3c f0       	mov    %eax,0xf03c6624
		ring_rfd[i].actual_count = 0x0;
f0104a88:	66 c7 05 2c 66 3c f0 	movw   $0x0,0xf03c662c
f0104a8f:	00 00 
		ring_rfd[i].size = PACKET_MAX_SIZE;
f0104a91:	66 c7 05 2e 66 3c f0 	movw   $0x5ee,0xf03c662e
f0104a98:	ee 05 
f0104a9a:	b9 20 6c 3c f0       	mov    $0xf03c6c20,%ecx
f0104a9f:	b8 01 00 00 00       	mov    $0x1,%eax
{
	int i,j;
	for (i=0; i < RFD_BUFFERS; i++)
	{
		j = ((i+1)%RFD_BUFFERS);
		ring_rfd[i].cb.status = 0x0;
f0104aa4:	be 20 66 3c f0       	mov    $0xf03c6620,%esi
		ring_rfd[i].cb.cmd = 0x0;
		ring_rfd[i].reserved = 0xffffffff;
		// ring_rfd[i].cb.link = j * sizeof (struct rfd);
		ring_rfd[i].cb.link = PADDR(&ring_rfd[j]);
f0104aa9:	bf ab aa aa 2a       	mov    $0x2aaaaaab,%edi
f0104aae:	e9 1d ff ff ff       	jmp    f01049d0 <alloc_rfd_ring+0x39>

f0104ab3 <fill_tcb_buffer>:
		}
	}
}

void fill_tcb_buffer (struct tcb* ptr, void* data, uint32_t len)
{
f0104ab3:	55                   	push   %ebp
f0104ab4:	89 e5                	mov    %esp,%ebp
f0104ab6:	83 ec 18             	sub    $0x18,%esp
f0104ab9:	8b 45 08             	mov    0x8(%ebp),%eax
f0104abc:	8b 55 10             	mov    0x10(%ebp),%edx
	ptr->cb.cmd = CB_TRANSMIT | CB_S;		// Set the Suspend bit
f0104abf:	66 c7 40 02 04 40    	movw   $0x4004,0x2(%eax)
	ptr->cb.status = 0x0;
f0104ac5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	ptr->tbd_array_addr = 0xffffffff;
f0104aca:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
	ptr->size = len;
f0104ad1:	66 89 50 0c          	mov    %dx,0xc(%eax)
	ptr->thrs = 0xe0;
f0104ad5:	c6 40 0e e0          	movb   $0xe0,0xe(%eax)
	memmove(ptr->packet_data, data, len);
f0104ad9:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104add:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104ae0:	89 54 24 04          	mov    %edx,0x4(%esp)
f0104ae4:	83 c0 10             	add    $0x10,%eax
f0104ae7:	89 04 24             	mov    %eax,(%esp)
f0104aea:	e8 a6 fb ff ff       	call   f0104695 <memmove>
}
f0104aef:	c9                   	leave  
f0104af0:	c3                   	ret    

f0104af1 <transmit_packet>:

int transmit_packet (void * data, uint32_t len)
{
f0104af1:	55                   	push   %ebp
f0104af2:	89 e5                	mov    %esp,%ebp
f0104af4:	83 ec 18             	sub    $0x18,%esp
f0104af7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0104afa:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0104afd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	reclaim_buffers();
f0104b00:	e8 48 fe ff ff       	call   f010494d <reclaim_buffers>
	if (len > PACKET_MAX_SIZE)
f0104b05:	81 fb ee 05 00 00    	cmp    $0x5ee,%ebx
f0104b0b:	0f 87 c9 00 00 00    	ja     f0104bda <transmit_packet+0xe9>
		return -E_NIC_TRANSMIT;
	
	if (check_tcb(&ring_tcb[cu_ind]) == 0)
f0104b11:	69 35 00 42 3c f0 fe 	imul   $0x5fe,0xf03c4200,%esi
f0104b18:	05 00 00 
f0104b1b:	81 c6 20 42 3c f0    	add    $0xf03c4220,%esi
f0104b21:	89 34 24             	mov    %esi,(%esp)
f0104b24:	e8 11 fe ff ff       	call   f010493a <check_tcb>
f0104b29:	85 c0                	test   %eax,%eax
f0104b2b:	0f 84 a9 00 00 00    	je     f0104bda <transmit_packet+0xe9>
		return -E_NIC_TRANSMIT;
	
	fill_tcb_buffer(&ring_tcb[cu_ind], data, len);
f0104b31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104b35:	8b 45 08             	mov    0x8(%ebp),%eax
f0104b38:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b3c:	89 34 24             	mov    %esi,(%esp)
f0104b3f:	e8 6f ff ff ff       	call   f0104ab3 <fill_tcb_buffer>
			
	int base = store.reg_base[1]; 		// for I/O Port Base
f0104b44:	8b 0d 58 8a 3c f0    	mov    0xf03c8a58,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0104b4a:	89 ca                	mov    %ecx,%edx
f0104b4c:	ec                   	in     (%dx),%al
	uint8_t status =  inb(base);
	status = status & SCBST_CU_MASK;
	
	 
	if (status == SCBST_CU_IDLE)
f0104b4d:	25 c0 00 00 00       	and    $0xc0,%eax
f0104b52:	75 4b                	jne    f0104b9f <transmit_packet+0xae>
	{
		// Start the CU
		outl(base + 0x4, PADDR((uint32_t)&ring_tcb[cu_ind]));
f0104b54:	69 05 00 42 3c f0 fe 	imul   $0x5fe,0xf03c4200,%eax
f0104b5b:	05 00 00 
f0104b5e:	05 20 42 3c f0       	add    $0xf03c4220,%eax
f0104b63:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104b68:	77 20                	ja     f0104b8a <transmit_packet+0x99>
f0104b6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104b6e:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0104b75:	f0 
f0104b76:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
f0104b7d:	00 
f0104b7e:	c7 04 24 ef 6c 10 f0 	movl   $0xf0106cef,(%esp)
f0104b85:	e8 fb b4 ff ff       	call   f0100085 <_panic>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0104b8a:	05 00 00 00 10       	add    $0x10000000,%eax
f0104b8f:	8d 51 04             	lea    0x4(%ecx),%edx
f0104b92:	ef                   	out    %eax,(%dx)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
f0104b93:	8d 51 02             	lea    0x2(%ecx),%edx
f0104b96:	b8 10 00 00 00       	mov    $0x10,%eax
f0104b9b:	66 ef                	out    %ax,(%dx)
f0104b9d:	eb 0e                	jmp    f0104bad <transmit_packet+0xbc>
		outw(base + 0x2, SCB_CU_START);	
	} 
	if (status ==  SCBST_CU_SUSPENDED)
f0104b9f:	3c 40                	cmp    $0x40,%al
f0104ba1:	75 0a                	jne    f0104bad <transmit_packet+0xbc>
f0104ba3:	8d 51 02             	lea    0x2(%ecx),%edx
f0104ba6:	b8 20 00 00 00       	mov    $0x20,%eax
f0104bab:	66 ef                	out    %ax,(%dx)
	{
		// Resume the CU
		outw(base + 0x2, SCB_CU_RESUME);				
	}
	// move cu_ind
	cu_ind = (cu_ind + 1) % TCB_BUFFERS;
f0104bad:	8b 0d 00 42 3c f0    	mov    0xf03c4200,%ecx
f0104bb3:	83 c1 01             	add    $0x1,%ecx
f0104bb6:	ba ab aa aa 2a       	mov    $0x2aaaaaab,%edx
f0104bbb:	89 c8                	mov    %ecx,%eax
f0104bbd:	f7 ea                	imul   %edx
f0104bbf:	89 c8                	mov    %ecx,%eax
f0104bc1:	c1 f8 1f             	sar    $0x1f,%eax
f0104bc4:	29 c2                	sub    %eax,%edx
f0104bc6:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104bc9:	01 c0                	add    %eax,%eax
f0104bcb:	29 c1                	sub    %eax,%ecx
f0104bcd:	89 0d 00 42 3c f0    	mov    %ecx,0xf03c4200
f0104bd3:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
f0104bd8:	eb 05                	jmp    f0104bdf <transmit_packet+0xee>
f0104bda:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
}
f0104bdf:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0104be2:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0104be5:	89 ec                	mov    %ebp,%esp
f0104be7:	5d                   	pop    %ebp
f0104be8:	c3                   	ret    

f0104be9 <receive_packet>:
	ptr->actual_count = 0x0;
	ptr->size = PACKET_MAX_SIZE;
}

int receive_packet (void* buffer)
{
f0104be9:	55                   	push   %ebp
f0104bea:	89 e5                	mov    %esp,%ebp
f0104bec:	83 ec 38             	sub    $0x38,%esp
f0104bef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0104bf2:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0104bf5:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0104bf8:	8b 7d 08             	mov    0x8(%ebp),%edi
	if (!buffer)
f0104bfb:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
f0104c00:	85 ff                	test   %edi,%edi
f0104c02:	0f 84 1a 01 00 00    	je     f0104d22 <receive_packet+0x139>
		return -E_NIC_RECEIVE;
	// Check if there is a valid packet in the buffer pointed by index ru_ind
	if (check_rfd(&ring_rfd[ru_ind]) == 0)
f0104c08:	8b 1d 04 42 3c f0    	mov    0xf03c4204,%ebx
f0104c0e:	69 c3 fe 05 00 00    	imul   $0x5fe,%ebx,%eax
f0104c14:	05 20 66 3c f0       	add    $0xf03c6620,%eax
f0104c19:	89 04 24             	mov    %eax,(%esp)
f0104c1c:	e8 7b fc ff ff       	call   f010489c <check_rfd>
f0104c21:	89 c2                	mov    %eax,%edx
f0104c23:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c28:	85 d2                	test   %edx,%edx
f0104c2a:	0f 84 f2 00 00 00    	je     f0104d22 <receive_packet+0x139>
		return 0;
	// Set count variable as the actual count of bytes in the packet
	// Mask is needed to mask off EOF and F bits
	// Open SDM: Figure 25
	uint16_t count = ring_rfd[ru_ind].actual_count & (~RFD_COUNT_MASK);
f0104c30:	be 20 66 3c f0       	mov    $0xf03c6620,%esi
f0104c35:	69 db fe 05 00 00    	imul   $0x5fe,%ebx,%ebx
f0104c3b:	0f b7 44 33 0c       	movzwl 0xc(%ebx,%esi,1),%eax
f0104c40:	66 25 ff 3f          	and    $0x3fff,%ax
f0104c44:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

	// Copy the "count" no of bytes from "packet_data" to the "buffer"	
	memmove(buffer, ring_rfd[ru_ind].packet_data, count);
f0104c48:	0f b7 c0             	movzwl %ax,%eax
f0104c4b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104c4f:	81 c3 30 66 3c f0    	add    $0xf03c6630,%ebx
f0104c55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104c59:	89 3c 24             	mov    %edi,(%esp)
f0104c5c:	e8 34 fa ff ff       	call   f0104695 <memmove>
	
	// This buffer can be reused now, clear it
	clear_rfd (&ring_rfd[ru_ind]);
f0104c61:	8b 1d 04 42 3c f0    	mov    0xf03c4204,%ebx
f0104c67:	69 c3 fe 05 00 00    	imul   $0x5fe,%ebx,%eax
f0104c6d:	01 f0                	add    %esi,%eax
f0104c6f:	89 04 24             	mov    %eax,(%esp)
f0104c72:	e8 34 fc ff ff       	call   f01048ab <clear_rfd>
	
	// Clear the EL bit in the last buffer, move the "last buffer" index
	ring_rfd[ru_ind_last].cb.cmd &= ~CB_EL;
f0104c77:	69 05 08 42 3c f0 fe 	imul   $0x5fe,0xf03c4208,%eax
f0104c7e:	05 00 00 
f0104c81:	66 81 64 06 02 ff 7f 	andw   $0x7fff,0x2(%esi,%eax,1)
	ru_ind_last = ru_ind;
f0104c88:	89 1d 08 42 3c f0    	mov    %ebx,0xf03c4208

	// Move the index ru_ind
	ru_ind = (ru_ind + 1) % RFD_BUFFERS;
f0104c8e:	83 c3 01             	add    $0x1,%ebx
f0104c91:	ba ab aa aa 2a       	mov    $0x2aaaaaab,%edx
f0104c96:	89 d8                	mov    %ebx,%eax
f0104c98:	f7 ea                	imul   %edx
f0104c9a:	89 d8                	mov    %ebx,%eax
f0104c9c:	c1 f8 1f             	sar    $0x1f,%eax
f0104c9f:	29 c2                	sub    %eax,%edx
f0104ca1:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104ca4:	01 c0                	add    %eax,%eax
f0104ca6:	29 c3                	sub    %eax,%ebx
f0104ca8:	89 1d 04 42 3c f0    	mov    %ebx,0xf03c4204

	int base = store.reg_base[1]; 		// for I/O Port Base
f0104cae:	8b 1d 58 8a 3c f0    	mov    0xf03c8a58,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0104cb4:	89 da                	mov    %ebx,%edx
f0104cb6:	ec                   	in     (%dx),%al
	uint8_t status =  inb(base);
	status = status & SCBST_RU_MASK;		
	 
	if ((status == SCBST_RU_IDLE))
f0104cb7:	83 e0 3c             	and    $0x3c,%eax
f0104cba:	75 54                	jne    f0104d10 <receive_packet+0x127>
	{
		// Start the RU
		cprintf("\n Starting the RU");
f0104cbc:	c7 04 24 fb 6c 10 f0 	movl   $0xf0106cfb,(%esp)
f0104cc3:	e8 9f dc ff ff       	call   f0102967 <cprintf>
		outl(base + 0x4, PADDR((uint32_t)&ring_rfd[ru_ind]));
f0104cc8:	69 05 04 42 3c f0 fe 	imul   $0x5fe,0xf03c4204,%eax
f0104ccf:	05 00 00 
f0104cd2:	01 f0                	add    %esi,%eax
f0104cd4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104cd9:	77 20                	ja     f0104cfb <receive_packet+0x112>
f0104cdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104cdf:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0104ce6:	f0 
f0104ce7:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
f0104cee:	00 
f0104cef:	c7 04 24 ef 6c 10 f0 	movl   $0xf0106cef,(%esp)
f0104cf6:	e8 8a b3 ff ff       	call   f0100085 <_panic>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0104cfb:	05 00 00 00 10       	add    $0x10000000,%eax
f0104d00:	8d 53 04             	lea    0x4(%ebx),%edx
f0104d03:	ef                   	out    %eax,(%dx)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
f0104d04:	8d 53 02             	lea    0x2(%ebx),%edx
f0104d07:	b8 01 00 00 00       	mov    $0x1,%eax
f0104d0c:	66 ef                	out    %ax,(%dx)
f0104d0e:	eb 0e                	jmp    f0104d1e <receive_packet+0x135>
		outw(base + 0x2, SCB_RU_START);	
	} 
	
	if (status ==  SCBST_RU_SUSPENDED)
f0104d10:	3c 04                	cmp    $0x4,%al
f0104d12:	75 0a                	jne    f0104d1e <receive_packet+0x135>
f0104d14:	8d 53 02             	lea    0x2(%ebx),%edx
f0104d17:	b8 02 00 00 00       	mov    $0x2,%eax
f0104d1c:	66 ef                	out    %ax,(%dx)
	{
		// Resume the RU
		outw(base + 0x2, SCB_RU_RESUME);				
	}

	return count;
f0104d1e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
}	
f0104d22:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0104d25:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0104d28:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0104d2b:	89 ec                	mov    %ebp,%esp
f0104d2d:	5d                   	pop    %ebp
f0104d2e:	c3                   	ret    

f0104d2f <e100_attach>:
int alloc_rfd_ring (void);
void clear_rfd (struct rfd*);

// function to attach the E100 device
int e100_attach(struct pci_func* f)
{
f0104d2f:	55                   	push   %ebp
f0104d30:	89 e5                	mov    %esp,%ebp
f0104d32:	56                   	push   %esi
f0104d33:	53                   	push   %ebx
f0104d34:	83 ec 10             	sub    $0x10,%esp
f0104d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	int base;
	
	// enable the E100 device
	pci_func_enable(f);
f0104d3a:	89 1c 24             	mov    %ebx,(%esp)
f0104d3d:	e8 cc 05 00 00       	call   f010530e <pci_func_enable>
f0104d42:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < 6; i++)
	{
		store.reg_base[i] = f->reg_base[i];
f0104d47:	be 54 8a 3c f0       	mov    $0xf03c8a54,%esi
		store.reg_size[i] = f->reg_size[i];
f0104d4c:	b9 6c 8a 3c f0       	mov    $0xf03c8a6c,%ecx
	
	// enable the E100 device
	pci_func_enable(f);
	for (i = 0; i < 6; i++)
	{
		store.reg_base[i] = f->reg_base[i];
f0104d51:	8b 54 83 14          	mov    0x14(%ebx,%eax,4),%edx
f0104d55:	89 14 86             	mov    %edx,(%esi,%eax,4)
		store.reg_size[i] = f->reg_size[i];
f0104d58:	8b 54 83 2c          	mov    0x2c(%ebx,%eax,4),%edx
f0104d5c:	89 14 81             	mov    %edx,(%ecx,%eax,4)
	int i;
	int base;
	
	// enable the E100 device
	pci_func_enable(f);
	for (i = 0; i < 6; i++)
f0104d5f:	83 c0 01             	add    $0x1,%eax
f0104d62:	83 f8 06             	cmp    $0x6,%eax
f0104d65:	75 ea                	jne    f0104d51 <e100_attach+0x22>
	{
		store.reg_base[i] = f->reg_base[i];
		store.reg_size[i] = f->reg_size[i];
	}
	store.irq_line = f->irq_line;
f0104d67:	0f b6 43 44          	movzbl 0x44(%ebx),%eax
f0104d6b:	a2 84 8a 3c f0       	mov    %al,0xf03c8a84
	
	// do a software reset
	base = store.reg_base[1]; 		// for I/O Port Base
f0104d70:	8b 1d 58 8a 3c f0    	mov    0xf03c8a58,%ebx
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0104d76:	8d 53 08             	lea    0x8(%ebx),%edx
f0104d79:	b8 00 00 00 00       	mov    $0x0,%eax
f0104d7e:	ef                   	out    %eax,(%dx)
	outl(base + 0x8, 0x0);

	// initialize the TBC Ring for CU
	alloc_tcb_ring();
f0104d7f:	e8 4d fb ff ff       	call   f01048d1 <alloc_tcb_ring>
	
	// load the CU Base register with the base address of the ring_tcb
	outl(base + 0x4, PADDR(&ring_tcb[0])); 
f0104d84:	b8 20 42 3c f0       	mov    $0xf03c4220,%eax
f0104d89:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104d8e:	77 20                	ja     f0104db0 <e100_attach+0x81>
f0104d90:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104d94:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0104d9b:	f0 
f0104d9c:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
f0104da3:	00 
f0104da4:	c7 04 24 ef 6c 10 f0 	movl   $0xf0106cef,(%esp)
f0104dab:	e8 d5 b2 ff ff       	call   f0100085 <_panic>
f0104db0:	8d 73 04             	lea    0x4(%ebx),%esi
f0104db3:	05 00 00 00 10       	add    $0x10000000,%eax
f0104db8:	89 f2                	mov    %esi,%edx
f0104dba:	ef                   	out    %eax,(%dx)
	outw(base + 0x2, SCB_CU_LOAD_CU_BASE); //op code in SCB command word
f0104dbb:	83 c3 02             	add    $0x2,%ebx
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
f0104dbe:	b8 60 00 00 00       	mov    $0x60,%eax
f0104dc3:	89 da                	mov    %ebx,%edx
f0104dc5:	66 ef                	out    %ax,(%dx)


	// initialize the RFD Ring for RU
	alloc_rfd_ring();
f0104dc7:	e8 cb fb ff ff       	call   f0104997 <alloc_rfd_ring>
	// load the RU Base register with the base address of the ring_rfd
	// outl(base + 0x4, PADDR(&ring_rfd[0]));
	// outw(base + 0x2, SCB_RU_LOAD_RU_BASE);
	
	// Start the RU
	outl(base + 0x4, PADDR((uint32_t)&ring_rfd[ru_ind]));
f0104dcc:	69 05 04 42 3c f0 fe 	imul   $0x5fe,0xf03c4204,%eax
f0104dd3:	05 00 00 
f0104dd6:	05 20 66 3c f0       	add    $0xf03c6620,%eax
f0104ddb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104de0:	77 20                	ja     f0104e02 <e100_attach+0xd3>
f0104de2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104de6:	c7 44 24 08 5c 61 10 	movl   $0xf010615c,0x8(%esp)
f0104ded:	f0 
f0104dee:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
f0104df5:	00 
f0104df6:	c7 04 24 ef 6c 10 f0 	movl   $0xf0106cef,(%esp)
f0104dfd:	e8 83 b2 ff ff       	call   f0100085 <_panic>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0104e02:	05 00 00 00 10       	add    $0x10000000,%eax
f0104e07:	89 f2                	mov    %esi,%edx
f0104e09:	ef                   	out    %eax,(%dx)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
f0104e0a:	b8 01 00 00 00       	mov    $0x1,%eax
f0104e0f:	89 da                	mov    %ebx,%edx
f0104e11:	66 ef                	out    %ax,(%dx)
	outw(base + 0x2, SCB_RU_START);	

        return 0;
}
f0104e13:	b8 00 00 00 00       	mov    $0x0,%eax
f0104e18:	83 c4 10             	add    $0x10,%esp
f0104e1b:	5b                   	pop    %ebx
f0104e1c:	5e                   	pop    %esi
f0104e1d:	5d                   	pop    %ebp
f0104e1e:	c3                   	ret    
	...

f0104e20 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0104e20:	55                   	push   %ebp
f0104e21:	89 e5                	mov    %esp,%ebp
f0104e23:	57                   	push   %edi
f0104e24:	56                   	push   %esi
f0104e25:	53                   	push   %ebx
f0104e26:	83 ec 3c             	sub    $0x3c,%esp
f0104e29:	89 c7                	mov    %eax,%edi
f0104e2b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104e2e:	89 ce                	mov    %ecx,%esi
	uint32_t i;
	
	for (i = 0; list[i].attachfn; i++) {
f0104e30:	8b 41 08             	mov    0x8(%ecx),%eax
f0104e33:	85 c0                	test   %eax,%eax
f0104e35:	74 4d                	je     f0104e84 <pci_attach_match+0x64>
f0104e37:	8d 59 0c             	lea    0xc(%ecx),%ebx
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0104e3a:	39 3e                	cmp    %edi,(%esi)
f0104e3c:	75 3a                	jne    f0104e78 <pci_attach_match+0x58>
f0104e3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104e41:	39 56 04             	cmp    %edx,0x4(%esi)
f0104e44:	75 32                	jne    f0104e78 <pci_attach_match+0x58>
			int r = list[i].attachfn(pcif);
f0104e46:	8b 55 08             	mov    0x8(%ebp),%edx
f0104e49:	89 14 24             	mov    %edx,(%esp)
f0104e4c:	ff d0                	call   *%eax
			if (r > 0)
f0104e4e:	85 c0                	test   %eax,%eax
f0104e50:	7f 37                	jg     f0104e89 <pci_attach_match+0x69>
				return r;
			if (r < 0)
f0104e52:	85 c0                	test   %eax,%eax
f0104e54:	79 22                	jns    f0104e78 <pci_attach_match+0x58>
				cprintf("pci_attach_match: attaching "
f0104e56:	89 44 24 10          	mov    %eax,0x10(%esp)
f0104e5a:	8b 46 08             	mov    0x8(%esi),%eax
f0104e5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104e61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104e64:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104e68:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104e6c:	c7 04 24 10 6d 10 f0 	movl   $0xf0106d10,(%esp)
f0104e73:	e8 ef da ff ff       	call   f0102967 <cprintf>
f0104e78:	89 de                	mov    %ebx,%esi
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;
	
	for (i = 0; list[i].attachfn; i++) {
f0104e7a:	8b 43 08             	mov    0x8(%ebx),%eax
f0104e7d:	83 c3 0c             	add    $0xc,%ebx
f0104e80:	85 c0                	test   %eax,%eax
f0104e82:	75 b6                	jne    f0104e3a <pci_attach_match+0x1a>
f0104e84:	b8 00 00 00 00       	mov    $0x0,%eax
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0104e89:	83 c4 3c             	add    $0x3c,%esp
f0104e8c:	5b                   	pop    %ebx
f0104e8d:	5e                   	pop    %esi
f0104e8e:	5f                   	pop    %edi
f0104e8f:	5d                   	pop    %ebp
f0104e90:	c3                   	ret    

f0104e91 <pci_conf1_set_addr>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f0104e91:	55                   	push   %ebp
f0104e92:	89 e5                	mov    %esp,%ebp
f0104e94:	53                   	push   %ebx
f0104e95:	83 ec 14             	sub    $0x14,%esp
f0104e98:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0104e9b:	3d ff 00 00 00       	cmp    $0xff,%eax
f0104ea0:	76 24                	jbe    f0104ec6 <pci_conf1_set_addr+0x35>
f0104ea2:	c7 44 24 0c b0 6e 10 	movl   $0xf0106eb0,0xc(%esp)
f0104ea9:	f0 
f0104eaa:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0104eb1:	f0 
f0104eb2:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
f0104eb9:	00 
f0104eba:	c7 04 24 ba 6e 10 f0 	movl   $0xf0106eba,(%esp)
f0104ec1:	e8 bf b1 ff ff       	call   f0100085 <_panic>
	assert(dev < 32);
f0104ec6:	83 fa 1f             	cmp    $0x1f,%edx
f0104ec9:	76 24                	jbe    f0104eef <pci_conf1_set_addr+0x5e>
f0104ecb:	c7 44 24 0c c5 6e 10 	movl   $0xf0106ec5,0xc(%esp)
f0104ed2:	f0 
f0104ed3:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0104eda:	f0 
f0104edb:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
f0104ee2:	00 
f0104ee3:	c7 04 24 ba 6e 10 f0 	movl   $0xf0106eba,(%esp)
f0104eea:	e8 96 b1 ff ff       	call   f0100085 <_panic>
	assert(func < 8);
f0104eef:	83 f9 07             	cmp    $0x7,%ecx
f0104ef2:	76 24                	jbe    f0104f18 <pci_conf1_set_addr+0x87>
f0104ef4:	c7 44 24 0c ce 6e 10 	movl   $0xf0106ece,0xc(%esp)
f0104efb:	f0 
f0104efc:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0104f03:	f0 
f0104f04:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
f0104f0b:	00 
f0104f0c:	c7 04 24 ba 6e 10 f0 	movl   $0xf0106eba,(%esp)
f0104f13:	e8 6d b1 ff ff       	call   f0100085 <_panic>
	assert(offset < 256);
f0104f18:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0104f1e:	76 24                	jbe    f0104f44 <pci_conf1_set_addr+0xb3>
f0104f20:	c7 44 24 0c d7 6e 10 	movl   $0xf0106ed7,0xc(%esp)
f0104f27:	f0 
f0104f28:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0104f2f:	f0 
f0104f30:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
f0104f37:	00 
f0104f38:	c7 04 24 ba 6e 10 f0 	movl   $0xf0106eba,(%esp)
f0104f3f:	e8 41 b1 ff ff       	call   f0100085 <_panic>
	assert((offset & 0x3) == 0);
f0104f44:	f6 c3 03             	test   $0x3,%bl
f0104f47:	74 24                	je     f0104f6d <pci_conf1_set_addr+0xdc>
f0104f49:	c7 44 24 0c e4 6e 10 	movl   $0xf0106ee4,0xc(%esp)
f0104f50:	f0 
f0104f51:	c7 44 24 08 07 63 10 	movl   $0xf0106307,0x8(%esp)
f0104f58:	f0 
f0104f59:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
f0104f60:	00 
f0104f61:	c7 04 24 ba 6e 10 f0 	movl   $0xf0106eba,(%esp)
f0104f68:	e8 18 b1 ff ff       	call   f0100085 <_panic>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0104f6d:	c1 e0 10             	shl    $0x10,%eax
f0104f70:	0d 00 00 00 80       	or     $0x80000000,%eax
f0104f75:	c1 e2 0b             	shl    $0xb,%edx
f0104f78:	09 d0                	or     %edx,%eax
f0104f7a:	09 d8                	or     %ebx,%eax
f0104f7c:	c1 e1 08             	shl    $0x8,%ecx
f0104f7f:	09 c8                	or     %ecx,%eax
f0104f81:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0104f86:	ef                   	out    %eax,(%dx)
	
	uint32_t v = (1 << 31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f0104f87:	83 c4 14             	add    $0x14,%esp
f0104f8a:	5b                   	pop    %ebx
f0104f8b:	5d                   	pop    %ebp
f0104f8c:	c3                   	ret    

f0104f8d <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f0104f8d:	55                   	push   %ebp
f0104f8e:	89 e5                	mov    %esp,%ebp
f0104f90:	53                   	push   %ebx
f0104f91:	83 ec 14             	sub    $0x14,%esp
f0104f94:	89 d3                	mov    %edx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0104f96:	8b 48 08             	mov    0x8(%eax),%ecx
f0104f99:	8b 50 04             	mov    0x4(%eax),%edx
f0104f9c:	8b 00                	mov    (%eax),%eax
f0104f9e:	8b 40 04             	mov    0x4(%eax),%eax
f0104fa1:	89 1c 24             	mov    %ebx,(%esp)
f0104fa4:	e8 e8 fe ff ff       	call   f0104e91 <pci_conf1_set_addr>

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0104fa9:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0104fae:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f0104faf:	83 c4 14             	add    $0x14,%esp
f0104fb2:	5b                   	pop    %ebx
f0104fb3:	5d                   	pop    %ebp
f0104fb4:	c3                   	ret    

f0104fb5 <pci_scan_bus>:
		f->irq_line);
}

static int 
pci_scan_bus(struct pci_bus *bus)
{
f0104fb5:	55                   	push   %ebp
f0104fb6:	89 e5                	mov    %esp,%ebp
f0104fb8:	57                   	push   %edi
f0104fb9:	56                   	push   %esi
f0104fba:	53                   	push   %ebx
f0104fbb:	81 ec 3c 01 00 00    	sub    $0x13c,%esp
f0104fc1:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0104fc3:	c7 44 24 08 48 00 00 	movl   $0x48,0x8(%esp)
f0104fca:	00 
f0104fcb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0104fd2:	00 
f0104fd3:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0104fd6:	89 04 24             	mov    %eax,(%esp)
f0104fd9:	e8 58 f6 ff ff       	call   f0104636 <memset>
	df.bus = bus;
f0104fde:	89 5d a0             	mov    %ebx,-0x60(%ebp)
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0104fe1:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
};

static void 
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
f0104fe8:	c7 85 fc fe ff ff 00 	movl   $0x0,-0x104(%ebp)
f0104fef:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0104ff2:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0104ff5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
			continue;
		
		totaldev++;
		
		struct pci_func f = df;
f0104ffb:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
f0105001:	89 8d f4 fe ff ff    	mov    %ecx,-0x10c(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
			struct pci_func af = f;
f0105007:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f010500d:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
f0105013:	89 8d 00 ff ff ff    	mov    %ecx,-0x100(%ebp)
f0105019:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f010501f:	ba 0c 00 00 00       	mov    $0xc,%edx
f0105024:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0105027:	e8 61 ff ff ff       	call   f0104f8d <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f010502c:	89 c2                	mov    %eax,%edx
f010502e:	c1 ea 10             	shr    $0x10,%edx
f0105031:	83 e2 7f             	and    $0x7f,%edx
f0105034:	83 fa 01             	cmp    $0x1,%edx
f0105037:	0f 87 77 01 00 00    	ja     f01051b4 <pci_scan_bus+0x1ff>
			continue;
		
		totaldev++;
		
		struct pci_func f = df;
f010503d:	b9 12 00 00 00       	mov    $0x12,%ecx
f0105042:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
f0105048:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
f010504e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0105050:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
f0105057:	00 00 00 
f010505a:	89 c3                	mov    %eax,%ebx
f010505c:	81 e3 00 00 80 00    	and    $0x800000,%ebx
f0105062:	e9 2f 01 00 00       	jmp    f0105196 <pci_scan_bus+0x1e1>
		     f.func++) {
			struct pci_func af = f;
f0105067:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
f010506d:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
f0105073:	b9 12 00 00 00       	mov    $0x12,%ecx
f0105078:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			
			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f010507a:	ba 00 00 00 00       	mov    $0x0,%edx
f010507f:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0105085:	e8 03 ff ff ff       	call   f0104f8d <pci_conf_read>
f010508a:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0105090:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f0105094:	0f 84 f5 00 00 00    	je     f010518f <pci_scan_bus+0x1da>
				continue;
			
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f010509a:	ba 3c 00 00 00       	mov    $0x3c,%edx
f010509f:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f01050a5:	e8 e3 fe ff ff       	call   f0104f8d <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f01050aa:	88 85 54 ff ff ff    	mov    %al,-0xac(%ebp)
			
			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f01050b0:	ba 08 00 00 00       	mov    $0x8,%edx
f01050b5:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f01050bb:	e8 cd fe ff ff       	call   f0104f8d <pci_conf_read>
f01050c0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)

static void 
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f01050c6:	89 c2                	mov    %eax,%edx
f01050c8:	c1 ea 18             	shr    $0x18,%edx
f01050cb:	b9 f8 6e 10 f0       	mov    $0xf0106ef8,%ecx
f01050d0:	83 fa 06             	cmp    $0x6,%edx
f01050d3:	77 07                	ja     f01050dc <pci_scan_bus+0x127>
		class = pci_class[PCI_CLASS(f->dev_class)];
f01050d5:	8b 0c 95 6c 6f 10 f0 	mov    -0xfef9094(,%edx,4),%ecx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f01050dc:	8b bd 1c ff ff ff    	mov    -0xe4(%ebp),%edi
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f01050e2:	0f b6 b5 54 ff ff ff 	movzbl -0xac(%ebp),%esi
f01050e9:	89 74 24 24          	mov    %esi,0x24(%esp)
f01050ed:	89 4c 24 20          	mov    %ecx,0x20(%esp)
f01050f1:	c1 e8 10             	shr    $0x10,%eax
f01050f4:	25 ff 00 00 00       	and    $0xff,%eax
f01050f9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f01050fd:	89 54 24 18          	mov    %edx,0x18(%esp)
f0105101:	89 f8                	mov    %edi,%eax
f0105103:	c1 e8 10             	shr    $0x10,%eax
f0105106:	89 44 24 14          	mov    %eax,0x14(%esp)
f010510a:	81 e7 ff ff 00 00    	and    $0xffff,%edi
f0105110:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0105114:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
f010511a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010511e:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
f0105124:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105128:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
f010512e:	8b 40 04             	mov    0x4(%eax),%eax
f0105131:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105135:	c7 04 24 3c 6d 10 f0 	movl   $0xf0106d3c,(%esp)
f010513c:	e8 26 d8 ff ff       	call   f0102967 <cprintf>
static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class), 
				 PCI_SUBCLASS(f->dev_class),
f0105141:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
				 &pci_attach_class[0], f) ||
f0105147:	89 c2                	mov    %eax,%edx
f0105149:	c1 ea 10             	shr    $0x10,%edx
f010514c:	81 e2 ff 00 00 00    	and    $0xff,%edx
f0105152:	c1 e8 18             	shr    $0x18,%eax
f0105155:	8b 8d 04 ff ff ff    	mov    -0xfc(%ebp),%ecx
f010515b:	89 0c 24             	mov    %ecx,(%esp)
f010515e:	b9 64 d3 11 f0       	mov    $0xf011d364,%ecx
f0105163:	e8 b8 fc ff ff       	call   f0104e20 <pci_attach_match>

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class), 
f0105168:	85 c0                	test   %eax,%eax
f010516a:	75 23                	jne    f010518f <pci_scan_bus+0x1da>
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id), 
				 PCI_PRODUCT(f->dev_id),
f010516c:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
				 &pci_attach_vendor[0], f);
f0105172:	89 c2                	mov    %eax,%edx
f0105174:	c1 ea 10             	shr    $0x10,%edx
f0105177:	25 ff ff 00 00       	and    $0xffff,%eax
f010517c:	8b 8d 04 ff ff ff    	mov    -0xfc(%ebp),%ecx
f0105182:	89 0c 24             	mov    %ecx,(%esp)
f0105185:	b9 7c d3 11 f0       	mov    $0xf011d37c,%ecx
f010518a:	e8 91 fc ff ff       	call   f0104e20 <pci_attach_match>
		
		totaldev++;
		
		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f010518f:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
			continue;
		
		totaldev++;
		
		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0105196:	83 fb 01             	cmp    $0x1,%ebx
f0105199:	19 c0                	sbb    %eax,%eax
f010519b:	83 e0 f9             	and    $0xfffffff9,%eax
f010519e:	83 c0 08             	add    $0x8,%eax
f01051a1:	3b 85 60 ff ff ff    	cmp    -0xa0(%ebp),%eax
f01051a7:	0f 87 ba fe ff ff    	ja     f0105067 <pci_scan_bus+0xb2>
	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
			continue;
		
		totaldev++;
f01051ad:	83 85 fc fe ff ff 01 	addl   $0x1,-0x104(%ebp)
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
f01051b4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f01051b7:	83 c0 01             	add    $0x1,%eax
f01051ba:	83 f8 1f             	cmp    $0x1f,%eax
f01051bd:	77 08                	ja     f01051c7 <pci_scan_bus+0x212>
f01051bf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f01051c2:	e9 58 fe ff ff       	jmp    f010501f <pci_scan_bus+0x6a>
			pci_attach(&af);
		}
	}
	
	return totaldev;
}
f01051c7:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
f01051cd:	81 c4 3c 01 00 00    	add    $0x13c,%esp
f01051d3:	5b                   	pop    %ebx
f01051d4:	5e                   	pop    %esi
f01051d5:	5f                   	pop    %edi
f01051d6:	5d                   	pop    %ebp
f01051d7:	c3                   	ret    

f01051d8 <pci_init>:
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}

int
pci_init(void)
{
f01051d8:	55                   	push   %ebp
f01051d9:	89 e5                	mov    %esp,%ebp
f01051db:	83 ec 18             	sub    $0x18,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f01051de:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f01051e5:	00 
f01051e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01051ed:	00 
f01051ee:	c7 04 24 14 8a 3c f0 	movl   $0xf03c8a14,(%esp)
f01051f5:	e8 3c f4 ff ff       	call   f0104636 <memset>
	
	return pci_scan_bus(&root_bus);
f01051fa:	b8 14 8a 3c f0       	mov    $0xf03c8a14,%eax
f01051ff:	e8 b1 fd ff ff       	call   f0104fb5 <pci_scan_bus>
}
f0105204:	c9                   	leave  
f0105205:	c3                   	ret    

f0105206 <pci_bridge_attach>:
	return totaldev;
}

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0105206:	55                   	push   %ebp
f0105207:	89 e5                	mov    %esp,%ebp
f0105209:	83 ec 48             	sub    $0x48,%esp
f010520c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f010520f:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0105212:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0105215:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0105218:	ba 1c 00 00 00       	mov    $0x1c,%edx
f010521d:	89 d8                	mov    %ebx,%eax
f010521f:	e8 69 fd ff ff       	call   f0104f8d <pci_conf_read>
f0105224:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0105226:	ba 18 00 00 00       	mov    $0x18,%edx
f010522b:	89 d8                	mov    %ebx,%eax
f010522d:	e8 5b fd ff ff       	call   f0104f8d <pci_conf_read>
f0105232:	89 c6                	mov    %eax,%esi
	
	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0105234:	83 e7 0f             	and    $0xf,%edi
f0105237:	83 ff 01             	cmp    $0x1,%edi
f010523a:	75 2a                	jne    f0105266 <pci_bridge_attach+0x60>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f010523c:	8b 43 08             	mov    0x8(%ebx),%eax
f010523f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105243:	8b 43 04             	mov    0x4(%ebx),%eax
f0105246:	89 44 24 08          	mov    %eax,0x8(%esp)
f010524a:	8b 03                	mov    (%ebx),%eax
f010524c:	8b 40 04             	mov    0x4(%eax),%eax
f010524f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105253:	c7 04 24 78 6d 10 f0 	movl   $0xf0106d78,(%esp)
f010525a:	e8 08 d7 ff ff       	call   f0102967 <cprintf>
f010525f:	b8 00 00 00 00       	mov    $0x0,%eax
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f0105264:	eb 66                	jmp    f01052cc <pci_bridge_attach+0xc6>
	}
	
	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0105266:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f010526d:	00 
f010526e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0105275:	00 
f0105276:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0105279:	89 3c 24             	mov    %edi,(%esp)
f010527c:	e8 b5 f3 ff ff       	call   f0104636 <memset>
	nbus.parent_bridge = pcif;
f0105281:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0105284:	89 f2                	mov    %esi,%edx
f0105286:	0f b6 c6             	movzbl %dh,%eax
f0105289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	
	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f010528c:	c1 ee 10             	shr    $0x10,%esi
f010528f:	81 e6 ff 00 00 00    	and    $0xff,%esi
f0105295:	89 74 24 14          	mov    %esi,0x14(%esp)
f0105299:	89 44 24 10          	mov    %eax,0x10(%esp)
f010529d:	8b 43 08             	mov    0x8(%ebx),%eax
f01052a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01052a4:	8b 43 04             	mov    0x4(%ebx),%eax
f01052a7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01052ab:	8b 03                	mov    (%ebx),%eax
f01052ad:	8b 40 04             	mov    0x4(%eax),%eax
f01052b0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052b4:	c7 04 24 ac 6d 10 f0 	movl   $0xf0106dac,(%esp)
f01052bb:	e8 a7 d6 ff ff       	call   f0102967 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
	
	pci_scan_bus(&nbus);
f01052c0:	89 f8                	mov    %edi,%eax
f01052c2:	e8 ee fc ff ff       	call   f0104fb5 <pci_scan_bus>
f01052c7:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
}
f01052cc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f01052cf:	8b 75 f8             	mov    -0x8(%ebp),%esi
f01052d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
f01052d5:	89 ec                	mov    %ebp,%esp
f01052d7:	5d                   	pop    %ebp
f01052d8:	c3                   	ret    

f01052d9 <pci_conf_write>:
	return inl(pci_conf1_data_ioport);
}

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f01052d9:	55                   	push   %ebp
f01052da:	89 e5                	mov    %esp,%ebp
f01052dc:	83 ec 18             	sub    $0x18,%esp
f01052df:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f01052e2:	89 75 fc             	mov    %esi,-0x4(%ebp)
f01052e5:	89 d3                	mov    %edx,%ebx
f01052e7:	89 ce                	mov    %ecx,%esi
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01052e9:	8b 48 08             	mov    0x8(%eax),%ecx
f01052ec:	8b 50 04             	mov    0x4(%eax),%edx
f01052ef:	8b 00                	mov    (%eax),%eax
f01052f1:	8b 40 04             	mov    0x4(%eax),%eax
f01052f4:	89 1c 24             	mov    %ebx,(%esp)
f01052f7:	e8 95 fb ff ff       	call   f0104e91 <pci_conf1_set_addr>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01052fc:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0105301:	89 f0                	mov    %esi,%eax
f0105303:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f0105304:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0105307:	8b 75 fc             	mov    -0x4(%ebp),%esi
f010530a:	89 ec                	mov    %ebp,%esp
f010530c:	5d                   	pop    %ebp
f010530d:	c3                   	ret    

f010530e <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f010530e:	55                   	push   %ebp
f010530f:	89 e5                	mov    %esp,%ebp
f0105311:	57                   	push   %edi
f0105312:	56                   	push   %esi
f0105313:	53                   	push   %ebx
f0105314:	83 ec 4c             	sub    $0x4c,%esp
f0105317:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f010531a:	b9 07 00 00 00       	mov    $0x7,%ecx
f010531f:	ba 04 00 00 00       	mov    $0x4,%edx
f0105324:	89 d8                	mov    %ebx,%eax
f0105326:	e8 ae ff ff ff       	call   f01052d9 <pci_conf_write>
f010532b:	be 10 00 00 00       	mov    $0x10,%esi
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f0105330:	89 f2                	mov    %esi,%edx
f0105332:	89 d8                	mov    %ebx,%eax
f0105334:	e8 54 fc ff ff       	call   f0104f8d <pci_conf_read>
f0105339:	89 45 dc             	mov    %eax,-0x24(%ebp)
		
		bar_width = 4;
		pci_conf_write(f, bar, 0xffffffff);
f010533c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0105341:	89 f2                	mov    %esi,%edx
f0105343:	89 d8                	mov    %ebx,%eax
f0105345:	e8 8f ff ff ff       	call   f01052d9 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f010534a:	89 f2                	mov    %esi,%edx
f010534c:	89 d8                	mov    %ebx,%eax
f010534e:	e8 3a fc ff ff       	call   f0104f8d <pci_conf_read>
		
		if (rv == 0)
f0105353:	bf 04 00 00 00       	mov    $0x4,%edi
f0105358:	85 c0                	test   %eax,%eax
f010535a:	0f 84 00 01 00 00    	je     f0105460 <pci_func_enable+0x152>
			continue;
		
		int regnum = PCI_MAPREG_NUM(bar);
f0105360:	8d 56 f0             	lea    -0x10(%esi),%edx
f0105363:	c1 ea 02             	shr    $0x2,%edx
f0105366:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0105369:	a8 01                	test   $0x1,%al
f010536b:	75 4a                	jne    f01053b7 <pci_func_enable+0xa9>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f010536d:	89 c2                	mov    %eax,%edx
f010536f:	83 e2 06             	and    $0x6,%edx
f0105372:	83 fa 04             	cmp    $0x4,%edx
f0105375:	0f 94 c2             	sete   %dl
f0105378:	0f b6 fa             	movzbl %dl,%edi
f010537b:	8d 3c bd 04 00 00 00 	lea    0x4(,%edi,4),%edi
				bar_width = 8;
			
			size = PCI_MAPREG_MEM_SIZE(rv);
f0105382:	83 e0 f0             	and    $0xfffffff0,%eax
f0105385:	89 c2                	mov    %eax,%edx
f0105387:	f7 da                	neg    %edx
f0105389:	21 d0                	and    %edx,%eax
f010538b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f010538e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105391:	83 e0 f0             	and    $0xfffffff0,%eax
f0105394:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
f0105397:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010539b:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010539e:	89 54 24 08          	mov    %edx,0x8(%esp)
f01053a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01053a5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053a9:	c7 04 24 dc 6d 10 f0 	movl   $0xf0106ddc,(%esp)
f01053b0:	e8 b2 d5 ff ff       	call   f0102967 <cprintf>
f01053b5:	eb 35                	jmp    f01053ec <pci_func_enable+0xde>
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f01053b7:	83 e0 fc             	and    $0xfffffffc,%eax
f01053ba:	89 c2                	mov    %eax,%edx
f01053bc:	f7 da                	neg    %edx
f01053be:	21 d0                	and    %edx,%eax
f01053c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f01053c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01053c6:	83 e2 fc             	and    $0xfffffffc,%edx
f01053c9:	89 55 d8             	mov    %edx,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
f01053cc:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01053d0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01053d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01053d7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053db:	c7 04 24 00 6e 10 f0 	movl   $0xf0106e00,(%esp)
f01053e2:	e8 80 d5 ff ff       	call   f0102967 <cprintf>
f01053e7:	bf 04 00 00 00       	mov    $0x4,%edi
					regnum, size, base);
		}
		
		pci_conf_write(f, bar, oldv);
f01053ec:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01053ef:	89 f2                	mov    %esi,%edx
f01053f1:	89 d8                	mov    %ebx,%eax
f01053f3:	e8 e1 fe ff ff       	call   f01052d9 <pci_conf_write>
		f->reg_base[regnum] = base;
f01053f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01053fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01053fe:	89 44 93 14          	mov    %eax,0x14(%ebx,%edx,4)
		f->reg_size[regnum] = size;
f0105402:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105405:	89 44 93 2c          	mov    %eax,0x2c(%ebx,%edx,4)
		
		if (size && !base)
f0105409:	85 c0                	test   %eax,%eax
f010540b:	74 53                	je     f0105460 <pci_func_enable+0x152>
f010540d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105411:	75 4d                	jne    f0105460 <pci_func_enable+0x152>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0105413:	8b 43 0c             	mov    0xc(%ebx),%eax
		pci_conf_write(f, bar, oldv);
		f->reg_base[regnum] = base;
		f->reg_size[regnum] = size;
		
		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0105416:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105419:	89 54 24 20          	mov    %edx,0x20(%esp)
f010541d:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105420:	89 54 24 1c          	mov    %edx,0x1c(%esp)
f0105424:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105427:	89 54 24 18          	mov    %edx,0x18(%esp)
f010542b:	89 c2                	mov    %eax,%edx
f010542d:	c1 ea 10             	shr    $0x10,%edx
f0105430:	89 54 24 14          	mov    %edx,0x14(%esp)
f0105434:	25 ff ff 00 00       	and    $0xffff,%eax
f0105439:	89 44 24 10          	mov    %eax,0x10(%esp)
f010543d:	8b 43 08             	mov    0x8(%ebx),%eax
f0105440:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105444:	8b 43 04             	mov    0x4(%ebx),%eax
f0105447:	89 44 24 08          	mov    %eax,0x8(%esp)
f010544b:	8b 03                	mov    (%ebx),%eax
f010544d:	8b 40 04             	mov    0x4(%eax),%eax
f0105450:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105454:	c7 04 24 24 6e 10 f0 	movl   $0xf0106e24,(%esp)
f010545b:	e8 07 d5 ff ff       	call   f0102967 <cprintf>
		       PCI_COMMAND_MASTER_ENABLE);
	
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
f0105460:	01 fe                	add    %edi,%esi
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);
	
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0105462:	83 fe 27             	cmp    $0x27,%esi
f0105465:	0f 86 c5 fe ff ff    	jbe    f0105330 <pci_func_enable+0x22>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f010546b:	8b 43 0c             	mov    0xc(%ebx),%eax
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f010546e:	89 c2                	mov    %eax,%edx
f0105470:	c1 ea 10             	shr    $0x10,%edx
f0105473:	89 54 24 14          	mov    %edx,0x14(%esp)
f0105477:	25 ff ff 00 00       	and    $0xffff,%eax
f010547c:	89 44 24 10          	mov    %eax,0x10(%esp)
f0105480:	8b 43 08             	mov    0x8(%ebx),%eax
f0105483:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105487:	8b 43 04             	mov    0x4(%ebx),%eax
f010548a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010548e:	8b 03                	mov    (%ebx),%eax
f0105490:	8b 40 04             	mov    0x4(%eax),%eax
f0105493:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105497:	c7 04 24 80 6e 10 f0 	movl   $0xf0106e80,(%esp)
f010549e:	e8 c4 d4 ff ff       	call   f0102967 <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}
f01054a3:	83 c4 4c             	add    $0x4c,%esp
f01054a6:	5b                   	pop    %ebx
f01054a7:	5e                   	pop    %esi
f01054a8:	5f                   	pop    %edi
f01054a9:	5d                   	pop    %ebp
f01054aa:	c3                   	ret    
	...

f01054ac <time_init>:

static unsigned int ticks;

void
time_init(void) 
{
f01054ac:	55                   	push   %ebp
f01054ad:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f01054af:	c7 05 1c 8a 3c f0 00 	movl   $0x0,0xf03c8a1c
f01054b6:	00 00 00 
}
f01054b9:	5d                   	pop    %ebp
f01054ba:	c3                   	ret    

f01054bb <time_msec>:
		panic("time_tick: time overflowed");
}

unsigned int
time_msec(void) 
{
f01054bb:	55                   	push   %ebp
f01054bc:	89 e5                	mov    %esp,%ebp
f01054be:	a1 1c 8a 3c f0       	mov    0xf03c8a1c,%eax
f01054c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01054c6:	01 c0                	add    %eax,%eax
	return ticks * 10;
}
f01054c8:	5d                   	pop    %ebp
f01054c9:	c3                   	ret    

f01054ca <time_tick>:

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void) 
{
f01054ca:	55                   	push   %ebp
f01054cb:	89 e5                	mov    %esp,%ebp
f01054cd:	83 ec 18             	sub    $0x18,%esp
	ticks++;
f01054d0:	a1 1c 8a 3c f0       	mov    0xf03c8a1c,%eax
f01054d5:	83 c0 01             	add    $0x1,%eax
f01054d8:	a3 1c 8a 3c f0       	mov    %eax,0xf03c8a1c
	if (ticks * 10 < ticks)
f01054dd:	8d 14 80             	lea    (%eax,%eax,4),%edx
f01054e0:	01 d2                	add    %edx,%edx
f01054e2:	39 d0                	cmp    %edx,%eax
f01054e4:	76 1c                	jbe    f0105502 <time_tick+0x38>
		panic("time_tick: time overflowed");
f01054e6:	c7 44 24 08 88 6f 10 	movl   $0xf0106f88,0x8(%esp)
f01054ed:	f0 
f01054ee:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
f01054f5:	00 
f01054f6:	c7 04 24 a3 6f 10 f0 	movl   $0xf0106fa3,(%esp)
f01054fd:	e8 83 ab ff ff       	call   f0100085 <_panic>
}
f0105502:	c9                   	leave  
f0105503:	c3                   	ret    
	...

f0105510 <__udivdi3>:
f0105510:	55                   	push   %ebp
f0105511:	89 e5                	mov    %esp,%ebp
f0105513:	57                   	push   %edi
f0105514:	56                   	push   %esi
f0105515:	83 ec 10             	sub    $0x10,%esp
f0105518:	8b 45 14             	mov    0x14(%ebp),%eax
f010551b:	8b 55 08             	mov    0x8(%ebp),%edx
f010551e:	8b 75 10             	mov    0x10(%ebp),%esi
f0105521:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105524:	85 c0                	test   %eax,%eax
f0105526:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0105529:	75 35                	jne    f0105560 <__udivdi3+0x50>
f010552b:	39 fe                	cmp    %edi,%esi
f010552d:	77 61                	ja     f0105590 <__udivdi3+0x80>
f010552f:	85 f6                	test   %esi,%esi
f0105531:	75 0b                	jne    f010553e <__udivdi3+0x2e>
f0105533:	b8 01 00 00 00       	mov    $0x1,%eax
f0105538:	31 d2                	xor    %edx,%edx
f010553a:	f7 f6                	div    %esi
f010553c:	89 c6                	mov    %eax,%esi
f010553e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0105541:	31 d2                	xor    %edx,%edx
f0105543:	89 f8                	mov    %edi,%eax
f0105545:	f7 f6                	div    %esi
f0105547:	89 c7                	mov    %eax,%edi
f0105549:	89 c8                	mov    %ecx,%eax
f010554b:	f7 f6                	div    %esi
f010554d:	89 c1                	mov    %eax,%ecx
f010554f:	89 fa                	mov    %edi,%edx
f0105551:	89 c8                	mov    %ecx,%eax
f0105553:	83 c4 10             	add    $0x10,%esp
f0105556:	5e                   	pop    %esi
f0105557:	5f                   	pop    %edi
f0105558:	5d                   	pop    %ebp
f0105559:	c3                   	ret    
f010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0105560:	39 f8                	cmp    %edi,%eax
f0105562:	77 1c                	ja     f0105580 <__udivdi3+0x70>
f0105564:	0f bd d0             	bsr    %eax,%edx
f0105567:	83 f2 1f             	xor    $0x1f,%edx
f010556a:	89 55 f4             	mov    %edx,-0xc(%ebp)
f010556d:	75 39                	jne    f01055a8 <__udivdi3+0x98>
f010556f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0105572:	0f 86 a0 00 00 00    	jbe    f0105618 <__udivdi3+0x108>
f0105578:	39 f8                	cmp    %edi,%eax
f010557a:	0f 82 98 00 00 00    	jb     f0105618 <__udivdi3+0x108>
f0105580:	31 ff                	xor    %edi,%edi
f0105582:	31 c9                	xor    %ecx,%ecx
f0105584:	89 c8                	mov    %ecx,%eax
f0105586:	89 fa                	mov    %edi,%edx
f0105588:	83 c4 10             	add    $0x10,%esp
f010558b:	5e                   	pop    %esi
f010558c:	5f                   	pop    %edi
f010558d:	5d                   	pop    %ebp
f010558e:	c3                   	ret    
f010558f:	90                   	nop
f0105590:	89 d1                	mov    %edx,%ecx
f0105592:	89 fa                	mov    %edi,%edx
f0105594:	89 c8                	mov    %ecx,%eax
f0105596:	31 ff                	xor    %edi,%edi
f0105598:	f7 f6                	div    %esi
f010559a:	89 c1                	mov    %eax,%ecx
f010559c:	89 fa                	mov    %edi,%edx
f010559e:	89 c8                	mov    %ecx,%eax
f01055a0:	83 c4 10             	add    $0x10,%esp
f01055a3:	5e                   	pop    %esi
f01055a4:	5f                   	pop    %edi
f01055a5:	5d                   	pop    %ebp
f01055a6:	c3                   	ret    
f01055a7:	90                   	nop
f01055a8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f01055ac:	89 f2                	mov    %esi,%edx
f01055ae:	d3 e0                	shl    %cl,%eax
f01055b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01055b3:	b8 20 00 00 00       	mov    $0x20,%eax
f01055b8:	2b 45 f4             	sub    -0xc(%ebp),%eax
f01055bb:	89 c1                	mov    %eax,%ecx
f01055bd:	d3 ea                	shr    %cl,%edx
f01055bf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f01055c3:	0b 55 ec             	or     -0x14(%ebp),%edx
f01055c6:	d3 e6                	shl    %cl,%esi
f01055c8:	89 c1                	mov    %eax,%ecx
f01055ca:	89 75 e8             	mov    %esi,-0x18(%ebp)
f01055cd:	89 fe                	mov    %edi,%esi
f01055cf:	d3 ee                	shr    %cl,%esi
f01055d1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f01055d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
f01055d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01055db:	d3 e7                	shl    %cl,%edi
f01055dd:	89 c1                	mov    %eax,%ecx
f01055df:	d3 ea                	shr    %cl,%edx
f01055e1:	09 d7                	or     %edx,%edi
f01055e3:	89 f2                	mov    %esi,%edx
f01055e5:	89 f8                	mov    %edi,%eax
f01055e7:	f7 75 ec             	divl   -0x14(%ebp)
f01055ea:	89 d6                	mov    %edx,%esi
f01055ec:	89 c7                	mov    %eax,%edi
f01055ee:	f7 65 e8             	mull   -0x18(%ebp)
f01055f1:	39 d6                	cmp    %edx,%esi
f01055f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
f01055f6:	72 30                	jb     f0105628 <__udivdi3+0x118>
f01055f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f01055fb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f01055ff:	d3 e2                	shl    %cl,%edx
f0105601:	39 c2                	cmp    %eax,%edx
f0105603:	73 05                	jae    f010560a <__udivdi3+0xfa>
f0105605:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0105608:	74 1e                	je     f0105628 <__udivdi3+0x118>
f010560a:	89 f9                	mov    %edi,%ecx
f010560c:	31 ff                	xor    %edi,%edi
f010560e:	e9 71 ff ff ff       	jmp    f0105584 <__udivdi3+0x74>
f0105613:	90                   	nop
f0105614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105618:	31 ff                	xor    %edi,%edi
f010561a:	b9 01 00 00 00       	mov    $0x1,%ecx
f010561f:	e9 60 ff ff ff       	jmp    f0105584 <__udivdi3+0x74>
f0105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105628:	8d 4f ff             	lea    -0x1(%edi),%ecx
f010562b:	31 ff                	xor    %edi,%edi
f010562d:	89 c8                	mov    %ecx,%eax
f010562f:	89 fa                	mov    %edi,%edx
f0105631:	83 c4 10             	add    $0x10,%esp
f0105634:	5e                   	pop    %esi
f0105635:	5f                   	pop    %edi
f0105636:	5d                   	pop    %ebp
f0105637:	c3                   	ret    
	...

f0105640 <__umoddi3>:
f0105640:	55                   	push   %ebp
f0105641:	89 e5                	mov    %esp,%ebp
f0105643:	57                   	push   %edi
f0105644:	56                   	push   %esi
f0105645:	83 ec 20             	sub    $0x20,%esp
f0105648:	8b 55 14             	mov    0x14(%ebp),%edx
f010564b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010564e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105651:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105654:	85 d2                	test   %edx,%edx
f0105656:	89 c8                	mov    %ecx,%eax
f0105658:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f010565b:	75 13                	jne    f0105670 <__umoddi3+0x30>
f010565d:	39 f7                	cmp    %esi,%edi
f010565f:	76 3f                	jbe    f01056a0 <__umoddi3+0x60>
f0105661:	89 f2                	mov    %esi,%edx
f0105663:	f7 f7                	div    %edi
f0105665:	89 d0                	mov    %edx,%eax
f0105667:	31 d2                	xor    %edx,%edx
f0105669:	83 c4 20             	add    $0x20,%esp
f010566c:	5e                   	pop    %esi
f010566d:	5f                   	pop    %edi
f010566e:	5d                   	pop    %ebp
f010566f:	c3                   	ret    
f0105670:	39 f2                	cmp    %esi,%edx
f0105672:	77 4c                	ja     f01056c0 <__umoddi3+0x80>
f0105674:	0f bd ca             	bsr    %edx,%ecx
f0105677:	83 f1 1f             	xor    $0x1f,%ecx
f010567a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f010567d:	75 51                	jne    f01056d0 <__umoddi3+0x90>
f010567f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f0105682:	0f 87 e0 00 00 00    	ja     f0105768 <__umoddi3+0x128>
f0105688:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010568b:	29 f8                	sub    %edi,%eax
f010568d:	19 d6                	sbb    %edx,%esi
f010568f:	89 45 f4             	mov    %eax,-0xc(%ebp)
f0105692:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105695:	89 f2                	mov    %esi,%edx
f0105697:	83 c4 20             	add    $0x20,%esp
f010569a:	5e                   	pop    %esi
f010569b:	5f                   	pop    %edi
f010569c:	5d                   	pop    %ebp
f010569d:	c3                   	ret    
f010569e:	66 90                	xchg   %ax,%ax
f01056a0:	85 ff                	test   %edi,%edi
f01056a2:	75 0b                	jne    f01056af <__umoddi3+0x6f>
f01056a4:	b8 01 00 00 00       	mov    $0x1,%eax
f01056a9:	31 d2                	xor    %edx,%edx
f01056ab:	f7 f7                	div    %edi
f01056ad:	89 c7                	mov    %eax,%edi
f01056af:	89 f0                	mov    %esi,%eax
f01056b1:	31 d2                	xor    %edx,%edx
f01056b3:	f7 f7                	div    %edi
f01056b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01056b8:	f7 f7                	div    %edi
f01056ba:	eb a9                	jmp    f0105665 <__umoddi3+0x25>
f01056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01056c0:	89 c8                	mov    %ecx,%eax
f01056c2:	89 f2                	mov    %esi,%edx
f01056c4:	83 c4 20             	add    $0x20,%esp
f01056c7:	5e                   	pop    %esi
f01056c8:	5f                   	pop    %edi
f01056c9:	5d                   	pop    %ebp
f01056ca:	c3                   	ret    
f01056cb:	90                   	nop
f01056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01056d0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f01056d4:	d3 e2                	shl    %cl,%edx
f01056d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
f01056d9:	ba 20 00 00 00       	mov    $0x20,%edx
f01056de:	2b 55 f0             	sub    -0x10(%ebp),%edx
f01056e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
f01056e4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01056e8:	89 fa                	mov    %edi,%edx
f01056ea:	d3 ea                	shr    %cl,%edx
f01056ec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f01056f0:	0b 55 f4             	or     -0xc(%ebp),%edx
f01056f3:	d3 e7                	shl    %cl,%edi
f01056f5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01056f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
f01056fc:	89 f2                	mov    %esi,%edx
f01056fe:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0105701:	89 c7                	mov    %eax,%edi
f0105703:	d3 ea                	shr    %cl,%edx
f0105705:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0105709:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010570c:	89 c2                	mov    %eax,%edx
f010570e:	d3 e6                	shl    %cl,%esi
f0105710:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0105714:	d3 ea                	shr    %cl,%edx
f0105716:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f010571a:	09 d6                	or     %edx,%esi
f010571c:	89 f0                	mov    %esi,%eax
f010571e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0105721:	d3 e7                	shl    %cl,%edi
f0105723:	89 f2                	mov    %esi,%edx
f0105725:	f7 75 f4             	divl   -0xc(%ebp)
f0105728:	89 d6                	mov    %edx,%esi
f010572a:	f7 65 e8             	mull   -0x18(%ebp)
f010572d:	39 d6                	cmp    %edx,%esi
f010572f:	72 2b                	jb     f010575c <__umoddi3+0x11c>
f0105731:	39 c7                	cmp    %eax,%edi
f0105733:	72 23                	jb     f0105758 <__umoddi3+0x118>
f0105735:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0105739:	29 c7                	sub    %eax,%edi
f010573b:	19 d6                	sbb    %edx,%esi
f010573d:	89 f0                	mov    %esi,%eax
f010573f:	89 f2                	mov    %esi,%edx
f0105741:	d3 ef                	shr    %cl,%edi
f0105743:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0105747:	d3 e0                	shl    %cl,%eax
f0105749:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f010574d:	09 f8                	or     %edi,%eax
f010574f:	d3 ea                	shr    %cl,%edx
f0105751:	83 c4 20             	add    $0x20,%esp
f0105754:	5e                   	pop    %esi
f0105755:	5f                   	pop    %edi
f0105756:	5d                   	pop    %ebp
f0105757:	c3                   	ret    
f0105758:	39 d6                	cmp    %edx,%esi
f010575a:	75 d9                	jne    f0105735 <__umoddi3+0xf5>
f010575c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f010575f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0105762:	eb d1                	jmp    f0105735 <__umoddi3+0xf5>
f0105764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105768:	39 f2                	cmp    %esi,%edx
f010576a:	0f 82 18 ff ff ff    	jb     f0105688 <__umoddi3+0x48>
f0105770:	e9 1d ff ff ff       	jmp    f0105692 <__umoddi3+0x52>
