
obj/user/pingpong:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
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
	
	envid_t who;

	if ((who = fork()) != 0) {
  80003d:	e8 c3 12 00 00       	call   801305 <fork>
  800042:	89 c3                	mov    %eax,%ebx
  800044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800047:	85 c0                	test   %eax,%eax
  800049:	74 3c                	je     800087 <umain+0x53>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004b:	e8 be 10 00 00       	call   80110e <sys_getenvid>
  800050:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800054:	89 44 24 04          	mov    %eax,0x4(%esp)
  800058:	c7 04 24 20 2d 80 00 	movl   $0x802d20,(%esp)
  80005f:	e8 61 01 00 00       	call   8001c5 <cprintf>
		ipc_send(who, 0, 0, 0);
  800064:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006b:	00 
  80006c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800073:	00 
  800074:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007b:	00 
  80007c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 d9 14 00 00       	call   801560 <ipc_send>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800087:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  80008a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800099:	00 
  80009a:	89 3c 24             	mov    %edi,(%esp)
  80009d:	e8 24 15 00 00       	call   8015c6 <ipc_recv>
  8000a2:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000a7:	e8 62 10 00 00       	call   80110e <sys_getenvid>
  8000ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b8:	c7 04 24 36 2d 80 00 	movl   $0x802d36,(%esp)
  8000bf:	e8 01 01 00 00       	call   8001c5 <cprintf>
		if (i == 10)
  8000c4:	83 fb 0a             	cmp    $0xa,%ebx
  8000c7:	74 27                	je     8000f0 <umain+0xbc>
			return;
		i++;
  8000c9:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d3:	00 
  8000d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000db:	00 
  8000dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e3:	89 04 24             	mov    %eax,(%esp)
  8000e6:	e8 75 14 00 00       	call   801560 <ipc_send>
		if (i == 10)
  8000eb:	83 fb 0a             	cmp    $0xa,%ebx
  8000ee:	75 9a                	jne    80008a <umain+0x56>
			return;
	}
	
}
  8000f0:	83 c4 2c             	add    $0x2c,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 18             	sub    $0x18,%esp
  8000fe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800101:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800104:	8b 75 08             	mov    0x8(%ebp),%esi
  800107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80010a:	e8 ff 0f 00 00       	call   80110e <sys_getenvid>
	env = &envs[ENVX(envid)];
  80010f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800114:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800117:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011c:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800121:	85 f6                	test   %esi,%esi
  800123:	7e 07                	jle    80012c <libmain+0x34>
		binaryname = argv[0];
  800125:	8b 03                	mov    (%ebx),%eax
  800127:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  80012c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800130:	89 34 24             	mov    %esi,(%esp)
  800133:	e8 fc fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800138:	e8 0b 00 00 00       	call   800148 <exit>
}
  80013d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800140:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800143:	89 ec                	mov    %ebp,%esp
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    
	...

00800148 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80014e:	e8 b8 19 00 00       	call   801b0b <close_all>
	sys_env_destroy(0);
  800153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015a:	e8 e3 0f 00 00       	call   801142 <sys_env_destroy>
}
  80015f:	c9                   	leave  
  800160:	c3                   	ret    
  800161:	00 00                	add    %al,(%eax)
	...

00800164 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80016d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800174:	00 00 00 
	b.cnt = 0;
  800177:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800181:	8b 45 0c             	mov    0xc(%ebp),%eax
  800184:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800188:	8b 45 08             	mov    0x8(%ebp),%eax
  80018b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80018f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800195:	89 44 24 04          	mov    %eax,0x4(%esp)
  800199:	c7 04 24 df 01 80 00 	movl   $0x8001df,(%esp)
  8001a0:	e8 d8 01 00 00       	call   80037d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001af:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b5:	89 04 24             	mov    %eax,(%esp)
  8001b8:	e8 c3 0a 00 00       	call   800c80 <sys_cputs>

	return b.cnt;
}
  8001bd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    

008001c5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8001cb:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8001ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 87 ff ff ff       	call   800164 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001dd:	c9                   	leave  
  8001de:	c3                   	ret    

008001df <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	53                   	push   %ebx
  8001e3:	83 ec 14             	sub    $0x14,%esp
  8001e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e9:	8b 03                	mov    (%ebx),%eax
  8001eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ee:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001f2:	83 c0 01             	add    $0x1,%eax
  8001f5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001f7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001fc:	75 19                	jne    800217 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001fe:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800205:	00 
  800206:	8d 43 08             	lea    0x8(%ebx),%eax
  800209:	89 04 24             	mov    %eax,(%esp)
  80020c:	e8 6f 0a 00 00       	call   800c80 <sys_cputs>
		b->idx = 0;
  800211:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800217:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80021b:	83 c4 14             	add    $0x14,%esp
  80021e:	5b                   	pop    %ebx
  80021f:	5d                   	pop    %ebp
  800220:	c3                   	ret    
	...

00800230 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 4c             	sub    $0x4c,%esp
  800239:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80023c:	89 d6                	mov    %edx,%esi
  80023e:	8b 45 08             	mov    0x8(%ebp),%eax
  800241:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800244:	8b 55 0c             	mov    0xc(%ebp),%edx
  800247:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800250:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800253:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800256:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025b:	39 d1                	cmp    %edx,%ecx
  80025d:	72 15                	jb     800274 <printnum+0x44>
  80025f:	77 07                	ja     800268 <printnum+0x38>
  800261:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800264:	39 d0                	cmp    %edx,%eax
  800266:	76 0c                	jbe    800274 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800268:	83 eb 01             	sub    $0x1,%ebx
  80026b:	85 db                	test   %ebx,%ebx
  80026d:	8d 76 00             	lea    0x0(%esi),%esi
  800270:	7f 61                	jg     8002d3 <printnum+0xa3>
  800272:	eb 70                	jmp    8002e4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800274:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800278:	83 eb 01             	sub    $0x1,%ebx
  80027b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80027f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800283:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800287:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80028b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80028e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800291:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800294:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800298:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80029f:	00 
  8002a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a3:	89 04 24             	mov    %eax,(%esp)
  8002a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002ad:	e8 ee 27 00 00       	call   802aa0 <__udivdi3>
  8002b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002c0:	89 04 24             	mov    %eax,(%esp)
  8002c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002c7:	89 f2                	mov    %esi,%edx
  8002c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002cc:	e8 5f ff ff ff       	call   800230 <printnum>
  8002d1:	eb 11                	jmp    8002e4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002d7:	89 3c 24             	mov    %edi,(%esp)
  8002da:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002dd:	83 eb 01             	sub    $0x1,%ebx
  8002e0:	85 db                	test   %ebx,%ebx
  8002e2:	7f ef                	jg     8002d3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002fa:	00 
  8002fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002fe:	89 14 24             	mov    %edx,(%esp)
  800301:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800304:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800308:	e8 c3 28 00 00       	call   802bd0 <__umoddi3>
  80030d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800311:	0f be 80 60 2d 80 00 	movsbl 0x802d60(%eax),%eax
  800318:	89 04 24             	mov    %eax,(%esp)
  80031b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80031e:	83 c4 4c             	add    $0x4c,%esp
  800321:	5b                   	pop    %ebx
  800322:	5e                   	pop    %esi
  800323:	5f                   	pop    %edi
  800324:	5d                   	pop    %ebp
  800325:	c3                   	ret    

00800326 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800329:	83 fa 01             	cmp    $0x1,%edx
  80032c:	7e 0e                	jle    80033c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80032e:	8b 10                	mov    (%eax),%edx
  800330:	8d 4a 08             	lea    0x8(%edx),%ecx
  800333:	89 08                	mov    %ecx,(%eax)
  800335:	8b 02                	mov    (%edx),%eax
  800337:	8b 52 04             	mov    0x4(%edx),%edx
  80033a:	eb 22                	jmp    80035e <getuint+0x38>
	else if (lflag)
  80033c:	85 d2                	test   %edx,%edx
  80033e:	74 10                	je     800350 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8d 4a 04             	lea    0x4(%edx),%ecx
  800345:	89 08                	mov    %ecx,(%eax)
  800347:	8b 02                	mov    (%edx),%eax
  800349:	ba 00 00 00 00       	mov    $0x0,%edx
  80034e:	eb 0e                	jmp    80035e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800350:	8b 10                	mov    (%eax),%edx
  800352:	8d 4a 04             	lea    0x4(%edx),%ecx
  800355:	89 08                	mov    %ecx,(%eax)
  800357:	8b 02                	mov    (%edx),%eax
  800359:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80035e:	5d                   	pop    %ebp
  80035f:	c3                   	ret    

00800360 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800366:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80036a:	8b 10                	mov    (%eax),%edx
  80036c:	3b 50 04             	cmp    0x4(%eax),%edx
  80036f:	73 0a                	jae    80037b <sprintputch+0x1b>
		*b->buf++ = ch;
  800371:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800374:	88 0a                	mov    %cl,(%edx)
  800376:	83 c2 01             	add    $0x1,%edx
  800379:	89 10                	mov    %edx,(%eax)
}
  80037b:	5d                   	pop    %ebp
  80037c:	c3                   	ret    

0080037d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	57                   	push   %edi
  800381:	56                   	push   %esi
  800382:	53                   	push   %ebx
  800383:	83 ec 5c             	sub    $0x5c,%esp
  800386:	8b 7d 08             	mov    0x8(%ebp),%edi
  800389:	8b 75 0c             	mov    0xc(%ebp),%esi
  80038c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80038f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800396:	eb 11                	jmp    8003a9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800398:	85 c0                	test   %eax,%eax
  80039a:	0f 84 ec 03 00 00    	je     80078c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8003a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003a4:	89 04 24             	mov    %eax,(%esp)
  8003a7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a9:	0f b6 03             	movzbl (%ebx),%eax
  8003ac:	83 c3 01             	add    $0x1,%ebx
  8003af:	83 f8 25             	cmp    $0x25,%eax
  8003b2:	75 e4                	jne    800398 <vprintfmt+0x1b>
  8003b4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8003b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003bf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d2:	eb 06                	jmp    8003da <vprintfmt+0x5d>
  8003d4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003d8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	0f b6 13             	movzbl (%ebx),%edx
  8003dd:	0f b6 c2             	movzbl %dl,%eax
  8003e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e3:	8d 43 01             	lea    0x1(%ebx),%eax
  8003e6:	83 ea 23             	sub    $0x23,%edx
  8003e9:	80 fa 55             	cmp    $0x55,%dl
  8003ec:	0f 87 7d 03 00 00    	ja     80076f <vprintfmt+0x3f2>
  8003f2:	0f b6 d2             	movzbl %dl,%edx
  8003f5:	ff 24 95 a0 2e 80 00 	jmp    *0x802ea0(,%edx,4)
  8003fc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800400:	eb d6                	jmp    8003d8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800402:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800405:	83 ea 30             	sub    $0x30,%edx
  800408:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80040b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80040e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800411:	83 fb 09             	cmp    $0x9,%ebx
  800414:	77 4c                	ja     800462 <vprintfmt+0xe5>
  800416:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800419:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80041c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80041f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800422:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800426:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800429:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80042c:	83 fb 09             	cmp    $0x9,%ebx
  80042f:	76 eb                	jbe    80041c <vprintfmt+0x9f>
  800431:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800434:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800437:	eb 29                	jmp    800462 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800439:	8b 55 14             	mov    0x14(%ebp),%edx
  80043c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80043f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800442:	8b 12                	mov    (%edx),%edx
  800444:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800447:	eb 19                	jmp    800462 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800449:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80044c:	c1 fa 1f             	sar    $0x1f,%edx
  80044f:	f7 d2                	not    %edx
  800451:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800454:	eb 82                	jmp    8003d8 <vprintfmt+0x5b>
  800456:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80045d:	e9 76 ff ff ff       	jmp    8003d8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800462:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800466:	0f 89 6c ff ff ff    	jns    8003d8 <vprintfmt+0x5b>
  80046c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80046f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800472:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800475:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800478:	e9 5b ff ff ff       	jmp    8003d8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80047d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800480:	e9 53 ff ff ff       	jmp    8003d8 <vprintfmt+0x5b>
  800485:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8d 50 04             	lea    0x4(%eax),%edx
  80048e:	89 55 14             	mov    %edx,0x14(%ebp)
  800491:	89 74 24 04          	mov    %esi,0x4(%esp)
  800495:	8b 00                	mov    (%eax),%eax
  800497:	89 04 24             	mov    %eax,(%esp)
  80049a:	ff d7                	call   *%edi
  80049c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80049f:	e9 05 ff ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  8004a4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	c1 fa 1f             	sar    $0x1f,%edx
  8004b7:	31 d0                	xor    %edx,%eax
  8004b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004bb:	83 f8 0f             	cmp    $0xf,%eax
  8004be:	7f 0b                	jg     8004cb <vprintfmt+0x14e>
  8004c0:	8b 14 85 00 30 80 00 	mov    0x803000(,%eax,4),%edx
  8004c7:	85 d2                	test   %edx,%edx
  8004c9:	75 20                	jne    8004eb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8004cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004cf:	c7 44 24 08 71 2d 80 	movl   $0x802d71,0x8(%esp)
  8004d6:	00 
  8004d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004db:	89 3c 24             	mov    %edi,(%esp)
  8004de:	e8 31 03 00 00       	call   800814 <printfmt>
  8004e3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004e6:	e9 be fe ff ff       	jmp    8003a9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ef:	c7 44 24 08 62 33 80 	movl   $0x803362,0x8(%esp)
  8004f6:	00 
  8004f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004fb:	89 3c 24             	mov    %edi,(%esp)
  8004fe:	e8 11 03 00 00       	call   800814 <printfmt>
  800503:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800506:	e9 9e fe ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  80050b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80050e:	89 c3                	mov    %eax,%ebx
  800510:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800516:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 50 04             	lea    0x4(%eax),%edx
  80051f:	89 55 14             	mov    %edx,0x14(%ebp)
  800522:	8b 00                	mov    (%eax),%eax
  800524:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800527:	85 c0                	test   %eax,%eax
  800529:	75 07                	jne    800532 <vprintfmt+0x1b5>
  80052b:	c7 45 e0 7a 2d 80 00 	movl   $0x802d7a,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800532:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800536:	7e 06                	jle    80053e <vprintfmt+0x1c1>
  800538:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80053c:	75 13                	jne    800551 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800541:	0f be 02             	movsbl (%edx),%eax
  800544:	85 c0                	test   %eax,%eax
  800546:	0f 85 99 00 00 00    	jne    8005e5 <vprintfmt+0x268>
  80054c:	e9 86 00 00 00       	jmp    8005d7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800551:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800555:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800558:	89 0c 24             	mov    %ecx,(%esp)
  80055b:	e8 fb 02 00 00       	call   80085b <strnlen>
  800560:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800563:	29 c2                	sub    %eax,%edx
  800565:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800568:	85 d2                	test   %edx,%edx
  80056a:	7e d2                	jle    80053e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80056c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800570:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800573:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800576:	89 d3                	mov    %edx,%ebx
  800578:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800584:	83 eb 01             	sub    $0x1,%ebx
  800587:	85 db                	test   %ebx,%ebx
  800589:	7f ed                	jg     800578 <vprintfmt+0x1fb>
  80058b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80058e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800595:	eb a7                	jmp    80053e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800597:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80059b:	74 18                	je     8005b5 <vprintfmt+0x238>
  80059d:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005a0:	83 fa 5e             	cmp    $0x5e,%edx
  8005a3:	76 10                	jbe    8005b5 <vprintfmt+0x238>
					putch('?', putdat);
  8005a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005b0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005b3:	eb 0a                	jmp    8005bf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b9:	89 04 24             	mov    %eax,(%esp)
  8005bc:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005c3:	0f be 03             	movsbl (%ebx),%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	74 05                	je     8005cf <vprintfmt+0x252>
  8005ca:	83 c3 01             	add    $0x1,%ebx
  8005cd:	eb 29                	jmp    8005f8 <vprintfmt+0x27b>
  8005cf:	89 fe                	mov    %edi,%esi
  8005d1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005d4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005db:	7f 2e                	jg     80060b <vprintfmt+0x28e>
  8005dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8005e0:	e9 c4 fd ff ff       	jmp    8003a9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e8:	83 c2 01             	add    $0x1,%edx
  8005eb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005ee:	89 f7                	mov    %esi,%edi
  8005f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005f3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8005f6:	89 d3                	mov    %edx,%ebx
  8005f8:	85 f6                	test   %esi,%esi
  8005fa:	78 9b                	js     800597 <vprintfmt+0x21a>
  8005fc:	83 ee 01             	sub    $0x1,%esi
  8005ff:	79 96                	jns    800597 <vprintfmt+0x21a>
  800601:	89 fe                	mov    %edi,%esi
  800603:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800606:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800609:	eb cc                	jmp    8005d7 <vprintfmt+0x25a>
  80060b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80060e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800611:	89 74 24 04          	mov    %esi,0x4(%esp)
  800615:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80061c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80061e:	83 eb 01             	sub    $0x1,%ebx
  800621:	85 db                	test   %ebx,%ebx
  800623:	7f ec                	jg     800611 <vprintfmt+0x294>
  800625:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800628:	e9 7c fd ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  80062d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800630:	83 f9 01             	cmp    $0x1,%ecx
  800633:	7e 16                	jle    80064b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 50 08             	lea    0x8(%eax),%edx
  80063b:	89 55 14             	mov    %edx,0x14(%ebp)
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 48 04             	mov    0x4(%eax),%ecx
  800643:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800646:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800649:	eb 32                	jmp    80067d <vprintfmt+0x300>
	else if (lflag)
  80064b:	85 c9                	test   %ecx,%ecx
  80064d:	74 18                	je     800667 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 50 04             	lea    0x4(%eax),%edx
  800655:	89 55 14             	mov    %edx,0x14(%ebp)
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065d:	89 c1                	mov    %eax,%ecx
  80065f:	c1 f9 1f             	sar    $0x1f,%ecx
  800662:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800665:	eb 16                	jmp    80067d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 50 04             	lea    0x4(%eax),%edx
  80066d:	89 55 14             	mov    %edx,0x14(%ebp)
  800670:	8b 00                	mov    (%eax),%eax
  800672:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800675:	89 c2                	mov    %eax,%edx
  800677:	c1 fa 1f             	sar    $0x1f,%edx
  80067a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80067d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800680:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800683:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800688:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068c:	0f 89 9b 00 00 00    	jns    80072d <vprintfmt+0x3b0>
				putch('-', putdat);
  800692:	89 74 24 04          	mov    %esi,0x4(%esp)
  800696:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80069d:	ff d7                	call   *%edi
				num = -(long long) num;
  80069f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006a2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006a5:	f7 d9                	neg    %ecx
  8006a7:	83 d3 00             	adc    $0x0,%ebx
  8006aa:	f7 db                	neg    %ebx
  8006ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b1:	eb 7a                	jmp    80072d <vprintfmt+0x3b0>
  8006b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006b6:	89 ca                	mov    %ecx,%edx
  8006b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006bb:	e8 66 fc ff ff       	call   800326 <getuint>
  8006c0:	89 c1                	mov    %eax,%ecx
  8006c2:	89 d3                	mov    %edx,%ebx
  8006c4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006c9:	eb 62                	jmp    80072d <vprintfmt+0x3b0>
  8006cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8006ce:	89 ca                	mov    %ecx,%edx
  8006d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d3:	e8 4e fc ff ff       	call   800326 <getuint>
  8006d8:	89 c1                	mov    %eax,%ecx
  8006da:	89 d3                	mov    %edx,%ebx
  8006dc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006e1:	eb 4a                	jmp    80072d <vprintfmt+0x3b0>
  8006e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8006e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ea:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006f1:	ff d7                	call   *%edi
			putch('x', putdat);
  8006f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006fe:	ff d7                	call   *%edi
			num = (unsigned long long)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 50 04             	lea    0x4(%eax),%edx
  800706:	89 55 14             	mov    %edx,0x14(%ebp)
  800709:	8b 08                	mov    (%eax),%ecx
  80070b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800710:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800715:	eb 16                	jmp    80072d <vprintfmt+0x3b0>
  800717:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80071a:	89 ca                	mov    %ecx,%edx
  80071c:	8d 45 14             	lea    0x14(%ebp),%eax
  80071f:	e8 02 fc ff ff       	call   800326 <getuint>
  800724:	89 c1                	mov    %eax,%ecx
  800726:	89 d3                	mov    %edx,%ebx
  800728:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80072d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800731:	89 54 24 10          	mov    %edx,0x10(%esp)
  800735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800738:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80073c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800740:	89 0c 24             	mov    %ecx,(%esp)
  800743:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800747:	89 f2                	mov    %esi,%edx
  800749:	89 f8                	mov    %edi,%eax
  80074b:	e8 e0 fa ff ff       	call   800230 <printnum>
  800750:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800753:	e9 51 fc ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  800758:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80075b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80075e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800762:	89 14 24             	mov    %edx,(%esp)
  800765:	ff d7                	call   *%edi
  800767:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80076a:	e9 3a fc ff ff       	jmp    8003a9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80076f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800773:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80077a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80077c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80077f:	80 38 25             	cmpb   $0x25,(%eax)
  800782:	0f 84 21 fc ff ff    	je     8003a9 <vprintfmt+0x2c>
  800788:	89 c3                	mov    %eax,%ebx
  80078a:	eb f0                	jmp    80077c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80078c:	83 c4 5c             	add    $0x5c,%esp
  80078f:	5b                   	pop    %ebx
  800790:	5e                   	pop    %esi
  800791:	5f                   	pop    %edi
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 28             	sub    $0x28,%esp
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	74 04                	je     8007a8 <vsnprintf+0x14>
  8007a4:	85 d2                	test   %edx,%edx
  8007a6:	7f 07                	jg     8007af <vsnprintf+0x1b>
  8007a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ad:	eb 3b                	jmp    8007ea <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d5:	c7 04 24 60 03 80 00 	movl   $0x800360,(%esp)
  8007dc:	e8 9c fb ff ff       	call   80037d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ea:	c9                   	leave  
  8007eb:	c3                   	ret    

008007ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8007f2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8007f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	89 44 24 04          	mov    %eax,0x4(%esp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	89 04 24             	mov    %eax,(%esp)
  80080d:	e8 82 ff ff ff       	call   800794 <vsnprintf>
	va_end(ap);

	return rc;
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80081a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80081d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800821:	8b 45 10             	mov    0x10(%ebp),%eax
  800824:	89 44 24 08          	mov    %eax,0x8(%esp)
  800828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	89 04 24             	mov    %eax,(%esp)
  800835:	e8 43 fb ff ff       	call   80037d <vprintfmt>
	va_end(ap);
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    
  80083c:	00 00                	add    %al,(%eax)
	...

00800840 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	80 3a 00             	cmpb   $0x0,(%edx)
  80084e:	74 09                	je     800859 <strlen+0x19>
		n++;
  800850:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800853:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800857:	75 f7                	jne    800850 <strlen+0x10>
		n++;
	return n;
}
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800862:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800865:	85 c9                	test   %ecx,%ecx
  800867:	74 19                	je     800882 <strnlen+0x27>
  800869:	80 3b 00             	cmpb   $0x0,(%ebx)
  80086c:	74 14                	je     800882 <strnlen+0x27>
  80086e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800873:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800876:	39 c8                	cmp    %ecx,%eax
  800878:	74 0d                	je     800887 <strnlen+0x2c>
  80087a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80087e:	75 f3                	jne    800873 <strnlen+0x18>
  800880:	eb 05                	jmp    800887 <strnlen+0x2c>
  800882:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800887:	5b                   	pop    %ebx
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	53                   	push   %ebx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800894:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800899:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80089d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008a0:	83 c2 01             	add    $0x1,%edx
  8008a3:	84 c9                	test   %cl,%cl
  8008a5:	75 f2                	jne    800899 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	56                   	push   %esi
  8008ae:	53                   	push   %ebx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b8:	85 f6                	test   %esi,%esi
  8008ba:	74 18                	je     8008d4 <strncpy+0x2a>
  8008bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008c1:	0f b6 1a             	movzbl (%edx),%ebx
  8008c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8008ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008cd:	83 c1 01             	add    $0x1,%ecx
  8008d0:	39 ce                	cmp    %ecx,%esi
  8008d2:	77 ed                	ja     8008c1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008d4:	5b                   	pop    %ebx
  8008d5:	5e                   	pop    %esi
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e6:	89 f0                	mov    %esi,%eax
  8008e8:	85 c9                	test   %ecx,%ecx
  8008ea:	74 27                	je     800913 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8008ec:	83 e9 01             	sub    $0x1,%ecx
  8008ef:	74 1d                	je     80090e <strlcpy+0x36>
  8008f1:	0f b6 1a             	movzbl (%edx),%ebx
  8008f4:	84 db                	test   %bl,%bl
  8008f6:	74 16                	je     80090e <strlcpy+0x36>
			*dst++ = *src++;
  8008f8:	88 18                	mov    %bl,(%eax)
  8008fa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008fd:	83 e9 01             	sub    $0x1,%ecx
  800900:	74 0e                	je     800910 <strlcpy+0x38>
			*dst++ = *src++;
  800902:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800905:	0f b6 1a             	movzbl (%edx),%ebx
  800908:	84 db                	test   %bl,%bl
  80090a:	75 ec                	jne    8008f8 <strlcpy+0x20>
  80090c:	eb 02                	jmp    800910 <strlcpy+0x38>
  80090e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800910:	c6 00 00             	movb   $0x0,(%eax)
  800913:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800915:	5b                   	pop    %ebx
  800916:	5e                   	pop    %esi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    

00800919 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
  80091c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800922:	0f b6 01             	movzbl (%ecx),%eax
  800925:	84 c0                	test   %al,%al
  800927:	74 15                	je     80093e <strcmp+0x25>
  800929:	3a 02                	cmp    (%edx),%al
  80092b:	75 11                	jne    80093e <strcmp+0x25>
		p++, q++;
  80092d:	83 c1 01             	add    $0x1,%ecx
  800930:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800933:	0f b6 01             	movzbl (%ecx),%eax
  800936:	84 c0                	test   %al,%al
  800938:	74 04                	je     80093e <strcmp+0x25>
  80093a:	3a 02                	cmp    (%edx),%al
  80093c:	74 ef                	je     80092d <strcmp+0x14>
  80093e:	0f b6 c0             	movzbl %al,%eax
  800941:	0f b6 12             	movzbl (%edx),%edx
  800944:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	53                   	push   %ebx
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
  80094f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800952:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800955:	85 c0                	test   %eax,%eax
  800957:	74 23                	je     80097c <strncmp+0x34>
  800959:	0f b6 1a             	movzbl (%edx),%ebx
  80095c:	84 db                	test   %bl,%bl
  80095e:	74 24                	je     800984 <strncmp+0x3c>
  800960:	3a 19                	cmp    (%ecx),%bl
  800962:	75 20                	jne    800984 <strncmp+0x3c>
  800964:	83 e8 01             	sub    $0x1,%eax
  800967:	74 13                	je     80097c <strncmp+0x34>
		n--, p++, q++;
  800969:	83 c2 01             	add    $0x1,%edx
  80096c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80096f:	0f b6 1a             	movzbl (%edx),%ebx
  800972:	84 db                	test   %bl,%bl
  800974:	74 0e                	je     800984 <strncmp+0x3c>
  800976:	3a 19                	cmp    (%ecx),%bl
  800978:	74 ea                	je     800964 <strncmp+0x1c>
  80097a:	eb 08                	jmp    800984 <strncmp+0x3c>
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800981:	5b                   	pop    %ebx
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800984:	0f b6 02             	movzbl (%edx),%eax
  800987:	0f b6 11             	movzbl (%ecx),%edx
  80098a:	29 d0                	sub    %edx,%eax
  80098c:	eb f3                	jmp    800981 <strncmp+0x39>

0080098e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800998:	0f b6 10             	movzbl (%eax),%edx
  80099b:	84 d2                	test   %dl,%dl
  80099d:	74 15                	je     8009b4 <strchr+0x26>
		if (*s == c)
  80099f:	38 ca                	cmp    %cl,%dl
  8009a1:	75 07                	jne    8009aa <strchr+0x1c>
  8009a3:	eb 14                	jmp    8009b9 <strchr+0x2b>
  8009a5:	38 ca                	cmp    %cl,%dl
  8009a7:	90                   	nop
  8009a8:	74 0f                	je     8009b9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	0f b6 10             	movzbl (%eax),%edx
  8009b0:	84 d2                	test   %dl,%dl
  8009b2:	75 f1                	jne    8009a5 <strchr+0x17>
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c5:	0f b6 10             	movzbl (%eax),%edx
  8009c8:	84 d2                	test   %dl,%dl
  8009ca:	74 18                	je     8009e4 <strfind+0x29>
		if (*s == c)
  8009cc:	38 ca                	cmp    %cl,%dl
  8009ce:	75 0a                	jne    8009da <strfind+0x1f>
  8009d0:	eb 12                	jmp    8009e4 <strfind+0x29>
  8009d2:	38 ca                	cmp    %cl,%dl
  8009d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8009d8:	74 0a                	je     8009e4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009da:	83 c0 01             	add    $0x1,%eax
  8009dd:	0f b6 10             	movzbl (%eax),%edx
  8009e0:	84 d2                	test   %dl,%dl
  8009e2:	75 ee                	jne    8009d2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	83 ec 0c             	sub    $0xc,%esp
  8009ec:	89 1c 24             	mov    %ebx,(%esp)
  8009ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a00:	85 c9                	test   %ecx,%ecx
  800a02:	74 30                	je     800a34 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0a:	75 25                	jne    800a31 <memset+0x4b>
  800a0c:	f6 c1 03             	test   $0x3,%cl
  800a0f:	75 20                	jne    800a31 <memset+0x4b>
		c &= 0xFF;
  800a11:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a14:	89 d3                	mov    %edx,%ebx
  800a16:	c1 e3 08             	shl    $0x8,%ebx
  800a19:	89 d6                	mov    %edx,%esi
  800a1b:	c1 e6 18             	shl    $0x18,%esi
  800a1e:	89 d0                	mov    %edx,%eax
  800a20:	c1 e0 10             	shl    $0x10,%eax
  800a23:	09 f0                	or     %esi,%eax
  800a25:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a27:	09 d8                	or     %ebx,%eax
  800a29:	c1 e9 02             	shr    $0x2,%ecx
  800a2c:	fc                   	cld    
  800a2d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2f:	eb 03                	jmp    800a34 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a31:	fc                   	cld    
  800a32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a34:	89 f8                	mov    %edi,%eax
  800a36:	8b 1c 24             	mov    (%esp),%ebx
  800a39:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a3d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a41:	89 ec                	mov    %ebp,%esp
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	89 34 24             	mov    %esi,(%esp)
  800a4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a58:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a5b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a5d:	39 c6                	cmp    %eax,%esi
  800a5f:	73 35                	jae    800a96 <memmove+0x51>
  800a61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a64:	39 d0                	cmp    %edx,%eax
  800a66:	73 2e                	jae    800a96 <memmove+0x51>
		s += n;
		d += n;
  800a68:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6a:	f6 c2 03             	test   $0x3,%dl
  800a6d:	75 1b                	jne    800a8a <memmove+0x45>
  800a6f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a75:	75 13                	jne    800a8a <memmove+0x45>
  800a77:	f6 c1 03             	test   $0x3,%cl
  800a7a:	75 0e                	jne    800a8a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a7c:	83 ef 04             	sub    $0x4,%edi
  800a7f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a82:	c1 e9 02             	shr    $0x2,%ecx
  800a85:	fd                   	std    
  800a86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a88:	eb 09                	jmp    800a93 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a8a:	83 ef 01             	sub    $0x1,%edi
  800a8d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a90:	fd                   	std    
  800a91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a93:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a94:	eb 20                	jmp    800ab6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9c:	75 15                	jne    800ab3 <memmove+0x6e>
  800a9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aa4:	75 0d                	jne    800ab3 <memmove+0x6e>
  800aa6:	f6 c1 03             	test   $0x3,%cl
  800aa9:	75 08                	jne    800ab3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800aab:	c1 e9 02             	shr    $0x2,%ecx
  800aae:	fc                   	cld    
  800aaf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab1:	eb 03                	jmp    800ab6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ab3:	fc                   	cld    
  800ab4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ab6:	8b 34 24             	mov    (%esp),%esi
  800ab9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800abd:	89 ec                	mov    %ebp,%esp
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	89 04 24             	mov    %eax,(%esp)
  800adb:	e8 65 ff ff ff       	call   800a45 <memmove>
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	57                   	push   %edi
  800ae6:	56                   	push   %esi
  800ae7:	53                   	push   %ebx
  800ae8:	8b 75 08             	mov    0x8(%ebp),%esi
  800aeb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800aee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af1:	85 c9                	test   %ecx,%ecx
  800af3:	74 36                	je     800b2b <memcmp+0x49>
		if (*s1 != *s2)
  800af5:	0f b6 06             	movzbl (%esi),%eax
  800af8:	0f b6 1f             	movzbl (%edi),%ebx
  800afb:	38 d8                	cmp    %bl,%al
  800afd:	74 20                	je     800b1f <memcmp+0x3d>
  800aff:	eb 14                	jmp    800b15 <memcmp+0x33>
  800b01:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800b06:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800b0b:	83 c2 01             	add    $0x1,%edx
  800b0e:	83 e9 01             	sub    $0x1,%ecx
  800b11:	38 d8                	cmp    %bl,%al
  800b13:	74 12                	je     800b27 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800b15:	0f b6 c0             	movzbl %al,%eax
  800b18:	0f b6 db             	movzbl %bl,%ebx
  800b1b:	29 d8                	sub    %ebx,%eax
  800b1d:	eb 11                	jmp    800b30 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1f:	83 e9 01             	sub    $0x1,%ecx
  800b22:	ba 00 00 00 00       	mov    $0x0,%edx
  800b27:	85 c9                	test   %ecx,%ecx
  800b29:	75 d6                	jne    800b01 <memcmp+0x1f>
  800b2b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b30:	5b                   	pop    %ebx
  800b31:	5e                   	pop    %esi
  800b32:	5f                   	pop    %edi
  800b33:	5d                   	pop    %ebp
  800b34:	c3                   	ret    

00800b35 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b40:	39 d0                	cmp    %edx,%eax
  800b42:	73 15                	jae    800b59 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b48:	38 08                	cmp    %cl,(%eax)
  800b4a:	75 06                	jne    800b52 <memfind+0x1d>
  800b4c:	eb 0b                	jmp    800b59 <memfind+0x24>
  800b4e:	38 08                	cmp    %cl,(%eax)
  800b50:	74 07                	je     800b59 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b52:	83 c0 01             	add    $0x1,%eax
  800b55:	39 c2                	cmp    %eax,%edx
  800b57:	77 f5                	ja     800b4e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
  800b61:	83 ec 04             	sub    $0x4,%esp
  800b64:	8b 55 08             	mov    0x8(%ebp),%edx
  800b67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6a:	0f b6 02             	movzbl (%edx),%eax
  800b6d:	3c 20                	cmp    $0x20,%al
  800b6f:	74 04                	je     800b75 <strtol+0x1a>
  800b71:	3c 09                	cmp    $0x9,%al
  800b73:	75 0e                	jne    800b83 <strtol+0x28>
		s++;
  800b75:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b78:	0f b6 02             	movzbl (%edx),%eax
  800b7b:	3c 20                	cmp    $0x20,%al
  800b7d:	74 f6                	je     800b75 <strtol+0x1a>
  800b7f:	3c 09                	cmp    $0x9,%al
  800b81:	74 f2                	je     800b75 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b83:	3c 2b                	cmp    $0x2b,%al
  800b85:	75 0c                	jne    800b93 <strtol+0x38>
		s++;
  800b87:	83 c2 01             	add    $0x1,%edx
  800b8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b91:	eb 15                	jmp    800ba8 <strtol+0x4d>
	else if (*s == '-')
  800b93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b9a:	3c 2d                	cmp    $0x2d,%al
  800b9c:	75 0a                	jne    800ba8 <strtol+0x4d>
		s++, neg = 1;
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba8:	85 db                	test   %ebx,%ebx
  800baa:	0f 94 c0             	sete   %al
  800bad:	74 05                	je     800bb4 <strtol+0x59>
  800baf:	83 fb 10             	cmp    $0x10,%ebx
  800bb2:	75 18                	jne    800bcc <strtol+0x71>
  800bb4:	80 3a 30             	cmpb   $0x30,(%edx)
  800bb7:	75 13                	jne    800bcc <strtol+0x71>
  800bb9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bbd:	8d 76 00             	lea    0x0(%esi),%esi
  800bc0:	75 0a                	jne    800bcc <strtol+0x71>
		s += 2, base = 16;
  800bc2:	83 c2 02             	add    $0x2,%edx
  800bc5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bca:	eb 15                	jmp    800be1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bcc:	84 c0                	test   %al,%al
  800bce:	66 90                	xchg   %ax,%ax
  800bd0:	74 0f                	je     800be1 <strtol+0x86>
  800bd2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800bd7:	80 3a 30             	cmpb   $0x30,(%edx)
  800bda:	75 05                	jne    800be1 <strtol+0x86>
		s++, base = 8;
  800bdc:	83 c2 01             	add    $0x1,%edx
  800bdf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800be8:	0f b6 0a             	movzbl (%edx),%ecx
  800beb:	89 cf                	mov    %ecx,%edi
  800bed:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bf0:	80 fb 09             	cmp    $0x9,%bl
  800bf3:	77 08                	ja     800bfd <strtol+0xa2>
			dig = *s - '0';
  800bf5:	0f be c9             	movsbl %cl,%ecx
  800bf8:	83 e9 30             	sub    $0x30,%ecx
  800bfb:	eb 1e                	jmp    800c1b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800bfd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c00:	80 fb 19             	cmp    $0x19,%bl
  800c03:	77 08                	ja     800c0d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800c05:	0f be c9             	movsbl %cl,%ecx
  800c08:	83 e9 57             	sub    $0x57,%ecx
  800c0b:	eb 0e                	jmp    800c1b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800c0d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c10:	80 fb 19             	cmp    $0x19,%bl
  800c13:	77 15                	ja     800c2a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800c15:	0f be c9             	movsbl %cl,%ecx
  800c18:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c1b:	39 f1                	cmp    %esi,%ecx
  800c1d:	7d 0b                	jge    800c2a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800c1f:	83 c2 01             	add    $0x1,%edx
  800c22:	0f af c6             	imul   %esi,%eax
  800c25:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c28:	eb be                	jmp    800be8 <strtol+0x8d>
  800c2a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c30:	74 05                	je     800c37 <strtol+0xdc>
		*endptr = (char *) s;
  800c32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c35:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c3b:	74 04                	je     800c41 <strtol+0xe6>
  800c3d:	89 c8                	mov    %ecx,%eax
  800c3f:	f7 d8                	neg    %eax
}
  800c41:	83 c4 04             	add    $0x4,%esp
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    
  800c49:	00 00                	add    %al,(%eax)
	...

00800c4c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	89 1c 24             	mov    %ebx,(%esp)
  800c55:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c59:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c62:	b8 01 00 00 00       	mov    $0x1,%eax
  800c67:	89 d1                	mov    %edx,%ecx
  800c69:	89 d3                	mov    %edx,%ebx
  800c6b:	89 d7                	mov    %edx,%edi
  800c6d:	89 d6                	mov    %edx,%esi
  800c6f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c71:	8b 1c 24             	mov    (%esp),%ebx
  800c74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c7c:	89 ec                	mov    %ebp,%esp
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 0c             	sub    $0xc,%esp
  800c86:	89 1c 24             	mov    %ebx,(%esp)
  800c89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	89 c3                	mov    %eax,%ebx
  800c9e:	89 c7                	mov    %eax,%edi
  800ca0:	89 c6                	mov    %eax,%esi
  800ca2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca4:	8b 1c 24             	mov    (%esp),%ebx
  800ca7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800caf:	89 ec                	mov    %ebp,%esp
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 38             	sub    $0x38,%esp
  800cb9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc2:	be 00 00 00 00       	mov    $0x0,%esi
  800cc7:	b8 12 00 00 00       	mov    $0x12,%eax
  800ccc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ccf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800cda:	85 c0                	test   %eax,%eax
  800cdc:	7e 28                	jle    800d06 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cde:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ce2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800ce9:	00 
  800cea:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  800cf1:	00 
  800cf2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf9:	00 
  800cfa:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  800d01:	e8 26 1c 00 00       	call   80292c <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800d06:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d09:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d0c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d0f:	89 ec                	mov    %ebp,%esp
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	83 ec 0c             	sub    $0xc,%esp
  800d19:	89 1c 24             	mov    %ebx,(%esp)
  800d1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d20:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d29:	b8 11 00 00 00       	mov    $0x11,%eax
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d31:	8b 55 08             	mov    0x8(%ebp),%edx
  800d34:	89 df                	mov    %ebx,%edi
  800d36:	89 de                	mov    %ebx,%esi
  800d38:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800d3a:	8b 1c 24             	mov    (%esp),%ebx
  800d3d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d41:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d45:	89 ec                	mov    %ebp,%esp
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 0c             	sub    $0xc,%esp
  800d4f:	89 1c 24             	mov    %ebx,(%esp)
  800d52:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d56:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5f:	b8 10 00 00 00       	mov    $0x10,%eax
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	89 cb                	mov    %ecx,%ebx
  800d69:	89 cf                	mov    %ecx,%edi
  800d6b:	89 ce                	mov    %ecx,%esi
  800d6d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800d6f:	8b 1c 24             	mov    (%esp),%ebx
  800d72:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d76:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d7a:	89 ec                	mov    %ebp,%esp
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 38             	sub    $0x38,%esp
  800d84:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d87:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d8a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d92:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	89 df                	mov    %ebx,%edi
  800d9f:	89 de                	mov    %ebx,%esi
  800da1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7e 28                	jle    800dcf <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dab:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800db2:	00 
  800db3:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  800dba:	00 
  800dbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc2:	00 
  800dc3:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  800dca:	e8 5d 1b 00 00       	call   80292c <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800dcf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd8:	89 ec                	mov    %ebp,%esp
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	89 1c 24             	mov    %ebx,(%esp)
  800de5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800de9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ded:	ba 00 00 00 00       	mov    $0x0,%edx
  800df2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800df7:	89 d1                	mov    %edx,%ecx
  800df9:	89 d3                	mov    %edx,%ebx
  800dfb:	89 d7                	mov    %edx,%edi
  800dfd:	89 d6                	mov    %edx,%esi
  800dff:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800e01:	8b 1c 24             	mov    (%esp),%ebx
  800e04:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e08:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e0c:	89 ec                	mov    %ebp,%esp
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	83 ec 38             	sub    $0x38,%esp
  800e16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e19:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e1c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e24:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	89 cb                	mov    %ecx,%ebx
  800e2e:	89 cf                	mov    %ecx,%edi
  800e30:	89 ce                	mov    %ecx,%esi
  800e32:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e34:	85 c0                	test   %eax,%eax
  800e36:	7e 28                	jle    800e60 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e38:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e43:	00 
  800e44:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  800e4b:	00 
  800e4c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e53:	00 
  800e54:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  800e5b:	e8 cc 1a 00 00       	call   80292c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e60:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e63:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e66:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e69:	89 ec                	mov    %ebp,%esp
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    

00800e6d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	89 1c 24             	mov    %ebx,(%esp)
  800e76:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e7a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7e:	be 00 00 00 00       	mov    $0x0,%esi
  800e83:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e88:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e91:	8b 55 08             	mov    0x8(%ebp),%edx
  800e94:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e96:	8b 1c 24             	mov    (%esp),%ebx
  800e99:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e9d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ea1:	89 ec                	mov    %ebp,%esp
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    

00800ea5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 38             	sub    $0x38,%esp
  800eab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eb1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	89 df                	mov    %ebx,%edi
  800ec6:	89 de                	mov    %ebx,%esi
  800ec8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7e 28                	jle    800ef6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ece:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ed9:	00 
  800eda:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  800ee1:	00 
  800ee2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee9:	00 
  800eea:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  800ef1:	e8 36 1a 00 00       	call   80292c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800efc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eff:	89 ec                	mov    %ebp,%esp
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 38             	sub    $0x38,%esp
  800f09:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f17:	b8 09 00 00 00       	mov    $0x9,%eax
  800f1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	89 df                	mov    %ebx,%edi
  800f24:	89 de                	mov    %ebx,%esi
  800f26:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	7e 28                	jle    800f54 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f30:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f37:	00 
  800f38:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  800f3f:	00 
  800f40:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f47:	00 
  800f48:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  800f4f:	e8 d8 19 00 00       	call   80292c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f54:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f57:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5d:	89 ec                	mov    %ebp,%esp
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 38             	sub    $0x38,%esp
  800f67:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f75:	b8 08 00 00 00       	mov    $0x8,%eax
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	89 df                	mov    %ebx,%edi
  800f82:	89 de                	mov    %ebx,%esi
  800f84:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f86:	85 c0                	test   %eax,%eax
  800f88:	7e 28                	jle    800fb2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f95:	00 
  800f96:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  800f9d:	00 
  800f9e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa5:	00 
  800fa6:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  800fad:	e8 7a 19 00 00       	call   80292c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fb2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbb:	89 ec                	mov    %ebp,%esp
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    

00800fbf <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 38             	sub    $0x38,%esp
  800fc5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd3:	b8 06 00 00 00       	mov    $0x6,%eax
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	89 df                	mov    %ebx,%edi
  800fe0:	89 de                	mov    %ebx,%esi
  800fe2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	7e 28                	jle    801010 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fec:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801003:	00 
  801004:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  80100b:	e8 1c 19 00 00       	call   80292c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801010:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801013:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801016:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801019:	89 ec                	mov    %ebp,%esp
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 38             	sub    $0x38,%esp
  801023:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801026:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801029:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102c:	b8 05 00 00 00       	mov    $0x5,%eax
  801031:	8b 75 18             	mov    0x18(%ebp),%esi
  801034:	8b 7d 14             	mov    0x14(%ebp),%edi
  801037:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801042:	85 c0                	test   %eax,%eax
  801044:	7e 28                	jle    80106e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801046:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801051:	00 
  801052:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  801059:	00 
  80105a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801061:	00 
  801062:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  801069:	e8 be 18 00 00       	call   80292c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80106e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801071:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801074:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801077:	89 ec                	mov    %ebp,%esp
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 38             	sub    $0x38,%esp
  801081:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801084:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801087:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108a:	be 00 00 00 00       	mov    $0x0,%esi
  80108f:	b8 04 00 00 00       	mov    $0x4,%eax
  801094:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801097:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109a:	8b 55 08             	mov    0x8(%ebp),%edx
  80109d:	89 f7                	mov    %esi,%edi
  80109f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	7e 28                	jle    8010cd <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010b0:	00 
  8010b1:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  8010b8:	00 
  8010b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c0:	00 
  8010c1:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  8010c8:	e8 5f 18 00 00       	call   80292c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d6:	89 ec                	mov    %ebp,%esp
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 0c             	sub    $0xc,%esp
  8010e0:	89 1c 24             	mov    %ebx,(%esp)
  8010e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010e7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010f5:	89 d1                	mov    %edx,%ecx
  8010f7:	89 d3                	mov    %edx,%ebx
  8010f9:	89 d7                	mov    %edx,%edi
  8010fb:	89 d6                	mov    %edx,%esi
  8010fd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010ff:	8b 1c 24             	mov    (%esp),%ebx
  801102:	8b 74 24 04          	mov    0x4(%esp),%esi
  801106:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80110a:	89 ec                	mov    %ebp,%esp
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	89 1c 24             	mov    %ebx,(%esp)
  801117:	89 74 24 04          	mov    %esi,0x4(%esp)
  80111b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111f:	ba 00 00 00 00       	mov    $0x0,%edx
  801124:	b8 02 00 00 00       	mov    $0x2,%eax
  801129:	89 d1                	mov    %edx,%ecx
  80112b:	89 d3                	mov    %edx,%ebx
  80112d:	89 d7                	mov    %edx,%edi
  80112f:	89 d6                	mov    %edx,%esi
  801131:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801133:	8b 1c 24             	mov    (%esp),%ebx
  801136:	8b 74 24 04          	mov    0x4(%esp),%esi
  80113a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80113e:	89 ec                	mov    %ebp,%esp
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    

00801142 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801142:	55                   	push   %ebp
  801143:	89 e5                	mov    %esp,%ebp
  801145:	83 ec 38             	sub    $0x38,%esp
  801148:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80114b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80114e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801151:	b9 00 00 00 00       	mov    $0x0,%ecx
  801156:	b8 03 00 00 00       	mov    $0x3,%eax
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	89 cb                	mov    %ecx,%ebx
  801160:	89 cf                	mov    %ecx,%edi
  801162:	89 ce                	mov    %ecx,%esi
  801164:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801166:	85 c0                	test   %eax,%eax
  801168:	7e 28                	jle    801192 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80116a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801175:	00 
  801176:	c7 44 24 08 5f 30 80 	movl   $0x80305f,0x8(%esp)
  80117d:	00 
  80117e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801185:	00 
  801186:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  80118d:	e8 9a 17 00 00       	call   80292c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801192:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801195:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801198:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80119b:	89 ec                	mov    %ebp,%esp
  80119d:	5d                   	pop    %ebp
  80119e:	c3                   	ret    
	...

008011a0 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8011a6:	c7 44 24 08 8a 30 80 	movl   $0x80308a,0x8(%esp)
  8011ad:	00 
  8011ae:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  8011b5:	00 
  8011b6:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  8011bd:	e8 6a 17 00 00       	call   80292c <_panic>

008011c2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	53                   	push   %ebx
  8011c6:	83 ec 24             	sub    $0x24,%esp
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8011cc:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  8011ce:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8011d2:	75 1c                	jne    8011f0 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  8011d4:	c7 44 24 08 ac 30 80 	movl   $0x8030ac,0x8(%esp)
  8011db:	00 
  8011dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011e3:	00 
  8011e4:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  8011eb:	e8 3c 17 00 00       	call   80292c <_panic>
	}
	pte = vpt[VPN(addr)];
  8011f0:	89 d8                	mov    %ebx,%eax
  8011f2:	c1 e8 0c             	shr    $0xc,%eax
  8011f5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  8011fc:	f6 c4 08             	test   $0x8,%ah
  8011ff:	75 1c                	jne    80121d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801201:	c7 44 24 08 f0 30 80 	movl   $0x8030f0,0x8(%esp)
  801208:	00 
  801209:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801210:	00 
  801211:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  801218:	e8 0f 17 00 00       	call   80292c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80121d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801224:	00 
  801225:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80122c:	00 
  80122d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801234:	e8 42 fe ff ff       	call   80107b <sys_page_alloc>
  801239:	85 c0                	test   %eax,%eax
  80123b:	79 20                	jns    80125d <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  80123d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801241:	c7 44 24 08 3c 31 80 	movl   $0x80313c,0x8(%esp)
  801248:	00 
  801249:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801250:	00 
  801251:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  801258:	e8 cf 16 00 00       	call   80292c <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  80125d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801263:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80126a:	00 
  80126b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80126f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801276:	e8 ca f7 ff ff       	call   800a45 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  80127b:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801282:	00 
  801283:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801287:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80128e:	00 
  80128f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801296:	00 
  801297:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80129e:	e8 7a fd ff ff       	call   80101d <sys_page_map>
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	79 20                	jns    8012c7 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  8012a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ab:	c7 44 24 08 78 31 80 	movl   $0x803178,0x8(%esp)
  8012b2:	00 
  8012b3:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8012ba:	00 
  8012bb:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  8012c2:	e8 65 16 00 00       	call   80292c <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  8012c7:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012ce:	00 
  8012cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d6:	e8 e4 fc ff ff       	call   800fbf <sys_page_unmap>
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	79 20                	jns    8012ff <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  8012df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012e3:	c7 44 24 08 b0 31 80 	movl   $0x8031b0,0x8(%esp)
  8012ea:	00 
  8012eb:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8012f2:	00 
  8012f3:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  8012fa:	e8 2d 16 00 00       	call   80292c <_panic>
	// panic("pgfault not implemented");
}
  8012ff:	83 c4 24             	add    $0x24,%esp
  801302:	5b                   	pop    %ebx
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	57                   	push   %edi
  801309:	56                   	push   %esi
  80130a:	53                   	push   %ebx
  80130b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80130e:	c7 04 24 c2 11 80 00 	movl   $0x8011c2,(%esp)
  801315:	e8 76 16 00 00       	call   802990 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80131a:	ba 07 00 00 00       	mov    $0x7,%edx
  80131f:	89 d0                	mov    %edx,%eax
  801321:	cd 30                	int    $0x30
  801323:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  801326:	85 c0                	test   %eax,%eax
  801328:	0f 88 21 02 00 00    	js     80154f <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  80132e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  801335:	85 c0                	test   %eax,%eax
  801337:	75 1c                	jne    801355 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  801339:	e8 d0 fd ff ff       	call   80110e <sys_getenvid>
  80133e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801343:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801346:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80134b:	a3 74 70 80 00       	mov    %eax,0x807074
		return 0;
  801350:	e9 fa 01 00 00       	jmp    80154f <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  801355:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801358:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  80135f:	a8 01                	test   $0x1,%al
  801361:	0f 84 16 01 00 00    	je     80147d <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  801367:	89 d3                	mov    %edx,%ebx
  801369:	c1 e3 0a             	shl    $0xa,%ebx
  80136c:	89 d7                	mov    %edx,%edi
  80136e:	c1 e7 16             	shl    $0x16,%edi
  801371:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  801376:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80137d:	a8 01                	test   $0x1,%al
  80137f:	0f 84 e0 00 00 00    	je     801465 <fork+0x160>
  801385:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80138b:	0f 87 d4 00 00 00    	ja     801465 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801391:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801398:	89 d0                	mov    %edx,%eax
  80139a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  80139f:	f6 c2 01             	test   $0x1,%dl
  8013a2:	75 1c                	jne    8013c0 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  8013a4:	c7 44 24 08 ec 31 80 	movl   $0x8031ec,0x8(%esp)
  8013ab:	00 
  8013ac:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  8013b3:	00 
  8013b4:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  8013bb:	e8 6c 15 00 00       	call   80292c <_panic>
	if ((perm & PTE_U) != PTE_U)
  8013c0:	a8 04                	test   $0x4,%al
  8013c2:	75 1c                	jne    8013e0 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  8013c4:	c7 44 24 08 34 32 80 	movl   $0x803234,0x8(%esp)
  8013cb:	00 
  8013cc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8013d3:	00 
  8013d4:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  8013db:	e8 4c 15 00 00       	call   80292c <_panic>
  8013e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  8013e3:	f6 c4 04             	test   $0x4,%ah
  8013e6:	75 5b                	jne    801443 <fork+0x13e>
  8013e8:	a9 02 08 00 00       	test   $0x802,%eax
  8013ed:	74 54                	je     801443 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  8013ef:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  8013f2:	80 cc 08             	or     $0x8,%ah
  8013f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8013f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013fc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801400:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801403:	89 54 24 08          	mov    %edx,0x8(%esp)
  801407:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80140b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801412:	e8 06 fc ff ff       	call   80101d <sys_page_map>
  801417:	85 c0                	test   %eax,%eax
  801419:	78 4a                	js     801465 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80141b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80141e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801422:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801425:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801429:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801430:	00 
  801431:	89 54 24 04          	mov    %edx,0x4(%esp)
  801435:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143c:	e8 dc fb ff ff       	call   80101d <sys_page_map>
  801441:	eb 22                	jmp    801465 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801443:	89 44 24 10          	mov    %eax,0x10(%esp)
  801447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80144e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801451:	89 54 24 08          	mov    %edx,0x8(%esp)
  801455:	89 44 24 04          	mov    %eax,0x4(%esp)
  801459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801460:	e8 b8 fb ff ff       	call   80101d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  801465:	83 c6 01             	add    $0x1,%esi
  801468:	83 c3 01             	add    $0x1,%ebx
  80146b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801471:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  801477:	0f 85 f9 fe ff ff    	jne    801376 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  80147d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  801481:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  801488:	0f 85 c7 fe ff ff    	jne    801355 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80148e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801495:	00 
  801496:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80149d:	ee 
  80149e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a1:	89 04 24             	mov    %eax,(%esp)
  8014a4:	e8 d2 fb ff ff       	call   80107b <sys_page_alloc>
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	79 08                	jns    8014b5 <fork+0x1b0>
  8014ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014b0:	e9 9a 00 00 00       	jmp    80154f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8014b5:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014bc:	00 
  8014bd:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8014c4:	00 
  8014c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014cc:	00 
  8014cd:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014d4:	ee 
  8014d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014d8:	89 14 24             	mov    %edx,(%esp)
  8014db:	e8 3d fb ff ff       	call   80101d <sys_page_map>
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	79 05                	jns    8014e9 <fork+0x1e4>
  8014e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014e7:	eb 66                	jmp    80154f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  8014e9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014f0:	00 
  8014f1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014f8:	ee 
  8014f9:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801500:	e8 40 f5 ff ff       	call   800a45 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801505:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80150c:	00 
  80150d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801514:	e8 a6 fa ff ff       	call   800fbf <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801519:	c7 44 24 04 24 2a 80 	movl   $0x802a24,0x4(%esp)
  801520:	00 
  801521:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	e8 79 f9 ff ff       	call   800ea5 <sys_env_set_pgfault_upcall>
  80152c:	85 c0                	test   %eax,%eax
  80152e:	79 05                	jns    801535 <fork+0x230>
  801530:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801533:	eb 1a                	jmp    80154f <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801535:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80153c:	00 
  80153d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801540:	89 14 24             	mov    %edx,(%esp)
  801543:	e8 19 fa ff ff       	call   800f61 <sys_env_set_status>
  801548:	85 c0                	test   %eax,%eax
  80154a:	79 03                	jns    80154f <fork+0x24a>
  80154c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  80154f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801552:	83 c4 3c             	add    $0x3c,%esp
  801555:	5b                   	pop    %ebx
  801556:	5e                   	pop    %esi
  801557:	5f                   	pop    %edi
  801558:	5d                   	pop    %ebp
  801559:	c3                   	ret    
  80155a:	00 00                	add    %al,(%eax)
  80155c:	00 00                	add    %al,(%eax)
	...

00801560 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	57                   	push   %edi
  801564:	56                   	push   %esi
  801565:	53                   	push   %ebx
  801566:	83 ec 1c             	sub    $0x1c,%esp
  801569:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80156c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80156f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801572:	85 db                	test   %ebx,%ebx
  801574:	75 2d                	jne    8015a3 <ipc_send+0x43>
  801576:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80157b:	eb 26                	jmp    8015a3 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80157d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801580:	74 1c                	je     80159e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  801582:	c7 44 24 08 7c 32 80 	movl   $0x80327c,0x8(%esp)
  801589:	00 
  80158a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801591:	00 
  801592:	c7 04 24 9e 32 80 00 	movl   $0x80329e,(%esp)
  801599:	e8 8e 13 00 00       	call   80292c <_panic>
		sys_yield();
  80159e:	e8 37 fb ff ff       	call   8010da <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8015a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8015a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	89 04 24             	mov    %eax,(%esp)
  8015b5:	e8 b3 f8 ff ff       	call   800e6d <sys_ipc_try_send>
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 bf                	js     80157d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8015be:	83 c4 1c             	add    $0x1c,%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 10             	sub    $0x10,%esp
  8015ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8015d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	75 05                	jne    8015e0 <ipc_recv+0x1a>
  8015db:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8015e0:	89 04 24             	mov    %eax,(%esp)
  8015e3:	e8 28 f8 ff ff       	call   800e10 <sys_ipc_recv>
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	79 16                	jns    801602 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8015ec:	85 db                	test   %ebx,%ebx
  8015ee:	74 06                	je     8015f6 <ipc_recv+0x30>
			*from_env_store = 0;
  8015f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8015f6:	85 f6                	test   %esi,%esi
  8015f8:	74 2c                	je     801626 <ipc_recv+0x60>
			*perm_store = 0;
  8015fa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  801600:	eb 24                	jmp    801626 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  801602:	85 db                	test   %ebx,%ebx
  801604:	74 0a                	je     801610 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  801606:	a1 74 70 80 00       	mov    0x807074,%eax
  80160b:	8b 40 74             	mov    0x74(%eax),%eax
  80160e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  801610:	85 f6                	test   %esi,%esi
  801612:	74 0a                	je     80161e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  801614:	a1 74 70 80 00       	mov    0x807074,%eax
  801619:	8b 40 78             	mov    0x78(%eax),%eax
  80161c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80161e:	a1 74 70 80 00       	mov    0x807074,%eax
  801623:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    
  80162d:	00 00                	add    %al,(%eax)
	...

00801630 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	05 00 00 00 30       	add    $0x30000000,%eax
  80163b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	89 04 24             	mov    %eax,(%esp)
  80164c:	e8 df ff ff ff       	call   801630 <fd2num>
  801651:	05 20 00 0d 00       	add    $0xd0020,%eax
  801656:	c1 e0 0c             	shl    $0xc,%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	57                   	push   %edi
  80165f:	56                   	push   %esi
  801660:	53                   	push   %ebx
  801661:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801664:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801669:	a8 01                	test   $0x1,%al
  80166b:	74 36                	je     8016a3 <fd_alloc+0x48>
  80166d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801672:	a8 01                	test   $0x1,%al
  801674:	74 2d                	je     8016a3 <fd_alloc+0x48>
  801676:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80167b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801680:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801685:	89 c3                	mov    %eax,%ebx
  801687:	89 c2                	mov    %eax,%edx
  801689:	c1 ea 16             	shr    $0x16,%edx
  80168c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80168f:	f6 c2 01             	test   $0x1,%dl
  801692:	74 14                	je     8016a8 <fd_alloc+0x4d>
  801694:	89 c2                	mov    %eax,%edx
  801696:	c1 ea 0c             	shr    $0xc,%edx
  801699:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80169c:	f6 c2 01             	test   $0x1,%dl
  80169f:	75 10                	jne    8016b1 <fd_alloc+0x56>
  8016a1:	eb 05                	jmp    8016a8 <fd_alloc+0x4d>
  8016a3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8016a8:	89 1f                	mov    %ebx,(%edi)
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8016af:	eb 17                	jmp    8016c8 <fd_alloc+0x6d>
  8016b1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8016b6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016bb:	75 c8                	jne    801685 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016bd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8016c3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8016c8:	5b                   	pop    %ebx
  8016c9:	5e                   	pop    %esi
  8016ca:	5f                   	pop    %edi
  8016cb:	5d                   	pop    %ebp
  8016cc:	c3                   	ret    

008016cd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	83 f8 1f             	cmp    $0x1f,%eax
  8016d6:	77 36                	ja     80170e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016d8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8016dd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8016e0:	89 c2                	mov    %eax,%edx
  8016e2:	c1 ea 16             	shr    $0x16,%edx
  8016e5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ec:	f6 c2 01             	test   $0x1,%dl
  8016ef:	74 1d                	je     80170e <fd_lookup+0x41>
  8016f1:	89 c2                	mov    %eax,%edx
  8016f3:	c1 ea 0c             	shr    $0xc,%edx
  8016f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016fd:	f6 c2 01             	test   $0x1,%dl
  801700:	74 0c                	je     80170e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801702:	8b 55 0c             	mov    0xc(%ebp),%edx
  801705:	89 02                	mov    %eax,(%edx)
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80170c:	eb 05                	jmp    801713 <fd_lookup+0x46>
  80170e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    

00801715 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80171e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 04 24             	mov    %eax,(%esp)
  801728:	e8 a0 ff ff ff       	call   8016cd <fd_lookup>
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 0e                	js     80173f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801731:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801734:	8b 55 0c             	mov    0xc(%ebp),%edx
  801737:	89 50 04             	mov    %edx,0x4(%eax)
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	56                   	push   %esi
  801745:	53                   	push   %ebx
  801746:	83 ec 10             	sub    $0x10,%esp
  801749:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80174c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80174f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801754:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801759:	be 24 33 80 00       	mov    $0x803324,%esi
		if (devtab[i]->dev_id == dev_id) {
  80175e:	39 08                	cmp    %ecx,(%eax)
  801760:	75 10                	jne    801772 <dev_lookup+0x31>
  801762:	eb 04                	jmp    801768 <dev_lookup+0x27>
  801764:	39 08                	cmp    %ecx,(%eax)
  801766:	75 0a                	jne    801772 <dev_lookup+0x31>
			*dev = devtab[i];
  801768:	89 03                	mov    %eax,(%ebx)
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80176f:	90                   	nop
  801770:	eb 31                	jmp    8017a3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801772:	83 c2 01             	add    $0x1,%edx
  801775:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801778:	85 c0                	test   %eax,%eax
  80177a:	75 e8                	jne    801764 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80177c:	a1 74 70 80 00       	mov    0x807074,%eax
  801781:	8b 40 4c             	mov    0x4c(%eax),%eax
  801784:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178c:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  801793:	e8 2d ea ff ff       	call   8001c5 <cprintf>
	*dev = 0;
  801798:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80179e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	53                   	push   %ebx
  8017ae:	83 ec 24             	sub    $0x24,%esp
  8017b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	89 04 24             	mov    %eax,(%esp)
  8017c1:	e8 07 ff ff ff       	call   8016cd <fd_lookup>
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 53                	js     80181d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d4:	8b 00                	mov    (%eax),%eax
  8017d6:	89 04 24             	mov    %eax,(%esp)
  8017d9:	e8 63 ff ff ff       	call   801741 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 3b                	js     80181d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8017e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ea:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8017ee:	74 2d                	je     80181d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017f0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017f3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017fa:	00 00 00 
	stat->st_isdir = 0;
  8017fd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801804:	00 00 00 
	stat->st_dev = dev;
  801807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801810:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801814:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801817:	89 14 24             	mov    %edx,(%esp)
  80181a:	ff 50 14             	call   *0x14(%eax)
}
  80181d:	83 c4 24             	add    $0x24,%esp
  801820:	5b                   	pop    %ebx
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    

00801823 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	53                   	push   %ebx
  801827:	83 ec 24             	sub    $0x24,%esp
  80182a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80182d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801830:	89 44 24 04          	mov    %eax,0x4(%esp)
  801834:	89 1c 24             	mov    %ebx,(%esp)
  801837:	e8 91 fe ff ff       	call   8016cd <fd_lookup>
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 5f                	js     80189f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801840:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801843:	89 44 24 04          	mov    %eax,0x4(%esp)
  801847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	89 04 24             	mov    %eax,(%esp)
  80184f:	e8 ed fe ff ff       	call   801741 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801854:	85 c0                	test   %eax,%eax
  801856:	78 47                	js     80189f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801858:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80185b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80185f:	75 23                	jne    801884 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801861:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801866:	8b 40 4c             	mov    0x4c(%eax),%eax
  801869:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80186d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801871:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  801878:	e8 48 e9 ff ff       	call   8001c5 <cprintf>
  80187d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801882:	eb 1b                	jmp    80189f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801887:	8b 48 18             	mov    0x18(%eax),%ecx
  80188a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80188f:	85 c9                	test   %ecx,%ecx
  801891:	74 0c                	je     80189f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801893:	8b 45 0c             	mov    0xc(%ebp),%eax
  801896:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189a:	89 14 24             	mov    %edx,(%esp)
  80189d:	ff d1                	call   *%ecx
}
  80189f:	83 c4 24             	add    $0x24,%esp
  8018a2:	5b                   	pop    %ebx
  8018a3:	5d                   	pop    %ebp
  8018a4:	c3                   	ret    

008018a5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	53                   	push   %ebx
  8018a9:	83 ec 24             	sub    $0x24,%esp
  8018ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b6:	89 1c 24             	mov    %ebx,(%esp)
  8018b9:	e8 0f fe ff ff       	call   8016cd <fd_lookup>
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	78 66                	js     801928 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	89 04 24             	mov    %eax,(%esp)
  8018d1:	e8 6b fe ff ff       	call   801741 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 4e                	js     801928 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018dd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018e1:	75 23                	jne    801906 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8018e3:	a1 74 70 80 00       	mov    0x807074,%eax
  8018e8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f3:	c7 04 24 e9 32 80 00 	movl   $0x8032e9,(%esp)
  8018fa:	e8 c6 e8 ff ff       	call   8001c5 <cprintf>
  8018ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801904:	eb 22                	jmp    801928 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801909:	8b 48 0c             	mov    0xc(%eax),%ecx
  80190c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801911:	85 c9                	test   %ecx,%ecx
  801913:	74 13                	je     801928 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801915:	8b 45 10             	mov    0x10(%ebp),%eax
  801918:	89 44 24 08          	mov    %eax,0x8(%esp)
  80191c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	89 14 24             	mov    %edx,(%esp)
  801926:	ff d1                	call   *%ecx
}
  801928:	83 c4 24             	add    $0x24,%esp
  80192b:	5b                   	pop    %ebx
  80192c:	5d                   	pop    %ebp
  80192d:	c3                   	ret    

0080192e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	53                   	push   %ebx
  801932:	83 ec 24             	sub    $0x24,%esp
  801935:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801938:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80193b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193f:	89 1c 24             	mov    %ebx,(%esp)
  801942:	e8 86 fd ff ff       	call   8016cd <fd_lookup>
  801947:	85 c0                	test   %eax,%eax
  801949:	78 6b                	js     8019b6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80194b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801955:	8b 00                	mov    (%eax),%eax
  801957:	89 04 24             	mov    %eax,(%esp)
  80195a:	e8 e2 fd ff ff       	call   801741 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 53                	js     8019b6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801963:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801966:	8b 42 08             	mov    0x8(%edx),%eax
  801969:	83 e0 03             	and    $0x3,%eax
  80196c:	83 f8 01             	cmp    $0x1,%eax
  80196f:	75 23                	jne    801994 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801971:	a1 74 70 80 00       	mov    0x807074,%eax
  801976:	8b 40 4c             	mov    0x4c(%eax),%eax
  801979:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80197d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801981:	c7 04 24 06 33 80 00 	movl   $0x803306,(%esp)
  801988:	e8 38 e8 ff ff       	call   8001c5 <cprintf>
  80198d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801992:	eb 22                	jmp    8019b6 <read+0x88>
	}
	if (!dev->dev_read)
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	8b 48 08             	mov    0x8(%eax),%ecx
  80199a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199f:	85 c9                	test   %ecx,%ecx
  8019a1:	74 13                	je     8019b6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b1:	89 14 24             	mov    %edx,(%esp)
  8019b4:	ff d1                	call   *%ecx
}
  8019b6:	83 c4 24             	add    $0x24,%esp
  8019b9:	5b                   	pop    %ebx
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    

008019bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	57                   	push   %edi
  8019c0:	56                   	push   %esi
  8019c1:	53                   	push   %ebx
  8019c2:	83 ec 1c             	sub    $0x1c,%esp
  8019c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019da:	85 f6                	test   %esi,%esi
  8019dc:	74 29                	je     801a07 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019de:	89 f0                	mov    %esi,%eax
  8019e0:	29 d0                	sub    %edx,%eax
  8019e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e6:	03 55 0c             	add    0xc(%ebp),%edx
  8019e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019ed:	89 3c 24             	mov    %edi,(%esp)
  8019f0:	e8 39 ff ff ff       	call   80192e <read>
		if (m < 0)
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 0e                	js     801a07 <readn+0x4b>
			return m;
		if (m == 0)
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	74 08                	je     801a05 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019fd:	01 c3                	add    %eax,%ebx
  8019ff:	89 da                	mov    %ebx,%edx
  801a01:	39 f3                	cmp    %esi,%ebx
  801a03:	72 d9                	jb     8019de <readn+0x22>
  801a05:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a07:	83 c4 1c             	add    $0x1c,%esp
  801a0a:	5b                   	pop    %ebx
  801a0b:	5e                   	pop    %esi
  801a0c:	5f                   	pop    %edi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    

00801a0f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
  801a14:	83 ec 20             	sub    $0x20,%esp
  801a17:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a1a:	89 34 24             	mov    %esi,(%esp)
  801a1d:	e8 0e fc ff ff       	call   801630 <fd2num>
  801a22:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a25:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a29:	89 04 24             	mov    %eax,(%esp)
  801a2c:	e8 9c fc ff ff       	call   8016cd <fd_lookup>
  801a31:	89 c3                	mov    %eax,%ebx
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 05                	js     801a3c <fd_close+0x2d>
  801a37:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801a3a:	74 0c                	je     801a48 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801a3c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a40:	19 c0                	sbb    %eax,%eax
  801a42:	f7 d0                	not    %eax
  801a44:	21 c3                	and    %eax,%ebx
  801a46:	eb 3d                	jmp    801a85 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a48:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4f:	8b 06                	mov    (%esi),%eax
  801a51:	89 04 24             	mov    %eax,(%esp)
  801a54:	e8 e8 fc ff ff       	call   801741 <dev_lookup>
  801a59:	89 c3                	mov    %eax,%ebx
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	78 16                	js     801a75 <fd_close+0x66>
		if (dev->dev_close)
  801a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a62:	8b 40 10             	mov    0x10(%eax),%eax
  801a65:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	74 07                	je     801a75 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801a6e:	89 34 24             	mov    %esi,(%esp)
  801a71:	ff d0                	call   *%eax
  801a73:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a75:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a80:	e8 3a f5 ff ff       	call   800fbf <sys_page_unmap>
	return r;
}
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	83 c4 20             	add    $0x20,%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5e                   	pop    %esi
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    

00801a8e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	89 04 24             	mov    %eax,(%esp)
  801aa1:	e8 27 fc ff ff       	call   8016cd <fd_lookup>
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 13                	js     801abd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801aaa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ab1:	00 
  801ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab5:	89 04 24             	mov    %eax,(%esp)
  801ab8:	e8 52 ff ff ff       	call   801a0f <fd_close>
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 18             	sub    $0x18,%esp
  801ac5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ac8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801acb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ad2:	00 
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	89 04 24             	mov    %eax,(%esp)
  801ad9:	e8 55 03 00 00       	call   801e33 <open>
  801ade:	89 c3                	mov    %eax,%ebx
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 1b                	js     801aff <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aeb:	89 1c 24             	mov    %ebx,(%esp)
  801aee:	e8 b7 fc ff ff       	call   8017aa <fstat>
  801af3:	89 c6                	mov    %eax,%esi
	close(fd);
  801af5:	89 1c 24             	mov    %ebx,(%esp)
  801af8:	e8 91 ff ff ff       	call   801a8e <close>
  801afd:	89 f3                	mov    %esi,%ebx
	return r;
}
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b04:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b07:	89 ec                	mov    %ebp,%esp
  801b09:	5d                   	pop    %ebp
  801b0a:	c3                   	ret    

00801b0b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	53                   	push   %ebx
  801b0f:	83 ec 14             	sub    $0x14,%esp
  801b12:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801b17:	89 1c 24             	mov    %ebx,(%esp)
  801b1a:	e8 6f ff ff ff       	call   801a8e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801b1f:	83 c3 01             	add    $0x1,%ebx
  801b22:	83 fb 20             	cmp    $0x20,%ebx
  801b25:	75 f0                	jne    801b17 <close_all+0xc>
		close(i);
}
  801b27:	83 c4 14             	add    $0x14,%esp
  801b2a:	5b                   	pop    %ebx
  801b2b:	5d                   	pop    %ebp
  801b2c:	c3                   	ret    

00801b2d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 58             	sub    $0x58,%esp
  801b33:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b36:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b39:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b3f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	89 04 24             	mov    %eax,(%esp)
  801b4c:	e8 7c fb ff ff       	call   8016cd <fd_lookup>
  801b51:	89 c3                	mov    %eax,%ebx
  801b53:	85 c0                	test   %eax,%eax
  801b55:	0f 88 e0 00 00 00    	js     801c3b <dup+0x10e>
		return r;
	close(newfdnum);
  801b5b:	89 3c 24             	mov    %edi,(%esp)
  801b5e:	e8 2b ff ff ff       	call   801a8e <close>

	newfd = INDEX2FD(newfdnum);
  801b63:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801b69:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b6f:	89 04 24             	mov    %eax,(%esp)
  801b72:	e8 c9 fa ff ff       	call   801640 <fd2data>
  801b77:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b79:	89 34 24             	mov    %esi,(%esp)
  801b7c:	e8 bf fa ff ff       	call   801640 <fd2data>
  801b81:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801b84:	89 da                	mov    %ebx,%edx
  801b86:	89 d8                	mov    %ebx,%eax
  801b88:	c1 e8 16             	shr    $0x16,%eax
  801b8b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b92:	a8 01                	test   $0x1,%al
  801b94:	74 43                	je     801bd9 <dup+0xac>
  801b96:	c1 ea 0c             	shr    $0xc,%edx
  801b99:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801ba0:	a8 01                	test   $0x1,%al
  801ba2:	74 35                	je     801bd9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801ba4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801bab:	25 07 0e 00 00       	and    $0xe07,%eax
  801bb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801bb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bc2:	00 
  801bc3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bce:	e8 4a f4 ff ff       	call   80101d <sys_page_map>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	78 3f                	js     801c18 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bdc:	89 c2                	mov    %eax,%edx
  801bde:	c1 ea 0c             	shr    $0xc,%edx
  801be1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801be8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801bee:	89 54 24 10          	mov    %edx,0x10(%esp)
  801bf2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801bf6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bfd:	00 
  801bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c09:	e8 0f f4 ff ff       	call   80101d <sys_page_map>
  801c0e:	89 c3                	mov    %eax,%ebx
  801c10:	85 c0                	test   %eax,%eax
  801c12:	78 04                	js     801c18 <dup+0xeb>
  801c14:	89 fb                	mov    %edi,%ebx
  801c16:	eb 23                	jmp    801c3b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801c18:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c23:	e8 97 f3 ff ff       	call   800fbf <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c36:	e8 84 f3 ff ff       	call   800fbf <sys_page_unmap>
	return r;
}
  801c3b:	89 d8                	mov    %ebx,%eax
  801c3d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c40:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c43:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c46:	89 ec                	mov    %ebp,%esp
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    
	...

00801c4c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 14             	sub    $0x14,%esp
  801c53:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c55:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801c5b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c62:	00 
  801c63:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801c6a:	00 
  801c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6f:	89 14 24             	mov    %edx,(%esp)
  801c72:	e8 e9 f8 ff ff       	call   801560 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c7e:	00 
  801c7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c8a:	e8 37 f9 ff ff       	call   8015c6 <ipc_recv>
}
  801c8f:	83 c4 14             	add    $0x14,%esp
  801c92:	5b                   	pop    %ebx
  801c93:	5d                   	pop    %ebp
  801c94:	c3                   	ret    

00801c95 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cae:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb3:	b8 02 00 00 00       	mov    $0x2,%eax
  801cb8:	e8 8f ff ff ff       	call   801c4c <fsipc>
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccb:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd5:	b8 06 00 00 00       	mov    $0x6,%eax
  801cda:	e8 6d ff ff ff       	call   801c4c <fsipc>
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cec:	b8 08 00 00 00       	mov    $0x8,%eax
  801cf1:	e8 56 ff ff ff       	call   801c4c <fsipc>
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	53                   	push   %ebx
  801cfc:	83 ec 14             	sub    $0x14,%esp
  801cff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	8b 40 0c             	mov    0xc(%eax),%eax
  801d08:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d12:	b8 05 00 00 00       	mov    $0x5,%eax
  801d17:	e8 30 ff ff ff       	call   801c4c <fsipc>
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	78 2b                	js     801d4b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d20:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801d27:	00 
  801d28:	89 1c 24             	mov    %ebx,(%esp)
  801d2b:	e8 5a eb ff ff       	call   80088a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d30:	a1 80 40 80 00       	mov    0x804080,%eax
  801d35:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d3b:	a1 84 40 80 00       	mov    0x804084,%eax
  801d40:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801d4b:	83 c4 14             	add    $0x14,%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 18             	sub    $0x18,%esp
  801d57:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801d5f:	76 05                	jbe    801d66 <devfile_write+0x15>
  801d61:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d66:	8b 55 08             	mov    0x8(%ebp),%edx
  801d69:	8b 52 0c             	mov    0xc(%edx),%edx
  801d6c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801d72:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801d77:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d82:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801d89:	e8 b7 ec ff ff       	call   800a45 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d93:	b8 04 00 00 00       	mov    $0x4,%eax
  801d98:	e8 af fe ff ff       	call   801c4c <fsipc>
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	53                   	push   %ebx
  801da3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dac:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801db1:	8b 45 10             	mov    0x10(%ebp),%eax
  801db4:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801db9:	ba 00 40 80 00       	mov    $0x804000,%edx
  801dbe:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc3:	e8 84 fe ff ff       	call   801c4c <fsipc>
  801dc8:	89 c3                	mov    %eax,%ebx
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 17                	js     801de5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801dce:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd2:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801dd9:	00 
  801dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddd:	89 04 24             	mov    %eax,(%esp)
  801de0:	e8 60 ec ff ff       	call   800a45 <memmove>
	return r;
}
  801de5:	89 d8                	mov    %ebx,%eax
  801de7:	83 c4 14             	add    $0x14,%esp
  801dea:	5b                   	pop    %ebx
  801deb:	5d                   	pop    %ebp
  801dec:	c3                   	ret    

00801ded <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	53                   	push   %ebx
  801df1:	83 ec 14             	sub    $0x14,%esp
  801df4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801df7:	89 1c 24             	mov    %ebx,(%esp)
  801dfa:	e8 41 ea ff ff       	call   800840 <strlen>
  801dff:	89 c2                	mov    %eax,%edx
  801e01:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801e06:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801e0c:	7f 1f                	jg     801e2d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801e0e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e12:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e19:	e8 6c ea ff ff       	call   80088a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801e1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e23:	b8 07 00 00 00       	mov    $0x7,%eax
  801e28:	e8 1f fe ff ff       	call   801c4c <fsipc>
}
  801e2d:	83 c4 14             	add    $0x14,%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5d                   	pop    %ebp
  801e32:	c3                   	ret    

00801e33 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 28             	sub    $0x28,%esp
  801e39:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e3c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e3f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801e42:	89 34 24             	mov    %esi,(%esp)
  801e45:	e8 f6 e9 ff ff       	call   800840 <strlen>
  801e4a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e4f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e54:	7f 5e                	jg     801eb4 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e59:	89 04 24             	mov    %eax,(%esp)
  801e5c:	e8 fa f7 ff ff       	call   80165b <fd_alloc>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	85 c0                	test   %eax,%eax
  801e65:	78 4d                	js     801eb4 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801e67:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e6b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e72:	e8 13 ea ff ff       	call   80088a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e82:	b8 01 00 00 00       	mov    $0x1,%eax
  801e87:	e8 c0 fd ff ff       	call   801c4c <fsipc>
  801e8c:	89 c3                	mov    %eax,%ebx
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	79 15                	jns    801ea7 <open+0x74>
	{
		fd_close(fd,0);
  801e92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e99:	00 
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	89 04 24             	mov    %eax,(%esp)
  801ea0:	e8 6a fb ff ff       	call   801a0f <fd_close>
		return r; 
  801ea5:	eb 0d                	jmp    801eb4 <open+0x81>
	}
	return fd2num(fd);
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaa:	89 04 24             	mov    %eax,(%esp)
  801ead:	e8 7e f7 ff ff       	call   801630 <fd2num>
  801eb2:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801eb4:	89 d8                	mov    %ebx,%eax
  801eb6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801eb9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ebc:	89 ec                	mov    %ebp,%esp
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    

00801ec0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ec6:	c7 44 24 04 38 33 80 	movl   $0x803338,0x4(%esp)
  801ecd:	00 
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	89 04 24             	mov    %eax,(%esp)
  801ed4:	e8 b1 e9 ff ff       	call   80088a <strcpy>
	return 0;
}
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8b 40 0c             	mov    0xc(%eax),%eax
  801eec:	89 04 24             	mov    %eax,(%esp)
  801eef:	e8 9e 02 00 00       	call   802192 <nsipc_close>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801efc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f03:	00 
  801f04:	8b 45 10             	mov    0x10(%ebp),%eax
  801f07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	8b 40 0c             	mov    0xc(%eax),%eax
  801f18:	89 04 24             	mov    %eax,(%esp)
  801f1b:	e8 ae 02 00 00       	call   8021ce <nsipc_send>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f28:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f2f:	00 
  801f30:	8b 45 10             	mov    0x10(%ebp),%eax
  801f33:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	8b 40 0c             	mov    0xc(%eax),%eax
  801f44:	89 04 24             	mov    %eax,(%esp)
  801f47:	e8 f5 02 00 00       	call   802241 <nsipc_recv>
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	56                   	push   %esi
  801f52:	53                   	push   %ebx
  801f53:	83 ec 20             	sub    $0x20,%esp
  801f56:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5b:	89 04 24             	mov    %eax,(%esp)
  801f5e:	e8 f8 f6 ff ff       	call   80165b <fd_alloc>
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 21                	js     801f8a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801f69:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f70:	00 
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7f:	e8 f7 f0 ff ff       	call   80107b <sys_page_alloc>
  801f84:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f86:	85 c0                	test   %eax,%eax
  801f88:	79 0a                	jns    801f94 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801f8a:	89 34 24             	mov    %esi,(%esp)
  801f8d:	e8 00 02 00 00       	call   802192 <nsipc_close>
		return r;
  801f92:	eb 28                	jmp    801fbc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f94:	8b 15 20 70 80 00    	mov    0x807020,%edx
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	89 04 24             	mov    %eax,(%esp)
  801fb5:	e8 76 f6 ff ff       	call   801630 <fd2num>
  801fba:	89 c3                	mov    %eax,%ebx
}
  801fbc:	89 d8                	mov    %ebx,%eax
  801fbe:	83 c4 20             	add    $0x20,%esp
  801fc1:	5b                   	pop    %ebx
  801fc2:	5e                   	pop    %esi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fce:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	89 04 24             	mov    %eax,(%esp)
  801fdf:	e8 62 01 00 00       	call   802146 <nsipc_socket>
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	78 05                	js     801fed <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801fe8:	e8 61 ff ff ff       	call   801f4e <alloc_sockfd>
}
  801fed:	c9                   	leave  
  801fee:	66 90                	xchg   %ax,%ax
  801ff0:	c3                   	ret    

00801ff1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ff7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ffa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ffe:	89 04 24             	mov    %eax,(%esp)
  802001:	e8 c7 f6 ff ff       	call   8016cd <fd_lookup>
  802006:	85 c0                	test   %eax,%eax
  802008:	78 15                	js     80201f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80200a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200d:	8b 0a                	mov    (%edx),%ecx
  80200f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802014:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80201a:	75 03                	jne    80201f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80201c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	e8 c2 ff ff ff       	call   801ff1 <fd2sockid>
  80202f:	85 c0                	test   %eax,%eax
  802031:	78 0f                	js     802042 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802033:	8b 55 0c             	mov    0xc(%ebp),%edx
  802036:	89 54 24 04          	mov    %edx,0x4(%esp)
  80203a:	89 04 24             	mov    %eax,(%esp)
  80203d:	e8 2e 01 00 00       	call   802170 <nsipc_listen>
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	e8 9f ff ff ff       	call   801ff1 <fd2sockid>
  802052:	85 c0                	test   %eax,%eax
  802054:	78 16                	js     80206c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802056:	8b 55 10             	mov    0x10(%ebp),%edx
  802059:	89 54 24 08          	mov    %edx,0x8(%esp)
  80205d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802060:	89 54 24 04          	mov    %edx,0x4(%esp)
  802064:	89 04 24             	mov    %eax,(%esp)
  802067:	e8 55 02 00 00       	call   8022c1 <nsipc_connect>
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	e8 75 ff ff ff       	call   801ff1 <fd2sockid>
  80207c:	85 c0                	test   %eax,%eax
  80207e:	78 0f                	js     80208f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802080:	8b 55 0c             	mov    0xc(%ebp),%edx
  802083:	89 54 24 04          	mov    %edx,0x4(%esp)
  802087:	89 04 24             	mov    %eax,(%esp)
  80208a:	e8 1d 01 00 00       	call   8021ac <nsipc_shutdown>
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	e8 52 ff ff ff       	call   801ff1 <fd2sockid>
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	78 16                	js     8020b9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8020a3:	8b 55 10             	mov    0x10(%ebp),%edx
  8020a6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ad:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020b1:	89 04 24             	mov    %eax,(%esp)
  8020b4:	e8 47 02 00 00       	call   802300 <nsipc_bind>
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	e8 28 ff ff ff       	call   801ff1 <fd2sockid>
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	78 1f                	js     8020ec <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020cd:	8b 55 10             	mov    0x10(%ebp),%edx
  8020d0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020db:	89 04 24             	mov    %eax,(%esp)
  8020de:	e8 5c 02 00 00       	call   80233f <nsipc_accept>
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	78 05                	js     8020ec <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8020e7:	e8 62 fe ff ff       	call   801f4e <alloc_sockfd>
}
  8020ec:	c9                   	leave  
  8020ed:	8d 76 00             	lea    0x0(%esi),%esi
  8020f0:	c3                   	ret    
	...

00802100 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802106:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80210c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802113:	00 
  802114:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80211b:	00 
  80211c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802120:	89 14 24             	mov    %edx,(%esp)
  802123:	e8 38 f4 ff ff       	call   801560 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802128:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80212f:	00 
  802130:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802137:	00 
  802138:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213f:	e8 82 f4 ff ff       	call   8015c6 <ipc_recv>
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802154:	8b 45 0c             	mov    0xc(%ebp),%eax
  802157:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80215c:	8b 45 10             	mov    0x10(%ebp),%eax
  80215f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802164:	b8 09 00 00 00       	mov    $0x9,%eax
  802169:	e8 92 ff ff ff       	call   802100 <nsipc>
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80217e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802181:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802186:	b8 06 00 00 00       	mov    $0x6,%eax
  80218b:	e8 70 ff ff ff       	call   802100 <nsipc>
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8021a0:	b8 04 00 00 00       	mov    $0x4,%eax
  8021a5:	e8 56 ff ff ff       	call   802100 <nsipc>
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8021c2:	b8 03 00 00 00       	mov    $0x3,%eax
  8021c7:	e8 34 ff ff ff       	call   802100 <nsipc>
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 14             	sub    $0x14,%esp
  8021d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021e0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021e6:	7e 24                	jle    80220c <nsipc_send+0x3e>
  8021e8:	c7 44 24 0c 44 33 80 	movl   $0x803344,0xc(%esp)
  8021ef:	00 
  8021f0:	c7 44 24 08 50 33 80 	movl   $0x803350,0x8(%esp)
  8021f7:	00 
  8021f8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8021ff:	00 
  802200:	c7 04 24 65 33 80 00 	movl   $0x803365,(%esp)
  802207:	e8 20 07 00 00       	call   80292c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80220c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80221e:	e8 22 e8 ff ff       	call   800a45 <memmove>
	nsipcbuf.send.req_size = size;
  802223:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802229:	8b 45 14             	mov    0x14(%ebp),%eax
  80222c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802231:	b8 08 00 00 00       	mov    $0x8,%eax
  802236:	e8 c5 fe ff ff       	call   802100 <nsipc>
}
  80223b:	83 c4 14             	add    $0x14,%esp
  80223e:	5b                   	pop    %ebx
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    

00802241 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	56                   	push   %esi
  802245:	53                   	push   %ebx
  802246:	83 ec 10             	sub    $0x10,%esp
  802249:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802254:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80225a:	8b 45 14             	mov    0x14(%ebp),%eax
  80225d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802262:	b8 07 00 00 00       	mov    $0x7,%eax
  802267:	e8 94 fe ff ff       	call   802100 <nsipc>
  80226c:	89 c3                	mov    %eax,%ebx
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 46                	js     8022b8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802272:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802277:	7f 04                	jg     80227d <nsipc_recv+0x3c>
  802279:	39 c6                	cmp    %eax,%esi
  80227b:	7d 24                	jge    8022a1 <nsipc_recv+0x60>
  80227d:	c7 44 24 0c 71 33 80 	movl   $0x803371,0xc(%esp)
  802284:	00 
  802285:	c7 44 24 08 50 33 80 	movl   $0x803350,0x8(%esp)
  80228c:	00 
  80228d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802294:	00 
  802295:	c7 04 24 65 33 80 00 	movl   $0x803365,(%esp)
  80229c:	e8 8b 06 00 00       	call   80292c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a5:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8022ac:	00 
  8022ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b0:	89 04 24             	mov    %eax,(%esp)
  8022b3:	e8 8d e7 ff ff       	call   800a45 <memmove>
	}

	return r;
}
  8022b8:	89 d8                	mov    %ebx,%eax
  8022ba:	83 c4 10             	add    $0x10,%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    

008022c1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	53                   	push   %ebx
  8022c5:	83 ec 14             	sub    $0x14,%esp
  8022c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022de:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8022e5:	e8 5b e7 ff ff       	call   800a45 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022ea:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8022f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8022f5:	e8 06 fe ff ff       	call   802100 <nsipc>
}
  8022fa:	83 c4 14             	add    $0x14,%esp
  8022fd:	5b                   	pop    %ebx
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    

00802300 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	53                   	push   %ebx
  802304:	83 ec 14             	sub    $0x14,%esp
  802307:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802312:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802324:	e8 1c e7 ff ff       	call   800a45 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802329:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80232f:	b8 02 00 00 00       	mov    $0x2,%eax
  802334:	e8 c7 fd ff ff       	call   802100 <nsipc>
}
  802339:	83 c4 14             	add    $0x14,%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5d                   	pop    %ebp
  80233e:	c3                   	ret    

0080233f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 18             	sub    $0x18,%esp
  802345:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802348:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802353:	b8 01 00 00 00       	mov    $0x1,%eax
  802358:	e8 a3 fd ff ff       	call   802100 <nsipc>
  80235d:	89 c3                	mov    %eax,%ebx
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 25                	js     802388 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802363:	be 10 60 80 00       	mov    $0x806010,%esi
  802368:	8b 06                	mov    (%esi),%eax
  80236a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80236e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802375:	00 
  802376:	8b 45 0c             	mov    0xc(%ebp),%eax
  802379:	89 04 24             	mov    %eax,(%esp)
  80237c:	e8 c4 e6 ff ff       	call   800a45 <memmove>
		*addrlen = ret->ret_addrlen;
  802381:	8b 16                	mov    (%esi),%edx
  802383:	8b 45 10             	mov    0x10(%ebp),%eax
  802386:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802388:	89 d8                	mov    %ebx,%eax
  80238a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80238d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802390:	89 ec                	mov    %ebp,%esp
  802392:	5d                   	pop    %ebp
  802393:	c3                   	ret    
	...

008023a0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 18             	sub    $0x18,%esp
  8023a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8023ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	89 04 24             	mov    %eax,(%esp)
  8023b5:	e8 86 f2 ff ff       	call   801640 <fd2data>
  8023ba:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8023bc:	c7 44 24 04 86 33 80 	movl   $0x803386,0x4(%esp)
  8023c3:	00 
  8023c4:	89 34 24             	mov    %esi,(%esp)
  8023c7:	e8 be e4 ff ff       	call   80088a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023cc:	8b 43 04             	mov    0x4(%ebx),%eax
  8023cf:	2b 03                	sub    (%ebx),%eax
  8023d1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8023d7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8023de:	00 00 00 
	stat->st_dev = &devpipe;
  8023e1:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  8023e8:	70 80 00 
	return 0;
}
  8023eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023f3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023f6:	89 ec                	mov    %ebp,%esp
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    

008023fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 14             	sub    $0x14,%esp
  802401:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802404:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802408:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80240f:	e8 ab eb ff ff       	call   800fbf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802414:	89 1c 24             	mov    %ebx,(%esp)
  802417:	e8 24 f2 ff ff       	call   801640 <fd2data>
  80241c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802420:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802427:	e8 93 eb ff ff       	call   800fbf <sys_page_unmap>
}
  80242c:	83 c4 14             	add    $0x14,%esp
  80242f:	5b                   	pop    %ebx
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    

00802432 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	57                   	push   %edi
  802436:	56                   	push   %esi
  802437:	53                   	push   %ebx
  802438:	83 ec 2c             	sub    $0x2c,%esp
  80243b:	89 c7                	mov    %eax,%edi
  80243d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802440:	a1 74 70 80 00       	mov    0x807074,%eax
  802445:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802448:	89 3c 24             	mov    %edi,(%esp)
  80244b:	e8 00 06 00 00       	call   802a50 <pageref>
  802450:	89 c6                	mov    %eax,%esi
  802452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802455:	89 04 24             	mov    %eax,(%esp)
  802458:	e8 f3 05 00 00       	call   802a50 <pageref>
  80245d:	39 c6                	cmp    %eax,%esi
  80245f:	0f 94 c0             	sete   %al
  802462:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802465:	8b 15 74 70 80 00    	mov    0x807074,%edx
  80246b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80246e:	39 cb                	cmp    %ecx,%ebx
  802470:	75 08                	jne    80247a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802472:	83 c4 2c             	add    $0x2c,%esp
  802475:	5b                   	pop    %ebx
  802476:	5e                   	pop    %esi
  802477:	5f                   	pop    %edi
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80247a:	83 f8 01             	cmp    $0x1,%eax
  80247d:	75 c1                	jne    802440 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80247f:	8b 52 58             	mov    0x58(%edx),%edx
  802482:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802486:	89 54 24 08          	mov    %edx,0x8(%esp)
  80248a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80248e:	c7 04 24 8d 33 80 00 	movl   $0x80338d,(%esp)
  802495:	e8 2b dd ff ff       	call   8001c5 <cprintf>
  80249a:	eb a4                	jmp    802440 <_pipeisclosed+0xe>

0080249c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	57                   	push   %edi
  8024a0:	56                   	push   %esi
  8024a1:	53                   	push   %ebx
  8024a2:	83 ec 1c             	sub    $0x1c,%esp
  8024a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024a8:	89 34 24             	mov    %esi,(%esp)
  8024ab:	e8 90 f1 ff ff       	call   801640 <fd2data>
  8024b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024bb:	75 54                	jne    802511 <devpipe_write+0x75>
  8024bd:	eb 60                	jmp    80251f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024bf:	89 da                	mov    %ebx,%edx
  8024c1:	89 f0                	mov    %esi,%eax
  8024c3:	e8 6a ff ff ff       	call   802432 <_pipeisclosed>
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	74 07                	je     8024d3 <devpipe_write+0x37>
  8024cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d1:	eb 53                	jmp    802526 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024d3:	90                   	nop
  8024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	e8 fd eb ff ff       	call   8010da <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024dd:	8b 43 04             	mov    0x4(%ebx),%eax
  8024e0:	8b 13                	mov    (%ebx),%edx
  8024e2:	83 c2 20             	add    $0x20,%edx
  8024e5:	39 d0                	cmp    %edx,%eax
  8024e7:	73 d6                	jae    8024bf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024e9:	89 c2                	mov    %eax,%edx
  8024eb:	c1 fa 1f             	sar    $0x1f,%edx
  8024ee:	c1 ea 1b             	shr    $0x1b,%edx
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	83 e0 1f             	and    $0x1f,%eax
  8024f6:	29 d0                	sub    %edx,%eax
  8024f8:	89 c2                	mov    %eax,%edx
  8024fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024fd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802501:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802505:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802509:	83 c7 01             	add    $0x1,%edi
  80250c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80250f:	76 13                	jbe    802524 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802511:	8b 43 04             	mov    0x4(%ebx),%eax
  802514:	8b 13                	mov    (%ebx),%edx
  802516:	83 c2 20             	add    $0x20,%edx
  802519:	39 d0                	cmp    %edx,%eax
  80251b:	73 a2                	jae    8024bf <devpipe_write+0x23>
  80251d:	eb ca                	jmp    8024e9 <devpipe_write+0x4d>
  80251f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802524:	89 f8                	mov    %edi,%eax
}
  802526:	83 c4 1c             	add    $0x1c,%esp
  802529:	5b                   	pop    %ebx
  80252a:	5e                   	pop    %esi
  80252b:	5f                   	pop    %edi
  80252c:	5d                   	pop    %ebp
  80252d:	c3                   	ret    

0080252e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 28             	sub    $0x28,%esp
  802534:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802537:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80253a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80253d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802540:	89 3c 24             	mov    %edi,(%esp)
  802543:	e8 f8 f0 ff ff       	call   801640 <fd2data>
  802548:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80254a:	be 00 00 00 00       	mov    $0x0,%esi
  80254f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802553:	75 4c                	jne    8025a1 <devpipe_read+0x73>
  802555:	eb 5b                	jmp    8025b2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802557:	89 f0                	mov    %esi,%eax
  802559:	eb 5e                	jmp    8025b9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80255b:	89 da                	mov    %ebx,%edx
  80255d:	89 f8                	mov    %edi,%eax
  80255f:	90                   	nop
  802560:	e8 cd fe ff ff       	call   802432 <_pipeisclosed>
  802565:	85 c0                	test   %eax,%eax
  802567:	74 07                	je     802570 <devpipe_read+0x42>
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
  80256e:	eb 49                	jmp    8025b9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802570:	e8 65 eb ff ff       	call   8010da <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802575:	8b 03                	mov    (%ebx),%eax
  802577:	3b 43 04             	cmp    0x4(%ebx),%eax
  80257a:	74 df                	je     80255b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80257c:	89 c2                	mov    %eax,%edx
  80257e:	c1 fa 1f             	sar    $0x1f,%edx
  802581:	c1 ea 1b             	shr    $0x1b,%edx
  802584:	01 d0                	add    %edx,%eax
  802586:	83 e0 1f             	and    $0x1f,%eax
  802589:	29 d0                	sub    %edx,%eax
  80258b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802590:	8b 55 0c             	mov    0xc(%ebp),%edx
  802593:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802596:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802599:	83 c6 01             	add    $0x1,%esi
  80259c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80259f:	76 16                	jbe    8025b7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  8025a1:	8b 03                	mov    (%ebx),%eax
  8025a3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025a6:	75 d4                	jne    80257c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8025a8:	85 f6                	test   %esi,%esi
  8025aa:	75 ab                	jne    802557 <devpipe_read+0x29>
  8025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	eb a9                	jmp    80255b <devpipe_read+0x2d>
  8025b2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025b7:	89 f0                	mov    %esi,%eax
}
  8025b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025c2:	89 ec                	mov    %ebp,%esp
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    

008025c6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
  8025c9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	89 04 24             	mov    %eax,(%esp)
  8025d9:	e8 ef f0 ff ff       	call   8016cd <fd_lookup>
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	78 15                	js     8025f7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	89 04 24             	mov    %eax,(%esp)
  8025e8:	e8 53 f0 ff ff       	call   801640 <fd2data>
	return _pipeisclosed(fd, p);
  8025ed:	89 c2                	mov    %eax,%edx
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	e8 3b fe ff ff       	call   802432 <_pipeisclosed>
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
  8025fc:	83 ec 48             	sub    $0x48,%esp
  8025ff:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802602:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802605:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802608:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80260b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80260e:	89 04 24             	mov    %eax,(%esp)
  802611:	e8 45 f0 ff ff       	call   80165b <fd_alloc>
  802616:	89 c3                	mov    %eax,%ebx
  802618:	85 c0                	test   %eax,%eax
  80261a:	0f 88 42 01 00 00    	js     802762 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802620:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802627:	00 
  802628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802636:	e8 40 ea ff ff       	call   80107b <sys_page_alloc>
  80263b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80263d:	85 c0                	test   %eax,%eax
  80263f:	0f 88 1d 01 00 00    	js     802762 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802645:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802648:	89 04 24             	mov    %eax,(%esp)
  80264b:	e8 0b f0 ff ff       	call   80165b <fd_alloc>
  802650:	89 c3                	mov    %eax,%ebx
  802652:	85 c0                	test   %eax,%eax
  802654:	0f 88 f5 00 00 00    	js     80274f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802661:	00 
  802662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802665:	89 44 24 04          	mov    %eax,0x4(%esp)
  802669:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802670:	e8 06 ea ff ff       	call   80107b <sys_page_alloc>
  802675:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802677:	85 c0                	test   %eax,%eax
  802679:	0f 88 d0 00 00 00    	js     80274f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80267f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802682:	89 04 24             	mov    %eax,(%esp)
  802685:	e8 b6 ef ff ff       	call   801640 <fd2data>
  80268a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802693:	00 
  802694:	89 44 24 04          	mov    %eax,0x4(%esp)
  802698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80269f:	e8 d7 e9 ff ff       	call   80107b <sys_page_alloc>
  8026a4:	89 c3                	mov    %eax,%ebx
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	0f 88 8e 00 00 00    	js     80273c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b1:	89 04 24             	mov    %eax,(%esp)
  8026b4:	e8 87 ef ff ff       	call   801640 <fd2data>
  8026b9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026c0:	00 
  8026c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026cc:	00 
  8026cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d8:	e8 40 e9 ff ff       	call   80101d <sys_page_map>
  8026dd:	89 c3                	mov    %eax,%ebx
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	78 49                	js     80272c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026e3:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  8026e8:	8b 08                	mov    (%eax),%ecx
  8026ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ed:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8026f9:	8b 10                	mov    (%eax),%edx
  8026fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fe:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802703:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80270a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270d:	89 04 24             	mov    %eax,(%esp)
  802710:	e8 1b ef ff ff       	call   801630 <fd2num>
  802715:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802717:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271a:	89 04 24             	mov    %eax,(%esp)
  80271d:	e8 0e ef ff ff       	call   801630 <fd2num>
  802722:	89 47 04             	mov    %eax,0x4(%edi)
  802725:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80272a:	eb 36                	jmp    802762 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80272c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802737:	e8 83 e8 ff ff       	call   800fbf <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80273c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802743:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80274a:	e8 70 e8 ff ff       	call   800fbf <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80274f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802752:	89 44 24 04          	mov    %eax,0x4(%esp)
  802756:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80275d:	e8 5d e8 ff ff       	call   800fbf <sys_page_unmap>
    err:
	return r;
}
  802762:	89 d8                	mov    %ebx,%eax
  802764:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802767:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80276a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80276d:	89 ec                	mov    %ebp,%esp
  80276f:	5d                   	pop    %ebp
  802770:	c3                   	ret    
	...

00802780 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    

0080278a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802790:	c7 44 24 04 a5 33 80 	movl   $0x8033a5,0x4(%esp)
  802797:	00 
  802798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279b:	89 04 24             	mov    %eax,(%esp)
  80279e:	e8 e7 e0 ff ff       	call   80088a <strcpy>
	return 0;
}
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	57                   	push   %edi
  8027ae:	56                   	push   %esi
  8027af:	53                   	push   %ebx
  8027b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	be 00 00 00 00       	mov    $0x0,%esi
  8027c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027c4:	74 3f                	je     802805 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8027cf:	29 c2                	sub    %eax,%edx
  8027d1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8027d3:	83 fa 7f             	cmp    $0x7f,%edx
  8027d6:	76 05                	jbe    8027dd <devcons_write+0x33>
  8027d8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027dd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027e1:	03 45 0c             	add    0xc(%ebp),%eax
  8027e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e8:	89 3c 24             	mov    %edi,(%esp)
  8027eb:	e8 55 e2 ff ff       	call   800a45 <memmove>
		sys_cputs(buf, m);
  8027f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027f4:	89 3c 24             	mov    %edi,(%esp)
  8027f7:	e8 84 e4 ff ff       	call   800c80 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027fc:	01 de                	add    %ebx,%esi
  8027fe:	89 f0                	mov    %esi,%eax
  802800:	3b 75 10             	cmp    0x10(%ebp),%esi
  802803:	72 c7                	jb     8027cc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802805:	89 f0                	mov    %esi,%eax
  802807:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80280d:	5b                   	pop    %ebx
  80280e:	5e                   	pop    %esi
  80280f:	5f                   	pop    %edi
  802810:	5d                   	pop    %ebp
  802811:	c3                   	ret    

00802812 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802812:	55                   	push   %ebp
  802813:	89 e5                	mov    %esp,%ebp
  802815:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802818:	8b 45 08             	mov    0x8(%ebp),%eax
  80281b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80281e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802825:	00 
  802826:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802829:	89 04 24             	mov    %eax,(%esp)
  80282c:	e8 4f e4 ff ff       	call   800c80 <sys_cputs>
}
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
  802836:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802839:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80283d:	75 07                	jne    802846 <devcons_read+0x13>
  80283f:	eb 28                	jmp    802869 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802841:	e8 94 e8 ff ff       	call   8010da <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802846:	66 90                	xchg   %ax,%ax
  802848:	e8 ff e3 ff ff       	call   800c4c <sys_cgetc>
  80284d:	85 c0                	test   %eax,%eax
  80284f:	90                   	nop
  802850:	74 ef                	je     802841 <devcons_read+0xe>
  802852:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802854:	85 c0                	test   %eax,%eax
  802856:	78 16                	js     80286e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802858:	83 f8 04             	cmp    $0x4,%eax
  80285b:	74 0c                	je     802869 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80285d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802860:	88 10                	mov    %dl,(%eax)
  802862:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802867:	eb 05                	jmp    80286e <devcons_read+0x3b>
  802869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286e:	c9                   	leave  
  80286f:	c3                   	ret    

00802870 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802876:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802879:	89 04 24             	mov    %eax,(%esp)
  80287c:	e8 da ed ff ff       	call   80165b <fd_alloc>
  802881:	85 c0                	test   %eax,%eax
  802883:	78 3f                	js     8028c4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802885:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80288c:	00 
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	89 44 24 04          	mov    %eax,0x4(%esp)
  802894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80289b:	e8 db e7 ff ff       	call   80107b <sys_page_alloc>
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	78 20                	js     8028c4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028a4:	8b 15 58 70 80 00    	mov    0x807058,%edx
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	89 04 24             	mov    %eax,(%esp)
  8028bf:	e8 6c ed ff ff       	call   801630 <fd2num>
}
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	89 04 24             	mov    %eax,(%esp)
  8028d9:	e8 ef ed ff ff       	call   8016cd <fd_lookup>
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	78 11                	js     8028f3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  8028ed:	0f 94 c0             	sete   %al
  8028f0:	0f b6 c0             	movzbl %al,%eax
}
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802902:	00 
  802903:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802906:	89 44 24 04          	mov    %eax,0x4(%esp)
  80290a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802911:	e8 18 f0 ff ff       	call   80192e <read>
	if (r < 0)
  802916:	85 c0                	test   %eax,%eax
  802918:	78 0f                	js     802929 <getchar+0x34>
		return r;
	if (r < 1)
  80291a:	85 c0                	test   %eax,%eax
  80291c:	7f 07                	jg     802925 <getchar+0x30>
  80291e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802923:	eb 04                	jmp    802929 <getchar+0x34>
		return -E_EOF;
	return c;
  802925:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802929:	c9                   	leave  
  80292a:	c3                   	ret    
	...

0080292c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	53                   	push   %ebx
  802930:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  802933:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  802936:	a1 78 70 80 00       	mov    0x807078,%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	74 10                	je     80294f <_panic+0x23>
		cprintf("%s: ", argv0);
  80293f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802943:	c7 04 24 b1 33 80 00 	movl   $0x8033b1,(%esp)
  80294a:	e8 76 d8 ff ff       	call   8001c5 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80294f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802952:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	89 44 24 08          	mov    %eax,0x8(%esp)
  80295d:	a1 00 70 80 00       	mov    0x807000,%eax
  802962:	89 44 24 04          	mov    %eax,0x4(%esp)
  802966:	c7 04 24 b6 33 80 00 	movl   $0x8033b6,(%esp)
  80296d:	e8 53 d8 ff ff       	call   8001c5 <cprintf>
	vcprintf(fmt, ap);
  802972:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802976:	8b 45 10             	mov    0x10(%ebp),%eax
  802979:	89 04 24             	mov    %eax,(%esp)
  80297c:	e8 e3 d7 ff ff       	call   800164 <vcprintf>
	cprintf("\n");
  802981:	c7 04 24 9e 33 80 00 	movl   $0x80339e,(%esp)
  802988:	e8 38 d8 ff ff       	call   8001c5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80298d:	cc                   	int3   
  80298e:	eb fd                	jmp    80298d <_panic+0x61>

00802990 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802996:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  80299d:	75 78                	jne    802a17 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80299f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029a6:	00 
  8029a7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029ae:	ee 
  8029af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b6:	e8 c0 e6 ff ff       	call   80107b <sys_page_alloc>
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	79 20                	jns    8029df <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  8029bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029c3:	c7 44 24 08 d2 33 80 	movl   $0x8033d2,0x8(%esp)
  8029ca:	00 
  8029cb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8029d2:	00 
  8029d3:	c7 04 24 f0 33 80 00 	movl   $0x8033f0,(%esp)
  8029da:	e8 4d ff ff ff       	call   80292c <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8029df:	c7 44 24 04 24 2a 80 	movl   $0x802a24,0x4(%esp)
  8029e6:	00 
  8029e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ee:	e8 b2 e4 ff ff       	call   800ea5 <sys_env_set_pgfault_upcall>
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	79 20                	jns    802a17 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  8029f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029fb:	c7 44 24 08 00 34 80 	movl   $0x803400,0x8(%esp)
  802a02:	00 
  802a03:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802a0a:	00 
  802a0b:	c7 04 24 f0 33 80 00 	movl   $0x8033f0,(%esp)
  802a12:	e8 15 ff ff ff       	call   80292c <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	a3 7c 70 80 00       	mov    %eax,0x80707c
	
}
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    
  802a21:	00 00                	add    %al,(%eax)
	...

00802a24 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a24:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a25:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  802a2a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a2c:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802a2f:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802a31:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802a35:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802a39:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802a3b:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802a3c:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802a3e:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802a41:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802a45:	83 c4 08             	add    $0x8,%esp
	popal
  802a48:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802a49:	83 c4 04             	add    $0x4,%esp
	popfl
  802a4c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802a4d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802a4e:	c3                   	ret    
	...

00802a50 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	89 c2                	mov    %eax,%edx
  802a58:	c1 ea 16             	shr    $0x16,%edx
  802a5b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802a62:	f6 c2 01             	test   $0x1,%dl
  802a65:	74 26                	je     802a8d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802a67:	c1 e8 0c             	shr    $0xc,%eax
  802a6a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802a71:	a8 01                	test   $0x1,%al
  802a73:	74 18                	je     802a8d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802a75:	c1 e8 0c             	shr    $0xc,%eax
  802a78:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802a7b:	c1 e2 02             	shl    $0x2,%edx
  802a7e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802a83:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802a88:	0f b7 c0             	movzwl %ax,%eax
  802a8b:	eb 05                	jmp    802a92 <pageref+0x42>
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a92:	5d                   	pop    %ebp
  802a93:	c3                   	ret    
	...

00802aa0 <__udivdi3>:
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
  802aa3:	57                   	push   %edi
  802aa4:	56                   	push   %esi
  802aa5:	83 ec 10             	sub    $0x10,%esp
  802aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  802aab:	8b 55 08             	mov    0x8(%ebp),%edx
  802aae:	8b 75 10             	mov    0x10(%ebp),%esi
  802ab1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802ab9:	75 35                	jne    802af0 <__udivdi3+0x50>
  802abb:	39 fe                	cmp    %edi,%esi
  802abd:	77 61                	ja     802b20 <__udivdi3+0x80>
  802abf:	85 f6                	test   %esi,%esi
  802ac1:	75 0b                	jne    802ace <__udivdi3+0x2e>
  802ac3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac8:	31 d2                	xor    %edx,%edx
  802aca:	f7 f6                	div    %esi
  802acc:	89 c6                	mov    %eax,%esi
  802ace:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ad1:	31 d2                	xor    %edx,%edx
  802ad3:	89 f8                	mov    %edi,%eax
  802ad5:	f7 f6                	div    %esi
  802ad7:	89 c7                	mov    %eax,%edi
  802ad9:	89 c8                	mov    %ecx,%eax
  802adb:	f7 f6                	div    %esi
  802add:	89 c1                	mov    %eax,%ecx
  802adf:	89 fa                	mov    %edi,%edx
  802ae1:	89 c8                	mov    %ecx,%eax
  802ae3:	83 c4 10             	add    $0x10,%esp
  802ae6:	5e                   	pop    %esi
  802ae7:	5f                   	pop    %edi
  802ae8:	5d                   	pop    %ebp
  802ae9:	c3                   	ret    
  802aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802af0:	39 f8                	cmp    %edi,%eax
  802af2:	77 1c                	ja     802b10 <__udivdi3+0x70>
  802af4:	0f bd d0             	bsr    %eax,%edx
  802af7:	83 f2 1f             	xor    $0x1f,%edx
  802afa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802afd:	75 39                	jne    802b38 <__udivdi3+0x98>
  802aff:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802b02:	0f 86 a0 00 00 00    	jbe    802ba8 <__udivdi3+0x108>
  802b08:	39 f8                	cmp    %edi,%eax
  802b0a:	0f 82 98 00 00 00    	jb     802ba8 <__udivdi3+0x108>
  802b10:	31 ff                	xor    %edi,%edi
  802b12:	31 c9                	xor    %ecx,%ecx
  802b14:	89 c8                	mov    %ecx,%eax
  802b16:	89 fa                	mov    %edi,%edx
  802b18:	83 c4 10             	add    $0x10,%esp
  802b1b:	5e                   	pop    %esi
  802b1c:	5f                   	pop    %edi
  802b1d:	5d                   	pop    %ebp
  802b1e:	c3                   	ret    
  802b1f:	90                   	nop
  802b20:	89 d1                	mov    %edx,%ecx
  802b22:	89 fa                	mov    %edi,%edx
  802b24:	89 c8                	mov    %ecx,%eax
  802b26:	31 ff                	xor    %edi,%edi
  802b28:	f7 f6                	div    %esi
  802b2a:	89 c1                	mov    %eax,%ecx
  802b2c:	89 fa                	mov    %edi,%edx
  802b2e:	89 c8                	mov    %ecx,%eax
  802b30:	83 c4 10             	add    $0x10,%esp
  802b33:	5e                   	pop    %esi
  802b34:	5f                   	pop    %edi
  802b35:	5d                   	pop    %ebp
  802b36:	c3                   	ret    
  802b37:	90                   	nop
  802b38:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b3c:	89 f2                	mov    %esi,%edx
  802b3e:	d3 e0                	shl    %cl,%eax
  802b40:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b43:	b8 20 00 00 00       	mov    $0x20,%eax
  802b48:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b4b:	89 c1                	mov    %eax,%ecx
  802b4d:	d3 ea                	shr    %cl,%edx
  802b4f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b53:	0b 55 ec             	or     -0x14(%ebp),%edx
  802b56:	d3 e6                	shl    %cl,%esi
  802b58:	89 c1                	mov    %eax,%ecx
  802b5a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802b5d:	89 fe                	mov    %edi,%esi
  802b5f:	d3 ee                	shr    %cl,%esi
  802b61:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b65:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802b68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6b:	d3 e7                	shl    %cl,%edi
  802b6d:	89 c1                	mov    %eax,%ecx
  802b6f:	d3 ea                	shr    %cl,%edx
  802b71:	09 d7                	or     %edx,%edi
  802b73:	89 f2                	mov    %esi,%edx
  802b75:	89 f8                	mov    %edi,%eax
  802b77:	f7 75 ec             	divl   -0x14(%ebp)
  802b7a:	89 d6                	mov    %edx,%esi
  802b7c:	89 c7                	mov    %eax,%edi
  802b7e:	f7 65 e8             	mull   -0x18(%ebp)
  802b81:	39 d6                	cmp    %edx,%esi
  802b83:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802b86:	72 30                	jb     802bb8 <__udivdi3+0x118>
  802b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b8f:	d3 e2                	shl    %cl,%edx
  802b91:	39 c2                	cmp    %eax,%edx
  802b93:	73 05                	jae    802b9a <__udivdi3+0xfa>
  802b95:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802b98:	74 1e                	je     802bb8 <__udivdi3+0x118>
  802b9a:	89 f9                	mov    %edi,%ecx
  802b9c:	31 ff                	xor    %edi,%edi
  802b9e:	e9 71 ff ff ff       	jmp    802b14 <__udivdi3+0x74>
  802ba3:	90                   	nop
  802ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	31 ff                	xor    %edi,%edi
  802baa:	b9 01 00 00 00       	mov    $0x1,%ecx
  802baf:	e9 60 ff ff ff       	jmp    802b14 <__udivdi3+0x74>
  802bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802bbb:	31 ff                	xor    %edi,%edi
  802bbd:	89 c8                	mov    %ecx,%eax
  802bbf:	89 fa                	mov    %edi,%edx
  802bc1:	83 c4 10             	add    $0x10,%esp
  802bc4:	5e                   	pop    %esi
  802bc5:	5f                   	pop    %edi
  802bc6:	5d                   	pop    %ebp
  802bc7:	c3                   	ret    
	...

00802bd0 <__umoddi3>:
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
  802bd3:	57                   	push   %edi
  802bd4:	56                   	push   %esi
  802bd5:	83 ec 20             	sub    $0x20,%esp
  802bd8:	8b 55 14             	mov    0x14(%ebp),%edx
  802bdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bde:	8b 7d 10             	mov    0x10(%ebp),%edi
  802be1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802be4:	85 d2                	test   %edx,%edx
  802be6:	89 c8                	mov    %ecx,%eax
  802be8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802beb:	75 13                	jne    802c00 <__umoddi3+0x30>
  802bed:	39 f7                	cmp    %esi,%edi
  802bef:	76 3f                	jbe    802c30 <__umoddi3+0x60>
  802bf1:	89 f2                	mov    %esi,%edx
  802bf3:	f7 f7                	div    %edi
  802bf5:	89 d0                	mov    %edx,%eax
  802bf7:	31 d2                	xor    %edx,%edx
  802bf9:	83 c4 20             	add    $0x20,%esp
  802bfc:	5e                   	pop    %esi
  802bfd:	5f                   	pop    %edi
  802bfe:	5d                   	pop    %ebp
  802bff:	c3                   	ret    
  802c00:	39 f2                	cmp    %esi,%edx
  802c02:	77 4c                	ja     802c50 <__umoddi3+0x80>
  802c04:	0f bd ca             	bsr    %edx,%ecx
  802c07:	83 f1 1f             	xor    $0x1f,%ecx
  802c0a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802c0d:	75 51                	jne    802c60 <__umoddi3+0x90>
  802c0f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802c12:	0f 87 e0 00 00 00    	ja     802cf8 <__umoddi3+0x128>
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	29 f8                	sub    %edi,%eax
  802c1d:	19 d6                	sbb    %edx,%esi
  802c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	89 f2                	mov    %esi,%edx
  802c27:	83 c4 20             	add    $0x20,%esp
  802c2a:	5e                   	pop    %esi
  802c2b:	5f                   	pop    %edi
  802c2c:	5d                   	pop    %ebp
  802c2d:	c3                   	ret    
  802c2e:	66 90                	xchg   %ax,%ax
  802c30:	85 ff                	test   %edi,%edi
  802c32:	75 0b                	jne    802c3f <__umoddi3+0x6f>
  802c34:	b8 01 00 00 00       	mov    $0x1,%eax
  802c39:	31 d2                	xor    %edx,%edx
  802c3b:	f7 f7                	div    %edi
  802c3d:	89 c7                	mov    %eax,%edi
  802c3f:	89 f0                	mov    %esi,%eax
  802c41:	31 d2                	xor    %edx,%edx
  802c43:	f7 f7                	div    %edi
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	f7 f7                	div    %edi
  802c4a:	eb a9                	jmp    802bf5 <__umoddi3+0x25>
  802c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c50:	89 c8                	mov    %ecx,%eax
  802c52:	89 f2                	mov    %esi,%edx
  802c54:	83 c4 20             	add    $0x20,%esp
  802c57:	5e                   	pop    %esi
  802c58:	5f                   	pop    %edi
  802c59:	5d                   	pop    %ebp
  802c5a:	c3                   	ret    
  802c5b:	90                   	nop
  802c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c60:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c64:	d3 e2                	shl    %cl,%edx
  802c66:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c69:	ba 20 00 00 00       	mov    $0x20,%edx
  802c6e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802c71:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c74:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c78:	89 fa                	mov    %edi,%edx
  802c7a:	d3 ea                	shr    %cl,%edx
  802c7c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c80:	0b 55 f4             	or     -0xc(%ebp),%edx
  802c83:	d3 e7                	shl    %cl,%edi
  802c85:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c89:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c8c:	89 f2                	mov    %esi,%edx
  802c8e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802c91:	89 c7                	mov    %eax,%edi
  802c93:	d3 ea                	shr    %cl,%edx
  802c95:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c99:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802c9c:	89 c2                	mov    %eax,%edx
  802c9e:	d3 e6                	shl    %cl,%esi
  802ca0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ca4:	d3 ea                	shr    %cl,%edx
  802ca6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802caa:	09 d6                	or     %edx,%esi
  802cac:	89 f0                	mov    %esi,%eax
  802cae:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802cb1:	d3 e7                	shl    %cl,%edi
  802cb3:	89 f2                	mov    %esi,%edx
  802cb5:	f7 75 f4             	divl   -0xc(%ebp)
  802cb8:	89 d6                	mov    %edx,%esi
  802cba:	f7 65 e8             	mull   -0x18(%ebp)
  802cbd:	39 d6                	cmp    %edx,%esi
  802cbf:	72 2b                	jb     802cec <__umoddi3+0x11c>
  802cc1:	39 c7                	cmp    %eax,%edi
  802cc3:	72 23                	jb     802ce8 <__umoddi3+0x118>
  802cc5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cc9:	29 c7                	sub    %eax,%edi
  802ccb:	19 d6                	sbb    %edx,%esi
  802ccd:	89 f0                	mov    %esi,%eax
  802ccf:	89 f2                	mov    %esi,%edx
  802cd1:	d3 ef                	shr    %cl,%edi
  802cd3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cd7:	d3 e0                	shl    %cl,%eax
  802cd9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cdd:	09 f8                	or     %edi,%eax
  802cdf:	d3 ea                	shr    %cl,%edx
  802ce1:	83 c4 20             	add    $0x20,%esp
  802ce4:	5e                   	pop    %esi
  802ce5:	5f                   	pop    %edi
  802ce6:	5d                   	pop    %ebp
  802ce7:	c3                   	ret    
  802ce8:	39 d6                	cmp    %edx,%esi
  802cea:	75 d9                	jne    802cc5 <__umoddi3+0xf5>
  802cec:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802cef:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802cf2:	eb d1                	jmp    802cc5 <__umoddi3+0xf5>
  802cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cf8:	39 f2                	cmp    %esi,%edx
  802cfa:	0f 82 18 ff ff ff    	jb     802c18 <__umoddi3+0x48>
  802d00:	e9 1d ff ff ff       	jmp    802c22 <__umoddi3+0x52>
