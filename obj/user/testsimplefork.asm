
obj/user/testsimplefork:     file format elf32-i386


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
  80002c:	e8 3b 00 00 00       	call   80006c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
#include <inc/lib.h>

void umain()
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	if (fork() == 0)
  800046:	e8 2a 12 00 00       	call   801275 <fork>
  80004b:	85 c0                	test   %eax,%eax
  80004d:	75 0e                	jne    80005d <umain+0x1d>
		cprintf("\n Hey, I'm the child process !!\n");
  80004f:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  800056:	e8 de 00 00 00       	call   800139 <cprintf>
  80005b:	eb 0c                	jmp    800069 <umain+0x29>
	else
		cprintf("\n Hey, I'm the parent process !!\n");
  80005d:	c7 04 24 a4 2c 80 00 	movl   $0x802ca4,(%esp)
  800064:	e8 d0 00 00 00       	call   800139 <cprintf>
}
  800069:	c9                   	leave  
  80006a:	c3                   	ret    
	...

0080006c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80006c:	55                   	push   %ebp
  80006d:	89 e5                	mov    %esp,%ebp
  80006f:	83 ec 18             	sub    $0x18,%esp
  800072:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800075:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800078:	8b 75 08             	mov    0x8(%ebp),%esi
  80007b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80007e:	e8 fb 0f 00 00       	call   80107e <sys_getenvid>
	env = &envs[ENVX(envid)];
  800083:	25 ff 03 00 00       	and    $0x3ff,%eax
  800088:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80008b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800090:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800095:	85 f6                	test   %esi,%esi
  800097:	7e 07                	jle    8000a0 <libmain+0x34>
		binaryname = argv[0];
  800099:	8b 03                	mov    (%ebx),%eax
  80009b:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  8000a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a4:	89 34 24             	mov    %esi,(%esp)
  8000a7:	e8 94 ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  8000ac:	e8 0b 00 00 00       	call   8000bc <exit>
}
  8000b1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000b4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000b7:	89 ec                	mov    %ebp,%esp
  8000b9:	5d                   	pop    %ebp
  8000ba:	c3                   	ret    
	...

008000bc <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8000bc:	55                   	push   %ebp
  8000bd:	89 e5                	mov    %esp,%ebp
  8000bf:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000c2:	e8 e4 18 00 00       	call   8019ab <close_all>
	sys_env_destroy(0);
  8000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ce:	e8 df 0f 00 00       	call   8010b2 <sys_env_destroy>
}
  8000d3:	c9                   	leave  
  8000d4:	c3                   	ret    
  8000d5:	00 00                	add    %al,(%eax)
	...

008000d8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8000e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000e8:	00 00 00 
	b.cnt = 0;
  8000eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000f2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800103:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800109:	89 44 24 04          	mov    %eax,0x4(%esp)
  80010d:	c7 04 24 53 01 80 00 	movl   $0x800153,(%esp)
  800114:	e8 d4 01 00 00       	call   8002ed <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800119:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80011f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800123:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800129:	89 04 24             	mov    %eax,(%esp)
  80012c:	e8 bf 0a 00 00       	call   800bf0 <sys_cputs>

	return b.cnt;
}
  800131:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800137:	c9                   	leave  
  800138:	c3                   	ret    

00800139 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80013f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800142:	89 44 24 04          	mov    %eax,0x4(%esp)
  800146:	8b 45 08             	mov    0x8(%ebp),%eax
  800149:	89 04 24             	mov    %eax,(%esp)
  80014c:	e8 87 ff ff ff       	call   8000d8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800151:	c9                   	leave  
  800152:	c3                   	ret    

00800153 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	53                   	push   %ebx
  800157:	83 ec 14             	sub    $0x14,%esp
  80015a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015d:	8b 03                	mov    (%ebx),%eax
  80015f:	8b 55 08             	mov    0x8(%ebp),%edx
  800162:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800166:	83 c0 01             	add    $0x1,%eax
  800169:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80016b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800170:	75 19                	jne    80018b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800172:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800179:	00 
  80017a:	8d 43 08             	lea    0x8(%ebx),%eax
  80017d:	89 04 24             	mov    %eax,(%esp)
  800180:	e8 6b 0a 00 00       	call   800bf0 <sys_cputs>
		b->idx = 0;
  800185:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80018b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80018f:	83 c4 14             	add    $0x14,%esp
  800192:	5b                   	pop    %ebx
  800193:	5d                   	pop    %ebp
  800194:	c3                   	ret    
	...

008001a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	57                   	push   %edi
  8001a4:	56                   	push   %esi
  8001a5:	53                   	push   %ebx
  8001a6:	83 ec 4c             	sub    $0x4c,%esp
  8001a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001ac:	89 d6                	mov    %edx,%esi
  8001ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001c0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001cb:	39 d1                	cmp    %edx,%ecx
  8001cd:	72 15                	jb     8001e4 <printnum+0x44>
  8001cf:	77 07                	ja     8001d8 <printnum+0x38>
  8001d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001d4:	39 d0                	cmp    %edx,%eax
  8001d6:	76 0c                	jbe    8001e4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001d8:	83 eb 01             	sub    $0x1,%ebx
  8001db:	85 db                	test   %ebx,%ebx
  8001dd:	8d 76 00             	lea    0x0(%esi),%esi
  8001e0:	7f 61                	jg     800243 <printnum+0xa3>
  8001e2:	eb 70                	jmp    800254 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8001e8:	83 eb 01             	sub    $0x1,%ebx
  8001eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8001f7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8001fb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8001fe:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800201:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800204:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800208:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80020f:	00 
  800210:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800213:	89 04 24             	mov    %eax,(%esp)
  800216:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800219:	89 54 24 04          	mov    %edx,0x4(%esp)
  80021d:	e8 ee 27 00 00       	call   802a10 <__udivdi3>
  800222:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800225:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800228:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80022c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800230:	89 04 24             	mov    %eax,(%esp)
  800233:	89 54 24 04          	mov    %edx,0x4(%esp)
  800237:	89 f2                	mov    %esi,%edx
  800239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023c:	e8 5f ff ff ff       	call   8001a0 <printnum>
  800241:	eb 11                	jmp    800254 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800243:	89 74 24 04          	mov    %esi,0x4(%esp)
  800247:	89 3c 24             	mov    %edi,(%esp)
  80024a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80024d:	83 eb 01             	sub    $0x1,%ebx
  800250:	85 db                	test   %ebx,%ebx
  800252:	7f ef                	jg     800243 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800254:	89 74 24 04          	mov    %esi,0x4(%esp)
  800258:	8b 74 24 04          	mov    0x4(%esp),%esi
  80025c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800263:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80026a:	00 
  80026b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80026e:	89 14 24             	mov    %edx,(%esp)
  800271:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800274:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800278:	e8 c3 28 00 00       	call   802b40 <__umoddi3>
  80027d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800281:	0f be 80 dd 2c 80 00 	movsbl 0x802cdd(%eax),%eax
  800288:	89 04 24             	mov    %eax,(%esp)
  80028b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80028e:	83 c4 4c             	add    $0x4c,%esp
  800291:	5b                   	pop    %ebx
  800292:	5e                   	pop    %esi
  800293:	5f                   	pop    %edi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800299:	83 fa 01             	cmp    $0x1,%edx
  80029c:	7e 0e                	jle    8002ac <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80029e:	8b 10                	mov    (%eax),%edx
  8002a0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002a3:	89 08                	mov    %ecx,(%eax)
  8002a5:	8b 02                	mov    (%edx),%eax
  8002a7:	8b 52 04             	mov    0x4(%edx),%edx
  8002aa:	eb 22                	jmp    8002ce <getuint+0x38>
	else if (lflag)
  8002ac:	85 d2                	test   %edx,%edx
  8002ae:	74 10                	je     8002c0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002b0:	8b 10                	mov    (%eax),%edx
  8002b2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002b5:	89 08                	mov    %ecx,(%eax)
  8002b7:	8b 02                	mov    (%edx),%eax
  8002b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002be:	eb 0e                	jmp    8002ce <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002c0:	8b 10                	mov    (%eax),%edx
  8002c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002c5:	89 08                	mov    %ecx,(%eax)
  8002c7:	8b 02                	mov    (%edx),%eax
  8002c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002da:	8b 10                	mov    (%eax),%edx
  8002dc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002df:	73 0a                	jae    8002eb <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e4:	88 0a                	mov    %cl,(%edx)
  8002e6:	83 c2 01             	add    $0x1,%edx
  8002e9:	89 10                	mov    %edx,(%eax)
}
  8002eb:	5d                   	pop    %ebp
  8002ec:	c3                   	ret    

008002ed <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 5c             	sub    $0x5c,%esp
  8002f6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002f9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8002ff:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800306:	eb 11                	jmp    800319 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800308:	85 c0                	test   %eax,%eax
  80030a:	0f 84 ec 03 00 00    	je     8006fc <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800310:	89 74 24 04          	mov    %esi,0x4(%esp)
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800319:	0f b6 03             	movzbl (%ebx),%eax
  80031c:	83 c3 01             	add    $0x1,%ebx
  80031f:	83 f8 25             	cmp    $0x25,%eax
  800322:	75 e4                	jne    800308 <vprintfmt+0x1b>
  800324:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800328:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80032f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800336:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80033d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800342:	eb 06                	jmp    80034a <vprintfmt+0x5d>
  800344:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800348:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80034a:	0f b6 13             	movzbl (%ebx),%edx
  80034d:	0f b6 c2             	movzbl %dl,%eax
  800350:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800353:	8d 43 01             	lea    0x1(%ebx),%eax
  800356:	83 ea 23             	sub    $0x23,%edx
  800359:	80 fa 55             	cmp    $0x55,%dl
  80035c:	0f 87 7d 03 00 00    	ja     8006df <vprintfmt+0x3f2>
  800362:	0f b6 d2             	movzbl %dl,%edx
  800365:	ff 24 95 20 2e 80 00 	jmp    *0x802e20(,%edx,4)
  80036c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800370:	eb d6                	jmp    800348 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800372:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800375:	83 ea 30             	sub    $0x30,%edx
  800378:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80037b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80037e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800381:	83 fb 09             	cmp    $0x9,%ebx
  800384:	77 4c                	ja     8003d2 <vprintfmt+0xe5>
  800386:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800389:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80038c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80038f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800392:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800396:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800399:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80039c:	83 fb 09             	cmp    $0x9,%ebx
  80039f:	76 eb                	jbe    80038c <vprintfmt+0x9f>
  8003a1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003a4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003a7:	eb 29                	jmp    8003d2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003a9:	8b 55 14             	mov    0x14(%ebp),%edx
  8003ac:	8d 5a 04             	lea    0x4(%edx),%ebx
  8003af:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8003b2:	8b 12                	mov    (%edx),%edx
  8003b4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8003b7:	eb 19                	jmp    8003d2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8003b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003bc:	c1 fa 1f             	sar    $0x1f,%edx
  8003bf:	f7 d2                	not    %edx
  8003c1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8003c4:	eb 82                	jmp    800348 <vprintfmt+0x5b>
  8003c6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003cd:	e9 76 ff ff ff       	jmp    800348 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8003d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003d6:	0f 89 6c ff ff ff    	jns    800348 <vprintfmt+0x5b>
  8003dc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8003df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003e2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8003e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8003e8:	e9 5b ff ff ff       	jmp    800348 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003ed:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8003f0:	e9 53 ff ff ff       	jmp    800348 <vprintfmt+0x5b>
  8003f5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fb:	8d 50 04             	lea    0x4(%eax),%edx
  8003fe:	89 55 14             	mov    %edx,0x14(%ebp)
  800401:	89 74 24 04          	mov    %esi,0x4(%esp)
  800405:	8b 00                	mov    (%eax),%eax
  800407:	89 04 24             	mov    %eax,(%esp)
  80040a:	ff d7                	call   *%edi
  80040c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80040f:	e9 05 ff ff ff       	jmp    800319 <vprintfmt+0x2c>
  800414:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	8d 50 04             	lea    0x4(%eax),%edx
  80041d:	89 55 14             	mov    %edx,0x14(%ebp)
  800420:	8b 00                	mov    (%eax),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	c1 fa 1f             	sar    $0x1f,%edx
  800427:	31 d0                	xor    %edx,%eax
  800429:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80042b:	83 f8 0f             	cmp    $0xf,%eax
  80042e:	7f 0b                	jg     80043b <vprintfmt+0x14e>
  800430:	8b 14 85 80 2f 80 00 	mov    0x802f80(,%eax,4),%edx
  800437:	85 d2                	test   %edx,%edx
  800439:	75 20                	jne    80045b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80043b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80043f:	c7 44 24 08 ee 2c 80 	movl   $0x802cee,0x8(%esp)
  800446:	00 
  800447:	89 74 24 04          	mov    %esi,0x4(%esp)
  80044b:	89 3c 24             	mov    %edi,(%esp)
  80044e:	e8 31 03 00 00       	call   800784 <printfmt>
  800453:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800456:	e9 be fe ff ff       	jmp    800319 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80045b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80045f:	c7 44 24 08 b6 32 80 	movl   $0x8032b6,0x8(%esp)
  800466:	00 
  800467:	89 74 24 04          	mov    %esi,0x4(%esp)
  80046b:	89 3c 24             	mov    %edi,(%esp)
  80046e:	e8 11 03 00 00       	call   800784 <printfmt>
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e9 9e fe ff ff       	jmp    800319 <vprintfmt+0x2c>
  80047b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80047e:	89 c3                	mov    %eax,%ebx
  800480:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800486:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800489:	8b 45 14             	mov    0x14(%ebp),%eax
  80048c:	8d 50 04             	lea    0x4(%eax),%edx
  80048f:	89 55 14             	mov    %edx,0x14(%ebp)
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800497:	85 c0                	test   %eax,%eax
  800499:	75 07                	jne    8004a2 <vprintfmt+0x1b5>
  80049b:	c7 45 e0 f7 2c 80 00 	movl   $0x802cf7,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8004a2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8004a6:	7e 06                	jle    8004ae <vprintfmt+0x1c1>
  8004a8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004ac:	75 13                	jne    8004c1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b1:	0f be 02             	movsbl (%edx),%eax
  8004b4:	85 c0                	test   %eax,%eax
  8004b6:	0f 85 99 00 00 00    	jne    800555 <vprintfmt+0x268>
  8004bc:	e9 86 00 00 00       	jmp    800547 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c8:	89 0c 24             	mov    %ecx,(%esp)
  8004cb:	e8 fb 02 00 00       	call   8007cb <strnlen>
  8004d0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d3:	29 c2                	sub    %eax,%edx
  8004d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004d8:	85 d2                	test   %edx,%edx
  8004da:	7e d2                	jle    8004ae <vprintfmt+0x1c1>
					putch(padc, putdat);
  8004dc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8004e0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004e3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8004e6:	89 d3                	mov    %edx,%ebx
  8004e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ef:	89 04 24             	mov    %eax,(%esp)
  8004f2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f4:	83 eb 01             	sub    $0x1,%ebx
  8004f7:	85 db                	test   %ebx,%ebx
  8004f9:	7f ed                	jg     8004e8 <vprintfmt+0x1fb>
  8004fb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800505:	eb a7                	jmp    8004ae <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800507:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80050b:	74 18                	je     800525 <vprintfmt+0x238>
  80050d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800510:	83 fa 5e             	cmp    $0x5e,%edx
  800513:	76 10                	jbe    800525 <vprintfmt+0x238>
					putch('?', putdat);
  800515:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800519:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800520:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800523:	eb 0a                	jmp    80052f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800525:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800529:	89 04 24             	mov    %eax,(%esp)
  80052c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80052f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800533:	0f be 03             	movsbl (%ebx),%eax
  800536:	85 c0                	test   %eax,%eax
  800538:	74 05                	je     80053f <vprintfmt+0x252>
  80053a:	83 c3 01             	add    $0x1,%ebx
  80053d:	eb 29                	jmp    800568 <vprintfmt+0x27b>
  80053f:	89 fe                	mov    %edi,%esi
  800541:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800544:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800547:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80054b:	7f 2e                	jg     80057b <vprintfmt+0x28e>
  80054d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800550:	e9 c4 fd ff ff       	jmp    800319 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800555:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800558:	83 c2 01             	add    $0x1,%edx
  80055b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80055e:	89 f7                	mov    %esi,%edi
  800560:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800563:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800566:	89 d3                	mov    %edx,%ebx
  800568:	85 f6                	test   %esi,%esi
  80056a:	78 9b                	js     800507 <vprintfmt+0x21a>
  80056c:	83 ee 01             	sub    $0x1,%esi
  80056f:	79 96                	jns    800507 <vprintfmt+0x21a>
  800571:	89 fe                	mov    %edi,%esi
  800573:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800576:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800579:	eb cc                	jmp    800547 <vprintfmt+0x25a>
  80057b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80057e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800581:	89 74 24 04          	mov    %esi,0x4(%esp)
  800585:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80058c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80058e:	83 eb 01             	sub    $0x1,%ebx
  800591:	85 db                	test   %ebx,%ebx
  800593:	7f ec                	jg     800581 <vprintfmt+0x294>
  800595:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800598:	e9 7c fd ff ff       	jmp    800319 <vprintfmt+0x2c>
  80059d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005a0:	83 f9 01             	cmp    $0x1,%ecx
  8005a3:	7e 16                	jle    8005bb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8d 50 08             	lea    0x8(%eax),%edx
  8005ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ae:	8b 10                	mov    (%eax),%edx
  8005b0:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8005b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b9:	eb 32                	jmp    8005ed <vprintfmt+0x300>
	else if (lflag)
  8005bb:	85 c9                	test   %ecx,%ecx
  8005bd:	74 18                	je     8005d7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 50 04             	lea    0x4(%eax),%edx
  8005c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cd:	89 c1                	mov    %eax,%ecx
  8005cf:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d5:	eb 16                	jmp    8005ed <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 50 04             	lea    0x4(%eax),%edx
  8005dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e5:	89 c2                	mov    %eax,%edx
  8005e7:	c1 fa 1f             	sar    $0x1f,%edx
  8005ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005ed:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005f0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005f8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005fc:	0f 89 9b 00 00 00    	jns    80069d <vprintfmt+0x3b0>
				putch('-', putdat);
  800602:	89 74 24 04          	mov    %esi,0x4(%esp)
  800606:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80060d:	ff d7                	call   *%edi
				num = -(long long) num;
  80060f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800612:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800615:	f7 d9                	neg    %ecx
  800617:	83 d3 00             	adc    $0x0,%ebx
  80061a:	f7 db                	neg    %ebx
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800621:	eb 7a                	jmp    80069d <vprintfmt+0x3b0>
  800623:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800626:	89 ca                	mov    %ecx,%edx
  800628:	8d 45 14             	lea    0x14(%ebp),%eax
  80062b:	e8 66 fc ff ff       	call   800296 <getuint>
  800630:	89 c1                	mov    %eax,%ecx
  800632:	89 d3                	mov    %edx,%ebx
  800634:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800639:	eb 62                	jmp    80069d <vprintfmt+0x3b0>
  80063b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80063e:	89 ca                	mov    %ecx,%edx
  800640:	8d 45 14             	lea    0x14(%ebp),%eax
  800643:	e8 4e fc ff ff       	call   800296 <getuint>
  800648:	89 c1                	mov    %eax,%ecx
  80064a:	89 d3                	mov    %edx,%ebx
  80064c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800651:	eb 4a                	jmp    80069d <vprintfmt+0x3b0>
  800653:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800656:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800661:	ff d7                	call   *%edi
			putch('x', putdat);
  800663:	89 74 24 04          	mov    %esi,0x4(%esp)
  800667:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80066e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 50 04             	lea    0x4(%eax),%edx
  800676:	89 55 14             	mov    %edx,0x14(%ebp)
  800679:	8b 08                	mov    (%eax),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800685:	eb 16                	jmp    80069d <vprintfmt+0x3b0>
  800687:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80068a:	89 ca                	mov    %ecx,%edx
  80068c:	8d 45 14             	lea    0x14(%ebp),%eax
  80068f:	e8 02 fc ff ff       	call   800296 <getuint>
  800694:	89 c1                	mov    %eax,%ecx
  800696:	89 d3                	mov    %edx,%ebx
  800698:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80069d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8006a1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006b0:	89 0c 24             	mov    %ecx,(%esp)
  8006b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006b7:	89 f2                	mov    %esi,%edx
  8006b9:	89 f8                	mov    %edi,%eax
  8006bb:	e8 e0 fa ff ff       	call   8001a0 <printnum>
  8006c0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006c3:	e9 51 fc ff ff       	jmp    800319 <vprintfmt+0x2c>
  8006c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8006cb:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d2:	89 14 24             	mov    %edx,(%esp)
  8006d5:	ff d7                	call   *%edi
  8006d7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006da:	e9 3a fc ff ff       	jmp    800319 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006ea:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8006ef:	80 38 25             	cmpb   $0x25,(%eax)
  8006f2:	0f 84 21 fc ff ff    	je     800319 <vprintfmt+0x2c>
  8006f8:	89 c3                	mov    %eax,%ebx
  8006fa:	eb f0                	jmp    8006ec <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8006fc:	83 c4 5c             	add    $0x5c,%esp
  8006ff:	5b                   	pop    %ebx
  800700:	5e                   	pop    %esi
  800701:	5f                   	pop    %edi
  800702:	5d                   	pop    %ebp
  800703:	c3                   	ret    

00800704 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 28             	sub    $0x28,%esp
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800710:	85 c0                	test   %eax,%eax
  800712:	74 04                	je     800718 <vsnprintf+0x14>
  800714:	85 d2                	test   %edx,%edx
  800716:	7f 07                	jg     80071f <vsnprintf+0x1b>
  800718:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80071d:	eb 3b                	jmp    80075a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80071f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800722:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800726:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800729:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800737:	8b 45 10             	mov    0x10(%ebp),%eax
  80073a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80073e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800741:	89 44 24 04          	mov    %eax,0x4(%esp)
  800745:	c7 04 24 d0 02 80 00 	movl   $0x8002d0,(%esp)
  80074c:	e8 9c fb ff ff       	call   8002ed <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800754:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800757:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800765:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800769:	8b 45 10             	mov    0x10(%ebp),%eax
  80076c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800770:	8b 45 0c             	mov    0xc(%ebp),%eax
  800773:	89 44 24 04          	mov    %eax,0x4(%esp)
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 04 24             	mov    %eax,(%esp)
  80077d:	e8 82 ff ff ff       	call   800704 <vsnprintf>
	va_end(ap);

	return rc;
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80078a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80078d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800791:	8b 45 10             	mov    0x10(%ebp),%eax
  800794:	89 44 24 08          	mov    %eax,0x8(%esp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	89 04 24             	mov    %eax,(%esp)
  8007a5:	e8 43 fb ff ff       	call   8002ed <vprintfmt>
	va_end(ap);
}
  8007aa:	c9                   	leave  
  8007ab:	c3                   	ret    
  8007ac:	00 00                	add    %al,(%eax)
	...

008007b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bb:	80 3a 00             	cmpb   $0x0,(%edx)
  8007be:	74 09                	je     8007c9 <strlen+0x19>
		n++;
  8007c0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c7:	75 f7                	jne    8007c0 <strlen+0x10>
		n++;
	return n;
}
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	53                   	push   %ebx
  8007cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d5:	85 c9                	test   %ecx,%ecx
  8007d7:	74 19                	je     8007f2 <strnlen+0x27>
  8007d9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007dc:	74 14                	je     8007f2 <strnlen+0x27>
  8007de:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8007e3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e6:	39 c8                	cmp    %ecx,%eax
  8007e8:	74 0d                	je     8007f7 <strnlen+0x2c>
  8007ea:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8007ee:	75 f3                	jne    8007e3 <strnlen+0x18>
  8007f0:	eb 05                	jmp    8007f7 <strnlen+0x2c>
  8007f2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8007f7:	5b                   	pop    %ebx
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800809:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80080d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800810:	83 c2 01             	add    $0x1,%edx
  800813:	84 c9                	test   %cl,%cl
  800815:	75 f2                	jne    800809 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800817:	5b                   	pop    %ebx
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	56                   	push   %esi
  80081e:	53                   	push   %ebx
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	8b 55 0c             	mov    0xc(%ebp),%edx
  800825:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800828:	85 f6                	test   %esi,%esi
  80082a:	74 18                	je     800844 <strncpy+0x2a>
  80082c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800831:	0f b6 1a             	movzbl (%edx),%ebx
  800834:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800837:	80 3a 01             	cmpb   $0x1,(%edx)
  80083a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80083d:	83 c1 01             	add    $0x1,%ecx
  800840:	39 ce                	cmp    %ecx,%esi
  800842:	77 ed                	ja     800831 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800844:	5b                   	pop    %ebx
  800845:	5e                   	pop    %esi
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	56                   	push   %esi
  80084c:	53                   	push   %ebx
  80084d:	8b 75 08             	mov    0x8(%ebp),%esi
  800850:	8b 55 0c             	mov    0xc(%ebp),%edx
  800853:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800856:	89 f0                	mov    %esi,%eax
  800858:	85 c9                	test   %ecx,%ecx
  80085a:	74 27                	je     800883 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80085c:	83 e9 01             	sub    $0x1,%ecx
  80085f:	74 1d                	je     80087e <strlcpy+0x36>
  800861:	0f b6 1a             	movzbl (%edx),%ebx
  800864:	84 db                	test   %bl,%bl
  800866:	74 16                	je     80087e <strlcpy+0x36>
			*dst++ = *src++;
  800868:	88 18                	mov    %bl,(%eax)
  80086a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80086d:	83 e9 01             	sub    $0x1,%ecx
  800870:	74 0e                	je     800880 <strlcpy+0x38>
			*dst++ = *src++;
  800872:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800875:	0f b6 1a             	movzbl (%edx),%ebx
  800878:	84 db                	test   %bl,%bl
  80087a:	75 ec                	jne    800868 <strlcpy+0x20>
  80087c:	eb 02                	jmp    800880 <strlcpy+0x38>
  80087e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800880:	c6 00 00             	movb   $0x0,(%eax)
  800883:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800885:	5b                   	pop    %ebx
  800886:	5e                   	pop    %esi
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800892:	0f b6 01             	movzbl (%ecx),%eax
  800895:	84 c0                	test   %al,%al
  800897:	74 15                	je     8008ae <strcmp+0x25>
  800899:	3a 02                	cmp    (%edx),%al
  80089b:	75 11                	jne    8008ae <strcmp+0x25>
		p++, q++;
  80089d:	83 c1 01             	add    $0x1,%ecx
  8008a0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008a3:	0f b6 01             	movzbl (%ecx),%eax
  8008a6:	84 c0                	test   %al,%al
  8008a8:	74 04                	je     8008ae <strcmp+0x25>
  8008aa:	3a 02                	cmp    (%edx),%al
  8008ac:	74 ef                	je     80089d <strcmp+0x14>
  8008ae:	0f b6 c0             	movzbl %al,%eax
  8008b1:	0f b6 12             	movzbl (%edx),%edx
  8008b4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  8008c5:	85 c0                	test   %eax,%eax
  8008c7:	74 23                	je     8008ec <strncmp+0x34>
  8008c9:	0f b6 1a             	movzbl (%edx),%ebx
  8008cc:	84 db                	test   %bl,%bl
  8008ce:	74 24                	je     8008f4 <strncmp+0x3c>
  8008d0:	3a 19                	cmp    (%ecx),%bl
  8008d2:	75 20                	jne    8008f4 <strncmp+0x3c>
  8008d4:	83 e8 01             	sub    $0x1,%eax
  8008d7:	74 13                	je     8008ec <strncmp+0x34>
		n--, p++, q++;
  8008d9:	83 c2 01             	add    $0x1,%edx
  8008dc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008df:	0f b6 1a             	movzbl (%edx),%ebx
  8008e2:	84 db                	test   %bl,%bl
  8008e4:	74 0e                	je     8008f4 <strncmp+0x3c>
  8008e6:	3a 19                	cmp    (%ecx),%bl
  8008e8:	74 ea                	je     8008d4 <strncmp+0x1c>
  8008ea:	eb 08                	jmp    8008f4 <strncmp+0x3c>
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008f1:	5b                   	pop    %ebx
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f4:	0f b6 02             	movzbl (%edx),%eax
  8008f7:	0f b6 11             	movzbl (%ecx),%edx
  8008fa:	29 d0                	sub    %edx,%eax
  8008fc:	eb f3                	jmp    8008f1 <strncmp+0x39>

008008fe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800908:	0f b6 10             	movzbl (%eax),%edx
  80090b:	84 d2                	test   %dl,%dl
  80090d:	74 15                	je     800924 <strchr+0x26>
		if (*s == c)
  80090f:	38 ca                	cmp    %cl,%dl
  800911:	75 07                	jne    80091a <strchr+0x1c>
  800913:	eb 14                	jmp    800929 <strchr+0x2b>
  800915:	38 ca                	cmp    %cl,%dl
  800917:	90                   	nop
  800918:	74 0f                	je     800929 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	0f b6 10             	movzbl (%eax),%edx
  800920:	84 d2                	test   %dl,%dl
  800922:	75 f1                	jne    800915 <strchr+0x17>
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800935:	0f b6 10             	movzbl (%eax),%edx
  800938:	84 d2                	test   %dl,%dl
  80093a:	74 18                	je     800954 <strfind+0x29>
		if (*s == c)
  80093c:	38 ca                	cmp    %cl,%dl
  80093e:	75 0a                	jne    80094a <strfind+0x1f>
  800940:	eb 12                	jmp    800954 <strfind+0x29>
  800942:	38 ca                	cmp    %cl,%dl
  800944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800948:	74 0a                	je     800954 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80094a:	83 c0 01             	add    $0x1,%eax
  80094d:	0f b6 10             	movzbl (%eax),%edx
  800950:	84 d2                	test   %dl,%dl
  800952:	75 ee                	jne    800942 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 0c             	sub    $0xc,%esp
  80095c:	89 1c 24             	mov    %ebx,(%esp)
  80095f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800963:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800967:	8b 7d 08             	mov    0x8(%ebp),%edi
  80096a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800970:	85 c9                	test   %ecx,%ecx
  800972:	74 30                	je     8009a4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800974:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80097a:	75 25                	jne    8009a1 <memset+0x4b>
  80097c:	f6 c1 03             	test   $0x3,%cl
  80097f:	75 20                	jne    8009a1 <memset+0x4b>
		c &= 0xFF;
  800981:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800984:	89 d3                	mov    %edx,%ebx
  800986:	c1 e3 08             	shl    $0x8,%ebx
  800989:	89 d6                	mov    %edx,%esi
  80098b:	c1 e6 18             	shl    $0x18,%esi
  80098e:	89 d0                	mov    %edx,%eax
  800990:	c1 e0 10             	shl    $0x10,%eax
  800993:	09 f0                	or     %esi,%eax
  800995:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800997:	09 d8                	or     %ebx,%eax
  800999:	c1 e9 02             	shr    $0x2,%ecx
  80099c:	fc                   	cld    
  80099d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80099f:	eb 03                	jmp    8009a4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a1:	fc                   	cld    
  8009a2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009a4:	89 f8                	mov    %edi,%eax
  8009a6:	8b 1c 24             	mov    (%esp),%ebx
  8009a9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009ad:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009b1:	89 ec                	mov    %ebp,%esp
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	89 34 24             	mov    %esi,(%esp)
  8009be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8009c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009cb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009cd:	39 c6                	cmp    %eax,%esi
  8009cf:	73 35                	jae    800a06 <memmove+0x51>
  8009d1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d4:	39 d0                	cmp    %edx,%eax
  8009d6:	73 2e                	jae    800a06 <memmove+0x51>
		s += n;
		d += n;
  8009d8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009da:	f6 c2 03             	test   $0x3,%dl
  8009dd:	75 1b                	jne    8009fa <memmove+0x45>
  8009df:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009e5:	75 13                	jne    8009fa <memmove+0x45>
  8009e7:	f6 c1 03             	test   $0x3,%cl
  8009ea:	75 0e                	jne    8009fa <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8009ec:	83 ef 04             	sub    $0x4,%edi
  8009ef:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f2:	c1 e9 02             	shr    $0x2,%ecx
  8009f5:	fd                   	std    
  8009f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f8:	eb 09                	jmp    800a03 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009fa:	83 ef 01             	sub    $0x1,%edi
  8009fd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a00:	fd                   	std    
  800a01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a03:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a04:	eb 20                	jmp    800a26 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a06:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0c:	75 15                	jne    800a23 <memmove+0x6e>
  800a0e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a14:	75 0d                	jne    800a23 <memmove+0x6e>
  800a16:	f6 c1 03             	test   $0x3,%cl
  800a19:	75 08                	jne    800a23 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a1b:	c1 e9 02             	shr    $0x2,%ecx
  800a1e:	fc                   	cld    
  800a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a21:	eb 03                	jmp    800a26 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a23:	fc                   	cld    
  800a24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a26:	8b 34 24             	mov    (%esp),%esi
  800a29:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a2d:	89 ec                	mov    %ebp,%esp
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a37:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	89 04 24             	mov    %eax,(%esp)
  800a4b:	e8 65 ff ff ff       	call   8009b5 <memmove>
}
  800a50:	c9                   	leave  
  800a51:	c3                   	ret    

00800a52 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	57                   	push   %edi
  800a56:	56                   	push   %esi
  800a57:	53                   	push   %ebx
  800a58:	8b 75 08             	mov    0x8(%ebp),%esi
  800a5b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a61:	85 c9                	test   %ecx,%ecx
  800a63:	74 36                	je     800a9b <memcmp+0x49>
		if (*s1 != *s2)
  800a65:	0f b6 06             	movzbl (%esi),%eax
  800a68:	0f b6 1f             	movzbl (%edi),%ebx
  800a6b:	38 d8                	cmp    %bl,%al
  800a6d:	74 20                	je     800a8f <memcmp+0x3d>
  800a6f:	eb 14                	jmp    800a85 <memcmp+0x33>
  800a71:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800a76:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800a7b:	83 c2 01             	add    $0x1,%edx
  800a7e:	83 e9 01             	sub    $0x1,%ecx
  800a81:	38 d8                	cmp    %bl,%al
  800a83:	74 12                	je     800a97 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800a85:	0f b6 c0             	movzbl %al,%eax
  800a88:	0f b6 db             	movzbl %bl,%ebx
  800a8b:	29 d8                	sub    %ebx,%eax
  800a8d:	eb 11                	jmp    800aa0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8f:	83 e9 01             	sub    $0x1,%ecx
  800a92:	ba 00 00 00 00       	mov    $0x0,%edx
  800a97:	85 c9                	test   %ecx,%ecx
  800a99:	75 d6                	jne    800a71 <memcmp+0x1f>
  800a9b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800aa0:	5b                   	pop    %ebx
  800aa1:	5e                   	pop    %esi
  800aa2:	5f                   	pop    %edi
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800aab:	89 c2                	mov    %eax,%edx
  800aad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab0:	39 d0                	cmp    %edx,%eax
  800ab2:	73 15                	jae    800ac9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ab8:	38 08                	cmp    %cl,(%eax)
  800aba:	75 06                	jne    800ac2 <memfind+0x1d>
  800abc:	eb 0b                	jmp    800ac9 <memfind+0x24>
  800abe:	38 08                	cmp    %cl,(%eax)
  800ac0:	74 07                	je     800ac9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ac2:	83 c0 01             	add    $0x1,%eax
  800ac5:	39 c2                	cmp    %eax,%edx
  800ac7:	77 f5                	ja     800abe <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	57                   	push   %edi
  800acf:	56                   	push   %esi
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ada:	0f b6 02             	movzbl (%edx),%eax
  800add:	3c 20                	cmp    $0x20,%al
  800adf:	74 04                	je     800ae5 <strtol+0x1a>
  800ae1:	3c 09                	cmp    $0x9,%al
  800ae3:	75 0e                	jne    800af3 <strtol+0x28>
		s++;
  800ae5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae8:	0f b6 02             	movzbl (%edx),%eax
  800aeb:	3c 20                	cmp    $0x20,%al
  800aed:	74 f6                	je     800ae5 <strtol+0x1a>
  800aef:	3c 09                	cmp    $0x9,%al
  800af1:	74 f2                	je     800ae5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800af3:	3c 2b                	cmp    $0x2b,%al
  800af5:	75 0c                	jne    800b03 <strtol+0x38>
		s++;
  800af7:	83 c2 01             	add    $0x1,%edx
  800afa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b01:	eb 15                	jmp    800b18 <strtol+0x4d>
	else if (*s == '-')
  800b03:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b0a:	3c 2d                	cmp    $0x2d,%al
  800b0c:	75 0a                	jne    800b18 <strtol+0x4d>
		s++, neg = 1;
  800b0e:	83 c2 01             	add    $0x1,%edx
  800b11:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b18:	85 db                	test   %ebx,%ebx
  800b1a:	0f 94 c0             	sete   %al
  800b1d:	74 05                	je     800b24 <strtol+0x59>
  800b1f:	83 fb 10             	cmp    $0x10,%ebx
  800b22:	75 18                	jne    800b3c <strtol+0x71>
  800b24:	80 3a 30             	cmpb   $0x30,(%edx)
  800b27:	75 13                	jne    800b3c <strtol+0x71>
  800b29:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b2d:	8d 76 00             	lea    0x0(%esi),%esi
  800b30:	75 0a                	jne    800b3c <strtol+0x71>
		s += 2, base = 16;
  800b32:	83 c2 02             	add    $0x2,%edx
  800b35:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3a:	eb 15                	jmp    800b51 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b3c:	84 c0                	test   %al,%al
  800b3e:	66 90                	xchg   %ax,%ax
  800b40:	74 0f                	je     800b51 <strtol+0x86>
  800b42:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b47:	80 3a 30             	cmpb   $0x30,(%edx)
  800b4a:	75 05                	jne    800b51 <strtol+0x86>
		s++, base = 8;
  800b4c:	83 c2 01             	add    $0x1,%edx
  800b4f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b58:	0f b6 0a             	movzbl (%edx),%ecx
  800b5b:	89 cf                	mov    %ecx,%edi
  800b5d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b60:	80 fb 09             	cmp    $0x9,%bl
  800b63:	77 08                	ja     800b6d <strtol+0xa2>
			dig = *s - '0';
  800b65:	0f be c9             	movsbl %cl,%ecx
  800b68:	83 e9 30             	sub    $0x30,%ecx
  800b6b:	eb 1e                	jmp    800b8b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800b6d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b70:	80 fb 19             	cmp    $0x19,%bl
  800b73:	77 08                	ja     800b7d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800b75:	0f be c9             	movsbl %cl,%ecx
  800b78:	83 e9 57             	sub    $0x57,%ecx
  800b7b:	eb 0e                	jmp    800b8b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800b7d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b80:	80 fb 19             	cmp    $0x19,%bl
  800b83:	77 15                	ja     800b9a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800b85:	0f be c9             	movsbl %cl,%ecx
  800b88:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b8b:	39 f1                	cmp    %esi,%ecx
  800b8d:	7d 0b                	jge    800b9a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800b8f:	83 c2 01             	add    $0x1,%edx
  800b92:	0f af c6             	imul   %esi,%eax
  800b95:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b98:	eb be                	jmp    800b58 <strtol+0x8d>
  800b9a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba0:	74 05                	je     800ba7 <strtol+0xdc>
		*endptr = (char *) s;
  800ba2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ba5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ba7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bab:	74 04                	je     800bb1 <strtol+0xe6>
  800bad:	89 c8                	mov    %ecx,%eax
  800baf:	f7 d8                	neg    %eax
}
  800bb1:	83 c4 04             	add    $0x4,%esp
  800bb4:	5b                   	pop    %ebx
  800bb5:	5e                   	pop    %esi
  800bb6:	5f                   	pop    %edi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    
  800bb9:	00 00                	add    %al,(%eax)
	...

00800bbc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 0c             	sub    $0xc,%esp
  800bc2:	89 1c 24             	mov    %ebx,(%esp)
  800bc5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bc9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd7:	89 d1                	mov    %edx,%ecx
  800bd9:	89 d3                	mov    %edx,%ebx
  800bdb:	89 d7                	mov    %edx,%edi
  800bdd:	89 d6                	mov    %edx,%esi
  800bdf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800be1:	8b 1c 24             	mov    (%esp),%ebx
  800be4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800be8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bec:	89 ec                	mov    %ebp,%esp
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 0c             	sub    $0xc,%esp
  800bf6:	89 1c 24             	mov    %ebx,(%esp)
  800bf9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bfd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	89 c3                	mov    %eax,%ebx
  800c0e:	89 c7                	mov    %eax,%edi
  800c10:	89 c6                	mov    %eax,%esi
  800c12:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c14:	8b 1c 24             	mov    (%esp),%ebx
  800c17:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c1b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c1f:	89 ec                	mov    %ebp,%esp
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	83 ec 38             	sub    $0x38,%esp
  800c29:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c2c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c2f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c32:	be 00 00 00 00       	mov    $0x0,%esi
  800c37:	b8 12 00 00 00       	mov    $0x12,%eax
  800c3c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c45:	8b 55 08             	mov    0x8(%ebp),%edx
  800c48:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	7e 28                	jle    800c76 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c52:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800c59:	00 
  800c5a:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800c61:	00 
  800c62:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c69:	00 
  800c6a:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800c71:	e8 56 1b 00 00       	call   8027cc <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800c76:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c79:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c7c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c7f:	89 ec                	mov    %ebp,%esp
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 0c             	sub    $0xc,%esp
  800c89:	89 1c 24             	mov    %ebx,(%esp)
  800c8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c90:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c99:	b8 11 00 00 00       	mov    $0x11,%eax
  800c9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	89 df                	mov    %ebx,%edi
  800ca6:	89 de                	mov    %ebx,%esi
  800ca8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800caa:	8b 1c 24             	mov    (%esp),%ebx
  800cad:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cb1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cb5:	89 ec                	mov    %ebp,%esp
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 0c             	sub    $0xc,%esp
  800cbf:	89 1c 24             	mov    %ebx,(%esp)
  800cc2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cc6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ccf:	b8 10 00 00 00       	mov    $0x10,%eax
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	89 cb                	mov    %ecx,%ebx
  800cd9:	89 cf                	mov    %ecx,%edi
  800cdb:	89 ce                	mov    %ecx,%esi
  800cdd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800cdf:	8b 1c 24             	mov    (%esp),%ebx
  800ce2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ce6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cea:	89 ec                	mov    %ebp,%esp
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    

00800cee <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	83 ec 38             	sub    $0x38,%esp
  800cf4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800cf7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cfa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d02:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	89 df                	mov    %ebx,%edi
  800d0f:	89 de                	mov    %ebx,%esi
  800d11:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7e 28                	jle    800d3f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d22:	00 
  800d23:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800d2a:	00 
  800d2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d32:	00 
  800d33:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800d3a:	e8 8d 1a 00 00       	call   8027cc <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800d3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d42:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d45:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d48:	89 ec                	mov    %ebp,%esp
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	89 1c 24             	mov    %ebx,(%esp)
  800d55:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d59:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d67:	89 d1                	mov    %edx,%ecx
  800d69:	89 d3                	mov    %edx,%ebx
  800d6b:	89 d7                	mov    %edx,%edi
  800d6d:	89 d6                	mov    %edx,%esi
  800d6f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800d71:	8b 1c 24             	mov    (%esp),%ebx
  800d74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d7c:	89 ec                	mov    %ebp,%esp
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 38             	sub    $0x38,%esp
  800d86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d94:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	89 cb                	mov    %ecx,%ebx
  800d9e:	89 cf                	mov    %ecx,%edi
  800da0:	89 ce                	mov    %ecx,%esi
  800da2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800da4:	85 c0                	test   %eax,%eax
  800da6:	7e 28                	jle    800dd0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dac:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800db3:	00 
  800db4:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc3:	00 
  800dc4:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800dcb:	e8 fc 19 00 00       	call   8027cc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dd0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dd3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dd6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dd9:	89 ec                	mov    %ebp,%esp
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 0c             	sub    $0xc,%esp
  800de3:	89 1c 24             	mov    %ebx,(%esp)
  800de6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dea:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dee:	be 00 00 00 00       	mov    $0x0,%esi
  800df3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e01:	8b 55 08             	mov    0x8(%ebp),%edx
  800e04:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e06:	8b 1c 24             	mov    (%esp),%ebx
  800e09:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e0d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e11:	89 ec                	mov    %ebp,%esp
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    

00800e15 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 38             	sub    $0x38,%esp
  800e1b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e1e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e21:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e29:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	89 df                	mov    %ebx,%edi
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7e 28                	jle    800e66 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e42:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e49:	00 
  800e4a:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800e51:	00 
  800e52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e59:	00 
  800e5a:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800e61:	e8 66 19 00 00       	call   8027cc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e6f:	89 ec                	mov    %ebp,%esp
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	83 ec 38             	sub    $0x38,%esp
  800e79:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e7f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e87:	b8 09 00 00 00       	mov    $0x9,%eax
  800e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	89 df                	mov    %ebx,%edi
  800e94:	89 de                	mov    %ebx,%esi
  800e96:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	7e 28                	jle    800ec4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ea7:	00 
  800ea8:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800eaf:	00 
  800eb0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb7:	00 
  800eb8:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800ebf:	e8 08 19 00 00       	call   8027cc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ec4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ecd:	89 ec                	mov    %ebp,%esp
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 38             	sub    $0x38,%esp
  800ed7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eda:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800edd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee5:	b8 08 00 00 00       	mov    $0x8,%eax
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	89 df                	mov    %ebx,%edi
  800ef2:	89 de                	mov    %ebx,%esi
  800ef4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	7e 28                	jle    800f22 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efe:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f05:	00 
  800f06:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800f0d:	00 
  800f0e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f15:	00 
  800f16:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800f1d:	e8 aa 18 00 00       	call   8027cc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f22:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f25:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f28:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f2b:	89 ec                	mov    %ebp,%esp
  800f2d:	5d                   	pop    %ebp
  800f2e:	c3                   	ret    

00800f2f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 38             	sub    $0x38,%esp
  800f35:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f38:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f43:	b8 06 00 00 00       	mov    $0x6,%eax
  800f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	89 df                	mov    %ebx,%edi
  800f50:	89 de                	mov    %ebx,%esi
  800f52:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	7e 28                	jle    800f80 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f63:	00 
  800f64:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800f6b:	00 
  800f6c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f73:	00 
  800f74:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800f7b:	e8 4c 18 00 00       	call   8027cc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f83:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f86:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f89:	89 ec                	mov    %ebp,%esp
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 38             	sub    $0x38,%esp
  800f93:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f96:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f99:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9c:	b8 05 00 00 00       	mov    $0x5,%eax
  800fa1:	8b 75 18             	mov    0x18(%ebp),%esi
  800fa4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fa7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800faa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fad:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	7e 28                	jle    800fde <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fba:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fc1:	00 
  800fc2:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800fc9:	00 
  800fca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd1:	00 
  800fd2:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800fd9:	e8 ee 17 00 00       	call   8027cc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fde:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe7:	89 ec                	mov    %ebp,%esp
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 38             	sub    $0x38,%esp
  800ff1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ff4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ff7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffa:	be 00 00 00 00       	mov    $0x0,%esi
  800fff:	b8 04 00 00 00       	mov    $0x4,%eax
  801004:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801007:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	89 f7                	mov    %esi,%edi
  80100f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801011:	85 c0                	test   %eax,%eax
  801013:	7e 28                	jle    80103d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801015:	89 44 24 10          	mov    %eax,0x10(%esp)
  801019:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801020:	00 
  801021:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801028:	00 
  801029:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801030:	00 
  801031:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  801038:	e8 8f 17 00 00       	call   8027cc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80103d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801040:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801043:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801046:	89 ec                	mov    %ebp,%esp
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 0c             	sub    $0xc,%esp
  801050:	89 1c 24             	mov    %ebx,(%esp)
  801053:	89 74 24 04          	mov    %esi,0x4(%esp)
  801057:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105b:	ba 00 00 00 00       	mov    $0x0,%edx
  801060:	b8 0b 00 00 00       	mov    $0xb,%eax
  801065:	89 d1                	mov    %edx,%ecx
  801067:	89 d3                	mov    %edx,%ebx
  801069:	89 d7                	mov    %edx,%edi
  80106b:	89 d6                	mov    %edx,%esi
  80106d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80106f:	8b 1c 24             	mov    (%esp),%ebx
  801072:	8b 74 24 04          	mov    0x4(%esp),%esi
  801076:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80107a:	89 ec                	mov    %ebp,%esp
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 0c             	sub    $0xc,%esp
  801084:	89 1c 24             	mov    %ebx,(%esp)
  801087:	89 74 24 04          	mov    %esi,0x4(%esp)
  80108b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108f:	ba 00 00 00 00       	mov    $0x0,%edx
  801094:	b8 02 00 00 00       	mov    $0x2,%eax
  801099:	89 d1                	mov    %edx,%ecx
  80109b:	89 d3                	mov    %edx,%ebx
  80109d:	89 d7                	mov    %edx,%edi
  80109f:	89 d6                	mov    %edx,%esi
  8010a1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010a3:	8b 1c 24             	mov    (%esp),%ebx
  8010a6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010aa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ae:	89 ec                	mov    %ebp,%esp
  8010b0:	5d                   	pop    %ebp
  8010b1:	c3                   	ret    

008010b2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 38             	sub    $0x38,%esp
  8010b8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010bb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010be:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c6:	b8 03 00 00 00       	mov    $0x3,%eax
  8010cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ce:	89 cb                	mov    %ecx,%ebx
  8010d0:	89 cf                	mov    %ecx,%edi
  8010d2:	89 ce                	mov    %ecx,%esi
  8010d4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	7e 28                	jle    801102 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010da:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010de:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010e5:	00 
  8010e6:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  8010ed:	00 
  8010ee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f5:	00 
  8010f6:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  8010fd:	e8 ca 16 00 00       	call   8027cc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801102:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801105:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801108:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110b:	89 ec                	mov    %ebp,%esp
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    
	...

00801110 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801116:	c7 44 24 08 0a 30 80 	movl   $0x80300a,0x8(%esp)
  80111d:	00 
  80111e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801125:	00 
  801126:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  80112d:	e8 9a 16 00 00       	call   8027cc <_panic>

00801132 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	53                   	push   %ebx
  801136:	83 ec 24             	sub    $0x24,%esp
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80113c:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80113e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801142:	75 1c                	jne    801160 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801144:	c7 44 24 08 2c 30 80 	movl   $0x80302c,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  80115b:	e8 6c 16 00 00       	call   8027cc <_panic>
	}
	pte = vpt[VPN(addr)];
  801160:	89 d8                	mov    %ebx,%eax
  801162:	c1 e8 0c             	shr    $0xc,%eax
  801165:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  80116c:	f6 c4 08             	test   $0x8,%ah
  80116f:	75 1c                	jne    80118d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801171:	c7 44 24 08 70 30 80 	movl   $0x803070,0x8(%esp)
  801178:	00 
  801179:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801180:	00 
  801181:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  801188:	e8 3f 16 00 00       	call   8027cc <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80118d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801194:	00 
  801195:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80119c:	00 
  80119d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a4:	e8 42 fe ff ff       	call   800feb <sys_page_alloc>
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	79 20                	jns    8011cd <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  8011ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011b1:	c7 44 24 08 bc 30 80 	movl   $0x8030bc,0x8(%esp)
  8011b8:	00 
  8011b9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8011c0:	00 
  8011c1:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  8011c8:	e8 ff 15 00 00       	call   8027cc <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  8011cd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8011d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8011da:	00 
  8011db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011df:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011e6:	e8 ca f7 ff ff       	call   8009b5 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  8011eb:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011f2:	00 
  8011f3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011fe:	00 
  8011ff:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801206:	00 
  801207:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80120e:	e8 7a fd ff ff       	call   800f8d <sys_page_map>
  801213:	85 c0                	test   %eax,%eax
  801215:	79 20                	jns    801237 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  801217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80121b:	c7 44 24 08 f8 30 80 	movl   $0x8030f8,0x8(%esp)
  801222:	00 
  801223:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80122a:	00 
  80122b:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  801232:	e8 95 15 00 00       	call   8027cc <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801237:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80123e:	00 
  80123f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801246:	e8 e4 fc ff ff       	call   800f2f <sys_page_unmap>
  80124b:	85 c0                	test   %eax,%eax
  80124d:	79 20                	jns    80126f <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80124f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801253:	c7 44 24 08 30 31 80 	movl   $0x803130,0x8(%esp)
  80125a:	00 
  80125b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801262:	00 
  801263:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  80126a:	e8 5d 15 00 00       	call   8027cc <_panic>
	// panic("pgfault not implemented");
}
  80126f:	83 c4 24             	add    $0x24,%esp
  801272:	5b                   	pop    %ebx
  801273:	5d                   	pop    %ebp
  801274:	c3                   	ret    

00801275 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	57                   	push   %edi
  801279:	56                   	push   %esi
  80127a:	53                   	push   %ebx
  80127b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80127e:	c7 04 24 32 11 80 00 	movl   $0x801132,(%esp)
  801285:	e8 a6 15 00 00       	call   802830 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80128a:	ba 07 00 00 00       	mov    $0x7,%edx
  80128f:	89 d0                	mov    %edx,%eax
  801291:	cd 30                	int    $0x30
  801293:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  801296:	85 c0                	test   %eax,%eax
  801298:	0f 88 21 02 00 00    	js     8014bf <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  80129e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 1c                	jne    8012c5 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  8012a9:	e8 d0 fd ff ff       	call   80107e <sys_getenvid>
  8012ae:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012b3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012b6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012bb:	a3 74 70 80 00       	mov    %eax,0x807074
		return 0;
  8012c0:	e9 fa 01 00 00       	jmp    8014bf <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  8012c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012c8:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8012cf:	a8 01                	test   $0x1,%al
  8012d1:	0f 84 16 01 00 00    	je     8013ed <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  8012d7:	89 d3                	mov    %edx,%ebx
  8012d9:	c1 e3 0a             	shl    $0xa,%ebx
  8012dc:	89 d7                	mov    %edx,%edi
  8012de:	c1 e7 16             	shl    $0x16,%edi
  8012e1:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  8012e6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012ed:	a8 01                	test   $0x1,%al
  8012ef:	0f 84 e0 00 00 00    	je     8013d5 <fork+0x160>
  8012f5:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8012fb:	0f 87 d4 00 00 00    	ja     8013d5 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801301:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801308:	89 d0                	mov    %edx,%eax
  80130a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  80130f:	f6 c2 01             	test   $0x1,%dl
  801312:	75 1c                	jne    801330 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  801314:	c7 44 24 08 6c 31 80 	movl   $0x80316c,0x8(%esp)
  80131b:	00 
  80131c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801323:	00 
  801324:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  80132b:	e8 9c 14 00 00       	call   8027cc <_panic>
	if ((perm & PTE_U) != PTE_U)
  801330:	a8 04                	test   $0x4,%al
  801332:	75 1c                	jne    801350 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801334:	c7 44 24 08 b4 31 80 	movl   $0x8031b4,0x8(%esp)
  80133b:	00 
  80133c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801343:	00 
  801344:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  80134b:	e8 7c 14 00 00       	call   8027cc <_panic>
  801350:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801353:	f6 c4 04             	test   $0x4,%ah
  801356:	75 5b                	jne    8013b3 <fork+0x13e>
  801358:	a9 02 08 00 00       	test   $0x802,%eax
  80135d:	74 54                	je     8013b3 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80135f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801362:	80 cc 08             	or     $0x8,%ah
  801365:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801368:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801370:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801373:	89 54 24 08          	mov    %edx,0x8(%esp)
  801377:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80137b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801382:	e8 06 fc ff ff       	call   800f8d <sys_page_map>
  801387:	85 c0                	test   %eax,%eax
  801389:	78 4a                	js     8013d5 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80138b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80138e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801392:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801395:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801399:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013a0:	00 
  8013a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ac:	e8 dc fb ff ff       	call   800f8d <sys_page_map>
  8013b1:	eb 22                	jmp    8013d5 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8013b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d0:	e8 b8 fb ff ff       	call   800f8d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  8013d5:	83 c6 01             	add    $0x1,%esi
  8013d8:	83 c3 01             	add    $0x1,%ebx
  8013db:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8013e1:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  8013e7:	0f 85 f9 fe ff ff    	jne    8012e6 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  8013ed:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  8013f1:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  8013f8:	0f 85 c7 fe ff ff    	jne    8012c5 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8013fe:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801405:	00 
  801406:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80140d:	ee 
  80140e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801411:	89 04 24             	mov    %eax,(%esp)
  801414:	e8 d2 fb ff ff       	call   800feb <sys_page_alloc>
  801419:	85 c0                	test   %eax,%eax
  80141b:	79 08                	jns    801425 <fork+0x1b0>
  80141d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801420:	e9 9a 00 00 00       	jmp    8014bf <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801425:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80142c:	00 
  80142d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801434:	00 
  801435:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80143c:	00 
  80143d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801444:	ee 
  801445:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801448:	89 14 24             	mov    %edx,(%esp)
  80144b:	e8 3d fb ff ff       	call   800f8d <sys_page_map>
  801450:	85 c0                	test   %eax,%eax
  801452:	79 05                	jns    801459 <fork+0x1e4>
  801454:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801457:	eb 66                	jmp    8014bf <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801459:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801460:	00 
  801461:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801468:	ee 
  801469:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801470:	e8 40 f5 ff ff       	call   8009b5 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801475:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80147c:	00 
  80147d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801484:	e8 a6 fa ff ff       	call   800f2f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801489:	c7 44 24 04 c4 28 80 	movl   $0x8028c4,0x4(%esp)
  801490:	00 
  801491:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801494:	89 04 24             	mov    %eax,(%esp)
  801497:	e8 79 f9 ff ff       	call   800e15 <sys_env_set_pgfault_upcall>
  80149c:	85 c0                	test   %eax,%eax
  80149e:	79 05                	jns    8014a5 <fork+0x230>
  8014a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014a3:	eb 1a                	jmp    8014bf <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8014a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014ac:	00 
  8014ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b0:	89 14 24             	mov    %edx,(%esp)
  8014b3:	e8 19 fa ff ff       	call   800ed1 <sys_env_set_status>
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	79 03                	jns    8014bf <fork+0x24a>
  8014bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  8014bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c2:	83 c4 3c             	add    $0x3c,%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5f                   	pop    %edi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    
  8014ca:	00 00                	add    %al,(%eax)
  8014cc:	00 00                	add    %al,(%eax)
	...

008014d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014db:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    

008014e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 04 24             	mov    %eax,(%esp)
  8014ec:	e8 df ff ff ff       	call   8014d0 <fd2num>
  8014f1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8014f6:	c1 e0 0c             	shl    $0xc,%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	57                   	push   %edi
  8014ff:	56                   	push   %esi
  801500:	53                   	push   %ebx
  801501:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801504:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801509:	a8 01                	test   $0x1,%al
  80150b:	74 36                	je     801543 <fd_alloc+0x48>
  80150d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801512:	a8 01                	test   $0x1,%al
  801514:	74 2d                	je     801543 <fd_alloc+0x48>
  801516:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80151b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801520:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801525:	89 c3                	mov    %eax,%ebx
  801527:	89 c2                	mov    %eax,%edx
  801529:	c1 ea 16             	shr    $0x16,%edx
  80152c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80152f:	f6 c2 01             	test   $0x1,%dl
  801532:	74 14                	je     801548 <fd_alloc+0x4d>
  801534:	89 c2                	mov    %eax,%edx
  801536:	c1 ea 0c             	shr    $0xc,%edx
  801539:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80153c:	f6 c2 01             	test   $0x1,%dl
  80153f:	75 10                	jne    801551 <fd_alloc+0x56>
  801541:	eb 05                	jmp    801548 <fd_alloc+0x4d>
  801543:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801548:	89 1f                	mov    %ebx,(%edi)
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80154f:	eb 17                	jmp    801568 <fd_alloc+0x6d>
  801551:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801556:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80155b:	75 c8                	jne    801525 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80155d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801563:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801568:	5b                   	pop    %ebx
  801569:	5e                   	pop    %esi
  80156a:	5f                   	pop    %edi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    

0080156d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	83 f8 1f             	cmp    $0x1f,%eax
  801576:	77 36                	ja     8015ae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801578:	05 00 00 0d 00       	add    $0xd0000,%eax
  80157d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801580:	89 c2                	mov    %eax,%edx
  801582:	c1 ea 16             	shr    $0x16,%edx
  801585:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80158c:	f6 c2 01             	test   $0x1,%dl
  80158f:	74 1d                	je     8015ae <fd_lookup+0x41>
  801591:	89 c2                	mov    %eax,%edx
  801593:	c1 ea 0c             	shr    $0xc,%edx
  801596:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80159d:	f6 c2 01             	test   $0x1,%dl
  8015a0:	74 0c                	je     8015ae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a5:	89 02                	mov    %eax,(%edx)
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8015ac:	eb 05                	jmp    8015b3 <fd_lookup+0x46>
  8015ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015b3:	5d                   	pop    %ebp
  8015b4:	c3                   	ret    

008015b5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015bb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	89 04 24             	mov    %eax,(%esp)
  8015c8:	e8 a0 ff ff ff       	call   80156d <fd_lookup>
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 0e                	js     8015df <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d7:	89 50 04             	mov    %edx,0x4(%eax)
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	56                   	push   %esi
  8015e5:	53                   	push   %ebx
  8015e6:	83 ec 10             	sub    $0x10,%esp
  8015e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8015ef:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8015f4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015f9:	be 78 32 80 00       	mov    $0x803278,%esi
		if (devtab[i]->dev_id == dev_id) {
  8015fe:	39 08                	cmp    %ecx,(%eax)
  801600:	75 10                	jne    801612 <dev_lookup+0x31>
  801602:	eb 04                	jmp    801608 <dev_lookup+0x27>
  801604:	39 08                	cmp    %ecx,(%eax)
  801606:	75 0a                	jne    801612 <dev_lookup+0x31>
			*dev = devtab[i];
  801608:	89 03                	mov    %eax,(%ebx)
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80160f:	90                   	nop
  801610:	eb 31                	jmp    801643 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801612:	83 c2 01             	add    $0x1,%edx
  801615:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801618:	85 c0                	test   %eax,%eax
  80161a:	75 e8                	jne    801604 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80161c:	a1 74 70 80 00       	mov    0x807074,%eax
  801621:	8b 40 4c             	mov    0x4c(%eax),%eax
  801624:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162c:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  801633:	e8 01 eb ff ff       	call   800139 <cprintf>
	*dev = 0;
  801638:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80163e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801643:	83 c4 10             	add    $0x10,%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	53                   	push   %ebx
  80164e:	83 ec 24             	sub    $0x24,%esp
  801651:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801654:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	89 04 24             	mov    %eax,(%esp)
  801661:	e8 07 ff ff ff       	call   80156d <fd_lookup>
  801666:	85 c0                	test   %eax,%eax
  801668:	78 53                	js     8016bd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80166a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801674:	8b 00                	mov    (%eax),%eax
  801676:	89 04 24             	mov    %eax,(%esp)
  801679:	e8 63 ff ff ff       	call   8015e1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80167e:	85 c0                	test   %eax,%eax
  801680:	78 3b                	js     8016bd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801682:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801687:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80168e:	74 2d                	je     8016bd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801690:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801693:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80169a:	00 00 00 
	stat->st_isdir = 0;
  80169d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016a4:	00 00 00 
	stat->st_dev = dev;
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b7:	89 14 24             	mov    %edx,(%esp)
  8016ba:	ff 50 14             	call   *0x14(%eax)
}
  8016bd:	83 c4 24             	add    $0x24,%esp
  8016c0:	5b                   	pop    %ebx
  8016c1:	5d                   	pop    %ebp
  8016c2:	c3                   	ret    

008016c3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 24             	sub    $0x24,%esp
  8016ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d4:	89 1c 24             	mov    %ebx,(%esp)
  8016d7:	e8 91 fe ff ff       	call   80156d <fd_lookup>
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 5f                	js     80173f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	8b 00                	mov    (%eax),%eax
  8016ec:	89 04 24             	mov    %eax,(%esp)
  8016ef:	e8 ed fe ff ff       	call   8015e1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f4:	85 c0                	test   %eax,%eax
  8016f6:	78 47                	js     80173f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8016ff:	75 23                	jne    801724 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801701:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801706:	8b 40 4c             	mov    0x4c(%eax),%eax
  801709:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80170d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801711:	c7 04 24 1c 32 80 00 	movl   $0x80321c,(%esp)
  801718:	e8 1c ea ff ff       	call   800139 <cprintf>
  80171d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801722:	eb 1b                	jmp    80173f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801727:	8b 48 18             	mov    0x18(%eax),%ecx
  80172a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80172f:	85 c9                	test   %ecx,%ecx
  801731:	74 0c                	je     80173f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801733:	8b 45 0c             	mov    0xc(%ebp),%eax
  801736:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173a:	89 14 24             	mov    %edx,(%esp)
  80173d:	ff d1                	call   *%ecx
}
  80173f:	83 c4 24             	add    $0x24,%esp
  801742:	5b                   	pop    %ebx
  801743:	5d                   	pop    %ebp
  801744:	c3                   	ret    

00801745 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	53                   	push   %ebx
  801749:	83 ec 24             	sub    $0x24,%esp
  80174c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801752:	89 44 24 04          	mov    %eax,0x4(%esp)
  801756:	89 1c 24             	mov    %ebx,(%esp)
  801759:	e8 0f fe ff ff       	call   80156d <fd_lookup>
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 66                	js     8017c8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801762:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801765:	89 44 24 04          	mov    %eax,0x4(%esp)
  801769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176c:	8b 00                	mov    (%eax),%eax
  80176e:	89 04 24             	mov    %eax,(%esp)
  801771:	e8 6b fe ff ff       	call   8015e1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801776:	85 c0                	test   %eax,%eax
  801778:	78 4e                	js     8017c8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80177a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801781:	75 23                	jne    8017a6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801783:	a1 74 70 80 00       	mov    0x807074,%eax
  801788:	8b 40 4c             	mov    0x4c(%eax),%eax
  80178b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80178f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801793:	c7 04 24 3d 32 80 00 	movl   $0x80323d,(%esp)
  80179a:	e8 9a e9 ff ff       	call   800139 <cprintf>
  80179f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8017a4:	eb 22                	jmp    8017c8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8017ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017b1:	85 c9                	test   %ecx,%ecx
  8017b3:	74 13                	je     8017c8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c3:	89 14 24             	mov    %edx,(%esp)
  8017c6:	ff d1                	call   *%ecx
}
  8017c8:	83 c4 24             	add    $0x24,%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    

008017ce <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	53                   	push   %ebx
  8017d2:	83 ec 24             	sub    $0x24,%esp
  8017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017df:	89 1c 24             	mov    %ebx,(%esp)
  8017e2:	e8 86 fd ff ff       	call   80156d <fd_lookup>
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	78 6b                	js     801856 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f5:	8b 00                	mov    (%eax),%eax
  8017f7:	89 04 24             	mov    %eax,(%esp)
  8017fa:	e8 e2 fd ff ff       	call   8015e1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ff:	85 c0                	test   %eax,%eax
  801801:	78 53                	js     801856 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801803:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801806:	8b 42 08             	mov    0x8(%edx),%eax
  801809:	83 e0 03             	and    $0x3,%eax
  80180c:	83 f8 01             	cmp    $0x1,%eax
  80180f:	75 23                	jne    801834 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801811:	a1 74 70 80 00       	mov    0x807074,%eax
  801816:	8b 40 4c             	mov    0x4c(%eax),%eax
  801819:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	c7 04 24 5a 32 80 00 	movl   $0x80325a,(%esp)
  801828:	e8 0c e9 ff ff       	call   800139 <cprintf>
  80182d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801832:	eb 22                	jmp    801856 <read+0x88>
	}
	if (!dev->dev_read)
  801834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801837:	8b 48 08             	mov    0x8(%eax),%ecx
  80183a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80183f:	85 c9                	test   %ecx,%ecx
  801841:	74 13                	je     801856 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801843:	8b 45 10             	mov    0x10(%ebp),%eax
  801846:	89 44 24 08          	mov    %eax,0x8(%esp)
  80184a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801851:	89 14 24             	mov    %edx,(%esp)
  801854:	ff d1                	call   *%ecx
}
  801856:	83 c4 24             	add    $0x24,%esp
  801859:	5b                   	pop    %ebx
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	57                   	push   %edi
  801860:	56                   	push   %esi
  801861:	53                   	push   %ebx
  801862:	83 ec 1c             	sub    $0x1c,%esp
  801865:	8b 7d 08             	mov    0x8(%ebp),%edi
  801868:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80186b:	ba 00 00 00 00       	mov    $0x0,%edx
  801870:	bb 00 00 00 00       	mov    $0x0,%ebx
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	85 f6                	test   %esi,%esi
  80187c:	74 29                	je     8018a7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80187e:	89 f0                	mov    %esi,%eax
  801880:	29 d0                	sub    %edx,%eax
  801882:	89 44 24 08          	mov    %eax,0x8(%esp)
  801886:	03 55 0c             	add    0xc(%ebp),%edx
  801889:	89 54 24 04          	mov    %edx,0x4(%esp)
  80188d:	89 3c 24             	mov    %edi,(%esp)
  801890:	e8 39 ff ff ff       	call   8017ce <read>
		if (m < 0)
  801895:	85 c0                	test   %eax,%eax
  801897:	78 0e                	js     8018a7 <readn+0x4b>
			return m;
		if (m == 0)
  801899:	85 c0                	test   %eax,%eax
  80189b:	74 08                	je     8018a5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80189d:	01 c3                	add    %eax,%ebx
  80189f:	89 da                	mov    %ebx,%edx
  8018a1:	39 f3                	cmp    %esi,%ebx
  8018a3:	72 d9                	jb     80187e <readn+0x22>
  8018a5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018a7:	83 c4 1c             	add    $0x1c,%esp
  8018aa:	5b                   	pop    %ebx
  8018ab:	5e                   	pop    %esi
  8018ac:	5f                   	pop    %edi
  8018ad:	5d                   	pop    %ebp
  8018ae:	c3                   	ret    

008018af <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 20             	sub    $0x20,%esp
  8018b7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018ba:	89 34 24             	mov    %esi,(%esp)
  8018bd:	e8 0e fc ff ff       	call   8014d0 <fd2num>
  8018c2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018c9:	89 04 24             	mov    %eax,(%esp)
  8018cc:	e8 9c fc ff ff       	call   80156d <fd_lookup>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 05                	js     8018dc <fd_close+0x2d>
  8018d7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018da:	74 0c                	je     8018e8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8018dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8018e0:	19 c0                	sbb    %eax,%eax
  8018e2:	f7 d0                	not    %eax
  8018e4:	21 c3                	and    %eax,%ebx
  8018e6:	eb 3d                	jmp    801925 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ef:	8b 06                	mov    (%esi),%eax
  8018f1:	89 04 24             	mov    %eax,(%esp)
  8018f4:	e8 e8 fc ff ff       	call   8015e1 <dev_lookup>
  8018f9:	89 c3                	mov    %eax,%ebx
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 16                	js     801915 <fd_close+0x66>
		if (dev->dev_close)
  8018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801902:	8b 40 10             	mov    0x10(%eax),%eax
  801905:	bb 00 00 00 00       	mov    $0x0,%ebx
  80190a:	85 c0                	test   %eax,%eax
  80190c:	74 07                	je     801915 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80190e:	89 34 24             	mov    %esi,(%esp)
  801911:	ff d0                	call   *%eax
  801913:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801915:	89 74 24 04          	mov    %esi,0x4(%esp)
  801919:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801920:	e8 0a f6 ff ff       	call   800f2f <sys_page_unmap>
	return r;
}
  801925:	89 d8                	mov    %ebx,%eax
  801927:	83 c4 20             	add    $0x20,%esp
  80192a:	5b                   	pop    %ebx
  80192b:	5e                   	pop    %esi
  80192c:	5d                   	pop    %ebp
  80192d:	c3                   	ret    

0080192e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801934:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801937:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	89 04 24             	mov    %eax,(%esp)
  801941:	e8 27 fc ff ff       	call   80156d <fd_lookup>
  801946:	85 c0                	test   %eax,%eax
  801948:	78 13                	js     80195d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80194a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801951:	00 
  801952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801955:	89 04 24             	mov    %eax,(%esp)
  801958:	e8 52 ff ff ff       	call   8018af <fd_close>
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 18             	sub    $0x18,%esp
  801965:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801968:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80196b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801972:	00 
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	89 04 24             	mov    %eax,(%esp)
  801979:	e8 55 03 00 00       	call   801cd3 <open>
  80197e:	89 c3                	mov    %eax,%ebx
  801980:	85 c0                	test   %eax,%eax
  801982:	78 1b                	js     80199f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801984:	8b 45 0c             	mov    0xc(%ebp),%eax
  801987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198b:	89 1c 24             	mov    %ebx,(%esp)
  80198e:	e8 b7 fc ff ff       	call   80164a <fstat>
  801993:	89 c6                	mov    %eax,%esi
	close(fd);
  801995:	89 1c 24             	mov    %ebx,(%esp)
  801998:	e8 91 ff ff ff       	call   80192e <close>
  80199d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80199f:	89 d8                	mov    %ebx,%eax
  8019a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8019a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019a7:	89 ec                	mov    %ebp,%esp
  8019a9:	5d                   	pop    %ebp
  8019aa:	c3                   	ret    

008019ab <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 14             	sub    $0x14,%esp
  8019b2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8019b7:	89 1c 24             	mov    %ebx,(%esp)
  8019ba:	e8 6f ff ff ff       	call   80192e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019bf:	83 c3 01             	add    $0x1,%ebx
  8019c2:	83 fb 20             	cmp    $0x20,%ebx
  8019c5:	75 f0                	jne    8019b7 <close_all+0xc>
		close(i);
}
  8019c7:	83 c4 14             	add    $0x14,%esp
  8019ca:	5b                   	pop    %ebx
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    

008019cd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 58             	sub    $0x58,%esp
  8019d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	89 04 24             	mov    %eax,(%esp)
  8019ec:	e8 7c fb ff ff       	call   80156d <fd_lookup>
  8019f1:	89 c3                	mov    %eax,%ebx
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	0f 88 e0 00 00 00    	js     801adb <dup+0x10e>
		return r;
	close(newfdnum);
  8019fb:	89 3c 24             	mov    %edi,(%esp)
  8019fe:	e8 2b ff ff ff       	call   80192e <close>

	newfd = INDEX2FD(newfdnum);
  801a03:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801a09:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a0f:	89 04 24             	mov    %eax,(%esp)
  801a12:	e8 c9 fa ff ff       	call   8014e0 <fd2data>
  801a17:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a19:	89 34 24             	mov    %esi,(%esp)
  801a1c:	e8 bf fa ff ff       	call   8014e0 <fd2data>
  801a21:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801a24:	89 da                	mov    %ebx,%edx
  801a26:	89 d8                	mov    %ebx,%eax
  801a28:	c1 e8 16             	shr    $0x16,%eax
  801a2b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a32:	a8 01                	test   $0x1,%al
  801a34:	74 43                	je     801a79 <dup+0xac>
  801a36:	c1 ea 0c             	shr    $0xc,%edx
  801a39:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a40:	a8 01                	test   $0x1,%al
  801a42:	74 35                	je     801a79 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801a44:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a4b:	25 07 0e 00 00       	and    $0xe07,%eax
  801a50:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a62:	00 
  801a63:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6e:	e8 1a f5 ff ff       	call   800f8d <sys_page_map>
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 3f                	js     801ab8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a7c:	89 c2                	mov    %eax,%edx
  801a7e:	c1 ea 0c             	shr    $0xc,%edx
  801a81:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a88:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a8e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a92:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a96:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a9d:	00 
  801a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aa9:	e8 df f4 ff ff       	call   800f8d <sys_page_map>
  801aae:	89 c3                	mov    %eax,%ebx
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 04                	js     801ab8 <dup+0xeb>
  801ab4:	89 fb                	mov    %edi,%ebx
  801ab6:	eb 23                	jmp    801adb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ab8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801abc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac3:	e8 67 f4 ff ff       	call   800f2f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ac8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad6:	e8 54 f4 ff ff       	call   800f2f <sys_page_unmap>
	return r;
}
  801adb:	89 d8                	mov    %ebx,%eax
  801add:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ae0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ae3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ae6:	89 ec                	mov    %ebp,%esp
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    
	...

00801aec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	53                   	push   %ebx
  801af0:	83 ec 14             	sub    $0x14,%esp
  801af3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801af5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801afb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b02:	00 
  801b03:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801b0a:	00 
  801b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0f:	89 14 24             	mov    %edx,(%esp)
  801b12:	e8 d9 0d 00 00       	call   8028f0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b1e:	00 
  801b1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2a:	e8 27 0e 00 00       	call   802956 <ipc_recv>
}
  801b2f:	83 c4 14             	add    $0x14,%esp
  801b32:	5b                   	pop    %ebx
  801b33:	5d                   	pop    %ebp
  801b34:	c3                   	ret    

00801b35 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b41:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b49:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b53:	b8 02 00 00 00       	mov    $0x2,%eax
  801b58:	e8 8f ff ff ff       	call   801aec <fsipc>
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801b70:	ba 00 00 00 00       	mov    $0x0,%edx
  801b75:	b8 06 00 00 00       	mov    $0x6,%eax
  801b7a:	e8 6d ff ff ff       	call   801aec <fsipc>
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b87:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b91:	e8 56 ff ff ff       	call   801aec <fsipc>
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	53                   	push   %ebx
  801b9c:	83 ec 14             	sub    $0x14,%esp
  801b9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba8:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bad:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb2:	b8 05 00 00 00       	mov    $0x5,%eax
  801bb7:	e8 30 ff ff ff       	call   801aec <fsipc>
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 2b                	js     801beb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bc0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801bc7:	00 
  801bc8:	89 1c 24             	mov    %ebx,(%esp)
  801bcb:	e8 2a ec ff ff       	call   8007fa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bd0:	a1 80 40 80 00       	mov    0x804080,%eax
  801bd5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bdb:	a1 84 40 80 00       	mov    0x804084,%eax
  801be0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801be6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801beb:	83 c4 14             	add    $0x14,%esp
  801bee:	5b                   	pop    %ebx
  801bef:	5d                   	pop    %ebp
  801bf0:	c3                   	ret    

00801bf1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 18             	sub    $0x18,%esp
  801bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfa:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801bff:	76 05                	jbe    801c06 <devfile_write+0x15>
  801c01:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c06:	8b 55 08             	mov    0x8(%ebp),%edx
  801c09:	8b 52 0c             	mov    0xc(%edx),%edx
  801c0c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801c12:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801c17:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c22:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801c29:	e8 87 ed ff ff       	call   8009b5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c33:	b8 04 00 00 00       	mov    $0x4,%eax
  801c38:	e8 af fe ff ff       	call   801aec <fsipc>
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	53                   	push   %ebx
  801c43:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801c51:	8b 45 10             	mov    0x10(%ebp),%eax
  801c54:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801c59:	ba 00 40 80 00       	mov    $0x804000,%edx
  801c5e:	b8 03 00 00 00       	mov    $0x3,%eax
  801c63:	e8 84 fe ff ff       	call   801aec <fsipc>
  801c68:	89 c3                	mov    %eax,%ebx
  801c6a:	85 c0                	test   %eax,%eax
  801c6c:	78 17                	js     801c85 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801c6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c72:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801c79:	00 
  801c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7d:	89 04 24             	mov    %eax,(%esp)
  801c80:	e8 30 ed ff ff       	call   8009b5 <memmove>
	return r;
}
  801c85:	89 d8                	mov    %ebx,%eax
  801c87:	83 c4 14             	add    $0x14,%esp
  801c8a:	5b                   	pop    %ebx
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    

00801c8d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	53                   	push   %ebx
  801c91:	83 ec 14             	sub    $0x14,%esp
  801c94:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801c97:	89 1c 24             	mov    %ebx,(%esp)
  801c9a:	e8 11 eb ff ff       	call   8007b0 <strlen>
  801c9f:	89 c2                	mov    %eax,%edx
  801ca1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801ca6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801cac:	7f 1f                	jg     801ccd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801cae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cb2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801cb9:	e8 3c eb ff ff       	call   8007fa <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc3:	b8 07 00 00 00       	mov    $0x7,%eax
  801cc8:	e8 1f fe ff ff       	call   801aec <fsipc>
}
  801ccd:	83 c4 14             	add    $0x14,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 28             	sub    $0x28,%esp
  801cd9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801cdc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801cdf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801ce2:	89 34 24             	mov    %esi,(%esp)
  801ce5:	e8 c6 ea ff ff       	call   8007b0 <strlen>
  801cea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cf4:	7f 5e                	jg     801d54 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801cf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf9:	89 04 24             	mov    %eax,(%esp)
  801cfc:	e8 fa f7 ff ff       	call   8014fb <fd_alloc>
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	85 c0                	test   %eax,%eax
  801d05:	78 4d                	js     801d54 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801d07:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d0b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d12:	e8 e3 ea ff ff       	call   8007fa <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801d1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
  801d27:	e8 c0 fd ff ff       	call   801aec <fsipc>
  801d2c:	89 c3                	mov    %eax,%ebx
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	79 15                	jns    801d47 <open+0x74>
	{
		fd_close(fd,0);
  801d32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d39:	00 
  801d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3d:	89 04 24             	mov    %eax,(%esp)
  801d40:	e8 6a fb ff ff       	call   8018af <fd_close>
		return r; 
  801d45:	eb 0d                	jmp    801d54 <open+0x81>
	}
	return fd2num(fd);
  801d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4a:	89 04 24             	mov    %eax,(%esp)
  801d4d:	e8 7e f7 ff ff       	call   8014d0 <fd2num>
  801d52:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801d54:	89 d8                	mov    %ebx,%eax
  801d56:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d59:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d5c:	89 ec                	mov    %ebp,%esp
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    

00801d60 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d66:	c7 44 24 04 8c 32 80 	movl   $0x80328c,0x4(%esp)
  801d6d:	00 
  801d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d71:	89 04 24             	mov    %eax,(%esp)
  801d74:	e8 81 ea ff ff       	call   8007fa <strcpy>
	return 0;
}
  801d79:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8c:	89 04 24             	mov    %eax,(%esp)
  801d8f:	e8 9e 02 00 00       	call   802032 <nsipc_close>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d9c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801da3:	00 
  801da4:	8b 45 10             	mov    0x10(%ebp),%eax
  801da7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	8b 40 0c             	mov    0xc(%eax),%eax
  801db8:	89 04 24             	mov    %eax,(%esp)
  801dbb:	e8 ae 02 00 00       	call   80206e <nsipc_send>
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801dc8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dcf:	00 
  801dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dda:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	8b 40 0c             	mov    0xc(%eax),%eax
  801de4:	89 04 24             	mov    %eax,(%esp)
  801de7:	e8 f5 02 00 00       	call   8020e1 <nsipc_recv>
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	56                   	push   %esi
  801df2:	53                   	push   %ebx
  801df3:	83 ec 20             	sub    $0x20,%esp
  801df6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801df8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfb:	89 04 24             	mov    %eax,(%esp)
  801dfe:	e8 f8 f6 ff ff       	call   8014fb <fd_alloc>
  801e03:	89 c3                	mov    %eax,%ebx
  801e05:	85 c0                	test   %eax,%eax
  801e07:	78 21                	js     801e2a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801e09:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e10:	00 
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e1f:	e8 c7 f1 ff ff       	call   800feb <sys_page_alloc>
  801e24:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e26:	85 c0                	test   %eax,%eax
  801e28:	79 0a                	jns    801e34 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801e2a:	89 34 24             	mov    %esi,(%esp)
  801e2d:	e8 00 02 00 00       	call   802032 <nsipc_close>
		return r;
  801e32:	eb 28                	jmp    801e5c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e34:	8b 15 20 70 80 00    	mov    0x807020,%edx
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e42:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	89 04 24             	mov    %eax,(%esp)
  801e55:	e8 76 f6 ff ff       	call   8014d0 <fd2num>
  801e5a:	89 c3                	mov    %eax,%ebx
}
  801e5c:	89 d8                	mov    %ebx,%eax
  801e5e:	83 c4 20             	add    $0x20,%esp
  801e61:	5b                   	pop    %ebx
  801e62:	5e                   	pop    %esi
  801e63:	5d                   	pop    %ebp
  801e64:	c3                   	ret    

00801e65 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	89 04 24             	mov    %eax,(%esp)
  801e7f:	e8 62 01 00 00       	call   801fe6 <nsipc_socket>
  801e84:	85 c0                	test   %eax,%eax
  801e86:	78 05                	js     801e8d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801e88:	e8 61 ff ff ff       	call   801dee <alloc_sockfd>
}
  801e8d:	c9                   	leave  
  801e8e:	66 90                	xchg   %ax,%ax
  801e90:	c3                   	ret    

00801e91 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e97:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e9a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e9e:	89 04 24             	mov    %eax,(%esp)
  801ea1:	e8 c7 f6 ff ff       	call   80156d <fd_lookup>
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	78 15                	js     801ebf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ead:	8b 0a                	mov    (%edx),%ecx
  801eaf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801eb4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  801eba:	75 03                	jne    801ebf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801ebc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	e8 c2 ff ff ff       	call   801e91 <fd2sockid>
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	78 0f                	js     801ee2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eda:	89 04 24             	mov    %eax,(%esp)
  801edd:	e8 2e 01 00 00       	call   802010 <nsipc_listen>
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	e8 9f ff ff ff       	call   801e91 <fd2sockid>
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	78 16                	js     801f0c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801ef6:	8b 55 10             	mov    0x10(%ebp),%edx
  801ef9:	89 54 24 08          	mov    %edx,0x8(%esp)
  801efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f00:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f04:	89 04 24             	mov    %eax,(%esp)
  801f07:	e8 55 02 00 00       	call   802161 <nsipc_connect>
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	e8 75 ff ff ff       	call   801e91 <fd2sockid>
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	78 0f                	js     801f2f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f27:	89 04 24             	mov    %eax,(%esp)
  801f2a:	e8 1d 01 00 00       	call   80204c <nsipc_shutdown>
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	e8 52 ff ff ff       	call   801e91 <fd2sockid>
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	78 16                	js     801f59 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801f43:	8b 55 10             	mov    0x10(%ebp),%edx
  801f46:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f51:	89 04 24             	mov    %eax,(%esp)
  801f54:	e8 47 02 00 00       	call   8021a0 <nsipc_bind>
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	e8 28 ff ff ff       	call   801e91 <fd2sockid>
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 1f                	js     801f8c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f6d:	8b 55 10             	mov    0x10(%ebp),%edx
  801f70:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f77:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f7b:	89 04 24             	mov    %eax,(%esp)
  801f7e:	e8 5c 02 00 00       	call   8021df <nsipc_accept>
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 05                	js     801f8c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801f87:	e8 62 fe ff ff       	call   801dee <alloc_sockfd>
}
  801f8c:	c9                   	leave  
  801f8d:	8d 76 00             	lea    0x0(%esi),%esi
  801f90:	c3                   	ret    
	...

00801fa0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fa6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801fac:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801fb3:	00 
  801fb4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801fbb:	00 
  801fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc0:	89 14 24             	mov    %edx,(%esp)
  801fc3:	e8 28 09 00 00       	call   8028f0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fc8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fcf:	00 
  801fd0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fd7:	00 
  801fd8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fdf:	e8 72 09 00 00       	call   802956 <ipc_recv>
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  801fff:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802004:	b8 09 00 00 00       	mov    $0x9,%eax
  802009:	e8 92 ff ff ff       	call   801fa0 <nsipc>
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802026:	b8 06 00 00 00       	mov    $0x6,%eax
  80202b:	e8 70 ff ff ff       	call   801fa0 <nsipc>
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802040:	b8 04 00 00 00       	mov    $0x4,%eax
  802045:	e8 56 ff ff ff       	call   801fa0 <nsipc>
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80205a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802062:	b8 03 00 00 00       	mov    $0x3,%eax
  802067:	e8 34 ff ff ff       	call   801fa0 <nsipc>
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	53                   	push   %ebx
  802072:	83 ec 14             	sub    $0x14,%esp
  802075:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802080:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802086:	7e 24                	jle    8020ac <nsipc_send+0x3e>
  802088:	c7 44 24 0c 98 32 80 	movl   $0x803298,0xc(%esp)
  80208f:	00 
  802090:	c7 44 24 08 a4 32 80 	movl   $0x8032a4,0x8(%esp)
  802097:	00 
  802098:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80209f:	00 
  8020a0:	c7 04 24 b9 32 80 00 	movl   $0x8032b9,(%esp)
  8020a7:	e8 20 07 00 00       	call   8027cc <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8020be:	e8 f2 e8 ff ff       	call   8009b5 <memmove>
	nsipcbuf.send.req_size = size;
  8020c3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8020c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8020cc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8020d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8020d6:	e8 c5 fe ff ff       	call   801fa0 <nsipc>
}
  8020db:	83 c4 14             	add    $0x14,%esp
  8020de:	5b                   	pop    %ebx
  8020df:	5d                   	pop    %ebp
  8020e0:	c3                   	ret    

008020e1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	56                   	push   %esi
  8020e5:	53                   	push   %ebx
  8020e6:	83 ec 10             	sub    $0x10,%esp
  8020e9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8020f4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8020fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802102:	b8 07 00 00 00       	mov    $0x7,%eax
  802107:	e8 94 fe ff ff       	call   801fa0 <nsipc>
  80210c:	89 c3                	mov    %eax,%ebx
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 46                	js     802158 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802112:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802117:	7f 04                	jg     80211d <nsipc_recv+0x3c>
  802119:	39 c6                	cmp    %eax,%esi
  80211b:	7d 24                	jge    802141 <nsipc_recv+0x60>
  80211d:	c7 44 24 0c c5 32 80 	movl   $0x8032c5,0xc(%esp)
  802124:	00 
  802125:	c7 44 24 08 a4 32 80 	movl   $0x8032a4,0x8(%esp)
  80212c:	00 
  80212d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802134:	00 
  802135:	c7 04 24 b9 32 80 00 	movl   $0x8032b9,(%esp)
  80213c:	e8 8b 06 00 00       	call   8027cc <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802141:	89 44 24 08          	mov    %eax,0x8(%esp)
  802145:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80214c:	00 
  80214d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802150:	89 04 24             	mov    %eax,(%esp)
  802153:	e8 5d e8 ff ff       	call   8009b5 <memmove>
	}

	return r;
}
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	5b                   	pop    %ebx
  80215e:	5e                   	pop    %esi
  80215f:	5d                   	pop    %ebp
  802160:	c3                   	ret    

00802161 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	53                   	push   %ebx
  802165:	83 ec 14             	sub    $0x14,%esp
  802168:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802173:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802185:	e8 2b e8 ff ff       	call   8009b5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80218a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802190:	b8 05 00 00 00       	mov    $0x5,%eax
  802195:	e8 06 fe ff ff       	call   801fa0 <nsipc>
}
  80219a:	83 c4 14             	add    $0x14,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5d                   	pop    %ebp
  80219f:	c3                   	ret    

008021a0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	53                   	push   %ebx
  8021a4:	83 ec 14             	sub    $0x14,%esp
  8021a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021b2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8021c4:	e8 ec e7 ff ff       	call   8009b5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021c9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8021cf:	b8 02 00 00 00       	mov    $0x2,%eax
  8021d4:	e8 c7 fd ff ff       	call   801fa0 <nsipc>
}
  8021d9:	83 c4 14             	add    $0x14,%esp
  8021dc:	5b                   	pop    %ebx
  8021dd:	5d                   	pop    %ebp
  8021de:	c3                   	ret    

008021df <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 18             	sub    $0x18,%esp
  8021e5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8021e8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f8:	e8 a3 fd ff ff       	call   801fa0 <nsipc>
  8021fd:	89 c3                	mov    %eax,%ebx
  8021ff:	85 c0                	test   %eax,%eax
  802201:	78 25                	js     802228 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802203:	be 10 60 80 00       	mov    $0x806010,%esi
  802208:	8b 06                	mov    (%esi),%eax
  80220a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80220e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802215:	00 
  802216:	8b 45 0c             	mov    0xc(%ebp),%eax
  802219:	89 04 24             	mov    %eax,(%esp)
  80221c:	e8 94 e7 ff ff       	call   8009b5 <memmove>
		*addrlen = ret->ret_addrlen;
  802221:	8b 16                	mov    (%esi),%edx
  802223:	8b 45 10             	mov    0x10(%ebp),%eax
  802226:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802228:	89 d8                	mov    %ebx,%eax
  80222a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80222d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802230:	89 ec                	mov    %ebp,%esp
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    
	...

00802240 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	83 ec 18             	sub    $0x18,%esp
  802246:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802249:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80224c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	89 04 24             	mov    %eax,(%esp)
  802255:	e8 86 f2 ff ff       	call   8014e0 <fd2data>
  80225a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80225c:	c7 44 24 04 da 32 80 	movl   $0x8032da,0x4(%esp)
  802263:	00 
  802264:	89 34 24             	mov    %esi,(%esp)
  802267:	e8 8e e5 ff ff       	call   8007fa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80226c:	8b 43 04             	mov    0x4(%ebx),%eax
  80226f:	2b 03                	sub    (%ebx),%eax
  802271:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802277:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80227e:	00 00 00 
	stat->st_dev = &devpipe;
  802281:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802288:	70 80 00 
	return 0;
}
  80228b:	b8 00 00 00 00       	mov    $0x0,%eax
  802290:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802293:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802296:	89 ec                	mov    %ebp,%esp
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    

0080229a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	53                   	push   %ebx
  80229e:	83 ec 14             	sub    $0x14,%esp
  8022a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022af:	e8 7b ec ff ff       	call   800f2f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022b4:	89 1c 24             	mov    %ebx,(%esp)
  8022b7:	e8 24 f2 ff ff       	call   8014e0 <fd2data>
  8022bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c7:	e8 63 ec ff ff       	call   800f2f <sys_page_unmap>
}
  8022cc:	83 c4 14             	add    $0x14,%esp
  8022cf:	5b                   	pop    %ebx
  8022d0:	5d                   	pop    %ebp
  8022d1:	c3                   	ret    

008022d2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	83 ec 2c             	sub    $0x2c,%esp
  8022db:	89 c7                	mov    %eax,%edi
  8022dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8022e0:	a1 74 70 80 00       	mov    0x807074,%eax
  8022e5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022e8:	89 3c 24             	mov    %edi,(%esp)
  8022eb:	e8 d0 06 00 00       	call   8029c0 <pageref>
  8022f0:	89 c6                	mov    %eax,%esi
  8022f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f5:	89 04 24             	mov    %eax,(%esp)
  8022f8:	e8 c3 06 00 00       	call   8029c0 <pageref>
  8022fd:	39 c6                	cmp    %eax,%esi
  8022ff:	0f 94 c0             	sete   %al
  802302:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802305:	8b 15 74 70 80 00    	mov    0x807074,%edx
  80230b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80230e:	39 cb                	cmp    %ecx,%ebx
  802310:	75 08                	jne    80231a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802312:	83 c4 2c             	add    $0x2c,%esp
  802315:	5b                   	pop    %ebx
  802316:	5e                   	pop    %esi
  802317:	5f                   	pop    %edi
  802318:	5d                   	pop    %ebp
  802319:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80231a:	83 f8 01             	cmp    $0x1,%eax
  80231d:	75 c1                	jne    8022e0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80231f:	8b 52 58             	mov    0x58(%edx),%edx
  802322:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802326:	89 54 24 08          	mov    %edx,0x8(%esp)
  80232a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80232e:	c7 04 24 e1 32 80 00 	movl   $0x8032e1,(%esp)
  802335:	e8 ff dd ff ff       	call   800139 <cprintf>
  80233a:	eb a4                	jmp    8022e0 <_pipeisclosed+0xe>

0080233c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	57                   	push   %edi
  802340:	56                   	push   %esi
  802341:	53                   	push   %ebx
  802342:	83 ec 1c             	sub    $0x1c,%esp
  802345:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802348:	89 34 24             	mov    %esi,(%esp)
  80234b:	e8 90 f1 ff ff       	call   8014e0 <fd2data>
  802350:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802352:	bf 00 00 00 00       	mov    $0x0,%edi
  802357:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80235b:	75 54                	jne    8023b1 <devpipe_write+0x75>
  80235d:	eb 60                	jmp    8023bf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80235f:	89 da                	mov    %ebx,%edx
  802361:	89 f0                	mov    %esi,%eax
  802363:	e8 6a ff ff ff       	call   8022d2 <_pipeisclosed>
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 07                	je     802373 <devpipe_write+0x37>
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	eb 53                	jmp    8023c6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802373:	90                   	nop
  802374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802378:	e8 cd ec ff ff       	call   80104a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80237d:	8b 43 04             	mov    0x4(%ebx),%eax
  802380:	8b 13                	mov    (%ebx),%edx
  802382:	83 c2 20             	add    $0x20,%edx
  802385:	39 d0                	cmp    %edx,%eax
  802387:	73 d6                	jae    80235f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802389:	89 c2                	mov    %eax,%edx
  80238b:	c1 fa 1f             	sar    $0x1f,%edx
  80238e:	c1 ea 1b             	shr    $0x1b,%edx
  802391:	01 d0                	add    %edx,%eax
  802393:	83 e0 1f             	and    $0x1f,%eax
  802396:	29 d0                	sub    %edx,%eax
  802398:	89 c2                	mov    %eax,%edx
  80239a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8023a1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8023a5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023a9:	83 c7 01             	add    $0x1,%edi
  8023ac:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8023af:	76 13                	jbe    8023c4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8023b4:	8b 13                	mov    (%ebx),%edx
  8023b6:	83 c2 20             	add    $0x20,%edx
  8023b9:	39 d0                	cmp    %edx,%eax
  8023bb:	73 a2                	jae    80235f <devpipe_write+0x23>
  8023bd:	eb ca                	jmp    802389 <devpipe_write+0x4d>
  8023bf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8023c4:	89 f8                	mov    %edi,%eax
}
  8023c6:	83 c4 1c             	add    $0x1c,%esp
  8023c9:	5b                   	pop    %ebx
  8023ca:	5e                   	pop    %esi
  8023cb:	5f                   	pop    %edi
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    

008023ce <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 28             	sub    $0x28,%esp
  8023d4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023d7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023da:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023e0:	89 3c 24             	mov    %edi,(%esp)
  8023e3:	e8 f8 f0 ff ff       	call   8014e0 <fd2data>
  8023e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023ea:	be 00 00 00 00       	mov    $0x0,%esi
  8023ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023f3:	75 4c                	jne    802441 <devpipe_read+0x73>
  8023f5:	eb 5b                	jmp    802452 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8023f7:	89 f0                	mov    %esi,%eax
  8023f9:	eb 5e                	jmp    802459 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023fb:	89 da                	mov    %ebx,%edx
  8023fd:	89 f8                	mov    %edi,%eax
  8023ff:	90                   	nop
  802400:	e8 cd fe ff ff       	call   8022d2 <_pipeisclosed>
  802405:	85 c0                	test   %eax,%eax
  802407:	74 07                	je     802410 <devpipe_read+0x42>
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
  80240e:	eb 49                	jmp    802459 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802410:	e8 35 ec ff ff       	call   80104a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802415:	8b 03                	mov    (%ebx),%eax
  802417:	3b 43 04             	cmp    0x4(%ebx),%eax
  80241a:	74 df                	je     8023fb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80241c:	89 c2                	mov    %eax,%edx
  80241e:	c1 fa 1f             	sar    $0x1f,%edx
  802421:	c1 ea 1b             	shr    $0x1b,%edx
  802424:	01 d0                	add    %edx,%eax
  802426:	83 e0 1f             	and    $0x1f,%eax
  802429:	29 d0                	sub    %edx,%eax
  80242b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802430:	8b 55 0c             	mov    0xc(%ebp),%edx
  802433:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802436:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802439:	83 c6 01             	add    $0x1,%esi
  80243c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80243f:	76 16                	jbe    802457 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802441:	8b 03                	mov    (%ebx),%eax
  802443:	3b 43 04             	cmp    0x4(%ebx),%eax
  802446:	75 d4                	jne    80241c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802448:	85 f6                	test   %esi,%esi
  80244a:	75 ab                	jne    8023f7 <devpipe_read+0x29>
  80244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802450:	eb a9                	jmp    8023fb <devpipe_read+0x2d>
  802452:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802457:	89 f0                	mov    %esi,%eax
}
  802459:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80245c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80245f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802462:	89 ec                	mov    %ebp,%esp
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80246c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80246f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	89 04 24             	mov    %eax,(%esp)
  802479:	e8 ef f0 ff ff       	call   80156d <fd_lookup>
  80247e:	85 c0                	test   %eax,%eax
  802480:	78 15                	js     802497 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	89 04 24             	mov    %eax,(%esp)
  802488:	e8 53 f0 ff ff       	call   8014e0 <fd2data>
	return _pipeisclosed(fd, p);
  80248d:	89 c2                	mov    %eax,%edx
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	e8 3b fe ff ff       	call   8022d2 <_pipeisclosed>
}
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	83 ec 48             	sub    $0x48,%esp
  80249f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8024a2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8024a5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8024a8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024ab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8024ae:	89 04 24             	mov    %eax,(%esp)
  8024b1:	e8 45 f0 ff ff       	call   8014fb <fd_alloc>
  8024b6:	89 c3                	mov    %eax,%ebx
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	0f 88 42 01 00 00    	js     802602 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024c0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024c7:	00 
  8024c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d6:	e8 10 eb ff ff       	call   800feb <sys_page_alloc>
  8024db:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	0f 88 1d 01 00 00    	js     802602 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8024e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8024e8:	89 04 24             	mov    %eax,(%esp)
  8024eb:	e8 0b f0 ff ff       	call   8014fb <fd_alloc>
  8024f0:	89 c3                	mov    %eax,%ebx
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	0f 88 f5 00 00 00    	js     8025ef <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024fa:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802501:	00 
  802502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802505:	89 44 24 04          	mov    %eax,0x4(%esp)
  802509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802510:	e8 d6 ea ff ff       	call   800feb <sys_page_alloc>
  802515:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802517:	85 c0                	test   %eax,%eax
  802519:	0f 88 d0 00 00 00    	js     8025ef <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80251f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802522:	89 04 24             	mov    %eax,(%esp)
  802525:	e8 b6 ef ff ff       	call   8014e0 <fd2data>
  80252a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80252c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802533:	00 
  802534:	89 44 24 04          	mov    %eax,0x4(%esp)
  802538:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80253f:	e8 a7 ea ff ff       	call   800feb <sys_page_alloc>
  802544:	89 c3                	mov    %eax,%ebx
  802546:	85 c0                	test   %eax,%eax
  802548:	0f 88 8e 00 00 00    	js     8025dc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80254e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802551:	89 04 24             	mov    %eax,(%esp)
  802554:	e8 87 ef ff ff       	call   8014e0 <fd2data>
  802559:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802560:	00 
  802561:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802565:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80256c:	00 
  80256d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802571:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802578:	e8 10 ea ff ff       	call   800f8d <sys_page_map>
  80257d:	89 c3                	mov    %eax,%ebx
  80257f:	85 c0                	test   %eax,%eax
  802581:	78 49                	js     8025cc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802583:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802588:	8b 08                	mov    (%eax),%ecx
  80258a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80258d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80258f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802592:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802599:	8b 10                	mov    (%eax),%edx
  80259b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8025aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ad:	89 04 24             	mov    %eax,(%esp)
  8025b0:	e8 1b ef ff ff       	call   8014d0 <fd2num>
  8025b5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8025b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ba:	89 04 24             	mov    %eax,(%esp)
  8025bd:	e8 0e ef ff ff       	call   8014d0 <fd2num>
  8025c2:	89 47 04             	mov    %eax,0x4(%edi)
  8025c5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8025ca:	eb 36                	jmp    802602 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8025cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d7:	e8 53 e9 ff ff       	call   800f2f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8025dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025ea:	e8 40 e9 ff ff       	call   800f2f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8025ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025fd:	e8 2d e9 ff ff       	call   800f2f <sys_page_unmap>
    err:
	return r;
}
  802602:	89 d8                	mov    %ebx,%eax
  802604:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802607:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80260a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80260d:	89 ec                	mov    %ebp,%esp
  80260f:	5d                   	pop    %ebp
  802610:	c3                   	ret    
	...

00802620 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
  802628:	5d                   	pop    %ebp
  802629:	c3                   	ret    

0080262a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802630:	c7 44 24 04 f9 32 80 	movl   $0x8032f9,0x4(%esp)
  802637:	00 
  802638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263b:	89 04 24             	mov    %eax,(%esp)
  80263e:	e8 b7 e1 ff ff       	call   8007fa <strcpy>
	return 0;
}
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	57                   	push   %edi
  80264e:	56                   	push   %esi
  80264f:	53                   	push   %ebx
  802650:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802656:	b8 00 00 00 00       	mov    $0x0,%eax
  80265b:	be 00 00 00 00       	mov    $0x0,%esi
  802660:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802664:	74 3f                	je     8026a5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802666:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80266c:	8b 55 10             	mov    0x10(%ebp),%edx
  80266f:	29 c2                	sub    %eax,%edx
  802671:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802673:	83 fa 7f             	cmp    $0x7f,%edx
  802676:	76 05                	jbe    80267d <devcons_write+0x33>
  802678:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80267d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802681:	03 45 0c             	add    0xc(%ebp),%eax
  802684:	89 44 24 04          	mov    %eax,0x4(%esp)
  802688:	89 3c 24             	mov    %edi,(%esp)
  80268b:	e8 25 e3 ff ff       	call   8009b5 <memmove>
		sys_cputs(buf, m);
  802690:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802694:	89 3c 24             	mov    %edi,(%esp)
  802697:	e8 54 e5 ff ff       	call   800bf0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80269c:	01 de                	add    %ebx,%esi
  80269e:	89 f0                	mov    %esi,%eax
  8026a0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026a3:	72 c7                	jb     80266c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8026a5:	89 f0                	mov    %esi,%eax
  8026a7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8026ad:	5b                   	pop    %ebx
  8026ae:	5e                   	pop    %esi
  8026af:	5f                   	pop    %edi
  8026b0:	5d                   	pop    %ebp
  8026b1:	c3                   	ret    

008026b2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8026be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8026c5:	00 
  8026c6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026c9:	89 04 24             	mov    %eax,(%esp)
  8026cc:	e8 1f e5 ff ff       	call   800bf0 <sys_cputs>
}
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8026d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026dd:	75 07                	jne    8026e6 <devcons_read+0x13>
  8026df:	eb 28                	jmp    802709 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8026e1:	e8 64 e9 ff ff       	call   80104a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8026e6:	66 90                	xchg   %ax,%ax
  8026e8:	e8 cf e4 ff ff       	call   800bbc <sys_cgetc>
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	90                   	nop
  8026f0:	74 ef                	je     8026e1 <devcons_read+0xe>
  8026f2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	78 16                	js     80270e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8026f8:	83 f8 04             	cmp    $0x4,%eax
  8026fb:	74 0c                	je     802709 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8026fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802700:	88 10                	mov    %dl,(%eax)
  802702:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802707:	eb 05                	jmp    80270e <devcons_read+0x3b>
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802716:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802719:	89 04 24             	mov    %eax,(%esp)
  80271c:	e8 da ed ff ff       	call   8014fb <fd_alloc>
  802721:	85 c0                	test   %eax,%eax
  802723:	78 3f                	js     802764 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802725:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80272c:	00 
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	89 44 24 04          	mov    %eax,0x4(%esp)
  802734:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80273b:	e8 ab e8 ff ff       	call   800feb <sys_page_alloc>
  802740:	85 c0                	test   %eax,%eax
  802742:	78 20                	js     802764 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802744:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	89 04 24             	mov    %eax,(%esp)
  80275f:	e8 6c ed ff ff       	call   8014d0 <fd2num>
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80276c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80276f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	89 04 24             	mov    %eax,(%esp)
  802779:	e8 ef ed ff ff       	call   80156d <fd_lookup>
  80277e:	85 c0                	test   %eax,%eax
  802780:	78 11                	js     802793 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  80278d:	0f 94 c0             	sete   %al
  802790:	0f b6 c0             	movzbl %al,%eax
}
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80279b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027a2:	00 
  8027a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b1:	e8 18 f0 ff ff       	call   8017ce <read>
	if (r < 0)
  8027b6:	85 c0                	test   %eax,%eax
  8027b8:	78 0f                	js     8027c9 <getchar+0x34>
		return r;
	if (r < 1)
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	7f 07                	jg     8027c5 <getchar+0x30>
  8027be:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027c3:	eb 04                	jmp    8027c9 <getchar+0x34>
		return -E_EOF;
	return c;
  8027c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    
	...

008027cc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
  8027cf:	53                   	push   %ebx
  8027d0:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8027d3:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8027d6:	a1 78 70 80 00       	mov    0x807078,%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 10                	je     8027ef <_panic+0x23>
		cprintf("%s: ", argv0);
  8027df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e3:	c7 04 24 05 33 80 00 	movl   $0x803305,(%esp)
  8027ea:	e8 4a d9 ff ff       	call   800139 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8027ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027fd:	a1 00 70 80 00       	mov    0x807000,%eax
  802802:	89 44 24 04          	mov    %eax,0x4(%esp)
  802806:	c7 04 24 0a 33 80 00 	movl   $0x80330a,(%esp)
  80280d:	e8 27 d9 ff ff       	call   800139 <cprintf>
	vcprintf(fmt, ap);
  802812:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802816:	8b 45 10             	mov    0x10(%ebp),%eax
  802819:	89 04 24             	mov    %eax,(%esp)
  80281c:	e8 b7 d8 ff ff       	call   8000d8 <vcprintf>
	cprintf("\n");
  802821:	c7 04 24 f2 32 80 00 	movl   $0x8032f2,(%esp)
  802828:	e8 0c d9 ff ff       	call   800139 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80282d:	cc                   	int3   
  80282e:	eb fd                	jmp    80282d <_panic+0x61>

00802830 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802836:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  80283d:	75 78                	jne    8028b7 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80283f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802846:	00 
  802847:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80284e:	ee 
  80284f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802856:	e8 90 e7 ff ff       	call   800feb <sys_page_alloc>
  80285b:	85 c0                	test   %eax,%eax
  80285d:	79 20                	jns    80287f <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  80285f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802863:	c7 44 24 08 26 33 80 	movl   $0x803326,0x8(%esp)
  80286a:	00 
  80286b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802872:	00 
  802873:	c7 04 24 44 33 80 00 	movl   $0x803344,(%esp)
  80287a:	e8 4d ff ff ff       	call   8027cc <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80287f:	c7 44 24 04 c4 28 80 	movl   $0x8028c4,0x4(%esp)
  802886:	00 
  802887:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80288e:	e8 82 e5 ff ff       	call   800e15 <sys_env_set_pgfault_upcall>
  802893:	85 c0                	test   %eax,%eax
  802895:	79 20                	jns    8028b7 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802897:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80289b:	c7 44 24 08 54 33 80 	movl   $0x803354,0x8(%esp)
  8028a2:	00 
  8028a3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8028aa:	00 
  8028ab:	c7 04 24 44 33 80 00 	movl   $0x803344,(%esp)
  8028b2:	e8 15 ff ff ff       	call   8027cc <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	a3 7c 70 80 00       	mov    %eax,0x80707c
	
}
  8028bf:	c9                   	leave  
  8028c0:	c3                   	ret    
  8028c1:	00 00                	add    %al,(%eax)
	...

008028c4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028c4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028c5:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  8028ca:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028cc:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  8028cf:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  8028d1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  8028d5:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  8028d9:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  8028db:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  8028dc:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  8028de:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  8028e1:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8028e5:	83 c4 08             	add    $0x8,%esp
	popal
  8028e8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  8028e9:	83 c4 04             	add    $0x4,%esp
	popfl
  8028ec:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8028ed:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  8028ee:	c3                   	ret    
	...

008028f0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
  8028f3:	57                   	push   %edi
  8028f4:	56                   	push   %esi
  8028f5:	53                   	push   %ebx
  8028f6:	83 ec 1c             	sub    $0x1c,%esp
  8028f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8028fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802902:	85 db                	test   %ebx,%ebx
  802904:	75 2d                	jne    802933 <ipc_send+0x43>
  802906:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80290b:	eb 26                	jmp    802933 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80290d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802910:	74 1c                	je     80292e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802912:	c7 44 24 08 80 33 80 	movl   $0x803380,0x8(%esp)
  802919:	00 
  80291a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802921:	00 
  802922:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  802929:	e8 9e fe ff ff       	call   8027cc <_panic>
		sys_yield();
  80292e:	e8 17 e7 ff ff       	call   80104a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802933:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802937:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80293b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	89 04 24             	mov    %eax,(%esp)
  802945:	e8 93 e4 ff ff       	call   800ddd <sys_ipc_try_send>
  80294a:	85 c0                	test   %eax,%eax
  80294c:	78 bf                	js     80290d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80294e:	83 c4 1c             	add    $0x1c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    

00802956 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	56                   	push   %esi
  80295a:	53                   	push   %ebx
  80295b:	83 ec 10             	sub    $0x10,%esp
  80295e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802961:	8b 45 0c             	mov    0xc(%ebp),%eax
  802964:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802967:	85 c0                	test   %eax,%eax
  802969:	75 05                	jne    802970 <ipc_recv+0x1a>
  80296b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802970:	89 04 24             	mov    %eax,(%esp)
  802973:	e8 08 e4 ff ff       	call   800d80 <sys_ipc_recv>
  802978:	85 c0                	test   %eax,%eax
  80297a:	79 16                	jns    802992 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80297c:	85 db                	test   %ebx,%ebx
  80297e:	74 06                	je     802986 <ipc_recv+0x30>
			*from_env_store = 0;
  802980:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802986:	85 f6                	test   %esi,%esi
  802988:	74 2c                	je     8029b6 <ipc_recv+0x60>
			*perm_store = 0;
  80298a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802990:	eb 24                	jmp    8029b6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802992:	85 db                	test   %ebx,%ebx
  802994:	74 0a                	je     8029a0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802996:	a1 74 70 80 00       	mov    0x807074,%eax
  80299b:	8b 40 74             	mov    0x74(%eax),%eax
  80299e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  8029a0:	85 f6                	test   %esi,%esi
  8029a2:	74 0a                	je     8029ae <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  8029a4:	a1 74 70 80 00       	mov    0x807074,%eax
  8029a9:	8b 40 78             	mov    0x78(%eax),%eax
  8029ac:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  8029ae:	a1 74 70 80 00       	mov    0x807074,%eax
  8029b3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8029b6:	83 c4 10             	add    $0x10,%esp
  8029b9:	5b                   	pop    %ebx
  8029ba:	5e                   	pop    %esi
  8029bb:	5d                   	pop    %ebp
  8029bc:	c3                   	ret    
  8029bd:	00 00                	add    %al,(%eax)
	...

008029c0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	89 c2                	mov    %eax,%edx
  8029c8:	c1 ea 16             	shr    $0x16,%edx
  8029cb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8029d2:	f6 c2 01             	test   $0x1,%dl
  8029d5:	74 26                	je     8029fd <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8029d7:	c1 e8 0c             	shr    $0xc,%eax
  8029da:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8029e1:	a8 01                	test   $0x1,%al
  8029e3:	74 18                	je     8029fd <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8029e5:	c1 e8 0c             	shr    $0xc,%eax
  8029e8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8029eb:	c1 e2 02             	shl    $0x2,%edx
  8029ee:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8029f3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8029f8:	0f b7 c0             	movzwl %ax,%eax
  8029fb:	eb 05                	jmp    802a02 <pageref+0x42>
  8029fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a02:	5d                   	pop    %ebp
  802a03:	c3                   	ret    
	...

00802a10 <__udivdi3>:
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	57                   	push   %edi
  802a14:	56                   	push   %esi
  802a15:	83 ec 10             	sub    $0x10,%esp
  802a18:	8b 45 14             	mov    0x14(%ebp),%eax
  802a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1e:	8b 75 10             	mov    0x10(%ebp),%esi
  802a21:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a24:	85 c0                	test   %eax,%eax
  802a26:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802a29:	75 35                	jne    802a60 <__udivdi3+0x50>
  802a2b:	39 fe                	cmp    %edi,%esi
  802a2d:	77 61                	ja     802a90 <__udivdi3+0x80>
  802a2f:	85 f6                	test   %esi,%esi
  802a31:	75 0b                	jne    802a3e <__udivdi3+0x2e>
  802a33:	b8 01 00 00 00       	mov    $0x1,%eax
  802a38:	31 d2                	xor    %edx,%edx
  802a3a:	f7 f6                	div    %esi
  802a3c:	89 c6                	mov    %eax,%esi
  802a3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a41:	31 d2                	xor    %edx,%edx
  802a43:	89 f8                	mov    %edi,%eax
  802a45:	f7 f6                	div    %esi
  802a47:	89 c7                	mov    %eax,%edi
  802a49:	89 c8                	mov    %ecx,%eax
  802a4b:	f7 f6                	div    %esi
  802a4d:	89 c1                	mov    %eax,%ecx
  802a4f:	89 fa                	mov    %edi,%edx
  802a51:	89 c8                	mov    %ecx,%eax
  802a53:	83 c4 10             	add    $0x10,%esp
  802a56:	5e                   	pop    %esi
  802a57:	5f                   	pop    %edi
  802a58:	5d                   	pop    %ebp
  802a59:	c3                   	ret    
  802a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a60:	39 f8                	cmp    %edi,%eax
  802a62:	77 1c                	ja     802a80 <__udivdi3+0x70>
  802a64:	0f bd d0             	bsr    %eax,%edx
  802a67:	83 f2 1f             	xor    $0x1f,%edx
  802a6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a6d:	75 39                	jne    802aa8 <__udivdi3+0x98>
  802a6f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802a72:	0f 86 a0 00 00 00    	jbe    802b18 <__udivdi3+0x108>
  802a78:	39 f8                	cmp    %edi,%eax
  802a7a:	0f 82 98 00 00 00    	jb     802b18 <__udivdi3+0x108>
  802a80:	31 ff                	xor    %edi,%edi
  802a82:	31 c9                	xor    %ecx,%ecx
  802a84:	89 c8                	mov    %ecx,%eax
  802a86:	89 fa                	mov    %edi,%edx
  802a88:	83 c4 10             	add    $0x10,%esp
  802a8b:	5e                   	pop    %esi
  802a8c:	5f                   	pop    %edi
  802a8d:	5d                   	pop    %ebp
  802a8e:	c3                   	ret    
  802a8f:	90                   	nop
  802a90:	89 d1                	mov    %edx,%ecx
  802a92:	89 fa                	mov    %edi,%edx
  802a94:	89 c8                	mov    %ecx,%eax
  802a96:	31 ff                	xor    %edi,%edi
  802a98:	f7 f6                	div    %esi
  802a9a:	89 c1                	mov    %eax,%ecx
  802a9c:	89 fa                	mov    %edi,%edx
  802a9e:	89 c8                	mov    %ecx,%eax
  802aa0:	83 c4 10             	add    $0x10,%esp
  802aa3:	5e                   	pop    %esi
  802aa4:	5f                   	pop    %edi
  802aa5:	5d                   	pop    %ebp
  802aa6:	c3                   	ret    
  802aa7:	90                   	nop
  802aa8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802aac:	89 f2                	mov    %esi,%edx
  802aae:	d3 e0                	shl    %cl,%eax
  802ab0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ab3:	b8 20 00 00 00       	mov    $0x20,%eax
  802ab8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802abb:	89 c1                	mov    %eax,%ecx
  802abd:	d3 ea                	shr    %cl,%edx
  802abf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ac3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802ac6:	d3 e6                	shl    %cl,%esi
  802ac8:	89 c1                	mov    %eax,%ecx
  802aca:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802acd:	89 fe                	mov    %edi,%esi
  802acf:	d3 ee                	shr    %cl,%esi
  802ad1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ad5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adb:	d3 e7                	shl    %cl,%edi
  802add:	89 c1                	mov    %eax,%ecx
  802adf:	d3 ea                	shr    %cl,%edx
  802ae1:	09 d7                	or     %edx,%edi
  802ae3:	89 f2                	mov    %esi,%edx
  802ae5:	89 f8                	mov    %edi,%eax
  802ae7:	f7 75 ec             	divl   -0x14(%ebp)
  802aea:	89 d6                	mov    %edx,%esi
  802aec:	89 c7                	mov    %eax,%edi
  802aee:	f7 65 e8             	mull   -0x18(%ebp)
  802af1:	39 d6                	cmp    %edx,%esi
  802af3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802af6:	72 30                	jb     802b28 <__udivdi3+0x118>
  802af8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802aff:	d3 e2                	shl    %cl,%edx
  802b01:	39 c2                	cmp    %eax,%edx
  802b03:	73 05                	jae    802b0a <__udivdi3+0xfa>
  802b05:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802b08:	74 1e                	je     802b28 <__udivdi3+0x118>
  802b0a:	89 f9                	mov    %edi,%ecx
  802b0c:	31 ff                	xor    %edi,%edi
  802b0e:	e9 71 ff ff ff       	jmp    802a84 <__udivdi3+0x74>
  802b13:	90                   	nop
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	31 ff                	xor    %edi,%edi
  802b1a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802b1f:	e9 60 ff ff ff       	jmp    802a84 <__udivdi3+0x74>
  802b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b28:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802b2b:	31 ff                	xor    %edi,%edi
  802b2d:	89 c8                	mov    %ecx,%eax
  802b2f:	89 fa                	mov    %edi,%edx
  802b31:	83 c4 10             	add    $0x10,%esp
  802b34:	5e                   	pop    %esi
  802b35:	5f                   	pop    %edi
  802b36:	5d                   	pop    %ebp
  802b37:	c3                   	ret    
	...

00802b40 <__umoddi3>:
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
  802b43:	57                   	push   %edi
  802b44:	56                   	push   %esi
  802b45:	83 ec 20             	sub    $0x20,%esp
  802b48:	8b 55 14             	mov    0x14(%ebp),%edx
  802b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b4e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802b51:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b54:	85 d2                	test   %edx,%edx
  802b56:	89 c8                	mov    %ecx,%eax
  802b58:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802b5b:	75 13                	jne    802b70 <__umoddi3+0x30>
  802b5d:	39 f7                	cmp    %esi,%edi
  802b5f:	76 3f                	jbe    802ba0 <__umoddi3+0x60>
  802b61:	89 f2                	mov    %esi,%edx
  802b63:	f7 f7                	div    %edi
  802b65:	89 d0                	mov    %edx,%eax
  802b67:	31 d2                	xor    %edx,%edx
  802b69:	83 c4 20             	add    $0x20,%esp
  802b6c:	5e                   	pop    %esi
  802b6d:	5f                   	pop    %edi
  802b6e:	5d                   	pop    %ebp
  802b6f:	c3                   	ret    
  802b70:	39 f2                	cmp    %esi,%edx
  802b72:	77 4c                	ja     802bc0 <__umoddi3+0x80>
  802b74:	0f bd ca             	bsr    %edx,%ecx
  802b77:	83 f1 1f             	xor    $0x1f,%ecx
  802b7a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802b7d:	75 51                	jne    802bd0 <__umoddi3+0x90>
  802b7f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802b82:	0f 87 e0 00 00 00    	ja     802c68 <__umoddi3+0x128>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	29 f8                	sub    %edi,%eax
  802b8d:	19 d6                	sbb    %edx,%esi
  802b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	89 f2                	mov    %esi,%edx
  802b97:	83 c4 20             	add    $0x20,%esp
  802b9a:	5e                   	pop    %esi
  802b9b:	5f                   	pop    %edi
  802b9c:	5d                   	pop    %ebp
  802b9d:	c3                   	ret    
  802b9e:	66 90                	xchg   %ax,%ax
  802ba0:	85 ff                	test   %edi,%edi
  802ba2:	75 0b                	jne    802baf <__umoddi3+0x6f>
  802ba4:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba9:	31 d2                	xor    %edx,%edx
  802bab:	f7 f7                	div    %edi
  802bad:	89 c7                	mov    %eax,%edi
  802baf:	89 f0                	mov    %esi,%eax
  802bb1:	31 d2                	xor    %edx,%edx
  802bb3:	f7 f7                	div    %edi
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	f7 f7                	div    %edi
  802bba:	eb a9                	jmp    802b65 <__umoddi3+0x25>
  802bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bc0:	89 c8                	mov    %ecx,%eax
  802bc2:	89 f2                	mov    %esi,%edx
  802bc4:	83 c4 20             	add    $0x20,%esp
  802bc7:	5e                   	pop    %esi
  802bc8:	5f                   	pop    %edi
  802bc9:	5d                   	pop    %ebp
  802bca:	c3                   	ret    
  802bcb:	90                   	nop
  802bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bd4:	d3 e2                	shl    %cl,%edx
  802bd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bd9:	ba 20 00 00 00       	mov    $0x20,%edx
  802bde:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802be1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802be4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802be8:	89 fa                	mov    %edi,%edx
  802bea:	d3 ea                	shr    %cl,%edx
  802bec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bf0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802bf3:	d3 e7                	shl    %cl,%edi
  802bf5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802bf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bfc:	89 f2                	mov    %esi,%edx
  802bfe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802c01:	89 c7                	mov    %eax,%edi
  802c03:	d3 ea                	shr    %cl,%edx
  802c05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802c0c:	89 c2                	mov    %eax,%edx
  802c0e:	d3 e6                	shl    %cl,%esi
  802c10:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c14:	d3 ea                	shr    %cl,%edx
  802c16:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c1a:	09 d6                	or     %edx,%esi
  802c1c:	89 f0                	mov    %esi,%eax
  802c1e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802c21:	d3 e7                	shl    %cl,%edi
  802c23:	89 f2                	mov    %esi,%edx
  802c25:	f7 75 f4             	divl   -0xc(%ebp)
  802c28:	89 d6                	mov    %edx,%esi
  802c2a:	f7 65 e8             	mull   -0x18(%ebp)
  802c2d:	39 d6                	cmp    %edx,%esi
  802c2f:	72 2b                	jb     802c5c <__umoddi3+0x11c>
  802c31:	39 c7                	cmp    %eax,%edi
  802c33:	72 23                	jb     802c58 <__umoddi3+0x118>
  802c35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c39:	29 c7                	sub    %eax,%edi
  802c3b:	19 d6                	sbb    %edx,%esi
  802c3d:	89 f0                	mov    %esi,%eax
  802c3f:	89 f2                	mov    %esi,%edx
  802c41:	d3 ef                	shr    %cl,%edi
  802c43:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c47:	d3 e0                	shl    %cl,%eax
  802c49:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c4d:	09 f8                	or     %edi,%eax
  802c4f:	d3 ea                	shr    %cl,%edx
  802c51:	83 c4 20             	add    $0x20,%esp
  802c54:	5e                   	pop    %esi
  802c55:	5f                   	pop    %edi
  802c56:	5d                   	pop    %ebp
  802c57:	c3                   	ret    
  802c58:	39 d6                	cmp    %edx,%esi
  802c5a:	75 d9                	jne    802c35 <__umoddi3+0xf5>
  802c5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c5f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802c62:	eb d1                	jmp    802c35 <__umoddi3+0xf5>
  802c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c68:	39 f2                	cmp    %esi,%edx
  802c6a:	0f 82 18 ff ff ff    	jb     802b88 <__umoddi3+0x48>
  802c70:	e9 1d ff ff ff       	jmp    802b92 <__umoddi3+0x52>
