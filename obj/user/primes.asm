
obj/user/primes:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 13 01 00 00       	call   800144 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003d:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800040:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800047:	00 
  800048:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004f:	00 
  800050:	89 34 24             	mov    %esi,(%esp)
  800053:	e8 1e 16 00 00       	call   801676 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
	cprintf("%d ", p);
  80005a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005e:	c7 04 24 60 2d 80 00 	movl   $0x802d60,(%esp)
  800065:	e8 0b 02 00 00       	call   800275 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80006a:	e8 46 13 00 00       	call   8013b5 <fork>
  80006f:	89 c7                	mov    %eax,%edi
  800071:	85 c0                	test   %eax,%eax
  800073:	79 20                	jns    800095 <primeproc+0x61>
		panic("fork: %e", id);
  800075:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800079:	c7 44 24 08 64 2d 80 	movl   $0x802d64,0x8(%esp)
  800080:	00 
  800081:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800088:	00 
  800089:	c7 04 24 6d 2d 80 00 	movl   $0x802d6d,(%esp)
  800090:	e8 1b 01 00 00       	call   8001b0 <_panic>
	if (id == 0)
  800095:	85 c0                	test   %eax,%eax
  800097:	74 a7                	je     800040 <primeproc+0xc>
		goto top;
	
	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800099:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80009c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000a3:	00 
  8000a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ab:	00 
  8000ac:	89 34 24             	mov    %esi,(%esp)
  8000af:	e8 c2 15 00 00       	call   801676 <ipc_recv>
  8000b4:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000b6:	89 c2                	mov    %eax,%edx
  8000b8:	c1 fa 1f             	sar    $0x1f,%edx
  8000bb:	f7 fb                	idiv   %ebx
  8000bd:	85 d2                	test   %edx,%edx
  8000bf:	74 db                	je     80009c <primeproc+0x68>
			ipc_send(id, i, 0, 0);
  8000c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000c8:	00 
  8000c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000d0:	00 
  8000d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000d5:	89 3c 24             	mov    %edi,(%esp)
  8000d8:	e8 33 15 00 00       	call   801610 <ipc_send>
  8000dd:	eb bd                	jmp    80009c <primeproc+0x68>

008000df <umain>:
	}
}

void
umain(void)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	56                   	push   %esi
  8000e3:	53                   	push   %ebx
  8000e4:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000e7:	e8 c9 12 00 00       	call   8013b5 <fork>
  8000ec:	89 c6                	mov    %eax,%esi
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	79 20                	jns    800112 <umain+0x33>
		panic("fork: %e", id);
  8000f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f6:	c7 44 24 08 64 2d 80 	movl   $0x802d64,0x8(%esp)
  8000fd:	00 
  8000fe:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800105:	00 
  800106:	c7 04 24 6d 2d 80 00 	movl   $0x802d6d,(%esp)
  80010d:	e8 9e 00 00 00       	call   8001b0 <_panic>
	if (id == 0)
  800112:	bb 02 00 00 00       	mov    $0x2,%ebx
  800117:	85 c0                	test   %eax,%eax
  800119:	75 05                	jne    800120 <umain+0x41>
		primeproc();
  80011b:	e8 14 ff ff ff       	call   800034 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  800120:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800127:	00 
  800128:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80012f:	00 
  800130:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800134:	89 34 24             	mov    %esi,(%esp)
  800137:	e8 d4 14 00 00       	call   801610 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  80013c:	83 c3 01             	add    $0x1,%ebx
  80013f:	eb df                	jmp    800120 <umain+0x41>
  800141:	00 00                	add    %al,(%eax)
	...

00800144 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	83 ec 18             	sub    $0x18,%esp
  80014a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80014d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800150:	8b 75 08             	mov    0x8(%ebp),%esi
  800153:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800156:	e8 63 10 00 00       	call   8011be <sys_getenvid>
	env = &envs[ENVX(envid)];
  80015b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800160:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016d:	85 f6                	test   %esi,%esi
  80016f:	7e 07                	jle    800178 <libmain+0x34>
		binaryname = argv[0];
  800171:	8b 03                	mov    (%ebx),%eax
  800173:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800178:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80017c:	89 34 24             	mov    %esi,(%esp)
  80017f:	e8 5b ff ff ff       	call   8000df <umain>

	// exit gracefully
	exit();
  800184:	e8 0b 00 00 00       	call   800194 <exit>
}
  800189:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80018c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80018f:	89 ec                	mov    %ebp,%esp
  800191:	5d                   	pop    %ebp
  800192:	c3                   	ret    
	...

00800194 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80019a:	e8 1c 1a 00 00       	call   801bbb <close_all>
	sys_env_destroy(0);
  80019f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a6:	e8 47 10 00 00       	call   8011f2 <sys_env_destroy>
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    
  8001ad:	00 00                	add    %al,(%eax)
	...

008001b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	53                   	push   %ebx
  8001b4:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8001b7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8001ba:	a1 78 70 80 00       	mov    0x807078,%eax
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	74 10                	je     8001d3 <_panic+0x23>
		cprintf("%s: ", argv0);
  8001c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c7:	c7 04 24 92 2d 80 00 	movl   $0x802d92,(%esp)
  8001ce:	e8 a2 00 00 00       	call   800275 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001da:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001e1:	a1 00 70 80 00       	mov    0x807000,%eax
  8001e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ea:	c7 04 24 97 2d 80 00 	movl   $0x802d97,(%esp)
  8001f1:	e8 7f 00 00 00       	call   800275 <cprintf>
	vcprintf(fmt, ap);
  8001f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fd:	89 04 24             	mov    %eax,(%esp)
  800200:	e8 0f 00 00 00       	call   800214 <vcprintf>
	cprintf("\n");
  800205:	c7 04 24 fe 33 80 00 	movl   $0x8033fe,(%esp)
  80020c:	e8 64 00 00 00       	call   800275 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800211:	cc                   	int3   
  800212:	eb fd                	jmp    800211 <_panic+0x61>

00800214 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80021d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800224:	00 00 00 
	b.cnt = 0;
  800227:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800245:	89 44 24 04          	mov    %eax,0x4(%esp)
  800249:	c7 04 24 8f 02 80 00 	movl   $0x80028f,(%esp)
  800250:	e8 d8 01 00 00       	call   80042d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800255:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80025b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800265:	89 04 24             	mov    %eax,(%esp)
  800268:	e8 c3 0a 00 00       	call   800d30 <sys_cputs>

	return b.cnt;
}
  80026d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80027b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80027e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	e8 87 ff ff ff       	call   800214 <vcprintf>
	va_end(ap);

	return cnt;
}
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	53                   	push   %ebx
  800293:	83 ec 14             	sub    $0x14,%esp
  800296:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800299:	8b 03                	mov    (%ebx),%eax
  80029b:	8b 55 08             	mov    0x8(%ebp),%edx
  80029e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002a2:	83 c0 01             	add    $0x1,%eax
  8002a5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ac:	75 19                	jne    8002c7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002ae:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002b5:	00 
  8002b6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002b9:	89 04 24             	mov    %eax,(%esp)
  8002bc:	e8 6f 0a 00 00       	call   800d30 <sys_cputs>
		b->idx = 0;
  8002c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cb:	83 c4 14             	add    $0x14,%esp
  8002ce:	5b                   	pop    %ebx
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    
	...

008002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 4c             	sub    $0x4c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d6                	mov    %edx,%esi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800300:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800303:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800306:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030b:	39 d1                	cmp    %edx,%ecx
  80030d:	72 15                	jb     800324 <printnum+0x44>
  80030f:	77 07                	ja     800318 <printnum+0x38>
  800311:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800314:	39 d0                	cmp    %edx,%eax
  800316:	76 0c                	jbe    800324 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800318:	83 eb 01             	sub    $0x1,%ebx
  80031b:	85 db                	test   %ebx,%ebx
  80031d:	8d 76 00             	lea    0x0(%esi),%esi
  800320:	7f 61                	jg     800383 <printnum+0xa3>
  800322:	eb 70                	jmp    800394 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800324:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800328:	83 eb 01             	sub    $0x1,%ebx
  80032b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80032f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800333:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800337:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80033b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80033e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800341:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800344:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800348:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80034f:	00 
  800350:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800353:	89 04 24             	mov    %eax,(%esp)
  800356:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800359:	89 54 24 04          	mov    %edx,0x4(%esp)
  80035d:	e8 7e 27 00 00       	call   802ae0 <__udivdi3>
  800362:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800365:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800368:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80036c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	89 54 24 04          	mov    %edx,0x4(%esp)
  800377:	89 f2                	mov    %esi,%edx
  800379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037c:	e8 5f ff ff ff       	call   8002e0 <printnum>
  800381:	eb 11                	jmp    800394 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800383:	89 74 24 04          	mov    %esi,0x4(%esp)
  800387:	89 3c 24             	mov    %edi,(%esp)
  80038a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038d:	83 eb 01             	sub    $0x1,%ebx
  800390:	85 db                	test   %ebx,%ebx
  800392:	7f ef                	jg     800383 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800394:	89 74 24 04          	mov    %esi,0x4(%esp)
  800398:	8b 74 24 04          	mov    0x4(%esp),%esi
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003aa:	00 
  8003ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003ae:	89 14 24             	mov    %edx,(%esp)
  8003b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003b4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003b8:	e8 53 28 00 00       	call   802c10 <__umoddi3>
  8003bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003c1:	0f be 80 b3 2d 80 00 	movsbl 0x802db3(%eax),%eax
  8003c8:	89 04 24             	mov    %eax,(%esp)
  8003cb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003ce:	83 c4 4c             	add    $0x4c,%esp
  8003d1:	5b                   	pop    %ebx
  8003d2:	5e                   	pop    %esi
  8003d3:	5f                   	pop    %edi
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d9:	83 fa 01             	cmp    $0x1,%edx
  8003dc:	7e 0e                	jle    8003ec <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003de:	8b 10                	mov    (%eax),%edx
  8003e0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003e3:	89 08                	mov    %ecx,(%eax)
  8003e5:	8b 02                	mov    (%edx),%eax
  8003e7:	8b 52 04             	mov    0x4(%edx),%edx
  8003ea:	eb 22                	jmp    80040e <getuint+0x38>
	else if (lflag)
  8003ec:	85 d2                	test   %edx,%edx
  8003ee:	74 10                	je     800400 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003f0:	8b 10                	mov    (%eax),%edx
  8003f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f5:	89 08                	mov    %ecx,(%eax)
  8003f7:	8b 02                	mov    (%edx),%eax
  8003f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fe:	eb 0e                	jmp    80040e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800400:	8b 10                	mov    (%eax),%edx
  800402:	8d 4a 04             	lea    0x4(%edx),%ecx
  800405:	89 08                	mov    %ecx,(%eax)
  800407:	8b 02                	mov    (%edx),%eax
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800416:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80041a:	8b 10                	mov    (%eax),%edx
  80041c:	3b 50 04             	cmp    0x4(%eax),%edx
  80041f:	73 0a                	jae    80042b <sprintputch+0x1b>
		*b->buf++ = ch;
  800421:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800424:	88 0a                	mov    %cl,(%edx)
  800426:	83 c2 01             	add    $0x1,%edx
  800429:	89 10                	mov    %edx,(%eax)
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    

0080042d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	57                   	push   %edi
  800431:	56                   	push   %esi
  800432:	53                   	push   %ebx
  800433:	83 ec 5c             	sub    $0x5c,%esp
  800436:	8b 7d 08             	mov    0x8(%ebp),%edi
  800439:	8b 75 0c             	mov    0xc(%ebp),%esi
  80043c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80043f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800446:	eb 11                	jmp    800459 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800448:	85 c0                	test   %eax,%eax
  80044a:	0f 84 ec 03 00 00    	je     80083c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800450:	89 74 24 04          	mov    %esi,0x4(%esp)
  800454:	89 04 24             	mov    %eax,(%esp)
  800457:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800459:	0f b6 03             	movzbl (%ebx),%eax
  80045c:	83 c3 01             	add    $0x1,%ebx
  80045f:	83 f8 25             	cmp    $0x25,%eax
  800462:	75 e4                	jne    800448 <vprintfmt+0x1b>
  800464:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800468:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80046f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80047d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800482:	eb 06                	jmp    80048a <vprintfmt+0x5d>
  800484:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800488:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	0f b6 13             	movzbl (%ebx),%edx
  80048d:	0f b6 c2             	movzbl %dl,%eax
  800490:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800493:	8d 43 01             	lea    0x1(%ebx),%eax
  800496:	83 ea 23             	sub    $0x23,%edx
  800499:	80 fa 55             	cmp    $0x55,%dl
  80049c:	0f 87 7d 03 00 00    	ja     80081f <vprintfmt+0x3f2>
  8004a2:	0f b6 d2             	movzbl %dl,%edx
  8004a5:	ff 24 95 00 2f 80 00 	jmp    *0x802f00(,%edx,4)
  8004ac:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004b0:	eb d6                	jmp    800488 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b5:	83 ea 30             	sub    $0x30,%edx
  8004b8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8004bb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004be:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004c1:	83 fb 09             	cmp    $0x9,%ebx
  8004c4:	77 4c                	ja     800512 <vprintfmt+0xe5>
  8004c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004c9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004cc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8004cf:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004d2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8004d6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004d9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004dc:	83 fb 09             	cmp    $0x9,%ebx
  8004df:	76 eb                	jbe    8004cc <vprintfmt+0x9f>
  8004e1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004e4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e7:	eb 29                	jmp    800512 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004e9:	8b 55 14             	mov    0x14(%ebp),%edx
  8004ec:	8d 5a 04             	lea    0x4(%edx),%ebx
  8004ef:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8004f2:	8b 12                	mov    (%edx),%edx
  8004f4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8004f7:	eb 19                	jmp    800512 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8004f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004fc:	c1 fa 1f             	sar    $0x1f,%edx
  8004ff:	f7 d2                	not    %edx
  800501:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800504:	eb 82                	jmp    800488 <vprintfmt+0x5b>
  800506:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80050d:	e9 76 ff ff ff       	jmp    800488 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800512:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800516:	0f 89 6c ff ff ff    	jns    800488 <vprintfmt+0x5b>
  80051c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80051f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800522:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800525:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800528:	e9 5b ff ff ff       	jmp    800488 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80052d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800530:	e9 53 ff ff ff       	jmp    800488 <vprintfmt+0x5b>
  800535:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	8d 50 04             	lea    0x4(%eax),%edx
  80053e:	89 55 14             	mov    %edx,0x14(%ebp)
  800541:	89 74 24 04          	mov    %esi,0x4(%esp)
  800545:	8b 00                	mov    (%eax),%eax
  800547:	89 04 24             	mov    %eax,(%esp)
  80054a:	ff d7                	call   *%edi
  80054c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80054f:	e9 05 ff ff ff       	jmp    800459 <vprintfmt+0x2c>
  800554:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 50 04             	lea    0x4(%eax),%edx
  80055d:	89 55 14             	mov    %edx,0x14(%ebp)
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 c2                	mov    %eax,%edx
  800564:	c1 fa 1f             	sar    $0x1f,%edx
  800567:	31 d0                	xor    %edx,%eax
  800569:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80056b:	83 f8 0f             	cmp    $0xf,%eax
  80056e:	7f 0b                	jg     80057b <vprintfmt+0x14e>
  800570:	8b 14 85 60 30 80 00 	mov    0x803060(,%eax,4),%edx
  800577:	85 d2                	test   %edx,%edx
  800579:	75 20                	jne    80059b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80057b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80057f:	c7 44 24 08 c4 2d 80 	movl   $0x802dc4,0x8(%esp)
  800586:	00 
  800587:	89 74 24 04          	mov    %esi,0x4(%esp)
  80058b:	89 3c 24             	mov    %edi,(%esp)
  80058e:	e8 31 03 00 00       	call   8008c4 <printfmt>
  800593:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800596:	e9 be fe ff ff       	jmp    800459 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80059b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80059f:	c7 44 24 08 c2 33 80 	movl   $0x8033c2,0x8(%esp)
  8005a6:	00 
  8005a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ab:	89 3c 24             	mov    %edi,(%esp)
  8005ae:	e8 11 03 00 00       	call   8008c4 <printfmt>
  8005b3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8005b6:	e9 9e fe ff ff       	jmp    800459 <vprintfmt+0x2c>
  8005bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005be:	89 c3                	mov    %eax,%ebx
  8005c0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8d 50 04             	lea    0x4(%eax),%edx
  8005cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d7:	85 c0                	test   %eax,%eax
  8005d9:	75 07                	jne    8005e2 <vprintfmt+0x1b5>
  8005db:	c7 45 e0 cd 2d 80 00 	movl   $0x802dcd,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8005e2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005e6:	7e 06                	jle    8005ee <vprintfmt+0x1c1>
  8005e8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005ec:	75 13                	jne    800601 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f1:	0f be 02             	movsbl (%edx),%eax
  8005f4:	85 c0                	test   %eax,%eax
  8005f6:	0f 85 99 00 00 00    	jne    800695 <vprintfmt+0x268>
  8005fc:	e9 86 00 00 00       	jmp    800687 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800601:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800605:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800608:	89 0c 24             	mov    %ecx,(%esp)
  80060b:	e8 fb 02 00 00       	call   80090b <strnlen>
  800610:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800613:	29 c2                	sub    %eax,%edx
  800615:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800618:	85 d2                	test   %edx,%edx
  80061a:	7e d2                	jle    8005ee <vprintfmt+0x1c1>
					putch(padc, putdat);
  80061c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800620:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800623:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800626:	89 d3                	mov    %edx,%ebx
  800628:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80062f:	89 04 24             	mov    %eax,(%esp)
  800632:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800634:	83 eb 01             	sub    $0x1,%ebx
  800637:	85 db                	test   %ebx,%ebx
  800639:	7f ed                	jg     800628 <vprintfmt+0x1fb>
  80063b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80063e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800645:	eb a7                	jmp    8005ee <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800647:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80064b:	74 18                	je     800665 <vprintfmt+0x238>
  80064d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800650:	83 fa 5e             	cmp    $0x5e,%edx
  800653:	76 10                	jbe    800665 <vprintfmt+0x238>
					putch('?', putdat);
  800655:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800659:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800660:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800663:	eb 0a                	jmp    80066f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800665:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800669:	89 04 24             	mov    %eax,(%esp)
  80066c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800673:	0f be 03             	movsbl (%ebx),%eax
  800676:	85 c0                	test   %eax,%eax
  800678:	74 05                	je     80067f <vprintfmt+0x252>
  80067a:	83 c3 01             	add    $0x1,%ebx
  80067d:	eb 29                	jmp    8006a8 <vprintfmt+0x27b>
  80067f:	89 fe                	mov    %edi,%esi
  800681:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800684:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800687:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068b:	7f 2e                	jg     8006bb <vprintfmt+0x28e>
  80068d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800690:	e9 c4 fd ff ff       	jmp    800459 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800695:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800698:	83 c2 01             	add    $0x1,%edx
  80069b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80069e:	89 f7                	mov    %esi,%edi
  8006a0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8006a6:	89 d3                	mov    %edx,%ebx
  8006a8:	85 f6                	test   %esi,%esi
  8006aa:	78 9b                	js     800647 <vprintfmt+0x21a>
  8006ac:	83 ee 01             	sub    $0x1,%esi
  8006af:	79 96                	jns    800647 <vprintfmt+0x21a>
  8006b1:	89 fe                	mov    %edi,%esi
  8006b3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006b6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006b9:	eb cc                	jmp    800687 <vprintfmt+0x25a>
  8006bb:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8006be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006cc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ce:	83 eb 01             	sub    $0x1,%ebx
  8006d1:	85 db                	test   %ebx,%ebx
  8006d3:	7f ec                	jg     8006c1 <vprintfmt+0x294>
  8006d5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8006d8:	e9 7c fd ff ff       	jmp    800459 <vprintfmt+0x2c>
  8006dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006e0:	83 f9 01             	cmp    $0x1,%ecx
  8006e3:	7e 16                	jle    8006fb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 50 08             	lea    0x8(%eax),%edx
  8006eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ee:	8b 10                	mov    (%eax),%edx
  8006f0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8006f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006f9:	eb 32                	jmp    80072d <vprintfmt+0x300>
	else if (lflag)
  8006fb:	85 c9                	test   %ecx,%ecx
  8006fd:	74 18                	je     800717 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 50 04             	lea    0x4(%eax),%edx
  800705:	89 55 14             	mov    %edx,0x14(%ebp)
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070d:	89 c1                	mov    %eax,%ecx
  80070f:	c1 f9 1f             	sar    $0x1f,%ecx
  800712:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800715:	eb 16                	jmp    80072d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	89 55 14             	mov    %edx,0x14(%ebp)
  800720:	8b 00                	mov    (%eax),%eax
  800722:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800725:	89 c2                	mov    %eax,%edx
  800727:	c1 fa 1f             	sar    $0x1f,%edx
  80072a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800730:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800733:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800738:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073c:	0f 89 9b 00 00 00    	jns    8007dd <vprintfmt+0x3b0>
				putch('-', putdat);
  800742:	89 74 24 04          	mov    %esi,0x4(%esp)
  800746:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80074d:	ff d7                	call   *%edi
				num = -(long long) num;
  80074f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800752:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800755:	f7 d9                	neg    %ecx
  800757:	83 d3 00             	adc    $0x0,%ebx
  80075a:	f7 db                	neg    %ebx
  80075c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800761:	eb 7a                	jmp    8007dd <vprintfmt+0x3b0>
  800763:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800766:	89 ca                	mov    %ecx,%edx
  800768:	8d 45 14             	lea    0x14(%ebp),%eax
  80076b:	e8 66 fc ff ff       	call   8003d6 <getuint>
  800770:	89 c1                	mov    %eax,%ecx
  800772:	89 d3                	mov    %edx,%ebx
  800774:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800779:	eb 62                	jmp    8007dd <vprintfmt+0x3b0>
  80077b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80077e:	89 ca                	mov    %ecx,%edx
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
  800783:	e8 4e fc ff ff       	call   8003d6 <getuint>
  800788:	89 c1                	mov    %eax,%ecx
  80078a:	89 d3                	mov    %edx,%ebx
  80078c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800791:	eb 4a                	jmp    8007dd <vprintfmt+0x3b0>
  800793:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800796:	89 74 24 04          	mov    %esi,0x4(%esp)
  80079a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007a1:	ff d7                	call   *%edi
			putch('x', putdat);
  8007a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007a7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007ae:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b9:	8b 08                	mov    (%eax),%ecx
  8007bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007c5:	eb 16                	jmp    8007dd <vprintfmt+0x3b0>
  8007c7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007ca:	89 ca                	mov    %ecx,%edx
  8007cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007cf:	e8 02 fc ff ff       	call   8003d6 <getuint>
  8007d4:	89 c1                	mov    %eax,%ecx
  8007d6:	89 d3                	mov    %edx,%ebx
  8007d8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007dd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8007e1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f0:	89 0c 24             	mov    %ecx,(%esp)
  8007f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007f7:	89 f2                	mov    %esi,%edx
  8007f9:	89 f8                	mov    %edi,%eax
  8007fb:	e8 e0 fa ff ff       	call   8002e0 <printnum>
  800800:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800803:	e9 51 fc ff ff       	jmp    800459 <vprintfmt+0x2c>
  800808:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80080b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80080e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800812:	89 14 24             	mov    %edx,(%esp)
  800815:	ff d7                	call   *%edi
  800817:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80081a:	e9 3a fc ff ff       	jmp    800459 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80081f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800823:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80082a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80082c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80082f:	80 38 25             	cmpb   $0x25,(%eax)
  800832:	0f 84 21 fc ff ff    	je     800459 <vprintfmt+0x2c>
  800838:	89 c3                	mov    %eax,%ebx
  80083a:	eb f0                	jmp    80082c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80083c:	83 c4 5c             	add    $0x5c,%esp
  80083f:	5b                   	pop    %ebx
  800840:	5e                   	pop    %esi
  800841:	5f                   	pop    %edi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	83 ec 28             	sub    $0x28,%esp
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800850:	85 c0                	test   %eax,%eax
  800852:	74 04                	je     800858 <vsnprintf+0x14>
  800854:	85 d2                	test   %edx,%edx
  800856:	7f 07                	jg     80085f <vsnprintf+0x1b>
  800858:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085d:	eb 3b                	jmp    80089a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80085f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800862:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800866:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800869:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800877:	8b 45 10             	mov    0x10(%ebp),%eax
  80087a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800881:	89 44 24 04          	mov    %eax,0x4(%esp)
  800885:	c7 04 24 10 04 80 00 	movl   $0x800410,(%esp)
  80088c:	e8 9c fb ff ff       	call   80042d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800894:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800897:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008a2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	89 04 24             	mov    %eax,(%esp)
  8008bd:	e8 82 ff ff ff       	call   800844 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8008ca:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8008cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	89 04 24             	mov    %eax,(%esp)
  8008e5:	e8 43 fb ff ff       	call   80042d <vprintfmt>
	va_end(ap);
}
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    
  8008ec:	00 00                	add    %al,(%eax)
	...

008008f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	80 3a 00             	cmpb   $0x0,(%edx)
  8008fe:	74 09                	je     800909 <strlen+0x19>
		n++;
  800900:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800903:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800907:	75 f7                	jne    800900 <strlen+0x10>
		n++;
	return n;
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	53                   	push   %ebx
  80090f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800915:	85 c9                	test   %ecx,%ecx
  800917:	74 19                	je     800932 <strnlen+0x27>
  800919:	80 3b 00             	cmpb   $0x0,(%ebx)
  80091c:	74 14                	je     800932 <strnlen+0x27>
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800923:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800926:	39 c8                	cmp    %ecx,%eax
  800928:	74 0d                	je     800937 <strnlen+0x2c>
  80092a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80092e:	75 f3                	jne    800923 <strnlen+0x18>
  800930:	eb 05                	jmp    800937 <strnlen+0x2c>
  800932:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800937:	5b                   	pop    %ebx
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	53                   	push   %ebx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800944:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800949:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800950:	83 c2 01             	add    $0x1,%edx
  800953:	84 c9                	test   %cl,%cl
  800955:	75 f2                	jne    800949 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800957:	5b                   	pop    %ebx
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	56                   	push   %esi
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 55 0c             	mov    0xc(%ebp),%edx
  800965:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800968:	85 f6                	test   %esi,%esi
  80096a:	74 18                	je     800984 <strncpy+0x2a>
  80096c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800971:	0f b6 1a             	movzbl (%edx),%ebx
  800974:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800977:	80 3a 01             	cmpb   $0x1,(%edx)
  80097a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80097d:	83 c1 01             	add    $0x1,%ecx
  800980:	39 ce                	cmp    %ecx,%esi
  800982:	77 ed                	ja     800971 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800984:	5b                   	pop    %ebx
  800985:	5e                   	pop    %esi
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	56                   	push   %esi
  80098c:	53                   	push   %ebx
  80098d:	8b 75 08             	mov    0x8(%ebp),%esi
  800990:	8b 55 0c             	mov    0xc(%ebp),%edx
  800993:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800996:	89 f0                	mov    %esi,%eax
  800998:	85 c9                	test   %ecx,%ecx
  80099a:	74 27                	je     8009c3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80099c:	83 e9 01             	sub    $0x1,%ecx
  80099f:	74 1d                	je     8009be <strlcpy+0x36>
  8009a1:	0f b6 1a             	movzbl (%edx),%ebx
  8009a4:	84 db                	test   %bl,%bl
  8009a6:	74 16                	je     8009be <strlcpy+0x36>
			*dst++ = *src++;
  8009a8:	88 18                	mov    %bl,(%eax)
  8009aa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009ad:	83 e9 01             	sub    $0x1,%ecx
  8009b0:	74 0e                	je     8009c0 <strlcpy+0x38>
			*dst++ = *src++;
  8009b2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009b5:	0f b6 1a             	movzbl (%edx),%ebx
  8009b8:	84 db                	test   %bl,%bl
  8009ba:	75 ec                	jne    8009a8 <strlcpy+0x20>
  8009bc:	eb 02                	jmp    8009c0 <strlcpy+0x38>
  8009be:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009c0:	c6 00 00             	movb   $0x0,(%eax)
  8009c3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8009c5:	5b                   	pop    %ebx
  8009c6:	5e                   	pop    %esi
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009d2:	0f b6 01             	movzbl (%ecx),%eax
  8009d5:	84 c0                	test   %al,%al
  8009d7:	74 15                	je     8009ee <strcmp+0x25>
  8009d9:	3a 02                	cmp    (%edx),%al
  8009db:	75 11                	jne    8009ee <strcmp+0x25>
		p++, q++;
  8009dd:	83 c1 01             	add    $0x1,%ecx
  8009e0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009e3:	0f b6 01             	movzbl (%ecx),%eax
  8009e6:	84 c0                	test   %al,%al
  8009e8:	74 04                	je     8009ee <strcmp+0x25>
  8009ea:	3a 02                	cmp    (%edx),%al
  8009ec:	74 ef                	je     8009dd <strcmp+0x14>
  8009ee:	0f b6 c0             	movzbl %al,%eax
  8009f1:	0f b6 12             	movzbl (%edx),%edx
  8009f4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	53                   	push   %ebx
  8009fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a05:	85 c0                	test   %eax,%eax
  800a07:	74 23                	je     800a2c <strncmp+0x34>
  800a09:	0f b6 1a             	movzbl (%edx),%ebx
  800a0c:	84 db                	test   %bl,%bl
  800a0e:	74 24                	je     800a34 <strncmp+0x3c>
  800a10:	3a 19                	cmp    (%ecx),%bl
  800a12:	75 20                	jne    800a34 <strncmp+0x3c>
  800a14:	83 e8 01             	sub    $0x1,%eax
  800a17:	74 13                	je     800a2c <strncmp+0x34>
		n--, p++, q++;
  800a19:	83 c2 01             	add    $0x1,%edx
  800a1c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a1f:	0f b6 1a             	movzbl (%edx),%ebx
  800a22:	84 db                	test   %bl,%bl
  800a24:	74 0e                	je     800a34 <strncmp+0x3c>
  800a26:	3a 19                	cmp    (%ecx),%bl
  800a28:	74 ea                	je     800a14 <strncmp+0x1c>
  800a2a:	eb 08                	jmp    800a34 <strncmp+0x3c>
  800a2c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a31:	5b                   	pop    %ebx
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a34:	0f b6 02             	movzbl (%edx),%eax
  800a37:	0f b6 11             	movzbl (%ecx),%edx
  800a3a:	29 d0                	sub    %edx,%eax
  800a3c:	eb f3                	jmp    800a31 <strncmp+0x39>

00800a3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a48:	0f b6 10             	movzbl (%eax),%edx
  800a4b:	84 d2                	test   %dl,%dl
  800a4d:	74 15                	je     800a64 <strchr+0x26>
		if (*s == c)
  800a4f:	38 ca                	cmp    %cl,%dl
  800a51:	75 07                	jne    800a5a <strchr+0x1c>
  800a53:	eb 14                	jmp    800a69 <strchr+0x2b>
  800a55:	38 ca                	cmp    %cl,%dl
  800a57:	90                   	nop
  800a58:	74 0f                	je     800a69 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a5a:	83 c0 01             	add    $0x1,%eax
  800a5d:	0f b6 10             	movzbl (%eax),%edx
  800a60:	84 d2                	test   %dl,%dl
  800a62:	75 f1                	jne    800a55 <strchr+0x17>
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a75:	0f b6 10             	movzbl (%eax),%edx
  800a78:	84 d2                	test   %dl,%dl
  800a7a:	74 18                	je     800a94 <strfind+0x29>
		if (*s == c)
  800a7c:	38 ca                	cmp    %cl,%dl
  800a7e:	75 0a                	jne    800a8a <strfind+0x1f>
  800a80:	eb 12                	jmp    800a94 <strfind+0x29>
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a88:	74 0a                	je     800a94 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	0f b6 10             	movzbl (%eax),%edx
  800a90:	84 d2                	test   %dl,%dl
  800a92:	75 ee                	jne    800a82 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	83 ec 0c             	sub    $0xc,%esp
  800a9c:	89 1c 24             	mov    %ebx,(%esp)
  800a9f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aa3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800aa7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab0:	85 c9                	test   %ecx,%ecx
  800ab2:	74 30                	je     800ae4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aba:	75 25                	jne    800ae1 <memset+0x4b>
  800abc:	f6 c1 03             	test   $0x3,%cl
  800abf:	75 20                	jne    800ae1 <memset+0x4b>
		c &= 0xFF;
  800ac1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac4:	89 d3                	mov    %edx,%ebx
  800ac6:	c1 e3 08             	shl    $0x8,%ebx
  800ac9:	89 d6                	mov    %edx,%esi
  800acb:	c1 e6 18             	shl    $0x18,%esi
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 10             	shl    $0x10,%eax
  800ad3:	09 f0                	or     %esi,%eax
  800ad5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ad7:	09 d8                	or     %ebx,%eax
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
  800adc:	fc                   	cld    
  800add:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800adf:	eb 03                	jmp    800ae4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae1:	fc                   	cld    
  800ae2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae4:	89 f8                	mov    %edi,%eax
  800ae6:	8b 1c 24             	mov    (%esp),%ebx
  800ae9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800aed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800af1:	89 ec                	mov    %ebp,%esp
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	89 34 24             	mov    %esi,(%esp)
  800afe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b08:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b0b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b0d:	39 c6                	cmp    %eax,%esi
  800b0f:	73 35                	jae    800b46 <memmove+0x51>
  800b11:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b14:	39 d0                	cmp    %edx,%eax
  800b16:	73 2e                	jae    800b46 <memmove+0x51>
		s += n;
		d += n;
  800b18:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1a:	f6 c2 03             	test   $0x3,%dl
  800b1d:	75 1b                	jne    800b3a <memmove+0x45>
  800b1f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b25:	75 13                	jne    800b3a <memmove+0x45>
  800b27:	f6 c1 03             	test   $0x3,%cl
  800b2a:	75 0e                	jne    800b3a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b2c:	83 ef 04             	sub    $0x4,%edi
  800b2f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b32:	c1 e9 02             	shr    $0x2,%ecx
  800b35:	fd                   	std    
  800b36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b38:	eb 09                	jmp    800b43 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b3a:	83 ef 01             	sub    $0x1,%edi
  800b3d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b40:	fd                   	std    
  800b41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b43:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b44:	eb 20                	jmp    800b66 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b4c:	75 15                	jne    800b63 <memmove+0x6e>
  800b4e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b54:	75 0d                	jne    800b63 <memmove+0x6e>
  800b56:	f6 c1 03             	test   $0x3,%cl
  800b59:	75 08                	jne    800b63 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b5b:	c1 e9 02             	shr    $0x2,%ecx
  800b5e:	fc                   	cld    
  800b5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b61:	eb 03                	jmp    800b66 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b63:	fc                   	cld    
  800b64:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b66:	8b 34 24             	mov    (%esp),%esi
  800b69:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b6d:	89 ec                	mov    %ebp,%esp
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b77:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	89 04 24             	mov    %eax,(%esp)
  800b8b:	e8 65 ff ff ff       	call   800af5 <memmove>
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	57                   	push   %edi
  800b96:	56                   	push   %esi
  800b97:	53                   	push   %ebx
  800b98:	8b 75 08             	mov    0x8(%ebp),%esi
  800b9b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba1:	85 c9                	test   %ecx,%ecx
  800ba3:	74 36                	je     800bdb <memcmp+0x49>
		if (*s1 != *s2)
  800ba5:	0f b6 06             	movzbl (%esi),%eax
  800ba8:	0f b6 1f             	movzbl (%edi),%ebx
  800bab:	38 d8                	cmp    %bl,%al
  800bad:	74 20                	je     800bcf <memcmp+0x3d>
  800baf:	eb 14                	jmp    800bc5 <memcmp+0x33>
  800bb1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800bb6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800bbb:	83 c2 01             	add    $0x1,%edx
  800bbe:	83 e9 01             	sub    $0x1,%ecx
  800bc1:	38 d8                	cmp    %bl,%al
  800bc3:	74 12                	je     800bd7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800bc5:	0f b6 c0             	movzbl %al,%eax
  800bc8:	0f b6 db             	movzbl %bl,%ebx
  800bcb:	29 d8                	sub    %ebx,%eax
  800bcd:	eb 11                	jmp    800be0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bcf:	83 e9 01             	sub    $0x1,%ecx
  800bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd7:	85 c9                	test   %ecx,%ecx
  800bd9:	75 d6                	jne    800bb1 <memcmp+0x1f>
  800bdb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800beb:	89 c2                	mov    %eax,%edx
  800bed:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bf0:	39 d0                	cmp    %edx,%eax
  800bf2:	73 15                	jae    800c09 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bf4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800bf8:	38 08                	cmp    %cl,(%eax)
  800bfa:	75 06                	jne    800c02 <memfind+0x1d>
  800bfc:	eb 0b                	jmp    800c09 <memfind+0x24>
  800bfe:	38 08                	cmp    %cl,(%eax)
  800c00:	74 07                	je     800c09 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c02:	83 c0 01             	add    $0x1,%eax
  800c05:	39 c2                	cmp    %eax,%edx
  800c07:	77 f5                	ja     800bfe <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	83 ec 04             	sub    $0x4,%esp
  800c14:	8b 55 08             	mov    0x8(%ebp),%edx
  800c17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c1a:	0f b6 02             	movzbl (%edx),%eax
  800c1d:	3c 20                	cmp    $0x20,%al
  800c1f:	74 04                	je     800c25 <strtol+0x1a>
  800c21:	3c 09                	cmp    $0x9,%al
  800c23:	75 0e                	jne    800c33 <strtol+0x28>
		s++;
  800c25:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c28:	0f b6 02             	movzbl (%edx),%eax
  800c2b:	3c 20                	cmp    $0x20,%al
  800c2d:	74 f6                	je     800c25 <strtol+0x1a>
  800c2f:	3c 09                	cmp    $0x9,%al
  800c31:	74 f2                	je     800c25 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c33:	3c 2b                	cmp    $0x2b,%al
  800c35:	75 0c                	jne    800c43 <strtol+0x38>
		s++;
  800c37:	83 c2 01             	add    $0x1,%edx
  800c3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c41:	eb 15                	jmp    800c58 <strtol+0x4d>
	else if (*s == '-')
  800c43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c4a:	3c 2d                	cmp    $0x2d,%al
  800c4c:	75 0a                	jne    800c58 <strtol+0x4d>
		s++, neg = 1;
  800c4e:	83 c2 01             	add    $0x1,%edx
  800c51:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c58:	85 db                	test   %ebx,%ebx
  800c5a:	0f 94 c0             	sete   %al
  800c5d:	74 05                	je     800c64 <strtol+0x59>
  800c5f:	83 fb 10             	cmp    $0x10,%ebx
  800c62:	75 18                	jne    800c7c <strtol+0x71>
  800c64:	80 3a 30             	cmpb   $0x30,(%edx)
  800c67:	75 13                	jne    800c7c <strtol+0x71>
  800c69:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c6d:	8d 76 00             	lea    0x0(%esi),%esi
  800c70:	75 0a                	jne    800c7c <strtol+0x71>
		s += 2, base = 16;
  800c72:	83 c2 02             	add    $0x2,%edx
  800c75:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c7a:	eb 15                	jmp    800c91 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c7c:	84 c0                	test   %al,%al
  800c7e:	66 90                	xchg   %ax,%ax
  800c80:	74 0f                	je     800c91 <strtol+0x86>
  800c82:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800c87:	80 3a 30             	cmpb   $0x30,(%edx)
  800c8a:	75 05                	jne    800c91 <strtol+0x86>
		s++, base = 8;
  800c8c:	83 c2 01             	add    $0x1,%edx
  800c8f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
  800c96:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c98:	0f b6 0a             	movzbl (%edx),%ecx
  800c9b:	89 cf                	mov    %ecx,%edi
  800c9d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ca0:	80 fb 09             	cmp    $0x9,%bl
  800ca3:	77 08                	ja     800cad <strtol+0xa2>
			dig = *s - '0';
  800ca5:	0f be c9             	movsbl %cl,%ecx
  800ca8:	83 e9 30             	sub    $0x30,%ecx
  800cab:	eb 1e                	jmp    800ccb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800cad:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800cb0:	80 fb 19             	cmp    $0x19,%bl
  800cb3:	77 08                	ja     800cbd <strtol+0xb2>
			dig = *s - 'a' + 10;
  800cb5:	0f be c9             	movsbl %cl,%ecx
  800cb8:	83 e9 57             	sub    $0x57,%ecx
  800cbb:	eb 0e                	jmp    800ccb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800cbd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800cc0:	80 fb 19             	cmp    $0x19,%bl
  800cc3:	77 15                	ja     800cda <strtol+0xcf>
			dig = *s - 'A' + 10;
  800cc5:	0f be c9             	movsbl %cl,%ecx
  800cc8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ccb:	39 f1                	cmp    %esi,%ecx
  800ccd:	7d 0b                	jge    800cda <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800ccf:	83 c2 01             	add    $0x1,%edx
  800cd2:	0f af c6             	imul   %esi,%eax
  800cd5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800cd8:	eb be                	jmp    800c98 <strtol+0x8d>
  800cda:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800cdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce0:	74 05                	je     800ce7 <strtol+0xdc>
		*endptr = (char *) s;
  800ce2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ce5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ce7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ceb:	74 04                	je     800cf1 <strtol+0xe6>
  800ced:	89 c8                	mov    %ecx,%eax
  800cef:	f7 d8                	neg    %eax
}
  800cf1:	83 c4 04             	add    $0x4,%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    
  800cf9:	00 00                	add    %al,(%eax)
	...

00800cfc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 0c             	sub    $0xc,%esp
  800d02:	89 1c 24             	mov    %ebx,(%esp)
  800d05:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d09:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d12:	b8 01 00 00 00       	mov    $0x1,%eax
  800d17:	89 d1                	mov    %edx,%ecx
  800d19:	89 d3                	mov    %edx,%ebx
  800d1b:	89 d7                	mov    %edx,%edi
  800d1d:	89 d6                	mov    %edx,%esi
  800d1f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d21:	8b 1c 24             	mov    (%esp),%ebx
  800d24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d2c:	89 ec                	mov    %ebp,%esp
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 0c             	sub    $0xc,%esp
  800d36:	89 1c 24             	mov    %ebx,(%esp)
  800d39:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d3d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d41:	b8 00 00 00 00       	mov    $0x0,%eax
  800d46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	89 c3                	mov    %eax,%ebx
  800d4e:	89 c7                	mov    %eax,%edi
  800d50:	89 c6                	mov    %eax,%esi
  800d52:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d54:	8b 1c 24             	mov    (%esp),%ebx
  800d57:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d5b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d5f:	89 ec                	mov    %ebp,%esp
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 38             	sub    $0x38,%esp
  800d69:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d72:	be 00 00 00 00       	mov    $0x0,%esi
  800d77:	b8 12 00 00 00       	mov    $0x12,%eax
  800d7c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d85:	8b 55 08             	mov    0x8(%ebp),%edx
  800d88:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7e 28                	jle    800db6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d92:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800d99:	00 
  800d9a:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  800da1:	00 
  800da2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da9:	00 
  800daa:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  800db1:	e8 fa f3 ff ff       	call   8001b0 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800db6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800db9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dbc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dbf:	89 ec                	mov    %ebp,%esp
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 0c             	sub    $0xc,%esp
  800dc9:	89 1c 24             	mov    %ebx,(%esp)
  800dcc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dd0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd9:	b8 11 00 00 00       	mov    $0x11,%eax
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	89 df                	mov    %ebx,%edi
  800de6:	89 de                	mov    %ebx,%esi
  800de8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800dea:	8b 1c 24             	mov    (%esp),%ebx
  800ded:	8b 74 24 04          	mov    0x4(%esp),%esi
  800df1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800df5:	89 ec                	mov    %ebp,%esp
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	89 1c 24             	mov    %ebx,(%esp)
  800e02:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e06:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e0f:	b8 10 00 00 00       	mov    $0x10,%eax
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	89 cb                	mov    %ecx,%ebx
  800e19:	89 cf                	mov    %ecx,%edi
  800e1b:	89 ce                	mov    %ecx,%esi
  800e1d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800e1f:	8b 1c 24             	mov    (%esp),%ebx
  800e22:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e26:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e2a:	89 ec                	mov    %ebp,%esp
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 38             	sub    $0x38,%esp
  800e34:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e37:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e3a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e42:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4d:	89 df                	mov    %ebx,%edi
  800e4f:	89 de                	mov    %ebx,%esi
  800e51:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	7e 28                	jle    800e7f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e57:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e62:	00 
  800e63:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  800e6a:	00 
  800e6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e72:	00 
  800e73:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  800e7a:	e8 31 f3 ff ff       	call   8001b0 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800e7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e88:	89 ec                	mov    %ebp,%esp
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	89 1c 24             	mov    %ebx,(%esp)
  800e95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e99:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea7:	89 d1                	mov    %edx,%ecx
  800ea9:	89 d3                	mov    %edx,%ebx
  800eab:	89 d7                	mov    %edx,%edi
  800ead:	89 d6                	mov    %edx,%esi
  800eaf:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800eb1:	8b 1c 24             	mov    (%esp),%ebx
  800eb4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800eb8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ebc:	89 ec                	mov    %ebp,%esp
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    

00800ec0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 38             	sub    $0x38,%esp
  800ec6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ec9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ecc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	89 cb                	mov    %ecx,%ebx
  800ede:	89 cf                	mov    %ecx,%edi
  800ee0:	89 ce                	mov    %ecx,%esi
  800ee2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ee4:	85 c0                	test   %eax,%eax
  800ee6:	7e 28                	jle    800f10 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eec:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  800efb:	00 
  800efc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f03:	00 
  800f04:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  800f0b:	e8 a0 f2 ff ff       	call   8001b0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f10:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f13:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f16:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f19:	89 ec                	mov    %ebp,%esp
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	83 ec 0c             	sub    $0xc,%esp
  800f23:	89 1c 24             	mov    %ebx,(%esp)
  800f26:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f2a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2e:	be 00 00 00 00       	mov    $0x0,%esi
  800f33:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f38:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f41:	8b 55 08             	mov    0x8(%ebp),%edx
  800f44:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f46:	8b 1c 24             	mov    (%esp),%ebx
  800f49:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f4d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f51:	89 ec                	mov    %ebp,%esp
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 38             	sub    $0x38,%esp
  800f5b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f5e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f61:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f69:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	89 df                	mov    %ebx,%edi
  800f76:	89 de                	mov    %ebx,%esi
  800f78:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	7e 28                	jle    800fa6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f82:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f89:	00 
  800f8a:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  800f91:	00 
  800f92:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f99:	00 
  800f9a:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  800fa1:	e8 0a f2 ff ff       	call   8001b0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800faf:	89 ec                	mov    %ebp,%esp
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 38             	sub    $0x38,%esp
  800fb9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc7:	b8 09 00 00 00       	mov    $0x9,%eax
  800fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd2:	89 df                	mov    %ebx,%edi
  800fd4:	89 de                	mov    %ebx,%esi
  800fd6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fd8:	85 c0                	test   %eax,%eax
  800fda:	7e 28                	jle    801004 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fe7:	00 
  800fe8:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  800fef:	00 
  800ff0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff7:	00 
  800ff8:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  800fff:	e8 ac f1 ff ff       	call   8001b0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801004:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801007:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80100d:	89 ec                	mov    %ebp,%esp
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 38             	sub    $0x38,%esp
  801017:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80101d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801020:	bb 00 00 00 00       	mov    $0x0,%ebx
  801025:	b8 08 00 00 00       	mov    $0x8,%eax
  80102a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102d:	8b 55 08             	mov    0x8(%ebp),%edx
  801030:	89 df                	mov    %ebx,%edi
  801032:	89 de                	mov    %ebx,%esi
  801034:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801036:	85 c0                	test   %eax,%eax
  801038:	7e 28                	jle    801062 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80103e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801045:	00 
  801046:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  80104d:	00 
  80104e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801055:	00 
  801056:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  80105d:	e8 4e f1 ff ff       	call   8001b0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801062:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801065:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801068:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80106b:	89 ec                	mov    %ebp,%esp
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    

0080106f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	83 ec 38             	sub    $0x38,%esp
  801075:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801078:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80107b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801083:	b8 06 00 00 00       	mov    $0x6,%eax
  801088:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108b:	8b 55 08             	mov    0x8(%ebp),%edx
  80108e:	89 df                	mov    %ebx,%edi
  801090:	89 de                	mov    %ebx,%esi
  801092:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801094:	85 c0                	test   %eax,%eax
  801096:	7e 28                	jle    8010c0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801098:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010a3:	00 
  8010a4:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  8010ab:	00 
  8010ac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b3:	00 
  8010b4:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  8010bb:	e8 f0 f0 ff ff       	call   8001b0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010c9:	89 ec                	mov    %ebp,%esp
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 38             	sub    $0x38,%esp
  8010d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8010e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	7e 28                	jle    80111e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010fa:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801101:	00 
  801102:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  801109:	00 
  80110a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801111:	00 
  801112:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  801119:	e8 92 f0 ff ff       	call   8001b0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80111e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801121:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801124:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801127:	89 ec                	mov    %ebp,%esp
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    

0080112b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	83 ec 38             	sub    $0x38,%esp
  801131:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801134:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801137:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113a:	be 00 00 00 00       	mov    $0x0,%esi
  80113f:	b8 04 00 00 00       	mov    $0x4,%eax
  801144:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114a:	8b 55 08             	mov    0x8(%ebp),%edx
  80114d:	89 f7                	mov    %esi,%edi
  80114f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801151:	85 c0                	test   %eax,%eax
  801153:	7e 28                	jle    80117d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801155:	89 44 24 10          	mov    %eax,0x10(%esp)
  801159:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801160:	00 
  801161:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  801168:	00 
  801169:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801170:	00 
  801171:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  801178:	e8 33 f0 ff ff       	call   8001b0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80117d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801180:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801183:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801186:	89 ec                	mov    %ebp,%esp
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 0c             	sub    $0xc,%esp
  801190:	89 1c 24             	mov    %ebx,(%esp)
  801193:	89 74 24 04          	mov    %esi,0x4(%esp)
  801197:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119b:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011a5:	89 d1                	mov    %edx,%ecx
  8011a7:	89 d3                	mov    %edx,%ebx
  8011a9:	89 d7                	mov    %edx,%edi
  8011ab:	89 d6                	mov    %edx,%esi
  8011ad:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011af:	8b 1c 24             	mov    (%esp),%ebx
  8011b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011b6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ba:	89 ec                	mov    %ebp,%esp
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 0c             	sub    $0xc,%esp
  8011c4:	89 1c 24             	mov    %ebx,(%esp)
  8011c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011cb:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8011d9:	89 d1                	mov    %edx,%ecx
  8011db:	89 d3                	mov    %edx,%ebx
  8011dd:	89 d7                	mov    %edx,%edi
  8011df:	89 d6                	mov    %edx,%esi
  8011e1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011e3:	8b 1c 24             	mov    (%esp),%ebx
  8011e6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011ea:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ee:	89 ec                	mov    %ebp,%esp
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	83 ec 38             	sub    $0x38,%esp
  8011f8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011fb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011fe:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801201:	b9 00 00 00 00       	mov    $0x0,%ecx
  801206:	b8 03 00 00 00       	mov    $0x3,%eax
  80120b:	8b 55 08             	mov    0x8(%ebp),%edx
  80120e:	89 cb                	mov    %ecx,%ebx
  801210:	89 cf                	mov    %ecx,%edi
  801212:	89 ce                	mov    %ecx,%esi
  801214:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801216:	85 c0                	test   %eax,%eax
  801218:	7e 28                	jle    801242 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80121a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80121e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801225:	00 
  801226:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  80122d:	00 
  80122e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801235:	00 
  801236:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  80123d:	e8 6e ef ff ff       	call   8001b0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801242:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801245:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801248:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80124b:	89 ec                	mov    %ebp,%esp
  80124d:	5d                   	pop    %ebp
  80124e:	c3                   	ret    
	...

00801250 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801256:	c7 44 24 08 ea 30 80 	movl   $0x8030ea,0x8(%esp)
  80125d:	00 
  80125e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801265:	00 
  801266:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  80126d:	e8 3e ef ff ff       	call   8001b0 <_panic>

00801272 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	53                   	push   %ebx
  801276:	83 ec 24             	sub    $0x24,%esp
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80127c:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80127e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801282:	75 1c                	jne    8012a0 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801284:	c7 44 24 08 0c 31 80 	movl   $0x80310c,0x8(%esp)
  80128b:	00 
  80128c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801293:	00 
  801294:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  80129b:	e8 10 ef ff ff       	call   8001b0 <_panic>
	}
	pte = vpt[VPN(addr)];
  8012a0:	89 d8                	mov    %ebx,%eax
  8012a2:	c1 e8 0c             	shr    $0xc,%eax
  8012a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  8012ac:	f6 c4 08             	test   $0x8,%ah
  8012af:	75 1c                	jne    8012cd <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  8012b1:	c7 44 24 08 50 31 80 	movl   $0x803150,0x8(%esp)
  8012b8:	00 
  8012b9:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  8012c0:	00 
  8012c1:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  8012c8:	e8 e3 ee ff ff       	call   8001b0 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8012cd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012d4:	00 
  8012d5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012dc:	00 
  8012dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e4:	e8 42 fe ff ff       	call   80112b <sys_page_alloc>
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	79 20                	jns    80130d <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  8012ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012f1:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  8012f8:	00 
  8012f9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801300:	00 
  801301:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  801308:	e8 a3 ee ff ff       	call   8001b0 <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  80130d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801313:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80131a:	00 
  80131b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80131f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801326:	e8 ca f7 ff ff       	call   800af5 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  80132b:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801332:	00 
  801333:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801337:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80133e:	00 
  80133f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801346:	00 
  801347:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134e:	e8 7a fd ff ff       	call   8010cd <sys_page_map>
  801353:	85 c0                	test   %eax,%eax
  801355:	79 20                	jns    801377 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  801357:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80135b:	c7 44 24 08 d8 31 80 	movl   $0x8031d8,0x8(%esp)
  801362:	00 
  801363:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80136a:	00 
  80136b:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  801372:	e8 39 ee ff ff       	call   8001b0 <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801377:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80137e:	00 
  80137f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801386:	e8 e4 fc ff ff       	call   80106f <sys_page_unmap>
  80138b:	85 c0                	test   %eax,%eax
  80138d:	79 20                	jns    8013af <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80138f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801393:	c7 44 24 08 10 32 80 	movl   $0x803210,0x8(%esp)
  80139a:	00 
  80139b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8013a2:	00 
  8013a3:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  8013aa:	e8 01 ee ff ff       	call   8001b0 <_panic>
	// panic("pgfault not implemented");
}
  8013af:	83 c4 24             	add    $0x24,%esp
  8013b2:	5b                   	pop    %ebx
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    

008013b5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	57                   	push   %edi
  8013b9:	56                   	push   %esi
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  8013be:	c7 04 24 72 12 80 00 	movl   $0x801272,(%esp)
  8013c5:	e8 12 16 00 00       	call   8029dc <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8013ca:	ba 07 00 00 00       	mov    $0x7,%edx
  8013cf:	89 d0                	mov    %edx,%eax
  8013d1:	cd 30                	int    $0x30
  8013d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	0f 88 21 02 00 00    	js     8015ff <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  8013de:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	75 1c                	jne    801405 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  8013e9:	e8 d0 fd ff ff       	call   8011be <sys_getenvid>
  8013ee:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013f3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013fb:	a3 74 70 80 00       	mov    %eax,0x807074
		return 0;
  801400:	e9 fa 01 00 00       	jmp    8015ff <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  801405:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801408:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  80140f:	a8 01                	test   $0x1,%al
  801411:	0f 84 16 01 00 00    	je     80152d <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  801417:	89 d3                	mov    %edx,%ebx
  801419:	c1 e3 0a             	shl    $0xa,%ebx
  80141c:	89 d7                	mov    %edx,%edi
  80141e:	c1 e7 16             	shl    $0x16,%edi
  801421:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  801426:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80142d:	a8 01                	test   $0x1,%al
  80142f:	0f 84 e0 00 00 00    	je     801515 <fork+0x160>
  801435:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80143b:	0f 87 d4 00 00 00    	ja     801515 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801441:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801448:	89 d0                	mov    %edx,%eax
  80144a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	75 1c                	jne    801470 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  801454:	c7 44 24 08 4c 32 80 	movl   $0x80324c,0x8(%esp)
  80145b:	00 
  80145c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801463:	00 
  801464:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  80146b:	e8 40 ed ff ff       	call   8001b0 <_panic>
	if ((perm & PTE_U) != PTE_U)
  801470:	a8 04                	test   $0x4,%al
  801472:	75 1c                	jne    801490 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801474:	c7 44 24 08 94 32 80 	movl   $0x803294,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  80148b:	e8 20 ed ff ff       	call   8001b0 <_panic>
  801490:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801493:	f6 c4 04             	test   $0x4,%ah
  801496:	75 5b                	jne    8014f3 <fork+0x13e>
  801498:	a9 02 08 00 00       	test   $0x802,%eax
  80149d:	74 54                	je     8014f3 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80149f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  8014a2:	80 cc 08             	or     $0x8,%ah
  8014a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8014a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ac:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c2:	e8 06 fc ff ff       	call   8010cd <sys_page_map>
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	78 4a                	js     801515 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  8014cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014d9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014e0:	00 
  8014e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014ec:	e8 dc fb ff ff       	call   8010cd <sys_page_map>
  8014f1:	eb 22                	jmp    801515 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8014f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801501:	89 54 24 08          	mov    %edx,0x8(%esp)
  801505:	89 44 24 04          	mov    %eax,0x4(%esp)
  801509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801510:	e8 b8 fb ff ff       	call   8010cd <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  801515:	83 c6 01             	add    $0x1,%esi
  801518:	83 c3 01             	add    $0x1,%ebx
  80151b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801521:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  801527:	0f 85 f9 fe ff ff    	jne    801426 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  80152d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  801531:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  801538:	0f 85 c7 fe ff ff    	jne    801405 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80153e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801545:	00 
  801546:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80154d:	ee 
  80154e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801551:	89 04 24             	mov    %eax,(%esp)
  801554:	e8 d2 fb ff ff       	call   80112b <sys_page_alloc>
  801559:	85 c0                	test   %eax,%eax
  80155b:	79 08                	jns    801565 <fork+0x1b0>
  80155d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801560:	e9 9a 00 00 00       	jmp    8015ff <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801565:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80156c:	00 
  80156d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801574:	00 
  801575:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80157c:	00 
  80157d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801584:	ee 
  801585:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801588:	89 14 24             	mov    %edx,(%esp)
  80158b:	e8 3d fb ff ff       	call   8010cd <sys_page_map>
  801590:	85 c0                	test   %eax,%eax
  801592:	79 05                	jns    801599 <fork+0x1e4>
  801594:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801597:	eb 66                	jmp    8015ff <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801599:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8015a0:	00 
  8015a1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015a8:	ee 
  8015a9:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8015b0:	e8 40 f5 ff ff       	call   800af5 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  8015b5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8015bc:	00 
  8015bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015c4:	e8 a6 fa ff ff       	call   80106f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  8015c9:	c7 44 24 04 70 2a 80 	movl   $0x802a70,0x4(%esp)
  8015d0:	00 
  8015d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d4:	89 04 24             	mov    %eax,(%esp)
  8015d7:	e8 79 f9 ff ff       	call   800f55 <sys_env_set_pgfault_upcall>
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	79 05                	jns    8015e5 <fork+0x230>
  8015e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015e3:	eb 1a                	jmp    8015ff <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8015e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015ec:	00 
  8015ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015f0:	89 14 24             	mov    %edx,(%esp)
  8015f3:	e8 19 fa ff ff       	call   801011 <sys_env_set_status>
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	79 03                	jns    8015ff <fork+0x24a>
  8015fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  8015ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801602:	83 c4 3c             	add    $0x3c,%esp
  801605:	5b                   	pop    %ebx
  801606:	5e                   	pop    %esi
  801607:	5f                   	pop    %edi
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    
  80160a:	00 00                	add    %al,(%eax)
  80160c:	00 00                	add    %al,(%eax)
	...

00801610 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	57                   	push   %edi
  801614:	56                   	push   %esi
  801615:	53                   	push   %ebx
  801616:	83 ec 1c             	sub    $0x1c,%esp
  801619:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80161c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80161f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801622:	85 db                	test   %ebx,%ebx
  801624:	75 2d                	jne    801653 <ipc_send+0x43>
  801626:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80162b:	eb 26                	jmp    801653 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80162d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801630:	74 1c                	je     80164e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  801632:	c7 44 24 08 dc 32 80 	movl   $0x8032dc,0x8(%esp)
  801639:	00 
  80163a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801641:	00 
  801642:	c7 04 24 fe 32 80 00 	movl   $0x8032fe,(%esp)
  801649:	e8 62 eb ff ff       	call   8001b0 <_panic>
		sys_yield();
  80164e:	e8 37 fb ff ff       	call   80118a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  801653:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801657:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80165b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	89 04 24             	mov    %eax,(%esp)
  801665:	e8 b3 f8 ff ff       	call   800f1d <sys_ipc_try_send>
  80166a:	85 c0                	test   %eax,%eax
  80166c:	78 bf                	js     80162d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80166e:	83 c4 1c             	add    $0x1c,%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5f                   	pop    %edi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	56                   	push   %esi
  80167a:	53                   	push   %ebx
  80167b:	83 ec 10             	sub    $0x10,%esp
  80167e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801681:	8b 45 0c             	mov    0xc(%ebp),%eax
  801684:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  801687:	85 c0                	test   %eax,%eax
  801689:	75 05                	jne    801690 <ipc_recv+0x1a>
  80168b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  801690:	89 04 24             	mov    %eax,(%esp)
  801693:	e8 28 f8 ff ff       	call   800ec0 <sys_ipc_recv>
  801698:	85 c0                	test   %eax,%eax
  80169a:	79 16                	jns    8016b2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80169c:	85 db                	test   %ebx,%ebx
  80169e:	74 06                	je     8016a6 <ipc_recv+0x30>
			*from_env_store = 0;
  8016a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8016a6:	85 f6                	test   %esi,%esi
  8016a8:	74 2c                	je     8016d6 <ipc_recv+0x60>
			*perm_store = 0;
  8016aa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8016b0:	eb 24                	jmp    8016d6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8016b2:	85 db                	test   %ebx,%ebx
  8016b4:	74 0a                	je     8016c0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8016b6:	a1 74 70 80 00       	mov    0x807074,%eax
  8016bb:	8b 40 74             	mov    0x74(%eax),%eax
  8016be:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  8016c0:	85 f6                	test   %esi,%esi
  8016c2:	74 0a                	je     8016ce <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  8016c4:	a1 74 70 80 00       	mov    0x807074,%eax
  8016c9:	8b 40 78             	mov    0x78(%eax),%eax
  8016cc:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  8016ce:	a1 74 70 80 00       	mov    0x807074,%eax
  8016d3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	5b                   	pop    %ebx
  8016da:	5e                   	pop    %esi
  8016db:	5d                   	pop    %ebp
  8016dc:	c3                   	ret    
  8016dd:	00 00                	add    %al,(%eax)
	...

008016e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8016eb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	89 04 24             	mov    %eax,(%esp)
  8016fc:	e8 df ff ff ff       	call   8016e0 <fd2num>
  801701:	05 20 00 0d 00       	add    $0xd0020,%eax
  801706:	c1 e0 0c             	shl    $0xc,%eax
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	57                   	push   %edi
  80170f:	56                   	push   %esi
  801710:	53                   	push   %ebx
  801711:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801714:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801719:	a8 01                	test   $0x1,%al
  80171b:	74 36                	je     801753 <fd_alloc+0x48>
  80171d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801722:	a8 01                	test   $0x1,%al
  801724:	74 2d                	je     801753 <fd_alloc+0x48>
  801726:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80172b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801730:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801735:	89 c3                	mov    %eax,%ebx
  801737:	89 c2                	mov    %eax,%edx
  801739:	c1 ea 16             	shr    $0x16,%edx
  80173c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80173f:	f6 c2 01             	test   $0x1,%dl
  801742:	74 14                	je     801758 <fd_alloc+0x4d>
  801744:	89 c2                	mov    %eax,%edx
  801746:	c1 ea 0c             	shr    $0xc,%edx
  801749:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80174c:	f6 c2 01             	test   $0x1,%dl
  80174f:	75 10                	jne    801761 <fd_alloc+0x56>
  801751:	eb 05                	jmp    801758 <fd_alloc+0x4d>
  801753:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801758:	89 1f                	mov    %ebx,(%edi)
  80175a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80175f:	eb 17                	jmp    801778 <fd_alloc+0x6d>
  801761:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801766:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80176b:	75 c8                	jne    801735 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80176d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801773:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801778:	5b                   	pop    %ebx
  801779:	5e                   	pop    %esi
  80177a:	5f                   	pop    %edi
  80177b:	5d                   	pop    %ebp
  80177c:	c3                   	ret    

0080177d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	83 f8 1f             	cmp    $0x1f,%eax
  801786:	77 36                	ja     8017be <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801788:	05 00 00 0d 00       	add    $0xd0000,%eax
  80178d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801790:	89 c2                	mov    %eax,%edx
  801792:	c1 ea 16             	shr    $0x16,%edx
  801795:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80179c:	f6 c2 01             	test   $0x1,%dl
  80179f:	74 1d                	je     8017be <fd_lookup+0x41>
  8017a1:	89 c2                	mov    %eax,%edx
  8017a3:	c1 ea 0c             	shr    $0xc,%edx
  8017a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017ad:	f6 c2 01             	test   $0x1,%dl
  8017b0:	74 0c                	je     8017be <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b5:	89 02                	mov    %eax,(%edx)
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8017bc:	eb 05                	jmp    8017c3 <fd_lookup+0x46>
  8017be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    

008017c5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017cb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	89 04 24             	mov    %eax,(%esp)
  8017d8:	e8 a0 ff ff ff       	call   80177d <fd_lookup>
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 0e                	js     8017ef <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	89 50 04             	mov    %edx,0x4(%eax)
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
  8017f6:	83 ec 10             	sub    $0x10,%esp
  8017f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8017ff:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801804:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801809:	be 84 33 80 00       	mov    $0x803384,%esi
		if (devtab[i]->dev_id == dev_id) {
  80180e:	39 08                	cmp    %ecx,(%eax)
  801810:	75 10                	jne    801822 <dev_lookup+0x31>
  801812:	eb 04                	jmp    801818 <dev_lookup+0x27>
  801814:	39 08                	cmp    %ecx,(%eax)
  801816:	75 0a                	jne    801822 <dev_lookup+0x31>
			*dev = devtab[i];
  801818:	89 03                	mov    %eax,(%ebx)
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80181f:	90                   	nop
  801820:	eb 31                	jmp    801853 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801822:	83 c2 01             	add    $0x1,%edx
  801825:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801828:	85 c0                	test   %eax,%eax
  80182a:	75 e8                	jne    801814 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80182c:	a1 74 70 80 00       	mov    0x807074,%eax
  801831:	8b 40 4c             	mov    0x4c(%eax),%eax
  801834:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183c:	c7 04 24 08 33 80 00 	movl   $0x803308,(%esp)
  801843:	e8 2d ea ff ff       	call   800275 <cprintf>
	*dev = 0;
  801848:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80184e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	5b                   	pop    %ebx
  801857:	5e                   	pop    %esi
  801858:	5d                   	pop    %ebp
  801859:	c3                   	ret    

0080185a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	53                   	push   %ebx
  80185e:	83 ec 24             	sub    $0x24,%esp
  801861:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801864:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	89 04 24             	mov    %eax,(%esp)
  801871:	e8 07 ff ff ff       	call   80177d <fd_lookup>
  801876:	85 c0                	test   %eax,%eax
  801878:	78 53                	js     8018cd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80187a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801884:	8b 00                	mov    (%eax),%eax
  801886:	89 04 24             	mov    %eax,(%esp)
  801889:	e8 63 ff ff ff       	call   8017f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 3b                	js     8018cd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801892:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80189e:	74 2d                	je     8018cd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018a0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018a3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018aa:	00 00 00 
	stat->st_isdir = 0;
  8018ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018b4:	00 00 00 
	stat->st_dev = dev;
  8018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ba:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c7:	89 14 24             	mov    %edx,(%esp)
  8018ca:	ff 50 14             	call   *0x14(%eax)
}
  8018cd:	83 c4 24             	add    $0x24,%esp
  8018d0:	5b                   	pop    %ebx
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    

008018d3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	53                   	push   %ebx
  8018d7:	83 ec 24             	sub    $0x24,%esp
  8018da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e4:	89 1c 24             	mov    %ebx,(%esp)
  8018e7:	e8 91 fe ff ff       	call   80177d <fd_lookup>
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 5f                	js     80194f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	8b 00                	mov    (%eax),%eax
  8018fc:	89 04 24             	mov    %eax,(%esp)
  8018ff:	e8 ed fe ff ff       	call   8017f1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801904:	85 c0                	test   %eax,%eax
  801906:	78 47                	js     80194f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80190b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80190f:	75 23                	jne    801934 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801911:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801916:	8b 40 4c             	mov    0x4c(%eax),%eax
  801919:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80191d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801921:	c7 04 24 28 33 80 00 	movl   $0x803328,(%esp)
  801928:	e8 48 e9 ff ff       	call   800275 <cprintf>
  80192d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801932:	eb 1b                	jmp    80194f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801937:	8b 48 18             	mov    0x18(%eax),%ecx
  80193a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193f:	85 c9                	test   %ecx,%ecx
  801941:	74 0c                	je     80194f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801943:	8b 45 0c             	mov    0xc(%ebp),%eax
  801946:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194a:	89 14 24             	mov    %edx,(%esp)
  80194d:	ff d1                	call   *%ecx
}
  80194f:	83 c4 24             	add    $0x24,%esp
  801952:	5b                   	pop    %ebx
  801953:	5d                   	pop    %ebp
  801954:	c3                   	ret    

00801955 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	53                   	push   %ebx
  801959:	83 ec 24             	sub    $0x24,%esp
  80195c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80195f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801962:	89 44 24 04          	mov    %eax,0x4(%esp)
  801966:	89 1c 24             	mov    %ebx,(%esp)
  801969:	e8 0f fe ff ff       	call   80177d <fd_lookup>
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 66                	js     8019d8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801972:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801975:	89 44 24 04          	mov    %eax,0x4(%esp)
  801979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197c:	8b 00                	mov    (%eax),%eax
  80197e:	89 04 24             	mov    %eax,(%esp)
  801981:	e8 6b fe ff ff       	call   8017f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801986:	85 c0                	test   %eax,%eax
  801988:	78 4e                	js     8019d8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80198a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801991:	75 23                	jne    8019b6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801993:	a1 74 70 80 00       	mov    0x807074,%eax
  801998:	8b 40 4c             	mov    0x4c(%eax),%eax
  80199b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80199f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a3:	c7 04 24 49 33 80 00 	movl   $0x803349,(%esp)
  8019aa:	e8 c6 e8 ff ff       	call   800275 <cprintf>
  8019af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8019b4:	eb 22                	jmp    8019d8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8019bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019c1:	85 c9                	test   %ecx,%ecx
  8019c3:	74 13                	je     8019d8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d3:	89 14 24             	mov    %edx,(%esp)
  8019d6:	ff d1                	call   *%ecx
}
  8019d8:	83 c4 24             	add    $0x24,%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5d                   	pop    %ebp
  8019dd:	c3                   	ret    

008019de <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	53                   	push   %ebx
  8019e2:	83 ec 24             	sub    $0x24,%esp
  8019e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ef:	89 1c 24             	mov    %ebx,(%esp)
  8019f2:	e8 86 fd ff ff       	call   80177d <fd_lookup>
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	78 6b                	js     801a66 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a05:	8b 00                	mov    (%eax),%eax
  801a07:	89 04 24             	mov    %eax,(%esp)
  801a0a:	e8 e2 fd ff ff       	call   8017f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	78 53                	js     801a66 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a16:	8b 42 08             	mov    0x8(%edx),%eax
  801a19:	83 e0 03             	and    $0x3,%eax
  801a1c:	83 f8 01             	cmp    $0x1,%eax
  801a1f:	75 23                	jne    801a44 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801a21:	a1 74 70 80 00       	mov    0x807074,%eax
  801a26:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a31:	c7 04 24 66 33 80 00 	movl   $0x803366,(%esp)
  801a38:	e8 38 e8 ff ff       	call   800275 <cprintf>
  801a3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a42:	eb 22                	jmp    801a66 <read+0x88>
	}
	if (!dev->dev_read)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	8b 48 08             	mov    0x8(%eax),%ecx
  801a4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a4f:	85 c9                	test   %ecx,%ecx
  801a51:	74 13                	je     801a66 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a61:	89 14 24             	mov    %edx,(%esp)
  801a64:	ff d1                	call   *%ecx
}
  801a66:	83 c4 24             	add    $0x24,%esp
  801a69:	5b                   	pop    %ebx
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    

00801a6c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	57                   	push   %edi
  801a70:	56                   	push   %esi
  801a71:	53                   	push   %ebx
  801a72:	83 ec 1c             	sub    $0x1c,%esp
  801a75:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a78:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a80:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a85:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8a:	85 f6                	test   %esi,%esi
  801a8c:	74 29                	je     801ab7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a8e:	89 f0                	mov    %esi,%eax
  801a90:	29 d0                	sub    %edx,%eax
  801a92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a96:	03 55 0c             	add    0xc(%ebp),%edx
  801a99:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a9d:	89 3c 24             	mov    %edi,(%esp)
  801aa0:	e8 39 ff ff ff       	call   8019de <read>
		if (m < 0)
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 0e                	js     801ab7 <readn+0x4b>
			return m;
		if (m == 0)
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	74 08                	je     801ab5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801aad:	01 c3                	add    %eax,%ebx
  801aaf:	89 da                	mov    %ebx,%edx
  801ab1:	39 f3                	cmp    %esi,%ebx
  801ab3:	72 d9                	jb     801a8e <readn+0x22>
  801ab5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801ab7:	83 c4 1c             	add    $0x1c,%esp
  801aba:	5b                   	pop    %ebx
  801abb:	5e                   	pop    %esi
  801abc:	5f                   	pop    %edi
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 20             	sub    $0x20,%esp
  801ac7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801aca:	89 34 24             	mov    %esi,(%esp)
  801acd:	e8 0e fc ff ff       	call   8016e0 <fd2num>
  801ad2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ad5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ad9:	89 04 24             	mov    %eax,(%esp)
  801adc:	e8 9c fc ff ff       	call   80177d <fd_lookup>
  801ae1:	89 c3                	mov    %eax,%ebx
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 05                	js     801aec <fd_close+0x2d>
  801ae7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801aea:	74 0c                	je     801af8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801aec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801af0:	19 c0                	sbb    %eax,%eax
  801af2:	f7 d0                	not    %eax
  801af4:	21 c3                	and    %eax,%ebx
  801af6:	eb 3d                	jmp    801b35 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801af8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aff:	8b 06                	mov    (%esi),%eax
  801b01:	89 04 24             	mov    %eax,(%esp)
  801b04:	e8 e8 fc ff ff       	call   8017f1 <dev_lookup>
  801b09:	89 c3                	mov    %eax,%ebx
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	78 16                	js     801b25 <fd_close+0x66>
		if (dev->dev_close)
  801b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b12:	8b 40 10             	mov    0x10(%eax),%eax
  801b15:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	74 07                	je     801b25 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801b1e:	89 34 24             	mov    %esi,(%esp)
  801b21:	ff d0                	call   *%eax
  801b23:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801b25:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b30:	e8 3a f5 ff ff       	call   80106f <sys_page_unmap>
	return r;
}
  801b35:	89 d8                	mov    %ebx,%eax
  801b37:	83 c4 20             	add    $0x20,%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5e                   	pop    %esi
  801b3c:	5d                   	pop    %ebp
  801b3d:	c3                   	ret    

00801b3e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	89 04 24             	mov    %eax,(%esp)
  801b51:	e8 27 fc ff ff       	call   80177d <fd_lookup>
  801b56:	85 c0                	test   %eax,%eax
  801b58:	78 13                	js     801b6d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801b5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b61:	00 
  801b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b65:	89 04 24             	mov    %eax,(%esp)
  801b68:	e8 52 ff ff ff       	call   801abf <fd_close>
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 18             	sub    $0x18,%esp
  801b75:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b78:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b82:	00 
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	89 04 24             	mov    %eax,(%esp)
  801b89:	e8 55 03 00 00       	call   801ee3 <open>
  801b8e:	89 c3                	mov    %eax,%ebx
  801b90:	85 c0                	test   %eax,%eax
  801b92:	78 1b                	js     801baf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9b:	89 1c 24             	mov    %ebx,(%esp)
  801b9e:	e8 b7 fc ff ff       	call   80185a <fstat>
  801ba3:	89 c6                	mov    %eax,%esi
	close(fd);
  801ba5:	89 1c 24             	mov    %ebx,(%esp)
  801ba8:	e8 91 ff ff ff       	call   801b3e <close>
  801bad:	89 f3                	mov    %esi,%ebx
	return r;
}
  801baf:	89 d8                	mov    %ebx,%eax
  801bb1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801bb4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801bb7:	89 ec                	mov    %ebp,%esp
  801bb9:	5d                   	pop    %ebp
  801bba:	c3                   	ret    

00801bbb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	53                   	push   %ebx
  801bbf:	83 ec 14             	sub    $0x14,%esp
  801bc2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801bc7:	89 1c 24             	mov    %ebx,(%esp)
  801bca:	e8 6f ff ff ff       	call   801b3e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801bcf:	83 c3 01             	add    $0x1,%ebx
  801bd2:	83 fb 20             	cmp    $0x20,%ebx
  801bd5:	75 f0                	jne    801bc7 <close_all+0xc>
		close(i);
}
  801bd7:	83 c4 14             	add    $0x14,%esp
  801bda:	5b                   	pop    %ebx
  801bdb:	5d                   	pop    %ebp
  801bdc:	c3                   	ret    

00801bdd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 58             	sub    $0x58,%esp
  801be3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801be6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801be9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bec:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801bef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	89 04 24             	mov    %eax,(%esp)
  801bfc:	e8 7c fb ff ff       	call   80177d <fd_lookup>
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	85 c0                	test   %eax,%eax
  801c05:	0f 88 e0 00 00 00    	js     801ceb <dup+0x10e>
		return r;
	close(newfdnum);
  801c0b:	89 3c 24             	mov    %edi,(%esp)
  801c0e:	e8 2b ff ff ff       	call   801b3e <close>

	newfd = INDEX2FD(newfdnum);
  801c13:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801c19:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c1f:	89 04 24             	mov    %eax,(%esp)
  801c22:	e8 c9 fa ff ff       	call   8016f0 <fd2data>
  801c27:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c29:	89 34 24             	mov    %esi,(%esp)
  801c2c:	e8 bf fa ff ff       	call   8016f0 <fd2data>
  801c31:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801c34:	89 da                	mov    %ebx,%edx
  801c36:	89 d8                	mov    %ebx,%eax
  801c38:	c1 e8 16             	shr    $0x16,%eax
  801c3b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c42:	a8 01                	test   $0x1,%al
  801c44:	74 43                	je     801c89 <dup+0xac>
  801c46:	c1 ea 0c             	shr    $0xc,%edx
  801c49:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c50:	a8 01                	test   $0x1,%al
  801c52:	74 35                	je     801c89 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801c54:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c5b:	25 07 0e 00 00       	and    $0xe07,%eax
  801c60:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c72:	00 
  801c73:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c7e:	e8 4a f4 ff ff       	call   8010cd <sys_page_map>
  801c83:	89 c3                	mov    %eax,%ebx
  801c85:	85 c0                	test   %eax,%eax
  801c87:	78 3f                	js     801cc8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c8c:	89 c2                	mov    %eax,%edx
  801c8e:	c1 ea 0c             	shr    $0xc,%edx
  801c91:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c98:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801c9e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801ca2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ca6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cad:	00 
  801cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb9:	e8 0f f4 ff ff       	call   8010cd <sys_page_map>
  801cbe:	89 c3                	mov    %eax,%ebx
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	78 04                	js     801cc8 <dup+0xeb>
  801cc4:	89 fb                	mov    %edi,%ebx
  801cc6:	eb 23                	jmp    801ceb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801cc8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ccc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cd3:	e8 97 f3 ff ff       	call   80106f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801cd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce6:	e8 84 f3 ff ff       	call   80106f <sys_page_unmap>
	return r;
}
  801ceb:	89 d8                	mov    %ebx,%eax
  801ced:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cf0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cf3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cf6:	89 ec                	mov    %ebp,%esp
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    
	...

00801cfc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	53                   	push   %ebx
  801d00:	83 ec 14             	sub    $0x14,%esp
  801d03:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d05:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801d0b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d12:	00 
  801d13:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801d1a:	00 
  801d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1f:	89 14 24             	mov    %edx,(%esp)
  801d22:	e8 e9 f8 ff ff       	call   801610 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d2e:	00 
  801d2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3a:	e8 37 f9 ff ff       	call   801676 <ipc_recv>
}
  801d3f:	83 c4 14             	add    $0x14,%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    

00801d45 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d51:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d59:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d63:	b8 02 00 00 00       	mov    $0x2,%eax
  801d68:	e8 8f ff ff ff       	call   801cfc <fsipc>
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801d80:	ba 00 00 00 00       	mov    $0x0,%edx
  801d85:	b8 06 00 00 00       	mov    $0x6,%eax
  801d8a:	e8 6d ff ff ff       	call   801cfc <fsipc>
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d97:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9c:	b8 08 00 00 00       	mov    $0x8,%eax
  801da1:	e8 56 ff ff ff       	call   801cfc <fsipc>
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	53                   	push   %ebx
  801dac:	83 ec 14             	sub    $0x14,%esp
  801daf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	8b 40 0c             	mov    0xc(%eax),%eax
  801db8:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc2:	b8 05 00 00 00       	mov    $0x5,%eax
  801dc7:	e8 30 ff ff ff       	call   801cfc <fsipc>
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	78 2b                	js     801dfb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dd0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801dd7:	00 
  801dd8:	89 1c 24             	mov    %ebx,(%esp)
  801ddb:	e8 5a eb ff ff       	call   80093a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801de0:	a1 80 40 80 00       	mov    0x804080,%eax
  801de5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801deb:	a1 84 40 80 00       	mov    0x804084,%eax
  801df0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801dfb:	83 c4 14             	add    $0x14,%esp
  801dfe:	5b                   	pop    %ebx
  801dff:	5d                   	pop    %ebp
  801e00:	c3                   	ret    

00801e01 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 18             	sub    $0x18,%esp
  801e07:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801e0f:	76 05                	jbe    801e16 <devfile_write+0x15>
  801e11:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e16:	8b 55 08             	mov    0x8(%ebp),%edx
  801e19:	8b 52 0c             	mov    0xc(%edx),%edx
  801e1c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801e22:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801e27:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e32:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801e39:	e8 b7 ec ff ff       	call   800af5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e43:	b8 04 00 00 00       	mov    $0x4,%eax
  801e48:	e8 af fe ff ff       	call   801cfc <fsipc>
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	53                   	push   %ebx
  801e53:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	8b 40 0c             	mov    0xc(%eax),%eax
  801e5c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801e69:	ba 00 40 80 00       	mov    $0x804000,%edx
  801e6e:	b8 03 00 00 00       	mov    $0x3,%eax
  801e73:	e8 84 fe ff ff       	call   801cfc <fsipc>
  801e78:	89 c3                	mov    %eax,%ebx
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	78 17                	js     801e95 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e82:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801e89:	00 
  801e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8d:	89 04 24             	mov    %eax,(%esp)
  801e90:	e8 60 ec ff ff       	call   800af5 <memmove>
	return r;
}
  801e95:	89 d8                	mov    %ebx,%eax
  801e97:	83 c4 14             	add    $0x14,%esp
  801e9a:	5b                   	pop    %ebx
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    

00801e9d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	53                   	push   %ebx
  801ea1:	83 ec 14             	sub    $0x14,%esp
  801ea4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801ea7:	89 1c 24             	mov    %ebx,(%esp)
  801eaa:	e8 41 ea ff ff       	call   8008f0 <strlen>
  801eaf:	89 c2                	mov    %eax,%edx
  801eb1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801eb6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801ebc:	7f 1f                	jg     801edd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801ebe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ec2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ec9:	e8 6c ea ff ff       	call   80093a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801ece:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed3:	b8 07 00 00 00       	mov    $0x7,%eax
  801ed8:	e8 1f fe ff ff       	call   801cfc <fsipc>
}
  801edd:	83 c4 14             	add    $0x14,%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5d                   	pop    %ebp
  801ee2:	c3                   	ret    

00801ee3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	83 ec 28             	sub    $0x28,%esp
  801ee9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801eec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801eef:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801ef2:	89 34 24             	mov    %esi,(%esp)
  801ef5:	e8 f6 e9 ff ff       	call   8008f0 <strlen>
  801efa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801eff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f04:	7f 5e                	jg     801f64 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f09:	89 04 24             	mov    %eax,(%esp)
  801f0c:	e8 fa f7 ff ff       	call   80170b <fd_alloc>
  801f11:	89 c3                	mov    %eax,%ebx
  801f13:	85 c0                	test   %eax,%eax
  801f15:	78 4d                	js     801f64 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801f17:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f1b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f22:	e8 13 ea ff ff       	call   80093a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f32:	b8 01 00 00 00       	mov    $0x1,%eax
  801f37:	e8 c0 fd ff ff       	call   801cfc <fsipc>
  801f3c:	89 c3                	mov    %eax,%ebx
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	79 15                	jns    801f57 <open+0x74>
	{
		fd_close(fd,0);
  801f42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f49:	00 
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	89 04 24             	mov    %eax,(%esp)
  801f50:	e8 6a fb ff ff       	call   801abf <fd_close>
		return r; 
  801f55:	eb 0d                	jmp    801f64 <open+0x81>
	}
	return fd2num(fd);
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	89 04 24             	mov    %eax,(%esp)
  801f5d:	e8 7e f7 ff ff       	call   8016e0 <fd2num>
  801f62:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801f64:	89 d8                	mov    %ebx,%eax
  801f66:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f69:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f6c:	89 ec                	mov    %ebp,%esp
  801f6e:	5d                   	pop    %ebp
  801f6f:	c3                   	ret    

00801f70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f76:	c7 44 24 04 98 33 80 	movl   $0x803398,0x4(%esp)
  801f7d:	00 
  801f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f81:	89 04 24             	mov    %eax,(%esp)
  801f84:	e8 b1 e9 ff ff       	call   80093a <strcpy>
	return 0;
}
  801f89:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9c:	89 04 24             	mov    %eax,(%esp)
  801f9f:	e8 9e 02 00 00       	call   802242 <nsipc_close>
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fb3:	00 
  801fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc8:	89 04 24             	mov    %eax,(%esp)
  801fcb:	e8 ae 02 00 00       	call   80227e <nsipc_send>
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fd8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fdf:	00 
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff4:	89 04 24             	mov    %eax,(%esp)
  801ff7:	e8 f5 02 00 00       	call   8022f1 <nsipc_recv>
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	56                   	push   %esi
  802002:	53                   	push   %ebx
  802003:	83 ec 20             	sub    $0x20,%esp
  802006:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802008:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200b:	89 04 24             	mov    %eax,(%esp)
  80200e:	e8 f8 f6 ff ff       	call   80170b <fd_alloc>
  802013:	89 c3                	mov    %eax,%ebx
  802015:	85 c0                	test   %eax,%eax
  802017:	78 21                	js     80203a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802019:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802020:	00 
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	89 44 24 04          	mov    %eax,0x4(%esp)
  802028:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202f:	e8 f7 f0 ff ff       	call   80112b <sys_page_alloc>
  802034:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802036:	85 c0                	test   %eax,%eax
  802038:	79 0a                	jns    802044 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80203a:	89 34 24             	mov    %esi,(%esp)
  80203d:	e8 00 02 00 00       	call   802242 <nsipc_close>
		return r;
  802042:	eb 28                	jmp    80206c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802044:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802052:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	89 04 24             	mov    %eax,(%esp)
  802065:	e8 76 f6 ff ff       	call   8016e0 <fd2num>
  80206a:	89 c3                	mov    %eax,%ebx
}
  80206c:	89 d8                	mov    %ebx,%eax
  80206e:	83 c4 20             	add    $0x20,%esp
  802071:	5b                   	pop    %ebx
  802072:	5e                   	pop    %esi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    

00802075 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80207b:	8b 45 10             	mov    0x10(%ebp),%eax
  80207e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802082:	8b 45 0c             	mov    0xc(%ebp),%eax
  802085:	89 44 24 04          	mov    %eax,0x4(%esp)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	89 04 24             	mov    %eax,(%esp)
  80208f:	e8 62 01 00 00       	call   8021f6 <nsipc_socket>
  802094:	85 c0                	test   %eax,%eax
  802096:	78 05                	js     80209d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802098:	e8 61 ff ff ff       	call   801ffe <alloc_sockfd>
}
  80209d:	c9                   	leave  
  80209e:	66 90                	xchg   %ax,%ax
  8020a0:	c3                   	ret    

008020a1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ae:	89 04 24             	mov    %eax,(%esp)
  8020b1:	e8 c7 f6 ff ff       	call   80177d <fd_lookup>
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	78 15                	js     8020cf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8020ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bd:	8b 0a                	mov    (%edx),%ecx
  8020bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020c4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8020ca:	75 03                	jne    8020cf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8020cc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	e8 c2 ff ff ff       	call   8020a1 <fd2sockid>
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 0f                	js     8020f2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8020e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ea:	89 04 24             	mov    %eax,(%esp)
  8020ed:	e8 2e 01 00 00       	call   802220 <nsipc_listen>
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	e8 9f ff ff ff       	call   8020a1 <fd2sockid>
  802102:	85 c0                	test   %eax,%eax
  802104:	78 16                	js     80211c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802106:	8b 55 10             	mov    0x10(%ebp),%edx
  802109:	89 54 24 08          	mov    %edx,0x8(%esp)
  80210d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802110:	89 54 24 04          	mov    %edx,0x4(%esp)
  802114:	89 04 24             	mov    %eax,(%esp)
  802117:	e8 55 02 00 00       	call   802371 <nsipc_connect>
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	e8 75 ff ff ff       	call   8020a1 <fd2sockid>
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 0f                	js     80213f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802130:	8b 55 0c             	mov    0xc(%ebp),%edx
  802133:	89 54 24 04          	mov    %edx,0x4(%esp)
  802137:	89 04 24             	mov    %eax,(%esp)
  80213a:	e8 1d 01 00 00       	call   80225c <nsipc_shutdown>
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	e8 52 ff ff ff       	call   8020a1 <fd2sockid>
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 16                	js     802169 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802153:	8b 55 10             	mov    0x10(%ebp),%edx
  802156:	89 54 24 08          	mov    %edx,0x8(%esp)
  80215a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802161:	89 04 24             	mov    %eax,(%esp)
  802164:	e8 47 02 00 00       	call   8023b0 <nsipc_bind>
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	e8 28 ff ff ff       	call   8020a1 <fd2sockid>
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 1f                	js     80219c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80217d:	8b 55 10             	mov    0x10(%ebp),%edx
  802180:	89 54 24 08          	mov    %edx,0x8(%esp)
  802184:	8b 55 0c             	mov    0xc(%ebp),%edx
  802187:	89 54 24 04          	mov    %edx,0x4(%esp)
  80218b:	89 04 24             	mov    %eax,(%esp)
  80218e:	e8 5c 02 00 00       	call   8023ef <nsipc_accept>
  802193:	85 c0                	test   %eax,%eax
  802195:	78 05                	js     80219c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802197:	e8 62 fe ff ff       	call   801ffe <alloc_sockfd>
}
  80219c:	c9                   	leave  
  80219d:	8d 76 00             	lea    0x0(%esi),%esi
  8021a0:	c3                   	ret    
	...

008021b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021b6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8021bc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8021c3:	00 
  8021c4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8021cb:	00 
  8021cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d0:	89 14 24             	mov    %edx,(%esp)
  8021d3:	e8 38 f4 ff ff       	call   801610 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021df:	00 
  8021e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021e7:	00 
  8021e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ef:	e8 82 f4 ff ff       	call   801676 <ipc_recv>
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802204:	8b 45 0c             	mov    0xc(%ebp),%eax
  802207:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80220c:	8b 45 10             	mov    0x10(%ebp),%eax
  80220f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802214:	b8 09 00 00 00       	mov    $0x9,%eax
  802219:	e8 92 ff ff ff       	call   8021b0 <nsipc>
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80222e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802231:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802236:	b8 06 00 00 00       	mov    $0x6,%eax
  80223b:	e8 70 ff ff ff       	call   8021b0 <nsipc>
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802250:	b8 04 00 00 00       	mov    $0x4,%eax
  802255:	e8 56 ff ff ff       	call   8021b0 <nsipc>
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80226a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802272:	b8 03 00 00 00       	mov    $0x3,%eax
  802277:	e8 34 ff ff ff       	call   8021b0 <nsipc>
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	53                   	push   %ebx
  802282:	83 ec 14             	sub    $0x14,%esp
  802285:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802290:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802296:	7e 24                	jle    8022bc <nsipc_send+0x3e>
  802298:	c7 44 24 0c a4 33 80 	movl   $0x8033a4,0xc(%esp)
  80229f:	00 
  8022a0:	c7 44 24 08 b0 33 80 	movl   $0x8033b0,0x8(%esp)
  8022a7:	00 
  8022a8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8022af:	00 
  8022b0:	c7 04 24 c5 33 80 00 	movl   $0x8033c5,(%esp)
  8022b7:	e8 f4 de ff ff       	call   8001b0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8022ce:	e8 22 e8 ff ff       	call   800af5 <memmove>
	nsipcbuf.send.req_size = size;
  8022d3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8022d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8022dc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8022e6:	e8 c5 fe ff ff       	call   8021b0 <nsipc>
}
  8022eb:	83 c4 14             	add    $0x14,%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    

008022f1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	56                   	push   %esi
  8022f5:	53                   	push   %ebx
  8022f6:	83 ec 10             	sub    $0x10,%esp
  8022f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802304:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80230a:	8b 45 14             	mov    0x14(%ebp),%eax
  80230d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802312:	b8 07 00 00 00       	mov    $0x7,%eax
  802317:	e8 94 fe ff ff       	call   8021b0 <nsipc>
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	85 c0                	test   %eax,%eax
  802320:	78 46                	js     802368 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802322:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802327:	7f 04                	jg     80232d <nsipc_recv+0x3c>
  802329:	39 c6                	cmp    %eax,%esi
  80232b:	7d 24                	jge    802351 <nsipc_recv+0x60>
  80232d:	c7 44 24 0c d1 33 80 	movl   $0x8033d1,0xc(%esp)
  802334:	00 
  802335:	c7 44 24 08 b0 33 80 	movl   $0x8033b0,0x8(%esp)
  80233c:	00 
  80233d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802344:	00 
  802345:	c7 04 24 c5 33 80 00 	movl   $0x8033c5,(%esp)
  80234c:	e8 5f de ff ff       	call   8001b0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802351:	89 44 24 08          	mov    %eax,0x8(%esp)
  802355:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80235c:	00 
  80235d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802360:	89 04 24             	mov    %eax,(%esp)
  802363:	e8 8d e7 ff ff       	call   800af5 <memmove>
	}

	return r;
}
  802368:	89 d8                	mov    %ebx,%eax
  80236a:	83 c4 10             	add    $0x10,%esp
  80236d:	5b                   	pop    %ebx
  80236e:	5e                   	pop    %esi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    

00802371 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	53                   	push   %ebx
  802375:	83 ec 14             	sub    $0x14,%esp
  802378:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802383:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802395:	e8 5b e7 ff ff       	call   800af5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80239a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8023a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8023a5:	e8 06 fe ff ff       	call   8021b0 <nsipc>
}
  8023aa:	83 c4 14             	add    $0x14,%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5d                   	pop    %ebp
  8023af:	c3                   	ret    

008023b0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 14             	sub    $0x14,%esp
  8023b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023cd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8023d4:	e8 1c e7 ff ff       	call   800af5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023d9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8023df:	b8 02 00 00 00       	mov    $0x2,%eax
  8023e4:	e8 c7 fd ff ff       	call   8021b0 <nsipc>
}
  8023e9:	83 c4 14             	add    $0x14,%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5d                   	pop    %ebp
  8023ee:	c3                   	ret    

008023ef <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 18             	sub    $0x18,%esp
  8023f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802403:	b8 01 00 00 00       	mov    $0x1,%eax
  802408:	e8 a3 fd ff ff       	call   8021b0 <nsipc>
  80240d:	89 c3                	mov    %eax,%ebx
  80240f:	85 c0                	test   %eax,%eax
  802411:	78 25                	js     802438 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802413:	be 10 60 80 00       	mov    $0x806010,%esi
  802418:	8b 06                	mov    (%esi),%eax
  80241a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80241e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802425:	00 
  802426:	8b 45 0c             	mov    0xc(%ebp),%eax
  802429:	89 04 24             	mov    %eax,(%esp)
  80242c:	e8 c4 e6 ff ff       	call   800af5 <memmove>
		*addrlen = ret->ret_addrlen;
  802431:	8b 16                	mov    (%esi),%edx
  802433:	8b 45 10             	mov    0x10(%ebp),%eax
  802436:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802438:	89 d8                	mov    %ebx,%eax
  80243a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80243d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802440:	89 ec                	mov    %ebp,%esp
  802442:	5d                   	pop    %ebp
  802443:	c3                   	ret    
	...

00802450 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	83 ec 18             	sub    $0x18,%esp
  802456:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802459:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80245c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	89 04 24             	mov    %eax,(%esp)
  802465:	e8 86 f2 ff ff       	call   8016f0 <fd2data>
  80246a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80246c:	c7 44 24 04 e6 33 80 	movl   $0x8033e6,0x4(%esp)
  802473:	00 
  802474:	89 34 24             	mov    %esi,(%esp)
  802477:	e8 be e4 ff ff       	call   80093a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80247c:	8b 43 04             	mov    0x4(%ebx),%eax
  80247f:	2b 03                	sub    (%ebx),%eax
  802481:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802487:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80248e:	00 00 00 
	stat->st_dev = &devpipe;
  802491:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802498:	70 80 00 
	return 0;
}
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8024a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8024a6:	89 ec                	mov    %ebp,%esp
  8024a8:	5d                   	pop    %ebp
  8024a9:	c3                   	ret    

008024aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	53                   	push   %ebx
  8024ae:	83 ec 14             	sub    $0x14,%esp
  8024b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024bf:	e8 ab eb ff ff       	call   80106f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024c4:	89 1c 24             	mov    %ebx,(%esp)
  8024c7:	e8 24 f2 ff ff       	call   8016f0 <fd2data>
  8024cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d7:	e8 93 eb ff ff       	call   80106f <sys_page_unmap>
}
  8024dc:	83 c4 14             	add    $0x14,%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    

008024e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	57                   	push   %edi
  8024e6:	56                   	push   %esi
  8024e7:	53                   	push   %ebx
  8024e8:	83 ec 2c             	sub    $0x2c,%esp
  8024eb:	89 c7                	mov    %eax,%edi
  8024ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8024f0:	a1 74 70 80 00       	mov    0x807074,%eax
  8024f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024f8:	89 3c 24             	mov    %edi,(%esp)
  8024fb:	e8 9c 05 00 00       	call   802a9c <pageref>
  802500:	89 c6                	mov    %eax,%esi
  802502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802505:	89 04 24             	mov    %eax,(%esp)
  802508:	e8 8f 05 00 00       	call   802a9c <pageref>
  80250d:	39 c6                	cmp    %eax,%esi
  80250f:	0f 94 c0             	sete   %al
  802512:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802515:	8b 15 74 70 80 00    	mov    0x807074,%edx
  80251b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80251e:	39 cb                	cmp    %ecx,%ebx
  802520:	75 08                	jne    80252a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802522:	83 c4 2c             	add    $0x2c,%esp
  802525:	5b                   	pop    %ebx
  802526:	5e                   	pop    %esi
  802527:	5f                   	pop    %edi
  802528:	5d                   	pop    %ebp
  802529:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80252a:	83 f8 01             	cmp    $0x1,%eax
  80252d:	75 c1                	jne    8024f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80252f:	8b 52 58             	mov    0x58(%edx),%edx
  802532:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802536:	89 54 24 08          	mov    %edx,0x8(%esp)
  80253a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80253e:	c7 04 24 ed 33 80 00 	movl   $0x8033ed,(%esp)
  802545:	e8 2b dd ff ff       	call   800275 <cprintf>
  80254a:	eb a4                	jmp    8024f0 <_pipeisclosed+0xe>

0080254c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	57                   	push   %edi
  802550:	56                   	push   %esi
  802551:	53                   	push   %ebx
  802552:	83 ec 1c             	sub    $0x1c,%esp
  802555:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802558:	89 34 24             	mov    %esi,(%esp)
  80255b:	e8 90 f1 ff ff       	call   8016f0 <fd2data>
  802560:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802562:	bf 00 00 00 00       	mov    $0x0,%edi
  802567:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80256b:	75 54                	jne    8025c1 <devpipe_write+0x75>
  80256d:	eb 60                	jmp    8025cf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80256f:	89 da                	mov    %ebx,%edx
  802571:	89 f0                	mov    %esi,%eax
  802573:	e8 6a ff ff ff       	call   8024e2 <_pipeisclosed>
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 07                	je     802583 <devpipe_write+0x37>
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
  802581:	eb 53                	jmp    8025d6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802583:	90                   	nop
  802584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802588:	e8 fd eb ff ff       	call   80118a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80258d:	8b 43 04             	mov    0x4(%ebx),%eax
  802590:	8b 13                	mov    (%ebx),%edx
  802592:	83 c2 20             	add    $0x20,%edx
  802595:	39 d0                	cmp    %edx,%eax
  802597:	73 d6                	jae    80256f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802599:	89 c2                	mov    %eax,%edx
  80259b:	c1 fa 1f             	sar    $0x1f,%edx
  80259e:	c1 ea 1b             	shr    $0x1b,%edx
  8025a1:	01 d0                	add    %edx,%eax
  8025a3:	83 e0 1f             	and    $0x1f,%eax
  8025a6:	29 d0                	sub    %edx,%eax
  8025a8:	89 c2                	mov    %eax,%edx
  8025aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025ad:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8025b1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025b9:	83 c7 01             	add    $0x1,%edi
  8025bc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8025bf:	76 13                	jbe    8025d4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8025c4:	8b 13                	mov    (%ebx),%edx
  8025c6:	83 c2 20             	add    $0x20,%edx
  8025c9:	39 d0                	cmp    %edx,%eax
  8025cb:	73 a2                	jae    80256f <devpipe_write+0x23>
  8025cd:	eb ca                	jmp    802599 <devpipe_write+0x4d>
  8025cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8025d4:	89 f8                	mov    %edi,%eax
}
  8025d6:	83 c4 1c             	add    $0x1c,%esp
  8025d9:	5b                   	pop    %ebx
  8025da:	5e                   	pop    %esi
  8025db:	5f                   	pop    %edi
  8025dc:	5d                   	pop    %ebp
  8025dd:	c3                   	ret    

008025de <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	83 ec 28             	sub    $0x28,%esp
  8025e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8025f0:	89 3c 24             	mov    %edi,(%esp)
  8025f3:	e8 f8 f0 ff ff       	call   8016f0 <fd2data>
  8025f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025fa:	be 00 00 00 00       	mov    $0x0,%esi
  8025ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802603:	75 4c                	jne    802651 <devpipe_read+0x73>
  802605:	eb 5b                	jmp    802662 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802607:	89 f0                	mov    %esi,%eax
  802609:	eb 5e                	jmp    802669 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80260b:	89 da                	mov    %ebx,%edx
  80260d:	89 f8                	mov    %edi,%eax
  80260f:	90                   	nop
  802610:	e8 cd fe ff ff       	call   8024e2 <_pipeisclosed>
  802615:	85 c0                	test   %eax,%eax
  802617:	74 07                	je     802620 <devpipe_read+0x42>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	eb 49                	jmp    802669 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802620:	e8 65 eb ff ff       	call   80118a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802625:	8b 03                	mov    (%ebx),%eax
  802627:	3b 43 04             	cmp    0x4(%ebx),%eax
  80262a:	74 df                	je     80260b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80262c:	89 c2                	mov    %eax,%edx
  80262e:	c1 fa 1f             	sar    $0x1f,%edx
  802631:	c1 ea 1b             	shr    $0x1b,%edx
  802634:	01 d0                	add    %edx,%eax
  802636:	83 e0 1f             	and    $0x1f,%eax
  802639:	29 d0                	sub    %edx,%eax
  80263b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802640:	8b 55 0c             	mov    0xc(%ebp),%edx
  802643:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802646:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802649:	83 c6 01             	add    $0x1,%esi
  80264c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80264f:	76 16                	jbe    802667 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802651:	8b 03                	mov    (%ebx),%eax
  802653:	3b 43 04             	cmp    0x4(%ebx),%eax
  802656:	75 d4                	jne    80262c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802658:	85 f6                	test   %esi,%esi
  80265a:	75 ab                	jne    802607 <devpipe_read+0x29>
  80265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802660:	eb a9                	jmp    80260b <devpipe_read+0x2d>
  802662:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802667:	89 f0                	mov    %esi,%eax
}
  802669:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80266c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80266f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802672:	89 ec                	mov    %ebp,%esp
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    

00802676 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80267c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 ef f0 ff ff       	call   80177d <fd_lookup>
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 15                	js     8026a7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	89 04 24             	mov    %eax,(%esp)
  802698:	e8 53 f0 ff ff       	call   8016f0 <fd2data>
	return _pipeisclosed(fd, p);
  80269d:	89 c2                	mov    %eax,%edx
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	e8 3b fe ff ff       	call   8024e2 <_pipeisclosed>
}
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    

008026a9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	83 ec 48             	sub    $0x48,%esp
  8026af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8026b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8026b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8026b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8026be:	89 04 24             	mov    %eax,(%esp)
  8026c1:	e8 45 f0 ff ff       	call   80170b <fd_alloc>
  8026c6:	89 c3                	mov    %eax,%ebx
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	0f 88 42 01 00 00    	js     802812 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026d0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026d7:	00 
  8026d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e6:	e8 40 ea ff ff       	call   80112b <sys_page_alloc>
  8026eb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	0f 88 1d 01 00 00    	js     802812 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8026f8:	89 04 24             	mov    %eax,(%esp)
  8026fb:	e8 0b f0 ff ff       	call   80170b <fd_alloc>
  802700:	89 c3                	mov    %eax,%ebx
  802702:	85 c0                	test   %eax,%eax
  802704:	0f 88 f5 00 00 00    	js     8027ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802711:	00 
  802712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802715:	89 44 24 04          	mov    %eax,0x4(%esp)
  802719:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802720:	e8 06 ea ff ff       	call   80112b <sys_page_alloc>
  802725:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802727:	85 c0                	test   %eax,%eax
  802729:	0f 88 d0 00 00 00    	js     8027ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80272f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802732:	89 04 24             	mov    %eax,(%esp)
  802735:	e8 b6 ef ff ff       	call   8016f0 <fd2data>
  80273a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80273c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802743:	00 
  802744:	89 44 24 04          	mov    %eax,0x4(%esp)
  802748:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80274f:	e8 d7 e9 ff ff       	call   80112b <sys_page_alloc>
  802754:	89 c3                	mov    %eax,%ebx
  802756:	85 c0                	test   %eax,%eax
  802758:	0f 88 8e 00 00 00    	js     8027ec <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80275e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802761:	89 04 24             	mov    %eax,(%esp)
  802764:	e8 87 ef ff ff       	call   8016f0 <fd2data>
  802769:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802770:	00 
  802771:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802775:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80277c:	00 
  80277d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802781:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802788:	e8 40 e9 ff ff       	call   8010cd <sys_page_map>
  80278d:	89 c3                	mov    %eax,%ebx
  80278f:	85 c0                	test   %eax,%eax
  802791:	78 49                	js     8027dc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802793:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802798:	8b 08                	mov    (%eax),%ecx
  80279a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80279d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80279f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8027a9:	8b 10                	mov    (%eax),%edx
  8027ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8027b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8027ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bd:	89 04 24             	mov    %eax,(%esp)
  8027c0:	e8 1b ef ff ff       	call   8016e0 <fd2num>
  8027c5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8027c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ca:	89 04 24             	mov    %eax,(%esp)
  8027cd:	e8 0e ef ff ff       	call   8016e0 <fd2num>
  8027d2:	89 47 04             	mov    %eax,0x4(%edi)
  8027d5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8027da:	eb 36                	jmp    802812 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8027dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027e7:	e8 83 e8 ff ff       	call   80106f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8027ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027fa:	e8 70 e8 ff ff       	call   80106f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8027ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802802:	89 44 24 04          	mov    %eax,0x4(%esp)
  802806:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80280d:	e8 5d e8 ff ff       	call   80106f <sys_page_unmap>
    err:
	return r;
}
  802812:	89 d8                	mov    %ebx,%eax
  802814:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802817:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80281a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80281d:	89 ec                	mov    %ebp,%esp
  80281f:	5d                   	pop    %ebp
  802820:	c3                   	ret    
	...

00802830 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
  802838:	5d                   	pop    %ebp
  802839:	c3                   	ret    

0080283a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
  80283d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802840:	c7 44 24 04 05 34 80 	movl   $0x803405,0x4(%esp)
  802847:	00 
  802848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284b:	89 04 24             	mov    %eax,(%esp)
  80284e:	e8 e7 e0 ff ff       	call   80093a <strcpy>
	return 0;
}
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
  80285d:	57                   	push   %edi
  80285e:	56                   	push   %esi
  80285f:	53                   	push   %ebx
  802860:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802866:	b8 00 00 00 00       	mov    $0x0,%eax
  80286b:	be 00 00 00 00       	mov    $0x0,%esi
  802870:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802874:	74 3f                	je     8028b5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802876:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80287c:	8b 55 10             	mov    0x10(%ebp),%edx
  80287f:	29 c2                	sub    %eax,%edx
  802881:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802883:	83 fa 7f             	cmp    $0x7f,%edx
  802886:	76 05                	jbe    80288d <devcons_write+0x33>
  802888:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80288d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802891:	03 45 0c             	add    0xc(%ebp),%eax
  802894:	89 44 24 04          	mov    %eax,0x4(%esp)
  802898:	89 3c 24             	mov    %edi,(%esp)
  80289b:	e8 55 e2 ff ff       	call   800af5 <memmove>
		sys_cputs(buf, m);
  8028a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028a4:	89 3c 24             	mov    %edi,(%esp)
  8028a7:	e8 84 e4 ff ff       	call   800d30 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028ac:	01 de                	add    %ebx,%esi
  8028ae:	89 f0                	mov    %esi,%eax
  8028b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8028b3:	72 c7                	jb     80287c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8028b5:	89 f0                	mov    %esi,%eax
  8028b7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8028bd:	5b                   	pop    %ebx
  8028be:	5e                   	pop    %esi
  8028bf:	5f                   	pop    %edi
  8028c0:	5d                   	pop    %ebp
  8028c1:	c3                   	ret    

008028c2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
  8028c5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028d5:	00 
  8028d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028d9:	89 04 24             	mov    %eax,(%esp)
  8028dc:	e8 4f e4 ff ff       	call   800d30 <sys_cputs>
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8028e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028ed:	75 07                	jne    8028f6 <devcons_read+0x13>
  8028ef:	eb 28                	jmp    802919 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028f1:	e8 94 e8 ff ff       	call   80118a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028f6:	66 90                	xchg   %ax,%ax
  8028f8:	e8 ff e3 ff ff       	call   800cfc <sys_cgetc>
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	90                   	nop
  802900:	74 ef                	je     8028f1 <devcons_read+0xe>
  802902:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802904:	85 c0                	test   %eax,%eax
  802906:	78 16                	js     80291e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802908:	83 f8 04             	cmp    $0x4,%eax
  80290b:	74 0c                	je     802919 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80290d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802910:	88 10                	mov    %dl,(%eax)
  802912:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802917:	eb 05                	jmp    80291e <devcons_read+0x3b>
  802919:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802926:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802929:	89 04 24             	mov    %eax,(%esp)
  80292c:	e8 da ed ff ff       	call   80170b <fd_alloc>
  802931:	85 c0                	test   %eax,%eax
  802933:	78 3f                	js     802974 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802935:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80293c:	00 
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	89 44 24 04          	mov    %eax,0x4(%esp)
  802944:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80294b:	e8 db e7 ff ff       	call   80112b <sys_page_alloc>
  802950:	85 c0                	test   %eax,%eax
  802952:	78 20                	js     802974 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802954:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	89 04 24             	mov    %eax,(%esp)
  80296f:	e8 6c ed ff ff       	call   8016e0 <fd2num>
}
  802974:	c9                   	leave  
  802975:	c3                   	ret    

00802976 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802976:	55                   	push   %ebp
  802977:	89 e5                	mov    %esp,%ebp
  802979:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80297c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80297f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	89 04 24             	mov    %eax,(%esp)
  802989:	e8 ef ed ff ff       	call   80177d <fd_lookup>
  80298e:	85 c0                	test   %eax,%eax
  802990:	78 11                	js     8029a3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  80299d:	0f 94 c0             	sete   %al
  8029a0:	0f b6 c0             	movzbl %al,%eax
}
  8029a3:	c9                   	leave  
  8029a4:	c3                   	ret    

008029a5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
  8029a8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029b2:	00 
  8029b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c1:	e8 18 f0 ff ff       	call   8019de <read>
	if (r < 0)
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	78 0f                	js     8029d9 <getchar+0x34>
		return r;
	if (r < 1)
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	7f 07                	jg     8029d5 <getchar+0x30>
  8029ce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029d3:	eb 04                	jmp    8029d9 <getchar+0x34>
		return -E_EOF;
	return c;
  8029d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    
	...

008029dc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
  8029df:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029e2:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  8029e9:	75 78                	jne    802a63 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8029eb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029f2:	00 
  8029f3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029fa:	ee 
  8029fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a02:	e8 24 e7 ff ff       	call   80112b <sys_page_alloc>
  802a07:	85 c0                	test   %eax,%eax
  802a09:	79 20                	jns    802a2b <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  802a0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a0f:	c7 44 24 08 11 34 80 	movl   $0x803411,0x8(%esp)
  802a16:	00 
  802a17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a1e:	00 
  802a1f:	c7 04 24 2f 34 80 00 	movl   $0x80342f,(%esp)
  802a26:	e8 85 d7 ff ff       	call   8001b0 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802a2b:	c7 44 24 04 70 2a 80 	movl   $0x802a70,0x4(%esp)
  802a32:	00 
  802a33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a3a:	e8 16 e5 ff ff       	call   800f55 <sys_env_set_pgfault_upcall>
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	79 20                	jns    802a63 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a47:	c7 44 24 08 40 34 80 	movl   $0x803440,0x8(%esp)
  802a4e:	00 
  802a4f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802a56:	00 
  802a57:	c7 04 24 2f 34 80 00 	movl   $0x80342f,(%esp)
  802a5e:	e8 4d d7 ff ff       	call   8001b0 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	a3 7c 70 80 00       	mov    %eax,0x80707c
	
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    
  802a6d:	00 00                	add    %al,(%eax)
	...

00802a70 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a70:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a71:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  802a76:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a78:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802a7b:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802a7d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802a81:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802a85:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802a87:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802a88:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802a8a:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802a8d:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802a91:	83 c4 08             	add    $0x8,%esp
	popal
  802a94:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802a95:	83 c4 04             	add    $0x4,%esp
	popfl
  802a98:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802a99:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802a9a:	c3                   	ret    
	...

00802a9c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a9c:	55                   	push   %ebp
  802a9d:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	89 c2                	mov    %eax,%edx
  802aa4:	c1 ea 16             	shr    $0x16,%edx
  802aa7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802aae:	f6 c2 01             	test   $0x1,%dl
  802ab1:	74 26                	je     802ad9 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802ab3:	c1 e8 0c             	shr    $0xc,%eax
  802ab6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802abd:	a8 01                	test   $0x1,%al
  802abf:	74 18                	je     802ad9 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802ac1:	c1 e8 0c             	shr    $0xc,%eax
  802ac4:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802ac7:	c1 e2 02             	shl    $0x2,%edx
  802aca:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802acf:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802ad4:	0f b7 c0             	movzwl %ax,%eax
  802ad7:	eb 05                	jmp    802ade <pageref+0x42>
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ade:	5d                   	pop    %ebp
  802adf:	c3                   	ret    

00802ae0 <__udivdi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
  802ae3:	57                   	push   %edi
  802ae4:	56                   	push   %esi
  802ae5:	83 ec 10             	sub    $0x10,%esp
  802ae8:	8b 45 14             	mov    0x14(%ebp),%eax
  802aeb:	8b 55 08             	mov    0x8(%ebp),%edx
  802aee:	8b 75 10             	mov    0x10(%ebp),%esi
  802af1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802af4:	85 c0                	test   %eax,%eax
  802af6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802af9:	75 35                	jne    802b30 <__udivdi3+0x50>
  802afb:	39 fe                	cmp    %edi,%esi
  802afd:	77 61                	ja     802b60 <__udivdi3+0x80>
  802aff:	85 f6                	test   %esi,%esi
  802b01:	75 0b                	jne    802b0e <__udivdi3+0x2e>
  802b03:	b8 01 00 00 00       	mov    $0x1,%eax
  802b08:	31 d2                	xor    %edx,%edx
  802b0a:	f7 f6                	div    %esi
  802b0c:	89 c6                	mov    %eax,%esi
  802b0e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b11:	31 d2                	xor    %edx,%edx
  802b13:	89 f8                	mov    %edi,%eax
  802b15:	f7 f6                	div    %esi
  802b17:	89 c7                	mov    %eax,%edi
  802b19:	89 c8                	mov    %ecx,%eax
  802b1b:	f7 f6                	div    %esi
  802b1d:	89 c1                	mov    %eax,%ecx
  802b1f:	89 fa                	mov    %edi,%edx
  802b21:	89 c8                	mov    %ecx,%eax
  802b23:	83 c4 10             	add    $0x10,%esp
  802b26:	5e                   	pop    %esi
  802b27:	5f                   	pop    %edi
  802b28:	5d                   	pop    %ebp
  802b29:	c3                   	ret    
  802b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b30:	39 f8                	cmp    %edi,%eax
  802b32:	77 1c                	ja     802b50 <__udivdi3+0x70>
  802b34:	0f bd d0             	bsr    %eax,%edx
  802b37:	83 f2 1f             	xor    $0x1f,%edx
  802b3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802b3d:	75 39                	jne    802b78 <__udivdi3+0x98>
  802b3f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802b42:	0f 86 a0 00 00 00    	jbe    802be8 <__udivdi3+0x108>
  802b48:	39 f8                	cmp    %edi,%eax
  802b4a:	0f 82 98 00 00 00    	jb     802be8 <__udivdi3+0x108>
  802b50:	31 ff                	xor    %edi,%edi
  802b52:	31 c9                	xor    %ecx,%ecx
  802b54:	89 c8                	mov    %ecx,%eax
  802b56:	89 fa                	mov    %edi,%edx
  802b58:	83 c4 10             	add    $0x10,%esp
  802b5b:	5e                   	pop    %esi
  802b5c:	5f                   	pop    %edi
  802b5d:	5d                   	pop    %ebp
  802b5e:	c3                   	ret    
  802b5f:	90                   	nop
  802b60:	89 d1                	mov    %edx,%ecx
  802b62:	89 fa                	mov    %edi,%edx
  802b64:	89 c8                	mov    %ecx,%eax
  802b66:	31 ff                	xor    %edi,%edi
  802b68:	f7 f6                	div    %esi
  802b6a:	89 c1                	mov    %eax,%ecx
  802b6c:	89 fa                	mov    %edi,%edx
  802b6e:	89 c8                	mov    %ecx,%eax
  802b70:	83 c4 10             	add    $0x10,%esp
  802b73:	5e                   	pop    %esi
  802b74:	5f                   	pop    %edi
  802b75:	5d                   	pop    %ebp
  802b76:	c3                   	ret    
  802b77:	90                   	nop
  802b78:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b7c:	89 f2                	mov    %esi,%edx
  802b7e:	d3 e0                	shl    %cl,%eax
  802b80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b83:	b8 20 00 00 00       	mov    $0x20,%eax
  802b88:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b8b:	89 c1                	mov    %eax,%ecx
  802b8d:	d3 ea                	shr    %cl,%edx
  802b8f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b93:	0b 55 ec             	or     -0x14(%ebp),%edx
  802b96:	d3 e6                	shl    %cl,%esi
  802b98:	89 c1                	mov    %eax,%ecx
  802b9a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802b9d:	89 fe                	mov    %edi,%esi
  802b9f:	d3 ee                	shr    %cl,%esi
  802ba1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ba5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bab:	d3 e7                	shl    %cl,%edi
  802bad:	89 c1                	mov    %eax,%ecx
  802baf:	d3 ea                	shr    %cl,%edx
  802bb1:	09 d7                	or     %edx,%edi
  802bb3:	89 f2                	mov    %esi,%edx
  802bb5:	89 f8                	mov    %edi,%eax
  802bb7:	f7 75 ec             	divl   -0x14(%ebp)
  802bba:	89 d6                	mov    %edx,%esi
  802bbc:	89 c7                	mov    %eax,%edi
  802bbe:	f7 65 e8             	mull   -0x18(%ebp)
  802bc1:	39 d6                	cmp    %edx,%esi
  802bc3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802bc6:	72 30                	jb     802bf8 <__udivdi3+0x118>
  802bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bcf:	d3 e2                	shl    %cl,%edx
  802bd1:	39 c2                	cmp    %eax,%edx
  802bd3:	73 05                	jae    802bda <__udivdi3+0xfa>
  802bd5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802bd8:	74 1e                	je     802bf8 <__udivdi3+0x118>
  802bda:	89 f9                	mov    %edi,%ecx
  802bdc:	31 ff                	xor    %edi,%edi
  802bde:	e9 71 ff ff ff       	jmp    802b54 <__udivdi3+0x74>
  802be3:	90                   	nop
  802be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802be8:	31 ff                	xor    %edi,%edi
  802bea:	b9 01 00 00 00       	mov    $0x1,%ecx
  802bef:	e9 60 ff ff ff       	jmp    802b54 <__udivdi3+0x74>
  802bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bf8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802bfb:	31 ff                	xor    %edi,%edi
  802bfd:	89 c8                	mov    %ecx,%eax
  802bff:	89 fa                	mov    %edi,%edx
  802c01:	83 c4 10             	add    $0x10,%esp
  802c04:	5e                   	pop    %esi
  802c05:	5f                   	pop    %edi
  802c06:	5d                   	pop    %ebp
  802c07:	c3                   	ret    
	...

00802c10 <__umoddi3>:
  802c10:	55                   	push   %ebp
  802c11:	89 e5                	mov    %esp,%ebp
  802c13:	57                   	push   %edi
  802c14:	56                   	push   %esi
  802c15:	83 ec 20             	sub    $0x20,%esp
  802c18:	8b 55 14             	mov    0x14(%ebp),%edx
  802c1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c1e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802c21:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c24:	85 d2                	test   %edx,%edx
  802c26:	89 c8                	mov    %ecx,%eax
  802c28:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802c2b:	75 13                	jne    802c40 <__umoddi3+0x30>
  802c2d:	39 f7                	cmp    %esi,%edi
  802c2f:	76 3f                	jbe    802c70 <__umoddi3+0x60>
  802c31:	89 f2                	mov    %esi,%edx
  802c33:	f7 f7                	div    %edi
  802c35:	89 d0                	mov    %edx,%eax
  802c37:	31 d2                	xor    %edx,%edx
  802c39:	83 c4 20             	add    $0x20,%esp
  802c3c:	5e                   	pop    %esi
  802c3d:	5f                   	pop    %edi
  802c3e:	5d                   	pop    %ebp
  802c3f:	c3                   	ret    
  802c40:	39 f2                	cmp    %esi,%edx
  802c42:	77 4c                	ja     802c90 <__umoddi3+0x80>
  802c44:	0f bd ca             	bsr    %edx,%ecx
  802c47:	83 f1 1f             	xor    $0x1f,%ecx
  802c4a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802c4d:	75 51                	jne    802ca0 <__umoddi3+0x90>
  802c4f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802c52:	0f 87 e0 00 00 00    	ja     802d38 <__umoddi3+0x128>
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	29 f8                	sub    %edi,%eax
  802c5d:	19 d6                	sbb    %edx,%esi
  802c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	89 f2                	mov    %esi,%edx
  802c67:	83 c4 20             	add    $0x20,%esp
  802c6a:	5e                   	pop    %esi
  802c6b:	5f                   	pop    %edi
  802c6c:	5d                   	pop    %ebp
  802c6d:	c3                   	ret    
  802c6e:	66 90                	xchg   %ax,%ax
  802c70:	85 ff                	test   %edi,%edi
  802c72:	75 0b                	jne    802c7f <__umoddi3+0x6f>
  802c74:	b8 01 00 00 00       	mov    $0x1,%eax
  802c79:	31 d2                	xor    %edx,%edx
  802c7b:	f7 f7                	div    %edi
  802c7d:	89 c7                	mov    %eax,%edi
  802c7f:	89 f0                	mov    %esi,%eax
  802c81:	31 d2                	xor    %edx,%edx
  802c83:	f7 f7                	div    %edi
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	f7 f7                	div    %edi
  802c8a:	eb a9                	jmp    802c35 <__umoddi3+0x25>
  802c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c90:	89 c8                	mov    %ecx,%eax
  802c92:	89 f2                	mov    %esi,%edx
  802c94:	83 c4 20             	add    $0x20,%esp
  802c97:	5e                   	pop    %esi
  802c98:	5f                   	pop    %edi
  802c99:	5d                   	pop    %ebp
  802c9a:	c3                   	ret    
  802c9b:	90                   	nop
  802c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ca0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ca4:	d3 e2                	shl    %cl,%edx
  802ca6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ca9:	ba 20 00 00 00       	mov    $0x20,%edx
  802cae:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802cb1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802cb4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cb8:	89 fa                	mov    %edi,%edx
  802cba:	d3 ea                	shr    %cl,%edx
  802cbc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cc0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802cc3:	d3 e7                	shl    %cl,%edi
  802cc5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ccc:	89 f2                	mov    %esi,%edx
  802cce:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802cd1:	89 c7                	mov    %eax,%edi
  802cd3:	d3 ea                	shr    %cl,%edx
  802cd5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cd9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802cdc:	89 c2                	mov    %eax,%edx
  802cde:	d3 e6                	shl    %cl,%esi
  802ce0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ce4:	d3 ea                	shr    %cl,%edx
  802ce6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cea:	09 d6                	or     %edx,%esi
  802cec:	89 f0                	mov    %esi,%eax
  802cee:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802cf1:	d3 e7                	shl    %cl,%edi
  802cf3:	89 f2                	mov    %esi,%edx
  802cf5:	f7 75 f4             	divl   -0xc(%ebp)
  802cf8:	89 d6                	mov    %edx,%esi
  802cfa:	f7 65 e8             	mull   -0x18(%ebp)
  802cfd:	39 d6                	cmp    %edx,%esi
  802cff:	72 2b                	jb     802d2c <__umoddi3+0x11c>
  802d01:	39 c7                	cmp    %eax,%edi
  802d03:	72 23                	jb     802d28 <__umoddi3+0x118>
  802d05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d09:	29 c7                	sub    %eax,%edi
  802d0b:	19 d6                	sbb    %edx,%esi
  802d0d:	89 f0                	mov    %esi,%eax
  802d0f:	89 f2                	mov    %esi,%edx
  802d11:	d3 ef                	shr    %cl,%edi
  802d13:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d17:	d3 e0                	shl    %cl,%eax
  802d19:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d1d:	09 f8                	or     %edi,%eax
  802d1f:	d3 ea                	shr    %cl,%edx
  802d21:	83 c4 20             	add    $0x20,%esp
  802d24:	5e                   	pop    %esi
  802d25:	5f                   	pop    %edi
  802d26:	5d                   	pop    %ebp
  802d27:	c3                   	ret    
  802d28:	39 d6                	cmp    %edx,%esi
  802d2a:	75 d9                	jne    802d05 <__umoddi3+0xf5>
  802d2c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802d2f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802d32:	eb d1                	jmp    802d05 <__umoddi3+0xf5>
  802d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d38:	39 f2                	cmp    %esi,%edx
  802d3a:	0f 82 18 ff ff ff    	jb     802c58 <__umoddi3+0x48>
  802d40:	e9 1d ff ff ff       	jmp    802c62 <__umoddi3+0x52>
