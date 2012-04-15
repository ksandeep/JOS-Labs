
obj/user/faultdie:     file format elf32-i386


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
  80002c:	e8 63 00 00 00       	call   800094 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
	sys_env_destroy(sys_getenvid());
}

void
umain(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  800046:	c7 04 24 5e 00 80 00 	movl   $0x80005e,(%esp)
  80004d:	e8 de 10 00 00       	call   801130 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800052:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800059:	00 00 00 
}
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	83 ec 18             	sub    $0x18,%esp
  800064:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800067:	8b 50 04             	mov    0x4(%eax),%edx
  80006a:	83 e2 07             	and    $0x7,%edx
  80006d:	89 54 24 08          	mov    %edx,0x8(%esp)
  800071:	8b 00                	mov    (%eax),%eax
  800073:	89 44 24 04          	mov    %eax,0x4(%esp)
  800077:	c7 04 24 e0 28 80 00 	movl   $0x8028e0,(%esp)
  80007e:	e8 de 00 00 00       	call   800161 <cprintf>
	sys_env_destroy(sys_getenvid());
  800083:	e8 16 10 00 00       	call   80109e <sys_getenvid>
  800088:	89 04 24             	mov    %eax,(%esp)
  80008b:	e8 42 10 00 00       	call   8010d2 <sys_env_destroy>
}
  800090:	c9                   	leave  
  800091:	c3                   	ret    
	...

00800094 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 18             	sub    $0x18,%esp
  80009a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80009d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8000a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8000a6:	e8 f3 0f 00 00       	call   80109e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8000ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b8:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bd:	85 f6                	test   %esi,%esi
  8000bf:	7e 07                	jle    8000c8 <libmain+0x34>
		binaryname = argv[0];
  8000c1:	8b 03                	mov    (%ebx),%eax
  8000c3:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  8000c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000cc:	89 34 24             	mov    %esi,(%esp)
  8000cf:	e8 6c ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  8000d4:	e8 0b 00 00 00       	call   8000e4 <exit>
}
  8000d9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000dc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000df:	89 ec                	mov    %ebp,%esp
  8000e1:	5d                   	pop    %ebp
  8000e2:	c3                   	ret    
	...

008000e4 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ea:	e8 dc 15 00 00       	call   8016cb <close_all>
	sys_env_destroy(0);
  8000ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f6:	e8 d7 0f 00 00       	call   8010d2 <sys_env_destroy>
}
  8000fb:	c9                   	leave  
  8000fc:	c3                   	ret    
  8000fd:	00 00                	add    %al,(%eax)
	...

00800100 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800109:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800110:	00 00 00 
	b.cnt = 0;
  800113:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800120:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800124:	8b 45 08             	mov    0x8(%ebp),%eax
  800127:	89 44 24 08          	mov    %eax,0x8(%esp)
  80012b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800131:	89 44 24 04          	mov    %eax,0x4(%esp)
  800135:	c7 04 24 7b 01 80 00 	movl   $0x80017b,(%esp)
  80013c:	e8 cc 01 00 00       	call   80030d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800141:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800151:	89 04 24             	mov    %eax,(%esp)
  800154:	e8 b7 0a 00 00       	call   800c10 <sys_cputs>

	return b.cnt;
}
  800159:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80015f:	c9                   	leave  
  800160:	c3                   	ret    

00800161 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800161:	55                   	push   %ebp
  800162:	89 e5                	mov    %esp,%ebp
  800164:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800167:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80016a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016e:	8b 45 08             	mov    0x8(%ebp),%eax
  800171:	89 04 24             	mov    %eax,(%esp)
  800174:	e8 87 ff ff ff       	call   800100 <vcprintf>
	va_end(ap);

	return cnt;
}
  800179:	c9                   	leave  
  80017a:	c3                   	ret    

0080017b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	53                   	push   %ebx
  80017f:	83 ec 14             	sub    $0x14,%esp
  800182:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800185:	8b 03                	mov    (%ebx),%eax
  800187:	8b 55 08             	mov    0x8(%ebp),%edx
  80018a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80018e:	83 c0 01             	add    $0x1,%eax
  800191:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800193:	3d ff 00 00 00       	cmp    $0xff,%eax
  800198:	75 19                	jne    8001b3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80019a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001a1:	00 
  8001a2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a5:	89 04 24             	mov    %eax,(%esp)
  8001a8:	e8 63 0a 00 00       	call   800c10 <sys_cputs>
		b->idx = 0;
  8001ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001b3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b7:	83 c4 14             	add    $0x14,%esp
  8001ba:	5b                   	pop    %ebx
  8001bb:	5d                   	pop    %ebp
  8001bc:	c3                   	ret    
  8001bd:	00 00                	add    %al,(%eax)
	...

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 4c             	sub    $0x4c,%esp
  8001c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001cc:	89 d6                	mov    %edx,%esi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001da:	8b 45 10             	mov    0x10(%ebp),%eax
  8001dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001e0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001eb:	39 d1                	cmp    %edx,%ecx
  8001ed:	72 15                	jb     800204 <printnum+0x44>
  8001ef:	77 07                	ja     8001f8 <printnum+0x38>
  8001f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001f4:	39 d0                	cmp    %edx,%eax
  8001f6:	76 0c                	jbe    800204 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001f8:	83 eb 01             	sub    $0x1,%ebx
  8001fb:	85 db                	test   %ebx,%ebx
  8001fd:	8d 76 00             	lea    0x0(%esi),%esi
  800200:	7f 61                	jg     800263 <printnum+0xa3>
  800202:	eb 70                	jmp    800274 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800204:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800208:	83 eb 01             	sub    $0x1,%ebx
  80020b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80020f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800213:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800217:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80021b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80021e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800221:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800224:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800228:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80022f:	00 
  800230:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800233:	89 04 24             	mov    %eax,(%esp)
  800236:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800239:	89 54 24 04          	mov    %edx,0x4(%esp)
  80023d:	e8 2e 24 00 00       	call   802670 <__udivdi3>
  800242:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800245:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800248:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80024c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	89 54 24 04          	mov    %edx,0x4(%esp)
  800257:	89 f2                	mov    %esi,%edx
  800259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80025c:	e8 5f ff ff ff       	call   8001c0 <printnum>
  800261:	eb 11                	jmp    800274 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800263:	89 74 24 04          	mov    %esi,0x4(%esp)
  800267:	89 3c 24             	mov    %edi,(%esp)
  80026a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80026d:	83 eb 01             	sub    $0x1,%ebx
  800270:	85 db                	test   %ebx,%ebx
  800272:	7f ef                	jg     800263 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800274:	89 74 24 04          	mov    %esi,0x4(%esp)
  800278:	8b 74 24 04          	mov    0x4(%esp),%esi
  80027c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80027f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800283:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80028a:	00 
  80028b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80028e:	89 14 24             	mov    %edx,(%esp)
  800291:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800294:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800298:	e8 03 25 00 00       	call   8027a0 <__umoddi3>
  80029d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002a1:	0f be 80 13 29 80 00 	movsbl 0x802913(%eax),%eax
  8002a8:	89 04 24             	mov    %eax,(%esp)
  8002ab:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002ae:	83 c4 4c             	add    $0x4c,%esp
  8002b1:	5b                   	pop    %ebx
  8002b2:	5e                   	pop    %esi
  8002b3:	5f                   	pop    %edi
  8002b4:	5d                   	pop    %ebp
  8002b5:	c3                   	ret    

008002b6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002b9:	83 fa 01             	cmp    $0x1,%edx
  8002bc:	7e 0e                	jle    8002cc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002be:	8b 10                	mov    (%eax),%edx
  8002c0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002c3:	89 08                	mov    %ecx,(%eax)
  8002c5:	8b 02                	mov    (%edx),%eax
  8002c7:	8b 52 04             	mov    0x4(%edx),%edx
  8002ca:	eb 22                	jmp    8002ee <getuint+0x38>
	else if (lflag)
  8002cc:	85 d2                	test   %edx,%edx
  8002ce:	74 10                	je     8002e0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002d0:	8b 10                	mov    (%eax),%edx
  8002d2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d5:	89 08                	mov    %ecx,(%eax)
  8002d7:	8b 02                	mov    (%edx),%eax
  8002d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002de:	eb 0e                	jmp    8002ee <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002e0:	8b 10                	mov    (%eax),%edx
  8002e2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 02                	mov    (%edx),%eax
  8002e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    

008002f0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fa:	8b 10                	mov    (%eax),%edx
  8002fc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ff:	73 0a                	jae    80030b <sprintputch+0x1b>
		*b->buf++ = ch;
  800301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800304:	88 0a                	mov    %cl,(%edx)
  800306:	83 c2 01             	add    $0x1,%edx
  800309:	89 10                	mov    %edx,(%eax)
}
  80030b:	5d                   	pop    %ebp
  80030c:	c3                   	ret    

0080030d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	57                   	push   %edi
  800311:	56                   	push   %esi
  800312:	53                   	push   %ebx
  800313:	83 ec 5c             	sub    $0x5c,%esp
  800316:	8b 7d 08             	mov    0x8(%ebp),%edi
  800319:	8b 75 0c             	mov    0xc(%ebp),%esi
  80031c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80031f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800326:	eb 11                	jmp    800339 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800328:	85 c0                	test   %eax,%eax
  80032a:	0f 84 ec 03 00 00    	je     80071c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800330:	89 74 24 04          	mov    %esi,0x4(%esp)
  800334:	89 04 24             	mov    %eax,(%esp)
  800337:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800339:	0f b6 03             	movzbl (%ebx),%eax
  80033c:	83 c3 01             	add    $0x1,%ebx
  80033f:	83 f8 25             	cmp    $0x25,%eax
  800342:	75 e4                	jne    800328 <vprintfmt+0x1b>
  800344:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800348:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80034f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800356:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80035d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800362:	eb 06                	jmp    80036a <vprintfmt+0x5d>
  800364:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800368:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	0f b6 13             	movzbl (%ebx),%edx
  80036d:	0f b6 c2             	movzbl %dl,%eax
  800370:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800373:	8d 43 01             	lea    0x1(%ebx),%eax
  800376:	83 ea 23             	sub    $0x23,%edx
  800379:	80 fa 55             	cmp    $0x55,%dl
  80037c:	0f 87 7d 03 00 00    	ja     8006ff <vprintfmt+0x3f2>
  800382:	0f b6 d2             	movzbl %dl,%edx
  800385:	ff 24 95 60 2a 80 00 	jmp    *0x802a60(,%edx,4)
  80038c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800390:	eb d6                	jmp    800368 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800392:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800395:	83 ea 30             	sub    $0x30,%edx
  800398:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80039b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80039e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8003a1:	83 fb 09             	cmp    $0x9,%ebx
  8003a4:	77 4c                	ja     8003f2 <vprintfmt+0xe5>
  8003a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003a9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003ac:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8003af:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003b2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8003b6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8003b9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8003bc:	83 fb 09             	cmp    $0x9,%ebx
  8003bf:	76 eb                	jbe    8003ac <vprintfmt+0x9f>
  8003c1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003c4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003c7:	eb 29                	jmp    8003f2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003c9:	8b 55 14             	mov    0x14(%ebp),%edx
  8003cc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8003cf:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8003d2:	8b 12                	mov    (%edx),%edx
  8003d4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8003d7:	eb 19                	jmp    8003f2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8003d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003dc:	c1 fa 1f             	sar    $0x1f,%edx
  8003df:	f7 d2                	not    %edx
  8003e1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8003e4:	eb 82                	jmp    800368 <vprintfmt+0x5b>
  8003e6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003ed:	e9 76 ff ff ff       	jmp    800368 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8003f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003f6:	0f 89 6c ff ff ff    	jns    800368 <vprintfmt+0x5b>
  8003fc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8003ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800402:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800405:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800408:	e9 5b ff ff ff       	jmp    800368 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80040d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800410:	e9 53 ff ff ff       	jmp    800368 <vprintfmt+0x5b>
  800415:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	8d 50 04             	lea    0x4(%eax),%edx
  80041e:	89 55 14             	mov    %edx,0x14(%ebp)
  800421:	89 74 24 04          	mov    %esi,0x4(%esp)
  800425:	8b 00                	mov    (%eax),%eax
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	ff d7                	call   *%edi
  80042c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80042f:	e9 05 ff ff ff       	jmp    800339 <vprintfmt+0x2c>
  800434:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8d 50 04             	lea    0x4(%eax),%edx
  80043d:	89 55 14             	mov    %edx,0x14(%ebp)
  800440:	8b 00                	mov    (%eax),%eax
  800442:	89 c2                	mov    %eax,%edx
  800444:	c1 fa 1f             	sar    $0x1f,%edx
  800447:	31 d0                	xor    %edx,%eax
  800449:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80044b:	83 f8 0f             	cmp    $0xf,%eax
  80044e:	7f 0b                	jg     80045b <vprintfmt+0x14e>
  800450:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  800457:	85 d2                	test   %edx,%edx
  800459:	75 20                	jne    80047b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80045b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045f:	c7 44 24 08 24 29 80 	movl   $0x802924,0x8(%esp)
  800466:	00 
  800467:	89 74 24 04          	mov    %esi,0x4(%esp)
  80046b:	89 3c 24             	mov    %edi,(%esp)
  80046e:	e8 31 03 00 00       	call   8007a4 <printfmt>
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800476:	e9 be fe ff ff       	jmp    800339 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80047b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80047f:	c7 44 24 08 5e 2d 80 	movl   $0x802d5e,0x8(%esp)
  800486:	00 
  800487:	89 74 24 04          	mov    %esi,0x4(%esp)
  80048b:	89 3c 24             	mov    %edi,(%esp)
  80048e:	e8 11 03 00 00       	call   8007a4 <printfmt>
  800493:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800496:	e9 9e fe ff ff       	jmp    800339 <vprintfmt+0x2c>
  80049b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80049e:	89 c3                	mov    %eax,%ebx
  8004a0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ac:	8d 50 04             	lea    0x4(%eax),%edx
  8004af:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b7:	85 c0                	test   %eax,%eax
  8004b9:	75 07                	jne    8004c2 <vprintfmt+0x1b5>
  8004bb:	c7 45 e0 2d 29 80 00 	movl   $0x80292d,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8004c2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8004c6:	7e 06                	jle    8004ce <vprintfmt+0x1c1>
  8004c8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004cc:	75 13                	jne    8004e1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d1:	0f be 02             	movsbl (%edx),%eax
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	0f 85 99 00 00 00    	jne    800575 <vprintfmt+0x268>
  8004dc:	e9 86 00 00 00       	jmp    800567 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e8:	89 0c 24             	mov    %ecx,(%esp)
  8004eb:	e8 fb 02 00 00       	call   8007eb <strnlen>
  8004f0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f3:	29 c2                	sub    %eax,%edx
  8004f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f8:	85 d2                	test   %edx,%edx
  8004fa:	7e d2                	jle    8004ce <vprintfmt+0x1c1>
					putch(padc, putdat);
  8004fc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800500:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800503:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800506:	89 d3                	mov    %edx,%ebx
  800508:	89 74 24 04          	mov    %esi,0x4(%esp)
  80050c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050f:	89 04 24             	mov    %eax,(%esp)
  800512:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800514:	83 eb 01             	sub    $0x1,%ebx
  800517:	85 db                	test   %ebx,%ebx
  800519:	7f ed                	jg     800508 <vprintfmt+0x1fb>
  80051b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80051e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800525:	eb a7                	jmp    8004ce <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800527:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052b:	74 18                	je     800545 <vprintfmt+0x238>
  80052d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800530:	83 fa 5e             	cmp    $0x5e,%edx
  800533:	76 10                	jbe    800545 <vprintfmt+0x238>
					putch('?', putdat);
  800535:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800539:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800540:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800543:	eb 0a                	jmp    80054f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800545:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800549:	89 04 24             	mov    %eax,(%esp)
  80054c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80054f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800553:	0f be 03             	movsbl (%ebx),%eax
  800556:	85 c0                	test   %eax,%eax
  800558:	74 05                	je     80055f <vprintfmt+0x252>
  80055a:	83 c3 01             	add    $0x1,%ebx
  80055d:	eb 29                	jmp    800588 <vprintfmt+0x27b>
  80055f:	89 fe                	mov    %edi,%esi
  800561:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800564:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80056b:	7f 2e                	jg     80059b <vprintfmt+0x28e>
  80056d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800570:	e9 c4 fd ff ff       	jmp    800339 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800575:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800578:	83 c2 01             	add    $0x1,%edx
  80057b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80057e:	89 f7                	mov    %esi,%edi
  800580:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800583:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800586:	89 d3                	mov    %edx,%ebx
  800588:	85 f6                	test   %esi,%esi
  80058a:	78 9b                	js     800527 <vprintfmt+0x21a>
  80058c:	83 ee 01             	sub    $0x1,%esi
  80058f:	79 96                	jns    800527 <vprintfmt+0x21a>
  800591:	89 fe                	mov    %edi,%esi
  800593:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800596:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800599:	eb cc                	jmp    800567 <vprintfmt+0x25a>
  80059b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80059e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005a5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005ac:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005ae:	83 eb 01             	sub    $0x1,%ebx
  8005b1:	85 db                	test   %ebx,%ebx
  8005b3:	7f ec                	jg     8005a1 <vprintfmt+0x294>
  8005b5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005b8:	e9 7c fd ff ff       	jmp    800339 <vprintfmt+0x2c>
  8005bd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005c0:	83 f9 01             	cmp    $0x1,%ecx
  8005c3:	7e 16                	jle    8005db <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8d 50 08             	lea    0x8(%eax),%edx
  8005cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ce:	8b 10                	mov    (%eax),%edx
  8005d0:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8005d6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d9:	eb 32                	jmp    80060d <vprintfmt+0x300>
	else if (lflag)
  8005db:	85 c9                	test   %ecx,%ecx
  8005dd:	74 18                	je     8005f7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 50 04             	lea    0x4(%eax),%edx
  8005e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ed:	89 c1                	mov    %eax,%ecx
  8005ef:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005f5:	eb 16                	jmp    80060d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 50 04             	lea    0x4(%eax),%edx
  8005fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800605:	89 c2                	mov    %eax,%edx
  800607:	c1 fa 1f             	sar    $0x1f,%edx
  80060a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800610:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800618:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80061c:	0f 89 9b 00 00 00    	jns    8006bd <vprintfmt+0x3b0>
				putch('-', putdat);
  800622:	89 74 24 04          	mov    %esi,0x4(%esp)
  800626:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80062d:	ff d7                	call   *%edi
				num = -(long long) num;
  80062f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800632:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800635:	f7 d9                	neg    %ecx
  800637:	83 d3 00             	adc    $0x0,%ebx
  80063a:	f7 db                	neg    %ebx
  80063c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800641:	eb 7a                	jmp    8006bd <vprintfmt+0x3b0>
  800643:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800646:	89 ca                	mov    %ecx,%edx
  800648:	8d 45 14             	lea    0x14(%ebp),%eax
  80064b:	e8 66 fc ff ff       	call   8002b6 <getuint>
  800650:	89 c1                	mov    %eax,%ecx
  800652:	89 d3                	mov    %edx,%ebx
  800654:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800659:	eb 62                	jmp    8006bd <vprintfmt+0x3b0>
  80065b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80065e:	89 ca                	mov    %ecx,%edx
  800660:	8d 45 14             	lea    0x14(%ebp),%eax
  800663:	e8 4e fc ff ff       	call   8002b6 <getuint>
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	89 d3                	mov    %edx,%ebx
  80066c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800671:	eb 4a                	jmp    8006bd <vprintfmt+0x3b0>
  800673:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800676:	89 74 24 04          	mov    %esi,0x4(%esp)
  80067a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800681:	ff d7                	call   *%edi
			putch('x', putdat);
  800683:	89 74 24 04          	mov    %esi,0x4(%esp)
  800687:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80068e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8d 50 04             	lea    0x4(%eax),%edx
  800696:	89 55 14             	mov    %edx,0x14(%ebp)
  800699:	8b 08                	mov    (%eax),%ecx
  80069b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006a0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006a5:	eb 16                	jmp    8006bd <vprintfmt+0x3b0>
  8006a7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006aa:	89 ca                	mov    %ecx,%edx
  8006ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8006af:	e8 02 fc ff ff       	call   8002b6 <getuint>
  8006b4:	89 c1                	mov    %eax,%ecx
  8006b6:	89 d3                	mov    %edx,%ebx
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006bd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8006c1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006c8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006d0:	89 0c 24             	mov    %ecx,(%esp)
  8006d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006d7:	89 f2                	mov    %esi,%edx
  8006d9:	89 f8                	mov    %edi,%eax
  8006db:	e8 e0 fa ff ff       	call   8001c0 <printnum>
  8006e0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006e3:	e9 51 fc ff ff       	jmp    800339 <vprintfmt+0x2c>
  8006e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8006eb:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f2:	89 14 24             	mov    %edx,(%esp)
  8006f5:	ff d7                	call   *%edi
  8006f7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006fa:	e9 3a fc ff ff       	jmp    800339 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  800703:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80070a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80070c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80070f:	80 38 25             	cmpb   $0x25,(%eax)
  800712:	0f 84 21 fc ff ff    	je     800339 <vprintfmt+0x2c>
  800718:	89 c3                	mov    %eax,%ebx
  80071a:	eb f0                	jmp    80070c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80071c:	83 c4 5c             	add    $0x5c,%esp
  80071f:	5b                   	pop    %ebx
  800720:	5e                   	pop    %esi
  800721:	5f                   	pop    %edi
  800722:	5d                   	pop    %ebp
  800723:	c3                   	ret    

00800724 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	83 ec 28             	sub    $0x28,%esp
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800730:	85 c0                	test   %eax,%eax
  800732:	74 04                	je     800738 <vsnprintf+0x14>
  800734:	85 d2                	test   %edx,%edx
  800736:	7f 07                	jg     80073f <vsnprintf+0x1b>
  800738:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80073d:	eb 3b                	jmp    80077a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80073f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800742:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800746:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800757:	8b 45 10             	mov    0x10(%ebp),%eax
  80075a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80075e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800761:	89 44 24 04          	mov    %eax,0x4(%esp)
  800765:	c7 04 24 f0 02 80 00 	movl   $0x8002f0,(%esp)
  80076c:	e8 9c fb ff ff       	call   80030d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800774:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800777:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077a:	c9                   	leave  
  80077b:	c3                   	ret    

0080077c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800782:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800785:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800789:	8b 45 10             	mov    0x10(%ebp),%eax
  80078c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800790:	8b 45 0c             	mov    0xc(%ebp),%eax
  800793:	89 44 24 04          	mov    %eax,0x4(%esp)
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 04 24             	mov    %eax,(%esp)
  80079d:	e8 82 ff ff ff       	call   800724 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8007aa:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8007ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	89 04 24             	mov    %eax,(%esp)
  8007c5:	e8 43 fb ff ff       	call   80030d <vprintfmt>
	va_end(ap);
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    
  8007cc:	00 00                	add    %al,(%eax)
	...

008007d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007db:	80 3a 00             	cmpb   $0x0,(%edx)
  8007de:	74 09                	je     8007e9 <strlen+0x19>
		n++;
  8007e0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e7:	75 f7                	jne    8007e0 <strlen+0x10>
		n++;
	return n;
}
  8007e9:	5d                   	pop    %ebp
  8007ea:	c3                   	ret    

008007eb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	53                   	push   %ebx
  8007ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f5:	85 c9                	test   %ecx,%ecx
  8007f7:	74 19                	je     800812 <strnlen+0x27>
  8007f9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007fc:	74 14                	je     800812 <strnlen+0x27>
  8007fe:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800803:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800806:	39 c8                	cmp    %ecx,%eax
  800808:	74 0d                	je     800817 <strnlen+0x2c>
  80080a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80080e:	75 f3                	jne    800803 <strnlen+0x18>
  800810:	eb 05                	jmp    800817 <strnlen+0x2c>
  800812:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800817:	5b                   	pop    %ebx
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800829:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80082d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800830:	83 c2 01             	add    $0x1,%edx
  800833:	84 c9                	test   %cl,%cl
  800835:	75 f2                	jne    800829 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800837:	5b                   	pop    %ebx
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	56                   	push   %esi
  80083e:	53                   	push   %ebx
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
  800845:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800848:	85 f6                	test   %esi,%esi
  80084a:	74 18                	je     800864 <strncpy+0x2a>
  80084c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800851:	0f b6 1a             	movzbl (%edx),%ebx
  800854:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800857:	80 3a 01             	cmpb   $0x1,(%edx)
  80085a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80085d:	83 c1 01             	add    $0x1,%ecx
  800860:	39 ce                	cmp    %ecx,%esi
  800862:	77 ed                	ja     800851 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800864:	5b                   	pop    %ebx
  800865:	5e                   	pop    %esi
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	56                   	push   %esi
  80086c:	53                   	push   %ebx
  80086d:	8b 75 08             	mov    0x8(%ebp),%esi
  800870:	8b 55 0c             	mov    0xc(%ebp),%edx
  800873:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800876:	89 f0                	mov    %esi,%eax
  800878:	85 c9                	test   %ecx,%ecx
  80087a:	74 27                	je     8008a3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80087c:	83 e9 01             	sub    $0x1,%ecx
  80087f:	74 1d                	je     80089e <strlcpy+0x36>
  800881:	0f b6 1a             	movzbl (%edx),%ebx
  800884:	84 db                	test   %bl,%bl
  800886:	74 16                	je     80089e <strlcpy+0x36>
			*dst++ = *src++;
  800888:	88 18                	mov    %bl,(%eax)
  80088a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80088d:	83 e9 01             	sub    $0x1,%ecx
  800890:	74 0e                	je     8008a0 <strlcpy+0x38>
			*dst++ = *src++;
  800892:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800895:	0f b6 1a             	movzbl (%edx),%ebx
  800898:	84 db                	test   %bl,%bl
  80089a:	75 ec                	jne    800888 <strlcpy+0x20>
  80089c:	eb 02                	jmp    8008a0 <strlcpy+0x38>
  80089e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008a0:	c6 00 00             	movb   $0x0,(%eax)
  8008a3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008b2:	0f b6 01             	movzbl (%ecx),%eax
  8008b5:	84 c0                	test   %al,%al
  8008b7:	74 15                	je     8008ce <strcmp+0x25>
  8008b9:	3a 02                	cmp    (%edx),%al
  8008bb:	75 11                	jne    8008ce <strcmp+0x25>
		p++, q++;
  8008bd:	83 c1 01             	add    $0x1,%ecx
  8008c0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008c3:	0f b6 01             	movzbl (%ecx),%eax
  8008c6:	84 c0                	test   %al,%al
  8008c8:	74 04                	je     8008ce <strcmp+0x25>
  8008ca:	3a 02                	cmp    (%edx),%al
  8008cc:	74 ef                	je     8008bd <strcmp+0x14>
  8008ce:	0f b6 c0             	movzbl %al,%eax
  8008d1:	0f b6 12             	movzbl (%edx),%edx
  8008d4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	53                   	push   %ebx
  8008dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  8008e5:	85 c0                	test   %eax,%eax
  8008e7:	74 23                	je     80090c <strncmp+0x34>
  8008e9:	0f b6 1a             	movzbl (%edx),%ebx
  8008ec:	84 db                	test   %bl,%bl
  8008ee:	74 24                	je     800914 <strncmp+0x3c>
  8008f0:	3a 19                	cmp    (%ecx),%bl
  8008f2:	75 20                	jne    800914 <strncmp+0x3c>
  8008f4:	83 e8 01             	sub    $0x1,%eax
  8008f7:	74 13                	je     80090c <strncmp+0x34>
		n--, p++, q++;
  8008f9:	83 c2 01             	add    $0x1,%edx
  8008fc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008ff:	0f b6 1a             	movzbl (%edx),%ebx
  800902:	84 db                	test   %bl,%bl
  800904:	74 0e                	je     800914 <strncmp+0x3c>
  800906:	3a 19                	cmp    (%ecx),%bl
  800908:	74 ea                	je     8008f4 <strncmp+0x1c>
  80090a:	eb 08                	jmp    800914 <strncmp+0x3c>
  80090c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800911:	5b                   	pop    %ebx
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800914:	0f b6 02             	movzbl (%edx),%eax
  800917:	0f b6 11             	movzbl (%ecx),%edx
  80091a:	29 d0                	sub    %edx,%eax
  80091c:	eb f3                	jmp    800911 <strncmp+0x39>

0080091e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800928:	0f b6 10             	movzbl (%eax),%edx
  80092b:	84 d2                	test   %dl,%dl
  80092d:	74 15                	je     800944 <strchr+0x26>
		if (*s == c)
  80092f:	38 ca                	cmp    %cl,%dl
  800931:	75 07                	jne    80093a <strchr+0x1c>
  800933:	eb 14                	jmp    800949 <strchr+0x2b>
  800935:	38 ca                	cmp    %cl,%dl
  800937:	90                   	nop
  800938:	74 0f                	je     800949 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80093a:	83 c0 01             	add    $0x1,%eax
  80093d:	0f b6 10             	movzbl (%eax),%edx
  800940:	84 d2                	test   %dl,%dl
  800942:	75 f1                	jne    800935 <strchr+0x17>
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800955:	0f b6 10             	movzbl (%eax),%edx
  800958:	84 d2                	test   %dl,%dl
  80095a:	74 18                	je     800974 <strfind+0x29>
		if (*s == c)
  80095c:	38 ca                	cmp    %cl,%dl
  80095e:	75 0a                	jne    80096a <strfind+0x1f>
  800960:	eb 12                	jmp    800974 <strfind+0x29>
  800962:	38 ca                	cmp    %cl,%dl
  800964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800968:	74 0a                	je     800974 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80096a:	83 c0 01             	add    $0x1,%eax
  80096d:	0f b6 10             	movzbl (%eax),%edx
  800970:	84 d2                	test   %dl,%dl
  800972:	75 ee                	jne    800962 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 0c             	sub    $0xc,%esp
  80097c:	89 1c 24             	mov    %ebx,(%esp)
  80097f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800983:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800987:	8b 7d 08             	mov    0x8(%ebp),%edi
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800990:	85 c9                	test   %ecx,%ecx
  800992:	74 30                	je     8009c4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800994:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099a:	75 25                	jne    8009c1 <memset+0x4b>
  80099c:	f6 c1 03             	test   $0x3,%cl
  80099f:	75 20                	jne    8009c1 <memset+0x4b>
		c &= 0xFF;
  8009a1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a4:	89 d3                	mov    %edx,%ebx
  8009a6:	c1 e3 08             	shl    $0x8,%ebx
  8009a9:	89 d6                	mov    %edx,%esi
  8009ab:	c1 e6 18             	shl    $0x18,%esi
  8009ae:	89 d0                	mov    %edx,%eax
  8009b0:	c1 e0 10             	shl    $0x10,%eax
  8009b3:	09 f0                	or     %esi,%eax
  8009b5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8009b7:	09 d8                	or     %ebx,%eax
  8009b9:	c1 e9 02             	shr    $0x2,%ecx
  8009bc:	fc                   	cld    
  8009bd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009bf:	eb 03                	jmp    8009c4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009c1:	fc                   	cld    
  8009c2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009c4:	89 f8                	mov    %edi,%eax
  8009c6:	8b 1c 24             	mov    (%esp),%ebx
  8009c9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009cd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009d1:	89 ec                	mov    %ebp,%esp
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	89 34 24             	mov    %esi,(%esp)
  8009de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8009e8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009eb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009ed:	39 c6                	cmp    %eax,%esi
  8009ef:	73 35                	jae    800a26 <memmove+0x51>
  8009f1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f4:	39 d0                	cmp    %edx,%eax
  8009f6:	73 2e                	jae    800a26 <memmove+0x51>
		s += n;
		d += n;
  8009f8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fa:	f6 c2 03             	test   $0x3,%dl
  8009fd:	75 1b                	jne    800a1a <memmove+0x45>
  8009ff:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a05:	75 13                	jne    800a1a <memmove+0x45>
  800a07:	f6 c1 03             	test   $0x3,%cl
  800a0a:	75 0e                	jne    800a1a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a0c:	83 ef 04             	sub    $0x4,%edi
  800a0f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a12:	c1 e9 02             	shr    $0x2,%ecx
  800a15:	fd                   	std    
  800a16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a18:	eb 09                	jmp    800a23 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a1a:	83 ef 01             	sub    $0x1,%edi
  800a1d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a20:	fd                   	std    
  800a21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a23:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a24:	eb 20                	jmp    800a46 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2c:	75 15                	jne    800a43 <memmove+0x6e>
  800a2e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a34:	75 0d                	jne    800a43 <memmove+0x6e>
  800a36:	f6 c1 03             	test   $0x3,%cl
  800a39:	75 08                	jne    800a43 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a3b:	c1 e9 02             	shr    $0x2,%ecx
  800a3e:	fc                   	cld    
  800a3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a41:	eb 03                	jmp    800a46 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a43:	fc                   	cld    
  800a44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a46:	8b 34 24             	mov    (%esp),%esi
  800a49:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a4d:	89 ec                	mov    %ebp,%esp
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a57:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	89 04 24             	mov    %eax,(%esp)
  800a6b:	e8 65 ff ff ff       	call   8009d5 <memmove>
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	57                   	push   %edi
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 75 08             	mov    0x8(%ebp),%esi
  800a7b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a81:	85 c9                	test   %ecx,%ecx
  800a83:	74 36                	je     800abb <memcmp+0x49>
		if (*s1 != *s2)
  800a85:	0f b6 06             	movzbl (%esi),%eax
  800a88:	0f b6 1f             	movzbl (%edi),%ebx
  800a8b:	38 d8                	cmp    %bl,%al
  800a8d:	74 20                	je     800aaf <memcmp+0x3d>
  800a8f:	eb 14                	jmp    800aa5 <memcmp+0x33>
  800a91:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800a96:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	83 e9 01             	sub    $0x1,%ecx
  800aa1:	38 d8                	cmp    %bl,%al
  800aa3:	74 12                	je     800ab7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800aa5:	0f b6 c0             	movzbl %al,%eax
  800aa8:	0f b6 db             	movzbl %bl,%ebx
  800aab:	29 d8                	sub    %ebx,%eax
  800aad:	eb 11                	jmp    800ac0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aaf:	83 e9 01             	sub    $0x1,%ecx
  800ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab7:	85 c9                	test   %ecx,%ecx
  800ab9:	75 d6                	jne    800a91 <memcmp+0x1f>
  800abb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800ac0:	5b                   	pop    %ebx
  800ac1:	5e                   	pop    %esi
  800ac2:	5f                   	pop    %edi
  800ac3:	5d                   	pop    %ebp
  800ac4:	c3                   	ret    

00800ac5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac5:	55                   	push   %ebp
  800ac6:	89 e5                	mov    %esp,%ebp
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800acb:	89 c2                	mov    %eax,%edx
  800acd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad0:	39 d0                	cmp    %edx,%eax
  800ad2:	73 15                	jae    800ae9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ad8:	38 08                	cmp    %cl,(%eax)
  800ada:	75 06                	jne    800ae2 <memfind+0x1d>
  800adc:	eb 0b                	jmp    800ae9 <memfind+0x24>
  800ade:	38 08                	cmp    %cl,(%eax)
  800ae0:	74 07                	je     800ae9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ae2:	83 c0 01             	add    $0x1,%eax
  800ae5:	39 c2                	cmp    %eax,%edx
  800ae7:	77 f5                	ja     800ade <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	57                   	push   %edi
  800aef:	56                   	push   %esi
  800af0:	53                   	push   %ebx
  800af1:	83 ec 04             	sub    $0x4,%esp
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afa:	0f b6 02             	movzbl (%edx),%eax
  800afd:	3c 20                	cmp    $0x20,%al
  800aff:	74 04                	je     800b05 <strtol+0x1a>
  800b01:	3c 09                	cmp    $0x9,%al
  800b03:	75 0e                	jne    800b13 <strtol+0x28>
		s++;
  800b05:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b08:	0f b6 02             	movzbl (%edx),%eax
  800b0b:	3c 20                	cmp    $0x20,%al
  800b0d:	74 f6                	je     800b05 <strtol+0x1a>
  800b0f:	3c 09                	cmp    $0x9,%al
  800b11:	74 f2                	je     800b05 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b13:	3c 2b                	cmp    $0x2b,%al
  800b15:	75 0c                	jne    800b23 <strtol+0x38>
		s++;
  800b17:	83 c2 01             	add    $0x1,%edx
  800b1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b21:	eb 15                	jmp    800b38 <strtol+0x4d>
	else if (*s == '-')
  800b23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b2a:	3c 2d                	cmp    $0x2d,%al
  800b2c:	75 0a                	jne    800b38 <strtol+0x4d>
		s++, neg = 1;
  800b2e:	83 c2 01             	add    $0x1,%edx
  800b31:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b38:	85 db                	test   %ebx,%ebx
  800b3a:	0f 94 c0             	sete   %al
  800b3d:	74 05                	je     800b44 <strtol+0x59>
  800b3f:	83 fb 10             	cmp    $0x10,%ebx
  800b42:	75 18                	jne    800b5c <strtol+0x71>
  800b44:	80 3a 30             	cmpb   $0x30,(%edx)
  800b47:	75 13                	jne    800b5c <strtol+0x71>
  800b49:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b4d:	8d 76 00             	lea    0x0(%esi),%esi
  800b50:	75 0a                	jne    800b5c <strtol+0x71>
		s += 2, base = 16;
  800b52:	83 c2 02             	add    $0x2,%edx
  800b55:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b5a:	eb 15                	jmp    800b71 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b5c:	84 c0                	test   %al,%al
  800b5e:	66 90                	xchg   %ax,%ax
  800b60:	74 0f                	je     800b71 <strtol+0x86>
  800b62:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b67:	80 3a 30             	cmpb   $0x30,(%edx)
  800b6a:	75 05                	jne    800b71 <strtol+0x86>
		s++, base = 8;
  800b6c:	83 c2 01             	add    $0x1,%edx
  800b6f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
  800b76:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b78:	0f b6 0a             	movzbl (%edx),%ecx
  800b7b:	89 cf                	mov    %ecx,%edi
  800b7d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b80:	80 fb 09             	cmp    $0x9,%bl
  800b83:	77 08                	ja     800b8d <strtol+0xa2>
			dig = *s - '0';
  800b85:	0f be c9             	movsbl %cl,%ecx
  800b88:	83 e9 30             	sub    $0x30,%ecx
  800b8b:	eb 1e                	jmp    800bab <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800b8d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b90:	80 fb 19             	cmp    $0x19,%bl
  800b93:	77 08                	ja     800b9d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800b95:	0f be c9             	movsbl %cl,%ecx
  800b98:	83 e9 57             	sub    $0x57,%ecx
  800b9b:	eb 0e                	jmp    800bab <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800b9d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ba0:	80 fb 19             	cmp    $0x19,%bl
  800ba3:	77 15                	ja     800bba <strtol+0xcf>
			dig = *s - 'A' + 10;
  800ba5:	0f be c9             	movsbl %cl,%ecx
  800ba8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bab:	39 f1                	cmp    %esi,%ecx
  800bad:	7d 0b                	jge    800bba <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800baf:	83 c2 01             	add    $0x1,%edx
  800bb2:	0f af c6             	imul   %esi,%eax
  800bb5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800bb8:	eb be                	jmp    800b78 <strtol+0x8d>
  800bba:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc0:	74 05                	je     800bc7 <strtol+0xdc>
		*endptr = (char *) s;
  800bc2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bc5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800bc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bcb:	74 04                	je     800bd1 <strtol+0xe6>
  800bcd:	89 c8                	mov    %ecx,%eax
  800bcf:	f7 d8                	neg    %eax
}
  800bd1:	83 c4 04             	add    $0x4,%esp
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    
  800bd9:	00 00                	add    %al,(%eax)
	...

00800bdc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	83 ec 0c             	sub    $0xc,%esp
  800be2:	89 1c 24             	mov    %ebx,(%esp)
  800be5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800be9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bed:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf7:	89 d1                	mov    %edx,%ecx
  800bf9:	89 d3                	mov    %edx,%ebx
  800bfb:	89 d7                	mov    %edx,%edi
  800bfd:	89 d6                	mov    %edx,%esi
  800bff:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c01:	8b 1c 24             	mov    (%esp),%ebx
  800c04:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c08:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c0c:	89 ec                	mov    %ebp,%esp
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	89 1c 24             	mov    %ebx,(%esp)
  800c19:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c1d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
  800c26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	89 c3                	mov    %eax,%ebx
  800c2e:	89 c7                	mov    %eax,%edi
  800c30:	89 c6                	mov    %eax,%esi
  800c32:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c34:	8b 1c 24             	mov    (%esp),%ebx
  800c37:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c3b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c3f:	89 ec                	mov    %ebp,%esp
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 38             	sub    $0x38,%esp
  800c49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c52:	be 00 00 00 00       	mov    $0x0,%esi
  800c57:	b8 12 00 00 00       	mov    $0x12,%eax
  800c5c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c65:	8b 55 08             	mov    0x8(%ebp),%edx
  800c68:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7e 28                	jle    800c96 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c72:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800c79:	00 
  800c7a:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  800c81:	00 
  800c82:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c89:	00 
  800c8a:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800c91:	e8 56 18 00 00       	call   8024ec <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800c96:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c99:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c9c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c9f:	89 ec                	mov    %ebp,%esp
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	89 1c 24             	mov    %ebx,(%esp)
  800cac:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cb0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb9:	b8 11 00 00 00       	mov    $0x11,%eax
  800cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	89 df                	mov    %ebx,%edi
  800cc6:	89 de                	mov    %ebx,%esi
  800cc8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800cca:	8b 1c 24             	mov    (%esp),%ebx
  800ccd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cd1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cd5:	89 ec                	mov    %ebp,%esp
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    

00800cd9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 0c             	sub    $0xc,%esp
  800cdf:	89 1c 24             	mov    %ebx,(%esp)
  800ce2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ce6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cea:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cef:	b8 10 00 00 00       	mov    $0x10,%eax
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	89 cb                	mov    %ecx,%ebx
  800cf9:	89 cf                	mov    %ecx,%edi
  800cfb:	89 ce                	mov    %ecx,%esi
  800cfd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800cff:	8b 1c 24             	mov    (%esp),%ebx
  800d02:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d06:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d0a:	89 ec                	mov    %ebp,%esp
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 38             	sub    $0x38,%esp
  800d14:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d17:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d1a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d22:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2d:	89 df                	mov    %ebx,%edi
  800d2f:	89 de                	mov    %ebx,%esi
  800d31:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7e 28                	jle    800d5f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d3b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d42:	00 
  800d43:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  800d4a:	00 
  800d4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d52:	00 
  800d53:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800d5a:	e8 8d 17 00 00       	call   8024ec <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800d5f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d62:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d65:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d68:	89 ec                	mov    %ebp,%esp
  800d6a:	5d                   	pop    %ebp
  800d6b:	c3                   	ret    

00800d6c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	89 1c 24             	mov    %ebx,(%esp)
  800d75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d79:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d82:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d87:	89 d1                	mov    %edx,%ecx
  800d89:	89 d3                	mov    %edx,%ebx
  800d8b:	89 d7                	mov    %edx,%edi
  800d8d:	89 d6                	mov    %edx,%esi
  800d8f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800d91:	8b 1c 24             	mov    (%esp),%ebx
  800d94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d9c:	89 ec                	mov    %ebp,%esp
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 38             	sub    $0x38,%esp
  800da6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800da9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dac:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800daf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	89 cb                	mov    %ecx,%ebx
  800dbe:	89 cf                	mov    %ecx,%edi
  800dc0:	89 ce                	mov    %ecx,%esi
  800dc2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800dc4:	85 c0                	test   %eax,%eax
  800dc6:	7e 28                	jle    800df0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dcc:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800dd3:	00 
  800dd4:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  800ddb:	00 
  800ddc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de3:	00 
  800de4:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800deb:	e8 fc 16 00 00       	call   8024ec <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800df0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800df3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800df6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800df9:	89 ec                	mov    %ebp,%esp
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 0c             	sub    $0xc,%esp
  800e03:	89 1c 24             	mov    %ebx,(%esp)
  800e06:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e0a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0e:	be 00 00 00 00       	mov    $0x0,%esi
  800e13:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e18:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e26:	8b 1c 24             	mov    (%esp),%ebx
  800e29:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e2d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e31:	89 ec                	mov    %ebp,%esp
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	83 ec 38             	sub    $0x38,%esp
  800e3b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e3e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e41:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e49:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	8b 55 08             	mov    0x8(%ebp),%edx
  800e54:	89 df                	mov    %ebx,%edi
  800e56:	89 de                	mov    %ebx,%esi
  800e58:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7e 28                	jle    800e86 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e62:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e69:	00 
  800e6a:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  800e71:	00 
  800e72:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e79:	00 
  800e7a:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800e81:	e8 66 16 00 00       	call   8024ec <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e89:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e8c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e8f:	89 ec                	mov    %ebp,%esp
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 38             	sub    $0x38,%esp
  800e99:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e9c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e9f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea7:	b8 09 00 00 00       	mov    $0x9,%eax
  800eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	89 df                	mov    %ebx,%edi
  800eb4:	89 de                	mov    %ebx,%esi
  800eb6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	7e 28                	jle    800ee4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ec7:	00 
  800ec8:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  800ecf:	00 
  800ed0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed7:	00 
  800ed8:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800edf:	e8 08 16 00 00       	call   8024ec <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ee4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ee7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eed:	89 ec                	mov    %ebp,%esp
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    

00800ef1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 38             	sub    $0x38,%esp
  800ef7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800efa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800efd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f05:	b8 08 00 00 00       	mov    $0x8,%eax
  800f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f10:	89 df                	mov    %ebx,%edi
  800f12:	89 de                	mov    %ebx,%esi
  800f14:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f16:	85 c0                	test   %eax,%eax
  800f18:	7e 28                	jle    800f42 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f25:	00 
  800f26:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  800f2d:	00 
  800f2e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f35:	00 
  800f36:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800f3d:	e8 aa 15 00 00       	call   8024ec <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f42:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f45:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f48:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f4b:	89 ec                	mov    %ebp,%esp
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	83 ec 38             	sub    $0x38,%esp
  800f55:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f58:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f5b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f63:	b8 06 00 00 00       	mov    $0x6,%eax
  800f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 df                	mov    %ebx,%edi
  800f70:	89 de                	mov    %ebx,%esi
  800f72:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f74:	85 c0                	test   %eax,%eax
  800f76:	7e 28                	jle    800fa0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f78:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f83:	00 
  800f84:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f93:	00 
  800f94:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800f9b:	e8 4c 15 00 00       	call   8024ec <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fa0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fa6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fa9:	89 ec                	mov    %ebp,%esp
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 38             	sub    $0x38,%esp
  800fb3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fb9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	b8 05 00 00 00       	mov    $0x5,%eax
  800fc1:	8b 75 18             	mov    0x18(%ebp),%esi
  800fc4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	7e 28                	jle    800ffe <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fda:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fe1:	00 
  800fe2:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  800fe9:	00 
  800fea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff1:	00 
  800ff2:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  800ff9:	e8 ee 14 00 00       	call   8024ec <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ffe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801001:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801004:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801007:	89 ec                	mov    %ebp,%esp
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 38             	sub    $0x38,%esp
  801011:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801014:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801017:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101a:	be 00 00 00 00       	mov    $0x0,%esi
  80101f:	b8 04 00 00 00       	mov    $0x4,%eax
  801024:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801027:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	89 f7                	mov    %esi,%edi
  80102f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801031:	85 c0                	test   %eax,%eax
  801033:	7e 28                	jle    80105d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801035:	89 44 24 10          	mov    %eax,0x10(%esp)
  801039:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801040:	00 
  801041:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  801048:	00 
  801049:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801050:	00 
  801051:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  801058:	e8 8f 14 00 00       	call   8024ec <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80105d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801060:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801063:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801066:	89 ec                	mov    %ebp,%esp
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 0c             	sub    $0xc,%esp
  801070:	89 1c 24             	mov    %ebx,(%esp)
  801073:	89 74 24 04          	mov    %esi,0x4(%esp)
  801077:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107b:	ba 00 00 00 00       	mov    $0x0,%edx
  801080:	b8 0b 00 00 00       	mov    $0xb,%eax
  801085:	89 d1                	mov    %edx,%ecx
  801087:	89 d3                	mov    %edx,%ebx
  801089:	89 d7                	mov    %edx,%edi
  80108b:	89 d6                	mov    %edx,%esi
  80108d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80108f:	8b 1c 24             	mov    (%esp),%ebx
  801092:	8b 74 24 04          	mov    0x4(%esp),%esi
  801096:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80109a:	89 ec                	mov    %ebp,%esp
  80109c:	5d                   	pop    %ebp
  80109d:	c3                   	ret    

0080109e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 0c             	sub    $0xc,%esp
  8010a4:	89 1c 24             	mov    %ebx,(%esp)
  8010a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010ab:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010af:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b4:	b8 02 00 00 00       	mov    $0x2,%eax
  8010b9:	89 d1                	mov    %edx,%ecx
  8010bb:	89 d3                	mov    %edx,%ebx
  8010bd:	89 d7                	mov    %edx,%edi
  8010bf:	89 d6                	mov    %edx,%esi
  8010c1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010c3:	8b 1c 24             	mov    (%esp),%ebx
  8010c6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010ca:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ce:	89 ec                	mov    %ebp,%esp
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 38             	sub    $0x38,%esp
  8010d8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010db:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010de:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e6:	b8 03 00 00 00       	mov    $0x3,%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 cb                	mov    %ecx,%ebx
  8010f0:	89 cf                	mov    %ecx,%edi
  8010f2:	89 ce                	mov    %ecx,%esi
  8010f4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	7e 28                	jle    801122 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010fe:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801105:	00 
  801106:	c7 44 24 08 1f 2c 80 	movl   $0x802c1f,0x8(%esp)
  80110d:	00 
  80110e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801115:	00 
  801116:	c7 04 24 3c 2c 80 00 	movl   $0x802c3c,(%esp)
  80111d:	e8 ca 13 00 00       	call   8024ec <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801122:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801125:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801128:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80112b:	89 ec                	mov    %ebp,%esp
  80112d:	5d                   	pop    %ebp
  80112e:	c3                   	ret    
	...

00801130 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  801136:	83 3d 78 60 80 00 00 	cmpl   $0x0,0x806078
  80113d:	75 78                	jne    8011b7 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80113f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801146:	00 
  801147:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80114e:	ee 
  80114f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801156:	e8 b0 fe ff ff       	call   80100b <sys_page_alloc>
  80115b:	85 c0                	test   %eax,%eax
  80115d:	79 20                	jns    80117f <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  80115f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801163:	c7 44 24 08 4a 2c 80 	movl   $0x802c4a,0x8(%esp)
  80116a:	00 
  80116b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801172:	00 
  801173:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  80117a:	e8 6d 13 00 00       	call   8024ec <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80117f:	c7 44 24 04 c4 11 80 	movl   $0x8011c4,0x4(%esp)
  801186:	00 
  801187:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80118e:	e8 a2 fc ff ff       	call   800e35 <sys_env_set_pgfault_upcall>
  801193:	85 c0                	test   %eax,%eax
  801195:	79 20                	jns    8011b7 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  801197:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80119b:	c7 44 24 08 78 2c 80 	movl   $0x802c78,0x8(%esp)
  8011a2:	00 
  8011a3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8011aa:	00 
  8011ab:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  8011b2:	e8 35 13 00 00       	call   8024ec <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	a3 78 60 80 00       	mov    %eax,0x806078
	
}
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    
  8011c1:	00 00                	add    %al,(%eax)
	...

008011c4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8011c4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8011c5:	a1 78 60 80 00       	mov    0x806078,%eax
	call *%eax
  8011ca:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8011cc:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  8011cf:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  8011d1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  8011d5:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  8011d9:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  8011db:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  8011dc:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  8011de:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  8011e1:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8011e5:	83 c4 08             	add    $0x8,%esp
	popal
  8011e8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  8011e9:	83 c4 04             	add    $0x4,%esp
	popfl
  8011ec:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8011ed:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  8011ee:	c3                   	ret    
	...

008011f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8011fb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	89 04 24             	mov    %eax,(%esp)
  80120c:	e8 df ff ff ff       	call   8011f0 <fd2num>
  801211:	05 20 00 0d 00       	add    $0xd0020,%eax
  801216:	c1 e0 0c             	shl    $0xc,%eax
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	57                   	push   %edi
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
  801221:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801224:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801229:	a8 01                	test   $0x1,%al
  80122b:	74 36                	je     801263 <fd_alloc+0x48>
  80122d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801232:	a8 01                	test   $0x1,%al
  801234:	74 2d                	je     801263 <fd_alloc+0x48>
  801236:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80123b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801240:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801245:	89 c3                	mov    %eax,%ebx
  801247:	89 c2                	mov    %eax,%edx
  801249:	c1 ea 16             	shr    $0x16,%edx
  80124c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80124f:	f6 c2 01             	test   $0x1,%dl
  801252:	74 14                	je     801268 <fd_alloc+0x4d>
  801254:	89 c2                	mov    %eax,%edx
  801256:	c1 ea 0c             	shr    $0xc,%edx
  801259:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80125c:	f6 c2 01             	test   $0x1,%dl
  80125f:	75 10                	jne    801271 <fd_alloc+0x56>
  801261:	eb 05                	jmp    801268 <fd_alloc+0x4d>
  801263:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801268:	89 1f                	mov    %ebx,(%edi)
  80126a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80126f:	eb 17                	jmp    801288 <fd_alloc+0x6d>
  801271:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801276:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80127b:	75 c8                	jne    801245 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80127d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801283:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5f                   	pop    %edi
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	83 f8 1f             	cmp    $0x1f,%eax
  801296:	77 36                	ja     8012ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801298:	05 00 00 0d 00       	add    $0xd0000,%eax
  80129d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8012a0:	89 c2                	mov    %eax,%edx
  8012a2:	c1 ea 16             	shr    $0x16,%edx
  8012a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012ac:	f6 c2 01             	test   $0x1,%dl
  8012af:	74 1d                	je     8012ce <fd_lookup+0x41>
  8012b1:	89 c2                	mov    %eax,%edx
  8012b3:	c1 ea 0c             	shr    $0xc,%edx
  8012b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012bd:	f6 c2 01             	test   $0x1,%dl
  8012c0:	74 0c                	je     8012ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c5:	89 02                	mov    %eax,(%edx)
  8012c7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8012cc:	eb 05                	jmp    8012d3 <fd_lookup+0x46>
  8012ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	89 04 24             	mov    %eax,(%esp)
  8012e8:	e8 a0 ff ff ff       	call   80128d <fd_lookup>
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	78 0e                	js     8012ff <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8012f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f7:	89 50 04             	mov    %edx,0x4(%eax)
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	56                   	push   %esi
  801305:	53                   	push   %ebx
  801306:	83 ec 10             	sub    $0x10,%esp
  801309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80130f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801314:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801319:	be 20 2d 80 00       	mov    $0x802d20,%esi
		if (devtab[i]->dev_id == dev_id) {
  80131e:	39 08                	cmp    %ecx,(%eax)
  801320:	75 10                	jne    801332 <dev_lookup+0x31>
  801322:	eb 04                	jmp    801328 <dev_lookup+0x27>
  801324:	39 08                	cmp    %ecx,(%eax)
  801326:	75 0a                	jne    801332 <dev_lookup+0x31>
			*dev = devtab[i];
  801328:	89 03                	mov    %eax,(%ebx)
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80132f:	90                   	nop
  801330:	eb 31                	jmp    801363 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801332:	83 c2 01             	add    $0x1,%edx
  801335:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801338:	85 c0                	test   %eax,%eax
  80133a:	75 e8                	jne    801324 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80133c:	a1 74 60 80 00       	mov    0x806074,%eax
  801341:	8b 40 4c             	mov    0x4c(%eax),%eax
  801344:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134c:	c7 04 24 a4 2c 80 00 	movl   $0x802ca4,(%esp)
  801353:	e8 09 ee ff ff       	call   800161 <cprintf>
	*dev = 0;
  801358:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80135e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	5b                   	pop    %ebx
  801367:	5e                   	pop    %esi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	83 ec 24             	sub    $0x24,%esp
  801371:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801374:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	89 04 24             	mov    %eax,(%esp)
  801381:	e8 07 ff ff ff       	call   80128d <fd_lookup>
  801386:	85 c0                	test   %eax,%eax
  801388:	78 53                	js     8013dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801394:	8b 00                	mov    (%eax),%eax
  801396:	89 04 24             	mov    %eax,(%esp)
  801399:	e8 63 ff ff ff       	call   801301 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 3b                	js     8013dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8013a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013aa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8013ae:	74 2d                	je     8013dd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013b0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013b3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013ba:	00 00 00 
	stat->st_isdir = 0;
  8013bd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013c4:	00 00 00 
	stat->st_dev = dev;
  8013c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d7:	89 14 24             	mov    %edx,(%esp)
  8013da:	ff 50 14             	call   *0x14(%eax)
}
  8013dd:	83 c4 24             	add    $0x24,%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    

008013e3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	53                   	push   %ebx
  8013e7:	83 ec 24             	sub    $0x24,%esp
  8013ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f4:	89 1c 24             	mov    %ebx,(%esp)
  8013f7:	e8 91 fe ff ff       	call   80128d <fd_lookup>
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 5f                	js     80145f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801400:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801403:	89 44 24 04          	mov    %eax,0x4(%esp)
  801407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	89 04 24             	mov    %eax,(%esp)
  80140f:	e8 ed fe ff ff       	call   801301 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801414:	85 c0                	test   %eax,%eax
  801416:	78 47                	js     80145f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801418:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80141b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80141f:	75 23                	jne    801444 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801421:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801426:	8b 40 4c             	mov    0x4c(%eax),%eax
  801429:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801431:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  801438:	e8 24 ed ff ff       	call   800161 <cprintf>
  80143d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801442:	eb 1b                	jmp    80145f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801447:	8b 48 18             	mov    0x18(%eax),%ecx
  80144a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80144f:	85 c9                	test   %ecx,%ecx
  801451:	74 0c                	je     80145f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145a:	89 14 24             	mov    %edx,(%esp)
  80145d:	ff d1                	call   *%ecx
}
  80145f:	83 c4 24             	add    $0x24,%esp
  801462:	5b                   	pop    %ebx
  801463:	5d                   	pop    %ebp
  801464:	c3                   	ret    

00801465 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	53                   	push   %ebx
  801469:	83 ec 24             	sub    $0x24,%esp
  80146c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801472:	89 44 24 04          	mov    %eax,0x4(%esp)
  801476:	89 1c 24             	mov    %ebx,(%esp)
  801479:	e8 0f fe ff ff       	call   80128d <fd_lookup>
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 66                	js     8014e8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801485:	89 44 24 04          	mov    %eax,0x4(%esp)
  801489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148c:	8b 00                	mov    (%eax),%eax
  80148e:	89 04 24             	mov    %eax,(%esp)
  801491:	e8 6b fe ff ff       	call   801301 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801496:	85 c0                	test   %eax,%eax
  801498:	78 4e                	js     8014e8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80149a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80149d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014a1:	75 23                	jne    8014c6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8014a3:	a1 74 60 80 00       	mov    0x806074,%eax
  8014a8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b3:	c7 04 24 e5 2c 80 00 	movl   $0x802ce5,(%esp)
  8014ba:	e8 a2 ec ff ff       	call   800161 <cprintf>
  8014bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8014c4:	eb 22                	jmp    8014e8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8014cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d1:	85 c9                	test   %ecx,%ecx
  8014d3:	74 13                	je     8014e8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e3:	89 14 24             	mov    %edx,(%esp)
  8014e6:	ff d1                	call   *%ecx
}
  8014e8:	83 c4 24             	add    $0x24,%esp
  8014eb:	5b                   	pop    %ebx
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    

008014ee <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 24             	sub    $0x24,%esp
  8014f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ff:	89 1c 24             	mov    %ebx,(%esp)
  801502:	e8 86 fd ff ff       	call   80128d <fd_lookup>
  801507:	85 c0                	test   %eax,%eax
  801509:	78 6b                	js     801576 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	89 04 24             	mov    %eax,(%esp)
  80151a:	e8 e2 fd ff ff       	call   801301 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 53                	js     801576 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801526:	8b 42 08             	mov    0x8(%edx),%eax
  801529:	83 e0 03             	and    $0x3,%eax
  80152c:	83 f8 01             	cmp    $0x1,%eax
  80152f:	75 23                	jne    801554 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801531:	a1 74 60 80 00       	mov    0x806074,%eax
  801536:	8b 40 4c             	mov    0x4c(%eax),%eax
  801539:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80153d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801541:	c7 04 24 02 2d 80 00 	movl   $0x802d02,(%esp)
  801548:	e8 14 ec ff ff       	call   800161 <cprintf>
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801552:	eb 22                	jmp    801576 <read+0x88>
	}
	if (!dev->dev_read)
  801554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801557:	8b 48 08             	mov    0x8(%eax),%ecx
  80155a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155f:	85 c9                	test   %ecx,%ecx
  801561:	74 13                	je     801576 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801563:	8b 45 10             	mov    0x10(%ebp),%eax
  801566:	89 44 24 08          	mov    %eax,0x8(%esp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801571:	89 14 24             	mov    %edx,(%esp)
  801574:	ff d1                	call   *%ecx
}
  801576:	83 c4 24             	add    $0x24,%esp
  801579:	5b                   	pop    %ebx
  80157a:	5d                   	pop    %ebp
  80157b:	c3                   	ret    

0080157c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	57                   	push   %edi
  801580:	56                   	push   %esi
  801581:	53                   	push   %ebx
  801582:	83 ec 1c             	sub    $0x1c,%esp
  801585:	8b 7d 08             	mov    0x8(%ebp),%edi
  801588:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80158b:	ba 00 00 00 00       	mov    $0x0,%edx
  801590:	bb 00 00 00 00       	mov    $0x0,%ebx
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
  80159a:	85 f6                	test   %esi,%esi
  80159c:	74 29                	je     8015c7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80159e:	89 f0                	mov    %esi,%eax
  8015a0:	29 d0                	sub    %edx,%eax
  8015a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015a6:	03 55 0c             	add    0xc(%ebp),%edx
  8015a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015ad:	89 3c 24             	mov    %edi,(%esp)
  8015b0:	e8 39 ff ff ff       	call   8014ee <read>
		if (m < 0)
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	78 0e                	js     8015c7 <readn+0x4b>
			return m;
		if (m == 0)
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	74 08                	je     8015c5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015bd:	01 c3                	add    %eax,%ebx
  8015bf:	89 da                	mov    %ebx,%edx
  8015c1:	39 f3                	cmp    %esi,%ebx
  8015c3:	72 d9                	jb     80159e <readn+0x22>
  8015c5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015c7:	83 c4 1c             	add    $0x1c,%esp
  8015ca:	5b                   	pop    %ebx
  8015cb:	5e                   	pop    %esi
  8015cc:	5f                   	pop    %edi
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	56                   	push   %esi
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 20             	sub    $0x20,%esp
  8015d7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015da:	89 34 24             	mov    %esi,(%esp)
  8015dd:	e8 0e fc ff ff       	call   8011f0 <fd2num>
  8015e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8015e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015e9:	89 04 24             	mov    %eax,(%esp)
  8015ec:	e8 9c fc ff ff       	call   80128d <fd_lookup>
  8015f1:	89 c3                	mov    %eax,%ebx
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	78 05                	js     8015fc <fd_close+0x2d>
  8015f7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015fa:	74 0c                	je     801608 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8015fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801600:	19 c0                	sbb    %eax,%eax
  801602:	f7 d0                	not    %eax
  801604:	21 c3                	and    %eax,%ebx
  801606:	eb 3d                	jmp    801645 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801608:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160f:	8b 06                	mov    (%esi),%eax
  801611:	89 04 24             	mov    %eax,(%esp)
  801614:	e8 e8 fc ff ff       	call   801301 <dev_lookup>
  801619:	89 c3                	mov    %eax,%ebx
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 16                	js     801635 <fd_close+0x66>
		if (dev->dev_close)
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801622:	8b 40 10             	mov    0x10(%eax),%eax
  801625:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 07                	je     801635 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80162e:	89 34 24             	mov    %esi,(%esp)
  801631:	ff d0                	call   *%eax
  801633:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801635:	89 74 24 04          	mov    %esi,0x4(%esp)
  801639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801640:	e8 0a f9 ff ff       	call   800f4f <sys_page_unmap>
	return r;
}
  801645:	89 d8                	mov    %ebx,%eax
  801647:	83 c4 20             	add    $0x20,%esp
  80164a:	5b                   	pop    %ebx
  80164b:	5e                   	pop    %esi
  80164c:	5d                   	pop    %ebp
  80164d:	c3                   	ret    

0080164e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801654:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	89 04 24             	mov    %eax,(%esp)
  801661:	e8 27 fc ff ff       	call   80128d <fd_lookup>
  801666:	85 c0                	test   %eax,%eax
  801668:	78 13                	js     80167d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80166a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801671:	00 
  801672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801675:	89 04 24             	mov    %eax,(%esp)
  801678:	e8 52 ff ff ff       	call   8015cf <fd_close>
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 18             	sub    $0x18,%esp
  801685:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801688:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80168b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801692:	00 
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	89 04 24             	mov    %eax,(%esp)
  801699:	e8 55 03 00 00       	call   8019f3 <open>
  80169e:	89 c3                	mov    %eax,%ebx
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 1b                	js     8016bf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ab:	89 1c 24             	mov    %ebx,(%esp)
  8016ae:	e8 b7 fc ff ff       	call   80136a <fstat>
  8016b3:	89 c6                	mov    %eax,%esi
	close(fd);
  8016b5:	89 1c 24             	mov    %ebx,(%esp)
  8016b8:	e8 91 ff ff ff       	call   80164e <close>
  8016bd:	89 f3                	mov    %esi,%ebx
	return r;
}
  8016bf:	89 d8                	mov    %ebx,%eax
  8016c1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016c4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016c7:	89 ec                	mov    %ebp,%esp
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	53                   	push   %ebx
  8016cf:	83 ec 14             	sub    $0x14,%esp
  8016d2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 6f ff ff ff       	call   80164e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016df:	83 c3 01             	add    $0x1,%ebx
  8016e2:	83 fb 20             	cmp    $0x20,%ebx
  8016e5:	75 f0                	jne    8016d7 <close_all+0xc>
		close(i);
}
  8016e7:	83 c4 14             	add    $0x14,%esp
  8016ea:	5b                   	pop    %ebx
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    

008016ed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 58             	sub    $0x58,%esp
  8016f3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016f9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8016fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801702:	89 44 24 04          	mov    %eax,0x4(%esp)
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	89 04 24             	mov    %eax,(%esp)
  80170c:	e8 7c fb ff ff       	call   80128d <fd_lookup>
  801711:	89 c3                	mov    %eax,%ebx
  801713:	85 c0                	test   %eax,%eax
  801715:	0f 88 e0 00 00 00    	js     8017fb <dup+0x10e>
		return r;
	close(newfdnum);
  80171b:	89 3c 24             	mov    %edi,(%esp)
  80171e:	e8 2b ff ff ff       	call   80164e <close>

	newfd = INDEX2FD(newfdnum);
  801723:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801729:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80172c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80172f:	89 04 24             	mov    %eax,(%esp)
  801732:	e8 c9 fa ff ff       	call   801200 <fd2data>
  801737:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801739:	89 34 24             	mov    %esi,(%esp)
  80173c:	e8 bf fa ff ff       	call   801200 <fd2data>
  801741:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801744:	89 da                	mov    %ebx,%edx
  801746:	89 d8                	mov    %ebx,%eax
  801748:	c1 e8 16             	shr    $0x16,%eax
  80174b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801752:	a8 01                	test   $0x1,%al
  801754:	74 43                	je     801799 <dup+0xac>
  801756:	c1 ea 0c             	shr    $0xc,%edx
  801759:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801760:	a8 01                	test   $0x1,%al
  801762:	74 35                	je     801799 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801764:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80176b:	25 07 0e 00 00       	and    $0xe07,%eax
  801770:	89 44 24 10          	mov    %eax,0x10(%esp)
  801774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801777:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80177b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801782:	00 
  801783:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801787:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80178e:	e8 1a f8 ff ff       	call   800fad <sys_page_map>
  801793:	89 c3                	mov    %eax,%ebx
  801795:	85 c0                	test   %eax,%eax
  801797:	78 3f                	js     8017d8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80179c:	89 c2                	mov    %eax,%edx
  80179e:	c1 ea 0c             	shr    $0xc,%edx
  8017a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017a8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017ae:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017b2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017bd:	00 
  8017be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c9:	e8 df f7 ff ff       	call   800fad <sys_page_map>
  8017ce:	89 c3                	mov    %eax,%ebx
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	78 04                	js     8017d8 <dup+0xeb>
  8017d4:	89 fb                	mov    %edi,%ebx
  8017d6:	eb 23                	jmp    8017fb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e3:	e8 67 f7 ff ff       	call   800f4f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f6:	e8 54 f7 ff ff       	call   800f4f <sys_page_unmap>
	return r;
}
  8017fb:	89 d8                	mov    %ebx,%eax
  8017fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801800:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801803:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801806:	89 ec                	mov    %ebp,%esp
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    
	...

0080180c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	53                   	push   %ebx
  801810:	83 ec 14             	sub    $0x14,%esp
  801813:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801815:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80181b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801822:	00 
  801823:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80182a:	00 
  80182b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182f:	89 14 24             	mov    %edx,(%esp)
  801832:	e8 19 0d 00 00       	call   802550 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801837:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80183e:	00 
  80183f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801843:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184a:	e8 67 0d 00 00       	call   8025b6 <ipc_recv>
}
  80184f:	83 c4 14             	add    $0x14,%esp
  801852:	5b                   	pop    %ebx
  801853:	5d                   	pop    %ebp
  801854:	c3                   	ret    

00801855 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	8b 40 0c             	mov    0xc(%eax),%eax
  801861:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801866:	8b 45 0c             	mov    0xc(%ebp),%eax
  801869:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	b8 02 00 00 00       	mov    $0x2,%eax
  801878:	e8 8f ff ff ff       	call   80180c <fsipc>
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8b 40 0c             	mov    0xc(%eax),%eax
  80188b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801890:	ba 00 00 00 00       	mov    $0x0,%edx
  801895:	b8 06 00 00 00       	mov    $0x6,%eax
  80189a:	e8 6d ff ff ff       	call   80180c <fsipc>
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8018b1:	e8 56 ff ff ff       	call   80180c <fsipc>
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 14             	sub    $0x14,%esp
  8018bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c8:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d2:	b8 05 00 00 00       	mov    $0x5,%eax
  8018d7:	e8 30 ff ff ff       	call   80180c <fsipc>
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 2b                	js     80190b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018e0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8018e7:	00 
  8018e8:	89 1c 24             	mov    %ebx,(%esp)
  8018eb:	e8 2a ef ff ff       	call   80081a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018f0:	a1 80 30 80 00       	mov    0x803080,%eax
  8018f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018fb:	a1 84 30 80 00       	mov    0x803084,%eax
  801900:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801906:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80190b:	83 c4 14             	add    $0x14,%esp
  80190e:	5b                   	pop    %ebx
  80190f:	5d                   	pop    %ebp
  801910:	c3                   	ret    

00801911 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 18             	sub    $0x18,%esp
  801917:	8b 45 10             	mov    0x10(%ebp),%eax
  80191a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80191f:	76 05                	jbe    801926 <devfile_write+0x15>
  801921:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801926:	8b 55 08             	mov    0x8(%ebp),%edx
  801929:	8b 52 0c             	mov    0xc(%edx),%edx
  80192c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801932:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801937:	89 44 24 08          	mov    %eax,0x8(%esp)
  80193b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801942:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801949:	e8 87 f0 ff ff       	call   8009d5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80194e:	ba 00 00 00 00       	mov    $0x0,%edx
  801953:	b8 04 00 00 00       	mov    $0x4,%eax
  801958:	e8 af fe ff ff       	call   80180c <fsipc>
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	53                   	push   %ebx
  801963:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	8b 40 0c             	mov    0xc(%eax),%eax
  80196c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801979:	ba 00 30 80 00       	mov    $0x803000,%edx
  80197e:	b8 03 00 00 00       	mov    $0x3,%eax
  801983:	e8 84 fe ff ff       	call   80180c <fsipc>
  801988:	89 c3                	mov    %eax,%ebx
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 17                	js     8019a5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80198e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801992:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801999:	00 
  80199a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199d:	89 04 24             	mov    %eax,(%esp)
  8019a0:	e8 30 f0 ff ff       	call   8009d5 <memmove>
	return r;
}
  8019a5:	89 d8                	mov    %ebx,%eax
  8019a7:	83 c4 14             	add    $0x14,%esp
  8019aa:	5b                   	pop    %ebx
  8019ab:	5d                   	pop    %ebp
  8019ac:	c3                   	ret    

008019ad <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	53                   	push   %ebx
  8019b1:	83 ec 14             	sub    $0x14,%esp
  8019b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8019b7:	89 1c 24             	mov    %ebx,(%esp)
  8019ba:	e8 11 ee ff ff       	call   8007d0 <strlen>
  8019bf:	89 c2                	mov    %eax,%edx
  8019c1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8019c6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8019cc:	7f 1f                	jg     8019ed <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8019ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019d2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8019d9:	e8 3c ee ff ff       	call   80081a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e3:	b8 07 00 00 00       	mov    $0x7,%eax
  8019e8:	e8 1f fe ff ff       	call   80180c <fsipc>
}
  8019ed:	83 c4 14             	add    $0x14,%esp
  8019f0:	5b                   	pop    %ebx
  8019f1:	5d                   	pop    %ebp
  8019f2:	c3                   	ret    

008019f3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 28             	sub    $0x28,%esp
  8019f9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8019fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8019ff:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801a02:	89 34 24             	mov    %esi,(%esp)
  801a05:	e8 c6 ed ff ff       	call   8007d0 <strlen>
  801a0a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a0f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a14:	7f 5e                	jg     801a74 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a19:	89 04 24             	mov    %eax,(%esp)
  801a1c:	e8 fa f7 ff ff       	call   80121b <fd_alloc>
  801a21:	89 c3                	mov    %eax,%ebx
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 4d                	js     801a74 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801a27:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a2b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a32:	e8 e3 ed ff ff       	call   80081a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	b8 01 00 00 00       	mov    $0x1,%eax
  801a47:	e8 c0 fd ff ff       	call   80180c <fsipc>
  801a4c:	89 c3                	mov    %eax,%ebx
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	79 15                	jns    801a67 <open+0x74>
	{
		fd_close(fd,0);
  801a52:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a59:	00 
  801a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5d:	89 04 24             	mov    %eax,(%esp)
  801a60:	e8 6a fb ff ff       	call   8015cf <fd_close>
		return r; 
  801a65:	eb 0d                	jmp    801a74 <open+0x81>
	}
	return fd2num(fd);
  801a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6a:	89 04 24             	mov    %eax,(%esp)
  801a6d:	e8 7e f7 ff ff       	call   8011f0 <fd2num>
  801a72:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a79:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a7c:	89 ec                	mov    %ebp,%esp
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    

00801a80 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801a86:	c7 44 24 04 34 2d 80 	movl   $0x802d34,0x4(%esp)
  801a8d:	00 
  801a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a91:	89 04 24             	mov    %eax,(%esp)
  801a94:	e8 81 ed ff ff       	call   80081a <strcpy>
	return 0;
}
  801a99:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	8b 40 0c             	mov    0xc(%eax),%eax
  801aac:	89 04 24             	mov    %eax,(%esp)
  801aaf:	e8 9e 02 00 00       	call   801d52 <nsipc_close>
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801abc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ac3:	00 
  801ac4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ace:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad8:	89 04 24             	mov    %eax,(%esp)
  801adb:	e8 ae 02 00 00       	call   801d8e <nsipc_send>
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ae8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801aef:	00 
  801af0:	8b 45 10             	mov    0x10(%ebp),%eax
  801af3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	8b 40 0c             	mov    0xc(%eax),%eax
  801b04:	89 04 24             	mov    %eax,(%esp)
  801b07:	e8 f5 02 00 00       	call   801e01 <nsipc_recv>
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	56                   	push   %esi
  801b12:	53                   	push   %ebx
  801b13:	83 ec 20             	sub    $0x20,%esp
  801b16:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801b18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1b:	89 04 24             	mov    %eax,(%esp)
  801b1e:	e8 f8 f6 ff ff       	call   80121b <fd_alloc>
  801b23:	89 c3                	mov    %eax,%ebx
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 21                	js     801b4a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801b29:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801b30:	00 
  801b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b3f:	e8 c7 f4 ff ff       	call   80100b <sys_page_alloc>
  801b44:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801b46:	85 c0                	test   %eax,%eax
  801b48:	79 0a                	jns    801b54 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801b4a:	89 34 24             	mov    %esi,(%esp)
  801b4d:	e8 00 02 00 00       	call   801d52 <nsipc_close>
		return r;
  801b52:	eb 28                	jmp    801b7c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b54:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b62:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b72:	89 04 24             	mov    %eax,(%esp)
  801b75:	e8 76 f6 ff ff       	call   8011f0 <fd2num>
  801b7a:	89 c3                	mov    %eax,%ebx
}
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	83 c4 20             	add    $0x20,%esp
  801b81:	5b                   	pop    %ebx
  801b82:	5e                   	pop    %esi
  801b83:	5d                   	pop    %ebp
  801b84:	c3                   	ret    

00801b85 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	89 04 24             	mov    %eax,(%esp)
  801b9f:	e8 62 01 00 00       	call   801d06 <nsipc_socket>
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 05                	js     801bad <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801ba8:	e8 61 ff ff ff       	call   801b0e <alloc_sockfd>
}
  801bad:	c9                   	leave  
  801bae:	66 90                	xchg   %ax,%ax
  801bb0:	c3                   	ret    

00801bb1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bb7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bba:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bbe:	89 04 24             	mov    %eax,(%esp)
  801bc1:	e8 c7 f6 ff ff       	call   80128d <fd_lookup>
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 15                	js     801bdf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcd:	8b 0a                	mov    (%edx),%ecx
  801bcf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bd4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801bda:	75 03                	jne    801bdf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801bdc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	e8 c2 ff ff ff       	call   801bb1 <fd2sockid>
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 0f                	js     801c02 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bfa:	89 04 24             	mov    %eax,(%esp)
  801bfd:	e8 2e 01 00 00       	call   801d30 <nsipc_listen>
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	e8 9f ff ff ff       	call   801bb1 <fd2sockid>
  801c12:	85 c0                	test   %eax,%eax
  801c14:	78 16                	js     801c2c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801c16:	8b 55 10             	mov    0x10(%ebp),%edx
  801c19:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c20:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c24:	89 04 24             	mov    %eax,(%esp)
  801c27:	e8 55 02 00 00       	call   801e81 <nsipc_connect>
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	e8 75 ff ff ff       	call   801bb1 <fd2sockid>
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 0f                	js     801c4f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c43:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c47:	89 04 24             	mov    %eax,(%esp)
  801c4a:	e8 1d 01 00 00       	call   801d6c <nsipc_shutdown>
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	e8 52 ff ff ff       	call   801bb1 <fd2sockid>
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 16                	js     801c79 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801c63:	8b 55 10             	mov    0x10(%ebp),%edx
  801c66:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c71:	89 04 24             	mov    %eax,(%esp)
  801c74:	e8 47 02 00 00       	call   801ec0 <nsipc_bind>
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	e8 28 ff ff ff       	call   801bb1 <fd2sockid>
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	78 1f                	js     801cac <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c8d:	8b 55 10             	mov    0x10(%ebp),%edx
  801c90:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c97:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c9b:	89 04 24             	mov    %eax,(%esp)
  801c9e:	e8 5c 02 00 00       	call   801eff <nsipc_accept>
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	78 05                	js     801cac <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801ca7:	e8 62 fe ff ff       	call   801b0e <alloc_sockfd>
}
  801cac:	c9                   	leave  
  801cad:	8d 76 00             	lea    0x0(%esi),%esi
  801cb0:	c3                   	ret    
	...

00801cc0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cc6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801ccc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801cd3:	00 
  801cd4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801cdb:	00 
  801cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce0:	89 14 24             	mov    %edx,(%esp)
  801ce3:	e8 68 08 00 00       	call   802550 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ce8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cef:	00 
  801cf0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cf7:	00 
  801cf8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cff:	e8 b2 08 00 00       	call   8025b6 <ipc_recv>
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d17:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801d24:	b8 09 00 00 00       	mov    $0x9,%eax
  801d29:	e8 92 ff ff ff       	call   801cc0 <nsipc>
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d41:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801d46:	b8 06 00 00 00       	mov    $0x6,%eax
  801d4b:	e8 70 ff ff ff       	call   801cc0 <nsipc>
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801d60:	b8 04 00 00 00       	mov    $0x4,%eax
  801d65:	e8 56 ff ff ff       	call   801cc0 <nsipc>
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801d82:	b8 03 00 00 00       	mov    $0x3,%eax
  801d87:	e8 34 ff ff ff       	call   801cc0 <nsipc>
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	53                   	push   %ebx
  801d92:	83 ec 14             	sub    $0x14,%esp
  801d95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801da0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801da6:	7e 24                	jle    801dcc <nsipc_send+0x3e>
  801da8:	c7 44 24 0c 40 2d 80 	movl   $0x802d40,0xc(%esp)
  801daf:	00 
  801db0:	c7 44 24 08 4c 2d 80 	movl   $0x802d4c,0x8(%esp)
  801db7:	00 
  801db8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801dbf:	00 
  801dc0:	c7 04 24 61 2d 80 00 	movl   $0x802d61,(%esp)
  801dc7:	e8 20 07 00 00       	call   8024ec <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801dcc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801dde:	e8 f2 eb ff ff       	call   8009d5 <memmove>
	nsipcbuf.send.req_size = size;
  801de3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801de9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dec:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801df1:	b8 08 00 00 00       	mov    $0x8,%eax
  801df6:	e8 c5 fe ff ff       	call   801cc0 <nsipc>
}
  801dfb:	83 c4 14             	add    $0x14,%esp
  801dfe:	5b                   	pop    %ebx
  801dff:	5d                   	pop    %ebp
  801e00:	c3                   	ret    

00801e01 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	56                   	push   %esi
  801e05:	53                   	push   %ebx
  801e06:	83 ec 10             	sub    $0x10,%esp
  801e09:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801e14:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e22:	b8 07 00 00 00       	mov    $0x7,%eax
  801e27:	e8 94 fe ff ff       	call   801cc0 <nsipc>
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 46                	js     801e78 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801e32:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e37:	7f 04                	jg     801e3d <nsipc_recv+0x3c>
  801e39:	39 c6                	cmp    %eax,%esi
  801e3b:	7d 24                	jge    801e61 <nsipc_recv+0x60>
  801e3d:	c7 44 24 0c 6d 2d 80 	movl   $0x802d6d,0xc(%esp)
  801e44:	00 
  801e45:	c7 44 24 08 4c 2d 80 	movl   $0x802d4c,0x8(%esp)
  801e4c:	00 
  801e4d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801e54:	00 
  801e55:	c7 04 24 61 2d 80 00 	movl   $0x802d61,(%esp)
  801e5c:	e8 8b 06 00 00       	call   8024ec <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e61:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e65:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801e6c:	00 
  801e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e70:	89 04 24             	mov    %eax,(%esp)
  801e73:	e8 5d eb ff ff       	call   8009d5 <memmove>
	}

	return r;
}
  801e78:	89 d8                	mov    %ebx,%eax
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5e                   	pop    %esi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    

00801e81 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	53                   	push   %ebx
  801e85:	83 ec 14             	sub    $0x14,%esp
  801e88:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801ea5:	e8 2b eb ff ff       	call   8009d5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801eaa:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  801eb0:	b8 05 00 00 00       	mov    $0x5,%eax
  801eb5:	e8 06 fe ff ff       	call   801cc0 <nsipc>
}
  801eba:	83 c4 14             	add    $0x14,%esp
  801ebd:	5b                   	pop    %ebx
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    

00801ec0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 14             	sub    $0x14,%esp
  801ec7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ed2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edd:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801ee4:	e8 ec ea ff ff       	call   8009d5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ee9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  801eef:	b8 02 00 00 00       	mov    $0x2,%eax
  801ef4:	e8 c7 fd ff ff       	call   801cc0 <nsipc>
}
  801ef9:	83 c4 14             	add    $0x14,%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5d                   	pop    %ebp
  801efe:	c3                   	ret    

00801eff <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 18             	sub    $0x18,%esp
  801f05:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801f08:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f13:	b8 01 00 00 00       	mov    $0x1,%eax
  801f18:	e8 a3 fd ff ff       	call   801cc0 <nsipc>
  801f1d:	89 c3                	mov    %eax,%ebx
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	78 25                	js     801f48 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f23:	be 10 50 80 00       	mov    $0x805010,%esi
  801f28:	8b 06                	mov    (%esi),%eax
  801f2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f2e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801f35:	00 
  801f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f39:	89 04 24             	mov    %eax,(%esp)
  801f3c:	e8 94 ea ff ff       	call   8009d5 <memmove>
		*addrlen = ret->ret_addrlen;
  801f41:	8b 16                	mov    (%esi),%edx
  801f43:	8b 45 10             	mov    0x10(%ebp),%eax
  801f46:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801f48:	89 d8                	mov    %ebx,%eax
  801f4a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f4d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f50:	89 ec                	mov    %ebp,%esp
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    
	...

00801f60 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 18             	sub    $0x18,%esp
  801f66:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801f69:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	89 04 24             	mov    %eax,(%esp)
  801f75:	e8 86 f2 ff ff       	call   801200 <fd2data>
  801f7a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801f7c:	c7 44 24 04 82 2d 80 	movl   $0x802d82,0x4(%esp)
  801f83:	00 
  801f84:	89 34 24             	mov    %esi,(%esp)
  801f87:	e8 8e e8 ff ff       	call   80081a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f8c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f8f:	2b 03                	sub    (%ebx),%eax
  801f91:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801f97:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801f9e:	00 00 00 
	stat->st_dev = &devpipe;
  801fa1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  801fa8:	60 80 00 
	return 0;
}
  801fab:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801fb3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801fb6:	89 ec                	mov    %ebp,%esp
  801fb8:	5d                   	pop    %ebp
  801fb9:	c3                   	ret    

00801fba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	53                   	push   %ebx
  801fbe:	83 ec 14             	sub    $0x14,%esp
  801fc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fc4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fc8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fcf:	e8 7b ef ff ff       	call   800f4f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fd4:	89 1c 24             	mov    %ebx,(%esp)
  801fd7:	e8 24 f2 ff ff       	call   801200 <fd2data>
  801fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe7:	e8 63 ef ff ff       	call   800f4f <sys_page_unmap>
}
  801fec:	83 c4 14             	add    $0x14,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5d                   	pop    %ebp
  801ff1:	c3                   	ret    

00801ff2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	57                   	push   %edi
  801ff6:	56                   	push   %esi
  801ff7:	53                   	push   %ebx
  801ff8:	83 ec 2c             	sub    $0x2c,%esp
  801ffb:	89 c7                	mov    %eax,%edi
  801ffd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802000:	a1 74 60 80 00       	mov    0x806074,%eax
  802005:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802008:	89 3c 24             	mov    %edi,(%esp)
  80200b:	e8 10 06 00 00       	call   802620 <pageref>
  802010:	89 c6                	mov    %eax,%esi
  802012:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802015:	89 04 24             	mov    %eax,(%esp)
  802018:	e8 03 06 00 00       	call   802620 <pageref>
  80201d:	39 c6                	cmp    %eax,%esi
  80201f:	0f 94 c0             	sete   %al
  802022:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802025:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80202b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80202e:	39 cb                	cmp    %ecx,%ebx
  802030:	75 08                	jne    80203a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802032:	83 c4 2c             	add    $0x2c,%esp
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5f                   	pop    %edi
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80203a:	83 f8 01             	cmp    $0x1,%eax
  80203d:	75 c1                	jne    802000 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80203f:	8b 52 58             	mov    0x58(%edx),%edx
  802042:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802046:	89 54 24 08          	mov    %edx,0x8(%esp)
  80204a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80204e:	c7 04 24 89 2d 80 00 	movl   $0x802d89,(%esp)
  802055:	e8 07 e1 ff ff       	call   800161 <cprintf>
  80205a:	eb a4                	jmp    802000 <_pipeisclosed+0xe>

0080205c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	57                   	push   %edi
  802060:	56                   	push   %esi
  802061:	53                   	push   %ebx
  802062:	83 ec 1c             	sub    $0x1c,%esp
  802065:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802068:	89 34 24             	mov    %esi,(%esp)
  80206b:	e8 90 f1 ff ff       	call   801200 <fd2data>
  802070:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802072:	bf 00 00 00 00       	mov    $0x0,%edi
  802077:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80207b:	75 54                	jne    8020d1 <devpipe_write+0x75>
  80207d:	eb 60                	jmp    8020df <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80207f:	89 da                	mov    %ebx,%edx
  802081:	89 f0                	mov    %esi,%eax
  802083:	e8 6a ff ff ff       	call   801ff2 <_pipeisclosed>
  802088:	85 c0                	test   %eax,%eax
  80208a:	74 07                	je     802093 <devpipe_write+0x37>
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
  802091:	eb 53                	jmp    8020e6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802093:	90                   	nop
  802094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802098:	e8 cd ef ff ff       	call   80106a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80209d:	8b 43 04             	mov    0x4(%ebx),%eax
  8020a0:	8b 13                	mov    (%ebx),%edx
  8020a2:	83 c2 20             	add    $0x20,%edx
  8020a5:	39 d0                	cmp    %edx,%eax
  8020a7:	73 d6                	jae    80207f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020a9:	89 c2                	mov    %eax,%edx
  8020ab:	c1 fa 1f             	sar    $0x1f,%edx
  8020ae:	c1 ea 1b             	shr    $0x1b,%edx
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	83 e0 1f             	and    $0x1f,%eax
  8020b6:	29 d0                	sub    %edx,%eax
  8020b8:	89 c2                	mov    %eax,%edx
  8020ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020bd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8020c1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020c5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020c9:	83 c7 01             	add    $0x1,%edi
  8020cc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8020cf:	76 13                	jbe    8020e4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020d1:	8b 43 04             	mov    0x4(%ebx),%eax
  8020d4:	8b 13                	mov    (%ebx),%edx
  8020d6:	83 c2 20             	add    $0x20,%edx
  8020d9:	39 d0                	cmp    %edx,%eax
  8020db:	73 a2                	jae    80207f <devpipe_write+0x23>
  8020dd:	eb ca                	jmp    8020a9 <devpipe_write+0x4d>
  8020df:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8020e4:	89 f8                	mov    %edi,%eax
}
  8020e6:	83 c4 1c             	add    $0x1c,%esp
  8020e9:	5b                   	pop    %ebx
  8020ea:	5e                   	pop    %esi
  8020eb:	5f                   	pop    %edi
  8020ec:	5d                   	pop    %ebp
  8020ed:	c3                   	ret    

008020ee <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 28             	sub    $0x28,%esp
  8020f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802100:	89 3c 24             	mov    %edi,(%esp)
  802103:	e8 f8 f0 ff ff       	call   801200 <fd2data>
  802108:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80210a:	be 00 00 00 00       	mov    $0x0,%esi
  80210f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802113:	75 4c                	jne    802161 <devpipe_read+0x73>
  802115:	eb 5b                	jmp    802172 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802117:	89 f0                	mov    %esi,%eax
  802119:	eb 5e                	jmp    802179 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80211b:	89 da                	mov    %ebx,%edx
  80211d:	89 f8                	mov    %edi,%eax
  80211f:	90                   	nop
  802120:	e8 cd fe ff ff       	call   801ff2 <_pipeisclosed>
  802125:	85 c0                	test   %eax,%eax
  802127:	74 07                	je     802130 <devpipe_read+0x42>
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
  80212e:	eb 49                	jmp    802179 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802130:	e8 35 ef ff ff       	call   80106a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802135:	8b 03                	mov    (%ebx),%eax
  802137:	3b 43 04             	cmp    0x4(%ebx),%eax
  80213a:	74 df                	je     80211b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80213c:	89 c2                	mov    %eax,%edx
  80213e:	c1 fa 1f             	sar    $0x1f,%edx
  802141:	c1 ea 1b             	shr    $0x1b,%edx
  802144:	01 d0                	add    %edx,%eax
  802146:	83 e0 1f             	and    $0x1f,%eax
  802149:	29 d0                	sub    %edx,%eax
  80214b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802150:	8b 55 0c             	mov    0xc(%ebp),%edx
  802153:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802156:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802159:	83 c6 01             	add    $0x1,%esi
  80215c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80215f:	76 16                	jbe    802177 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802161:	8b 03                	mov    (%ebx),%eax
  802163:	3b 43 04             	cmp    0x4(%ebx),%eax
  802166:	75 d4                	jne    80213c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802168:	85 f6                	test   %esi,%esi
  80216a:	75 ab                	jne    802117 <devpipe_read+0x29>
  80216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802170:	eb a9                	jmp    80211b <devpipe_read+0x2d>
  802172:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802177:	89 f0                	mov    %esi,%eax
}
  802179:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80217c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80217f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802182:	89 ec                	mov    %ebp,%esp
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    

00802186 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80218c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80218f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	89 04 24             	mov    %eax,(%esp)
  802199:	e8 ef f0 ff ff       	call   80128d <fd_lookup>
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	78 15                	js     8021b7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	89 04 24             	mov    %eax,(%esp)
  8021a8:	e8 53 f0 ff ff       	call   801200 <fd2data>
	return _pipeisclosed(fd, p);
  8021ad:	89 c2                	mov    %eax,%edx
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	e8 3b fe ff ff       	call   801ff2 <_pipeisclosed>
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 48             	sub    $0x48,%esp
  8021bf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8021c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8021c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8021c8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021cb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8021ce:	89 04 24             	mov    %eax,(%esp)
  8021d1:	e8 45 f0 ff ff       	call   80121b <fd_alloc>
  8021d6:	89 c3                	mov    %eax,%ebx
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	0f 88 42 01 00 00    	js     802322 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021e0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021e7:	00 
  8021e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f6:	e8 10 ee ff ff       	call   80100b <sys_page_alloc>
  8021fb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	0f 88 1d 01 00 00    	js     802322 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802205:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802208:	89 04 24             	mov    %eax,(%esp)
  80220b:	e8 0b f0 ff ff       	call   80121b <fd_alloc>
  802210:	89 c3                	mov    %eax,%ebx
  802212:	85 c0                	test   %eax,%eax
  802214:	0f 88 f5 00 00 00    	js     80230f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802221:	00 
  802222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802225:	89 44 24 04          	mov    %eax,0x4(%esp)
  802229:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802230:	e8 d6 ed ff ff       	call   80100b <sys_page_alloc>
  802235:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802237:	85 c0                	test   %eax,%eax
  802239:	0f 88 d0 00 00 00    	js     80230f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80223f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802242:	89 04 24             	mov    %eax,(%esp)
  802245:	e8 b6 ef ff ff       	call   801200 <fd2data>
  80224a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80224c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802253:	00 
  802254:	89 44 24 04          	mov    %eax,0x4(%esp)
  802258:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80225f:	e8 a7 ed ff ff       	call   80100b <sys_page_alloc>
  802264:	89 c3                	mov    %eax,%ebx
  802266:	85 c0                	test   %eax,%eax
  802268:	0f 88 8e 00 00 00    	js     8022fc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802271:	89 04 24             	mov    %eax,(%esp)
  802274:	e8 87 ef ff ff       	call   801200 <fd2data>
  802279:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802280:	00 
  802281:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802285:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80228c:	00 
  80228d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802291:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802298:	e8 10 ed ff ff       	call   800fad <sys_page_map>
  80229d:	89 c3                	mov    %eax,%ebx
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	78 49                	js     8022ec <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8022a3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  8022a8:	8b 08                	mov    (%eax),%ecx
  8022aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022ad:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022b2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8022b9:	8b 10                	mov    (%eax),%edx
  8022bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022be:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8022ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022cd:	89 04 24             	mov    %eax,(%esp)
  8022d0:	e8 1b ef ff ff       	call   8011f0 <fd2num>
  8022d5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8022d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022da:	89 04 24             	mov    %eax,(%esp)
  8022dd:	e8 0e ef ff ff       	call   8011f0 <fd2num>
  8022e2:	89 47 04             	mov    %eax,0x4(%edi)
  8022e5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8022ea:	eb 36                	jmp    802322 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8022ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f7:	e8 53 ec ff ff       	call   800f4f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8022fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802303:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80230a:	e8 40 ec ff ff       	call   800f4f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80230f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802312:	89 44 24 04          	mov    %eax,0x4(%esp)
  802316:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80231d:	e8 2d ec ff ff       	call   800f4f <sys_page_unmap>
    err:
	return r;
}
  802322:	89 d8                	mov    %ebx,%eax
  802324:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802327:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80232a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80232d:	89 ec                	mov    %ebp,%esp
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
	...

00802340 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    

0080234a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802350:	c7 44 24 04 a1 2d 80 	movl   $0x802da1,0x4(%esp)
  802357:	00 
  802358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235b:	89 04 24             	mov    %eax,(%esp)
  80235e:	e8 b7 e4 ff ff       	call   80081a <strcpy>
	return 0;
}
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	57                   	push   %edi
  80236e:	56                   	push   %esi
  80236f:	53                   	push   %ebx
  802370:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
  80237b:	be 00 00 00 00       	mov    $0x0,%esi
  802380:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802384:	74 3f                	je     8023c5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802386:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80238c:	8b 55 10             	mov    0x10(%ebp),%edx
  80238f:	29 c2                	sub    %eax,%edx
  802391:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802393:	83 fa 7f             	cmp    $0x7f,%edx
  802396:	76 05                	jbe    80239d <devcons_write+0x33>
  802398:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80239d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023a1:	03 45 0c             	add    0xc(%ebp),%eax
  8023a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a8:	89 3c 24             	mov    %edi,(%esp)
  8023ab:	e8 25 e6 ff ff       	call   8009d5 <memmove>
		sys_cputs(buf, m);
  8023b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023b4:	89 3c 24             	mov    %edi,(%esp)
  8023b7:	e8 54 e8 ff ff       	call   800c10 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023bc:	01 de                	add    %ebx,%esi
  8023be:	89 f0                	mov    %esi,%eax
  8023c0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023c3:	72 c7                	jb     80238c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8023c5:	89 f0                	mov    %esi,%eax
  8023c7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8023cd:	5b                   	pop    %ebx
  8023ce:	5e                   	pop    %esi
  8023cf:	5f                   	pop    %edi
  8023d0:	5d                   	pop    %ebp
  8023d1:	c3                   	ret    

008023d2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
  8023d5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8023de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8023e5:	00 
  8023e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023e9:	89 04 24             	mov    %eax,(%esp)
  8023ec:	e8 1f e8 ff ff       	call   800c10 <sys_cputs>
}
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8023f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023fd:	75 07                	jne    802406 <devcons_read+0x13>
  8023ff:	eb 28                	jmp    802429 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802401:	e8 64 ec ff ff       	call   80106a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802406:	66 90                	xchg   %ax,%ax
  802408:	e8 cf e7 ff ff       	call   800bdc <sys_cgetc>
  80240d:	85 c0                	test   %eax,%eax
  80240f:	90                   	nop
  802410:	74 ef                	je     802401 <devcons_read+0xe>
  802412:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802414:	85 c0                	test   %eax,%eax
  802416:	78 16                	js     80242e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802418:	83 f8 04             	cmp    $0x4,%eax
  80241b:	74 0c                	je     802429 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80241d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802420:	88 10                	mov    %dl,(%eax)
  802422:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802427:	eb 05                	jmp    80242e <devcons_read+0x3b>
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802436:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802439:	89 04 24             	mov    %eax,(%esp)
  80243c:	e8 da ed ff ff       	call   80121b <fd_alloc>
  802441:	85 c0                	test   %eax,%eax
  802443:	78 3f                	js     802484 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802445:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80244c:	00 
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	89 44 24 04          	mov    %eax,0x4(%esp)
  802454:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80245b:	e8 ab eb ff ff       	call   80100b <sys_page_alloc>
  802460:	85 c0                	test   %eax,%eax
  802462:	78 20                	js     802484 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802464:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	89 04 24             	mov    %eax,(%esp)
  80247f:	e8 6c ed ff ff       	call   8011f0 <fd2num>
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	89 04 24             	mov    %eax,(%esp)
  802499:	e8 ef ed ff ff       	call   80128d <fd_lookup>
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	78 11                	js     8024b3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  8024ad:	0f 94 c0             	sete   %al
  8024b0:	0f b6 c0             	movzbl %al,%eax
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024bb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8024c2:	00 
  8024c3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d1:	e8 18 f0 ff ff       	call   8014ee <read>
	if (r < 0)
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	78 0f                	js     8024e9 <getchar+0x34>
		return r;
	if (r < 1)
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	7f 07                	jg     8024e5 <getchar+0x30>
  8024de:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024e3:	eb 04                	jmp    8024e9 <getchar+0x34>
		return -E_EOF;
	return c;
  8024e5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    
	...

008024ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	53                   	push   %ebx
  8024f0:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8024f3:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8024f6:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	74 10                	je     80250f <_panic+0x23>
		cprintf("%s: ", argv0);
  8024ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802503:	c7 04 24 ad 2d 80 00 	movl   $0x802dad,(%esp)
  80250a:	e8 52 dc ff ff       	call   800161 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80250f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802512:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802516:	8b 45 08             	mov    0x8(%ebp),%eax
  802519:	89 44 24 08          	mov    %eax,0x8(%esp)
  80251d:	a1 00 60 80 00       	mov    0x806000,%eax
  802522:	89 44 24 04          	mov    %eax,0x4(%esp)
  802526:	c7 04 24 b2 2d 80 00 	movl   $0x802db2,(%esp)
  80252d:	e8 2f dc ff ff       	call   800161 <cprintf>
	vcprintf(fmt, ap);
  802532:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802536:	8b 45 10             	mov    0x10(%ebp),%eax
  802539:	89 04 24             	mov    %eax,(%esp)
  80253c:	e8 bf db ff ff       	call   800100 <vcprintf>
	cprintf("\n");
  802541:	c7 04 24 9a 2d 80 00 	movl   $0x802d9a,(%esp)
  802548:	e8 14 dc ff ff       	call   800161 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80254d:	cc                   	int3   
  80254e:	eb fd                	jmp    80254d <_panic+0x61>

00802550 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	57                   	push   %edi
  802554:	56                   	push   %esi
  802555:	53                   	push   %ebx
  802556:	83 ec 1c             	sub    $0x1c,%esp
  802559:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80255c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80255f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802562:	85 db                	test   %ebx,%ebx
  802564:	75 2d                	jne    802593 <ipc_send+0x43>
  802566:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80256b:	eb 26                	jmp    802593 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80256d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802570:	74 1c                	je     80258e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802572:	c7 44 24 08 d0 2d 80 	movl   $0x802dd0,0x8(%esp)
  802579:	00 
  80257a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802581:	00 
  802582:	c7 04 24 f4 2d 80 00 	movl   $0x802df4,(%esp)
  802589:	e8 5e ff ff ff       	call   8024ec <_panic>
		sys_yield();
  80258e:	e8 d7 ea ff ff       	call   80106a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802593:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802597:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80259b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	89 04 24             	mov    %eax,(%esp)
  8025a5:	e8 53 e8 ff ff       	call   800dfd <sys_ipc_try_send>
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	78 bf                	js     80256d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8025ae:	83 c4 1c             	add    $0x1c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    

008025b6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	56                   	push   %esi
  8025ba:	53                   	push   %ebx
  8025bb:	83 ec 10             	sub    $0x10,%esp
  8025be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8025c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	75 05                	jne    8025d0 <ipc_recv+0x1a>
  8025cb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8025d0:	89 04 24             	mov    %eax,(%esp)
  8025d3:	e8 c8 e7 ff ff       	call   800da0 <sys_ipc_recv>
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	79 16                	jns    8025f2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8025dc:	85 db                	test   %ebx,%ebx
  8025de:	74 06                	je     8025e6 <ipc_recv+0x30>
			*from_env_store = 0;
  8025e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8025e6:	85 f6                	test   %esi,%esi
  8025e8:	74 2c                	je     802616 <ipc_recv+0x60>
			*perm_store = 0;
  8025ea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8025f0:	eb 24                	jmp    802616 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8025f2:	85 db                	test   %ebx,%ebx
  8025f4:	74 0a                	je     802600 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8025f6:	a1 74 60 80 00       	mov    0x806074,%eax
  8025fb:	8b 40 74             	mov    0x74(%eax),%eax
  8025fe:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802600:	85 f6                	test   %esi,%esi
  802602:	74 0a                	je     80260e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802604:	a1 74 60 80 00       	mov    0x806074,%eax
  802609:	8b 40 78             	mov    0x78(%eax),%eax
  80260c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80260e:	a1 74 60 80 00       	mov    0x806074,%eax
  802613:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802616:	83 c4 10             	add    $0x10,%esp
  802619:	5b                   	pop    %ebx
  80261a:	5e                   	pop    %esi
  80261b:	5d                   	pop    %ebp
  80261c:	c3                   	ret    
  80261d:	00 00                	add    %al,(%eax)
	...

00802620 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	89 c2                	mov    %eax,%edx
  802628:	c1 ea 16             	shr    $0x16,%edx
  80262b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802632:	f6 c2 01             	test   $0x1,%dl
  802635:	74 26                	je     80265d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802637:	c1 e8 0c             	shr    $0xc,%eax
  80263a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802641:	a8 01                	test   $0x1,%al
  802643:	74 18                	je     80265d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802645:	c1 e8 0c             	shr    $0xc,%eax
  802648:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80264b:	c1 e2 02             	shl    $0x2,%edx
  80264e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802653:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802658:	0f b7 c0             	movzwl %ax,%eax
  80265b:	eb 05                	jmp    802662 <pageref+0x42>
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802662:	5d                   	pop    %ebp
  802663:	c3                   	ret    
	...

00802670 <__udivdi3>:
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	57                   	push   %edi
  802674:	56                   	push   %esi
  802675:	83 ec 10             	sub    $0x10,%esp
  802678:	8b 45 14             	mov    0x14(%ebp),%eax
  80267b:	8b 55 08             	mov    0x8(%ebp),%edx
  80267e:	8b 75 10             	mov    0x10(%ebp),%esi
  802681:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802684:	85 c0                	test   %eax,%eax
  802686:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802689:	75 35                	jne    8026c0 <__udivdi3+0x50>
  80268b:	39 fe                	cmp    %edi,%esi
  80268d:	77 61                	ja     8026f0 <__udivdi3+0x80>
  80268f:	85 f6                	test   %esi,%esi
  802691:	75 0b                	jne    80269e <__udivdi3+0x2e>
  802693:	b8 01 00 00 00       	mov    $0x1,%eax
  802698:	31 d2                	xor    %edx,%edx
  80269a:	f7 f6                	div    %esi
  80269c:	89 c6                	mov    %eax,%esi
  80269e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8026a1:	31 d2                	xor    %edx,%edx
  8026a3:	89 f8                	mov    %edi,%eax
  8026a5:	f7 f6                	div    %esi
  8026a7:	89 c7                	mov    %eax,%edi
  8026a9:	89 c8                	mov    %ecx,%eax
  8026ab:	f7 f6                	div    %esi
  8026ad:	89 c1                	mov    %eax,%ecx
  8026af:	89 fa                	mov    %edi,%edx
  8026b1:	89 c8                	mov    %ecx,%eax
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	5e                   	pop    %esi
  8026b7:	5f                   	pop    %edi
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    
  8026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026c0:	39 f8                	cmp    %edi,%eax
  8026c2:	77 1c                	ja     8026e0 <__udivdi3+0x70>
  8026c4:	0f bd d0             	bsr    %eax,%edx
  8026c7:	83 f2 1f             	xor    $0x1f,%edx
  8026ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8026cd:	75 39                	jne    802708 <__udivdi3+0x98>
  8026cf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8026d2:	0f 86 a0 00 00 00    	jbe    802778 <__udivdi3+0x108>
  8026d8:	39 f8                	cmp    %edi,%eax
  8026da:	0f 82 98 00 00 00    	jb     802778 <__udivdi3+0x108>
  8026e0:	31 ff                	xor    %edi,%edi
  8026e2:	31 c9                	xor    %ecx,%ecx
  8026e4:	89 c8                	mov    %ecx,%eax
  8026e6:	89 fa                	mov    %edi,%edx
  8026e8:	83 c4 10             	add    $0x10,%esp
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    
  8026ef:	90                   	nop
  8026f0:	89 d1                	mov    %edx,%ecx
  8026f2:	89 fa                	mov    %edi,%edx
  8026f4:	89 c8                	mov    %ecx,%eax
  8026f6:	31 ff                	xor    %edi,%edi
  8026f8:	f7 f6                	div    %esi
  8026fa:	89 c1                	mov    %eax,%ecx
  8026fc:	89 fa                	mov    %edi,%edx
  8026fe:	89 c8                	mov    %ecx,%eax
  802700:	83 c4 10             	add    $0x10,%esp
  802703:	5e                   	pop    %esi
  802704:	5f                   	pop    %edi
  802705:	5d                   	pop    %ebp
  802706:	c3                   	ret    
  802707:	90                   	nop
  802708:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80270c:	89 f2                	mov    %esi,%edx
  80270e:	d3 e0                	shl    %cl,%eax
  802710:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802713:	b8 20 00 00 00       	mov    $0x20,%eax
  802718:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80271b:	89 c1                	mov    %eax,%ecx
  80271d:	d3 ea                	shr    %cl,%edx
  80271f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802723:	0b 55 ec             	or     -0x14(%ebp),%edx
  802726:	d3 e6                	shl    %cl,%esi
  802728:	89 c1                	mov    %eax,%ecx
  80272a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80272d:	89 fe                	mov    %edi,%esi
  80272f:	d3 ee                	shr    %cl,%esi
  802731:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802735:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802738:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273b:	d3 e7                	shl    %cl,%edi
  80273d:	89 c1                	mov    %eax,%ecx
  80273f:	d3 ea                	shr    %cl,%edx
  802741:	09 d7                	or     %edx,%edi
  802743:	89 f2                	mov    %esi,%edx
  802745:	89 f8                	mov    %edi,%eax
  802747:	f7 75 ec             	divl   -0x14(%ebp)
  80274a:	89 d6                	mov    %edx,%esi
  80274c:	89 c7                	mov    %eax,%edi
  80274e:	f7 65 e8             	mull   -0x18(%ebp)
  802751:	39 d6                	cmp    %edx,%esi
  802753:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802756:	72 30                	jb     802788 <__udivdi3+0x118>
  802758:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80275f:	d3 e2                	shl    %cl,%edx
  802761:	39 c2                	cmp    %eax,%edx
  802763:	73 05                	jae    80276a <__udivdi3+0xfa>
  802765:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802768:	74 1e                	je     802788 <__udivdi3+0x118>
  80276a:	89 f9                	mov    %edi,%ecx
  80276c:	31 ff                	xor    %edi,%edi
  80276e:	e9 71 ff ff ff       	jmp    8026e4 <__udivdi3+0x74>
  802773:	90                   	nop
  802774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802778:	31 ff                	xor    %edi,%edi
  80277a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80277f:	e9 60 ff ff ff       	jmp    8026e4 <__udivdi3+0x74>
  802784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802788:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80278b:	31 ff                	xor    %edi,%edi
  80278d:	89 c8                	mov    %ecx,%eax
  80278f:	89 fa                	mov    %edi,%edx
  802791:	83 c4 10             	add    $0x10,%esp
  802794:	5e                   	pop    %esi
  802795:	5f                   	pop    %edi
  802796:	5d                   	pop    %ebp
  802797:	c3                   	ret    
	...

008027a0 <__umoddi3>:
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
  8027a3:	57                   	push   %edi
  8027a4:	56                   	push   %esi
  8027a5:	83 ec 20             	sub    $0x20,%esp
  8027a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8027ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8027b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027b4:	85 d2                	test   %edx,%edx
  8027b6:	89 c8                	mov    %ecx,%eax
  8027b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8027bb:	75 13                	jne    8027d0 <__umoddi3+0x30>
  8027bd:	39 f7                	cmp    %esi,%edi
  8027bf:	76 3f                	jbe    802800 <__umoddi3+0x60>
  8027c1:	89 f2                	mov    %esi,%edx
  8027c3:	f7 f7                	div    %edi
  8027c5:	89 d0                	mov    %edx,%eax
  8027c7:	31 d2                	xor    %edx,%edx
  8027c9:	83 c4 20             	add    $0x20,%esp
  8027cc:	5e                   	pop    %esi
  8027cd:	5f                   	pop    %edi
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    
  8027d0:	39 f2                	cmp    %esi,%edx
  8027d2:	77 4c                	ja     802820 <__umoddi3+0x80>
  8027d4:	0f bd ca             	bsr    %edx,%ecx
  8027d7:	83 f1 1f             	xor    $0x1f,%ecx
  8027da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8027dd:	75 51                	jne    802830 <__umoddi3+0x90>
  8027df:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8027e2:	0f 87 e0 00 00 00    	ja     8028c8 <__umoddi3+0x128>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	29 f8                	sub    %edi,%eax
  8027ed:	19 d6                	sbb    %edx,%esi
  8027ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	89 f2                	mov    %esi,%edx
  8027f7:	83 c4 20             	add    $0x20,%esp
  8027fa:	5e                   	pop    %esi
  8027fb:	5f                   	pop    %edi
  8027fc:	5d                   	pop    %ebp
  8027fd:	c3                   	ret    
  8027fe:	66 90                	xchg   %ax,%ax
  802800:	85 ff                	test   %edi,%edi
  802802:	75 0b                	jne    80280f <__umoddi3+0x6f>
  802804:	b8 01 00 00 00       	mov    $0x1,%eax
  802809:	31 d2                	xor    %edx,%edx
  80280b:	f7 f7                	div    %edi
  80280d:	89 c7                	mov    %eax,%edi
  80280f:	89 f0                	mov    %esi,%eax
  802811:	31 d2                	xor    %edx,%edx
  802813:	f7 f7                	div    %edi
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	f7 f7                	div    %edi
  80281a:	eb a9                	jmp    8027c5 <__umoddi3+0x25>
  80281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802820:	89 c8                	mov    %ecx,%eax
  802822:	89 f2                	mov    %esi,%edx
  802824:	83 c4 20             	add    $0x20,%esp
  802827:	5e                   	pop    %esi
  802828:	5f                   	pop    %edi
  802829:	5d                   	pop    %ebp
  80282a:	c3                   	ret    
  80282b:	90                   	nop
  80282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802830:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802834:	d3 e2                	shl    %cl,%edx
  802836:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802839:	ba 20 00 00 00       	mov    $0x20,%edx
  80283e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802841:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802844:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802848:	89 fa                	mov    %edi,%edx
  80284a:	d3 ea                	shr    %cl,%edx
  80284c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802850:	0b 55 f4             	or     -0xc(%ebp),%edx
  802853:	d3 e7                	shl    %cl,%edi
  802855:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802859:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80285c:	89 f2                	mov    %esi,%edx
  80285e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802861:	89 c7                	mov    %eax,%edi
  802863:	d3 ea                	shr    %cl,%edx
  802865:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802869:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80286c:	89 c2                	mov    %eax,%edx
  80286e:	d3 e6                	shl    %cl,%esi
  802870:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802874:	d3 ea                	shr    %cl,%edx
  802876:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80287a:	09 d6                	or     %edx,%esi
  80287c:	89 f0                	mov    %esi,%eax
  80287e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802881:	d3 e7                	shl    %cl,%edi
  802883:	89 f2                	mov    %esi,%edx
  802885:	f7 75 f4             	divl   -0xc(%ebp)
  802888:	89 d6                	mov    %edx,%esi
  80288a:	f7 65 e8             	mull   -0x18(%ebp)
  80288d:	39 d6                	cmp    %edx,%esi
  80288f:	72 2b                	jb     8028bc <__umoddi3+0x11c>
  802891:	39 c7                	cmp    %eax,%edi
  802893:	72 23                	jb     8028b8 <__umoddi3+0x118>
  802895:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802899:	29 c7                	sub    %eax,%edi
  80289b:	19 d6                	sbb    %edx,%esi
  80289d:	89 f0                	mov    %esi,%eax
  80289f:	89 f2                	mov    %esi,%edx
  8028a1:	d3 ef                	shr    %cl,%edi
  8028a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8028a7:	d3 e0                	shl    %cl,%eax
  8028a9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028ad:	09 f8                	or     %edi,%eax
  8028af:	d3 ea                	shr    %cl,%edx
  8028b1:	83 c4 20             	add    $0x20,%esp
  8028b4:	5e                   	pop    %esi
  8028b5:	5f                   	pop    %edi
  8028b6:	5d                   	pop    %ebp
  8028b7:	c3                   	ret    
  8028b8:	39 d6                	cmp    %edx,%esi
  8028ba:	75 d9                	jne    802895 <__umoddi3+0xf5>
  8028bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8028bf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8028c2:	eb d1                	jmp    802895 <__umoddi3+0xf5>
  8028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028c8:	39 f2                	cmp    %esi,%edx
  8028ca:	0f 82 18 ff ff ff    	jb     8027e8 <__umoddi3+0x48>
  8028d0:	e9 1d ff ff ff       	jmp    8027f2 <__umoddi3+0x52>
