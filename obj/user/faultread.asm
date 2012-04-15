
obj/user/faultread:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
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
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  80003a:	a1 00 00 00 00       	mov    0x0,%eax
  80003f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800043:	c7 04 24 e0 27 80 00 	movl   $0x8027e0,(%esp)
  80004a:	e8 d2 00 00 00       	call   800121 <cprintf>
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    
  800051:	00 00                	add    %al,(%eax)
	...

00800054 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
  80005a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80005d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800060:	8b 75 08             	mov    0x8(%ebp),%esi
  800063:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800066:	e8 f3 0f 00 00       	call   80105e <sys_getenvid>
	env = &envs[ENVX(envid)];
  80006b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800070:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800073:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800078:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007d:	85 f6                	test   %esi,%esi
  80007f:	7e 07                	jle    800088 <libmain+0x34>
		binaryname = argv[0];
  800081:	8b 03                	mov    (%ebx),%eax
  800083:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800088:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008c:	89 34 24             	mov    %esi,(%esp)
  80008f:	e8 a0 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800094:	e8 0b 00 00 00       	call   8000a4 <exit>
}
  800099:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80009c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80009f:	89 ec                	mov    %ebp,%esp
  8000a1:	5d                   	pop    %ebp
  8000a2:	c3                   	ret    
	...

008000a4 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000aa:	e8 1c 15 00 00       	call   8015cb <close_all>
	sys_env_destroy(0);
  8000af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b6:	e8 d7 0f 00 00       	call   801092 <sys_env_destroy>
}
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    
  8000bd:	00 00                	add    %al,(%eax)
	...

008000c0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8000c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000d0:	00 00 00 
	b.cnt = 0;
  8000d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8000e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8000f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f5:	c7 04 24 3b 01 80 00 	movl   $0x80013b,(%esp)
  8000fc:	e8 cc 01 00 00       	call   8002cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800101:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800107:	89 44 24 04          	mov    %eax,0x4(%esp)
  80010b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800111:	89 04 24             	mov    %eax,(%esp)
  800114:	e8 b7 0a 00 00       	call   800bd0 <sys_cputs>

	return b.cnt;
}
  800119:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80011f:	c9                   	leave  
  800120:	c3                   	ret    

00800121 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800127:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80012a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012e:	8b 45 08             	mov    0x8(%ebp),%eax
  800131:	89 04 24             	mov    %eax,(%esp)
  800134:	e8 87 ff ff ff       	call   8000c0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	53                   	push   %ebx
  80013f:	83 ec 14             	sub    $0x14,%esp
  800142:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800145:	8b 03                	mov    (%ebx),%eax
  800147:	8b 55 08             	mov    0x8(%ebp),%edx
  80014a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80014e:	83 c0 01             	add    $0x1,%eax
  800151:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800153:	3d ff 00 00 00       	cmp    $0xff,%eax
  800158:	75 19                	jne    800173 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80015a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800161:	00 
  800162:	8d 43 08             	lea    0x8(%ebx),%eax
  800165:	89 04 24             	mov    %eax,(%esp)
  800168:	e8 63 0a 00 00       	call   800bd0 <sys_cputs>
		b->idx = 0;
  80016d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800173:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800177:	83 c4 14             	add    $0x14,%esp
  80017a:	5b                   	pop    %ebx
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    
  80017d:	00 00                	add    %al,(%eax)
	...

00800180 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 4c             	sub    $0x4c,%esp
  800189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80018c:	89 d6                	mov    %edx,%esi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800194:	8b 55 0c             	mov    0xc(%ebp),%edx
  800197:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80019a:	8b 45 10             	mov    0x10(%ebp),%eax
  80019d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001a0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001ab:	39 d1                	cmp    %edx,%ecx
  8001ad:	72 15                	jb     8001c4 <printnum+0x44>
  8001af:	77 07                	ja     8001b8 <printnum+0x38>
  8001b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001b4:	39 d0                	cmp    %edx,%eax
  8001b6:	76 0c                	jbe    8001c4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001b8:	83 eb 01             	sub    $0x1,%ebx
  8001bb:	85 db                	test   %ebx,%ebx
  8001bd:	8d 76 00             	lea    0x0(%esi),%esi
  8001c0:	7f 61                	jg     800223 <printnum+0xa3>
  8001c2:	eb 70                	jmp    800234 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8001c8:	83 eb 01             	sub    $0x1,%ebx
  8001cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8001d7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8001db:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8001de:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8001e1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001ef:	00 
  8001f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001fd:	e8 6e 23 00 00       	call   802570 <__udivdi3>
  800202:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800205:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800208:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80020c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800210:	89 04 24             	mov    %eax,(%esp)
  800213:	89 54 24 04          	mov    %edx,0x4(%esp)
  800217:	89 f2                	mov    %esi,%edx
  800219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80021c:	e8 5f ff ff ff       	call   800180 <printnum>
  800221:	eb 11                	jmp    800234 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800223:	89 74 24 04          	mov    %esi,0x4(%esp)
  800227:	89 3c 24             	mov    %edi,(%esp)
  80022a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80022d:	83 eb 01             	sub    $0x1,%ebx
  800230:	85 db                	test   %ebx,%ebx
  800232:	7f ef                	jg     800223 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800234:	89 74 24 04          	mov    %esi,0x4(%esp)
  800238:	8b 74 24 04          	mov    0x4(%esp),%esi
  80023c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800243:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80024a:	00 
  80024b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80024e:	89 14 24             	mov    %edx,(%esp)
  800251:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800254:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800258:	e8 43 24 00 00       	call   8026a0 <__umoddi3>
  80025d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800261:	0f be 80 15 28 80 00 	movsbl 0x802815(%eax),%eax
  800268:	89 04 24             	mov    %eax,(%esp)
  80026b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80026e:	83 c4 4c             	add    $0x4c,%esp
  800271:	5b                   	pop    %ebx
  800272:	5e                   	pop    %esi
  800273:	5f                   	pop    %edi
  800274:	5d                   	pop    %ebp
  800275:	c3                   	ret    

00800276 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800279:	83 fa 01             	cmp    $0x1,%edx
  80027c:	7e 0e                	jle    80028c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80027e:	8b 10                	mov    (%eax),%edx
  800280:	8d 4a 08             	lea    0x8(%edx),%ecx
  800283:	89 08                	mov    %ecx,(%eax)
  800285:	8b 02                	mov    (%edx),%eax
  800287:	8b 52 04             	mov    0x4(%edx),%edx
  80028a:	eb 22                	jmp    8002ae <getuint+0x38>
	else if (lflag)
  80028c:	85 d2                	test   %edx,%edx
  80028e:	74 10                	je     8002a0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800290:	8b 10                	mov    (%eax),%edx
  800292:	8d 4a 04             	lea    0x4(%edx),%ecx
  800295:	89 08                	mov    %ecx,(%eax)
  800297:	8b 02                	mov    (%edx),%eax
  800299:	ba 00 00 00 00       	mov    $0x0,%edx
  80029e:	eb 0e                	jmp    8002ae <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002a0:	8b 10                	mov    (%eax),%edx
  8002a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002a5:	89 08                	mov    %ecx,(%eax)
  8002a7:	8b 02                	mov    (%edx),%eax
  8002a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ba:	8b 10                	mov    (%eax),%edx
  8002bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002bf:	73 0a                	jae    8002cb <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c4:	88 0a                	mov    %cl,(%edx)
  8002c6:	83 c2 01             	add    $0x1,%edx
  8002c9:	89 10                	mov    %edx,(%eax)
}
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	57                   	push   %edi
  8002d1:	56                   	push   %esi
  8002d2:	53                   	push   %ebx
  8002d3:	83 ec 5c             	sub    $0x5c,%esp
  8002d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8002df:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8002e6:	eb 11                	jmp    8002f9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002e8:	85 c0                	test   %eax,%eax
  8002ea:	0f 84 ec 03 00 00    	je     8006dc <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8002f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002f4:	89 04 24             	mov    %eax,(%esp)
  8002f7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002f9:	0f b6 03             	movzbl (%ebx),%eax
  8002fc:	83 c3 01             	add    $0x1,%ebx
  8002ff:	83 f8 25             	cmp    $0x25,%eax
  800302:	75 e4                	jne    8002e8 <vprintfmt+0x1b>
  800304:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800308:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80030f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800316:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80031d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800322:	eb 06                	jmp    80032a <vprintfmt+0x5d>
  800324:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800328:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	0f b6 13             	movzbl (%ebx),%edx
  80032d:	0f b6 c2             	movzbl %dl,%eax
  800330:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800333:	8d 43 01             	lea    0x1(%ebx),%eax
  800336:	83 ea 23             	sub    $0x23,%edx
  800339:	80 fa 55             	cmp    $0x55,%dl
  80033c:	0f 87 7d 03 00 00    	ja     8006bf <vprintfmt+0x3f2>
  800342:	0f b6 d2             	movzbl %dl,%edx
  800345:	ff 24 95 60 29 80 00 	jmp    *0x802960(,%edx,4)
  80034c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800350:	eb d6                	jmp    800328 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800352:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800355:	83 ea 30             	sub    $0x30,%edx
  800358:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80035b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80035e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800361:	83 fb 09             	cmp    $0x9,%ebx
  800364:	77 4c                	ja     8003b2 <vprintfmt+0xe5>
  800366:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800369:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80036c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80036f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800372:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800376:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800379:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80037c:	83 fb 09             	cmp    $0x9,%ebx
  80037f:	76 eb                	jbe    80036c <vprintfmt+0x9f>
  800381:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800384:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800387:	eb 29                	jmp    8003b2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800389:	8b 55 14             	mov    0x14(%ebp),%edx
  80038c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80038f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800392:	8b 12                	mov    (%edx),%edx
  800394:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800397:	eb 19                	jmp    8003b2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80039c:	c1 fa 1f             	sar    $0x1f,%edx
  80039f:	f7 d2                	not    %edx
  8003a1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8003a4:	eb 82                	jmp    800328 <vprintfmt+0x5b>
  8003a6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003ad:	e9 76 ff ff ff       	jmp    800328 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8003b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003b6:	0f 89 6c ff ff ff    	jns    800328 <vprintfmt+0x5b>
  8003bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8003bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8003c5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8003c8:	e9 5b ff ff ff       	jmp    800328 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003cd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8003d0:	e9 53 ff ff ff       	jmp    800328 <vprintfmt+0x5b>
  8003d5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	8d 50 04             	lea    0x4(%eax),%edx
  8003de:	89 55 14             	mov    %edx,0x14(%ebp)
  8003e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 04 24             	mov    %eax,(%esp)
  8003ea:	ff d7                	call   *%edi
  8003ec:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8003ef:	e9 05 ff ff ff       	jmp    8002f9 <vprintfmt+0x2c>
  8003f4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fa:	8d 50 04             	lea    0x4(%eax),%edx
  8003fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800400:	8b 00                	mov    (%eax),%eax
  800402:	89 c2                	mov    %eax,%edx
  800404:	c1 fa 1f             	sar    $0x1f,%edx
  800407:	31 d0                	xor    %edx,%eax
  800409:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80040b:	83 f8 0f             	cmp    $0xf,%eax
  80040e:	7f 0b                	jg     80041b <vprintfmt+0x14e>
  800410:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  800417:	85 d2                	test   %edx,%edx
  800419:	75 20                	jne    80043b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80041b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80041f:	c7 44 24 08 26 28 80 	movl   $0x802826,0x8(%esp)
  800426:	00 
  800427:	89 74 24 04          	mov    %esi,0x4(%esp)
  80042b:	89 3c 24             	mov    %edi,(%esp)
  80042e:	e8 31 03 00 00       	call   800764 <printfmt>
  800433:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800436:	e9 be fe ff ff       	jmp    8002f9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80043b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80043f:	c7 44 24 08 06 2c 80 	movl   $0x802c06,0x8(%esp)
  800446:	00 
  800447:	89 74 24 04          	mov    %esi,0x4(%esp)
  80044b:	89 3c 24             	mov    %edi,(%esp)
  80044e:	e8 11 03 00 00       	call   800764 <printfmt>
  800453:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800456:	e9 9e fe ff ff       	jmp    8002f9 <vprintfmt+0x2c>
  80045b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80045e:	89 c3                	mov    %eax,%ebx
  800460:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800466:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800469:	8b 45 14             	mov    0x14(%ebp),%eax
  80046c:	8d 50 04             	lea    0x4(%eax),%edx
  80046f:	89 55 14             	mov    %edx,0x14(%ebp)
  800472:	8b 00                	mov    (%eax),%eax
  800474:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800477:	85 c0                	test   %eax,%eax
  800479:	75 07                	jne    800482 <vprintfmt+0x1b5>
  80047b:	c7 45 e0 2f 28 80 00 	movl   $0x80282f,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800482:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800486:	7e 06                	jle    80048e <vprintfmt+0x1c1>
  800488:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80048c:	75 13                	jne    8004a1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80048e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800491:	0f be 02             	movsbl (%edx),%eax
  800494:	85 c0                	test   %eax,%eax
  800496:	0f 85 99 00 00 00    	jne    800535 <vprintfmt+0x268>
  80049c:	e9 86 00 00 00       	jmp    800527 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a8:	89 0c 24             	mov    %ecx,(%esp)
  8004ab:	e8 fb 02 00 00       	call   8007ab <strnlen>
  8004b0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004b3:	29 c2                	sub    %eax,%edx
  8004b5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004b8:	85 d2                	test   %edx,%edx
  8004ba:	7e d2                	jle    80048e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8004bc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8004c0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004c3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8004c6:	89 d3                	mov    %edx,%ebx
  8004c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004cf:	89 04 24             	mov    %eax,(%esp)
  8004d2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d4:	83 eb 01             	sub    $0x1,%ebx
  8004d7:	85 db                	test   %ebx,%ebx
  8004d9:	7f ed                	jg     8004c8 <vprintfmt+0x1fb>
  8004db:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004e5:	eb a7                	jmp    80048e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004eb:	74 18                	je     800505 <vprintfmt+0x238>
  8004ed:	8d 50 e0             	lea    -0x20(%eax),%edx
  8004f0:	83 fa 5e             	cmp    $0x5e,%edx
  8004f3:	76 10                	jbe    800505 <vprintfmt+0x238>
					putch('?', putdat);
  8004f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800500:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800503:	eb 0a                	jmp    80050f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800505:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800509:	89 04 24             	mov    %eax,(%esp)
  80050c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800513:	0f be 03             	movsbl (%ebx),%eax
  800516:	85 c0                	test   %eax,%eax
  800518:	74 05                	je     80051f <vprintfmt+0x252>
  80051a:	83 c3 01             	add    $0x1,%ebx
  80051d:	eb 29                	jmp    800548 <vprintfmt+0x27b>
  80051f:	89 fe                	mov    %edi,%esi
  800521:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800524:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800527:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80052b:	7f 2e                	jg     80055b <vprintfmt+0x28e>
  80052d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800530:	e9 c4 fd ff ff       	jmp    8002f9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800535:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800538:	83 c2 01             	add    $0x1,%edx
  80053b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80053e:	89 f7                	mov    %esi,%edi
  800540:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800543:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800546:	89 d3                	mov    %edx,%ebx
  800548:	85 f6                	test   %esi,%esi
  80054a:	78 9b                	js     8004e7 <vprintfmt+0x21a>
  80054c:	83 ee 01             	sub    $0x1,%esi
  80054f:	79 96                	jns    8004e7 <vprintfmt+0x21a>
  800551:	89 fe                	mov    %edi,%esi
  800553:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800556:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800559:	eb cc                	jmp    800527 <vprintfmt+0x25a>
  80055b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80055e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800561:	89 74 24 04          	mov    %esi,0x4(%esp)
  800565:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80056c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80056e:	83 eb 01             	sub    $0x1,%ebx
  800571:	85 db                	test   %ebx,%ebx
  800573:	7f ec                	jg     800561 <vprintfmt+0x294>
  800575:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800578:	e9 7c fd ff ff       	jmp    8002f9 <vprintfmt+0x2c>
  80057d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800580:	83 f9 01             	cmp    $0x1,%ecx
  800583:	7e 16                	jle    80059b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 50 08             	lea    0x8(%eax),%edx
  80058b:	89 55 14             	mov    %edx,0x14(%ebp)
  80058e:	8b 10                	mov    (%eax),%edx
  800590:	8b 48 04             	mov    0x4(%eax),%ecx
  800593:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800596:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800599:	eb 32                	jmp    8005cd <vprintfmt+0x300>
	else if (lflag)
  80059b:	85 c9                	test   %ecx,%ecx
  80059d:	74 18                	je     8005b7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8d 50 04             	lea    0x4(%eax),%edx
  8005a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ad:	89 c1                	mov    %eax,%ecx
  8005af:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b5:	eb 16                	jmp    8005cd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 50 04             	lea    0x4(%eax),%edx
  8005bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c5:	89 c2                	mov    %eax,%edx
  8005c7:	c1 fa 1f             	sar    $0x1f,%edx
  8005ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005cd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005d0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005d3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005dc:	0f 89 9b 00 00 00    	jns    80067d <vprintfmt+0x3b0>
				putch('-', putdat);
  8005e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005ed:	ff d7                	call   *%edi
				num = -(long long) num;
  8005ef:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005f2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005f5:	f7 d9                	neg    %ecx
  8005f7:	83 d3 00             	adc    $0x0,%ebx
  8005fa:	f7 db                	neg    %ebx
  8005fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800601:	eb 7a                	jmp    80067d <vprintfmt+0x3b0>
  800603:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800606:	89 ca                	mov    %ecx,%edx
  800608:	8d 45 14             	lea    0x14(%ebp),%eax
  80060b:	e8 66 fc ff ff       	call   800276 <getuint>
  800610:	89 c1                	mov    %eax,%ecx
  800612:	89 d3                	mov    %edx,%ebx
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800619:	eb 62                	jmp    80067d <vprintfmt+0x3b0>
  80061b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80061e:	89 ca                	mov    %ecx,%edx
  800620:	8d 45 14             	lea    0x14(%ebp),%eax
  800623:	e8 4e fc ff ff       	call   800276 <getuint>
  800628:	89 c1                	mov    %eax,%ecx
  80062a:	89 d3                	mov    %edx,%ebx
  80062c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800631:	eb 4a                	jmp    80067d <vprintfmt+0x3b0>
  800633:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800636:	89 74 24 04          	mov    %esi,0x4(%esp)
  80063a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800641:	ff d7                	call   *%edi
			putch('x', putdat);
  800643:	89 74 24 04          	mov    %esi,0x4(%esp)
  800647:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80064e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	89 55 14             	mov    %edx,0x14(%ebp)
  800659:	8b 08                	mov    (%eax),%ecx
  80065b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800660:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800665:	eb 16                	jmp    80067d <vprintfmt+0x3b0>
  800667:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80066a:	89 ca                	mov    %ecx,%edx
  80066c:	8d 45 14             	lea    0x14(%ebp),%eax
  80066f:	e8 02 fc ff ff       	call   800276 <getuint>
  800674:	89 c1                	mov    %eax,%ecx
  800676:	89 d3                	mov    %edx,%ebx
  800678:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80067d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800681:	89 54 24 10          	mov    %edx,0x10(%esp)
  800685:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800688:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80068c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800690:	89 0c 24             	mov    %ecx,(%esp)
  800693:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800697:	89 f2                	mov    %esi,%edx
  800699:	89 f8                	mov    %edi,%eax
  80069b:	e8 e0 fa ff ff       	call   800180 <printnum>
  8006a0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006a3:	e9 51 fc ff ff       	jmp    8002f9 <vprintfmt+0x2c>
  8006a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8006ab:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006b2:	89 14 24             	mov    %edx,(%esp)
  8006b5:	ff d7                	call   *%edi
  8006b7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006ba:	e9 3a fc ff ff       	jmp    8002f9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006ca:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8006cf:	80 38 25             	cmpb   $0x25,(%eax)
  8006d2:	0f 84 21 fc ff ff    	je     8002f9 <vprintfmt+0x2c>
  8006d8:	89 c3                	mov    %eax,%ebx
  8006da:	eb f0                	jmp    8006cc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8006dc:	83 c4 5c             	add    $0x5c,%esp
  8006df:	5b                   	pop    %ebx
  8006e0:	5e                   	pop    %esi
  8006e1:	5f                   	pop    %edi
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 28             	sub    $0x28,%esp
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	74 04                	je     8006f8 <vsnprintf+0x14>
  8006f4:	85 d2                	test   %edx,%edx
  8006f6:	7f 07                	jg     8006ff <vsnprintf+0x1b>
  8006f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fd:	eb 3b                	jmp    80073a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800702:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800709:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800717:	8b 45 10             	mov    0x10(%ebp),%eax
  80071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80071e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800721:	89 44 24 04          	mov    %eax,0x4(%esp)
  800725:	c7 04 24 b0 02 80 00 	movl   $0x8002b0,(%esp)
  80072c:	e8 9c fb ff ff       	call   8002cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800734:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800737:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800742:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800745:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800749:	8b 45 10             	mov    0x10(%ebp),%eax
  80074c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800750:	8b 45 0c             	mov    0xc(%ebp),%eax
  800753:	89 44 24 04          	mov    %eax,0x4(%esp)
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 04 24             	mov    %eax,(%esp)
  80075d:	e8 82 ff ff ff       	call   8006e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800762:	c9                   	leave  
  800763:	c3                   	ret    

00800764 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80076a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80076d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800771:	8b 45 10             	mov    0x10(%ebp),%eax
  800774:	89 44 24 08          	mov    %eax,0x8(%esp)
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	89 04 24             	mov    %eax,(%esp)
  800785:	e8 43 fb ff ff       	call   8002cd <vprintfmt>
	va_end(ap);
}
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    
  80078c:	00 00                	add    %al,(%eax)
	...

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
  80079b:	80 3a 00             	cmpb   $0x0,(%edx)
  80079e:	74 09                	je     8007a9 <strlen+0x19>
		n++;
  8007a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a7:	75 f7                	jne    8007a0 <strlen+0x10>
		n++;
	return n;
}
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b5:	85 c9                	test   %ecx,%ecx
  8007b7:	74 19                	je     8007d2 <strnlen+0x27>
  8007b9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007bc:	74 14                	je     8007d2 <strnlen+0x27>
  8007be:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8007c3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c6:	39 c8                	cmp    %ecx,%eax
  8007c8:	74 0d                	je     8007d7 <strnlen+0x2c>
  8007ca:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8007ce:	75 f3                	jne    8007c3 <strnlen+0x18>
  8007d0:	eb 05                	jmp    8007d7 <strnlen+0x2c>
  8007d2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8007d7:	5b                   	pop    %ebx
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	53                   	push   %ebx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007e4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007ed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8007f0:	83 c2 01             	add    $0x1,%edx
  8007f3:	84 c9                	test   %cl,%cl
  8007f5:	75 f2                	jne    8007e9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8007f7:	5b                   	pop    %ebx
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	56                   	push   %esi
  8007fe:	53                   	push   %ebx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 55 0c             	mov    0xc(%ebp),%edx
  800805:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800808:	85 f6                	test   %esi,%esi
  80080a:	74 18                	je     800824 <strncpy+0x2a>
  80080c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800811:	0f b6 1a             	movzbl (%edx),%ebx
  800814:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800817:	80 3a 01             	cmpb   $0x1,(%edx)
  80081a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80081d:	83 c1 01             	add    $0x1,%ecx
  800820:	39 ce                	cmp    %ecx,%esi
  800822:	77 ed                	ja     800811 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800824:	5b                   	pop    %ebx
  800825:	5e                   	pop    %esi
  800826:	5d                   	pop    %ebp
  800827:	c3                   	ret    

00800828 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	56                   	push   %esi
  80082c:	53                   	push   %ebx
  80082d:	8b 75 08             	mov    0x8(%ebp),%esi
  800830:	8b 55 0c             	mov    0xc(%ebp),%edx
  800833:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800836:	89 f0                	mov    %esi,%eax
  800838:	85 c9                	test   %ecx,%ecx
  80083a:	74 27                	je     800863 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80083c:	83 e9 01             	sub    $0x1,%ecx
  80083f:	74 1d                	je     80085e <strlcpy+0x36>
  800841:	0f b6 1a             	movzbl (%edx),%ebx
  800844:	84 db                	test   %bl,%bl
  800846:	74 16                	je     80085e <strlcpy+0x36>
			*dst++ = *src++;
  800848:	88 18                	mov    %bl,(%eax)
  80084a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80084d:	83 e9 01             	sub    $0x1,%ecx
  800850:	74 0e                	je     800860 <strlcpy+0x38>
			*dst++ = *src++;
  800852:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800855:	0f b6 1a             	movzbl (%edx),%ebx
  800858:	84 db                	test   %bl,%bl
  80085a:	75 ec                	jne    800848 <strlcpy+0x20>
  80085c:	eb 02                	jmp    800860 <strlcpy+0x38>
  80085e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800860:	c6 00 00             	movb   $0x0,(%eax)
  800863:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800865:	5b                   	pop    %ebx
  800866:	5e                   	pop    %esi
  800867:	5d                   	pop    %ebp
  800868:	c3                   	ret    

00800869 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800872:	0f b6 01             	movzbl (%ecx),%eax
  800875:	84 c0                	test   %al,%al
  800877:	74 15                	je     80088e <strcmp+0x25>
  800879:	3a 02                	cmp    (%edx),%al
  80087b:	75 11                	jne    80088e <strcmp+0x25>
		p++, q++;
  80087d:	83 c1 01             	add    $0x1,%ecx
  800880:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800883:	0f b6 01             	movzbl (%ecx),%eax
  800886:	84 c0                	test   %al,%al
  800888:	74 04                	je     80088e <strcmp+0x25>
  80088a:	3a 02                	cmp    (%edx),%al
  80088c:	74 ef                	je     80087d <strcmp+0x14>
  80088e:	0f b6 c0             	movzbl %al,%eax
  800891:	0f b6 12             	movzbl (%edx),%edx
  800894:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	53                   	push   %ebx
  80089c:	8b 55 08             	mov    0x8(%ebp),%edx
  80089f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	74 23                	je     8008cc <strncmp+0x34>
  8008a9:	0f b6 1a             	movzbl (%edx),%ebx
  8008ac:	84 db                	test   %bl,%bl
  8008ae:	74 24                	je     8008d4 <strncmp+0x3c>
  8008b0:	3a 19                	cmp    (%ecx),%bl
  8008b2:	75 20                	jne    8008d4 <strncmp+0x3c>
  8008b4:	83 e8 01             	sub    $0x1,%eax
  8008b7:	74 13                	je     8008cc <strncmp+0x34>
		n--, p++, q++;
  8008b9:	83 c2 01             	add    $0x1,%edx
  8008bc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008bf:	0f b6 1a             	movzbl (%edx),%ebx
  8008c2:	84 db                	test   %bl,%bl
  8008c4:	74 0e                	je     8008d4 <strncmp+0x3c>
  8008c6:	3a 19                	cmp    (%ecx),%bl
  8008c8:	74 ea                	je     8008b4 <strncmp+0x1c>
  8008ca:	eb 08                	jmp    8008d4 <strncmp+0x3c>
  8008cc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008d1:	5b                   	pop    %ebx
  8008d2:	5d                   	pop    %ebp
  8008d3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d4:	0f b6 02             	movzbl (%edx),%eax
  8008d7:	0f b6 11             	movzbl (%ecx),%edx
  8008da:	29 d0                	sub    %edx,%eax
  8008dc:	eb f3                	jmp    8008d1 <strncmp+0x39>

008008de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e8:	0f b6 10             	movzbl (%eax),%edx
  8008eb:	84 d2                	test   %dl,%dl
  8008ed:	74 15                	je     800904 <strchr+0x26>
		if (*s == c)
  8008ef:	38 ca                	cmp    %cl,%dl
  8008f1:	75 07                	jne    8008fa <strchr+0x1c>
  8008f3:	eb 14                	jmp    800909 <strchr+0x2b>
  8008f5:	38 ca                	cmp    %cl,%dl
  8008f7:	90                   	nop
  8008f8:	74 0f                	je     800909 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 10             	movzbl (%eax),%edx
  800900:	84 d2                	test   %dl,%dl
  800902:	75 f1                	jne    8008f5 <strchr+0x17>
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800915:	0f b6 10             	movzbl (%eax),%edx
  800918:	84 d2                	test   %dl,%dl
  80091a:	74 18                	je     800934 <strfind+0x29>
		if (*s == c)
  80091c:	38 ca                	cmp    %cl,%dl
  80091e:	75 0a                	jne    80092a <strfind+0x1f>
  800920:	eb 12                	jmp    800934 <strfind+0x29>
  800922:	38 ca                	cmp    %cl,%dl
  800924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800928:	74 0a                	je     800934 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80092a:	83 c0 01             	add    $0x1,%eax
  80092d:	0f b6 10             	movzbl (%eax),%edx
  800930:	84 d2                	test   %dl,%dl
  800932:	75 ee                	jne    800922 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    

00800936 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	83 ec 0c             	sub    $0xc,%esp
  80093c:	89 1c 24             	mov    %ebx,(%esp)
  80093f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800943:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800947:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800950:	85 c9                	test   %ecx,%ecx
  800952:	74 30                	je     800984 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800954:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80095a:	75 25                	jne    800981 <memset+0x4b>
  80095c:	f6 c1 03             	test   $0x3,%cl
  80095f:	75 20                	jne    800981 <memset+0x4b>
		c &= 0xFF;
  800961:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800964:	89 d3                	mov    %edx,%ebx
  800966:	c1 e3 08             	shl    $0x8,%ebx
  800969:	89 d6                	mov    %edx,%esi
  80096b:	c1 e6 18             	shl    $0x18,%esi
  80096e:	89 d0                	mov    %edx,%eax
  800970:	c1 e0 10             	shl    $0x10,%eax
  800973:	09 f0                	or     %esi,%eax
  800975:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800977:	09 d8                	or     %ebx,%eax
  800979:	c1 e9 02             	shr    $0x2,%ecx
  80097c:	fc                   	cld    
  80097d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097f:	eb 03                	jmp    800984 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800981:	fc                   	cld    
  800982:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800984:	89 f8                	mov    %edi,%eax
  800986:	8b 1c 24             	mov    (%esp),%ebx
  800989:	8b 74 24 04          	mov    0x4(%esp),%esi
  80098d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800991:	89 ec                	mov    %ebp,%esp
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	89 34 24             	mov    %esi,(%esp)
  80099e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8009a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009ab:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009ad:	39 c6                	cmp    %eax,%esi
  8009af:	73 35                	jae    8009e6 <memmove+0x51>
  8009b1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b4:	39 d0                	cmp    %edx,%eax
  8009b6:	73 2e                	jae    8009e6 <memmove+0x51>
		s += n;
		d += n;
  8009b8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ba:	f6 c2 03             	test   $0x3,%dl
  8009bd:	75 1b                	jne    8009da <memmove+0x45>
  8009bf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009c5:	75 13                	jne    8009da <memmove+0x45>
  8009c7:	f6 c1 03             	test   $0x3,%cl
  8009ca:	75 0e                	jne    8009da <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8009cc:	83 ef 04             	sub    $0x4,%edi
  8009cf:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d2:	c1 e9 02             	shr    $0x2,%ecx
  8009d5:	fd                   	std    
  8009d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d8:	eb 09                	jmp    8009e3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009da:	83 ef 01             	sub    $0x1,%edi
  8009dd:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009e0:	fd                   	std    
  8009e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e4:	eb 20                	jmp    800a06 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ec:	75 15                	jne    800a03 <memmove+0x6e>
  8009ee:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009f4:	75 0d                	jne    800a03 <memmove+0x6e>
  8009f6:	f6 c1 03             	test   $0x3,%cl
  8009f9:	75 08                	jne    800a03 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8009fb:	c1 e9 02             	shr    $0x2,%ecx
  8009fe:	fc                   	cld    
  8009ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a01:	eb 03                	jmp    800a06 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a03:	fc                   	cld    
  800a04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a06:	8b 34 24             	mov    (%esp),%esi
  800a09:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a0d:	89 ec                	mov    %ebp,%esp
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a17:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	89 04 24             	mov    %eax,(%esp)
  800a2b:	e8 65 ff ff ff       	call   800995 <memmove>
}
  800a30:	c9                   	leave  
  800a31:	c3                   	ret    

00800a32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	57                   	push   %edi
  800a36:	56                   	push   %esi
  800a37:	53                   	push   %ebx
  800a38:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a41:	85 c9                	test   %ecx,%ecx
  800a43:	74 36                	je     800a7b <memcmp+0x49>
		if (*s1 != *s2)
  800a45:	0f b6 06             	movzbl (%esi),%eax
  800a48:	0f b6 1f             	movzbl (%edi),%ebx
  800a4b:	38 d8                	cmp    %bl,%al
  800a4d:	74 20                	je     800a6f <memcmp+0x3d>
  800a4f:	eb 14                	jmp    800a65 <memcmp+0x33>
  800a51:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800a56:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800a5b:	83 c2 01             	add    $0x1,%edx
  800a5e:	83 e9 01             	sub    $0x1,%ecx
  800a61:	38 d8                	cmp    %bl,%al
  800a63:	74 12                	je     800a77 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800a65:	0f b6 c0             	movzbl %al,%eax
  800a68:	0f b6 db             	movzbl %bl,%ebx
  800a6b:	29 d8                	sub    %ebx,%eax
  800a6d:	eb 11                	jmp    800a80 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6f:	83 e9 01             	sub    $0x1,%ecx
  800a72:	ba 00 00 00 00       	mov    $0x0,%edx
  800a77:	85 c9                	test   %ecx,%ecx
  800a79:	75 d6                	jne    800a51 <memcmp+0x1f>
  800a7b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a80:	5b                   	pop    %ebx
  800a81:	5e                   	pop    %esi
  800a82:	5f                   	pop    %edi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a8b:	89 c2                	mov    %eax,%edx
  800a8d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a90:	39 d0                	cmp    %edx,%eax
  800a92:	73 15                	jae    800aa9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800a98:	38 08                	cmp    %cl,(%eax)
  800a9a:	75 06                	jne    800aa2 <memfind+0x1d>
  800a9c:	eb 0b                	jmp    800aa9 <memfind+0x24>
  800a9e:	38 08                	cmp    %cl,(%eax)
  800aa0:	74 07                	je     800aa9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aa2:	83 c0 01             	add    $0x1,%eax
  800aa5:	39 c2                	cmp    %eax,%edx
  800aa7:	77 f5                	ja     800a9e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	57                   	push   %edi
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aba:	0f b6 02             	movzbl (%edx),%eax
  800abd:	3c 20                	cmp    $0x20,%al
  800abf:	74 04                	je     800ac5 <strtol+0x1a>
  800ac1:	3c 09                	cmp    $0x9,%al
  800ac3:	75 0e                	jne    800ad3 <strtol+0x28>
		s++;
  800ac5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac8:	0f b6 02             	movzbl (%edx),%eax
  800acb:	3c 20                	cmp    $0x20,%al
  800acd:	74 f6                	je     800ac5 <strtol+0x1a>
  800acf:	3c 09                	cmp    $0x9,%al
  800ad1:	74 f2                	je     800ac5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ad3:	3c 2b                	cmp    $0x2b,%al
  800ad5:	75 0c                	jne    800ae3 <strtol+0x38>
		s++;
  800ad7:	83 c2 01             	add    $0x1,%edx
  800ada:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ae1:	eb 15                	jmp    800af8 <strtol+0x4d>
	else if (*s == '-')
  800ae3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800aea:	3c 2d                	cmp    $0x2d,%al
  800aec:	75 0a                	jne    800af8 <strtol+0x4d>
		s++, neg = 1;
  800aee:	83 c2 01             	add    $0x1,%edx
  800af1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af8:	85 db                	test   %ebx,%ebx
  800afa:	0f 94 c0             	sete   %al
  800afd:	74 05                	je     800b04 <strtol+0x59>
  800aff:	83 fb 10             	cmp    $0x10,%ebx
  800b02:	75 18                	jne    800b1c <strtol+0x71>
  800b04:	80 3a 30             	cmpb   $0x30,(%edx)
  800b07:	75 13                	jne    800b1c <strtol+0x71>
  800b09:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b0d:	8d 76 00             	lea    0x0(%esi),%esi
  800b10:	75 0a                	jne    800b1c <strtol+0x71>
		s += 2, base = 16;
  800b12:	83 c2 02             	add    $0x2,%edx
  800b15:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1a:	eb 15                	jmp    800b31 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b1c:	84 c0                	test   %al,%al
  800b1e:	66 90                	xchg   %ax,%ax
  800b20:	74 0f                	je     800b31 <strtol+0x86>
  800b22:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b27:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2a:	75 05                	jne    800b31 <strtol+0x86>
		s++, base = 8;
  800b2c:	83 c2 01             	add    $0x1,%edx
  800b2f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
  800b36:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b38:	0f b6 0a             	movzbl (%edx),%ecx
  800b3b:	89 cf                	mov    %ecx,%edi
  800b3d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b40:	80 fb 09             	cmp    $0x9,%bl
  800b43:	77 08                	ja     800b4d <strtol+0xa2>
			dig = *s - '0';
  800b45:	0f be c9             	movsbl %cl,%ecx
  800b48:	83 e9 30             	sub    $0x30,%ecx
  800b4b:	eb 1e                	jmp    800b6b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800b4d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b50:	80 fb 19             	cmp    $0x19,%bl
  800b53:	77 08                	ja     800b5d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800b55:	0f be c9             	movsbl %cl,%ecx
  800b58:	83 e9 57             	sub    $0x57,%ecx
  800b5b:	eb 0e                	jmp    800b6b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800b5d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b60:	80 fb 19             	cmp    $0x19,%bl
  800b63:	77 15                	ja     800b7a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800b65:	0f be c9             	movsbl %cl,%ecx
  800b68:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b6b:	39 f1                	cmp    %esi,%ecx
  800b6d:	7d 0b                	jge    800b7a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800b6f:	83 c2 01             	add    $0x1,%edx
  800b72:	0f af c6             	imul   %esi,%eax
  800b75:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b78:	eb be                	jmp    800b38 <strtol+0x8d>
  800b7a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b80:	74 05                	je     800b87 <strtol+0xdc>
		*endptr = (char *) s;
  800b82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b85:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b8b:	74 04                	je     800b91 <strtol+0xe6>
  800b8d:	89 c8                	mov    %ecx,%eax
  800b8f:	f7 d8                	neg    %eax
}
  800b91:	83 c4 04             	add    $0x4,%esp
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5f                   	pop    %edi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
  800b99:	00 00                	add    %al,(%eax)
	...

00800b9c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 0c             	sub    $0xc,%esp
  800ba2:	89 1c 24             	mov    %ebx,(%esp)
  800ba5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ba9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bad:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb7:	89 d1                	mov    %edx,%ecx
  800bb9:	89 d3                	mov    %edx,%ebx
  800bbb:	89 d7                	mov    %edx,%edi
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc1:	8b 1c 24             	mov    (%esp),%ebx
  800bc4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bc8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bcc:	89 ec                	mov    %ebp,%esp
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	89 1c 24             	mov    %ebx,(%esp)
  800bd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bdd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800be1:	b8 00 00 00 00       	mov    $0x0,%eax
  800be6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bec:	89 c3                	mov    %eax,%ebx
  800bee:	89 c7                	mov    %eax,%edi
  800bf0:	89 c6                	mov    %eax,%esi
  800bf2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf4:	8b 1c 24             	mov    (%esp),%ebx
  800bf7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bfb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bff:	89 ec                	mov    %ebp,%esp
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	83 ec 38             	sub    $0x38,%esp
  800c09:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c12:	be 00 00 00 00       	mov    $0x0,%esi
  800c17:	b8 12 00 00 00       	mov    $0x12,%eax
  800c1c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	7e 28                	jle    800c56 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c32:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800c39:	00 
  800c3a:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  800c41:	00 
  800c42:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c49:	00 
  800c4a:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  800c51:	e8 96 17 00 00       	call   8023ec <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800c56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c59:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c5c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c5f:	89 ec                	mov    %ebp,%esp
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 0c             	sub    $0xc,%esp
  800c69:	89 1c 24             	mov    %ebx,(%esp)
  800c6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c70:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c79:	b8 11 00 00 00       	mov    $0x11,%eax
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	8b 55 08             	mov    0x8(%ebp),%edx
  800c84:	89 df                	mov    %ebx,%edi
  800c86:	89 de                	mov    %ebx,%esi
  800c88:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800c8a:	8b 1c 24             	mov    (%esp),%ebx
  800c8d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c91:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c95:	89 ec                	mov    %ebp,%esp
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	89 1c 24             	mov    %ebx,(%esp)
  800ca2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ca6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800caa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800caf:	b8 10 00 00 00       	mov    $0x10,%eax
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	89 cb                	mov    %ecx,%ebx
  800cb9:	89 cf                	mov    %ecx,%edi
  800cbb:	89 ce                	mov    %ecx,%esi
  800cbd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800cbf:	8b 1c 24             	mov    (%esp),%ebx
  800cc2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cc6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cca:	89 ec                	mov    %ebp,%esp
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	83 ec 38             	sub    $0x38,%esp
  800cd4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cd7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cda:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ce7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	89 df                	mov    %ebx,%edi
  800cef:	89 de                	mov    %ebx,%esi
  800cf1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800cf3:	85 c0                	test   %eax,%eax
  800cf5:	7e 28                	jle    800d1f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cfb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d02:	00 
  800d03:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  800d0a:	00 
  800d0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d12:	00 
  800d13:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  800d1a:	e8 cd 16 00 00       	call   8023ec <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800d1f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d22:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d25:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d28:	89 ec                	mov    %ebp,%esp
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	89 1c 24             	mov    %ebx,(%esp)
  800d35:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d39:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d42:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d47:	89 d1                	mov    %edx,%ecx
  800d49:	89 d3                	mov    %edx,%ebx
  800d4b:	89 d7                	mov    %edx,%edi
  800d4d:	89 d6                	mov    %edx,%esi
  800d4f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800d51:	8b 1c 24             	mov    (%esp),%ebx
  800d54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d5c:	89 ec                	mov    %ebp,%esp
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 38             	sub    $0x38,%esp
  800d66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d74:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	89 cb                	mov    %ecx,%ebx
  800d7e:	89 cf                	mov    %ecx,%edi
  800d80:	89 ce                	mov    %ecx,%esi
  800d82:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	7e 28                	jle    800db0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d88:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d8c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d93:	00 
  800d94:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  800d9b:	00 
  800d9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da3:	00 
  800da4:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  800dab:	e8 3c 16 00 00       	call   8023ec <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800db0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800db3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800db6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800db9:	89 ec                	mov    %ebp,%esp
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 0c             	sub    $0xc,%esp
  800dc3:	89 1c 24             	mov    %ebx,(%esp)
  800dc6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dca:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dce:	be 00 00 00 00       	mov    $0x0,%esi
  800dd3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de6:	8b 1c 24             	mov    (%esp),%ebx
  800de9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ded:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800df1:	89 ec                	mov    %ebp,%esp
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 38             	sub    $0x38,%esp
  800dfb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dfe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e01:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7e 28                	jle    800e46 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e22:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e29:	00 
  800e2a:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  800e31:	00 
  800e32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e39:	00 
  800e3a:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  800e41:	e8 a6 15 00 00       	call   8023ec <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e4f:	89 ec                	mov    %ebp,%esp
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 38             	sub    $0x38,%esp
  800e59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e67:	b8 09 00 00 00       	mov    $0x9,%eax
  800e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e72:	89 df                	mov    %ebx,%edi
  800e74:	89 de                	mov    %ebx,%esi
  800e76:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	7e 28                	jle    800ea4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e80:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e87:	00 
  800e88:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  800e8f:	00 
  800e90:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e97:	00 
  800e98:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  800e9f:	e8 48 15 00 00       	call   8023ec <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ea7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eaa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ead:	89 ec                	mov    %ebp,%esp
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    

00800eb1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	83 ec 38             	sub    $0x38,%esp
  800eb7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ebd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec5:	b8 08 00 00 00       	mov    $0x8,%eax
  800eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed0:	89 df                	mov    %ebx,%edi
  800ed2:	89 de                	mov    %ebx,%esi
  800ed4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	7e 28                	jle    800f02 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ede:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ee5:	00 
  800ee6:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  800eed:	00 
  800eee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef5:	00 
  800ef6:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  800efd:	e8 ea 14 00 00       	call   8023ec <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f02:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f05:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f08:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f0b:	89 ec                	mov    %ebp,%esp
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 38             	sub    $0x38,%esp
  800f15:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f18:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f1b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f23:	b8 06 00 00 00       	mov    $0x6,%eax
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2e:	89 df                	mov    %ebx,%edi
  800f30:	89 de                	mov    %ebx,%esi
  800f32:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7e 28                	jle    800f60 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f43:	00 
  800f44:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  800f4b:	00 
  800f4c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f53:	00 
  800f54:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  800f5b:	e8 8c 14 00 00       	call   8023ec <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f60:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f63:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f66:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f69:	89 ec                	mov    %ebp,%esp
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 38             	sub    $0x38,%esp
  800f73:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f76:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f79:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7c:	b8 05 00 00 00       	mov    $0x5,%eax
  800f81:	8b 75 18             	mov    0x18(%ebp),%esi
  800f84:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f92:	85 c0                	test   %eax,%eax
  800f94:	7e 28                	jle    800fbe <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f96:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fa1:	00 
  800fa2:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  800fa9:	00 
  800faa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb1:	00 
  800fb2:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  800fb9:	e8 2e 14 00 00       	call   8023ec <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fbe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fc1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fc4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fc7:	89 ec                	mov    %ebp,%esp
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 38             	sub    $0x38,%esp
  800fd1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fd4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fd7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fda:	be 00 00 00 00       	mov    $0x0,%esi
  800fdf:	b8 04 00 00 00       	mov    $0x4,%eax
  800fe4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	89 f7                	mov    %esi,%edi
  800fef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	7e 28                	jle    80101d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801000:	00 
  801001:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  801008:	00 
  801009:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801010:	00 
  801011:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801018:	e8 cf 13 00 00       	call   8023ec <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80101d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801020:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801023:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801026:	89 ec                	mov    %ebp,%esp
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 0c             	sub    $0xc,%esp
  801030:	89 1c 24             	mov    %ebx,(%esp)
  801033:	89 74 24 04          	mov    %esi,0x4(%esp)
  801037:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103b:	ba 00 00 00 00       	mov    $0x0,%edx
  801040:	b8 0b 00 00 00       	mov    $0xb,%eax
  801045:	89 d1                	mov    %edx,%ecx
  801047:	89 d3                	mov    %edx,%ebx
  801049:	89 d7                	mov    %edx,%edi
  80104b:	89 d6                	mov    %edx,%esi
  80104d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80104f:	8b 1c 24             	mov    (%esp),%ebx
  801052:	8b 74 24 04          	mov    0x4(%esp),%esi
  801056:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80105a:	89 ec                	mov    %ebp,%esp
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    

0080105e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 0c             	sub    $0xc,%esp
  801064:	89 1c 24             	mov    %ebx,(%esp)
  801067:	89 74 24 04          	mov    %esi,0x4(%esp)
  80106b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106f:	ba 00 00 00 00       	mov    $0x0,%edx
  801074:	b8 02 00 00 00       	mov    $0x2,%eax
  801079:	89 d1                	mov    %edx,%ecx
  80107b:	89 d3                	mov    %edx,%ebx
  80107d:	89 d7                	mov    %edx,%edi
  80107f:	89 d6                	mov    %edx,%esi
  801081:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801083:	8b 1c 24             	mov    (%esp),%ebx
  801086:	8b 74 24 04          	mov    0x4(%esp),%esi
  80108a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80108e:	89 ec                	mov    %ebp,%esp
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    

00801092 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 38             	sub    $0x38,%esp
  801098:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80109b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80109e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8010ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ae:	89 cb                	mov    %ecx,%ebx
  8010b0:	89 cf                	mov    %ecx,%edi
  8010b2:	89 ce                	mov    %ecx,%esi
  8010b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	7e 28                	jle    8010e2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010be:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010c5:	00 
  8010c6:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  8010cd:	00 
  8010ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d5:	00 
  8010d6:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  8010dd:	e8 0a 13 00 00       	call   8023ec <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010eb:	89 ec                	mov    %ebp,%esp
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    
	...

008010f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010fb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	89 04 24             	mov    %eax,(%esp)
  80110c:	e8 df ff ff ff       	call   8010f0 <fd2num>
  801111:	05 20 00 0d 00       	add    $0xd0020,%eax
  801116:	c1 e0 0c             	shl    $0xc,%eax
}
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	57                   	push   %edi
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
  801121:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801124:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801129:	a8 01                	test   $0x1,%al
  80112b:	74 36                	je     801163 <fd_alloc+0x48>
  80112d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801132:	a8 01                	test   $0x1,%al
  801134:	74 2d                	je     801163 <fd_alloc+0x48>
  801136:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80113b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801140:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801145:	89 c3                	mov    %eax,%ebx
  801147:	89 c2                	mov    %eax,%edx
  801149:	c1 ea 16             	shr    $0x16,%edx
  80114c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80114f:	f6 c2 01             	test   $0x1,%dl
  801152:	74 14                	je     801168 <fd_alloc+0x4d>
  801154:	89 c2                	mov    %eax,%edx
  801156:	c1 ea 0c             	shr    $0xc,%edx
  801159:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80115c:	f6 c2 01             	test   $0x1,%dl
  80115f:	75 10                	jne    801171 <fd_alloc+0x56>
  801161:	eb 05                	jmp    801168 <fd_alloc+0x4d>
  801163:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801168:	89 1f                	mov    %ebx,(%edi)
  80116a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80116f:	eb 17                	jmp    801188 <fd_alloc+0x6d>
  801171:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801176:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80117b:	75 c8                	jne    801145 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80117d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801183:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	83 f8 1f             	cmp    $0x1f,%eax
  801196:	77 36                	ja     8011ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801198:	05 00 00 0d 00       	add    $0xd0000,%eax
  80119d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	c1 ea 16             	shr    $0x16,%edx
  8011a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ac:	f6 c2 01             	test   $0x1,%dl
  8011af:	74 1d                	je     8011ce <fd_lookup+0x41>
  8011b1:	89 c2                	mov    %eax,%edx
  8011b3:	c1 ea 0c             	shr    $0xc,%edx
  8011b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011bd:	f6 c2 01             	test   $0x1,%dl
  8011c0:	74 0c                	je     8011ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c5:	89 02                	mov    %eax,(%edx)
  8011c7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8011cc:	eb 05                	jmp    8011d3 <fd_lookup+0x46>
  8011ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    

008011d5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	89 04 24             	mov    %eax,(%esp)
  8011e8:	e8 a0 ff ff ff       	call   80118d <fd_lookup>
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	78 0e                	js     8011ff <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8011f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	89 50 04             	mov    %edx,0x4(%eax)
  8011fa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8011ff:	c9                   	leave  
  801200:	c3                   	ret    

00801201 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	56                   	push   %esi
  801205:	53                   	push   %ebx
  801206:	83 ec 10             	sub    $0x10,%esp
  801209:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80120c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80120f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801214:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801219:	be c8 2b 80 00       	mov    $0x802bc8,%esi
		if (devtab[i]->dev_id == dev_id) {
  80121e:	39 08                	cmp    %ecx,(%eax)
  801220:	75 10                	jne    801232 <dev_lookup+0x31>
  801222:	eb 04                	jmp    801228 <dev_lookup+0x27>
  801224:	39 08                	cmp    %ecx,(%eax)
  801226:	75 0a                	jne    801232 <dev_lookup+0x31>
			*dev = devtab[i];
  801228:	89 03                	mov    %eax,(%ebx)
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80122f:	90                   	nop
  801230:	eb 31                	jmp    801263 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801232:	83 c2 01             	add    $0x1,%edx
  801235:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801238:	85 c0                	test   %eax,%eax
  80123a:	75 e8                	jne    801224 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80123c:	a1 74 60 80 00       	mov    0x806074,%eax
  801241:	8b 40 4c             	mov    0x4c(%eax),%eax
  801244:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124c:	c7 04 24 4c 2b 80 00 	movl   $0x802b4c,(%esp)
  801253:	e8 c9 ee ff ff       	call   800121 <cprintf>
	*dev = 0;
  801258:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80125e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	5b                   	pop    %ebx
  801267:	5e                   	pop    %esi
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    

0080126a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	53                   	push   %ebx
  80126e:	83 ec 24             	sub    $0x24,%esp
  801271:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801274:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801277:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	89 04 24             	mov    %eax,(%esp)
  801281:	e8 07 ff ff ff       	call   80118d <fd_lookup>
  801286:	85 c0                	test   %eax,%eax
  801288:	78 53                	js     8012dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80128a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	89 04 24             	mov    %eax,(%esp)
  801299:	e8 63 ff ff ff       	call   801201 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 3b                	js     8012dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8012a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012aa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8012ae:	74 2d                	je     8012dd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012b0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012b3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012ba:	00 00 00 
	stat->st_isdir = 0;
  8012bd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012c4:	00 00 00 
	stat->st_dev = dev;
  8012c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d7:	89 14 24             	mov    %edx,(%esp)
  8012da:	ff 50 14             	call   *0x14(%eax)
}
  8012dd:	83 c4 24             	add    $0x24,%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	53                   	push   %ebx
  8012e7:	83 ec 24             	sub    $0x24,%esp
  8012ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f4:	89 1c 24             	mov    %ebx,(%esp)
  8012f7:	e8 91 fe ff ff       	call   80118d <fd_lookup>
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	78 5f                	js     80135f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801300:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801303:	89 44 24 04          	mov    %eax,0x4(%esp)
  801307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	89 04 24             	mov    %eax,(%esp)
  80130f:	e8 ed fe ff ff       	call   801201 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801314:	85 c0                	test   %eax,%eax
  801316:	78 47                	js     80135f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801318:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80131b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80131f:	75 23                	jne    801344 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801321:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801326:	8b 40 4c             	mov    0x4c(%eax),%eax
  801329:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80132d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801331:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  801338:	e8 e4 ed ff ff       	call   800121 <cprintf>
  80133d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801342:	eb 1b                	jmp    80135f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801347:	8b 48 18             	mov    0x18(%eax),%ecx
  80134a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80134f:	85 c9                	test   %ecx,%ecx
  801351:	74 0c                	je     80135f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135a:	89 14 24             	mov    %edx,(%esp)
  80135d:	ff d1                	call   *%ecx
}
  80135f:	83 c4 24             	add    $0x24,%esp
  801362:	5b                   	pop    %ebx
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    

00801365 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	53                   	push   %ebx
  801369:	83 ec 24             	sub    $0x24,%esp
  80136c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80136f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801372:	89 44 24 04          	mov    %eax,0x4(%esp)
  801376:	89 1c 24             	mov    %ebx,(%esp)
  801379:	e8 0f fe ff ff       	call   80118d <fd_lookup>
  80137e:	85 c0                	test   %eax,%eax
  801380:	78 66                	js     8013e8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801382:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801385:	89 44 24 04          	mov    %eax,0x4(%esp)
  801389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	89 04 24             	mov    %eax,(%esp)
  801391:	e8 6b fe ff ff       	call   801201 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801396:	85 c0                	test   %eax,%eax
  801398:	78 4e                	js     8013e8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80139d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8013a1:	75 23                	jne    8013c6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8013a3:	a1 74 60 80 00       	mov    0x806074,%eax
  8013a8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b3:	c7 04 24 8d 2b 80 00 	movl   $0x802b8d,(%esp)
  8013ba:	e8 62 ed ff ff       	call   800121 <cprintf>
  8013bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8013c4:	eb 22                	jmp    8013e8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8013cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d1:	85 c9                	test   %ecx,%ecx
  8013d3:	74 13                	je     8013e8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e3:	89 14 24             	mov    %edx,(%esp)
  8013e6:	ff d1                	call   *%ecx
}
  8013e8:	83 c4 24             	add    $0x24,%esp
  8013eb:	5b                   	pop    %ebx
  8013ec:	5d                   	pop    %ebp
  8013ed:	c3                   	ret    

008013ee <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 24             	sub    $0x24,%esp
  8013f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ff:	89 1c 24             	mov    %ebx,(%esp)
  801402:	e8 86 fd ff ff       	call   80118d <fd_lookup>
  801407:	85 c0                	test   %eax,%eax
  801409:	78 6b                	js     801476 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801415:	8b 00                	mov    (%eax),%eax
  801417:	89 04 24             	mov    %eax,(%esp)
  80141a:	e8 e2 fd ff ff       	call   801201 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 53                	js     801476 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801423:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801426:	8b 42 08             	mov    0x8(%edx),%eax
  801429:	83 e0 03             	and    $0x3,%eax
  80142c:	83 f8 01             	cmp    $0x1,%eax
  80142f:	75 23                	jne    801454 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801431:	a1 74 60 80 00       	mov    0x806074,%eax
  801436:	8b 40 4c             	mov    0x4c(%eax),%eax
  801439:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80143d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801441:	c7 04 24 aa 2b 80 00 	movl   $0x802baa,(%esp)
  801448:	e8 d4 ec ff ff       	call   800121 <cprintf>
  80144d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801452:	eb 22                	jmp    801476 <read+0x88>
	}
	if (!dev->dev_read)
  801454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801457:	8b 48 08             	mov    0x8(%eax),%ecx
  80145a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145f:	85 c9                	test   %ecx,%ecx
  801461:	74 13                	je     801476 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801463:	8b 45 10             	mov    0x10(%ebp),%eax
  801466:	89 44 24 08          	mov    %eax,0x8(%esp)
  80146a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801471:	89 14 24             	mov    %edx,(%esp)
  801474:	ff d1                	call   *%ecx
}
  801476:	83 c4 24             	add    $0x24,%esp
  801479:	5b                   	pop    %ebx
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	57                   	push   %edi
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
  801482:	83 ec 1c             	sub    $0x1c,%esp
  801485:	8b 7d 08             	mov    0x8(%ebp),%edi
  801488:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80148b:	ba 00 00 00 00       	mov    $0x0,%edx
  801490:	bb 00 00 00 00       	mov    $0x0,%ebx
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
  80149a:	85 f6                	test   %esi,%esi
  80149c:	74 29                	je     8014c7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80149e:	89 f0                	mov    %esi,%eax
  8014a0:	29 d0                	sub    %edx,%eax
  8014a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014a6:	03 55 0c             	add    0xc(%ebp),%edx
  8014a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014ad:	89 3c 24             	mov    %edi,(%esp)
  8014b0:	e8 39 ff ff ff       	call   8013ee <read>
		if (m < 0)
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 0e                	js     8014c7 <readn+0x4b>
			return m;
		if (m == 0)
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	74 08                	je     8014c5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014bd:	01 c3                	add    %eax,%ebx
  8014bf:	89 da                	mov    %ebx,%edx
  8014c1:	39 f3                	cmp    %esi,%ebx
  8014c3:	72 d9                	jb     80149e <readn+0x22>
  8014c5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014c7:	83 c4 1c             	add    $0x1c,%esp
  8014ca:	5b                   	pop    %ebx
  8014cb:	5e                   	pop    %esi
  8014cc:	5f                   	pop    %edi
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	56                   	push   %esi
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 20             	sub    $0x20,%esp
  8014d7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014da:	89 34 24             	mov    %esi,(%esp)
  8014dd:	e8 0e fc ff ff       	call   8010f0 <fd2num>
  8014e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014e9:	89 04 24             	mov    %eax,(%esp)
  8014ec:	e8 9c fc ff ff       	call   80118d <fd_lookup>
  8014f1:	89 c3                	mov    %eax,%ebx
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 05                	js     8014fc <fd_close+0x2d>
  8014f7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014fa:	74 0c                	je     801508 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8014fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801500:	19 c0                	sbb    %eax,%eax
  801502:	f7 d0                	not    %eax
  801504:	21 c3                	and    %eax,%ebx
  801506:	eb 3d                	jmp    801545 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801508:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150f:	8b 06                	mov    (%esi),%eax
  801511:	89 04 24             	mov    %eax,(%esp)
  801514:	e8 e8 fc ff ff       	call   801201 <dev_lookup>
  801519:	89 c3                	mov    %eax,%ebx
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 16                	js     801535 <fd_close+0x66>
		if (dev->dev_close)
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	8b 40 10             	mov    0x10(%eax),%eax
  801525:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152a:	85 c0                	test   %eax,%eax
  80152c:	74 07                	je     801535 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80152e:	89 34 24             	mov    %esi,(%esp)
  801531:	ff d0                	call   *%eax
  801533:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801535:	89 74 24 04          	mov    %esi,0x4(%esp)
  801539:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801540:	e8 ca f9 ff ff       	call   800f0f <sys_page_unmap>
	return r;
}
  801545:	89 d8                	mov    %ebx,%eax
  801547:	83 c4 20             	add    $0x20,%esp
  80154a:	5b                   	pop    %ebx
  80154b:	5e                   	pop    %esi
  80154c:	5d                   	pop    %ebp
  80154d:	c3                   	ret    

0080154e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801554:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801557:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	89 04 24             	mov    %eax,(%esp)
  801561:	e8 27 fc ff ff       	call   80118d <fd_lookup>
  801566:	85 c0                	test   %eax,%eax
  801568:	78 13                	js     80157d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80156a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801571:	00 
  801572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801575:	89 04 24             	mov    %eax,(%esp)
  801578:	e8 52 ff ff ff       	call   8014cf <fd_close>
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 18             	sub    $0x18,%esp
  801585:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801588:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80158b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801592:	00 
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	89 04 24             	mov    %eax,(%esp)
  801599:	e8 55 03 00 00       	call   8018f3 <open>
  80159e:	89 c3                	mov    %eax,%ebx
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	78 1b                	js     8015bf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ab:	89 1c 24             	mov    %ebx,(%esp)
  8015ae:	e8 b7 fc ff ff       	call   80126a <fstat>
  8015b3:	89 c6                	mov    %eax,%esi
	close(fd);
  8015b5:	89 1c 24             	mov    %ebx,(%esp)
  8015b8:	e8 91 ff ff ff       	call   80154e <close>
  8015bd:	89 f3                	mov    %esi,%ebx
	return r;
}
  8015bf:	89 d8                	mov    %ebx,%eax
  8015c1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015c4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015c7:	89 ec                	mov    %ebp,%esp
  8015c9:	5d                   	pop    %ebp
  8015ca:	c3                   	ret    

008015cb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	53                   	push   %ebx
  8015cf:	83 ec 14             	sub    $0x14,%esp
  8015d2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8015d7:	89 1c 24             	mov    %ebx,(%esp)
  8015da:	e8 6f ff ff ff       	call   80154e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015df:	83 c3 01             	add    $0x1,%ebx
  8015e2:	83 fb 20             	cmp    $0x20,%ebx
  8015e5:	75 f0                	jne    8015d7 <close_all+0xc>
		close(i);
}
  8015e7:	83 c4 14             	add    $0x14,%esp
  8015ea:	5b                   	pop    %ebx
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    

008015ed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 58             	sub    $0x58,%esp
  8015f3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015f9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801602:	89 44 24 04          	mov    %eax,0x4(%esp)
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	89 04 24             	mov    %eax,(%esp)
  80160c:	e8 7c fb ff ff       	call   80118d <fd_lookup>
  801611:	89 c3                	mov    %eax,%ebx
  801613:	85 c0                	test   %eax,%eax
  801615:	0f 88 e0 00 00 00    	js     8016fb <dup+0x10e>
		return r;
	close(newfdnum);
  80161b:	89 3c 24             	mov    %edi,(%esp)
  80161e:	e8 2b ff ff ff       	call   80154e <close>

	newfd = INDEX2FD(newfdnum);
  801623:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801629:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80162c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162f:	89 04 24             	mov    %eax,(%esp)
  801632:	e8 c9 fa ff ff       	call   801100 <fd2data>
  801637:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801639:	89 34 24             	mov    %esi,(%esp)
  80163c:	e8 bf fa ff ff       	call   801100 <fd2data>
  801641:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801644:	89 da                	mov    %ebx,%edx
  801646:	89 d8                	mov    %ebx,%eax
  801648:	c1 e8 16             	shr    $0x16,%eax
  80164b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801652:	a8 01                	test   $0x1,%al
  801654:	74 43                	je     801699 <dup+0xac>
  801656:	c1 ea 0c             	shr    $0xc,%edx
  801659:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801660:	a8 01                	test   $0x1,%al
  801662:	74 35                	je     801699 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801664:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80166b:	25 07 0e 00 00       	and    $0xe07,%eax
  801670:	89 44 24 10          	mov    %eax,0x10(%esp)
  801674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801677:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80167b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801682:	00 
  801683:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801687:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168e:	e8 da f8 ff ff       	call   800f6d <sys_page_map>
  801693:	89 c3                	mov    %eax,%ebx
  801695:	85 c0                	test   %eax,%eax
  801697:	78 3f                	js     8016d8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80169c:	89 c2                	mov    %eax,%edx
  80169e:	c1 ea 0c             	shr    $0xc,%edx
  8016a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016a8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016ae:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016b2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016bd:	00 
  8016be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c9:	e8 9f f8 ff ff       	call   800f6d <sys_page_map>
  8016ce:	89 c3                	mov    %eax,%ebx
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	78 04                	js     8016d8 <dup+0xeb>
  8016d4:	89 fb                	mov    %edi,%ebx
  8016d6:	eb 23                	jmp    8016fb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e3:	e8 27 f8 ff ff       	call   800f0f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f6:	e8 14 f8 ff ff       	call   800f0f <sys_page_unmap>
	return r;
}
  8016fb:	89 d8                	mov    %ebx,%eax
  8016fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801700:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801703:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801706:	89 ec                	mov    %ebp,%esp
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    
	...

0080170c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	53                   	push   %ebx
  801710:	83 ec 14             	sub    $0x14,%esp
  801713:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801715:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80171b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801722:	00 
  801723:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80172a:	00 
  80172b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172f:	89 14 24             	mov    %edx,(%esp)
  801732:	e8 19 0d 00 00       	call   802450 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801737:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80173e:	00 
  80173f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801743:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174a:	e8 67 0d 00 00       	call   8024b6 <ipc_recv>
}
  80174f:	83 c4 14             	add    $0x14,%esp
  801752:	5b                   	pop    %ebx
  801753:	5d                   	pop    %ebp
  801754:	c3                   	ret    

00801755 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8b 40 0c             	mov    0xc(%eax),%eax
  801761:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801766:	8b 45 0c             	mov    0xc(%ebp),%eax
  801769:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80176e:	ba 00 00 00 00       	mov    $0x0,%edx
  801773:	b8 02 00 00 00       	mov    $0x2,%eax
  801778:	e8 8f ff ff ff       	call   80170c <fsipc>
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8b 40 0c             	mov    0xc(%eax),%eax
  80178b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801790:	ba 00 00 00 00       	mov    $0x0,%edx
  801795:	b8 06 00 00 00       	mov    $0x6,%eax
  80179a:	e8 6d ff ff ff       	call   80170c <fsipc>
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8017b1:	e8 56 ff ff ff       	call   80170c <fsipc>
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	53                   	push   %ebx
  8017bc:	83 ec 14             	sub    $0x14,%esp
  8017bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c8:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d2:	b8 05 00 00 00       	mov    $0x5,%eax
  8017d7:	e8 30 ff ff ff       	call   80170c <fsipc>
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 2b                	js     80180b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017e0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8017e7:	00 
  8017e8:	89 1c 24             	mov    %ebx,(%esp)
  8017eb:	e8 ea ef ff ff       	call   8007da <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017f0:	a1 80 30 80 00       	mov    0x803080,%eax
  8017f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017fb:	a1 84 30 80 00       	mov    0x803084,%eax
  801800:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80180b:	83 c4 14             	add    $0x14,%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    

00801811 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 18             	sub    $0x18,%esp
  801817:	8b 45 10             	mov    0x10(%ebp),%eax
  80181a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80181f:	76 05                	jbe    801826 <devfile_write+0x15>
  801821:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801826:	8b 55 08             	mov    0x8(%ebp),%edx
  801829:	8b 52 0c             	mov    0xc(%edx),%edx
  80182c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801832:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801837:	89 44 24 08          	mov    %eax,0x8(%esp)
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801842:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801849:	e8 47 f1 ff ff       	call   800995 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80184e:	ba 00 00 00 00       	mov    $0x0,%edx
  801853:	b8 04 00 00 00       	mov    $0x4,%eax
  801858:	e8 af fe ff ff       	call   80170c <fsipc>
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	53                   	push   %ebx
  801863:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	8b 40 0c             	mov    0xc(%eax),%eax
  80186c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801871:	8b 45 10             	mov    0x10(%ebp),%eax
  801874:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801879:	ba 00 30 80 00       	mov    $0x803000,%edx
  80187e:	b8 03 00 00 00       	mov    $0x3,%eax
  801883:	e8 84 fe ff ff       	call   80170c <fsipc>
  801888:	89 c3                	mov    %eax,%ebx
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 17                	js     8018a5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80188e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801892:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801899:	00 
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	89 04 24             	mov    %eax,(%esp)
  8018a0:	e8 f0 f0 ff ff       	call   800995 <memmove>
	return r;
}
  8018a5:	89 d8                	mov    %ebx,%eax
  8018a7:	83 c4 14             	add    $0x14,%esp
  8018aa:	5b                   	pop    %ebx
  8018ab:	5d                   	pop    %ebp
  8018ac:	c3                   	ret    

008018ad <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 14             	sub    $0x14,%esp
  8018b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8018b7:	89 1c 24             	mov    %ebx,(%esp)
  8018ba:	e8 d1 ee ff ff       	call   800790 <strlen>
  8018bf:	89 c2                	mov    %eax,%edx
  8018c1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8018c6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8018cc:	7f 1f                	jg     8018ed <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8018ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8018d9:	e8 fc ee ff ff       	call   8007da <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8018de:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e3:	b8 07 00 00 00       	mov    $0x7,%eax
  8018e8:	e8 1f fe ff ff       	call   80170c <fsipc>
}
  8018ed:	83 c4 14             	add    $0x14,%esp
  8018f0:	5b                   	pop    %ebx
  8018f1:	5d                   	pop    %ebp
  8018f2:	c3                   	ret    

008018f3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 28             	sub    $0x28,%esp
  8018f9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8018fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8018ff:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801902:	89 34 24             	mov    %esi,(%esp)
  801905:	e8 86 ee ff ff       	call   800790 <strlen>
  80190a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80190f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801914:	7f 5e                	jg     801974 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801916:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801919:	89 04 24             	mov    %eax,(%esp)
  80191c:	e8 fa f7 ff ff       	call   80111b <fd_alloc>
  801921:	89 c3                	mov    %eax,%ebx
  801923:	85 c0                	test   %eax,%eax
  801925:	78 4d                	js     801974 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801927:	89 74 24 04          	mov    %esi,0x4(%esp)
  80192b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801932:	e8 a3 ee ff ff       	call   8007da <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	b8 01 00 00 00       	mov    $0x1,%eax
  801947:	e8 c0 fd ff ff       	call   80170c <fsipc>
  80194c:	89 c3                	mov    %eax,%ebx
  80194e:	85 c0                	test   %eax,%eax
  801950:	79 15                	jns    801967 <open+0x74>
	{
		fd_close(fd,0);
  801952:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801959:	00 
  80195a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195d:	89 04 24             	mov    %eax,(%esp)
  801960:	e8 6a fb ff ff       	call   8014cf <fd_close>
		return r; 
  801965:	eb 0d                	jmp    801974 <open+0x81>
	}
	return fd2num(fd);
  801967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196a:	89 04 24             	mov    %eax,(%esp)
  80196d:	e8 7e f7 ff ff       	call   8010f0 <fd2num>
  801972:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801974:	89 d8                	mov    %ebx,%eax
  801976:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801979:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80197c:	89 ec                	mov    %ebp,%esp
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801986:	c7 44 24 04 dc 2b 80 	movl   $0x802bdc,0x4(%esp)
  80198d:	00 
  80198e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801991:	89 04 24             	mov    %eax,(%esp)
  801994:	e8 41 ee ff ff       	call   8007da <strcpy>
	return 0;
}
  801999:	b8 00 00 00 00       	mov    $0x0,%eax
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ac:	89 04 24             	mov    %eax,(%esp)
  8019af:	e8 9e 02 00 00       	call   801c52 <nsipc_close>
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019bc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019c3:	00 
  8019c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d8:	89 04 24             	mov    %eax,(%esp)
  8019db:	e8 ae 02 00 00       	call   801c8e <nsipc_send>
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ef:	00 
  8019f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	8b 40 0c             	mov    0xc(%eax),%eax
  801a04:	89 04 24             	mov    %eax,(%esp)
  801a07:	e8 f5 02 00 00       	call   801d01 <nsipc_recv>
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	56                   	push   %esi
  801a12:	53                   	push   %ebx
  801a13:	83 ec 20             	sub    $0x20,%esp
  801a16:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1b:	89 04 24             	mov    %eax,(%esp)
  801a1e:	e8 f8 f6 ff ff       	call   80111b <fd_alloc>
  801a23:	89 c3                	mov    %eax,%ebx
  801a25:	85 c0                	test   %eax,%eax
  801a27:	78 21                	js     801a4a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801a29:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a30:	00 
  801a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3f:	e8 87 f5 ff ff       	call   800fcb <sys_page_alloc>
  801a44:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a46:	85 c0                	test   %eax,%eax
  801a48:	79 0a                	jns    801a54 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801a4a:	89 34 24             	mov    %esi,(%esp)
  801a4d:	e8 00 02 00 00       	call   801c52 <nsipc_close>
		return r;
  801a52:	eb 28                	jmp    801a7c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a54:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a62:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	e8 76 f6 ff ff       	call   8010f0 <fd2num>
  801a7a:	89 c3                	mov    %eax,%ebx
}
  801a7c:	89 d8                	mov    %ebx,%eax
  801a7e:	83 c4 20             	add    $0x20,%esp
  801a81:	5b                   	pop    %ebx
  801a82:	5e                   	pop    %esi
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    

00801a85 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	89 04 24             	mov    %eax,(%esp)
  801a9f:	e8 62 01 00 00       	call   801c06 <nsipc_socket>
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	78 05                	js     801aad <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801aa8:	e8 61 ff ff ff       	call   801a0e <alloc_sockfd>
}
  801aad:	c9                   	leave  
  801aae:	66 90                	xchg   %ax,%ax
  801ab0:	c3                   	ret    

00801ab1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ab7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801aba:	89 54 24 04          	mov    %edx,0x4(%esp)
  801abe:	89 04 24             	mov    %eax,(%esp)
  801ac1:	e8 c7 f6 ff ff       	call   80118d <fd_lookup>
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 15                	js     801adf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801aca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801acd:	8b 0a                	mov    (%edx),%ecx
  801acf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801ada:	75 03                	jne    801adf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801adc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	e8 c2 ff ff ff       	call   801ab1 <fd2sockid>
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 0f                	js     801b02 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801afa:	89 04 24             	mov    %eax,(%esp)
  801afd:	e8 2e 01 00 00       	call   801c30 <nsipc_listen>
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	e8 9f ff ff ff       	call   801ab1 <fd2sockid>
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 16                	js     801b2c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801b16:	8b 55 10             	mov    0x10(%ebp),%edx
  801b19:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b20:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b24:	89 04 24             	mov    %eax,(%esp)
  801b27:	e8 55 02 00 00       	call   801d81 <nsipc_connect>
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	e8 75 ff ff ff       	call   801ab1 <fd2sockid>
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	78 0f                	js     801b4f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b43:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b47:	89 04 24             	mov    %eax,(%esp)
  801b4a:	e8 1d 01 00 00       	call   801c6c <nsipc_shutdown>
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	e8 52 ff ff ff       	call   801ab1 <fd2sockid>
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 16                	js     801b79 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801b63:	8b 55 10             	mov    0x10(%ebp),%edx
  801b66:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b71:	89 04 24             	mov    %eax,(%esp)
  801b74:	e8 47 02 00 00       	call   801dc0 <nsipc_bind>
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	e8 28 ff ff ff       	call   801ab1 <fd2sockid>
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	78 1f                	js     801bac <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b8d:	8b 55 10             	mov    0x10(%ebp),%edx
  801b90:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b97:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b9b:	89 04 24             	mov    %eax,(%esp)
  801b9e:	e8 5c 02 00 00       	call   801dff <nsipc_accept>
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	78 05                	js     801bac <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801ba7:	e8 62 fe ff ff       	call   801a0e <alloc_sockfd>
}
  801bac:	c9                   	leave  
  801bad:	8d 76 00             	lea    0x0(%esi),%esi
  801bb0:	c3                   	ret    
	...

00801bc0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bc6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801bcc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bd3:	00 
  801bd4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801bdb:	00 
  801bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be0:	89 14 24             	mov    %edx,(%esp)
  801be3:	e8 68 08 00 00       	call   802450 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801be8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bef:	00 
  801bf0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bf7:	00 
  801bf8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bff:	e8 b2 08 00 00       	call   8024b6 <ipc_recv>
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c17:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801c24:	b8 09 00 00 00       	mov    $0x9,%eax
  801c29:	e8 92 ff ff ff       	call   801bc0 <nsipc>
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c41:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801c46:	b8 06 00 00 00       	mov    $0x6,%eax
  801c4b:	e8 70 ff ff ff       	call   801bc0 <nsipc>
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801c60:	b8 04 00 00 00       	mov    $0x4,%eax
  801c65:	e8 56 ff ff ff       	call   801bc0 <nsipc>
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801c82:	b8 03 00 00 00       	mov    $0x3,%eax
  801c87:	e8 34 ff ff ff       	call   801bc0 <nsipc>
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	53                   	push   %ebx
  801c92:	83 ec 14             	sub    $0x14,%esp
  801c95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801ca0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ca6:	7e 24                	jle    801ccc <nsipc_send+0x3e>
  801ca8:	c7 44 24 0c e8 2b 80 	movl   $0x802be8,0xc(%esp)
  801caf:	00 
  801cb0:	c7 44 24 08 f4 2b 80 	movl   $0x802bf4,0x8(%esp)
  801cb7:	00 
  801cb8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801cbf:	00 
  801cc0:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  801cc7:	e8 20 07 00 00       	call   8023ec <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ccc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801cde:	e8 b2 ec ff ff       	call   800995 <memmove>
	nsipcbuf.send.req_size = size;
  801ce3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cec:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801cf1:	b8 08 00 00 00       	mov    $0x8,%eax
  801cf6:	e8 c5 fe ff ff       	call   801bc0 <nsipc>
}
  801cfb:	83 c4 14             	add    $0x14,%esp
  801cfe:	5b                   	pop    %ebx
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    

00801d01 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	56                   	push   %esi
  801d05:	53                   	push   %ebx
  801d06:	83 ec 10             	sub    $0x10,%esp
  801d09:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801d14:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d22:	b8 07 00 00 00       	mov    $0x7,%eax
  801d27:	e8 94 fe ff ff       	call   801bc0 <nsipc>
  801d2c:	89 c3                	mov    %eax,%ebx
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	78 46                	js     801d78 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d32:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d37:	7f 04                	jg     801d3d <nsipc_recv+0x3c>
  801d39:	39 c6                	cmp    %eax,%esi
  801d3b:	7d 24                	jge    801d61 <nsipc_recv+0x60>
  801d3d:	c7 44 24 0c 15 2c 80 	movl   $0x802c15,0xc(%esp)
  801d44:	00 
  801d45:	c7 44 24 08 f4 2b 80 	movl   $0x802bf4,0x8(%esp)
  801d4c:	00 
  801d4d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801d54:	00 
  801d55:	c7 04 24 09 2c 80 00 	movl   $0x802c09,(%esp)
  801d5c:	e8 8b 06 00 00       	call   8023ec <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d61:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d65:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801d6c:	00 
  801d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d70:	89 04 24             	mov    %eax,(%esp)
  801d73:	e8 1d ec ff ff       	call   800995 <memmove>
	}

	return r;
}
  801d78:	89 d8                	mov    %ebx,%eax
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5e                   	pop    %esi
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    

00801d81 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	53                   	push   %ebx
  801d85:	83 ec 14             	sub    $0x14,%esp
  801d88:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801da5:	e8 eb eb ff ff       	call   800995 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801daa:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  801db0:	b8 05 00 00 00       	mov    $0x5,%eax
  801db5:	e8 06 fe ff ff       	call   801bc0 <nsipc>
}
  801dba:	83 c4 14             	add    $0x14,%esp
  801dbd:	5b                   	pop    %ebx
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    

00801dc0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	53                   	push   %ebx
  801dc4:	83 ec 14             	sub    $0x14,%esp
  801dc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801dd2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddd:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801de4:	e8 ac eb ff ff       	call   800995 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801de9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  801def:	b8 02 00 00 00       	mov    $0x2,%eax
  801df4:	e8 c7 fd ff ff       	call   801bc0 <nsipc>
}
  801df9:	83 c4 14             	add    $0x14,%esp
  801dfc:	5b                   	pop    %ebx
  801dfd:	5d                   	pop    %ebp
  801dfe:	c3                   	ret    

00801dff <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 18             	sub    $0x18,%esp
  801e05:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e08:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e13:	b8 01 00 00 00       	mov    $0x1,%eax
  801e18:	e8 a3 fd ff ff       	call   801bc0 <nsipc>
  801e1d:	89 c3                	mov    %eax,%ebx
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	78 25                	js     801e48 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e23:	be 10 50 80 00       	mov    $0x805010,%esi
  801e28:	8b 06                	mov    (%esi),%eax
  801e2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e2e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801e35:	00 
  801e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e39:	89 04 24             	mov    %eax,(%esp)
  801e3c:	e8 54 eb ff ff       	call   800995 <memmove>
		*addrlen = ret->ret_addrlen;
  801e41:	8b 16                	mov    (%esi),%edx
  801e43:	8b 45 10             	mov    0x10(%ebp),%eax
  801e46:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801e48:	89 d8                	mov    %ebx,%eax
  801e4a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e4d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e50:	89 ec                	mov    %ebp,%esp
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    
	...

00801e60 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 18             	sub    $0x18,%esp
  801e66:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e69:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e6c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	89 04 24             	mov    %eax,(%esp)
  801e75:	e8 86 f2 ff ff       	call   801100 <fd2data>
  801e7a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801e7c:	c7 44 24 04 2a 2c 80 	movl   $0x802c2a,0x4(%esp)
  801e83:	00 
  801e84:	89 34 24             	mov    %esi,(%esp)
  801e87:	e8 4e e9 ff ff       	call   8007da <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e8c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e8f:	2b 03                	sub    (%ebx),%eax
  801e91:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801e97:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801e9e:	00 00 00 
	stat->st_dev = &devpipe;
  801ea1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  801ea8:	60 80 00 
	return 0;
}
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801eb3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801eb6:	89 ec                	mov    %ebp,%esp
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    

00801eba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	53                   	push   %ebx
  801ebe:	83 ec 14             	sub    $0x14,%esp
  801ec1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ec4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ec8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ecf:	e8 3b f0 ff ff       	call   800f0f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ed4:	89 1c 24             	mov    %ebx,(%esp)
  801ed7:	e8 24 f2 ff ff       	call   801100 <fd2data>
  801edc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee7:	e8 23 f0 ff ff       	call   800f0f <sys_page_unmap>
}
  801eec:	83 c4 14             	add    $0x14,%esp
  801eef:	5b                   	pop    %ebx
  801ef0:	5d                   	pop    %ebp
  801ef1:	c3                   	ret    

00801ef2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	57                   	push   %edi
  801ef6:	56                   	push   %esi
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 2c             	sub    $0x2c,%esp
  801efb:	89 c7                	mov    %eax,%edi
  801efd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801f00:	a1 74 60 80 00       	mov    0x806074,%eax
  801f05:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f08:	89 3c 24             	mov    %edi,(%esp)
  801f0b:	e8 10 06 00 00       	call   802520 <pageref>
  801f10:	89 c6                	mov    %eax,%esi
  801f12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f15:	89 04 24             	mov    %eax,(%esp)
  801f18:	e8 03 06 00 00       	call   802520 <pageref>
  801f1d:	39 c6                	cmp    %eax,%esi
  801f1f:	0f 94 c0             	sete   %al
  801f22:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801f25:	8b 15 74 60 80 00    	mov    0x806074,%edx
  801f2b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f2e:	39 cb                	cmp    %ecx,%ebx
  801f30:	75 08                	jne    801f3a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801f32:	83 c4 2c             	add    $0x2c,%esp
  801f35:	5b                   	pop    %ebx
  801f36:	5e                   	pop    %esi
  801f37:	5f                   	pop    %edi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801f3a:	83 f8 01             	cmp    $0x1,%eax
  801f3d:	75 c1                	jne    801f00 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801f3f:	8b 52 58             	mov    0x58(%edx),%edx
  801f42:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f46:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f4a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f4e:	c7 04 24 31 2c 80 00 	movl   $0x802c31,(%esp)
  801f55:	e8 c7 e1 ff ff       	call   800121 <cprintf>
  801f5a:	eb a4                	jmp    801f00 <_pipeisclosed+0xe>

00801f5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	57                   	push   %edi
  801f60:	56                   	push   %esi
  801f61:	53                   	push   %ebx
  801f62:	83 ec 1c             	sub    $0x1c,%esp
  801f65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f68:	89 34 24             	mov    %esi,(%esp)
  801f6b:	e8 90 f1 ff ff       	call   801100 <fd2data>
  801f70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f72:	bf 00 00 00 00       	mov    $0x0,%edi
  801f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f7b:	75 54                	jne    801fd1 <devpipe_write+0x75>
  801f7d:	eb 60                	jmp    801fdf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f7f:	89 da                	mov    %ebx,%edx
  801f81:	89 f0                	mov    %esi,%eax
  801f83:	e8 6a ff ff ff       	call   801ef2 <_pipeisclosed>
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	74 07                	je     801f93 <devpipe_write+0x37>
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f91:	eb 53                	jmp    801fe6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f93:	90                   	nop
  801f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f98:	e8 8d f0 ff ff       	call   80102a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f9d:	8b 43 04             	mov    0x4(%ebx),%eax
  801fa0:	8b 13                	mov    (%ebx),%edx
  801fa2:	83 c2 20             	add    $0x20,%edx
  801fa5:	39 d0                	cmp    %edx,%eax
  801fa7:	73 d6                	jae    801f7f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fa9:	89 c2                	mov    %eax,%edx
  801fab:	c1 fa 1f             	sar    $0x1f,%edx
  801fae:	c1 ea 1b             	shr    $0x1b,%edx
  801fb1:	01 d0                	add    %edx,%eax
  801fb3:	83 e0 1f             	and    $0x1f,%eax
  801fb6:	29 d0                	sub    %edx,%eax
  801fb8:	89 c2                	mov    %eax,%edx
  801fba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fbd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  801fc1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fc5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fc9:	83 c7 01             	add    $0x1,%edi
  801fcc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  801fcf:	76 13                	jbe    801fe4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fd1:	8b 43 04             	mov    0x4(%ebx),%eax
  801fd4:	8b 13                	mov    (%ebx),%edx
  801fd6:	83 c2 20             	add    $0x20,%edx
  801fd9:	39 d0                	cmp    %edx,%eax
  801fdb:	73 a2                	jae    801f7f <devpipe_write+0x23>
  801fdd:	eb ca                	jmp    801fa9 <devpipe_write+0x4d>
  801fdf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  801fe4:	89 f8                	mov    %edi,%eax
}
  801fe6:	83 c4 1c             	add    $0x1c,%esp
  801fe9:	5b                   	pop    %ebx
  801fea:	5e                   	pop    %esi
  801feb:	5f                   	pop    %edi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 28             	sub    $0x28,%esp
  801ff4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ff7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ffa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ffd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802000:	89 3c 24             	mov    %edi,(%esp)
  802003:	e8 f8 f0 ff ff       	call   801100 <fd2data>
  802008:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80200a:	be 00 00 00 00       	mov    $0x0,%esi
  80200f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802013:	75 4c                	jne    802061 <devpipe_read+0x73>
  802015:	eb 5b                	jmp    802072 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802017:	89 f0                	mov    %esi,%eax
  802019:	eb 5e                	jmp    802079 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80201b:	89 da                	mov    %ebx,%edx
  80201d:	89 f8                	mov    %edi,%eax
  80201f:	90                   	nop
  802020:	e8 cd fe ff ff       	call   801ef2 <_pipeisclosed>
  802025:	85 c0                	test   %eax,%eax
  802027:	74 07                	je     802030 <devpipe_read+0x42>
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	eb 49                	jmp    802079 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802030:	e8 f5 ef ff ff       	call   80102a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802035:	8b 03                	mov    (%ebx),%eax
  802037:	3b 43 04             	cmp    0x4(%ebx),%eax
  80203a:	74 df                	je     80201b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80203c:	89 c2                	mov    %eax,%edx
  80203e:	c1 fa 1f             	sar    $0x1f,%edx
  802041:	c1 ea 1b             	shr    $0x1b,%edx
  802044:	01 d0                	add    %edx,%eax
  802046:	83 e0 1f             	and    $0x1f,%eax
  802049:	29 d0                	sub    %edx,%eax
  80204b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802050:	8b 55 0c             	mov    0xc(%ebp),%edx
  802053:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802056:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802059:	83 c6 01             	add    $0x1,%esi
  80205c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80205f:	76 16                	jbe    802077 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802061:	8b 03                	mov    (%ebx),%eax
  802063:	3b 43 04             	cmp    0x4(%ebx),%eax
  802066:	75 d4                	jne    80203c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802068:	85 f6                	test   %esi,%esi
  80206a:	75 ab                	jne    802017 <devpipe_read+0x29>
  80206c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802070:	eb a9                	jmp    80201b <devpipe_read+0x2d>
  802072:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802077:	89 f0                	mov    %esi,%eax
}
  802079:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80207c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80207f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802082:	89 ec                	mov    %ebp,%esp
  802084:	5d                   	pop    %ebp
  802085:	c3                   	ret    

00802086 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80208c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	89 04 24             	mov    %eax,(%esp)
  802099:	e8 ef f0 ff ff       	call   80118d <fd_lookup>
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	78 15                	js     8020b7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	89 04 24             	mov    %eax,(%esp)
  8020a8:	e8 53 f0 ff ff       	call   801100 <fd2data>
	return _pipeisclosed(fd, p);
  8020ad:	89 c2                	mov    %eax,%edx
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	e8 3b fe ff ff       	call   801ef2 <_pipeisclosed>
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 48             	sub    $0x48,%esp
  8020bf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020c8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020cb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8020ce:	89 04 24             	mov    %eax,(%esp)
  8020d1:	e8 45 f0 ff ff       	call   80111b <fd_alloc>
  8020d6:	89 c3                	mov    %eax,%ebx
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	0f 88 42 01 00 00    	js     802222 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020e7:	00 
  8020e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f6:	e8 d0 ee ff ff       	call   800fcb <sys_page_alloc>
  8020fb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	0f 88 1d 01 00 00    	js     802222 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802105:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802108:	89 04 24             	mov    %eax,(%esp)
  80210b:	e8 0b f0 ff ff       	call   80111b <fd_alloc>
  802110:	89 c3                	mov    %eax,%ebx
  802112:	85 c0                	test   %eax,%eax
  802114:	0f 88 f5 00 00 00    	js     80220f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80211a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802121:	00 
  802122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802125:	89 44 24 04          	mov    %eax,0x4(%esp)
  802129:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802130:	e8 96 ee ff ff       	call   800fcb <sys_page_alloc>
  802135:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802137:	85 c0                	test   %eax,%eax
  802139:	0f 88 d0 00 00 00    	js     80220f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80213f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802142:	89 04 24             	mov    %eax,(%esp)
  802145:	e8 b6 ef ff ff       	call   801100 <fd2data>
  80214a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80214c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802153:	00 
  802154:	89 44 24 04          	mov    %eax,0x4(%esp)
  802158:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80215f:	e8 67 ee ff ff       	call   800fcb <sys_page_alloc>
  802164:	89 c3                	mov    %eax,%ebx
  802166:	85 c0                	test   %eax,%eax
  802168:	0f 88 8e 00 00 00    	js     8021fc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80216e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802171:	89 04 24             	mov    %eax,(%esp)
  802174:	e8 87 ef ff ff       	call   801100 <fd2data>
  802179:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802180:	00 
  802181:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802185:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80218c:	00 
  80218d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802191:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802198:	e8 d0 ed ff ff       	call   800f6d <sys_page_map>
  80219d:	89 c3                	mov    %eax,%ebx
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	78 49                	js     8021ec <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021a3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  8021a8:	8b 08                	mov    (%eax),%ecx
  8021aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021ad:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021b2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8021b9:	8b 10                	mov    (%eax),%edx
  8021bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021be:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8021ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021cd:	89 04 24             	mov    %eax,(%esp)
  8021d0:	e8 1b ef ff ff       	call   8010f0 <fd2num>
  8021d5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8021d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021da:	89 04 24             	mov    %eax,(%esp)
  8021dd:	e8 0e ef ff ff       	call   8010f0 <fd2num>
  8021e2:	89 47 04             	mov    %eax,0x4(%edi)
  8021e5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8021ea:	eb 36                	jmp    802222 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8021ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f7:	e8 13 ed ff ff       	call   800f0f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8021fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802203:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220a:	e8 00 ed ff ff       	call   800f0f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80220f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802212:	89 44 24 04          	mov    %eax,0x4(%esp)
  802216:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80221d:	e8 ed ec ff ff       	call   800f0f <sys_page_unmap>
    err:
	return r;
}
  802222:	89 d8                	mov    %ebx,%eax
  802224:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802227:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80222a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80222d:	89 ec                	mov    %ebp,%esp
  80222f:	5d                   	pop    %ebp
  802230:	c3                   	ret    
	...

00802240 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802243:	b8 00 00 00 00       	mov    $0x0,%eax
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    

0080224a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802250:	c7 44 24 04 49 2c 80 	movl   $0x802c49,0x4(%esp)
  802257:	00 
  802258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225b:	89 04 24             	mov    %eax,(%esp)
  80225e:	e8 77 e5 ff ff       	call   8007da <strcpy>
	return 0;
}
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	57                   	push   %edi
  80226e:	56                   	push   %esi
  80226f:	53                   	push   %ebx
  802270:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
  80227b:	be 00 00 00 00       	mov    $0x0,%esi
  802280:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802284:	74 3f                	je     8022c5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802286:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80228c:	8b 55 10             	mov    0x10(%ebp),%edx
  80228f:	29 c2                	sub    %eax,%edx
  802291:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802293:	83 fa 7f             	cmp    $0x7f,%edx
  802296:	76 05                	jbe    80229d <devcons_write+0x33>
  802298:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80229d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022a1:	03 45 0c             	add    0xc(%ebp),%eax
  8022a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a8:	89 3c 24             	mov    %edi,(%esp)
  8022ab:	e8 e5 e6 ff ff       	call   800995 <memmove>
		sys_cputs(buf, m);
  8022b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022b4:	89 3c 24             	mov    %edi,(%esp)
  8022b7:	e8 14 e9 ff ff       	call   800bd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022bc:	01 de                	add    %ebx,%esi
  8022be:	89 f0                	mov    %esi,%eax
  8022c0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022c3:	72 c7                	jb     80228c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8022c5:	89 f0                	mov    %esi,%eax
  8022c7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8022cd:	5b                   	pop    %ebx
  8022ce:	5e                   	pop    %esi
  8022cf:	5f                   	pop    %edi
  8022d0:	5d                   	pop    %ebp
  8022d1:	c3                   	ret    

008022d2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022e5:	00 
  8022e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022e9:	89 04 24             	mov    %eax,(%esp)
  8022ec:	e8 df e8 ff ff       	call   800bd0 <sys_cputs>
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8022f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022fd:	75 07                	jne    802306 <devcons_read+0x13>
  8022ff:	eb 28                	jmp    802329 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802301:	e8 24 ed ff ff       	call   80102a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802306:	66 90                	xchg   %ax,%ax
  802308:	e8 8f e8 ff ff       	call   800b9c <sys_cgetc>
  80230d:	85 c0                	test   %eax,%eax
  80230f:	90                   	nop
  802310:	74 ef                	je     802301 <devcons_read+0xe>
  802312:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802314:	85 c0                	test   %eax,%eax
  802316:	78 16                	js     80232e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802318:	83 f8 04             	cmp    $0x4,%eax
  80231b:	74 0c                	je     802329 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80231d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802320:	88 10                	mov    %dl,(%eax)
  802322:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802327:	eb 05                	jmp    80232e <devcons_read+0x3b>
  802329:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802339:	89 04 24             	mov    %eax,(%esp)
  80233c:	e8 da ed ff ff       	call   80111b <fd_alloc>
  802341:	85 c0                	test   %eax,%eax
  802343:	78 3f                	js     802384 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802345:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80234c:	00 
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	89 44 24 04          	mov    %eax,0x4(%esp)
  802354:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80235b:	e8 6b ec ff ff       	call   800fcb <sys_page_alloc>
  802360:	85 c0                	test   %eax,%eax
  802362:	78 20                	js     802384 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802364:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 04 24             	mov    %eax,(%esp)
  80237f:	e8 6c ed ff ff       	call   8010f0 <fd2num>
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80238c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80238f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	89 04 24             	mov    %eax,(%esp)
  802399:	e8 ef ed ff ff       	call   80118d <fd_lookup>
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	78 11                	js     8023b3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  8023ad:	0f 94 c0             	sete   %al
  8023b0:	0f b6 c0             	movzbl %al,%eax
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8023bb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023c2:	00 
  8023c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d1:	e8 18 f0 ff ff       	call   8013ee <read>
	if (r < 0)
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	78 0f                	js     8023e9 <getchar+0x34>
		return r;
	if (r < 1)
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	7f 07                	jg     8023e5 <getchar+0x30>
  8023de:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023e3:	eb 04                	jmp    8023e9 <getchar+0x34>
		return -E_EOF;
	return c;
  8023e5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    
	...

008023ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	53                   	push   %ebx
  8023f0:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8023f3:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8023f6:	a1 78 60 80 00       	mov    0x806078,%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 10                	je     80240f <_panic+0x23>
		cprintf("%s: ", argv0);
  8023ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802403:	c7 04 24 55 2c 80 00 	movl   $0x802c55,(%esp)
  80240a:	e8 12 dd ff ff       	call   800121 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80240f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802412:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	89 44 24 08          	mov    %eax,0x8(%esp)
  80241d:	a1 00 60 80 00       	mov    0x806000,%eax
  802422:	89 44 24 04          	mov    %eax,0x4(%esp)
  802426:	c7 04 24 5a 2c 80 00 	movl   $0x802c5a,(%esp)
  80242d:	e8 ef dc ff ff       	call   800121 <cprintf>
	vcprintf(fmt, ap);
  802432:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802436:	8b 45 10             	mov    0x10(%ebp),%eax
  802439:	89 04 24             	mov    %eax,(%esp)
  80243c:	e8 7f dc ff ff       	call   8000c0 <vcprintf>
	cprintf("\n");
  802441:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  802448:	e8 d4 dc ff ff       	call   800121 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80244d:	cc                   	int3   
  80244e:	eb fd                	jmp    80244d <_panic+0x61>

00802450 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	57                   	push   %edi
  802454:	56                   	push   %esi
  802455:	53                   	push   %ebx
  802456:	83 ec 1c             	sub    $0x1c,%esp
  802459:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80245c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80245f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802462:	85 db                	test   %ebx,%ebx
  802464:	75 2d                	jne    802493 <ipc_send+0x43>
  802466:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80246b:	eb 26                	jmp    802493 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80246d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802470:	74 1c                	je     80248e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802472:	c7 44 24 08 78 2c 80 	movl   $0x802c78,0x8(%esp)
  802479:	00 
  80247a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802481:	00 
  802482:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  802489:	e8 5e ff ff ff       	call   8023ec <_panic>
		sys_yield();
  80248e:	e8 97 eb ff ff       	call   80102a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802493:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802497:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80249b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	89 04 24             	mov    %eax,(%esp)
  8024a5:	e8 13 e9 ff ff       	call   800dbd <sys_ipc_try_send>
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	78 bf                	js     80246d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    

008024b6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	56                   	push   %esi
  8024ba:	53                   	push   %ebx
  8024bb:	83 ec 10             	sub    $0x10,%esp
  8024be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	75 05                	jne    8024d0 <ipc_recv+0x1a>
  8024cb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8024d0:	89 04 24             	mov    %eax,(%esp)
  8024d3:	e8 88 e8 ff ff       	call   800d60 <sys_ipc_recv>
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	79 16                	jns    8024f2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8024dc:	85 db                	test   %ebx,%ebx
  8024de:	74 06                	je     8024e6 <ipc_recv+0x30>
			*from_env_store = 0;
  8024e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8024e6:	85 f6                	test   %esi,%esi
  8024e8:	74 2c                	je     802516 <ipc_recv+0x60>
			*perm_store = 0;
  8024ea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8024f0:	eb 24                	jmp    802516 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8024f2:	85 db                	test   %ebx,%ebx
  8024f4:	74 0a                	je     802500 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8024f6:	a1 74 60 80 00       	mov    0x806074,%eax
  8024fb:	8b 40 74             	mov    0x74(%eax),%eax
  8024fe:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802500:	85 f6                	test   %esi,%esi
  802502:	74 0a                	je     80250e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802504:	a1 74 60 80 00       	mov    0x806074,%eax
  802509:	8b 40 78             	mov    0x78(%eax),%eax
  80250c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80250e:	a1 74 60 80 00       	mov    0x806074,%eax
  802513:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	5b                   	pop    %ebx
  80251a:	5e                   	pop    %esi
  80251b:	5d                   	pop    %ebp
  80251c:	c3                   	ret    
  80251d:	00 00                	add    %al,(%eax)
	...

00802520 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	89 c2                	mov    %eax,%edx
  802528:	c1 ea 16             	shr    $0x16,%edx
  80252b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802532:	f6 c2 01             	test   $0x1,%dl
  802535:	74 26                	je     80255d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802537:	c1 e8 0c             	shr    $0xc,%eax
  80253a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802541:	a8 01                	test   $0x1,%al
  802543:	74 18                	je     80255d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802545:	c1 e8 0c             	shr    $0xc,%eax
  802548:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80254b:	c1 e2 02             	shl    $0x2,%edx
  80254e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802553:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802558:	0f b7 c0             	movzwl %ax,%eax
  80255b:	eb 05                	jmp    802562 <pageref+0x42>
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
	...

00802570 <__udivdi3>:
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	57                   	push   %edi
  802574:	56                   	push   %esi
  802575:	83 ec 10             	sub    $0x10,%esp
  802578:	8b 45 14             	mov    0x14(%ebp),%eax
  80257b:	8b 55 08             	mov    0x8(%ebp),%edx
  80257e:	8b 75 10             	mov    0x10(%ebp),%esi
  802581:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802584:	85 c0                	test   %eax,%eax
  802586:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802589:	75 35                	jne    8025c0 <__udivdi3+0x50>
  80258b:	39 fe                	cmp    %edi,%esi
  80258d:	77 61                	ja     8025f0 <__udivdi3+0x80>
  80258f:	85 f6                	test   %esi,%esi
  802591:	75 0b                	jne    80259e <__udivdi3+0x2e>
  802593:	b8 01 00 00 00       	mov    $0x1,%eax
  802598:	31 d2                	xor    %edx,%edx
  80259a:	f7 f6                	div    %esi
  80259c:	89 c6                	mov    %eax,%esi
  80259e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025a1:	31 d2                	xor    %edx,%edx
  8025a3:	89 f8                	mov    %edi,%eax
  8025a5:	f7 f6                	div    %esi
  8025a7:	89 c7                	mov    %eax,%edi
  8025a9:	89 c8                	mov    %ecx,%eax
  8025ab:	f7 f6                	div    %esi
  8025ad:	89 c1                	mov    %eax,%ecx
  8025af:	89 fa                	mov    %edi,%edx
  8025b1:	89 c8                	mov    %ecx,%eax
  8025b3:	83 c4 10             	add    $0x10,%esp
  8025b6:	5e                   	pop    %esi
  8025b7:	5f                   	pop    %edi
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    
  8025ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025c0:	39 f8                	cmp    %edi,%eax
  8025c2:	77 1c                	ja     8025e0 <__udivdi3+0x70>
  8025c4:	0f bd d0             	bsr    %eax,%edx
  8025c7:	83 f2 1f             	xor    $0x1f,%edx
  8025ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8025cd:	75 39                	jne    802608 <__udivdi3+0x98>
  8025cf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8025d2:	0f 86 a0 00 00 00    	jbe    802678 <__udivdi3+0x108>
  8025d8:	39 f8                	cmp    %edi,%eax
  8025da:	0f 82 98 00 00 00    	jb     802678 <__udivdi3+0x108>
  8025e0:	31 ff                	xor    %edi,%edi
  8025e2:	31 c9                	xor    %ecx,%ecx
  8025e4:	89 c8                	mov    %ecx,%eax
  8025e6:	89 fa                	mov    %edi,%edx
  8025e8:	83 c4 10             	add    $0x10,%esp
  8025eb:	5e                   	pop    %esi
  8025ec:	5f                   	pop    %edi
  8025ed:	5d                   	pop    %ebp
  8025ee:	c3                   	ret    
  8025ef:	90                   	nop
  8025f0:	89 d1                	mov    %edx,%ecx
  8025f2:	89 fa                	mov    %edi,%edx
  8025f4:	89 c8                	mov    %ecx,%eax
  8025f6:	31 ff                	xor    %edi,%edi
  8025f8:	f7 f6                	div    %esi
  8025fa:	89 c1                	mov    %eax,%ecx
  8025fc:	89 fa                	mov    %edi,%edx
  8025fe:	89 c8                	mov    %ecx,%eax
  802600:	83 c4 10             	add    $0x10,%esp
  802603:	5e                   	pop    %esi
  802604:	5f                   	pop    %edi
  802605:	5d                   	pop    %ebp
  802606:	c3                   	ret    
  802607:	90                   	nop
  802608:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80260c:	89 f2                	mov    %esi,%edx
  80260e:	d3 e0                	shl    %cl,%eax
  802610:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802613:	b8 20 00 00 00       	mov    $0x20,%eax
  802618:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80261b:	89 c1                	mov    %eax,%ecx
  80261d:	d3 ea                	shr    %cl,%edx
  80261f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802623:	0b 55 ec             	or     -0x14(%ebp),%edx
  802626:	d3 e6                	shl    %cl,%esi
  802628:	89 c1                	mov    %eax,%ecx
  80262a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80262d:	89 fe                	mov    %edi,%esi
  80262f:	d3 ee                	shr    %cl,%esi
  802631:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802635:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802638:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263b:	d3 e7                	shl    %cl,%edi
  80263d:	89 c1                	mov    %eax,%ecx
  80263f:	d3 ea                	shr    %cl,%edx
  802641:	09 d7                	or     %edx,%edi
  802643:	89 f2                	mov    %esi,%edx
  802645:	89 f8                	mov    %edi,%eax
  802647:	f7 75 ec             	divl   -0x14(%ebp)
  80264a:	89 d6                	mov    %edx,%esi
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	f7 65 e8             	mull   -0x18(%ebp)
  802651:	39 d6                	cmp    %edx,%esi
  802653:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802656:	72 30                	jb     802688 <__udivdi3+0x118>
  802658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80265f:	d3 e2                	shl    %cl,%edx
  802661:	39 c2                	cmp    %eax,%edx
  802663:	73 05                	jae    80266a <__udivdi3+0xfa>
  802665:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802668:	74 1e                	je     802688 <__udivdi3+0x118>
  80266a:	89 f9                	mov    %edi,%ecx
  80266c:	31 ff                	xor    %edi,%edi
  80266e:	e9 71 ff ff ff       	jmp    8025e4 <__udivdi3+0x74>
  802673:	90                   	nop
  802674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802678:	31 ff                	xor    %edi,%edi
  80267a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80267f:	e9 60 ff ff ff       	jmp    8025e4 <__udivdi3+0x74>
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80268b:	31 ff                	xor    %edi,%edi
  80268d:	89 c8                	mov    %ecx,%eax
  80268f:	89 fa                	mov    %edi,%edx
  802691:	83 c4 10             	add    $0x10,%esp
  802694:	5e                   	pop    %esi
  802695:	5f                   	pop    %edi
  802696:	5d                   	pop    %ebp
  802697:	c3                   	ret    
	...

008026a0 <__umoddi3>:
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	57                   	push   %edi
  8026a4:	56                   	push   %esi
  8026a5:	83 ec 20             	sub    $0x20,%esp
  8026a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8026ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8026b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026b4:	85 d2                	test   %edx,%edx
  8026b6:	89 c8                	mov    %ecx,%eax
  8026b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8026bb:	75 13                	jne    8026d0 <__umoddi3+0x30>
  8026bd:	39 f7                	cmp    %esi,%edi
  8026bf:	76 3f                	jbe    802700 <__umoddi3+0x60>
  8026c1:	89 f2                	mov    %esi,%edx
  8026c3:	f7 f7                	div    %edi
  8026c5:	89 d0                	mov    %edx,%eax
  8026c7:	31 d2                	xor    %edx,%edx
  8026c9:	83 c4 20             	add    $0x20,%esp
  8026cc:	5e                   	pop    %esi
  8026cd:	5f                   	pop    %edi
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    
  8026d0:	39 f2                	cmp    %esi,%edx
  8026d2:	77 4c                	ja     802720 <__umoddi3+0x80>
  8026d4:	0f bd ca             	bsr    %edx,%ecx
  8026d7:	83 f1 1f             	xor    $0x1f,%ecx
  8026da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8026dd:	75 51                	jne    802730 <__umoddi3+0x90>
  8026df:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8026e2:	0f 87 e0 00 00 00    	ja     8027c8 <__umoddi3+0x128>
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	29 f8                	sub    %edi,%eax
  8026ed:	19 d6                	sbb    %edx,%esi
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	89 f2                	mov    %esi,%edx
  8026f7:	83 c4 20             	add    $0x20,%esp
  8026fa:	5e                   	pop    %esi
  8026fb:	5f                   	pop    %edi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    
  8026fe:	66 90                	xchg   %ax,%ax
  802700:	85 ff                	test   %edi,%edi
  802702:	75 0b                	jne    80270f <__umoddi3+0x6f>
  802704:	b8 01 00 00 00       	mov    $0x1,%eax
  802709:	31 d2                	xor    %edx,%edx
  80270b:	f7 f7                	div    %edi
  80270d:	89 c7                	mov    %eax,%edi
  80270f:	89 f0                	mov    %esi,%eax
  802711:	31 d2                	xor    %edx,%edx
  802713:	f7 f7                	div    %edi
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	f7 f7                	div    %edi
  80271a:	eb a9                	jmp    8026c5 <__umoddi3+0x25>
  80271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802720:	89 c8                	mov    %ecx,%eax
  802722:	89 f2                	mov    %esi,%edx
  802724:	83 c4 20             	add    $0x20,%esp
  802727:	5e                   	pop    %esi
  802728:	5f                   	pop    %edi
  802729:	5d                   	pop    %ebp
  80272a:	c3                   	ret    
  80272b:	90                   	nop
  80272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802730:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802734:	d3 e2                	shl    %cl,%edx
  802736:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802739:	ba 20 00 00 00       	mov    $0x20,%edx
  80273e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802741:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802744:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802748:	89 fa                	mov    %edi,%edx
  80274a:	d3 ea                	shr    %cl,%edx
  80274c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802750:	0b 55 f4             	or     -0xc(%ebp),%edx
  802753:	d3 e7                	shl    %cl,%edi
  802755:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802759:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80275c:	89 f2                	mov    %esi,%edx
  80275e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802761:	89 c7                	mov    %eax,%edi
  802763:	d3 ea                	shr    %cl,%edx
  802765:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802769:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80276c:	89 c2                	mov    %eax,%edx
  80276e:	d3 e6                	shl    %cl,%esi
  802770:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802774:	d3 ea                	shr    %cl,%edx
  802776:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80277a:	09 d6                	or     %edx,%esi
  80277c:	89 f0                	mov    %esi,%eax
  80277e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802781:	d3 e7                	shl    %cl,%edi
  802783:	89 f2                	mov    %esi,%edx
  802785:	f7 75 f4             	divl   -0xc(%ebp)
  802788:	89 d6                	mov    %edx,%esi
  80278a:	f7 65 e8             	mull   -0x18(%ebp)
  80278d:	39 d6                	cmp    %edx,%esi
  80278f:	72 2b                	jb     8027bc <__umoddi3+0x11c>
  802791:	39 c7                	cmp    %eax,%edi
  802793:	72 23                	jb     8027b8 <__umoddi3+0x118>
  802795:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802799:	29 c7                	sub    %eax,%edi
  80279b:	19 d6                	sbb    %edx,%esi
  80279d:	89 f0                	mov    %esi,%eax
  80279f:	89 f2                	mov    %esi,%edx
  8027a1:	d3 ef                	shr    %cl,%edi
  8027a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027a7:	d3 e0                	shl    %cl,%eax
  8027a9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027ad:	09 f8                	or     %edi,%eax
  8027af:	d3 ea                	shr    %cl,%edx
  8027b1:	83 c4 20             	add    $0x20,%esp
  8027b4:	5e                   	pop    %esi
  8027b5:	5f                   	pop    %edi
  8027b6:	5d                   	pop    %ebp
  8027b7:	c3                   	ret    
  8027b8:	39 d6                	cmp    %edx,%esi
  8027ba:	75 d9                	jne    802795 <__umoddi3+0xf5>
  8027bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027bf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8027c2:	eb d1                	jmp    802795 <__umoddi3+0xf5>
  8027c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027c8:	39 f2                	cmp    %esi,%edx
  8027ca:	0f 82 18 ff ff ff    	jb     8026e8 <__umoddi3+0x48>
  8027d0:	e9 1d ff ff ff       	jmp    8026f2 <__umoddi3+0x52>
