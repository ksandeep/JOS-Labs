
obj/user/primespipe:     file format elf32-i386


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
  80002c:	e8 9f 02 00 00       	call   8002d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800040:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800043:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800046:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004d:	00 
  80004e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800052:	89 1c 24             	mov    %ebx,(%esp)
  800055:	e8 c2 1a 00 00       	call   801b1c <readn>
  80005a:	83 f8 04             	cmp    $0x4,%eax
  80005d:	74 31                	je     800090 <primeproc+0x5c>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005f:	85 c0                	test   %eax,%eax
  800061:	0f 9f c2             	setg   %dl
  800064:	0f b6 d2             	movzbl %dl,%edx
  800067:	83 ea 01             	sub    $0x1,%edx
  80006a:	21 c2                	and    %eax,%edx
  80006c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800070:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800074:	c7 44 24 08 e0 2e 80 	movl   $0x802ee0,0x8(%esp)
  80007b:	00 
  80007c:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800083:	00 
  800084:	c7 04 24 0f 2f 80 00 	movl   $0x802f0f,(%esp)
  80008b:	e8 ac 02 00 00       	call   80033c <_panic>

	cprintf("%d\n", p);
  800090:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800093:	89 44 24 04          	mov    %eax,0x4(%esp)
  800097:	c7 04 24 21 2f 80 00 	movl   $0x802f21,(%esp)
  80009e:	e8 5e 03 00 00       	call   800401 <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000a3:	89 3c 24             	mov    %edi,(%esp)
  8000a6:	e8 ae 26 00 00       	call   802759 <pipe>
  8000ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	79 20                	jns    8000d2 <primeproc+0x9e>
		panic("pipe: %e", i);
  8000b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b6:	c7 44 24 08 25 2f 80 	movl   $0x802f25,0x8(%esp)
  8000bd:	00 
  8000be:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c5:	00 
  8000c6:	c7 04 24 0f 2f 80 00 	movl   $0x802f0f,(%esp)
  8000cd:	e8 6a 02 00 00       	call   80033c <_panic>
	if ((id = fork()) < 0)
  8000d2:	e8 5e 14 00 00       	call   801535 <fork>
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	79 20                	jns    8000fb <primeproc+0xc7>
		panic("fork: %e", id);
  8000db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000df:	c7 44 24 08 2e 2f 80 	movl   $0x802f2e,0x8(%esp)
  8000e6:	00 
  8000e7:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000ee:	00 
  8000ef:	c7 04 24 0f 2f 80 00 	movl   $0x802f0f,(%esp)
  8000f6:	e8 41 02 00 00       	call   80033c <_panic>
	if (id == 0) {
  8000fb:	85 c0                	test   %eax,%eax
  8000fd:	75 1b                	jne    80011a <primeproc+0xe6>
		close(fd);
  8000ff:	89 1c 24             	mov    %ebx,(%esp)
  800102:	e8 e7 1a 00 00       	call   801bee <close>
		close(pfd[1]);
  800107:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80010a:	89 04 24             	mov    %eax,(%esp)
  80010d:	e8 dc 1a 00 00       	call   801bee <close>
		fd = pfd[0];
  800112:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800115:	e9 2c ff ff ff       	jmp    800046 <primeproc+0x12>
	}

	close(pfd[0]);
  80011a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 c9 1a 00 00       	call   801bee <close>
	wfd = pfd[1];
  800125:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800128:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80012b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800132:	00 
  800133:	89 74 24 04          	mov    %esi,0x4(%esp)
  800137:	89 1c 24             	mov    %ebx,(%esp)
  80013a:	e8 dd 19 00 00       	call   801b1c <readn>
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 3c                	je     800180 <primeproc+0x14c>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800144:	85 c0                	test   %eax,%eax
  800146:	0f 9f c2             	setg   %dl
  800149:	0f b6 d2             	movzbl %dl,%edx
  80014c:	83 ea 01             	sub    $0x1,%edx
  80014f:	21 c2                	and    %eax,%edx
  800151:	89 54 24 18          	mov    %edx,0x18(%esp)
  800155:	89 44 24 14          	mov    %eax,0x14(%esp)
  800159:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  80015d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800160:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800164:	c7 44 24 08 37 2f 80 	movl   $0x802f37,0x8(%esp)
  80016b:	00 
  80016c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  800173:	00 
  800174:	c7 04 24 0f 2f 80 00 	movl   $0x802f0f,(%esp)
  80017b:	e8 bc 01 00 00       	call   80033c <_panic>
		if (i%p)
  800180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800183:	89 d0                	mov    %edx,%eax
  800185:	c1 fa 1f             	sar    $0x1f,%edx
  800188:	f7 7d e0             	idivl  -0x20(%ebp)
  80018b:	85 d2                	test   %edx,%edx
  80018d:	74 9c                	je     80012b <primeproc+0xf7>
			if ((r=write(wfd, &i, 4)) != 4)
  80018f:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800196:	00 
  800197:	89 74 24 04          	mov    %esi,0x4(%esp)
  80019b:	89 3c 24             	mov    %edi,(%esp)
  80019e:	e8 62 18 00 00       	call   801a05 <write>
  8001a3:	83 f8 04             	cmp    $0x4,%eax
  8001a6:	74 83                	je     80012b <primeproc+0xf7>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	0f 9f c2             	setg   %dl
  8001ad:	0f b6 d2             	movzbl %dl,%edx
  8001b0:	83 ea 01             	sub    $0x1,%edx
  8001b3:	21 c2                	and    %eax,%edx
  8001b5:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c4:	c7 44 24 08 53 2f 80 	movl   $0x802f53,0x8(%esp)
  8001cb:	00 
  8001cc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001d3:	00 
  8001d4:	c7 04 24 0f 2f 80 00 	movl   $0x802f0f,(%esp)
  8001db:	e8 5c 01 00 00       	call   80033c <_panic>

008001e0 <umain>:
	}
}

void
umain(void)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	53                   	push   %ebx
  8001e4:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	argv0 = "primespipe";
  8001e7:	c7 05 78 70 80 00 6d 	movl   $0x802f6d,0x807078
  8001ee:	2f 80 00 

	if ((i=pipe(p)) < 0)
  8001f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 5d 25 00 00       	call   802759 <pipe>
  8001fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001ff:	85 c0                	test   %eax,%eax
  800201:	79 20                	jns    800223 <umain+0x43>
		panic("pipe: %e", i);
  800203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800207:	c7 44 24 08 25 2f 80 	movl   $0x802f25,0x8(%esp)
  80020e:	00 
  80020f:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800216:	00 
  800217:	c7 04 24 0f 2f 80 00 	movl   $0x802f0f,(%esp)
  80021e:	e8 19 01 00 00       	call   80033c <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800223:	e8 0d 13 00 00       	call   801535 <fork>
  800228:	85 c0                	test   %eax,%eax
  80022a:	79 20                	jns    80024c <umain+0x6c>
		panic("fork: %e", id);
  80022c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800230:	c7 44 24 08 2e 2f 80 	movl   $0x802f2e,0x8(%esp)
  800237:	00 
  800238:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  80023f:	00 
  800240:	c7 04 24 0f 2f 80 00 	movl   $0x802f0f,(%esp)
  800247:	e8 f0 00 00 00       	call   80033c <_panic>

	if (id == 0) {
  80024c:	85 c0                	test   %eax,%eax
  80024e:	75 16                	jne    800266 <umain+0x86>
		close(p[1]);
  800250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800253:	89 04 24             	mov    %eax,(%esp)
  800256:	e8 93 19 00 00       	call   801bee <close>
		primeproc(p[0]);
  80025b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	e8 ce fd ff ff       	call   800034 <primeproc>
	}

	close(p[0]);
  800266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800269:	89 04 24             	mov    %eax,(%esp)
  80026c:	e8 7d 19 00 00       	call   801bee <close>

	// feed all the integers through
	for (i=2;; i++)
  800271:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800278:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80027b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800282:	00 
  800283:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80028a:	89 04 24             	mov    %eax,(%esp)
  80028d:	e8 73 17 00 00       	call   801a05 <write>
  800292:	83 f8 04             	cmp    $0x4,%eax
  800295:	74 31                	je     8002c8 <umain+0xe8>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800297:	85 c0                	test   %eax,%eax
  800299:	0f 9f c2             	setg   %dl
  80029c:	0f b6 d2             	movzbl %dl,%edx
  80029f:	83 ea 01             	sub    $0x1,%edx
  8002a2:	21 c2                	and    %eax,%edx
  8002a4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ac:	c7 44 24 08 78 2f 80 	movl   $0x802f78,0x8(%esp)
  8002b3:	00 
  8002b4:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002bb:	00 
  8002bc:	c7 04 24 0f 2f 80 00 	movl   $0x802f0f,(%esp)
  8002c3:	e8 74 00 00 00       	call   80033c <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002cc:	eb ad                	jmp    80027b <umain+0x9b>
	...

008002d0 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
  8002d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002d9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8002df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8002e2:	e8 57 10 00 00       	call   80133e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8002e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f4:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f9:	85 f6                	test   %esi,%esi
  8002fb:	7e 07                	jle    800304 <libmain+0x34>
		binaryname = argv[0];
  8002fd:	8b 03                	mov    (%ebx),%eax
  8002ff:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800304:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800308:	89 34 24             	mov    %esi,(%esp)
  80030b:	e8 d0 fe ff ff       	call   8001e0 <umain>

	// exit gracefully
	exit();
  800310:	e8 0b 00 00 00       	call   800320 <exit>
}
  800315:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800318:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80031b:	89 ec                	mov    %ebp,%esp
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    
	...

00800320 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800326:	e8 40 19 00 00       	call   801c6b <close_all>
	sys_env_destroy(0);
  80032b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800332:	e8 3b 10 00 00       	call   801372 <sys_env_destroy>
}
  800337:	c9                   	leave  
  800338:	c3                   	ret    
  800339:	00 00                	add    %al,(%eax)
	...

0080033c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	53                   	push   %ebx
  800340:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800343:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800346:	a1 78 70 80 00       	mov    0x807078,%eax
  80034b:	85 c0                	test   %eax,%eax
  80034d:	74 10                	je     80035f <_panic+0x23>
		cprintf("%s: ", argv0);
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 a7 2f 80 00 	movl   $0x802fa7,(%esp)
  80035a:	e8 a2 00 00 00       	call   800401 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80035f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800362:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	89 44 24 08          	mov    %eax,0x8(%esp)
  80036d:	a1 00 70 80 00       	mov    0x807000,%eax
  800372:	89 44 24 04          	mov    %eax,0x4(%esp)
  800376:	c7 04 24 ac 2f 80 00 	movl   $0x802fac,(%esp)
  80037d:	e8 7f 00 00 00       	call   800401 <cprintf>
	vcprintf(fmt, ap);
  800382:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800386:	8b 45 10             	mov    0x10(%ebp),%eax
  800389:	89 04 24             	mov    %eax,(%esp)
  80038c:	e8 0f 00 00 00       	call   8003a0 <vcprintf>
	cprintf("\n");
  800391:	c7 04 24 23 2f 80 00 	movl   $0x802f23,(%esp)
  800398:	e8 64 00 00 00       	call   800401 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80039d:	cc                   	int3   
  80039e:	eb fd                	jmp    80039d <_panic+0x61>

008003a0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003b0:	00 00 00 
	b.cnt = 0;
  8003b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d5:	c7 04 24 1b 04 80 00 	movl   $0x80041b,(%esp)
  8003dc:	e8 cc 01 00 00       	call   8005ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f1:	89 04 24             	mov    %eax,(%esp)
  8003f4:	e8 b7 0a 00 00       	call   800eb0 <sys_cputs>

	return b.cnt;
}
  8003f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800407:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80040a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	e8 87 ff ff ff       	call   8003a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800419:	c9                   	leave  
  80041a:	c3                   	ret    

0080041b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	53                   	push   %ebx
  80041f:	83 ec 14             	sub    $0x14,%esp
  800422:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800425:	8b 03                	mov    (%ebx),%eax
  800427:	8b 55 08             	mov    0x8(%ebp),%edx
  80042a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80042e:	83 c0 01             	add    $0x1,%eax
  800431:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800433:	3d ff 00 00 00       	cmp    $0xff,%eax
  800438:	75 19                	jne    800453 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80043a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800441:	00 
  800442:	8d 43 08             	lea    0x8(%ebx),%eax
  800445:	89 04 24             	mov    %eax,(%esp)
  800448:	e8 63 0a 00 00       	call   800eb0 <sys_cputs>
		b->idx = 0;
  80044d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800453:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800457:	83 c4 14             	add    $0x14,%esp
  80045a:	5b                   	pop    %ebx
  80045b:	5d                   	pop    %ebp
  80045c:	c3                   	ret    
  80045d:	00 00                	add    %al,(%eax)
	...

00800460 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	57                   	push   %edi
  800464:	56                   	push   %esi
  800465:	53                   	push   %ebx
  800466:	83 ec 4c             	sub    $0x4c,%esp
  800469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046c:	89 d6                	mov    %edx,%esi
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800474:	8b 55 0c             	mov    0xc(%ebp),%edx
  800477:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80047a:	8b 45 10             	mov    0x10(%ebp),%eax
  80047d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800480:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800483:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800486:	b9 00 00 00 00       	mov    $0x0,%ecx
  80048b:	39 d1                	cmp    %edx,%ecx
  80048d:	72 15                	jb     8004a4 <printnum+0x44>
  80048f:	77 07                	ja     800498 <printnum+0x38>
  800491:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800494:	39 d0                	cmp    %edx,%eax
  800496:	76 0c                	jbe    8004a4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800498:	83 eb 01             	sub    $0x1,%ebx
  80049b:	85 db                	test   %ebx,%ebx
  80049d:	8d 76 00             	lea    0x0(%esi),%esi
  8004a0:	7f 61                	jg     800503 <printnum+0xa3>
  8004a2:	eb 70                	jmp    800514 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004a4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004a8:	83 eb 01             	sub    $0x1,%ebx
  8004ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8004b7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8004bb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004be:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004c1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8004c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004cf:	00 
  8004d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d3:	89 04 24             	mov    %eax,(%esp)
  8004d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004dd:	e8 8e 27 00 00       	call   802c70 <__udivdi3>
  8004e2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004e5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004f0:	89 04 24             	mov    %eax,(%esp)
  8004f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004f7:	89 f2                	mov    %esi,%edx
  8004f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004fc:	e8 5f ff ff ff       	call   800460 <printnum>
  800501:	eb 11                	jmp    800514 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800503:	89 74 24 04          	mov    %esi,0x4(%esp)
  800507:	89 3c 24             	mov    %edi,(%esp)
  80050a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050d:	83 eb 01             	sub    $0x1,%ebx
  800510:	85 db                	test   %ebx,%ebx
  800512:	7f ef                	jg     800503 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800514:	89 74 24 04          	mov    %esi,0x4(%esp)
  800518:	8b 74 24 04          	mov    0x4(%esp),%esi
  80051c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80051f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800523:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80052a:	00 
  80052b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052e:	89 14 24             	mov    %edx,(%esp)
  800531:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800534:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800538:	e8 63 28 00 00       	call   802da0 <__umoddi3>
  80053d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800541:	0f be 80 c8 2f 80 00 	movsbl 0x802fc8(%eax),%eax
  800548:	89 04 24             	mov    %eax,(%esp)
  80054b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80054e:	83 c4 4c             	add    $0x4c,%esp
  800551:	5b                   	pop    %ebx
  800552:	5e                   	pop    %esi
  800553:	5f                   	pop    %edi
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800559:	83 fa 01             	cmp    $0x1,%edx
  80055c:	7e 0e                	jle    80056c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	8d 4a 08             	lea    0x8(%edx),%ecx
  800563:	89 08                	mov    %ecx,(%eax)
  800565:	8b 02                	mov    (%edx),%eax
  800567:	8b 52 04             	mov    0x4(%edx),%edx
  80056a:	eb 22                	jmp    80058e <getuint+0x38>
	else if (lflag)
  80056c:	85 d2                	test   %edx,%edx
  80056e:	74 10                	je     800580 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800570:	8b 10                	mov    (%eax),%edx
  800572:	8d 4a 04             	lea    0x4(%edx),%ecx
  800575:	89 08                	mov    %ecx,(%eax)
  800577:	8b 02                	mov    (%edx),%eax
  800579:	ba 00 00 00 00       	mov    $0x0,%edx
  80057e:	eb 0e                	jmp    80058e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800580:	8b 10                	mov    (%eax),%edx
  800582:	8d 4a 04             	lea    0x4(%edx),%ecx
  800585:	89 08                	mov    %ecx,(%eax)
  800587:	8b 02                	mov    (%edx),%eax
  800589:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80058e:	5d                   	pop    %ebp
  80058f:	c3                   	ret    

00800590 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800596:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80059a:	8b 10                	mov    (%eax),%edx
  80059c:	3b 50 04             	cmp    0x4(%eax),%edx
  80059f:	73 0a                	jae    8005ab <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a4:	88 0a                	mov    %cl,(%edx)
  8005a6:	83 c2 01             	add    $0x1,%edx
  8005a9:	89 10                	mov    %edx,(%eax)
}
  8005ab:	5d                   	pop    %ebp
  8005ac:	c3                   	ret    

008005ad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	57                   	push   %edi
  8005b1:	56                   	push   %esi
  8005b2:	53                   	push   %ebx
  8005b3:	83 ec 5c             	sub    $0x5c,%esp
  8005b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005bf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8005c6:	eb 11                	jmp    8005d9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005c8:	85 c0                	test   %eax,%eax
  8005ca:	0f 84 ec 03 00 00    	je     8009bc <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8005d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d4:	89 04 24             	mov    %eax,(%esp)
  8005d7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d9:	0f b6 03             	movzbl (%ebx),%eax
  8005dc:	83 c3 01             	add    $0x1,%ebx
  8005df:	83 f8 25             	cmp    $0x25,%eax
  8005e2:	75 e4                	jne    8005c8 <vprintfmt+0x1b>
  8005e4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8005e8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8005ef:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800602:	eb 06                	jmp    80060a <vprintfmt+0x5d>
  800604:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800608:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060a:	0f b6 13             	movzbl (%ebx),%edx
  80060d:	0f b6 c2             	movzbl %dl,%eax
  800610:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800613:	8d 43 01             	lea    0x1(%ebx),%eax
  800616:	83 ea 23             	sub    $0x23,%edx
  800619:	80 fa 55             	cmp    $0x55,%dl
  80061c:	0f 87 7d 03 00 00    	ja     80099f <vprintfmt+0x3f2>
  800622:	0f b6 d2             	movzbl %dl,%edx
  800625:	ff 24 95 00 31 80 00 	jmp    *0x803100(,%edx,4)
  80062c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800630:	eb d6                	jmp    800608 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800632:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800635:	83 ea 30             	sub    $0x30,%edx
  800638:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80063b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80063e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800641:	83 fb 09             	cmp    $0x9,%ebx
  800644:	77 4c                	ja     800692 <vprintfmt+0xe5>
  800646:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800649:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80064c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80064f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800652:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800656:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800659:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80065c:	83 fb 09             	cmp    $0x9,%ebx
  80065f:	76 eb                	jbe    80064c <vprintfmt+0x9f>
  800661:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800664:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800667:	eb 29                	jmp    800692 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800669:	8b 55 14             	mov    0x14(%ebp),%edx
  80066c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80066f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800672:	8b 12                	mov    (%edx),%edx
  800674:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800677:	eb 19                	jmp    800692 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800679:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80067c:	c1 fa 1f             	sar    $0x1f,%edx
  80067f:	f7 d2                	not    %edx
  800681:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800684:	eb 82                	jmp    800608 <vprintfmt+0x5b>
  800686:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80068d:	e9 76 ff ff ff       	jmp    800608 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	0f 89 6c ff ff ff    	jns    800608 <vprintfmt+0x5b>
  80069c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80069f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006a5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006a8:	e9 5b ff ff ff       	jmp    800608 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ad:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8006b0:	e9 53 ff ff ff       	jmp    800608 <vprintfmt+0x5b>
  8006b5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 50 04             	lea    0x4(%eax),%edx
  8006be:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 04 24             	mov    %eax,(%esp)
  8006ca:	ff d7                	call   *%edi
  8006cc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006cf:	e9 05 ff ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  8006d4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 50 04             	lea    0x4(%eax),%edx
  8006dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 c2                	mov    %eax,%edx
  8006e4:	c1 fa 1f             	sar    $0x1f,%edx
  8006e7:	31 d0                	xor    %edx,%eax
  8006e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006eb:	83 f8 0f             	cmp    $0xf,%eax
  8006ee:	7f 0b                	jg     8006fb <vprintfmt+0x14e>
  8006f0:	8b 14 85 60 32 80 00 	mov    0x803260(,%eax,4),%edx
  8006f7:	85 d2                	test   %edx,%edx
  8006f9:	75 20                	jne    80071b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8006fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006ff:	c7 44 24 08 d9 2f 80 	movl   $0x802fd9,0x8(%esp)
  800706:	00 
  800707:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070b:	89 3c 24             	mov    %edi,(%esp)
  80070e:	e8 31 03 00 00       	call   800a44 <printfmt>
  800713:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800716:	e9 be fe ff ff       	jmp    8005d9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80071b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80071f:	c7 44 24 08 96 35 80 	movl   $0x803596,0x8(%esp)
  800726:	00 
  800727:	89 74 24 04          	mov    %esi,0x4(%esp)
  80072b:	89 3c 24             	mov    %edi,(%esp)
  80072e:	e8 11 03 00 00       	call   800a44 <printfmt>
  800733:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800736:	e9 9e fe ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  80073b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80073e:	89 c3                	mov    %eax,%ebx
  800740:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800746:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 50 04             	lea    0x4(%eax),%edx
  80074f:	89 55 14             	mov    %edx,0x14(%ebp)
  800752:	8b 00                	mov    (%eax),%eax
  800754:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800757:	85 c0                	test   %eax,%eax
  800759:	75 07                	jne    800762 <vprintfmt+0x1b5>
  80075b:	c7 45 e0 e2 2f 80 00 	movl   $0x802fe2,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800762:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800766:	7e 06                	jle    80076e <vprintfmt+0x1c1>
  800768:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80076c:	75 13                	jne    800781 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800771:	0f be 02             	movsbl (%edx),%eax
  800774:	85 c0                	test   %eax,%eax
  800776:	0f 85 99 00 00 00    	jne    800815 <vprintfmt+0x268>
  80077c:	e9 86 00 00 00       	jmp    800807 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800781:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800785:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800788:	89 0c 24             	mov    %ecx,(%esp)
  80078b:	e8 fb 02 00 00       	call   800a8b <strnlen>
  800790:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800793:	29 c2                	sub    %eax,%edx
  800795:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800798:	85 d2                	test   %edx,%edx
  80079a:	7e d2                	jle    80076e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80079c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8007a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007a3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8007a6:	89 d3                	mov    %edx,%ebx
  8007a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007af:	89 04 24             	mov    %eax,(%esp)
  8007b2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b4:	83 eb 01             	sub    $0x1,%ebx
  8007b7:	85 db                	test   %ebx,%ebx
  8007b9:	7f ed                	jg     8007a8 <vprintfmt+0x1fb>
  8007bb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007c5:	eb a7                	jmp    80076e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007cb:	74 18                	je     8007e5 <vprintfmt+0x238>
  8007cd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007d0:	83 fa 5e             	cmp    $0x5e,%edx
  8007d3:	76 10                	jbe    8007e5 <vprintfmt+0x238>
					putch('?', putdat);
  8007d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007e0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007e3:	eb 0a                	jmp    8007ef <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8007e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e9:	89 04 24             	mov    %eax,(%esp)
  8007ec:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ef:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007f3:	0f be 03             	movsbl (%ebx),%eax
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	74 05                	je     8007ff <vprintfmt+0x252>
  8007fa:	83 c3 01             	add    $0x1,%ebx
  8007fd:	eb 29                	jmp    800828 <vprintfmt+0x27b>
  8007ff:	89 fe                	mov    %edi,%esi
  800801:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800804:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800807:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080b:	7f 2e                	jg     80083b <vprintfmt+0x28e>
  80080d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800810:	e9 c4 fd ff ff       	jmp    8005d9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800815:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800818:	83 c2 01             	add    $0x1,%edx
  80081b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80081e:	89 f7                	mov    %esi,%edi
  800820:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800823:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800826:	89 d3                	mov    %edx,%ebx
  800828:	85 f6                	test   %esi,%esi
  80082a:	78 9b                	js     8007c7 <vprintfmt+0x21a>
  80082c:	83 ee 01             	sub    $0x1,%esi
  80082f:	79 96                	jns    8007c7 <vprintfmt+0x21a>
  800831:	89 fe                	mov    %edi,%esi
  800833:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800836:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800839:	eb cc                	jmp    800807 <vprintfmt+0x25a>
  80083b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80083e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800841:	89 74 24 04          	mov    %esi,0x4(%esp)
  800845:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80084c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80084e:	83 eb 01             	sub    $0x1,%ebx
  800851:	85 db                	test   %ebx,%ebx
  800853:	7f ec                	jg     800841 <vprintfmt+0x294>
  800855:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800858:	e9 7c fd ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  80085d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800860:	83 f9 01             	cmp    $0x1,%ecx
  800863:	7e 16                	jle    80087b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 50 08             	lea    0x8(%eax),%edx
  80086b:	89 55 14             	mov    %edx,0x14(%ebp)
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	8b 48 04             	mov    0x4(%eax),%ecx
  800873:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800876:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800879:	eb 32                	jmp    8008ad <vprintfmt+0x300>
	else if (lflag)
  80087b:	85 c9                	test   %ecx,%ecx
  80087d:	74 18                	je     800897 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 50 04             	lea    0x4(%eax),%edx
  800885:	89 55 14             	mov    %edx,0x14(%ebp)
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088d:	89 c1                	mov    %eax,%ecx
  80088f:	c1 f9 1f             	sar    $0x1f,%ecx
  800892:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800895:	eb 16                	jmp    8008ad <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 50 04             	lea    0x4(%eax),%edx
  80089d:	89 55 14             	mov    %edx,0x14(%ebp)
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a5:	89 c2                	mov    %eax,%edx
  8008a7:	c1 fa 1f             	sar    $0x1f,%edx
  8008aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ad:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8008b0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8008b3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8008b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008bc:	0f 89 9b 00 00 00    	jns    80095d <vprintfmt+0x3b0>
				putch('-', putdat);
  8008c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008cd:	ff d7                	call   *%edi
				num = -(long long) num;
  8008cf:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8008d2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8008d5:	f7 d9                	neg    %ecx
  8008d7:	83 d3 00             	adc    $0x0,%ebx
  8008da:	f7 db                	neg    %ebx
  8008dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e1:	eb 7a                	jmp    80095d <vprintfmt+0x3b0>
  8008e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e6:	89 ca                	mov    %ecx,%edx
  8008e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008eb:	e8 66 fc ff ff       	call   800556 <getuint>
  8008f0:	89 c1                	mov    %eax,%ecx
  8008f2:	89 d3                	mov    %edx,%ebx
  8008f4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8008f9:	eb 62                	jmp    80095d <vprintfmt+0x3b0>
  8008fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8008fe:	89 ca                	mov    %ecx,%edx
  800900:	8d 45 14             	lea    0x14(%ebp),%eax
  800903:	e8 4e fc ff ff       	call   800556 <getuint>
  800908:	89 c1                	mov    %eax,%ecx
  80090a:	89 d3                	mov    %edx,%ebx
  80090c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800911:	eb 4a                	jmp    80095d <vprintfmt+0x3b0>
  800913:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800916:	89 74 24 04          	mov    %esi,0x4(%esp)
  80091a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800921:	ff d7                	call   *%edi
			putch('x', putdat);
  800923:	89 74 24 04          	mov    %esi,0x4(%esp)
  800927:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80092e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 50 04             	lea    0x4(%eax),%edx
  800936:	89 55 14             	mov    %edx,0x14(%ebp)
  800939:	8b 08                	mov    (%eax),%ecx
  80093b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800940:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800945:	eb 16                	jmp    80095d <vprintfmt+0x3b0>
  800947:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80094a:	89 ca                	mov    %ecx,%edx
  80094c:	8d 45 14             	lea    0x14(%ebp),%eax
  80094f:	e8 02 fc ff ff       	call   800556 <getuint>
  800954:	89 c1                	mov    %eax,%ecx
  800956:	89 d3                	mov    %edx,%ebx
  800958:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80095d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800961:	89 54 24 10          	mov    %edx,0x10(%esp)
  800965:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800968:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80096c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800970:	89 0c 24             	mov    %ecx,(%esp)
  800973:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800977:	89 f2                	mov    %esi,%edx
  800979:	89 f8                	mov    %edi,%eax
  80097b:	e8 e0 fa ff ff       	call   800460 <printnum>
  800980:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800983:	e9 51 fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  800988:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80098b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80098e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800992:	89 14 24             	mov    %edx,(%esp)
  800995:	ff d7                	call   *%edi
  800997:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80099a:	e9 3a fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80099f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009a3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009aa:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8009af:	80 38 25             	cmpb   $0x25,(%eax)
  8009b2:	0f 84 21 fc ff ff    	je     8005d9 <vprintfmt+0x2c>
  8009b8:	89 c3                	mov    %eax,%ebx
  8009ba:	eb f0                	jmp    8009ac <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8009bc:	83 c4 5c             	add    $0x5c,%esp
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 28             	sub    $0x28,%esp
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8009d0:	85 c0                	test   %eax,%eax
  8009d2:	74 04                	je     8009d8 <vsnprintf+0x14>
  8009d4:	85 d2                	test   %edx,%edx
  8009d6:	7f 07                	jg     8009df <vsnprintf+0x1b>
  8009d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009dd:	eb 3b                	jmp    800a1a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a05:	c7 04 24 90 05 80 00 	movl   $0x800590,(%esp)
  800a0c:	e8 9c fb ff ff       	call   8005ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a22:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a29:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	89 04 24             	mov    %eax,(%esp)
  800a3d:	e8 82 ff ff ff       	call   8009c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800a4a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800a4d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a51:	8b 45 10             	mov    0x10(%ebp),%eax
  800a54:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	89 04 24             	mov    %eax,(%esp)
  800a65:	e8 43 fb ff ff       	call   8005ad <vprintfmt>
	va_end(ap);
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    
  800a6c:	00 00                	add    %al,(%eax)
	...

00800a70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	80 3a 00             	cmpb   $0x0,(%edx)
  800a7e:	74 09                	je     800a89 <strlen+0x19>
		n++;
  800a80:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a87:	75 f7                	jne    800a80 <strlen+0x10>
		n++;
	return n;
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	53                   	push   %ebx
  800a8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a95:	85 c9                	test   %ecx,%ecx
  800a97:	74 19                	je     800ab2 <strnlen+0x27>
  800a99:	80 3b 00             	cmpb   $0x0,(%ebx)
  800a9c:	74 14                	je     800ab2 <strnlen+0x27>
  800a9e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800aa3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa6:	39 c8                	cmp    %ecx,%eax
  800aa8:	74 0d                	je     800ab7 <strnlen+0x2c>
  800aaa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800aae:	75 f3                	jne    800aa3 <strnlen+0x18>
  800ab0:	eb 05                	jmp    800ab7 <strnlen+0x2c>
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ac9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800acd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ad0:	83 c2 01             	add    $0x1,%edx
  800ad3:	84 c9                	test   %cl,%cl
  800ad5:	75 f2                	jne    800ac9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	56                   	push   %esi
  800ade:	53                   	push   %ebx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae8:	85 f6                	test   %esi,%esi
  800aea:	74 18                	je     800b04 <strncpy+0x2a>
  800aec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800af1:	0f b6 1a             	movzbl (%edx),%ebx
  800af4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800af7:	80 3a 01             	cmpb   $0x1,(%edx)
  800afa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800afd:	83 c1 01             	add    $0x1,%ecx
  800b00:	39 ce                	cmp    %ecx,%esi
  800b02:	77 ed                	ja     800af1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b13:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b16:	89 f0                	mov    %esi,%eax
  800b18:	85 c9                	test   %ecx,%ecx
  800b1a:	74 27                	je     800b43 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800b1c:	83 e9 01             	sub    $0x1,%ecx
  800b1f:	74 1d                	je     800b3e <strlcpy+0x36>
  800b21:	0f b6 1a             	movzbl (%edx),%ebx
  800b24:	84 db                	test   %bl,%bl
  800b26:	74 16                	je     800b3e <strlcpy+0x36>
			*dst++ = *src++;
  800b28:	88 18                	mov    %bl,(%eax)
  800b2a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b2d:	83 e9 01             	sub    $0x1,%ecx
  800b30:	74 0e                	je     800b40 <strlcpy+0x38>
			*dst++ = *src++;
  800b32:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b35:	0f b6 1a             	movzbl (%edx),%ebx
  800b38:	84 db                	test   %bl,%bl
  800b3a:	75 ec                	jne    800b28 <strlcpy+0x20>
  800b3c:	eb 02                	jmp    800b40 <strlcpy+0x38>
  800b3e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800b40:	c6 00 00             	movb   $0x0,(%eax)
  800b43:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b52:	0f b6 01             	movzbl (%ecx),%eax
  800b55:	84 c0                	test   %al,%al
  800b57:	74 15                	je     800b6e <strcmp+0x25>
  800b59:	3a 02                	cmp    (%edx),%al
  800b5b:	75 11                	jne    800b6e <strcmp+0x25>
		p++, q++;
  800b5d:	83 c1 01             	add    $0x1,%ecx
  800b60:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b63:	0f b6 01             	movzbl (%ecx),%eax
  800b66:	84 c0                	test   %al,%al
  800b68:	74 04                	je     800b6e <strcmp+0x25>
  800b6a:	3a 02                	cmp    (%edx),%al
  800b6c:	74 ef                	je     800b5d <strcmp+0x14>
  800b6e:	0f b6 c0             	movzbl %al,%eax
  800b71:	0f b6 12             	movzbl (%edx),%edx
  800b74:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	53                   	push   %ebx
  800b7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b82:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800b85:	85 c0                	test   %eax,%eax
  800b87:	74 23                	je     800bac <strncmp+0x34>
  800b89:	0f b6 1a             	movzbl (%edx),%ebx
  800b8c:	84 db                	test   %bl,%bl
  800b8e:	74 24                	je     800bb4 <strncmp+0x3c>
  800b90:	3a 19                	cmp    (%ecx),%bl
  800b92:	75 20                	jne    800bb4 <strncmp+0x3c>
  800b94:	83 e8 01             	sub    $0x1,%eax
  800b97:	74 13                	je     800bac <strncmp+0x34>
		n--, p++, q++;
  800b99:	83 c2 01             	add    $0x1,%edx
  800b9c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b9f:	0f b6 1a             	movzbl (%edx),%ebx
  800ba2:	84 db                	test   %bl,%bl
  800ba4:	74 0e                	je     800bb4 <strncmp+0x3c>
  800ba6:	3a 19                	cmp    (%ecx),%bl
  800ba8:	74 ea                	je     800b94 <strncmp+0x1c>
  800baa:	eb 08                	jmp    800bb4 <strncmp+0x3c>
  800bac:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb4:	0f b6 02             	movzbl (%edx),%eax
  800bb7:	0f b6 11             	movzbl (%ecx),%edx
  800bba:	29 d0                	sub    %edx,%eax
  800bbc:	eb f3                	jmp    800bb1 <strncmp+0x39>

00800bbe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc8:	0f b6 10             	movzbl (%eax),%edx
  800bcb:	84 d2                	test   %dl,%dl
  800bcd:	74 15                	je     800be4 <strchr+0x26>
		if (*s == c)
  800bcf:	38 ca                	cmp    %cl,%dl
  800bd1:	75 07                	jne    800bda <strchr+0x1c>
  800bd3:	eb 14                	jmp    800be9 <strchr+0x2b>
  800bd5:	38 ca                	cmp    %cl,%dl
  800bd7:	90                   	nop
  800bd8:	74 0f                	je     800be9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bda:	83 c0 01             	add    $0x1,%eax
  800bdd:	0f b6 10             	movzbl (%eax),%edx
  800be0:	84 d2                	test   %dl,%dl
  800be2:	75 f1                	jne    800bd5 <strchr+0x17>
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bf5:	0f b6 10             	movzbl (%eax),%edx
  800bf8:	84 d2                	test   %dl,%dl
  800bfa:	74 18                	je     800c14 <strfind+0x29>
		if (*s == c)
  800bfc:	38 ca                	cmp    %cl,%dl
  800bfe:	75 0a                	jne    800c0a <strfind+0x1f>
  800c00:	eb 12                	jmp    800c14 <strfind+0x29>
  800c02:	38 ca                	cmp    %cl,%dl
  800c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c08:	74 0a                	je     800c14 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c0a:	83 c0 01             	add    $0x1,%eax
  800c0d:	0f b6 10             	movzbl (%eax),%edx
  800c10:	84 d2                	test   %dl,%dl
  800c12:	75 ee                	jne    800c02 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 0c             	sub    $0xc,%esp
  800c1c:	89 1c 24             	mov    %ebx,(%esp)
  800c1f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c23:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c27:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c30:	85 c9                	test   %ecx,%ecx
  800c32:	74 30                	je     800c64 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c34:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c3a:	75 25                	jne    800c61 <memset+0x4b>
  800c3c:	f6 c1 03             	test   $0x3,%cl
  800c3f:	75 20                	jne    800c61 <memset+0x4b>
		c &= 0xFF;
  800c41:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c44:	89 d3                	mov    %edx,%ebx
  800c46:	c1 e3 08             	shl    $0x8,%ebx
  800c49:	89 d6                	mov    %edx,%esi
  800c4b:	c1 e6 18             	shl    $0x18,%esi
  800c4e:	89 d0                	mov    %edx,%eax
  800c50:	c1 e0 10             	shl    $0x10,%eax
  800c53:	09 f0                	or     %esi,%eax
  800c55:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800c57:	09 d8                	or     %ebx,%eax
  800c59:	c1 e9 02             	shr    $0x2,%ecx
  800c5c:	fc                   	cld    
  800c5d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c5f:	eb 03                	jmp    800c64 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c61:	fc                   	cld    
  800c62:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c64:	89 f8                	mov    %edi,%eax
  800c66:	8b 1c 24             	mov    (%esp),%ebx
  800c69:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c6d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c71:	89 ec                	mov    %ebp,%esp
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	89 34 24             	mov    %esi,(%esp)
  800c7e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800c88:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800c8b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c8d:	39 c6                	cmp    %eax,%esi
  800c8f:	73 35                	jae    800cc6 <memmove+0x51>
  800c91:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c94:	39 d0                	cmp    %edx,%eax
  800c96:	73 2e                	jae    800cc6 <memmove+0x51>
		s += n;
		d += n;
  800c98:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c9a:	f6 c2 03             	test   $0x3,%dl
  800c9d:	75 1b                	jne    800cba <memmove+0x45>
  800c9f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ca5:	75 13                	jne    800cba <memmove+0x45>
  800ca7:	f6 c1 03             	test   $0x3,%cl
  800caa:	75 0e                	jne    800cba <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800cac:	83 ef 04             	sub    $0x4,%edi
  800caf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cb2:	c1 e9 02             	shr    $0x2,%ecx
  800cb5:	fd                   	std    
  800cb6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb8:	eb 09                	jmp    800cc3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800cba:	83 ef 01             	sub    $0x1,%edi
  800cbd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800cc0:	fd                   	std    
  800cc1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cc3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cc4:	eb 20                	jmp    800ce6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cc6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ccc:	75 15                	jne    800ce3 <memmove+0x6e>
  800cce:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cd4:	75 0d                	jne    800ce3 <memmove+0x6e>
  800cd6:	f6 c1 03             	test   $0x3,%cl
  800cd9:	75 08                	jne    800ce3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800cdb:	c1 e9 02             	shr    $0x2,%ecx
  800cde:	fc                   	cld    
  800cdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ce1:	eb 03                	jmp    800ce6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ce3:	fc                   	cld    
  800ce4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ce6:	8b 34 24             	mov    (%esp),%esi
  800ce9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ced:	89 ec                	mov    %ebp,%esp
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	89 04 24             	mov    %eax,(%esp)
  800d0b:	e8 65 ff ff ff       	call   800c75 <memmove>
}
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	8b 75 08             	mov    0x8(%ebp),%esi
  800d1b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d21:	85 c9                	test   %ecx,%ecx
  800d23:	74 36                	je     800d5b <memcmp+0x49>
		if (*s1 != *s2)
  800d25:	0f b6 06             	movzbl (%esi),%eax
  800d28:	0f b6 1f             	movzbl (%edi),%ebx
  800d2b:	38 d8                	cmp    %bl,%al
  800d2d:	74 20                	je     800d4f <memcmp+0x3d>
  800d2f:	eb 14                	jmp    800d45 <memcmp+0x33>
  800d31:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800d36:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800d3b:	83 c2 01             	add    $0x1,%edx
  800d3e:	83 e9 01             	sub    $0x1,%ecx
  800d41:	38 d8                	cmp    %bl,%al
  800d43:	74 12                	je     800d57 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800d45:	0f b6 c0             	movzbl %al,%eax
  800d48:	0f b6 db             	movzbl %bl,%ebx
  800d4b:	29 d8                	sub    %ebx,%eax
  800d4d:	eb 11                	jmp    800d60 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d4f:	83 e9 01             	sub    $0x1,%ecx
  800d52:	ba 00 00 00 00       	mov    $0x0,%edx
  800d57:	85 c9                	test   %ecx,%ecx
  800d59:	75 d6                	jne    800d31 <memcmp+0x1f>
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5f                   	pop    %edi
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800d6b:	89 c2                	mov    %eax,%edx
  800d6d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d70:	39 d0                	cmp    %edx,%eax
  800d72:	73 15                	jae    800d89 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800d78:	38 08                	cmp    %cl,(%eax)
  800d7a:	75 06                	jne    800d82 <memfind+0x1d>
  800d7c:	eb 0b                	jmp    800d89 <memfind+0x24>
  800d7e:	38 08                	cmp    %cl,(%eax)
  800d80:	74 07                	je     800d89 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d82:	83 c0 01             	add    $0x1,%eax
  800d85:	39 c2                	cmp    %eax,%edx
  800d87:	77 f5                	ja     800d7e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	83 ec 04             	sub    $0x4,%esp
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d9a:	0f b6 02             	movzbl (%edx),%eax
  800d9d:	3c 20                	cmp    $0x20,%al
  800d9f:	74 04                	je     800da5 <strtol+0x1a>
  800da1:	3c 09                	cmp    $0x9,%al
  800da3:	75 0e                	jne    800db3 <strtol+0x28>
		s++;
  800da5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800da8:	0f b6 02             	movzbl (%edx),%eax
  800dab:	3c 20                	cmp    $0x20,%al
  800dad:	74 f6                	je     800da5 <strtol+0x1a>
  800daf:	3c 09                	cmp    $0x9,%al
  800db1:	74 f2                	je     800da5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800db3:	3c 2b                	cmp    $0x2b,%al
  800db5:	75 0c                	jne    800dc3 <strtol+0x38>
		s++;
  800db7:	83 c2 01             	add    $0x1,%edx
  800dba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dc1:	eb 15                	jmp    800dd8 <strtol+0x4d>
	else if (*s == '-')
  800dc3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dca:	3c 2d                	cmp    $0x2d,%al
  800dcc:	75 0a                	jne    800dd8 <strtol+0x4d>
		s++, neg = 1;
  800dce:	83 c2 01             	add    $0x1,%edx
  800dd1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dd8:	85 db                	test   %ebx,%ebx
  800dda:	0f 94 c0             	sete   %al
  800ddd:	74 05                	je     800de4 <strtol+0x59>
  800ddf:	83 fb 10             	cmp    $0x10,%ebx
  800de2:	75 18                	jne    800dfc <strtol+0x71>
  800de4:	80 3a 30             	cmpb   $0x30,(%edx)
  800de7:	75 13                	jne    800dfc <strtol+0x71>
  800de9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ded:	8d 76 00             	lea    0x0(%esi),%esi
  800df0:	75 0a                	jne    800dfc <strtol+0x71>
		s += 2, base = 16;
  800df2:	83 c2 02             	add    $0x2,%edx
  800df5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dfa:	eb 15                	jmp    800e11 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dfc:	84 c0                	test   %al,%al
  800dfe:	66 90                	xchg   %ax,%ax
  800e00:	74 0f                	je     800e11 <strtol+0x86>
  800e02:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800e07:	80 3a 30             	cmpb   $0x30,(%edx)
  800e0a:	75 05                	jne    800e11 <strtol+0x86>
		s++, base = 8;
  800e0c:	83 c2 01             	add    $0x1,%edx
  800e0f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
  800e16:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e18:	0f b6 0a             	movzbl (%edx),%ecx
  800e1b:	89 cf                	mov    %ecx,%edi
  800e1d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e20:	80 fb 09             	cmp    $0x9,%bl
  800e23:	77 08                	ja     800e2d <strtol+0xa2>
			dig = *s - '0';
  800e25:	0f be c9             	movsbl %cl,%ecx
  800e28:	83 e9 30             	sub    $0x30,%ecx
  800e2b:	eb 1e                	jmp    800e4b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800e2d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800e30:	80 fb 19             	cmp    $0x19,%bl
  800e33:	77 08                	ja     800e3d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800e35:	0f be c9             	movsbl %cl,%ecx
  800e38:	83 e9 57             	sub    $0x57,%ecx
  800e3b:	eb 0e                	jmp    800e4b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800e3d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800e40:	80 fb 19             	cmp    $0x19,%bl
  800e43:	77 15                	ja     800e5a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800e45:	0f be c9             	movsbl %cl,%ecx
  800e48:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e4b:	39 f1                	cmp    %esi,%ecx
  800e4d:	7d 0b                	jge    800e5a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800e4f:	83 c2 01             	add    $0x1,%edx
  800e52:	0f af c6             	imul   %esi,%eax
  800e55:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800e58:	eb be                	jmp    800e18 <strtol+0x8d>
  800e5a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800e5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e60:	74 05                	je     800e67 <strtol+0xdc>
		*endptr = (char *) s;
  800e62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e65:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e6b:	74 04                	je     800e71 <strtol+0xe6>
  800e6d:	89 c8                	mov    %ecx,%eax
  800e6f:	f7 d8                	neg    %eax
}
  800e71:	83 c4 04             	add    $0x4,%esp
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    
  800e79:	00 00                	add    %al,(%eax)
	...

00800e7c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	89 1c 24             	mov    %ebx,(%esp)
  800e85:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e89:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e92:	b8 01 00 00 00       	mov    $0x1,%eax
  800e97:	89 d1                	mov    %edx,%ecx
  800e99:	89 d3                	mov    %edx,%ebx
  800e9b:	89 d7                	mov    %edx,%edi
  800e9d:	89 d6                	mov    %edx,%esi
  800e9f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ea1:	8b 1c 24             	mov    (%esp),%ebx
  800ea4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ea8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eac:	89 ec                	mov    %ebp,%esp
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	89 1c 24             	mov    %ebx,(%esp)
  800eb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ebd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	89 c3                	mov    %eax,%ebx
  800ece:	89 c7                	mov    %eax,%edi
  800ed0:	89 c6                	mov    %eax,%esi
  800ed2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ed4:	8b 1c 24             	mov    (%esp),%ebx
  800ed7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800edb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800edf:	89 ec                	mov    %ebp,%esp
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 38             	sub    $0x38,%esp
  800ee9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eef:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef2:	be 00 00 00 00       	mov    $0x0,%esi
  800ef7:	b8 12 00 00 00       	mov    $0x12,%eax
  800efc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7e 28                	jle    800f36 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f12:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f19:	00 
  800f1a:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  800f21:	00 
  800f22:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f29:	00 
  800f2a:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  800f31:	e8 06 f4 ff ff       	call   80033c <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800f36:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f39:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f3c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f3f:	89 ec                	mov    %ebp,%esp
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 0c             	sub    $0xc,%esp
  800f49:	89 1c 24             	mov    %ebx,(%esp)
  800f4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f50:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f59:	b8 11 00 00 00       	mov    $0x11,%eax
  800f5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	89 df                	mov    %ebx,%edi
  800f66:	89 de                	mov    %ebx,%esi
  800f68:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800f6a:	8b 1c 24             	mov    (%esp),%ebx
  800f6d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f71:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f75:	89 ec                	mov    %ebp,%esp
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	89 1c 24             	mov    %ebx,(%esp)
  800f82:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f86:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8f:	b8 10 00 00 00       	mov    $0x10,%eax
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	89 cb                	mov    %ecx,%ebx
  800f99:	89 cf                	mov    %ecx,%edi
  800f9b:	89 ce                	mov    %ecx,%esi
  800f9d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800f9f:	8b 1c 24             	mov    (%esp),%ebx
  800fa2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fa6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800faa:	89 ec                	mov    %ebp,%esp
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	83 ec 38             	sub    $0x38,%esp
  800fb4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	89 df                	mov    %ebx,%edi
  800fcf:	89 de                	mov    %ebx,%esi
  800fd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	7e 28                	jle    800fff <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fdb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fe2:	00 
  800fe3:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  800fea:	00 
  800feb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff2:	00 
  800ff3:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  800ffa:	e8 3d f3 ff ff       	call   80033c <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800fff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801002:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801005:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801008:	89 ec                	mov    %ebp,%esp
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 0c             	sub    $0xc,%esp
  801012:	89 1c 24             	mov    %ebx,(%esp)
  801015:	89 74 24 04          	mov    %esi,0x4(%esp)
  801019:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101d:	ba 00 00 00 00       	mov    $0x0,%edx
  801022:	b8 0e 00 00 00       	mov    $0xe,%eax
  801027:	89 d1                	mov    %edx,%ecx
  801029:	89 d3                	mov    %edx,%ebx
  80102b:	89 d7                	mov    %edx,%edi
  80102d:	89 d6                	mov    %edx,%esi
  80102f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  801031:	8b 1c 24             	mov    (%esp),%ebx
  801034:	8b 74 24 04          	mov    0x4(%esp),%esi
  801038:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80103c:	89 ec                	mov    %ebp,%esp
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    

00801040 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 38             	sub    $0x38,%esp
  801046:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801049:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80104c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801054:	b8 0d 00 00 00       	mov    $0xd,%eax
  801059:	8b 55 08             	mov    0x8(%ebp),%edx
  80105c:	89 cb                	mov    %ecx,%ebx
  80105e:	89 cf                	mov    %ecx,%edi
  801060:	89 ce                	mov    %ecx,%esi
  801062:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801064:	85 c0                	test   %eax,%eax
  801066:	7e 28                	jle    801090 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801068:	89 44 24 10          	mov    %eax,0x10(%esp)
  80106c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801073:	00 
  801074:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  80107b:	00 
  80107c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801083:	00 
  801084:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  80108b:	e8 ac f2 ff ff       	call   80033c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801090:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801093:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801096:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801099:	89 ec                	mov    %ebp,%esp
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	83 ec 0c             	sub    $0xc,%esp
  8010a3:	89 1c 24             	mov    %ebx,(%esp)
  8010a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ae:	be 00 00 00 00       	mov    $0x0,%esi
  8010b3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010c6:	8b 1c 24             	mov    (%esp),%ebx
  8010c9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010cd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010d1:	89 ec                	mov    %ebp,%esp
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    

008010d5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 38             	sub    $0x38,%esp
  8010db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f4:	89 df                	mov    %ebx,%edi
  8010f6:	89 de                	mov    %ebx,%esi
  8010f8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	7e 28                	jle    801126 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801102:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801109:	00 
  80110a:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  801111:	00 
  801112:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801119:	00 
  80111a:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  801121:	e8 16 f2 ff ff       	call   80033c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801126:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801129:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80112c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80112f:	89 ec                	mov    %ebp,%esp
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	83 ec 38             	sub    $0x38,%esp
  801139:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80113c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80113f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801142:	bb 00 00 00 00       	mov    $0x0,%ebx
  801147:	b8 09 00 00 00       	mov    $0x9,%eax
  80114c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114f:	8b 55 08             	mov    0x8(%ebp),%edx
  801152:	89 df                	mov    %ebx,%edi
  801154:	89 de                	mov    %ebx,%esi
  801156:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801158:	85 c0                	test   %eax,%eax
  80115a:	7e 28                	jle    801184 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80115c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801160:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801167:	00 
  801168:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  80116f:	00 
  801170:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801177:	00 
  801178:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  80117f:	e8 b8 f1 ff ff       	call   80033c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801184:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801187:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80118a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80118d:	89 ec                	mov    %ebp,%esp
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 38             	sub    $0x38,%esp
  801197:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80119a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80119d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8011aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	89 df                	mov    %ebx,%edi
  8011b2:	89 de                	mov    %ebx,%esi
  8011b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	7e 28                	jle    8011e2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011be:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8011c5:	00 
  8011c6:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  8011cd:	00 
  8011ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d5:	00 
  8011d6:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  8011dd:	e8 5a f1 ff ff       	call   80033c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011eb:	89 ec                	mov    %ebp,%esp
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    

008011ef <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	83 ec 38             	sub    $0x38,%esp
  8011f5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011f8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011fb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801203:	b8 06 00 00 00       	mov    $0x6,%eax
  801208:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120b:	8b 55 08             	mov    0x8(%ebp),%edx
  80120e:	89 df                	mov    %ebx,%edi
  801210:	89 de                	mov    %ebx,%esi
  801212:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801214:	85 c0                	test   %eax,%eax
  801216:	7e 28                	jle    801240 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801218:	89 44 24 10          	mov    %eax,0x10(%esp)
  80121c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801223:	00 
  801224:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  80122b:	00 
  80122c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801233:	00 
  801234:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  80123b:	e8 fc f0 ff ff       	call   80033c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801240:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801243:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801246:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801249:	89 ec                	mov    %ebp,%esp
  80124b:	5d                   	pop    %ebp
  80124c:	c3                   	ret    

0080124d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 38             	sub    $0x38,%esp
  801253:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801256:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801259:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125c:	b8 05 00 00 00       	mov    $0x5,%eax
  801261:	8b 75 18             	mov    0x18(%ebp),%esi
  801264:	8b 7d 14             	mov    0x14(%ebp),%edi
  801267:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80126a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126d:	8b 55 08             	mov    0x8(%ebp),%edx
  801270:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801272:	85 c0                	test   %eax,%eax
  801274:	7e 28                	jle    80129e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801276:	89 44 24 10          	mov    %eax,0x10(%esp)
  80127a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801281:	00 
  801282:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  801289:	00 
  80128a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801291:	00 
  801292:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  801299:	e8 9e f0 ff ff       	call   80033c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80129e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012a7:	89 ec                	mov    %ebp,%esp
  8012a9:	5d                   	pop    %ebp
  8012aa:	c3                   	ret    

008012ab <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	83 ec 38             	sub    $0x38,%esp
  8012b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ba:	be 00 00 00 00       	mov    $0x0,%esi
  8012bf:	b8 04 00 00 00       	mov    $0x4,%eax
  8012c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cd:	89 f7                	mov    %esi,%edi
  8012cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012d1:	85 c0                	test   %eax,%eax
  8012d3:	7e 28                	jle    8012fd <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8012e0:	00 
  8012e1:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  8012e8:	00 
  8012e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012f0:	00 
  8012f1:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  8012f8:	e8 3f f0 ff ff       	call   80033c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801300:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801303:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801306:	89 ec                	mov    %ebp,%esp
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    

0080130a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	83 ec 0c             	sub    $0xc,%esp
  801310:	89 1c 24             	mov    %ebx,(%esp)
  801313:	89 74 24 04          	mov    %esi,0x4(%esp)
  801317:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80131b:	ba 00 00 00 00       	mov    $0x0,%edx
  801320:	b8 0b 00 00 00       	mov    $0xb,%eax
  801325:	89 d1                	mov    %edx,%ecx
  801327:	89 d3                	mov    %edx,%ebx
  801329:	89 d7                	mov    %edx,%edi
  80132b:	89 d6                	mov    %edx,%esi
  80132d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80132f:	8b 1c 24             	mov    (%esp),%ebx
  801332:	8b 74 24 04          	mov    0x4(%esp),%esi
  801336:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80133a:	89 ec                	mov    %ebp,%esp
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 0c             	sub    $0xc,%esp
  801344:	89 1c 24             	mov    %ebx,(%esp)
  801347:	89 74 24 04          	mov    %esi,0x4(%esp)
  80134b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80134f:	ba 00 00 00 00       	mov    $0x0,%edx
  801354:	b8 02 00 00 00       	mov    $0x2,%eax
  801359:	89 d1                	mov    %edx,%ecx
  80135b:	89 d3                	mov    %edx,%ebx
  80135d:	89 d7                	mov    %edx,%edi
  80135f:	89 d6                	mov    %edx,%esi
  801361:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801363:	8b 1c 24             	mov    (%esp),%ebx
  801366:	8b 74 24 04          	mov    0x4(%esp),%esi
  80136a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80136e:	89 ec                	mov    %ebp,%esp
  801370:	5d                   	pop    %ebp
  801371:	c3                   	ret    

00801372 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 38             	sub    $0x38,%esp
  801378:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80137b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80137e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801381:	b9 00 00 00 00       	mov    $0x0,%ecx
  801386:	b8 03 00 00 00       	mov    $0x3,%eax
  80138b:	8b 55 08             	mov    0x8(%ebp),%edx
  80138e:	89 cb                	mov    %ecx,%ebx
  801390:	89 cf                	mov    %ecx,%edi
  801392:	89 ce                	mov    %ecx,%esi
  801394:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801396:	85 c0                	test   %eax,%eax
  801398:	7e 28                	jle    8013c2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80139a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80139e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8013a5:	00 
  8013a6:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  8013ad:	00 
  8013ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013b5:	00 
  8013b6:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  8013bd:	e8 7a ef ff ff       	call   80033c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013c5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013cb:	89 ec                	mov    %ebp,%esp
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    
	...

008013d0 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013d6:	c7 44 24 08 ea 32 80 	movl   $0x8032ea,0x8(%esp)
  8013dd:	00 
  8013de:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  8013e5:	00 
  8013e6:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  8013ed:	e8 4a ef ff ff       	call   80033c <_panic>

008013f2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 24             	sub    $0x24,%esp
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8013fc:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  8013fe:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801402:	75 1c                	jne    801420 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801404:	c7 44 24 08 0c 33 80 	movl   $0x80330c,0x8(%esp)
  80140b:	00 
  80140c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801413:	00 
  801414:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  80141b:	e8 1c ef ff ff       	call   80033c <_panic>
	}
	pte = vpt[VPN(addr)];
  801420:	89 d8                	mov    %ebx,%eax
  801422:	c1 e8 0c             	shr    $0xc,%eax
  801425:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  80142c:	f6 c4 08             	test   $0x8,%ah
  80142f:	75 1c                	jne    80144d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801431:	c7 44 24 08 50 33 80 	movl   $0x803350,0x8(%esp)
  801438:	00 
  801439:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801440:	00 
  801441:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  801448:	e8 ef ee ff ff       	call   80033c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80144d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801454:	00 
  801455:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80145c:	00 
  80145d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801464:	e8 42 fe ff ff       	call   8012ab <sys_page_alloc>
  801469:	85 c0                	test   %eax,%eax
  80146b:	79 20                	jns    80148d <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  80146d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801471:	c7 44 24 08 9c 33 80 	movl   $0x80339c,0x8(%esp)
  801478:	00 
  801479:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801480:	00 
  801481:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  801488:	e8 af ee ff ff       	call   80033c <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  80148d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801493:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80149a:	00 
  80149b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80149f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8014a6:	e8 ca f7 ff ff       	call   800c75 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  8014ab:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014b2:	00 
  8014b3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014be:	00 
  8014bf:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014c6:	00 
  8014c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014ce:	e8 7a fd ff ff       	call   80124d <sys_page_map>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	79 20                	jns    8014f7 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  8014d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014db:	c7 44 24 08 d8 33 80 	movl   $0x8033d8,0x8(%esp)
  8014e2:	00 
  8014e3:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8014ea:	00 
  8014eb:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  8014f2:	e8 45 ee ff ff       	call   80033c <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  8014f7:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014fe:	00 
  8014ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801506:	e8 e4 fc ff ff       	call   8011ef <sys_page_unmap>
  80150b:	85 c0                	test   %eax,%eax
  80150d:	79 20                	jns    80152f <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80150f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801513:	c7 44 24 08 10 34 80 	movl   $0x803410,0x8(%esp)
  80151a:	00 
  80151b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801522:	00 
  801523:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  80152a:	e8 0d ee ff ff       	call   80033c <_panic>
	// panic("pgfault not implemented");
}
  80152f:	83 c4 24             	add    $0x24,%esp
  801532:	5b                   	pop    %ebx
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    

00801535 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	57                   	push   %edi
  801539:	56                   	push   %esi
  80153a:	53                   	push   %ebx
  80153b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80153e:	c7 04 24 f2 13 80 00 	movl   $0x8013f2,(%esp)
  801545:	e8 42 15 00 00       	call   802a8c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80154a:	ba 07 00 00 00       	mov    $0x7,%edx
  80154f:	89 d0                	mov    %edx,%eax
  801551:	cd 30                	int    $0x30
  801553:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  801556:	85 c0                	test   %eax,%eax
  801558:	0f 88 21 02 00 00    	js     80177f <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  80155e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  801565:	85 c0                	test   %eax,%eax
  801567:	75 1c                	jne    801585 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  801569:	e8 d0 fd ff ff       	call   80133e <sys_getenvid>
  80156e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801573:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801576:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80157b:	a3 74 70 80 00       	mov    %eax,0x807074
		return 0;
  801580:	e9 fa 01 00 00       	jmp    80177f <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  801585:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801588:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  80158f:	a8 01                	test   $0x1,%al
  801591:	0f 84 16 01 00 00    	je     8016ad <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  801597:	89 d3                	mov    %edx,%ebx
  801599:	c1 e3 0a             	shl    $0xa,%ebx
  80159c:	89 d7                	mov    %edx,%edi
  80159e:	c1 e7 16             	shl    $0x16,%edi
  8015a1:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  8015a6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015ad:	a8 01                	test   $0x1,%al
  8015af:	0f 84 e0 00 00 00    	je     801695 <fork+0x160>
  8015b5:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8015bb:	0f 87 d4 00 00 00    	ja     801695 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  8015c1:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  8015c8:	89 d0                	mov    %edx,%eax
  8015ca:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  8015cf:	f6 c2 01             	test   $0x1,%dl
  8015d2:	75 1c                	jne    8015f0 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  8015d4:	c7 44 24 08 4c 34 80 	movl   $0x80344c,0x8(%esp)
  8015db:	00 
  8015dc:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  8015e3:	00 
  8015e4:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  8015eb:	e8 4c ed ff ff       	call   80033c <_panic>
	if ((perm & PTE_U) != PTE_U)
  8015f0:	a8 04                	test   $0x4,%al
  8015f2:	75 1c                	jne    801610 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  8015f4:	c7 44 24 08 94 34 80 	movl   $0x803494,0x8(%esp)
  8015fb:	00 
  8015fc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801603:	00 
  801604:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  80160b:	e8 2c ed ff ff       	call   80033c <_panic>
  801610:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801613:	f6 c4 04             	test   $0x4,%ah
  801616:	75 5b                	jne    801673 <fork+0x13e>
  801618:	a9 02 08 00 00       	test   $0x802,%eax
  80161d:	74 54                	je     801673 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80161f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801622:	80 cc 08             	or     $0x8,%ah
  801625:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801628:	89 44 24 10          	mov    %eax,0x10(%esp)
  80162c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801633:	89 54 24 08          	mov    %edx,0x8(%esp)
  801637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80163b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801642:	e8 06 fc ff ff       	call   80124d <sys_page_map>
  801647:	85 c0                	test   %eax,%eax
  801649:	78 4a                	js     801695 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80164b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80164e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801655:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801659:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801660:	00 
  801661:	89 54 24 04          	mov    %edx,0x4(%esp)
  801665:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80166c:	e8 dc fb ff ff       	call   80124d <sys_page_map>
  801671:	eb 22                	jmp    801695 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801673:	89 44 24 10          	mov    %eax,0x10(%esp)
  801677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80167e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801681:	89 54 24 08          	mov    %edx,0x8(%esp)
  801685:	89 44 24 04          	mov    %eax,0x4(%esp)
  801689:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801690:	e8 b8 fb ff ff       	call   80124d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  801695:	83 c6 01             	add    $0x1,%esi
  801698:	83 c3 01             	add    $0x1,%ebx
  80169b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8016a1:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  8016a7:	0f 85 f9 fe ff ff    	jne    8015a6 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  8016ad:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  8016b1:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  8016b8:	0f 85 c7 fe ff ff    	jne    801585 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8016be:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016c5:	00 
  8016c6:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8016cd:	ee 
  8016ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d1:	89 04 24             	mov    %eax,(%esp)
  8016d4:	e8 d2 fb ff ff       	call   8012ab <sys_page_alloc>
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	79 08                	jns    8016e5 <fork+0x1b0>
  8016dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016e0:	e9 9a 00 00 00       	jmp    80177f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8016e5:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8016ec:	00 
  8016ed:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8016f4:	00 
  8016f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016fc:	00 
  8016fd:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801704:	ee 
  801705:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801708:	89 14 24             	mov    %edx,(%esp)
  80170b:	e8 3d fb ff ff       	call   80124d <sys_page_map>
  801710:	85 c0                	test   %eax,%eax
  801712:	79 05                	jns    801719 <fork+0x1e4>
  801714:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801717:	eb 66                	jmp    80177f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801719:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801720:	00 
  801721:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801728:	ee 
  801729:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801730:	e8 40 f5 ff ff       	call   800c75 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801735:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80173c:	00 
  80173d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801744:	e8 a6 fa ff ff       	call   8011ef <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801749:	c7 44 24 04 20 2b 80 	movl   $0x802b20,0x4(%esp)
  801750:	00 
  801751:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801754:	89 04 24             	mov    %eax,(%esp)
  801757:	e8 79 f9 ff ff       	call   8010d5 <sys_env_set_pgfault_upcall>
  80175c:	85 c0                	test   %eax,%eax
  80175e:	79 05                	jns    801765 <fork+0x230>
  801760:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801763:	eb 1a                	jmp    80177f <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801765:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80176c:	00 
  80176d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801770:	89 14 24             	mov    %edx,(%esp)
  801773:	e8 19 fa ff ff       	call   801191 <sys_env_set_status>
  801778:	85 c0                	test   %eax,%eax
  80177a:	79 03                	jns    80177f <fork+0x24a>
  80177c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  80177f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801782:	83 c4 3c             	add    $0x3c,%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5f                   	pop    %edi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    
  80178a:	00 00                	add    %al,(%eax)
  80178c:	00 00                	add    %al,(%eax)
	...

00801790 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	05 00 00 00 30       	add    $0x30000000,%eax
  80179b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	89 04 24             	mov    %eax,(%esp)
  8017ac:	e8 df ff ff ff       	call   801790 <fd2num>
  8017b1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8017b6:	c1 e0 0c             	shl    $0xc,%eax
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	57                   	push   %edi
  8017bf:	56                   	push   %esi
  8017c0:	53                   	push   %ebx
  8017c1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8017c4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8017c9:	a8 01                	test   $0x1,%al
  8017cb:	74 36                	je     801803 <fd_alloc+0x48>
  8017cd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8017d2:	a8 01                	test   $0x1,%al
  8017d4:	74 2d                	je     801803 <fd_alloc+0x48>
  8017d6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8017db:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8017e0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8017e5:	89 c3                	mov    %eax,%ebx
  8017e7:	89 c2                	mov    %eax,%edx
  8017e9:	c1 ea 16             	shr    $0x16,%edx
  8017ec:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8017ef:	f6 c2 01             	test   $0x1,%dl
  8017f2:	74 14                	je     801808 <fd_alloc+0x4d>
  8017f4:	89 c2                	mov    %eax,%edx
  8017f6:	c1 ea 0c             	shr    $0xc,%edx
  8017f9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8017fc:	f6 c2 01             	test   $0x1,%dl
  8017ff:	75 10                	jne    801811 <fd_alloc+0x56>
  801801:	eb 05                	jmp    801808 <fd_alloc+0x4d>
  801803:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801808:	89 1f                	mov    %ebx,(%edi)
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80180f:	eb 17                	jmp    801828 <fd_alloc+0x6d>
  801811:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801816:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80181b:	75 c8                	jne    8017e5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80181d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801823:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801828:	5b                   	pop    %ebx
  801829:	5e                   	pop    %esi
  80182a:	5f                   	pop    %edi
  80182b:	5d                   	pop    %ebp
  80182c:	c3                   	ret    

0080182d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	83 f8 1f             	cmp    $0x1f,%eax
  801836:	77 36                	ja     80186e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801838:	05 00 00 0d 00       	add    $0xd0000,%eax
  80183d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801840:	89 c2                	mov    %eax,%edx
  801842:	c1 ea 16             	shr    $0x16,%edx
  801845:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80184c:	f6 c2 01             	test   $0x1,%dl
  80184f:	74 1d                	je     80186e <fd_lookup+0x41>
  801851:	89 c2                	mov    %eax,%edx
  801853:	c1 ea 0c             	shr    $0xc,%edx
  801856:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80185d:	f6 c2 01             	test   $0x1,%dl
  801860:	74 0c                	je     80186e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801862:	8b 55 0c             	mov    0xc(%ebp),%edx
  801865:	89 02                	mov    %eax,(%edx)
  801867:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80186c:	eb 05                	jmp    801873 <fd_lookup+0x46>
  80186e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    

00801875 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80187b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80187e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	89 04 24             	mov    %eax,(%esp)
  801888:	e8 a0 ff ff ff       	call   80182d <fd_lookup>
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 0e                	js     80189f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801891:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801894:	8b 55 0c             	mov    0xc(%ebp),%edx
  801897:	89 50 04             	mov    %edx,0x4(%eax)
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	56                   	push   %esi
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 10             	sub    $0x10,%esp
  8018a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8018af:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8018b4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018b9:	be 58 35 80 00       	mov    $0x803558,%esi
		if (devtab[i]->dev_id == dev_id) {
  8018be:	39 08                	cmp    %ecx,(%eax)
  8018c0:	75 10                	jne    8018d2 <dev_lookup+0x31>
  8018c2:	eb 04                	jmp    8018c8 <dev_lookup+0x27>
  8018c4:	39 08                	cmp    %ecx,(%eax)
  8018c6:	75 0a                	jne    8018d2 <dev_lookup+0x31>
			*dev = devtab[i];
  8018c8:	89 03                	mov    %eax,(%ebx)
  8018ca:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8018cf:	90                   	nop
  8018d0:	eb 31                	jmp    801903 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018d2:	83 c2 01             	add    $0x1,%edx
  8018d5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	75 e8                	jne    8018c4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8018dc:	a1 74 70 80 00       	mov    0x807074,%eax
  8018e1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ec:	c7 04 24 dc 34 80 00 	movl   $0x8034dc,(%esp)
  8018f3:	e8 09 eb ff ff       	call   800401 <cprintf>
	*dev = 0;
  8018f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8018fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	5b                   	pop    %ebx
  801907:	5e                   	pop    %esi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    

0080190a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	53                   	push   %ebx
  80190e:	83 ec 24             	sub    $0x24,%esp
  801911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801914:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801917:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 04 24             	mov    %eax,(%esp)
  801921:	e8 07 ff ff ff       	call   80182d <fd_lookup>
  801926:	85 c0                	test   %eax,%eax
  801928:	78 53                	js     80197d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801934:	8b 00                	mov    (%eax),%eax
  801936:	89 04 24             	mov    %eax,(%esp)
  801939:	e8 63 ff ff ff       	call   8018a1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 3b                	js     80197d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801942:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801947:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80194e:	74 2d                	je     80197d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801950:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801953:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80195a:	00 00 00 
	stat->st_isdir = 0;
  80195d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801964:	00 00 00 
	stat->st_dev = dev;
  801967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801970:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801974:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801977:	89 14 24             	mov    %edx,(%esp)
  80197a:	ff 50 14             	call   *0x14(%eax)
}
  80197d:	83 c4 24             	add    $0x24,%esp
  801980:	5b                   	pop    %ebx
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    

00801983 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	53                   	push   %ebx
  801987:	83 ec 24             	sub    $0x24,%esp
  80198a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801990:	89 44 24 04          	mov    %eax,0x4(%esp)
  801994:	89 1c 24             	mov    %ebx,(%esp)
  801997:	e8 91 fe ff ff       	call   80182d <fd_lookup>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 5f                	js     8019ff <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019aa:	8b 00                	mov    (%eax),%eax
  8019ac:	89 04 24             	mov    %eax,(%esp)
  8019af:	e8 ed fe ff ff       	call   8018a1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 47                	js     8019ff <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019bb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8019bf:	75 23                	jne    8019e4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8019c1:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019c6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d1:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  8019d8:	e8 24 ea ff ff       	call   800401 <cprintf>
  8019dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8019e2:	eb 1b                	jmp    8019ff <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8019e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e7:	8b 48 18             	mov    0x18(%eax),%ecx
  8019ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ef:	85 c9                	test   %ecx,%ecx
  8019f1:	74 0c                	je     8019ff <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fa:	89 14 24             	mov    %edx,(%esp)
  8019fd:	ff d1                	call   *%ecx
}
  8019ff:	83 c4 24             	add    $0x24,%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    

00801a05 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	53                   	push   %ebx
  801a09:	83 ec 24             	sub    $0x24,%esp
  801a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a16:	89 1c 24             	mov    %ebx,(%esp)
  801a19:	e8 0f fe ff ff       	call   80182d <fd_lookup>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 66                	js     801a88 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2c:	8b 00                	mov    (%eax),%eax
  801a2e:	89 04 24             	mov    %eax,(%esp)
  801a31:	e8 6b fe ff ff       	call   8018a1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a36:	85 c0                	test   %eax,%eax
  801a38:	78 4e                	js     801a88 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a3d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a41:	75 23                	jne    801a66 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801a43:	a1 74 70 80 00       	mov    0x807074,%eax
  801a48:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a53:	c7 04 24 1d 35 80 00 	movl   $0x80351d,(%esp)
  801a5a:	e8 a2 e9 ff ff       	call   800401 <cprintf>
  801a5f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a64:	eb 22                	jmp    801a88 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a69:	8b 48 0c             	mov    0xc(%eax),%ecx
  801a6c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a71:	85 c9                	test   %ecx,%ecx
  801a73:	74 13                	je     801a88 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a75:	8b 45 10             	mov    0x10(%ebp),%eax
  801a78:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a83:	89 14 24             	mov    %edx,(%esp)
  801a86:	ff d1                	call   *%ecx
}
  801a88:	83 c4 24             	add    $0x24,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    

00801a8e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	53                   	push   %ebx
  801a92:	83 ec 24             	sub    $0x24,%esp
  801a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9f:	89 1c 24             	mov    %ebx,(%esp)
  801aa2:	e8 86 fd ff ff       	call   80182d <fd_lookup>
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 6b                	js     801b16 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab5:	8b 00                	mov    (%eax),%eax
  801ab7:	89 04 24             	mov    %eax,(%esp)
  801aba:	e8 e2 fd ff ff       	call   8018a1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 53                	js     801b16 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ac3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ac6:	8b 42 08             	mov    0x8(%edx),%eax
  801ac9:	83 e0 03             	and    $0x3,%eax
  801acc:	83 f8 01             	cmp    $0x1,%eax
  801acf:	75 23                	jne    801af4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801ad1:	a1 74 70 80 00       	mov    0x807074,%eax
  801ad6:	8b 40 4c             	mov    0x4c(%eax),%eax
  801ad9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801add:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae1:	c7 04 24 3a 35 80 00 	movl   $0x80353a,(%esp)
  801ae8:	e8 14 e9 ff ff       	call   800401 <cprintf>
  801aed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801af2:	eb 22                	jmp    801b16 <read+0x88>
	}
	if (!dev->dev_read)
  801af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af7:	8b 48 08             	mov    0x8(%eax),%ecx
  801afa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aff:	85 c9                	test   %ecx,%ecx
  801b01:	74 13                	je     801b16 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b03:	8b 45 10             	mov    0x10(%ebp),%eax
  801b06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b11:	89 14 24             	mov    %edx,(%esp)
  801b14:	ff d1                	call   *%ecx
}
  801b16:	83 c4 24             	add    $0x24,%esp
  801b19:	5b                   	pop    %ebx
  801b1a:	5d                   	pop    %ebp
  801b1b:	c3                   	ret    

00801b1c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	57                   	push   %edi
  801b20:	56                   	push   %esi
  801b21:	53                   	push   %ebx
  801b22:	83 ec 1c             	sub    $0x1c,%esp
  801b25:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b28:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b30:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b35:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3a:	85 f6                	test   %esi,%esi
  801b3c:	74 29                	je     801b67 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b3e:	89 f0                	mov    %esi,%eax
  801b40:	29 d0                	sub    %edx,%eax
  801b42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b46:	03 55 0c             	add    0xc(%ebp),%edx
  801b49:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b4d:	89 3c 24             	mov    %edi,(%esp)
  801b50:	e8 39 ff ff ff       	call   801a8e <read>
		if (m < 0)
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 0e                	js     801b67 <readn+0x4b>
			return m;
		if (m == 0)
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	74 08                	je     801b65 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b5d:	01 c3                	add    %eax,%ebx
  801b5f:	89 da                	mov    %ebx,%edx
  801b61:	39 f3                	cmp    %esi,%ebx
  801b63:	72 d9                	jb     801b3e <readn+0x22>
  801b65:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b67:	83 c4 1c             	add    $0x1c,%esp
  801b6a:	5b                   	pop    %ebx
  801b6b:	5e                   	pop    %esi
  801b6c:	5f                   	pop    %edi
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    

00801b6f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 20             	sub    $0x20,%esp
  801b77:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b7a:	89 34 24             	mov    %esi,(%esp)
  801b7d:	e8 0e fc ff ff       	call   801790 <fd2num>
  801b82:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b85:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b89:	89 04 24             	mov    %eax,(%esp)
  801b8c:	e8 9c fc ff ff       	call   80182d <fd_lookup>
  801b91:	89 c3                	mov    %eax,%ebx
  801b93:	85 c0                	test   %eax,%eax
  801b95:	78 05                	js     801b9c <fd_close+0x2d>
  801b97:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801b9a:	74 0c                	je     801ba8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801b9c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801ba0:	19 c0                	sbb    %eax,%eax
  801ba2:	f7 d0                	not    %eax
  801ba4:	21 c3                	and    %eax,%ebx
  801ba6:	eb 3d                	jmp    801be5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ba8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801baf:	8b 06                	mov    (%esi),%eax
  801bb1:	89 04 24             	mov    %eax,(%esp)
  801bb4:	e8 e8 fc ff ff       	call   8018a1 <dev_lookup>
  801bb9:	89 c3                	mov    %eax,%ebx
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 16                	js     801bd5 <fd_close+0x66>
		if (dev->dev_close)
  801bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc2:	8b 40 10             	mov    0x10(%eax),%eax
  801bc5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	74 07                	je     801bd5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801bce:	89 34 24             	mov    %esi,(%esp)
  801bd1:	ff d0                	call   *%eax
  801bd3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801bd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be0:	e8 0a f6 ff ff       	call   8011ef <sys_page_unmap>
	return r;
}
  801be5:	89 d8                	mov    %ebx,%eax
  801be7:	83 c4 20             	add    $0x20,%esp
  801bea:	5b                   	pop    %ebx
  801beb:	5e                   	pop    %esi
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	89 04 24             	mov    %eax,(%esp)
  801c01:	e8 27 fc ff ff       	call   80182d <fd_lookup>
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 13                	js     801c1d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801c0a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c11:	00 
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	89 04 24             	mov    %eax,(%esp)
  801c18:	e8 52 ff ff ff       	call   801b6f <fd_close>
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 18             	sub    $0x18,%esp
  801c25:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c28:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c32:	00 
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 04 24             	mov    %eax,(%esp)
  801c39:	e8 55 03 00 00       	call   801f93 <open>
  801c3e:	89 c3                	mov    %eax,%ebx
  801c40:	85 c0                	test   %eax,%eax
  801c42:	78 1b                	js     801c5f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4b:	89 1c 24             	mov    %ebx,(%esp)
  801c4e:	e8 b7 fc ff ff       	call   80190a <fstat>
  801c53:	89 c6                	mov    %eax,%esi
	close(fd);
  801c55:	89 1c 24             	mov    %ebx,(%esp)
  801c58:	e8 91 ff ff ff       	call   801bee <close>
  801c5d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801c5f:	89 d8                	mov    %ebx,%eax
  801c61:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c64:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c67:	89 ec                	mov    %ebp,%esp
  801c69:	5d                   	pop    %ebp
  801c6a:	c3                   	ret    

00801c6b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	53                   	push   %ebx
  801c6f:	83 ec 14             	sub    $0x14,%esp
  801c72:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801c77:	89 1c 24             	mov    %ebx,(%esp)
  801c7a:	e8 6f ff ff ff       	call   801bee <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801c7f:	83 c3 01             	add    $0x1,%ebx
  801c82:	83 fb 20             	cmp    $0x20,%ebx
  801c85:	75 f0                	jne    801c77 <close_all+0xc>
		close(i);
}
  801c87:	83 c4 14             	add    $0x14,%esp
  801c8a:	5b                   	pop    %ebx
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    

00801c8d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 58             	sub    $0x58,%esp
  801c93:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c96:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c99:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801c9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801c9f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	89 04 24             	mov    %eax,(%esp)
  801cac:	e8 7c fb ff ff       	call   80182d <fd_lookup>
  801cb1:	89 c3                	mov    %eax,%ebx
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	0f 88 e0 00 00 00    	js     801d9b <dup+0x10e>
		return r;
	close(newfdnum);
  801cbb:	89 3c 24             	mov    %edi,(%esp)
  801cbe:	e8 2b ff ff ff       	call   801bee <close>

	newfd = INDEX2FD(newfdnum);
  801cc3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801cc9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801ccc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ccf:	89 04 24             	mov    %eax,(%esp)
  801cd2:	e8 c9 fa ff ff       	call   8017a0 <fd2data>
  801cd7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801cd9:	89 34 24             	mov    %esi,(%esp)
  801cdc:	e8 bf fa ff ff       	call   8017a0 <fd2data>
  801ce1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801ce4:	89 da                	mov    %ebx,%edx
  801ce6:	89 d8                	mov    %ebx,%eax
  801ce8:	c1 e8 16             	shr    $0x16,%eax
  801ceb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801cf2:	a8 01                	test   $0x1,%al
  801cf4:	74 43                	je     801d39 <dup+0xac>
  801cf6:	c1 ea 0c             	shr    $0xc,%edx
  801cf9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d00:	a8 01                	test   $0x1,%al
  801d02:	74 35                	je     801d39 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801d04:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d0b:	25 07 0e 00 00       	and    $0xe07,%eax
  801d10:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d22:	00 
  801d23:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2e:	e8 1a f5 ff ff       	call   80124d <sys_page_map>
  801d33:	89 c3                	mov    %eax,%ebx
  801d35:	85 c0                	test   %eax,%eax
  801d37:	78 3f                	js     801d78 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d3c:	89 c2                	mov    %eax,%edx
  801d3e:	c1 ea 0c             	shr    $0xc,%edx
  801d41:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d48:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801d4e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d52:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d56:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d5d:	00 
  801d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d69:	e8 df f4 ff ff       	call   80124d <sys_page_map>
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 04                	js     801d78 <dup+0xeb>
  801d74:	89 fb                	mov    %edi,%ebx
  801d76:	eb 23                	jmp    801d9b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801d78:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d83:	e8 67 f4 ff ff       	call   8011ef <sys_page_unmap>
	sys_page_unmap(0, nva);
  801d88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d96:	e8 54 f4 ff ff       	call   8011ef <sys_page_unmap>
	return r;
}
  801d9b:	89 d8                	mov    %ebx,%eax
  801d9d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801da0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801da3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801da6:	89 ec                	mov    %ebp,%esp
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    
	...

00801dac <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	53                   	push   %ebx
  801db0:	83 ec 14             	sub    $0x14,%esp
  801db3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801db5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801dbb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801dc2:	00 
  801dc3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801dca:	00 
  801dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dcf:	89 14 24             	mov    %edx,(%esp)
  801dd2:	e8 79 0d 00 00       	call   802b50 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801dd7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dde:	00 
  801ddf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801de3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dea:	e8 c7 0d 00 00       	call   802bb6 <ipc_recv>
}
  801def:	83 c4 14             	add    $0x14,%esp
  801df2:	5b                   	pop    %ebx
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    

00801df5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  801e01:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e09:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e13:	b8 02 00 00 00       	mov    $0x2,%eax
  801e18:	e8 8f ff ff ff       	call   801dac <fsipc>
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801e30:	ba 00 00 00 00       	mov    $0x0,%edx
  801e35:	b8 06 00 00 00       	mov    $0x6,%eax
  801e3a:	e8 6d ff ff ff       	call   801dac <fsipc>
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e47:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4c:	b8 08 00 00 00       	mov    $0x8,%eax
  801e51:	e8 56 ff ff ff       	call   801dac <fsipc>
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	53                   	push   %ebx
  801e5c:	83 ec 14             	sub    $0x14,%esp
  801e5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	8b 40 0c             	mov    0xc(%eax),%eax
  801e68:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e72:	b8 05 00 00 00       	mov    $0x5,%eax
  801e77:	e8 30 ff ff ff       	call   801dac <fsipc>
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	78 2b                	js     801eab <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e80:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801e87:	00 
  801e88:	89 1c 24             	mov    %ebx,(%esp)
  801e8b:	e8 2a ec ff ff       	call   800aba <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e90:	a1 80 40 80 00       	mov    0x804080,%eax
  801e95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e9b:	a1 84 40 80 00       	mov    0x804084,%eax
  801ea0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801ea6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801eab:	83 c4 14             	add    $0x14,%esp
  801eae:	5b                   	pop    %ebx
  801eaf:	5d                   	pop    %ebp
  801eb0:	c3                   	ret    

00801eb1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 18             	sub    $0x18,%esp
  801eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eba:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801ebf:	76 05                	jbe    801ec6 <devfile_write+0x15>
  801ec1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec9:	8b 52 0c             	mov    0xc(%edx),%edx
  801ecc:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801ed2:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801ed7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ede:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee2:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801ee9:	e8 87 ed ff ff       	call   800c75 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801eee:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef3:	b8 04 00 00 00       	mov    $0x4,%eax
  801ef8:	e8 af fe ff ff       	call   801dac <fsipc>
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	53                   	push   %ebx
  801f03:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801f19:	ba 00 40 80 00       	mov    $0x804000,%edx
  801f1e:	b8 03 00 00 00       	mov    $0x3,%eax
  801f23:	e8 84 fe ff ff       	call   801dac <fsipc>
  801f28:	89 c3                	mov    %eax,%ebx
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 17                	js     801f45 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801f2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f32:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801f39:	00 
  801f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3d:	89 04 24             	mov    %eax,(%esp)
  801f40:	e8 30 ed ff ff       	call   800c75 <memmove>
	return r;
}
  801f45:	89 d8                	mov    %ebx,%eax
  801f47:	83 c4 14             	add    $0x14,%esp
  801f4a:	5b                   	pop    %ebx
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    

00801f4d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	53                   	push   %ebx
  801f51:	83 ec 14             	sub    $0x14,%esp
  801f54:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801f57:	89 1c 24             	mov    %ebx,(%esp)
  801f5a:	e8 11 eb ff ff       	call   800a70 <strlen>
  801f5f:	89 c2                	mov    %eax,%edx
  801f61:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801f66:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801f6c:	7f 1f                	jg     801f8d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801f6e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f72:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f79:	e8 3c eb ff ff       	call   800aba <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801f7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f83:	b8 07 00 00 00       	mov    $0x7,%eax
  801f88:	e8 1f fe ff ff       	call   801dac <fsipc>
}
  801f8d:	83 c4 14             	add    $0x14,%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5d                   	pop    %ebp
  801f92:	c3                   	ret    

00801f93 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 28             	sub    $0x28,%esp
  801f99:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801f9c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801f9f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801fa2:	89 34 24             	mov    %esi,(%esp)
  801fa5:	e8 c6 ea ff ff       	call   800a70 <strlen>
  801faa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801faf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fb4:	7f 5e                	jg     802014 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb9:	89 04 24             	mov    %eax,(%esp)
  801fbc:	e8 fa f7 ff ff       	call   8017bb <fd_alloc>
  801fc1:	89 c3                	mov    %eax,%ebx
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	78 4d                	js     802014 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801fc7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fcb:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801fd2:	e8 e3 ea ff ff       	call   800aba <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fda:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe7:	e8 c0 fd ff ff       	call   801dac <fsipc>
  801fec:	89 c3                	mov    %eax,%ebx
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	79 15                	jns    802007 <open+0x74>
	{
		fd_close(fd,0);
  801ff2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ff9:	00 
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	89 04 24             	mov    %eax,(%esp)
  802000:	e8 6a fb ff ff       	call   801b6f <fd_close>
		return r; 
  802005:	eb 0d                	jmp    802014 <open+0x81>
	}
	return fd2num(fd);
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 7e f7 ff ff       	call   801790 <fd2num>
  802012:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  802014:	89 d8                	mov    %ebx,%eax
  802016:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802019:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80201c:	89 ec                	mov    %ebp,%esp
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    

00802020 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802026:	c7 44 24 04 6c 35 80 	movl   $0x80356c,0x4(%esp)
  80202d:	00 
  80202e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802031:	89 04 24             	mov    %eax,(%esp)
  802034:	e8 81 ea ff ff       	call   800aba <strcpy>
	return 0;
}
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 40 0c             	mov    0xc(%eax),%eax
  80204c:	89 04 24             	mov    %eax,(%esp)
  80204f:	e8 9e 02 00 00       	call   8022f2 <nsipc_close>
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80205c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802063:	00 
  802064:	8b 45 10             	mov    0x10(%ebp),%eax
  802067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80206b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	8b 40 0c             	mov    0xc(%eax),%eax
  802078:	89 04 24             	mov    %eax,(%esp)
  80207b:	e8 ae 02 00 00       	call   80232e <nsipc_send>
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802088:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80208f:	00 
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	89 44 24 08          	mov    %eax,0x8(%esp)
  802097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a4:	89 04 24             	mov    %eax,(%esp)
  8020a7:	e8 f5 02 00 00       	call   8023a1 <nsipc_recv>
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	56                   	push   %esi
  8020b2:	53                   	push   %ebx
  8020b3:	83 ec 20             	sub    $0x20,%esp
  8020b6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bb:	89 04 24             	mov    %eax,(%esp)
  8020be:	e8 f8 f6 ff ff       	call   8017bb <fd_alloc>
  8020c3:	89 c3                	mov    %eax,%ebx
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 21                	js     8020ea <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8020c9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8020d0:	00 
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020df:	e8 c7 f1 ff ff       	call   8012ab <sys_page_alloc>
  8020e4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	79 0a                	jns    8020f4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8020ea:	89 34 24             	mov    %esi,(%esp)
  8020ed:	e8 00 02 00 00       	call   8022f2 <nsipc_close>
		return r;
  8020f2:	eb 28                	jmp    80211c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8020f4:	8b 15 20 70 80 00    	mov    0x807020,%edx
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	89 04 24             	mov    %eax,(%esp)
  802115:	e8 76 f6 ff ff       	call   801790 <fd2num>
  80211a:	89 c3                	mov    %eax,%ebx
}
  80211c:	89 d8                	mov    %ebx,%eax
  80211e:	83 c4 20             	add    $0x20,%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    

00802125 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80212b:	8b 45 10             	mov    0x10(%ebp),%eax
  80212e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802132:	8b 45 0c             	mov    0xc(%ebp),%eax
  802135:	89 44 24 04          	mov    %eax,0x4(%esp)
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	89 04 24             	mov    %eax,(%esp)
  80213f:	e8 62 01 00 00       	call   8022a6 <nsipc_socket>
  802144:	85 c0                	test   %eax,%eax
  802146:	78 05                	js     80214d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802148:	e8 61 ff ff ff       	call   8020ae <alloc_sockfd>
}
  80214d:	c9                   	leave  
  80214e:	66 90                	xchg   %ax,%ax
  802150:	c3                   	ret    

00802151 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802157:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80215a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80215e:	89 04 24             	mov    %eax,(%esp)
  802161:	e8 c7 f6 ff ff       	call   80182d <fd_lookup>
  802166:	85 c0                	test   %eax,%eax
  802168:	78 15                	js     80217f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80216a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216d:	8b 0a                	mov    (%edx),%ecx
  80216f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802174:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80217a:	75 03                	jne    80217f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80217c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	e8 c2 ff ff ff       	call   802151 <fd2sockid>
  80218f:	85 c0                	test   %eax,%eax
  802191:	78 0f                	js     8021a2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802193:	8b 55 0c             	mov    0xc(%ebp),%edx
  802196:	89 54 24 04          	mov    %edx,0x4(%esp)
  80219a:	89 04 24             	mov    %eax,(%esp)
  80219d:	e8 2e 01 00 00       	call   8022d0 <nsipc_listen>
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	e8 9f ff ff ff       	call   802151 <fd2sockid>
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 16                	js     8021cc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8021b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8021b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021c4:	89 04 24             	mov    %eax,(%esp)
  8021c7:	e8 55 02 00 00       	call   802421 <nsipc_connect>
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	e8 75 ff ff ff       	call   802151 <fd2sockid>
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	78 0f                	js     8021ef <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8021e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021e7:	89 04 24             	mov    %eax,(%esp)
  8021ea:	e8 1d 01 00 00       	call   80230c <nsipc_shutdown>
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	e8 52 ff ff ff       	call   802151 <fd2sockid>
  8021ff:	85 c0                	test   %eax,%eax
  802201:	78 16                	js     802219 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802203:	8b 55 10             	mov    0x10(%ebp),%edx
  802206:	89 54 24 08          	mov    %edx,0x8(%esp)
  80220a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802211:	89 04 24             	mov    %eax,(%esp)
  802214:	e8 47 02 00 00       	call   802460 <nsipc_bind>
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	e8 28 ff ff ff       	call   802151 <fd2sockid>
  802229:	85 c0                	test   %eax,%eax
  80222b:	78 1f                	js     80224c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80222d:	8b 55 10             	mov    0x10(%ebp),%edx
  802230:	89 54 24 08          	mov    %edx,0x8(%esp)
  802234:	8b 55 0c             	mov    0xc(%ebp),%edx
  802237:	89 54 24 04          	mov    %edx,0x4(%esp)
  80223b:	89 04 24             	mov    %eax,(%esp)
  80223e:	e8 5c 02 00 00       	call   80249f <nsipc_accept>
  802243:	85 c0                	test   %eax,%eax
  802245:	78 05                	js     80224c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802247:	e8 62 fe ff ff       	call   8020ae <alloc_sockfd>
}
  80224c:	c9                   	leave  
  80224d:	8d 76 00             	lea    0x0(%esi),%esi
  802250:	c3                   	ret    
	...

00802260 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802266:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80226c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802273:	00 
  802274:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80227b:	00 
  80227c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802280:	89 14 24             	mov    %edx,(%esp)
  802283:	e8 c8 08 00 00       	call   802b50 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802288:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80228f:	00 
  802290:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802297:	00 
  802298:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80229f:	e8 12 09 00 00       	call   802bb6 <ipc_recv>
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8022b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8022bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022bf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8022c4:	b8 09 00 00 00       	mov    $0x9,%eax
  8022c9:	e8 92 ff ff ff       	call   802260 <nsipc>
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8022de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8022e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8022eb:	e8 70 ff ff ff       	call   802260 <nsipc>
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802300:	b8 04 00 00 00       	mov    $0x4,%eax
  802305:	e8 56 ff ff ff       	call   802260 <nsipc>
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80231a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802322:	b8 03 00 00 00       	mov    $0x3,%eax
  802327:	e8 34 ff ff ff       	call   802260 <nsipc>
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	53                   	push   %ebx
  802332:	83 ec 14             	sub    $0x14,%esp
  802335:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802340:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802346:	7e 24                	jle    80236c <nsipc_send+0x3e>
  802348:	c7 44 24 0c 78 35 80 	movl   $0x803578,0xc(%esp)
  80234f:	00 
  802350:	c7 44 24 08 84 35 80 	movl   $0x803584,0x8(%esp)
  802357:	00 
  802358:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80235f:	00 
  802360:	c7 04 24 99 35 80 00 	movl   $0x803599,(%esp)
  802367:	e8 d0 df ff ff       	call   80033c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80236c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802370:	8b 45 0c             	mov    0xc(%ebp),%eax
  802373:	89 44 24 04          	mov    %eax,0x4(%esp)
  802377:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80237e:	e8 f2 e8 ff ff       	call   800c75 <memmove>
	nsipcbuf.send.req_size = size;
  802383:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802389:	8b 45 14             	mov    0x14(%ebp),%eax
  80238c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802391:	b8 08 00 00 00       	mov    $0x8,%eax
  802396:	e8 c5 fe ff ff       	call   802260 <nsipc>
}
  80239b:	83 c4 14             	add    $0x14,%esp
  80239e:	5b                   	pop    %ebx
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    

008023a1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	56                   	push   %esi
  8023a5:	53                   	push   %ebx
  8023a6:	83 ec 10             	sub    $0x10,%esp
  8023a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8023b4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8023ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8023bd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8023c7:	e8 94 fe ff ff       	call   802260 <nsipc>
  8023cc:	89 c3                	mov    %eax,%ebx
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	78 46                	js     802418 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8023d2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023d7:	7f 04                	jg     8023dd <nsipc_recv+0x3c>
  8023d9:	39 c6                	cmp    %eax,%esi
  8023db:	7d 24                	jge    802401 <nsipc_recv+0x60>
  8023dd:	c7 44 24 0c a5 35 80 	movl   $0x8035a5,0xc(%esp)
  8023e4:	00 
  8023e5:	c7 44 24 08 84 35 80 	movl   $0x803584,0x8(%esp)
  8023ec:	00 
  8023ed:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8023f4:	00 
  8023f5:	c7 04 24 99 35 80 00 	movl   $0x803599,(%esp)
  8023fc:	e8 3b df ff ff       	call   80033c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802401:	89 44 24 08          	mov    %eax,0x8(%esp)
  802405:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80240c:	00 
  80240d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802410:	89 04 24             	mov    %eax,(%esp)
  802413:	e8 5d e8 ff ff       	call   800c75 <memmove>
	}

	return r;
}
  802418:	89 d8                	mov    %ebx,%eax
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    

00802421 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	53                   	push   %ebx
  802425:	83 ec 14             	sub    $0x14,%esp
  802428:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802433:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802445:	e8 2b e8 ff ff       	call   800c75 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80244a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802450:	b8 05 00 00 00       	mov    $0x5,%eax
  802455:	e8 06 fe ff ff       	call   802260 <nsipc>
}
  80245a:	83 c4 14             	add    $0x14,%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5d                   	pop    %ebp
  80245f:	c3                   	ret    

00802460 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	53                   	push   %ebx
  802464:	83 ec 14             	sub    $0x14,%esp
  802467:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802472:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802476:	8b 45 0c             	mov    0xc(%ebp),%eax
  802479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802484:	e8 ec e7 ff ff       	call   800c75 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802489:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80248f:	b8 02 00 00 00       	mov    $0x2,%eax
  802494:	e8 c7 fd ff ff       	call   802260 <nsipc>
}
  802499:	83 c4 14             	add    $0x14,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5d                   	pop    %ebp
  80249e:	c3                   	ret    

0080249f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 18             	sub    $0x18,%esp
  8024a5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8024a8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8024b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b8:	e8 a3 fd ff ff       	call   802260 <nsipc>
  8024bd:	89 c3                	mov    %eax,%ebx
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	78 25                	js     8024e8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8024c3:	be 10 60 80 00       	mov    $0x806010,%esi
  8024c8:	8b 06                	mov    (%esi),%eax
  8024ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024ce:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8024d5:	00 
  8024d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d9:	89 04 24             	mov    %eax,(%esp)
  8024dc:	e8 94 e7 ff ff       	call   800c75 <memmove>
		*addrlen = ret->ret_addrlen;
  8024e1:	8b 16                	mov    (%esi),%edx
  8024e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8024e8:	89 d8                	mov    %ebx,%eax
  8024ea:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8024ed:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8024f0:	89 ec                	mov    %ebp,%esp
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    
	...

00802500 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 18             	sub    $0x18,%esp
  802506:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802509:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80250c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	89 04 24             	mov    %eax,(%esp)
  802515:	e8 86 f2 ff ff       	call   8017a0 <fd2data>
  80251a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80251c:	c7 44 24 04 ba 35 80 	movl   $0x8035ba,0x4(%esp)
  802523:	00 
  802524:	89 34 24             	mov    %esi,(%esp)
  802527:	e8 8e e5 ff ff       	call   800aba <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80252c:	8b 43 04             	mov    0x4(%ebx),%eax
  80252f:	2b 03                	sub    (%ebx),%eax
  802531:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802537:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80253e:	00 00 00 
	stat->st_dev = &devpipe;
  802541:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802548:	70 80 00 
	return 0;
}
  80254b:	b8 00 00 00 00       	mov    $0x0,%eax
  802550:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802553:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802556:	89 ec                	mov    %ebp,%esp
  802558:	5d                   	pop    %ebp
  802559:	c3                   	ret    

0080255a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	53                   	push   %ebx
  80255e:	83 ec 14             	sub    $0x14,%esp
  802561:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802564:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802568:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80256f:	e8 7b ec ff ff       	call   8011ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802574:	89 1c 24             	mov    %ebx,(%esp)
  802577:	e8 24 f2 ff ff       	call   8017a0 <fd2data>
  80257c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802587:	e8 63 ec ff ff       	call   8011ef <sys_page_unmap>
}
  80258c:	83 c4 14             	add    $0x14,%esp
  80258f:	5b                   	pop    %ebx
  802590:	5d                   	pop    %ebp
  802591:	c3                   	ret    

00802592 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	57                   	push   %edi
  802596:	56                   	push   %esi
  802597:	53                   	push   %ebx
  802598:	83 ec 2c             	sub    $0x2c,%esp
  80259b:	89 c7                	mov    %eax,%edi
  80259d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8025a0:	a1 74 70 80 00       	mov    0x807074,%eax
  8025a5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025a8:	89 3c 24             	mov    %edi,(%esp)
  8025ab:	e8 70 06 00 00       	call   802c20 <pageref>
  8025b0:	89 c6                	mov    %eax,%esi
  8025b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b5:	89 04 24             	mov    %eax,(%esp)
  8025b8:	e8 63 06 00 00       	call   802c20 <pageref>
  8025bd:	39 c6                	cmp    %eax,%esi
  8025bf:	0f 94 c0             	sete   %al
  8025c2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8025c5:	8b 15 74 70 80 00    	mov    0x807074,%edx
  8025cb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8025ce:	39 cb                	cmp    %ecx,%ebx
  8025d0:	75 08                	jne    8025da <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8025d2:	83 c4 2c             	add    $0x2c,%esp
  8025d5:	5b                   	pop    %ebx
  8025d6:	5e                   	pop    %esi
  8025d7:	5f                   	pop    %edi
  8025d8:	5d                   	pop    %ebp
  8025d9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8025da:	83 f8 01             	cmp    $0x1,%eax
  8025dd:	75 c1                	jne    8025a0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8025df:	8b 52 58             	mov    0x58(%edx),%edx
  8025e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025e6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025ee:	c7 04 24 c1 35 80 00 	movl   $0x8035c1,(%esp)
  8025f5:	e8 07 de ff ff       	call   800401 <cprintf>
  8025fa:	eb a4                	jmp    8025a0 <_pipeisclosed+0xe>

008025fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	57                   	push   %edi
  802600:	56                   	push   %esi
  802601:	53                   	push   %ebx
  802602:	83 ec 1c             	sub    $0x1c,%esp
  802605:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802608:	89 34 24             	mov    %esi,(%esp)
  80260b:	e8 90 f1 ff ff       	call   8017a0 <fd2data>
  802610:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802612:	bf 00 00 00 00       	mov    $0x0,%edi
  802617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80261b:	75 54                	jne    802671 <devpipe_write+0x75>
  80261d:	eb 60                	jmp    80267f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80261f:	89 da                	mov    %ebx,%edx
  802621:	89 f0                	mov    %esi,%eax
  802623:	e8 6a ff ff ff       	call   802592 <_pipeisclosed>
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 07                	je     802633 <devpipe_write+0x37>
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	eb 53                	jmp    802686 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802633:	90                   	nop
  802634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802638:	e8 cd ec ff ff       	call   80130a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80263d:	8b 43 04             	mov    0x4(%ebx),%eax
  802640:	8b 13                	mov    (%ebx),%edx
  802642:	83 c2 20             	add    $0x20,%edx
  802645:	39 d0                	cmp    %edx,%eax
  802647:	73 d6                	jae    80261f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802649:	89 c2                	mov    %eax,%edx
  80264b:	c1 fa 1f             	sar    $0x1f,%edx
  80264e:	c1 ea 1b             	shr    $0x1b,%edx
  802651:	01 d0                	add    %edx,%eax
  802653:	83 e0 1f             	and    $0x1f,%eax
  802656:	29 d0                	sub    %edx,%eax
  802658:	89 c2                	mov    %eax,%edx
  80265a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80265d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802661:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802665:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802669:	83 c7 01             	add    $0x1,%edi
  80266c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80266f:	76 13                	jbe    802684 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802671:	8b 43 04             	mov    0x4(%ebx),%eax
  802674:	8b 13                	mov    (%ebx),%edx
  802676:	83 c2 20             	add    $0x20,%edx
  802679:	39 d0                	cmp    %edx,%eax
  80267b:	73 a2                	jae    80261f <devpipe_write+0x23>
  80267d:	eb ca                	jmp    802649 <devpipe_write+0x4d>
  80267f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802684:	89 f8                	mov    %edi,%eax
}
  802686:	83 c4 1c             	add    $0x1c,%esp
  802689:	5b                   	pop    %ebx
  80268a:	5e                   	pop    %esi
  80268b:	5f                   	pop    %edi
  80268c:	5d                   	pop    %ebp
  80268d:	c3                   	ret    

0080268e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 28             	sub    $0x28,%esp
  802694:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802697:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80269a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80269d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026a0:	89 3c 24             	mov    %edi,(%esp)
  8026a3:	e8 f8 f0 ff ff       	call   8017a0 <fd2data>
  8026a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026aa:	be 00 00 00 00       	mov    $0x0,%esi
  8026af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026b3:	75 4c                	jne    802701 <devpipe_read+0x73>
  8026b5:	eb 5b                	jmp    802712 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8026b7:	89 f0                	mov    %esi,%eax
  8026b9:	eb 5e                	jmp    802719 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8026bb:	89 da                	mov    %ebx,%edx
  8026bd:	89 f8                	mov    %edi,%eax
  8026bf:	90                   	nop
  8026c0:	e8 cd fe ff ff       	call   802592 <_pipeisclosed>
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 07                	je     8026d0 <devpipe_read+0x42>
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	eb 49                	jmp    802719 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026d0:	e8 35 ec ff ff       	call   80130a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026d5:	8b 03                	mov    (%ebx),%eax
  8026d7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026da:	74 df                	je     8026bb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026dc:	89 c2                	mov    %eax,%edx
  8026de:	c1 fa 1f             	sar    $0x1f,%edx
  8026e1:	c1 ea 1b             	shr    $0x1b,%edx
  8026e4:	01 d0                	add    %edx,%eax
  8026e6:	83 e0 1f             	and    $0x1f,%eax
  8026e9:	29 d0                	sub    %edx,%eax
  8026eb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8026f6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026f9:	83 c6 01             	add    $0x1,%esi
  8026fc:	39 75 10             	cmp    %esi,0x10(%ebp)
  8026ff:	76 16                	jbe    802717 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802701:	8b 03                	mov    (%ebx),%eax
  802703:	3b 43 04             	cmp    0x4(%ebx),%eax
  802706:	75 d4                	jne    8026dc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802708:	85 f6                	test   %esi,%esi
  80270a:	75 ab                	jne    8026b7 <devpipe_read+0x29>
  80270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802710:	eb a9                	jmp    8026bb <devpipe_read+0x2d>
  802712:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802717:	89 f0                	mov    %esi,%eax
}
  802719:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80271c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80271f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802722:	89 ec                	mov    %ebp,%esp
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80272c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80272f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	89 04 24             	mov    %eax,(%esp)
  802739:	e8 ef f0 ff ff       	call   80182d <fd_lookup>
  80273e:	85 c0                	test   %eax,%eax
  802740:	78 15                	js     802757 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	89 04 24             	mov    %eax,(%esp)
  802748:	e8 53 f0 ff ff       	call   8017a0 <fd2data>
	return _pipeisclosed(fd, p);
  80274d:	89 c2                	mov    %eax,%edx
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	e8 3b fe ff ff       	call   802592 <_pipeisclosed>
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	83 ec 48             	sub    $0x48,%esp
  80275f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802762:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802765:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802768:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80276b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80276e:	89 04 24             	mov    %eax,(%esp)
  802771:	e8 45 f0 ff ff       	call   8017bb <fd_alloc>
  802776:	89 c3                	mov    %eax,%ebx
  802778:	85 c0                	test   %eax,%eax
  80277a:	0f 88 42 01 00 00    	js     8028c2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802780:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802787:	00 
  802788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802796:	e8 10 eb ff ff       	call   8012ab <sys_page_alloc>
  80279b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80279d:	85 c0                	test   %eax,%eax
  80279f:	0f 88 1d 01 00 00    	js     8028c2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8027a8:	89 04 24             	mov    %eax,(%esp)
  8027ab:	e8 0b f0 ff ff       	call   8017bb <fd_alloc>
  8027b0:	89 c3                	mov    %eax,%ebx
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	0f 88 f5 00 00 00    	js     8028af <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ba:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027c1:	00 
  8027c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d0:	e8 d6 ea ff ff       	call   8012ab <sys_page_alloc>
  8027d5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	0f 88 d0 00 00 00    	js     8028af <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	89 04 24             	mov    %eax,(%esp)
  8027e5:	e8 b6 ef ff ff       	call   8017a0 <fd2data>
  8027ea:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ec:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027f3:	00 
  8027f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027ff:	e8 a7 ea ff ff       	call   8012ab <sys_page_alloc>
  802804:	89 c3                	mov    %eax,%ebx
  802806:	85 c0                	test   %eax,%eax
  802808:	0f 88 8e 00 00 00    	js     80289c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802811:	89 04 24             	mov    %eax,(%esp)
  802814:	e8 87 ef ff ff       	call   8017a0 <fd2data>
  802819:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802820:	00 
  802821:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802825:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80282c:	00 
  80282d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802831:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802838:	e8 10 ea ff ff       	call   80124d <sys_page_map>
  80283d:	89 c3                	mov    %eax,%ebx
  80283f:	85 c0                	test   %eax,%eax
  802841:	78 49                	js     80288c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802843:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802848:	8b 08                	mov    (%eax),%ecx
  80284a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80284d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80284f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802852:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802859:	8b 10                	mov    (%eax),%edx
  80285b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802860:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802863:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80286a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286d:	89 04 24             	mov    %eax,(%esp)
  802870:	e8 1b ef ff ff       	call   801790 <fd2num>
  802875:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287a:	89 04 24             	mov    %eax,(%esp)
  80287d:	e8 0e ef ff ff       	call   801790 <fd2num>
  802882:	89 47 04             	mov    %eax,0x4(%edi)
  802885:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80288a:	eb 36                	jmp    8028c2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80288c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802897:	e8 53 e9 ff ff       	call   8011ef <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80289c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028aa:	e8 40 e9 ff ff       	call   8011ef <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028bd:	e8 2d e9 ff ff       	call   8011ef <sys_page_unmap>
    err:
	return r;
}
  8028c2:	89 d8                	mov    %ebx,%eax
  8028c4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8028c7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8028ca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8028cd:	89 ec                	mov    %ebp,%esp
  8028cf:	5d                   	pop    %ebp
  8028d0:	c3                   	ret    
	...

008028e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8028e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e8:	5d                   	pop    %ebp
  8028e9:	c3                   	ret    

008028ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8028f0:	c7 44 24 04 d4 35 80 	movl   $0x8035d4,0x4(%esp)
  8028f7:	00 
  8028f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fb:	89 04 24             	mov    %eax,(%esp)
  8028fe:	e8 b7 e1 ff ff       	call   800aba <strcpy>
	return 0;
}
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	57                   	push   %edi
  80290e:	56                   	push   %esi
  80290f:	53                   	push   %ebx
  802910:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802916:	b8 00 00 00 00       	mov    $0x0,%eax
  80291b:	be 00 00 00 00       	mov    $0x0,%esi
  802920:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802924:	74 3f                	je     802965 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802926:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80292c:	8b 55 10             	mov    0x10(%ebp),%edx
  80292f:	29 c2                	sub    %eax,%edx
  802931:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802933:	83 fa 7f             	cmp    $0x7f,%edx
  802936:	76 05                	jbe    80293d <devcons_write+0x33>
  802938:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80293d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802941:	03 45 0c             	add    0xc(%ebp),%eax
  802944:	89 44 24 04          	mov    %eax,0x4(%esp)
  802948:	89 3c 24             	mov    %edi,(%esp)
  80294b:	e8 25 e3 ff ff       	call   800c75 <memmove>
		sys_cputs(buf, m);
  802950:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802954:	89 3c 24             	mov    %edi,(%esp)
  802957:	e8 54 e5 ff ff       	call   800eb0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80295c:	01 de                	add    %ebx,%esi
  80295e:	89 f0                	mov    %esi,%eax
  802960:	3b 75 10             	cmp    0x10(%ebp),%esi
  802963:	72 c7                	jb     80292c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802965:	89 f0                	mov    %esi,%eax
  802967:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80296d:	5b                   	pop    %ebx
  80296e:	5e                   	pop    %esi
  80296f:	5f                   	pop    %edi
  802970:	5d                   	pop    %ebp
  802971:	c3                   	ret    

00802972 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802972:	55                   	push   %ebp
  802973:	89 e5                	mov    %esp,%ebp
  802975:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80297e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802985:	00 
  802986:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802989:	89 04 24             	mov    %eax,(%esp)
  80298c:	e8 1f e5 ff ff       	call   800eb0 <sys_cputs>
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
  802996:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802999:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80299d:	75 07                	jne    8029a6 <devcons_read+0x13>
  80299f:	eb 28                	jmp    8029c9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029a1:	e8 64 e9 ff ff       	call   80130a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029a6:	66 90                	xchg   %ax,%ax
  8029a8:	e8 cf e4 ff ff       	call   800e7c <sys_cgetc>
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	90                   	nop
  8029b0:	74 ef                	je     8029a1 <devcons_read+0xe>
  8029b2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	78 16                	js     8029ce <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029b8:	83 f8 04             	cmp    $0x4,%eax
  8029bb:	74 0c                	je     8029c9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8029bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c0:	88 10                	mov    %dl,(%eax)
  8029c2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8029c7:	eb 05                	jmp    8029ce <devcons_read+0x3b>
  8029c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ce:	c9                   	leave  
  8029cf:	c3                   	ret    

008029d0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029d9:	89 04 24             	mov    %eax,(%esp)
  8029dc:	e8 da ed ff ff       	call   8017bb <fd_alloc>
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	78 3f                	js     802a24 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029e5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029ec:	00 
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029fb:	e8 ab e8 ff ff       	call   8012ab <sys_page_alloc>
  802a00:	85 c0                	test   %eax,%eax
  802a02:	78 20                	js     802a24 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a04:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	89 04 24             	mov    %eax,(%esp)
  802a1f:	e8 6c ed ff ff       	call   801790 <fd2num>
}
  802a24:	c9                   	leave  
  802a25:	c3                   	ret    

00802a26 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a26:	55                   	push   %ebp
  802a27:	89 e5                	mov    %esp,%ebp
  802a29:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	89 04 24             	mov    %eax,(%esp)
  802a39:	e8 ef ed ff ff       	call   80182d <fd_lookup>
  802a3e:	85 c0                	test   %eax,%eax
  802a40:	78 11                	js     802a53 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802a4d:	0f 94 c0             	sete   %al
  802a50:	0f b6 c0             	movzbl %al,%eax
}
  802a53:	c9                   	leave  
  802a54:	c3                   	ret    

00802a55 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802a55:	55                   	push   %ebp
  802a56:	89 e5                	mov    %esp,%ebp
  802a58:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a62:	00 
  802a63:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a71:	e8 18 f0 ff ff       	call   801a8e <read>
	if (r < 0)
  802a76:	85 c0                	test   %eax,%eax
  802a78:	78 0f                	js     802a89 <getchar+0x34>
		return r;
	if (r < 1)
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	7f 07                	jg     802a85 <getchar+0x30>
  802a7e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802a83:	eb 04                	jmp    802a89 <getchar+0x34>
		return -E_EOF;
	return c;
  802a85:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    
	...

00802a8c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802a92:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  802a99:	75 78                	jne    802b13 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  802a9b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802aa2:	00 
  802aa3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802aaa:	ee 
  802aab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ab2:	e8 f4 e7 ff ff       	call   8012ab <sys_page_alloc>
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	79 20                	jns    802adb <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  802abb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802abf:	c7 44 24 08 e0 35 80 	movl   $0x8035e0,0x8(%esp)
  802ac6:	00 
  802ac7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802ace:	00 
  802acf:	c7 04 24 fe 35 80 00 	movl   $0x8035fe,(%esp)
  802ad6:	e8 61 d8 ff ff       	call   80033c <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802adb:	c7 44 24 04 20 2b 80 	movl   $0x802b20,0x4(%esp)
  802ae2:	00 
  802ae3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aea:	e8 e6 e5 ff ff       	call   8010d5 <sys_env_set_pgfault_upcall>
  802aef:	85 c0                	test   %eax,%eax
  802af1:	79 20                	jns    802b13 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802af3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802af7:	c7 44 24 08 0c 36 80 	movl   $0x80360c,0x8(%esp)
  802afe:	00 
  802aff:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802b06:	00 
  802b07:	c7 04 24 fe 35 80 00 	movl   $0x8035fe,(%esp)
  802b0e:	e8 29 d8 ff ff       	call   80033c <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	a3 7c 70 80 00       	mov    %eax,0x80707c
	
}
  802b1b:	c9                   	leave  
  802b1c:	c3                   	ret    
  802b1d:	00 00                	add    %al,(%eax)
	...

00802b20 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b20:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b21:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  802b26:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b28:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802b2b:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802b2d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802b31:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802b35:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802b37:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802b38:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802b3a:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802b3d:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802b41:	83 c4 08             	add    $0x8,%esp
	popal
  802b44:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802b45:	83 c4 04             	add    $0x4,%esp
	popfl
  802b48:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802b49:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802b4a:	c3                   	ret    
  802b4b:	00 00                	add    %al,(%eax)
  802b4d:	00 00                	add    %al,(%eax)
	...

00802b50 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b50:	55                   	push   %ebp
  802b51:	89 e5                	mov    %esp,%ebp
  802b53:	57                   	push   %edi
  802b54:	56                   	push   %esi
  802b55:	53                   	push   %ebx
  802b56:	83 ec 1c             	sub    $0x1c,%esp
  802b59:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b5f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802b62:	85 db                	test   %ebx,%ebx
  802b64:	75 2d                	jne    802b93 <ipc_send+0x43>
  802b66:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  802b6b:	eb 26                	jmp    802b93 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  802b6d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b70:	74 1c                	je     802b8e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802b72:	c7 44 24 08 38 36 80 	movl   $0x803638,0x8(%esp)
  802b79:	00 
  802b7a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802b81:	00 
  802b82:	c7 04 24 5c 36 80 00 	movl   $0x80365c,(%esp)
  802b89:	e8 ae d7 ff ff       	call   80033c <_panic>
		sys_yield();
  802b8e:	e8 77 e7 ff ff       	call   80130a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802b93:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802b97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b9b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	89 04 24             	mov    %eax,(%esp)
  802ba5:	e8 f3 e4 ff ff       	call   80109d <sys_ipc_try_send>
  802baa:	85 c0                	test   %eax,%eax
  802bac:	78 bf                	js     802b6d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802bae:	83 c4 1c             	add    $0x1c,%esp
  802bb1:	5b                   	pop    %ebx
  802bb2:	5e                   	pop    %esi
  802bb3:	5f                   	pop    %edi
  802bb4:	5d                   	pop    %ebp
  802bb5:	c3                   	ret    

00802bb6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	56                   	push   %esi
  802bba:	53                   	push   %ebx
  802bbb:	83 ec 10             	sub    $0x10,%esp
  802bbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	75 05                	jne    802bd0 <ipc_recv+0x1a>
  802bcb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802bd0:	89 04 24             	mov    %eax,(%esp)
  802bd3:	e8 68 e4 ff ff       	call   801040 <sys_ipc_recv>
  802bd8:	85 c0                	test   %eax,%eax
  802bda:	79 16                	jns    802bf2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  802bdc:	85 db                	test   %ebx,%ebx
  802bde:	74 06                	je     802be6 <ipc_recv+0x30>
			*from_env_store = 0;
  802be0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802be6:	85 f6                	test   %esi,%esi
  802be8:	74 2c                	je     802c16 <ipc_recv+0x60>
			*perm_store = 0;
  802bea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802bf0:	eb 24                	jmp    802c16 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802bf2:	85 db                	test   %ebx,%ebx
  802bf4:	74 0a                	je     802c00 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802bf6:	a1 74 70 80 00       	mov    0x807074,%eax
  802bfb:	8b 40 74             	mov    0x74(%eax),%eax
  802bfe:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802c00:	85 f6                	test   %esi,%esi
  802c02:	74 0a                	je     802c0e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802c04:	a1 74 70 80 00       	mov    0x807074,%eax
  802c09:	8b 40 78             	mov    0x78(%eax),%eax
  802c0c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  802c0e:	a1 74 70 80 00       	mov    0x807074,%eax
  802c13:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802c16:	83 c4 10             	add    $0x10,%esp
  802c19:	5b                   	pop    %ebx
  802c1a:	5e                   	pop    %esi
  802c1b:	5d                   	pop    %ebp
  802c1c:	c3                   	ret    
  802c1d:	00 00                	add    %al,(%eax)
	...

00802c20 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c20:	55                   	push   %ebp
  802c21:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	89 c2                	mov    %eax,%edx
  802c28:	c1 ea 16             	shr    $0x16,%edx
  802c2b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c32:	f6 c2 01             	test   $0x1,%dl
  802c35:	74 26                	je     802c5d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802c37:	c1 e8 0c             	shr    $0xc,%eax
  802c3a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c41:	a8 01                	test   $0x1,%al
  802c43:	74 18                	je     802c5d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802c45:	c1 e8 0c             	shr    $0xc,%eax
  802c48:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802c4b:	c1 e2 02             	shl    $0x2,%edx
  802c4e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802c53:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802c58:	0f b7 c0             	movzwl %ax,%eax
  802c5b:	eb 05                	jmp    802c62 <pageref+0x42>
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c62:	5d                   	pop    %ebp
  802c63:	c3                   	ret    
	...

00802c70 <__udivdi3>:
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
  802c73:	57                   	push   %edi
  802c74:	56                   	push   %esi
  802c75:	83 ec 10             	sub    $0x10,%esp
  802c78:	8b 45 14             	mov    0x14(%ebp),%eax
  802c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7e:	8b 75 10             	mov    0x10(%ebp),%esi
  802c81:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c84:	85 c0                	test   %eax,%eax
  802c86:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802c89:	75 35                	jne    802cc0 <__udivdi3+0x50>
  802c8b:	39 fe                	cmp    %edi,%esi
  802c8d:	77 61                	ja     802cf0 <__udivdi3+0x80>
  802c8f:	85 f6                	test   %esi,%esi
  802c91:	75 0b                	jne    802c9e <__udivdi3+0x2e>
  802c93:	b8 01 00 00 00       	mov    $0x1,%eax
  802c98:	31 d2                	xor    %edx,%edx
  802c9a:	f7 f6                	div    %esi
  802c9c:	89 c6                	mov    %eax,%esi
  802c9e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ca1:	31 d2                	xor    %edx,%edx
  802ca3:	89 f8                	mov    %edi,%eax
  802ca5:	f7 f6                	div    %esi
  802ca7:	89 c7                	mov    %eax,%edi
  802ca9:	89 c8                	mov    %ecx,%eax
  802cab:	f7 f6                	div    %esi
  802cad:	89 c1                	mov    %eax,%ecx
  802caf:	89 fa                	mov    %edi,%edx
  802cb1:	89 c8                	mov    %ecx,%eax
  802cb3:	83 c4 10             	add    $0x10,%esp
  802cb6:	5e                   	pop    %esi
  802cb7:	5f                   	pop    %edi
  802cb8:	5d                   	pop    %ebp
  802cb9:	c3                   	ret    
  802cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cc0:	39 f8                	cmp    %edi,%eax
  802cc2:	77 1c                	ja     802ce0 <__udivdi3+0x70>
  802cc4:	0f bd d0             	bsr    %eax,%edx
  802cc7:	83 f2 1f             	xor    $0x1f,%edx
  802cca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ccd:	75 39                	jne    802d08 <__udivdi3+0x98>
  802ccf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802cd2:	0f 86 a0 00 00 00    	jbe    802d78 <__udivdi3+0x108>
  802cd8:	39 f8                	cmp    %edi,%eax
  802cda:	0f 82 98 00 00 00    	jb     802d78 <__udivdi3+0x108>
  802ce0:	31 ff                	xor    %edi,%edi
  802ce2:	31 c9                	xor    %ecx,%ecx
  802ce4:	89 c8                	mov    %ecx,%eax
  802ce6:	89 fa                	mov    %edi,%edx
  802ce8:	83 c4 10             	add    $0x10,%esp
  802ceb:	5e                   	pop    %esi
  802cec:	5f                   	pop    %edi
  802ced:	5d                   	pop    %ebp
  802cee:	c3                   	ret    
  802cef:	90                   	nop
  802cf0:	89 d1                	mov    %edx,%ecx
  802cf2:	89 fa                	mov    %edi,%edx
  802cf4:	89 c8                	mov    %ecx,%eax
  802cf6:	31 ff                	xor    %edi,%edi
  802cf8:	f7 f6                	div    %esi
  802cfa:	89 c1                	mov    %eax,%ecx
  802cfc:	89 fa                	mov    %edi,%edx
  802cfe:	89 c8                	mov    %ecx,%eax
  802d00:	83 c4 10             	add    $0x10,%esp
  802d03:	5e                   	pop    %esi
  802d04:	5f                   	pop    %edi
  802d05:	5d                   	pop    %ebp
  802d06:	c3                   	ret    
  802d07:	90                   	nop
  802d08:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d0c:	89 f2                	mov    %esi,%edx
  802d0e:	d3 e0                	shl    %cl,%eax
  802d10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d13:	b8 20 00 00 00       	mov    $0x20,%eax
  802d18:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d1b:	89 c1                	mov    %eax,%ecx
  802d1d:	d3 ea                	shr    %cl,%edx
  802d1f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d23:	0b 55 ec             	or     -0x14(%ebp),%edx
  802d26:	d3 e6                	shl    %cl,%esi
  802d28:	89 c1                	mov    %eax,%ecx
  802d2a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802d2d:	89 fe                	mov    %edi,%esi
  802d2f:	d3 ee                	shr    %cl,%esi
  802d31:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d35:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3b:	d3 e7                	shl    %cl,%edi
  802d3d:	89 c1                	mov    %eax,%ecx
  802d3f:	d3 ea                	shr    %cl,%edx
  802d41:	09 d7                	or     %edx,%edi
  802d43:	89 f2                	mov    %esi,%edx
  802d45:	89 f8                	mov    %edi,%eax
  802d47:	f7 75 ec             	divl   -0x14(%ebp)
  802d4a:	89 d6                	mov    %edx,%esi
  802d4c:	89 c7                	mov    %eax,%edi
  802d4e:	f7 65 e8             	mull   -0x18(%ebp)
  802d51:	39 d6                	cmp    %edx,%esi
  802d53:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d56:	72 30                	jb     802d88 <__udivdi3+0x118>
  802d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d5f:	d3 e2                	shl    %cl,%edx
  802d61:	39 c2                	cmp    %eax,%edx
  802d63:	73 05                	jae    802d6a <__udivdi3+0xfa>
  802d65:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802d68:	74 1e                	je     802d88 <__udivdi3+0x118>
  802d6a:	89 f9                	mov    %edi,%ecx
  802d6c:	31 ff                	xor    %edi,%edi
  802d6e:	e9 71 ff ff ff       	jmp    802ce4 <__udivdi3+0x74>
  802d73:	90                   	nop
  802d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d78:	31 ff                	xor    %edi,%edi
  802d7a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802d7f:	e9 60 ff ff ff       	jmp    802ce4 <__udivdi3+0x74>
  802d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d88:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802d8b:	31 ff                	xor    %edi,%edi
  802d8d:	89 c8                	mov    %ecx,%eax
  802d8f:	89 fa                	mov    %edi,%edx
  802d91:	83 c4 10             	add    $0x10,%esp
  802d94:	5e                   	pop    %esi
  802d95:	5f                   	pop    %edi
  802d96:	5d                   	pop    %ebp
  802d97:	c3                   	ret    
	...

00802da0 <__umoddi3>:
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
  802da3:	57                   	push   %edi
  802da4:	56                   	push   %esi
  802da5:	83 ec 20             	sub    $0x20,%esp
  802da8:	8b 55 14             	mov    0x14(%ebp),%edx
  802dab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dae:	8b 7d 10             	mov    0x10(%ebp),%edi
  802db1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802db4:	85 d2                	test   %edx,%edx
  802db6:	89 c8                	mov    %ecx,%eax
  802db8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802dbb:	75 13                	jne    802dd0 <__umoddi3+0x30>
  802dbd:	39 f7                	cmp    %esi,%edi
  802dbf:	76 3f                	jbe    802e00 <__umoddi3+0x60>
  802dc1:	89 f2                	mov    %esi,%edx
  802dc3:	f7 f7                	div    %edi
  802dc5:	89 d0                	mov    %edx,%eax
  802dc7:	31 d2                	xor    %edx,%edx
  802dc9:	83 c4 20             	add    $0x20,%esp
  802dcc:	5e                   	pop    %esi
  802dcd:	5f                   	pop    %edi
  802dce:	5d                   	pop    %ebp
  802dcf:	c3                   	ret    
  802dd0:	39 f2                	cmp    %esi,%edx
  802dd2:	77 4c                	ja     802e20 <__umoddi3+0x80>
  802dd4:	0f bd ca             	bsr    %edx,%ecx
  802dd7:	83 f1 1f             	xor    $0x1f,%ecx
  802dda:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802ddd:	75 51                	jne    802e30 <__umoddi3+0x90>
  802ddf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802de2:	0f 87 e0 00 00 00    	ja     802ec8 <__umoddi3+0x128>
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	29 f8                	sub    %edi,%eax
  802ded:	19 d6                	sbb    %edx,%esi
  802def:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	89 f2                	mov    %esi,%edx
  802df7:	83 c4 20             	add    $0x20,%esp
  802dfa:	5e                   	pop    %esi
  802dfb:	5f                   	pop    %edi
  802dfc:	5d                   	pop    %ebp
  802dfd:	c3                   	ret    
  802dfe:	66 90                	xchg   %ax,%ax
  802e00:	85 ff                	test   %edi,%edi
  802e02:	75 0b                	jne    802e0f <__umoddi3+0x6f>
  802e04:	b8 01 00 00 00       	mov    $0x1,%eax
  802e09:	31 d2                	xor    %edx,%edx
  802e0b:	f7 f7                	div    %edi
  802e0d:	89 c7                	mov    %eax,%edi
  802e0f:	89 f0                	mov    %esi,%eax
  802e11:	31 d2                	xor    %edx,%edx
  802e13:	f7 f7                	div    %edi
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	f7 f7                	div    %edi
  802e1a:	eb a9                	jmp    802dc5 <__umoddi3+0x25>
  802e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e20:	89 c8                	mov    %ecx,%eax
  802e22:	89 f2                	mov    %esi,%edx
  802e24:	83 c4 20             	add    $0x20,%esp
  802e27:	5e                   	pop    %esi
  802e28:	5f                   	pop    %edi
  802e29:	5d                   	pop    %ebp
  802e2a:	c3                   	ret    
  802e2b:	90                   	nop
  802e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e30:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e34:	d3 e2                	shl    %cl,%edx
  802e36:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e39:	ba 20 00 00 00       	mov    $0x20,%edx
  802e3e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802e41:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e44:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e48:	89 fa                	mov    %edi,%edx
  802e4a:	d3 ea                	shr    %cl,%edx
  802e4c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e50:	0b 55 f4             	or     -0xc(%ebp),%edx
  802e53:	d3 e7                	shl    %cl,%edi
  802e55:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e59:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e5c:	89 f2                	mov    %esi,%edx
  802e5e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802e61:	89 c7                	mov    %eax,%edi
  802e63:	d3 ea                	shr    %cl,%edx
  802e65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802e6c:	89 c2                	mov    %eax,%edx
  802e6e:	d3 e6                	shl    %cl,%esi
  802e70:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e74:	d3 ea                	shr    %cl,%edx
  802e76:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e7a:	09 d6                	or     %edx,%esi
  802e7c:	89 f0                	mov    %esi,%eax
  802e7e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802e81:	d3 e7                	shl    %cl,%edi
  802e83:	89 f2                	mov    %esi,%edx
  802e85:	f7 75 f4             	divl   -0xc(%ebp)
  802e88:	89 d6                	mov    %edx,%esi
  802e8a:	f7 65 e8             	mull   -0x18(%ebp)
  802e8d:	39 d6                	cmp    %edx,%esi
  802e8f:	72 2b                	jb     802ebc <__umoddi3+0x11c>
  802e91:	39 c7                	cmp    %eax,%edi
  802e93:	72 23                	jb     802eb8 <__umoddi3+0x118>
  802e95:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e99:	29 c7                	sub    %eax,%edi
  802e9b:	19 d6                	sbb    %edx,%esi
  802e9d:	89 f0                	mov    %esi,%eax
  802e9f:	89 f2                	mov    %esi,%edx
  802ea1:	d3 ef                	shr    %cl,%edi
  802ea3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ea7:	d3 e0                	shl    %cl,%eax
  802ea9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ead:	09 f8                	or     %edi,%eax
  802eaf:	d3 ea                	shr    %cl,%edx
  802eb1:	83 c4 20             	add    $0x20,%esp
  802eb4:	5e                   	pop    %esi
  802eb5:	5f                   	pop    %edi
  802eb6:	5d                   	pop    %ebp
  802eb7:	c3                   	ret    
  802eb8:	39 d6                	cmp    %edx,%esi
  802eba:	75 d9                	jne    802e95 <__umoddi3+0xf5>
  802ebc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ebf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802ec2:	eb d1                	jmp    802e95 <__umoddi3+0xf5>
  802ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ec8:	39 f2                	cmp    %esi,%edx
  802eca:	0f 82 18 ff ff ff    	jb     802de8 <__umoddi3+0x48>
  802ed0:	e9 1d ff ff ff       	jmp    802df2 <__umoddi3+0x52>
