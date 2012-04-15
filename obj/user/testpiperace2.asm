
obj/user/testpiperace2:     file format elf32-i386


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
  80002c:	e8 bb 01 00 00       	call   8001ec <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

#include <inc/lib.h>

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int p[2], r, i;
	struct Fd *fd;
	volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003d:	c7 04 24 00 2e 80 00 	movl   $0x802e00,(%esp)
  800044:	e8 d4 02 00 00       	call   80031d <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 25 26 00 00       	call   802679 <pipe>
  800054:	85 c0                	test   %eax,%eax
  800056:	79 20                	jns    800078 <umain+0x44>
		panic("pipe: %e", r);
  800058:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005c:	c7 44 24 08 4e 2e 80 	movl   $0x802e4e,0x8(%esp)
  800063:	00 
  800064:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006b:	00 
  80006c:	c7 04 24 57 2e 80 00 	movl   $0x802e57,(%esp)
  800073:	e8 e0 01 00 00       	call   800258 <_panic>
	if ((r = fork()) < 0)
  800078:	e8 d8 13 00 00       	call   801455 <fork>
  80007d:	89 c7                	mov    %eax,%edi
  80007f:	85 c0                	test   %eax,%eax
  800081:	79 20                	jns    8000a3 <umain+0x6f>
		panic("fork: %e", r);
  800083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800087:	c7 44 24 08 6c 2e 80 	movl   $0x802e6c,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 57 2e 80 00 	movl   $0x802e57,(%esp)
  80009e:	e8 b5 01 00 00       	call   800258 <_panic>
	if (r == 0) {
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	75 75                	jne    80011c <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000aa:	89 04 24             	mov    %eax,(%esp)
  8000ad:	e8 5c 1a 00 00       	call   801b0e <close>
  8000b2:	bb 00 00 00 00       	mov    $0x0,%ebx
		for (i = 0; i < 200; i++) {
			if (i % 10 == 0)
  8000b7:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	f7 ee                	imul   %esi
  8000c0:	c1 fa 02             	sar    $0x2,%edx
  8000c3:	89 d8                	mov    %ebx,%eax
  8000c5:	c1 f8 1f             	sar    $0x1f,%eax
  8000c8:	29 c2                	sub    %eax,%edx
  8000ca:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	39 c3                	cmp    %eax,%ebx
  8000d1:	75 10                	jne    8000e3 <umain+0xaf>
				cprintf("%d.", i);
  8000d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d7:	c7 04 24 75 2e 80 00 	movl   $0x802e75,(%esp)
  8000de:	e8 3a 02 00 00       	call   80031d <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e3:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000ea:	00 
  8000eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ee:	89 04 24             	mov    %eax,(%esp)
  8000f1:	e8 b7 1a 00 00       	call   801bad <dup>
			sys_yield();
  8000f6:	e8 2f 11 00 00       	call   80122a <sys_yield>
			close(10);
  8000fb:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800102:	e8 07 1a 00 00       	call   801b0e <close>
			sys_yield();
  800107:	e8 1e 11 00 00       	call   80122a <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010c:	83 c3 01             	add    $0x1,%ebx
  80010f:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800115:	75 a5                	jne    8000bc <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800117:	e8 20 01 00 00       	call   80023c <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011c:	89 fb                	mov    %edi,%ebx
  80011e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800124:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800127:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012d:	eb 28                	jmp    800157 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  80012f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800132:	89 04 24             	mov    %eax,(%esp)
  800135:	e8 0c 25 00 00       	call   802646 <pipeisclosed>
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 19                	je     800157 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013e:	c7 04 24 79 2e 80 00 	movl   $0x802e79,(%esp)
  800145:	e8 d3 01 00 00       	call   80031d <cprintf>
			sys_env_destroy(r);
  80014a:	89 3c 24             	mov    %edi,(%esp)
  80014d:	e8 40 11 00 00       	call   801292 <sys_env_destroy>
			exit();
  800152:	e8 e5 00 00 00       	call   80023c <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800157:	8b 43 54             	mov    0x54(%ebx),%eax
  80015a:	83 f8 01             	cmp    $0x1,%eax
  80015d:	74 d0                	je     80012f <umain+0xfb>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80015f:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  800166:	e8 b2 01 00 00       	call   80031d <cprintf>
	if (pipeisclosed(p[0]))
  80016b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016e:	89 04 24             	mov    %eax,(%esp)
  800171:	e8 d0 24 00 00       	call   802646 <pipeisclosed>
  800176:	85 c0                	test   %eax,%eax
  800178:	74 1c                	je     800196 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  80017a:	c7 44 24 08 24 2e 80 	movl   $0x802e24,0x8(%esp)
  800181:	00 
  800182:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800189:	00 
  80018a:	c7 04 24 57 2e 80 00 	movl   $0x802e57,(%esp)
  800191:	e8 c2 00 00 00       	call   800258 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800196:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800199:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 a5 15 00 00       	call   80174d <fd_lookup>
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	79 20                	jns    8001cc <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b0:	c7 44 24 08 ab 2e 80 	movl   $0x802eab,0x8(%esp)
  8001b7:	00 
  8001b8:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001bf:	00 
  8001c0:	c7 04 24 57 2e 80 00 	movl   $0x802e57,(%esp)
  8001c7:	e8 8c 00 00 00       	call   800258 <_panic>
	(void) fd2data(fd);
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	89 04 24             	mov    %eax,(%esp)
  8001d2:	e8 e9 14 00 00       	call   8016c0 <fd2data>
	cprintf("race didn't happen\n");
  8001d7:	c7 04 24 c3 2e 80 00 	movl   $0x802ec3,(%esp)
  8001de:	e8 3a 01 00 00       	call   80031d <cprintf>
}
  8001e3:	83 c4 2c             	add    $0x2c,%esp
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5f                   	pop    %edi
  8001e9:	5d                   	pop    %ebp
  8001ea:	c3                   	ret    
	...

008001ec <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 18             	sub    $0x18,%esp
  8001f2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001f5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8001fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8001fe:	e8 5b 10 00 00       	call   80125e <sys_getenvid>
	env = &envs[ENVX(envid)];
  800203:	25 ff 03 00 00       	and    $0x3ff,%eax
  800208:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800210:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800215:	85 f6                	test   %esi,%esi
  800217:	7e 07                	jle    800220 <libmain+0x34>
		binaryname = argv[0];
  800219:	8b 03                	mov    (%ebx),%eax
  80021b:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800224:	89 34 24             	mov    %esi,(%esp)
  800227:	e8 08 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80022c:	e8 0b 00 00 00       	call   80023c <exit>
}
  800231:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800234:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800237:	89 ec                	mov    %ebp,%esp
  800239:	5d                   	pop    %ebp
  80023a:	c3                   	ret    
	...

0080023c <exit>:
#include <inc/lib.h>

void
exit(void)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800242:	e8 44 19 00 00       	call   801b8b <close_all>
	sys_env_destroy(0);
  800247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80024e:	e8 3f 10 00 00       	call   801292 <sys_env_destroy>
}
  800253:	c9                   	leave  
  800254:	c3                   	ret    
  800255:	00 00                	add    %al,(%eax)
	...

00800258 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	53                   	push   %ebx
  80025c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80025f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800262:	a1 78 70 80 00       	mov    0x807078,%eax
  800267:	85 c0                	test   %eax,%eax
  800269:	74 10                	je     80027b <_panic+0x23>
		cprintf("%s: ", argv0);
  80026b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026f:	c7 04 24 ee 2e 80 00 	movl   $0x802eee,(%esp)
  800276:	e8 a2 00 00 00       	call   80031d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	89 44 24 08          	mov    %eax,0x8(%esp)
  800289:	a1 00 70 80 00       	mov    0x807000,%eax
  80028e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800292:	c7 04 24 f3 2e 80 00 	movl   $0x802ef3,(%esp)
  800299:	e8 7f 00 00 00       	call   80031d <cprintf>
	vcprintf(fmt, ap);
  80029e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	89 04 24             	mov    %eax,(%esp)
  8002a8:	e8 0f 00 00 00       	call   8002bc <vcprintf>
	cprintf("\n");
  8002ad:	c7 04 24 32 35 80 00 	movl   $0x803532,(%esp)
  8002b4:	e8 64 00 00 00       	call   80031d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002b9:	cc                   	int3   
  8002ba:	eb fd                	jmp    8002b9 <_panic+0x61>

008002bc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cc:	00 00 00 
	b.cnt = 0;
  8002cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	c7 04 24 37 03 80 00 	movl   $0x800337,(%esp)
  8002f8:	e8 d0 01 00 00       	call   8004cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002fd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800303:	89 44 24 04          	mov    %eax,0x4(%esp)
  800307:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030d:	89 04 24             	mov    %eax,(%esp)
  800310:	e8 bb 0a 00 00       	call   800dd0 <sys_cputs>

	return b.cnt;
}
  800315:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800323:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800326:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	89 04 24             	mov    %eax,(%esp)
  800330:	e8 87 ff ff ff       	call   8002bc <vcprintf>
	va_end(ap);

	return cnt;
}
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	53                   	push   %ebx
  80033b:	83 ec 14             	sub    $0x14,%esp
  80033e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800341:	8b 03                	mov    (%ebx),%eax
  800343:	8b 55 08             	mov    0x8(%ebp),%edx
  800346:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80034a:	83 c0 01             	add    $0x1,%eax
  80034d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80034f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800354:	75 19                	jne    80036f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800356:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80035d:	00 
  80035e:	8d 43 08             	lea    0x8(%ebx),%eax
  800361:	89 04 24             	mov    %eax,(%esp)
  800364:	e8 67 0a 00 00       	call   800dd0 <sys_cputs>
		b->idx = 0;
  800369:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80036f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800373:	83 c4 14             	add    $0x14,%esp
  800376:	5b                   	pop    %ebx
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    
  800379:	00 00                	add    %al,(%eax)
  80037b:	00 00                	add    %al,(%eax)
  80037d:	00 00                	add    %al,(%eax)
	...

00800380 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	57                   	push   %edi
  800384:	56                   	push   %esi
  800385:	53                   	push   %ebx
  800386:	83 ec 4c             	sub    $0x4c,%esp
  800389:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038c:	89 d6                	mov    %edx,%esi
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80039a:	8b 45 10             	mov    0x10(%ebp),%eax
  80039d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003a0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ab:	39 d1                	cmp    %edx,%ecx
  8003ad:	72 15                	jb     8003c4 <printnum+0x44>
  8003af:	77 07                	ja     8003b8 <printnum+0x38>
  8003b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003b4:	39 d0                	cmp    %edx,%eax
  8003b6:	76 0c                	jbe    8003c4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b8:	83 eb 01             	sub    $0x1,%ebx
  8003bb:	85 db                	test   %ebx,%ebx
  8003bd:	8d 76 00             	lea    0x0(%esi),%esi
  8003c0:	7f 61                	jg     800423 <printnum+0xa3>
  8003c2:	eb 70                	jmp    800434 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003c8:	83 eb 01             	sub    $0x1,%ebx
  8003cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003d7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003db:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003de:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003e1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003ef:	00 
  8003f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f3:	89 04 24             	mov    %eax,(%esp)
  8003f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003fd:	e8 8e 27 00 00       	call   802b90 <__udivdi3>
  800402:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800405:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800408:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80040c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800410:	89 04 24             	mov    %eax,(%esp)
  800413:	89 54 24 04          	mov    %edx,0x4(%esp)
  800417:	89 f2                	mov    %esi,%edx
  800419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041c:	e8 5f ff ff ff       	call   800380 <printnum>
  800421:	eb 11                	jmp    800434 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800423:	89 74 24 04          	mov    %esi,0x4(%esp)
  800427:	89 3c 24             	mov    %edi,(%esp)
  80042a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042d:	83 eb 01             	sub    $0x1,%ebx
  800430:	85 db                	test   %ebx,%ebx
  800432:	7f ef                	jg     800423 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800434:	89 74 24 04          	mov    %esi,0x4(%esp)
  800438:	8b 74 24 04          	mov    0x4(%esp),%esi
  80043c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800443:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80044a:	00 
  80044b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80044e:	89 14 24             	mov    %edx,(%esp)
  800451:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800454:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800458:	e8 63 28 00 00       	call   802cc0 <__umoddi3>
  80045d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800461:	0f be 80 0f 2f 80 00 	movsbl 0x802f0f(%eax),%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80046e:	83 c4 4c             	add    $0x4c,%esp
  800471:	5b                   	pop    %ebx
  800472:	5e                   	pop    %esi
  800473:	5f                   	pop    %edi
  800474:	5d                   	pop    %ebp
  800475:	c3                   	ret    

00800476 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800479:	83 fa 01             	cmp    $0x1,%edx
  80047c:	7e 0e                	jle    80048c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80047e:	8b 10                	mov    (%eax),%edx
  800480:	8d 4a 08             	lea    0x8(%edx),%ecx
  800483:	89 08                	mov    %ecx,(%eax)
  800485:	8b 02                	mov    (%edx),%eax
  800487:	8b 52 04             	mov    0x4(%edx),%edx
  80048a:	eb 22                	jmp    8004ae <getuint+0x38>
	else if (lflag)
  80048c:	85 d2                	test   %edx,%edx
  80048e:	74 10                	je     8004a0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8d 4a 04             	lea    0x4(%edx),%ecx
  800495:	89 08                	mov    %ecx,(%eax)
  800497:	8b 02                	mov    (%edx),%eax
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
  80049e:	eb 0e                	jmp    8004ae <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004a0:	8b 10                	mov    (%eax),%edx
  8004a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004a5:	89 08                	mov    %ecx,(%eax)
  8004a7:	8b 02                	mov    (%edx),%eax
  8004a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ba:	8b 10                	mov    (%eax),%edx
  8004bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8004bf:	73 0a                	jae    8004cb <sprintputch+0x1b>
		*b->buf++ = ch;
  8004c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c4:	88 0a                	mov    %cl,(%edx)
  8004c6:	83 c2 01             	add    $0x1,%edx
  8004c9:	89 10                	mov    %edx,(%eax)
}
  8004cb:	5d                   	pop    %ebp
  8004cc:	c3                   	ret    

008004cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	57                   	push   %edi
  8004d1:	56                   	push   %esi
  8004d2:	53                   	push   %ebx
  8004d3:	83 ec 5c             	sub    $0x5c,%esp
  8004d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004df:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004e6:	eb 11                	jmp    8004f9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	0f 84 ec 03 00 00    	je     8008dc <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8004f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004f4:	89 04 24             	mov    %eax,(%esp)
  8004f7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f9:	0f b6 03             	movzbl (%ebx),%eax
  8004fc:	83 c3 01             	add    $0x1,%ebx
  8004ff:	83 f8 25             	cmp    $0x25,%eax
  800502:	75 e4                	jne    8004e8 <vprintfmt+0x1b>
  800504:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800508:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80050f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800516:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80051d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800522:	eb 06                	jmp    80052a <vprintfmt+0x5d>
  800524:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800528:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	0f b6 13             	movzbl (%ebx),%edx
  80052d:	0f b6 c2             	movzbl %dl,%eax
  800530:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800533:	8d 43 01             	lea    0x1(%ebx),%eax
  800536:	83 ea 23             	sub    $0x23,%edx
  800539:	80 fa 55             	cmp    $0x55,%dl
  80053c:	0f 87 7d 03 00 00    	ja     8008bf <vprintfmt+0x3f2>
  800542:	0f b6 d2             	movzbl %dl,%edx
  800545:	ff 24 95 60 30 80 00 	jmp    *0x803060(,%edx,4)
  80054c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800550:	eb d6                	jmp    800528 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800552:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800555:	83 ea 30             	sub    $0x30,%edx
  800558:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80055b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80055e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800561:	83 fb 09             	cmp    $0x9,%ebx
  800564:	77 4c                	ja     8005b2 <vprintfmt+0xe5>
  800566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800569:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80056c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80056f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800572:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800576:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800579:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80057c:	83 fb 09             	cmp    $0x9,%ebx
  80057f:	76 eb                	jbe    80056c <vprintfmt+0x9f>
  800581:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800584:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800587:	eb 29                	jmp    8005b2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800589:	8b 55 14             	mov    0x14(%ebp),%edx
  80058c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80058f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800592:	8b 12                	mov    (%edx),%edx
  800594:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800597:	eb 19                	jmp    8005b2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800599:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80059c:	c1 fa 1f             	sar    $0x1f,%edx
  80059f:	f7 d2                	not    %edx
  8005a1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8005a4:	eb 82                	jmp    800528 <vprintfmt+0x5b>
  8005a6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8005ad:	e9 76 ff ff ff       	jmp    800528 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8005b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b6:	0f 89 6c ff ff ff    	jns    800528 <vprintfmt+0x5b>
  8005bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8005c5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005c8:	e9 5b ff ff ff       	jmp    800528 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005cd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8005d0:	e9 53 ff ff ff       	jmp    800528 <vprintfmt+0x5b>
  8005d5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8d 50 04             	lea    0x4(%eax),%edx
  8005de:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 04 24             	mov    %eax,(%esp)
  8005ea:	ff d7                	call   *%edi
  8005ec:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8005ef:	e9 05 ff ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  8005f4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 50 04             	lea    0x4(%eax),%edx
  8005fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 c2                	mov    %eax,%edx
  800604:	c1 fa 1f             	sar    $0x1f,%edx
  800607:	31 d0                	xor    %edx,%eax
  800609:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80060b:	83 f8 0f             	cmp    $0xf,%eax
  80060e:	7f 0b                	jg     80061b <vprintfmt+0x14e>
  800610:	8b 14 85 c0 31 80 00 	mov    0x8031c0(,%eax,4),%edx
  800617:	85 d2                	test   %edx,%edx
  800619:	75 20                	jne    80063b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80061b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80061f:	c7 44 24 08 20 2f 80 	movl   $0x802f20,0x8(%esp)
  800626:	00 
  800627:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062b:	89 3c 24             	mov    %edi,(%esp)
  80062e:	e8 31 03 00 00       	call   800964 <printfmt>
  800633:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800636:	e9 be fe ff ff       	jmp    8004f9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80063b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80063f:	c7 44 24 08 f6 34 80 	movl   $0x8034f6,0x8(%esp)
  800646:	00 
  800647:	89 74 24 04          	mov    %esi,0x4(%esp)
  80064b:	89 3c 24             	mov    %edi,(%esp)
  80064e:	e8 11 03 00 00       	call   800964 <printfmt>
  800653:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800656:	e9 9e fe ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  80065b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80065e:	89 c3                	mov    %eax,%ebx
  800660:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800666:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 50 04             	lea    0x4(%eax),%edx
  80066f:	89 55 14             	mov    %edx,0x14(%ebp)
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800677:	85 c0                	test   %eax,%eax
  800679:	75 07                	jne    800682 <vprintfmt+0x1b5>
  80067b:	c7 45 e0 29 2f 80 00 	movl   $0x802f29,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800682:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800686:	7e 06                	jle    80068e <vprintfmt+0x1c1>
  800688:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80068c:	75 13                	jne    8006a1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800691:	0f be 02             	movsbl (%edx),%eax
  800694:	85 c0                	test   %eax,%eax
  800696:	0f 85 99 00 00 00    	jne    800735 <vprintfmt+0x268>
  80069c:	e9 86 00 00 00       	jmp    800727 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006a8:	89 0c 24             	mov    %ecx,(%esp)
  8006ab:	e8 fb 02 00 00       	call   8009ab <strnlen>
  8006b0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006b3:	29 c2                	sub    %eax,%edx
  8006b5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b8:	85 d2                	test   %edx,%edx
  8006ba:	7e d2                	jle    80068e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8006bc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8006c0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006c3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8006c6:	89 d3                	mov    %edx,%ebx
  8006c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	83 eb 01             	sub    $0x1,%ebx
  8006d7:	85 db                	test   %ebx,%ebx
  8006d9:	7f ed                	jg     8006c8 <vprintfmt+0x1fb>
  8006db:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8006de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006e5:	eb a7                	jmp    80068e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006eb:	74 18                	je     800705 <vprintfmt+0x238>
  8006ed:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006f0:	83 fa 5e             	cmp    $0x5e,%edx
  8006f3:	76 10                	jbe    800705 <vprintfmt+0x238>
					putch('?', putdat);
  8006f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800700:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800703:	eb 0a                	jmp    80070f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800705:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800709:	89 04 24             	mov    %eax,(%esp)
  80070c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800713:	0f be 03             	movsbl (%ebx),%eax
  800716:	85 c0                	test   %eax,%eax
  800718:	74 05                	je     80071f <vprintfmt+0x252>
  80071a:	83 c3 01             	add    $0x1,%ebx
  80071d:	eb 29                	jmp    800748 <vprintfmt+0x27b>
  80071f:	89 fe                	mov    %edi,%esi
  800721:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800724:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800727:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072b:	7f 2e                	jg     80075b <vprintfmt+0x28e>
  80072d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800730:	e9 c4 fd ff ff       	jmp    8004f9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800738:	83 c2 01             	add    $0x1,%edx
  80073b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80073e:	89 f7                	mov    %esi,%edi
  800740:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800743:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800746:	89 d3                	mov    %edx,%ebx
  800748:	85 f6                	test   %esi,%esi
  80074a:	78 9b                	js     8006e7 <vprintfmt+0x21a>
  80074c:	83 ee 01             	sub    $0x1,%esi
  80074f:	79 96                	jns    8006e7 <vprintfmt+0x21a>
  800751:	89 fe                	mov    %edi,%esi
  800753:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800756:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800759:	eb cc                	jmp    800727 <vprintfmt+0x25a>
  80075b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80075e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800761:	89 74 24 04          	mov    %esi,0x4(%esp)
  800765:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80076c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076e:	83 eb 01             	sub    $0x1,%ebx
  800771:	85 db                	test   %ebx,%ebx
  800773:	7f ec                	jg     800761 <vprintfmt+0x294>
  800775:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800778:	e9 7c fd ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  80077d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800780:	83 f9 01             	cmp    $0x1,%ecx
  800783:	7e 16                	jle    80079b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 50 08             	lea    0x8(%eax),%edx
  80078b:	89 55 14             	mov    %edx,0x14(%ebp)
  80078e:	8b 10                	mov    (%eax),%edx
  800790:	8b 48 04             	mov    0x4(%eax),%ecx
  800793:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800796:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800799:	eb 32                	jmp    8007cd <vprintfmt+0x300>
	else if (lflag)
  80079b:	85 c9                	test   %ecx,%ecx
  80079d:	74 18                	je     8007b7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8d 50 04             	lea    0x4(%eax),%edx
  8007a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ad:	89 c1                	mov    %eax,%ecx
  8007af:	c1 f9 1f             	sar    $0x1f,%ecx
  8007b2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007b5:	eb 16                	jmp    8007cd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8d 50 04             	lea    0x4(%eax),%edx
  8007bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c5:	89 c2                	mov    %eax,%edx
  8007c7:	c1 fa 1f             	sar    $0x1f,%edx
  8007ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007cd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007d0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007d3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007dc:	0f 89 9b 00 00 00    	jns    80087d <vprintfmt+0x3b0>
				putch('-', putdat);
  8007e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007ed:	ff d7                	call   *%edi
				num = -(long long) num;
  8007ef:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007f2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007f5:	f7 d9                	neg    %ecx
  8007f7:	83 d3 00             	adc    $0x0,%ebx
  8007fa:	f7 db                	neg    %ebx
  8007fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800801:	eb 7a                	jmp    80087d <vprintfmt+0x3b0>
  800803:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800806:	89 ca                	mov    %ecx,%edx
  800808:	8d 45 14             	lea    0x14(%ebp),%eax
  80080b:	e8 66 fc ff ff       	call   800476 <getuint>
  800810:	89 c1                	mov    %eax,%ecx
  800812:	89 d3                	mov    %edx,%ebx
  800814:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800819:	eb 62                	jmp    80087d <vprintfmt+0x3b0>
  80081b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80081e:	89 ca                	mov    %ecx,%edx
  800820:	8d 45 14             	lea    0x14(%ebp),%eax
  800823:	e8 4e fc ff ff       	call   800476 <getuint>
  800828:	89 c1                	mov    %eax,%ecx
  80082a:	89 d3                	mov    %edx,%ebx
  80082c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800831:	eb 4a                	jmp    80087d <vprintfmt+0x3b0>
  800833:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800836:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800841:	ff d7                	call   *%edi
			putch('x', putdat);
  800843:	89 74 24 04          	mov    %esi,0x4(%esp)
  800847:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80084e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	89 55 14             	mov    %edx,0x14(%ebp)
  800859:	8b 08                	mov    (%eax),%ecx
  80085b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800860:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800865:	eb 16                	jmp    80087d <vprintfmt+0x3b0>
  800867:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80086a:	89 ca                	mov    %ecx,%edx
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
  80086f:	e8 02 fc ff ff       	call   800476 <getuint>
  800874:	89 c1                	mov    %eax,%ecx
  800876:	89 d3                	mov    %edx,%ebx
  800878:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80087d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800881:	89 54 24 10          	mov    %edx,0x10(%esp)
  800885:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800888:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80088c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800890:	89 0c 24             	mov    %ecx,(%esp)
  800893:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800897:	89 f2                	mov    %esi,%edx
  800899:	89 f8                	mov    %edi,%eax
  80089b:	e8 e0 fa ff ff       	call   800380 <printnum>
  8008a0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8008a3:	e9 51 fc ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  8008a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8008ab:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008b2:	89 14 24             	mov    %edx,(%esp)
  8008b5:	ff d7                	call   *%edi
  8008b7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8008ba:	e9 3a fc ff ff       	jmp    8004f9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008ca:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8008cf:	80 38 25             	cmpb   $0x25,(%eax)
  8008d2:	0f 84 21 fc ff ff    	je     8004f9 <vprintfmt+0x2c>
  8008d8:	89 c3                	mov    %eax,%ebx
  8008da:	eb f0                	jmp    8008cc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8008dc:	83 c4 5c             	add    $0x5c,%esp
  8008df:	5b                   	pop    %ebx
  8008e0:	5e                   	pop    %esi
  8008e1:	5f                   	pop    %edi
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    

008008e4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	83 ec 28             	sub    $0x28,%esp
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	74 04                	je     8008f8 <vsnprintf+0x14>
  8008f4:	85 d2                	test   %edx,%edx
  8008f6:	7f 07                	jg     8008ff <vsnprintf+0x1b>
  8008f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fd:	eb 3b                	jmp    80093a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800902:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800906:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800909:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800917:	8b 45 10             	mov    0x10(%ebp),%eax
  80091a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800921:	89 44 24 04          	mov    %eax,0x4(%esp)
  800925:	c7 04 24 b0 04 80 00 	movl   $0x8004b0,(%esp)
  80092c:	e8 9c fb ff ff       	call   8004cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800931:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800934:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800937:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800942:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800945:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800949:	8b 45 10             	mov    0x10(%ebp),%eax
  80094c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800950:	8b 45 0c             	mov    0xc(%ebp),%eax
  800953:	89 44 24 04          	mov    %eax,0x4(%esp)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	89 04 24             	mov    %eax,(%esp)
  80095d:	e8 82 ff ff ff       	call   8008e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800962:	c9                   	leave  
  800963:	c3                   	ret    

00800964 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80096a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80096d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800971:	8b 45 10             	mov    0x10(%ebp),%eax
  800974:	89 44 24 08          	mov    %eax,0x8(%esp)
  800978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	89 04 24             	mov    %eax,(%esp)
  800985:	e8 43 fb ff ff       	call   8004cd <vprintfmt>
	va_end(ap);
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    
  80098c:	00 00                	add    %al,(%eax)
	...

00800990 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800996:	b8 00 00 00 00       	mov    $0x0,%eax
  80099b:	80 3a 00             	cmpb   $0x0,(%edx)
  80099e:	74 09                	je     8009a9 <strlen+0x19>
		n++;
  8009a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009a7:	75 f7                	jne    8009a0 <strlen+0x10>
		n++;
	return n;
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	53                   	push   %ebx
  8009af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b5:	85 c9                	test   %ecx,%ecx
  8009b7:	74 19                	je     8009d2 <strnlen+0x27>
  8009b9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009bc:	74 14                	je     8009d2 <strnlen+0x27>
  8009be:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8009c3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c6:	39 c8                	cmp    %ecx,%eax
  8009c8:	74 0d                	je     8009d7 <strnlen+0x2c>
  8009ca:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8009ce:	75 f3                	jne    8009c3 <strnlen+0x18>
  8009d0:	eb 05                	jmp    8009d7 <strnlen+0x2c>
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009e4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f0:	83 c2 01             	add    $0x1,%edx
  8009f3:	84 c9                	test   %cl,%cl
  8009f5:	75 f2                	jne    8009e9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a05:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a08:	85 f6                	test   %esi,%esi
  800a0a:	74 18                	je     800a24 <strncpy+0x2a>
  800a0c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a11:	0f b6 1a             	movzbl (%edx),%ebx
  800a14:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a17:	80 3a 01             	cmpb   $0x1,(%edx)
  800a1a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1d:	83 c1 01             	add    $0x1,%ecx
  800a20:	39 ce                	cmp    %ecx,%esi
  800a22:	77 ed                	ja     800a11 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a24:	5b                   	pop    %ebx
  800a25:	5e                   	pop    %esi
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a33:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a36:	89 f0                	mov    %esi,%eax
  800a38:	85 c9                	test   %ecx,%ecx
  800a3a:	74 27                	je     800a63 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a3c:	83 e9 01             	sub    $0x1,%ecx
  800a3f:	74 1d                	je     800a5e <strlcpy+0x36>
  800a41:	0f b6 1a             	movzbl (%edx),%ebx
  800a44:	84 db                	test   %bl,%bl
  800a46:	74 16                	je     800a5e <strlcpy+0x36>
			*dst++ = *src++;
  800a48:	88 18                	mov    %bl,(%eax)
  800a4a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a4d:	83 e9 01             	sub    $0x1,%ecx
  800a50:	74 0e                	je     800a60 <strlcpy+0x38>
			*dst++ = *src++;
  800a52:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a55:	0f b6 1a             	movzbl (%edx),%ebx
  800a58:	84 db                	test   %bl,%bl
  800a5a:	75 ec                	jne    800a48 <strlcpy+0x20>
  800a5c:	eb 02                	jmp    800a60 <strlcpy+0x38>
  800a5e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a60:	c6 00 00             	movb   $0x0,(%eax)
  800a63:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a72:	0f b6 01             	movzbl (%ecx),%eax
  800a75:	84 c0                	test   %al,%al
  800a77:	74 15                	je     800a8e <strcmp+0x25>
  800a79:	3a 02                	cmp    (%edx),%al
  800a7b:	75 11                	jne    800a8e <strcmp+0x25>
		p++, q++;
  800a7d:	83 c1 01             	add    $0x1,%ecx
  800a80:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a83:	0f b6 01             	movzbl (%ecx),%eax
  800a86:	84 c0                	test   %al,%al
  800a88:	74 04                	je     800a8e <strcmp+0x25>
  800a8a:	3a 02                	cmp    (%edx),%al
  800a8c:	74 ef                	je     800a7d <strcmp+0x14>
  800a8e:	0f b6 c0             	movzbl %al,%eax
  800a91:	0f b6 12             	movzbl (%edx),%edx
  800a94:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	53                   	push   %ebx
  800a9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800aa5:	85 c0                	test   %eax,%eax
  800aa7:	74 23                	je     800acc <strncmp+0x34>
  800aa9:	0f b6 1a             	movzbl (%edx),%ebx
  800aac:	84 db                	test   %bl,%bl
  800aae:	74 24                	je     800ad4 <strncmp+0x3c>
  800ab0:	3a 19                	cmp    (%ecx),%bl
  800ab2:	75 20                	jne    800ad4 <strncmp+0x3c>
  800ab4:	83 e8 01             	sub    $0x1,%eax
  800ab7:	74 13                	je     800acc <strncmp+0x34>
		n--, p++, q++;
  800ab9:	83 c2 01             	add    $0x1,%edx
  800abc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800abf:	0f b6 1a             	movzbl (%edx),%ebx
  800ac2:	84 db                	test   %bl,%bl
  800ac4:	74 0e                	je     800ad4 <strncmp+0x3c>
  800ac6:	3a 19                	cmp    (%ecx),%bl
  800ac8:	74 ea                	je     800ab4 <strncmp+0x1c>
  800aca:	eb 08                	jmp    800ad4 <strncmp+0x3c>
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad4:	0f b6 02             	movzbl (%edx),%eax
  800ad7:	0f b6 11             	movzbl (%ecx),%edx
  800ada:	29 d0                	sub    %edx,%eax
  800adc:	eb f3                	jmp    800ad1 <strncmp+0x39>

00800ade <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae8:	0f b6 10             	movzbl (%eax),%edx
  800aeb:	84 d2                	test   %dl,%dl
  800aed:	74 15                	je     800b04 <strchr+0x26>
		if (*s == c)
  800aef:	38 ca                	cmp    %cl,%dl
  800af1:	75 07                	jne    800afa <strchr+0x1c>
  800af3:	eb 14                	jmp    800b09 <strchr+0x2b>
  800af5:	38 ca                	cmp    %cl,%dl
  800af7:	90                   	nop
  800af8:	74 0f                	je     800b09 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	0f b6 10             	movzbl (%eax),%edx
  800b00:	84 d2                	test   %dl,%dl
  800b02:	75 f1                	jne    800af5 <strchr+0x17>
  800b04:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b15:	0f b6 10             	movzbl (%eax),%edx
  800b18:	84 d2                	test   %dl,%dl
  800b1a:	74 18                	je     800b34 <strfind+0x29>
		if (*s == c)
  800b1c:	38 ca                	cmp    %cl,%dl
  800b1e:	75 0a                	jne    800b2a <strfind+0x1f>
  800b20:	eb 12                	jmp    800b34 <strfind+0x29>
  800b22:	38 ca                	cmp    %cl,%dl
  800b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b28:	74 0a                	je     800b34 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b2a:	83 c0 01             	add    $0x1,%eax
  800b2d:	0f b6 10             	movzbl (%eax),%edx
  800b30:	84 d2                	test   %dl,%dl
  800b32:	75 ee                	jne    800b22 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 0c             	sub    $0xc,%esp
  800b3c:	89 1c 24             	mov    %ebx,(%esp)
  800b3f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b47:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b50:	85 c9                	test   %ecx,%ecx
  800b52:	74 30                	je     800b84 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b54:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b5a:	75 25                	jne    800b81 <memset+0x4b>
  800b5c:	f6 c1 03             	test   $0x3,%cl
  800b5f:	75 20                	jne    800b81 <memset+0x4b>
		c &= 0xFF;
  800b61:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b64:	89 d3                	mov    %edx,%ebx
  800b66:	c1 e3 08             	shl    $0x8,%ebx
  800b69:	89 d6                	mov    %edx,%esi
  800b6b:	c1 e6 18             	shl    $0x18,%esi
  800b6e:	89 d0                	mov    %edx,%eax
  800b70:	c1 e0 10             	shl    $0x10,%eax
  800b73:	09 f0                	or     %esi,%eax
  800b75:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b77:	09 d8                	or     %ebx,%eax
  800b79:	c1 e9 02             	shr    $0x2,%ecx
  800b7c:	fc                   	cld    
  800b7d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b7f:	eb 03                	jmp    800b84 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b81:	fc                   	cld    
  800b82:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b84:	89 f8                	mov    %edi,%eax
  800b86:	8b 1c 24             	mov    (%esp),%ebx
  800b89:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b8d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b91:	89 ec                	mov    %ebp,%esp
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	89 34 24             	mov    %esi,(%esp)
  800b9e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800bab:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800bad:	39 c6                	cmp    %eax,%esi
  800baf:	73 35                	jae    800be6 <memmove+0x51>
  800bb1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb4:	39 d0                	cmp    %edx,%eax
  800bb6:	73 2e                	jae    800be6 <memmove+0x51>
		s += n;
		d += n;
  800bb8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bba:	f6 c2 03             	test   $0x3,%dl
  800bbd:	75 1b                	jne    800bda <memmove+0x45>
  800bbf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bc5:	75 13                	jne    800bda <memmove+0x45>
  800bc7:	f6 c1 03             	test   $0x3,%cl
  800bca:	75 0e                	jne    800bda <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800bcc:	83 ef 04             	sub    $0x4,%edi
  800bcf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd2:	c1 e9 02             	shr    $0x2,%ecx
  800bd5:	fd                   	std    
  800bd6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd8:	eb 09                	jmp    800be3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bda:	83 ef 01             	sub    $0x1,%edi
  800bdd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800be0:	fd                   	std    
  800be1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be4:	eb 20                	jmp    800c06 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bec:	75 15                	jne    800c03 <memmove+0x6e>
  800bee:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bf4:	75 0d                	jne    800c03 <memmove+0x6e>
  800bf6:	f6 c1 03             	test   $0x3,%cl
  800bf9:	75 08                	jne    800c03 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800bfb:	c1 e9 02             	shr    $0x2,%ecx
  800bfe:	fc                   	cld    
  800bff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c01:	eb 03                	jmp    800c06 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c03:	fc                   	cld    
  800c04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c06:	8b 34 24             	mov    (%esp),%esi
  800c09:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c0d:	89 ec                	mov    %ebp,%esp
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    

00800c11 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	89 04 24             	mov    %eax,(%esp)
  800c2b:	e8 65 ff ff ff       	call   800b95 <memmove>
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	8b 75 08             	mov    0x8(%ebp),%esi
  800c3b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c41:	85 c9                	test   %ecx,%ecx
  800c43:	74 36                	je     800c7b <memcmp+0x49>
		if (*s1 != *s2)
  800c45:	0f b6 06             	movzbl (%esi),%eax
  800c48:	0f b6 1f             	movzbl (%edi),%ebx
  800c4b:	38 d8                	cmp    %bl,%al
  800c4d:	74 20                	je     800c6f <memcmp+0x3d>
  800c4f:	eb 14                	jmp    800c65 <memcmp+0x33>
  800c51:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c56:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c5b:	83 c2 01             	add    $0x1,%edx
  800c5e:	83 e9 01             	sub    $0x1,%ecx
  800c61:	38 d8                	cmp    %bl,%al
  800c63:	74 12                	je     800c77 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	0f b6 db             	movzbl %bl,%ebx
  800c6b:	29 d8                	sub    %ebx,%eax
  800c6d:	eb 11                	jmp    800c80 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c6f:	83 e9 01             	sub    $0x1,%ecx
  800c72:	ba 00 00 00 00       	mov    $0x0,%edx
  800c77:	85 c9                	test   %ecx,%ecx
  800c79:	75 d6                	jne    800c51 <memcmp+0x1f>
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c90:	39 d0                	cmp    %edx,%eax
  800c92:	73 15                	jae    800ca9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c98:	38 08                	cmp    %cl,(%eax)
  800c9a:	75 06                	jne    800ca2 <memfind+0x1d>
  800c9c:	eb 0b                	jmp    800ca9 <memfind+0x24>
  800c9e:	38 08                	cmp    %cl,(%eax)
  800ca0:	74 07                	je     800ca9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca2:	83 c0 01             	add    $0x1,%eax
  800ca5:	39 c2                	cmp    %eax,%edx
  800ca7:	77 f5                	ja     800c9e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 04             	sub    $0x4,%esp
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cba:	0f b6 02             	movzbl (%edx),%eax
  800cbd:	3c 20                	cmp    $0x20,%al
  800cbf:	74 04                	je     800cc5 <strtol+0x1a>
  800cc1:	3c 09                	cmp    $0x9,%al
  800cc3:	75 0e                	jne    800cd3 <strtol+0x28>
		s++;
  800cc5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc8:	0f b6 02             	movzbl (%edx),%eax
  800ccb:	3c 20                	cmp    $0x20,%al
  800ccd:	74 f6                	je     800cc5 <strtol+0x1a>
  800ccf:	3c 09                	cmp    $0x9,%al
  800cd1:	74 f2                	je     800cc5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cd3:	3c 2b                	cmp    $0x2b,%al
  800cd5:	75 0c                	jne    800ce3 <strtol+0x38>
		s++;
  800cd7:	83 c2 01             	add    $0x1,%edx
  800cda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ce1:	eb 15                	jmp    800cf8 <strtol+0x4d>
	else if (*s == '-')
  800ce3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cea:	3c 2d                	cmp    $0x2d,%al
  800cec:	75 0a                	jne    800cf8 <strtol+0x4d>
		s++, neg = 1;
  800cee:	83 c2 01             	add    $0x1,%edx
  800cf1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	0f 94 c0             	sete   %al
  800cfd:	74 05                	je     800d04 <strtol+0x59>
  800cff:	83 fb 10             	cmp    $0x10,%ebx
  800d02:	75 18                	jne    800d1c <strtol+0x71>
  800d04:	80 3a 30             	cmpb   $0x30,(%edx)
  800d07:	75 13                	jne    800d1c <strtol+0x71>
  800d09:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d0d:	8d 76 00             	lea    0x0(%esi),%esi
  800d10:	75 0a                	jne    800d1c <strtol+0x71>
		s += 2, base = 16;
  800d12:	83 c2 02             	add    $0x2,%edx
  800d15:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1a:	eb 15                	jmp    800d31 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d1c:	84 c0                	test   %al,%al
  800d1e:	66 90                	xchg   %ax,%ax
  800d20:	74 0f                	je     800d31 <strtol+0x86>
  800d22:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d27:	80 3a 30             	cmpb   $0x30,(%edx)
  800d2a:	75 05                	jne    800d31 <strtol+0x86>
		s++, base = 8;
  800d2c:	83 c2 01             	add    $0x1,%edx
  800d2f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d31:	b8 00 00 00 00       	mov    $0x0,%eax
  800d36:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d38:	0f b6 0a             	movzbl (%edx),%ecx
  800d3b:	89 cf                	mov    %ecx,%edi
  800d3d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d40:	80 fb 09             	cmp    $0x9,%bl
  800d43:	77 08                	ja     800d4d <strtol+0xa2>
			dig = *s - '0';
  800d45:	0f be c9             	movsbl %cl,%ecx
  800d48:	83 e9 30             	sub    $0x30,%ecx
  800d4b:	eb 1e                	jmp    800d6b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d4d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d50:	80 fb 19             	cmp    $0x19,%bl
  800d53:	77 08                	ja     800d5d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d55:	0f be c9             	movsbl %cl,%ecx
  800d58:	83 e9 57             	sub    $0x57,%ecx
  800d5b:	eb 0e                	jmp    800d6b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d5d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d60:	80 fb 19             	cmp    $0x19,%bl
  800d63:	77 15                	ja     800d7a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d65:	0f be c9             	movsbl %cl,%ecx
  800d68:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d6b:	39 f1                	cmp    %esi,%ecx
  800d6d:	7d 0b                	jge    800d7a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d6f:	83 c2 01             	add    $0x1,%edx
  800d72:	0f af c6             	imul   %esi,%eax
  800d75:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d78:	eb be                	jmp    800d38 <strtol+0x8d>
  800d7a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d80:	74 05                	je     800d87 <strtol+0xdc>
		*endptr = (char *) s;
  800d82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d85:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d8b:	74 04                	je     800d91 <strtol+0xe6>
  800d8d:	89 c8                	mov    %ecx,%eax
  800d8f:	f7 d8                	neg    %eax
}
  800d91:	83 c4 04             	add    $0x4,%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
  800d99:	00 00                	add    %al,(%eax)
	...

00800d9c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	89 1c 24             	mov    %ebx,(%esp)
  800da5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800da9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dad:	ba 00 00 00 00       	mov    $0x0,%edx
  800db2:	b8 01 00 00 00       	mov    $0x1,%eax
  800db7:	89 d1                	mov    %edx,%ecx
  800db9:	89 d3                	mov    %edx,%ebx
  800dbb:	89 d7                	mov    %edx,%edi
  800dbd:	89 d6                	mov    %edx,%esi
  800dbf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dc1:	8b 1c 24             	mov    (%esp),%ebx
  800dc4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dc8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dcc:	89 ec                	mov    %ebp,%esp
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	89 1c 24             	mov    %ebx,(%esp)
  800dd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ddd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de1:	b8 00 00 00 00       	mov    $0x0,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	89 c3                	mov    %eax,%ebx
  800dee:	89 c7                	mov    %eax,%edi
  800df0:	89 c6                	mov    %eax,%esi
  800df2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df4:	8b 1c 24             	mov    (%esp),%ebx
  800df7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dfb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dff:	89 ec                	mov    %ebp,%esp
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 38             	sub    $0x38,%esp
  800e09:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e12:	be 00 00 00 00       	mov    $0x0,%esi
  800e17:	b8 12 00 00 00       	mov    $0x12,%eax
  800e1c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e25:	8b 55 08             	mov    0x8(%ebp),%edx
  800e28:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	7e 28                	jle    800e56 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e32:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800e39:	00 
  800e3a:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800e41:	00 
  800e42:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e49:	00 
  800e4a:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800e51:	e8 02 f4 ff ff       	call   800258 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800e56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e59:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e5c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e5f:	89 ec                	mov    %ebp,%esp
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 0c             	sub    $0xc,%esp
  800e69:	89 1c 24             	mov    %ebx,(%esp)
  800e6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e70:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e79:	b8 11 00 00 00       	mov    $0x11,%eax
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	89 df                	mov    %ebx,%edi
  800e86:	89 de                	mov    %ebx,%esi
  800e88:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800e8a:	8b 1c 24             	mov    (%esp),%ebx
  800e8d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e91:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e95:	89 ec                	mov    %ebp,%esp
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 0c             	sub    $0xc,%esp
  800e9f:	89 1c 24             	mov    %ebx,(%esp)
  800ea2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ea6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eaa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaf:	b8 10 00 00 00       	mov    $0x10,%eax
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	89 cb                	mov    %ecx,%ebx
  800eb9:	89 cf                	mov    %ecx,%edi
  800ebb:	89 ce                	mov    %ecx,%esi
  800ebd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800ebf:	8b 1c 24             	mov    (%esp),%ebx
  800ec2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ec6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eca:	89 ec                	mov    %ebp,%esp
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	83 ec 38             	sub    $0x38,%esp
  800ed4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eda:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	89 df                	mov    %ebx,%edi
  800eef:	89 de                	mov    %ebx,%esi
  800ef1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7e 28                	jle    800f1f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f02:	00 
  800f03:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800f0a:	00 
  800f0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f12:	00 
  800f13:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800f1a:	e8 39 f3 ff ff       	call   800258 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800f1f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f22:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f25:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f28:	89 ec                	mov    %ebp,%esp
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 0c             	sub    $0xc,%esp
  800f32:	89 1c 24             	mov    %ebx,(%esp)
  800f35:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f39:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f42:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f47:	89 d1                	mov    %edx,%ecx
  800f49:	89 d3                	mov    %edx,%ebx
  800f4b:	89 d7                	mov    %edx,%edi
  800f4d:	89 d6                	mov    %edx,%esi
  800f4f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800f51:	8b 1c 24             	mov    (%esp),%ebx
  800f54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f5c:	89 ec                	mov    %ebp,%esp
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 38             	sub    $0x38,%esp
  800f66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f74:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	89 cb                	mov    %ecx,%ebx
  800f7e:	89 cf                	mov    %ecx,%edi
  800f80:	89 ce                	mov    %ecx,%esi
  800f82:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f84:	85 c0                	test   %eax,%eax
  800f86:	7e 28                	jle    800fb0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f88:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f93:	00 
  800f94:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800f9b:	00 
  800f9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa3:	00 
  800fa4:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800fab:	e8 a8 f2 ff ff       	call   800258 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb9:	89 ec                	mov    %ebp,%esp
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	89 1c 24             	mov    %ebx,(%esp)
  800fc6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fca:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fce:	be 00 00 00 00       	mov    $0x0,%esi
  800fd3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fd8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fe6:	8b 1c 24             	mov    (%esp),%ebx
  800fe9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ff1:	89 ec                	mov    %ebp,%esp
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 38             	sub    $0x38,%esp
  800ffb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ffe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801001:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801004:	bb 00 00 00 00       	mov    $0x0,%ebx
  801009:	b8 0a 00 00 00       	mov    $0xa,%eax
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	89 df                	mov    %ebx,%edi
  801016:	89 de                	mov    %ebx,%esi
  801018:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80101a:	85 c0                	test   %eax,%eax
  80101c:	7e 28                	jle    801046 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801022:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801029:	00 
  80102a:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  801031:	00 
  801032:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801039:	00 
  80103a:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  801041:	e8 12 f2 ff ff       	call   800258 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801046:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801049:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80104c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80104f:	89 ec                	mov    %ebp,%esp
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 38             	sub    $0x38,%esp
  801059:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80105c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80105f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801062:	bb 00 00 00 00       	mov    $0x0,%ebx
  801067:	b8 09 00 00 00       	mov    $0x9,%eax
  80106c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	89 df                	mov    %ebx,%edi
  801074:	89 de                	mov    %ebx,%esi
  801076:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801078:	85 c0                	test   %eax,%eax
  80107a:	7e 28                	jle    8010a4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801080:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801087:	00 
  801088:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  80108f:	00 
  801090:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801097:	00 
  801098:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  80109f:	e8 b4 f1 ff ff       	call   800258 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010a4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010aa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ad:	89 ec                	mov    %ebp,%esp
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    

008010b1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	83 ec 38             	sub    $0x38,%esp
  8010b7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010bd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8010ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d0:	89 df                	mov    %ebx,%edi
  8010d2:	89 de                	mov    %ebx,%esi
  8010d4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	7e 28                	jle    801102 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010da:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010de:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010e5:	00 
  8010e6:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  8010ed:	00 
  8010ee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f5:	00 
  8010f6:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  8010fd:	e8 56 f1 ff ff       	call   800258 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801102:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801105:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801108:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110b:	89 ec                	mov    %ebp,%esp
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    

0080110f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 38             	sub    $0x38,%esp
  801115:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801118:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80111b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801123:	b8 06 00 00 00       	mov    $0x6,%eax
  801128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	89 df                	mov    %ebx,%edi
  801130:	89 de                	mov    %ebx,%esi
  801132:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801134:	85 c0                	test   %eax,%eax
  801136:	7e 28                	jle    801160 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801138:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801143:	00 
  801144:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  80115b:	e8 f8 f0 ff ff       	call   800258 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801160:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801163:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801166:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801169:	89 ec                	mov    %ebp,%esp
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 38             	sub    $0x38,%esp
  801173:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801176:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801179:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117c:	b8 05 00 00 00       	mov    $0x5,%eax
  801181:	8b 75 18             	mov    0x18(%ebp),%esi
  801184:	8b 7d 14             	mov    0x14(%ebp),%edi
  801187:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80118a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118d:	8b 55 08             	mov    0x8(%ebp),%edx
  801190:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801192:	85 c0                	test   %eax,%eax
  801194:	7e 28                	jle    8011be <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801196:	89 44 24 10          	mov    %eax,0x10(%esp)
  80119a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011a1:	00 
  8011a2:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  8011a9:	00 
  8011aa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b1:	00 
  8011b2:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  8011b9:	e8 9a f0 ff ff       	call   800258 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011be:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011c1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011c7:	89 ec                	mov    %ebp,%esp
  8011c9:	5d                   	pop    %ebp
  8011ca:	c3                   	ret    

008011cb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 38             	sub    $0x38,%esp
  8011d1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011d4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011d7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011da:	be 00 00 00 00       	mov    $0x0,%esi
  8011df:	b8 04 00 00 00       	mov    $0x4,%eax
  8011e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ed:	89 f7                	mov    %esi,%edi
  8011ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	7e 28                	jle    80121d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801200:	00 
  801201:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  801208:	00 
  801209:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801210:	00 
  801211:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  801218:	e8 3b f0 ff ff       	call   800258 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80121d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801220:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801223:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801226:	89 ec                	mov    %ebp,%esp
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    

0080122a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	89 1c 24             	mov    %ebx,(%esp)
  801233:	89 74 24 04          	mov    %esi,0x4(%esp)
  801237:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123b:	ba 00 00 00 00       	mov    $0x0,%edx
  801240:	b8 0b 00 00 00       	mov    $0xb,%eax
  801245:	89 d1                	mov    %edx,%ecx
  801247:	89 d3                	mov    %edx,%ebx
  801249:	89 d7                	mov    %edx,%edi
  80124b:	89 d6                	mov    %edx,%esi
  80124d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80124f:	8b 1c 24             	mov    (%esp),%ebx
  801252:	8b 74 24 04          	mov    0x4(%esp),%esi
  801256:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80125a:	89 ec                	mov    %ebp,%esp
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	83 ec 0c             	sub    $0xc,%esp
  801264:	89 1c 24             	mov    %ebx,(%esp)
  801267:	89 74 24 04          	mov    %esi,0x4(%esp)
  80126b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126f:	ba 00 00 00 00       	mov    $0x0,%edx
  801274:	b8 02 00 00 00       	mov    $0x2,%eax
  801279:	89 d1                	mov    %edx,%ecx
  80127b:	89 d3                	mov    %edx,%ebx
  80127d:	89 d7                	mov    %edx,%edi
  80127f:	89 d6                	mov    %edx,%esi
  801281:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801283:	8b 1c 24             	mov    (%esp),%ebx
  801286:	8b 74 24 04          	mov    0x4(%esp),%esi
  80128a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80128e:	89 ec                	mov    %ebp,%esp
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 38             	sub    $0x38,%esp
  801298:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80129b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80129e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8012ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ae:	89 cb                	mov    %ecx,%ebx
  8012b0:	89 cf                	mov    %ecx,%edi
  8012b2:	89 ce                	mov    %ecx,%esi
  8012b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	7e 28                	jle    8012e2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012be:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8012c5:	00 
  8012c6:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  8012cd:	00 
  8012ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012d5:	00 
  8012d6:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  8012dd:	e8 76 ef ff ff       	call   800258 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012eb:	89 ec                	mov    %ebp,%esp
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    
	...

008012f0 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8012f6:	c7 44 24 08 4a 32 80 	movl   $0x80324a,0x8(%esp)
  8012fd:	00 
  8012fe:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801305:	00 
  801306:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  80130d:	e8 46 ef ff ff       	call   800258 <_panic>

00801312 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	53                   	push   %ebx
  801316:	83 ec 24             	sub    $0x24,%esp
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80131c:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80131e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801322:	75 1c                	jne    801340 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801324:	c7 44 24 08 6c 32 80 	movl   $0x80326c,0x8(%esp)
  80132b:	00 
  80132c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801333:	00 
  801334:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  80133b:	e8 18 ef ff ff       	call   800258 <_panic>
	}
	pte = vpt[VPN(addr)];
  801340:	89 d8                	mov    %ebx,%eax
  801342:	c1 e8 0c             	shr    $0xc,%eax
  801345:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  80134c:	f6 c4 08             	test   $0x8,%ah
  80134f:	75 1c                	jne    80136d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801351:	c7 44 24 08 b0 32 80 	movl   $0x8032b0,0x8(%esp)
  801358:	00 
  801359:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801360:	00 
  801361:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  801368:	e8 eb ee ff ff       	call   800258 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80136d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801374:	00 
  801375:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80137c:	00 
  80137d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801384:	e8 42 fe ff ff       	call   8011cb <sys_page_alloc>
  801389:	85 c0                	test   %eax,%eax
  80138b:	79 20                	jns    8013ad <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  80138d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801391:	c7 44 24 08 fc 32 80 	movl   $0x8032fc,0x8(%esp)
  801398:	00 
  801399:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8013a0:	00 
  8013a1:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  8013a8:	e8 ab ee ff ff       	call   800258 <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  8013ad:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8013b3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013ba:	00 
  8013bb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013bf:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8013c6:	e8 ca f7 ff ff       	call   800b95 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  8013cb:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8013d2:	00 
  8013d3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013de:	00 
  8013df:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013e6:	00 
  8013e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ee:	e8 7a fd ff ff       	call   80116d <sys_page_map>
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	79 20                	jns    801417 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  8013f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013fb:	c7 44 24 08 38 33 80 	movl   $0x803338,0x8(%esp)
  801402:	00 
  801403:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80140a:	00 
  80140b:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  801412:	e8 41 ee ff ff       	call   800258 <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801417:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80141e:	00 
  80141f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801426:	e8 e4 fc ff ff       	call   80110f <sys_page_unmap>
  80142b:	85 c0                	test   %eax,%eax
  80142d:	79 20                	jns    80144f <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80142f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801433:	c7 44 24 08 70 33 80 	movl   $0x803370,0x8(%esp)
  80143a:	00 
  80143b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801442:	00 
  801443:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  80144a:	e8 09 ee ff ff       	call   800258 <_panic>
	// panic("pgfault not implemented");
}
  80144f:	83 c4 24             	add    $0x24,%esp
  801452:	5b                   	pop    %ebx
  801453:	5d                   	pop    %ebp
  801454:	c3                   	ret    

00801455 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	57                   	push   %edi
  801459:	56                   	push   %esi
  80145a:	53                   	push   %ebx
  80145b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80145e:	c7 04 24 12 13 80 00 	movl   $0x801312,(%esp)
  801465:	e8 42 15 00 00       	call   8029ac <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80146a:	ba 07 00 00 00       	mov    $0x7,%edx
  80146f:	89 d0                	mov    %edx,%eax
  801471:	cd 30                	int    $0x30
  801473:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  801476:	85 c0                	test   %eax,%eax
  801478:	0f 88 21 02 00 00    	js     80169f <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  80147e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  801485:	85 c0                	test   %eax,%eax
  801487:	75 1c                	jne    8014a5 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  801489:	e8 d0 fd ff ff       	call   80125e <sys_getenvid>
  80148e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801493:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801496:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80149b:	a3 74 70 80 00       	mov    %eax,0x807074
		return 0;
  8014a0:	e9 fa 01 00 00       	jmp    80169f <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  8014a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014a8:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8014af:	a8 01                	test   $0x1,%al
  8014b1:	0f 84 16 01 00 00    	je     8015cd <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  8014b7:	89 d3                	mov    %edx,%ebx
  8014b9:	c1 e3 0a             	shl    $0xa,%ebx
  8014bc:	89 d7                	mov    %edx,%edi
  8014be:	c1 e7 16             	shl    $0x16,%edi
  8014c1:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  8014c6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8014cd:	a8 01                	test   $0x1,%al
  8014cf:	0f 84 e0 00 00 00    	je     8015b5 <fork+0x160>
  8014d5:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8014db:	0f 87 d4 00 00 00    	ja     8015b5 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  8014e1:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  8014e8:	89 d0                	mov    %edx,%eax
  8014ea:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  8014ef:	f6 c2 01             	test   $0x1,%dl
  8014f2:	75 1c                	jne    801510 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  8014f4:	c7 44 24 08 ac 33 80 	movl   $0x8033ac,0x8(%esp)
  8014fb:	00 
  8014fc:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801503:	00 
  801504:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  80150b:	e8 48 ed ff ff       	call   800258 <_panic>
	if ((perm & PTE_U) != PTE_U)
  801510:	a8 04                	test   $0x4,%al
  801512:	75 1c                	jne    801530 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801514:	c7 44 24 08 f4 33 80 	movl   $0x8033f4,0x8(%esp)
  80151b:	00 
  80151c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801523:	00 
  801524:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  80152b:	e8 28 ed ff ff       	call   800258 <_panic>
  801530:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801533:	f6 c4 04             	test   $0x4,%ah
  801536:	75 5b                	jne    801593 <fork+0x13e>
  801538:	a9 02 08 00 00       	test   $0x802,%eax
  80153d:	74 54                	je     801593 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80153f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801542:	80 cc 08             	or     $0x8,%ah
  801545:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801548:	89 44 24 10          	mov    %eax,0x10(%esp)
  80154c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801550:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801553:	89 54 24 08          	mov    %edx,0x8(%esp)
  801557:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80155b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801562:	e8 06 fc ff ff       	call   80116d <sys_page_map>
  801567:	85 c0                	test   %eax,%eax
  801569:	78 4a                	js     8015b5 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80156b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80156e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801572:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801575:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801579:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801580:	00 
  801581:	89 54 24 04          	mov    %edx,0x4(%esp)
  801585:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80158c:	e8 dc fb ff ff       	call   80116d <sys_page_map>
  801591:	eb 22                	jmp    8015b5 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801593:	89 44 24 10          	mov    %eax,0x10(%esp)
  801597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80159e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015a1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b0:	e8 b8 fb ff ff       	call   80116d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  8015b5:	83 c6 01             	add    $0x1,%esi
  8015b8:	83 c3 01             	add    $0x1,%ebx
  8015bb:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8015c1:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  8015c7:	0f 85 f9 fe ff ff    	jne    8014c6 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  8015cd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  8015d1:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  8015d8:	0f 85 c7 fe ff ff    	jne    8014a5 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8015de:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015e5:	00 
  8015e6:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015ed:	ee 
  8015ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f1:	89 04 24             	mov    %eax,(%esp)
  8015f4:	e8 d2 fb ff ff       	call   8011cb <sys_page_alloc>
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	79 08                	jns    801605 <fork+0x1b0>
  8015fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801600:	e9 9a 00 00 00       	jmp    80169f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801605:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80160c:	00 
  80160d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801614:	00 
  801615:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80161c:	00 
  80161d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801624:	ee 
  801625:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801628:	89 14 24             	mov    %edx,(%esp)
  80162b:	e8 3d fb ff ff       	call   80116d <sys_page_map>
  801630:	85 c0                	test   %eax,%eax
  801632:	79 05                	jns    801639 <fork+0x1e4>
  801634:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801637:	eb 66                	jmp    80169f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801639:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801640:	00 
  801641:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801648:	ee 
  801649:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801650:	e8 40 f5 ff ff       	call   800b95 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801655:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80165c:	00 
  80165d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801664:	e8 a6 fa ff ff       	call   80110f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801669:	c7 44 24 04 40 2a 80 	movl   $0x802a40,0x4(%esp)
  801670:	00 
  801671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801674:	89 04 24             	mov    %eax,(%esp)
  801677:	e8 79 f9 ff ff       	call   800ff5 <sys_env_set_pgfault_upcall>
  80167c:	85 c0                	test   %eax,%eax
  80167e:	79 05                	jns    801685 <fork+0x230>
  801680:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801683:	eb 1a                	jmp    80169f <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801685:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80168c:	00 
  80168d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801690:	89 14 24             	mov    %edx,(%esp)
  801693:	e8 19 fa ff ff       	call   8010b1 <sys_env_set_status>
  801698:	85 c0                	test   %eax,%eax
  80169a:	79 03                	jns    80169f <fork+0x24a>
  80169c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  80169f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a2:	83 c4 3c             	add    $0x3c,%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5f                   	pop    %edi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    
  8016aa:	00 00                	add    %al,(%eax)
  8016ac:	00 00                	add    %al,(%eax)
	...

008016b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8016bb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    

008016c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	89 04 24             	mov    %eax,(%esp)
  8016cc:	e8 df ff ff ff       	call   8016b0 <fd2num>
  8016d1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8016d6:	c1 e0 0c             	shl    $0xc,%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	57                   	push   %edi
  8016df:	56                   	push   %esi
  8016e0:	53                   	push   %ebx
  8016e1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8016e4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8016e9:	a8 01                	test   $0x1,%al
  8016eb:	74 36                	je     801723 <fd_alloc+0x48>
  8016ed:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8016f2:	a8 01                	test   $0x1,%al
  8016f4:	74 2d                	je     801723 <fd_alloc+0x48>
  8016f6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8016fb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801700:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801705:	89 c3                	mov    %eax,%ebx
  801707:	89 c2                	mov    %eax,%edx
  801709:	c1 ea 16             	shr    $0x16,%edx
  80170c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80170f:	f6 c2 01             	test   $0x1,%dl
  801712:	74 14                	je     801728 <fd_alloc+0x4d>
  801714:	89 c2                	mov    %eax,%edx
  801716:	c1 ea 0c             	shr    $0xc,%edx
  801719:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80171c:	f6 c2 01             	test   $0x1,%dl
  80171f:	75 10                	jne    801731 <fd_alloc+0x56>
  801721:	eb 05                	jmp    801728 <fd_alloc+0x4d>
  801723:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801728:	89 1f                	mov    %ebx,(%edi)
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80172f:	eb 17                	jmp    801748 <fd_alloc+0x6d>
  801731:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801736:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80173b:	75 c8                	jne    801705 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80173d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801743:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5f                   	pop    %edi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	83 f8 1f             	cmp    $0x1f,%eax
  801756:	77 36                	ja     80178e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801758:	05 00 00 0d 00       	add    $0xd0000,%eax
  80175d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801760:	89 c2                	mov    %eax,%edx
  801762:	c1 ea 16             	shr    $0x16,%edx
  801765:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80176c:	f6 c2 01             	test   $0x1,%dl
  80176f:	74 1d                	je     80178e <fd_lookup+0x41>
  801771:	89 c2                	mov    %eax,%edx
  801773:	c1 ea 0c             	shr    $0xc,%edx
  801776:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80177d:	f6 c2 01             	test   $0x1,%dl
  801780:	74 0c                	je     80178e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	89 02                	mov    %eax,(%edx)
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80178c:	eb 05                	jmp    801793 <fd_lookup+0x46>
  80178e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801793:	5d                   	pop    %ebp
  801794:	c3                   	ret    

00801795 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80179b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80179e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	89 04 24             	mov    %eax,(%esp)
  8017a8:	e8 a0 ff ff ff       	call   80174d <fd_lookup>
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	78 0e                	js     8017bf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	89 50 04             	mov    %edx,0x4(%eax)
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	56                   	push   %esi
  8017c5:	53                   	push   %ebx
  8017c6:	83 ec 10             	sub    $0x10,%esp
  8017c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8017cf:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017d9:	be b8 34 80 00       	mov    $0x8034b8,%esi
		if (devtab[i]->dev_id == dev_id) {
  8017de:	39 08                	cmp    %ecx,(%eax)
  8017e0:	75 10                	jne    8017f2 <dev_lookup+0x31>
  8017e2:	eb 04                	jmp    8017e8 <dev_lookup+0x27>
  8017e4:	39 08                	cmp    %ecx,(%eax)
  8017e6:	75 0a                	jne    8017f2 <dev_lookup+0x31>
			*dev = devtab[i];
  8017e8:	89 03                	mov    %eax,(%ebx)
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8017ef:	90                   	nop
  8017f0:	eb 31                	jmp    801823 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017f2:	83 c2 01             	add    $0x1,%edx
  8017f5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	75 e8                	jne    8017e4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8017fc:	a1 74 70 80 00       	mov    0x807074,%eax
  801801:	8b 40 4c             	mov    0x4c(%eax),%eax
  801804:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180c:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  801813:	e8 05 eb ff ff       	call   80031d <cprintf>
	*dev = 0;
  801818:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80181e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	5b                   	pop    %ebx
  801827:	5e                   	pop    %esi
  801828:	5d                   	pop    %ebp
  801829:	c3                   	ret    

0080182a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	53                   	push   %ebx
  80182e:	83 ec 24             	sub    $0x24,%esp
  801831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801834:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801837:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	89 04 24             	mov    %eax,(%esp)
  801841:	e8 07 ff ff ff       	call   80174d <fd_lookup>
  801846:	85 c0                	test   %eax,%eax
  801848:	78 53                	js     80189d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80184a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801854:	8b 00                	mov    (%eax),%eax
  801856:	89 04 24             	mov    %eax,(%esp)
  801859:	e8 63 ff ff ff       	call   8017c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 3b                	js     80189d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801862:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80186e:	74 2d                	je     80189d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801870:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801873:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80187a:	00 00 00 
	stat->st_isdir = 0;
  80187d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801884:	00 00 00 
	stat->st_dev = dev;
  801887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801890:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801894:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801897:	89 14 24             	mov    %edx,(%esp)
  80189a:	ff 50 14             	call   *0x14(%eax)
}
  80189d:	83 c4 24             	add    $0x24,%esp
  8018a0:	5b                   	pop    %ebx
  8018a1:	5d                   	pop    %ebp
  8018a2:	c3                   	ret    

008018a3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	53                   	push   %ebx
  8018a7:	83 ec 24             	sub    $0x24,%esp
  8018aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b4:	89 1c 24             	mov    %ebx,(%esp)
  8018b7:	e8 91 fe ff ff       	call   80174d <fd_lookup>
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 5f                	js     80191f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ca:	8b 00                	mov    (%eax),%eax
  8018cc:	89 04 24             	mov    %eax,(%esp)
  8018cf:	e8 ed fe ff ff       	call   8017c1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	78 47                	js     80191f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018db:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018df:	75 23                	jne    801904 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8018e1:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018e6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f1:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  8018f8:	e8 20 ea ff ff       	call   80031d <cprintf>
  8018fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801902:	eb 1b                	jmp    80191f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801907:	8b 48 18             	mov    0x18(%eax),%ecx
  80190a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80190f:	85 c9                	test   %ecx,%ecx
  801911:	74 0c                	je     80191f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801913:	8b 45 0c             	mov    0xc(%ebp),%eax
  801916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191a:	89 14 24             	mov    %edx,(%esp)
  80191d:	ff d1                	call   *%ecx
}
  80191f:	83 c4 24             	add    $0x24,%esp
  801922:	5b                   	pop    %ebx
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	53                   	push   %ebx
  801929:	83 ec 24             	sub    $0x24,%esp
  80192c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80192f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801932:	89 44 24 04          	mov    %eax,0x4(%esp)
  801936:	89 1c 24             	mov    %ebx,(%esp)
  801939:	e8 0f fe ff ff       	call   80174d <fd_lookup>
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 66                	js     8019a8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801942:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801945:	89 44 24 04          	mov    %eax,0x4(%esp)
  801949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194c:	8b 00                	mov    (%eax),%eax
  80194e:	89 04 24             	mov    %eax,(%esp)
  801951:	e8 6b fe ff ff       	call   8017c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801956:	85 c0                	test   %eax,%eax
  801958:	78 4e                	js     8019a8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80195a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80195d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801961:	75 23                	jne    801986 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801963:	a1 74 70 80 00       	mov    0x807074,%eax
  801968:	8b 40 4c             	mov    0x4c(%eax),%eax
  80196b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80196f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801973:	c7 04 24 7d 34 80 00 	movl   $0x80347d,(%esp)
  80197a:	e8 9e e9 ff ff       	call   80031d <cprintf>
  80197f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801984:	eb 22                	jmp    8019a8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801989:	8b 48 0c             	mov    0xc(%eax),%ecx
  80198c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801991:	85 c9                	test   %ecx,%ecx
  801993:	74 13                	je     8019a8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801995:	8b 45 10             	mov    0x10(%ebp),%eax
  801998:	89 44 24 08          	mov    %eax,0x8(%esp)
  80199c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a3:	89 14 24             	mov    %edx,(%esp)
  8019a6:	ff d1                	call   *%ecx
}
  8019a8:	83 c4 24             	add    $0x24,%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5d                   	pop    %ebp
  8019ad:	c3                   	ret    

008019ae <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 24             	sub    $0x24,%esp
  8019b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bf:	89 1c 24             	mov    %ebx,(%esp)
  8019c2:	e8 86 fd ff ff       	call   80174d <fd_lookup>
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 6b                	js     801a36 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d5:	8b 00                	mov    (%eax),%eax
  8019d7:	89 04 24             	mov    %eax,(%esp)
  8019da:	e8 e2 fd ff ff       	call   8017c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 53                	js     801a36 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e6:	8b 42 08             	mov    0x8(%edx),%eax
  8019e9:	83 e0 03             	and    $0x3,%eax
  8019ec:	83 f8 01             	cmp    $0x1,%eax
  8019ef:	75 23                	jne    801a14 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8019f1:	a1 74 70 80 00       	mov    0x807074,%eax
  8019f6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a01:	c7 04 24 9a 34 80 00 	movl   $0x80349a,(%esp)
  801a08:	e8 10 e9 ff ff       	call   80031d <cprintf>
  801a0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a12:	eb 22                	jmp    801a36 <read+0x88>
	}
	if (!dev->dev_read)
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a17:	8b 48 08             	mov    0x8(%eax),%ecx
  801a1a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a1f:	85 c9                	test   %ecx,%ecx
  801a21:	74 13                	je     801a36 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a23:	8b 45 10             	mov    0x10(%ebp),%eax
  801a26:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a31:	89 14 24             	mov    %edx,(%esp)
  801a34:	ff d1                	call   *%ecx
}
  801a36:	83 c4 24             	add    $0x24,%esp
  801a39:	5b                   	pop    %ebx
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    

00801a3c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	57                   	push   %edi
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	83 ec 1c             	sub    $0x1c,%esp
  801a45:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a48:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a50:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a55:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5a:	85 f6                	test   %esi,%esi
  801a5c:	74 29                	je     801a87 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a5e:	89 f0                	mov    %esi,%eax
  801a60:	29 d0                	sub    %edx,%eax
  801a62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a66:	03 55 0c             	add    0xc(%ebp),%edx
  801a69:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a6d:	89 3c 24             	mov    %edi,(%esp)
  801a70:	e8 39 ff ff ff       	call   8019ae <read>
		if (m < 0)
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 0e                	js     801a87 <readn+0x4b>
			return m;
		if (m == 0)
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	74 08                	je     801a85 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a7d:	01 c3                	add    %eax,%ebx
  801a7f:	89 da                	mov    %ebx,%edx
  801a81:	39 f3                	cmp    %esi,%ebx
  801a83:	72 d9                	jb     801a5e <readn+0x22>
  801a85:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a87:	83 c4 1c             	add    $0x1c,%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5f                   	pop    %edi
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 20             	sub    $0x20,%esp
  801a97:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a9a:	89 34 24             	mov    %esi,(%esp)
  801a9d:	e8 0e fc ff ff       	call   8016b0 <fd2num>
  801aa2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801aa5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aa9:	89 04 24             	mov    %eax,(%esp)
  801aac:	e8 9c fc ff ff       	call   80174d <fd_lookup>
  801ab1:	89 c3                	mov    %eax,%ebx
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 05                	js     801abc <fd_close+0x2d>
  801ab7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801aba:	74 0c                	je     801ac8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801abc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801ac0:	19 c0                	sbb    %eax,%eax
  801ac2:	f7 d0                	not    %eax
  801ac4:	21 c3                	and    %eax,%ebx
  801ac6:	eb 3d                	jmp    801b05 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ac8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acf:	8b 06                	mov    (%esi),%eax
  801ad1:	89 04 24             	mov    %eax,(%esp)
  801ad4:	e8 e8 fc ff ff       	call   8017c1 <dev_lookup>
  801ad9:	89 c3                	mov    %eax,%ebx
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 16                	js     801af5 <fd_close+0x66>
		if (dev->dev_close)
  801adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae2:	8b 40 10             	mov    0x10(%eax),%eax
  801ae5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aea:	85 c0                	test   %eax,%eax
  801aec:	74 07                	je     801af5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801aee:	89 34 24             	mov    %esi,(%esp)
  801af1:	ff d0                	call   *%eax
  801af3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801af5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801af9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b00:	e8 0a f6 ff ff       	call   80110f <sys_page_unmap>
	return r;
}
  801b05:	89 d8                	mov    %ebx,%eax
  801b07:	83 c4 20             	add    $0x20,%esp
  801b0a:	5b                   	pop    %ebx
  801b0b:	5e                   	pop    %esi
  801b0c:	5d                   	pop    %ebp
  801b0d:	c3                   	ret    

00801b0e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	89 04 24             	mov    %eax,(%esp)
  801b21:	e8 27 fc ff ff       	call   80174d <fd_lookup>
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 13                	js     801b3d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801b2a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b31:	00 
  801b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b35:	89 04 24             	mov    %eax,(%esp)
  801b38:	e8 52 ff ff ff       	call   801a8f <fd_close>
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 18             	sub    $0x18,%esp
  801b45:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b48:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b52:	00 
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	89 04 24             	mov    %eax,(%esp)
  801b59:	e8 55 03 00 00       	call   801eb3 <open>
  801b5e:	89 c3                	mov    %eax,%ebx
  801b60:	85 c0                	test   %eax,%eax
  801b62:	78 1b                	js     801b7f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6b:	89 1c 24             	mov    %ebx,(%esp)
  801b6e:	e8 b7 fc ff ff       	call   80182a <fstat>
  801b73:	89 c6                	mov    %eax,%esi
	close(fd);
  801b75:	89 1c 24             	mov    %ebx,(%esp)
  801b78:	e8 91 ff ff ff       	call   801b0e <close>
  801b7d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801b7f:	89 d8                	mov    %ebx,%eax
  801b81:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b84:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b87:	89 ec                	mov    %ebp,%esp
  801b89:	5d                   	pop    %ebp
  801b8a:	c3                   	ret    

00801b8b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	53                   	push   %ebx
  801b8f:	83 ec 14             	sub    $0x14,%esp
  801b92:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801b97:	89 1c 24             	mov    %ebx,(%esp)
  801b9a:	e8 6f ff ff ff       	call   801b0e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801b9f:	83 c3 01             	add    $0x1,%ebx
  801ba2:	83 fb 20             	cmp    $0x20,%ebx
  801ba5:	75 f0                	jne    801b97 <close_all+0xc>
		close(i);
}
  801ba7:	83 c4 14             	add    $0x14,%esp
  801baa:	5b                   	pop    %ebx
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    

00801bad <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 58             	sub    $0x58,%esp
  801bb3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801bb6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bb9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801bbf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	89 04 24             	mov    %eax,(%esp)
  801bcc:	e8 7c fb ff ff       	call   80174d <fd_lookup>
  801bd1:	89 c3                	mov    %eax,%ebx
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	0f 88 e0 00 00 00    	js     801cbb <dup+0x10e>
		return r;
	close(newfdnum);
  801bdb:	89 3c 24             	mov    %edi,(%esp)
  801bde:	e8 2b ff ff ff       	call   801b0e <close>

	newfd = INDEX2FD(newfdnum);
  801be3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801be9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bef:	89 04 24             	mov    %eax,(%esp)
  801bf2:	e8 c9 fa ff ff       	call   8016c0 <fd2data>
  801bf7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801bf9:	89 34 24             	mov    %esi,(%esp)
  801bfc:	e8 bf fa ff ff       	call   8016c0 <fd2data>
  801c01:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801c04:	89 da                	mov    %ebx,%edx
  801c06:	89 d8                	mov    %ebx,%eax
  801c08:	c1 e8 16             	shr    $0x16,%eax
  801c0b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c12:	a8 01                	test   $0x1,%al
  801c14:	74 43                	je     801c59 <dup+0xac>
  801c16:	c1 ea 0c             	shr    $0xc,%edx
  801c19:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c20:	a8 01                	test   $0x1,%al
  801c22:	74 35                	je     801c59 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801c24:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c2b:	25 07 0e 00 00       	and    $0xe07,%eax
  801c30:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c42:	00 
  801c43:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c4e:	e8 1a f5 ff ff       	call   80116d <sys_page_map>
  801c53:	89 c3                	mov    %eax,%ebx
  801c55:	85 c0                	test   %eax,%eax
  801c57:	78 3f                	js     801c98 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5c:	89 c2                	mov    %eax,%edx
  801c5e:	c1 ea 0c             	shr    $0xc,%edx
  801c61:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c68:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801c6e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c72:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c7d:	00 
  801c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c89:	e8 df f4 ff ff       	call   80116d <sys_page_map>
  801c8e:	89 c3                	mov    %eax,%ebx
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 04                	js     801c98 <dup+0xeb>
  801c94:	89 fb                	mov    %edi,%ebx
  801c96:	eb 23                	jmp    801cbb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801c98:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c9c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca3:	e8 67 f4 ff ff       	call   80110f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ca8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801caf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb6:	e8 54 f4 ff ff       	call   80110f <sys_page_unmap>
	return r;
}
  801cbb:	89 d8                	mov    %ebx,%eax
  801cbd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801cc0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801cc3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801cc6:	89 ec                	mov    %ebp,%esp
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    
	...

00801ccc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 14             	sub    $0x14,%esp
  801cd3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801cd5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801cdb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ce2:	00 
  801ce3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801cea:	00 
  801ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cef:	89 14 24             	mov    %edx,(%esp)
  801cf2:	e8 79 0d 00 00       	call   802a70 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cf7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cfe:	00 
  801cff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d0a:	e8 c7 0d 00 00       	call   802ad6 <ipc_recv>
}
  801d0f:	83 c4 14             	add    $0x14,%esp
  801d12:	5b                   	pop    %ebx
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    

00801d15 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d21:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d29:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d33:	b8 02 00 00 00       	mov    $0x2,%eax
  801d38:	e8 8f ff ff ff       	call   801ccc <fsipc>
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801d50:	ba 00 00 00 00       	mov    $0x0,%edx
  801d55:	b8 06 00 00 00       	mov    $0x6,%eax
  801d5a:	e8 6d ff ff ff       	call   801ccc <fsipc>
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d67:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d71:	e8 56 ff ff ff       	call   801ccc <fsipc>
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 14             	sub    $0x14,%esp
  801d7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8b 40 0c             	mov    0xc(%eax),%eax
  801d88:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d92:	b8 05 00 00 00       	mov    $0x5,%eax
  801d97:	e8 30 ff ff ff       	call   801ccc <fsipc>
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 2b                	js     801dcb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801da0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801da7:	00 
  801da8:	89 1c 24             	mov    %ebx,(%esp)
  801dab:	e8 2a ec ff ff       	call   8009da <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801db0:	a1 80 40 80 00       	mov    0x804080,%eax
  801db5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dbb:	a1 84 40 80 00       	mov    0x804084,%eax
  801dc0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801dcb:	83 c4 14             	add    $0x14,%esp
  801dce:	5b                   	pop    %ebx
  801dcf:	5d                   	pop    %ebp
  801dd0:	c3                   	ret    

00801dd1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 18             	sub    $0x18,%esp
  801dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dda:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801ddf:	76 05                	jbe    801de6 <devfile_write+0x15>
  801de1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801de6:	8b 55 08             	mov    0x8(%ebp),%edx
  801de9:	8b 52 0c             	mov    0xc(%edx),%edx
  801dec:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801df2:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801df7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e02:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801e09:	e8 87 ed ff ff       	call   800b95 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e13:	b8 04 00 00 00       	mov    $0x4,%eax
  801e18:	e8 af fe ff ff       	call   801ccc <fsipc>
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	53                   	push   %ebx
  801e23:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801e31:	8b 45 10             	mov    0x10(%ebp),%eax
  801e34:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801e39:	ba 00 40 80 00       	mov    $0x804000,%edx
  801e3e:	b8 03 00 00 00       	mov    $0x3,%eax
  801e43:	e8 84 fe ff ff       	call   801ccc <fsipc>
  801e48:	89 c3                	mov    %eax,%ebx
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	78 17                	js     801e65 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801e4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e52:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801e59:	00 
  801e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5d:	89 04 24             	mov    %eax,(%esp)
  801e60:	e8 30 ed ff ff       	call   800b95 <memmove>
	return r;
}
  801e65:	89 d8                	mov    %ebx,%eax
  801e67:	83 c4 14             	add    $0x14,%esp
  801e6a:	5b                   	pop    %ebx
  801e6b:	5d                   	pop    %ebp
  801e6c:	c3                   	ret    

00801e6d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	53                   	push   %ebx
  801e71:	83 ec 14             	sub    $0x14,%esp
  801e74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801e77:	89 1c 24             	mov    %ebx,(%esp)
  801e7a:	e8 11 eb ff ff       	call   800990 <strlen>
  801e7f:	89 c2                	mov    %eax,%edx
  801e81:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801e86:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801e8c:	7f 1f                	jg     801ead <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801e8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e92:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e99:	e8 3c eb ff ff       	call   8009da <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801e9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea3:	b8 07 00 00 00       	mov    $0x7,%eax
  801ea8:	e8 1f fe ff ff       	call   801ccc <fsipc>
}
  801ead:	83 c4 14             	add    $0x14,%esp
  801eb0:	5b                   	pop    %ebx
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    

00801eb3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 28             	sub    $0x28,%esp
  801eb9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ebc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801ebf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801ec2:	89 34 24             	mov    %esi,(%esp)
  801ec5:	e8 c6 ea ff ff       	call   800990 <strlen>
  801eca:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ecf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ed4:	7f 5e                	jg     801f34 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801ed6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed9:	89 04 24             	mov    %eax,(%esp)
  801edc:	e8 fa f7 ff ff       	call   8016db <fd_alloc>
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 4d                	js     801f34 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eeb:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ef2:	e8 e3 ea ff ff       	call   8009da <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f02:	b8 01 00 00 00       	mov    $0x1,%eax
  801f07:	e8 c0 fd ff ff       	call   801ccc <fsipc>
  801f0c:	89 c3                	mov    %eax,%ebx
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	79 15                	jns    801f27 <open+0x74>
	{
		fd_close(fd,0);
  801f12:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f19:	00 
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	89 04 24             	mov    %eax,(%esp)
  801f20:	e8 6a fb ff ff       	call   801a8f <fd_close>
		return r; 
  801f25:	eb 0d                	jmp    801f34 <open+0x81>
	}
	return fd2num(fd);
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	89 04 24             	mov    %eax,(%esp)
  801f2d:	e8 7e f7 ff ff       	call   8016b0 <fd2num>
  801f32:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801f34:	89 d8                	mov    %ebx,%eax
  801f36:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f39:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f3c:	89 ec                	mov    %ebp,%esp
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    

00801f40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f46:	c7 44 24 04 cc 34 80 	movl   $0x8034cc,0x4(%esp)
  801f4d:	00 
  801f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f51:	89 04 24             	mov    %eax,(%esp)
  801f54:	e8 81 ea ff ff       	call   8009da <strcpy>
	return 0;
}
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6c:	89 04 24             	mov    %eax,(%esp)
  801f6f:	e8 9e 02 00 00       	call   802212 <nsipc_close>
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f7c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f83:	00 
  801f84:	8b 45 10             	mov    0x10(%ebp),%eax
  801f87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	8b 40 0c             	mov    0xc(%eax),%eax
  801f98:	89 04 24             	mov    %eax,(%esp)
  801f9b:	e8 ae 02 00 00       	call   80224e <nsipc_send>
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fa8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801faf:	00 
  801fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc4:	89 04 24             	mov    %eax,(%esp)
  801fc7:	e8 f5 02 00 00       	call   8022c1 <nsipc_recv>
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	56                   	push   %esi
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 20             	sub    $0x20,%esp
  801fd6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdb:	89 04 24             	mov    %eax,(%esp)
  801fde:	e8 f8 f6 ff ff       	call   8016db <fd_alloc>
  801fe3:	89 c3                	mov    %eax,%ebx
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	78 21                	js     80200a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801fe9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ff0:	00 
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fff:	e8 c7 f1 ff ff       	call   8011cb <sys_page_alloc>
  802004:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802006:	85 c0                	test   %eax,%eax
  802008:	79 0a                	jns    802014 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80200a:	89 34 24             	mov    %esi,(%esp)
  80200d:	e8 00 02 00 00       	call   802212 <nsipc_close>
		return r;
  802012:	eb 28                	jmp    80203c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802014:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	89 04 24             	mov    %eax,(%esp)
  802035:	e8 76 f6 ff ff       	call   8016b0 <fd2num>
  80203a:	89 c3                	mov    %eax,%ebx
}
  80203c:	89 d8                	mov    %ebx,%eax
  80203e:	83 c4 20             	add    $0x20,%esp
  802041:	5b                   	pop    %ebx
  802042:	5e                   	pop    %esi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    

00802045 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80204b:	8b 45 10             	mov    0x10(%ebp),%eax
  80204e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802052:	8b 45 0c             	mov    0xc(%ebp),%eax
  802055:	89 44 24 04          	mov    %eax,0x4(%esp)
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	89 04 24             	mov    %eax,(%esp)
  80205f:	e8 62 01 00 00       	call   8021c6 <nsipc_socket>
  802064:	85 c0                	test   %eax,%eax
  802066:	78 05                	js     80206d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802068:	e8 61 ff ff ff       	call   801fce <alloc_sockfd>
}
  80206d:	c9                   	leave  
  80206e:	66 90                	xchg   %ax,%ax
  802070:	c3                   	ret    

00802071 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802077:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80207a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80207e:	89 04 24             	mov    %eax,(%esp)
  802081:	e8 c7 f6 ff ff       	call   80174d <fd_lookup>
  802086:	85 c0                	test   %eax,%eax
  802088:	78 15                	js     80209f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80208a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208d:	8b 0a                	mov    (%edx),%ecx
  80208f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802094:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80209a:	75 03                	jne    80209f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80209c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	e8 c2 ff ff ff       	call   802071 <fd2sockid>
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 0f                	js     8020c2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8020b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ba:	89 04 24             	mov    %eax,(%esp)
  8020bd:	e8 2e 01 00 00       	call   8021f0 <nsipc_listen>
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	e8 9f ff ff ff       	call   802071 <fd2sockid>
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	78 16                	js     8020ec <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8020d6:	8b 55 10             	mov    0x10(%ebp),%edx
  8020d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e4:	89 04 24             	mov    %eax,(%esp)
  8020e7:	e8 55 02 00 00       	call   802341 <nsipc_connect>
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	e8 75 ff ff ff       	call   802071 <fd2sockid>
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	78 0f                	js     80210f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802100:	8b 55 0c             	mov    0xc(%ebp),%edx
  802103:	89 54 24 04          	mov    %edx,0x4(%esp)
  802107:	89 04 24             	mov    %eax,(%esp)
  80210a:	e8 1d 01 00 00       	call   80222c <nsipc_shutdown>
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	e8 52 ff ff ff       	call   802071 <fd2sockid>
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 16                	js     802139 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802123:	8b 55 10             	mov    0x10(%ebp),%edx
  802126:	89 54 24 08          	mov    %edx,0x8(%esp)
  80212a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802131:	89 04 24             	mov    %eax,(%esp)
  802134:	e8 47 02 00 00       	call   802380 <nsipc_bind>
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	e8 28 ff ff ff       	call   802071 <fd2sockid>
  802149:	85 c0                	test   %eax,%eax
  80214b:	78 1f                	js     80216c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80214d:	8b 55 10             	mov    0x10(%ebp),%edx
  802150:	89 54 24 08          	mov    %edx,0x8(%esp)
  802154:	8b 55 0c             	mov    0xc(%ebp),%edx
  802157:	89 54 24 04          	mov    %edx,0x4(%esp)
  80215b:	89 04 24             	mov    %eax,(%esp)
  80215e:	e8 5c 02 00 00       	call   8023bf <nsipc_accept>
  802163:	85 c0                	test   %eax,%eax
  802165:	78 05                	js     80216c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802167:	e8 62 fe ff ff       	call   801fce <alloc_sockfd>
}
  80216c:	c9                   	leave  
  80216d:	8d 76 00             	lea    0x0(%esi),%esi
  802170:	c3                   	ret    
	...

00802180 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802186:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80218c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802193:	00 
  802194:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80219b:	00 
  80219c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a0:	89 14 24             	mov    %edx,(%esp)
  8021a3:	e8 c8 08 00 00       	call   802a70 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021af:	00 
  8021b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021b7:	00 
  8021b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021bf:	e8 12 09 00 00       	call   802ad6 <ipc_recv>
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8021dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021df:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8021e4:	b8 09 00 00 00       	mov    $0x9,%eax
  8021e9:	e8 92 ff ff ff       	call   802180 <nsipc>
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8021fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802201:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802206:	b8 06 00 00 00       	mov    $0x6,%eax
  80220b:	e8 70 ff ff ff       	call   802180 <nsipc>
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802220:	b8 04 00 00 00       	mov    $0x4,%eax
  802225:	e8 56 ff ff ff       	call   802180 <nsipc>
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80223a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802242:	b8 03 00 00 00       	mov    $0x3,%eax
  802247:	e8 34 ff ff ff       	call   802180 <nsipc>
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	53                   	push   %ebx
  802252:	83 ec 14             	sub    $0x14,%esp
  802255:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802260:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802266:	7e 24                	jle    80228c <nsipc_send+0x3e>
  802268:	c7 44 24 0c d8 34 80 	movl   $0x8034d8,0xc(%esp)
  80226f:	00 
  802270:	c7 44 24 08 e4 34 80 	movl   $0x8034e4,0x8(%esp)
  802277:	00 
  802278:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80227f:	00 
  802280:	c7 04 24 f9 34 80 00 	movl   $0x8034f9,(%esp)
  802287:	e8 cc df ff ff       	call   800258 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80228c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802290:	8b 45 0c             	mov    0xc(%ebp),%eax
  802293:	89 44 24 04          	mov    %eax,0x4(%esp)
  802297:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80229e:	e8 f2 e8 ff ff       	call   800b95 <memmove>
	nsipcbuf.send.req_size = size;
  8022a3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8022a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ac:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022b1:	b8 08 00 00 00       	mov    $0x8,%eax
  8022b6:	e8 c5 fe ff ff       	call   802180 <nsipc>
}
  8022bb:	83 c4 14             	add    $0x14,%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    

008022c1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	56                   	push   %esi
  8022c5:	53                   	push   %ebx
  8022c6:	83 ec 10             	sub    $0x10,%esp
  8022c9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8022d4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8022da:	8b 45 14             	mov    0x14(%ebp),%eax
  8022dd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022e2:	b8 07 00 00 00       	mov    $0x7,%eax
  8022e7:	e8 94 fe ff ff       	call   802180 <nsipc>
  8022ec:	89 c3                	mov    %eax,%ebx
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	78 46                	js     802338 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022f2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022f7:	7f 04                	jg     8022fd <nsipc_recv+0x3c>
  8022f9:	39 c6                	cmp    %eax,%esi
  8022fb:	7d 24                	jge    802321 <nsipc_recv+0x60>
  8022fd:	c7 44 24 0c 05 35 80 	movl   $0x803505,0xc(%esp)
  802304:	00 
  802305:	c7 44 24 08 e4 34 80 	movl   $0x8034e4,0x8(%esp)
  80230c:	00 
  80230d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802314:	00 
  802315:	c7 04 24 f9 34 80 00 	movl   $0x8034f9,(%esp)
  80231c:	e8 37 df ff ff       	call   800258 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802321:	89 44 24 08          	mov    %eax,0x8(%esp)
  802325:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80232c:	00 
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	89 04 24             	mov    %eax,(%esp)
  802333:	e8 5d e8 ff ff       	call   800b95 <memmove>
	}

	return r;
}
  802338:	89 d8                	mov    %ebx,%eax
  80233a:	83 c4 10             	add    $0x10,%esp
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    

00802341 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	53                   	push   %ebx
  802345:	83 ec 14             	sub    $0x14,%esp
  802348:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802353:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802365:	e8 2b e8 ff ff       	call   800b95 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80236a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802370:	b8 05 00 00 00       	mov    $0x5,%eax
  802375:	e8 06 fe ff ff       	call   802180 <nsipc>
}
  80237a:	83 c4 14             	add    $0x14,%esp
  80237d:	5b                   	pop    %ebx
  80237e:	5d                   	pop    %ebp
  80237f:	c3                   	ret    

00802380 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	53                   	push   %ebx
  802384:	83 ec 14             	sub    $0x14,%esp
  802387:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802392:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8023a4:	e8 ec e7 ff ff       	call   800b95 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023a9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8023af:	b8 02 00 00 00       	mov    $0x2,%eax
  8023b4:	e8 c7 fd ff ff       	call   802180 <nsipc>
}
  8023b9:	83 c4 14             	add    $0x14,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 18             	sub    $0x18,%esp
  8023c5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023c8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d8:	e8 a3 fd ff ff       	call   802180 <nsipc>
  8023dd:	89 c3                	mov    %eax,%ebx
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	78 25                	js     802408 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023e3:	be 10 60 80 00       	mov    $0x806010,%esi
  8023e8:	8b 06                	mov    (%esi),%eax
  8023ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ee:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8023f5:	00 
  8023f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f9:	89 04 24             	mov    %eax,(%esp)
  8023fc:	e8 94 e7 ff ff       	call   800b95 <memmove>
		*addrlen = ret->ret_addrlen;
  802401:	8b 16                	mov    (%esi),%edx
  802403:	8b 45 10             	mov    0x10(%ebp),%eax
  802406:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802408:	89 d8                	mov    %ebx,%eax
  80240a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80240d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802410:	89 ec                	mov    %ebp,%esp
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    
	...

00802420 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 18             	sub    $0x18,%esp
  802426:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802429:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80242c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	89 04 24             	mov    %eax,(%esp)
  802435:	e8 86 f2 ff ff       	call   8016c0 <fd2data>
  80243a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80243c:	c7 44 24 04 1a 35 80 	movl   $0x80351a,0x4(%esp)
  802443:	00 
  802444:	89 34 24             	mov    %esi,(%esp)
  802447:	e8 8e e5 ff ff       	call   8009da <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80244c:	8b 43 04             	mov    0x4(%ebx),%eax
  80244f:	2b 03                	sub    (%ebx),%eax
  802451:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802457:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80245e:	00 00 00 
	stat->st_dev = &devpipe;
  802461:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802468:	70 80 00 
	return 0;
}
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802473:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802476:	89 ec                	mov    %ebp,%esp
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    

0080247a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	53                   	push   %ebx
  80247e:	83 ec 14             	sub    $0x14,%esp
  802481:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802484:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802488:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80248f:	e8 7b ec ff ff       	call   80110f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802494:	89 1c 24             	mov    %ebx,(%esp)
  802497:	e8 24 f2 ff ff       	call   8016c0 <fd2data>
  80249c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a7:	e8 63 ec ff ff       	call   80110f <sys_page_unmap>
}
  8024ac:	83 c4 14             	add    $0x14,%esp
  8024af:	5b                   	pop    %ebx
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    

008024b2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	57                   	push   %edi
  8024b6:	56                   	push   %esi
  8024b7:	53                   	push   %ebx
  8024b8:	83 ec 2c             	sub    $0x2c,%esp
  8024bb:	89 c7                	mov    %eax,%edi
  8024bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8024c0:	a1 74 70 80 00       	mov    0x807074,%eax
  8024c5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024c8:	89 3c 24             	mov    %edi,(%esp)
  8024cb:	e8 70 06 00 00       	call   802b40 <pageref>
  8024d0:	89 c6                	mov    %eax,%esi
  8024d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d5:	89 04 24             	mov    %eax,(%esp)
  8024d8:	e8 63 06 00 00       	call   802b40 <pageref>
  8024dd:	39 c6                	cmp    %eax,%esi
  8024df:	0f 94 c0             	sete   %al
  8024e2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8024e5:	8b 15 74 70 80 00    	mov    0x807074,%edx
  8024eb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024ee:	39 cb                	cmp    %ecx,%ebx
  8024f0:	75 08                	jne    8024fa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8024f2:	83 c4 2c             	add    $0x2c,%esp
  8024f5:	5b                   	pop    %ebx
  8024f6:	5e                   	pop    %esi
  8024f7:	5f                   	pop    %edi
  8024f8:	5d                   	pop    %ebp
  8024f9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8024fa:	83 f8 01             	cmp    $0x1,%eax
  8024fd:	75 c1                	jne    8024c0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8024ff:	8b 52 58             	mov    0x58(%edx),%edx
  802502:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802506:	89 54 24 08          	mov    %edx,0x8(%esp)
  80250a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80250e:	c7 04 24 21 35 80 00 	movl   $0x803521,(%esp)
  802515:	e8 03 de ff ff       	call   80031d <cprintf>
  80251a:	eb a4                	jmp    8024c0 <_pipeisclosed+0xe>

0080251c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	57                   	push   %edi
  802520:	56                   	push   %esi
  802521:	53                   	push   %ebx
  802522:	83 ec 1c             	sub    $0x1c,%esp
  802525:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802528:	89 34 24             	mov    %esi,(%esp)
  80252b:	e8 90 f1 ff ff       	call   8016c0 <fd2data>
  802530:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802532:	bf 00 00 00 00       	mov    $0x0,%edi
  802537:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80253b:	75 54                	jne    802591 <devpipe_write+0x75>
  80253d:	eb 60                	jmp    80259f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80253f:	89 da                	mov    %ebx,%edx
  802541:	89 f0                	mov    %esi,%eax
  802543:	e8 6a ff ff ff       	call   8024b2 <_pipeisclosed>
  802548:	85 c0                	test   %eax,%eax
  80254a:	74 07                	je     802553 <devpipe_write+0x37>
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
  802551:	eb 53                	jmp    8025a6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802553:	90                   	nop
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	e8 cd ec ff ff       	call   80122a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80255d:	8b 43 04             	mov    0x4(%ebx),%eax
  802560:	8b 13                	mov    (%ebx),%edx
  802562:	83 c2 20             	add    $0x20,%edx
  802565:	39 d0                	cmp    %edx,%eax
  802567:	73 d6                	jae    80253f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802569:	89 c2                	mov    %eax,%edx
  80256b:	c1 fa 1f             	sar    $0x1f,%edx
  80256e:	c1 ea 1b             	shr    $0x1b,%edx
  802571:	01 d0                	add    %edx,%eax
  802573:	83 e0 1f             	and    $0x1f,%eax
  802576:	29 d0                	sub    %edx,%eax
  802578:	89 c2                	mov    %eax,%edx
  80257a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80257d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802581:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802585:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802589:	83 c7 01             	add    $0x1,%edi
  80258c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80258f:	76 13                	jbe    8025a4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802591:	8b 43 04             	mov    0x4(%ebx),%eax
  802594:	8b 13                	mov    (%ebx),%edx
  802596:	83 c2 20             	add    $0x20,%edx
  802599:	39 d0                	cmp    %edx,%eax
  80259b:	73 a2                	jae    80253f <devpipe_write+0x23>
  80259d:	eb ca                	jmp    802569 <devpipe_write+0x4d>
  80259f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8025a4:	89 f8                	mov    %edi,%eax
}
  8025a6:	83 c4 1c             	add    $0x1c,%esp
  8025a9:	5b                   	pop    %ebx
  8025aa:	5e                   	pop    %esi
  8025ab:	5f                   	pop    %edi
  8025ac:	5d                   	pop    %ebp
  8025ad:	c3                   	ret    

008025ae <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 28             	sub    $0x28,%esp
  8025b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8025c0:	89 3c 24             	mov    %edi,(%esp)
  8025c3:	e8 f8 f0 ff ff       	call   8016c0 <fd2data>
  8025c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025ca:	be 00 00 00 00       	mov    $0x0,%esi
  8025cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025d3:	75 4c                	jne    802621 <devpipe_read+0x73>
  8025d5:	eb 5b                	jmp    802632 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8025d7:	89 f0                	mov    %esi,%eax
  8025d9:	eb 5e                	jmp    802639 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025db:	89 da                	mov    %ebx,%edx
  8025dd:	89 f8                	mov    %edi,%eax
  8025df:	90                   	nop
  8025e0:	e8 cd fe ff ff       	call   8024b2 <_pipeisclosed>
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 07                	je     8025f0 <devpipe_read+0x42>
  8025e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ee:	eb 49                	jmp    802639 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8025f0:	e8 35 ec ff ff       	call   80122a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8025f5:	8b 03                	mov    (%ebx),%eax
  8025f7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025fa:	74 df                	je     8025db <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025fc:	89 c2                	mov    %eax,%edx
  8025fe:	c1 fa 1f             	sar    $0x1f,%edx
  802601:	c1 ea 1b             	shr    $0x1b,%edx
  802604:	01 d0                	add    %edx,%eax
  802606:	83 e0 1f             	and    $0x1f,%eax
  802609:	29 d0                	sub    %edx,%eax
  80260b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802610:	8b 55 0c             	mov    0xc(%ebp),%edx
  802613:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802616:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802619:	83 c6 01             	add    $0x1,%esi
  80261c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80261f:	76 16                	jbe    802637 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802621:	8b 03                	mov    (%ebx),%eax
  802623:	3b 43 04             	cmp    0x4(%ebx),%eax
  802626:	75 d4                	jne    8025fc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802628:	85 f6                	test   %esi,%esi
  80262a:	75 ab                	jne    8025d7 <devpipe_read+0x29>
  80262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802630:	eb a9                	jmp    8025db <devpipe_read+0x2d>
  802632:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802637:	89 f0                	mov    %esi,%eax
}
  802639:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80263c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80263f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802642:	89 ec                	mov    %ebp,%esp
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    

00802646 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	89 04 24             	mov    %eax,(%esp)
  802659:	e8 ef f0 ff ff       	call   80174d <fd_lookup>
  80265e:	85 c0                	test   %eax,%eax
  802660:	78 15                	js     802677 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	89 04 24             	mov    %eax,(%esp)
  802668:	e8 53 f0 ff ff       	call   8016c0 <fd2data>
	return _pipeisclosed(fd, p);
  80266d:	89 c2                	mov    %eax,%edx
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	e8 3b fe ff ff       	call   8024b2 <_pipeisclosed>
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	83 ec 48             	sub    $0x48,%esp
  80267f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802682:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802685:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802688:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80268b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80268e:	89 04 24             	mov    %eax,(%esp)
  802691:	e8 45 f0 ff ff       	call   8016db <fd_alloc>
  802696:	89 c3                	mov    %eax,%ebx
  802698:	85 c0                	test   %eax,%eax
  80269a:	0f 88 42 01 00 00    	js     8027e2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026a0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026a7:	00 
  8026a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b6:	e8 10 eb ff ff       	call   8011cb <sys_page_alloc>
  8026bb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	0f 88 1d 01 00 00    	js     8027e2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8026c8:	89 04 24             	mov    %eax,(%esp)
  8026cb:	e8 0b f0 ff ff       	call   8016db <fd_alloc>
  8026d0:	89 c3                	mov    %eax,%ebx
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	0f 88 f5 00 00 00    	js     8027cf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026da:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026e1:	00 
  8026e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f0:	e8 d6 ea ff ff       	call   8011cb <sys_page_alloc>
  8026f5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	0f 88 d0 00 00 00    	js     8027cf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8026ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802702:	89 04 24             	mov    %eax,(%esp)
  802705:	e8 b6 ef ff ff       	call   8016c0 <fd2data>
  80270a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802713:	00 
  802714:	89 44 24 04          	mov    %eax,0x4(%esp)
  802718:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80271f:	e8 a7 ea ff ff       	call   8011cb <sys_page_alloc>
  802724:	89 c3                	mov    %eax,%ebx
  802726:	85 c0                	test   %eax,%eax
  802728:	0f 88 8e 00 00 00    	js     8027bc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80272e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802731:	89 04 24             	mov    %eax,(%esp)
  802734:	e8 87 ef ff ff       	call   8016c0 <fd2data>
  802739:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802740:	00 
  802741:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802745:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80274c:	00 
  80274d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802751:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802758:	e8 10 ea ff ff       	call   80116d <sys_page_map>
  80275d:	89 c3                	mov    %eax,%ebx
  80275f:	85 c0                	test   %eax,%eax
  802761:	78 49                	js     8027ac <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802763:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802768:	8b 08                	mov    (%eax),%ecx
  80276a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80276d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80276f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802772:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802779:	8b 10                	mov    (%eax),%edx
  80277b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802780:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802783:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80278a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278d:	89 04 24             	mov    %eax,(%esp)
  802790:	e8 1b ef ff ff       	call   8016b0 <fd2num>
  802795:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	89 04 24             	mov    %eax,(%esp)
  80279d:	e8 0e ef ff ff       	call   8016b0 <fd2num>
  8027a2:	89 47 04             	mov    %eax,0x4(%edi)
  8027a5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8027aa:	eb 36                	jmp    8027e2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8027ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b7:	e8 53 e9 ff ff       	call   80110f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8027bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027ca:	e8 40 e9 ff ff       	call   80110f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8027cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027dd:	e8 2d e9 ff ff       	call   80110f <sys_page_unmap>
    err:
	return r;
}
  8027e2:	89 d8                	mov    %ebx,%eax
  8027e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8027e7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8027ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8027ed:	89 ec                	mov    %ebp,%esp
  8027ef:	5d                   	pop    %ebp
  8027f0:	c3                   	ret    
	...

00802800 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	5d                   	pop    %ebp
  802809:	c3                   	ret    

0080280a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802810:	c7 44 24 04 39 35 80 	movl   $0x803539,0x4(%esp)
  802817:	00 
  802818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80281b:	89 04 24             	mov    %eax,(%esp)
  80281e:	e8 b7 e1 ff ff       	call   8009da <strcpy>
	return 0;
}
  802823:	b8 00 00 00 00       	mov    $0x0,%eax
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	57                   	push   %edi
  80282e:	56                   	push   %esi
  80282f:	53                   	push   %ebx
  802830:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	be 00 00 00 00       	mov    $0x0,%esi
  802840:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802844:	74 3f                	je     802885 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802846:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80284c:	8b 55 10             	mov    0x10(%ebp),%edx
  80284f:	29 c2                	sub    %eax,%edx
  802851:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802853:	83 fa 7f             	cmp    $0x7f,%edx
  802856:	76 05                	jbe    80285d <devcons_write+0x33>
  802858:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80285d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802861:	03 45 0c             	add    0xc(%ebp),%eax
  802864:	89 44 24 04          	mov    %eax,0x4(%esp)
  802868:	89 3c 24             	mov    %edi,(%esp)
  80286b:	e8 25 e3 ff ff       	call   800b95 <memmove>
		sys_cputs(buf, m);
  802870:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802874:	89 3c 24             	mov    %edi,(%esp)
  802877:	e8 54 e5 ff ff       	call   800dd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80287c:	01 de                	add    %ebx,%esi
  80287e:	89 f0                	mov    %esi,%eax
  802880:	3b 75 10             	cmp    0x10(%ebp),%esi
  802883:	72 c7                	jb     80284c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802885:	89 f0                	mov    %esi,%eax
  802887:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80288d:	5b                   	pop    %ebx
  80288e:	5e                   	pop    %esi
  80288f:	5f                   	pop    %edi
  802890:	5d                   	pop    %ebp
  802891:	c3                   	ret    

00802892 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80289e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028a5:	00 
  8028a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028a9:	89 04 24             	mov    %eax,(%esp)
  8028ac:	e8 1f e5 ff ff       	call   800dd0 <sys_cputs>
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8028b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028bd:	75 07                	jne    8028c6 <devcons_read+0x13>
  8028bf:	eb 28                	jmp    8028e9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028c1:	e8 64 e9 ff ff       	call   80122a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028c6:	66 90                	xchg   %ax,%ax
  8028c8:	e8 cf e4 ff ff       	call   800d9c <sys_cgetc>
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	90                   	nop
  8028d0:	74 ef                	je     8028c1 <devcons_read+0xe>
  8028d2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	78 16                	js     8028ee <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8028d8:	83 f8 04             	cmp    $0x4,%eax
  8028db:	74 0c                	je     8028e9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8028dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e0:	88 10                	mov    %dl,(%eax)
  8028e2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8028e7:	eb 05                	jmp    8028ee <devcons_read+0x3b>
  8028e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
  8028f3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028f9:	89 04 24             	mov    %eax,(%esp)
  8028fc:	e8 da ed ff ff       	call   8016db <fd_alloc>
  802901:	85 c0                	test   %eax,%eax
  802903:	78 3f                	js     802944 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802905:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80290c:	00 
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	89 44 24 04          	mov    %eax,0x4(%esp)
  802914:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80291b:	e8 ab e8 ff ff       	call   8011cb <sys_page_alloc>
  802920:	85 c0                	test   %eax,%eax
  802922:	78 20                	js     802944 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802924:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	89 04 24             	mov    %eax,(%esp)
  80293f:	e8 6c ed ff ff       	call   8016b0 <fd2num>
}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80294c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80294f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	89 04 24             	mov    %eax,(%esp)
  802959:	e8 ef ed ff ff       	call   80174d <fd_lookup>
  80295e:	85 c0                	test   %eax,%eax
  802960:	78 11                	js     802973 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  80296d:	0f 94 c0             	sete   %al
  802970:	0f b6 c0             	movzbl %al,%eax
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80297b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802982:	00 
  802983:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802986:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802991:	e8 18 f0 ff ff       	call   8019ae <read>
	if (r < 0)
  802996:	85 c0                	test   %eax,%eax
  802998:	78 0f                	js     8029a9 <getchar+0x34>
		return r;
	if (r < 1)
  80299a:	85 c0                	test   %eax,%eax
  80299c:	7f 07                	jg     8029a5 <getchar+0x30>
  80299e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029a3:	eb 04                	jmp    8029a9 <getchar+0x34>
		return -E_EOF;
	return c;
  8029a5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029a9:	c9                   	leave  
  8029aa:	c3                   	ret    
	...

008029ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8029b2:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  8029b9:	75 78                	jne    802a33 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8029bb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029c2:	00 
  8029c3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029ca:	ee 
  8029cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029d2:	e8 f4 e7 ff ff       	call   8011cb <sys_page_alloc>
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	79 20                	jns    8029fb <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  8029db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029df:	c7 44 24 08 45 35 80 	movl   $0x803545,0x8(%esp)
  8029e6:	00 
  8029e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8029ee:	00 
  8029ef:	c7 04 24 63 35 80 00 	movl   $0x803563,(%esp)
  8029f6:	e8 5d d8 ff ff       	call   800258 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8029fb:	c7 44 24 04 40 2a 80 	movl   $0x802a40,0x4(%esp)
  802a02:	00 
  802a03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a0a:	e8 e6 e5 ff ff       	call   800ff5 <sys_env_set_pgfault_upcall>
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	79 20                	jns    802a33 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802a13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a17:	c7 44 24 08 74 35 80 	movl   $0x803574,0x8(%esp)
  802a1e:	00 
  802a1f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802a26:	00 
  802a27:	c7 04 24 63 35 80 00 	movl   $0x803563,(%esp)
  802a2e:	e8 25 d8 ff ff       	call   800258 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	a3 7c 70 80 00       	mov    %eax,0x80707c
	
}
  802a3b:	c9                   	leave  
  802a3c:	c3                   	ret    
  802a3d:	00 00                	add    %al,(%eax)
	...

00802a40 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a40:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a41:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  802a46:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a48:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802a4b:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802a4d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802a51:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802a55:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802a57:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802a58:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802a5a:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802a5d:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802a61:	83 c4 08             	add    $0x8,%esp
	popal
  802a64:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802a65:	83 c4 04             	add    $0x4,%esp
	popfl
  802a68:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802a69:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802a6a:	c3                   	ret    
  802a6b:	00 00                	add    %al,(%eax)
  802a6d:	00 00                	add    %al,(%eax)
	...

00802a70 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
  802a73:	57                   	push   %edi
  802a74:	56                   	push   %esi
  802a75:	53                   	push   %ebx
  802a76:	83 ec 1c             	sub    $0x1c,%esp
  802a79:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a7f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802a82:	85 db                	test   %ebx,%ebx
  802a84:	75 2d                	jne    802ab3 <ipc_send+0x43>
  802a86:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  802a8b:	eb 26                	jmp    802ab3 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  802a8d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a90:	74 1c                	je     802aae <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802a92:	c7 44 24 08 a0 35 80 	movl   $0x8035a0,0x8(%esp)
  802a99:	00 
  802a9a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802aa1:	00 
  802aa2:	c7 04 24 c4 35 80 00 	movl   $0x8035c4,(%esp)
  802aa9:	e8 aa d7 ff ff       	call   800258 <_panic>
		sys_yield();
  802aae:	e8 77 e7 ff ff       	call   80122a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802ab3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802ab7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802abb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	89 04 24             	mov    %eax,(%esp)
  802ac5:	e8 f3 e4 ff ff       	call   800fbd <sys_ipc_try_send>
  802aca:	85 c0                	test   %eax,%eax
  802acc:	78 bf                	js     802a8d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802ace:	83 c4 1c             	add    $0x1c,%esp
  802ad1:	5b                   	pop    %ebx
  802ad2:	5e                   	pop    %esi
  802ad3:	5f                   	pop    %edi
  802ad4:	5d                   	pop    %ebp
  802ad5:	c3                   	ret    

00802ad6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ad6:	55                   	push   %ebp
  802ad7:	89 e5                	mov    %esp,%ebp
  802ad9:	56                   	push   %esi
  802ada:	53                   	push   %ebx
  802adb:	83 ec 10             	sub    $0x10,%esp
  802ade:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	75 05                	jne    802af0 <ipc_recv+0x1a>
  802aeb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802af0:	89 04 24             	mov    %eax,(%esp)
  802af3:	e8 68 e4 ff ff       	call   800f60 <sys_ipc_recv>
  802af8:	85 c0                	test   %eax,%eax
  802afa:	79 16                	jns    802b12 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  802afc:	85 db                	test   %ebx,%ebx
  802afe:	74 06                	je     802b06 <ipc_recv+0x30>
			*from_env_store = 0;
  802b00:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802b06:	85 f6                	test   %esi,%esi
  802b08:	74 2c                	je     802b36 <ipc_recv+0x60>
			*perm_store = 0;
  802b0a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802b10:	eb 24                	jmp    802b36 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802b12:	85 db                	test   %ebx,%ebx
  802b14:	74 0a                	je     802b20 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802b16:	a1 74 70 80 00       	mov    0x807074,%eax
  802b1b:	8b 40 74             	mov    0x74(%eax),%eax
  802b1e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802b20:	85 f6                	test   %esi,%esi
  802b22:	74 0a                	je     802b2e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802b24:	a1 74 70 80 00       	mov    0x807074,%eax
  802b29:	8b 40 78             	mov    0x78(%eax),%eax
  802b2c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  802b2e:	a1 74 70 80 00       	mov    0x807074,%eax
  802b33:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802b36:	83 c4 10             	add    $0x10,%esp
  802b39:	5b                   	pop    %ebx
  802b3a:	5e                   	pop    %esi
  802b3b:	5d                   	pop    %ebp
  802b3c:	c3                   	ret    
  802b3d:	00 00                	add    %al,(%eax)
	...

00802b40 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	89 c2                	mov    %eax,%edx
  802b48:	c1 ea 16             	shr    $0x16,%edx
  802b4b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802b52:	f6 c2 01             	test   $0x1,%dl
  802b55:	74 26                	je     802b7d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802b57:	c1 e8 0c             	shr    $0xc,%eax
  802b5a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802b61:	a8 01                	test   $0x1,%al
  802b63:	74 18                	je     802b7d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802b65:	c1 e8 0c             	shr    $0xc,%eax
  802b68:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802b6b:	c1 e2 02             	shl    $0x2,%edx
  802b6e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802b73:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802b78:	0f b7 c0             	movzwl %ax,%eax
  802b7b:	eb 05                	jmp    802b82 <pageref+0x42>
  802b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b82:	5d                   	pop    %ebp
  802b83:	c3                   	ret    
	...

00802b90 <__udivdi3>:
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
  802b93:	57                   	push   %edi
  802b94:	56                   	push   %esi
  802b95:	83 ec 10             	sub    $0x10,%esp
  802b98:	8b 45 14             	mov    0x14(%ebp),%eax
  802b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9e:	8b 75 10             	mov    0x10(%ebp),%esi
  802ba1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802ba9:	75 35                	jne    802be0 <__udivdi3+0x50>
  802bab:	39 fe                	cmp    %edi,%esi
  802bad:	77 61                	ja     802c10 <__udivdi3+0x80>
  802baf:	85 f6                	test   %esi,%esi
  802bb1:	75 0b                	jne    802bbe <__udivdi3+0x2e>
  802bb3:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb8:	31 d2                	xor    %edx,%edx
  802bba:	f7 f6                	div    %esi
  802bbc:	89 c6                	mov    %eax,%esi
  802bbe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802bc1:	31 d2                	xor    %edx,%edx
  802bc3:	89 f8                	mov    %edi,%eax
  802bc5:	f7 f6                	div    %esi
  802bc7:	89 c7                	mov    %eax,%edi
  802bc9:	89 c8                	mov    %ecx,%eax
  802bcb:	f7 f6                	div    %esi
  802bcd:	89 c1                	mov    %eax,%ecx
  802bcf:	89 fa                	mov    %edi,%edx
  802bd1:	89 c8                	mov    %ecx,%eax
  802bd3:	83 c4 10             	add    $0x10,%esp
  802bd6:	5e                   	pop    %esi
  802bd7:	5f                   	pop    %edi
  802bd8:	5d                   	pop    %ebp
  802bd9:	c3                   	ret    
  802bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802be0:	39 f8                	cmp    %edi,%eax
  802be2:	77 1c                	ja     802c00 <__udivdi3+0x70>
  802be4:	0f bd d0             	bsr    %eax,%edx
  802be7:	83 f2 1f             	xor    $0x1f,%edx
  802bea:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bed:	75 39                	jne    802c28 <__udivdi3+0x98>
  802bef:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802bf2:	0f 86 a0 00 00 00    	jbe    802c98 <__udivdi3+0x108>
  802bf8:	39 f8                	cmp    %edi,%eax
  802bfa:	0f 82 98 00 00 00    	jb     802c98 <__udivdi3+0x108>
  802c00:	31 ff                	xor    %edi,%edi
  802c02:	31 c9                	xor    %ecx,%ecx
  802c04:	89 c8                	mov    %ecx,%eax
  802c06:	89 fa                	mov    %edi,%edx
  802c08:	83 c4 10             	add    $0x10,%esp
  802c0b:	5e                   	pop    %esi
  802c0c:	5f                   	pop    %edi
  802c0d:	5d                   	pop    %ebp
  802c0e:	c3                   	ret    
  802c0f:	90                   	nop
  802c10:	89 d1                	mov    %edx,%ecx
  802c12:	89 fa                	mov    %edi,%edx
  802c14:	89 c8                	mov    %ecx,%eax
  802c16:	31 ff                	xor    %edi,%edi
  802c18:	f7 f6                	div    %esi
  802c1a:	89 c1                	mov    %eax,%ecx
  802c1c:	89 fa                	mov    %edi,%edx
  802c1e:	89 c8                	mov    %ecx,%eax
  802c20:	83 c4 10             	add    $0x10,%esp
  802c23:	5e                   	pop    %esi
  802c24:	5f                   	pop    %edi
  802c25:	5d                   	pop    %ebp
  802c26:	c3                   	ret    
  802c27:	90                   	nop
  802c28:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c2c:	89 f2                	mov    %esi,%edx
  802c2e:	d3 e0                	shl    %cl,%eax
  802c30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c33:	b8 20 00 00 00       	mov    $0x20,%eax
  802c38:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c3b:	89 c1                	mov    %eax,%ecx
  802c3d:	d3 ea                	shr    %cl,%edx
  802c3f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c43:	0b 55 ec             	or     -0x14(%ebp),%edx
  802c46:	d3 e6                	shl    %cl,%esi
  802c48:	89 c1                	mov    %eax,%ecx
  802c4a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802c4d:	89 fe                	mov    %edi,%esi
  802c4f:	d3 ee                	shr    %cl,%esi
  802c51:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c55:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5b:	d3 e7                	shl    %cl,%edi
  802c5d:	89 c1                	mov    %eax,%ecx
  802c5f:	d3 ea                	shr    %cl,%edx
  802c61:	09 d7                	or     %edx,%edi
  802c63:	89 f2                	mov    %esi,%edx
  802c65:	89 f8                	mov    %edi,%eax
  802c67:	f7 75 ec             	divl   -0x14(%ebp)
  802c6a:	89 d6                	mov    %edx,%esi
  802c6c:	89 c7                	mov    %eax,%edi
  802c6e:	f7 65 e8             	mull   -0x18(%ebp)
  802c71:	39 d6                	cmp    %edx,%esi
  802c73:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c76:	72 30                	jb     802ca8 <__udivdi3+0x118>
  802c78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c7f:	d3 e2                	shl    %cl,%edx
  802c81:	39 c2                	cmp    %eax,%edx
  802c83:	73 05                	jae    802c8a <__udivdi3+0xfa>
  802c85:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802c88:	74 1e                	je     802ca8 <__udivdi3+0x118>
  802c8a:	89 f9                	mov    %edi,%ecx
  802c8c:	31 ff                	xor    %edi,%edi
  802c8e:	e9 71 ff ff ff       	jmp    802c04 <__udivdi3+0x74>
  802c93:	90                   	nop
  802c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c98:	31 ff                	xor    %edi,%edi
  802c9a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802c9f:	e9 60 ff ff ff       	jmp    802c04 <__udivdi3+0x74>
  802ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ca8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802cab:	31 ff                	xor    %edi,%edi
  802cad:	89 c8                	mov    %ecx,%eax
  802caf:	89 fa                	mov    %edi,%edx
  802cb1:	83 c4 10             	add    $0x10,%esp
  802cb4:	5e                   	pop    %esi
  802cb5:	5f                   	pop    %edi
  802cb6:	5d                   	pop    %ebp
  802cb7:	c3                   	ret    
	...

00802cc0 <__umoddi3>:
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
  802cc3:	57                   	push   %edi
  802cc4:	56                   	push   %esi
  802cc5:	83 ec 20             	sub    $0x20,%esp
  802cc8:	8b 55 14             	mov    0x14(%ebp),%edx
  802ccb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cce:	8b 7d 10             	mov    0x10(%ebp),%edi
  802cd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cd4:	85 d2                	test   %edx,%edx
  802cd6:	89 c8                	mov    %ecx,%eax
  802cd8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802cdb:	75 13                	jne    802cf0 <__umoddi3+0x30>
  802cdd:	39 f7                	cmp    %esi,%edi
  802cdf:	76 3f                	jbe    802d20 <__umoddi3+0x60>
  802ce1:	89 f2                	mov    %esi,%edx
  802ce3:	f7 f7                	div    %edi
  802ce5:	89 d0                	mov    %edx,%eax
  802ce7:	31 d2                	xor    %edx,%edx
  802ce9:	83 c4 20             	add    $0x20,%esp
  802cec:	5e                   	pop    %esi
  802ced:	5f                   	pop    %edi
  802cee:	5d                   	pop    %ebp
  802cef:	c3                   	ret    
  802cf0:	39 f2                	cmp    %esi,%edx
  802cf2:	77 4c                	ja     802d40 <__umoddi3+0x80>
  802cf4:	0f bd ca             	bsr    %edx,%ecx
  802cf7:	83 f1 1f             	xor    $0x1f,%ecx
  802cfa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802cfd:	75 51                	jne    802d50 <__umoddi3+0x90>
  802cff:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802d02:	0f 87 e0 00 00 00    	ja     802de8 <__umoddi3+0x128>
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	29 f8                	sub    %edi,%eax
  802d0d:	19 d6                	sbb    %edx,%esi
  802d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	89 f2                	mov    %esi,%edx
  802d17:	83 c4 20             	add    $0x20,%esp
  802d1a:	5e                   	pop    %esi
  802d1b:	5f                   	pop    %edi
  802d1c:	5d                   	pop    %ebp
  802d1d:	c3                   	ret    
  802d1e:	66 90                	xchg   %ax,%ax
  802d20:	85 ff                	test   %edi,%edi
  802d22:	75 0b                	jne    802d2f <__umoddi3+0x6f>
  802d24:	b8 01 00 00 00       	mov    $0x1,%eax
  802d29:	31 d2                	xor    %edx,%edx
  802d2b:	f7 f7                	div    %edi
  802d2d:	89 c7                	mov    %eax,%edi
  802d2f:	89 f0                	mov    %esi,%eax
  802d31:	31 d2                	xor    %edx,%edx
  802d33:	f7 f7                	div    %edi
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	f7 f7                	div    %edi
  802d3a:	eb a9                	jmp    802ce5 <__umoddi3+0x25>
  802d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d40:	89 c8                	mov    %ecx,%eax
  802d42:	89 f2                	mov    %esi,%edx
  802d44:	83 c4 20             	add    $0x20,%esp
  802d47:	5e                   	pop    %esi
  802d48:	5f                   	pop    %edi
  802d49:	5d                   	pop    %ebp
  802d4a:	c3                   	ret    
  802d4b:	90                   	nop
  802d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d50:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d54:	d3 e2                	shl    %cl,%edx
  802d56:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d59:	ba 20 00 00 00       	mov    $0x20,%edx
  802d5e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802d61:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d64:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d68:	89 fa                	mov    %edi,%edx
  802d6a:	d3 ea                	shr    %cl,%edx
  802d6c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d70:	0b 55 f4             	or     -0xc(%ebp),%edx
  802d73:	d3 e7                	shl    %cl,%edi
  802d75:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d79:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d7c:	89 f2                	mov    %esi,%edx
  802d7e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802d81:	89 c7                	mov    %eax,%edi
  802d83:	d3 ea                	shr    %cl,%edx
  802d85:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802d8c:	89 c2                	mov    %eax,%edx
  802d8e:	d3 e6                	shl    %cl,%esi
  802d90:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d94:	d3 ea                	shr    %cl,%edx
  802d96:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d9a:	09 d6                	or     %edx,%esi
  802d9c:	89 f0                	mov    %esi,%eax
  802d9e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802da1:	d3 e7                	shl    %cl,%edi
  802da3:	89 f2                	mov    %esi,%edx
  802da5:	f7 75 f4             	divl   -0xc(%ebp)
  802da8:	89 d6                	mov    %edx,%esi
  802daa:	f7 65 e8             	mull   -0x18(%ebp)
  802dad:	39 d6                	cmp    %edx,%esi
  802daf:	72 2b                	jb     802ddc <__umoddi3+0x11c>
  802db1:	39 c7                	cmp    %eax,%edi
  802db3:	72 23                	jb     802dd8 <__umoddi3+0x118>
  802db5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802db9:	29 c7                	sub    %eax,%edi
  802dbb:	19 d6                	sbb    %edx,%esi
  802dbd:	89 f0                	mov    %esi,%eax
  802dbf:	89 f2                	mov    %esi,%edx
  802dc1:	d3 ef                	shr    %cl,%edi
  802dc3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802dc7:	d3 e0                	shl    %cl,%eax
  802dc9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802dcd:	09 f8                	or     %edi,%eax
  802dcf:	d3 ea                	shr    %cl,%edx
  802dd1:	83 c4 20             	add    $0x20,%esp
  802dd4:	5e                   	pop    %esi
  802dd5:	5f                   	pop    %edi
  802dd6:	5d                   	pop    %ebp
  802dd7:	c3                   	ret    
  802dd8:	39 d6                	cmp    %edx,%esi
  802dda:	75 d9                	jne    802db5 <__umoddi3+0xf5>
  802ddc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ddf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802de2:	eb d1                	jmp    802db5 <__umoddi3+0xf5>
  802de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802de8:	39 f2                	cmp    %esi,%edx
  802dea:	0f 82 18 ff ff ff    	jb     802d08 <__umoddi3+0x48>
  802df0:	e9 1d ff ff ff       	jmp    802d12 <__umoddi3+0x52>
