
obj/user/testpiperace:     file format elf32-i386


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
  80002c:	e8 ef 01 00 00       	call   800220 <libmain>
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
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003c:	c7 04 24 40 2e 80 00 	movl   $0x802e40,(%esp)
  800043:	e8 09 03 00 00       	call   800351 <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 76 27 00 00       	call   8027c9 <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 59 2e 80 	movl   $0x802e59,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 62 2e 80 00 	movl   $0x802e62,(%esp)
  800072:	e8 15 02 00 00       	call   80028c <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800077:	e8 09 14 00 00       	call   801485 <fork>
  80007c:	89 c6                	mov    %eax,%esi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6e>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 76 2e 80 	movl   $0x802e76,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 62 2e 80 00 	movl   $0x802e62,(%esp)
  80009d:	e8 ea 01 00 00       	call   80028c <_panic>
	if (r == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	75 5c                	jne    800102 <umain+0xce>
		close(p[1]);
  8000a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a9:	89 04 24             	mov    %eax,(%esp)
  8000ac:	e8 5d 1b 00 00       	call   801c0e <close>
  8000b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000b9:	89 04 24             	mov    %eax,(%esp)
  8000bc:	e8 d5 26 00 00       	call   802796 <pipeisclosed>
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	74 11                	je     8000d6 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000c5:	c7 04 24 7f 2e 80 00 	movl   $0x802e7f,(%esp)
  8000cc:	e8 80 02 00 00       	call   800351 <cprintf>
				exit();
  8000d1:	e8 9a 01 00 00       	call   800270 <exit>
			}
			sys_yield();
  8000d6:	e8 7f 11 00 00       	call   80125a <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000db:	83 c3 01             	add    $0x1,%ebx
  8000de:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  8000e4:	75 d0                	jne    8000b6 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ed:	00 
  8000ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000fd:	e8 44 16 00 00       	call   801746 <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800102:	89 74 24 04          	mov    %esi,0x4(%esp)
  800106:	c7 04 24 9a 2e 80 00 	movl   $0x802e9a,(%esp)
  80010d:	e8 3f 02 00 00       	call   800351 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800112:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800118:	6b f6 7c             	imul   $0x7c,%esi,%esi
	cprintf("kid is %d\n", kid-envs);
  80011b:	8d 9e 00 00 c0 ee    	lea    -0x11400000(%esi),%ebx
  800121:	c1 ee 02             	shr    $0x2,%esi
  800124:	69 f6 df 7b ef bd    	imul   $0xbdef7bdf,%esi,%esi
  80012a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012e:	c7 04 24 a5 2e 80 00 	movl   $0x802ea5,(%esp)
  800135:	e8 17 02 00 00       	call   800351 <cprintf>
	dup(p[0], 10);
  80013a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800141:	00 
  800142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800145:	89 04 24             	mov    %eax,(%esp)
  800148:	e8 60 1b 00 00       	call   801cad <dup>
	while (kid->env_status == ENV_RUNNABLE)
  80014d:	8b 43 54             	mov    0x54(%ebx),%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	75 1b                	jne    800170 <umain+0x13c>
		dup(p[0], 10);
  800155:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  80015c:	00 
  80015d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800160:	89 04 24             	mov    %eax,(%esp)
  800163:	e8 45 1b 00 00       	call   801cad <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800168:	8b 43 54             	mov    0x54(%ebx),%eax
  80016b:	83 f8 01             	cmp    $0x1,%eax
  80016e:	74 e5                	je     800155 <umain+0x121>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800170:	c7 04 24 b0 2e 80 00 	movl   $0x802eb0,(%esp)
  800177:	e8 d5 01 00 00       	call   800351 <cprintf>
	if (pipeisclosed(p[0]))
  80017c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 0f 26 00 00       	call   802796 <pipeisclosed>
  800187:	85 c0                	test   %eax,%eax
  800189:	74 1c                	je     8001a7 <umain+0x173>
		panic("somehow the other end of p[0] got closed!");
  80018b:	c7 44 24 08 0c 2f 80 	movl   $0x802f0c,0x8(%esp)
  800192:	00 
  800193:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  80019a:	00 
  80019b:	c7 04 24 62 2e 80 00 	movl   $0x802e62,(%esp)
  8001a2:	e8 e5 00 00 00       	call   80028c <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b1:	89 04 24             	mov    %eax,(%esp)
  8001b4:	e8 94 16 00 00       	call   80184d <fd_lookup>
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	79 20                	jns    8001dd <umain+0x1a9>
		panic("cannot look up p[0]: %e", r);
  8001bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c1:	c7 44 24 08 c6 2e 80 	movl   $0x802ec6,0x8(%esp)
  8001c8:	00 
  8001c9:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001d0:	00 
  8001d1:	c7 04 24 62 2e 80 00 	movl   $0x802e62,(%esp)
  8001d8:	e8 af 00 00 00       	call   80028c <_panic>
	va = fd2data(fd);
  8001dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e0:	89 04 24             	mov    %eax,(%esp)
  8001e3:	e8 d8 15 00 00       	call   8017c0 <fd2data>
	if (pageref(va) != 3+1)
  8001e8:	89 04 24             	mov    %eax,(%esp)
  8001eb:	e8 50 1e 00 00       	call   802040 <pageref>
  8001f0:	83 f8 04             	cmp    $0x4,%eax
  8001f3:	74 0e                	je     800203 <umain+0x1cf>
		cprintf("\nchild detected race\n");
  8001f5:	c7 04 24 de 2e 80 00 	movl   $0x802ede,(%esp)
  8001fc:	e8 50 01 00 00       	call   800351 <cprintf>
  800201:	eb 14                	jmp    800217 <umain+0x1e3>
	else
		cprintf("\nrace didn't happen\n", max);
  800203:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  80020a:	00 
  80020b:	c7 04 24 f4 2e 80 00 	movl   $0x802ef4,(%esp)
  800212:	e8 3a 01 00 00       	call   800351 <cprintf>
}
  800217:	83 c4 20             	add    $0x20,%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    
	...

00800220 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 18             	sub    $0x18,%esp
  800226:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800229:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80022c:	8b 75 08             	mov    0x8(%ebp),%esi
  80022f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800232:	e8 57 10 00 00       	call   80128e <sys_getenvid>
	env = &envs[ENVX(envid)];
  800237:	25 ff 03 00 00       	and    $0x3ff,%eax
  80023c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80023f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800244:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	85 f6                	test   %esi,%esi
  80024b:	7e 07                	jle    800254 <libmain+0x34>
		binaryname = argv[0];
  80024d:	8b 03                	mov    (%ebx),%eax
  80024f:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800254:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800258:	89 34 24             	mov    %esi,(%esp)
  80025b:	e8 d4 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800260:	e8 0b 00 00 00       	call   800270 <exit>
}
  800265:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800268:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80026b:	89 ec                	mov    %ebp,%esp
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    
	...

00800270 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800276:	e8 10 1a 00 00       	call   801c8b <close_all>
	sys_env_destroy(0);
  80027b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800282:	e8 3b 10 00 00       	call   8012c2 <sys_env_destroy>
}
  800287:	c9                   	leave  
  800288:	c3                   	ret    
  800289:	00 00                	add    %al,(%eax)
	...

0080028c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	53                   	push   %ebx
  800290:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800293:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800296:	a1 78 70 80 00       	mov    0x807078,%eax
  80029b:	85 c0                	test   %eax,%eax
  80029d:	74 10                	je     8002af <_panic+0x23>
		cprintf("%s: ", argv0);
  80029f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a3:	c7 04 24 4d 2f 80 00 	movl   $0x802f4d,(%esp)
  8002aa:	e8 a2 00 00 00       	call   800351 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002bd:	a1 00 70 80 00       	mov    0x807000,%eax
  8002c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c6:	c7 04 24 52 2f 80 00 	movl   $0x802f52,(%esp)
  8002cd:	e8 7f 00 00 00       	call   800351 <cprintf>
	vcprintf(fmt, ap);
  8002d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 0f 00 00 00       	call   8002f0 <vcprintf>
	cprintf("\n");
  8002e1:	c7 04 24 57 2e 80 00 	movl   $0x802e57,(%esp)
  8002e8:	e8 64 00 00 00       	call   800351 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ed:	cc                   	int3   
  8002ee:	eb fd                	jmp    8002ed <_panic+0x61>

008002f0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800300:	00 00 00 
	b.cnt = 0;
  800303:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800314:	8b 45 08             	mov    0x8(%ebp),%eax
  800317:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	c7 04 24 6b 03 80 00 	movl   $0x80036b,(%esp)
  80032c:	e8 cc 01 00 00       	call   8004fd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800331:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800337:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800341:	89 04 24             	mov    %eax,(%esp)
  800344:	e8 b7 0a 00 00       	call   800e00 <sys_cputs>

	return b.cnt;
}
  800349:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800357:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	89 04 24             	mov    %eax,(%esp)
  800364:	e8 87 ff ff ff       	call   8002f0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	53                   	push   %ebx
  80036f:	83 ec 14             	sub    $0x14,%esp
  800372:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800375:	8b 03                	mov    (%ebx),%eax
  800377:	8b 55 08             	mov    0x8(%ebp),%edx
  80037a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80037e:	83 c0 01             	add    $0x1,%eax
  800381:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800383:	3d ff 00 00 00       	cmp    $0xff,%eax
  800388:	75 19                	jne    8003a3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80038a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800391:	00 
  800392:	8d 43 08             	lea    0x8(%ebx),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	e8 63 0a 00 00       	call   800e00 <sys_cputs>
		b->idx = 0;
  80039d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003a3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a7:	83 c4 14             	add    $0x14,%esp
  8003aa:	5b                   	pop    %ebx
  8003ab:	5d                   	pop    %ebp
  8003ac:	c3                   	ret    
  8003ad:	00 00                	add    %al,(%eax)
	...

008003b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	57                   	push   %edi
  8003b4:	56                   	push   %esi
  8003b5:	53                   	push   %ebx
  8003b6:	83 ec 4c             	sub    $0x4c,%esp
  8003b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003bc:	89 d6                	mov    %edx,%esi
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8003ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003d0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003db:	39 d1                	cmp    %edx,%ecx
  8003dd:	72 15                	jb     8003f4 <printnum+0x44>
  8003df:	77 07                	ja     8003e8 <printnum+0x38>
  8003e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003e4:	39 d0                	cmp    %edx,%eax
  8003e6:	76 0c                	jbe    8003f4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e8:	83 eb 01             	sub    $0x1,%ebx
  8003eb:	85 db                	test   %ebx,%ebx
  8003ed:	8d 76 00             	lea    0x0(%esi),%esi
  8003f0:	7f 61                	jg     800453 <printnum+0xa3>
  8003f2:	eb 70                	jmp    800464 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003f8:	83 eb 01             	sub    $0x1,%ebx
  8003fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800403:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800407:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80040b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80040e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800411:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800414:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800418:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80041f:	00 
  800420:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800423:	89 04 24             	mov    %eax,(%esp)
  800426:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800429:	89 54 24 04          	mov    %edx,0x4(%esp)
  80042d:	e8 8e 27 00 00       	call   802bc0 <__udivdi3>
  800432:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800435:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800438:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80043c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800440:	89 04 24             	mov    %eax,(%esp)
  800443:	89 54 24 04          	mov    %edx,0x4(%esp)
  800447:	89 f2                	mov    %esi,%edx
  800449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044c:	e8 5f ff ff ff       	call   8003b0 <printnum>
  800451:	eb 11                	jmp    800464 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800453:	89 74 24 04          	mov    %esi,0x4(%esp)
  800457:	89 3c 24             	mov    %edi,(%esp)
  80045a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045d:	83 eb 01             	sub    $0x1,%ebx
  800460:	85 db                	test   %ebx,%ebx
  800462:	7f ef                	jg     800453 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800464:	89 74 24 04          	mov    %esi,0x4(%esp)
  800468:	8b 74 24 04          	mov    0x4(%esp),%esi
  80046c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80046f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800473:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80047a:	00 
  80047b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80047e:	89 14 24             	mov    %edx,(%esp)
  800481:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800484:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800488:	e8 63 28 00 00       	call   802cf0 <__umoddi3>
  80048d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800491:	0f be 80 6e 2f 80 00 	movsbl 0x802f6e(%eax),%eax
  800498:	89 04 24             	mov    %eax,(%esp)
  80049b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80049e:	83 c4 4c             	add    $0x4c,%esp
  8004a1:	5b                   	pop    %ebx
  8004a2:	5e                   	pop    %esi
  8004a3:	5f                   	pop    %edi
  8004a4:	5d                   	pop    %ebp
  8004a5:	c3                   	ret    

008004a6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a9:	83 fa 01             	cmp    $0x1,%edx
  8004ac:	7e 0e                	jle    8004bc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004ae:	8b 10                	mov    (%eax),%edx
  8004b0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004b3:	89 08                	mov    %ecx,(%eax)
  8004b5:	8b 02                	mov    (%edx),%eax
  8004b7:	8b 52 04             	mov    0x4(%edx),%edx
  8004ba:	eb 22                	jmp    8004de <getuint+0x38>
	else if (lflag)
  8004bc:	85 d2                	test   %edx,%edx
  8004be:	74 10                	je     8004d0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004c0:	8b 10                	mov    (%eax),%edx
  8004c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004c5:	89 08                	mov    %ecx,(%eax)
  8004c7:	8b 02                	mov    (%edx),%eax
  8004c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ce:	eb 0e                	jmp    8004de <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004d0:	8b 10                	mov    (%eax),%edx
  8004d2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004d5:	89 08                	mov    %ecx,(%eax)
  8004d7:	8b 02                	mov    (%edx),%eax
  8004d9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004de:	5d                   	pop    %ebp
  8004df:	c3                   	ret    

008004e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ea:	8b 10                	mov    (%eax),%edx
  8004ec:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ef:	73 0a                	jae    8004fb <sprintputch+0x1b>
		*b->buf++ = ch;
  8004f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004f4:	88 0a                	mov    %cl,(%edx)
  8004f6:	83 c2 01             	add    $0x1,%edx
  8004f9:	89 10                	mov    %edx,(%eax)
}
  8004fb:	5d                   	pop    %ebp
  8004fc:	c3                   	ret    

008004fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	57                   	push   %edi
  800501:	56                   	push   %esi
  800502:	53                   	push   %ebx
  800503:	83 ec 5c             	sub    $0x5c,%esp
  800506:	8b 7d 08             	mov    0x8(%ebp),%edi
  800509:	8b 75 0c             	mov    0xc(%ebp),%esi
  80050c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80050f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800516:	eb 11                	jmp    800529 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800518:	85 c0                	test   %eax,%eax
  80051a:	0f 84 ec 03 00 00    	je     80090c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800520:	89 74 24 04          	mov    %esi,0x4(%esp)
  800524:	89 04 24             	mov    %eax,(%esp)
  800527:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800529:	0f b6 03             	movzbl (%ebx),%eax
  80052c:	83 c3 01             	add    $0x1,%ebx
  80052f:	83 f8 25             	cmp    $0x25,%eax
  800532:	75 e4                	jne    800518 <vprintfmt+0x1b>
  800534:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800538:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80053f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800546:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80054d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800552:	eb 06                	jmp    80055a <vprintfmt+0x5d>
  800554:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800558:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055a:	0f b6 13             	movzbl (%ebx),%edx
  80055d:	0f b6 c2             	movzbl %dl,%eax
  800560:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800563:	8d 43 01             	lea    0x1(%ebx),%eax
  800566:	83 ea 23             	sub    $0x23,%edx
  800569:	80 fa 55             	cmp    $0x55,%dl
  80056c:	0f 87 7d 03 00 00    	ja     8008ef <vprintfmt+0x3f2>
  800572:	0f b6 d2             	movzbl %dl,%edx
  800575:	ff 24 95 c0 30 80 00 	jmp    *0x8030c0(,%edx,4)
  80057c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800580:	eb d6                	jmp    800558 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800582:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800585:	83 ea 30             	sub    $0x30,%edx
  800588:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80058b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80058e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800591:	83 fb 09             	cmp    $0x9,%ebx
  800594:	77 4c                	ja     8005e2 <vprintfmt+0xe5>
  800596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800599:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80059c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80059f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005a2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8005a6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8005a9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8005ac:	83 fb 09             	cmp    $0x9,%ebx
  8005af:	76 eb                	jbe    80059c <vprintfmt+0x9f>
  8005b1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8005b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b7:	eb 29                	jmp    8005e2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b9:	8b 55 14             	mov    0x14(%ebp),%edx
  8005bc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8005bf:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8005c2:	8b 12                	mov    (%edx),%edx
  8005c4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8005c7:	eb 19                	jmp    8005e2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8005c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005cc:	c1 fa 1f             	sar    $0x1f,%edx
  8005cf:	f7 d2                	not    %edx
  8005d1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8005d4:	eb 82                	jmp    800558 <vprintfmt+0x5b>
  8005d6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8005dd:	e9 76 ff ff ff       	jmp    800558 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8005e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e6:	0f 89 6c ff ff ff    	jns    800558 <vprintfmt+0x5b>
  8005ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8005f5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005f8:	e9 5b ff ff ff       	jmp    800558 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005fd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800600:	e9 53 ff ff ff       	jmp    800558 <vprintfmt+0x5b>
  800605:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 50 04             	lea    0x4(%eax),%edx
  80060e:	89 55 14             	mov    %edx,0x14(%ebp)
  800611:	89 74 24 04          	mov    %esi,0x4(%esp)
  800615:	8b 00                	mov    (%eax),%eax
  800617:	89 04 24             	mov    %eax,(%esp)
  80061a:	ff d7                	call   *%edi
  80061c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80061f:	e9 05 ff ff ff       	jmp    800529 <vprintfmt+0x2c>
  800624:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 50 04             	lea    0x4(%eax),%edx
  80062d:	89 55 14             	mov    %edx,0x14(%ebp)
  800630:	8b 00                	mov    (%eax),%eax
  800632:	89 c2                	mov    %eax,%edx
  800634:	c1 fa 1f             	sar    $0x1f,%edx
  800637:	31 d0                	xor    %edx,%eax
  800639:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80063b:	83 f8 0f             	cmp    $0xf,%eax
  80063e:	7f 0b                	jg     80064b <vprintfmt+0x14e>
  800640:	8b 14 85 20 32 80 00 	mov    0x803220(,%eax,4),%edx
  800647:	85 d2                	test   %edx,%edx
  800649:	75 20                	jne    80066b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80064b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80064f:	c7 44 24 08 7f 2f 80 	movl   $0x802f7f,0x8(%esp)
  800656:	00 
  800657:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065b:	89 3c 24             	mov    %edi,(%esp)
  80065e:	e8 31 03 00 00       	call   800994 <printfmt>
  800663:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800666:	e9 be fe ff ff       	jmp    800529 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80066b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80066f:	c7 44 24 08 82 35 80 	movl   $0x803582,0x8(%esp)
  800676:	00 
  800677:	89 74 24 04          	mov    %esi,0x4(%esp)
  80067b:	89 3c 24             	mov    %edi,(%esp)
  80067e:	e8 11 03 00 00       	call   800994 <printfmt>
  800683:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800686:	e9 9e fe ff ff       	jmp    800529 <vprintfmt+0x2c>
  80068b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80068e:	89 c3                	mov    %eax,%ebx
  800690:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800696:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 50 04             	lea    0x4(%eax),%edx
  80069f:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	75 07                	jne    8006b2 <vprintfmt+0x1b5>
  8006ab:	c7 45 e0 88 2f 80 00 	movl   $0x802f88,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8006b2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006b6:	7e 06                	jle    8006be <vprintfmt+0x1c1>
  8006b8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006bc:	75 13                	jne    8006d1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	0f be 02             	movsbl (%edx),%eax
  8006c4:	85 c0                	test   %eax,%eax
  8006c6:	0f 85 99 00 00 00    	jne    800765 <vprintfmt+0x268>
  8006cc:	e9 86 00 00 00       	jmp    800757 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006d8:	89 0c 24             	mov    %ecx,(%esp)
  8006db:	e8 fb 02 00 00       	call   8009db <strnlen>
  8006e0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006e3:	29 c2                	sub    %eax,%edx
  8006e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006e8:	85 d2                	test   %edx,%edx
  8006ea:	7e d2                	jle    8006be <vprintfmt+0x1c1>
					putch(padc, putdat);
  8006ec:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8006f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006f3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8006f6:	89 d3                	mov    %edx,%ebx
  8006f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800704:	83 eb 01             	sub    $0x1,%ebx
  800707:	85 db                	test   %ebx,%ebx
  800709:	7f ed                	jg     8006f8 <vprintfmt+0x1fb>
  80070b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80070e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800715:	eb a7                	jmp    8006be <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800717:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80071b:	74 18                	je     800735 <vprintfmt+0x238>
  80071d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800720:	83 fa 5e             	cmp    $0x5e,%edx
  800723:	76 10                	jbe    800735 <vprintfmt+0x238>
					putch('?', putdat);
  800725:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800729:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800730:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800733:	eb 0a                	jmp    80073f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800735:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800739:	89 04 24             	mov    %eax,(%esp)
  80073c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800743:	0f be 03             	movsbl (%ebx),%eax
  800746:	85 c0                	test   %eax,%eax
  800748:	74 05                	je     80074f <vprintfmt+0x252>
  80074a:	83 c3 01             	add    $0x1,%ebx
  80074d:	eb 29                	jmp    800778 <vprintfmt+0x27b>
  80074f:	89 fe                	mov    %edi,%esi
  800751:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800754:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075b:	7f 2e                	jg     80078b <vprintfmt+0x28e>
  80075d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800760:	e9 c4 fd ff ff       	jmp    800529 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800765:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800768:	83 c2 01             	add    $0x1,%edx
  80076b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80076e:	89 f7                	mov    %esi,%edi
  800770:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800773:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800776:	89 d3                	mov    %edx,%ebx
  800778:	85 f6                	test   %esi,%esi
  80077a:	78 9b                	js     800717 <vprintfmt+0x21a>
  80077c:	83 ee 01             	sub    $0x1,%esi
  80077f:	79 96                	jns    800717 <vprintfmt+0x21a>
  800781:	89 fe                	mov    %edi,%esi
  800783:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800786:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800789:	eb cc                	jmp    800757 <vprintfmt+0x25a>
  80078b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80078e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800791:	89 74 24 04          	mov    %esi,0x4(%esp)
  800795:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80079c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	83 eb 01             	sub    $0x1,%ebx
  8007a1:	85 db                	test   %ebx,%ebx
  8007a3:	7f ec                	jg     800791 <vprintfmt+0x294>
  8007a5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8007a8:	e9 7c fd ff ff       	jmp    800529 <vprintfmt+0x2c>
  8007ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007b0:	83 f9 01             	cmp    $0x1,%ecx
  8007b3:	7e 16                	jle    8007cb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 50 08             	lea    0x8(%eax),%edx
  8007bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8007be:	8b 10                	mov    (%eax),%edx
  8007c0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8007c6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007c9:	eb 32                	jmp    8007fd <vprintfmt+0x300>
	else if (lflag)
  8007cb:	85 c9                	test   %ecx,%ecx
  8007cd:	74 18                	je     8007e7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 50 04             	lea    0x4(%eax),%edx
  8007d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dd:	89 c1                	mov    %eax,%ecx
  8007df:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007e5:	eb 16                	jmp    8007fd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f5:	89 c2                	mov    %eax,%edx
  8007f7:	c1 fa 1f             	sar    $0x1f,%edx
  8007fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007fd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800800:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800803:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800808:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80080c:	0f 89 9b 00 00 00    	jns    8008ad <vprintfmt+0x3b0>
				putch('-', putdat);
  800812:	89 74 24 04          	mov    %esi,0x4(%esp)
  800816:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80081d:	ff d7                	call   *%edi
				num = -(long long) num;
  80081f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800822:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800825:	f7 d9                	neg    %ecx
  800827:	83 d3 00             	adc    $0x0,%ebx
  80082a:	f7 db                	neg    %ebx
  80082c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800831:	eb 7a                	jmp    8008ad <vprintfmt+0x3b0>
  800833:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800836:	89 ca                	mov    %ecx,%edx
  800838:	8d 45 14             	lea    0x14(%ebp),%eax
  80083b:	e8 66 fc ff ff       	call   8004a6 <getuint>
  800840:	89 c1                	mov    %eax,%ecx
  800842:	89 d3                	mov    %edx,%ebx
  800844:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800849:	eb 62                	jmp    8008ad <vprintfmt+0x3b0>
  80084b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80084e:	89 ca                	mov    %ecx,%edx
  800850:	8d 45 14             	lea    0x14(%ebp),%eax
  800853:	e8 4e fc ff ff       	call   8004a6 <getuint>
  800858:	89 c1                	mov    %eax,%ecx
  80085a:	89 d3                	mov    %edx,%ebx
  80085c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800861:	eb 4a                	jmp    8008ad <vprintfmt+0x3b0>
  800863:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800866:	89 74 24 04          	mov    %esi,0x4(%esp)
  80086a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800871:	ff d7                	call   *%edi
			putch('x', putdat);
  800873:	89 74 24 04          	mov    %esi,0x4(%esp)
  800877:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80087e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	8d 50 04             	lea    0x4(%eax),%edx
  800886:	89 55 14             	mov    %edx,0x14(%ebp)
  800889:	8b 08                	mov    (%eax),%ecx
  80088b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800890:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800895:	eb 16                	jmp    8008ad <vprintfmt+0x3b0>
  800897:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089a:	89 ca                	mov    %ecx,%edx
  80089c:	8d 45 14             	lea    0x14(%ebp),%eax
  80089f:	e8 02 fc ff ff       	call   8004a6 <getuint>
  8008a4:	89 c1                	mov    %eax,%ecx
  8008a6:	89 d3                	mov    %edx,%ebx
  8008a8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008ad:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8008b1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8008b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008b8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c0:	89 0c 24             	mov    %ecx,(%esp)
  8008c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008c7:	89 f2                	mov    %esi,%edx
  8008c9:	89 f8                	mov    %edi,%eax
  8008cb:	e8 e0 fa ff ff       	call   8003b0 <printnum>
  8008d0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8008d3:	e9 51 fc ff ff       	jmp    800529 <vprintfmt+0x2c>
  8008d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8008db:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008e2:	89 14 24             	mov    %edx,(%esp)
  8008e5:	ff d7                	call   *%edi
  8008e7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8008ea:	e9 3a fc ff ff       	jmp    800529 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008f3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008fa:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8008ff:	80 38 25             	cmpb   $0x25,(%eax)
  800902:	0f 84 21 fc ff ff    	je     800529 <vprintfmt+0x2c>
  800908:	89 c3                	mov    %eax,%ebx
  80090a:	eb f0                	jmp    8008fc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80090c:	83 c4 5c             	add    $0x5c,%esp
  80090f:	5b                   	pop    %ebx
  800910:	5e                   	pop    %esi
  800911:	5f                   	pop    %edi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	83 ec 28             	sub    $0x28,%esp
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800920:	85 c0                	test   %eax,%eax
  800922:	74 04                	je     800928 <vsnprintf+0x14>
  800924:	85 d2                	test   %edx,%edx
  800926:	7f 07                	jg     80092f <vsnprintf+0x1b>
  800928:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80092d:	eb 3b                	jmp    80096a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800932:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800936:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800939:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800947:	8b 45 10             	mov    0x10(%ebp),%eax
  80094a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800951:	89 44 24 04          	mov    %eax,0x4(%esp)
  800955:	c7 04 24 e0 04 80 00 	movl   $0x8004e0,(%esp)
  80095c:	e8 9c fb ff ff       	call   8004fd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800964:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800967:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    

0080096c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800972:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800975:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800979:	8b 45 10             	mov    0x10(%ebp),%eax
  80097c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800980:	8b 45 0c             	mov    0xc(%ebp),%eax
  800983:	89 44 24 04          	mov    %eax,0x4(%esp)
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	89 04 24             	mov    %eax,(%esp)
  80098d:	e8 82 ff ff ff       	call   800914 <vsnprintf>
	va_end(ap);

	return rc;
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80099a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80099d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	89 04 24             	mov    %eax,(%esp)
  8009b5:	e8 43 fb ff ff       	call   8004fd <vprintfmt>
	va_end(ap);
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    
  8009bc:	00 00                	add    %al,(%eax)
	...

008009c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cb:	80 3a 00             	cmpb   $0x0,(%edx)
  8009ce:	74 09                	je     8009d9 <strlen+0x19>
		n++;
  8009d0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009d7:	75 f7                	jne    8009d0 <strlen+0x10>
		n++;
	return n;
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	53                   	push   %ebx
  8009df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e5:	85 c9                	test   %ecx,%ecx
  8009e7:	74 19                	je     800a02 <strnlen+0x27>
  8009e9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009ec:	74 14                	je     800a02 <strnlen+0x27>
  8009ee:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8009f3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f6:	39 c8                	cmp    %ecx,%eax
  8009f8:	74 0d                	je     800a07 <strnlen+0x2c>
  8009fa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8009fe:	75 f3                	jne    8009f3 <strnlen+0x18>
  800a00:	eb 05                	jmp    800a07 <strnlen+0x2c>
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800a07:	5b                   	pop    %ebx
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	53                   	push   %ebx
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a14:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a19:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a1d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a20:	83 c2 01             	add    $0x1,%edx
  800a23:	84 c9                	test   %cl,%cl
  800a25:	75 f2                	jne    800a19 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a27:	5b                   	pop    %ebx
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	56                   	push   %esi
  800a2e:	53                   	push   %ebx
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a35:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a38:	85 f6                	test   %esi,%esi
  800a3a:	74 18                	je     800a54 <strncpy+0x2a>
  800a3c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a41:	0f b6 1a             	movzbl (%edx),%ebx
  800a44:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a47:	80 3a 01             	cmpb   $0x1,(%edx)
  800a4a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	39 ce                	cmp    %ecx,%esi
  800a52:	77 ed                	ja     800a41 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a54:	5b                   	pop    %ebx
  800a55:	5e                   	pop    %esi
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    

00800a58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	56                   	push   %esi
  800a5c:	53                   	push   %ebx
  800a5d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a66:	89 f0                	mov    %esi,%eax
  800a68:	85 c9                	test   %ecx,%ecx
  800a6a:	74 27                	je     800a93 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a6c:	83 e9 01             	sub    $0x1,%ecx
  800a6f:	74 1d                	je     800a8e <strlcpy+0x36>
  800a71:	0f b6 1a             	movzbl (%edx),%ebx
  800a74:	84 db                	test   %bl,%bl
  800a76:	74 16                	je     800a8e <strlcpy+0x36>
			*dst++ = *src++;
  800a78:	88 18                	mov    %bl,(%eax)
  800a7a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a7d:	83 e9 01             	sub    $0x1,%ecx
  800a80:	74 0e                	je     800a90 <strlcpy+0x38>
			*dst++ = *src++;
  800a82:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a85:	0f b6 1a             	movzbl (%edx),%ebx
  800a88:	84 db                	test   %bl,%bl
  800a8a:	75 ec                	jne    800a78 <strlcpy+0x20>
  800a8c:	eb 02                	jmp    800a90 <strlcpy+0x38>
  800a8e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a90:	c6 00 00             	movb   $0x0,(%eax)
  800a93:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a95:	5b                   	pop    %ebx
  800a96:	5e                   	pop    %esi
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    

00800a99 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aa2:	0f b6 01             	movzbl (%ecx),%eax
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 15                	je     800abe <strcmp+0x25>
  800aa9:	3a 02                	cmp    (%edx),%al
  800aab:	75 11                	jne    800abe <strcmp+0x25>
		p++, q++;
  800aad:	83 c1 01             	add    $0x1,%ecx
  800ab0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ab3:	0f b6 01             	movzbl (%ecx),%eax
  800ab6:	84 c0                	test   %al,%al
  800ab8:	74 04                	je     800abe <strcmp+0x25>
  800aba:	3a 02                	cmp    (%edx),%al
  800abc:	74 ef                	je     800aad <strcmp+0x14>
  800abe:	0f b6 c0             	movzbl %al,%eax
  800ac1:	0f b6 12             	movzbl (%edx),%edx
  800ac4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	53                   	push   %ebx
  800acc:	8b 55 08             	mov    0x8(%ebp),%edx
  800acf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800ad5:	85 c0                	test   %eax,%eax
  800ad7:	74 23                	je     800afc <strncmp+0x34>
  800ad9:	0f b6 1a             	movzbl (%edx),%ebx
  800adc:	84 db                	test   %bl,%bl
  800ade:	74 24                	je     800b04 <strncmp+0x3c>
  800ae0:	3a 19                	cmp    (%ecx),%bl
  800ae2:	75 20                	jne    800b04 <strncmp+0x3c>
  800ae4:	83 e8 01             	sub    $0x1,%eax
  800ae7:	74 13                	je     800afc <strncmp+0x34>
		n--, p++, q++;
  800ae9:	83 c2 01             	add    $0x1,%edx
  800aec:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800aef:	0f b6 1a             	movzbl (%edx),%ebx
  800af2:	84 db                	test   %bl,%bl
  800af4:	74 0e                	je     800b04 <strncmp+0x3c>
  800af6:	3a 19                	cmp    (%ecx),%bl
  800af8:	74 ea                	je     800ae4 <strncmp+0x1c>
  800afa:	eb 08                	jmp    800b04 <strncmp+0x3c>
  800afc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b01:	5b                   	pop    %ebx
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b04:	0f b6 02             	movzbl (%edx),%eax
  800b07:	0f b6 11             	movzbl (%ecx),%edx
  800b0a:	29 d0                	sub    %edx,%eax
  800b0c:	eb f3                	jmp    800b01 <strncmp+0x39>

00800b0e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b18:	0f b6 10             	movzbl (%eax),%edx
  800b1b:	84 d2                	test   %dl,%dl
  800b1d:	74 15                	je     800b34 <strchr+0x26>
		if (*s == c)
  800b1f:	38 ca                	cmp    %cl,%dl
  800b21:	75 07                	jne    800b2a <strchr+0x1c>
  800b23:	eb 14                	jmp    800b39 <strchr+0x2b>
  800b25:	38 ca                	cmp    %cl,%dl
  800b27:	90                   	nop
  800b28:	74 0f                	je     800b39 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b2a:	83 c0 01             	add    $0x1,%eax
  800b2d:	0f b6 10             	movzbl (%eax),%edx
  800b30:	84 d2                	test   %dl,%dl
  800b32:	75 f1                	jne    800b25 <strchr+0x17>
  800b34:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b45:	0f b6 10             	movzbl (%eax),%edx
  800b48:	84 d2                	test   %dl,%dl
  800b4a:	74 18                	je     800b64 <strfind+0x29>
		if (*s == c)
  800b4c:	38 ca                	cmp    %cl,%dl
  800b4e:	75 0a                	jne    800b5a <strfind+0x1f>
  800b50:	eb 12                	jmp    800b64 <strfind+0x29>
  800b52:	38 ca                	cmp    %cl,%dl
  800b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b58:	74 0a                	je     800b64 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	0f b6 10             	movzbl (%eax),%edx
  800b60:	84 d2                	test   %dl,%dl
  800b62:	75 ee                	jne    800b52 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 0c             	sub    $0xc,%esp
  800b6c:	89 1c 24             	mov    %ebx,(%esp)
  800b6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b73:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b77:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b80:	85 c9                	test   %ecx,%ecx
  800b82:	74 30                	je     800bb4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b84:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b8a:	75 25                	jne    800bb1 <memset+0x4b>
  800b8c:	f6 c1 03             	test   $0x3,%cl
  800b8f:	75 20                	jne    800bb1 <memset+0x4b>
		c &= 0xFF;
  800b91:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b94:	89 d3                	mov    %edx,%ebx
  800b96:	c1 e3 08             	shl    $0x8,%ebx
  800b99:	89 d6                	mov    %edx,%esi
  800b9b:	c1 e6 18             	shl    $0x18,%esi
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	c1 e0 10             	shl    $0x10,%eax
  800ba3:	09 f0                	or     %esi,%eax
  800ba5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ba7:	09 d8                	or     %ebx,%eax
  800ba9:	c1 e9 02             	shr    $0x2,%ecx
  800bac:	fc                   	cld    
  800bad:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800baf:	eb 03                	jmp    800bb4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bb1:	fc                   	cld    
  800bb2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bb4:	89 f8                	mov    %edi,%eax
  800bb6:	8b 1c 24             	mov    (%esp),%ebx
  800bb9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bbd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bc1:	89 ec                	mov    %ebp,%esp
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 08             	sub    $0x8,%esp
  800bcb:	89 34 24             	mov    %esi,(%esp)
  800bce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800bd8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800bdb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800bdd:	39 c6                	cmp    %eax,%esi
  800bdf:	73 35                	jae    800c16 <memmove+0x51>
  800be1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be4:	39 d0                	cmp    %edx,%eax
  800be6:	73 2e                	jae    800c16 <memmove+0x51>
		s += n;
		d += n;
  800be8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bea:	f6 c2 03             	test   $0x3,%dl
  800bed:	75 1b                	jne    800c0a <memmove+0x45>
  800bef:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bf5:	75 13                	jne    800c0a <memmove+0x45>
  800bf7:	f6 c1 03             	test   $0x3,%cl
  800bfa:	75 0e                	jne    800c0a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800bfc:	83 ef 04             	sub    $0x4,%edi
  800bff:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c02:	c1 e9 02             	shr    $0x2,%ecx
  800c05:	fd                   	std    
  800c06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c08:	eb 09                	jmp    800c13 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c0a:	83 ef 01             	sub    $0x1,%edi
  800c0d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800c10:	fd                   	std    
  800c11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c13:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c14:	eb 20                	jmp    800c36 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c1c:	75 15                	jne    800c33 <memmove+0x6e>
  800c1e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c24:	75 0d                	jne    800c33 <memmove+0x6e>
  800c26:	f6 c1 03             	test   $0x3,%cl
  800c29:	75 08                	jne    800c33 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800c2b:	c1 e9 02             	shr    $0x2,%ecx
  800c2e:	fc                   	cld    
  800c2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c31:	eb 03                	jmp    800c36 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c33:	fc                   	cld    
  800c34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c36:	8b 34 24             	mov    (%esp),%esi
  800c39:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c3d:	89 ec                	mov    %ebp,%esp
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    

00800c41 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 04 24             	mov    %eax,(%esp)
  800c5b:	e8 65 ff ff ff       	call   800bc5 <memmove>
}
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	8b 75 08             	mov    0x8(%ebp),%esi
  800c6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c71:	85 c9                	test   %ecx,%ecx
  800c73:	74 36                	je     800cab <memcmp+0x49>
		if (*s1 != *s2)
  800c75:	0f b6 06             	movzbl (%esi),%eax
  800c78:	0f b6 1f             	movzbl (%edi),%ebx
  800c7b:	38 d8                	cmp    %bl,%al
  800c7d:	74 20                	je     800c9f <memcmp+0x3d>
  800c7f:	eb 14                	jmp    800c95 <memcmp+0x33>
  800c81:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c86:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c8b:	83 c2 01             	add    $0x1,%edx
  800c8e:	83 e9 01             	sub    $0x1,%ecx
  800c91:	38 d8                	cmp    %bl,%al
  800c93:	74 12                	je     800ca7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c95:	0f b6 c0             	movzbl %al,%eax
  800c98:	0f b6 db             	movzbl %bl,%ebx
  800c9b:	29 d8                	sub    %ebx,%eax
  800c9d:	eb 11                	jmp    800cb0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c9f:	83 e9 01             	sub    $0x1,%ecx
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca7:	85 c9                	test   %ecx,%ecx
  800ca9:	75 d6                	jne    800c81 <memcmp+0x1f>
  800cab:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800cbb:	89 c2                	mov    %eax,%edx
  800cbd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cc0:	39 d0                	cmp    %edx,%eax
  800cc2:	73 15                	jae    800cd9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800cc8:	38 08                	cmp    %cl,(%eax)
  800cca:	75 06                	jne    800cd2 <memfind+0x1d>
  800ccc:	eb 0b                	jmp    800cd9 <memfind+0x24>
  800cce:	38 08                	cmp    %cl,(%eax)
  800cd0:	74 07                	je     800cd9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cd2:	83 c0 01             	add    $0x1,%eax
  800cd5:	39 c2                	cmp    %eax,%edx
  800cd7:	77 f5                	ja     800cce <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 04             	sub    $0x4,%esp
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cea:	0f b6 02             	movzbl (%edx),%eax
  800ced:	3c 20                	cmp    $0x20,%al
  800cef:	74 04                	je     800cf5 <strtol+0x1a>
  800cf1:	3c 09                	cmp    $0x9,%al
  800cf3:	75 0e                	jne    800d03 <strtol+0x28>
		s++;
  800cf5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cf8:	0f b6 02             	movzbl (%edx),%eax
  800cfb:	3c 20                	cmp    $0x20,%al
  800cfd:	74 f6                	je     800cf5 <strtol+0x1a>
  800cff:	3c 09                	cmp    $0x9,%al
  800d01:	74 f2                	je     800cf5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d03:	3c 2b                	cmp    $0x2b,%al
  800d05:	75 0c                	jne    800d13 <strtol+0x38>
		s++;
  800d07:	83 c2 01             	add    $0x1,%edx
  800d0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d11:	eb 15                	jmp    800d28 <strtol+0x4d>
	else if (*s == '-')
  800d13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d1a:	3c 2d                	cmp    $0x2d,%al
  800d1c:	75 0a                	jne    800d28 <strtol+0x4d>
		s++, neg = 1;
  800d1e:	83 c2 01             	add    $0x1,%edx
  800d21:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d28:	85 db                	test   %ebx,%ebx
  800d2a:	0f 94 c0             	sete   %al
  800d2d:	74 05                	je     800d34 <strtol+0x59>
  800d2f:	83 fb 10             	cmp    $0x10,%ebx
  800d32:	75 18                	jne    800d4c <strtol+0x71>
  800d34:	80 3a 30             	cmpb   $0x30,(%edx)
  800d37:	75 13                	jne    800d4c <strtol+0x71>
  800d39:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d3d:	8d 76 00             	lea    0x0(%esi),%esi
  800d40:	75 0a                	jne    800d4c <strtol+0x71>
		s += 2, base = 16;
  800d42:	83 c2 02             	add    $0x2,%edx
  800d45:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d4a:	eb 15                	jmp    800d61 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d4c:	84 c0                	test   %al,%al
  800d4e:	66 90                	xchg   %ax,%ax
  800d50:	74 0f                	je     800d61 <strtol+0x86>
  800d52:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d57:	80 3a 30             	cmpb   $0x30,(%edx)
  800d5a:	75 05                	jne    800d61 <strtol+0x86>
		s++, base = 8;
  800d5c:	83 c2 01             	add    $0x1,%edx
  800d5f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d68:	0f b6 0a             	movzbl (%edx),%ecx
  800d6b:	89 cf                	mov    %ecx,%edi
  800d6d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d70:	80 fb 09             	cmp    $0x9,%bl
  800d73:	77 08                	ja     800d7d <strtol+0xa2>
			dig = *s - '0';
  800d75:	0f be c9             	movsbl %cl,%ecx
  800d78:	83 e9 30             	sub    $0x30,%ecx
  800d7b:	eb 1e                	jmp    800d9b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d7d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d80:	80 fb 19             	cmp    $0x19,%bl
  800d83:	77 08                	ja     800d8d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d85:	0f be c9             	movsbl %cl,%ecx
  800d88:	83 e9 57             	sub    $0x57,%ecx
  800d8b:	eb 0e                	jmp    800d9b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d8d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d90:	80 fb 19             	cmp    $0x19,%bl
  800d93:	77 15                	ja     800daa <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d95:	0f be c9             	movsbl %cl,%ecx
  800d98:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d9b:	39 f1                	cmp    %esi,%ecx
  800d9d:	7d 0b                	jge    800daa <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d9f:	83 c2 01             	add    $0x1,%edx
  800da2:	0f af c6             	imul   %esi,%eax
  800da5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800da8:	eb be                	jmp    800d68 <strtol+0x8d>
  800daa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800dac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db0:	74 05                	je     800db7 <strtol+0xdc>
		*endptr = (char *) s;
  800db2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800db5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800db7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dbb:	74 04                	je     800dc1 <strtol+0xe6>
  800dbd:	89 c8                	mov    %ecx,%eax
  800dbf:	f7 d8                	neg    %eax
}
  800dc1:	83 c4 04             	add    $0x4,%esp
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    
  800dc9:	00 00                	add    %al,(%eax)
	...

00800dcc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	89 1c 24             	mov    %ebx,(%esp)
  800dd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dd9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddd:	ba 00 00 00 00       	mov    $0x0,%edx
  800de2:	b8 01 00 00 00       	mov    $0x1,%eax
  800de7:	89 d1                	mov    %edx,%ecx
  800de9:	89 d3                	mov    %edx,%ebx
  800deb:	89 d7                	mov    %edx,%edi
  800ded:	89 d6                	mov    %edx,%esi
  800def:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800df1:	8b 1c 24             	mov    (%esp),%ebx
  800df4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800df8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dfc:	89 ec                	mov    %ebp,%esp
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	89 1c 24             	mov    %ebx,(%esp)
  800e09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	89 c3                	mov    %eax,%ebx
  800e1e:	89 c7                	mov    %eax,%edi
  800e20:	89 c6                	mov    %eax,%esi
  800e22:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e24:	8b 1c 24             	mov    (%esp),%ebx
  800e27:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e2b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e2f:	89 ec                	mov    %ebp,%esp
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 38             	sub    $0x38,%esp
  800e39:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e3c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e3f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e42:	be 00 00 00 00       	mov    $0x0,%esi
  800e47:	b8 12 00 00 00       	mov    $0x12,%eax
  800e4c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7e 28                	jle    800e86 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e62:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800e69:	00 
  800e6a:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  800e71:	00 
  800e72:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e79:	00 
  800e7a:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  800e81:	e8 06 f4 ff ff       	call   80028c <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800e86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e89:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e8c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e8f:	89 ec                	mov    %ebp,%esp
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	89 1c 24             	mov    %ebx,(%esp)
  800e9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ea0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea9:	b8 11 00 00 00       	mov    $0x11,%eax
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	89 df                	mov    %ebx,%edi
  800eb6:	89 de                	mov    %ebx,%esi
  800eb8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800eba:	8b 1c 24             	mov    (%esp),%ebx
  800ebd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ec1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ec5:	89 ec                	mov    %ebp,%esp
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 0c             	sub    $0xc,%esp
  800ecf:	89 1c 24             	mov    %ebx,(%esp)
  800ed2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ed6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800edf:	b8 10 00 00 00       	mov    $0x10,%eax
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	89 cb                	mov    %ecx,%ebx
  800ee9:	89 cf                	mov    %ecx,%edi
  800eeb:	89 ce                	mov    %ecx,%esi
  800eed:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800eef:	8b 1c 24             	mov    (%esp),%ebx
  800ef2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ef6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800efa:	89 ec                	mov    %ebp,%esp
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    

00800efe <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 38             	sub    $0x38,%esp
  800f04:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f07:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f12:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	89 df                	mov    %ebx,%edi
  800f1f:	89 de                	mov    %ebx,%esi
  800f21:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f23:	85 c0                	test   %eax,%eax
  800f25:	7e 28                	jle    800f4f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f32:	00 
  800f33:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  800f3a:	00 
  800f3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f42:	00 
  800f43:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  800f4a:	e8 3d f3 ff ff       	call   80028c <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800f4f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f52:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f55:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f58:	89 ec                	mov    %ebp,%esp
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	89 1c 24             	mov    %ebx,(%esp)
  800f65:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f69:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f72:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f77:	89 d1                	mov    %edx,%ecx
  800f79:	89 d3                	mov    %edx,%ebx
  800f7b:	89 d7                	mov    %edx,%edi
  800f7d:	89 d6                	mov    %edx,%esi
  800f7f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800f81:	8b 1c 24             	mov    (%esp),%ebx
  800f84:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f88:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f8c:	89 ec                	mov    %ebp,%esp
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	83 ec 38             	sub    $0x38,%esp
  800f96:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f99:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f9c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fac:	89 cb                	mov    %ecx,%ebx
  800fae:	89 cf                	mov    %ecx,%edi
  800fb0:	89 ce                	mov    %ecx,%esi
  800fb2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7e 28                	jle    800fe0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbc:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fc3:	00 
  800fc4:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd3:	00 
  800fd4:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  800fdb:	e8 ac f2 ff ff       	call   80028c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fe0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe9:	89 ec                	mov    %ebp,%esp
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 0c             	sub    $0xc,%esp
  800ff3:	89 1c 24             	mov    %ebx,(%esp)
  800ff6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ffa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffe:	be 00 00 00 00       	mov    $0x0,%esi
  801003:	b8 0c 00 00 00       	mov    $0xc,%eax
  801008:	8b 7d 14             	mov    0x14(%ebp),%edi
  80100b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801016:	8b 1c 24             	mov    (%esp),%ebx
  801019:	8b 74 24 04          	mov    0x4(%esp),%esi
  80101d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801021:	89 ec                	mov    %ebp,%esp
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 38             	sub    $0x38,%esp
  80102b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80102e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801031:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801034:	bb 00 00 00 00       	mov    $0x0,%ebx
  801039:	b8 0a 00 00 00       	mov    $0xa,%eax
  80103e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
  801044:	89 df                	mov    %ebx,%edi
  801046:	89 de                	mov    %ebx,%esi
  801048:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80104a:	85 c0                	test   %eax,%eax
  80104c:	7e 28                	jle    801076 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801052:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801059:	00 
  80105a:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  801061:	00 
  801062:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801069:	00 
  80106a:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  801071:	e8 16 f2 ff ff       	call   80028c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801076:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801079:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80107c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80107f:	89 ec                	mov    %ebp,%esp
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 38             	sub    $0x38,%esp
  801089:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80108c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80108f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801092:	bb 00 00 00 00       	mov    $0x0,%ebx
  801097:	b8 09 00 00 00       	mov    $0x9,%eax
  80109c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109f:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a2:	89 df                	mov    %ebx,%edi
  8010a4:	89 de                	mov    %ebx,%esi
  8010a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	7e 28                	jle    8010d4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010b7:	00 
  8010b8:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  8010bf:	00 
  8010c0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c7:	00 
  8010c8:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  8010cf:	e8 b8 f1 ff ff       	call   80028c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010d4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010da:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010dd:	89 ec                	mov    %ebp,%esp
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    

008010e1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	83 ec 38             	sub    $0x38,%esp
  8010e7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ea:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ed:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8010fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	89 df                	mov    %ebx,%edi
  801102:	89 de                	mov    %ebx,%esi
  801104:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801106:	85 c0                	test   %eax,%eax
  801108:	7e 28                	jle    801132 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801115:	00 
  801116:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  80111d:	00 
  80111e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801125:	00 
  801126:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  80112d:	e8 5a f1 ff ff       	call   80028c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801132:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801135:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801138:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80113b:	89 ec                	mov    %ebp,%esp
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 38             	sub    $0x38,%esp
  801145:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801148:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80114b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801153:	b8 06 00 00 00       	mov    $0x6,%eax
  801158:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	89 df                	mov    %ebx,%edi
  801160:	89 de                	mov    %ebx,%esi
  801162:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801164:	85 c0                	test   %eax,%eax
  801166:	7e 28                	jle    801190 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801168:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801173:	00 
  801174:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  80117b:	00 
  80117c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801183:	00 
  801184:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  80118b:	e8 fc f0 ff ff       	call   80028c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801190:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801193:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801196:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801199:	89 ec                	mov    %ebp,%esp
  80119b:	5d                   	pop    %ebp
  80119c:	c3                   	ret    

0080119d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 38             	sub    $0x38,%esp
  8011a3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011a6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011a9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8011b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8011b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	7e 28                	jle    8011ee <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ca:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011d1:	00 
  8011d2:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  8011d9:	00 
  8011da:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011e1:	00 
  8011e2:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  8011e9:	e8 9e f0 ff ff       	call   80028c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011f7:	89 ec                	mov    %ebp,%esp
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    

008011fb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	83 ec 38             	sub    $0x38,%esp
  801201:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801204:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801207:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120a:	be 00 00 00 00       	mov    $0x0,%esi
  80120f:	b8 04 00 00 00       	mov    $0x4,%eax
  801214:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121a:	8b 55 08             	mov    0x8(%ebp),%edx
  80121d:	89 f7                	mov    %esi,%edi
  80121f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801221:	85 c0                	test   %eax,%eax
  801223:	7e 28                	jle    80124d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801225:	89 44 24 10          	mov    %eax,0x10(%esp)
  801229:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801230:	00 
  801231:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  801238:	00 
  801239:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801240:	00 
  801241:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  801248:	e8 3f f0 ff ff       	call   80028c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80124d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801250:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801253:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801256:	89 ec                	mov    %ebp,%esp
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	89 1c 24             	mov    %ebx,(%esp)
  801263:	89 74 24 04          	mov    %esi,0x4(%esp)
  801267:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126b:	ba 00 00 00 00       	mov    $0x0,%edx
  801270:	b8 0b 00 00 00       	mov    $0xb,%eax
  801275:	89 d1                	mov    %edx,%ecx
  801277:	89 d3                	mov    %edx,%ebx
  801279:	89 d7                	mov    %edx,%edi
  80127b:	89 d6                	mov    %edx,%esi
  80127d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80127f:	8b 1c 24             	mov    (%esp),%ebx
  801282:	8b 74 24 04          	mov    0x4(%esp),%esi
  801286:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80128a:	89 ec                	mov    %ebp,%esp
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    

0080128e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 0c             	sub    $0xc,%esp
  801294:	89 1c 24             	mov    %ebx,(%esp)
  801297:	89 74 24 04          	mov    %esi,0x4(%esp)
  80129b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129f:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8012a9:	89 d1                	mov    %edx,%ecx
  8012ab:	89 d3                	mov    %edx,%ebx
  8012ad:	89 d7                	mov    %edx,%edi
  8012af:	89 d6                	mov    %edx,%esi
  8012b1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012b3:	8b 1c 24             	mov    (%esp),%ebx
  8012b6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012ba:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012be:	89 ec                	mov    %ebp,%esp
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    

008012c2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	83 ec 38             	sub    $0x38,%esp
  8012c8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012cb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012ce:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012d6:	b8 03 00 00 00       	mov    $0x3,%eax
  8012db:	8b 55 08             	mov    0x8(%ebp),%edx
  8012de:	89 cb                	mov    %ecx,%ebx
  8012e0:	89 cf                	mov    %ecx,%edi
  8012e2:	89 ce                	mov    %ecx,%esi
  8012e4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	7e 28                	jle    801312 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ee:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8012f5:	00 
  8012f6:	c7 44 24 08 7f 32 80 	movl   $0x80327f,0x8(%esp)
  8012fd:	00 
  8012fe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801305:	00 
  801306:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  80130d:	e8 7a ef ff ff       	call   80028c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801312:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801315:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801318:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80131b:	89 ec                	mov    %ebp,%esp
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    
	...

00801320 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801326:	c7 44 24 08 aa 32 80 	movl   $0x8032aa,0x8(%esp)
  80132d:	00 
  80132e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801335:	00 
  801336:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  80133d:	e8 4a ef ff ff       	call   80028c <_panic>

00801342 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	53                   	push   %ebx
  801346:	83 ec 24             	sub    $0x24,%esp
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80134c:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80134e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801352:	75 1c                	jne    801370 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801354:	c7 44 24 08 cc 32 80 	movl   $0x8032cc,0x8(%esp)
  80135b:	00 
  80135c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801363:	00 
  801364:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  80136b:	e8 1c ef ff ff       	call   80028c <_panic>
	}
	pte = vpt[VPN(addr)];
  801370:	89 d8                	mov    %ebx,%eax
  801372:	c1 e8 0c             	shr    $0xc,%eax
  801375:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  80137c:	f6 c4 08             	test   $0x8,%ah
  80137f:	75 1c                	jne    80139d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801381:	c7 44 24 08 10 33 80 	movl   $0x803310,0x8(%esp)
  801388:	00 
  801389:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801390:	00 
  801391:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  801398:	e8 ef ee ff ff       	call   80028c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80139d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013a4:	00 
  8013a5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013ac:	00 
  8013ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013b4:	e8 42 fe ff ff       	call   8011fb <sys_page_alloc>
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	79 20                	jns    8013dd <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  8013bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013c1:	c7 44 24 08 5c 33 80 	movl   $0x80335c,0x8(%esp)
  8013c8:	00 
  8013c9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8013d0:	00 
  8013d1:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  8013d8:	e8 af ee ff ff       	call   80028c <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  8013dd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8013e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013ea:	00 
  8013eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013ef:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8013f6:	e8 ca f7 ff ff       	call   800bc5 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  8013fb:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801402:	00 
  801403:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801407:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80140e:	00 
  80140f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801416:	00 
  801417:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80141e:	e8 7a fd ff ff       	call   80119d <sys_page_map>
  801423:	85 c0                	test   %eax,%eax
  801425:	79 20                	jns    801447 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  801427:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80142b:	c7 44 24 08 98 33 80 	movl   $0x803398,0x8(%esp)
  801432:	00 
  801433:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80143a:	00 
  80143b:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  801442:	e8 45 ee ff ff       	call   80028c <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801447:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80144e:	00 
  80144f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801456:	e8 e4 fc ff ff       	call   80113f <sys_page_unmap>
  80145b:	85 c0                	test   %eax,%eax
  80145d:	79 20                	jns    80147f <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80145f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801463:	c7 44 24 08 d0 33 80 	movl   $0x8033d0,0x8(%esp)
  80146a:	00 
  80146b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801472:	00 
  801473:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  80147a:	e8 0d ee ff ff       	call   80028c <_panic>
	// panic("pgfault not implemented");
}
  80147f:	83 c4 24             	add    $0x24,%esp
  801482:	5b                   	pop    %ebx
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	57                   	push   %edi
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80148e:	c7 04 24 42 13 80 00 	movl   $0x801342,(%esp)
  801495:	e8 62 16 00 00       	call   802afc <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80149a:	ba 07 00 00 00       	mov    $0x7,%edx
  80149f:	89 d0                	mov    %edx,%eax
  8014a1:	cd 30                	int    $0x30
  8014a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	0f 88 21 02 00 00    	js     8016cf <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  8014ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	75 1c                	jne    8014d5 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  8014b9:	e8 d0 fd ff ff       	call   80128e <sys_getenvid>
  8014be:	25 ff 03 00 00       	and    $0x3ff,%eax
  8014c3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014c6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014cb:	a3 74 70 80 00       	mov    %eax,0x807074
		return 0;
  8014d0:	e9 fa 01 00 00       	jmp    8016cf <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  8014d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014d8:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8014df:	a8 01                	test   $0x1,%al
  8014e1:	0f 84 16 01 00 00    	je     8015fd <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  8014e7:	89 d3                	mov    %edx,%ebx
  8014e9:	c1 e3 0a             	shl    $0xa,%ebx
  8014ec:	89 d7                	mov    %edx,%edi
  8014ee:	c1 e7 16             	shl    $0x16,%edi
  8014f1:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  8014f6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8014fd:	a8 01                	test   $0x1,%al
  8014ff:	0f 84 e0 00 00 00    	je     8015e5 <fork+0x160>
  801505:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80150b:	0f 87 d4 00 00 00    	ja     8015e5 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801511:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801518:	89 d0                	mov    %edx,%eax
  80151a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  80151f:	f6 c2 01             	test   $0x1,%dl
  801522:	75 1c                	jne    801540 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  801524:	c7 44 24 08 0c 34 80 	movl   $0x80340c,0x8(%esp)
  80152b:	00 
  80152c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801533:	00 
  801534:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  80153b:	e8 4c ed ff ff       	call   80028c <_panic>
	if ((perm & PTE_U) != PTE_U)
  801540:	a8 04                	test   $0x4,%al
  801542:	75 1c                	jne    801560 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801544:	c7 44 24 08 54 34 80 	movl   $0x803454,0x8(%esp)
  80154b:	00 
  80154c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801553:	00 
  801554:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  80155b:	e8 2c ed ff ff       	call   80028c <_panic>
  801560:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801563:	f6 c4 04             	test   $0x4,%ah
  801566:	75 5b                	jne    8015c3 <fork+0x13e>
  801568:	a9 02 08 00 00       	test   $0x802,%eax
  80156d:	74 54                	je     8015c3 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80156f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801572:	80 cc 08             	or     $0x8,%ah
  801575:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801578:	89 44 24 10          	mov    %eax,0x10(%esp)
  80157c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801580:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801583:	89 54 24 08          	mov    %edx,0x8(%esp)
  801587:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80158b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801592:	e8 06 fc ff ff       	call   80119d <sys_page_map>
  801597:	85 c0                	test   %eax,%eax
  801599:	78 4a                	js     8015e5 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80159b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80159e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015b0:	00 
  8015b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015bc:	e8 dc fb ff ff       	call   80119d <sys_page_map>
  8015c1:	eb 22                	jmp    8015e5 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8015c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8015d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e0:	e8 b8 fb ff ff       	call   80119d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  8015e5:	83 c6 01             	add    $0x1,%esi
  8015e8:	83 c3 01             	add    $0x1,%ebx
  8015eb:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8015f1:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  8015f7:	0f 85 f9 fe ff ff    	jne    8014f6 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  8015fd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  801601:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  801608:	0f 85 c7 fe ff ff    	jne    8014d5 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80160e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801615:	00 
  801616:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80161d:	ee 
  80161e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801621:	89 04 24             	mov    %eax,(%esp)
  801624:	e8 d2 fb ff ff       	call   8011fb <sys_page_alloc>
  801629:	85 c0                	test   %eax,%eax
  80162b:	79 08                	jns    801635 <fork+0x1b0>
  80162d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801630:	e9 9a 00 00 00       	jmp    8016cf <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801635:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80163c:	00 
  80163d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801644:	00 
  801645:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80164c:	00 
  80164d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801654:	ee 
  801655:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801658:	89 14 24             	mov    %edx,(%esp)
  80165b:	e8 3d fb ff ff       	call   80119d <sys_page_map>
  801660:	85 c0                	test   %eax,%eax
  801662:	79 05                	jns    801669 <fork+0x1e4>
  801664:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801667:	eb 66                	jmp    8016cf <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801669:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801670:	00 
  801671:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801678:	ee 
  801679:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801680:	e8 40 f5 ff ff       	call   800bc5 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801685:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80168c:	00 
  80168d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801694:	e8 a6 fa ff ff       	call   80113f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801699:	c7 44 24 04 90 2b 80 	movl   $0x802b90,0x4(%esp)
  8016a0:	00 
  8016a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a4:	89 04 24             	mov    %eax,(%esp)
  8016a7:	e8 79 f9 ff ff       	call   801025 <sys_env_set_pgfault_upcall>
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	79 05                	jns    8016b5 <fork+0x230>
  8016b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016b3:	eb 1a                	jmp    8016cf <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8016b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016bc:	00 
  8016bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016c0:	89 14 24             	mov    %edx,(%esp)
  8016c3:	e8 19 fa ff ff       	call   8010e1 <sys_env_set_status>
  8016c8:	85 c0                	test   %eax,%eax
  8016ca:	79 03                	jns    8016cf <fork+0x24a>
  8016cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  8016cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d2:	83 c4 3c             	add    $0x3c,%esp
  8016d5:	5b                   	pop    %ebx
  8016d6:	5e                   	pop    %esi
  8016d7:	5f                   	pop    %edi
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    
  8016da:	00 00                	add    %al,(%eax)
  8016dc:	00 00                	add    %al,(%eax)
	...

008016e0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	57                   	push   %edi
  8016e4:	56                   	push   %esi
  8016e5:	53                   	push   %ebx
  8016e6:	83 ec 1c             	sub    $0x1c,%esp
  8016e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8016f2:	85 db                	test   %ebx,%ebx
  8016f4:	75 2d                	jne    801723 <ipc_send+0x43>
  8016f6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8016fb:	eb 26                	jmp    801723 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8016fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801700:	74 1c                	je     80171e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  801702:	c7 44 24 08 9c 34 80 	movl   $0x80349c,0x8(%esp)
  801709:	00 
  80170a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801711:	00 
  801712:	c7 04 24 be 34 80 00 	movl   $0x8034be,(%esp)
  801719:	e8 6e eb ff ff       	call   80028c <_panic>
		sys_yield();
  80171e:	e8 37 fb ff ff       	call   80125a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  801723:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801727:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80172b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	89 04 24             	mov    %eax,(%esp)
  801735:	e8 b3 f8 ff ff       	call   800fed <sys_ipc_try_send>
  80173a:	85 c0                	test   %eax,%eax
  80173c:	78 bf                	js     8016fd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80173e:	83 c4 1c             	add    $0x1c,%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5f                   	pop    %edi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	56                   	push   %esi
  80174a:	53                   	push   %ebx
  80174b:	83 ec 10             	sub    $0x10,%esp
  80174e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801751:	8b 45 0c             	mov    0xc(%ebp),%eax
  801754:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  801757:	85 c0                	test   %eax,%eax
  801759:	75 05                	jne    801760 <ipc_recv+0x1a>
  80175b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  801760:	89 04 24             	mov    %eax,(%esp)
  801763:	e8 28 f8 ff ff       	call   800f90 <sys_ipc_recv>
  801768:	85 c0                	test   %eax,%eax
  80176a:	79 16                	jns    801782 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80176c:	85 db                	test   %ebx,%ebx
  80176e:	74 06                	je     801776 <ipc_recv+0x30>
			*from_env_store = 0;
  801770:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  801776:	85 f6                	test   %esi,%esi
  801778:	74 2c                	je     8017a6 <ipc_recv+0x60>
			*perm_store = 0;
  80177a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  801780:	eb 24                	jmp    8017a6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  801782:	85 db                	test   %ebx,%ebx
  801784:	74 0a                	je     801790 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  801786:	a1 74 70 80 00       	mov    0x807074,%eax
  80178b:	8b 40 74             	mov    0x74(%eax),%eax
  80178e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  801790:	85 f6                	test   %esi,%esi
  801792:	74 0a                	je     80179e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  801794:	a1 74 70 80 00       	mov    0x807074,%eax
  801799:	8b 40 78             	mov    0x78(%eax),%eax
  80179c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80179e:	a1 74 70 80 00       	mov    0x807074,%eax
  8017a3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5e                   	pop    %esi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    
  8017ad:	00 00                	add    %al,(%eax)
	...

008017b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017bb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    

008017c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	89 04 24             	mov    %eax,(%esp)
  8017cc:	e8 df ff ff ff       	call   8017b0 <fd2num>
  8017d1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8017d6:	c1 e0 0c             	shl    $0xc,%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8017e4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8017e9:	a8 01                	test   $0x1,%al
  8017eb:	74 36                	je     801823 <fd_alloc+0x48>
  8017ed:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8017f2:	a8 01                	test   $0x1,%al
  8017f4:	74 2d                	je     801823 <fd_alloc+0x48>
  8017f6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8017fb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801800:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801805:	89 c3                	mov    %eax,%ebx
  801807:	89 c2                	mov    %eax,%edx
  801809:	c1 ea 16             	shr    $0x16,%edx
  80180c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80180f:	f6 c2 01             	test   $0x1,%dl
  801812:	74 14                	je     801828 <fd_alloc+0x4d>
  801814:	89 c2                	mov    %eax,%edx
  801816:	c1 ea 0c             	shr    $0xc,%edx
  801819:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80181c:	f6 c2 01             	test   $0x1,%dl
  80181f:	75 10                	jne    801831 <fd_alloc+0x56>
  801821:	eb 05                	jmp    801828 <fd_alloc+0x4d>
  801823:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801828:	89 1f                	mov    %ebx,(%edi)
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80182f:	eb 17                	jmp    801848 <fd_alloc+0x6d>
  801831:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801836:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80183b:	75 c8                	jne    801805 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80183d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801843:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801848:	5b                   	pop    %ebx
  801849:	5e                   	pop    %esi
  80184a:	5f                   	pop    %edi
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    

0080184d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	83 f8 1f             	cmp    $0x1f,%eax
  801856:	77 36                	ja     80188e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801858:	05 00 00 0d 00       	add    $0xd0000,%eax
  80185d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801860:	89 c2                	mov    %eax,%edx
  801862:	c1 ea 16             	shr    $0x16,%edx
  801865:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80186c:	f6 c2 01             	test   $0x1,%dl
  80186f:	74 1d                	je     80188e <fd_lookup+0x41>
  801871:	89 c2                	mov    %eax,%edx
  801873:	c1 ea 0c             	shr    $0xc,%edx
  801876:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80187d:	f6 c2 01             	test   $0x1,%dl
  801880:	74 0c                	je     80188e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801882:	8b 55 0c             	mov    0xc(%ebp),%edx
  801885:	89 02                	mov    %eax,(%edx)
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80188c:	eb 05                	jmp    801893 <fd_lookup+0x46>
  80188e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    

00801895 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80189e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	89 04 24             	mov    %eax,(%esp)
  8018a8:	e8 a0 ff ff ff       	call   80184d <fd_lookup>
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	78 0e                	js     8018bf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	89 50 04             	mov    %edx,0x4(%eax)
  8018ba:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 10             	sub    $0x10,%esp
  8018c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8018cf:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8018d4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018d9:	be 44 35 80 00       	mov    $0x803544,%esi
		if (devtab[i]->dev_id == dev_id) {
  8018de:	39 08                	cmp    %ecx,(%eax)
  8018e0:	75 10                	jne    8018f2 <dev_lookup+0x31>
  8018e2:	eb 04                	jmp    8018e8 <dev_lookup+0x27>
  8018e4:	39 08                	cmp    %ecx,(%eax)
  8018e6:	75 0a                	jne    8018f2 <dev_lookup+0x31>
			*dev = devtab[i];
  8018e8:	89 03                	mov    %eax,(%ebx)
  8018ea:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8018ef:	90                   	nop
  8018f0:	eb 31                	jmp    801923 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018f2:	83 c2 01             	add    $0x1,%edx
  8018f5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	75 e8                	jne    8018e4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8018fc:	a1 74 70 80 00       	mov    0x807074,%eax
  801901:	8b 40 4c             	mov    0x4c(%eax),%eax
  801904:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190c:	c7 04 24 c8 34 80 00 	movl   $0x8034c8,(%esp)
  801913:	e8 39 ea ff ff       	call   800351 <cprintf>
	*dev = 0;
  801918:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80191e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	5b                   	pop    %ebx
  801927:	5e                   	pop    %esi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	53                   	push   %ebx
  80192e:	83 ec 24             	sub    $0x24,%esp
  801931:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801934:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801937:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	89 04 24             	mov    %eax,(%esp)
  801941:	e8 07 ff ff ff       	call   80184d <fd_lookup>
  801946:	85 c0                	test   %eax,%eax
  801948:	78 53                	js     80199d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80194a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	8b 00                	mov    (%eax),%eax
  801956:	89 04 24             	mov    %eax,(%esp)
  801959:	e8 63 ff ff ff       	call   8018c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 3b                	js     80199d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801962:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80196e:	74 2d                	je     80199d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801970:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801973:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80197a:	00 00 00 
	stat->st_isdir = 0;
  80197d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801984:	00 00 00 
	stat->st_dev = dev;
  801987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801990:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801994:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801997:	89 14 24             	mov    %edx,(%esp)
  80199a:	ff 50 14             	call   *0x14(%eax)
}
  80199d:	83 c4 24             	add    $0x24,%esp
  8019a0:	5b                   	pop    %ebx
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	53                   	push   %ebx
  8019a7:	83 ec 24             	sub    $0x24,%esp
  8019aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b4:	89 1c 24             	mov    %ebx,(%esp)
  8019b7:	e8 91 fe ff ff       	call   80184d <fd_lookup>
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 5f                	js     801a1f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	89 04 24             	mov    %eax,(%esp)
  8019cf:	e8 ed fe ff ff       	call   8018c1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	78 47                	js     801a1f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019db:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8019df:	75 23                	jne    801a04 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8019e1:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019e6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f1:	c7 04 24 e8 34 80 00 	movl   $0x8034e8,(%esp)
  8019f8:	e8 54 e9 ff ff       	call   800351 <cprintf>
  8019fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801a02:	eb 1b                	jmp    801a1f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a07:	8b 48 18             	mov    0x18(%eax),%ecx
  801a0a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a0f:	85 c9                	test   %ecx,%ecx
  801a11:	74 0c                	je     801a1f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1a:	89 14 24             	mov    %edx,(%esp)
  801a1d:	ff d1                	call   *%ecx
}
  801a1f:	83 c4 24             	add    $0x24,%esp
  801a22:	5b                   	pop    %ebx
  801a23:	5d                   	pop    %ebp
  801a24:	c3                   	ret    

00801a25 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	53                   	push   %ebx
  801a29:	83 ec 24             	sub    $0x24,%esp
  801a2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a2f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a36:	89 1c 24             	mov    %ebx,(%esp)
  801a39:	e8 0f fe ff ff       	call   80184d <fd_lookup>
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 66                	js     801aa8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4c:	8b 00                	mov    (%eax),%eax
  801a4e:	89 04 24             	mov    %eax,(%esp)
  801a51:	e8 6b fe ff ff       	call   8018c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 4e                	js     801aa8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a5d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a61:	75 23                	jne    801a86 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801a63:	a1 74 70 80 00       	mov    0x807074,%eax
  801a68:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a73:	c7 04 24 09 35 80 00 	movl   $0x803509,(%esp)
  801a7a:	e8 d2 e8 ff ff       	call   800351 <cprintf>
  801a7f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a84:	eb 22                	jmp    801aa8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a89:	8b 48 0c             	mov    0xc(%eax),%ecx
  801a8c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a91:	85 c9                	test   %ecx,%ecx
  801a93:	74 13                	je     801aa8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a95:	8b 45 10             	mov    0x10(%ebp),%eax
  801a98:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa3:	89 14 24             	mov    %edx,(%esp)
  801aa6:	ff d1                	call   *%ecx
}
  801aa8:	83 c4 24             	add    $0x24,%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5d                   	pop    %ebp
  801aad:	c3                   	ret    

00801aae <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	53                   	push   %ebx
  801ab2:	83 ec 24             	sub    $0x24,%esp
  801ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abf:	89 1c 24             	mov    %ebx,(%esp)
  801ac2:	e8 86 fd ff ff       	call   80184d <fd_lookup>
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 6b                	js     801b36 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801acb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ace:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad5:	8b 00                	mov    (%eax),%eax
  801ad7:	89 04 24             	mov    %eax,(%esp)
  801ada:	e8 e2 fd ff ff       	call   8018c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801adf:	85 c0                	test   %eax,%eax
  801ae1:	78 53                	js     801b36 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ae3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ae6:	8b 42 08             	mov    0x8(%edx),%eax
  801ae9:	83 e0 03             	and    $0x3,%eax
  801aec:	83 f8 01             	cmp    $0x1,%eax
  801aef:	75 23                	jne    801b14 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801af1:	a1 74 70 80 00       	mov    0x807074,%eax
  801af6:	8b 40 4c             	mov    0x4c(%eax),%eax
  801af9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b01:	c7 04 24 26 35 80 00 	movl   $0x803526,(%esp)
  801b08:	e8 44 e8 ff ff       	call   800351 <cprintf>
  801b0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801b12:	eb 22                	jmp    801b36 <read+0x88>
	}
	if (!dev->dev_read)
  801b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b17:	8b 48 08             	mov    0x8(%eax),%ecx
  801b1a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b1f:	85 c9                	test   %ecx,%ecx
  801b21:	74 13                	je     801b36 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b23:	8b 45 10             	mov    0x10(%ebp),%eax
  801b26:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b31:	89 14 24             	mov    %edx,(%esp)
  801b34:	ff d1                	call   *%ecx
}
  801b36:	83 c4 24             	add    $0x24,%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	57                   	push   %edi
  801b40:	56                   	push   %esi
  801b41:	53                   	push   %ebx
  801b42:	83 ec 1c             	sub    $0x1c,%esp
  801b45:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b48:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b50:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b55:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5a:	85 f6                	test   %esi,%esi
  801b5c:	74 29                	je     801b87 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b5e:	89 f0                	mov    %esi,%eax
  801b60:	29 d0                	sub    %edx,%eax
  801b62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b66:	03 55 0c             	add    0xc(%ebp),%edx
  801b69:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b6d:	89 3c 24             	mov    %edi,(%esp)
  801b70:	e8 39 ff ff ff       	call   801aae <read>
		if (m < 0)
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 0e                	js     801b87 <readn+0x4b>
			return m;
		if (m == 0)
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	74 08                	je     801b85 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b7d:	01 c3                	add    %eax,%ebx
  801b7f:	89 da                	mov    %ebx,%edx
  801b81:	39 f3                	cmp    %esi,%ebx
  801b83:	72 d9                	jb     801b5e <readn+0x22>
  801b85:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b87:	83 c4 1c             	add    $0x1c,%esp
  801b8a:	5b                   	pop    %ebx
  801b8b:	5e                   	pop    %esi
  801b8c:	5f                   	pop    %edi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    

00801b8f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	83 ec 20             	sub    $0x20,%esp
  801b97:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b9a:	89 34 24             	mov    %esi,(%esp)
  801b9d:	e8 0e fc ff ff       	call   8017b0 <fd2num>
  801ba2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ba5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ba9:	89 04 24             	mov    %eax,(%esp)
  801bac:	e8 9c fc ff ff       	call   80184d <fd_lookup>
  801bb1:	89 c3                	mov    %eax,%ebx
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 05                	js     801bbc <fd_close+0x2d>
  801bb7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801bba:	74 0c                	je     801bc8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801bbc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bc0:	19 c0                	sbb    %eax,%eax
  801bc2:	f7 d0                	not    %eax
  801bc4:	21 c3                	and    %eax,%ebx
  801bc6:	eb 3d                	jmp    801c05 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bc8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcf:	8b 06                	mov    (%esi),%eax
  801bd1:	89 04 24             	mov    %eax,(%esp)
  801bd4:	e8 e8 fc ff ff       	call   8018c1 <dev_lookup>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	78 16                	js     801bf5 <fd_close+0x66>
		if (dev->dev_close)
  801bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be2:	8b 40 10             	mov    0x10(%eax),%eax
  801be5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bea:	85 c0                	test   %eax,%eax
  801bec:	74 07                	je     801bf5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801bee:	89 34 24             	mov    %esi,(%esp)
  801bf1:	ff d0                	call   *%eax
  801bf3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801bf5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c00:	e8 3a f5 ff ff       	call   80113f <sys_page_unmap>
	return r;
}
  801c05:	89 d8                	mov    %ebx,%eax
  801c07:	83 c4 20             	add    $0x20,%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5e                   	pop    %esi
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    

00801c0e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	89 04 24             	mov    %eax,(%esp)
  801c21:	e8 27 fc ff ff       	call   80184d <fd_lookup>
  801c26:	85 c0                	test   %eax,%eax
  801c28:	78 13                	js     801c3d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801c2a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c31:	00 
  801c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c35:	89 04 24             	mov    %eax,(%esp)
  801c38:	e8 52 ff ff ff       	call   801b8f <fd_close>
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 18             	sub    $0x18,%esp
  801c45:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c48:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c52:	00 
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	89 04 24             	mov    %eax,(%esp)
  801c59:	e8 55 03 00 00       	call   801fb3 <open>
  801c5e:	89 c3                	mov    %eax,%ebx
  801c60:	85 c0                	test   %eax,%eax
  801c62:	78 1b                	js     801c7f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6b:	89 1c 24             	mov    %ebx,(%esp)
  801c6e:	e8 b7 fc ff ff       	call   80192a <fstat>
  801c73:	89 c6                	mov    %eax,%esi
	close(fd);
  801c75:	89 1c 24             	mov    %ebx,(%esp)
  801c78:	e8 91 ff ff ff       	call   801c0e <close>
  801c7d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801c7f:	89 d8                	mov    %ebx,%eax
  801c81:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c84:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c87:	89 ec                	mov    %ebp,%esp
  801c89:	5d                   	pop    %ebp
  801c8a:	c3                   	ret    

00801c8b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	53                   	push   %ebx
  801c8f:	83 ec 14             	sub    $0x14,%esp
  801c92:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801c97:	89 1c 24             	mov    %ebx,(%esp)
  801c9a:	e8 6f ff ff ff       	call   801c0e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801c9f:	83 c3 01             	add    $0x1,%ebx
  801ca2:	83 fb 20             	cmp    $0x20,%ebx
  801ca5:	75 f0                	jne    801c97 <close_all+0xc>
		close(i);
}
  801ca7:	83 c4 14             	add    $0x14,%esp
  801caa:	5b                   	pop    %ebx
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    

00801cad <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 58             	sub    $0x58,%esp
  801cb3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cb6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801cb9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801cbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801cbf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	89 04 24             	mov    %eax,(%esp)
  801ccc:	e8 7c fb ff ff       	call   80184d <fd_lookup>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	0f 88 e0 00 00 00    	js     801dbb <dup+0x10e>
		return r;
	close(newfdnum);
  801cdb:	89 3c 24             	mov    %edi,(%esp)
  801cde:	e8 2b ff ff ff       	call   801c0e <close>

	newfd = INDEX2FD(newfdnum);
  801ce3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801ce9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	e8 c9 fa ff ff       	call   8017c0 <fd2data>
  801cf7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801cf9:	89 34 24             	mov    %esi,(%esp)
  801cfc:	e8 bf fa ff ff       	call   8017c0 <fd2data>
  801d01:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801d04:	89 da                	mov    %ebx,%edx
  801d06:	89 d8                	mov    %ebx,%eax
  801d08:	c1 e8 16             	shr    $0x16,%eax
  801d0b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d12:	a8 01                	test   $0x1,%al
  801d14:	74 43                	je     801d59 <dup+0xac>
  801d16:	c1 ea 0c             	shr    $0xc,%edx
  801d19:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d20:	a8 01                	test   $0x1,%al
  801d22:	74 35                	je     801d59 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801d24:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d2b:	25 07 0e 00 00       	and    $0xe07,%eax
  801d30:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d42:	00 
  801d43:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4e:	e8 4a f4 ff ff       	call   80119d <sys_page_map>
  801d53:	89 c3                	mov    %eax,%ebx
  801d55:	85 c0                	test   %eax,%eax
  801d57:	78 3f                	js     801d98 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d5c:	89 c2                	mov    %eax,%edx
  801d5e:	c1 ea 0c             	shr    $0xc,%edx
  801d61:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d68:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801d6e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d72:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d7d:	00 
  801d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d89:	e8 0f f4 ff ff       	call   80119d <sys_page_map>
  801d8e:	89 c3                	mov    %eax,%ebx
  801d90:	85 c0                	test   %eax,%eax
  801d92:	78 04                	js     801d98 <dup+0xeb>
  801d94:	89 fb                	mov    %edi,%ebx
  801d96:	eb 23                	jmp    801dbb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801d98:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d9c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da3:	e8 97 f3 ff ff       	call   80113f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801da8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801daf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db6:	e8 84 f3 ff ff       	call   80113f <sys_page_unmap>
	return r;
}
  801dbb:	89 d8                	mov    %ebx,%eax
  801dbd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801dc0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801dc3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801dc6:	89 ec                	mov    %ebp,%esp
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    
	...

00801dcc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 14             	sub    $0x14,%esp
  801dd3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801dd5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801ddb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801de2:	00 
  801de3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801dea:	00 
  801deb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801def:	89 14 24             	mov    %edx,(%esp)
  801df2:	e8 e9 f8 ff ff       	call   8016e0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801df7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dfe:	00 
  801dff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e0a:	e8 37 f9 ff ff       	call   801746 <ipc_recv>
}
  801e0f:	83 c4 14             	add    $0x14,%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5d                   	pop    %ebp
  801e14:	c3                   	ret    

00801e15 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e21:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e29:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e33:	b8 02 00 00 00       	mov    $0x2,%eax
  801e38:	e8 8f ff ff ff       	call   801dcc <fsipc>
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801e50:	ba 00 00 00 00       	mov    $0x0,%edx
  801e55:	b8 06 00 00 00       	mov    $0x6,%eax
  801e5a:	e8 6d ff ff ff       	call   801dcc <fsipc>
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e67:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6c:	b8 08 00 00 00       	mov    $0x8,%eax
  801e71:	e8 56 ff ff ff       	call   801dcc <fsipc>
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 14             	sub    $0x14,%esp
  801e7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	8b 40 0c             	mov    0xc(%eax),%eax
  801e88:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e92:	b8 05 00 00 00       	mov    $0x5,%eax
  801e97:	e8 30 ff ff ff       	call   801dcc <fsipc>
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	78 2b                	js     801ecb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ea0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801ea7:	00 
  801ea8:	89 1c 24             	mov    %ebx,(%esp)
  801eab:	e8 5a eb ff ff       	call   800a0a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801eb0:	a1 80 40 80 00       	mov    0x804080,%eax
  801eb5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ebb:	a1 84 40 80 00       	mov    0x804084,%eax
  801ec0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801ecb:	83 c4 14             	add    $0x14,%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    

00801ed1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 18             	sub    $0x18,%esp
  801ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eda:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801edf:	76 05                	jbe    801ee6 <devfile_write+0x15>
  801ee1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee9:	8b 52 0c             	mov    0xc(%edx),%edx
  801eec:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801ef2:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801ef7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f02:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801f09:	e8 b7 ec ff ff       	call   800bc5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801f0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f13:	b8 04 00 00 00       	mov    $0x4,%eax
  801f18:	e8 af fe ff ff       	call   801dcc <fsipc>
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	53                   	push   %ebx
  801f23:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801f31:	8b 45 10             	mov    0x10(%ebp),%eax
  801f34:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801f39:	ba 00 40 80 00       	mov    $0x804000,%edx
  801f3e:	b8 03 00 00 00       	mov    $0x3,%eax
  801f43:	e8 84 fe ff ff       	call   801dcc <fsipc>
  801f48:	89 c3                	mov    %eax,%ebx
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	78 17                	js     801f65 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801f4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f52:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801f59:	00 
  801f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5d:	89 04 24             	mov    %eax,(%esp)
  801f60:	e8 60 ec ff ff       	call   800bc5 <memmove>
	return r;
}
  801f65:	89 d8                	mov    %ebx,%eax
  801f67:	83 c4 14             	add    $0x14,%esp
  801f6a:	5b                   	pop    %ebx
  801f6b:	5d                   	pop    %ebp
  801f6c:	c3                   	ret    

00801f6d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	53                   	push   %ebx
  801f71:	83 ec 14             	sub    $0x14,%esp
  801f74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801f77:	89 1c 24             	mov    %ebx,(%esp)
  801f7a:	e8 41 ea ff ff       	call   8009c0 <strlen>
  801f7f:	89 c2                	mov    %eax,%edx
  801f81:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801f86:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801f8c:	7f 1f                	jg     801fad <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801f8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f92:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f99:	e8 6c ea ff ff       	call   800a0a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801f9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa3:	b8 07 00 00 00       	mov    $0x7,%eax
  801fa8:	e8 1f fe ff ff       	call   801dcc <fsipc>
}
  801fad:	83 c4 14             	add    $0x14,%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5d                   	pop    %ebp
  801fb2:	c3                   	ret    

00801fb3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 28             	sub    $0x28,%esp
  801fb9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801fbc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801fbf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801fc2:	89 34 24             	mov    %esi,(%esp)
  801fc5:	e8 f6 e9 ff ff       	call   8009c0 <strlen>
  801fca:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fcf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fd4:	7f 5e                	jg     802034 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd9:	89 04 24             	mov    %eax,(%esp)
  801fdc:	e8 fa f7 ff ff       	call   8017db <fd_alloc>
  801fe1:	89 c3                	mov    %eax,%ebx
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	78 4d                	js     802034 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801fe7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801feb:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ff2:	e8 13 ea ff ff       	call   800a0a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffa:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	b8 01 00 00 00       	mov    $0x1,%eax
  802007:	e8 c0 fd ff ff       	call   801dcc <fsipc>
  80200c:	89 c3                	mov    %eax,%ebx
  80200e:	85 c0                	test   %eax,%eax
  802010:	79 15                	jns    802027 <open+0x74>
	{
		fd_close(fd,0);
  802012:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802019:	00 
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	89 04 24             	mov    %eax,(%esp)
  802020:	e8 6a fb ff ff       	call   801b8f <fd_close>
		return r; 
  802025:	eb 0d                	jmp    802034 <open+0x81>
	}
	return fd2num(fd);
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	89 04 24             	mov    %eax,(%esp)
  80202d:	e8 7e f7 ff ff       	call   8017b0 <fd2num>
  802032:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  802034:	89 d8                	mov    %ebx,%eax
  802036:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802039:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80203c:	89 ec                	mov    %ebp,%esp
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    

00802040 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	89 c2                	mov    %eax,%edx
  802048:	c1 ea 16             	shr    $0x16,%edx
  80204b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802052:	f6 c2 01             	test   $0x1,%dl
  802055:	74 26                	je     80207d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802057:	c1 e8 0c             	shr    $0xc,%eax
  80205a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802061:	a8 01                	test   $0x1,%al
  802063:	74 18                	je     80207d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802065:	c1 e8 0c             	shr    $0xc,%eax
  802068:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80206b:	c1 e2 02             	shl    $0x2,%edx
  80206e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802073:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802078:	0f b7 c0             	movzwl %ax,%eax
  80207b:	eb 05                	jmp    802082 <pageref+0x42>
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    
	...

00802090 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802096:	c7 44 24 04 58 35 80 	movl   $0x803558,0x4(%esp)
  80209d:	00 
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	89 04 24             	mov    %eax,(%esp)
  8020a4:	e8 61 e9 ff ff       	call   800a0a <strcpy>
	return 0;
}
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020bc:	89 04 24             	mov    %eax,(%esp)
  8020bf:	e8 9e 02 00 00       	call   802362 <nsipc_close>
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020d3:	00 
  8020d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e8:	89 04 24             	mov    %eax,(%esp)
  8020eb:	e8 ae 02 00 00       	call   80239e <nsipc_send>
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020ff:	00 
  802100:	8b 45 10             	mov    0x10(%ebp),%eax
  802103:	89 44 24 08          	mov    %eax,0x8(%esp)
  802107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	8b 40 0c             	mov    0xc(%eax),%eax
  802114:	89 04 24             	mov    %eax,(%esp)
  802117:	e8 f5 02 00 00       	call   802411 <nsipc_recv>
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	56                   	push   %esi
  802122:	53                   	push   %ebx
  802123:	83 ec 20             	sub    $0x20,%esp
  802126:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802128:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212b:	89 04 24             	mov    %eax,(%esp)
  80212e:	e8 a8 f6 ff ff       	call   8017db <fd_alloc>
  802133:	89 c3                	mov    %eax,%ebx
  802135:	85 c0                	test   %eax,%eax
  802137:	78 21                	js     80215a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802139:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802140:	00 
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	89 44 24 04          	mov    %eax,0x4(%esp)
  802148:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80214f:	e8 a7 f0 ff ff       	call   8011fb <sys_page_alloc>
  802154:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802156:	85 c0                	test   %eax,%eax
  802158:	79 0a                	jns    802164 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80215a:	89 34 24             	mov    %esi,(%esp)
  80215d:	e8 00 02 00 00       	call   802362 <nsipc_close>
		return r;
  802162:	eb 28                	jmp    80218c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802164:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	89 04 24             	mov    %eax,(%esp)
  802185:	e8 26 f6 ff ff       	call   8017b0 <fd2num>
  80218a:	89 c3                	mov    %eax,%ebx
}
  80218c:	89 d8                	mov    %ebx,%eax
  80218e:	83 c4 20             	add    $0x20,%esp
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    

00802195 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
  802198:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80219b:	8b 45 10             	mov    0x10(%ebp),%eax
  80219e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	89 04 24             	mov    %eax,(%esp)
  8021af:	e8 62 01 00 00       	call   802316 <nsipc_socket>
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	78 05                	js     8021bd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8021b8:	e8 61 ff ff ff       	call   80211e <alloc_sockfd>
}
  8021bd:	c9                   	leave  
  8021be:	66 90                	xchg   %ax,%ax
  8021c0:	c3                   	ret    

008021c1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021c7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021ce:	89 04 24             	mov    %eax,(%esp)
  8021d1:	e8 77 f6 ff ff       	call   80184d <fd_lookup>
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	78 15                	js     8021ef <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021dd:	8b 0a                	mov    (%edx),%ecx
  8021df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021e4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8021ea:	75 03                	jne    8021ef <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021ec:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	e8 c2 ff ff ff       	call   8021c1 <fd2sockid>
  8021ff:	85 c0                	test   %eax,%eax
  802201:	78 0f                	js     802212 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802203:	8b 55 0c             	mov    0xc(%ebp),%edx
  802206:	89 54 24 04          	mov    %edx,0x4(%esp)
  80220a:	89 04 24             	mov    %eax,(%esp)
  80220d:	e8 2e 01 00 00       	call   802340 <nsipc_listen>
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	e8 9f ff ff ff       	call   8021c1 <fd2sockid>
  802222:	85 c0                	test   %eax,%eax
  802224:	78 16                	js     80223c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802226:	8b 55 10             	mov    0x10(%ebp),%edx
  802229:	89 54 24 08          	mov    %edx,0x8(%esp)
  80222d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802230:	89 54 24 04          	mov    %edx,0x4(%esp)
  802234:	89 04 24             	mov    %eax,(%esp)
  802237:	e8 55 02 00 00       	call   802491 <nsipc_connect>
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	e8 75 ff ff ff       	call   8021c1 <fd2sockid>
  80224c:	85 c0                	test   %eax,%eax
  80224e:	78 0f                	js     80225f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802250:	8b 55 0c             	mov    0xc(%ebp),%edx
  802253:	89 54 24 04          	mov    %edx,0x4(%esp)
  802257:	89 04 24             	mov    %eax,(%esp)
  80225a:	e8 1d 01 00 00       	call   80237c <nsipc_shutdown>
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	e8 52 ff ff ff       	call   8021c1 <fd2sockid>
  80226f:	85 c0                	test   %eax,%eax
  802271:	78 16                	js     802289 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802273:	8b 55 10             	mov    0x10(%ebp),%edx
  802276:	89 54 24 08          	mov    %edx,0x8(%esp)
  80227a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802281:	89 04 24             	mov    %eax,(%esp)
  802284:	e8 47 02 00 00       	call   8024d0 <nsipc_bind>
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	e8 28 ff ff ff       	call   8021c1 <fd2sockid>
  802299:	85 c0                	test   %eax,%eax
  80229b:	78 1f                	js     8022bc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80229d:	8b 55 10             	mov    0x10(%ebp),%edx
  8022a0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ab:	89 04 24             	mov    %eax,(%esp)
  8022ae:	e8 5c 02 00 00       	call   80250f <nsipc_accept>
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	78 05                	js     8022bc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8022b7:	e8 62 fe ff ff       	call   80211e <alloc_sockfd>
}
  8022bc:	c9                   	leave  
  8022bd:	8d 76 00             	lea    0x0(%esi),%esi
  8022c0:	c3                   	ret    
	...

008022d0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022d6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8022dc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022e3:	00 
  8022e4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8022eb:	00 
  8022ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f0:	89 14 24             	mov    %edx,(%esp)
  8022f3:	e8 e8 f3 ff ff       	call   8016e0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022ff:	00 
  802300:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802307:	00 
  802308:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80230f:	e8 32 f4 ff ff       	call   801746 <ipc_recv>
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802324:	8b 45 0c             	mov    0xc(%ebp),%eax
  802327:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80232c:	8b 45 10             	mov    0x10(%ebp),%eax
  80232f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802334:	b8 09 00 00 00       	mov    $0x9,%eax
  802339:	e8 92 ff ff ff       	call   8022d0 <nsipc>
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80234e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802351:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802356:	b8 06 00 00 00       	mov    $0x6,%eax
  80235b:	e8 70 ff ff ff       	call   8022d0 <nsipc>
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802370:	b8 04 00 00 00       	mov    $0x4,%eax
  802375:	e8 56 ff ff ff       	call   8022d0 <nsipc>
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80238a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802392:	b8 03 00 00 00       	mov    $0x3,%eax
  802397:	e8 34 ff ff ff       	call   8022d0 <nsipc>
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	53                   	push   %ebx
  8023a2:	83 ec 14             	sub    $0x14,%esp
  8023a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8023b0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023b6:	7e 24                	jle    8023dc <nsipc_send+0x3e>
  8023b8:	c7 44 24 0c 64 35 80 	movl   $0x803564,0xc(%esp)
  8023bf:	00 
  8023c0:	c7 44 24 08 70 35 80 	movl   $0x803570,0x8(%esp)
  8023c7:	00 
  8023c8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8023cf:	00 
  8023d0:	c7 04 24 85 35 80 00 	movl   $0x803585,(%esp)
  8023d7:	e8 b0 de ff ff       	call   80028c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8023ee:	e8 d2 e7 ff ff       	call   800bc5 <memmove>
	nsipcbuf.send.req_size = size;
  8023f3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8023f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023fc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802401:	b8 08 00 00 00       	mov    $0x8,%eax
  802406:	e8 c5 fe ff ff       	call   8022d0 <nsipc>
}
  80240b:	83 c4 14             	add    $0x14,%esp
  80240e:	5b                   	pop    %ebx
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    

00802411 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	56                   	push   %esi
  802415:	53                   	push   %ebx
  802416:	83 ec 10             	sub    $0x10,%esp
  802419:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802424:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80242a:	8b 45 14             	mov    0x14(%ebp),%eax
  80242d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802432:	b8 07 00 00 00       	mov    $0x7,%eax
  802437:	e8 94 fe ff ff       	call   8022d0 <nsipc>
  80243c:	89 c3                	mov    %eax,%ebx
  80243e:	85 c0                	test   %eax,%eax
  802440:	78 46                	js     802488 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802442:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802447:	7f 04                	jg     80244d <nsipc_recv+0x3c>
  802449:	39 c6                	cmp    %eax,%esi
  80244b:	7d 24                	jge    802471 <nsipc_recv+0x60>
  80244d:	c7 44 24 0c 91 35 80 	movl   $0x803591,0xc(%esp)
  802454:	00 
  802455:	c7 44 24 08 70 35 80 	movl   $0x803570,0x8(%esp)
  80245c:	00 
  80245d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802464:	00 
  802465:	c7 04 24 85 35 80 00 	movl   $0x803585,(%esp)
  80246c:	e8 1b de ff ff       	call   80028c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802471:	89 44 24 08          	mov    %eax,0x8(%esp)
  802475:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80247c:	00 
  80247d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802480:	89 04 24             	mov    %eax,(%esp)
  802483:	e8 3d e7 ff ff       	call   800bc5 <memmove>
	}

	return r;
}
  802488:	89 d8                	mov    %ebx,%eax
  80248a:	83 c4 10             	add    $0x10,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    

00802491 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	53                   	push   %ebx
  802495:	83 ec 14             	sub    $0x14,%esp
  802498:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8024a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ae:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8024b5:	e8 0b e7 ff ff       	call   800bc5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024ba:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8024c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8024c5:	e8 06 fe ff ff       	call   8022d0 <nsipc>
}
  8024ca:	83 c4 14             	add    $0x14,%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5d                   	pop    %ebp
  8024cf:	c3                   	ret    

008024d0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	53                   	push   %ebx
  8024d4:	83 ec 14             	sub    $0x14,%esp
  8024d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ed:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8024f4:	e8 cc e6 ff ff       	call   800bc5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024f9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8024ff:	b8 02 00 00 00       	mov    $0x2,%eax
  802504:	e8 c7 fd ff ff       	call   8022d0 <nsipc>
}
  802509:	83 c4 14             	add    $0x14,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5d                   	pop    %ebp
  80250e:	c3                   	ret    

0080250f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
  802512:	83 ec 18             	sub    $0x18,%esp
  802515:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802518:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802523:	b8 01 00 00 00       	mov    $0x1,%eax
  802528:	e8 a3 fd ff ff       	call   8022d0 <nsipc>
  80252d:	89 c3                	mov    %eax,%ebx
  80252f:	85 c0                	test   %eax,%eax
  802531:	78 25                	js     802558 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802533:	be 10 60 80 00       	mov    $0x806010,%esi
  802538:	8b 06                	mov    (%esi),%eax
  80253a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80253e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802545:	00 
  802546:	8b 45 0c             	mov    0xc(%ebp),%eax
  802549:	89 04 24             	mov    %eax,(%esp)
  80254c:	e8 74 e6 ff ff       	call   800bc5 <memmove>
		*addrlen = ret->ret_addrlen;
  802551:	8b 16                	mov    (%esi),%edx
  802553:	8b 45 10             	mov    0x10(%ebp),%eax
  802556:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802558:	89 d8                	mov    %ebx,%eax
  80255a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80255d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802560:	89 ec                	mov    %ebp,%esp
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
	...

00802570 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 18             	sub    $0x18,%esp
  802576:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802579:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80257c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	89 04 24             	mov    %eax,(%esp)
  802585:	e8 36 f2 ff ff       	call   8017c0 <fd2data>
  80258a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80258c:	c7 44 24 04 a6 35 80 	movl   $0x8035a6,0x4(%esp)
  802593:	00 
  802594:	89 34 24             	mov    %esi,(%esp)
  802597:	e8 6e e4 ff ff       	call   800a0a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80259c:	8b 43 04             	mov    0x4(%ebx),%eax
  80259f:	2b 03                	sub    (%ebx),%eax
  8025a1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8025a7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8025ae:	00 00 00 
	stat->st_dev = &devpipe;
  8025b1:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  8025b8:	70 80 00 
	return 0;
}
  8025bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025c3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025c6:	89 ec                	mov    %ebp,%esp
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    

008025ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	53                   	push   %ebx
  8025ce:	83 ec 14             	sub    $0x14,%esp
  8025d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025df:	e8 5b eb ff ff       	call   80113f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025e4:	89 1c 24             	mov    %ebx,(%esp)
  8025e7:	e8 d4 f1 ff ff       	call   8017c0 <fd2data>
  8025ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f7:	e8 43 eb ff ff       	call   80113f <sys_page_unmap>
}
  8025fc:	83 c4 14             	add    $0x14,%esp
  8025ff:	5b                   	pop    %ebx
  802600:	5d                   	pop    %ebp
  802601:	c3                   	ret    

00802602 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	57                   	push   %edi
  802606:	56                   	push   %esi
  802607:	53                   	push   %ebx
  802608:	83 ec 2c             	sub    $0x2c,%esp
  80260b:	89 c7                	mov    %eax,%edi
  80260d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802610:	a1 74 70 80 00       	mov    0x807074,%eax
  802615:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802618:	89 3c 24             	mov    %edi,(%esp)
  80261b:	e8 20 fa ff ff       	call   802040 <pageref>
  802620:	89 c6                	mov    %eax,%esi
  802622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802625:	89 04 24             	mov    %eax,(%esp)
  802628:	e8 13 fa ff ff       	call   802040 <pageref>
  80262d:	39 c6                	cmp    %eax,%esi
  80262f:	0f 94 c0             	sete   %al
  802632:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802635:	8b 15 74 70 80 00    	mov    0x807074,%edx
  80263b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80263e:	39 cb                	cmp    %ecx,%ebx
  802640:	75 08                	jne    80264a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802642:	83 c4 2c             	add    $0x2c,%esp
  802645:	5b                   	pop    %ebx
  802646:	5e                   	pop    %esi
  802647:	5f                   	pop    %edi
  802648:	5d                   	pop    %ebp
  802649:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80264a:	83 f8 01             	cmp    $0x1,%eax
  80264d:	75 c1                	jne    802610 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80264f:	8b 52 58             	mov    0x58(%edx),%edx
  802652:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802656:	89 54 24 08          	mov    %edx,0x8(%esp)
  80265a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80265e:	c7 04 24 ad 35 80 00 	movl   $0x8035ad,(%esp)
  802665:	e8 e7 dc ff ff       	call   800351 <cprintf>
  80266a:	eb a4                	jmp    802610 <_pipeisclosed+0xe>

0080266c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	57                   	push   %edi
  802670:	56                   	push   %esi
  802671:	53                   	push   %ebx
  802672:	83 ec 1c             	sub    $0x1c,%esp
  802675:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802678:	89 34 24             	mov    %esi,(%esp)
  80267b:	e8 40 f1 ff ff       	call   8017c0 <fd2data>
  802680:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802682:	bf 00 00 00 00       	mov    $0x0,%edi
  802687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80268b:	75 54                	jne    8026e1 <devpipe_write+0x75>
  80268d:	eb 60                	jmp    8026ef <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80268f:	89 da                	mov    %ebx,%edx
  802691:	89 f0                	mov    %esi,%eax
  802693:	e8 6a ff ff ff       	call   802602 <_pipeisclosed>
  802698:	85 c0                	test   %eax,%eax
  80269a:	74 07                	je     8026a3 <devpipe_write+0x37>
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a1:	eb 53                	jmp    8026f6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8026a3:	90                   	nop
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	e8 ad eb ff ff       	call   80125a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8026b0:	8b 13                	mov    (%ebx),%edx
  8026b2:	83 c2 20             	add    $0x20,%edx
  8026b5:	39 d0                	cmp    %edx,%eax
  8026b7:	73 d6                	jae    80268f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026b9:	89 c2                	mov    %eax,%edx
  8026bb:	c1 fa 1f             	sar    $0x1f,%edx
  8026be:	c1 ea 1b             	shr    $0x1b,%edx
  8026c1:	01 d0                	add    %edx,%eax
  8026c3:	83 e0 1f             	and    $0x1f,%eax
  8026c6:	29 d0                	sub    %edx,%eax
  8026c8:	89 c2                	mov    %eax,%edx
  8026ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026cd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8026d1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026d9:	83 c7 01             	add    $0x1,%edi
  8026dc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8026df:	76 13                	jbe    8026f4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8026e4:	8b 13                	mov    (%ebx),%edx
  8026e6:	83 c2 20             	add    $0x20,%edx
  8026e9:	39 d0                	cmp    %edx,%eax
  8026eb:	73 a2                	jae    80268f <devpipe_write+0x23>
  8026ed:	eb ca                	jmp    8026b9 <devpipe_write+0x4d>
  8026ef:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8026f4:	89 f8                	mov    %edi,%eax
}
  8026f6:	83 c4 1c             	add    $0x1c,%esp
  8026f9:	5b                   	pop    %ebx
  8026fa:	5e                   	pop    %esi
  8026fb:	5f                   	pop    %edi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    

008026fe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	83 ec 28             	sub    $0x28,%esp
  802704:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802707:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80270a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80270d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802710:	89 3c 24             	mov    %edi,(%esp)
  802713:	e8 a8 f0 ff ff       	call   8017c0 <fd2data>
  802718:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80271a:	be 00 00 00 00       	mov    $0x0,%esi
  80271f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802723:	75 4c                	jne    802771 <devpipe_read+0x73>
  802725:	eb 5b                	jmp    802782 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802727:	89 f0                	mov    %esi,%eax
  802729:	eb 5e                	jmp    802789 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80272b:	89 da                	mov    %ebx,%edx
  80272d:	89 f8                	mov    %edi,%eax
  80272f:	90                   	nop
  802730:	e8 cd fe ff ff       	call   802602 <_pipeisclosed>
  802735:	85 c0                	test   %eax,%eax
  802737:	74 07                	je     802740 <devpipe_read+0x42>
  802739:	b8 00 00 00 00       	mov    $0x0,%eax
  80273e:	eb 49                	jmp    802789 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802740:	e8 15 eb ff ff       	call   80125a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802745:	8b 03                	mov    (%ebx),%eax
  802747:	3b 43 04             	cmp    0x4(%ebx),%eax
  80274a:	74 df                	je     80272b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80274c:	89 c2                	mov    %eax,%edx
  80274e:	c1 fa 1f             	sar    $0x1f,%edx
  802751:	c1 ea 1b             	shr    $0x1b,%edx
  802754:	01 d0                	add    %edx,%eax
  802756:	83 e0 1f             	and    $0x1f,%eax
  802759:	29 d0                	sub    %edx,%eax
  80275b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802760:	8b 55 0c             	mov    0xc(%ebp),%edx
  802763:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802766:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802769:	83 c6 01             	add    $0x1,%esi
  80276c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80276f:	76 16                	jbe    802787 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802771:	8b 03                	mov    (%ebx),%eax
  802773:	3b 43 04             	cmp    0x4(%ebx),%eax
  802776:	75 d4                	jne    80274c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802778:	85 f6                	test   %esi,%esi
  80277a:	75 ab                	jne    802727 <devpipe_read+0x29>
  80277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802780:	eb a9                	jmp    80272b <devpipe_read+0x2d>
  802782:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802787:	89 f0                	mov    %esi,%eax
}
  802789:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80278c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80278f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802792:	89 ec                	mov    %ebp,%esp
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    

00802796 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80279c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80279f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	89 04 24             	mov    %eax,(%esp)
  8027a9:	e8 9f f0 ff ff       	call   80184d <fd_lookup>
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	78 15                	js     8027c7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	89 04 24             	mov    %eax,(%esp)
  8027b8:	e8 03 f0 ff ff       	call   8017c0 <fd2data>
	return _pipeisclosed(fd, p);
  8027bd:	89 c2                	mov    %eax,%edx
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	e8 3b fe ff ff       	call   802602 <_pipeisclosed>
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 48             	sub    $0x48,%esp
  8027cf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027d2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027d5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027d8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8027de:	89 04 24             	mov    %eax,(%esp)
  8027e1:	e8 f5 ef ff ff       	call   8017db <fd_alloc>
  8027e6:	89 c3                	mov    %eax,%ebx
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	0f 88 42 01 00 00    	js     802932 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027f0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027f7:	00 
  8027f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802806:	e8 f0 e9 ff ff       	call   8011fb <sys_page_alloc>
  80280b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80280d:	85 c0                	test   %eax,%eax
  80280f:	0f 88 1d 01 00 00    	js     802932 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802815:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802818:	89 04 24             	mov    %eax,(%esp)
  80281b:	e8 bb ef ff ff       	call   8017db <fd_alloc>
  802820:	89 c3                	mov    %eax,%ebx
  802822:	85 c0                	test   %eax,%eax
  802824:	0f 88 f5 00 00 00    	js     80291f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80282a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802831:	00 
  802832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802835:	89 44 24 04          	mov    %eax,0x4(%esp)
  802839:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802840:	e8 b6 e9 ff ff       	call   8011fb <sys_page_alloc>
  802845:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802847:	85 c0                	test   %eax,%eax
  802849:	0f 88 d0 00 00 00    	js     80291f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80284f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802852:	89 04 24             	mov    %eax,(%esp)
  802855:	e8 66 ef ff ff       	call   8017c0 <fd2data>
  80285a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80285c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802863:	00 
  802864:	89 44 24 04          	mov    %eax,0x4(%esp)
  802868:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80286f:	e8 87 e9 ff ff       	call   8011fb <sys_page_alloc>
  802874:	89 c3                	mov    %eax,%ebx
  802876:	85 c0                	test   %eax,%eax
  802878:	0f 88 8e 00 00 00    	js     80290c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80287e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802881:	89 04 24             	mov    %eax,(%esp)
  802884:	e8 37 ef ff ff       	call   8017c0 <fd2data>
  802889:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802890:	00 
  802891:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802895:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80289c:	00 
  80289d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a8:	e8 f0 e8 ff ff       	call   80119d <sys_page_map>
  8028ad:	89 c3                	mov    %eax,%ebx
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	78 49                	js     8028fc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8028b3:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  8028b8:	8b 08                	mov    (%eax),%ecx
  8028ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028bd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8028bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028c2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8028c9:	8b 10                	mov    (%eax),%edx
  8028cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ce:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8028da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028dd:	89 04 24             	mov    %eax,(%esp)
  8028e0:	e8 cb ee ff ff       	call   8017b0 <fd2num>
  8028e5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8028e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ea:	89 04 24             	mov    %eax,(%esp)
  8028ed:	e8 be ee ff ff       	call   8017b0 <fd2num>
  8028f2:	89 47 04             	mov    %eax,0x4(%edi)
  8028f5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8028fa:	eb 36                	jmp    802932 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8028fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802900:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802907:	e8 33 e8 ff ff       	call   80113f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80290c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802913:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80291a:	e8 20 e8 ff ff       	call   80113f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80291f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802922:	89 44 24 04          	mov    %eax,0x4(%esp)
  802926:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80292d:	e8 0d e8 ff ff       	call   80113f <sys_page_unmap>
    err:
	return r;
}
  802932:	89 d8                	mov    %ebx,%eax
  802934:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802937:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80293a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80293d:	89 ec                	mov    %ebp,%esp
  80293f:	5d                   	pop    %ebp
  802940:	c3                   	ret    
	...

00802950 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
  802958:	5d                   	pop    %ebp
  802959:	c3                   	ret    

0080295a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
  80295d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802960:	c7 44 24 04 c5 35 80 	movl   $0x8035c5,0x4(%esp)
  802967:	00 
  802968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296b:	89 04 24             	mov    %eax,(%esp)
  80296e:	e8 97 e0 ff ff       	call   800a0a <strcpy>
	return 0;
}
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	c9                   	leave  
  802979:	c3                   	ret    

0080297a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	57                   	push   %edi
  80297e:	56                   	push   %esi
  80297f:	53                   	push   %ebx
  802980:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802986:	b8 00 00 00 00       	mov    $0x0,%eax
  80298b:	be 00 00 00 00       	mov    $0x0,%esi
  802990:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802994:	74 3f                	je     8029d5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802996:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80299c:	8b 55 10             	mov    0x10(%ebp),%edx
  80299f:	29 c2                	sub    %eax,%edx
  8029a1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8029a3:	83 fa 7f             	cmp    $0x7f,%edx
  8029a6:	76 05                	jbe    8029ad <devcons_write+0x33>
  8029a8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029b1:	03 45 0c             	add    0xc(%ebp),%eax
  8029b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b8:	89 3c 24             	mov    %edi,(%esp)
  8029bb:	e8 05 e2 ff ff       	call   800bc5 <memmove>
		sys_cputs(buf, m);
  8029c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8029c4:	89 3c 24             	mov    %edi,(%esp)
  8029c7:	e8 34 e4 ff ff       	call   800e00 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029cc:	01 de                	add    %ebx,%esi
  8029ce:	89 f0                	mov    %esi,%eax
  8029d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029d3:	72 c7                	jb     80299c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8029d5:	89 f0                	mov    %esi,%eax
  8029d7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8029dd:	5b                   	pop    %ebx
  8029de:	5e                   	pop    %esi
  8029df:	5f                   	pop    %edi
  8029e0:	5d                   	pop    %ebp
  8029e1:	c3                   	ret    

008029e2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029e2:	55                   	push   %ebp
  8029e3:	89 e5                	mov    %esp,%ebp
  8029e5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029f5:	00 
  8029f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029f9:	89 04 24             	mov    %eax,(%esp)
  8029fc:	e8 ff e3 ff ff       	call   800e00 <sys_cputs>
}
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
  802a06:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802a09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a0d:	75 07                	jne    802a16 <devcons_read+0x13>
  802a0f:	eb 28                	jmp    802a39 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a11:	e8 44 e8 ff ff       	call   80125a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802a16:	66 90                	xchg   %ax,%ax
  802a18:	e8 af e3 ff ff       	call   800dcc <sys_cgetc>
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	90                   	nop
  802a20:	74 ef                	je     802a11 <devcons_read+0xe>
  802a22:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802a24:	85 c0                	test   %eax,%eax
  802a26:	78 16                	js     802a3e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802a28:	83 f8 04             	cmp    $0x4,%eax
  802a2b:	74 0c                	je     802a39 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a30:	88 10                	mov    %dl,(%eax)
  802a32:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802a37:	eb 05                	jmp    802a3e <devcons_read+0x3b>
  802a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3e:	c9                   	leave  
  802a3f:	c3                   	ret    

00802a40 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802a40:	55                   	push   %ebp
  802a41:	89 e5                	mov    %esp,%ebp
  802a43:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a49:	89 04 24             	mov    %eax,(%esp)
  802a4c:	e8 8a ed ff ff       	call   8017db <fd_alloc>
  802a51:	85 c0                	test   %eax,%eax
  802a53:	78 3f                	js     802a94 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a55:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a5c:	00 
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a6b:	e8 8b e7 ff ff       	call   8011fb <sys_page_alloc>
  802a70:	85 c0                	test   %eax,%eax
  802a72:	78 20                	js     802a94 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a74:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	89 04 24             	mov    %eax,(%esp)
  802a8f:	e8 1c ed ff ff       	call   8017b0 <fd2num>
}
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    

00802a96 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
  802a99:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	89 04 24             	mov    %eax,(%esp)
  802aa9:	e8 9f ed ff ff       	call   80184d <fd_lookup>
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	78 11                	js     802ac3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802abd:	0f 94 c0             	sete   %al
  802ac0:	0f b6 c0             	movzbl %al,%eax
}
  802ac3:	c9                   	leave  
  802ac4:	c3                   	ret    

00802ac5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802ac5:	55                   	push   %ebp
  802ac6:	89 e5                	mov    %esp,%ebp
  802ac8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802acb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802ad2:	00 
  802ad3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ada:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ae1:	e8 c8 ef ff ff       	call   801aae <read>
	if (r < 0)
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	78 0f                	js     802af9 <getchar+0x34>
		return r;
	if (r < 1)
  802aea:	85 c0                	test   %eax,%eax
  802aec:	7f 07                	jg     802af5 <getchar+0x30>
  802aee:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802af3:	eb 04                	jmp    802af9 <getchar+0x34>
		return -E_EOF;
	return c;
  802af5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802af9:	c9                   	leave  
  802afa:	c3                   	ret    
	...

00802afc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
  802aff:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b02:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  802b09:	75 78                	jne    802b83 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  802b0b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b12:	00 
  802b13:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802b1a:	ee 
  802b1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b22:	e8 d4 e6 ff ff       	call   8011fb <sys_page_alloc>
  802b27:	85 c0                	test   %eax,%eax
  802b29:	79 20                	jns    802b4b <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  802b2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b2f:	c7 44 24 08 d1 35 80 	movl   $0x8035d1,0x8(%esp)
  802b36:	00 
  802b37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b3e:	00 
  802b3f:	c7 04 24 ef 35 80 00 	movl   $0x8035ef,(%esp)
  802b46:	e8 41 d7 ff ff       	call   80028c <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802b4b:	c7 44 24 04 90 2b 80 	movl   $0x802b90,0x4(%esp)
  802b52:	00 
  802b53:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b5a:	e8 c6 e4 ff ff       	call   801025 <sys_env_set_pgfault_upcall>
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	79 20                	jns    802b83 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802b63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b67:	c7 44 24 08 00 36 80 	movl   $0x803600,0x8(%esp)
  802b6e:	00 
  802b6f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802b76:	00 
  802b77:	c7 04 24 ef 35 80 00 	movl   $0x8035ef,(%esp)
  802b7e:	e8 09 d7 ff ff       	call   80028c <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	a3 7c 70 80 00       	mov    %eax,0x80707c
	
}
  802b8b:	c9                   	leave  
  802b8c:	c3                   	ret    
  802b8d:	00 00                	add    %al,(%eax)
	...

00802b90 <_pgfault_upcall>:
  802b90:	54                   	push   %esp
  802b91:	a1 7c 70 80 00       	mov    0x80707c,%eax
  802b96:	ff d0                	call   *%eax
  802b98:	83 c4 04             	add    $0x4,%esp
  802b9b:	89 e1                	mov    %esp,%ecx
  802b9d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
  802ba1:	8b 54 24 30          	mov    0x30(%esp),%edx
  802ba5:	89 d4                	mov    %edx,%esp
  802ba7:	53                   	push   %ebx
  802ba8:	89 cc                	mov    %ecx,%esp
  802baa:	83 ea 04             	sub    $0x4,%edx
  802bad:	89 54 24 30          	mov    %edx,0x30(%esp)
  802bb1:	83 c4 08             	add    $0x8,%esp
  802bb4:	61                   	popa   
  802bb5:	83 c4 04             	add    $0x4,%esp
  802bb8:	9d                   	popf   
  802bb9:	5c                   	pop    %esp
  802bba:	c3                   	ret    
  802bbb:	00 00                	add    %al,(%eax)
  802bbd:	00 00                	add    %al,(%eax)
	...

00802bc0 <__udivdi3>:
  802bc0:	55                   	push   %ebp
  802bc1:	89 e5                	mov    %esp,%ebp
  802bc3:	57                   	push   %edi
  802bc4:	56                   	push   %esi
  802bc5:	83 ec 10             	sub    $0x10,%esp
  802bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  802bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bce:	8b 75 10             	mov    0x10(%ebp),%esi
  802bd1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802bd9:	75 35                	jne    802c10 <__udivdi3+0x50>
  802bdb:	39 fe                	cmp    %edi,%esi
  802bdd:	77 61                	ja     802c40 <__udivdi3+0x80>
  802bdf:	85 f6                	test   %esi,%esi
  802be1:	75 0b                	jne    802bee <__udivdi3+0x2e>
  802be3:	b8 01 00 00 00       	mov    $0x1,%eax
  802be8:	31 d2                	xor    %edx,%edx
  802bea:	f7 f6                	div    %esi
  802bec:	89 c6                	mov    %eax,%esi
  802bee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802bf1:	31 d2                	xor    %edx,%edx
  802bf3:	89 f8                	mov    %edi,%eax
  802bf5:	f7 f6                	div    %esi
  802bf7:	89 c7                	mov    %eax,%edi
  802bf9:	89 c8                	mov    %ecx,%eax
  802bfb:	f7 f6                	div    %esi
  802bfd:	89 c1                	mov    %eax,%ecx
  802bff:	89 fa                	mov    %edi,%edx
  802c01:	89 c8                	mov    %ecx,%eax
  802c03:	83 c4 10             	add    $0x10,%esp
  802c06:	5e                   	pop    %esi
  802c07:	5f                   	pop    %edi
  802c08:	5d                   	pop    %ebp
  802c09:	c3                   	ret    
  802c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c10:	39 f8                	cmp    %edi,%eax
  802c12:	77 1c                	ja     802c30 <__udivdi3+0x70>
  802c14:	0f bd d0             	bsr    %eax,%edx
  802c17:	83 f2 1f             	xor    $0x1f,%edx
  802c1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c1d:	75 39                	jne    802c58 <__udivdi3+0x98>
  802c1f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802c22:	0f 86 a0 00 00 00    	jbe    802cc8 <__udivdi3+0x108>
  802c28:	39 f8                	cmp    %edi,%eax
  802c2a:	0f 82 98 00 00 00    	jb     802cc8 <__udivdi3+0x108>
  802c30:	31 ff                	xor    %edi,%edi
  802c32:	31 c9                	xor    %ecx,%ecx
  802c34:	89 c8                	mov    %ecx,%eax
  802c36:	89 fa                	mov    %edi,%edx
  802c38:	83 c4 10             	add    $0x10,%esp
  802c3b:	5e                   	pop    %esi
  802c3c:	5f                   	pop    %edi
  802c3d:	5d                   	pop    %ebp
  802c3e:	c3                   	ret    
  802c3f:	90                   	nop
  802c40:	89 d1                	mov    %edx,%ecx
  802c42:	89 fa                	mov    %edi,%edx
  802c44:	89 c8                	mov    %ecx,%eax
  802c46:	31 ff                	xor    %edi,%edi
  802c48:	f7 f6                	div    %esi
  802c4a:	89 c1                	mov    %eax,%ecx
  802c4c:	89 fa                	mov    %edi,%edx
  802c4e:	89 c8                	mov    %ecx,%eax
  802c50:	83 c4 10             	add    $0x10,%esp
  802c53:	5e                   	pop    %esi
  802c54:	5f                   	pop    %edi
  802c55:	5d                   	pop    %ebp
  802c56:	c3                   	ret    
  802c57:	90                   	nop
  802c58:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c5c:	89 f2                	mov    %esi,%edx
  802c5e:	d3 e0                	shl    %cl,%eax
  802c60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c63:	b8 20 00 00 00       	mov    $0x20,%eax
  802c68:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c6b:	89 c1                	mov    %eax,%ecx
  802c6d:	d3 ea                	shr    %cl,%edx
  802c6f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c73:	0b 55 ec             	or     -0x14(%ebp),%edx
  802c76:	d3 e6                	shl    %cl,%esi
  802c78:	89 c1                	mov    %eax,%ecx
  802c7a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802c7d:	89 fe                	mov    %edi,%esi
  802c7f:	d3 ee                	shr    %cl,%esi
  802c81:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c85:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8b:	d3 e7                	shl    %cl,%edi
  802c8d:	89 c1                	mov    %eax,%ecx
  802c8f:	d3 ea                	shr    %cl,%edx
  802c91:	09 d7                	or     %edx,%edi
  802c93:	89 f2                	mov    %esi,%edx
  802c95:	89 f8                	mov    %edi,%eax
  802c97:	f7 75 ec             	divl   -0x14(%ebp)
  802c9a:	89 d6                	mov    %edx,%esi
  802c9c:	89 c7                	mov    %eax,%edi
  802c9e:	f7 65 e8             	mull   -0x18(%ebp)
  802ca1:	39 d6                	cmp    %edx,%esi
  802ca3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ca6:	72 30                	jb     802cd8 <__udivdi3+0x118>
  802ca8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cab:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802caf:	d3 e2                	shl    %cl,%edx
  802cb1:	39 c2                	cmp    %eax,%edx
  802cb3:	73 05                	jae    802cba <__udivdi3+0xfa>
  802cb5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802cb8:	74 1e                	je     802cd8 <__udivdi3+0x118>
  802cba:	89 f9                	mov    %edi,%ecx
  802cbc:	31 ff                	xor    %edi,%edi
  802cbe:	e9 71 ff ff ff       	jmp    802c34 <__udivdi3+0x74>
  802cc3:	90                   	nop
  802cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cc8:	31 ff                	xor    %edi,%edi
  802cca:	b9 01 00 00 00       	mov    $0x1,%ecx
  802ccf:	e9 60 ff ff ff       	jmp    802c34 <__udivdi3+0x74>
  802cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cd8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802cdb:	31 ff                	xor    %edi,%edi
  802cdd:	89 c8                	mov    %ecx,%eax
  802cdf:	89 fa                	mov    %edi,%edx
  802ce1:	83 c4 10             	add    $0x10,%esp
  802ce4:	5e                   	pop    %esi
  802ce5:	5f                   	pop    %edi
  802ce6:	5d                   	pop    %ebp
  802ce7:	c3                   	ret    
	...

00802cf0 <__umoddi3>:
  802cf0:	55                   	push   %ebp
  802cf1:	89 e5                	mov    %esp,%ebp
  802cf3:	57                   	push   %edi
  802cf4:	56                   	push   %esi
  802cf5:	83 ec 20             	sub    $0x20,%esp
  802cf8:	8b 55 14             	mov    0x14(%ebp),%edx
  802cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cfe:	8b 7d 10             	mov    0x10(%ebp),%edi
  802d01:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d04:	85 d2                	test   %edx,%edx
  802d06:	89 c8                	mov    %ecx,%eax
  802d08:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802d0b:	75 13                	jne    802d20 <__umoddi3+0x30>
  802d0d:	39 f7                	cmp    %esi,%edi
  802d0f:	76 3f                	jbe    802d50 <__umoddi3+0x60>
  802d11:	89 f2                	mov    %esi,%edx
  802d13:	f7 f7                	div    %edi
  802d15:	89 d0                	mov    %edx,%eax
  802d17:	31 d2                	xor    %edx,%edx
  802d19:	83 c4 20             	add    $0x20,%esp
  802d1c:	5e                   	pop    %esi
  802d1d:	5f                   	pop    %edi
  802d1e:	5d                   	pop    %ebp
  802d1f:	c3                   	ret    
  802d20:	39 f2                	cmp    %esi,%edx
  802d22:	77 4c                	ja     802d70 <__umoddi3+0x80>
  802d24:	0f bd ca             	bsr    %edx,%ecx
  802d27:	83 f1 1f             	xor    $0x1f,%ecx
  802d2a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802d2d:	75 51                	jne    802d80 <__umoddi3+0x90>
  802d2f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802d32:	0f 87 e0 00 00 00    	ja     802e18 <__umoddi3+0x128>
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	29 f8                	sub    %edi,%eax
  802d3d:	19 d6                	sbb    %edx,%esi
  802d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	89 f2                	mov    %esi,%edx
  802d47:	83 c4 20             	add    $0x20,%esp
  802d4a:	5e                   	pop    %esi
  802d4b:	5f                   	pop    %edi
  802d4c:	5d                   	pop    %ebp
  802d4d:	c3                   	ret    
  802d4e:	66 90                	xchg   %ax,%ax
  802d50:	85 ff                	test   %edi,%edi
  802d52:	75 0b                	jne    802d5f <__umoddi3+0x6f>
  802d54:	b8 01 00 00 00       	mov    $0x1,%eax
  802d59:	31 d2                	xor    %edx,%edx
  802d5b:	f7 f7                	div    %edi
  802d5d:	89 c7                	mov    %eax,%edi
  802d5f:	89 f0                	mov    %esi,%eax
  802d61:	31 d2                	xor    %edx,%edx
  802d63:	f7 f7                	div    %edi
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	f7 f7                	div    %edi
  802d6a:	eb a9                	jmp    802d15 <__umoddi3+0x25>
  802d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d70:	89 c8                	mov    %ecx,%eax
  802d72:	89 f2                	mov    %esi,%edx
  802d74:	83 c4 20             	add    $0x20,%esp
  802d77:	5e                   	pop    %esi
  802d78:	5f                   	pop    %edi
  802d79:	5d                   	pop    %ebp
  802d7a:	c3                   	ret    
  802d7b:	90                   	nop
  802d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d80:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d84:	d3 e2                	shl    %cl,%edx
  802d86:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d89:	ba 20 00 00 00       	mov    $0x20,%edx
  802d8e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802d91:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d94:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d98:	89 fa                	mov    %edi,%edx
  802d9a:	d3 ea                	shr    %cl,%edx
  802d9c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802da0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802da3:	d3 e7                	shl    %cl,%edi
  802da5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802da9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802dac:	89 f2                	mov    %esi,%edx
  802dae:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802db1:	89 c7                	mov    %eax,%edi
  802db3:	d3 ea                	shr    %cl,%edx
  802db5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802db9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802dbc:	89 c2                	mov    %eax,%edx
  802dbe:	d3 e6                	shl    %cl,%esi
  802dc0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802dc4:	d3 ea                	shr    %cl,%edx
  802dc6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802dca:	09 d6                	or     %edx,%esi
  802dcc:	89 f0                	mov    %esi,%eax
  802dce:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802dd1:	d3 e7                	shl    %cl,%edi
  802dd3:	89 f2                	mov    %esi,%edx
  802dd5:	f7 75 f4             	divl   -0xc(%ebp)
  802dd8:	89 d6                	mov    %edx,%esi
  802dda:	f7 65 e8             	mull   -0x18(%ebp)
  802ddd:	39 d6                	cmp    %edx,%esi
  802ddf:	72 2b                	jb     802e0c <__umoddi3+0x11c>
  802de1:	39 c7                	cmp    %eax,%edi
  802de3:	72 23                	jb     802e08 <__umoddi3+0x118>
  802de5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802de9:	29 c7                	sub    %eax,%edi
  802deb:	19 d6                	sbb    %edx,%esi
  802ded:	89 f0                	mov    %esi,%eax
  802def:	89 f2                	mov    %esi,%edx
  802df1:	d3 ef                	shr    %cl,%edi
  802df3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802df7:	d3 e0                	shl    %cl,%eax
  802df9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802dfd:	09 f8                	or     %edi,%eax
  802dff:	d3 ea                	shr    %cl,%edx
  802e01:	83 c4 20             	add    $0x20,%esp
  802e04:	5e                   	pop    %esi
  802e05:	5f                   	pop    %edi
  802e06:	5d                   	pop    %ebp
  802e07:	c3                   	ret    
  802e08:	39 d6                	cmp    %edx,%esi
  802e0a:	75 d9                	jne    802de5 <__umoddi3+0xf5>
  802e0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e0f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802e12:	eb d1                	jmp    802de5 <__umoddi3+0xf5>
  802e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e18:	39 f2                	cmp    %esi,%edx
  802e1a:	0f 82 18 ff ff ff    	jb     802d38 <__umoddi3+0x48>
  802e20:	e9 1d ff ff ff       	jmp    802d42 <__umoddi3+0x52>
