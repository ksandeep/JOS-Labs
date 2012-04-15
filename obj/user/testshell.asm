
obj/user/testshell:     file format elf32-i386


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
  80002c:	e8 6b 05 00 00       	call   80059c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80004c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800052:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800055:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800059:	89 3c 24             	mov    %edi,(%esp)
  80005c:	e8 e4 1a 00 00       	call   801b45 <seek>
	seek(kfd, off);
  800061:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800065:	89 34 24             	mov    %esi,(%esp)
  800068:	e8 d8 1a 00 00       	call   801b45 <seek>

	cprintf("shell produced incorrect output.\n");
  80006d:	c7 04 24 a0 36 80 00 	movl   $0x8036a0,(%esp)
  800074:	e8 54 06 00 00       	call   8006cd <cprintf>
	cprintf("expected:\n===\n");
  800079:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  800080:	e8 48 06 00 00       	call   8006cd <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800085:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800088:	eb 0c                	jmp    800096 <wrong+0x56>
		sys_cputs(buf, n);
  80008a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008e:	89 1c 24             	mov    %ebx,(%esp)
  800091:	e8 ea 10 00 00       	call   801180 <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800096:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  80009d:	00 
  80009e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a2:	89 34 24             	mov    %esi,(%esp)
  8000a5:	e8 b4 1c 00 00       	call   801d5e <read>
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	7f dc                	jg     80008a <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000ae:	c7 04 24 4a 37 80 00 	movl   $0x80374a,(%esp)
  8000b5:	e8 13 06 00 00       	call   8006cd <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ba:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000bd:	eb 0c                	jmp    8000cb <wrong+0x8b>
		sys_cputs(buf, n);
  8000bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c3:	89 1c 24             	mov    %ebx,(%esp)
  8000c6:	e8 b5 10 00 00       	call   801180 <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000cb:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000d2:	00 
  8000d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d7:	89 3c 24             	mov    %edi,(%esp)
  8000da:	e8 7f 1c 00 00       	call   801d5e <read>
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	7f dc                	jg     8000bf <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000e3:	c7 04 24 45 37 80 00 	movl   $0x803745,(%esp)
  8000ea:	e8 de 05 00 00       	call   8006cd <cprintf>
	exit();
  8000ef:	e8 f8 04 00 00       	call   8005ec <exit>
}
  8000f4:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5f                   	pop    %edi
  8000fd:	5d                   	pop    %ebp
  8000fe:	c3                   	ret    

008000ff <umain>:

void wrong(int, int, int);

void
umain(void)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	57                   	push   %edi
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;

	close(0);
  800108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010f:	e8 aa 1d 00 00       	call   801ebe <close>
	close(1);
  800114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80011b:	e8 9e 1d 00 00       	call   801ebe <close>
	opencons();
  800120:	e8 bb 03 00 00       	call   8004e0 <opencons>
	opencons();
  800125:	e8 b6 03 00 00       	call   8004e0 <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80012a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800131:	00 
  800132:	c7 04 24 58 37 80 00 	movl   $0x803758,(%esp)
  800139:	e8 25 21 00 00       	call   802263 <open>
  80013e:	89 c6                	mov    %eax,%esi
  800140:	85 c0                	test   %eax,%eax
  800142:	79 20                	jns    800164 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800144:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800148:	c7 44 24 08 65 37 80 	movl   $0x803765,0x8(%esp)
  80014f:	00 
  800150:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  800157:	00 
  800158:	c7 04 24 7b 37 80 00 	movl   $0x80377b,(%esp)
  80015f:	e8 a4 04 00 00       	call   800608 <_panic>
	if ((wfd = open("testshell.out", O_WRONLY|O_CREAT|O_TRUNC)) < 0)
  800164:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  80016b:	00 
  80016c:	c7 04 24 8c 37 80 00 	movl   $0x80378c,(%esp)
  800173:	e8 eb 20 00 00       	call   802263 <open>
  800178:	89 c7                	mov    %eax,%edi
  80017a:	85 c0                	test   %eax,%eax
  80017c:	79 20                	jns    80019e <umain+0x9f>
		panic("open testshell.out: %e", wfd);
  80017e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800182:	c7 44 24 08 9a 37 80 	movl   $0x80379a,0x8(%esp)
  800189:	00 
  80018a:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  800191:	00 
  800192:	c7 04 24 7b 37 80 00 	movl   $0x80377b,(%esp)
  800199:	e8 6a 04 00 00       	call   800608 <_panic>

	cprintf("running sh -x < testshell.sh > testshell.out\n");
  80019e:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  8001a5:	e8 23 05 00 00       	call   8006cd <cprintf>
	if ((r = fork()) < 0)
  8001aa:	e8 56 16 00 00       	call   801805 <fork>
  8001af:	89 c3                	mov    %eax,%ebx
  8001b1:	85 c0                	test   %eax,%eax
  8001b3:	79 20                	jns    8001d5 <umain+0xd6>
		panic("fork: %e", r);
  8001b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b9:	c7 44 24 08 b1 37 80 	movl   $0x8037b1,0x8(%esp)
  8001c0:	00 
  8001c1:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  8001c8:	00 
  8001c9:	c7 04 24 7b 37 80 00 	movl   $0x80377b,(%esp)
  8001d0:	e8 33 04 00 00       	call   800608 <_panic>
	if (r == 0) {
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	0f 85 9f 00 00 00    	jne    80027c <umain+0x17d>
		dup(rfd, 0);
  8001dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001e4:	00 
  8001e5:	89 34 24             	mov    %esi,(%esp)
  8001e8:	e8 70 1d 00 00       	call   801f5d <dup>
		dup(wfd, 1);
  8001ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001f4:	00 
  8001f5:	89 3c 24             	mov    %edi,(%esp)
  8001f8:	e8 60 1d 00 00       	call   801f5d <dup>
		close(rfd);
  8001fd:	89 34 24             	mov    %esi,(%esp)
  800200:	e8 b9 1c 00 00       	call   801ebe <close>
		close(wfd);
  800205:	89 3c 24             	mov    %edi,(%esp)
  800208:	e8 b1 1c 00 00       	call   801ebe <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80020d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800214:	00 
  800215:	c7 44 24 08 ba 37 80 	movl   $0x8037ba,0x8(%esp)
  80021c:	00 
  80021d:	c7 44 24 04 62 37 80 	movl   $0x803762,0x4(%esp)
  800224:	00 
  800225:	c7 04 24 bd 37 80 00 	movl   $0x8037bd,(%esp)
  80022c:	e8 de 26 00 00       	call   80290f <spawnl>
  800231:	89 c3                	mov    %eax,%ebx
  800233:	85 c0                	test   %eax,%eax
  800235:	79 20                	jns    800257 <umain+0x158>
			panic("spawn: %e", r);
  800237:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80023b:	c7 44 24 08 c1 37 80 	movl   $0x8037c1,0x8(%esp)
  800242:	00 
  800243:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80024a:	00 
  80024b:	c7 04 24 7b 37 80 00 	movl   $0x80377b,(%esp)
  800252:	e8 b1 03 00 00       	call   800608 <_panic>
		close(0);
  800257:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80025e:	e8 5b 1c 00 00       	call   801ebe <close>
		close(1);
  800263:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80026a:	e8 4f 1c 00 00       	call   801ebe <close>
		wait(r);
  80026f:	89 1c 24             	mov    %ebx,(%esp)
  800272:	e8 6d 2f 00 00       	call   8031e4 <wait>
		exit();
  800277:	e8 70 03 00 00       	call   8005ec <exit>
	}
	close(rfd);
  80027c:	89 34 24             	mov    %esi,(%esp)
  80027f:	e8 3a 1c 00 00       	call   801ebe <close>
	close(wfd);
  800284:	89 3c 24             	mov    %edi,(%esp)
  800287:	e8 32 1c 00 00       	call   801ebe <close>
	wait(r);
  80028c:	89 1c 24             	mov    %ebx,(%esp)
  80028f:	e8 50 2f 00 00       	call   8031e4 <wait>

	if ((rfd = open("testshell.out", O_RDONLY)) < 0)
  800294:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80029b:	00 
  80029c:	c7 04 24 8c 37 80 00 	movl   $0x80378c,(%esp)
  8002a3:	e8 bb 1f 00 00       	call   802263 <open>
  8002a8:	89 c7                	mov    %eax,%edi
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	79 20                	jns    8002ce <umain+0x1cf>
		panic("open testshell.out for reading: %e", rfd);
  8002ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b2:	c7 44 24 08 f4 36 80 	movl   $0x8036f4,0x8(%esp)
  8002b9:	00 
  8002ba:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  8002c1:	00 
  8002c2:	c7 04 24 7b 37 80 00 	movl   $0x80377b,(%esp)
  8002c9:	e8 3a 03 00 00       	call   800608 <_panic>
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002d5:	00 
  8002d6:	c7 04 24 cb 37 80 00 	movl   $0x8037cb,(%esp)
  8002dd:	e8 81 1f 00 00       	call   802263 <open>
  8002e2:	89 c6                	mov    %eax,%esi
  8002e4:	85 c0                	test   %eax,%eax
  8002e6:	79 20                	jns    800308 <umain+0x209>
		panic("open testshell.key for reading: %e", kfd);
  8002e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ec:	c7 44 24 08 18 37 80 	movl   $0x803718,0x8(%esp)
  8002f3:	00 
  8002f4:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002fb:	00 
  8002fc:	c7 04 24 7b 37 80 00 	movl   $0x80377b,(%esp)
  800303:	e8 00 03 00 00       	call   800608 <_panic>
  800308:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  80030f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  800316:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80031d:	00 
  80031e:	8d 45 e7             	lea    -0x19(%ebp),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	89 3c 24             	mov    %edi,(%esp)
  800328:	e8 31 1a 00 00       	call   801d5e <read>
  80032d:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  80032f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800336:	00 
  800337:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  80033a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033e:	89 34 24             	mov    %esi,(%esp)
  800341:	e8 18 1a 00 00       	call   801d5e <read>
		if (n1 < 0)
  800346:	85 db                	test   %ebx,%ebx
  800348:	79 20                	jns    80036a <umain+0x26b>
			panic("reading testshell.out: %e", n1);
  80034a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80034e:	c7 44 24 08 d9 37 80 	movl   $0x8037d9,0x8(%esp)
  800355:	00 
  800356:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80035d:	00 
  80035e:	c7 04 24 7b 37 80 00 	movl   $0x80377b,(%esp)
  800365:	e8 9e 02 00 00       	call   800608 <_panic>
		if (n2 < 0)
  80036a:	85 c0                	test   %eax,%eax
  80036c:	79 20                	jns    80038e <umain+0x28f>
			panic("reading testshell.key: %e", n2);
  80036e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800372:	c7 44 24 08 f3 37 80 	movl   $0x8037f3,0x8(%esp)
  800379:	00 
  80037a:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800381:	00 
  800382:	c7 04 24 7b 37 80 00 	movl   $0x80377b,(%esp)
  800389:	e8 7a 02 00 00       	call   800608 <_panic>
		if (n1 == 0 && n2 == 0)
  80038e:	85 c0                	test   %eax,%eax
  800390:	75 04                	jne    800396 <umain+0x297>
  800392:	85 db                	test   %ebx,%ebx
  800394:	74 3d                	je     8003d3 <umain+0x2d4>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800396:	83 fb 01             	cmp    $0x1,%ebx
  800399:	75 10                	jne    8003ab <umain+0x2ac>
  80039b:	83 f8 01             	cmp    $0x1,%eax
  80039e:	66 90                	xchg   %ax,%ax
  8003a0:	75 09                	jne    8003ab <umain+0x2ac>
  8003a2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  8003a6:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  8003a9:	74 13                	je     8003be <umain+0x2bf>
			wrong(rfd, kfd, nloff);
  8003ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b6:	89 3c 24             	mov    %edi,(%esp)
  8003b9:	e8 82 fc ff ff       	call   800040 <wrong>
		if (c1 == '\n')
  8003be:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8003c2:	75 06                	jne    8003ca <umain+0x2cb>
  8003c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ca:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			nloff = off+1;
	}
  8003ce:	e9 43 ff ff ff       	jmp    800316 <umain+0x217>
	cprintf("shell ran correctly\n");			
  8003d3:	c7 04 24 0d 38 80 00 	movl   $0x80380d,(%esp)
  8003da:	e8 ee 02 00 00       	call   8006cd <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8003df:	cc                   	int3   

	breakpoint();
}
  8003e0:	83 c4 3c             	add    $0x3c,%esp
  8003e3:	5b                   	pop    %ebx
  8003e4:	5e                   	pop    %esi
  8003e5:	5f                   	pop    %edi
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    
	...

008003f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f8:	5d                   	pop    %ebp
  8003f9:	c3                   	ret    

008003fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800400:	c7 44 24 04 22 38 80 	movl   $0x803822,0x4(%esp)
  800407:	00 
  800408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040b:	89 04 24             	mov    %eax,(%esp)
  80040e:	e8 77 09 00 00       	call   800d8a <strcpy>
	return 0;
}
  800413:	b8 00 00 00 00       	mov    $0x0,%eax
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	57                   	push   %edi
  80041e:	56                   	push   %esi
  80041f:	53                   	push   %ebx
  800420:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	be 00 00 00 00       	mov    $0x0,%esi
  800430:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800434:	74 3f                	je     800475 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800436:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80043c:	8b 55 10             	mov    0x10(%ebp),%edx
  80043f:	29 c2                	sub    %eax,%edx
  800441:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  800443:	83 fa 7f             	cmp    $0x7f,%edx
  800446:	76 05                	jbe    80044d <devcons_write+0x33>
  800448:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80044d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800451:	03 45 0c             	add    0xc(%ebp),%eax
  800454:	89 44 24 04          	mov    %eax,0x4(%esp)
  800458:	89 3c 24             	mov    %edi,(%esp)
  80045b:	e8 e5 0a 00 00       	call   800f45 <memmove>
		sys_cputs(buf, m);
  800460:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800464:	89 3c 24             	mov    %edi,(%esp)
  800467:	e8 14 0d 00 00       	call   801180 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80046c:	01 de                	add    %ebx,%esi
  80046e:	89 f0                	mov    %esi,%eax
  800470:	3b 75 10             	cmp    0x10(%ebp),%esi
  800473:	72 c7                	jb     80043c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800475:	89 f0                	mov    %esi,%eax
  800477:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80047d:	5b                   	pop    %ebx
  80047e:	5e                   	pop    %esi
  80047f:	5f                   	pop    %edi
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80048e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800495:	00 
  800496:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800499:	89 04 24             	mov    %eax,(%esp)
  80049c:	e8 df 0c 00 00       	call   801180 <sys_cputs>
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8004a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8004ad:	75 07                	jne    8004b6 <devcons_read+0x13>
  8004af:	eb 28                	jmp    8004d9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8004b1:	e8 24 11 00 00       	call   8015da <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8004b6:	66 90                	xchg   %ax,%ax
  8004b8:	e8 8f 0c 00 00       	call   80114c <sys_cgetc>
  8004bd:	85 c0                	test   %eax,%eax
  8004bf:	90                   	nop
  8004c0:	74 ef                	je     8004b1 <devcons_read+0xe>
  8004c2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8004c4:	85 c0                	test   %eax,%eax
  8004c6:	78 16                	js     8004de <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8004c8:	83 f8 04             	cmp    $0x4,%eax
  8004cb:	74 0c                	je     8004d9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	88 10                	mov    %dl,(%eax)
  8004d2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8004d7:	eb 05                	jmp    8004de <devcons_read+0x3b>
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004e9:	89 04 24             	mov    %eax,(%esp)
  8004ec:	e8 9a 15 00 00       	call   801a8b <fd_alloc>
  8004f1:	85 c0                	test   %eax,%eax
  8004f3:	78 3f                	js     800534 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004f5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8004fc:	00 
  8004fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800500:	89 44 24 04          	mov    %eax,0x4(%esp)
  800504:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80050b:	e8 6b 10 00 00       	call   80157b <sys_page_alloc>
  800510:	85 c0                	test   %eax,%eax
  800512:	78 20                	js     800534 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800514:	8b 15 00 70 80 00    	mov    0x807000,%edx
  80051a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80051f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800522:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052c:	89 04 24             	mov    %eax,(%esp)
  80052f:	e8 2c 15 00 00       	call   801a60 <fd2num>
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80053c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80053f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 04 24             	mov    %eax,(%esp)
  800549:	e8 af 15 00 00       	call   801afd <fd_lookup>
  80054e:	85 c0                	test   %eax,%eax
  800550:	78 11                	js     800563 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	3b 05 00 70 80 00    	cmp    0x807000,%eax
  80055d:	0f 94 c0             	sete   %al
  800560:	0f b6 c0             	movzbl %al,%eax
}
  800563:	c9                   	leave  
  800564:	c3                   	ret    

00800565 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80056b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800572:	00 
  800573:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800576:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800581:	e8 d8 17 00 00       	call   801d5e <read>
	if (r < 0)
  800586:	85 c0                	test   %eax,%eax
  800588:	78 0f                	js     800599 <getchar+0x34>
		return r;
	if (r < 1)
  80058a:	85 c0                	test   %eax,%eax
  80058c:	7f 07                	jg     800595 <getchar+0x30>
  80058e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800593:	eb 04                	jmp    800599 <getchar+0x34>
		return -E_EOF;
	return c;
  800595:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800599:	c9                   	leave  
  80059a:	c3                   	ret    
	...

0080059c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 18             	sub    $0x18,%esp
  8005a2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8005a5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8005a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8005ae:	e8 5b 10 00 00       	call   80160e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8005b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c5:	85 f6                	test   %esi,%esi
  8005c7:	7e 07                	jle    8005d0 <libmain+0x34>
		binaryname = argv[0];
  8005c9:	8b 03                	mov    (%ebx),%eax
  8005cb:	a3 1c 70 80 00       	mov    %eax,0x80701c

	// call user main routine
	umain(argc, argv);
  8005d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d4:	89 34 24             	mov    %esi,(%esp)
  8005d7:	e8 23 fb ff ff       	call   8000ff <umain>

	// exit gracefully
	exit();
  8005dc:	e8 0b 00 00 00       	call   8005ec <exit>
}
  8005e1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8005e4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8005e7:	89 ec                	mov    %ebp,%esp
  8005e9:	5d                   	pop    %ebp
  8005ea:	c3                   	ret    
	...

008005ec <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005f2:	e8 44 19 00 00       	call   801f3b <close_all>
	sys_env_destroy(0);
  8005f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005fe:	e8 3f 10 00 00       	call   801642 <sys_env_destroy>
}
  800603:	c9                   	leave  
  800604:	c3                   	ret    
  800605:	00 00                	add    %al,(%eax)
	...

00800608 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  80060b:	53                   	push   %ebx
  80060c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80060f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800612:	a1 78 70 80 00       	mov    0x807078,%eax
  800617:	85 c0                	test   %eax,%eax
  800619:	74 10                	je     80062b <_panic+0x23>
		cprintf("%s: ", argv0);
  80061b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061f:	c7 04 24 45 38 80 00 	movl   $0x803845,(%esp)
  800626:	e8 a2 00 00 00       	call   8006cd <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	89 44 24 08          	mov    %eax,0x8(%esp)
  800639:	a1 1c 70 80 00       	mov    0x80701c,%eax
  80063e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800642:	c7 04 24 4a 38 80 00 	movl   $0x80384a,(%esp)
  800649:	e8 7f 00 00 00       	call   8006cd <cprintf>
	vcprintf(fmt, ap);
  80064e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800652:	8b 45 10             	mov    0x10(%ebp),%eax
  800655:	89 04 24             	mov    %eax,(%esp)
  800658:	e8 0f 00 00 00       	call   80066c <vcprintf>
	cprintf("\n");
  80065d:	c7 04 24 48 37 80 00 	movl   $0x803748,(%esp)
  800664:	e8 64 00 00 00       	call   8006cd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800669:	cc                   	int3   
  80066a:	eb fd                	jmp    800669 <_panic+0x61>

0080066c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800675:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80067c:	00 00 00 
	b.cnt = 0;
  80067f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800686:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 44 24 08          	mov    %eax,0x8(%esp)
  800697:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80069d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a1:	c7 04 24 e7 06 80 00 	movl   $0x8006e7,(%esp)
  8006a8:	e8 d0 01 00 00       	call   80087d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006ad:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006bd:	89 04 24             	mov    %eax,(%esp)
  8006c0:	e8 bb 0a 00 00       	call   801180 <sys_cputs>

	return b.cnt;
}
  8006c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006cb:	c9                   	leave  
  8006cc:	c3                   	ret    

008006cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
  8006d0:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8006d3:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8006d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	89 04 24             	mov    %eax,(%esp)
  8006e0:	e8 87 ff ff ff       	call   80066c <vcprintf>
	va_end(ap);

	return cnt;
}
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    

008006e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	53                   	push   %ebx
  8006eb:	83 ec 14             	sub    $0x14,%esp
  8006ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006f1:	8b 03                	mov    (%ebx),%eax
  8006f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8006fa:	83 c0 01             	add    $0x1,%eax
  8006fd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8006ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800704:	75 19                	jne    80071f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800706:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80070d:	00 
  80070e:	8d 43 08             	lea    0x8(%ebx),%eax
  800711:	89 04 24             	mov    %eax,(%esp)
  800714:	e8 67 0a 00 00       	call   801180 <sys_cputs>
		b->idx = 0;
  800719:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80071f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800723:	83 c4 14             	add    $0x14,%esp
  800726:	5b                   	pop    %ebx
  800727:	5d                   	pop    %ebp
  800728:	c3                   	ret    
  800729:	00 00                	add    %al,(%eax)
  80072b:	00 00                	add    %al,(%eax)
  80072d:	00 00                	add    %al,(%eax)
	...

00800730 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	57                   	push   %edi
  800734:	56                   	push   %esi
  800735:	53                   	push   %ebx
  800736:	83 ec 4c             	sub    $0x4c,%esp
  800739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073c:	89 d6                	mov    %edx,%esi
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	8b 55 0c             	mov    0xc(%ebp),%edx
  800747:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80074a:	8b 45 10             	mov    0x10(%ebp),%eax
  80074d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800750:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800753:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800756:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075b:	39 d1                	cmp    %edx,%ecx
  80075d:	72 15                	jb     800774 <printnum+0x44>
  80075f:	77 07                	ja     800768 <printnum+0x38>
  800761:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800764:	39 d0                	cmp    %edx,%eax
  800766:	76 0c                	jbe    800774 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800768:	83 eb 01             	sub    $0x1,%ebx
  80076b:	85 db                	test   %ebx,%ebx
  80076d:	8d 76 00             	lea    0x0(%esi),%esi
  800770:	7f 61                	jg     8007d3 <printnum+0xa3>
  800772:	eb 70                	jmp    8007e4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800774:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800778:	83 eb 01             	sub    $0x1,%ebx
  80077b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80077f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800783:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800787:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80078b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80078e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800791:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800794:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800798:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80079f:	00 
  8007a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007a3:	89 04 24             	mov    %eax,(%esp)
  8007a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007ad:	e8 7e 2c 00 00       	call   803430 <__udivdi3>
  8007b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007c0:	89 04 24             	mov    %eax,(%esp)
  8007c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007c7:	89 f2                	mov    %esi,%edx
  8007c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007cc:	e8 5f ff ff ff       	call   800730 <printnum>
  8007d1:	eb 11                	jmp    8007e4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d7:	89 3c 24             	mov    %edi,(%esp)
  8007da:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007dd:	83 eb 01             	sub    $0x1,%ebx
  8007e0:	85 db                	test   %ebx,%ebx
  8007e2:	7f ef                	jg     8007d3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8007ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007fa:	00 
  8007fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007fe:	89 14 24             	mov    %edx,(%esp)
  800801:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800804:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800808:	e8 53 2d 00 00       	call   803560 <__umoddi3>
  80080d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800811:	0f be 80 66 38 80 00 	movsbl 0x803866(%eax),%eax
  800818:	89 04 24             	mov    %eax,(%esp)
  80081b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80081e:	83 c4 4c             	add    $0x4c,%esp
  800821:	5b                   	pop    %ebx
  800822:	5e                   	pop    %esi
  800823:	5f                   	pop    %edi
  800824:	5d                   	pop    %ebp
  800825:	c3                   	ret    

00800826 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800829:	83 fa 01             	cmp    $0x1,%edx
  80082c:	7e 0e                	jle    80083c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80082e:	8b 10                	mov    (%eax),%edx
  800830:	8d 4a 08             	lea    0x8(%edx),%ecx
  800833:	89 08                	mov    %ecx,(%eax)
  800835:	8b 02                	mov    (%edx),%eax
  800837:	8b 52 04             	mov    0x4(%edx),%edx
  80083a:	eb 22                	jmp    80085e <getuint+0x38>
	else if (lflag)
  80083c:	85 d2                	test   %edx,%edx
  80083e:	74 10                	je     800850 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800840:	8b 10                	mov    (%eax),%edx
  800842:	8d 4a 04             	lea    0x4(%edx),%ecx
  800845:	89 08                	mov    %ecx,(%eax)
  800847:	8b 02                	mov    (%edx),%eax
  800849:	ba 00 00 00 00       	mov    $0x0,%edx
  80084e:	eb 0e                	jmp    80085e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800850:	8b 10                	mov    (%eax),%edx
  800852:	8d 4a 04             	lea    0x4(%edx),%ecx
  800855:	89 08                	mov    %ecx,(%eax)
  800857:	8b 02                	mov    (%edx),%eax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80085e:	5d                   	pop    %ebp
  80085f:	c3                   	ret    

00800860 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800866:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80086a:	8b 10                	mov    (%eax),%edx
  80086c:	3b 50 04             	cmp    0x4(%eax),%edx
  80086f:	73 0a                	jae    80087b <sprintputch+0x1b>
		*b->buf++ = ch;
  800871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800874:	88 0a                	mov    %cl,(%edx)
  800876:	83 c2 01             	add    $0x1,%edx
  800879:	89 10                	mov    %edx,(%eax)
}
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	57                   	push   %edi
  800881:	56                   	push   %esi
  800882:	53                   	push   %ebx
  800883:	83 ec 5c             	sub    $0x5c,%esp
  800886:	8b 7d 08             	mov    0x8(%ebp),%edi
  800889:	8b 75 0c             	mov    0xc(%ebp),%esi
  80088c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800896:	eb 11                	jmp    8008a9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800898:	85 c0                	test   %eax,%eax
  80089a:	0f 84 ec 03 00 00    	je     800c8c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8008a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008a4:	89 04 24             	mov    %eax,(%esp)
  8008a7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a9:	0f b6 03             	movzbl (%ebx),%eax
  8008ac:	83 c3 01             	add    $0x1,%ebx
  8008af:	83 f8 25             	cmp    $0x25,%eax
  8008b2:	75 e4                	jne    800898 <vprintfmt+0x1b>
  8008b4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8008b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8008bf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8008c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8008cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008d2:	eb 06                	jmp    8008da <vprintfmt+0x5d>
  8008d4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8008d8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008da:	0f b6 13             	movzbl (%ebx),%edx
  8008dd:	0f b6 c2             	movzbl %dl,%eax
  8008e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008e3:	8d 43 01             	lea    0x1(%ebx),%eax
  8008e6:	83 ea 23             	sub    $0x23,%edx
  8008e9:	80 fa 55             	cmp    $0x55,%dl
  8008ec:	0f 87 7d 03 00 00    	ja     800c6f <vprintfmt+0x3f2>
  8008f2:	0f b6 d2             	movzbl %dl,%edx
  8008f5:	ff 24 95 a0 39 80 00 	jmp    *0x8039a0(,%edx,4)
  8008fc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800900:	eb d6                	jmp    8008d8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800902:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800905:	83 ea 30             	sub    $0x30,%edx
  800908:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80090b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80090e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800911:	83 fb 09             	cmp    $0x9,%ebx
  800914:	77 4c                	ja     800962 <vprintfmt+0xe5>
  800916:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800919:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80091f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800922:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800926:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800929:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80092c:	83 fb 09             	cmp    $0x9,%ebx
  80092f:	76 eb                	jbe    80091c <vprintfmt+0x9f>
  800931:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800934:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800937:	eb 29                	jmp    800962 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800939:	8b 55 14             	mov    0x14(%ebp),%edx
  80093c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80093f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800942:	8b 12                	mov    (%edx),%edx
  800944:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800947:	eb 19                	jmp    800962 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80094c:	c1 fa 1f             	sar    $0x1f,%edx
  80094f:	f7 d2                	not    %edx
  800951:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800954:	eb 82                	jmp    8008d8 <vprintfmt+0x5b>
  800956:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80095d:	e9 76 ff ff ff       	jmp    8008d8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800962:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800966:	0f 89 6c ff ff ff    	jns    8008d8 <vprintfmt+0x5b>
  80096c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80096f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800972:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800975:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800978:	e9 5b ff ff ff       	jmp    8008d8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80097d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800980:	e9 53 ff ff ff       	jmp    8008d8 <vprintfmt+0x5b>
  800985:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	8d 50 04             	lea    0x4(%eax),%edx
  80098e:	89 55 14             	mov    %edx,0x14(%ebp)
  800991:	89 74 24 04          	mov    %esi,0x4(%esp)
  800995:	8b 00                	mov    (%eax),%eax
  800997:	89 04 24             	mov    %eax,(%esp)
  80099a:	ff d7                	call   *%edi
  80099c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80099f:	e9 05 ff ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  8009a4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	8d 50 04             	lea    0x4(%eax),%edx
  8009ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	89 c2                	mov    %eax,%edx
  8009b4:	c1 fa 1f             	sar    $0x1f,%edx
  8009b7:	31 d0                	xor    %edx,%eax
  8009b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009bb:	83 f8 0f             	cmp    $0xf,%eax
  8009be:	7f 0b                	jg     8009cb <vprintfmt+0x14e>
  8009c0:	8b 14 85 00 3b 80 00 	mov    0x803b00(,%eax,4),%edx
  8009c7:	85 d2                	test   %edx,%edx
  8009c9:	75 20                	jne    8009eb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8009cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009cf:	c7 44 24 08 77 38 80 	movl   $0x803877,0x8(%esp)
  8009d6:	00 
  8009d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009db:	89 3c 24             	mov    %edi,(%esp)
  8009de:	e8 31 03 00 00       	call   800d14 <printfmt>
  8009e3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009e6:	e9 be fe ff ff       	jmp    8008a9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009ef:	c7 44 24 08 38 3e 80 	movl   $0x803e38,0x8(%esp)
  8009f6:	00 
  8009f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009fb:	89 3c 24             	mov    %edi,(%esp)
  8009fe:	e8 11 03 00 00       	call   800d14 <printfmt>
  800a03:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a06:	e9 9e fe ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  800a0b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800a0e:	89 c3                	mov    %eax,%ebx
  800a10:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8d 50 04             	lea    0x4(%eax),%edx
  800a1f:	89 55 14             	mov    %edx,0x14(%ebp)
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a27:	85 c0                	test   %eax,%eax
  800a29:	75 07                	jne    800a32 <vprintfmt+0x1b5>
  800a2b:	c7 45 e0 80 38 80 00 	movl   $0x803880,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800a32:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800a36:	7e 06                	jle    800a3e <vprintfmt+0x1c1>
  800a38:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800a3c:	75 13                	jne    800a51 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a41:	0f be 02             	movsbl (%edx),%eax
  800a44:	85 c0                	test   %eax,%eax
  800a46:	0f 85 99 00 00 00    	jne    800ae5 <vprintfmt+0x268>
  800a4c:	e9 86 00 00 00       	jmp    800ad7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a55:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a58:	89 0c 24             	mov    %ecx,(%esp)
  800a5b:	e8 fb 02 00 00       	call   800d5b <strnlen>
  800a60:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a63:	29 c2                	sub    %eax,%edx
  800a65:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a68:	85 d2                	test   %edx,%edx
  800a6a:	7e d2                	jle    800a3e <vprintfmt+0x1c1>
					putch(padc, putdat);
  800a6c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800a70:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800a73:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800a76:	89 d3                	mov    %edx,%ebx
  800a78:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a7f:	89 04 24             	mov    %eax,(%esp)
  800a82:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a84:	83 eb 01             	sub    $0x1,%ebx
  800a87:	85 db                	test   %ebx,%ebx
  800a89:	7f ed                	jg     800a78 <vprintfmt+0x1fb>
  800a8b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a8e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800a95:	eb a7                	jmp    800a3e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a97:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a9b:	74 18                	je     800ab5 <vprintfmt+0x238>
  800a9d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800aa0:	83 fa 5e             	cmp    $0x5e,%edx
  800aa3:	76 10                	jbe    800ab5 <vprintfmt+0x238>
					putch('?', putdat);
  800aa5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aa9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800ab0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ab3:	eb 0a                	jmp    800abf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800ab5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab9:	89 04 24             	mov    %eax,(%esp)
  800abc:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800abf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800ac3:	0f be 03             	movsbl (%ebx),%eax
  800ac6:	85 c0                	test   %eax,%eax
  800ac8:	74 05                	je     800acf <vprintfmt+0x252>
  800aca:	83 c3 01             	add    $0x1,%ebx
  800acd:	eb 29                	jmp    800af8 <vprintfmt+0x27b>
  800acf:	89 fe                	mov    %edi,%esi
  800ad1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800ad4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adb:	7f 2e                	jg     800b0b <vprintfmt+0x28e>
  800add:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800ae0:	e9 c4 fd ff ff       	jmp    8008a9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ae5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae8:	83 c2 01             	add    $0x1,%edx
  800aeb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800aee:	89 f7                	mov    %esi,%edi
  800af0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800af3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800af6:	89 d3                	mov    %edx,%ebx
  800af8:	85 f6                	test   %esi,%esi
  800afa:	78 9b                	js     800a97 <vprintfmt+0x21a>
  800afc:	83 ee 01             	sub    $0x1,%esi
  800aff:	79 96                	jns    800a97 <vprintfmt+0x21a>
  800b01:	89 fe                	mov    %edi,%esi
  800b03:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800b06:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800b09:	eb cc                	jmp    800ad7 <vprintfmt+0x25a>
  800b0b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800b0e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800b11:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b15:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800b1c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b1e:	83 eb 01             	sub    $0x1,%ebx
  800b21:	85 db                	test   %ebx,%ebx
  800b23:	7f ec                	jg     800b11 <vprintfmt+0x294>
  800b25:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800b28:	e9 7c fd ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  800b2d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b30:	83 f9 01             	cmp    $0x1,%ecx
  800b33:	7e 16                	jle    800b4b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	8d 50 08             	lea    0x8(%eax),%edx
  800b3b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b3e:	8b 10                	mov    (%eax),%edx
  800b40:	8b 48 04             	mov    0x4(%eax),%ecx
  800b43:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800b46:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b49:	eb 32                	jmp    800b7d <vprintfmt+0x300>
	else if (lflag)
  800b4b:	85 c9                	test   %ecx,%ecx
  800b4d:	74 18                	je     800b67 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	8d 50 04             	lea    0x4(%eax),%edx
  800b55:	89 55 14             	mov    %edx,0x14(%ebp)
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5d:	89 c1                	mov    %eax,%ecx
  800b5f:	c1 f9 1f             	sar    $0x1f,%ecx
  800b62:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b65:	eb 16                	jmp    800b7d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800b67:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6a:	8d 50 04             	lea    0x4(%eax),%edx
  800b6d:	89 55 14             	mov    %edx,0x14(%ebp)
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	c1 fa 1f             	sar    $0x1f,%edx
  800b7a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800b80:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800b83:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800b88:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b8c:	0f 89 9b 00 00 00    	jns    800c2d <vprintfmt+0x3b0>
				putch('-', putdat);
  800b92:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b96:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b9d:	ff d7                	call   *%edi
				num = -(long long) num;
  800b9f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800ba2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800ba5:	f7 d9                	neg    %ecx
  800ba7:	83 d3 00             	adc    $0x0,%ebx
  800baa:	f7 db                	neg    %ebx
  800bac:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb1:	eb 7a                	jmp    800c2d <vprintfmt+0x3b0>
  800bb3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bb6:	89 ca                	mov    %ecx,%edx
  800bb8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbb:	e8 66 fc ff ff       	call   800826 <getuint>
  800bc0:	89 c1                	mov    %eax,%ecx
  800bc2:	89 d3                	mov    %edx,%ebx
  800bc4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800bc9:	eb 62                	jmp    800c2d <vprintfmt+0x3b0>
  800bcb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  800bce:	89 ca                	mov    %ecx,%edx
  800bd0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd3:	e8 4e fc ff ff       	call   800826 <getuint>
  800bd8:	89 c1                	mov    %eax,%ecx
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800be1:	eb 4a                	jmp    800c2d <vprintfmt+0x3b0>
  800be3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800be6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bea:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bf1:	ff d7                	call   *%edi
			putch('x', putdat);
  800bf3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bf7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800bfe:	ff d7                	call   *%edi
			num = (unsigned long long)
  800c00:	8b 45 14             	mov    0x14(%ebp),%eax
  800c03:	8d 50 04             	lea    0x4(%eax),%edx
  800c06:	89 55 14             	mov    %edx,0x14(%ebp)
  800c09:	8b 08                	mov    (%eax),%ecx
  800c0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c10:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800c15:	eb 16                	jmp    800c2d <vprintfmt+0x3b0>
  800c17:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c1a:	89 ca                	mov    %ecx,%edx
  800c1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c1f:	e8 02 fc ff ff       	call   800826 <getuint>
  800c24:	89 c1                	mov    %eax,%ecx
  800c26:	89 d3                	mov    %edx,%ebx
  800c28:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c2d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800c31:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c38:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c40:	89 0c 24             	mov    %ecx,(%esp)
  800c43:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c47:	89 f2                	mov    %esi,%edx
  800c49:	89 f8                	mov    %edi,%eax
  800c4b:	e8 e0 fa ff ff       	call   800730 <printnum>
  800c50:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800c53:	e9 51 fc ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  800c58:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800c5b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c5e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c62:	89 14 24             	mov    %edx,(%esp)
  800c65:	ff d7                	call   *%edi
  800c67:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800c6a:	e9 3a fc ff ff       	jmp    8008a9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c73:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c7a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800c7f:	80 38 25             	cmpb   $0x25,(%eax)
  800c82:	0f 84 21 fc ff ff    	je     8008a9 <vprintfmt+0x2c>
  800c88:	89 c3                	mov    %eax,%ebx
  800c8a:	eb f0                	jmp    800c7c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  800c8c:	83 c4 5c             	add    $0x5c,%esp
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 28             	sub    $0x28,%esp
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	74 04                	je     800ca8 <vsnprintf+0x14>
  800ca4:	85 d2                	test   %edx,%edx
  800ca6:	7f 07                	jg     800caf <vsnprintf+0x1b>
  800ca8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cad:	eb 3b                	jmp    800cea <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800caf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd5:	c7 04 24 60 08 80 00 	movl   $0x800860,(%esp)
  800cdc:	e8 9c fb ff ff       	call   80087d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cea:	c9                   	leave  
  800ceb:	c3                   	ret    

00800cec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800cf2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800cf5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 04 24             	mov    %eax,(%esp)
  800d0d:	e8 82 ff ff ff       	call   800c94 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d12:	c9                   	leave  
  800d13:	c3                   	ret    

00800d14 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800d1a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800d1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 04 24             	mov    %eax,(%esp)
  800d35:	e8 43 fb ff ff       	call   80087d <vprintfmt>
	va_end(ap);
}
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    
  800d3c:	00 00                	add    %al,(%eax)
	...

00800d40 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d46:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4b:	80 3a 00             	cmpb   $0x0,(%edx)
  800d4e:	74 09                	je     800d59 <strlen+0x19>
		n++;
  800d50:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d57:	75 f7                	jne    800d50 <strlen+0x10>
		n++;
	return n;
}
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	53                   	push   %ebx
  800d5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d65:	85 c9                	test   %ecx,%ecx
  800d67:	74 19                	je     800d82 <strnlen+0x27>
  800d69:	80 3b 00             	cmpb   $0x0,(%ebx)
  800d6c:	74 14                	je     800d82 <strnlen+0x27>
  800d6e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800d73:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d76:	39 c8                	cmp    %ecx,%eax
  800d78:	74 0d                	je     800d87 <strnlen+0x2c>
  800d7a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800d7e:	75 f3                	jne    800d73 <strnlen+0x18>
  800d80:	eb 05                	jmp    800d87 <strnlen+0x2c>
  800d82:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800d87:	5b                   	pop    %ebx
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	53                   	push   %ebx
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d94:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d99:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800d9d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800da0:	83 c2 01             	add    $0x1,%edx
  800da3:	84 c9                	test   %cl,%cl
  800da5:	75 f2                	jne    800d99 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800da7:	5b                   	pop    %ebx
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db8:	85 f6                	test   %esi,%esi
  800dba:	74 18                	je     800dd4 <strncpy+0x2a>
  800dbc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800dc1:	0f b6 1a             	movzbl (%edx),%ebx
  800dc4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800dc7:	80 3a 01             	cmpb   $0x1,(%edx)
  800dca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dcd:	83 c1 01             	add    $0x1,%ecx
  800dd0:	39 ce                	cmp    %ecx,%esi
  800dd2:	77 ed                	ja     800dc1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	8b 75 08             	mov    0x8(%ebp),%esi
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800de6:	89 f0                	mov    %esi,%eax
  800de8:	85 c9                	test   %ecx,%ecx
  800dea:	74 27                	je     800e13 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800dec:	83 e9 01             	sub    $0x1,%ecx
  800def:	74 1d                	je     800e0e <strlcpy+0x36>
  800df1:	0f b6 1a             	movzbl (%edx),%ebx
  800df4:	84 db                	test   %bl,%bl
  800df6:	74 16                	je     800e0e <strlcpy+0x36>
			*dst++ = *src++;
  800df8:	88 18                	mov    %bl,(%eax)
  800dfa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dfd:	83 e9 01             	sub    $0x1,%ecx
  800e00:	74 0e                	je     800e10 <strlcpy+0x38>
			*dst++ = *src++;
  800e02:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e05:	0f b6 1a             	movzbl (%edx),%ebx
  800e08:	84 db                	test   %bl,%bl
  800e0a:	75 ec                	jne    800df8 <strlcpy+0x20>
  800e0c:	eb 02                	jmp    800e10 <strlcpy+0x38>
  800e0e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800e10:	c6 00 00             	movb   $0x0,(%eax)
  800e13:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e22:	0f b6 01             	movzbl (%ecx),%eax
  800e25:	84 c0                	test   %al,%al
  800e27:	74 15                	je     800e3e <strcmp+0x25>
  800e29:	3a 02                	cmp    (%edx),%al
  800e2b:	75 11                	jne    800e3e <strcmp+0x25>
		p++, q++;
  800e2d:	83 c1 01             	add    $0x1,%ecx
  800e30:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e33:	0f b6 01             	movzbl (%ecx),%eax
  800e36:	84 c0                	test   %al,%al
  800e38:	74 04                	je     800e3e <strcmp+0x25>
  800e3a:	3a 02                	cmp    (%edx),%al
  800e3c:	74 ef                	je     800e2d <strcmp+0x14>
  800e3e:	0f b6 c0             	movzbl %al,%eax
  800e41:	0f b6 12             	movzbl (%edx),%edx
  800e44:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	53                   	push   %ebx
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e52:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	74 23                	je     800e7c <strncmp+0x34>
  800e59:	0f b6 1a             	movzbl (%edx),%ebx
  800e5c:	84 db                	test   %bl,%bl
  800e5e:	74 24                	je     800e84 <strncmp+0x3c>
  800e60:	3a 19                	cmp    (%ecx),%bl
  800e62:	75 20                	jne    800e84 <strncmp+0x3c>
  800e64:	83 e8 01             	sub    $0x1,%eax
  800e67:	74 13                	je     800e7c <strncmp+0x34>
		n--, p++, q++;
  800e69:	83 c2 01             	add    $0x1,%edx
  800e6c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e6f:	0f b6 1a             	movzbl (%edx),%ebx
  800e72:	84 db                	test   %bl,%bl
  800e74:	74 0e                	je     800e84 <strncmp+0x3c>
  800e76:	3a 19                	cmp    (%ecx),%bl
  800e78:	74 ea                	je     800e64 <strncmp+0x1c>
  800e7a:	eb 08                	jmp    800e84 <strncmp+0x3c>
  800e7c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e81:	5b                   	pop    %ebx
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e84:	0f b6 02             	movzbl (%edx),%eax
  800e87:	0f b6 11             	movzbl (%ecx),%edx
  800e8a:	29 d0                	sub    %edx,%eax
  800e8c:	eb f3                	jmp    800e81 <strncmp+0x39>

00800e8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e98:	0f b6 10             	movzbl (%eax),%edx
  800e9b:	84 d2                	test   %dl,%dl
  800e9d:	74 15                	je     800eb4 <strchr+0x26>
		if (*s == c)
  800e9f:	38 ca                	cmp    %cl,%dl
  800ea1:	75 07                	jne    800eaa <strchr+0x1c>
  800ea3:	eb 14                	jmp    800eb9 <strchr+0x2b>
  800ea5:	38 ca                	cmp    %cl,%dl
  800ea7:	90                   	nop
  800ea8:	74 0f                	je     800eb9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eaa:	83 c0 01             	add    $0x1,%eax
  800ead:	0f b6 10             	movzbl (%eax),%edx
  800eb0:	84 d2                	test   %dl,%dl
  800eb2:	75 f1                	jne    800ea5 <strchr+0x17>
  800eb4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ec5:	0f b6 10             	movzbl (%eax),%edx
  800ec8:	84 d2                	test   %dl,%dl
  800eca:	74 18                	je     800ee4 <strfind+0x29>
		if (*s == c)
  800ecc:	38 ca                	cmp    %cl,%dl
  800ece:	75 0a                	jne    800eda <strfind+0x1f>
  800ed0:	eb 12                	jmp    800ee4 <strfind+0x29>
  800ed2:	38 ca                	cmp    %cl,%dl
  800ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ed8:	74 0a                	je     800ee4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800eda:	83 c0 01             	add    $0x1,%eax
  800edd:	0f b6 10             	movzbl (%eax),%edx
  800ee0:	84 d2                	test   %dl,%dl
  800ee2:	75 ee                	jne    800ed2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 0c             	sub    $0xc,%esp
  800eec:	89 1c 24             	mov    %ebx,(%esp)
  800eef:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ef3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ef7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f00:	85 c9                	test   %ecx,%ecx
  800f02:	74 30                	je     800f34 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f0a:	75 25                	jne    800f31 <memset+0x4b>
  800f0c:	f6 c1 03             	test   $0x3,%cl
  800f0f:	75 20                	jne    800f31 <memset+0x4b>
		c &= 0xFF;
  800f11:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f14:	89 d3                	mov    %edx,%ebx
  800f16:	c1 e3 08             	shl    $0x8,%ebx
  800f19:	89 d6                	mov    %edx,%esi
  800f1b:	c1 e6 18             	shl    $0x18,%esi
  800f1e:	89 d0                	mov    %edx,%eax
  800f20:	c1 e0 10             	shl    $0x10,%eax
  800f23:	09 f0                	or     %esi,%eax
  800f25:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800f27:	09 d8                	or     %ebx,%eax
  800f29:	c1 e9 02             	shr    $0x2,%ecx
  800f2c:	fc                   	cld    
  800f2d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f2f:	eb 03                	jmp    800f34 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f31:	fc                   	cld    
  800f32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f34:	89 f8                	mov    %edi,%eax
  800f36:	8b 1c 24             	mov    (%esp),%ebx
  800f39:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f3d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f41:	89 ec                	mov    %ebp,%esp
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	89 34 24             	mov    %esi,(%esp)
  800f4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800f58:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800f5b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800f5d:	39 c6                	cmp    %eax,%esi
  800f5f:	73 35                	jae    800f96 <memmove+0x51>
  800f61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f64:	39 d0                	cmp    %edx,%eax
  800f66:	73 2e                	jae    800f96 <memmove+0x51>
		s += n;
		d += n;
  800f68:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f6a:	f6 c2 03             	test   $0x3,%dl
  800f6d:	75 1b                	jne    800f8a <memmove+0x45>
  800f6f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f75:	75 13                	jne    800f8a <memmove+0x45>
  800f77:	f6 c1 03             	test   $0x3,%cl
  800f7a:	75 0e                	jne    800f8a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800f7c:	83 ef 04             	sub    $0x4,%edi
  800f7f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f82:	c1 e9 02             	shr    $0x2,%ecx
  800f85:	fd                   	std    
  800f86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f88:	eb 09                	jmp    800f93 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800f8a:	83 ef 01             	sub    $0x1,%edi
  800f8d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800f90:	fd                   	std    
  800f91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f93:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f94:	eb 20                	jmp    800fb6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f9c:	75 15                	jne    800fb3 <memmove+0x6e>
  800f9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800fa4:	75 0d                	jne    800fb3 <memmove+0x6e>
  800fa6:	f6 c1 03             	test   $0x3,%cl
  800fa9:	75 08                	jne    800fb3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800fab:	c1 e9 02             	shr    $0x2,%ecx
  800fae:	fc                   	cld    
  800faf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fb1:	eb 03                	jmp    800fb6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800fb3:	fc                   	cld    
  800fb4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fb6:	8b 34 24             	mov    (%esp),%esi
  800fb9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800fbd:	89 ec                	mov    %ebp,%esp
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	89 04 24             	mov    %eax,(%esp)
  800fdb:	e8 65 ff ff ff       	call   800f45 <memmove>
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    

00800fe2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	8b 75 08             	mov    0x8(%ebp),%esi
  800feb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800fee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ff1:	85 c9                	test   %ecx,%ecx
  800ff3:	74 36                	je     80102b <memcmp+0x49>
		if (*s1 != *s2)
  800ff5:	0f b6 06             	movzbl (%esi),%eax
  800ff8:	0f b6 1f             	movzbl (%edi),%ebx
  800ffb:	38 d8                	cmp    %bl,%al
  800ffd:	74 20                	je     80101f <memcmp+0x3d>
  800fff:	eb 14                	jmp    801015 <memcmp+0x33>
  801001:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  801006:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80100b:	83 c2 01             	add    $0x1,%edx
  80100e:	83 e9 01             	sub    $0x1,%ecx
  801011:	38 d8                	cmp    %bl,%al
  801013:	74 12                	je     801027 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  801015:	0f b6 c0             	movzbl %al,%eax
  801018:	0f b6 db             	movzbl %bl,%ebx
  80101b:	29 d8                	sub    %ebx,%eax
  80101d:	eb 11                	jmp    801030 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80101f:	83 e9 01             	sub    $0x1,%ecx
  801022:	ba 00 00 00 00       	mov    $0x0,%edx
  801027:	85 c9                	test   %ecx,%ecx
  801029:	75 d6                	jne    801001 <memcmp+0x1f>
  80102b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  801030:	5b                   	pop    %ebx
  801031:	5e                   	pop    %esi
  801032:	5f                   	pop    %edi
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801040:	39 d0                	cmp    %edx,%eax
  801042:	73 15                	jae    801059 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  801044:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801048:	38 08                	cmp    %cl,(%eax)
  80104a:	75 06                	jne    801052 <memfind+0x1d>
  80104c:	eb 0b                	jmp    801059 <memfind+0x24>
  80104e:	38 08                	cmp    %cl,(%eax)
  801050:	74 07                	je     801059 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	83 c0 01             	add    $0x1,%eax
  801055:	39 c2                	cmp    %eax,%edx
  801057:	77 f5                	ja     80104e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
  801061:	83 ec 04             	sub    $0x4,%esp
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80106a:	0f b6 02             	movzbl (%edx),%eax
  80106d:	3c 20                	cmp    $0x20,%al
  80106f:	74 04                	je     801075 <strtol+0x1a>
  801071:	3c 09                	cmp    $0x9,%al
  801073:	75 0e                	jne    801083 <strtol+0x28>
		s++;
  801075:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801078:	0f b6 02             	movzbl (%edx),%eax
  80107b:	3c 20                	cmp    $0x20,%al
  80107d:	74 f6                	je     801075 <strtol+0x1a>
  80107f:	3c 09                	cmp    $0x9,%al
  801081:	74 f2                	je     801075 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  801083:	3c 2b                	cmp    $0x2b,%al
  801085:	75 0c                	jne    801093 <strtol+0x38>
		s++;
  801087:	83 c2 01             	add    $0x1,%edx
  80108a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801091:	eb 15                	jmp    8010a8 <strtol+0x4d>
	else if (*s == '-')
  801093:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80109a:	3c 2d                	cmp    $0x2d,%al
  80109c:	75 0a                	jne    8010a8 <strtol+0x4d>
		s++, neg = 1;
  80109e:	83 c2 01             	add    $0x1,%edx
  8010a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a8:	85 db                	test   %ebx,%ebx
  8010aa:	0f 94 c0             	sete   %al
  8010ad:	74 05                	je     8010b4 <strtol+0x59>
  8010af:	83 fb 10             	cmp    $0x10,%ebx
  8010b2:	75 18                	jne    8010cc <strtol+0x71>
  8010b4:	80 3a 30             	cmpb   $0x30,(%edx)
  8010b7:	75 13                	jne    8010cc <strtol+0x71>
  8010b9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8010bd:	8d 76 00             	lea    0x0(%esi),%esi
  8010c0:	75 0a                	jne    8010cc <strtol+0x71>
		s += 2, base = 16;
  8010c2:	83 c2 02             	add    $0x2,%edx
  8010c5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ca:	eb 15                	jmp    8010e1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8010cc:	84 c0                	test   %al,%al
  8010ce:	66 90                	xchg   %ax,%ax
  8010d0:	74 0f                	je     8010e1 <strtol+0x86>
  8010d2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8010d7:	80 3a 30             	cmpb   $0x30,(%edx)
  8010da:	75 05                	jne    8010e1 <strtol+0x86>
		s++, base = 8;
  8010dc:	83 c2 01             	add    $0x1,%edx
  8010df:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8010e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e8:	0f b6 0a             	movzbl (%edx),%ecx
  8010eb:	89 cf                	mov    %ecx,%edi
  8010ed:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8010f0:	80 fb 09             	cmp    $0x9,%bl
  8010f3:	77 08                	ja     8010fd <strtol+0xa2>
			dig = *s - '0';
  8010f5:	0f be c9             	movsbl %cl,%ecx
  8010f8:	83 e9 30             	sub    $0x30,%ecx
  8010fb:	eb 1e                	jmp    80111b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  8010fd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801100:	80 fb 19             	cmp    $0x19,%bl
  801103:	77 08                	ja     80110d <strtol+0xb2>
			dig = *s - 'a' + 10;
  801105:	0f be c9             	movsbl %cl,%ecx
  801108:	83 e9 57             	sub    $0x57,%ecx
  80110b:	eb 0e                	jmp    80111b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80110d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801110:	80 fb 19             	cmp    $0x19,%bl
  801113:	77 15                	ja     80112a <strtol+0xcf>
			dig = *s - 'A' + 10;
  801115:	0f be c9             	movsbl %cl,%ecx
  801118:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80111b:	39 f1                	cmp    %esi,%ecx
  80111d:	7d 0b                	jge    80112a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80111f:	83 c2 01             	add    $0x1,%edx
  801122:	0f af c6             	imul   %esi,%eax
  801125:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801128:	eb be                	jmp    8010e8 <strtol+0x8d>
  80112a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80112c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801130:	74 05                	je     801137 <strtol+0xdc>
		*endptr = (char *) s;
  801132:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801135:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801137:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80113b:	74 04                	je     801141 <strtol+0xe6>
  80113d:	89 c8                	mov    %ecx,%eax
  80113f:	f7 d8                	neg    %eax
}
  801141:	83 c4 04             	add    $0x4,%esp
  801144:	5b                   	pop    %ebx
  801145:	5e                   	pop    %esi
  801146:	5f                   	pop    %edi
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    
  801149:	00 00                	add    %al,(%eax)
	...

0080114c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 0c             	sub    $0xc,%esp
  801152:	89 1c 24             	mov    %ebx,(%esp)
  801155:	89 74 24 04          	mov    %esi,0x4(%esp)
  801159:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115d:	ba 00 00 00 00       	mov    $0x0,%edx
  801162:	b8 01 00 00 00       	mov    $0x1,%eax
  801167:	89 d1                	mov    %edx,%ecx
  801169:	89 d3                	mov    %edx,%ebx
  80116b:	89 d7                	mov    %edx,%edi
  80116d:	89 d6                	mov    %edx,%esi
  80116f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801171:	8b 1c 24             	mov    (%esp),%ebx
  801174:	8b 74 24 04          	mov    0x4(%esp),%esi
  801178:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80117c:	89 ec                	mov    %ebp,%esp
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 0c             	sub    $0xc,%esp
  801186:	89 1c 24             	mov    %ebx,(%esp)
  801189:	89 74 24 04          	mov    %esi,0x4(%esp)
  80118d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801191:	b8 00 00 00 00       	mov    $0x0,%eax
  801196:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801199:	8b 55 08             	mov    0x8(%ebp),%edx
  80119c:	89 c3                	mov    %eax,%ebx
  80119e:	89 c7                	mov    %eax,%edi
  8011a0:	89 c6                	mov    %eax,%esi
  8011a2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8011a4:	8b 1c 24             	mov    (%esp),%ebx
  8011a7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011ab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011af:	89 ec                	mov    %ebp,%esp
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 38             	sub    $0x38,%esp
  8011b9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c2:	be 00 00 00 00       	mov    $0x0,%esi
  8011c7:	b8 12 00 00 00       	mov    $0x12,%eax
  8011cc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	7e 28                	jle    801206 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011de:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8011e9:	00 
  8011ea:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  8011f1:	00 
  8011f2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f9:	00 
  8011fa:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  801201:	e8 02 f4 ff ff       	call   800608 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  801206:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801209:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80120c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80120f:	89 ec                	mov    %ebp,%esp
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    

00801213 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 0c             	sub    $0xc,%esp
  801219:	89 1c 24             	mov    %ebx,(%esp)
  80121c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801220:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801224:	bb 00 00 00 00       	mov    $0x0,%ebx
  801229:	b8 11 00 00 00       	mov    $0x11,%eax
  80122e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801231:	8b 55 08             	mov    0x8(%ebp),%edx
  801234:	89 df                	mov    %ebx,%edi
  801236:	89 de                	mov    %ebx,%esi
  801238:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80123a:	8b 1c 24             	mov    (%esp),%ebx
  80123d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801241:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801245:	89 ec                	mov    %ebp,%esp
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 0c             	sub    $0xc,%esp
  80124f:	89 1c 24             	mov    %ebx,(%esp)
  801252:	89 74 24 04          	mov    %esi,0x4(%esp)
  801256:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80125f:	b8 10 00 00 00       	mov    $0x10,%eax
  801264:	8b 55 08             	mov    0x8(%ebp),%edx
  801267:	89 cb                	mov    %ecx,%ebx
  801269:	89 cf                	mov    %ecx,%edi
  80126b:	89 ce                	mov    %ecx,%esi
  80126d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  80126f:	8b 1c 24             	mov    (%esp),%ebx
  801272:	8b 74 24 04          	mov    0x4(%esp),%esi
  801276:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80127a:	89 ec                	mov    %ebp,%esp
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 38             	sub    $0x38,%esp
  801284:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801287:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80128a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801292:	b8 0f 00 00 00       	mov    $0xf,%eax
  801297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129a:	8b 55 08             	mov    0x8(%ebp),%edx
  80129d:	89 df                	mov    %ebx,%edi
  80129f:	89 de                	mov    %ebx,%esi
  8012a1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	7e 28                	jle    8012cf <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ab:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8012b2:	00 
  8012b3:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  8012ba:	00 
  8012bb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c2:	00 
  8012c3:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  8012ca:	e8 39 f3 ff ff       	call   800608 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  8012cf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012d2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012d5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012d8:	89 ec                	mov    %ebp,%esp
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    

008012dc <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	83 ec 0c             	sub    $0xc,%esp
  8012e2:	89 1c 24             	mov    %ebx,(%esp)
  8012e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012f7:	89 d1                	mov    %edx,%ecx
  8012f9:	89 d3                	mov    %edx,%ebx
  8012fb:	89 d7                	mov    %edx,%edi
  8012fd:	89 d6                	mov    %edx,%esi
  8012ff:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  801301:	8b 1c 24             	mov    (%esp),%ebx
  801304:	8b 74 24 04          	mov    0x4(%esp),%esi
  801308:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80130c:	89 ec                	mov    %ebp,%esp
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 38             	sub    $0x38,%esp
  801316:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801319:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80131c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80131f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801324:	b8 0d 00 00 00       	mov    $0xd,%eax
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	89 cb                	mov    %ecx,%ebx
  80132e:	89 cf                	mov    %ecx,%edi
  801330:	89 ce                	mov    %ecx,%esi
  801332:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801334:	85 c0                	test   %eax,%eax
  801336:	7e 28                	jle    801360 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801338:	89 44 24 10          	mov    %eax,0x10(%esp)
  80133c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801343:	00 
  801344:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  80134b:	00 
  80134c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801353:	00 
  801354:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  80135b:	e8 a8 f2 ff ff       	call   800608 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801360:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801363:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801366:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801369:	89 ec                	mov    %ebp,%esp
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	89 1c 24             	mov    %ebx,(%esp)
  801376:	89 74 24 04          	mov    %esi,0x4(%esp)
  80137a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80137e:	be 00 00 00 00       	mov    $0x0,%esi
  801383:	b8 0c 00 00 00       	mov    $0xc,%eax
  801388:	8b 7d 14             	mov    0x14(%ebp),%edi
  80138b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80138e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801391:	8b 55 08             	mov    0x8(%ebp),%edx
  801394:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801396:	8b 1c 24             	mov    (%esp),%ebx
  801399:	8b 74 24 04          	mov    0x4(%esp),%esi
  80139d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013a1:	89 ec                	mov    %ebp,%esp
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    

008013a5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	83 ec 38             	sub    $0x38,%esp
  8013ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c4:	89 df                	mov    %ebx,%edi
  8013c6:	89 de                	mov    %ebx,%esi
  8013c8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	7e 28                	jle    8013f6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013d2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8013d9:	00 
  8013da:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  8013e1:	00 
  8013e2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013e9:	00 
  8013ea:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  8013f1:	e8 12 f2 ff ff       	call   800608 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013f6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013f9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013ff:	89 ec                	mov    %ebp,%esp
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    

00801403 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 38             	sub    $0x38,%esp
  801409:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80140c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80140f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801412:	bb 00 00 00 00       	mov    $0x0,%ebx
  801417:	b8 09 00 00 00       	mov    $0x9,%eax
  80141c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141f:	8b 55 08             	mov    0x8(%ebp),%edx
  801422:	89 df                	mov    %ebx,%edi
  801424:	89 de                	mov    %ebx,%esi
  801426:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801428:	85 c0                	test   %eax,%eax
  80142a:	7e 28                	jle    801454 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80142c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801430:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801437:	00 
  801438:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  80143f:	00 
  801440:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801447:	00 
  801448:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  80144f:	e8 b4 f1 ff ff       	call   800608 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801454:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801457:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80145a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80145d:	89 ec                	mov    %ebp,%esp
  80145f:	5d                   	pop    %ebp
  801460:	c3                   	ret    

00801461 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 38             	sub    $0x38,%esp
  801467:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80146a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80146d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801470:	bb 00 00 00 00       	mov    $0x0,%ebx
  801475:	b8 08 00 00 00       	mov    $0x8,%eax
  80147a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80147d:	8b 55 08             	mov    0x8(%ebp),%edx
  801480:	89 df                	mov    %ebx,%edi
  801482:	89 de                	mov    %ebx,%esi
  801484:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801486:	85 c0                	test   %eax,%eax
  801488:	7e 28                	jle    8014b2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80148a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80148e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801495:	00 
  801496:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  80149d:	00 
  80149e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014a5:	00 
  8014a6:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  8014ad:	e8 56 f1 ff ff       	call   800608 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8014b2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014bb:	89 ec                	mov    %ebp,%esp
  8014bd:	5d                   	pop    %ebp
  8014be:	c3                   	ret    

008014bf <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	83 ec 38             	sub    $0x38,%esp
  8014c5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014c8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014cb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d3:	b8 06 00 00 00       	mov    $0x6,%eax
  8014d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014db:	8b 55 08             	mov    0x8(%ebp),%edx
  8014de:	89 df                	mov    %ebx,%edi
  8014e0:	89 de                	mov    %ebx,%esi
  8014e2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	7e 28                	jle    801510 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ec:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8014f3:	00 
  8014f4:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  8014fb:	00 
  8014fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801503:	00 
  801504:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  80150b:	e8 f8 f0 ff ff       	call   800608 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801510:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801513:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801516:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801519:	89 ec                	mov    %ebp,%esp
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	83 ec 38             	sub    $0x38,%esp
  801523:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801526:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801529:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80152c:	b8 05 00 00 00       	mov    $0x5,%eax
  801531:	8b 75 18             	mov    0x18(%ebp),%esi
  801534:	8b 7d 14             	mov    0x14(%ebp),%edi
  801537:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80153a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801542:	85 c0                	test   %eax,%eax
  801544:	7e 28                	jle    80156e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801546:	89 44 24 10          	mov    %eax,0x10(%esp)
  80154a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801551:	00 
  801552:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  801559:	00 
  80155a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801561:	00 
  801562:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  801569:	e8 9a f0 ff ff       	call   800608 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80156e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801571:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801574:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801577:	89 ec                	mov    %ebp,%esp
  801579:	5d                   	pop    %ebp
  80157a:	c3                   	ret    

0080157b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 38             	sub    $0x38,%esp
  801581:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801584:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801587:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80158a:	be 00 00 00 00       	mov    $0x0,%esi
  80158f:	b8 04 00 00 00       	mov    $0x4,%eax
  801594:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801597:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80159a:	8b 55 08             	mov    0x8(%ebp),%edx
  80159d:	89 f7                	mov    %esi,%edi
  80159f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	7e 28                	jle    8015cd <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015a9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8015b0:	00 
  8015b1:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  8015b8:	00 
  8015b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015c0:	00 
  8015c1:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  8015c8:	e8 3b f0 ff ff       	call   800608 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8015cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015d6:	89 ec                	mov    %ebp,%esp
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	89 1c 24             	mov    %ebx,(%esp)
  8015e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8015f5:	89 d1                	mov    %edx,%ecx
  8015f7:	89 d3                	mov    %edx,%ebx
  8015f9:	89 d7                	mov    %edx,%edi
  8015fb:	89 d6                	mov    %edx,%esi
  8015fd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8015ff:	8b 1c 24             	mov    (%esp),%ebx
  801602:	8b 74 24 04          	mov    0x4(%esp),%esi
  801606:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80160a:	89 ec                	mov    %ebp,%esp
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    

0080160e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 0c             	sub    $0xc,%esp
  801614:	89 1c 24             	mov    %ebx,(%esp)
  801617:	89 74 24 04          	mov    %esi,0x4(%esp)
  80161b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161f:	ba 00 00 00 00       	mov    $0x0,%edx
  801624:	b8 02 00 00 00       	mov    $0x2,%eax
  801629:	89 d1                	mov    %edx,%ecx
  80162b:	89 d3                	mov    %edx,%ebx
  80162d:	89 d7                	mov    %edx,%edi
  80162f:	89 d6                	mov    %edx,%esi
  801631:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801633:	8b 1c 24             	mov    (%esp),%ebx
  801636:	8b 74 24 04          	mov    0x4(%esp),%esi
  80163a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80163e:	89 ec                	mov    %ebp,%esp
  801640:	5d                   	pop    %ebp
  801641:	c3                   	ret    

00801642 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 38             	sub    $0x38,%esp
  801648:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80164b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80164e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801651:	b9 00 00 00 00       	mov    $0x0,%ecx
  801656:	b8 03 00 00 00       	mov    $0x3,%eax
  80165b:	8b 55 08             	mov    0x8(%ebp),%edx
  80165e:	89 cb                	mov    %ecx,%ebx
  801660:	89 cf                	mov    %ecx,%edi
  801662:	89 ce                	mov    %ecx,%esi
  801664:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801666:	85 c0                	test   %eax,%eax
  801668:	7e 28                	jle    801692 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80166a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80166e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801675:	00 
  801676:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  80167d:	00 
  80167e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801685:	00 
  801686:	c7 04 24 7c 3b 80 00 	movl   $0x803b7c,(%esp)
  80168d:	e8 76 ef ff ff       	call   800608 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801692:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801695:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801698:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80169b:	89 ec                	mov    %ebp,%esp
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    
	...

008016a0 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8016a6:	c7 44 24 08 8a 3b 80 	movl   $0x803b8a,0x8(%esp)
  8016ad:	00 
  8016ae:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  8016b5:	00 
  8016b6:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  8016bd:	e8 46 ef ff ff       	call   800608 <_panic>

008016c2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	53                   	push   %ebx
  8016c6:	83 ec 24             	sub    $0x24,%esp
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8016cc:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  8016ce:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8016d2:	75 1c                	jne    8016f0 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  8016d4:	c7 44 24 08 ac 3b 80 	movl   $0x803bac,0x8(%esp)
  8016db:	00 
  8016dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016e3:	00 
  8016e4:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  8016eb:	e8 18 ef ff ff       	call   800608 <_panic>
	}
	pte = vpt[VPN(addr)];
  8016f0:	89 d8                	mov    %ebx,%eax
  8016f2:	c1 e8 0c             	shr    $0xc,%eax
  8016f5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  8016fc:	f6 c4 08             	test   $0x8,%ah
  8016ff:	75 1c                	jne    80171d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801701:	c7 44 24 08 f0 3b 80 	movl   $0x803bf0,0x8(%esp)
  801708:	00 
  801709:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801710:	00 
  801711:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  801718:	e8 eb ee ff ff       	call   800608 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80171d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801724:	00 
  801725:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80172c:	00 
  80172d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801734:	e8 42 fe ff ff       	call   80157b <sys_page_alloc>
  801739:	85 c0                	test   %eax,%eax
  80173b:	79 20                	jns    80175d <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  80173d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801741:	c7 44 24 08 3c 3c 80 	movl   $0x803c3c,0x8(%esp)
  801748:	00 
  801749:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801750:	00 
  801751:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  801758:	e8 ab ee ff ff       	call   800608 <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  80175d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801763:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80176a:	00 
  80176b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80176f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801776:	e8 ca f7 ff ff       	call   800f45 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  80177b:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801782:	00 
  801783:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801787:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80178e:	00 
  80178f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801796:	00 
  801797:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80179e:	e8 7a fd ff ff       	call   80151d <sys_page_map>
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	79 20                	jns    8017c7 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  8017a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ab:	c7 44 24 08 78 3c 80 	movl   $0x803c78,0x8(%esp)
  8017b2:	00 
  8017b3:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8017ba:	00 
  8017bb:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  8017c2:	e8 41 ee ff ff       	call   800608 <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  8017c7:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8017ce:	00 
  8017cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d6:	e8 e4 fc ff ff       	call   8014bf <sys_page_unmap>
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	79 20                	jns    8017ff <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  8017df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017e3:	c7 44 24 08 b0 3c 80 	movl   $0x803cb0,0x8(%esp)
  8017ea:	00 
  8017eb:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8017f2:	00 
  8017f3:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  8017fa:	e8 09 ee ff ff       	call   800608 <_panic>
	// panic("pgfault not implemented");
}
  8017ff:	83 c4 24             	add    $0x24,%esp
  801802:	5b                   	pop    %ebx
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	57                   	push   %edi
  801809:	56                   	push   %esi
  80180a:	53                   	push   %ebx
  80180b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80180e:	c7 04 24 c2 16 80 00 	movl   $0x8016c2,(%esp)
  801815:	e8 36 1a 00 00       	call   803250 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80181a:	ba 07 00 00 00       	mov    $0x7,%edx
  80181f:	89 d0                	mov    %edx,%eax
  801821:	cd 30                	int    $0x30
  801823:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  801826:	85 c0                	test   %eax,%eax
  801828:	0f 88 21 02 00 00    	js     801a4f <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  80182e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  801835:	85 c0                	test   %eax,%eax
  801837:	75 1c                	jne    801855 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  801839:	e8 d0 fd ff ff       	call   80160e <sys_getenvid>
  80183e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801843:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801846:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80184b:	a3 74 70 80 00       	mov    %eax,0x807074
		return 0;
  801850:	e9 fa 01 00 00       	jmp    801a4f <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  801855:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801858:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  80185f:	a8 01                	test   $0x1,%al
  801861:	0f 84 16 01 00 00    	je     80197d <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  801867:	89 d3                	mov    %edx,%ebx
  801869:	c1 e3 0a             	shl    $0xa,%ebx
  80186c:	89 d7                	mov    %edx,%edi
  80186e:	c1 e7 16             	shl    $0x16,%edi
  801871:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  801876:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80187d:	a8 01                	test   $0x1,%al
  80187f:	0f 84 e0 00 00 00    	je     801965 <fork+0x160>
  801885:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80188b:	0f 87 d4 00 00 00    	ja     801965 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801891:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801898:	89 d0                	mov    %edx,%eax
  80189a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  80189f:	f6 c2 01             	test   $0x1,%dl
  8018a2:	75 1c                	jne    8018c0 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  8018a4:	c7 44 24 08 ec 3c 80 	movl   $0x803cec,0x8(%esp)
  8018ab:	00 
  8018ac:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  8018b3:	00 
  8018b4:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  8018bb:	e8 48 ed ff ff       	call   800608 <_panic>
	if ((perm & PTE_U) != PTE_U)
  8018c0:	a8 04                	test   $0x4,%al
  8018c2:	75 1c                	jne    8018e0 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  8018c4:	c7 44 24 08 34 3d 80 	movl   $0x803d34,0x8(%esp)
  8018cb:	00 
  8018cc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8018d3:	00 
  8018d4:	c7 04 24 a0 3b 80 00 	movl   $0x803ba0,(%esp)
  8018db:	e8 28 ed ff ff       	call   800608 <_panic>
  8018e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  8018e3:	f6 c4 04             	test   $0x4,%ah
  8018e6:	75 5b                	jne    801943 <fork+0x13e>
  8018e8:	a9 02 08 00 00       	test   $0x802,%eax
  8018ed:	74 54                	je     801943 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  8018ef:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  8018f2:	80 cc 08             	or     $0x8,%ah
  8018f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8018f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018fc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801900:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801903:	89 54 24 08          	mov    %edx,0x8(%esp)
  801907:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80190b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801912:	e8 06 fc ff ff       	call   80151d <sys_page_map>
  801917:	85 c0                	test   %eax,%eax
  801919:	78 4a                	js     801965 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80191b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80191e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801922:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801925:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801929:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801930:	00 
  801931:	89 54 24 04          	mov    %edx,0x4(%esp)
  801935:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80193c:	e8 dc fb ff ff       	call   80151d <sys_page_map>
  801941:	eb 22                	jmp    801965 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801943:	89 44 24 10          	mov    %eax,0x10(%esp)
  801947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80194a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80194e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801951:	89 54 24 08          	mov    %edx,0x8(%esp)
  801955:	89 44 24 04          	mov    %eax,0x4(%esp)
  801959:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801960:	e8 b8 fb ff ff       	call   80151d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  801965:	83 c6 01             	add    $0x1,%esi
  801968:	83 c3 01             	add    $0x1,%ebx
  80196b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801971:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  801977:	0f 85 f9 fe ff ff    	jne    801876 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  80197d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  801981:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  801988:	0f 85 c7 fe ff ff    	jne    801855 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80198e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801995:	00 
  801996:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80199d:	ee 
  80199e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a1:	89 04 24             	mov    %eax,(%esp)
  8019a4:	e8 d2 fb ff ff       	call   80157b <sys_page_alloc>
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	79 08                	jns    8019b5 <fork+0x1b0>
  8019ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019b0:	e9 9a 00 00 00       	jmp    801a4f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8019b5:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8019bc:	00 
  8019bd:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8019c4:	00 
  8019c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019cc:	00 
  8019cd:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8019d4:	ee 
  8019d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d8:	89 14 24             	mov    %edx,(%esp)
  8019db:	e8 3d fb ff ff       	call   80151d <sys_page_map>
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	79 05                	jns    8019e9 <fork+0x1e4>
  8019e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019e7:	eb 66                	jmp    801a4f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  8019e9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8019f0:	00 
  8019f1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8019f8:	ee 
  8019f9:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801a00:	e8 40 f5 ff ff       	call   800f45 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801a05:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a0c:	00 
  801a0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a14:	e8 a6 fa ff ff       	call   8014bf <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801a19:	c7 44 24 04 e4 32 80 	movl   $0x8032e4,0x4(%esp)
  801a20:	00 
  801a21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	e8 79 f9 ff ff       	call   8013a5 <sys_env_set_pgfault_upcall>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	79 05                	jns    801a35 <fork+0x230>
  801a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a33:	eb 1a                	jmp    801a4f <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801a35:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a3c:	00 
  801a3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a40:	89 14 24             	mov    %edx,(%esp)
  801a43:	e8 19 fa ff ff       	call   801461 <sys_env_set_status>
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	79 03                	jns    801a4f <fork+0x24a>
  801a4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  801a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a52:	83 c4 3c             	add    $0x3c,%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5f                   	pop    %edi
  801a58:	5d                   	pop    %ebp
  801a59:	c3                   	ret    
  801a5a:	00 00                	add    %al,(%eax)
  801a5c:	00 00                	add    %al,(%eax)
	...

00801a60 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	05 00 00 00 30       	add    $0x30000000,%eax
  801a6b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    

00801a70 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	89 04 24             	mov    %eax,(%esp)
  801a7c:	e8 df ff ff ff       	call   801a60 <fd2num>
  801a81:	05 20 00 0d 00       	add    $0xd0020,%eax
  801a86:	c1 e0 0c             	shl    $0xc,%eax
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	57                   	push   %edi
  801a8f:	56                   	push   %esi
  801a90:	53                   	push   %ebx
  801a91:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801a94:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801a99:	a8 01                	test   $0x1,%al
  801a9b:	74 36                	je     801ad3 <fd_alloc+0x48>
  801a9d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801aa2:	a8 01                	test   $0x1,%al
  801aa4:	74 2d                	je     801ad3 <fd_alloc+0x48>
  801aa6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  801aab:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801ab0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801ab5:	89 c3                	mov    %eax,%ebx
  801ab7:	89 c2                	mov    %eax,%edx
  801ab9:	c1 ea 16             	shr    $0x16,%edx
  801abc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801abf:	f6 c2 01             	test   $0x1,%dl
  801ac2:	74 14                	je     801ad8 <fd_alloc+0x4d>
  801ac4:	89 c2                	mov    %eax,%edx
  801ac6:	c1 ea 0c             	shr    $0xc,%edx
  801ac9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  801acc:	f6 c2 01             	test   $0x1,%dl
  801acf:	75 10                	jne    801ae1 <fd_alloc+0x56>
  801ad1:	eb 05                	jmp    801ad8 <fd_alloc+0x4d>
  801ad3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801ad8:	89 1f                	mov    %ebx,(%edi)
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801adf:	eb 17                	jmp    801af8 <fd_alloc+0x6d>
  801ae1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801ae6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801aeb:	75 c8                	jne    801ab5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801aed:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801af3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801af8:	5b                   	pop    %ebx
  801af9:	5e                   	pop    %esi
  801afa:	5f                   	pop    %edi
  801afb:	5d                   	pop    %ebp
  801afc:	c3                   	ret    

00801afd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	83 f8 1f             	cmp    $0x1f,%eax
  801b06:	77 36                	ja     801b3e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801b08:	05 00 00 0d 00       	add    $0xd0000,%eax
  801b0d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	c1 ea 16             	shr    $0x16,%edx
  801b15:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801b1c:	f6 c2 01             	test   $0x1,%dl
  801b1f:	74 1d                	je     801b3e <fd_lookup+0x41>
  801b21:	89 c2                	mov    %eax,%edx
  801b23:	c1 ea 0c             	shr    $0xc,%edx
  801b26:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b2d:	f6 c2 01             	test   $0x1,%dl
  801b30:	74 0c                	je     801b3e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b35:	89 02                	mov    %eax,(%edx)
  801b37:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801b3c:	eb 05                	jmp    801b43 <fd_lookup+0x46>
  801b3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801b43:	5d                   	pop    %ebp
  801b44:	c3                   	ret    

00801b45 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b4b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	89 04 24             	mov    %eax,(%esp)
  801b58:	e8 a0 ff ff ff       	call   801afd <fd_lookup>
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	78 0e                	js     801b6f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	89 50 04             	mov    %edx,0x4(%eax)
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
  801b76:	83 ec 10             	sub    $0x10,%esp
  801b79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  801b7f:	b8 20 70 80 00       	mov    $0x807020,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801b84:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801b89:	be f8 3d 80 00       	mov    $0x803df8,%esi
		if (devtab[i]->dev_id == dev_id) {
  801b8e:	39 08                	cmp    %ecx,(%eax)
  801b90:	75 10                	jne    801ba2 <dev_lookup+0x31>
  801b92:	eb 04                	jmp    801b98 <dev_lookup+0x27>
  801b94:	39 08                	cmp    %ecx,(%eax)
  801b96:	75 0a                	jne    801ba2 <dev_lookup+0x31>
			*dev = devtab[i];
  801b98:	89 03                	mov    %eax,(%ebx)
  801b9a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801b9f:	90                   	nop
  801ba0:	eb 31                	jmp    801bd3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ba2:	83 c2 01             	add    $0x1,%edx
  801ba5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	75 e8                	jne    801b94 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801bac:	a1 74 70 80 00       	mov    0x807074,%eax
  801bb1:	8b 40 4c             	mov    0x4c(%eax),%eax
  801bb4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbc:	c7 04 24 7c 3d 80 00 	movl   $0x803d7c,(%esp)
  801bc3:	e8 05 eb ff ff       	call   8006cd <cprintf>
	*dev = 0;
  801bc8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801bce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	5b                   	pop    %ebx
  801bd7:	5e                   	pop    %esi
  801bd8:	5d                   	pop    %ebp
  801bd9:	c3                   	ret    

00801bda <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	53                   	push   %ebx
  801bde:	83 ec 24             	sub    $0x24,%esp
  801be1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	89 04 24             	mov    %eax,(%esp)
  801bf1:	e8 07 ff ff ff       	call   801afd <fd_lookup>
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	78 53                	js     801c4d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c04:	8b 00                	mov    (%eax),%eax
  801c06:	89 04 24             	mov    %eax,(%esp)
  801c09:	e8 63 ff ff ff       	call   801b71 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	78 3b                	js     801c4d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801c12:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c1a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801c1e:	74 2d                	je     801c4d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c20:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c23:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c2a:	00 00 00 
	stat->st_isdir = 0;
  801c2d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c34:	00 00 00 
	stat->st_dev = dev;
  801c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c40:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c47:	89 14 24             	mov    %edx,(%esp)
  801c4a:	ff 50 14             	call   *0x14(%eax)
}
  801c4d:	83 c4 24             	add    $0x24,%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5d                   	pop    %ebp
  801c52:	c3                   	ret    

00801c53 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	53                   	push   %ebx
  801c57:	83 ec 24             	sub    $0x24,%esp
  801c5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c64:	89 1c 24             	mov    %ebx,(%esp)
  801c67:	e8 91 fe ff ff       	call   801afd <fd_lookup>
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 5f                	js     801ccf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7a:	8b 00                	mov    (%eax),%eax
  801c7c:	89 04 24             	mov    %eax,(%esp)
  801c7f:	e8 ed fe ff ff       	call   801b71 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c84:	85 c0                	test   %eax,%eax
  801c86:	78 47                	js     801ccf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c8b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801c8f:	75 23                	jne    801cb4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801c91:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c96:	8b 40 4c             	mov    0x4c(%eax),%eax
  801c99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca1:	c7 04 24 9c 3d 80 00 	movl   $0x803d9c,(%esp)
  801ca8:	e8 20 ea ff ff       	call   8006cd <cprintf>
  801cad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801cb2:	eb 1b                	jmp    801ccf <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb7:	8b 48 18             	mov    0x18(%eax),%ecx
  801cba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801cbf:	85 c9                	test   %ecx,%ecx
  801cc1:	74 0c                	je     801ccf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cca:	89 14 24             	mov    %edx,(%esp)
  801ccd:	ff d1                	call   *%ecx
}
  801ccf:	83 c4 24             	add    $0x24,%esp
  801cd2:	5b                   	pop    %ebx
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    

00801cd5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	53                   	push   %ebx
  801cd9:	83 ec 24             	sub    $0x24,%esp
  801cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cdf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce6:	89 1c 24             	mov    %ebx,(%esp)
  801ce9:	e8 0f fe ff ff       	call   801afd <fd_lookup>
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 66                	js     801d58 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cf2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfc:	8b 00                	mov    (%eax),%eax
  801cfe:	89 04 24             	mov    %eax,(%esp)
  801d01:	e8 6b fe ff ff       	call   801b71 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d06:	85 c0                	test   %eax,%eax
  801d08:	78 4e                	js     801d58 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d0d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801d11:	75 23                	jne    801d36 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801d13:	a1 74 70 80 00       	mov    0x807074,%eax
  801d18:	8b 40 4c             	mov    0x4c(%eax),%eax
  801d1b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d23:	c7 04 24 bd 3d 80 00 	movl   $0x803dbd,(%esp)
  801d2a:	e8 9e e9 ff ff       	call   8006cd <cprintf>
  801d2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801d34:	eb 22                	jmp    801d58 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d39:	8b 48 0c             	mov    0xc(%eax),%ecx
  801d3c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d41:	85 c9                	test   %ecx,%ecx
  801d43:	74 13                	je     801d58 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801d45:	8b 45 10             	mov    0x10(%ebp),%eax
  801d48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d53:	89 14 24             	mov    %edx,(%esp)
  801d56:	ff d1                	call   *%ecx
}
  801d58:	83 c4 24             	add    $0x24,%esp
  801d5b:	5b                   	pop    %ebx
  801d5c:	5d                   	pop    %ebp
  801d5d:	c3                   	ret    

00801d5e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	53                   	push   %ebx
  801d62:	83 ec 24             	sub    $0x24,%esp
  801d65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d68:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6f:	89 1c 24             	mov    %ebx,(%esp)
  801d72:	e8 86 fd ff ff       	call   801afd <fd_lookup>
  801d77:	85 c0                	test   %eax,%eax
  801d79:	78 6b                	js     801de6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d85:	8b 00                	mov    (%eax),%eax
  801d87:	89 04 24             	mov    %eax,(%esp)
  801d8a:	e8 e2 fd ff ff       	call   801b71 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	78 53                	js     801de6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801d93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d96:	8b 42 08             	mov    0x8(%edx),%eax
  801d99:	83 e0 03             	and    $0x3,%eax
  801d9c:	83 f8 01             	cmp    $0x1,%eax
  801d9f:	75 23                	jne    801dc4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801da1:	a1 74 70 80 00       	mov    0x807074,%eax
  801da6:	8b 40 4c             	mov    0x4c(%eax),%eax
  801da9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db1:	c7 04 24 da 3d 80 00 	movl   $0x803dda,(%esp)
  801db8:	e8 10 e9 ff ff       	call   8006cd <cprintf>
  801dbd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801dc2:	eb 22                	jmp    801de6 <read+0x88>
	}
	if (!dev->dev_read)
  801dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc7:	8b 48 08             	mov    0x8(%eax),%ecx
  801dca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dcf:	85 c9                	test   %ecx,%ecx
  801dd1:	74 13                	je     801de6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801dd3:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de1:	89 14 24             	mov    %edx,(%esp)
  801de4:	ff d1                	call   *%ecx
}
  801de6:	83 c4 24             	add    $0x24,%esp
  801de9:	5b                   	pop    %ebx
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	57                   	push   %edi
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	83 ec 1c             	sub    $0x1c,%esp
  801df5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801df8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801dfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801e00:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e05:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0a:	85 f6                	test   %esi,%esi
  801e0c:	74 29                	je     801e37 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801e0e:	89 f0                	mov    %esi,%eax
  801e10:	29 d0                	sub    %edx,%eax
  801e12:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e16:	03 55 0c             	add    0xc(%ebp),%edx
  801e19:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e1d:	89 3c 24             	mov    %edi,(%esp)
  801e20:	e8 39 ff ff ff       	call   801d5e <read>
		if (m < 0)
  801e25:	85 c0                	test   %eax,%eax
  801e27:	78 0e                	js     801e37 <readn+0x4b>
			return m;
		if (m == 0)
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	74 08                	je     801e35 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801e2d:	01 c3                	add    %eax,%ebx
  801e2f:	89 da                	mov    %ebx,%edx
  801e31:	39 f3                	cmp    %esi,%ebx
  801e33:	72 d9                	jb     801e0e <readn+0x22>
  801e35:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801e37:	83 c4 1c             	add    $0x1c,%esp
  801e3a:	5b                   	pop    %ebx
  801e3b:	5e                   	pop    %esi
  801e3c:	5f                   	pop    %edi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	56                   	push   %esi
  801e43:	53                   	push   %ebx
  801e44:	83 ec 20             	sub    $0x20,%esp
  801e47:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e4a:	89 34 24             	mov    %esi,(%esp)
  801e4d:	e8 0e fc ff ff       	call   801a60 <fd2num>
  801e52:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e55:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e59:	89 04 24             	mov    %eax,(%esp)
  801e5c:	e8 9c fc ff ff       	call   801afd <fd_lookup>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 05                	js     801e6c <fd_close+0x2d>
  801e67:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801e6a:	74 0c                	je     801e78 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801e6c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801e70:	19 c0                	sbb    %eax,%eax
  801e72:	f7 d0                	not    %eax
  801e74:	21 c3                	and    %eax,%ebx
  801e76:	eb 3d                	jmp    801eb5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7f:	8b 06                	mov    (%esi),%eax
  801e81:	89 04 24             	mov    %eax,(%esp)
  801e84:	e8 e8 fc ff ff       	call   801b71 <dev_lookup>
  801e89:	89 c3                	mov    %eax,%ebx
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	78 16                	js     801ea5 <fd_close+0x66>
		if (dev->dev_close)
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	8b 40 10             	mov    0x10(%eax),%eax
  801e95:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	74 07                	je     801ea5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801e9e:	89 34 24             	mov    %esi,(%esp)
  801ea1:	ff d0                	call   *%eax
  801ea3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ea5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ea9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb0:	e8 0a f6 ff ff       	call   8014bf <sys_page_unmap>
	return r;
}
  801eb5:	89 d8                	mov    %ebx,%eax
  801eb7:	83 c4 20             	add    $0x20,%esp
  801eba:	5b                   	pop    %ebx
  801ebb:	5e                   	pop    %esi
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ec4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	89 04 24             	mov    %eax,(%esp)
  801ed1:	e8 27 fc ff ff       	call   801afd <fd_lookup>
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	78 13                	js     801eed <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801eda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ee1:	00 
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	89 04 24             	mov    %eax,(%esp)
  801ee8:	e8 52 ff ff ff       	call   801e3f <fd_close>
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 18             	sub    $0x18,%esp
  801ef5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ef8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801efb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f02:	00 
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	89 04 24             	mov    %eax,(%esp)
  801f09:	e8 55 03 00 00       	call   802263 <open>
  801f0e:	89 c3                	mov    %eax,%ebx
  801f10:	85 c0                	test   %eax,%eax
  801f12:	78 1b                	js     801f2f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1b:	89 1c 24             	mov    %ebx,(%esp)
  801f1e:	e8 b7 fc ff ff       	call   801bda <fstat>
  801f23:	89 c6                	mov    %eax,%esi
	close(fd);
  801f25:	89 1c 24             	mov    %ebx,(%esp)
  801f28:	e8 91 ff ff ff       	call   801ebe <close>
  801f2d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801f2f:	89 d8                	mov    %ebx,%eax
  801f31:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f34:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f37:	89 ec                	mov    %ebp,%esp
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 14             	sub    $0x14,%esp
  801f42:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801f47:	89 1c 24             	mov    %ebx,(%esp)
  801f4a:	e8 6f ff ff ff       	call   801ebe <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f4f:	83 c3 01             	add    $0x1,%ebx
  801f52:	83 fb 20             	cmp    $0x20,%ebx
  801f55:	75 f0                	jne    801f47 <close_all+0xc>
		close(i);
}
  801f57:	83 c4 14             	add    $0x14,%esp
  801f5a:	5b                   	pop    %ebx
  801f5b:	5d                   	pop    %ebp
  801f5c:	c3                   	ret    

00801f5d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 58             	sub    $0x58,%esp
  801f63:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f66:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f69:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801f6f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	89 04 24             	mov    %eax,(%esp)
  801f7c:	e8 7c fb ff ff       	call   801afd <fd_lookup>
  801f81:	89 c3                	mov    %eax,%ebx
  801f83:	85 c0                	test   %eax,%eax
  801f85:	0f 88 e0 00 00 00    	js     80206b <dup+0x10e>
		return r;
	close(newfdnum);
  801f8b:	89 3c 24             	mov    %edi,(%esp)
  801f8e:	e8 2b ff ff ff       	call   801ebe <close>

	newfd = INDEX2FD(newfdnum);
  801f93:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801f99:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9f:	89 04 24             	mov    %eax,(%esp)
  801fa2:	e8 c9 fa ff ff       	call   801a70 <fd2data>
  801fa7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801fa9:	89 34 24             	mov    %esi,(%esp)
  801fac:	e8 bf fa ff ff       	call   801a70 <fd2data>
  801fb1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801fb4:	89 da                	mov    %ebx,%edx
  801fb6:	89 d8                	mov    %ebx,%eax
  801fb8:	c1 e8 16             	shr    $0x16,%eax
  801fbb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801fc2:	a8 01                	test   $0x1,%al
  801fc4:	74 43                	je     802009 <dup+0xac>
  801fc6:	c1 ea 0c             	shr    $0xc,%edx
  801fc9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801fd0:	a8 01                	test   $0x1,%al
  801fd2:	74 35                	je     802009 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801fd4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801fdb:	25 07 0e 00 00       	and    $0xe07,%eax
  801fe0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801fe4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fe7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801feb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ff2:	00 
  801ff3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ff7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ffe:	e8 1a f5 ff ff       	call   80151d <sys_page_map>
  802003:	89 c3                	mov    %eax,%ebx
  802005:	85 c0                	test   %eax,%eax
  802007:	78 3f                	js     802048 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  802009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80200c:	89 c2                	mov    %eax,%edx
  80200e:	c1 ea 0c             	shr    $0xc,%edx
  802011:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802018:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80201e:	89 54 24 10          	mov    %edx,0x10(%esp)
  802022:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802026:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80202d:	00 
  80202e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802032:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802039:	e8 df f4 ff ff       	call   80151d <sys_page_map>
  80203e:	89 c3                	mov    %eax,%ebx
  802040:	85 c0                	test   %eax,%eax
  802042:	78 04                	js     802048 <dup+0xeb>
  802044:	89 fb                	mov    %edi,%ebx
  802046:	eb 23                	jmp    80206b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802048:	89 74 24 04          	mov    %esi,0x4(%esp)
  80204c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802053:	e8 67 f4 ff ff       	call   8014bf <sys_page_unmap>
	sys_page_unmap(0, nva);
  802058:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80205b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802066:	e8 54 f4 ff ff       	call   8014bf <sys_page_unmap>
	return r;
}
  80206b:	89 d8                	mov    %ebx,%eax
  80206d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802070:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802073:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802076:	89 ec                	mov    %ebp,%esp
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    
	...

0080207c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	53                   	push   %ebx
  802080:	83 ec 14             	sub    $0x14,%esp
  802083:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802085:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80208b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802092:	00 
  802093:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  80209a:	00 
  80209b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209f:	89 14 24             	mov    %edx,(%esp)
  8020a2:	e8 69 12 00 00       	call   803310 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8020a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020ae:	00 
  8020af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ba:	e8 b7 12 00 00       	call   803376 <ipc_recv>
}
  8020bf:	83 c4 14             	add    $0x14,%esp
  8020c2:	5b                   	pop    %ebx
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    

008020c5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  8020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8020de:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8020e8:	e8 8f ff ff ff       	call   80207c <fsipc>
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020fb:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  802100:	ba 00 00 00 00       	mov    $0x0,%edx
  802105:	b8 06 00 00 00       	mov    $0x6,%eax
  80210a:	e8 6d ff ff ff       	call   80207c <fsipc>
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802117:	ba 00 00 00 00       	mov    $0x0,%edx
  80211c:	b8 08 00 00 00       	mov    $0x8,%eax
  802121:	e8 56 ff ff ff       	call   80207c <fsipc>
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	53                   	push   %ebx
  80212c:	83 ec 14             	sub    $0x14,%esp
  80212f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	8b 40 0c             	mov    0xc(%eax),%eax
  802138:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80213d:	ba 00 00 00 00       	mov    $0x0,%edx
  802142:	b8 05 00 00 00       	mov    $0x5,%eax
  802147:	e8 30 ff ff ff       	call   80207c <fsipc>
  80214c:	85 c0                	test   %eax,%eax
  80214e:	78 2b                	js     80217b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802150:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802157:	00 
  802158:	89 1c 24             	mov    %ebx,(%esp)
  80215b:	e8 2a ec ff ff       	call   800d8a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802160:	a1 80 40 80 00       	mov    0x804080,%eax
  802165:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80216b:	a1 84 40 80 00       	mov    0x804084,%eax
  802170:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80217b:	83 c4 14             	add    $0x14,%esp
  80217e:	5b                   	pop    %ebx
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
  802187:	8b 45 10             	mov    0x10(%ebp),%eax
  80218a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80218f:	76 05                	jbe    802196 <devfile_write+0x15>
  802191:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802196:	8b 55 08             	mov    0x8(%ebp),%edx
  802199:	8b 52 0c             	mov    0xc(%edx),%edx
  80219c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  8021a2:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  8021a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b2:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  8021b9:	e8 87 ed ff ff       	call   800f45 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  8021be:	ba 00 00 00 00       	mov    $0x0,%edx
  8021c3:	b8 04 00 00 00       	mov    $0x4,%eax
  8021c8:	e8 af fe ff ff       	call   80207c <fsipc>
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	53                   	push   %ebx
  8021d3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021dc:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  8021e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e4:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  8021e9:	ba 00 40 80 00       	mov    $0x804000,%edx
  8021ee:	b8 03 00 00 00       	mov    $0x3,%eax
  8021f3:	e8 84 fe ff ff       	call   80207c <fsipc>
  8021f8:	89 c3                	mov    %eax,%ebx
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	78 17                	js     802215 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  8021fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  802202:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802209:	00 
  80220a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220d:	89 04 24             	mov    %eax,(%esp)
  802210:	e8 30 ed ff ff       	call   800f45 <memmove>
	return r;
}
  802215:	89 d8                	mov    %ebx,%eax
  802217:	83 c4 14             	add    $0x14,%esp
  80221a:	5b                   	pop    %ebx
  80221b:	5d                   	pop    %ebp
  80221c:	c3                   	ret    

0080221d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	53                   	push   %ebx
  802221:	83 ec 14             	sub    $0x14,%esp
  802224:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  802227:	89 1c 24             	mov    %ebx,(%esp)
  80222a:	e8 11 eb ff ff       	call   800d40 <strlen>
  80222f:	89 c2                	mov    %eax,%edx
  802231:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802236:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  80223c:	7f 1f                	jg     80225d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  80223e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802242:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802249:	e8 3c eb ff ff       	call   800d8a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  80224e:	ba 00 00 00 00       	mov    $0x0,%edx
  802253:	b8 07 00 00 00       	mov    $0x7,%eax
  802258:	e8 1f fe ff ff       	call   80207c <fsipc>
}
  80225d:	83 c4 14             	add    $0x14,%esp
  802260:	5b                   	pop    %ebx
  802261:	5d                   	pop    %ebp
  802262:	c3                   	ret    

00802263 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	83 ec 28             	sub    $0x28,%esp
  802269:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80226c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80226f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  802272:	89 34 24             	mov    %esi,(%esp)
  802275:	e8 c6 ea ff ff       	call   800d40 <strlen>
  80227a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80227f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802284:	7f 5e                	jg     8022e4 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  802286:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802289:	89 04 24             	mov    %eax,(%esp)
  80228c:	e8 fa f7 ff ff       	call   801a8b <fd_alloc>
  802291:	89 c3                	mov    %eax,%ebx
  802293:	85 c0                	test   %eax,%eax
  802295:	78 4d                	js     8022e4 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  802297:	89 74 24 04          	mov    %esi,0x4(%esp)
  80229b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8022a2:	e8 e3 ea ff ff       	call   800d8a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  8022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022aa:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  8022af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b7:	e8 c0 fd ff ff       	call   80207c <fsipc>
  8022bc:	89 c3                	mov    %eax,%ebx
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	79 15                	jns    8022d7 <open+0x74>
	{
		fd_close(fd,0);
  8022c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022c9:	00 
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	89 04 24             	mov    %eax,(%esp)
  8022d0:	e8 6a fb ff ff       	call   801e3f <fd_close>
		return r; 
  8022d5:	eb 0d                	jmp    8022e4 <open+0x81>
	}
	return fd2num(fd);
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	89 04 24             	mov    %eax,(%esp)
  8022dd:	e8 7e f7 ff ff       	call   801a60 <fd2num>
  8022e2:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  8022e4:	89 d8                	mov    %ebx,%eax
  8022e6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8022e9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8022ec:	89 ec                	mov    %ebp,%esp
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    

008022f0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	57                   	push   %edi
  8022f4:	56                   	push   %esi
  8022f5:	53                   	push   %ebx
  8022f6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8022fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802303:	00 
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	89 04 24             	mov    %eax,(%esp)
  80230a:	e8 54 ff ff ff       	call   802263 <open>
  80230f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  802315:	89 c3                	mov    %eax,%ebx
  802317:	85 c0                	test   %eax,%eax
  802319:	0f 88 be 05 00 00    	js     8028dd <spawn+0x5ed>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  80231f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802326:	00 
  802327:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80232d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802331:	89 1c 24             	mov    %ebx,(%esp)
  802334:	e8 25 fa ff ff       	call   801d5e <read>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802339:	3d 00 02 00 00       	cmp    $0x200,%eax
  80233e:	75 0c                	jne    80234c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802340:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802347:	45 4c 46 
  80234a:	74 36                	je     802382 <spawn+0x92>
		close(fd);
  80234c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802352:	89 04 24             	mov    %eax,(%esp)
  802355:	e8 64 fb ff ff       	call   801ebe <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80235a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802361:	46 
  802362:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236c:	c7 04 24 0c 3e 80 00 	movl   $0x803e0c,(%esp)
  802373:	e8 55 e3 ff ff       	call   8006cd <cprintf>
  802378:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  80237d:	e9 5b 05 00 00       	jmp    8028dd <spawn+0x5ed>
  802382:	ba 07 00 00 00       	mov    $0x7,%edx
  802387:	89 d0                	mov    %edx,%eax
  802389:	cd 30                	int    $0x30
  80238b:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802391:	85 c0                	test   %eax,%eax
  802393:	0f 88 3e 05 00 00    	js     8028d7 <spawn+0x5e7>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802399:	89 c6                	mov    %eax,%esi
  80239b:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8023a1:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8023a4:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8023aa:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8023b0:	b9 11 00 00 00       	mov    $0x11,%ecx
  8023b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8023b7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8023bd:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8023c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c6:	8b 02                	mov    (%edx),%eax
  8023c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023cd:	be 00 00 00 00       	mov    $0x0,%esi
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	75 16                	jne    8023ec <spawn+0xfc>
  8023d6:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8023dd:	00 00 00 
  8023e0:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  8023e7:	00 00 00 
  8023ea:	eb 2c                	jmp    802418 <spawn+0x128>
  8023ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  8023ef:	89 04 24             	mov    %eax,(%esp)
  8023f2:	e8 49 e9 ff ff       	call   800d40 <strlen>
  8023f7:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8023fb:	83 c6 01             	add    $0x1,%esi
  8023fe:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  802405:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  802408:	85 c0                	test   %eax,%eax
  80240a:	75 e3                	jne    8023ef <spawn+0xff>
  80240c:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  802412:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802418:	f7 db                	neg    %ebx
  80241a:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802420:	89 fa                	mov    %edi,%edx
  802422:	83 e2 fc             	and    $0xfffffffc,%edx
  802425:	89 f0                	mov    %esi,%eax
  802427:	f7 d0                	not    %eax
  802429:	8d 04 82             	lea    (%edx,%eax,4),%eax
  80242c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802432:	83 e8 08             	sub    $0x8,%eax
  802435:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  80243b:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802440:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802445:	0f 86 92 04 00 00    	jbe    8028dd <spawn+0x5ed>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80244b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802452:	00 
  802453:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80245a:	00 
  80245b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802462:	e8 14 f1 ff ff       	call   80157b <sys_page_alloc>
  802467:	89 c3                	mov    %eax,%ebx
  802469:	85 c0                	test   %eax,%eax
  80246b:	0f 88 6c 04 00 00    	js     8028dd <spawn+0x5ed>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802471:	85 f6                	test   %esi,%esi
  802473:	7e 46                	jle    8024bb <spawn+0x1cb>
  802475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80247a:	89 b5 88 fd ff ff    	mov    %esi,-0x278(%ebp)
  802480:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  802483:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802489:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80248f:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  802492:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  802495:	89 44 24 04          	mov    %eax,0x4(%esp)
  802499:	89 3c 24             	mov    %edi,(%esp)
  80249c:	e8 e9 e8 ff ff       	call   800d8a <strcpy>
		string_store += strlen(argv[i]) + 1;
  8024a1:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8024a4:	89 04 24             	mov    %eax,(%esp)
  8024a7:	e8 94 e8 ff ff       	call   800d40 <strlen>
  8024ac:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8024b0:	83 c3 01             	add    $0x1,%ebx
  8024b3:	3b 9d 88 fd ff ff    	cmp    -0x278(%ebp),%ebx
  8024b9:	7c c8                	jl     802483 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8024bb:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8024c1:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  8024c7:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8024ce:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8024d4:	74 24                	je     8024fa <spawn+0x20a>
  8024d6:	c7 44 24 0c ac 3e 80 	movl   $0x803eac,0xc(%esp)
  8024dd:	00 
  8024de:	c7 44 24 08 26 3e 80 	movl   $0x803e26,0x8(%esp)
  8024e5:	00 
  8024e6:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  8024ed:	00 
  8024ee:	c7 04 24 3b 3e 80 00 	movl   $0x803e3b,(%esp)
  8024f5:	e8 0e e1 ff ff       	call   800608 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8024fa:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802500:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802505:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80250b:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  80250e:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  802514:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80251a:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80251c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802522:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802527:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80252d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802534:	00 
  802535:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  80253c:	ee 
  80253d:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802543:	89 44 24 08          	mov    %eax,0x8(%esp)
  802547:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80254e:	00 
  80254f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802556:	e8 c2 ef ff ff       	call   80151d <sys_page_map>
  80255b:	89 c3                	mov    %eax,%ebx
  80255d:	85 c0                	test   %eax,%eax
  80255f:	78 1a                	js     80257b <spawn+0x28b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802561:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802568:	00 
  802569:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802570:	e8 4a ef ff ff       	call   8014bf <sys_page_unmap>
  802575:	89 c3                	mov    %eax,%ebx
  802577:	85 c0                	test   %eax,%eax
  802579:	79 19                	jns    802594 <spawn+0x2a4>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80257b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802582:	00 
  802583:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80258a:	e8 30 ef ff ff       	call   8014bf <sys_page_unmap>
  80258f:	e9 49 03 00 00       	jmp    8028dd <spawn+0x5ed>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802594:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80259a:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  8025a1:	00 
  8025a2:	0f 84 e3 01 00 00    	je     80278b <spawn+0x49b>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8025a8:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8025af:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  8025b5:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8025bc:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
  8025bf:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  8025c5:	83 3a 01             	cmpl   $0x1,(%edx)
  8025c8:	0f 85 9b 01 00 00    	jne    802769 <spawn+0x479>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8025ce:	8b 42 18             	mov    0x18(%edx),%eax
  8025d1:	83 e0 02             	and    $0x2,%eax
  8025d4:	83 f8 01             	cmp    $0x1,%eax
  8025d7:	19 c0                	sbb    %eax,%eax
  8025d9:	83 e0 fe             	and    $0xfffffffe,%eax
  8025dc:	83 c0 07             	add    $0x7,%eax
  8025df:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  8025e5:	8b 52 04             	mov    0x4(%edx),%edx
  8025e8:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  8025ee:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8025f4:	8b 58 10             	mov    0x10(%eax),%ebx
  8025f7:	8b 50 14             	mov    0x14(%eax),%edx
  8025fa:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
  802600:	8b 40 08             	mov    0x8(%eax),%eax
  802603:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802609:	25 ff 0f 00 00       	and    $0xfff,%eax
  80260e:	74 16                	je     802626 <spawn+0x336>
		va -= i;
  802610:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  802616:	01 c2                	add    %eax,%edx
  802618:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		filesz += i;
  80261e:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  802620:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802626:	83 bd 88 fd ff ff 00 	cmpl   $0x0,-0x278(%ebp)
  80262d:	0f 84 36 01 00 00    	je     802769 <spawn+0x479>
  802633:	bf 00 00 00 00       	mov    $0x0,%edi
  802638:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  80263d:	39 fb                	cmp    %edi,%ebx
  80263f:	77 31                	ja     802672 <spawn+0x382>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802641:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802647:	89 54 24 08          	mov    %edx,0x8(%esp)
  80264b:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802651:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802655:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80265b:	89 04 24             	mov    %eax,(%esp)
  80265e:	e8 18 ef ff ff       	call   80157b <sys_page_alloc>
  802663:	85 c0                	test   %eax,%eax
  802665:	0f 89 ea 00 00 00    	jns    802755 <spawn+0x465>
  80266b:	89 c3                	mov    %eax,%ebx
  80266d:	e9 47 02 00 00       	jmp    8028b9 <spawn+0x5c9>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802672:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802679:	00 
  80267a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802681:	00 
  802682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802689:	e8 ed ee ff ff       	call   80157b <sys_page_alloc>
  80268e:	85 c0                	test   %eax,%eax
  802690:	0f 88 19 02 00 00    	js     8028af <spawn+0x5bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802696:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  80269c:	8d 04 16             	lea    (%esi,%edx,1),%eax
  80269f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a3:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8026a9:	89 04 24             	mov    %eax,(%esp)
  8026ac:	e8 94 f4 ff ff       	call   801b45 <seek>
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	0f 88 fa 01 00 00    	js     8028b3 <spawn+0x5c3>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8026b9:	89 d8                	mov    %ebx,%eax
  8026bb:	29 f8                	sub    %edi,%eax
  8026bd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8026c2:	76 05                	jbe    8026c9 <spawn+0x3d9>
  8026c4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026cd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8026d4:	00 
  8026d5:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  8026db:	89 14 24             	mov    %edx,(%esp)
  8026de:	e8 7b f6 ff ff       	call   801d5e <read>
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	0f 88 cc 01 00 00    	js     8028b7 <spawn+0x5c7>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8026eb:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8026f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8026f5:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  8026fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ff:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802705:	89 54 24 08          	mov    %edx,0x8(%esp)
  802709:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802710:	00 
  802711:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802718:	e8 00 ee ff ff       	call   80151d <sys_page_map>
  80271d:	85 c0                	test   %eax,%eax
  80271f:	79 20                	jns    802741 <spawn+0x451>
				panic("spawn: sys_page_map data: %e", r);
  802721:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802725:	c7 44 24 08 47 3e 80 	movl   $0x803e47,0x8(%esp)
  80272c:	00 
  80272d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  802734:	00 
  802735:	c7 04 24 3b 3e 80 00 	movl   $0x803e3b,(%esp)
  80273c:	e8 c7 de ff ff       	call   800608 <_panic>
			sys_page_unmap(0, UTEMP);
  802741:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802748:	00 
  802749:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802750:	e8 6a ed ff ff       	call   8014bf <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802755:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80275b:	89 f7                	mov    %esi,%edi
  80275d:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  802763:	0f 87 d4 fe ff ff    	ja     80263d <spawn+0x34d>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802769:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802770:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802777:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  80277d:	7e 0c                	jle    80278b <spawn+0x49b>
  80277f:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  802786:	e9 34 fe ff ff       	jmp    8025bf <spawn+0x2cf>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80278b:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802791:	89 04 24             	mov    %eax,(%esp)
  802794:	e8 25 f7 ff ff       	call   801ebe <close>
  802799:	c7 85 94 fd ff ff 00 	movl   $0x0,-0x26c(%ebp)
  8027a0:	00 00 00 
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  8027a3:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8027a9:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8027b0:	a8 01                	test   $0x1,%al
  8027b2:	74 65                	je     802819 <spawn+0x529>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;
  8027b4:	89 d7                	mov    %edx,%edi
  8027b6:	c1 e7 0a             	shl    $0xa,%edi
  8027b9:	89 d6                	mov    %edx,%esi
  8027bb:	c1 e6 16             	shl    $0x16,%esi
  8027be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027c3:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
				pte = vpt[vpn];
  8027c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
				if ((pte & PTE_P) && (pte & PTE_SHARE))
  8027cd:	89 c2                	mov    %eax,%edx
  8027cf:	81 e2 01 04 00 00    	and    $0x401,%edx
  8027d5:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  8027db:	75 2b                	jne    802808 <spawn+0x518>
				{
					va = (void*)(vpn * PGSIZE);
					r = sys_page_map(0, va, child, va, pte & PTE_USER);
  8027dd:	25 07 0e 00 00       	and    $0xe07,%eax
  8027e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8027e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8027ea:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8027f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027f4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027ff:	e8 19 ed ff ff       	call   80151d <sys_page_map>
					if (r < 0)
  802804:	85 c0                	test   %eax,%eax
  802806:	78 2d                	js     802835 <spawn+0x545>
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  802808:	83 c3 01             	add    $0x1,%ebx
  80280b:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802811:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  802817:	75 aa                	jne    8027c3 <spawn+0x4d3>
	uint32_t pde_x, pte_x, vpn;
	pte_t pte;
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  802819:	83 85 94 fd ff ff 01 	addl   $0x1,-0x26c(%ebp)
  802820:	81 bd 94 fd ff ff bb 	cmpl   $0x3bb,-0x26c(%ebp)
  802827:	03 00 00 
  80282a:	0f 85 73 ff ff ff    	jne    8027a3 <spawn+0x4b3>
  802830:	e9 b5 00 00 00       	jmp    8028ea <spawn+0x5fa>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  802835:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802839:	c7 44 24 08 64 3e 80 	movl   $0x803e64,0x8(%esp)
  802840:	00 
  802841:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  802848:	00 
  802849:	c7 04 24 3b 3e 80 00 	movl   $0x803e3b,(%esp)
  802850:	e8 b3 dd ff ff       	call   800608 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802855:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802859:	c7 44 24 08 7a 3e 80 	movl   $0x803e7a,0x8(%esp)
  802860:	00 
  802861:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802868:	00 
  802869:	c7 04 24 3b 3e 80 00 	movl   $0x803e3b,(%esp)
  802870:	e8 93 dd ff ff       	call   800608 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802875:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80287c:	00 
  80287d:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802883:	89 14 24             	mov    %edx,(%esp)
  802886:	e8 d6 eb ff ff       	call   801461 <sys_env_set_status>
  80288b:	85 c0                	test   %eax,%eax
  80288d:	79 48                	jns    8028d7 <spawn+0x5e7>
		panic("sys_env_set_status: %e", r);
  80288f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802893:	c7 44 24 08 94 3e 80 	movl   $0x803e94,0x8(%esp)
  80289a:	00 
  80289b:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8028a2:	00 
  8028a3:	c7 04 24 3b 3e 80 00 	movl   $0x803e3b,(%esp)
  8028aa:	e8 59 dd ff ff       	call   800608 <_panic>
  8028af:	89 c3                	mov    %eax,%ebx
  8028b1:	eb 06                	jmp    8028b9 <spawn+0x5c9>
  8028b3:	89 c3                	mov    %eax,%ebx
  8028b5:	eb 02                	jmp    8028b9 <spawn+0x5c9>
  8028b7:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  8028b9:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8028bf:	89 04 24             	mov    %eax,(%esp)
  8028c2:	e8 7b ed ff ff       	call   801642 <sys_env_destroy>
	close(fd);
  8028c7:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  8028cd:	89 14 24             	mov    %edx,(%esp)
  8028d0:	e8 e9 f5 ff ff       	call   801ebe <close>
	return r;
  8028d5:	eb 06                	jmp    8028dd <spawn+0x5ed>
  8028d7:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
}
  8028dd:	89 d8                	mov    %ebx,%eax
  8028df:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8028e5:	5b                   	pop    %ebx
  8028e6:	5e                   	pop    %esi
  8028e7:	5f                   	pop    %edi
  8028e8:	5d                   	pop    %ebp
  8028e9:	c3                   	ret    

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8028ea:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8028f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f4:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8028fa:	89 04 24             	mov    %eax,(%esp)
  8028fd:	e8 01 eb ff ff       	call   801403 <sys_env_set_trapframe>
  802902:	85 c0                	test   %eax,%eax
  802904:	0f 89 6b ff ff ff    	jns    802875 <spawn+0x585>
  80290a:	e9 46 ff ff ff       	jmp    802855 <spawn+0x565>

0080290f <spawnl>:
}

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  80290f:	55                   	push   %ebp
  802910:	89 e5                	mov    %esp,%ebp
  802912:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  802915:	8d 45 0c             	lea    0xc(%ebp),%eax
  802918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	89 04 24             	mov    %eax,(%esp)
  802922:	e8 c9 f9 ff ff       	call   8022f0 <spawn>
}
  802927:	c9                   	leave  
  802928:	c3                   	ret    
  802929:	00 00                	add    %al,(%eax)
  80292b:	00 00                	add    %al,(%eax)
  80292d:	00 00                	add    %al,(%eax)
	...

00802930 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
  802933:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802936:	c7 44 24 04 d2 3e 80 	movl   $0x803ed2,0x4(%esp)
  80293d:	00 
  80293e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802941:	89 04 24             	mov    %eax,(%esp)
  802944:	e8 41 e4 ff ff       	call   800d8a <strcpy>
	return 0;
}
  802949:	b8 00 00 00 00       	mov    $0x0,%eax
  80294e:	c9                   	leave  
  80294f:	c3                   	ret    

00802950 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	8b 40 0c             	mov    0xc(%eax),%eax
  80295c:	89 04 24             	mov    %eax,(%esp)
  80295f:	e8 9e 02 00 00       	call   802c02 <nsipc_close>
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80296c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802973:	00 
  802974:	8b 45 10             	mov    0x10(%ebp),%eax
  802977:	89 44 24 08          	mov    %eax,0x8(%esp)
  80297b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80297e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	8b 40 0c             	mov    0xc(%eax),%eax
  802988:	89 04 24             	mov    %eax,(%esp)
  80298b:	e8 ae 02 00 00       	call   802c3e <nsipc_send>
}
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
  802995:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802998:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80299f:	00 
  8029a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8029a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b4:	89 04 24             	mov    %eax,(%esp)
  8029b7:	e8 f5 02 00 00       	call   802cb1 <nsipc_recv>
}
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    

008029be <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
  8029c1:	56                   	push   %esi
  8029c2:	53                   	push   %ebx
  8029c3:	83 ec 20             	sub    $0x20,%esp
  8029c6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8029c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029cb:	89 04 24             	mov    %eax,(%esp)
  8029ce:	e8 b8 f0 ff ff       	call   801a8b <fd_alloc>
  8029d3:	89 c3                	mov    %eax,%ebx
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	78 21                	js     8029fa <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8029d9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029e0:	00 
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ef:	e8 87 eb ff ff       	call   80157b <sys_page_alloc>
  8029f4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	79 0a                	jns    802a04 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8029fa:	89 34 24             	mov    %esi,(%esp)
  8029fd:	e8 00 02 00 00       	call   802c02 <nsipc_close>
		return r;
  802a02:	eb 28                	jmp    802a2c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802a04:	8b 15 3c 70 80 00    	mov    0x80703c,%edx
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	89 04 24             	mov    %eax,(%esp)
  802a25:	e8 36 f0 ff ff       	call   801a60 <fd2num>
  802a2a:	89 c3                	mov    %eax,%ebx
}
  802a2c:	89 d8                	mov    %ebx,%eax
  802a2e:	83 c4 20             	add    $0x20,%esp
  802a31:	5b                   	pop    %ebx
  802a32:	5e                   	pop    %esi
  802a33:	5d                   	pop    %ebp
  802a34:	c3                   	ret    

00802a35 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
  802a38:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802a3b:	8b 45 10             	mov    0x10(%ebp),%eax
  802a3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	89 04 24             	mov    %eax,(%esp)
  802a4f:	e8 62 01 00 00       	call   802bb6 <nsipc_socket>
  802a54:	85 c0                	test   %eax,%eax
  802a56:	78 05                	js     802a5d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802a58:	e8 61 ff ff ff       	call   8029be <alloc_sockfd>
}
  802a5d:	c9                   	leave  
  802a5e:	66 90                	xchg   %ax,%ax
  802a60:	c3                   	ret    

00802a61 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
  802a64:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a67:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802a6a:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a6e:	89 04 24             	mov    %eax,(%esp)
  802a71:	e8 87 f0 ff ff       	call   801afd <fd_lookup>
  802a76:	85 c0                	test   %eax,%eax
  802a78:	78 15                	js     802a8f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7d:	8b 0a                	mov    (%edx),%ecx
  802a7f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802a84:	3b 0d 3c 70 80 00    	cmp    0x80703c,%ecx
  802a8a:	75 03                	jne    802a8f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802a8c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
  802a94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	e8 c2 ff ff ff       	call   802a61 <fd2sockid>
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	78 0f                	js     802ab2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa6:	89 54 24 04          	mov    %edx,0x4(%esp)
  802aaa:	89 04 24             	mov    %eax,(%esp)
  802aad:	e8 2e 01 00 00       	call   802be0 <nsipc_listen>
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
  802ab7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	e8 9f ff ff ff       	call   802a61 <fd2sockid>
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	78 16                	js     802adc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802ac6:	8b 55 10             	mov    0x10(%ebp),%edx
  802ac9:	89 54 24 08          	mov    %edx,0x8(%esp)
  802acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad0:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ad4:	89 04 24             	mov    %eax,(%esp)
  802ad7:	e8 55 02 00 00       	call   802d31 <nsipc_connect>
}
  802adc:	c9                   	leave  
  802add:	c3                   	ret    

00802ade <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802ade:	55                   	push   %ebp
  802adf:	89 e5                	mov    %esp,%ebp
  802ae1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	e8 75 ff ff ff       	call   802a61 <fd2sockid>
  802aec:	85 c0                	test   %eax,%eax
  802aee:	78 0f                	js     802aff <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af3:	89 54 24 04          	mov    %edx,0x4(%esp)
  802af7:	89 04 24             	mov    %eax,(%esp)
  802afa:	e8 1d 01 00 00       	call   802c1c <nsipc_shutdown>
}
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    

00802b01 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802b01:	55                   	push   %ebp
  802b02:	89 e5                	mov    %esp,%ebp
  802b04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	e8 52 ff ff ff       	call   802a61 <fd2sockid>
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	78 16                	js     802b29 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802b13:	8b 55 10             	mov    0x10(%ebp),%edx
  802b16:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b1d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b21:	89 04 24             	mov    %eax,(%esp)
  802b24:	e8 47 02 00 00       	call   802d70 <nsipc_bind>
}
  802b29:	c9                   	leave  
  802b2a:	c3                   	ret    

00802b2b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b2b:	55                   	push   %ebp
  802b2c:	89 e5                	mov    %esp,%ebp
  802b2e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	e8 28 ff ff ff       	call   802a61 <fd2sockid>
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	78 1f                	js     802b5c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b3d:	8b 55 10             	mov    0x10(%ebp),%edx
  802b40:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b47:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b4b:	89 04 24             	mov    %eax,(%esp)
  802b4e:	e8 5c 02 00 00       	call   802daf <nsipc_accept>
  802b53:	85 c0                	test   %eax,%eax
  802b55:	78 05                	js     802b5c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802b57:	e8 62 fe ff ff       	call   8029be <alloc_sockfd>
}
  802b5c:	c9                   	leave  
  802b5d:	8d 76 00             	lea    0x0(%esi),%esi
  802b60:	c3                   	ret    
	...

00802b70 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802b70:	55                   	push   %ebp
  802b71:	89 e5                	mov    %esp,%ebp
  802b73:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802b76:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  802b7c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802b83:	00 
  802b84:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  802b8b:	00 
  802b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b90:	89 14 24             	mov    %edx,(%esp)
  802b93:	e8 78 07 00 00       	call   803310 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802b98:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802b9f:	00 
  802ba0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802ba7:	00 
  802ba8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802baf:	e8 c2 07 00 00       	call   803376 <ipc_recv>
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802bcc:	8b 45 10             	mov    0x10(%ebp),%eax
  802bcf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802bd4:	b8 09 00 00 00       	mov    $0x9,%eax
  802bd9:	e8 92 ff ff ff       	call   802b70 <nsipc>
}
  802bde:	c9                   	leave  
  802bdf:	c3                   	ret    

00802be0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
  802be3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802bf6:	b8 06 00 00 00       	mov    $0x6,%eax
  802bfb:	e8 70 ff ff ff       	call   802b70 <nsipc>
}
  802c00:	c9                   	leave  
  802c01:	c3                   	ret    

00802c02 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802c02:	55                   	push   %ebp
  802c03:	89 e5                	mov    %esp,%ebp
  802c05:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802c10:	b8 04 00 00 00       	mov    $0x4,%eax
  802c15:	e8 56 ff ff ff       	call   802b70 <nsipc>
}
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
  802c1f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802c32:	b8 03 00 00 00       	mov    $0x3,%eax
  802c37:	e8 34 ff ff ff       	call   802b70 <nsipc>
}
  802c3c:	c9                   	leave  
  802c3d:	c3                   	ret    

00802c3e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802c3e:	55                   	push   %ebp
  802c3f:	89 e5                	mov    %esp,%ebp
  802c41:	53                   	push   %ebx
  802c42:	83 ec 14             	sub    $0x14,%esp
  802c45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802c50:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802c56:	7e 24                	jle    802c7c <nsipc_send+0x3e>
  802c58:	c7 44 24 0c de 3e 80 	movl   $0x803ede,0xc(%esp)
  802c5f:	00 
  802c60:	c7 44 24 08 26 3e 80 	movl   $0x803e26,0x8(%esp)
  802c67:	00 
  802c68:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  802c6f:	00 
  802c70:	c7 04 24 ea 3e 80 00 	movl   $0x803eea,(%esp)
  802c77:	e8 8c d9 ff ff       	call   800608 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802c7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c87:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  802c8e:	e8 b2 e2 ff ff       	call   800f45 <memmove>
	nsipcbuf.send.req_size = size;
  802c93:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802c99:	8b 45 14             	mov    0x14(%ebp),%eax
  802c9c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802ca1:	b8 08 00 00 00       	mov    $0x8,%eax
  802ca6:	e8 c5 fe ff ff       	call   802b70 <nsipc>
}
  802cab:	83 c4 14             	add    $0x14,%esp
  802cae:	5b                   	pop    %ebx
  802caf:	5d                   	pop    %ebp
  802cb0:	c3                   	ret    

00802cb1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802cb1:	55                   	push   %ebp
  802cb2:	89 e5                	mov    %esp,%ebp
  802cb4:	56                   	push   %esi
  802cb5:	53                   	push   %ebx
  802cb6:	83 ec 10             	sub    $0x10,%esp
  802cb9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802cc4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802cca:	8b 45 14             	mov    0x14(%ebp),%eax
  802ccd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802cd2:	b8 07 00 00 00       	mov    $0x7,%eax
  802cd7:	e8 94 fe ff ff       	call   802b70 <nsipc>
  802cdc:	89 c3                	mov    %eax,%ebx
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	78 46                	js     802d28 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802ce2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802ce7:	7f 04                	jg     802ced <nsipc_recv+0x3c>
  802ce9:	39 c6                	cmp    %eax,%esi
  802ceb:	7d 24                	jge    802d11 <nsipc_recv+0x60>
  802ced:	c7 44 24 0c f6 3e 80 	movl   $0x803ef6,0xc(%esp)
  802cf4:	00 
  802cf5:	c7 44 24 08 26 3e 80 	movl   $0x803e26,0x8(%esp)
  802cfc:	00 
  802cfd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802d04:	00 
  802d05:	c7 04 24 ea 3e 80 00 	movl   $0x803eea,(%esp)
  802d0c:	e8 f7 d8 ff ff       	call   800608 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802d11:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d15:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802d1c:	00 
  802d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d20:	89 04 24             	mov    %eax,(%esp)
  802d23:	e8 1d e2 ff ff       	call   800f45 <memmove>
	}

	return r;
}
  802d28:	89 d8                	mov    %ebx,%eax
  802d2a:	83 c4 10             	add    $0x10,%esp
  802d2d:	5b                   	pop    %ebx
  802d2e:	5e                   	pop    %esi
  802d2f:	5d                   	pop    %ebp
  802d30:	c3                   	ret    

00802d31 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d31:	55                   	push   %ebp
  802d32:	89 e5                	mov    %esp,%ebp
  802d34:	53                   	push   %ebx
  802d35:	83 ec 14             	sub    $0x14,%esp
  802d38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802d43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d4e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802d55:	e8 eb e1 ff ff       	call   800f45 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802d5a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802d60:	b8 05 00 00 00       	mov    $0x5,%eax
  802d65:	e8 06 fe ff ff       	call   802b70 <nsipc>
}
  802d6a:	83 c4 14             	add    $0x14,%esp
  802d6d:	5b                   	pop    %ebx
  802d6e:	5d                   	pop    %ebp
  802d6f:	c3                   	ret    

00802d70 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802d70:	55                   	push   %ebp
  802d71:	89 e5                	mov    %esp,%ebp
  802d73:	53                   	push   %ebx
  802d74:	83 ec 14             	sub    $0x14,%esp
  802d77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802d82:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d8d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802d94:	e8 ac e1 ff ff       	call   800f45 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802d99:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802d9f:	b8 02 00 00 00       	mov    $0x2,%eax
  802da4:	e8 c7 fd ff ff       	call   802b70 <nsipc>
}
  802da9:	83 c4 14             	add    $0x14,%esp
  802dac:	5b                   	pop    %ebx
  802dad:	5d                   	pop    %ebp
  802dae:	c3                   	ret    

00802daf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802daf:	55                   	push   %ebp
  802db0:	89 e5                	mov    %esp,%ebp
  802db2:	83 ec 18             	sub    $0x18,%esp
  802db5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802db8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802dc3:	b8 01 00 00 00       	mov    $0x1,%eax
  802dc8:	e8 a3 fd ff ff       	call   802b70 <nsipc>
  802dcd:	89 c3                	mov    %eax,%ebx
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	78 25                	js     802df8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802dd3:	be 10 60 80 00       	mov    $0x806010,%esi
  802dd8:	8b 06                	mov    (%esi),%eax
  802dda:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dde:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802de5:	00 
  802de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de9:	89 04 24             	mov    %eax,(%esp)
  802dec:	e8 54 e1 ff ff       	call   800f45 <memmove>
		*addrlen = ret->ret_addrlen;
  802df1:	8b 16                	mov    (%esi),%edx
  802df3:	8b 45 10             	mov    0x10(%ebp),%eax
  802df6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802df8:	89 d8                	mov    %ebx,%eax
  802dfa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802dfd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802e00:	89 ec                	mov    %ebp,%esp
  802e02:	5d                   	pop    %ebp
  802e03:	c3                   	ret    
	...

00802e10 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
  802e13:	83 ec 18             	sub    $0x18,%esp
  802e16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802e19:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802e1c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	89 04 24             	mov    %eax,(%esp)
  802e25:	e8 46 ec ff ff       	call   801a70 <fd2data>
  802e2a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802e2c:	c7 44 24 04 0b 3f 80 	movl   $0x803f0b,0x4(%esp)
  802e33:	00 
  802e34:	89 34 24             	mov    %esi,(%esp)
  802e37:	e8 4e df ff ff       	call   800d8a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802e3c:	8b 43 04             	mov    0x4(%ebx),%eax
  802e3f:	2b 03                	sub    (%ebx),%eax
  802e41:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802e47:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  802e4e:	00 00 00 
	stat->st_dev = &devpipe;
  802e51:	c7 86 88 00 00 00 58 	movl   $0x807058,0x88(%esi)
  802e58:	70 80 00 
	return 0;
}
  802e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e60:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802e63:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802e66:	89 ec                	mov    %ebp,%esp
  802e68:	5d                   	pop    %ebp
  802e69:	c3                   	ret    

00802e6a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802e6a:	55                   	push   %ebp
  802e6b:	89 e5                	mov    %esp,%ebp
  802e6d:	53                   	push   %ebx
  802e6e:	83 ec 14             	sub    $0x14,%esp
  802e71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802e74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e7f:	e8 3b e6 ff ff       	call   8014bf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802e84:	89 1c 24             	mov    %ebx,(%esp)
  802e87:	e8 e4 eb ff ff       	call   801a70 <fd2data>
  802e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e97:	e8 23 e6 ff ff       	call   8014bf <sys_page_unmap>
}
  802e9c:	83 c4 14             	add    $0x14,%esp
  802e9f:	5b                   	pop    %ebx
  802ea0:	5d                   	pop    %ebp
  802ea1:	c3                   	ret    

00802ea2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
  802ea5:	57                   	push   %edi
  802ea6:	56                   	push   %esi
  802ea7:	53                   	push   %ebx
  802ea8:	83 ec 2c             	sub    $0x2c,%esp
  802eab:	89 c7                	mov    %eax,%edi
  802ead:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802eb0:	a1 74 70 80 00       	mov    0x807074,%eax
  802eb5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802eb8:	89 3c 24             	mov    %edi,(%esp)
  802ebb:	e8 20 05 00 00       	call   8033e0 <pageref>
  802ec0:	89 c6                	mov    %eax,%esi
  802ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec5:	89 04 24             	mov    %eax,(%esp)
  802ec8:	e8 13 05 00 00       	call   8033e0 <pageref>
  802ecd:	39 c6                	cmp    %eax,%esi
  802ecf:	0f 94 c0             	sete   %al
  802ed2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802ed5:	8b 15 74 70 80 00    	mov    0x807074,%edx
  802edb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802ede:	39 cb                	cmp    %ecx,%ebx
  802ee0:	75 08                	jne    802eea <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802ee2:	83 c4 2c             	add    $0x2c,%esp
  802ee5:	5b                   	pop    %ebx
  802ee6:	5e                   	pop    %esi
  802ee7:	5f                   	pop    %edi
  802ee8:	5d                   	pop    %ebp
  802ee9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802eea:	83 f8 01             	cmp    $0x1,%eax
  802eed:	75 c1                	jne    802eb0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802eef:	8b 52 58             	mov    0x58(%edx),%edx
  802ef2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ef6:	89 54 24 08          	mov    %edx,0x8(%esp)
  802efa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802efe:	c7 04 24 12 3f 80 00 	movl   $0x803f12,(%esp)
  802f05:	e8 c3 d7 ff ff       	call   8006cd <cprintf>
  802f0a:	eb a4                	jmp    802eb0 <_pipeisclosed+0xe>

00802f0c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f0c:	55                   	push   %ebp
  802f0d:	89 e5                	mov    %esp,%ebp
  802f0f:	57                   	push   %edi
  802f10:	56                   	push   %esi
  802f11:	53                   	push   %ebx
  802f12:	83 ec 1c             	sub    $0x1c,%esp
  802f15:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802f18:	89 34 24             	mov    %esi,(%esp)
  802f1b:	e8 50 eb ff ff       	call   801a70 <fd2data>
  802f20:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f22:	bf 00 00 00 00       	mov    $0x0,%edi
  802f27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802f2b:	75 54                	jne    802f81 <devpipe_write+0x75>
  802f2d:	eb 60                	jmp    802f8f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802f2f:	89 da                	mov    %ebx,%edx
  802f31:	89 f0                	mov    %esi,%eax
  802f33:	e8 6a ff ff ff       	call   802ea2 <_pipeisclosed>
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 07                	je     802f43 <devpipe_write+0x37>
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f41:	eb 53                	jmp    802f96 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802f43:	90                   	nop
  802f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f48:	e8 8d e6 ff ff       	call   8015da <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f4d:	8b 43 04             	mov    0x4(%ebx),%eax
  802f50:	8b 13                	mov    (%ebx),%edx
  802f52:	83 c2 20             	add    $0x20,%edx
  802f55:	39 d0                	cmp    %edx,%eax
  802f57:	73 d6                	jae    802f2f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f59:	89 c2                	mov    %eax,%edx
  802f5b:	c1 fa 1f             	sar    $0x1f,%edx
  802f5e:	c1 ea 1b             	shr    $0x1b,%edx
  802f61:	01 d0                	add    %edx,%eax
  802f63:	83 e0 1f             	and    $0x1f,%eax
  802f66:	29 d0                	sub    %edx,%eax
  802f68:	89 c2                	mov    %eax,%edx
  802f6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f6d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802f71:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802f75:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f79:	83 c7 01             	add    $0x1,%edi
  802f7c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802f7f:	76 13                	jbe    802f94 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f81:	8b 43 04             	mov    0x4(%ebx),%eax
  802f84:	8b 13                	mov    (%ebx),%edx
  802f86:	83 c2 20             	add    $0x20,%edx
  802f89:	39 d0                	cmp    %edx,%eax
  802f8b:	73 a2                	jae    802f2f <devpipe_write+0x23>
  802f8d:	eb ca                	jmp    802f59 <devpipe_write+0x4d>
  802f8f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802f94:	89 f8                	mov    %edi,%eax
}
  802f96:	83 c4 1c             	add    $0x1c,%esp
  802f99:	5b                   	pop    %ebx
  802f9a:	5e                   	pop    %esi
  802f9b:	5f                   	pop    %edi
  802f9c:	5d                   	pop    %ebp
  802f9d:	c3                   	ret    

00802f9e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f9e:	55                   	push   %ebp
  802f9f:	89 e5                	mov    %esp,%ebp
  802fa1:	83 ec 28             	sub    $0x28,%esp
  802fa4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802fa7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802faa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802fad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802fb0:	89 3c 24             	mov    %edi,(%esp)
  802fb3:	e8 b8 ea ff ff       	call   801a70 <fd2data>
  802fb8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802fba:	be 00 00 00 00       	mov    $0x0,%esi
  802fbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fc3:	75 4c                	jne    803011 <devpipe_read+0x73>
  802fc5:	eb 5b                	jmp    803022 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802fc7:	89 f0                	mov    %esi,%eax
  802fc9:	eb 5e                	jmp    803029 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802fcb:	89 da                	mov    %ebx,%edx
  802fcd:	89 f8                	mov    %edi,%eax
  802fcf:	90                   	nop
  802fd0:	e8 cd fe ff ff       	call   802ea2 <_pipeisclosed>
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	74 07                	je     802fe0 <devpipe_read+0x42>
  802fd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fde:	eb 49                	jmp    803029 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802fe0:	e8 f5 e5 ff ff       	call   8015da <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802fe5:	8b 03                	mov    (%ebx),%eax
  802fe7:	3b 43 04             	cmp    0x4(%ebx),%eax
  802fea:	74 df                	je     802fcb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fec:	89 c2                	mov    %eax,%edx
  802fee:	c1 fa 1f             	sar    $0x1f,%edx
  802ff1:	c1 ea 1b             	shr    $0x1b,%edx
  802ff4:	01 d0                	add    %edx,%eax
  802ff6:	83 e0 1f             	and    $0x1f,%eax
  802ff9:	29 d0                	sub    %edx,%eax
  802ffb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803000:	8b 55 0c             	mov    0xc(%ebp),%edx
  803003:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803006:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803009:	83 c6 01             	add    $0x1,%esi
  80300c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80300f:	76 16                	jbe    803027 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  803011:	8b 03                	mov    (%ebx),%eax
  803013:	3b 43 04             	cmp    0x4(%ebx),%eax
  803016:	75 d4                	jne    802fec <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803018:	85 f6                	test   %esi,%esi
  80301a:	75 ab                	jne    802fc7 <devpipe_read+0x29>
  80301c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803020:	eb a9                	jmp    802fcb <devpipe_read+0x2d>
  803022:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803027:	89 f0                	mov    %esi,%eax
}
  803029:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80302c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80302f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803032:	89 ec                	mov    %ebp,%esp
  803034:	5d                   	pop    %ebp
  803035:	c3                   	ret    

00803036 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803036:	55                   	push   %ebp
  803037:	89 e5                	mov    %esp,%ebp
  803039:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80303c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80303f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	89 04 24             	mov    %eax,(%esp)
  803049:	e8 af ea ff ff       	call   801afd <fd_lookup>
  80304e:	85 c0                	test   %eax,%eax
  803050:	78 15                	js     803067 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	89 04 24             	mov    %eax,(%esp)
  803058:	e8 13 ea ff ff       	call   801a70 <fd2data>
	return _pipeisclosed(fd, p);
  80305d:	89 c2                	mov    %eax,%edx
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	e8 3b fe ff ff       	call   802ea2 <_pipeisclosed>
}
  803067:	c9                   	leave  
  803068:	c3                   	ret    

00803069 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803069:	55                   	push   %ebp
  80306a:	89 e5                	mov    %esp,%ebp
  80306c:	83 ec 48             	sub    $0x48,%esp
  80306f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803072:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803075:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803078:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80307b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80307e:	89 04 24             	mov    %eax,(%esp)
  803081:	e8 05 ea ff ff       	call   801a8b <fd_alloc>
  803086:	89 c3                	mov    %eax,%ebx
  803088:	85 c0                	test   %eax,%eax
  80308a:	0f 88 42 01 00 00    	js     8031d2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803090:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803097:	00 
  803098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80309f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030a6:	e8 d0 e4 ff ff       	call   80157b <sys_page_alloc>
  8030ab:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	0f 88 1d 01 00 00    	js     8031d2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030b8:	89 04 24             	mov    %eax,(%esp)
  8030bb:	e8 cb e9 ff ff       	call   801a8b <fd_alloc>
  8030c0:	89 c3                	mov    %eax,%ebx
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	0f 88 f5 00 00 00    	js     8031bf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030ca:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030d1:	00 
  8030d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030e0:	e8 96 e4 ff ff       	call   80157b <sys_page_alloc>
  8030e5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	0f 88 d0 00 00 00    	js     8031bf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8030ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f2:	89 04 24             	mov    %eax,(%esp)
  8030f5:	e8 76 e9 ff ff       	call   801a70 <fd2data>
  8030fa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030fc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803103:	00 
  803104:	89 44 24 04          	mov    %eax,0x4(%esp)
  803108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80310f:	e8 67 e4 ff ff       	call   80157b <sys_page_alloc>
  803114:	89 c3                	mov    %eax,%ebx
  803116:	85 c0                	test   %eax,%eax
  803118:	0f 88 8e 00 00 00    	js     8031ac <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80311e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803121:	89 04 24             	mov    %eax,(%esp)
  803124:	e8 47 e9 ff ff       	call   801a70 <fd2data>
  803129:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803130:	00 
  803131:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803135:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80313c:	00 
  80313d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803141:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803148:	e8 d0 e3 ff ff       	call   80151d <sys_page_map>
  80314d:	89 c3                	mov    %eax,%ebx
  80314f:	85 c0                	test   %eax,%eax
  803151:	78 49                	js     80319c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803153:	b8 58 70 80 00       	mov    $0x807058,%eax
  803158:	8b 08                	mov    (%eax),%ecx
  80315a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80315d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80315f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803162:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  803169:	8b 10                	mov    (%eax),%edx
  80316b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80316e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803170:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803173:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80317a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317d:	89 04 24             	mov    %eax,(%esp)
  803180:	e8 db e8 ff ff       	call   801a60 <fd2num>
  803185:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  803187:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318a:	89 04 24             	mov    %eax,(%esp)
  80318d:	e8 ce e8 ff ff       	call   801a60 <fd2num>
  803192:	89 47 04             	mov    %eax,0x4(%edi)
  803195:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80319a:	eb 36                	jmp    8031d2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80319c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031a7:	e8 13 e3 ff ff       	call   8014bf <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8031ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031ba:	e8 00 e3 ff ff       	call   8014bf <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8031bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031cd:	e8 ed e2 ff ff       	call   8014bf <sys_page_unmap>
    err:
	return r;
}
  8031d2:	89 d8                	mov    %ebx,%eax
  8031d4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8031d7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8031da:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8031dd:	89 ec                	mov    %ebp,%esp
  8031df:	5d                   	pop    %ebp
  8031e0:	c3                   	ret    
  8031e1:	00 00                	add    %al,(%eax)
	...

008031e4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8031e4:	55                   	push   %ebp
  8031e5:	89 e5                	mov    %esp,%ebp
  8031e7:	56                   	push   %esi
  8031e8:	53                   	push   %ebx
  8031e9:	83 ec 10             	sub    $0x10,%esp
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	75 24                	jne    803217 <wait+0x33>
  8031f3:	c7 44 24 0c 2a 3f 80 	movl   $0x803f2a,0xc(%esp)
  8031fa:	00 
  8031fb:	c7 44 24 08 26 3e 80 	movl   $0x803e26,0x8(%esp)
  803202:	00 
  803203:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80320a:	00 
  80320b:	c7 04 24 35 3f 80 00 	movl   $0x803f35,(%esp)
  803212:	e8 f1 d3 ff ff       	call   800608 <_panic>
	e = &envs[ENVX(envid)];
  803217:	89 c3                	mov    %eax,%ebx
  803219:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80321f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803222:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803228:	8b 73 4c             	mov    0x4c(%ebx),%esi
  80322b:	39 c6                	cmp    %eax,%esi
  80322d:	75 1a                	jne    803249 <wait+0x65>
  80322f:	8b 43 54             	mov    0x54(%ebx),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 13                	je     803249 <wait+0x65>
		sys_yield();
  803236:	e8 9f e3 ff ff       	call   8015da <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80323b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80323e:	39 f0                	cmp    %esi,%eax
  803240:	75 07                	jne    803249 <wait+0x65>
  803242:	8b 43 54             	mov    0x54(%ebx),%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	75 ed                	jne    803236 <wait+0x52>
		sys_yield();
}
  803249:	83 c4 10             	add    $0x10,%esp
  80324c:	5b                   	pop    %ebx
  80324d:	5e                   	pop    %esi
  80324e:	5d                   	pop    %ebp
  80324f:	c3                   	ret    

00803250 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803250:	55                   	push   %ebp
  803251:	89 e5                	mov    %esp,%ebp
  803253:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  803256:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  80325d:	75 78                	jne    8032d7 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80325f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803266:	00 
  803267:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80326e:	ee 
  80326f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803276:	e8 00 e3 ff ff       	call   80157b <sys_page_alloc>
  80327b:	85 c0                	test   %eax,%eax
  80327d:	79 20                	jns    80329f <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  80327f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803283:	c7 44 24 08 40 3f 80 	movl   $0x803f40,0x8(%esp)
  80328a:	00 
  80328b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  803292:	00 
  803293:	c7 04 24 5e 3f 80 00 	movl   $0x803f5e,(%esp)
  80329a:	e8 69 d3 ff ff       	call   800608 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80329f:	c7 44 24 04 e4 32 80 	movl   $0x8032e4,0x4(%esp)
  8032a6:	00 
  8032a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032ae:	e8 f2 e0 ff ff       	call   8013a5 <sys_env_set_pgfault_upcall>
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	79 20                	jns    8032d7 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  8032b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032bb:	c7 44 24 08 6c 3f 80 	movl   $0x803f6c,0x8(%esp)
  8032c2:	00 
  8032c3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8032ca:	00 
  8032cb:	c7 04 24 5e 3f 80 00 	movl   $0x803f5e,(%esp)
  8032d2:	e8 31 d3 ff ff       	call   800608 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	a3 7c 70 80 00       	mov    %eax,0x80707c
	
}
  8032df:	c9                   	leave  
  8032e0:	c3                   	ret    
  8032e1:	00 00                	add    %al,(%eax)
	...

008032e4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8032e4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8032e5:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  8032ea:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8032ec:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  8032ef:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  8032f1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  8032f5:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  8032f9:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  8032fb:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  8032fc:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  8032fe:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  803301:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  803305:	83 c4 08             	add    $0x8,%esp
	popal
  803308:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  803309:	83 c4 04             	add    $0x4,%esp
	popfl
  80330c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  80330d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  80330e:	c3                   	ret    
	...

00803310 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803310:	55                   	push   %ebp
  803311:	89 e5                	mov    %esp,%ebp
  803313:	57                   	push   %edi
  803314:	56                   	push   %esi
  803315:	53                   	push   %ebx
  803316:	83 ec 1c             	sub    $0x1c,%esp
  803319:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80331c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80331f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  803322:	85 db                	test   %ebx,%ebx
  803324:	75 2d                	jne    803353 <ipc_send+0x43>
  803326:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80332b:	eb 26                	jmp    803353 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80332d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803330:	74 1c                	je     80334e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  803332:	c7 44 24 08 98 3f 80 	movl   $0x803f98,0x8(%esp)
  803339:	00 
  80333a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  803341:	00 
  803342:	c7 04 24 bc 3f 80 00 	movl   $0x803fbc,(%esp)
  803349:	e8 ba d2 ff ff       	call   800608 <_panic>
		sys_yield();
  80334e:	e8 87 e2 ff ff       	call   8015da <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803353:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803357:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80335b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	89 04 24             	mov    %eax,(%esp)
  803365:	e8 03 e0 ff ff       	call   80136d <sys_ipc_try_send>
  80336a:	85 c0                	test   %eax,%eax
  80336c:	78 bf                	js     80332d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80336e:	83 c4 1c             	add    $0x1c,%esp
  803371:	5b                   	pop    %ebx
  803372:	5e                   	pop    %esi
  803373:	5f                   	pop    %edi
  803374:	5d                   	pop    %ebp
  803375:	c3                   	ret    

00803376 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803376:	55                   	push   %ebp
  803377:	89 e5                	mov    %esp,%ebp
  803379:	56                   	push   %esi
  80337a:	53                   	push   %ebx
  80337b:	83 ec 10             	sub    $0x10,%esp
  80337e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803381:	8b 45 0c             	mov    0xc(%ebp),%eax
  803384:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  803387:	85 c0                	test   %eax,%eax
  803389:	75 05                	jne    803390 <ipc_recv+0x1a>
  80338b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  803390:	89 04 24             	mov    %eax,(%esp)
  803393:	e8 78 df ff ff       	call   801310 <sys_ipc_recv>
  803398:	85 c0                	test   %eax,%eax
  80339a:	79 16                	jns    8033b2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80339c:	85 db                	test   %ebx,%ebx
  80339e:	74 06                	je     8033a6 <ipc_recv+0x30>
			*from_env_store = 0;
  8033a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8033a6:	85 f6                	test   %esi,%esi
  8033a8:	74 2c                	je     8033d6 <ipc_recv+0x60>
			*perm_store = 0;
  8033aa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8033b0:	eb 24                	jmp    8033d6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8033b2:	85 db                	test   %ebx,%ebx
  8033b4:	74 0a                	je     8033c0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8033b6:	a1 74 70 80 00       	mov    0x807074,%eax
  8033bb:	8b 40 74             	mov    0x74(%eax),%eax
  8033be:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  8033c0:	85 f6                	test   %esi,%esi
  8033c2:	74 0a                	je     8033ce <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  8033c4:	a1 74 70 80 00       	mov    0x807074,%eax
  8033c9:	8b 40 78             	mov    0x78(%eax),%eax
  8033cc:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  8033ce:	a1 74 70 80 00       	mov    0x807074,%eax
  8033d3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8033d6:	83 c4 10             	add    $0x10,%esp
  8033d9:	5b                   	pop    %ebx
  8033da:	5e                   	pop    %esi
  8033db:	5d                   	pop    %ebp
  8033dc:	c3                   	ret    
  8033dd:	00 00                	add    %al,(%eax)
	...

008033e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8033e0:	55                   	push   %ebp
  8033e1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	89 c2                	mov    %eax,%edx
  8033e8:	c1 ea 16             	shr    $0x16,%edx
  8033eb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8033f2:	f6 c2 01             	test   $0x1,%dl
  8033f5:	74 26                	je     80341d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8033f7:	c1 e8 0c             	shr    $0xc,%eax
  8033fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803401:	a8 01                	test   $0x1,%al
  803403:	74 18                	je     80341d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  803405:	c1 e8 0c             	shr    $0xc,%eax
  803408:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80340b:	c1 e2 02             	shl    $0x2,%edx
  80340e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803413:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  803418:	0f b7 c0             	movzwl %ax,%eax
  80341b:	eb 05                	jmp    803422 <pageref+0x42>
  80341d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
	...

00803430 <__udivdi3>:
  803430:	55                   	push   %ebp
  803431:	89 e5                	mov    %esp,%ebp
  803433:	57                   	push   %edi
  803434:	56                   	push   %esi
  803435:	83 ec 10             	sub    $0x10,%esp
  803438:	8b 45 14             	mov    0x14(%ebp),%eax
  80343b:	8b 55 08             	mov    0x8(%ebp),%edx
  80343e:	8b 75 10             	mov    0x10(%ebp),%esi
  803441:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803444:	85 c0                	test   %eax,%eax
  803446:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803449:	75 35                	jne    803480 <__udivdi3+0x50>
  80344b:	39 fe                	cmp    %edi,%esi
  80344d:	77 61                	ja     8034b0 <__udivdi3+0x80>
  80344f:	85 f6                	test   %esi,%esi
  803451:	75 0b                	jne    80345e <__udivdi3+0x2e>
  803453:	b8 01 00 00 00       	mov    $0x1,%eax
  803458:	31 d2                	xor    %edx,%edx
  80345a:	f7 f6                	div    %esi
  80345c:	89 c6                	mov    %eax,%esi
  80345e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803461:	31 d2                	xor    %edx,%edx
  803463:	89 f8                	mov    %edi,%eax
  803465:	f7 f6                	div    %esi
  803467:	89 c7                	mov    %eax,%edi
  803469:	89 c8                	mov    %ecx,%eax
  80346b:	f7 f6                	div    %esi
  80346d:	89 c1                	mov    %eax,%ecx
  80346f:	89 fa                	mov    %edi,%edx
  803471:	89 c8                	mov    %ecx,%eax
  803473:	83 c4 10             	add    $0x10,%esp
  803476:	5e                   	pop    %esi
  803477:	5f                   	pop    %edi
  803478:	5d                   	pop    %ebp
  803479:	c3                   	ret    
  80347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803480:	39 f8                	cmp    %edi,%eax
  803482:	77 1c                	ja     8034a0 <__udivdi3+0x70>
  803484:	0f bd d0             	bsr    %eax,%edx
  803487:	83 f2 1f             	xor    $0x1f,%edx
  80348a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80348d:	75 39                	jne    8034c8 <__udivdi3+0x98>
  80348f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803492:	0f 86 a0 00 00 00    	jbe    803538 <__udivdi3+0x108>
  803498:	39 f8                	cmp    %edi,%eax
  80349a:	0f 82 98 00 00 00    	jb     803538 <__udivdi3+0x108>
  8034a0:	31 ff                	xor    %edi,%edi
  8034a2:	31 c9                	xor    %ecx,%ecx
  8034a4:	89 c8                	mov    %ecx,%eax
  8034a6:	89 fa                	mov    %edi,%edx
  8034a8:	83 c4 10             	add    $0x10,%esp
  8034ab:	5e                   	pop    %esi
  8034ac:	5f                   	pop    %edi
  8034ad:	5d                   	pop    %ebp
  8034ae:	c3                   	ret    
  8034af:	90                   	nop
  8034b0:	89 d1                	mov    %edx,%ecx
  8034b2:	89 fa                	mov    %edi,%edx
  8034b4:	89 c8                	mov    %ecx,%eax
  8034b6:	31 ff                	xor    %edi,%edi
  8034b8:	f7 f6                	div    %esi
  8034ba:	89 c1                	mov    %eax,%ecx
  8034bc:	89 fa                	mov    %edi,%edx
  8034be:	89 c8                	mov    %ecx,%eax
  8034c0:	83 c4 10             	add    $0x10,%esp
  8034c3:	5e                   	pop    %esi
  8034c4:	5f                   	pop    %edi
  8034c5:	5d                   	pop    %ebp
  8034c6:	c3                   	ret    
  8034c7:	90                   	nop
  8034c8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8034cc:	89 f2                	mov    %esi,%edx
  8034ce:	d3 e0                	shl    %cl,%eax
  8034d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8034d3:	b8 20 00 00 00       	mov    $0x20,%eax
  8034d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8034db:	89 c1                	mov    %eax,%ecx
  8034dd:	d3 ea                	shr    %cl,%edx
  8034df:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8034e3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8034e6:	d3 e6                	shl    %cl,%esi
  8034e8:	89 c1                	mov    %eax,%ecx
  8034ea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8034ed:	89 fe                	mov    %edi,%esi
  8034ef:	d3 ee                	shr    %cl,%esi
  8034f1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8034f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8034f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034fb:	d3 e7                	shl    %cl,%edi
  8034fd:	89 c1                	mov    %eax,%ecx
  8034ff:	d3 ea                	shr    %cl,%edx
  803501:	09 d7                	or     %edx,%edi
  803503:	89 f2                	mov    %esi,%edx
  803505:	89 f8                	mov    %edi,%eax
  803507:	f7 75 ec             	divl   -0x14(%ebp)
  80350a:	89 d6                	mov    %edx,%esi
  80350c:	89 c7                	mov    %eax,%edi
  80350e:	f7 65 e8             	mull   -0x18(%ebp)
  803511:	39 d6                	cmp    %edx,%esi
  803513:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803516:	72 30                	jb     803548 <__udivdi3+0x118>
  803518:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80351f:	d3 e2                	shl    %cl,%edx
  803521:	39 c2                	cmp    %eax,%edx
  803523:	73 05                	jae    80352a <__udivdi3+0xfa>
  803525:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  803528:	74 1e                	je     803548 <__udivdi3+0x118>
  80352a:	89 f9                	mov    %edi,%ecx
  80352c:	31 ff                	xor    %edi,%edi
  80352e:	e9 71 ff ff ff       	jmp    8034a4 <__udivdi3+0x74>
  803533:	90                   	nop
  803534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803538:	31 ff                	xor    %edi,%edi
  80353a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80353f:	e9 60 ff ff ff       	jmp    8034a4 <__udivdi3+0x74>
  803544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803548:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80354b:	31 ff                	xor    %edi,%edi
  80354d:	89 c8                	mov    %ecx,%eax
  80354f:	89 fa                	mov    %edi,%edx
  803551:	83 c4 10             	add    $0x10,%esp
  803554:	5e                   	pop    %esi
  803555:	5f                   	pop    %edi
  803556:	5d                   	pop    %ebp
  803557:	c3                   	ret    
	...

00803560 <__umoddi3>:
  803560:	55                   	push   %ebp
  803561:	89 e5                	mov    %esp,%ebp
  803563:	57                   	push   %edi
  803564:	56                   	push   %esi
  803565:	83 ec 20             	sub    $0x20,%esp
  803568:	8b 55 14             	mov    0x14(%ebp),%edx
  80356b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80356e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803571:	8b 75 0c             	mov    0xc(%ebp),%esi
  803574:	85 d2                	test   %edx,%edx
  803576:	89 c8                	mov    %ecx,%eax
  803578:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80357b:	75 13                	jne    803590 <__umoddi3+0x30>
  80357d:	39 f7                	cmp    %esi,%edi
  80357f:	76 3f                	jbe    8035c0 <__umoddi3+0x60>
  803581:	89 f2                	mov    %esi,%edx
  803583:	f7 f7                	div    %edi
  803585:	89 d0                	mov    %edx,%eax
  803587:	31 d2                	xor    %edx,%edx
  803589:	83 c4 20             	add    $0x20,%esp
  80358c:	5e                   	pop    %esi
  80358d:	5f                   	pop    %edi
  80358e:	5d                   	pop    %ebp
  80358f:	c3                   	ret    
  803590:	39 f2                	cmp    %esi,%edx
  803592:	77 4c                	ja     8035e0 <__umoddi3+0x80>
  803594:	0f bd ca             	bsr    %edx,%ecx
  803597:	83 f1 1f             	xor    $0x1f,%ecx
  80359a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80359d:	75 51                	jne    8035f0 <__umoddi3+0x90>
  80359f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8035a2:	0f 87 e0 00 00 00    	ja     803688 <__umoddi3+0x128>
  8035a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ab:	29 f8                	sub    %edi,%eax
  8035ad:	19 d6                	sbb    %edx,%esi
  8035af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	89 f2                	mov    %esi,%edx
  8035b7:	83 c4 20             	add    $0x20,%esp
  8035ba:	5e                   	pop    %esi
  8035bb:	5f                   	pop    %edi
  8035bc:	5d                   	pop    %ebp
  8035bd:	c3                   	ret    
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	85 ff                	test   %edi,%edi
  8035c2:	75 0b                	jne    8035cf <__umoddi3+0x6f>
  8035c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8035c9:	31 d2                	xor    %edx,%edx
  8035cb:	f7 f7                	div    %edi
  8035cd:	89 c7                	mov    %eax,%edi
  8035cf:	89 f0                	mov    %esi,%eax
  8035d1:	31 d2                	xor    %edx,%edx
  8035d3:	f7 f7                	div    %edi
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	f7 f7                	div    %edi
  8035da:	eb a9                	jmp    803585 <__umoddi3+0x25>
  8035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8035e0:	89 c8                	mov    %ecx,%eax
  8035e2:	89 f2                	mov    %esi,%edx
  8035e4:	83 c4 20             	add    $0x20,%esp
  8035e7:	5e                   	pop    %esi
  8035e8:	5f                   	pop    %edi
  8035e9:	5d                   	pop    %ebp
  8035ea:	c3                   	ret    
  8035eb:	90                   	nop
  8035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8035f0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8035f4:	d3 e2                	shl    %cl,%edx
  8035f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8035f9:	ba 20 00 00 00       	mov    $0x20,%edx
  8035fe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  803601:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803604:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803608:	89 fa                	mov    %edi,%edx
  80360a:	d3 ea                	shr    %cl,%edx
  80360c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803610:	0b 55 f4             	or     -0xc(%ebp),%edx
  803613:	d3 e7                	shl    %cl,%edi
  803615:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803619:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80361c:	89 f2                	mov    %esi,%edx
  80361e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  803621:	89 c7                	mov    %eax,%edi
  803623:	d3 ea                	shr    %cl,%edx
  803625:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803629:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80362c:	89 c2                	mov    %eax,%edx
  80362e:	d3 e6                	shl    %cl,%esi
  803630:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803634:	d3 ea                	shr    %cl,%edx
  803636:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80363a:	09 d6                	or     %edx,%esi
  80363c:	89 f0                	mov    %esi,%eax
  80363e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803641:	d3 e7                	shl    %cl,%edi
  803643:	89 f2                	mov    %esi,%edx
  803645:	f7 75 f4             	divl   -0xc(%ebp)
  803648:	89 d6                	mov    %edx,%esi
  80364a:	f7 65 e8             	mull   -0x18(%ebp)
  80364d:	39 d6                	cmp    %edx,%esi
  80364f:	72 2b                	jb     80367c <__umoddi3+0x11c>
  803651:	39 c7                	cmp    %eax,%edi
  803653:	72 23                	jb     803678 <__umoddi3+0x118>
  803655:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803659:	29 c7                	sub    %eax,%edi
  80365b:	19 d6                	sbb    %edx,%esi
  80365d:	89 f0                	mov    %esi,%eax
  80365f:	89 f2                	mov    %esi,%edx
  803661:	d3 ef                	shr    %cl,%edi
  803663:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803667:	d3 e0                	shl    %cl,%eax
  803669:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80366d:	09 f8                	or     %edi,%eax
  80366f:	d3 ea                	shr    %cl,%edx
  803671:	83 c4 20             	add    $0x20,%esp
  803674:	5e                   	pop    %esi
  803675:	5f                   	pop    %edi
  803676:	5d                   	pop    %ebp
  803677:	c3                   	ret    
  803678:	39 d6                	cmp    %edx,%esi
  80367a:	75 d9                	jne    803655 <__umoddi3+0xf5>
  80367c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80367f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803682:	eb d1                	jmp    803655 <__umoddi3+0xf5>
  803684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803688:	39 f2                	cmp    %esi,%edx
  80368a:	0f 82 18 ff ff ff    	jb     8035a8 <__umoddi3+0x48>
  803690:	e9 1d ff ff ff       	jmp    8035b2 <__umoddi3+0x52>
