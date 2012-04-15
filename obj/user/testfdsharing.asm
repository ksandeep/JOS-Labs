
obj/user/testfdsharing:     file format elf32-i386


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
  80002c:	e8 cf 03 00 00       	call   800400 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

char buf[512], buf2[512];

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800044:	00 
  800045:	c7 04 24 ec 30 80 00 	movl   $0x8030ec,(%esp)
  80004c:	e8 72 20 00 00       	call   8020c3 <open>
  800051:	89 c3                	mov    %eax,%ebx
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("open motd: %e", fd);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 80 30 80 	movl   $0x803080,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  800072:	e8 f5 03 00 00       	call   80046c <_panic>
	seek(fd, 0);
  800077:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007e:	00 
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 1e 19 00 00       	call   8019a5 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800087:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 80 72 80 	movl   $0x807280,0x4(%esp)
  800096:	00 
  800097:	89 1c 24             	mov    %ebx,(%esp)
  80009a:	e8 ad 1b 00 00       	call   801c4c <readn>
  80009f:	89 c7                	mov    %eax,%edi
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	7f 20                	jg     8000c5 <umain+0x91>
		panic("readn: %e", n);
  8000a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a9:	c7 44 24 08 a3 30 80 	movl   $0x8030a3,0x8(%esp)
  8000b0:	00 
  8000b1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b8:	00 
  8000b9:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  8000c0:	e8 a7 03 00 00       	call   80046c <_panic>

	if ((r = fork()) < 0)
  8000c5:	e8 9b 15 00 00       	call   801665 <fork>
  8000ca:	89 c6                	mov    %eax,%esi
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	79 20                	jns    8000f0 <umain+0xbc>
		panic("fork: %e", r);
  8000d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d4:	c7 44 24 08 ad 30 80 	movl   $0x8030ad,0x8(%esp)
  8000db:	00 
  8000dc:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e3:	00 
  8000e4:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  8000eb:	e8 7c 03 00 00       	call   80046c <_panic>
	if (r == 0) {
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	0f 85 bd 00 00 00    	jne    8001b5 <umain+0x181>
		seek(fd, 0);
  8000f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ff:	00 
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 9d 18 00 00       	call   8019a5 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800108:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  80010f:	e8 1d 04 00 00       	call   800531 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800114:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011b:	00 
  80011c:	c7 44 24 04 80 70 80 	movl   $0x807080,0x4(%esp)
  800123:	00 
  800124:	89 1c 24             	mov    %ebx,(%esp)
  800127:	e8 20 1b 00 00       	call   801c4c <readn>
  80012c:	39 c7                	cmp    %eax,%edi
  80012e:	74 24                	je     800154 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  800130:	89 44 24 10          	mov    %eax,0x10(%esp)
  800134:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800138:	c7 44 24 08 d8 31 80 	movl   $0x8031d8,0x8(%esp)
  80013f:	00 
  800140:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800147:	00 
  800148:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  80014f:	e8 18 03 00 00       	call   80046c <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800154:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800158:	c7 44 24 04 80 70 80 	movl   $0x807080,0x4(%esp)
  80015f:	00 
  800160:	c7 04 24 80 72 80 00 	movl   $0x807280,(%esp)
  800167:	e8 d6 0c 00 00       	call   800e42 <memcmp>
  80016c:	85 c0                	test   %eax,%eax
  80016e:	74 1c                	je     80018c <umain+0x158>
			panic("read in parent got different bytes from read in child");
  800170:	c7 44 24 08 04 32 80 	movl   $0x803204,0x8(%esp)
  800177:	00 
  800178:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017f:	00 
  800180:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  800187:	e8 e0 02 00 00       	call   80046c <_panic>
		cprintf("read in child succeeded\n");
  80018c:	c7 04 24 b6 30 80 00 	movl   $0x8030b6,(%esp)
  800193:	e8 99 03 00 00       	call   800531 <cprintf>
		seek(fd, 0);
  800198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019f:	00 
  8001a0:	89 1c 24             	mov    %ebx,(%esp)
  8001a3:	e8 fd 17 00 00       	call   8019a5 <seek>
		close(fd);
  8001a8:	89 1c 24             	mov    %ebx,(%esp)
  8001ab:	e8 6e 1b 00 00       	call   801d1e <close>
		exit();
  8001b0:	e8 9b 02 00 00       	call   800450 <exit>
	}
	wait(r);
  8001b5:	89 34 24             	mov    %esi,(%esp)
  8001b8:	e8 47 28 00 00       	call   802a04 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c4:	00 
  8001c5:	c7 44 24 04 80 70 80 	movl   $0x807080,0x4(%esp)
  8001cc:	00 
  8001cd:	89 1c 24             	mov    %ebx,(%esp)
  8001d0:	e8 77 1a 00 00       	call   801c4c <readn>
  8001d5:	39 c7                	cmp    %eax,%edi
  8001d7:	74 24                	je     8001fd <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e1:	c7 44 24 08 3c 32 80 	movl   $0x80323c,0x8(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001f0:	00 
  8001f1:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  8001f8:	e8 6f 02 00 00       	call   80046c <_panic>
	cprintf("read in parent succeeded\n");		
  8001fd:	c7 04 24 cf 30 80 00 	movl   $0x8030cf,(%esp)
  800204:	e8 28 03 00 00       	call   800531 <cprintf>
	close(fd);
  800209:	89 1c 24             	mov    %ebx,(%esp)
  80020c:	e8 0d 1b 00 00       	call   801d1e <close>

	if ((fd = open("newmotd", O_RDWR)) < 0)
  800211:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  800218:	00 
  800219:	c7 04 24 e9 30 80 00 	movl   $0x8030e9,(%esp)
  800220:	e8 9e 1e 00 00       	call   8020c3 <open>
  800225:	89 c3                	mov    %eax,%ebx
  800227:	85 c0                	test   %eax,%eax
  800229:	79 20                	jns    80024b <umain+0x217>
		panic("open newmotd: %e", fd);
  80022b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022f:	c7 44 24 08 f1 30 80 	movl   $0x8030f1,0x8(%esp)
  800236:	00 
  800237:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  80023e:	00 
  80023f:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  800246:	e8 21 02 00 00       	call   80046c <_panic>
	seek(fd, 0);
  80024b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800252:	00 
  800253:	89 04 24             	mov    %eax,(%esp)
  800256:	e8 4a 17 00 00       	call   8019a5 <seek>
	if ((n = write(fd, "hello", 5)) != 5)
  80025b:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  800262:	00 
  800263:	c7 44 24 04 02 31 80 	movl   $0x803102,0x4(%esp)
  80026a:	00 
  80026b:	89 1c 24             	mov    %ebx,(%esp)
  80026e:	e8 c2 18 00 00       	call   801b35 <write>
  800273:	83 f8 05             	cmp    $0x5,%eax
  800276:	74 20                	je     800298 <umain+0x264>
		panic("write: %e", n);
  800278:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80027c:	c7 44 24 08 08 31 80 	movl   $0x803108,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  800293:	e8 d4 01 00 00       	call   80046c <_panic>

	if ((r = fork()) < 0)
  800298:	e8 c8 13 00 00       	call   801665 <fork>
  80029d:	89 c6                	mov    %eax,%esi
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	79 20                	jns    8002c3 <umain+0x28f>
		panic("fork: %e", r);
  8002a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a7:	c7 44 24 08 ad 30 80 	movl   $0x8030ad,0x8(%esp)
  8002ae:	00 
  8002af:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002b6:	00 
  8002b7:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  8002be:	e8 a9 01 00 00       	call   80046c <_panic>
	if (r == 0) {
  8002c3:	85 c0                	test   %eax,%eax
  8002c5:	75 72                	jne    800339 <umain+0x305>
		seek(fd, 0);
  8002c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002ce:	00 
  8002cf:	89 1c 24             	mov    %ebx,(%esp)
  8002d2:	e8 ce 16 00 00       	call   8019a5 <seek>
		cprintf("going to write in child\n");
  8002d7:	c7 04 24 12 31 80 00 	movl   $0x803112,(%esp)
  8002de:	e8 4e 02 00 00       	call   800531 <cprintf>
		if ((n = write(fd, "world", 5)) != 5)
  8002e3:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  8002ea:	00 
  8002eb:	c7 44 24 04 2b 31 80 	movl   $0x80312b,0x4(%esp)
  8002f2:	00 
  8002f3:	89 1c 24             	mov    %ebx,(%esp)
  8002f6:	e8 3a 18 00 00       	call   801b35 <write>
  8002fb:	83 f8 05             	cmp    $0x5,%eax
  8002fe:	74 20                	je     800320 <umain+0x2ec>
			panic("write in child: %e", n);
  800300:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800304:	c7 44 24 08 31 31 80 	movl   $0x803131,0x8(%esp)
  80030b:	00 
  80030c:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  800313:	00 
  800314:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  80031b:	e8 4c 01 00 00       	call   80046c <_panic>
		cprintf("write in child finished\n");
  800320:	c7 04 24 44 31 80 00 	movl   $0x803144,(%esp)
  800327:	e8 05 02 00 00       	call   800531 <cprintf>
		close(fd);
  80032c:	89 1c 24             	mov    %ebx,(%esp)
  80032f:	e8 ea 19 00 00       	call   801d1e <close>
		exit();
  800334:	e8 17 01 00 00       	call   800450 <exit>
	}
	wait(r);
  800339:	89 34 24             	mov    %esi,(%esp)
  80033c:	e8 c3 26 00 00       	call   802a04 <wait>
	seek(fd, 0);
  800341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800348:	00 
  800349:	89 1c 24             	mov    %ebx,(%esp)
  80034c:	e8 54 16 00 00       	call   8019a5 <seek>
	if ((n = readn(fd, buf, 5)) != 5)
  800351:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  800358:	00 
  800359:	c7 44 24 04 80 72 80 	movl   $0x807280,0x4(%esp)
  800360:	00 
  800361:	89 1c 24             	mov    %ebx,(%esp)
  800364:	e8 e3 18 00 00       	call   801c4c <readn>
  800369:	83 f8 05             	cmp    $0x5,%eax
  80036c:	74 20                	je     80038e <umain+0x35a>
		panic("readn: %e", n);
  80036e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800372:	c7 44 24 08 a3 30 80 	movl   $0x8030a3,0x8(%esp)
  800379:	00 
  80037a:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  800381:	00 
  800382:	c7 04 24 8e 30 80 00 	movl   $0x80308e,(%esp)
  800389:	e8 de 00 00 00       	call   80046c <_panic>
	buf[5] = 0;
  80038e:	c6 05 85 72 80 00 00 	movb   $0x0,0x807285
	if (strcmp(buf, "hello") == 0)
  800395:	c7 44 24 04 02 31 80 	movl   $0x803102,0x4(%esp)
  80039c:	00 
  80039d:	c7 04 24 80 72 80 00 	movl   $0x807280,(%esp)
  8003a4:	e8 d0 08 00 00       	call   800c79 <strcmp>
  8003a9:	85 c0                	test   %eax,%eax
  8003ab:	75 0e                	jne    8003bb <umain+0x387>
		cprintf("write to file failed; got old data\n");
  8003ad:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  8003b4:	e8 78 01 00 00       	call   800531 <cprintf>
  8003b9:	eb 3a                	jmp    8003f5 <umain+0x3c1>
	else if (strcmp(buf, "world") == 0)
  8003bb:	c7 44 24 04 2b 31 80 	movl   $0x80312b,0x4(%esp)
  8003c2:	00 
  8003c3:	c7 04 24 80 72 80 00 	movl   $0x807280,(%esp)
  8003ca:	e8 aa 08 00 00       	call   800c79 <strcmp>
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	75 0e                	jne    8003e1 <umain+0x3ad>
		cprintf("write to file succeeded\n");
  8003d3:	c7 04 24 5d 31 80 00 	movl   $0x80315d,(%esp)
  8003da:	e8 52 01 00 00       	call   800531 <cprintf>
  8003df:	eb 14                	jmp    8003f5 <umain+0x3c1>
	else
		cprintf("write to file failed; got %s\n", buf);
  8003e1:	c7 44 24 04 80 72 80 	movl   $0x807280,0x4(%esp)
  8003e8:	00 
  8003e9:	c7 04 24 76 31 80 00 	movl   $0x803176,(%esp)
  8003f0:	e8 3c 01 00 00       	call   800531 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8003f5:	cc                   	int3   

	breakpoint();
}
  8003f6:	83 c4 2c             	add    $0x2c,%esp
  8003f9:	5b                   	pop    %ebx
  8003fa:	5e                   	pop    %esi
  8003fb:	5f                   	pop    %edi
  8003fc:	5d                   	pop    %ebp
  8003fd:	c3                   	ret    
	...

00800400 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	83 ec 18             	sub    $0x18,%esp
  800406:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800409:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80040c:	8b 75 08             	mov    0x8(%ebp),%esi
  80040f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800412:	e8 57 10 00 00       	call   80146e <sys_getenvid>
	env = &envs[ENVX(envid)];
  800417:	25 ff 03 00 00       	and    $0x3ff,%eax
  80041c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80041f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800424:	a3 80 74 80 00       	mov    %eax,0x807480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800429:	85 f6                	test   %esi,%esi
  80042b:	7e 07                	jle    800434 <libmain+0x34>
		binaryname = argv[0];
  80042d:	8b 03                	mov    (%ebx),%eax
  80042f:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800434:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800438:	89 34 24             	mov    %esi,(%esp)
  80043b:	e8 f4 fb ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800440:	e8 0b 00 00 00       	call   800450 <exit>
}
  800445:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800448:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80044b:	89 ec                	mov    %ebp,%esp
  80044d:	5d                   	pop    %ebp
  80044e:	c3                   	ret    
	...

00800450 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800456:	e8 40 19 00 00       	call   801d9b <close_all>
	sys_env_destroy(0);
  80045b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800462:	e8 3b 10 00 00       	call   8014a2 <sys_env_destroy>
}
  800467:	c9                   	leave  
  800468:	c3                   	ret    
  800469:	00 00                	add    %al,(%eax)
	...

0080046c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	53                   	push   %ebx
  800470:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800473:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800476:	a1 84 74 80 00       	mov    0x807484,%eax
  80047b:	85 c0                	test   %eax,%eax
  80047d:	74 10                	je     80048f <_panic+0x23>
		cprintf("%s: ", argv0);
  80047f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800483:	c7 04 24 9b 32 80 00 	movl   $0x80329b,(%esp)
  80048a:	e8 a2 00 00 00       	call   800531 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	89 44 24 08          	mov    %eax,0x8(%esp)
  80049d:	a1 00 70 80 00       	mov    0x807000,%eax
  8004a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a6:	c7 04 24 a0 32 80 00 	movl   $0x8032a0,(%esp)
  8004ad:	e8 7f 00 00 00       	call   800531 <cprintf>
	vcprintf(fmt, ap);
  8004b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b9:	89 04 24             	mov    %eax,(%esp)
  8004bc:	e8 0f 00 00 00       	call   8004d0 <vcprintf>
	cprintf("\n");
  8004c1:	c7 04 24 cd 30 80 00 	movl   $0x8030cd,(%esp)
  8004c8:	e8 64 00 00 00       	call   800531 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004cd:	cc                   	int3   
  8004ce:	eb fd                	jmp    8004cd <_panic+0x61>

008004d0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8004d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e0:	00 00 00 
	b.cnt = 0;
  8004e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800501:	89 44 24 04          	mov    %eax,0x4(%esp)
  800505:	c7 04 24 4b 05 80 00 	movl   $0x80054b,(%esp)
  80050c:	e8 cc 01 00 00       	call   8006dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800511:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800517:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800521:	89 04 24             	mov    %eax,(%esp)
  800524:	e8 b7 0a 00 00       	call   800fe0 <sys_cputs>

	return b.cnt;
}
  800529:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800537:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80053a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	89 04 24             	mov    %eax,(%esp)
  800544:	e8 87 ff ff ff       	call   8004d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	53                   	push   %ebx
  80054f:	83 ec 14             	sub    $0x14,%esp
  800552:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800555:	8b 03                	mov    (%ebx),%eax
  800557:	8b 55 08             	mov    0x8(%ebp),%edx
  80055a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80055e:	83 c0 01             	add    $0x1,%eax
  800561:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800563:	3d ff 00 00 00       	cmp    $0xff,%eax
  800568:	75 19                	jne    800583 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80056a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800571:	00 
  800572:	8d 43 08             	lea    0x8(%ebx),%eax
  800575:	89 04 24             	mov    %eax,(%esp)
  800578:	e8 63 0a 00 00       	call   800fe0 <sys_cputs>
		b->idx = 0;
  80057d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800583:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800587:	83 c4 14             	add    $0x14,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5d                   	pop    %ebp
  80058c:	c3                   	ret    
  80058d:	00 00                	add    %al,(%eax)
	...

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	57                   	push   %edi
  800594:	56                   	push   %esi
  800595:	53                   	push   %ebx
  800596:	83 ec 4c             	sub    $0x4c,%esp
  800599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059c:	89 d6                	mov    %edx,%esi
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8005b0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bb:	39 d1                	cmp    %edx,%ecx
  8005bd:	72 15                	jb     8005d4 <printnum+0x44>
  8005bf:	77 07                	ja     8005c8 <printnum+0x38>
  8005c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c4:	39 d0                	cmp    %edx,%eax
  8005c6:	76 0c                	jbe    8005d4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c8:	83 eb 01             	sub    $0x1,%ebx
  8005cb:	85 db                	test   %ebx,%ebx
  8005cd:	8d 76 00             	lea    0x0(%esi),%esi
  8005d0:	7f 61                	jg     800633 <printnum+0xa3>
  8005d2:	eb 70                	jmp    800644 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005d4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8005d8:	83 eb 01             	sub    $0x1,%ebx
  8005db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005e3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8005e7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8005eb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8005ee:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005f1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005ff:	00 
  800600:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800603:	89 04 24             	mov    %eax,(%esp)
  800606:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800609:	89 54 24 04          	mov    %edx,0x4(%esp)
  80060d:	e8 ee 27 00 00       	call   802e00 <__udivdi3>
  800612:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800615:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800618:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80061c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800620:	89 04 24             	mov    %eax,(%esp)
  800623:	89 54 24 04          	mov    %edx,0x4(%esp)
  800627:	89 f2                	mov    %esi,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	e8 5f ff ff ff       	call   800590 <printnum>
  800631:	eb 11                	jmp    800644 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800633:	89 74 24 04          	mov    %esi,0x4(%esp)
  800637:	89 3c 24             	mov    %edi,(%esp)
  80063a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063d:	83 eb 01             	sub    $0x1,%ebx
  800640:	85 db                	test   %ebx,%ebx
  800642:	7f ef                	jg     800633 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800644:	89 74 24 04          	mov    %esi,0x4(%esp)
  800648:	8b 74 24 04          	mov    0x4(%esp),%esi
  80064c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800653:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80065a:	00 
  80065b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80065e:	89 14 24             	mov    %edx,(%esp)
  800661:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800664:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800668:	e8 c3 28 00 00       	call   802f30 <__umoddi3>
  80066d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800671:	0f be 80 bc 32 80 00 	movsbl 0x8032bc(%eax),%eax
  800678:	89 04 24             	mov    %eax,(%esp)
  80067b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80067e:	83 c4 4c             	add    $0x4c,%esp
  800681:	5b                   	pop    %ebx
  800682:	5e                   	pop    %esi
  800683:	5f                   	pop    %edi
  800684:	5d                   	pop    %ebp
  800685:	c3                   	ret    

00800686 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800689:	83 fa 01             	cmp    $0x1,%edx
  80068c:	7e 0e                	jle    80069c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	8d 4a 08             	lea    0x8(%edx),%ecx
  800693:	89 08                	mov    %ecx,(%eax)
  800695:	8b 02                	mov    (%edx),%eax
  800697:	8b 52 04             	mov    0x4(%edx),%edx
  80069a:	eb 22                	jmp    8006be <getuint+0x38>
	else if (lflag)
  80069c:	85 d2                	test   %edx,%edx
  80069e:	74 10                	je     8006b0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8006a0:	8b 10                	mov    (%eax),%edx
  8006a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006a5:	89 08                	mov    %ecx,(%eax)
  8006a7:	8b 02                	mov    (%edx),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	eb 0e                	jmp    8006be <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006b5:	89 08                	mov    %ecx,(%eax)
  8006b7:	8b 02                	mov    (%edx),%eax
  8006b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006be:	5d                   	pop    %ebp
  8006bf:	c3                   	ret    

008006c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006ca:	8b 10                	mov    (%eax),%edx
  8006cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8006cf:	73 0a                	jae    8006db <sprintputch+0x1b>
		*b->buf++ = ch;
  8006d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006d4:	88 0a                	mov    %cl,(%edx)
  8006d6:	83 c2 01             	add    $0x1,%edx
  8006d9:	89 10                	mov    %edx,(%eax)
}
  8006db:	5d                   	pop    %ebp
  8006dc:	c3                   	ret    

008006dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	57                   	push   %edi
  8006e1:	56                   	push   %esi
  8006e2:	53                   	push   %ebx
  8006e3:	83 ec 5c             	sub    $0x5c,%esp
  8006e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006ef:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8006f6:	eb 11                	jmp    800709 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	0f 84 ec 03 00 00    	je     800aec <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800700:	89 74 24 04          	mov    %esi,0x4(%esp)
  800704:	89 04 24             	mov    %eax,(%esp)
  800707:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800709:	0f b6 03             	movzbl (%ebx),%eax
  80070c:	83 c3 01             	add    $0x1,%ebx
  80070f:	83 f8 25             	cmp    $0x25,%eax
  800712:	75 e4                	jne    8006f8 <vprintfmt+0x1b>
  800714:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800718:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80071f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800726:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80072d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800732:	eb 06                	jmp    80073a <vprintfmt+0x5d>
  800734:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800738:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073a:	0f b6 13             	movzbl (%ebx),%edx
  80073d:	0f b6 c2             	movzbl %dl,%eax
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800743:	8d 43 01             	lea    0x1(%ebx),%eax
  800746:	83 ea 23             	sub    $0x23,%edx
  800749:	80 fa 55             	cmp    $0x55,%dl
  80074c:	0f 87 7d 03 00 00    	ja     800acf <vprintfmt+0x3f2>
  800752:	0f b6 d2             	movzbl %dl,%edx
  800755:	ff 24 95 00 34 80 00 	jmp    *0x803400(,%edx,4)
  80075c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800760:	eb d6                	jmp    800738 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800762:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800765:	83 ea 30             	sub    $0x30,%edx
  800768:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80076b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80076e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800771:	83 fb 09             	cmp    $0x9,%ebx
  800774:	77 4c                	ja     8007c2 <vprintfmt+0xe5>
  800776:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800779:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80077f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800782:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800786:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800789:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80078c:	83 fb 09             	cmp    $0x9,%ebx
  80078f:	76 eb                	jbe    80077c <vprintfmt+0x9f>
  800791:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800794:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800797:	eb 29                	jmp    8007c2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800799:	8b 55 14             	mov    0x14(%ebp),%edx
  80079c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80079f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8007a2:	8b 12                	mov    (%edx),%edx
  8007a4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8007a7:	eb 19                	jmp    8007c2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8007a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007ac:	c1 fa 1f             	sar    $0x1f,%edx
  8007af:	f7 d2                	not    %edx
  8007b1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8007b4:	eb 82                	jmp    800738 <vprintfmt+0x5b>
  8007b6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8007bd:	e9 76 ff ff ff       	jmp    800738 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8007c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c6:	0f 89 6c ff ff ff    	jns    800738 <vprintfmt+0x5b>
  8007cc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8007d5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007d8:	e9 5b ff ff ff       	jmp    800738 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007dd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8007e0:	e9 53 ff ff ff       	jmp    800738 <vprintfmt+0x5b>
  8007e5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 50 04             	lea    0x4(%eax),%edx
  8007ee:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 04 24             	mov    %eax,(%esp)
  8007fa:	ff d7                	call   *%edi
  8007fc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8007ff:	e9 05 ff ff ff       	jmp    800709 <vprintfmt+0x2c>
  800804:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	89 55 14             	mov    %edx,0x14(%ebp)
  800810:	8b 00                	mov    (%eax),%eax
  800812:	89 c2                	mov    %eax,%edx
  800814:	c1 fa 1f             	sar    $0x1f,%edx
  800817:	31 d0                	xor    %edx,%eax
  800819:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80081b:	83 f8 0f             	cmp    $0xf,%eax
  80081e:	7f 0b                	jg     80082b <vprintfmt+0x14e>
  800820:	8b 14 85 60 35 80 00 	mov    0x803560(,%eax,4),%edx
  800827:	85 d2                	test   %edx,%edx
  800829:	75 20                	jne    80084b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80082b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80082f:	c7 44 24 08 cd 32 80 	movl   $0x8032cd,0x8(%esp)
  800836:	00 
  800837:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083b:	89 3c 24             	mov    %edi,(%esp)
  80083e:	e8 31 03 00 00       	call   800b74 <printfmt>
  800843:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800846:	e9 be fe ff ff       	jmp    800709 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80084b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80084f:	c7 44 24 08 96 38 80 	movl   $0x803896,0x8(%esp)
  800856:	00 
  800857:	89 74 24 04          	mov    %esi,0x4(%esp)
  80085b:	89 3c 24             	mov    %edi,(%esp)
  80085e:	e8 11 03 00 00       	call   800b74 <printfmt>
  800863:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800866:	e9 9e fe ff ff       	jmp    800709 <vprintfmt+0x2c>
  80086b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80086e:	89 c3                	mov    %eax,%ebx
  800870:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8d 50 04             	lea    0x4(%eax),%edx
  80087f:	89 55 14             	mov    %edx,0x14(%ebp)
  800882:	8b 00                	mov    (%eax),%eax
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800887:	85 c0                	test   %eax,%eax
  800889:	75 07                	jne    800892 <vprintfmt+0x1b5>
  80088b:	c7 45 e0 d6 32 80 00 	movl   $0x8032d6,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800892:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800896:	7e 06                	jle    80089e <vprintfmt+0x1c1>
  800898:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80089c:	75 13                	jne    8008b1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80089e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a1:	0f be 02             	movsbl (%edx),%eax
  8008a4:	85 c0                	test   %eax,%eax
  8008a6:	0f 85 99 00 00 00    	jne    800945 <vprintfmt+0x268>
  8008ac:	e9 86 00 00 00       	jmp    800937 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008b8:	89 0c 24             	mov    %ecx,(%esp)
  8008bb:	e8 fb 02 00 00       	call   800bbb <strnlen>
  8008c0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008c3:	29 c2                	sub    %eax,%edx
  8008c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008c8:	85 d2                	test   %edx,%edx
  8008ca:	7e d2                	jle    80089e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8008cc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8008d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008d3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8008d6:	89 d3                	mov    %edx,%ebx
  8008d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008df:	89 04 24             	mov    %eax,(%esp)
  8008e2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e4:	83 eb 01             	sub    $0x1,%ebx
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	7f ed                	jg     8008d8 <vprintfmt+0x1fb>
  8008eb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8008ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8008f5:	eb a7                	jmp    80089e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008fb:	74 18                	je     800915 <vprintfmt+0x238>
  8008fd:	8d 50 e0             	lea    -0x20(%eax),%edx
  800900:	83 fa 5e             	cmp    $0x5e,%edx
  800903:	76 10                	jbe    800915 <vprintfmt+0x238>
					putch('?', putdat);
  800905:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800909:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800910:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800913:	eb 0a                	jmp    80091f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800915:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800919:	89 04 24             	mov    %eax,(%esp)
  80091c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800923:	0f be 03             	movsbl (%ebx),%eax
  800926:	85 c0                	test   %eax,%eax
  800928:	74 05                	je     80092f <vprintfmt+0x252>
  80092a:	83 c3 01             	add    $0x1,%ebx
  80092d:	eb 29                	jmp    800958 <vprintfmt+0x27b>
  80092f:	89 fe                	mov    %edi,%esi
  800931:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800934:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800937:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093b:	7f 2e                	jg     80096b <vprintfmt+0x28e>
  80093d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800940:	e9 c4 fd ff ff       	jmp    800709 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800945:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800948:	83 c2 01             	add    $0x1,%edx
  80094b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80094e:	89 f7                	mov    %esi,%edi
  800950:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800953:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800956:	89 d3                	mov    %edx,%ebx
  800958:	85 f6                	test   %esi,%esi
  80095a:	78 9b                	js     8008f7 <vprintfmt+0x21a>
  80095c:	83 ee 01             	sub    $0x1,%esi
  80095f:	79 96                	jns    8008f7 <vprintfmt+0x21a>
  800961:	89 fe                	mov    %edi,%esi
  800963:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800966:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800969:	eb cc                	jmp    800937 <vprintfmt+0x25a>
  80096b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80096e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800971:	89 74 24 04          	mov    %esi,0x4(%esp)
  800975:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80097c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097e:	83 eb 01             	sub    $0x1,%ebx
  800981:	85 db                	test   %ebx,%ebx
  800983:	7f ec                	jg     800971 <vprintfmt+0x294>
  800985:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800988:	e9 7c fd ff ff       	jmp    800709 <vprintfmt+0x2c>
  80098d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800990:	83 f9 01             	cmp    $0x1,%ecx
  800993:	7e 16                	jle    8009ab <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800995:	8b 45 14             	mov    0x14(%ebp),%eax
  800998:	8d 50 08             	lea    0x8(%eax),%edx
  80099b:	89 55 14             	mov    %edx,0x14(%ebp)
  80099e:	8b 10                	mov    (%eax),%edx
  8009a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8009a3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8009a6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009a9:	eb 32                	jmp    8009dd <vprintfmt+0x300>
	else if (lflag)
  8009ab:	85 c9                	test   %ecx,%ecx
  8009ad:	74 18                	je     8009c7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8d 50 04             	lea    0x4(%eax),%edx
  8009b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009bd:	89 c1                	mov    %eax,%ecx
  8009bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8009c2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009c5:	eb 16                	jmp    8009dd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8009c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ca:	8d 50 04             	lea    0x4(%eax),%edx
  8009cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009d5:	89 c2                	mov    %eax,%edx
  8009d7:	c1 fa 1f             	sar    $0x1f,%edx
  8009da:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009dd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8009e0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009e3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8009e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ec:	0f 89 9b 00 00 00    	jns    800a8d <vprintfmt+0x3b0>
				putch('-', putdat);
  8009f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009fd:	ff d7                	call   *%edi
				num = -(long long) num;
  8009ff:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800a02:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800a05:	f7 d9                	neg    %ecx
  800a07:	83 d3 00             	adc    $0x0,%ebx
  800a0a:	f7 db                	neg    %ebx
  800a0c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a11:	eb 7a                	jmp    800a8d <vprintfmt+0x3b0>
  800a13:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a16:	89 ca                	mov    %ecx,%edx
  800a18:	8d 45 14             	lea    0x14(%ebp),%eax
  800a1b:	e8 66 fc ff ff       	call   800686 <getuint>
  800a20:	89 c1                	mov    %eax,%ecx
  800a22:	89 d3                	mov    %edx,%ebx
  800a24:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800a29:	eb 62                	jmp    800a8d <vprintfmt+0x3b0>
  800a2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  800a2e:	89 ca                	mov    %ecx,%edx
  800a30:	8d 45 14             	lea    0x14(%ebp),%eax
  800a33:	e8 4e fc ff ff       	call   800686 <getuint>
  800a38:	89 c1                	mov    %eax,%ecx
  800a3a:	89 d3                	mov    %edx,%ebx
  800a3c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800a41:	eb 4a                	jmp    800a8d <vprintfmt+0x3b0>
  800a43:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800a46:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a4a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a51:	ff d7                	call   *%edi
			putch('x', putdat);
  800a53:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a57:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a5e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	8d 50 04             	lea    0x4(%eax),%edx
  800a66:	89 55 14             	mov    %edx,0x14(%ebp)
  800a69:	8b 08                	mov    (%eax),%ecx
  800a6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a70:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a75:	eb 16                	jmp    800a8d <vprintfmt+0x3b0>
  800a77:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a7a:	89 ca                	mov    %ecx,%edx
  800a7c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7f:	e8 02 fc ff ff       	call   800686 <getuint>
  800a84:	89 c1                	mov    %eax,%ecx
  800a86:	89 d3                	mov    %edx,%ebx
  800a88:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a8d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800a91:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a98:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa0:	89 0c 24             	mov    %ecx,(%esp)
  800aa3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aa7:	89 f2                	mov    %esi,%edx
  800aa9:	89 f8                	mov    %edi,%eax
  800aab:	e8 e0 fa ff ff       	call   800590 <printnum>
  800ab0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800ab3:	e9 51 fc ff ff       	jmp    800709 <vprintfmt+0x2c>
  800ab8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800abb:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800abe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ac2:	89 14 24             	mov    %edx,(%esp)
  800ac5:	ff d7                	call   *%edi
  800ac7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800aca:	e9 3a fc ff ff       	jmp    800709 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800acf:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ad3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800ada:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800adc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800adf:	80 38 25             	cmpb   $0x25,(%eax)
  800ae2:	0f 84 21 fc ff ff    	je     800709 <vprintfmt+0x2c>
  800ae8:	89 c3                	mov    %eax,%ebx
  800aea:	eb f0                	jmp    800adc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  800aec:	83 c4 5c             	add    $0x5c,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 28             	sub    $0x28,%esp
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800b00:	85 c0                	test   %eax,%eax
  800b02:	74 04                	je     800b08 <vsnprintf+0x14>
  800b04:	85 d2                	test   %edx,%edx
  800b06:	7f 07                	jg     800b0f <vsnprintf+0x1b>
  800b08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b0d:	eb 3b                	jmp    800b4a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b12:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b20:	8b 45 14             	mov    0x14(%ebp),%eax
  800b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b27:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b35:	c7 04 24 c0 06 80 00 	movl   $0x8006c0,(%esp)
  800b3c:	e8 9c fb ff ff       	call   8006dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b44:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800b52:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800b55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b59:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	89 04 24             	mov    %eax,(%esp)
  800b6d:	e8 82 ff ff ff       	call   800af4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800b7a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800b7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b81:	8b 45 10             	mov    0x10(%ebp),%eax
  800b84:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	89 04 24             	mov    %eax,(%esp)
  800b95:	e8 43 fb ff ff       	call   8006dd <vprintfmt>
	va_end(ap);
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    
  800b9c:	00 00                	add    %al,(%eax)
	...

00800ba0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bab:	80 3a 00             	cmpb   $0x0,(%edx)
  800bae:	74 09                	je     800bb9 <strlen+0x19>
		n++;
  800bb0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bb7:	75 f7                	jne    800bb0 <strlen+0x10>
		n++;
	return n;
}
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	53                   	push   %ebx
  800bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc5:	85 c9                	test   %ecx,%ecx
  800bc7:	74 19                	je     800be2 <strnlen+0x27>
  800bc9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800bcc:	74 14                	je     800be2 <strnlen+0x27>
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800bd3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	39 c8                	cmp    %ecx,%eax
  800bd8:	74 0d                	je     800be7 <strnlen+0x2c>
  800bda:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800bde:	75 f3                	jne    800bd3 <strnlen+0x18>
  800be0:	eb 05                	jmp    800be7 <strnlen+0x2c>
  800be2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800be7:	5b                   	pop    %ebx
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	53                   	push   %ebx
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bf4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bf9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bfd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c00:	83 c2 01             	add    $0x1,%edx
  800c03:	84 c9                	test   %cl,%cl
  800c05:	75 f2                	jne    800bf9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c07:	5b                   	pop    %ebx
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c18:	85 f6                	test   %esi,%esi
  800c1a:	74 18                	je     800c34 <strncpy+0x2a>
  800c1c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800c21:	0f b6 1a             	movzbl (%edx),%ebx
  800c24:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c27:	80 3a 01             	cmpb   $0x1,(%edx)
  800c2a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c2d:	83 c1 01             	add    $0x1,%ecx
  800c30:	39 ce                	cmp    %ecx,%esi
  800c32:	77 ed                	ja     800c21 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c34:	5b                   	pop    %ebx
  800c35:	5e                   	pop    %esi
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c43:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c46:	89 f0                	mov    %esi,%eax
  800c48:	85 c9                	test   %ecx,%ecx
  800c4a:	74 27                	je     800c73 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800c4c:	83 e9 01             	sub    $0x1,%ecx
  800c4f:	74 1d                	je     800c6e <strlcpy+0x36>
  800c51:	0f b6 1a             	movzbl (%edx),%ebx
  800c54:	84 db                	test   %bl,%bl
  800c56:	74 16                	je     800c6e <strlcpy+0x36>
			*dst++ = *src++;
  800c58:	88 18                	mov    %bl,(%eax)
  800c5a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c5d:	83 e9 01             	sub    $0x1,%ecx
  800c60:	74 0e                	je     800c70 <strlcpy+0x38>
			*dst++ = *src++;
  800c62:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c65:	0f b6 1a             	movzbl (%edx),%ebx
  800c68:	84 db                	test   %bl,%bl
  800c6a:	75 ec                	jne    800c58 <strlcpy+0x20>
  800c6c:	eb 02                	jmp    800c70 <strlcpy+0x38>
  800c6e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c70:	c6 00 00             	movb   $0x0,(%eax)
  800c73:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c82:	0f b6 01             	movzbl (%ecx),%eax
  800c85:	84 c0                	test   %al,%al
  800c87:	74 15                	je     800c9e <strcmp+0x25>
  800c89:	3a 02                	cmp    (%edx),%al
  800c8b:	75 11                	jne    800c9e <strcmp+0x25>
		p++, q++;
  800c8d:	83 c1 01             	add    $0x1,%ecx
  800c90:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c93:	0f b6 01             	movzbl (%ecx),%eax
  800c96:	84 c0                	test   %al,%al
  800c98:	74 04                	je     800c9e <strcmp+0x25>
  800c9a:	3a 02                	cmp    (%edx),%al
  800c9c:	74 ef                	je     800c8d <strcmp+0x14>
  800c9e:	0f b6 c0             	movzbl %al,%eax
  800ca1:	0f b6 12             	movzbl (%edx),%edx
  800ca4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	53                   	push   %ebx
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	74 23                	je     800cdc <strncmp+0x34>
  800cb9:	0f b6 1a             	movzbl (%edx),%ebx
  800cbc:	84 db                	test   %bl,%bl
  800cbe:	74 24                	je     800ce4 <strncmp+0x3c>
  800cc0:	3a 19                	cmp    (%ecx),%bl
  800cc2:	75 20                	jne    800ce4 <strncmp+0x3c>
  800cc4:	83 e8 01             	sub    $0x1,%eax
  800cc7:	74 13                	je     800cdc <strncmp+0x34>
		n--, p++, q++;
  800cc9:	83 c2 01             	add    $0x1,%edx
  800ccc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ccf:	0f b6 1a             	movzbl (%edx),%ebx
  800cd2:	84 db                	test   %bl,%bl
  800cd4:	74 0e                	je     800ce4 <strncmp+0x3c>
  800cd6:	3a 19                	cmp    (%ecx),%bl
  800cd8:	74 ea                	je     800cc4 <strncmp+0x1c>
  800cda:	eb 08                	jmp    800ce4 <strncmp+0x3c>
  800cdc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ce1:	5b                   	pop    %ebx
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce4:	0f b6 02             	movzbl (%edx),%eax
  800ce7:	0f b6 11             	movzbl (%ecx),%edx
  800cea:	29 d0                	sub    %edx,%eax
  800cec:	eb f3                	jmp    800ce1 <strncmp+0x39>

00800cee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf8:	0f b6 10             	movzbl (%eax),%edx
  800cfb:	84 d2                	test   %dl,%dl
  800cfd:	74 15                	je     800d14 <strchr+0x26>
		if (*s == c)
  800cff:	38 ca                	cmp    %cl,%dl
  800d01:	75 07                	jne    800d0a <strchr+0x1c>
  800d03:	eb 14                	jmp    800d19 <strchr+0x2b>
  800d05:	38 ca                	cmp    %cl,%dl
  800d07:	90                   	nop
  800d08:	74 0f                	je     800d19 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d0a:	83 c0 01             	add    $0x1,%eax
  800d0d:	0f b6 10             	movzbl (%eax),%edx
  800d10:	84 d2                	test   %dl,%dl
  800d12:	75 f1                	jne    800d05 <strchr+0x17>
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d25:	0f b6 10             	movzbl (%eax),%edx
  800d28:	84 d2                	test   %dl,%dl
  800d2a:	74 18                	je     800d44 <strfind+0x29>
		if (*s == c)
  800d2c:	38 ca                	cmp    %cl,%dl
  800d2e:	75 0a                	jne    800d3a <strfind+0x1f>
  800d30:	eb 12                	jmp    800d44 <strfind+0x29>
  800d32:	38 ca                	cmp    %cl,%dl
  800d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d38:	74 0a                	je     800d44 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d3a:	83 c0 01             	add    $0x1,%eax
  800d3d:	0f b6 10             	movzbl (%eax),%edx
  800d40:	84 d2                	test   %dl,%dl
  800d42:	75 ee                	jne    800d32 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	89 1c 24             	mov    %ebx,(%esp)
  800d4f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d57:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d60:	85 c9                	test   %ecx,%ecx
  800d62:	74 30                	je     800d94 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d64:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d6a:	75 25                	jne    800d91 <memset+0x4b>
  800d6c:	f6 c1 03             	test   $0x3,%cl
  800d6f:	75 20                	jne    800d91 <memset+0x4b>
		c &= 0xFF;
  800d71:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d74:	89 d3                	mov    %edx,%ebx
  800d76:	c1 e3 08             	shl    $0x8,%ebx
  800d79:	89 d6                	mov    %edx,%esi
  800d7b:	c1 e6 18             	shl    $0x18,%esi
  800d7e:	89 d0                	mov    %edx,%eax
  800d80:	c1 e0 10             	shl    $0x10,%eax
  800d83:	09 f0                	or     %esi,%eax
  800d85:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d87:	09 d8                	or     %ebx,%eax
  800d89:	c1 e9 02             	shr    $0x2,%ecx
  800d8c:	fc                   	cld    
  800d8d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d8f:	eb 03                	jmp    800d94 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d91:	fc                   	cld    
  800d92:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d94:	89 f8                	mov    %edi,%eax
  800d96:	8b 1c 24             	mov    (%esp),%ebx
  800d99:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d9d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800da1:	89 ec                	mov    %ebp,%esp
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	89 34 24             	mov    %esi,(%esp)
  800dae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800db8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800dbb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800dbd:	39 c6                	cmp    %eax,%esi
  800dbf:	73 35                	jae    800df6 <memmove+0x51>
  800dc1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc4:	39 d0                	cmp    %edx,%eax
  800dc6:	73 2e                	jae    800df6 <memmove+0x51>
		s += n;
		d += n;
  800dc8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dca:	f6 c2 03             	test   $0x3,%dl
  800dcd:	75 1b                	jne    800dea <memmove+0x45>
  800dcf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dd5:	75 13                	jne    800dea <memmove+0x45>
  800dd7:	f6 c1 03             	test   $0x3,%cl
  800dda:	75 0e                	jne    800dea <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ddc:	83 ef 04             	sub    $0x4,%edi
  800ddf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800de2:	c1 e9 02             	shr    $0x2,%ecx
  800de5:	fd                   	std    
  800de6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de8:	eb 09                	jmp    800df3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800dea:	83 ef 01             	sub    $0x1,%edi
  800ded:	8d 72 ff             	lea    -0x1(%edx),%esi
  800df0:	fd                   	std    
  800df1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800df3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800df4:	eb 20                	jmp    800e16 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dfc:	75 15                	jne    800e13 <memmove+0x6e>
  800dfe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e04:	75 0d                	jne    800e13 <memmove+0x6e>
  800e06:	f6 c1 03             	test   $0x3,%cl
  800e09:	75 08                	jne    800e13 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800e0b:	c1 e9 02             	shr    $0x2,%ecx
  800e0e:	fc                   	cld    
  800e0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e11:	eb 03                	jmp    800e16 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e13:	fc                   	cld    
  800e14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e16:	8b 34 24             	mov    (%esp),%esi
  800e19:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800e1d:	89 ec                	mov    %ebp,%esp
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	89 04 24             	mov    %eax,(%esp)
  800e3b:	e8 65 ff ff ff       	call   800da5 <memmove>
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	8b 75 08             	mov    0x8(%ebp),%esi
  800e4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e51:	85 c9                	test   %ecx,%ecx
  800e53:	74 36                	je     800e8b <memcmp+0x49>
		if (*s1 != *s2)
  800e55:	0f b6 06             	movzbl (%esi),%eax
  800e58:	0f b6 1f             	movzbl (%edi),%ebx
  800e5b:	38 d8                	cmp    %bl,%al
  800e5d:	74 20                	je     800e7f <memcmp+0x3d>
  800e5f:	eb 14                	jmp    800e75 <memcmp+0x33>
  800e61:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800e66:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800e6b:	83 c2 01             	add    $0x1,%edx
  800e6e:	83 e9 01             	sub    $0x1,%ecx
  800e71:	38 d8                	cmp    %bl,%al
  800e73:	74 12                	je     800e87 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800e75:	0f b6 c0             	movzbl %al,%eax
  800e78:	0f b6 db             	movzbl %bl,%ebx
  800e7b:	29 d8                	sub    %ebx,%eax
  800e7d:	eb 11                	jmp    800e90 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e7f:	83 e9 01             	sub    $0x1,%ecx
  800e82:	ba 00 00 00 00       	mov    $0x0,%edx
  800e87:	85 c9                	test   %ecx,%ecx
  800e89:	75 d6                	jne    800e61 <memcmp+0x1f>
  800e8b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e9b:	89 c2                	mov    %eax,%edx
  800e9d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ea0:	39 d0                	cmp    %edx,%eax
  800ea2:	73 15                	jae    800eb9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ea4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ea8:	38 08                	cmp    %cl,(%eax)
  800eaa:	75 06                	jne    800eb2 <memfind+0x1d>
  800eac:	eb 0b                	jmp    800eb9 <memfind+0x24>
  800eae:	38 08                	cmp    %cl,(%eax)
  800eb0:	74 07                	je     800eb9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eb2:	83 c0 01             	add    $0x1,%eax
  800eb5:	39 c2                	cmp    %eax,%edx
  800eb7:	77 f5                	ja     800eae <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
  800ec1:	83 ec 04             	sub    $0x4,%esp
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eca:	0f b6 02             	movzbl (%edx),%eax
  800ecd:	3c 20                	cmp    $0x20,%al
  800ecf:	74 04                	je     800ed5 <strtol+0x1a>
  800ed1:	3c 09                	cmp    $0x9,%al
  800ed3:	75 0e                	jne    800ee3 <strtol+0x28>
		s++;
  800ed5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed8:	0f b6 02             	movzbl (%edx),%eax
  800edb:	3c 20                	cmp    $0x20,%al
  800edd:	74 f6                	je     800ed5 <strtol+0x1a>
  800edf:	3c 09                	cmp    $0x9,%al
  800ee1:	74 f2                	je     800ed5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ee3:	3c 2b                	cmp    $0x2b,%al
  800ee5:	75 0c                	jne    800ef3 <strtol+0x38>
		s++;
  800ee7:	83 c2 01             	add    $0x1,%edx
  800eea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ef1:	eb 15                	jmp    800f08 <strtol+0x4d>
	else if (*s == '-')
  800ef3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800efa:	3c 2d                	cmp    $0x2d,%al
  800efc:	75 0a                	jne    800f08 <strtol+0x4d>
		s++, neg = 1;
  800efe:	83 c2 01             	add    $0x1,%edx
  800f01:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f08:	85 db                	test   %ebx,%ebx
  800f0a:	0f 94 c0             	sete   %al
  800f0d:	74 05                	je     800f14 <strtol+0x59>
  800f0f:	83 fb 10             	cmp    $0x10,%ebx
  800f12:	75 18                	jne    800f2c <strtol+0x71>
  800f14:	80 3a 30             	cmpb   $0x30,(%edx)
  800f17:	75 13                	jne    800f2c <strtol+0x71>
  800f19:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f1d:	8d 76 00             	lea    0x0(%esi),%esi
  800f20:	75 0a                	jne    800f2c <strtol+0x71>
		s += 2, base = 16;
  800f22:	83 c2 02             	add    $0x2,%edx
  800f25:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f2a:	eb 15                	jmp    800f41 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f2c:	84 c0                	test   %al,%al
  800f2e:	66 90                	xchg   %ax,%ax
  800f30:	74 0f                	je     800f41 <strtol+0x86>
  800f32:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800f37:	80 3a 30             	cmpb   $0x30,(%edx)
  800f3a:	75 05                	jne    800f41 <strtol+0x86>
		s++, base = 8;
  800f3c:	83 c2 01             	add    $0x1,%edx
  800f3f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f41:	b8 00 00 00 00       	mov    $0x0,%eax
  800f46:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f48:	0f b6 0a             	movzbl (%edx),%ecx
  800f4b:	89 cf                	mov    %ecx,%edi
  800f4d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f50:	80 fb 09             	cmp    $0x9,%bl
  800f53:	77 08                	ja     800f5d <strtol+0xa2>
			dig = *s - '0';
  800f55:	0f be c9             	movsbl %cl,%ecx
  800f58:	83 e9 30             	sub    $0x30,%ecx
  800f5b:	eb 1e                	jmp    800f7b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800f5d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f60:	80 fb 19             	cmp    $0x19,%bl
  800f63:	77 08                	ja     800f6d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800f65:	0f be c9             	movsbl %cl,%ecx
  800f68:	83 e9 57             	sub    $0x57,%ecx
  800f6b:	eb 0e                	jmp    800f7b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800f6d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f70:	80 fb 19             	cmp    $0x19,%bl
  800f73:	77 15                	ja     800f8a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800f75:	0f be c9             	movsbl %cl,%ecx
  800f78:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f7b:	39 f1                	cmp    %esi,%ecx
  800f7d:	7d 0b                	jge    800f8a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800f7f:	83 c2 01             	add    $0x1,%edx
  800f82:	0f af c6             	imul   %esi,%eax
  800f85:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f88:	eb be                	jmp    800f48 <strtol+0x8d>
  800f8a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f90:	74 05                	je     800f97 <strtol+0xdc>
		*endptr = (char *) s;
  800f92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f95:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f9b:	74 04                	je     800fa1 <strtol+0xe6>
  800f9d:	89 c8                	mov    %ecx,%eax
  800f9f:	f7 d8                	neg    %eax
}
  800fa1:	83 c4 04             	add    $0x4,%esp
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    
  800fa9:	00 00                	add    %al,(%eax)
	...

00800fac <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	83 ec 0c             	sub    $0xc,%esp
  800fb2:	89 1c 24             	mov    %ebx,(%esp)
  800fb5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fb9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc7:	89 d1                	mov    %edx,%ecx
  800fc9:	89 d3                	mov    %edx,%ebx
  800fcb:	89 d7                	mov    %edx,%edi
  800fcd:	89 d6                	mov    %edx,%esi
  800fcf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fd1:	8b 1c 24             	mov    (%esp),%ebx
  800fd4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fd8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fdc:	89 ec                	mov    %ebp,%esp
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	89 1c 24             	mov    %ebx,(%esp)
  800fe9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fed:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffc:	89 c3                	mov    %eax,%ebx
  800ffe:	89 c7                	mov    %eax,%edi
  801000:	89 c6                	mov    %eax,%esi
  801002:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801004:	8b 1c 24             	mov    (%esp),%ebx
  801007:	8b 74 24 04          	mov    0x4(%esp),%esi
  80100b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80100f:	89 ec                	mov    %ebp,%esp
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 38             	sub    $0x38,%esp
  801019:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80101c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80101f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801022:	be 00 00 00 00       	mov    $0x0,%esi
  801027:	b8 12 00 00 00       	mov    $0x12,%eax
  80102c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80102f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	7e 28                	jle    801066 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801042:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801049:	00 
  80104a:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  801051:	00 
  801052:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801059:	00 
  80105a:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  801061:	e8 06 f4 ff ff       	call   80046c <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  801066:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801069:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80106c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80106f:	89 ec                	mov    %ebp,%esp
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 0c             	sub    $0xc,%esp
  801079:	89 1c 24             	mov    %ebx,(%esp)
  80107c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801080:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801084:	bb 00 00 00 00       	mov    $0x0,%ebx
  801089:	b8 11 00 00 00       	mov    $0x11,%eax
  80108e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801091:	8b 55 08             	mov    0x8(%ebp),%edx
  801094:	89 df                	mov    %ebx,%edi
  801096:	89 de                	mov    %ebx,%esi
  801098:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80109a:	8b 1c 24             	mov    (%esp),%ebx
  80109d:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010a5:	89 ec                	mov    %ebp,%esp
  8010a7:	5d                   	pop    %ebp
  8010a8:	c3                   	ret    

008010a9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
  8010ac:	83 ec 0c             	sub    $0xc,%esp
  8010af:	89 1c 24             	mov    %ebx,(%esp)
  8010b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010b6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010bf:	b8 10 00 00 00       	mov    $0x10,%eax
  8010c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c7:	89 cb                	mov    %ecx,%ebx
  8010c9:	89 cf                	mov    %ecx,%edi
  8010cb:	89 ce                	mov    %ecx,%esi
  8010cd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  8010cf:	8b 1c 24             	mov    (%esp),%ebx
  8010d2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010d6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010da:	89 ec                	mov    %ebp,%esp
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 38             	sub    $0x38,%esp
  8010e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 df                	mov    %ebx,%edi
  8010ff:	89 de                	mov    %ebx,%esi
  801101:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801103:	85 c0                	test   %eax,%eax
  801105:	7e 28                	jle    80112f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801107:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801112:	00 
  801113:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  80111a:	00 
  80111b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801122:	00 
  801123:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  80112a:	e8 3d f3 ff ff       	call   80046c <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80112f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801132:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801135:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801138:	89 ec                	mov    %ebp,%esp
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 0c             	sub    $0xc,%esp
  801142:	89 1c 24             	mov    %ebx,(%esp)
  801145:	89 74 24 04          	mov    %esi,0x4(%esp)
  801149:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114d:	ba 00 00 00 00       	mov    $0x0,%edx
  801152:	b8 0e 00 00 00       	mov    $0xe,%eax
  801157:	89 d1                	mov    %edx,%ecx
  801159:	89 d3                	mov    %edx,%ebx
  80115b:	89 d7                	mov    %edx,%edi
  80115d:	89 d6                	mov    %edx,%esi
  80115f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  801161:	8b 1c 24             	mov    (%esp),%ebx
  801164:	8b 74 24 04          	mov    0x4(%esp),%esi
  801168:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80116c:	89 ec                	mov    %ebp,%esp
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 38             	sub    $0x38,%esp
  801176:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801179:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80117c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801184:	b8 0d 00 00 00       	mov    $0xd,%eax
  801189:	8b 55 08             	mov    0x8(%ebp),%edx
  80118c:	89 cb                	mov    %ecx,%ebx
  80118e:	89 cf                	mov    %ecx,%edi
  801190:	89 ce                	mov    %ecx,%esi
  801192:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801194:	85 c0                	test   %eax,%eax
  801196:	7e 28                	jle    8011c0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801198:	89 44 24 10          	mov    %eax,0x10(%esp)
  80119c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8011a3:	00 
  8011a4:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  8011ab:	00 
  8011ac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b3:	00 
  8011b4:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  8011bb:	e8 ac f2 ff ff       	call   80046c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011c9:	89 ec                	mov    %ebp,%esp
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    

008011cd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 0c             	sub    $0xc,%esp
  8011d3:	89 1c 24             	mov    %ebx,(%esp)
  8011d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011da:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011de:	be 00 00 00 00       	mov    $0x0,%esi
  8011e3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011e8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011f6:	8b 1c 24             	mov    (%esp),%ebx
  8011f9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011fd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801201:	89 ec                	mov    %ebp,%esp
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    

00801205 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 38             	sub    $0x38,%esp
  80120b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80120e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801211:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801214:	bb 00 00 00 00       	mov    $0x0,%ebx
  801219:	b8 0a 00 00 00       	mov    $0xa,%eax
  80121e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801221:	8b 55 08             	mov    0x8(%ebp),%edx
  801224:	89 df                	mov    %ebx,%edi
  801226:	89 de                	mov    %ebx,%esi
  801228:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80122a:	85 c0                	test   %eax,%eax
  80122c:	7e 28                	jle    801256 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80122e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801232:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801239:	00 
  80123a:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  801241:	00 
  801242:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801249:	00 
  80124a:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  801251:	e8 16 f2 ff ff       	call   80046c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801256:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801259:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80125c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80125f:	89 ec                	mov    %ebp,%esp
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 38             	sub    $0x38,%esp
  801269:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80126c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80126f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801272:	bb 00 00 00 00       	mov    $0x0,%ebx
  801277:	b8 09 00 00 00       	mov    $0x9,%eax
  80127c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127f:	8b 55 08             	mov    0x8(%ebp),%edx
  801282:	89 df                	mov    %ebx,%edi
  801284:	89 de                	mov    %ebx,%esi
  801286:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801288:	85 c0                	test   %eax,%eax
  80128a:	7e 28                	jle    8012b4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80128c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801290:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801297:	00 
  801298:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  80129f:	00 
  8012a0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012a7:	00 
  8012a8:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  8012af:	e8 b8 f1 ff ff       	call   80046c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012b4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012b7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012ba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012bd:	89 ec                	mov    %ebp,%esp
  8012bf:	5d                   	pop    %ebp
  8012c0:	c3                   	ret    

008012c1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 38             	sub    $0x38,%esp
  8012c7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012ca:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012cd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d5:	b8 08 00 00 00       	mov    $0x8,%eax
  8012da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	89 df                	mov    %ebx,%edi
  8012e2:	89 de                	mov    %ebx,%esi
  8012e4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	7e 28                	jle    801312 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ee:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8012f5:	00 
  8012f6:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  8012fd:	00 
  8012fe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801305:	00 
  801306:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  80130d:	e8 5a f1 ff ff       	call   80046c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801312:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801315:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801318:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80131b:	89 ec                	mov    %ebp,%esp
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	83 ec 38             	sub    $0x38,%esp
  801325:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801328:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80132b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801333:	b8 06 00 00 00       	mov    $0x6,%eax
  801338:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133b:	8b 55 08             	mov    0x8(%ebp),%edx
  80133e:	89 df                	mov    %ebx,%edi
  801340:	89 de                	mov    %ebx,%esi
  801342:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801344:	85 c0                	test   %eax,%eax
  801346:	7e 28                	jle    801370 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801348:	89 44 24 10          	mov    %eax,0x10(%esp)
  80134c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801353:	00 
  801354:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  80135b:	00 
  80135c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801363:	00 
  801364:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  80136b:	e8 fc f0 ff ff       	call   80046c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801370:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801373:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801376:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801379:	89 ec                	mov    %ebp,%esp
  80137b:	5d                   	pop    %ebp
  80137c:	c3                   	ret    

0080137d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 38             	sub    $0x38,%esp
  801383:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801386:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801389:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80138c:	b8 05 00 00 00       	mov    $0x5,%eax
  801391:	8b 75 18             	mov    0x18(%ebp),%esi
  801394:	8b 7d 14             	mov    0x14(%ebp),%edi
  801397:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80139a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139d:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	7e 28                	jle    8013ce <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013aa:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8013b1:	00 
  8013b2:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  8013b9:	00 
  8013ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013c1:	00 
  8013c2:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  8013c9:	e8 9e f0 ff ff       	call   80046c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8013ce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013d1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013d7:	89 ec                	mov    %ebp,%esp
  8013d9:	5d                   	pop    %ebp
  8013da:	c3                   	ret    

008013db <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 38             	sub    $0x38,%esp
  8013e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ea:	be 00 00 00 00       	mov    $0x0,%esi
  8013ef:	b8 04 00 00 00       	mov    $0x4,%eax
  8013f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fd:	89 f7                	mov    %esi,%edi
  8013ff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801401:	85 c0                	test   %eax,%eax
  801403:	7e 28                	jle    80142d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801405:	89 44 24 10          	mov    %eax,0x10(%esp)
  801409:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801410:	00 
  801411:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  801418:	00 
  801419:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801420:	00 
  801421:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  801428:	e8 3f f0 ff ff       	call   80046c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80142d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801430:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801433:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801436:	89 ec                	mov    %ebp,%esp
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    

0080143a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 0c             	sub    $0xc,%esp
  801440:	89 1c 24             	mov    %ebx,(%esp)
  801443:	89 74 24 04          	mov    %esi,0x4(%esp)
  801447:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144b:	ba 00 00 00 00       	mov    $0x0,%edx
  801450:	b8 0b 00 00 00       	mov    $0xb,%eax
  801455:	89 d1                	mov    %edx,%ecx
  801457:	89 d3                	mov    %edx,%ebx
  801459:	89 d7                	mov    %edx,%edi
  80145b:	89 d6                	mov    %edx,%esi
  80145d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80145f:	8b 1c 24             	mov    (%esp),%ebx
  801462:	8b 74 24 04          	mov    0x4(%esp),%esi
  801466:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80146a:	89 ec                	mov    %ebp,%esp
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 0c             	sub    $0xc,%esp
  801474:	89 1c 24             	mov    %ebx,(%esp)
  801477:	89 74 24 04          	mov    %esi,0x4(%esp)
  80147b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80147f:	ba 00 00 00 00       	mov    $0x0,%edx
  801484:	b8 02 00 00 00       	mov    $0x2,%eax
  801489:	89 d1                	mov    %edx,%ecx
  80148b:	89 d3                	mov    %edx,%ebx
  80148d:	89 d7                	mov    %edx,%edi
  80148f:	89 d6                	mov    %edx,%esi
  801491:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801493:	8b 1c 24             	mov    (%esp),%ebx
  801496:	8b 74 24 04          	mov    0x4(%esp),%esi
  80149a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80149e:	89 ec                	mov    %ebp,%esp
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 38             	sub    $0x38,%esp
  8014a8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014ab:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014ae:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014b6:	b8 03 00 00 00       	mov    $0x3,%eax
  8014bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014be:	89 cb                	mov    %ecx,%ebx
  8014c0:	89 cf                	mov    %ecx,%edi
  8014c2:	89 ce                	mov    %ecx,%esi
  8014c4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	7e 28                	jle    8014f2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ce:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8014d5:	00 
  8014d6:	c7 44 24 08 bf 35 80 	movl   $0x8035bf,0x8(%esp)
  8014dd:	00 
  8014de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014e5:	00 
  8014e6:	c7 04 24 dc 35 80 00 	movl   $0x8035dc,(%esp)
  8014ed:	e8 7a ef ff ff       	call   80046c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014fb:	89 ec                	mov    %ebp,%esp
  8014fd:	5d                   	pop    %ebp
  8014fe:	c3                   	ret    
	...

00801500 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801506:	c7 44 24 08 ea 35 80 	movl   $0x8035ea,0x8(%esp)
  80150d:	00 
  80150e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801515:	00 
  801516:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  80151d:	e8 4a ef ff ff       	call   80046c <_panic>

00801522 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	53                   	push   %ebx
  801526:	83 ec 24             	sub    $0x24,%esp
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80152c:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80152e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801532:	75 1c                	jne    801550 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801534:	c7 44 24 08 0c 36 80 	movl   $0x80360c,0x8(%esp)
  80153b:	00 
  80153c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801543:	00 
  801544:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  80154b:	e8 1c ef ff ff       	call   80046c <_panic>
	}
	pte = vpt[VPN(addr)];
  801550:	89 d8                	mov    %ebx,%eax
  801552:	c1 e8 0c             	shr    $0xc,%eax
  801555:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  80155c:	f6 c4 08             	test   $0x8,%ah
  80155f:	75 1c                	jne    80157d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801561:	c7 44 24 08 50 36 80 	movl   $0x803650,0x8(%esp)
  801568:	00 
  801569:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801570:	00 
  801571:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  801578:	e8 ef ee ff ff       	call   80046c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80157d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801584:	00 
  801585:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80158c:	00 
  80158d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801594:	e8 42 fe ff ff       	call   8013db <sys_page_alloc>
  801599:	85 c0                	test   %eax,%eax
  80159b:	79 20                	jns    8015bd <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  80159d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015a1:	c7 44 24 08 9c 36 80 	movl   $0x80369c,0x8(%esp)
  8015a8:	00 
  8015a9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8015b0:	00 
  8015b1:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  8015b8:	e8 af ee ff ff       	call   80046c <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  8015bd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8015c3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8015ca:	00 
  8015cb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015cf:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8015d6:	e8 ca f7 ff ff       	call   800da5 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  8015db:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8015e2:	00 
  8015e3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015ee:	00 
  8015ef:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015f6:	00 
  8015f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015fe:	e8 7a fd ff ff       	call   80137d <sys_page_map>
  801603:	85 c0                	test   %eax,%eax
  801605:	79 20                	jns    801627 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  801607:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80160b:	c7 44 24 08 d8 36 80 	movl   $0x8036d8,0x8(%esp)
  801612:	00 
  801613:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80161a:	00 
  80161b:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  801622:	e8 45 ee ff ff       	call   80046c <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801627:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80162e:	00 
  80162f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801636:	e8 e4 fc ff ff       	call   80131f <sys_page_unmap>
  80163b:	85 c0                	test   %eax,%eax
  80163d:	79 20                	jns    80165f <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80163f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801643:	c7 44 24 08 10 37 80 	movl   $0x803710,0x8(%esp)
  80164a:	00 
  80164b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801652:	00 
  801653:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  80165a:	e8 0d ee ff ff       	call   80046c <_panic>
	// panic("pgfault not implemented");
}
  80165f:	83 c4 24             	add    $0x24,%esp
  801662:	5b                   	pop    %ebx
  801663:	5d                   	pop    %ebp
  801664:	c3                   	ret    

00801665 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	57                   	push   %edi
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80166e:	c7 04 24 22 15 80 00 	movl   $0x801522,(%esp)
  801675:	e8 a2 15 00 00       	call   802c1c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80167a:	ba 07 00 00 00       	mov    $0x7,%edx
  80167f:	89 d0                	mov    %edx,%eax
  801681:	cd 30                	int    $0x30
  801683:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  801686:	85 c0                	test   %eax,%eax
  801688:	0f 88 21 02 00 00    	js     8018af <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  80168e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  801695:	85 c0                	test   %eax,%eax
  801697:	75 1c                	jne    8016b5 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  801699:	e8 d0 fd ff ff       	call   80146e <sys_getenvid>
  80169e:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016a3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8016a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016ab:	a3 80 74 80 00       	mov    %eax,0x807480
		return 0;
  8016b0:	e9 fa 01 00 00       	jmp    8018af <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  8016b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016b8:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8016bf:	a8 01                	test   $0x1,%al
  8016c1:	0f 84 16 01 00 00    	je     8017dd <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  8016c7:	89 d3                	mov    %edx,%ebx
  8016c9:	c1 e3 0a             	shl    $0xa,%ebx
  8016cc:	89 d7                	mov    %edx,%edi
  8016ce:	c1 e7 16             	shl    $0x16,%edi
  8016d1:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  8016d6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8016dd:	a8 01                	test   $0x1,%al
  8016df:	0f 84 e0 00 00 00    	je     8017c5 <fork+0x160>
  8016e5:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8016eb:	0f 87 d4 00 00 00    	ja     8017c5 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  8016f1:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  8016f8:	89 d0                	mov    %edx,%eax
  8016fa:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  8016ff:	f6 c2 01             	test   $0x1,%dl
  801702:	75 1c                	jne    801720 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  801704:	c7 44 24 08 4c 37 80 	movl   $0x80374c,0x8(%esp)
  80170b:	00 
  80170c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801713:	00 
  801714:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  80171b:	e8 4c ed ff ff       	call   80046c <_panic>
	if ((perm & PTE_U) != PTE_U)
  801720:	a8 04                	test   $0x4,%al
  801722:	75 1c                	jne    801740 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801724:	c7 44 24 08 94 37 80 	movl   $0x803794,0x8(%esp)
  80172b:	00 
  80172c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801733:	00 
  801734:	c7 04 24 00 36 80 00 	movl   $0x803600,(%esp)
  80173b:	e8 2c ed ff ff       	call   80046c <_panic>
  801740:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801743:	f6 c4 04             	test   $0x4,%ah
  801746:	75 5b                	jne    8017a3 <fork+0x13e>
  801748:	a9 02 08 00 00       	test   $0x802,%eax
  80174d:	74 54                	je     8017a3 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80174f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801752:	80 cc 08             	or     $0x8,%ah
  801755:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801758:	89 44 24 10          	mov    %eax,0x10(%esp)
  80175c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801760:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801763:	89 54 24 08          	mov    %edx,0x8(%esp)
  801767:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80176b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801772:	e8 06 fc ff ff       	call   80137d <sys_page_map>
  801777:	85 c0                	test   %eax,%eax
  801779:	78 4a                	js     8017c5 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80177b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80177e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801782:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801785:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801789:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801790:	00 
  801791:	89 54 24 04          	mov    %edx,0x4(%esp)
  801795:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80179c:	e8 dc fb ff ff       	call   80137d <sys_page_map>
  8017a1:	eb 22                	jmp    8017c5 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8017a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c0:	e8 b8 fb ff ff       	call   80137d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  8017c5:	83 c6 01             	add    $0x1,%esi
  8017c8:	83 c3 01             	add    $0x1,%ebx
  8017cb:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8017d1:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  8017d7:	0f 85 f9 fe ff ff    	jne    8016d6 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  8017dd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  8017e1:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  8017e8:	0f 85 c7 fe ff ff    	jne    8016b5 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8017ee:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8017f5:	00 
  8017f6:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8017fd:	ee 
  8017fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801801:	89 04 24             	mov    %eax,(%esp)
  801804:	e8 d2 fb ff ff       	call   8013db <sys_page_alloc>
  801809:	85 c0                	test   %eax,%eax
  80180b:	79 08                	jns    801815 <fork+0x1b0>
  80180d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801810:	e9 9a 00 00 00       	jmp    8018af <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801815:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80181c:	00 
  80181d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801824:	00 
  801825:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80182c:	00 
  80182d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801834:	ee 
  801835:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801838:	89 14 24             	mov    %edx,(%esp)
  80183b:	e8 3d fb ff ff       	call   80137d <sys_page_map>
  801840:	85 c0                	test   %eax,%eax
  801842:	79 05                	jns    801849 <fork+0x1e4>
  801844:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801847:	eb 66                	jmp    8018af <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801849:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801850:	00 
  801851:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801858:	ee 
  801859:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801860:	e8 40 f5 ff ff       	call   800da5 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801865:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80186c:	00 
  80186d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801874:	e8 a6 fa ff ff       	call   80131f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801879:	c7 44 24 04 b0 2c 80 	movl   $0x802cb0,0x4(%esp)
  801880:	00 
  801881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801884:	89 04 24             	mov    %eax,(%esp)
  801887:	e8 79 f9 ff ff       	call   801205 <sys_env_set_pgfault_upcall>
  80188c:	85 c0                	test   %eax,%eax
  80188e:	79 05                	jns    801895 <fork+0x230>
  801890:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801893:	eb 1a                	jmp    8018af <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801895:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80189c:	00 
  80189d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018a0:	89 14 24             	mov    %edx,(%esp)
  8018a3:	e8 19 fa ff ff       	call   8012c1 <sys_env_set_status>
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	79 03                	jns    8018af <fork+0x24a>
  8018ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  8018af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b2:	83 c4 3c             	add    $0x3c,%esp
  8018b5:	5b                   	pop    %ebx
  8018b6:	5e                   	pop    %esi
  8018b7:	5f                   	pop    %edi
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    
  8018ba:	00 00                	add    %al,(%eax)
  8018bc:	00 00                	add    %al,(%eax)
	...

008018c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8018cb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8018ce:	5d                   	pop    %ebp
  8018cf:	c3                   	ret    

008018d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	89 04 24             	mov    %eax,(%esp)
  8018dc:	e8 df ff ff ff       	call   8018c0 <fd2num>
  8018e1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8018e6:	c1 e0 0c             	shl    $0xc,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	57                   	push   %edi
  8018ef:	56                   	push   %esi
  8018f0:	53                   	push   %ebx
  8018f1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8018f4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8018f9:	a8 01                	test   $0x1,%al
  8018fb:	74 36                	je     801933 <fd_alloc+0x48>
  8018fd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801902:	a8 01                	test   $0x1,%al
  801904:	74 2d                	je     801933 <fd_alloc+0x48>
  801906:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80190b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801910:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801915:	89 c3                	mov    %eax,%ebx
  801917:	89 c2                	mov    %eax,%edx
  801919:	c1 ea 16             	shr    $0x16,%edx
  80191c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80191f:	f6 c2 01             	test   $0x1,%dl
  801922:	74 14                	je     801938 <fd_alloc+0x4d>
  801924:	89 c2                	mov    %eax,%edx
  801926:	c1 ea 0c             	shr    $0xc,%edx
  801929:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80192c:	f6 c2 01             	test   $0x1,%dl
  80192f:	75 10                	jne    801941 <fd_alloc+0x56>
  801931:	eb 05                	jmp    801938 <fd_alloc+0x4d>
  801933:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801938:	89 1f                	mov    %ebx,(%edi)
  80193a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80193f:	eb 17                	jmp    801958 <fd_alloc+0x6d>
  801941:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801946:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80194b:	75 c8                	jne    801915 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80194d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801953:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801958:	5b                   	pop    %ebx
  801959:	5e                   	pop    %esi
  80195a:	5f                   	pop    %edi
  80195b:	5d                   	pop    %ebp
  80195c:	c3                   	ret    

0080195d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	83 f8 1f             	cmp    $0x1f,%eax
  801966:	77 36                	ja     80199e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801968:	05 00 00 0d 00       	add    $0xd0000,%eax
  80196d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801970:	89 c2                	mov    %eax,%edx
  801972:	c1 ea 16             	shr    $0x16,%edx
  801975:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80197c:	f6 c2 01             	test   $0x1,%dl
  80197f:	74 1d                	je     80199e <fd_lookup+0x41>
  801981:	89 c2                	mov    %eax,%edx
  801983:	c1 ea 0c             	shr    $0xc,%edx
  801986:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80198d:	f6 c2 01             	test   $0x1,%dl
  801990:	74 0c                	je     80199e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	89 02                	mov    %eax,(%edx)
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80199c:	eb 05                	jmp    8019a3 <fd_lookup+0x46>
  80199e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    

008019a5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ab:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	89 04 24             	mov    %eax,(%esp)
  8019b8:	e8 a0 ff ff ff       	call   80195d <fd_lookup>
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	78 0e                	js     8019cf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c7:	89 50 04             	mov    %edx,0x4(%eax)
  8019ca:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	56                   	push   %esi
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 10             	sub    $0x10,%esp
  8019d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8019df:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8019e9:	be 58 38 80 00       	mov    $0x803858,%esi
		if (devtab[i]->dev_id == dev_id) {
  8019ee:	39 08                	cmp    %ecx,(%eax)
  8019f0:	75 10                	jne    801a02 <dev_lookup+0x31>
  8019f2:	eb 04                	jmp    8019f8 <dev_lookup+0x27>
  8019f4:	39 08                	cmp    %ecx,(%eax)
  8019f6:	75 0a                	jne    801a02 <dev_lookup+0x31>
			*dev = devtab[i];
  8019f8:	89 03                	mov    %eax,(%ebx)
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8019ff:	90                   	nop
  801a00:	eb 31                	jmp    801a33 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801a02:	83 c2 01             	add    $0x1,%edx
  801a05:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	75 e8                	jne    8019f4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801a0c:	a1 80 74 80 00       	mov    0x807480,%eax
  801a11:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a14:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1c:	c7 04 24 dc 37 80 00 	movl   $0x8037dc,(%esp)
  801a23:	e8 09 eb ff ff       	call   800531 <cprintf>
	*dev = 0;
  801a28:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	5b                   	pop    %ebx
  801a37:	5e                   	pop    %esi
  801a38:	5d                   	pop    %ebp
  801a39:	c3                   	ret    

00801a3a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	53                   	push   %ebx
  801a3e:	83 ec 24             	sub    $0x24,%esp
  801a41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	89 04 24             	mov    %eax,(%esp)
  801a51:	e8 07 ff ff ff       	call   80195d <fd_lookup>
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 53                	js     801aad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a64:	8b 00                	mov    (%eax),%eax
  801a66:	89 04 24             	mov    %eax,(%esp)
  801a69:	e8 63 ff ff ff       	call   8019d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 3b                	js     801aad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801a72:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801a7e:	74 2d                	je     801aad <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a80:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a83:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a8a:	00 00 00 
	stat->st_isdir = 0;
  801a8d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a94:	00 00 00 
	stat->st_dev = dev;
  801a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801aa0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa7:	89 14 24             	mov    %edx,(%esp)
  801aaa:	ff 50 14             	call   *0x14(%eax)
}
  801aad:	83 c4 24             	add    $0x24,%esp
  801ab0:	5b                   	pop    %ebx
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 24             	sub    $0x24,%esp
  801aba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801abd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac4:	89 1c 24             	mov    %ebx,(%esp)
  801ac7:	e8 91 fe ff ff       	call   80195d <fd_lookup>
  801acc:	85 c0                	test   %eax,%eax
  801ace:	78 5f                	js     801b2f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ad0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ada:	8b 00                	mov    (%eax),%eax
  801adc:	89 04 24             	mov    %eax,(%esp)
  801adf:	e8 ed fe ff ff       	call   8019d1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	78 47                	js     801b2f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ae8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aeb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801aef:	75 23                	jne    801b14 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801af1:	a1 80 74 80 00       	mov    0x807480,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801af6:	8b 40 4c             	mov    0x4c(%eax),%eax
  801af9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b01:	c7 04 24 fc 37 80 00 	movl   $0x8037fc,(%esp)
  801b08:	e8 24 ea ff ff       	call   800531 <cprintf>
  801b0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801b12:	eb 1b                	jmp    801b2f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b17:	8b 48 18             	mov    0x18(%eax),%ecx
  801b1a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b1f:	85 c9                	test   %ecx,%ecx
  801b21:	74 0c                	je     801b2f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2a:	89 14 24             	mov    %edx,(%esp)
  801b2d:	ff d1                	call   *%ecx
}
  801b2f:	83 c4 24             	add    $0x24,%esp
  801b32:	5b                   	pop    %ebx
  801b33:	5d                   	pop    %ebp
  801b34:	c3                   	ret    

00801b35 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	53                   	push   %ebx
  801b39:	83 ec 24             	sub    $0x24,%esp
  801b3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b46:	89 1c 24             	mov    %ebx,(%esp)
  801b49:	e8 0f fe ff ff       	call   80195d <fd_lookup>
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	78 66                	js     801bb8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b5c:	8b 00                	mov    (%eax),%eax
  801b5e:	89 04 24             	mov    %eax,(%esp)
  801b61:	e8 6b fe ff ff       	call   8019d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 4e                	js     801bb8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b6d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801b71:	75 23                	jne    801b96 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801b73:	a1 80 74 80 00       	mov    0x807480,%eax
  801b78:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b83:	c7 04 24 1d 38 80 00 	movl   $0x80381d,(%esp)
  801b8a:	e8 a2 e9 ff ff       	call   800531 <cprintf>
  801b8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801b94:	eb 22                	jmp    801bb8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b99:	8b 48 0c             	mov    0xc(%eax),%ecx
  801b9c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba1:	85 c9                	test   %ecx,%ecx
  801ba3:	74 13                	je     801bb8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb3:	89 14 24             	mov    %edx,(%esp)
  801bb6:	ff d1                	call   *%ecx
}
  801bb8:	83 c4 24             	add    $0x24,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5d                   	pop    %ebp
  801bbd:	c3                   	ret    

00801bbe <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	53                   	push   %ebx
  801bc2:	83 ec 24             	sub    $0x24,%esp
  801bc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bc8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcf:	89 1c 24             	mov    %ebx,(%esp)
  801bd2:	e8 86 fd ff ff       	call   80195d <fd_lookup>
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	78 6b                	js     801c46 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be5:	8b 00                	mov    (%eax),%eax
  801be7:	89 04 24             	mov    %eax,(%esp)
  801bea:	e8 e2 fd ff ff       	call   8019d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 53                	js     801c46 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801bf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bf6:	8b 42 08             	mov    0x8(%edx),%eax
  801bf9:	83 e0 03             	and    $0x3,%eax
  801bfc:	83 f8 01             	cmp    $0x1,%eax
  801bff:	75 23                	jne    801c24 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801c01:	a1 80 74 80 00       	mov    0x807480,%eax
  801c06:	8b 40 4c             	mov    0x4c(%eax),%eax
  801c09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c11:	c7 04 24 3a 38 80 00 	movl   $0x80383a,(%esp)
  801c18:	e8 14 e9 ff ff       	call   800531 <cprintf>
  801c1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801c22:	eb 22                	jmp    801c46 <read+0x88>
	}
	if (!dev->dev_read)
  801c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c27:	8b 48 08             	mov    0x8(%eax),%ecx
  801c2a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c2f:	85 c9                	test   %ecx,%ecx
  801c31:	74 13                	je     801c46 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c33:	8b 45 10             	mov    0x10(%ebp),%eax
  801c36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c41:	89 14 24             	mov    %edx,(%esp)
  801c44:	ff d1                	call   *%ecx
}
  801c46:	83 c4 24             	add    $0x24,%esp
  801c49:	5b                   	pop    %ebx
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	57                   	push   %edi
  801c50:	56                   	push   %esi
  801c51:	53                   	push   %ebx
  801c52:	83 ec 1c             	sub    $0x1c,%esp
  801c55:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c58:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c60:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	85 f6                	test   %esi,%esi
  801c6c:	74 29                	je     801c97 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c6e:	89 f0                	mov    %esi,%eax
  801c70:	29 d0                	sub    %edx,%eax
  801c72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c76:	03 55 0c             	add    0xc(%ebp),%edx
  801c79:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c7d:	89 3c 24             	mov    %edi,(%esp)
  801c80:	e8 39 ff ff ff       	call   801bbe <read>
		if (m < 0)
  801c85:	85 c0                	test   %eax,%eax
  801c87:	78 0e                	js     801c97 <readn+0x4b>
			return m;
		if (m == 0)
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	74 08                	je     801c95 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c8d:	01 c3                	add    %eax,%ebx
  801c8f:	89 da                	mov    %ebx,%edx
  801c91:	39 f3                	cmp    %esi,%ebx
  801c93:	72 d9                	jb     801c6e <readn+0x22>
  801c95:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801c97:	83 c4 1c             	add    $0x1c,%esp
  801c9a:	5b                   	pop    %ebx
  801c9b:	5e                   	pop    %esi
  801c9c:	5f                   	pop    %edi
  801c9d:	5d                   	pop    %ebp
  801c9e:	c3                   	ret    

00801c9f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 20             	sub    $0x20,%esp
  801ca7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801caa:	89 34 24             	mov    %esi,(%esp)
  801cad:	e8 0e fc ff ff       	call   8018c0 <fd2num>
  801cb2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801cb5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cb9:	89 04 24             	mov    %eax,(%esp)
  801cbc:	e8 9c fc ff ff       	call   80195d <fd_lookup>
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 05                	js     801ccc <fd_close+0x2d>
  801cc7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801cca:	74 0c                	je     801cd8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801ccc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801cd0:	19 c0                	sbb    %eax,%eax
  801cd2:	f7 d0                	not    %eax
  801cd4:	21 c3                	and    %eax,%ebx
  801cd6:	eb 3d                	jmp    801d15 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801cd8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdf:	8b 06                	mov    (%esi),%eax
  801ce1:	89 04 24             	mov    %eax,(%esp)
  801ce4:	e8 e8 fc ff ff       	call   8019d1 <dev_lookup>
  801ce9:	89 c3                	mov    %eax,%ebx
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	78 16                	js     801d05 <fd_close+0x66>
		if (dev->dev_close)
  801cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf2:	8b 40 10             	mov    0x10(%eax),%eax
  801cf5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	74 07                	je     801d05 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801cfe:	89 34 24             	mov    %esi,(%esp)
  801d01:	ff d0                	call   *%eax
  801d03:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d05:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d10:	e8 0a f6 ff ff       	call   80131f <sys_page_unmap>
	return r;
}
  801d15:	89 d8                	mov    %ebx,%eax
  801d17:	83 c4 20             	add    $0x20,%esp
  801d1a:	5b                   	pop    %ebx
  801d1b:	5e                   	pop    %esi
  801d1c:	5d                   	pop    %ebp
  801d1d:	c3                   	ret    

00801d1e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	89 04 24             	mov    %eax,(%esp)
  801d31:	e8 27 fc ff ff       	call   80195d <fd_lookup>
  801d36:	85 c0                	test   %eax,%eax
  801d38:	78 13                	js     801d4d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801d3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d41:	00 
  801d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d45:	89 04 24             	mov    %eax,(%esp)
  801d48:	e8 52 ff ff ff       	call   801c9f <fd_close>
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 18             	sub    $0x18,%esp
  801d55:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d58:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d62:	00 
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	89 04 24             	mov    %eax,(%esp)
  801d69:	e8 55 03 00 00       	call   8020c3 <open>
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 1b                	js     801d8f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7b:	89 1c 24             	mov    %ebx,(%esp)
  801d7e:	e8 b7 fc ff ff       	call   801a3a <fstat>
  801d83:	89 c6                	mov    %eax,%esi
	close(fd);
  801d85:	89 1c 24             	mov    %ebx,(%esp)
  801d88:	e8 91 ff ff ff       	call   801d1e <close>
  801d8d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801d8f:	89 d8                	mov    %ebx,%eax
  801d91:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d94:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d97:	89 ec                	mov    %ebp,%esp
  801d99:	5d                   	pop    %ebp
  801d9a:	c3                   	ret    

00801d9b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	53                   	push   %ebx
  801d9f:	83 ec 14             	sub    $0x14,%esp
  801da2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801da7:	89 1c 24             	mov    %ebx,(%esp)
  801daa:	e8 6f ff ff ff       	call   801d1e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801daf:	83 c3 01             	add    $0x1,%ebx
  801db2:	83 fb 20             	cmp    $0x20,%ebx
  801db5:	75 f0                	jne    801da7 <close_all+0xc>
		close(i);
}
  801db7:	83 c4 14             	add    $0x14,%esp
  801dba:	5b                   	pop    %ebx
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    

00801dbd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	83 ec 58             	sub    $0x58,%esp
  801dc3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801dc6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801dc9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801dcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801dcf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801dd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	89 04 24             	mov    %eax,(%esp)
  801ddc:	e8 7c fb ff ff       	call   80195d <fd_lookup>
  801de1:	89 c3                	mov    %eax,%ebx
  801de3:	85 c0                	test   %eax,%eax
  801de5:	0f 88 e0 00 00 00    	js     801ecb <dup+0x10e>
		return r;
	close(newfdnum);
  801deb:	89 3c 24             	mov    %edi,(%esp)
  801dee:	e8 2b ff ff ff       	call   801d1e <close>

	newfd = INDEX2FD(newfdnum);
  801df3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801df9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dff:	89 04 24             	mov    %eax,(%esp)
  801e02:	e8 c9 fa ff ff       	call   8018d0 <fd2data>
  801e07:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801e09:	89 34 24             	mov    %esi,(%esp)
  801e0c:	e8 bf fa ff ff       	call   8018d0 <fd2data>
  801e11:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801e14:	89 da                	mov    %ebx,%edx
  801e16:	89 d8                	mov    %ebx,%eax
  801e18:	c1 e8 16             	shr    $0x16,%eax
  801e1b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e22:	a8 01                	test   $0x1,%al
  801e24:	74 43                	je     801e69 <dup+0xac>
  801e26:	c1 ea 0c             	shr    $0xc,%edx
  801e29:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e30:	a8 01                	test   $0x1,%al
  801e32:	74 35                	je     801e69 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801e34:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e3b:	25 07 0e 00 00       	and    $0xe07,%eax
  801e40:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e52:	00 
  801e53:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e5e:	e8 1a f5 ff ff       	call   80137d <sys_page_map>
  801e63:	89 c3                	mov    %eax,%ebx
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 3f                	js     801ea8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e6c:	89 c2                	mov    %eax,%edx
  801e6e:	c1 ea 0c             	shr    $0xc,%edx
  801e71:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e78:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801e7e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801e82:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e8d:	00 
  801e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e99:	e8 df f4 ff ff       	call   80137d <sys_page_map>
  801e9e:	89 c3                	mov    %eax,%ebx
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	78 04                	js     801ea8 <dup+0xeb>
  801ea4:	89 fb                	mov    %edi,%ebx
  801ea6:	eb 23                	jmp    801ecb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ea8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb3:	e8 67 f4 ff ff       	call   80131f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801eb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ebb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ebf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec6:	e8 54 f4 ff ff       	call   80131f <sys_page_unmap>
	return r;
}
  801ecb:	89 d8                	mov    %ebx,%eax
  801ecd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ed0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ed3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ed6:	89 ec                	mov    %ebp,%esp
  801ed8:	5d                   	pop    %ebp
  801ed9:	c3                   	ret    
	...

00801edc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 14             	sub    $0x14,%esp
  801ee3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ee5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801eeb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ef2:	00 
  801ef3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801efa:	00 
  801efb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eff:	89 14 24             	mov    %edx,(%esp)
  801f02:	e8 d9 0d 00 00       	call   802ce0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f0e:	00 
  801f0f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1a:	e8 27 0e 00 00       	call   802d46 <ipc_recv>
}
  801f1f:	83 c4 14             	add    $0x14,%esp
  801f22:	5b                   	pop    %ebx
  801f23:	5d                   	pop    %ebp
  801f24:	c3                   	ret    

00801f25 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f31:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f39:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f43:	b8 02 00 00 00       	mov    $0x2,%eax
  801f48:	e8 8f ff ff ff       	call   801edc <fsipc>
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801f60:	ba 00 00 00 00       	mov    $0x0,%edx
  801f65:	b8 06 00 00 00       	mov    $0x6,%eax
  801f6a:	e8 6d ff ff ff       	call   801edc <fsipc>
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801f77:	ba 00 00 00 00       	mov    $0x0,%edx
  801f7c:	b8 08 00 00 00       	mov    $0x8,%eax
  801f81:	e8 56 ff ff ff       	call   801edc <fsipc>
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	53                   	push   %ebx
  801f8c:	83 ec 14             	sub    $0x14,%esp
  801f8f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	8b 40 0c             	mov    0xc(%eax),%eax
  801f98:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa2:	b8 05 00 00 00       	mov    $0x5,%eax
  801fa7:	e8 30 ff ff ff       	call   801edc <fsipc>
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 2b                	js     801fdb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fb0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801fb7:	00 
  801fb8:	89 1c 24             	mov    %ebx,(%esp)
  801fbb:	e8 2a ec ff ff       	call   800bea <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801fc0:	a1 80 40 80 00       	mov    0x804080,%eax
  801fc5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801fcb:	a1 84 40 80 00       	mov    0x804084,%eax
  801fd0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801fdb:	83 c4 14             	add    $0x14,%esp
  801fde:	5b                   	pop    %ebx
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    

00801fe1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 18             	sub    $0x18,%esp
  801fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fea:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801fef:	76 05                	jbe    801ff6 <devfile_write+0x15>
  801ff1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff9:	8b 52 0c             	mov    0xc(%edx),%edx
  801ffc:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  802002:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  802007:	89 44 24 08          	mov    %eax,0x8(%esp)
  80200b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802012:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  802019:	e8 87 ed ff ff       	call   800da5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80201e:	ba 00 00 00 00       	mov    $0x0,%edx
  802023:	b8 04 00 00 00       	mov    $0x4,%eax
  802028:	e8 af fe ff ff       	call   801edc <fsipc>
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	53                   	push   %ebx
  802033:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8b 40 0c             	mov    0xc(%eax),%eax
  80203c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  802041:	8b 45 10             	mov    0x10(%ebp),%eax
  802044:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  802049:	ba 00 40 80 00       	mov    $0x804000,%edx
  80204e:	b8 03 00 00 00       	mov    $0x3,%eax
  802053:	e8 84 fe ff ff       	call   801edc <fsipc>
  802058:	89 c3                	mov    %eax,%ebx
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 17                	js     802075 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80205e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802062:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802069:	00 
  80206a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206d:	89 04 24             	mov    %eax,(%esp)
  802070:	e8 30 ed ff ff       	call   800da5 <memmove>
	return r;
}
  802075:	89 d8                	mov    %ebx,%eax
  802077:	83 c4 14             	add    $0x14,%esp
  80207a:	5b                   	pop    %ebx
  80207b:	5d                   	pop    %ebp
  80207c:	c3                   	ret    

0080207d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	53                   	push   %ebx
  802081:	83 ec 14             	sub    $0x14,%esp
  802084:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  802087:	89 1c 24             	mov    %ebx,(%esp)
  80208a:	e8 11 eb ff ff       	call   800ba0 <strlen>
  80208f:	89 c2                	mov    %eax,%edx
  802091:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802096:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  80209c:	7f 1f                	jg     8020bd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  80209e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020a2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8020a9:	e8 3c eb ff ff       	call   800bea <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8020ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8020b8:	e8 1f fe ff ff       	call   801edc <fsipc>
}
  8020bd:	83 c4 14             	add    $0x14,%esp
  8020c0:	5b                   	pop    %ebx
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    

008020c3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 28             	sub    $0x28,%esp
  8020c9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020cc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8020cf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  8020d2:	89 34 24             	mov    %esi,(%esp)
  8020d5:	e8 c6 ea ff ff       	call   800ba0 <strlen>
  8020da:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8020df:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020e4:	7f 5e                	jg     802144 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  8020e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e9:	89 04 24             	mov    %eax,(%esp)
  8020ec:	e8 fa f7 ff ff       	call   8018eb <fd_alloc>
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 4d                	js     802144 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  8020f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020fb:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802102:	e8 e3 ea ff ff       	call   800bea <strcpy>
	fsipcbuf.open.req_omode = mode;	
  802107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80210f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802112:	b8 01 00 00 00       	mov    $0x1,%eax
  802117:	e8 c0 fd ff ff       	call   801edc <fsipc>
  80211c:	89 c3                	mov    %eax,%ebx
  80211e:	85 c0                	test   %eax,%eax
  802120:	79 15                	jns    802137 <open+0x74>
	{
		fd_close(fd,0);
  802122:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802129:	00 
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	89 04 24             	mov    %eax,(%esp)
  802130:	e8 6a fb ff ff       	call   801c9f <fd_close>
		return r; 
  802135:	eb 0d                	jmp    802144 <open+0x81>
	}
	return fd2num(fd);
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	89 04 24             	mov    %eax,(%esp)
  80213d:	e8 7e f7 ff ff       	call   8018c0 <fd2num>
  802142:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  802144:	89 d8                	mov    %ebx,%eax
  802146:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802149:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80214c:	89 ec                	mov    %ebp,%esp
  80214e:	5d                   	pop    %ebp
  80214f:	c3                   	ret    

00802150 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802156:	c7 44 24 04 6c 38 80 	movl   $0x80386c,0x4(%esp)
  80215d:	00 
  80215e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802161:	89 04 24             	mov    %eax,(%esp)
  802164:	e8 81 ea ff ff       	call   800bea <strcpy>
	return 0;
}
  802169:	b8 00 00 00 00       	mov    $0x0,%eax
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	8b 40 0c             	mov    0xc(%eax),%eax
  80217c:	89 04 24             	mov    %eax,(%esp)
  80217f:	e8 9e 02 00 00       	call   802422 <nsipc_close>
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80218c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802193:	00 
  802194:	8b 45 10             	mov    0x10(%ebp),%eax
  802197:	89 44 24 08          	mov    %eax,0x8(%esp)
  80219b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a8:	89 04 24             	mov    %eax,(%esp)
  8021ab:	e8 ae 02 00 00       	call   80245e <nsipc_send>
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021bf:	00 
  8021c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d4:	89 04 24             	mov    %eax,(%esp)
  8021d7:	e8 f5 02 00 00       	call   8024d1 <nsipc_recv>
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	56                   	push   %esi
  8021e2:	53                   	push   %ebx
  8021e3:	83 ec 20             	sub    $0x20,%esp
  8021e6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021eb:	89 04 24             	mov    %eax,(%esp)
  8021ee:	e8 f8 f6 ff ff       	call   8018eb <fd_alloc>
  8021f3:	89 c3                	mov    %eax,%ebx
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	78 21                	js     80221a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8021f9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802200:	00 
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	89 44 24 04          	mov    %eax,0x4(%esp)
  802208:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220f:	e8 c7 f1 ff ff       	call   8013db <sys_page_alloc>
  802214:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802216:	85 c0                	test   %eax,%eax
  802218:	79 0a                	jns    802224 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80221a:	89 34 24             	mov    %esi,(%esp)
  80221d:	e8 00 02 00 00       	call   802422 <nsipc_close>
		return r;
  802222:	eb 28                	jmp    80224c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802224:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	89 04 24             	mov    %eax,(%esp)
  802245:	e8 76 f6 ff ff       	call   8018c0 <fd2num>
  80224a:	89 c3                	mov    %eax,%ebx
}
  80224c:	89 d8                	mov    %ebx,%eax
  80224e:	83 c4 20             	add    $0x20,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80225b:	8b 45 10             	mov    0x10(%ebp),%eax
  80225e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802262:	8b 45 0c             	mov    0xc(%ebp),%eax
  802265:	89 44 24 04          	mov    %eax,0x4(%esp)
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	89 04 24             	mov    %eax,(%esp)
  80226f:	e8 62 01 00 00       	call   8023d6 <nsipc_socket>
  802274:	85 c0                	test   %eax,%eax
  802276:	78 05                	js     80227d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802278:	e8 61 ff ff ff       	call   8021de <alloc_sockfd>
}
  80227d:	c9                   	leave  
  80227e:	66 90                	xchg   %ax,%ax
  802280:	c3                   	ret    

00802281 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802287:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80228a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80228e:	89 04 24             	mov    %eax,(%esp)
  802291:	e8 c7 f6 ff ff       	call   80195d <fd_lookup>
  802296:	85 c0                	test   %eax,%eax
  802298:	78 15                	js     8022af <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229d:	8b 0a                	mov    (%edx),%ecx
  80229f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022a4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8022aa:	75 03                	jne    8022af <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8022ac:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	e8 c2 ff ff ff       	call   802281 <fd2sockid>
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	78 0f                	js     8022d2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8022c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ca:	89 04 24             	mov    %eax,(%esp)
  8022cd:	e8 2e 01 00 00       	call   802400 <nsipc_listen>
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	e8 9f ff ff ff       	call   802281 <fd2sockid>
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	78 16                	js     8022fc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8022e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8022e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022f4:	89 04 24             	mov    %eax,(%esp)
  8022f7:	e8 55 02 00 00       	call   802551 <nsipc_connect>
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	e8 75 ff ff ff       	call   802281 <fd2sockid>
  80230c:	85 c0                	test   %eax,%eax
  80230e:	78 0f                	js     80231f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802310:	8b 55 0c             	mov    0xc(%ebp),%edx
  802313:	89 54 24 04          	mov    %edx,0x4(%esp)
  802317:	89 04 24             	mov    %eax,(%esp)
  80231a:	e8 1d 01 00 00       	call   80243c <nsipc_shutdown>
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	e8 52 ff ff ff       	call   802281 <fd2sockid>
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 16                	js     802349 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802333:	8b 55 10             	mov    0x10(%ebp),%edx
  802336:	89 54 24 08          	mov    %edx,0x8(%esp)
  80233a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802341:	89 04 24             	mov    %eax,(%esp)
  802344:	e8 47 02 00 00       	call   802590 <nsipc_bind>
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	e8 28 ff ff ff       	call   802281 <fd2sockid>
  802359:	85 c0                	test   %eax,%eax
  80235b:	78 1f                	js     80237c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80235d:	8b 55 10             	mov    0x10(%ebp),%edx
  802360:	89 54 24 08          	mov    %edx,0x8(%esp)
  802364:	8b 55 0c             	mov    0xc(%ebp),%edx
  802367:	89 54 24 04          	mov    %edx,0x4(%esp)
  80236b:	89 04 24             	mov    %eax,(%esp)
  80236e:	e8 5c 02 00 00       	call   8025cf <nsipc_accept>
  802373:	85 c0                	test   %eax,%eax
  802375:	78 05                	js     80237c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802377:	e8 62 fe ff ff       	call   8021de <alloc_sockfd>
}
  80237c:	c9                   	leave  
  80237d:	8d 76 00             	lea    0x0(%esi),%esi
  802380:	c3                   	ret    
	...

00802390 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802396:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80239c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023a3:	00 
  8023a4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8023ab:	00 
  8023ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b0:	89 14 24             	mov    %edx,(%esp)
  8023b3:	e8 28 09 00 00       	call   802ce0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023bf:	00 
  8023c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023c7:	00 
  8023c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023cf:	e8 72 09 00 00       	call   802d46 <ipc_recv>
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8023ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ef:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8023f4:	b8 09 00 00 00       	mov    $0x9,%eax
  8023f9:	e8 92 ff ff ff       	call   802390 <nsipc>
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80240e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802411:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802416:	b8 06 00 00 00       	mov    $0x6,%eax
  80241b:	e8 70 ff ff ff       	call   802390 <nsipc>
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802430:	b8 04 00 00 00       	mov    $0x4,%eax
  802435:	e8 56 ff ff ff       	call   802390 <nsipc>
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80244a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802452:	b8 03 00 00 00       	mov    $0x3,%eax
  802457:	e8 34 ff ff ff       	call   802390 <nsipc>
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	53                   	push   %ebx
  802462:	83 ec 14             	sub    $0x14,%esp
  802465:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802470:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802476:	7e 24                	jle    80249c <nsipc_send+0x3e>
  802478:	c7 44 24 0c 78 38 80 	movl   $0x803878,0xc(%esp)
  80247f:	00 
  802480:	c7 44 24 08 84 38 80 	movl   $0x803884,0x8(%esp)
  802487:	00 
  802488:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80248f:	00 
  802490:	c7 04 24 99 38 80 00 	movl   $0x803899,(%esp)
  802497:	e8 d0 df ff ff       	call   80046c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80249c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8024ae:	e8 f2 e8 ff ff       	call   800da5 <memmove>
	nsipcbuf.send.req_size = size;
  8024b3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8024b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8024bc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8024c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8024c6:	e8 c5 fe ff ff       	call   802390 <nsipc>
}
  8024cb:	83 c4 14             	add    $0x14,%esp
  8024ce:	5b                   	pop    %ebx
  8024cf:	5d                   	pop    %ebp
  8024d0:	c3                   	ret    

008024d1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	56                   	push   %esi
  8024d5:	53                   	push   %ebx
  8024d6:	83 ec 10             	sub    $0x10,%esp
  8024d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8024e4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8024ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ed:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024f2:	b8 07 00 00 00       	mov    $0x7,%eax
  8024f7:	e8 94 fe ff ff       	call   802390 <nsipc>
  8024fc:	89 c3                	mov    %eax,%ebx
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 46                	js     802548 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802502:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802507:	7f 04                	jg     80250d <nsipc_recv+0x3c>
  802509:	39 c6                	cmp    %eax,%esi
  80250b:	7d 24                	jge    802531 <nsipc_recv+0x60>
  80250d:	c7 44 24 0c a5 38 80 	movl   $0x8038a5,0xc(%esp)
  802514:	00 
  802515:	c7 44 24 08 84 38 80 	movl   $0x803884,0x8(%esp)
  80251c:	00 
  80251d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802524:	00 
  802525:	c7 04 24 99 38 80 00 	movl   $0x803899,(%esp)
  80252c:	e8 3b df ff ff       	call   80046c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802531:	89 44 24 08          	mov    %eax,0x8(%esp)
  802535:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80253c:	00 
  80253d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802540:	89 04 24             	mov    %eax,(%esp)
  802543:	e8 5d e8 ff ff       	call   800da5 <memmove>
	}

	return r;
}
  802548:	89 d8                	mov    %ebx,%eax
  80254a:	83 c4 10             	add    $0x10,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    

00802551 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	53                   	push   %ebx
  802555:	83 ec 14             	sub    $0x14,%esp
  802558:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802563:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802575:	e8 2b e8 ff ff       	call   800da5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80257a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802580:	b8 05 00 00 00       	mov    $0x5,%eax
  802585:	e8 06 fe ff ff       	call   802390 <nsipc>
}
  80258a:	83 c4 14             	add    $0x14,%esp
  80258d:	5b                   	pop    %ebx
  80258e:	5d                   	pop    %ebp
  80258f:	c3                   	ret    

00802590 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	53                   	push   %ebx
  802594:	83 ec 14             	sub    $0x14,%esp
  802597:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ad:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8025b4:	e8 ec e7 ff ff       	call   800da5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8025b9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8025bf:	b8 02 00 00 00       	mov    $0x2,%eax
  8025c4:	e8 c7 fd ff ff       	call   802390 <nsipc>
}
  8025c9:	83 c4 14             	add    $0x14,%esp
  8025cc:	5b                   	pop    %ebx
  8025cd:	5d                   	pop    %ebp
  8025ce:	c3                   	ret    

008025cf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	83 ec 18             	sub    $0x18,%esp
  8025d5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8025d8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e8:	e8 a3 fd ff ff       	call   802390 <nsipc>
  8025ed:	89 c3                	mov    %eax,%ebx
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	78 25                	js     802618 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8025f3:	be 10 60 80 00       	mov    $0x806010,%esi
  8025f8:	8b 06                	mov    (%esi),%eax
  8025fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025fe:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802605:	00 
  802606:	8b 45 0c             	mov    0xc(%ebp),%eax
  802609:	89 04 24             	mov    %eax,(%esp)
  80260c:	e8 94 e7 ff ff       	call   800da5 <memmove>
		*addrlen = ret->ret_addrlen;
  802611:	8b 16                	mov    (%esi),%edx
  802613:	8b 45 10             	mov    0x10(%ebp),%eax
  802616:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802618:	89 d8                	mov    %ebx,%eax
  80261a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80261d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802620:	89 ec                	mov    %ebp,%esp
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    
	...

00802630 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 18             	sub    $0x18,%esp
  802636:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802639:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80263c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	89 04 24             	mov    %eax,(%esp)
  802645:	e8 86 f2 ff ff       	call   8018d0 <fd2data>
  80264a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80264c:	c7 44 24 04 ba 38 80 	movl   $0x8038ba,0x4(%esp)
  802653:	00 
  802654:	89 34 24             	mov    %esi,(%esp)
  802657:	e8 8e e5 ff ff       	call   800bea <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80265c:	8b 43 04             	mov    0x4(%ebx),%eax
  80265f:	2b 03                	sub    (%ebx),%eax
  802661:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802667:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80266e:	00 00 00 
	stat->st_dev = &devpipe;
  802671:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802678:	70 80 00 
	return 0;
}
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802683:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802686:	89 ec                	mov    %ebp,%esp
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    

0080268a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	53                   	push   %ebx
  80268e:	83 ec 14             	sub    $0x14,%esp
  802691:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802694:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80269f:	e8 7b ec ff ff       	call   80131f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026a4:	89 1c 24             	mov    %ebx,(%esp)
  8026a7:	e8 24 f2 ff ff       	call   8018d0 <fd2data>
  8026ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b7:	e8 63 ec ff ff       	call   80131f <sys_page_unmap>
}
  8026bc:	83 c4 14             	add    $0x14,%esp
  8026bf:	5b                   	pop    %ebx
  8026c0:	5d                   	pop    %ebp
  8026c1:	c3                   	ret    

008026c2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	57                   	push   %edi
  8026c6:	56                   	push   %esi
  8026c7:	53                   	push   %ebx
  8026c8:	83 ec 2c             	sub    $0x2c,%esp
  8026cb:	89 c7                	mov    %eax,%edi
  8026cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8026d0:	a1 80 74 80 00       	mov    0x807480,%eax
  8026d5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026d8:	89 3c 24             	mov    %edi,(%esp)
  8026db:	e8 d0 06 00 00       	call   802db0 <pageref>
  8026e0:	89 c6                	mov    %eax,%esi
  8026e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e5:	89 04 24             	mov    %eax,(%esp)
  8026e8:	e8 c3 06 00 00       	call   802db0 <pageref>
  8026ed:	39 c6                	cmp    %eax,%esi
  8026ef:	0f 94 c0             	sete   %al
  8026f2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8026f5:	8b 15 80 74 80 00    	mov    0x807480,%edx
  8026fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026fe:	39 cb                	cmp    %ecx,%ebx
  802700:	75 08                	jne    80270a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802702:	83 c4 2c             	add    $0x2c,%esp
  802705:	5b                   	pop    %ebx
  802706:	5e                   	pop    %esi
  802707:	5f                   	pop    %edi
  802708:	5d                   	pop    %ebp
  802709:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80270a:	83 f8 01             	cmp    $0x1,%eax
  80270d:	75 c1                	jne    8026d0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80270f:	8b 52 58             	mov    0x58(%edx),%edx
  802712:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802716:	89 54 24 08          	mov    %edx,0x8(%esp)
  80271a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80271e:	c7 04 24 c1 38 80 00 	movl   $0x8038c1,(%esp)
  802725:	e8 07 de ff ff       	call   800531 <cprintf>
  80272a:	eb a4                	jmp    8026d0 <_pipeisclosed+0xe>

0080272c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	57                   	push   %edi
  802730:	56                   	push   %esi
  802731:	53                   	push   %ebx
  802732:	83 ec 1c             	sub    $0x1c,%esp
  802735:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802738:	89 34 24             	mov    %esi,(%esp)
  80273b:	e8 90 f1 ff ff       	call   8018d0 <fd2data>
  802740:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802742:	bf 00 00 00 00       	mov    $0x0,%edi
  802747:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80274b:	75 54                	jne    8027a1 <devpipe_write+0x75>
  80274d:	eb 60                	jmp    8027af <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80274f:	89 da                	mov    %ebx,%edx
  802751:	89 f0                	mov    %esi,%eax
  802753:	e8 6a ff ff ff       	call   8026c2 <_pipeisclosed>
  802758:	85 c0                	test   %eax,%eax
  80275a:	74 07                	je     802763 <devpipe_write+0x37>
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
  802761:	eb 53                	jmp    8027b6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802763:	90                   	nop
  802764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802768:	e8 cd ec ff ff       	call   80143a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80276d:	8b 43 04             	mov    0x4(%ebx),%eax
  802770:	8b 13                	mov    (%ebx),%edx
  802772:	83 c2 20             	add    $0x20,%edx
  802775:	39 d0                	cmp    %edx,%eax
  802777:	73 d6                	jae    80274f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802779:	89 c2                	mov    %eax,%edx
  80277b:	c1 fa 1f             	sar    $0x1f,%edx
  80277e:	c1 ea 1b             	shr    $0x1b,%edx
  802781:	01 d0                	add    %edx,%eax
  802783:	83 e0 1f             	and    $0x1f,%eax
  802786:	29 d0                	sub    %edx,%eax
  802788:	89 c2                	mov    %eax,%edx
  80278a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80278d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802791:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802795:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802799:	83 c7 01             	add    $0x1,%edi
  80279c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80279f:	76 13                	jbe    8027b4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8027a4:	8b 13                	mov    (%ebx),%edx
  8027a6:	83 c2 20             	add    $0x20,%edx
  8027a9:	39 d0                	cmp    %edx,%eax
  8027ab:	73 a2                	jae    80274f <devpipe_write+0x23>
  8027ad:	eb ca                	jmp    802779 <devpipe_write+0x4d>
  8027af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8027b4:	89 f8                	mov    %edi,%eax
}
  8027b6:	83 c4 1c             	add    $0x1c,%esp
  8027b9:	5b                   	pop    %ebx
  8027ba:	5e                   	pop    %esi
  8027bb:	5f                   	pop    %edi
  8027bc:	5d                   	pop    %ebp
  8027bd:	c3                   	ret    

008027be <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
  8027c1:	83 ec 28             	sub    $0x28,%esp
  8027c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027d0:	89 3c 24             	mov    %edi,(%esp)
  8027d3:	e8 f8 f0 ff ff       	call   8018d0 <fd2data>
  8027d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027da:	be 00 00 00 00       	mov    $0x0,%esi
  8027df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027e3:	75 4c                	jne    802831 <devpipe_read+0x73>
  8027e5:	eb 5b                	jmp    802842 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8027e7:	89 f0                	mov    %esi,%eax
  8027e9:	eb 5e                	jmp    802849 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8027eb:	89 da                	mov    %ebx,%edx
  8027ed:	89 f8                	mov    %edi,%eax
  8027ef:	90                   	nop
  8027f0:	e8 cd fe ff ff       	call   8026c2 <_pipeisclosed>
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 07                	je     802800 <devpipe_read+0x42>
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	eb 49                	jmp    802849 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802800:	e8 35 ec ff ff       	call   80143a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802805:	8b 03                	mov    (%ebx),%eax
  802807:	3b 43 04             	cmp    0x4(%ebx),%eax
  80280a:	74 df                	je     8027eb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80280c:	89 c2                	mov    %eax,%edx
  80280e:	c1 fa 1f             	sar    $0x1f,%edx
  802811:	c1 ea 1b             	shr    $0x1b,%edx
  802814:	01 d0                	add    %edx,%eax
  802816:	83 e0 1f             	and    $0x1f,%eax
  802819:	29 d0                	sub    %edx,%eax
  80281b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802820:	8b 55 0c             	mov    0xc(%ebp),%edx
  802823:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802826:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802829:	83 c6 01             	add    $0x1,%esi
  80282c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80282f:	76 16                	jbe    802847 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802831:	8b 03                	mov    (%ebx),%eax
  802833:	3b 43 04             	cmp    0x4(%ebx),%eax
  802836:	75 d4                	jne    80280c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802838:	85 f6                	test   %esi,%esi
  80283a:	75 ab                	jne    8027e7 <devpipe_read+0x29>
  80283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802840:	eb a9                	jmp    8027eb <devpipe_read+0x2d>
  802842:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802847:	89 f0                	mov    %esi,%eax
}
  802849:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80284c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80284f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802852:	89 ec                	mov    %ebp,%esp
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    

00802856 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80285c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80285f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	89 04 24             	mov    %eax,(%esp)
  802869:	e8 ef f0 ff ff       	call   80195d <fd_lookup>
  80286e:	85 c0                	test   %eax,%eax
  802870:	78 15                	js     802887 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	89 04 24             	mov    %eax,(%esp)
  802878:	e8 53 f0 ff ff       	call   8018d0 <fd2data>
	return _pipeisclosed(fd, p);
  80287d:	89 c2                	mov    %eax,%edx
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	e8 3b fe ff ff       	call   8026c2 <_pipeisclosed>
}
  802887:	c9                   	leave  
  802888:	c3                   	ret    

00802889 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
  80288c:	83 ec 48             	sub    $0x48,%esp
  80288f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802892:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802895:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802898:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80289b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80289e:	89 04 24             	mov    %eax,(%esp)
  8028a1:	e8 45 f0 ff ff       	call   8018eb <fd_alloc>
  8028a6:	89 c3                	mov    %eax,%ebx
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	0f 88 42 01 00 00    	js     8029f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028b0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028b7:	00 
  8028b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c6:	e8 10 eb ff ff       	call   8013db <sys_page_alloc>
  8028cb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	0f 88 1d 01 00 00    	js     8029f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8028d8:	89 04 24             	mov    %eax,(%esp)
  8028db:	e8 0b f0 ff ff       	call   8018eb <fd_alloc>
  8028e0:	89 c3                	mov    %eax,%ebx
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	0f 88 f5 00 00 00    	js     8029df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028ea:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028f1:	00 
  8028f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802900:	e8 d6 ea ff ff       	call   8013db <sys_page_alloc>
  802905:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802907:	85 c0                	test   %eax,%eax
  802909:	0f 88 d0 00 00 00    	js     8029df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80290f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802912:	89 04 24             	mov    %eax,(%esp)
  802915:	e8 b6 ef ff ff       	call   8018d0 <fd2data>
  80291a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80291c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802923:	00 
  802924:	89 44 24 04          	mov    %eax,0x4(%esp)
  802928:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80292f:	e8 a7 ea ff ff       	call   8013db <sys_page_alloc>
  802934:	89 c3                	mov    %eax,%ebx
  802936:	85 c0                	test   %eax,%eax
  802938:	0f 88 8e 00 00 00    	js     8029cc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80293e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802941:	89 04 24             	mov    %eax,(%esp)
  802944:	e8 87 ef ff ff       	call   8018d0 <fd2data>
  802949:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802950:	00 
  802951:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802955:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80295c:	00 
  80295d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802961:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802968:	e8 10 ea ff ff       	call   80137d <sys_page_map>
  80296d:	89 c3                	mov    %eax,%ebx
  80296f:	85 c0                	test   %eax,%eax
  802971:	78 49                	js     8029bc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802973:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802978:	8b 08                	mov    (%eax),%ecx
  80297a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80297d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80297f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802982:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802989:	8b 10                	mov    (%eax),%edx
  80298b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802993:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80299a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299d:	89 04 24             	mov    %eax,(%esp)
  8029a0:	e8 1b ef ff ff       	call   8018c0 <fd2num>
  8029a5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8029a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029aa:	89 04 24             	mov    %eax,(%esp)
  8029ad:	e8 0e ef ff ff       	call   8018c0 <fd2num>
  8029b2:	89 47 04             	mov    %eax,0x4(%edi)
  8029b5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8029ba:	eb 36                	jmp    8029f2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8029bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c7:	e8 53 e9 ff ff       	call   80131f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029da:	e8 40 e9 ff ff       	call   80131f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ed:	e8 2d e9 ff ff       	call   80131f <sys_page_unmap>
    err:
	return r;
}
  8029f2:	89 d8                	mov    %ebx,%eax
  8029f4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029f7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029fd:	89 ec                	mov    %ebp,%esp
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	00 00                	add    %al,(%eax)
	...

00802a04 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	56                   	push   %esi
  802a08:	53                   	push   %ebx
  802a09:	83 ec 10             	sub    $0x10,%esp
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	75 24                	jne    802a37 <wait+0x33>
  802a13:	c7 44 24 0c d9 38 80 	movl   $0x8038d9,0xc(%esp)
  802a1a:	00 
  802a1b:	c7 44 24 08 84 38 80 	movl   $0x803884,0x8(%esp)
  802a22:	00 
  802a23:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802a2a:	00 
  802a2b:	c7 04 24 e4 38 80 00 	movl   $0x8038e4,(%esp)
  802a32:	e8 35 da ff ff       	call   80046c <_panic>
	e = &envs[ENVX(envid)];
  802a37:	89 c3                	mov    %eax,%ebx
  802a39:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802a3f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802a42:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a48:	8b 73 4c             	mov    0x4c(%ebx),%esi
  802a4b:	39 c6                	cmp    %eax,%esi
  802a4d:	75 1a                	jne    802a69 <wait+0x65>
  802a4f:	8b 43 54             	mov    0x54(%ebx),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 13                	je     802a69 <wait+0x65>
		sys_yield();
  802a56:	e8 df e9 ff ff       	call   80143a <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a5b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802a5e:	39 f0                	cmp    %esi,%eax
  802a60:	75 07                	jne    802a69 <wait+0x65>
  802a62:	8b 43 54             	mov    0x54(%ebx),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	75 ed                	jne    802a56 <wait+0x52>
		sys_yield();
}
  802a69:	83 c4 10             	add    $0x10,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5d                   	pop    %ebp
  802a6f:	c3                   	ret    

00802a70 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
  802a78:	5d                   	pop    %ebp
  802a79:	c3                   	ret    

00802a7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
  802a7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a80:	c7 44 24 04 ef 38 80 	movl   $0x8038ef,0x4(%esp)
  802a87:	00 
  802a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a8b:	89 04 24             	mov    %eax,(%esp)
  802a8e:	e8 57 e1 ff ff       	call   800bea <strcpy>
	return 0;
}
  802a93:	b8 00 00 00 00       	mov    $0x0,%eax
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	57                   	push   %edi
  802a9e:	56                   	push   %esi
  802a9f:	53                   	push   %ebx
  802aa0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aab:	be 00 00 00 00       	mov    $0x0,%esi
  802ab0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ab4:	74 3f                	je     802af5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802ab6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802abc:	8b 55 10             	mov    0x10(%ebp),%edx
  802abf:	29 c2                	sub    %eax,%edx
  802ac1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802ac3:	83 fa 7f             	cmp    $0x7f,%edx
  802ac6:	76 05                	jbe    802acd <devcons_write+0x33>
  802ac8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802acd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ad1:	03 45 0c             	add    0xc(%ebp),%eax
  802ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad8:	89 3c 24             	mov    %edi,(%esp)
  802adb:	e8 c5 e2 ff ff       	call   800da5 <memmove>
		sys_cputs(buf, m);
  802ae0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ae4:	89 3c 24             	mov    %edi,(%esp)
  802ae7:	e8 f4 e4 ff ff       	call   800fe0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802aec:	01 de                	add    %ebx,%esi
  802aee:	89 f0                	mov    %esi,%eax
  802af0:	3b 75 10             	cmp    0x10(%ebp),%esi
  802af3:	72 c7                	jb     802abc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802af5:	89 f0                	mov    %esi,%eax
  802af7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802afd:	5b                   	pop    %ebx
  802afe:	5e                   	pop    %esi
  802aff:	5f                   	pop    %edi
  802b00:	5d                   	pop    %ebp
  802b01:	c3                   	ret    

00802b02 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802b02:	55                   	push   %ebp
  802b03:	89 e5                	mov    %esp,%ebp
  802b05:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802b0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802b15:	00 
  802b16:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b19:	89 04 24             	mov    %eax,(%esp)
  802b1c:	e8 bf e4 ff ff       	call   800fe0 <sys_cputs>
}
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
  802b26:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802b29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b2d:	75 07                	jne    802b36 <devcons_read+0x13>
  802b2f:	eb 28                	jmp    802b59 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802b31:	e8 04 e9 ff ff       	call   80143a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802b36:	66 90                	xchg   %ax,%ax
  802b38:	e8 6f e4 ff ff       	call   800fac <sys_cgetc>
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	90                   	nop
  802b40:	74 ef                	je     802b31 <devcons_read+0xe>
  802b42:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802b44:	85 c0                	test   %eax,%eax
  802b46:	78 16                	js     802b5e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802b48:	83 f8 04             	cmp    $0x4,%eax
  802b4b:	74 0c                	je     802b59 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b50:	88 10                	mov    %dl,(%eax)
  802b52:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802b57:	eb 05                	jmp    802b5e <devcons_read+0x3b>
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5e:	c9                   	leave  
  802b5f:	c3                   	ret    

00802b60 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
  802b63:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b69:	89 04 24             	mov    %eax,(%esp)
  802b6c:	e8 7a ed ff ff       	call   8018eb <fd_alloc>
  802b71:	85 c0                	test   %eax,%eax
  802b73:	78 3f                	js     802bb4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b75:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b7c:	00 
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b8b:	e8 4b e8 ff ff       	call   8013db <sys_page_alloc>
  802b90:	85 c0                	test   %eax,%eax
  802b92:	78 20                	js     802bb4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b94:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	89 04 24             	mov    %eax,(%esp)
  802baf:	e8 0c ed ff ff       	call   8018c0 <fd2num>
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	89 04 24             	mov    %eax,(%esp)
  802bc9:	e8 8f ed ff ff       	call   80195d <fd_lookup>
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	78 11                	js     802be3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802bdd:	0f 94 c0             	sete   %al
  802be0:	0f b6 c0             	movzbl %al,%eax
}
  802be3:	c9                   	leave  
  802be4:	c3                   	ret    

00802be5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802be5:	55                   	push   %ebp
  802be6:	89 e5                	mov    %esp,%ebp
  802be8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802beb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802bf2:	00 
  802bf3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c01:	e8 b8 ef ff ff       	call   801bbe <read>
	if (r < 0)
  802c06:	85 c0                	test   %eax,%eax
  802c08:	78 0f                	js     802c19 <getchar+0x34>
		return r;
	if (r < 1)
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	7f 07                	jg     802c15 <getchar+0x30>
  802c0e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802c13:	eb 04                	jmp    802c19 <getchar+0x34>
		return -E_EOF;
	return c;
  802c15:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802c19:	c9                   	leave  
  802c1a:	c3                   	ret    
	...

00802c1c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
  802c1f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802c22:	83 3d 88 74 80 00 00 	cmpl   $0x0,0x807488
  802c29:	75 78                	jne    802ca3 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  802c2b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c32:	00 
  802c33:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802c3a:	ee 
  802c3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c42:	e8 94 e7 ff ff       	call   8013db <sys_page_alloc>
  802c47:	85 c0                	test   %eax,%eax
  802c49:	79 20                	jns    802c6b <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  802c4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c4f:	c7 44 24 08 fb 38 80 	movl   $0x8038fb,0x8(%esp)
  802c56:	00 
  802c57:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802c5e:	00 
  802c5f:	c7 04 24 19 39 80 00 	movl   $0x803919,(%esp)
  802c66:	e8 01 d8 ff ff       	call   80046c <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802c6b:	c7 44 24 04 b0 2c 80 	movl   $0x802cb0,0x4(%esp)
  802c72:	00 
  802c73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c7a:	e8 86 e5 ff ff       	call   801205 <sys_env_set_pgfault_upcall>
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	79 20                	jns    802ca3 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802c83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c87:	c7 44 24 08 28 39 80 	movl   $0x803928,0x8(%esp)
  802c8e:	00 
  802c8f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802c96:	00 
  802c97:	c7 04 24 19 39 80 00 	movl   $0x803919,(%esp)
  802c9e:	e8 c9 d7 ff ff       	call   80046c <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	a3 88 74 80 00       	mov    %eax,0x807488
	
}
  802cab:	c9                   	leave  
  802cac:	c3                   	ret    
  802cad:	00 00                	add    %al,(%eax)
	...

00802cb0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802cb0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802cb1:	a1 88 74 80 00       	mov    0x807488,%eax
	call *%eax
  802cb6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802cb8:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802cbb:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802cbd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802cc1:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802cc5:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802cc7:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802cc8:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802cca:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802ccd:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802cd1:	83 c4 08             	add    $0x8,%esp
	popal
  802cd4:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802cd5:	83 c4 04             	add    $0x4,%esp
	popfl
  802cd8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802cd9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802cda:	c3                   	ret    
  802cdb:	00 00                	add    %al,(%eax)
  802cdd:	00 00                	add    %al,(%eax)
	...

00802ce0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	57                   	push   %edi
  802ce4:	56                   	push   %esi
  802ce5:	53                   	push   %ebx
  802ce6:	83 ec 1c             	sub    $0x1c,%esp
  802ce9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802cec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802cef:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802cf2:	85 db                	test   %ebx,%ebx
  802cf4:	75 2d                	jne    802d23 <ipc_send+0x43>
  802cf6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  802cfb:	eb 26                	jmp    802d23 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  802cfd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d00:	74 1c                	je     802d1e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802d02:	c7 44 24 08 54 39 80 	movl   $0x803954,0x8(%esp)
  802d09:	00 
  802d0a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802d11:	00 
  802d12:	c7 04 24 78 39 80 00 	movl   $0x803978,(%esp)
  802d19:	e8 4e d7 ff ff       	call   80046c <_panic>
		sys_yield();
  802d1e:	e8 17 e7 ff ff       	call   80143a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802d23:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802d27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d2b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	89 04 24             	mov    %eax,(%esp)
  802d35:	e8 93 e4 ff ff       	call   8011cd <sys_ipc_try_send>
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	78 bf                	js     802cfd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802d3e:	83 c4 1c             	add    $0x1c,%esp
  802d41:	5b                   	pop    %ebx
  802d42:	5e                   	pop    %esi
  802d43:	5f                   	pop    %edi
  802d44:	5d                   	pop    %ebp
  802d45:	c3                   	ret    

00802d46 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d46:	55                   	push   %ebp
  802d47:	89 e5                	mov    %esp,%ebp
  802d49:	56                   	push   %esi
  802d4a:	53                   	push   %ebx
  802d4b:	83 ec 10             	sub    $0x10,%esp
  802d4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d54:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802d57:	85 c0                	test   %eax,%eax
  802d59:	75 05                	jne    802d60 <ipc_recv+0x1a>
  802d5b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802d60:	89 04 24             	mov    %eax,(%esp)
  802d63:	e8 08 e4 ff ff       	call   801170 <sys_ipc_recv>
  802d68:	85 c0                	test   %eax,%eax
  802d6a:	79 16                	jns    802d82 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  802d6c:	85 db                	test   %ebx,%ebx
  802d6e:	74 06                	je     802d76 <ipc_recv+0x30>
			*from_env_store = 0;
  802d70:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802d76:	85 f6                	test   %esi,%esi
  802d78:	74 2c                	je     802da6 <ipc_recv+0x60>
			*perm_store = 0;
  802d7a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802d80:	eb 24                	jmp    802da6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802d82:	85 db                	test   %ebx,%ebx
  802d84:	74 0a                	je     802d90 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802d86:	a1 80 74 80 00       	mov    0x807480,%eax
  802d8b:	8b 40 74             	mov    0x74(%eax),%eax
  802d8e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802d90:	85 f6                	test   %esi,%esi
  802d92:	74 0a                	je     802d9e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802d94:	a1 80 74 80 00       	mov    0x807480,%eax
  802d99:	8b 40 78             	mov    0x78(%eax),%eax
  802d9c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  802d9e:	a1 80 74 80 00       	mov    0x807480,%eax
  802da3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802da6:	83 c4 10             	add    $0x10,%esp
  802da9:	5b                   	pop    %ebx
  802daa:	5e                   	pop    %esi
  802dab:	5d                   	pop    %ebp
  802dac:	c3                   	ret    
  802dad:	00 00                	add    %al,(%eax)
	...

00802db0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802db0:	55                   	push   %ebp
  802db1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	89 c2                	mov    %eax,%edx
  802db8:	c1 ea 16             	shr    $0x16,%edx
  802dbb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802dc2:	f6 c2 01             	test   $0x1,%dl
  802dc5:	74 26                	je     802ded <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802dc7:	c1 e8 0c             	shr    $0xc,%eax
  802dca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802dd1:	a8 01                	test   $0x1,%al
  802dd3:	74 18                	je     802ded <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802dd5:	c1 e8 0c             	shr    $0xc,%eax
  802dd8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802ddb:	c1 e2 02             	shl    $0x2,%edx
  802dde:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802de3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802de8:	0f b7 c0             	movzwl %ax,%eax
  802deb:	eb 05                	jmp    802df2 <pageref+0x42>
  802ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df2:	5d                   	pop    %ebp
  802df3:	c3                   	ret    
	...

00802e00 <__udivdi3>:
  802e00:	55                   	push   %ebp
  802e01:	89 e5                	mov    %esp,%ebp
  802e03:	57                   	push   %edi
  802e04:	56                   	push   %esi
  802e05:	83 ec 10             	sub    $0x10,%esp
  802e08:	8b 45 14             	mov    0x14(%ebp),%eax
  802e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0e:	8b 75 10             	mov    0x10(%ebp),%esi
  802e11:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802e14:	85 c0                	test   %eax,%eax
  802e16:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802e19:	75 35                	jne    802e50 <__udivdi3+0x50>
  802e1b:	39 fe                	cmp    %edi,%esi
  802e1d:	77 61                	ja     802e80 <__udivdi3+0x80>
  802e1f:	85 f6                	test   %esi,%esi
  802e21:	75 0b                	jne    802e2e <__udivdi3+0x2e>
  802e23:	b8 01 00 00 00       	mov    $0x1,%eax
  802e28:	31 d2                	xor    %edx,%edx
  802e2a:	f7 f6                	div    %esi
  802e2c:	89 c6                	mov    %eax,%esi
  802e2e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e31:	31 d2                	xor    %edx,%edx
  802e33:	89 f8                	mov    %edi,%eax
  802e35:	f7 f6                	div    %esi
  802e37:	89 c7                	mov    %eax,%edi
  802e39:	89 c8                	mov    %ecx,%eax
  802e3b:	f7 f6                	div    %esi
  802e3d:	89 c1                	mov    %eax,%ecx
  802e3f:	89 fa                	mov    %edi,%edx
  802e41:	89 c8                	mov    %ecx,%eax
  802e43:	83 c4 10             	add    $0x10,%esp
  802e46:	5e                   	pop    %esi
  802e47:	5f                   	pop    %edi
  802e48:	5d                   	pop    %ebp
  802e49:	c3                   	ret    
  802e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e50:	39 f8                	cmp    %edi,%eax
  802e52:	77 1c                	ja     802e70 <__udivdi3+0x70>
  802e54:	0f bd d0             	bsr    %eax,%edx
  802e57:	83 f2 1f             	xor    $0x1f,%edx
  802e5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e5d:	75 39                	jne    802e98 <__udivdi3+0x98>
  802e5f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802e62:	0f 86 a0 00 00 00    	jbe    802f08 <__udivdi3+0x108>
  802e68:	39 f8                	cmp    %edi,%eax
  802e6a:	0f 82 98 00 00 00    	jb     802f08 <__udivdi3+0x108>
  802e70:	31 ff                	xor    %edi,%edi
  802e72:	31 c9                	xor    %ecx,%ecx
  802e74:	89 c8                	mov    %ecx,%eax
  802e76:	89 fa                	mov    %edi,%edx
  802e78:	83 c4 10             	add    $0x10,%esp
  802e7b:	5e                   	pop    %esi
  802e7c:	5f                   	pop    %edi
  802e7d:	5d                   	pop    %ebp
  802e7e:	c3                   	ret    
  802e7f:	90                   	nop
  802e80:	89 d1                	mov    %edx,%ecx
  802e82:	89 fa                	mov    %edi,%edx
  802e84:	89 c8                	mov    %ecx,%eax
  802e86:	31 ff                	xor    %edi,%edi
  802e88:	f7 f6                	div    %esi
  802e8a:	89 c1                	mov    %eax,%ecx
  802e8c:	89 fa                	mov    %edi,%edx
  802e8e:	89 c8                	mov    %ecx,%eax
  802e90:	83 c4 10             	add    $0x10,%esp
  802e93:	5e                   	pop    %esi
  802e94:	5f                   	pop    %edi
  802e95:	5d                   	pop    %ebp
  802e96:	c3                   	ret    
  802e97:	90                   	nop
  802e98:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802e9c:	89 f2                	mov    %esi,%edx
  802e9e:	d3 e0                	shl    %cl,%eax
  802ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ea3:	b8 20 00 00 00       	mov    $0x20,%eax
  802ea8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802eab:	89 c1                	mov    %eax,%ecx
  802ead:	d3 ea                	shr    %cl,%edx
  802eaf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802eb3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802eb6:	d3 e6                	shl    %cl,%esi
  802eb8:	89 c1                	mov    %eax,%ecx
  802eba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802ebd:	89 fe                	mov    %edi,%esi
  802ebf:	d3 ee                	shr    %cl,%esi
  802ec1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ec5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ec8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ecb:	d3 e7                	shl    %cl,%edi
  802ecd:	89 c1                	mov    %eax,%ecx
  802ecf:	d3 ea                	shr    %cl,%edx
  802ed1:	09 d7                	or     %edx,%edi
  802ed3:	89 f2                	mov    %esi,%edx
  802ed5:	89 f8                	mov    %edi,%eax
  802ed7:	f7 75 ec             	divl   -0x14(%ebp)
  802eda:	89 d6                	mov    %edx,%esi
  802edc:	89 c7                	mov    %eax,%edi
  802ede:	f7 65 e8             	mull   -0x18(%ebp)
  802ee1:	39 d6                	cmp    %edx,%esi
  802ee3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ee6:	72 30                	jb     802f18 <__udivdi3+0x118>
  802ee8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eeb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802eef:	d3 e2                	shl    %cl,%edx
  802ef1:	39 c2                	cmp    %eax,%edx
  802ef3:	73 05                	jae    802efa <__udivdi3+0xfa>
  802ef5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802ef8:	74 1e                	je     802f18 <__udivdi3+0x118>
  802efa:	89 f9                	mov    %edi,%ecx
  802efc:	31 ff                	xor    %edi,%edi
  802efe:	e9 71 ff ff ff       	jmp    802e74 <__udivdi3+0x74>
  802f03:	90                   	nop
  802f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f08:	31 ff                	xor    %edi,%edi
  802f0a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802f0f:	e9 60 ff ff ff       	jmp    802e74 <__udivdi3+0x74>
  802f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f18:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802f1b:	31 ff                	xor    %edi,%edi
  802f1d:	89 c8                	mov    %ecx,%eax
  802f1f:	89 fa                	mov    %edi,%edx
  802f21:	83 c4 10             	add    $0x10,%esp
  802f24:	5e                   	pop    %esi
  802f25:	5f                   	pop    %edi
  802f26:	5d                   	pop    %ebp
  802f27:	c3                   	ret    
	...

00802f30 <__umoddi3>:
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
  802f33:	57                   	push   %edi
  802f34:	56                   	push   %esi
  802f35:	83 ec 20             	sub    $0x20,%esp
  802f38:	8b 55 14             	mov    0x14(%ebp),%edx
  802f3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f3e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802f41:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f44:	85 d2                	test   %edx,%edx
  802f46:	89 c8                	mov    %ecx,%eax
  802f48:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802f4b:	75 13                	jne    802f60 <__umoddi3+0x30>
  802f4d:	39 f7                	cmp    %esi,%edi
  802f4f:	76 3f                	jbe    802f90 <__umoddi3+0x60>
  802f51:	89 f2                	mov    %esi,%edx
  802f53:	f7 f7                	div    %edi
  802f55:	89 d0                	mov    %edx,%eax
  802f57:	31 d2                	xor    %edx,%edx
  802f59:	83 c4 20             	add    $0x20,%esp
  802f5c:	5e                   	pop    %esi
  802f5d:	5f                   	pop    %edi
  802f5e:	5d                   	pop    %ebp
  802f5f:	c3                   	ret    
  802f60:	39 f2                	cmp    %esi,%edx
  802f62:	77 4c                	ja     802fb0 <__umoddi3+0x80>
  802f64:	0f bd ca             	bsr    %edx,%ecx
  802f67:	83 f1 1f             	xor    $0x1f,%ecx
  802f6a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802f6d:	75 51                	jne    802fc0 <__umoddi3+0x90>
  802f6f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802f72:	0f 87 e0 00 00 00    	ja     803058 <__umoddi3+0x128>
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	29 f8                	sub    %edi,%eax
  802f7d:	19 d6                	sbb    %edx,%esi
  802f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	89 f2                	mov    %esi,%edx
  802f87:	83 c4 20             	add    $0x20,%esp
  802f8a:	5e                   	pop    %esi
  802f8b:	5f                   	pop    %edi
  802f8c:	5d                   	pop    %ebp
  802f8d:	c3                   	ret    
  802f8e:	66 90                	xchg   %ax,%ax
  802f90:	85 ff                	test   %edi,%edi
  802f92:	75 0b                	jne    802f9f <__umoddi3+0x6f>
  802f94:	b8 01 00 00 00       	mov    $0x1,%eax
  802f99:	31 d2                	xor    %edx,%edx
  802f9b:	f7 f7                	div    %edi
  802f9d:	89 c7                	mov    %eax,%edi
  802f9f:	89 f0                	mov    %esi,%eax
  802fa1:	31 d2                	xor    %edx,%edx
  802fa3:	f7 f7                	div    %edi
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	f7 f7                	div    %edi
  802faa:	eb a9                	jmp    802f55 <__umoddi3+0x25>
  802fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fb0:	89 c8                	mov    %ecx,%eax
  802fb2:	89 f2                	mov    %esi,%edx
  802fb4:	83 c4 20             	add    $0x20,%esp
  802fb7:	5e                   	pop    %esi
  802fb8:	5f                   	pop    %edi
  802fb9:	5d                   	pop    %ebp
  802fba:	c3                   	ret    
  802fbb:	90                   	nop
  802fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fc0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fc4:	d3 e2                	shl    %cl,%edx
  802fc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802fc9:	ba 20 00 00 00       	mov    $0x20,%edx
  802fce:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802fd1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802fd4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fd8:	89 fa                	mov    %edi,%edx
  802fda:	d3 ea                	shr    %cl,%edx
  802fdc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fe0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802fe3:	d3 e7                	shl    %cl,%edi
  802fe5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fe9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802fec:	89 f2                	mov    %esi,%edx
  802fee:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802ff1:	89 c7                	mov    %eax,%edi
  802ff3:	d3 ea                	shr    %cl,%edx
  802ff5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ff9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802ffc:	89 c2                	mov    %eax,%edx
  802ffe:	d3 e6                	shl    %cl,%esi
  803000:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803004:	d3 ea                	shr    %cl,%edx
  803006:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80300a:	09 d6                	or     %edx,%esi
  80300c:	89 f0                	mov    %esi,%eax
  80300e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803011:	d3 e7                	shl    %cl,%edi
  803013:	89 f2                	mov    %esi,%edx
  803015:	f7 75 f4             	divl   -0xc(%ebp)
  803018:	89 d6                	mov    %edx,%esi
  80301a:	f7 65 e8             	mull   -0x18(%ebp)
  80301d:	39 d6                	cmp    %edx,%esi
  80301f:	72 2b                	jb     80304c <__umoddi3+0x11c>
  803021:	39 c7                	cmp    %eax,%edi
  803023:	72 23                	jb     803048 <__umoddi3+0x118>
  803025:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803029:	29 c7                	sub    %eax,%edi
  80302b:	19 d6                	sbb    %edx,%esi
  80302d:	89 f0                	mov    %esi,%eax
  80302f:	89 f2                	mov    %esi,%edx
  803031:	d3 ef                	shr    %cl,%edi
  803033:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803037:	d3 e0                	shl    %cl,%eax
  803039:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80303d:	09 f8                	or     %edi,%eax
  80303f:	d3 ea                	shr    %cl,%edx
  803041:	83 c4 20             	add    $0x20,%esp
  803044:	5e                   	pop    %esi
  803045:	5f                   	pop    %edi
  803046:	5d                   	pop    %ebp
  803047:	c3                   	ret    
  803048:	39 d6                	cmp    %edx,%esi
  80304a:	75 d9                	jne    803025 <__umoddi3+0xf5>
  80304c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80304f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803052:	eb d1                	jmp    803025 <__umoddi3+0xf5>
  803054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803058:	39 f2                	cmp    %esi,%edx
  80305a:	0f 82 18 ff ff ff    	jb     802f78 <__umoddi3+0x48>
  803060:	e9 1d ff ff ff       	jmp    802f82 <__umoddi3+0x52>
