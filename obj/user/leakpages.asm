
obj/user/leakpages:     file format elf32-i386


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
  80002c:	e8 97 00 00 00       	call   8000c8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#include <inc/lib.h>
#define N 65536
//#define N 131072

void umain()
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 28             	sub    $0x28,%esp

	int i;
	struct Page *p = NULL;
  80003a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *va = (void*)0xF000;
	
	// Leak the low memory pages
	i = sys_page_waste(&p, N);
  800041:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
  800048:	00 
  800049:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 8f 0c 00 00       	call   800ce3 <sys_page_waste>
	cprintf("\n Pages leaked / wasted: %d\n", i);
  800054:	89 44 24 04          	mov    %eax,0x4(%esp)
  800058:	c7 04 24 60 28 80 00 	movl   $0x802860,(%esp)
  80005f:	e8 31 01 00 00       	call   800195 <cprintf>
	
	// Allocate a new page
	i = sys_page_alloc(0, va, PTE_P | PTE_U | PTE_W );
  800064:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80006b:	00 
  80006c:	c7 44 24 04 00 f0 00 	movl   $0xf000,0x4(%esp)
  800073:	00 
  800074:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007b:	e8 cb 0f 00 00       	call   80104b <sys_page_alloc>
	if (i < 0)
  800080:	85 c0                	test   %eax,%eax
  800082:	79 0c                	jns    800090 <umain+0x5c>
		cprintf("\n Page allocation failed!!\n");
  800084:	c7 04 24 7d 28 80 00 	movl   $0x80287d,(%esp)
  80008b:	e8 05 01 00 00       	call   800195 <cprintf>
	*(int*)va = 35;
  800090:	c7 05 00 f0 00 00 23 	movl   $0x23,0xf000
  800097:	00 00 00 

	cprintf("\n Physical address of allocated page  = %x, value at va = %d\n", (p-pages)<<12, *(int*)va);
  80009a:	c7 44 24 08 23 00 00 	movl   $0x23,0x8(%esp)
  8000a1:	00 
  8000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a5:	2d 00 00 00 ef       	sub    $0xef000000,%eax
  8000aa:	c1 f8 02             	sar    $0x2,%eax
  8000ad:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  8000b3:	c1 e0 0c             	shl    $0xc,%eax
  8000b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ba:	c7 04 24 9c 28 80 00 	movl   $0x80289c,(%esp)
  8000c1:	e8 cf 00 00 00       	call   800195 <cprintf>
		

}
  8000c6:	c9                   	leave  
  8000c7:	c3                   	ret    

008000c8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	83 ec 18             	sub    $0x18,%esp
  8000ce:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000d1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8000d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8000da:	e8 ff 0f 00 00       	call   8010de <sys_getenvid>
	env = &envs[ENVX(envid)];
  8000df:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000e4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ec:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f1:	85 f6                	test   %esi,%esi
  8000f3:	7e 07                	jle    8000fc <libmain+0x34>
		binaryname = argv[0];
  8000f5:	8b 03                	mov    (%ebx),%eax
  8000f7:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  8000fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800100:	89 34 24             	mov    %esi,(%esp)
  800103:	e8 2c ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800108:	e8 0b 00 00 00       	call   800118 <exit>
}
  80010d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800110:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800113:	89 ec                	mov    %ebp,%esp
  800115:	5d                   	pop    %ebp
  800116:	c3                   	ret    
	...

00800118 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80011e:	e8 28 15 00 00       	call   80164b <close_all>
	sys_env_destroy(0);
  800123:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012a:	e8 e3 0f 00 00       	call   801112 <sys_env_destroy>
}
  80012f:	c9                   	leave  
  800130:	c3                   	ret    
  800131:	00 00                	add    %al,(%eax)
	...

00800134 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80013d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800144:	00 00 00 
	b.cnt = 0;
  800147:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80014e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800151:	8b 45 0c             	mov    0xc(%ebp),%eax
  800154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800158:	8b 45 08             	mov    0x8(%ebp),%eax
  80015b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80015f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800165:	89 44 24 04          	mov    %eax,0x4(%esp)
  800169:	c7 04 24 af 01 80 00 	movl   $0x8001af,(%esp)
  800170:	e8 d8 01 00 00       	call   80034d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800175:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80017b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800185:	89 04 24             	mov    %eax,(%esp)
  800188:	e8 c3 0a 00 00       	call   800c50 <sys_cputs>

	return b.cnt;
}
  80018d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80019b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a5:	89 04 24             	mov    %eax,(%esp)
  8001a8:	e8 87 ff ff ff       	call   800134 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ad:	c9                   	leave  
  8001ae:	c3                   	ret    

008001af <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 14             	sub    $0x14,%esp
  8001b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b9:	8b 03                	mov    (%ebx),%eax
  8001bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001be:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001c2:	83 c0 01             	add    $0x1,%eax
  8001c5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cc:	75 19                	jne    8001e7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ce:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001d5:	00 
  8001d6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d9:	89 04 24             	mov    %eax,(%esp)
  8001dc:	e8 6f 0a 00 00       	call   800c50 <sys_cputs>
		b->idx = 0;
  8001e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001e7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001eb:	83 c4 14             	add    $0x14,%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5d                   	pop    %ebp
  8001f0:	c3                   	ret    
	...

00800200 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	57                   	push   %edi
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	83 ec 4c             	sub    $0x4c,%esp
  800209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80020c:	89 d6                	mov    %edx,%esi
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80021a:	8b 45 10             	mov    0x10(%ebp),%eax
  80021d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800220:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800223:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800226:	b9 00 00 00 00       	mov    $0x0,%ecx
  80022b:	39 d1                	cmp    %edx,%ecx
  80022d:	72 15                	jb     800244 <printnum+0x44>
  80022f:	77 07                	ja     800238 <printnum+0x38>
  800231:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800234:	39 d0                	cmp    %edx,%eax
  800236:	76 0c                	jbe    800244 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800238:	83 eb 01             	sub    $0x1,%ebx
  80023b:	85 db                	test   %ebx,%ebx
  80023d:	8d 76 00             	lea    0x0(%esi),%esi
  800240:	7f 61                	jg     8002a3 <printnum+0xa3>
  800242:	eb 70                	jmp    8002b4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800244:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800248:	83 eb 01             	sub    $0x1,%ebx
  80024b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80024f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800253:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800257:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80025b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80025e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800261:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800264:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800268:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80026f:	00 
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	89 04 24             	mov    %eax,(%esp)
  800276:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800279:	89 54 24 04          	mov    %edx,0x4(%esp)
  80027d:	e8 6e 23 00 00       	call   8025f0 <__udivdi3>
  800282:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800285:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800288:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80028c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800290:	89 04 24             	mov    %eax,(%esp)
  800293:	89 54 24 04          	mov    %edx,0x4(%esp)
  800297:	89 f2                	mov    %esi,%edx
  800299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029c:	e8 5f ff ff ff       	call   800200 <printnum>
  8002a1:	eb 11                	jmp    8002b4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002a7:	89 3c 24             	mov    %edi,(%esp)
  8002aa:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002ad:	83 eb 01             	sub    $0x1,%ebx
  8002b0:	85 db                	test   %ebx,%ebx
  8002b2:	7f ef                	jg     8002a3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002ca:	00 
  8002cb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002ce:	89 14 24             	mov    %edx,(%esp)
  8002d1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002d4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002d8:	e8 43 24 00 00       	call   802720 <__umoddi3>
  8002dd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002e1:	0f be 80 f1 28 80 00 	movsbl 0x8028f1(%eax),%eax
  8002e8:	89 04 24             	mov    %eax,(%esp)
  8002eb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002ee:	83 c4 4c             	add    $0x4c,%esp
  8002f1:	5b                   	pop    %ebx
  8002f2:	5e                   	pop    %esi
  8002f3:	5f                   	pop    %edi
  8002f4:	5d                   	pop    %ebp
  8002f5:	c3                   	ret    

008002f6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002f9:	83 fa 01             	cmp    $0x1,%edx
  8002fc:	7e 0e                	jle    80030c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002fe:	8b 10                	mov    (%eax),%edx
  800300:	8d 4a 08             	lea    0x8(%edx),%ecx
  800303:	89 08                	mov    %ecx,(%eax)
  800305:	8b 02                	mov    (%edx),%eax
  800307:	8b 52 04             	mov    0x4(%edx),%edx
  80030a:	eb 22                	jmp    80032e <getuint+0x38>
	else if (lflag)
  80030c:	85 d2                	test   %edx,%edx
  80030e:	74 10                	je     800320 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800310:	8b 10                	mov    (%eax),%edx
  800312:	8d 4a 04             	lea    0x4(%edx),%ecx
  800315:	89 08                	mov    %ecx,(%eax)
  800317:	8b 02                	mov    (%edx),%eax
  800319:	ba 00 00 00 00       	mov    $0x0,%edx
  80031e:	eb 0e                	jmp    80032e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800320:	8b 10                	mov    (%eax),%edx
  800322:	8d 4a 04             	lea    0x4(%edx),%ecx
  800325:	89 08                	mov    %ecx,(%eax)
  800327:	8b 02                	mov    (%edx),%eax
  800329:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    

00800330 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800336:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033a:	8b 10                	mov    (%eax),%edx
  80033c:	3b 50 04             	cmp    0x4(%eax),%edx
  80033f:	73 0a                	jae    80034b <sprintputch+0x1b>
		*b->buf++ = ch;
  800341:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800344:	88 0a                	mov    %cl,(%edx)
  800346:	83 c2 01             	add    $0x1,%edx
  800349:	89 10                	mov    %edx,(%eax)
}
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	57                   	push   %edi
  800351:	56                   	push   %esi
  800352:	53                   	push   %ebx
  800353:	83 ec 5c             	sub    $0x5c,%esp
  800356:	8b 7d 08             	mov    0x8(%ebp),%edi
  800359:	8b 75 0c             	mov    0xc(%ebp),%esi
  80035c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80035f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800366:	eb 11                	jmp    800379 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800368:	85 c0                	test   %eax,%eax
  80036a:	0f 84 ec 03 00 00    	je     80075c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800370:	89 74 24 04          	mov    %esi,0x4(%esp)
  800374:	89 04 24             	mov    %eax,(%esp)
  800377:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800379:	0f b6 03             	movzbl (%ebx),%eax
  80037c:	83 c3 01             	add    $0x1,%ebx
  80037f:	83 f8 25             	cmp    $0x25,%eax
  800382:	75 e4                	jne    800368 <vprintfmt+0x1b>
  800384:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800388:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80038f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800396:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80039d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003a2:	eb 06                	jmp    8003aa <vprintfmt+0x5d>
  8003a4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003a8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	0f b6 13             	movzbl (%ebx),%edx
  8003ad:	0f b6 c2             	movzbl %dl,%eax
  8003b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b3:	8d 43 01             	lea    0x1(%ebx),%eax
  8003b6:	83 ea 23             	sub    $0x23,%edx
  8003b9:	80 fa 55             	cmp    $0x55,%dl
  8003bc:	0f 87 7d 03 00 00    	ja     80073f <vprintfmt+0x3f2>
  8003c2:	0f b6 d2             	movzbl %dl,%edx
  8003c5:	ff 24 95 40 2a 80 00 	jmp    *0x802a40(,%edx,4)
  8003cc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003d0:	eb d6                	jmp    8003a8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d5:	83 ea 30             	sub    $0x30,%edx
  8003d8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8003db:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8003de:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8003e1:	83 fb 09             	cmp    $0x9,%ebx
  8003e4:	77 4c                	ja     800432 <vprintfmt+0xe5>
  8003e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003e9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003ec:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8003ef:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003f2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8003f6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8003f9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8003fc:	83 fb 09             	cmp    $0x9,%ebx
  8003ff:	76 eb                	jbe    8003ec <vprintfmt+0x9f>
  800401:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800404:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800407:	eb 29                	jmp    800432 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800409:	8b 55 14             	mov    0x14(%ebp),%edx
  80040c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80040f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800412:	8b 12                	mov    (%edx),%edx
  800414:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800417:	eb 19                	jmp    800432 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041c:	c1 fa 1f             	sar    $0x1f,%edx
  80041f:	f7 d2                	not    %edx
  800421:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800424:	eb 82                	jmp    8003a8 <vprintfmt+0x5b>
  800426:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80042d:	e9 76 ff ff ff       	jmp    8003a8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800432:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800436:	0f 89 6c ff ff ff    	jns    8003a8 <vprintfmt+0x5b>
  80043c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80043f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800442:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800445:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800448:	e9 5b ff ff ff       	jmp    8003a8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80044d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800450:	e9 53 ff ff ff       	jmp    8003a8 <vprintfmt+0x5b>
  800455:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8d 50 04             	lea    0x4(%eax),%edx
  80045e:	89 55 14             	mov    %edx,0x14(%ebp)
  800461:	89 74 24 04          	mov    %esi,0x4(%esp)
  800465:	8b 00                	mov    (%eax),%eax
  800467:	89 04 24             	mov    %eax,(%esp)
  80046a:	ff d7                	call   *%edi
  80046c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80046f:	e9 05 ff ff ff       	jmp    800379 <vprintfmt+0x2c>
  800474:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800477:	8b 45 14             	mov    0x14(%ebp),%eax
  80047a:	8d 50 04             	lea    0x4(%eax),%edx
  80047d:	89 55 14             	mov    %edx,0x14(%ebp)
  800480:	8b 00                	mov    (%eax),%eax
  800482:	89 c2                	mov    %eax,%edx
  800484:	c1 fa 1f             	sar    $0x1f,%edx
  800487:	31 d0                	xor    %edx,%eax
  800489:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80048b:	83 f8 0f             	cmp    $0xf,%eax
  80048e:	7f 0b                	jg     80049b <vprintfmt+0x14e>
  800490:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  800497:	85 d2                	test   %edx,%edx
  800499:	75 20                	jne    8004bb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80049b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80049f:	c7 44 24 08 02 29 80 	movl   $0x802902,0x8(%esp)
  8004a6:	00 
  8004a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ab:	89 3c 24             	mov    %edi,(%esp)
  8004ae:	e8 31 03 00 00       	call   8007e4 <printfmt>
  8004b3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004b6:	e9 be fe ff ff       	jmp    800379 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004bf:	c7 44 24 08 e6 2c 80 	movl   $0x802ce6,0x8(%esp)
  8004c6:	00 
  8004c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004cb:	89 3c 24             	mov    %edi,(%esp)
  8004ce:	e8 11 03 00 00       	call   8007e4 <printfmt>
  8004d3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004d6:	e9 9e fe ff ff       	jmp    800379 <vprintfmt+0x2c>
  8004db:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004de:	89 c3                	mov    %eax,%ebx
  8004e0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ec:	8d 50 04             	lea    0x4(%eax),%edx
  8004ef:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f7:	85 c0                	test   %eax,%eax
  8004f9:	75 07                	jne    800502 <vprintfmt+0x1b5>
  8004fb:	c7 45 e0 0b 29 80 00 	movl   $0x80290b,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800502:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800506:	7e 06                	jle    80050e <vprintfmt+0x1c1>
  800508:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80050c:	75 13                	jne    800521 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800511:	0f be 02             	movsbl (%edx),%eax
  800514:	85 c0                	test   %eax,%eax
  800516:	0f 85 99 00 00 00    	jne    8005b5 <vprintfmt+0x268>
  80051c:	e9 86 00 00 00       	jmp    8005a7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800521:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800525:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800528:	89 0c 24             	mov    %ecx,(%esp)
  80052b:	e8 fb 02 00 00       	call   80082b <strnlen>
  800530:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800533:	29 c2                	sub    %eax,%edx
  800535:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800538:	85 d2                	test   %edx,%edx
  80053a:	7e d2                	jle    80050e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80053c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800540:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800543:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800546:	89 d3                	mov    %edx,%ebx
  800548:	89 74 24 04          	mov    %esi,0x4(%esp)
  80054c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80054f:	89 04 24             	mov    %eax,(%esp)
  800552:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800554:	83 eb 01             	sub    $0x1,%ebx
  800557:	85 db                	test   %ebx,%ebx
  800559:	7f ed                	jg     800548 <vprintfmt+0x1fb>
  80055b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80055e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800565:	eb a7                	jmp    80050e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800567:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80056b:	74 18                	je     800585 <vprintfmt+0x238>
  80056d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800570:	83 fa 5e             	cmp    $0x5e,%edx
  800573:	76 10                	jbe    800585 <vprintfmt+0x238>
					putch('?', putdat);
  800575:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800579:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800580:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800583:	eb 0a                	jmp    80058f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800585:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800589:	89 04 24             	mov    %eax,(%esp)
  80058c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800593:	0f be 03             	movsbl (%ebx),%eax
  800596:	85 c0                	test   %eax,%eax
  800598:	74 05                	je     80059f <vprintfmt+0x252>
  80059a:	83 c3 01             	add    $0x1,%ebx
  80059d:	eb 29                	jmp    8005c8 <vprintfmt+0x27b>
  80059f:	89 fe                	mov    %edi,%esi
  8005a1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005a4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ab:	7f 2e                	jg     8005db <vprintfmt+0x28e>
  8005ad:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8005b0:	e9 c4 fd ff ff       	jmp    800379 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b8:	83 c2 01             	add    $0x1,%edx
  8005bb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8005be:	89 f7                	mov    %esi,%edi
  8005c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8005c6:	89 d3                	mov    %edx,%ebx
  8005c8:	85 f6                	test   %esi,%esi
  8005ca:	78 9b                	js     800567 <vprintfmt+0x21a>
  8005cc:	83 ee 01             	sub    $0x1,%esi
  8005cf:	79 96                	jns    800567 <vprintfmt+0x21a>
  8005d1:	89 fe                	mov    %edi,%esi
  8005d3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005d6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005d9:	eb cc                	jmp    8005a7 <vprintfmt+0x25a>
  8005db:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8005de:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005ec:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005ee:	83 eb 01             	sub    $0x1,%ebx
  8005f1:	85 db                	test   %ebx,%ebx
  8005f3:	7f ec                	jg     8005e1 <vprintfmt+0x294>
  8005f5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005f8:	e9 7c fd ff ff       	jmp    800379 <vprintfmt+0x2c>
  8005fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800600:	83 f9 01             	cmp    $0x1,%ecx
  800603:	7e 16                	jle    80061b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8d 50 08             	lea    0x8(%eax),%edx
  80060b:	89 55 14             	mov    %edx,0x14(%ebp)
  80060e:	8b 10                	mov    (%eax),%edx
  800610:	8b 48 04             	mov    0x4(%eax),%ecx
  800613:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800616:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800619:	eb 32                	jmp    80064d <vprintfmt+0x300>
	else if (lflag)
  80061b:	85 c9                	test   %ecx,%ecx
  80061d:	74 18                	je     800637 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 50 04             	lea    0x4(%eax),%edx
  800625:	89 55 14             	mov    %edx,0x14(%ebp)
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062d:	89 c1                	mov    %eax,%ecx
  80062f:	c1 f9 1f             	sar    $0x1f,%ecx
  800632:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800635:	eb 16                	jmp    80064d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8d 50 04             	lea    0x4(%eax),%edx
  80063d:	89 55 14             	mov    %edx,0x14(%ebp)
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 c2                	mov    %eax,%edx
  800647:	c1 fa 1f             	sar    $0x1f,%edx
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80064d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800650:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800653:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800658:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80065c:	0f 89 9b 00 00 00    	jns    8006fd <vprintfmt+0x3b0>
				putch('-', putdat);
  800662:	89 74 24 04          	mov    %esi,0x4(%esp)
  800666:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80066d:	ff d7                	call   *%edi
				num = -(long long) num;
  80066f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800672:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800675:	f7 d9                	neg    %ecx
  800677:	83 d3 00             	adc    $0x0,%ebx
  80067a:	f7 db                	neg    %ebx
  80067c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800681:	eb 7a                	jmp    8006fd <vprintfmt+0x3b0>
  800683:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800686:	89 ca                	mov    %ecx,%edx
  800688:	8d 45 14             	lea    0x14(%ebp),%eax
  80068b:	e8 66 fc ff ff       	call   8002f6 <getuint>
  800690:	89 c1                	mov    %eax,%ecx
  800692:	89 d3                	mov    %edx,%ebx
  800694:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800699:	eb 62                	jmp    8006fd <vprintfmt+0x3b0>
  80069b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80069e:	89 ca                	mov    %ecx,%edx
  8006a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a3:	e8 4e fc ff ff       	call   8002f6 <getuint>
  8006a8:	89 c1                	mov    %eax,%ecx
  8006aa:	89 d3                	mov    %edx,%ebx
  8006ac:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8006b1:	eb 4a                	jmp    8006fd <vprintfmt+0x3b0>
  8006b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8006b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ba:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006c1:	ff d7                	call   *%edi
			putch('x', putdat);
  8006c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006ce:	ff d7                	call   *%edi
			num = (unsigned long long)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d9:	8b 08                	mov    (%eax),%ecx
  8006db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006e0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006e5:	eb 16                	jmp    8006fd <vprintfmt+0x3b0>
  8006e7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006ea:	89 ca                	mov    %ecx,%edx
  8006ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ef:	e8 02 fc ff ff       	call   8002f6 <getuint>
  8006f4:	89 c1                	mov    %eax,%ecx
  8006f6:	89 d3                	mov    %edx,%ebx
  8006f8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006fd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800701:	89 54 24 10          	mov    %edx,0x10(%esp)
  800705:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800708:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80070c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800710:	89 0c 24             	mov    %ecx,(%esp)
  800713:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800717:	89 f2                	mov    %esi,%edx
  800719:	89 f8                	mov    %edi,%eax
  80071b:	e8 e0 fa ff ff       	call   800200 <printnum>
  800720:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800723:	e9 51 fc ff ff       	jmp    800379 <vprintfmt+0x2c>
  800728:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80072b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800732:	89 14 24             	mov    %edx,(%esp)
  800735:	ff d7                	call   *%edi
  800737:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80073a:	e9 3a fc ff ff       	jmp    800379 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80073f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800743:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80074a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80074c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80074f:	80 38 25             	cmpb   $0x25,(%eax)
  800752:	0f 84 21 fc ff ff    	je     800379 <vprintfmt+0x2c>
  800758:	89 c3                	mov    %eax,%ebx
  80075a:	eb f0                	jmp    80074c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80075c:	83 c4 5c             	add    $0x5c,%esp
  80075f:	5b                   	pop    %ebx
  800760:	5e                   	pop    %esi
  800761:	5f                   	pop    %edi
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 28             	sub    $0x28,%esp
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800770:	85 c0                	test   %eax,%eax
  800772:	74 04                	je     800778 <vsnprintf+0x14>
  800774:	85 d2                	test   %edx,%edx
  800776:	7f 07                	jg     80077f <vsnprintf+0x1b>
  800778:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80077d:	eb 3b                	jmp    8007ba <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80077f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800782:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800789:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a5:	c7 04 24 30 03 80 00 	movl   $0x800330,(%esp)
  8007ac:	e8 9c fb ff ff       	call   80034d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8007c2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8007c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	89 04 24             	mov    %eax,(%esp)
  8007dd:	e8 82 ff ff ff       	call   800764 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    

008007e4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8007ea:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8007ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 04 24             	mov    %eax,(%esp)
  800805:	e8 43 fb ff ff       	call   80034d <vprintfmt>
	va_end(ap);
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    
  80080c:	00 00                	add    %al,(%eax)
	...

00800810 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800816:	b8 00 00 00 00       	mov    $0x0,%eax
  80081b:	80 3a 00             	cmpb   $0x0,(%edx)
  80081e:	74 09                	je     800829 <strlen+0x19>
		n++;
  800820:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800823:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800827:	75 f7                	jne    800820 <strlen+0x10>
		n++;
	return n;
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	53                   	push   %ebx
  80082f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800832:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800835:	85 c9                	test   %ecx,%ecx
  800837:	74 19                	je     800852 <strnlen+0x27>
  800839:	80 3b 00             	cmpb   $0x0,(%ebx)
  80083c:	74 14                	je     800852 <strnlen+0x27>
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800843:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800846:	39 c8                	cmp    %ecx,%eax
  800848:	74 0d                	je     800857 <strnlen+0x2c>
  80084a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80084e:	75 f3                	jne    800843 <strnlen+0x18>
  800850:	eb 05                	jmp    800857 <strnlen+0x2c>
  800852:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800857:	5b                   	pop    %ebx
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	53                   	push   %ebx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800864:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800869:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80086d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800870:	83 c2 01             	add    $0x1,%edx
  800873:	84 c9                	test   %cl,%cl
  800875:	75 f2                	jne    800869 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800877:	5b                   	pop    %ebx
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	56                   	push   %esi
  80087e:	53                   	push   %ebx
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
  800885:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800888:	85 f6                	test   %esi,%esi
  80088a:	74 18                	je     8008a4 <strncpy+0x2a>
  80088c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800891:	0f b6 1a             	movzbl (%edx),%ebx
  800894:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800897:	80 3a 01             	cmpb   $0x1,(%edx)
  80089a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80089d:	83 c1 01             	add    $0x1,%ecx
  8008a0:	39 ce                	cmp    %ecx,%esi
  8008a2:	77 ed                	ja     800891 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008a4:	5b                   	pop    %ebx
  8008a5:	5e                   	pop    %esi
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	56                   	push   %esi
  8008ac:	53                   	push   %ebx
  8008ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b6:	89 f0                	mov    %esi,%eax
  8008b8:	85 c9                	test   %ecx,%ecx
  8008ba:	74 27                	je     8008e3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8008bc:	83 e9 01             	sub    $0x1,%ecx
  8008bf:	74 1d                	je     8008de <strlcpy+0x36>
  8008c1:	0f b6 1a             	movzbl (%edx),%ebx
  8008c4:	84 db                	test   %bl,%bl
  8008c6:	74 16                	je     8008de <strlcpy+0x36>
			*dst++ = *src++;
  8008c8:	88 18                	mov    %bl,(%eax)
  8008ca:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008cd:	83 e9 01             	sub    $0x1,%ecx
  8008d0:	74 0e                	je     8008e0 <strlcpy+0x38>
			*dst++ = *src++;
  8008d2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008d5:	0f b6 1a             	movzbl (%edx),%ebx
  8008d8:	84 db                	test   %bl,%bl
  8008da:	75 ec                	jne    8008c8 <strlcpy+0x20>
  8008dc:	eb 02                	jmp    8008e0 <strlcpy+0x38>
  8008de:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008e0:	c6 00 00             	movb   $0x0,(%eax)
  8008e3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8008e5:	5b                   	pop    %ebx
  8008e6:	5e                   	pop    %esi
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f2:	0f b6 01             	movzbl (%ecx),%eax
  8008f5:	84 c0                	test   %al,%al
  8008f7:	74 15                	je     80090e <strcmp+0x25>
  8008f9:	3a 02                	cmp    (%edx),%al
  8008fb:	75 11                	jne    80090e <strcmp+0x25>
		p++, q++;
  8008fd:	83 c1 01             	add    $0x1,%ecx
  800900:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800903:	0f b6 01             	movzbl (%ecx),%eax
  800906:	84 c0                	test   %al,%al
  800908:	74 04                	je     80090e <strcmp+0x25>
  80090a:	3a 02                	cmp    (%edx),%al
  80090c:	74 ef                	je     8008fd <strcmp+0x14>
  80090e:	0f b6 c0             	movzbl %al,%eax
  800911:	0f b6 12             	movzbl (%edx),%edx
  800914:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	53                   	push   %ebx
  80091c:	8b 55 08             	mov    0x8(%ebp),%edx
  80091f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800922:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800925:	85 c0                	test   %eax,%eax
  800927:	74 23                	je     80094c <strncmp+0x34>
  800929:	0f b6 1a             	movzbl (%edx),%ebx
  80092c:	84 db                	test   %bl,%bl
  80092e:	74 24                	je     800954 <strncmp+0x3c>
  800930:	3a 19                	cmp    (%ecx),%bl
  800932:	75 20                	jne    800954 <strncmp+0x3c>
  800934:	83 e8 01             	sub    $0x1,%eax
  800937:	74 13                	je     80094c <strncmp+0x34>
		n--, p++, q++;
  800939:	83 c2 01             	add    $0x1,%edx
  80093c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80093f:	0f b6 1a             	movzbl (%edx),%ebx
  800942:	84 db                	test   %bl,%bl
  800944:	74 0e                	je     800954 <strncmp+0x3c>
  800946:	3a 19                	cmp    (%ecx),%bl
  800948:	74 ea                	je     800934 <strncmp+0x1c>
  80094a:	eb 08                	jmp    800954 <strncmp+0x3c>
  80094c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800951:	5b                   	pop    %ebx
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800954:	0f b6 02             	movzbl (%edx),%eax
  800957:	0f b6 11             	movzbl (%ecx),%edx
  80095a:	29 d0                	sub    %edx,%eax
  80095c:	eb f3                	jmp    800951 <strncmp+0x39>

0080095e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800968:	0f b6 10             	movzbl (%eax),%edx
  80096b:	84 d2                	test   %dl,%dl
  80096d:	74 15                	je     800984 <strchr+0x26>
		if (*s == c)
  80096f:	38 ca                	cmp    %cl,%dl
  800971:	75 07                	jne    80097a <strchr+0x1c>
  800973:	eb 14                	jmp    800989 <strchr+0x2b>
  800975:	38 ca                	cmp    %cl,%dl
  800977:	90                   	nop
  800978:	74 0f                	je     800989 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	0f b6 10             	movzbl (%eax),%edx
  800980:	84 d2                	test   %dl,%dl
  800982:	75 f1                	jne    800975 <strchr+0x17>
  800984:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800995:	0f b6 10             	movzbl (%eax),%edx
  800998:	84 d2                	test   %dl,%dl
  80099a:	74 18                	je     8009b4 <strfind+0x29>
		if (*s == c)
  80099c:	38 ca                	cmp    %cl,%dl
  80099e:	75 0a                	jne    8009aa <strfind+0x1f>
  8009a0:	eb 12                	jmp    8009b4 <strfind+0x29>
  8009a2:	38 ca                	cmp    %cl,%dl
  8009a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8009a8:	74 0a                	je     8009b4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	0f b6 10             	movzbl (%eax),%edx
  8009b0:	84 d2                	test   %dl,%dl
  8009b2:	75 ee                	jne    8009a2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	83 ec 0c             	sub    $0xc,%esp
  8009bc:	89 1c 24             	mov    %ebx,(%esp)
  8009bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d0:	85 c9                	test   %ecx,%ecx
  8009d2:	74 30                	je     800a04 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009da:	75 25                	jne    800a01 <memset+0x4b>
  8009dc:	f6 c1 03             	test   $0x3,%cl
  8009df:	75 20                	jne    800a01 <memset+0x4b>
		c &= 0xFF;
  8009e1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e4:	89 d3                	mov    %edx,%ebx
  8009e6:	c1 e3 08             	shl    $0x8,%ebx
  8009e9:	89 d6                	mov    %edx,%esi
  8009eb:	c1 e6 18             	shl    $0x18,%esi
  8009ee:	89 d0                	mov    %edx,%eax
  8009f0:	c1 e0 10             	shl    $0x10,%eax
  8009f3:	09 f0                	or     %esi,%eax
  8009f5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8009f7:	09 d8                	or     %ebx,%eax
  8009f9:	c1 e9 02             	shr    $0x2,%ecx
  8009fc:	fc                   	cld    
  8009fd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009ff:	eb 03                	jmp    800a04 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a01:	fc                   	cld    
  800a02:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a04:	89 f8                	mov    %edi,%eax
  800a06:	8b 1c 24             	mov    (%esp),%ebx
  800a09:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a0d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a11:	89 ec                	mov    %ebp,%esp
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	83 ec 08             	sub    $0x8,%esp
  800a1b:	89 34 24             	mov    %esi,(%esp)
  800a1e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a28:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a2b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a2d:	39 c6                	cmp    %eax,%esi
  800a2f:	73 35                	jae    800a66 <memmove+0x51>
  800a31:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a34:	39 d0                	cmp    %edx,%eax
  800a36:	73 2e                	jae    800a66 <memmove+0x51>
		s += n;
		d += n;
  800a38:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3a:	f6 c2 03             	test   $0x3,%dl
  800a3d:	75 1b                	jne    800a5a <memmove+0x45>
  800a3f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a45:	75 13                	jne    800a5a <memmove+0x45>
  800a47:	f6 c1 03             	test   $0x3,%cl
  800a4a:	75 0e                	jne    800a5a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a4c:	83 ef 04             	sub    $0x4,%edi
  800a4f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a52:	c1 e9 02             	shr    $0x2,%ecx
  800a55:	fd                   	std    
  800a56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a58:	eb 09                	jmp    800a63 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a5a:	83 ef 01             	sub    $0x1,%edi
  800a5d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a60:	fd                   	std    
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a63:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a64:	eb 20                	jmp    800a86 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a66:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6c:	75 15                	jne    800a83 <memmove+0x6e>
  800a6e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a74:	75 0d                	jne    800a83 <memmove+0x6e>
  800a76:	f6 c1 03             	test   $0x3,%cl
  800a79:	75 08                	jne    800a83 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
  800a7e:	fc                   	cld    
  800a7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a81:	eb 03                	jmp    800a86 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a83:	fc                   	cld    
  800a84:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a86:	8b 34 24             	mov    (%esp),%esi
  800a89:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a8d:	89 ec                	mov    %ebp,%esp
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a97:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	89 04 24             	mov    %eax,(%esp)
  800aab:	e8 65 ff ff ff       	call   800a15 <memmove>
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	57                   	push   %edi
  800ab6:	56                   	push   %esi
  800ab7:	53                   	push   %ebx
  800ab8:	8b 75 08             	mov    0x8(%ebp),%esi
  800abb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800abe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac1:	85 c9                	test   %ecx,%ecx
  800ac3:	74 36                	je     800afb <memcmp+0x49>
		if (*s1 != *s2)
  800ac5:	0f b6 06             	movzbl (%esi),%eax
  800ac8:	0f b6 1f             	movzbl (%edi),%ebx
  800acb:	38 d8                	cmp    %bl,%al
  800acd:	74 20                	je     800aef <memcmp+0x3d>
  800acf:	eb 14                	jmp    800ae5 <memcmp+0x33>
  800ad1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800ad6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800adb:	83 c2 01             	add    $0x1,%edx
  800ade:	83 e9 01             	sub    $0x1,%ecx
  800ae1:	38 d8                	cmp    %bl,%al
  800ae3:	74 12                	je     800af7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800ae5:	0f b6 c0             	movzbl %al,%eax
  800ae8:	0f b6 db             	movzbl %bl,%ebx
  800aeb:	29 d8                	sub    %ebx,%eax
  800aed:	eb 11                	jmp    800b00 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aef:	83 e9 01             	sub    $0x1,%ecx
  800af2:	ba 00 00 00 00       	mov    $0x0,%edx
  800af7:	85 c9                	test   %ecx,%ecx
  800af9:	75 d6                	jne    800ad1 <memcmp+0x1f>
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b0b:	89 c2                	mov    %eax,%edx
  800b0d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b10:	39 d0                	cmp    %edx,%eax
  800b12:	73 15                	jae    800b29 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b14:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b18:	38 08                	cmp    %cl,(%eax)
  800b1a:	75 06                	jne    800b22 <memfind+0x1d>
  800b1c:	eb 0b                	jmp    800b29 <memfind+0x24>
  800b1e:	38 08                	cmp    %cl,(%eax)
  800b20:	74 07                	je     800b29 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b22:	83 c0 01             	add    $0x1,%eax
  800b25:	39 c2                	cmp    %eax,%edx
  800b27:	77 f5                	ja     800b1e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	57                   	push   %edi
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	83 ec 04             	sub    $0x4,%esp
  800b34:	8b 55 08             	mov    0x8(%ebp),%edx
  800b37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3a:	0f b6 02             	movzbl (%edx),%eax
  800b3d:	3c 20                	cmp    $0x20,%al
  800b3f:	74 04                	je     800b45 <strtol+0x1a>
  800b41:	3c 09                	cmp    $0x9,%al
  800b43:	75 0e                	jne    800b53 <strtol+0x28>
		s++;
  800b45:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b48:	0f b6 02             	movzbl (%edx),%eax
  800b4b:	3c 20                	cmp    $0x20,%al
  800b4d:	74 f6                	je     800b45 <strtol+0x1a>
  800b4f:	3c 09                	cmp    $0x9,%al
  800b51:	74 f2                	je     800b45 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b53:	3c 2b                	cmp    $0x2b,%al
  800b55:	75 0c                	jne    800b63 <strtol+0x38>
		s++;
  800b57:	83 c2 01             	add    $0x1,%edx
  800b5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b61:	eb 15                	jmp    800b78 <strtol+0x4d>
	else if (*s == '-')
  800b63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b6a:	3c 2d                	cmp    $0x2d,%al
  800b6c:	75 0a                	jne    800b78 <strtol+0x4d>
		s++, neg = 1;
  800b6e:	83 c2 01             	add    $0x1,%edx
  800b71:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b78:	85 db                	test   %ebx,%ebx
  800b7a:	0f 94 c0             	sete   %al
  800b7d:	74 05                	je     800b84 <strtol+0x59>
  800b7f:	83 fb 10             	cmp    $0x10,%ebx
  800b82:	75 18                	jne    800b9c <strtol+0x71>
  800b84:	80 3a 30             	cmpb   $0x30,(%edx)
  800b87:	75 13                	jne    800b9c <strtol+0x71>
  800b89:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b8d:	8d 76 00             	lea    0x0(%esi),%esi
  800b90:	75 0a                	jne    800b9c <strtol+0x71>
		s += 2, base = 16;
  800b92:	83 c2 02             	add    $0x2,%edx
  800b95:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9a:	eb 15                	jmp    800bb1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b9c:	84 c0                	test   %al,%al
  800b9e:	66 90                	xchg   %ax,%ax
  800ba0:	74 0f                	je     800bb1 <strtol+0x86>
  800ba2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ba7:	80 3a 30             	cmpb   $0x30,(%edx)
  800baa:	75 05                	jne    800bb1 <strtol+0x86>
		s++, base = 8;
  800bac:	83 c2 01             	add    $0x1,%edx
  800baf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bb8:	0f b6 0a             	movzbl (%edx),%ecx
  800bbb:	89 cf                	mov    %ecx,%edi
  800bbd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800bc0:	80 fb 09             	cmp    $0x9,%bl
  800bc3:	77 08                	ja     800bcd <strtol+0xa2>
			dig = *s - '0';
  800bc5:	0f be c9             	movsbl %cl,%ecx
  800bc8:	83 e9 30             	sub    $0x30,%ecx
  800bcb:	eb 1e                	jmp    800beb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800bcd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800bd0:	80 fb 19             	cmp    $0x19,%bl
  800bd3:	77 08                	ja     800bdd <strtol+0xb2>
			dig = *s - 'a' + 10;
  800bd5:	0f be c9             	movsbl %cl,%ecx
  800bd8:	83 e9 57             	sub    $0x57,%ecx
  800bdb:	eb 0e                	jmp    800beb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800bdd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800be0:	80 fb 19             	cmp    $0x19,%bl
  800be3:	77 15                	ja     800bfa <strtol+0xcf>
			dig = *s - 'A' + 10;
  800be5:	0f be c9             	movsbl %cl,%ecx
  800be8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800beb:	39 f1                	cmp    %esi,%ecx
  800bed:	7d 0b                	jge    800bfa <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800bef:	83 c2 01             	add    $0x1,%edx
  800bf2:	0f af c6             	imul   %esi,%eax
  800bf5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800bf8:	eb be                	jmp    800bb8 <strtol+0x8d>
  800bfa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c00:	74 05                	je     800c07 <strtol+0xdc>
		*endptr = (char *) s;
  800c02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c05:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c0b:	74 04                	je     800c11 <strtol+0xe6>
  800c0d:	89 c8                	mov    %ecx,%eax
  800c0f:	f7 d8                	neg    %eax
}
  800c11:	83 c4 04             	add    $0x4,%esp
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    
  800c19:	00 00                	add    %al,(%eax)
	...

00800c1c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 0c             	sub    $0xc,%esp
  800c22:	89 1c 24             	mov    %ebx,(%esp)
  800c25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c29:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c32:	b8 01 00 00 00       	mov    $0x1,%eax
  800c37:	89 d1                	mov    %edx,%ecx
  800c39:	89 d3                	mov    %edx,%ebx
  800c3b:	89 d7                	mov    %edx,%edi
  800c3d:	89 d6                	mov    %edx,%esi
  800c3f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c41:	8b 1c 24             	mov    (%esp),%ebx
  800c44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c4c:	89 ec                	mov    %ebp,%esp
  800c4e:	5d                   	pop    %ebp
  800c4f:	c3                   	ret    

00800c50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	89 1c 24             	mov    %ebx,(%esp)
  800c59:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c5d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c61:	b8 00 00 00 00       	mov    $0x0,%eax
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	89 c3                	mov    %eax,%ebx
  800c6e:	89 c7                	mov    %eax,%edi
  800c70:	89 c6                	mov    %eax,%esi
  800c72:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c74:	8b 1c 24             	mov    (%esp),%ebx
  800c77:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c7b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c7f:	89 ec                	mov    %ebp,%esp
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 38             	sub    $0x38,%esp
  800c89:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c8c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c8f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c92:	be 00 00 00 00       	mov    $0x0,%esi
  800c97:	b8 12 00 00 00       	mov    $0x12,%eax
  800c9c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7e 28                	jle    800cd6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cae:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800cb9:	00 
  800cba:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800cc1:	00 
  800cc2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc9:	00 
  800cca:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800cd1:	e8 96 17 00 00       	call   80246c <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800cd6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800cd9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cdc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cdf:	89 ec                	mov    %ebp,%esp
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	83 ec 0c             	sub    $0xc,%esp
  800ce9:	89 1c 24             	mov    %ebx,(%esp)
  800cec:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cf0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf9:	b8 11 00 00 00       	mov    $0x11,%eax
  800cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d01:	8b 55 08             	mov    0x8(%ebp),%edx
  800d04:	89 df                	mov    %ebx,%edi
  800d06:	89 de                	mov    %ebx,%esi
  800d08:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800d0a:	8b 1c 24             	mov    (%esp),%ebx
  800d0d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d11:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d15:	89 ec                	mov    %ebp,%esp
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	89 1c 24             	mov    %ebx,(%esp)
  800d22:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d26:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2f:	b8 10 00 00 00       	mov    $0x10,%eax
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	89 cb                	mov    %ecx,%ebx
  800d39:	89 cf                	mov    %ecx,%edi
  800d3b:	89 ce                	mov    %ecx,%esi
  800d3d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800d3f:	8b 1c 24             	mov    (%esp),%ebx
  800d42:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d46:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d4a:	89 ec                	mov    %ebp,%esp
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 38             	sub    $0x38,%esp
  800d54:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d57:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d5a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d62:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	89 df                	mov    %ebx,%edi
  800d6f:	89 de                	mov    %ebx,%esi
  800d71:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	7e 28                	jle    800d9f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d77:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d82:	00 
  800d83:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800d8a:	00 
  800d8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d92:	00 
  800d93:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800d9a:	e8 cd 16 00 00       	call   80246c <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800d9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800da2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800da5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800da8:	89 ec                	mov    %ebp,%esp
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	89 1c 24             	mov    %ebx,(%esp)
  800db5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800db9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dc7:	89 d1                	mov    %edx,%ecx
  800dc9:	89 d3                	mov    %edx,%ebx
  800dcb:	89 d7                	mov    %edx,%edi
  800dcd:	89 d6                	mov    %edx,%esi
  800dcf:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800dd1:	8b 1c 24             	mov    (%esp),%ebx
  800dd4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dd8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ddc:	89 ec                	mov    %ebp,%esp
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 38             	sub    $0x38,%esp
  800de6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dec:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800def:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	89 cb                	mov    %ecx,%ebx
  800dfe:	89 cf                	mov    %ecx,%edi
  800e00:	89 ce                	mov    %ecx,%esi
  800e02:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7e 28                	jle    800e30 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e08:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e13:	00 
  800e14:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800e1b:	00 
  800e1c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e23:	00 
  800e24:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800e2b:	e8 3c 16 00 00       	call   80246c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e30:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e33:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e36:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e39:	89 ec                	mov    %ebp,%esp
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    

00800e3d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 0c             	sub    $0xc,%esp
  800e43:	89 1c 24             	mov    %ebx,(%esp)
  800e46:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e4a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4e:	be 00 00 00 00       	mov    $0x0,%esi
  800e53:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e58:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	8b 55 08             	mov    0x8(%ebp),%edx
  800e64:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e66:	8b 1c 24             	mov    (%esp),%ebx
  800e69:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e6d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e71:	89 ec                	mov    %ebp,%esp
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	83 ec 38             	sub    $0x38,%esp
  800e7b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e7e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e81:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e89:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e91:	8b 55 08             	mov    0x8(%ebp),%edx
  800e94:	89 df                	mov    %ebx,%edi
  800e96:	89 de                	mov    %ebx,%esi
  800e98:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e9a:	85 c0                	test   %eax,%eax
  800e9c:	7e 28                	jle    800ec6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ea9:	00 
  800eaa:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800eb1:	00 
  800eb2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb9:	00 
  800eba:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800ec1:	e8 a6 15 00 00       	call   80246c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ec6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ecc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ecf:	89 ec                	mov    %ebp,%esp
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 38             	sub    $0x38,%esp
  800ed9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800edc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800edf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	b8 09 00 00 00       	mov    $0x9,%eax
  800eec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7e 28                	jle    800f24 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f00:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f07:	00 
  800f08:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800f0f:	00 
  800f10:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f17:	00 
  800f18:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800f1f:	e8 48 15 00 00       	call   80246c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f24:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f27:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f2a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f2d:	89 ec                	mov    %ebp,%esp
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    

00800f31 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	83 ec 38             	sub    $0x38,%esp
  800f37:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f3a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f45:	b8 08 00 00 00       	mov    $0x8,%eax
  800f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	7e 28                	jle    800f82 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f65:	00 
  800f66:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800f6d:	00 
  800f6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f75:	00 
  800f76:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800f7d:	e8 ea 14 00 00       	call   80246c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8b:	89 ec                	mov    %ebp,%esp
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	83 ec 38             	sub    $0x38,%esp
  800f95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa3:	b8 06 00 00 00       	mov    $0x6,%eax
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fab:	8b 55 08             	mov    0x8(%ebp),%edx
  800fae:	89 df                	mov    %ebx,%edi
  800fb0:	89 de                	mov    %ebx,%esi
  800fb2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7e 28                	jle    800fe0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbc:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fc3:	00 
  800fc4:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd3:	00 
  800fd4:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800fdb:	e8 8c 14 00 00       	call   80246c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe9:	89 ec                	mov    %ebp,%esp
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 38             	sub    $0x38,%esp
  800ff3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ff6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ff9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffc:	b8 05 00 00 00       	mov    $0x5,%eax
  801001:	8b 75 18             	mov    0x18(%ebp),%esi
  801004:	8b 7d 14             	mov    0x14(%ebp),%edi
  801007:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80100a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100d:	8b 55 08             	mov    0x8(%ebp),%edx
  801010:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801012:	85 c0                	test   %eax,%eax
  801014:	7e 28                	jle    80103e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801016:	89 44 24 10          	mov    %eax,0x10(%esp)
  80101a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801021:	00 
  801022:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  801029:	00 
  80102a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801031:	00 
  801032:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  801039:	e8 2e 14 00 00       	call   80246c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80103e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801041:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801044:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801047:	89 ec                	mov    %ebp,%esp
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 38             	sub    $0x38,%esp
  801051:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801054:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801057:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105a:	be 00 00 00 00       	mov    $0x0,%esi
  80105f:	b8 04 00 00 00       	mov    $0x4,%eax
  801064:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801067:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106a:	8b 55 08             	mov    0x8(%ebp),%edx
  80106d:	89 f7                	mov    %esi,%edi
  80106f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801071:	85 c0                	test   %eax,%eax
  801073:	7e 28                	jle    80109d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801075:	89 44 24 10          	mov    %eax,0x10(%esp)
  801079:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801080:	00 
  801081:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  801088:	00 
  801089:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801090:	00 
  801091:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  801098:	e8 cf 13 00 00       	call   80246c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80109d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010a6:	89 ec                	mov    %ebp,%esp
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    

008010aa <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 0c             	sub    $0xc,%esp
  8010b0:	89 1c 24             	mov    %ebx,(%esp)
  8010b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010b7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	89 d3                	mov    %edx,%ebx
  8010c9:	89 d7                	mov    %edx,%edi
  8010cb:	89 d6                	mov    %edx,%esi
  8010cd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010cf:	8b 1c 24             	mov    (%esp),%ebx
  8010d2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010d6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010da:	89 ec                	mov    %ebp,%esp
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 0c             	sub    $0xc,%esp
  8010e4:	89 1c 24             	mov    %ebx,(%esp)
  8010e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010eb:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f4:	b8 02 00 00 00       	mov    $0x2,%eax
  8010f9:	89 d1                	mov    %edx,%ecx
  8010fb:	89 d3                	mov    %edx,%ebx
  8010fd:	89 d7                	mov    %edx,%edi
  8010ff:	89 d6                	mov    %edx,%esi
  801101:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801103:	8b 1c 24             	mov    (%esp),%ebx
  801106:	8b 74 24 04          	mov    0x4(%esp),%esi
  80110a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80110e:	89 ec                	mov    %ebp,%esp
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    

00801112 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 38             	sub    $0x38,%esp
  801118:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80111b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80111e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801121:	b9 00 00 00 00       	mov    $0x0,%ecx
  801126:	b8 03 00 00 00       	mov    $0x3,%eax
  80112b:	8b 55 08             	mov    0x8(%ebp),%edx
  80112e:	89 cb                	mov    %ecx,%ebx
  801130:	89 cf                	mov    %ecx,%edi
  801132:	89 ce                	mov    %ecx,%esi
  801134:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801136:	85 c0                	test   %eax,%eax
  801138:	7e 28                	jle    801162 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801145:	00 
  801146:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  80114d:	00 
  80114e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801155:	00 
  801156:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  80115d:	e8 0a 13 00 00       	call   80246c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801162:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801165:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801168:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80116b:	89 ec                	mov    %ebp,%esp
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    
	...

00801170 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	05 00 00 00 30       	add    $0x30000000,%eax
  80117b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	89 04 24             	mov    %eax,(%esp)
  80118c:	e8 df ff ff ff       	call   801170 <fd2num>
  801191:	05 20 00 0d 00       	add    $0xd0020,%eax
  801196:	c1 e0 0c             	shl    $0xc,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	57                   	push   %edi
  80119f:	56                   	push   %esi
  8011a0:	53                   	push   %ebx
  8011a1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8011a4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8011a9:	a8 01                	test   $0x1,%al
  8011ab:	74 36                	je     8011e3 <fd_alloc+0x48>
  8011ad:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8011b2:	a8 01                	test   $0x1,%al
  8011b4:	74 2d                	je     8011e3 <fd_alloc+0x48>
  8011b6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8011bb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8011c0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8011c5:	89 c3                	mov    %eax,%ebx
  8011c7:	89 c2                	mov    %eax,%edx
  8011c9:	c1 ea 16             	shr    $0x16,%edx
  8011cc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8011cf:	f6 c2 01             	test   $0x1,%dl
  8011d2:	74 14                	je     8011e8 <fd_alloc+0x4d>
  8011d4:	89 c2                	mov    %eax,%edx
  8011d6:	c1 ea 0c             	shr    $0xc,%edx
  8011d9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8011dc:	f6 c2 01             	test   $0x1,%dl
  8011df:	75 10                	jne    8011f1 <fd_alloc+0x56>
  8011e1:	eb 05                	jmp    8011e8 <fd_alloc+0x4d>
  8011e3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8011e8:	89 1f                	mov    %ebx,(%edi)
  8011ea:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8011ef:	eb 17                	jmp    801208 <fd_alloc+0x6d>
  8011f1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011f6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011fb:	75 c8                	jne    8011c5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011fd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801203:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801208:	5b                   	pop    %ebx
  801209:	5e                   	pop    %esi
  80120a:	5f                   	pop    %edi
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	83 f8 1f             	cmp    $0x1f,%eax
  801216:	77 36                	ja     80124e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801218:	05 00 00 0d 00       	add    $0xd0000,%eax
  80121d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801220:	89 c2                	mov    %eax,%edx
  801222:	c1 ea 16             	shr    $0x16,%edx
  801225:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80122c:	f6 c2 01             	test   $0x1,%dl
  80122f:	74 1d                	je     80124e <fd_lookup+0x41>
  801231:	89 c2                	mov    %eax,%edx
  801233:	c1 ea 0c             	shr    $0xc,%edx
  801236:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80123d:	f6 c2 01             	test   $0x1,%dl
  801240:	74 0c                	je     80124e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801242:	8b 55 0c             	mov    0xc(%ebp),%edx
  801245:	89 02                	mov    %eax,(%edx)
  801247:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80124c:	eb 05                	jmp    801253 <fd_lookup+0x46>
  80124e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801253:	5d                   	pop    %ebp
  801254:	c3                   	ret    

00801255 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801255:	55                   	push   %ebp
  801256:	89 e5                	mov    %esp,%ebp
  801258:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80125b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80125e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	89 04 24             	mov    %eax,(%esp)
  801268:	e8 a0 ff ff ff       	call   80120d <fd_lookup>
  80126d:	85 c0                	test   %eax,%eax
  80126f:	78 0e                	js     80127f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	8b 55 0c             	mov    0xc(%ebp),%edx
  801277:	89 50 04             	mov    %edx,0x4(%eax)
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 10             	sub    $0x10,%esp
  801289:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80128c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80128f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801294:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801299:	be a8 2c 80 00       	mov    $0x802ca8,%esi
		if (devtab[i]->dev_id == dev_id) {
  80129e:	39 08                	cmp    %ecx,(%eax)
  8012a0:	75 10                	jne    8012b2 <dev_lookup+0x31>
  8012a2:	eb 04                	jmp    8012a8 <dev_lookup+0x27>
  8012a4:	39 08                	cmp    %ecx,(%eax)
  8012a6:	75 0a                	jne    8012b2 <dev_lookup+0x31>
			*dev = devtab[i];
  8012a8:	89 03                	mov    %eax,(%ebx)
  8012aa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8012af:	90                   	nop
  8012b0:	eb 31                	jmp    8012e3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8012b2:	83 c2 01             	add    $0x1,%edx
  8012b5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	75 e8                	jne    8012a4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8012bc:	a1 74 60 80 00       	mov    0x806074,%eax
  8012c1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8012c4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cc:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  8012d3:	e8 bd ee ff ff       	call   800195 <cprintf>
	*dev = 0;
  8012d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8012de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	5b                   	pop    %ebx
  8012e7:	5e                   	pop    %esi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 24             	sub    $0x24,%esp
  8012f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 04 24             	mov    %eax,(%esp)
  801301:	e8 07 ff ff ff       	call   80120d <fd_lookup>
  801306:	85 c0                	test   %eax,%eax
  801308:	78 53                	js     80135d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80130a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801314:	8b 00                	mov    (%eax),%eax
  801316:	89 04 24             	mov    %eax,(%esp)
  801319:	e8 63 ff ff ff       	call   801281 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 3b                	js     80135d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801322:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80132e:	74 2d                	je     80135d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801330:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801333:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80133a:	00 00 00 
	stat->st_isdir = 0;
  80133d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801344:	00 00 00 
	stat->st_dev = dev;
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801350:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801354:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801357:	89 14 24             	mov    %edx,(%esp)
  80135a:	ff 50 14             	call   *0x14(%eax)
}
  80135d:	83 c4 24             	add    $0x24,%esp
  801360:	5b                   	pop    %ebx
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	53                   	push   %ebx
  801367:	83 ec 24             	sub    $0x24,%esp
  80136a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80136d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801370:	89 44 24 04          	mov    %eax,0x4(%esp)
  801374:	89 1c 24             	mov    %ebx,(%esp)
  801377:	e8 91 fe ff ff       	call   80120d <fd_lookup>
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 5f                	js     8013df <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801380:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801383:	89 44 24 04          	mov    %eax,0x4(%esp)
  801387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138a:	8b 00                	mov    (%eax),%eax
  80138c:	89 04 24             	mov    %eax,(%esp)
  80138f:	e8 ed fe ff ff       	call   801281 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801394:	85 c0                	test   %eax,%eax
  801396:	78 47                	js     8013df <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80139b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80139f:	75 23                	jne    8013c4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8013a1:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013a6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b1:	c7 04 24 4c 2c 80 00 	movl   $0x802c4c,(%esp)
  8013b8:	e8 d8 ed ff ff       	call   800195 <cprintf>
  8013bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8013c2:	eb 1b                	jmp    8013df <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8b 48 18             	mov    0x18(%eax),%ecx
  8013ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013cf:	85 c9                	test   %ecx,%ecx
  8013d1:	74 0c                	je     8013df <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013da:	89 14 24             	mov    %edx,(%esp)
  8013dd:	ff d1                	call   *%ecx
}
  8013df:	83 c4 24             	add    $0x24,%esp
  8013e2:	5b                   	pop    %ebx
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    

008013e5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	53                   	push   %ebx
  8013e9:	83 ec 24             	sub    $0x24,%esp
  8013ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f6:	89 1c 24             	mov    %ebx,(%esp)
  8013f9:	e8 0f fe ff ff       	call   80120d <fd_lookup>
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 66                	js     801468 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801405:	89 44 24 04          	mov    %eax,0x4(%esp)
  801409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	89 04 24             	mov    %eax,(%esp)
  801411:	e8 6b fe ff ff       	call   801281 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801416:	85 c0                	test   %eax,%eax
  801418:	78 4e                	js     801468 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80141a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80141d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801421:	75 23                	jne    801446 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801423:	a1 74 60 80 00       	mov    0x806074,%eax
  801428:	8b 40 4c             	mov    0x4c(%eax),%eax
  80142b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801433:	c7 04 24 6d 2c 80 00 	movl   $0x802c6d,(%esp)
  80143a:	e8 56 ed ff ff       	call   800195 <cprintf>
  80143f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801444:	eb 22                	jmp    801468 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801449:	8b 48 0c             	mov    0xc(%eax),%ecx
  80144c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801451:	85 c9                	test   %ecx,%ecx
  801453:	74 13                	je     801468 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801455:	8b 45 10             	mov    0x10(%ebp),%eax
  801458:	89 44 24 08          	mov    %eax,0x8(%esp)
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801463:	89 14 24             	mov    %edx,(%esp)
  801466:	ff d1                	call   *%ecx
}
  801468:	83 c4 24             	add    $0x24,%esp
  80146b:	5b                   	pop    %ebx
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	53                   	push   %ebx
  801472:	83 ec 24             	sub    $0x24,%esp
  801475:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801478:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147f:	89 1c 24             	mov    %ebx,(%esp)
  801482:	e8 86 fd ff ff       	call   80120d <fd_lookup>
  801487:	85 c0                	test   %eax,%eax
  801489:	78 6b                	js     8014f6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801495:	8b 00                	mov    (%eax),%eax
  801497:	89 04 24             	mov    %eax,(%esp)
  80149a:	e8 e2 fd ff ff       	call   801281 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 53                	js     8014f6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014a6:	8b 42 08             	mov    0x8(%edx),%eax
  8014a9:	83 e0 03             	and    $0x3,%eax
  8014ac:	83 f8 01             	cmp    $0x1,%eax
  8014af:	75 23                	jne    8014d4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8014b1:	a1 74 60 80 00       	mov    0x806074,%eax
  8014b6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c1:	c7 04 24 8a 2c 80 00 	movl   $0x802c8a,(%esp)
  8014c8:	e8 c8 ec ff ff       	call   800195 <cprintf>
  8014cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8014d2:	eb 22                	jmp    8014f6 <read+0x88>
	}
	if (!dev->dev_read)
  8014d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d7:	8b 48 08             	mov    0x8(%eax),%ecx
  8014da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014df:	85 c9                	test   %ecx,%ecx
  8014e1:	74 13                	je     8014f6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	89 14 24             	mov    %edx,(%esp)
  8014f4:	ff d1                	call   *%ecx
}
  8014f6:	83 c4 24             	add    $0x24,%esp
  8014f9:	5b                   	pop    %ebx
  8014fa:	5d                   	pop    %ebp
  8014fb:	c3                   	ret    

008014fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	57                   	push   %edi
  801500:	56                   	push   %esi
  801501:	53                   	push   %ebx
  801502:	83 ec 1c             	sub    $0x1c,%esp
  801505:	8b 7d 08             	mov    0x8(%ebp),%edi
  801508:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80150b:	ba 00 00 00 00       	mov    $0x0,%edx
  801510:	bb 00 00 00 00       	mov    $0x0,%ebx
  801515:	b8 00 00 00 00       	mov    $0x0,%eax
  80151a:	85 f6                	test   %esi,%esi
  80151c:	74 29                	je     801547 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80151e:	89 f0                	mov    %esi,%eax
  801520:	29 d0                	sub    %edx,%eax
  801522:	89 44 24 08          	mov    %eax,0x8(%esp)
  801526:	03 55 0c             	add    0xc(%ebp),%edx
  801529:	89 54 24 04          	mov    %edx,0x4(%esp)
  80152d:	89 3c 24             	mov    %edi,(%esp)
  801530:	e8 39 ff ff ff       	call   80146e <read>
		if (m < 0)
  801535:	85 c0                	test   %eax,%eax
  801537:	78 0e                	js     801547 <readn+0x4b>
			return m;
		if (m == 0)
  801539:	85 c0                	test   %eax,%eax
  80153b:	74 08                	je     801545 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80153d:	01 c3                	add    %eax,%ebx
  80153f:	89 da                	mov    %ebx,%edx
  801541:	39 f3                	cmp    %esi,%ebx
  801543:	72 d9                	jb     80151e <readn+0x22>
  801545:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801547:	83 c4 1c             	add    $0x1c,%esp
  80154a:	5b                   	pop    %ebx
  80154b:	5e                   	pop    %esi
  80154c:	5f                   	pop    %edi
  80154d:	5d                   	pop    %ebp
  80154e:	c3                   	ret    

0080154f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	56                   	push   %esi
  801553:	53                   	push   %ebx
  801554:	83 ec 20             	sub    $0x20,%esp
  801557:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80155a:	89 34 24             	mov    %esi,(%esp)
  80155d:	e8 0e fc ff ff       	call   801170 <fd2num>
  801562:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801565:	89 54 24 04          	mov    %edx,0x4(%esp)
  801569:	89 04 24             	mov    %eax,(%esp)
  80156c:	e8 9c fc ff ff       	call   80120d <fd_lookup>
  801571:	89 c3                	mov    %eax,%ebx
  801573:	85 c0                	test   %eax,%eax
  801575:	78 05                	js     80157c <fd_close+0x2d>
  801577:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80157a:	74 0c                	je     801588 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80157c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801580:	19 c0                	sbb    %eax,%eax
  801582:	f7 d0                	not    %eax
  801584:	21 c3                	and    %eax,%ebx
  801586:	eb 3d                	jmp    8015c5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801588:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158f:	8b 06                	mov    (%esi),%eax
  801591:	89 04 24             	mov    %eax,(%esp)
  801594:	e8 e8 fc ff ff       	call   801281 <dev_lookup>
  801599:	89 c3                	mov    %eax,%ebx
  80159b:	85 c0                	test   %eax,%eax
  80159d:	78 16                	js     8015b5 <fd_close+0x66>
		if (dev->dev_close)
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	8b 40 10             	mov    0x10(%eax),%eax
  8015a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	74 07                	je     8015b5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8015ae:	89 34 24             	mov    %esi,(%esp)
  8015b1:	ff d0                	call   *%eax
  8015b3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015c0:	e8 ca f9 ff ff       	call   800f8f <sys_page_unmap>
	return r;
}
  8015c5:	89 d8                	mov    %ebx,%eax
  8015c7:	83 c4 20             	add    $0x20,%esp
  8015ca:	5b                   	pop    %ebx
  8015cb:	5e                   	pop    %esi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	89 04 24             	mov    %eax,(%esp)
  8015e1:	e8 27 fc ff ff       	call   80120d <fd_lookup>
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 13                	js     8015fd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8015ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015f1:	00 
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	89 04 24             	mov    %eax,(%esp)
  8015f8:	e8 52 ff ff ff       	call   80154f <fd_close>
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 18             	sub    $0x18,%esp
  801605:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801608:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80160b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801612:	00 
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	89 04 24             	mov    %eax,(%esp)
  801619:	e8 55 03 00 00       	call   801973 <open>
  80161e:	89 c3                	mov    %eax,%ebx
  801620:	85 c0                	test   %eax,%eax
  801622:	78 1b                	js     80163f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801624:	8b 45 0c             	mov    0xc(%ebp),%eax
  801627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162b:	89 1c 24             	mov    %ebx,(%esp)
  80162e:	e8 b7 fc ff ff       	call   8012ea <fstat>
  801633:	89 c6                	mov    %eax,%esi
	close(fd);
  801635:	89 1c 24             	mov    %ebx,(%esp)
  801638:	e8 91 ff ff ff       	call   8015ce <close>
  80163d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80163f:	89 d8                	mov    %ebx,%eax
  801641:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801644:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801647:	89 ec                	mov    %ebp,%esp
  801649:	5d                   	pop    %ebp
  80164a:	c3                   	ret    

0080164b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	53                   	push   %ebx
  80164f:	83 ec 14             	sub    $0x14,%esp
  801652:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801657:	89 1c 24             	mov    %ebx,(%esp)
  80165a:	e8 6f ff ff ff       	call   8015ce <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80165f:	83 c3 01             	add    $0x1,%ebx
  801662:	83 fb 20             	cmp    $0x20,%ebx
  801665:	75 f0                	jne    801657 <close_all+0xc>
		close(i);
}
  801667:	83 c4 14             	add    $0x14,%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5d                   	pop    %ebp
  80166c:	c3                   	ret    

0080166d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 58             	sub    $0x58,%esp
  801673:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801676:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801679:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80167c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80167f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801682:	89 44 24 04          	mov    %eax,0x4(%esp)
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	89 04 24             	mov    %eax,(%esp)
  80168c:	e8 7c fb ff ff       	call   80120d <fd_lookup>
  801691:	89 c3                	mov    %eax,%ebx
  801693:	85 c0                	test   %eax,%eax
  801695:	0f 88 e0 00 00 00    	js     80177b <dup+0x10e>
		return r;
	close(newfdnum);
  80169b:	89 3c 24             	mov    %edi,(%esp)
  80169e:	e8 2b ff ff ff       	call   8015ce <close>

	newfd = INDEX2FD(newfdnum);
  8016a3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8016a9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8016ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016af:	89 04 24             	mov    %eax,(%esp)
  8016b2:	e8 c9 fa ff ff       	call   801180 <fd2data>
  8016b7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8016b9:	89 34 24             	mov    %esi,(%esp)
  8016bc:	e8 bf fa ff ff       	call   801180 <fd2data>
  8016c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8016c4:	89 da                	mov    %ebx,%edx
  8016c6:	89 d8                	mov    %ebx,%eax
  8016c8:	c1 e8 16             	shr    $0x16,%eax
  8016cb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016d2:	a8 01                	test   $0x1,%al
  8016d4:	74 43                	je     801719 <dup+0xac>
  8016d6:	c1 ea 0c             	shr    $0xc,%edx
  8016d9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016e0:	a8 01                	test   $0x1,%al
  8016e2:	74 35                	je     801719 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8016e4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8016f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801702:	00 
  801703:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801707:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80170e:	e8 da f8 ff ff       	call   800fed <sys_page_map>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	85 c0                	test   %eax,%eax
  801717:	78 3f                	js     801758 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80171c:	89 c2                	mov    %eax,%edx
  80171e:	c1 ea 0c             	shr    $0xc,%edx
  801721:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801728:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80172e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801732:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801736:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80173d:	00 
  80173e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801742:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801749:	e8 9f f8 ff ff       	call   800fed <sys_page_map>
  80174e:	89 c3                	mov    %eax,%ebx
  801750:	85 c0                	test   %eax,%eax
  801752:	78 04                	js     801758 <dup+0xeb>
  801754:	89 fb                	mov    %edi,%ebx
  801756:	eb 23                	jmp    80177b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801758:	89 74 24 04          	mov    %esi,0x4(%esp)
  80175c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801763:	e8 27 f8 ff ff       	call   800f8f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80176b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801776:	e8 14 f8 ff ff       	call   800f8f <sys_page_unmap>
	return r;
}
  80177b:	89 d8                	mov    %ebx,%eax
  80177d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801780:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801783:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801786:	89 ec                	mov    %ebp,%esp
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    
	...

0080178c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	53                   	push   %ebx
  801790:	83 ec 14             	sub    $0x14,%esp
  801793:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801795:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80179b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8017a2:	00 
  8017a3:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  8017aa:	00 
  8017ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017af:	89 14 24             	mov    %edx,(%esp)
  8017b2:	e8 19 0d 00 00       	call   8024d0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017be:	00 
  8017bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017ca:	e8 67 0d 00 00       	call   802536 <ipc_recv>
}
  8017cf:	83 c4 14             	add    $0x14,%esp
  8017d2:	5b                   	pop    %ebx
  8017d3:	5d                   	pop    %ebp
  8017d4:	c3                   	ret    

008017d5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  8017e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f3:	b8 02 00 00 00       	mov    $0x2,%eax
  8017f8:	e8 8f ff ff ff       	call   80178c <fsipc>
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	8b 40 0c             	mov    0xc(%eax),%eax
  80180b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801810:	ba 00 00 00 00       	mov    $0x0,%edx
  801815:	b8 06 00 00 00       	mov    $0x6,%eax
  80181a:	e8 6d ff ff ff       	call   80178c <fsipc>
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801827:	ba 00 00 00 00       	mov    $0x0,%edx
  80182c:	b8 08 00 00 00       	mov    $0x8,%eax
  801831:	e8 56 ff ff ff       	call   80178c <fsipc>
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	53                   	push   %ebx
  80183c:	83 ec 14             	sub    $0x14,%esp
  80183f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8b 40 0c             	mov    0xc(%eax),%eax
  801848:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80184d:	ba 00 00 00 00       	mov    $0x0,%edx
  801852:	b8 05 00 00 00       	mov    $0x5,%eax
  801857:	e8 30 ff ff ff       	call   80178c <fsipc>
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 2b                	js     80188b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801860:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801867:	00 
  801868:	89 1c 24             	mov    %ebx,(%esp)
  80186b:	e8 ea ef ff ff       	call   80085a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801870:	a1 80 30 80 00       	mov    0x803080,%eax
  801875:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80187b:	a1 84 30 80 00       	mov    0x803084,%eax
  801880:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80188b:	83 c4 14             	add    $0x14,%esp
  80188e:	5b                   	pop    %ebx
  80188f:	5d                   	pop    %ebp
  801890:	c3                   	ret    

00801891 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 18             	sub    $0x18,%esp
  801897:	8b 45 10             	mov    0x10(%ebp),%eax
  80189a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80189f:	76 05                	jbe    8018a6 <devfile_write+0x15>
  8018a1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a9:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ac:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  8018b2:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  8018b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c2:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8018c9:	e8 47 f1 ff ff       	call   800a15 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  8018ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d3:	b8 04 00 00 00       	mov    $0x4,%eax
  8018d8:	e8 af fe ff ff       	call   80178c <fsipc>
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	53                   	push   %ebx
  8018e3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ec:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  8018f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f4:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  8018f9:	ba 00 30 80 00       	mov    $0x803000,%edx
  8018fe:	b8 03 00 00 00       	mov    $0x3,%eax
  801903:	e8 84 fe ff ff       	call   80178c <fsipc>
  801908:	89 c3                	mov    %eax,%ebx
  80190a:	85 c0                	test   %eax,%eax
  80190c:	78 17                	js     801925 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80190e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801912:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801919:	00 
  80191a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191d:	89 04 24             	mov    %eax,(%esp)
  801920:	e8 f0 f0 ff ff       	call   800a15 <memmove>
	return r;
}
  801925:	89 d8                	mov    %ebx,%eax
  801927:	83 c4 14             	add    $0x14,%esp
  80192a:	5b                   	pop    %ebx
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	53                   	push   %ebx
  801931:	83 ec 14             	sub    $0x14,%esp
  801934:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801937:	89 1c 24             	mov    %ebx,(%esp)
  80193a:	e8 d1 ee ff ff       	call   800810 <strlen>
  80193f:	89 c2                	mov    %eax,%edx
  801941:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801946:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  80194c:	7f 1f                	jg     80196d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  80194e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801952:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801959:	e8 fc ee ff ff       	call   80085a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  80195e:	ba 00 00 00 00       	mov    $0x0,%edx
  801963:	b8 07 00 00 00       	mov    $0x7,%eax
  801968:	e8 1f fe ff ff       	call   80178c <fsipc>
}
  80196d:	83 c4 14             	add    $0x14,%esp
  801970:	5b                   	pop    %ebx
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    

00801973 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 28             	sub    $0x28,%esp
  801979:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80197c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80197f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801982:	89 34 24             	mov    %esi,(%esp)
  801985:	e8 86 ee ff ff       	call   800810 <strlen>
  80198a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80198f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801994:	7f 5e                	jg     8019f4 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801996:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801999:	89 04 24             	mov    %eax,(%esp)
  80199c:	e8 fa f7 ff ff       	call   80119b <fd_alloc>
  8019a1:	89 c3                	mov    %eax,%ebx
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 4d                	js     8019f4 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  8019a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019ab:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8019b2:	e8 a3 ee ff ff       	call   80085a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  8019bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c7:	e8 c0 fd ff ff       	call   80178c <fsipc>
  8019cc:	89 c3                	mov    %eax,%ebx
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	79 15                	jns    8019e7 <open+0x74>
	{
		fd_close(fd,0);
  8019d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019d9:	00 
  8019da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019dd:	89 04 24             	mov    %eax,(%esp)
  8019e0:	e8 6a fb ff ff       	call   80154f <fd_close>
		return r; 
  8019e5:	eb 0d                	jmp    8019f4 <open+0x81>
	}
	return fd2num(fd);
  8019e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ea:	89 04 24             	mov    %eax,(%esp)
  8019ed:	e8 7e f7 ff ff       	call   801170 <fd2num>
  8019f2:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  8019f4:	89 d8                	mov    %ebx,%eax
  8019f6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8019f9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019fc:	89 ec                	mov    %ebp,%esp
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    

00801a00 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801a06:	c7 44 24 04 bc 2c 80 	movl   $0x802cbc,0x4(%esp)
  801a0d:	00 
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	89 04 24             	mov    %eax,(%esp)
  801a14:	e8 41 ee ff ff       	call   80085a <strcpy>
	return 0;
}
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2c:	89 04 24             	mov    %eax,(%esp)
  801a2f:	e8 9e 02 00 00       	call   801cd2 <nsipc_close>
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a3c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a43:	00 
  801a44:	8b 45 10             	mov    0x10(%ebp),%eax
  801a47:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	8b 40 0c             	mov    0xc(%eax),%eax
  801a58:	89 04 24             	mov    %eax,(%esp)
  801a5b:	e8 ae 02 00 00       	call   801d0e <nsipc_send>
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a68:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a6f:	00 
  801a70:	8b 45 10             	mov    0x10(%ebp),%eax
  801a73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	8b 40 0c             	mov    0xc(%eax),%eax
  801a84:	89 04 24             	mov    %eax,(%esp)
  801a87:	e8 f5 02 00 00       	call   801d81 <nsipc_recv>
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	56                   	push   %esi
  801a92:	53                   	push   %ebx
  801a93:	83 ec 20             	sub    $0x20,%esp
  801a96:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9b:	89 04 24             	mov    %eax,(%esp)
  801a9e:	e8 f8 f6 ff ff       	call   80119b <fd_alloc>
  801aa3:	89 c3                	mov    %eax,%ebx
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 21                	js     801aca <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801aa9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ab0:	00 
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abf:	e8 87 f5 ff ff       	call   80104b <sys_page_alloc>
  801ac4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	79 0a                	jns    801ad4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801aca:	89 34 24             	mov    %esi,(%esp)
  801acd:	e8 00 02 00 00       	call   801cd2 <nsipc_close>
		return r;
  801ad2:	eb 28                	jmp    801afc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ad4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801add:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af2:	89 04 24             	mov    %eax,(%esp)
  801af5:	e8 76 f6 ff ff       	call   801170 <fd2num>
  801afa:	89 c3                	mov    %eax,%ebx
}
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	83 c4 20             	add    $0x20,%esp
  801b01:	5b                   	pop    %ebx
  801b02:	5e                   	pop    %esi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    

00801b05 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	89 04 24             	mov    %eax,(%esp)
  801b1f:	e8 62 01 00 00       	call   801c86 <nsipc_socket>
  801b24:	85 c0                	test   %eax,%eax
  801b26:	78 05                	js     801b2d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801b28:	e8 61 ff ff ff       	call   801a8e <alloc_sockfd>
}
  801b2d:	c9                   	leave  
  801b2e:	66 90                	xchg   %ax,%ax
  801b30:	c3                   	ret    

00801b31 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b37:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b3a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b3e:	89 04 24             	mov    %eax,(%esp)
  801b41:	e8 c7 f6 ff ff       	call   80120d <fd_lookup>
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 15                	js     801b5f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b4d:	8b 0a                	mov    (%edx),%ecx
  801b4f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b54:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801b5a:	75 03                	jne    801b5f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801b5c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	e8 c2 ff ff ff       	call   801b31 <fd2sockid>
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 0f                	js     801b82 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b7a:	89 04 24             	mov    %eax,(%esp)
  801b7d:	e8 2e 01 00 00       	call   801cb0 <nsipc_listen>
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	e8 9f ff ff ff       	call   801b31 <fd2sockid>
  801b92:	85 c0                	test   %eax,%eax
  801b94:	78 16                	js     801bac <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801b96:	8b 55 10             	mov    0x10(%ebp),%edx
  801b99:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ba4:	89 04 24             	mov    %eax,(%esp)
  801ba7:	e8 55 02 00 00       	call   801e01 <nsipc_connect>
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	e8 75 ff ff ff       	call   801b31 <fd2sockid>
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 0f                	js     801bcf <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bc7:	89 04 24             	mov    %eax,(%esp)
  801bca:	e8 1d 01 00 00       	call   801cec <nsipc_shutdown>
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	e8 52 ff ff ff       	call   801b31 <fd2sockid>
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 16                	js     801bf9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801be3:	8b 55 10             	mov    0x10(%ebp),%edx
  801be6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bed:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bf1:	89 04 24             	mov    %eax,(%esp)
  801bf4:	e8 47 02 00 00       	call   801e40 <nsipc_bind>
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	e8 28 ff ff ff       	call   801b31 <fd2sockid>
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	78 1f                	js     801c2c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c0d:	8b 55 10             	mov    0x10(%ebp),%edx
  801c10:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c17:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 5c 02 00 00       	call   801e7f <nsipc_accept>
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 05                	js     801c2c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801c27:	e8 62 fe ff ff       	call   801a8e <alloc_sockfd>
}
  801c2c:	c9                   	leave  
  801c2d:	8d 76 00             	lea    0x0(%esi),%esi
  801c30:	c3                   	ret    
	...

00801c40 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c46:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801c4c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c53:	00 
  801c54:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801c5b:	00 
  801c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c60:	89 14 24             	mov    %edx,(%esp)
  801c63:	e8 68 08 00 00       	call   8024d0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c68:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c6f:	00 
  801c70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c77:	00 
  801c78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c7f:	e8 b2 08 00 00       	call   802536 <ipc_recv>
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801ca4:	b8 09 00 00 00       	mov    $0x9,%eax
  801ca9:	e8 92 ff ff ff       	call   801c40 <nsipc>
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801cc6:	b8 06 00 00 00       	mov    $0x6,%eax
  801ccb:	e8 70 ff ff ff       	call   801c40 <nsipc>
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801ce0:	b8 04 00 00 00       	mov    $0x4,%eax
  801ce5:	e8 56 ff ff ff       	call   801c40 <nsipc>
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfd:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801d02:	b8 03 00 00 00       	mov    $0x3,%eax
  801d07:	e8 34 ff ff ff       	call   801c40 <nsipc>
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	53                   	push   %ebx
  801d12:	83 ec 14             	sub    $0x14,%esp
  801d15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801d20:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d26:	7e 24                	jle    801d4c <nsipc_send+0x3e>
  801d28:	c7 44 24 0c c8 2c 80 	movl   $0x802cc8,0xc(%esp)
  801d2f:	00 
  801d30:	c7 44 24 08 d4 2c 80 	movl   $0x802cd4,0x8(%esp)
  801d37:	00 
  801d38:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801d3f:	00 
  801d40:	c7 04 24 e9 2c 80 00 	movl   $0x802ce9,(%esp)
  801d47:	e8 20 07 00 00       	call   80246c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d4c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d57:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801d5e:	e8 b2 ec ff ff       	call   800a15 <memmove>
	nsipcbuf.send.req_size = size;
  801d63:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801d71:	b8 08 00 00 00       	mov    $0x8,%eax
  801d76:	e8 c5 fe ff ff       	call   801c40 <nsipc>
}
  801d7b:	83 c4 14             	add    $0x14,%esp
  801d7e:	5b                   	pop    %ebx
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    

00801d81 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	56                   	push   %esi
  801d85:	53                   	push   %ebx
  801d86:	83 ec 10             	sub    $0x10,%esp
  801d89:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801d94:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801da2:	b8 07 00 00 00       	mov    $0x7,%eax
  801da7:	e8 94 fe ff ff       	call   801c40 <nsipc>
  801dac:	89 c3                	mov    %eax,%ebx
  801dae:	85 c0                	test   %eax,%eax
  801db0:	78 46                	js     801df8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801db2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801db7:	7f 04                	jg     801dbd <nsipc_recv+0x3c>
  801db9:	39 c6                	cmp    %eax,%esi
  801dbb:	7d 24                	jge    801de1 <nsipc_recv+0x60>
  801dbd:	c7 44 24 0c f5 2c 80 	movl   $0x802cf5,0xc(%esp)
  801dc4:	00 
  801dc5:	c7 44 24 08 d4 2c 80 	movl   $0x802cd4,0x8(%esp)
  801dcc:	00 
  801dcd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801dd4:	00 
  801dd5:	c7 04 24 e9 2c 80 00 	movl   $0x802ce9,(%esp)
  801ddc:	e8 8b 06 00 00       	call   80246c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801de1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801de5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801dec:	00 
  801ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df0:	89 04 24             	mov    %eax,(%esp)
  801df3:	e8 1d ec ff ff       	call   800a15 <memmove>
	}

	return r;
}
  801df8:	89 d8                	mov    %ebx,%eax
  801dfa:	83 c4 10             	add    $0x10,%esp
  801dfd:	5b                   	pop    %ebx
  801dfe:	5e                   	pop    %esi
  801dff:	5d                   	pop    %ebp
  801e00:	c3                   	ret    

00801e01 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	53                   	push   %ebx
  801e05:	83 ec 14             	sub    $0x14,%esp
  801e08:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801e25:	e8 eb eb ff ff       	call   800a15 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e2a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  801e30:	b8 05 00 00 00       	mov    $0x5,%eax
  801e35:	e8 06 fe ff ff       	call   801c40 <nsipc>
}
  801e3a:	83 c4 14             	add    $0x14,%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    

00801e40 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	53                   	push   %ebx
  801e44:	83 ec 14             	sub    $0x14,%esp
  801e47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e52:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5d:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801e64:	e8 ac eb ff ff       	call   800a15 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e69:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  801e6f:	b8 02 00 00 00       	mov    $0x2,%eax
  801e74:	e8 c7 fd ff ff       	call   801c40 <nsipc>
}
  801e79:	83 c4 14             	add    $0x14,%esp
  801e7c:	5b                   	pop    %ebx
  801e7d:	5d                   	pop    %ebp
  801e7e:	c3                   	ret    

00801e7f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 18             	sub    $0x18,%esp
  801e85:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e88:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e93:	b8 01 00 00 00       	mov    $0x1,%eax
  801e98:	e8 a3 fd ff ff       	call   801c40 <nsipc>
  801e9d:	89 c3                	mov    %eax,%ebx
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	78 25                	js     801ec8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ea3:	be 10 50 80 00       	mov    $0x805010,%esi
  801ea8:	8b 06                	mov    (%esi),%eax
  801eaa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eae:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801eb5:	00 
  801eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb9:	89 04 24             	mov    %eax,(%esp)
  801ebc:	e8 54 eb ff ff       	call   800a15 <memmove>
		*addrlen = ret->ret_addrlen;
  801ec1:	8b 16                	mov    (%esi),%edx
  801ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801ec8:	89 d8                	mov    %ebx,%eax
  801eca:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ecd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ed0:	89 ec                	mov    %ebp,%esp
  801ed2:	5d                   	pop    %ebp
  801ed3:	c3                   	ret    
	...

00801ee0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
  801ee6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ee9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801eec:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	89 04 24             	mov    %eax,(%esp)
  801ef5:	e8 86 f2 ff ff       	call   801180 <fd2data>
  801efa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801efc:	c7 44 24 04 0a 2d 80 	movl   $0x802d0a,0x4(%esp)
  801f03:	00 
  801f04:	89 34 24             	mov    %esi,(%esp)
  801f07:	e8 4e e9 ff ff       	call   80085a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f0c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f0f:	2b 03                	sub    (%ebx),%eax
  801f11:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801f17:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801f1e:	00 00 00 
	stat->st_dev = &devpipe;
  801f21:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  801f28:	60 80 00 
	return 0;
}
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f30:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f33:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f36:	89 ec                	mov    %ebp,%esp
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	53                   	push   %ebx
  801f3e:	83 ec 14             	sub    $0x14,%esp
  801f41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4f:	e8 3b f0 ff ff       	call   800f8f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f54:	89 1c 24             	mov    %ebx,(%esp)
  801f57:	e8 24 f2 ff ff       	call   801180 <fd2data>
  801f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f67:	e8 23 f0 ff ff       	call   800f8f <sys_page_unmap>
}
  801f6c:	83 c4 14             	add    $0x14,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5d                   	pop    %ebp
  801f71:	c3                   	ret    

00801f72 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	57                   	push   %edi
  801f76:	56                   	push   %esi
  801f77:	53                   	push   %ebx
  801f78:	83 ec 2c             	sub    $0x2c,%esp
  801f7b:	89 c7                	mov    %eax,%edi
  801f7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801f80:	a1 74 60 80 00       	mov    0x806074,%eax
  801f85:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f88:	89 3c 24             	mov    %edi,(%esp)
  801f8b:	e8 10 06 00 00       	call   8025a0 <pageref>
  801f90:	89 c6                	mov    %eax,%esi
  801f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f95:	89 04 24             	mov    %eax,(%esp)
  801f98:	e8 03 06 00 00       	call   8025a0 <pageref>
  801f9d:	39 c6                	cmp    %eax,%esi
  801f9f:	0f 94 c0             	sete   %al
  801fa2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801fa5:	8b 15 74 60 80 00    	mov    0x806074,%edx
  801fab:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fae:	39 cb                	cmp    %ecx,%ebx
  801fb0:	75 08                	jne    801fba <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801fb2:	83 c4 2c             	add    $0x2c,%esp
  801fb5:	5b                   	pop    %ebx
  801fb6:	5e                   	pop    %esi
  801fb7:	5f                   	pop    %edi
  801fb8:	5d                   	pop    %ebp
  801fb9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801fba:	83 f8 01             	cmp    $0x1,%eax
  801fbd:	75 c1                	jne    801f80 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801fbf:	8b 52 58             	mov    0x58(%edx),%edx
  801fc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fc6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fce:	c7 04 24 11 2d 80 00 	movl   $0x802d11,(%esp)
  801fd5:	e8 bb e1 ff ff       	call   800195 <cprintf>
  801fda:	eb a4                	jmp    801f80 <_pipeisclosed+0xe>

00801fdc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	57                   	push   %edi
  801fe0:	56                   	push   %esi
  801fe1:	53                   	push   %ebx
  801fe2:	83 ec 1c             	sub    $0x1c,%esp
  801fe5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fe8:	89 34 24             	mov    %esi,(%esp)
  801feb:	e8 90 f1 ff ff       	call   801180 <fd2data>
  801ff0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ff2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ffb:	75 54                	jne    802051 <devpipe_write+0x75>
  801ffd:	eb 60                	jmp    80205f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fff:	89 da                	mov    %ebx,%edx
  802001:	89 f0                	mov    %esi,%eax
  802003:	e8 6a ff ff ff       	call   801f72 <_pipeisclosed>
  802008:	85 c0                	test   %eax,%eax
  80200a:	74 07                	je     802013 <devpipe_write+0x37>
  80200c:	b8 00 00 00 00       	mov    $0x0,%eax
  802011:	eb 53                	jmp    802066 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802013:	90                   	nop
  802014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802018:	e8 8d f0 ff ff       	call   8010aa <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80201d:	8b 43 04             	mov    0x4(%ebx),%eax
  802020:	8b 13                	mov    (%ebx),%edx
  802022:	83 c2 20             	add    $0x20,%edx
  802025:	39 d0                	cmp    %edx,%eax
  802027:	73 d6                	jae    801fff <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802029:	89 c2                	mov    %eax,%edx
  80202b:	c1 fa 1f             	sar    $0x1f,%edx
  80202e:	c1 ea 1b             	shr    $0x1b,%edx
  802031:	01 d0                	add    %edx,%eax
  802033:	83 e0 1f             	and    $0x1f,%eax
  802036:	29 d0                	sub    %edx,%eax
  802038:	89 c2                	mov    %eax,%edx
  80203a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802041:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802045:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802049:	83 c7 01             	add    $0x1,%edi
  80204c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80204f:	76 13                	jbe    802064 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802051:	8b 43 04             	mov    0x4(%ebx),%eax
  802054:	8b 13                	mov    (%ebx),%edx
  802056:	83 c2 20             	add    $0x20,%edx
  802059:	39 d0                	cmp    %edx,%eax
  80205b:	73 a2                	jae    801fff <devpipe_write+0x23>
  80205d:	eb ca                	jmp    802029 <devpipe_write+0x4d>
  80205f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802064:	89 f8                	mov    %edi,%eax
}
  802066:	83 c4 1c             	add    $0x1c,%esp
  802069:	5b                   	pop    %ebx
  80206a:	5e                   	pop    %esi
  80206b:	5f                   	pop    %edi
  80206c:	5d                   	pop    %ebp
  80206d:	c3                   	ret    

0080206e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 28             	sub    $0x28,%esp
  802074:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802077:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80207a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80207d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802080:	89 3c 24             	mov    %edi,(%esp)
  802083:	e8 f8 f0 ff ff       	call   801180 <fd2data>
  802088:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80208a:	be 00 00 00 00       	mov    $0x0,%esi
  80208f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802093:	75 4c                	jne    8020e1 <devpipe_read+0x73>
  802095:	eb 5b                	jmp    8020f2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802097:	89 f0                	mov    %esi,%eax
  802099:	eb 5e                	jmp    8020f9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80209b:	89 da                	mov    %ebx,%edx
  80209d:	89 f8                	mov    %edi,%eax
  80209f:	90                   	nop
  8020a0:	e8 cd fe ff ff       	call   801f72 <_pipeisclosed>
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	74 07                	je     8020b0 <devpipe_read+0x42>
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	eb 49                	jmp    8020f9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8020b0:	e8 f5 ef ff ff       	call   8010aa <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8020b5:	8b 03                	mov    (%ebx),%eax
  8020b7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020ba:	74 df                	je     80209b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020bc:	89 c2                	mov    %eax,%edx
  8020be:	c1 fa 1f             	sar    $0x1f,%edx
  8020c1:	c1 ea 1b             	shr    $0x1b,%edx
  8020c4:	01 d0                	add    %edx,%eax
  8020c6:	83 e0 1f             	and    $0x1f,%eax
  8020c9:	29 d0                	sub    %edx,%eax
  8020cb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8020d6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020d9:	83 c6 01             	add    $0x1,%esi
  8020dc:	39 75 10             	cmp    %esi,0x10(%ebp)
  8020df:	76 16                	jbe    8020f7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  8020e1:	8b 03                	mov    (%ebx),%eax
  8020e3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020e6:	75 d4                	jne    8020bc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020e8:	85 f6                	test   %esi,%esi
  8020ea:	75 ab                	jne    802097 <devpipe_read+0x29>
  8020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	eb a9                	jmp    80209b <devpipe_read+0x2d>
  8020f2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020f7:	89 f0                	mov    %esi,%eax
}
  8020f9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020fc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020ff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802102:	89 ec                	mov    %ebp,%esp
  802104:	5d                   	pop    %ebp
  802105:	c3                   	ret    

00802106 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	89 04 24             	mov    %eax,(%esp)
  802119:	e8 ef f0 ff ff       	call   80120d <fd_lookup>
  80211e:	85 c0                	test   %eax,%eax
  802120:	78 15                	js     802137 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802125:	89 04 24             	mov    %eax,(%esp)
  802128:	e8 53 f0 ff ff       	call   801180 <fd2data>
	return _pipeisclosed(fd, p);
  80212d:	89 c2                	mov    %eax,%edx
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	e8 3b fe ff ff       	call   801f72 <_pipeisclosed>
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 48             	sub    $0x48,%esp
  80213f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802142:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802145:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802148:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80214b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80214e:	89 04 24             	mov    %eax,(%esp)
  802151:	e8 45 f0 ff ff       	call   80119b <fd_alloc>
  802156:	89 c3                	mov    %eax,%ebx
  802158:	85 c0                	test   %eax,%eax
  80215a:	0f 88 42 01 00 00    	js     8022a2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802160:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802167:	00 
  802168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80216b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802176:	e8 d0 ee ff ff       	call   80104b <sys_page_alloc>
  80217b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80217d:	85 c0                	test   %eax,%eax
  80217f:	0f 88 1d 01 00 00    	js     8022a2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802185:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802188:	89 04 24             	mov    %eax,(%esp)
  80218b:	e8 0b f0 ff ff       	call   80119b <fd_alloc>
  802190:	89 c3                	mov    %eax,%ebx
  802192:	85 c0                	test   %eax,%eax
  802194:	0f 88 f5 00 00 00    	js     80228f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80219a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021a1:	00 
  8021a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b0:	e8 96 ee ff ff       	call   80104b <sys_page_alloc>
  8021b5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	0f 88 d0 00 00 00    	js     80228f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8021bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021c2:	89 04 24             	mov    %eax,(%esp)
  8021c5:	e8 b6 ef ff ff       	call   801180 <fd2data>
  8021ca:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021cc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021d3:	00 
  8021d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021df:	e8 67 ee ff ff       	call   80104b <sys_page_alloc>
  8021e4:	89 c3                	mov    %eax,%ebx
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	0f 88 8e 00 00 00    	js     80227c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f1:	89 04 24             	mov    %eax,(%esp)
  8021f4:	e8 87 ef ff ff       	call   801180 <fd2data>
  8021f9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802200:	00 
  802201:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802205:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80220c:	00 
  80220d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802218:	e8 d0 ed ff ff       	call   800fed <sys_page_map>
  80221d:	89 c3                	mov    %eax,%ebx
  80221f:	85 c0                	test   %eax,%eax
  802221:	78 49                	js     80226c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802223:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  802228:	8b 08                	mov    (%eax),%ecx
  80222a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80222d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80222f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802232:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802239:	8b 10                	mov    (%eax),%edx
  80223b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80223e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802240:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802243:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80224a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80224d:	89 04 24             	mov    %eax,(%esp)
  802250:	e8 1b ef ff ff       	call   801170 <fd2num>
  802255:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802257:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80225a:	89 04 24             	mov    %eax,(%esp)
  80225d:	e8 0e ef ff ff       	call   801170 <fd2num>
  802262:	89 47 04             	mov    %eax,0x4(%edi)
  802265:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80226a:	eb 36                	jmp    8022a2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80226c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802277:	e8 13 ed ff ff       	call   800f8f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80227c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80227f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802283:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80228a:	e8 00 ed ff ff       	call   800f8f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80228f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802292:	89 44 24 04          	mov    %eax,0x4(%esp)
  802296:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80229d:	e8 ed ec ff ff       	call   800f8f <sys_page_unmap>
    err:
	return r;
}
  8022a2:	89 d8                	mov    %ebx,%eax
  8022a4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022a7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8022aa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8022ad:	89 ec                	mov    %ebp,%esp
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    
	...

008022c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    

008022ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022d0:	c7 44 24 04 29 2d 80 	movl   $0x802d29,0x4(%esp)
  8022d7:	00 
  8022d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022db:	89 04 24             	mov    %eax,(%esp)
  8022de:	e8 77 e5 ff ff       	call   80085a <strcpy>
	return 0;
}
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	57                   	push   %edi
  8022ee:	56                   	push   %esi
  8022ef:	53                   	push   %ebx
  8022f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fb:	be 00 00 00 00       	mov    $0x0,%esi
  802300:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802304:	74 3f                	je     802345 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802306:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80230c:	8b 55 10             	mov    0x10(%ebp),%edx
  80230f:	29 c2                	sub    %eax,%edx
  802311:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802313:	83 fa 7f             	cmp    $0x7f,%edx
  802316:	76 05                	jbe    80231d <devcons_write+0x33>
  802318:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80231d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802321:	03 45 0c             	add    0xc(%ebp),%eax
  802324:	89 44 24 04          	mov    %eax,0x4(%esp)
  802328:	89 3c 24             	mov    %edi,(%esp)
  80232b:	e8 e5 e6 ff ff       	call   800a15 <memmove>
		sys_cputs(buf, m);
  802330:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802334:	89 3c 24             	mov    %edi,(%esp)
  802337:	e8 14 e9 ff ff       	call   800c50 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80233c:	01 de                	add    %ebx,%esi
  80233e:	89 f0                	mov    %esi,%eax
  802340:	3b 75 10             	cmp    0x10(%ebp),%esi
  802343:	72 c7                	jb     80230c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802345:	89 f0                	mov    %esi,%eax
  802347:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5f                   	pop    %edi
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    

00802352 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80235e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802365:	00 
  802366:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802369:	89 04 24             	mov    %eax,(%esp)
  80236c:	e8 df e8 ff ff       	call   800c50 <sys_cputs>
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802379:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80237d:	75 07                	jne    802386 <devcons_read+0x13>
  80237f:	eb 28                	jmp    8023a9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802381:	e8 24 ed ff ff       	call   8010aa <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802386:	66 90                	xchg   %ax,%ax
  802388:	e8 8f e8 ff ff       	call   800c1c <sys_cgetc>
  80238d:	85 c0                	test   %eax,%eax
  80238f:	90                   	nop
  802390:	74 ef                	je     802381 <devcons_read+0xe>
  802392:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802394:	85 c0                	test   %eax,%eax
  802396:	78 16                	js     8023ae <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802398:	83 f8 04             	cmp    $0x4,%eax
  80239b:	74 0c                	je     8023a9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80239d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a0:	88 10                	mov    %dl,(%eax)
  8023a2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8023a7:	eb 05                	jmp    8023ae <devcons_read+0x3b>
  8023a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023b9:	89 04 24             	mov    %eax,(%esp)
  8023bc:	e8 da ed ff ff       	call   80119b <fd_alloc>
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	78 3f                	js     802404 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023c5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023cc:	00 
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023db:	e8 6b ec ff ff       	call   80104b <sys_page_alloc>
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	78 20                	js     802404 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8023e4:	8b 15 58 60 80 00    	mov    0x806058,%edx
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	89 04 24             	mov    %eax,(%esp)
  8023ff:	e8 6c ed ff ff       	call   801170 <fd2num>
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80240c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80240f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	89 04 24             	mov    %eax,(%esp)
  802419:	e8 ef ed ff ff       	call   80120d <fd_lookup>
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 11                	js     802433 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  80242d:	0f 94 c0             	sete   %al
  802430:	0f b6 c0             	movzbl %al,%eax
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80243b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802442:	00 
  802443:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80244a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802451:	e8 18 f0 ff ff       	call   80146e <read>
	if (r < 0)
  802456:	85 c0                	test   %eax,%eax
  802458:	78 0f                	js     802469 <getchar+0x34>
		return r;
	if (r < 1)
  80245a:	85 c0                	test   %eax,%eax
  80245c:	7f 07                	jg     802465 <getchar+0x30>
  80245e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802463:	eb 04                	jmp    802469 <getchar+0x34>
		return -E_EOF;
	return c;
  802465:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    
	...

0080246c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	53                   	push   %ebx
  802470:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  802473:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  802476:	a1 78 60 80 00       	mov    0x806078,%eax
  80247b:	85 c0                	test   %eax,%eax
  80247d:	74 10                	je     80248f <_panic+0x23>
		cprintf("%s: ", argv0);
  80247f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802483:	c7 04 24 35 2d 80 00 	movl   $0x802d35,(%esp)
  80248a:	e8 06 dd ff ff       	call   800195 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80248f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802492:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	89 44 24 08          	mov    %eax,0x8(%esp)
  80249d:	a1 00 60 80 00       	mov    0x806000,%eax
  8024a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a6:	c7 04 24 3a 2d 80 00 	movl   $0x802d3a,(%esp)
  8024ad:	e8 e3 dc ff ff       	call   800195 <cprintf>
	vcprintf(fmt, ap);
  8024b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b9:	89 04 24             	mov    %eax,(%esp)
  8024bc:	e8 73 dc ff ff       	call   800134 <vcprintf>
	cprintf("\n");
  8024c1:	c7 04 24 97 28 80 00 	movl   $0x802897,(%esp)
  8024c8:	e8 c8 dc ff ff       	call   800195 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8024cd:	cc                   	int3   
  8024ce:	eb fd                	jmp    8024cd <_panic+0x61>

008024d0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	57                   	push   %edi
  8024d4:	56                   	push   %esi
  8024d5:	53                   	push   %ebx
  8024d6:	83 ec 1c             	sub    $0x1c,%esp
  8024d9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8024dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024df:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8024e2:	85 db                	test   %ebx,%ebx
  8024e4:	75 2d                	jne    802513 <ipc_send+0x43>
  8024e6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8024eb:	eb 26                	jmp    802513 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8024ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024f0:	74 1c                	je     80250e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  8024f2:	c7 44 24 08 58 2d 80 	movl   $0x802d58,0x8(%esp)
  8024f9:	00 
  8024fa:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802501:	00 
  802502:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  802509:	e8 5e ff ff ff       	call   80246c <_panic>
		sys_yield();
  80250e:	e8 97 eb ff ff       	call   8010aa <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802513:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802517:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80251b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	89 04 24             	mov    %eax,(%esp)
  802525:	e8 13 e9 ff ff       	call   800e3d <sys_ipc_try_send>
  80252a:	85 c0                	test   %eax,%eax
  80252c:	78 bf                	js     8024ed <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80252e:	83 c4 1c             	add    $0x1c,%esp
  802531:	5b                   	pop    %ebx
  802532:	5e                   	pop    %esi
  802533:	5f                   	pop    %edi
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    

00802536 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	56                   	push   %esi
  80253a:	53                   	push   %ebx
  80253b:	83 ec 10             	sub    $0x10,%esp
  80253e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802541:	8b 45 0c             	mov    0xc(%ebp),%eax
  802544:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802547:	85 c0                	test   %eax,%eax
  802549:	75 05                	jne    802550 <ipc_recv+0x1a>
  80254b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802550:	89 04 24             	mov    %eax,(%esp)
  802553:	e8 88 e8 ff ff       	call   800de0 <sys_ipc_recv>
  802558:	85 c0                	test   %eax,%eax
  80255a:	79 16                	jns    802572 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80255c:	85 db                	test   %ebx,%ebx
  80255e:	74 06                	je     802566 <ipc_recv+0x30>
			*from_env_store = 0;
  802560:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802566:	85 f6                	test   %esi,%esi
  802568:	74 2c                	je     802596 <ipc_recv+0x60>
			*perm_store = 0;
  80256a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802570:	eb 24                	jmp    802596 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802572:	85 db                	test   %ebx,%ebx
  802574:	74 0a                	je     802580 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802576:	a1 74 60 80 00       	mov    0x806074,%eax
  80257b:	8b 40 74             	mov    0x74(%eax),%eax
  80257e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802580:	85 f6                	test   %esi,%esi
  802582:	74 0a                	je     80258e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802584:	a1 74 60 80 00       	mov    0x806074,%eax
  802589:	8b 40 78             	mov    0x78(%eax),%eax
  80258c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80258e:	a1 74 60 80 00       	mov    0x806074,%eax
  802593:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802596:	83 c4 10             	add    $0x10,%esp
  802599:	5b                   	pop    %ebx
  80259a:	5e                   	pop    %esi
  80259b:	5d                   	pop    %ebp
  80259c:	c3                   	ret    
  80259d:	00 00                	add    %al,(%eax)
	...

008025a0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	89 c2                	mov    %eax,%edx
  8025a8:	c1 ea 16             	shr    $0x16,%edx
  8025ab:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8025b2:	f6 c2 01             	test   $0x1,%dl
  8025b5:	74 26                	je     8025dd <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8025b7:	c1 e8 0c             	shr    $0xc,%eax
  8025ba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025c1:	a8 01                	test   $0x1,%al
  8025c3:	74 18                	je     8025dd <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8025c5:	c1 e8 0c             	shr    $0xc,%eax
  8025c8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8025cb:	c1 e2 02             	shl    $0x2,%edx
  8025ce:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8025d3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8025d8:	0f b7 c0             	movzwl %ax,%eax
  8025db:	eb 05                	jmp    8025e2 <pageref+0x42>
  8025dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e2:	5d                   	pop    %ebp
  8025e3:	c3                   	ret    
	...

008025f0 <__udivdi3>:
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	57                   	push   %edi
  8025f4:	56                   	push   %esi
  8025f5:	83 ec 10             	sub    $0x10,%esp
  8025f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8025fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fe:	8b 75 10             	mov    0x10(%ebp),%esi
  802601:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802604:	85 c0                	test   %eax,%eax
  802606:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802609:	75 35                	jne    802640 <__udivdi3+0x50>
  80260b:	39 fe                	cmp    %edi,%esi
  80260d:	77 61                	ja     802670 <__udivdi3+0x80>
  80260f:	85 f6                	test   %esi,%esi
  802611:	75 0b                	jne    80261e <__udivdi3+0x2e>
  802613:	b8 01 00 00 00       	mov    $0x1,%eax
  802618:	31 d2                	xor    %edx,%edx
  80261a:	f7 f6                	div    %esi
  80261c:	89 c6                	mov    %eax,%esi
  80261e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802621:	31 d2                	xor    %edx,%edx
  802623:	89 f8                	mov    %edi,%eax
  802625:	f7 f6                	div    %esi
  802627:	89 c7                	mov    %eax,%edi
  802629:	89 c8                	mov    %ecx,%eax
  80262b:	f7 f6                	div    %esi
  80262d:	89 c1                	mov    %eax,%ecx
  80262f:	89 fa                	mov    %edi,%edx
  802631:	89 c8                	mov    %ecx,%eax
  802633:	83 c4 10             	add    $0x10,%esp
  802636:	5e                   	pop    %esi
  802637:	5f                   	pop    %edi
  802638:	5d                   	pop    %ebp
  802639:	c3                   	ret    
  80263a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802640:	39 f8                	cmp    %edi,%eax
  802642:	77 1c                	ja     802660 <__udivdi3+0x70>
  802644:	0f bd d0             	bsr    %eax,%edx
  802647:	83 f2 1f             	xor    $0x1f,%edx
  80264a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80264d:	75 39                	jne    802688 <__udivdi3+0x98>
  80264f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802652:	0f 86 a0 00 00 00    	jbe    8026f8 <__udivdi3+0x108>
  802658:	39 f8                	cmp    %edi,%eax
  80265a:	0f 82 98 00 00 00    	jb     8026f8 <__udivdi3+0x108>
  802660:	31 ff                	xor    %edi,%edi
  802662:	31 c9                	xor    %ecx,%ecx
  802664:	89 c8                	mov    %ecx,%eax
  802666:	89 fa                	mov    %edi,%edx
  802668:	83 c4 10             	add    $0x10,%esp
  80266b:	5e                   	pop    %esi
  80266c:	5f                   	pop    %edi
  80266d:	5d                   	pop    %ebp
  80266e:	c3                   	ret    
  80266f:	90                   	nop
  802670:	89 d1                	mov    %edx,%ecx
  802672:	89 fa                	mov    %edi,%edx
  802674:	89 c8                	mov    %ecx,%eax
  802676:	31 ff                	xor    %edi,%edi
  802678:	f7 f6                	div    %esi
  80267a:	89 c1                	mov    %eax,%ecx
  80267c:	89 fa                	mov    %edi,%edx
  80267e:	89 c8                	mov    %ecx,%eax
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	5e                   	pop    %esi
  802684:	5f                   	pop    %edi
  802685:	5d                   	pop    %ebp
  802686:	c3                   	ret    
  802687:	90                   	nop
  802688:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80268c:	89 f2                	mov    %esi,%edx
  80268e:	d3 e0                	shl    %cl,%eax
  802690:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802693:	b8 20 00 00 00       	mov    $0x20,%eax
  802698:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80269b:	89 c1                	mov    %eax,%ecx
  80269d:	d3 ea                	shr    %cl,%edx
  80269f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026a3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8026a6:	d3 e6                	shl    %cl,%esi
  8026a8:	89 c1                	mov    %eax,%ecx
  8026aa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8026ad:	89 fe                	mov    %edi,%esi
  8026af:	d3 ee                	shr    %cl,%esi
  8026b1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8026b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026bb:	d3 e7                	shl    %cl,%edi
  8026bd:	89 c1                	mov    %eax,%ecx
  8026bf:	d3 ea                	shr    %cl,%edx
  8026c1:	09 d7                	or     %edx,%edi
  8026c3:	89 f2                	mov    %esi,%edx
  8026c5:	89 f8                	mov    %edi,%eax
  8026c7:	f7 75 ec             	divl   -0x14(%ebp)
  8026ca:	89 d6                	mov    %edx,%esi
  8026cc:	89 c7                	mov    %eax,%edi
  8026ce:	f7 65 e8             	mull   -0x18(%ebp)
  8026d1:	39 d6                	cmp    %edx,%esi
  8026d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8026d6:	72 30                	jb     802708 <__udivdi3+0x118>
  8026d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026db:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026df:	d3 e2                	shl    %cl,%edx
  8026e1:	39 c2                	cmp    %eax,%edx
  8026e3:	73 05                	jae    8026ea <__udivdi3+0xfa>
  8026e5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8026e8:	74 1e                	je     802708 <__udivdi3+0x118>
  8026ea:	89 f9                	mov    %edi,%ecx
  8026ec:	31 ff                	xor    %edi,%edi
  8026ee:	e9 71 ff ff ff       	jmp    802664 <__udivdi3+0x74>
  8026f3:	90                   	nop
  8026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f8:	31 ff                	xor    %edi,%edi
  8026fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  8026ff:	e9 60 ff ff ff       	jmp    802664 <__udivdi3+0x74>
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80270b:	31 ff                	xor    %edi,%edi
  80270d:	89 c8                	mov    %ecx,%eax
  80270f:	89 fa                	mov    %edi,%edx
  802711:	83 c4 10             	add    $0x10,%esp
  802714:	5e                   	pop    %esi
  802715:	5f                   	pop    %edi
  802716:	5d                   	pop    %ebp
  802717:	c3                   	ret    
	...

00802720 <__umoddi3>:
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	57                   	push   %edi
  802724:	56                   	push   %esi
  802725:	83 ec 20             	sub    $0x20,%esp
  802728:	8b 55 14             	mov    0x14(%ebp),%edx
  80272b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80272e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802731:	8b 75 0c             	mov    0xc(%ebp),%esi
  802734:	85 d2                	test   %edx,%edx
  802736:	89 c8                	mov    %ecx,%eax
  802738:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80273b:	75 13                	jne    802750 <__umoddi3+0x30>
  80273d:	39 f7                	cmp    %esi,%edi
  80273f:	76 3f                	jbe    802780 <__umoddi3+0x60>
  802741:	89 f2                	mov    %esi,%edx
  802743:	f7 f7                	div    %edi
  802745:	89 d0                	mov    %edx,%eax
  802747:	31 d2                	xor    %edx,%edx
  802749:	83 c4 20             	add    $0x20,%esp
  80274c:	5e                   	pop    %esi
  80274d:	5f                   	pop    %edi
  80274e:	5d                   	pop    %ebp
  80274f:	c3                   	ret    
  802750:	39 f2                	cmp    %esi,%edx
  802752:	77 4c                	ja     8027a0 <__umoddi3+0x80>
  802754:	0f bd ca             	bsr    %edx,%ecx
  802757:	83 f1 1f             	xor    $0x1f,%ecx
  80275a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80275d:	75 51                	jne    8027b0 <__umoddi3+0x90>
  80275f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802762:	0f 87 e0 00 00 00    	ja     802848 <__umoddi3+0x128>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	29 f8                	sub    %edi,%eax
  80276d:	19 d6                	sbb    %edx,%esi
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	89 f2                	mov    %esi,%edx
  802777:	83 c4 20             	add    $0x20,%esp
  80277a:	5e                   	pop    %esi
  80277b:	5f                   	pop    %edi
  80277c:	5d                   	pop    %ebp
  80277d:	c3                   	ret    
  80277e:	66 90                	xchg   %ax,%ax
  802780:	85 ff                	test   %edi,%edi
  802782:	75 0b                	jne    80278f <__umoddi3+0x6f>
  802784:	b8 01 00 00 00       	mov    $0x1,%eax
  802789:	31 d2                	xor    %edx,%edx
  80278b:	f7 f7                	div    %edi
  80278d:	89 c7                	mov    %eax,%edi
  80278f:	89 f0                	mov    %esi,%eax
  802791:	31 d2                	xor    %edx,%edx
  802793:	f7 f7                	div    %edi
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	f7 f7                	div    %edi
  80279a:	eb a9                	jmp    802745 <__umoddi3+0x25>
  80279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027a0:	89 c8                	mov    %ecx,%eax
  8027a2:	89 f2                	mov    %esi,%edx
  8027a4:	83 c4 20             	add    $0x20,%esp
  8027a7:	5e                   	pop    %esi
  8027a8:	5f                   	pop    %edi
  8027a9:	5d                   	pop    %ebp
  8027aa:	c3                   	ret    
  8027ab:	90                   	nop
  8027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027b4:	d3 e2                	shl    %cl,%edx
  8027b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027b9:	ba 20 00 00 00       	mov    $0x20,%edx
  8027be:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8027c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8027c4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027c8:	89 fa                	mov    %edi,%edx
  8027ca:	d3 ea                	shr    %cl,%edx
  8027cc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027d0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8027d3:	d3 e7                	shl    %cl,%edi
  8027d5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027dc:	89 f2                	mov    %esi,%edx
  8027de:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8027e1:	89 c7                	mov    %eax,%edi
  8027e3:	d3 ea                	shr    %cl,%edx
  8027e5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8027ec:	89 c2                	mov    %eax,%edx
  8027ee:	d3 e6                	shl    %cl,%esi
  8027f0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027f4:	d3 ea                	shr    %cl,%edx
  8027f6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027fa:	09 d6                	or     %edx,%esi
  8027fc:	89 f0                	mov    %esi,%eax
  8027fe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802801:	d3 e7                	shl    %cl,%edi
  802803:	89 f2                	mov    %esi,%edx
  802805:	f7 75 f4             	divl   -0xc(%ebp)
  802808:	89 d6                	mov    %edx,%esi
  80280a:	f7 65 e8             	mull   -0x18(%ebp)
  80280d:	39 d6                	cmp    %edx,%esi
  80280f:	72 2b                	jb     80283c <__umoddi3+0x11c>
  802811:	39 c7                	cmp    %eax,%edi
  802813:	72 23                	jb     802838 <__umoddi3+0x118>
  802815:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802819:	29 c7                	sub    %eax,%edi
  80281b:	19 d6                	sbb    %edx,%esi
  80281d:	89 f0                	mov    %esi,%eax
  80281f:	89 f2                	mov    %esi,%edx
  802821:	d3 ef                	shr    %cl,%edi
  802823:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802827:	d3 e0                	shl    %cl,%eax
  802829:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80282d:	09 f8                	or     %edi,%eax
  80282f:	d3 ea                	shr    %cl,%edx
  802831:	83 c4 20             	add    $0x20,%esp
  802834:	5e                   	pop    %esi
  802835:	5f                   	pop    %edi
  802836:	5d                   	pop    %ebp
  802837:	c3                   	ret    
  802838:	39 d6                	cmp    %edx,%esi
  80283a:	75 d9                	jne    802815 <__umoddi3+0xf5>
  80283c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80283f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802842:	eb d1                	jmp    802815 <__umoddi3+0xf5>
  802844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802848:	39 f2                	cmp    %esi,%edx
  80284a:	0f 82 18 ff ff ff    	jb     802768 <__umoddi3+0x48>
  802850:	e9 1d ff ff ff       	jmp    802772 <__umoddi3+0x52>
