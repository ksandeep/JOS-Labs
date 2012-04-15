
obj/user/hello:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	cprintf("hello, world\n");
  80003a:	c7 04 24 00 28 80 00 	movl   $0x802800,(%esp)
  800041:	e8 e7 00 00 00       	call   80012d <cprintf>
//	cprintf("test line \n\n");
	cprintf("i am environment %08x\n", env->env_id);
  800046:	a1 74 60 80 00       	mov    0x806074,%eax
  80004b:	8b 40 4c             	mov    0x4c(%eax),%eax
  80004e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800052:	c7 04 24 0e 28 80 00 	movl   $0x80280e,(%esp)
  800059:	e8 cf 00 00 00       	call   80012d <cprintf>
}
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	83 ec 18             	sub    $0x18,%esp
  800066:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800069:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80006c:	8b 75 08             	mov    0x8(%ebp),%esi
  80006f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800072:	e8 f7 0f 00 00       	call   80106e <sys_getenvid>
	env = &envs[ENVX(envid)];
  800077:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800084:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800089:	85 f6                	test   %esi,%esi
  80008b:	7e 07                	jle    800094 <libmain+0x34>
		binaryname = argv[0];
  80008d:	8b 03                	mov    (%ebx),%eax
  80008f:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800094:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800098:	89 34 24             	mov    %esi,(%esp)
  80009b:	e8 94 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000a0:	e8 0b 00 00 00       	call   8000b0 <exit>
}
  8000a5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000a8:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000ab:	89 ec                	mov    %ebp,%esp
  8000ad:	5d                   	pop    %ebp
  8000ae:	c3                   	ret    
	...

008000b0 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000b6:	e8 20 15 00 00       	call   8015db <close_all>
	sys_env_destroy(0);
  8000bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c2:	e8 db 0f 00 00       	call   8010a2 <sys_env_destroy>
}
  8000c7:	c9                   	leave  
  8000c8:	c3                   	ret    
  8000c9:	00 00                	add    %al,(%eax)
	...

008000cc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8000d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8000dc:	00 00 00 
	b.cnt = 0;
  8000df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8000e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8000e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	c7 04 24 47 01 80 00 	movl   $0x800147,(%esp)
  800108:	e8 d0 01 00 00       	call   8002dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80010d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800113:	89 44 24 04          	mov    %eax,0x4(%esp)
  800117:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 bb 0a 00 00       	call   800be0 <sys_cputs>

	return b.cnt;
}
  800125:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80012b:	c9                   	leave  
  80012c:	c3                   	ret    

0080012d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800133:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013a:	8b 45 08             	mov    0x8(%ebp),%eax
  80013d:	89 04 24             	mov    %eax,(%esp)
  800140:	e8 87 ff ff ff       	call   8000cc <vcprintf>
	va_end(ap);

	return cnt;
}
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	53                   	push   %ebx
  80014b:	83 ec 14             	sub    $0x14,%esp
  80014e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800151:	8b 03                	mov    (%ebx),%eax
  800153:	8b 55 08             	mov    0x8(%ebp),%edx
  800156:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80015a:	83 c0 01             	add    $0x1,%eax
  80015d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80015f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800164:	75 19                	jne    80017f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800166:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80016d:	00 
  80016e:	8d 43 08             	lea    0x8(%ebx),%eax
  800171:	89 04 24             	mov    %eax,(%esp)
  800174:	e8 67 0a 00 00       	call   800be0 <sys_cputs>
		b->idx = 0;
  800179:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80017f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800183:	83 c4 14             	add    $0x14,%esp
  800186:	5b                   	pop    %ebx
  800187:	5d                   	pop    %ebp
  800188:	c3                   	ret    
  800189:	00 00                	add    %al,(%eax)
  80018b:	00 00                	add    %al,(%eax)
  80018d:	00 00                	add    %al,(%eax)
	...

00800190 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 4c             	sub    $0x4c,%esp
  800199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80019c:	89 d6                	mov    %edx,%esi
  80019e:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001b0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001bb:	39 d1                	cmp    %edx,%ecx
  8001bd:	72 15                	jb     8001d4 <printnum+0x44>
  8001bf:	77 07                	ja     8001c8 <printnum+0x38>
  8001c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001c4:	39 d0                	cmp    %edx,%eax
  8001c6:	76 0c                	jbe    8001d4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001c8:	83 eb 01             	sub    $0x1,%ebx
  8001cb:	85 db                	test   %ebx,%ebx
  8001cd:	8d 76 00             	lea    0x0(%esi),%esi
  8001d0:	7f 61                	jg     800233 <printnum+0xa3>
  8001d2:	eb 70                	jmp    800244 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8001d8:	83 eb 01             	sub    $0x1,%ebx
  8001db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8001df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001e3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8001e7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8001eb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8001ee:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8001f1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8001f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001ff:	00 
  800200:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800203:	89 04 24             	mov    %eax,(%esp)
  800206:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800209:	89 54 24 04          	mov    %edx,0x4(%esp)
  80020d:	e8 6e 23 00 00       	call   802580 <__udivdi3>
  800212:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800215:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800218:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80021c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800220:	89 04 24             	mov    %eax,(%esp)
  800223:	89 54 24 04          	mov    %edx,0x4(%esp)
  800227:	89 f2                	mov    %esi,%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	e8 5f ff ff ff       	call   800190 <printnum>
  800231:	eb 11                	jmp    800244 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800233:	89 74 24 04          	mov    %esi,0x4(%esp)
  800237:	89 3c 24             	mov    %edi,(%esp)
  80023a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80023d:	83 eb 01             	sub    $0x1,%ebx
  800240:	85 db                	test   %ebx,%ebx
  800242:	7f ef                	jg     800233 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800244:	89 74 24 04          	mov    %esi,0x4(%esp)
  800248:	8b 74 24 04          	mov    0x4(%esp),%esi
  80024c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800253:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80025a:	00 
  80025b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80025e:	89 14 24             	mov    %edx,(%esp)
  800261:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800264:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800268:	e8 43 24 00 00       	call   8026b0 <__umoddi3>
  80026d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800271:	0f be 80 3c 28 80 00 	movsbl 0x80283c(%eax),%eax
  800278:	89 04 24             	mov    %eax,(%esp)
  80027b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80027e:	83 c4 4c             	add    $0x4c,%esp
  800281:	5b                   	pop    %ebx
  800282:	5e                   	pop    %esi
  800283:	5f                   	pop    %edi
  800284:	5d                   	pop    %ebp
  800285:	c3                   	ret    

00800286 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800289:	83 fa 01             	cmp    $0x1,%edx
  80028c:	7e 0e                	jle    80029c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80028e:	8b 10                	mov    (%eax),%edx
  800290:	8d 4a 08             	lea    0x8(%edx),%ecx
  800293:	89 08                	mov    %ecx,(%eax)
  800295:	8b 02                	mov    (%edx),%eax
  800297:	8b 52 04             	mov    0x4(%edx),%edx
  80029a:	eb 22                	jmp    8002be <getuint+0x38>
	else if (lflag)
  80029c:	85 d2                	test   %edx,%edx
  80029e:	74 10                	je     8002b0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002a0:	8b 10                	mov    (%eax),%edx
  8002a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002a5:	89 08                	mov    %ecx,(%eax)
  8002a7:	8b 02                	mov    (%edx),%eax
  8002a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ae:	eb 0e                	jmp    8002be <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002b0:	8b 10                	mov    (%eax),%edx
  8002b2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002b5:	89 08                	mov    %ecx,(%eax)
  8002b7:	8b 02                	mov    (%edx),%eax
  8002b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ca:	8b 10                	mov    (%eax),%edx
  8002cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002cf:	73 0a                	jae    8002db <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002d4:	88 0a                	mov    %cl,(%edx)
  8002d6:	83 c2 01             	add    $0x1,%edx
  8002d9:	89 10                	mov    %edx,(%eax)
}
  8002db:	5d                   	pop    %ebp
  8002dc:	c3                   	ret    

008002dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	57                   	push   %edi
  8002e1:	56                   	push   %esi
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 5c             	sub    $0x5c,%esp
  8002e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8002ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8002ef:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8002f6:	eb 11                	jmp    800309 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002f8:	85 c0                	test   %eax,%eax
  8002fa:	0f 84 ec 03 00 00    	je     8006ec <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800300:	89 74 24 04          	mov    %esi,0x4(%esp)
  800304:	89 04 24             	mov    %eax,(%esp)
  800307:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800309:	0f b6 03             	movzbl (%ebx),%eax
  80030c:	83 c3 01             	add    $0x1,%ebx
  80030f:	83 f8 25             	cmp    $0x25,%eax
  800312:	75 e4                	jne    8002f8 <vprintfmt+0x1b>
  800314:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800318:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80031f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800326:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80032d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800332:	eb 06                	jmp    80033a <vprintfmt+0x5d>
  800334:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800338:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	0f b6 13             	movzbl (%ebx),%edx
  80033d:	0f b6 c2             	movzbl %dl,%eax
  800340:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800343:	8d 43 01             	lea    0x1(%ebx),%eax
  800346:	83 ea 23             	sub    $0x23,%edx
  800349:	80 fa 55             	cmp    $0x55,%dl
  80034c:	0f 87 7d 03 00 00    	ja     8006cf <vprintfmt+0x3f2>
  800352:	0f b6 d2             	movzbl %dl,%edx
  800355:	ff 24 95 80 29 80 00 	jmp    *0x802980(,%edx,4)
  80035c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800360:	eb d6                	jmp    800338 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800362:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800365:	83 ea 30             	sub    $0x30,%edx
  800368:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80036b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80036e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800371:	83 fb 09             	cmp    $0x9,%ebx
  800374:	77 4c                	ja     8003c2 <vprintfmt+0xe5>
  800376:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800379:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80037c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80037f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800382:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800386:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800389:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80038c:	83 fb 09             	cmp    $0x9,%ebx
  80038f:	76 eb                	jbe    80037c <vprintfmt+0x9f>
  800391:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800394:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800397:	eb 29                	jmp    8003c2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800399:	8b 55 14             	mov    0x14(%ebp),%edx
  80039c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80039f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8003a2:	8b 12                	mov    (%edx),%edx
  8003a4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8003a7:	eb 19                	jmp    8003c2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8003a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003ac:	c1 fa 1f             	sar    $0x1f,%edx
  8003af:	f7 d2                	not    %edx
  8003b1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8003b4:	eb 82                	jmp    800338 <vprintfmt+0x5b>
  8003b6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003bd:	e9 76 ff ff ff       	jmp    800338 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8003c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003c6:	0f 89 6c ff ff ff    	jns    800338 <vprintfmt+0x5b>
  8003cc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8003cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8003d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8003d5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8003d8:	e9 5b ff ff ff       	jmp    800338 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003dd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8003e0:	e9 53 ff ff ff       	jmp    800338 <vprintfmt+0x5b>
  8003e5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	8d 50 04             	lea    0x4(%eax),%edx
  8003ee:	89 55 14             	mov    %edx,0x14(%ebp)
  8003f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	89 04 24             	mov    %eax,(%esp)
  8003fa:	ff d7                	call   *%edi
  8003fc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8003ff:	e9 05 ff ff ff       	jmp    800309 <vprintfmt+0x2c>
  800404:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8d 50 04             	lea    0x4(%eax),%edx
  80040d:	89 55 14             	mov    %edx,0x14(%ebp)
  800410:	8b 00                	mov    (%eax),%eax
  800412:	89 c2                	mov    %eax,%edx
  800414:	c1 fa 1f             	sar    $0x1f,%edx
  800417:	31 d0                	xor    %edx,%eax
  800419:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80041b:	83 f8 0f             	cmp    $0xf,%eax
  80041e:	7f 0b                	jg     80042b <vprintfmt+0x14e>
  800420:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  800427:	85 d2                	test   %edx,%edx
  800429:	75 20                	jne    80044b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80042b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80042f:	c7 44 24 08 4d 28 80 	movl   $0x80284d,0x8(%esp)
  800436:	00 
  800437:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043b:	89 3c 24             	mov    %edi,(%esp)
  80043e:	e8 31 03 00 00       	call   800774 <printfmt>
  800443:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800446:	e9 be fe ff ff       	jmp    800309 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80044b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80044f:	c7 44 24 08 26 2c 80 	movl   $0x802c26,0x8(%esp)
  800456:	00 
  800457:	89 74 24 04          	mov    %esi,0x4(%esp)
  80045b:	89 3c 24             	mov    %edi,(%esp)
  80045e:	e8 11 03 00 00       	call   800774 <printfmt>
  800463:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800466:	e9 9e fe ff ff       	jmp    800309 <vprintfmt+0x2c>
  80046b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80046e:	89 c3                	mov    %eax,%ebx
  800470:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800476:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	8d 50 04             	lea    0x4(%eax),%edx
  80047f:	89 55 14             	mov    %edx,0x14(%ebp)
  800482:	8b 00                	mov    (%eax),%eax
  800484:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800487:	85 c0                	test   %eax,%eax
  800489:	75 07                	jne    800492 <vprintfmt+0x1b5>
  80048b:	c7 45 e0 56 28 80 00 	movl   $0x802856,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800492:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800496:	7e 06                	jle    80049e <vprintfmt+0x1c1>
  800498:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80049c:	75 13                	jne    8004b1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a1:	0f be 02             	movsbl (%edx),%eax
  8004a4:	85 c0                	test   %eax,%eax
  8004a6:	0f 85 99 00 00 00    	jne    800545 <vprintfmt+0x268>
  8004ac:	e9 86 00 00 00       	jmp    800537 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b8:	89 0c 24             	mov    %ecx,(%esp)
  8004bb:	e8 fb 02 00 00       	call   8007bb <strnlen>
  8004c0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004c3:	29 c2                	sub    %eax,%edx
  8004c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004c8:	85 d2                	test   %edx,%edx
  8004ca:	7e d2                	jle    80049e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8004cc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8004d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8004d3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8004d6:	89 d3                	mov    %edx,%ebx
  8004d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004df:	89 04 24             	mov    %eax,(%esp)
  8004e2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e4:	83 eb 01             	sub    $0x1,%ebx
  8004e7:	85 db                	test   %ebx,%ebx
  8004e9:	7f ed                	jg     8004d8 <vprintfmt+0x1fb>
  8004eb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8004f5:	eb a7                	jmp    80049e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004fb:	74 18                	je     800515 <vprintfmt+0x238>
  8004fd:	8d 50 e0             	lea    -0x20(%eax),%edx
  800500:	83 fa 5e             	cmp    $0x5e,%edx
  800503:	76 10                	jbe    800515 <vprintfmt+0x238>
					putch('?', putdat);
  800505:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800509:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800510:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800513:	eb 0a                	jmp    80051f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800515:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800519:	89 04 24             	mov    %eax,(%esp)
  80051c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800523:	0f be 03             	movsbl (%ebx),%eax
  800526:	85 c0                	test   %eax,%eax
  800528:	74 05                	je     80052f <vprintfmt+0x252>
  80052a:	83 c3 01             	add    $0x1,%ebx
  80052d:	eb 29                	jmp    800558 <vprintfmt+0x27b>
  80052f:	89 fe                	mov    %edi,%esi
  800531:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800534:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80053b:	7f 2e                	jg     80056b <vprintfmt+0x28e>
  80053d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800540:	e9 c4 fd ff ff       	jmp    800309 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800545:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800548:	83 c2 01             	add    $0x1,%edx
  80054b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80054e:	89 f7                	mov    %esi,%edi
  800550:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800553:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800556:	89 d3                	mov    %edx,%ebx
  800558:	85 f6                	test   %esi,%esi
  80055a:	78 9b                	js     8004f7 <vprintfmt+0x21a>
  80055c:	83 ee 01             	sub    $0x1,%esi
  80055f:	79 96                	jns    8004f7 <vprintfmt+0x21a>
  800561:	89 fe                	mov    %edi,%esi
  800563:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800566:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800569:	eb cc                	jmp    800537 <vprintfmt+0x25a>
  80056b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80056e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800571:	89 74 24 04          	mov    %esi,0x4(%esp)
  800575:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80057c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80057e:	83 eb 01             	sub    $0x1,%ebx
  800581:	85 db                	test   %ebx,%ebx
  800583:	7f ec                	jg     800571 <vprintfmt+0x294>
  800585:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800588:	e9 7c fd ff ff       	jmp    800309 <vprintfmt+0x2c>
  80058d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800590:	83 f9 01             	cmp    $0x1,%ecx
  800593:	7e 16                	jle    8005ab <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 50 08             	lea    0x8(%eax),%edx
  80059b:	89 55 14             	mov    %edx,0x14(%ebp)
  80059e:	8b 10                	mov    (%eax),%edx
  8005a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8005a3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8005a6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005a9:	eb 32                	jmp    8005dd <vprintfmt+0x300>
	else if (lflag)
  8005ab:	85 c9                	test   %ecx,%ecx
  8005ad:	74 18                	je     8005c7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 50 04             	lea    0x4(%eax),%edx
  8005b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bd:	89 c1                	mov    %eax,%ecx
  8005bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c5:	eb 16                	jmp    8005dd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	89 c2                	mov    %eax,%edx
  8005d7:	c1 fa 1f             	sar    $0x1f,%edx
  8005da:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005dd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8005e0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005e3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005ec:	0f 89 9b 00 00 00    	jns    80068d <vprintfmt+0x3b0>
				putch('-', putdat);
  8005f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005fd:	ff d7                	call   *%edi
				num = -(long long) num;
  8005ff:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800602:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800605:	f7 d9                	neg    %ecx
  800607:	83 d3 00             	adc    $0x0,%ebx
  80060a:	f7 db                	neg    %ebx
  80060c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800611:	eb 7a                	jmp    80068d <vprintfmt+0x3b0>
  800613:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800616:	89 ca                	mov    %ecx,%edx
  800618:	8d 45 14             	lea    0x14(%ebp),%eax
  80061b:	e8 66 fc ff ff       	call   800286 <getuint>
  800620:	89 c1                	mov    %eax,%ecx
  800622:	89 d3                	mov    %edx,%ebx
  800624:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800629:	eb 62                	jmp    80068d <vprintfmt+0x3b0>
  80062b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80062e:	89 ca                	mov    %ecx,%edx
  800630:	8d 45 14             	lea    0x14(%ebp),%eax
  800633:	e8 4e fc ff ff       	call   800286 <getuint>
  800638:	89 c1                	mov    %eax,%ecx
  80063a:	89 d3                	mov    %edx,%ebx
  80063c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800641:	eb 4a                	jmp    80068d <vprintfmt+0x3b0>
  800643:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800646:	89 74 24 04          	mov    %esi,0x4(%esp)
  80064a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800651:	ff d7                	call   *%edi
			putch('x', putdat);
  800653:	89 74 24 04          	mov    %esi,0x4(%esp)
  800657:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80065e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8d 50 04             	lea    0x4(%eax),%edx
  800666:	89 55 14             	mov    %edx,0x14(%ebp)
  800669:	8b 08                	mov    (%eax),%ecx
  80066b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800670:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800675:	eb 16                	jmp    80068d <vprintfmt+0x3b0>
  800677:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80067a:	89 ca                	mov    %ecx,%edx
  80067c:	8d 45 14             	lea    0x14(%ebp),%eax
  80067f:	e8 02 fc ff ff       	call   800286 <getuint>
  800684:	89 c1                	mov    %eax,%ecx
  800686:	89 d3                	mov    %edx,%ebx
  800688:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80068d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800691:	89 54 24 10          	mov    %edx,0x10(%esp)
  800695:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800698:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80069c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006a0:	89 0c 24             	mov    %ecx,(%esp)
  8006a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006a7:	89 f2                	mov    %esi,%edx
  8006a9:	89 f8                	mov    %edi,%eax
  8006ab:	e8 e0 fa ff ff       	call   800190 <printnum>
  8006b0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006b3:	e9 51 fc ff ff       	jmp    800309 <vprintfmt+0x2c>
  8006b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8006bb:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c2:	89 14 24             	mov    %edx,(%esp)
  8006c5:	ff d7                	call   *%edi
  8006c7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006ca:	e9 3a fc ff ff       	jmp    800309 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006da:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8006df:	80 38 25             	cmpb   $0x25,(%eax)
  8006e2:	0f 84 21 fc ff ff    	je     800309 <vprintfmt+0x2c>
  8006e8:	89 c3                	mov    %eax,%ebx
  8006ea:	eb f0                	jmp    8006dc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8006ec:	83 c4 5c             	add    $0x5c,%esp
  8006ef:	5b                   	pop    %ebx
  8006f0:	5e                   	pop    %esi
  8006f1:	5f                   	pop    %edi
  8006f2:	5d                   	pop    %ebp
  8006f3:	c3                   	ret    

008006f4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 28             	sub    $0x28,%esp
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800700:	85 c0                	test   %eax,%eax
  800702:	74 04                	je     800708 <vsnprintf+0x14>
  800704:	85 d2                	test   %edx,%edx
  800706:	7f 07                	jg     80070f <vsnprintf+0x1b>
  800708:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070d:	eb 3b                	jmp    80074a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800712:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800716:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800719:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800727:	8b 45 10             	mov    0x10(%ebp),%eax
  80072a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80072e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800731:	89 44 24 04          	mov    %eax,0x4(%esp)
  800735:	c7 04 24 c0 02 80 00 	movl   $0x8002c0,(%esp)
  80073c:	e8 9c fb ff ff       	call   8002dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800744:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800747:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800752:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800755:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800760:	8b 45 0c             	mov    0xc(%ebp),%eax
  800763:	89 44 24 04          	mov    %eax,0x4(%esp)
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	89 04 24             	mov    %eax,(%esp)
  80076d:	e8 82 ff ff ff       	call   8006f4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80077a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80077d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800781:	8b 45 10             	mov    0x10(%ebp),%eax
  800784:	89 44 24 08          	mov    %eax,0x8(%esp)
  800788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	89 04 24             	mov    %eax,(%esp)
  800795:	e8 43 fb ff ff       	call   8002dd <vprintfmt>
	va_end(ap);
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    
  80079c:	00 00                	add    %al,(%eax)
	...

008007a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	80 3a 00             	cmpb   $0x0,(%edx)
  8007ae:	74 09                	je     8007b9 <strlen+0x19>
		n++;
  8007b0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b7:	75 f7                	jne    8007b0 <strlen+0x10>
		n++;
	return n;
}
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	53                   	push   %ebx
  8007bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c5:	85 c9                	test   %ecx,%ecx
  8007c7:	74 19                	je     8007e2 <strnlen+0x27>
  8007c9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8007cc:	74 14                	je     8007e2 <strnlen+0x27>
  8007ce:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8007d3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d6:	39 c8                	cmp    %ecx,%eax
  8007d8:	74 0d                	je     8007e7 <strnlen+0x2c>
  8007da:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8007de:	75 f3                	jne    8007d3 <strnlen+0x18>
  8007e0:	eb 05                	jmp    8007e7 <strnlen+0x2c>
  8007e2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8007e7:	5b                   	pop    %ebx
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	53                   	push   %ebx
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8007f4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007f9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8007fd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800800:	83 c2 01             	add    $0x1,%edx
  800803:	84 c9                	test   %cl,%cl
  800805:	75 f2                	jne    8007f9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800807:	5b                   	pop    %ebx
  800808:	5d                   	pop    %ebp
  800809:	c3                   	ret    

0080080a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	56                   	push   %esi
  80080e:	53                   	push   %ebx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	8b 55 0c             	mov    0xc(%ebp),%edx
  800815:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800818:	85 f6                	test   %esi,%esi
  80081a:	74 18                	je     800834 <strncpy+0x2a>
  80081c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800821:	0f b6 1a             	movzbl (%edx),%ebx
  800824:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800827:	80 3a 01             	cmpb   $0x1,(%edx)
  80082a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80082d:	83 c1 01             	add    $0x1,%ecx
  800830:	39 ce                	cmp    %ecx,%esi
  800832:	77 ed                	ja     800821 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800834:	5b                   	pop    %ebx
  800835:	5e                   	pop    %esi
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    

00800838 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	56                   	push   %esi
  80083c:	53                   	push   %ebx
  80083d:	8b 75 08             	mov    0x8(%ebp),%esi
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
  800843:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800846:	89 f0                	mov    %esi,%eax
  800848:	85 c9                	test   %ecx,%ecx
  80084a:	74 27                	je     800873 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80084c:	83 e9 01             	sub    $0x1,%ecx
  80084f:	74 1d                	je     80086e <strlcpy+0x36>
  800851:	0f b6 1a             	movzbl (%edx),%ebx
  800854:	84 db                	test   %bl,%bl
  800856:	74 16                	je     80086e <strlcpy+0x36>
			*dst++ = *src++;
  800858:	88 18                	mov    %bl,(%eax)
  80085a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80085d:	83 e9 01             	sub    $0x1,%ecx
  800860:	74 0e                	je     800870 <strlcpy+0x38>
			*dst++ = *src++;
  800862:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800865:	0f b6 1a             	movzbl (%edx),%ebx
  800868:	84 db                	test   %bl,%bl
  80086a:	75 ec                	jne    800858 <strlcpy+0x20>
  80086c:	eb 02                	jmp    800870 <strlcpy+0x38>
  80086e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800870:	c6 00 00             	movb   $0x0,(%eax)
  800873:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800875:	5b                   	pop    %ebx
  800876:	5e                   	pop    %esi
  800877:	5d                   	pop    %ebp
  800878:	c3                   	ret    

00800879 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800882:	0f b6 01             	movzbl (%ecx),%eax
  800885:	84 c0                	test   %al,%al
  800887:	74 15                	je     80089e <strcmp+0x25>
  800889:	3a 02                	cmp    (%edx),%al
  80088b:	75 11                	jne    80089e <strcmp+0x25>
		p++, q++;
  80088d:	83 c1 01             	add    $0x1,%ecx
  800890:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800893:	0f b6 01             	movzbl (%ecx),%eax
  800896:	84 c0                	test   %al,%al
  800898:	74 04                	je     80089e <strcmp+0x25>
  80089a:	3a 02                	cmp    (%edx),%al
  80089c:	74 ef                	je     80088d <strcmp+0x14>
  80089e:	0f b6 c0             	movzbl %al,%eax
  8008a1:	0f b6 12             	movzbl (%edx),%edx
  8008a4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	53                   	push   %ebx
  8008ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8008af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  8008b5:	85 c0                	test   %eax,%eax
  8008b7:	74 23                	je     8008dc <strncmp+0x34>
  8008b9:	0f b6 1a             	movzbl (%edx),%ebx
  8008bc:	84 db                	test   %bl,%bl
  8008be:	74 24                	je     8008e4 <strncmp+0x3c>
  8008c0:	3a 19                	cmp    (%ecx),%bl
  8008c2:	75 20                	jne    8008e4 <strncmp+0x3c>
  8008c4:	83 e8 01             	sub    $0x1,%eax
  8008c7:	74 13                	je     8008dc <strncmp+0x34>
		n--, p++, q++;
  8008c9:	83 c2 01             	add    $0x1,%edx
  8008cc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008cf:	0f b6 1a             	movzbl (%edx),%ebx
  8008d2:	84 db                	test   %bl,%bl
  8008d4:	74 0e                	je     8008e4 <strncmp+0x3c>
  8008d6:	3a 19                	cmp    (%ecx),%bl
  8008d8:	74 ea                	je     8008c4 <strncmp+0x1c>
  8008da:	eb 08                	jmp    8008e4 <strncmp+0x3c>
  8008dc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008e1:	5b                   	pop    %ebx
  8008e2:	5d                   	pop    %ebp
  8008e3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e4:	0f b6 02             	movzbl (%edx),%eax
  8008e7:	0f b6 11             	movzbl (%ecx),%edx
  8008ea:	29 d0                	sub    %edx,%eax
  8008ec:	eb f3                	jmp    8008e1 <strncmp+0x39>

008008ee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f8:	0f b6 10             	movzbl (%eax),%edx
  8008fb:	84 d2                	test   %dl,%dl
  8008fd:	74 15                	je     800914 <strchr+0x26>
		if (*s == c)
  8008ff:	38 ca                	cmp    %cl,%dl
  800901:	75 07                	jne    80090a <strchr+0x1c>
  800903:	eb 14                	jmp    800919 <strchr+0x2b>
  800905:	38 ca                	cmp    %cl,%dl
  800907:	90                   	nop
  800908:	74 0f                	je     800919 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80090a:	83 c0 01             	add    $0x1,%eax
  80090d:	0f b6 10             	movzbl (%eax),%edx
  800910:	84 d2                	test   %dl,%dl
  800912:	75 f1                	jne    800905 <strchr+0x17>
  800914:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800925:	0f b6 10             	movzbl (%eax),%edx
  800928:	84 d2                	test   %dl,%dl
  80092a:	74 18                	je     800944 <strfind+0x29>
		if (*s == c)
  80092c:	38 ca                	cmp    %cl,%dl
  80092e:	75 0a                	jne    80093a <strfind+0x1f>
  800930:	eb 12                	jmp    800944 <strfind+0x29>
  800932:	38 ca                	cmp    %cl,%dl
  800934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800938:	74 0a                	je     800944 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80093a:	83 c0 01             	add    $0x1,%eax
  80093d:	0f b6 10             	movzbl (%eax),%edx
  800940:	84 d2                	test   %dl,%dl
  800942:	75 ee                	jne    800932 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	83 ec 0c             	sub    $0xc,%esp
  80094c:	89 1c 24             	mov    %ebx,(%esp)
  80094f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800953:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800957:	8b 7d 08             	mov    0x8(%ebp),%edi
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800960:	85 c9                	test   %ecx,%ecx
  800962:	74 30                	je     800994 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800964:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80096a:	75 25                	jne    800991 <memset+0x4b>
  80096c:	f6 c1 03             	test   $0x3,%cl
  80096f:	75 20                	jne    800991 <memset+0x4b>
		c &= 0xFF;
  800971:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800974:	89 d3                	mov    %edx,%ebx
  800976:	c1 e3 08             	shl    $0x8,%ebx
  800979:	89 d6                	mov    %edx,%esi
  80097b:	c1 e6 18             	shl    $0x18,%esi
  80097e:	89 d0                	mov    %edx,%eax
  800980:	c1 e0 10             	shl    $0x10,%eax
  800983:	09 f0                	or     %esi,%eax
  800985:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800987:	09 d8                	or     %ebx,%eax
  800989:	c1 e9 02             	shr    $0x2,%ecx
  80098c:	fc                   	cld    
  80098d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80098f:	eb 03                	jmp    800994 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800991:	fc                   	cld    
  800992:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800994:	89 f8                	mov    %edi,%eax
  800996:	8b 1c 24             	mov    (%esp),%ebx
  800999:	8b 74 24 04          	mov    0x4(%esp),%esi
  80099d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009a1:	89 ec                	mov    %ebp,%esp
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	89 34 24             	mov    %esi,(%esp)
  8009ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8009b8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009bb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009bd:	39 c6                	cmp    %eax,%esi
  8009bf:	73 35                	jae    8009f6 <memmove+0x51>
  8009c1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c4:	39 d0                	cmp    %edx,%eax
  8009c6:	73 2e                	jae    8009f6 <memmove+0x51>
		s += n;
		d += n;
  8009c8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ca:	f6 c2 03             	test   $0x3,%dl
  8009cd:	75 1b                	jne    8009ea <memmove+0x45>
  8009cf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009d5:	75 13                	jne    8009ea <memmove+0x45>
  8009d7:	f6 c1 03             	test   $0x3,%cl
  8009da:	75 0e                	jne    8009ea <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8009dc:	83 ef 04             	sub    $0x4,%edi
  8009df:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e2:	c1 e9 02             	shr    $0x2,%ecx
  8009e5:	fd                   	std    
  8009e6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e8:	eb 09                	jmp    8009f3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009ea:	83 ef 01             	sub    $0x1,%edi
  8009ed:	8d 72 ff             	lea    -0x1(%edx),%esi
  8009f0:	fd                   	std    
  8009f1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f4:	eb 20                	jmp    800a16 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009fc:	75 15                	jne    800a13 <memmove+0x6e>
  8009fe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a04:	75 0d                	jne    800a13 <memmove+0x6e>
  800a06:	f6 c1 03             	test   $0x3,%cl
  800a09:	75 08                	jne    800a13 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a0b:	c1 e9 02             	shr    $0x2,%ecx
  800a0e:	fc                   	cld    
  800a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a11:	eb 03                	jmp    800a16 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a13:	fc                   	cld    
  800a14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a16:	8b 34 24             	mov    (%esp),%esi
  800a19:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a1d:	89 ec                	mov    %ebp,%esp
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	89 04 24             	mov    %eax,(%esp)
  800a3b:	e8 65 ff ff ff       	call   8009a5 <memmove>
}
  800a40:	c9                   	leave  
  800a41:	c3                   	ret    

00800a42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	57                   	push   %edi
  800a46:	56                   	push   %esi
  800a47:	53                   	push   %ebx
  800a48:	8b 75 08             	mov    0x8(%ebp),%esi
  800a4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a51:	85 c9                	test   %ecx,%ecx
  800a53:	74 36                	je     800a8b <memcmp+0x49>
		if (*s1 != *s2)
  800a55:	0f b6 06             	movzbl (%esi),%eax
  800a58:	0f b6 1f             	movzbl (%edi),%ebx
  800a5b:	38 d8                	cmp    %bl,%al
  800a5d:	74 20                	je     800a7f <memcmp+0x3d>
  800a5f:	eb 14                	jmp    800a75 <memcmp+0x33>
  800a61:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800a66:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800a6b:	83 c2 01             	add    $0x1,%edx
  800a6e:	83 e9 01             	sub    $0x1,%ecx
  800a71:	38 d8                	cmp    %bl,%al
  800a73:	74 12                	je     800a87 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800a75:	0f b6 c0             	movzbl %al,%eax
  800a78:	0f b6 db             	movzbl %bl,%ebx
  800a7b:	29 d8                	sub    %ebx,%eax
  800a7d:	eb 11                	jmp    800a90 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a7f:	83 e9 01             	sub    $0x1,%ecx
  800a82:	ba 00 00 00 00       	mov    $0x0,%edx
  800a87:	85 c9                	test   %ecx,%ecx
  800a89:	75 d6                	jne    800a61 <memcmp+0x1f>
  800a8b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800a90:	5b                   	pop    %ebx
  800a91:	5e                   	pop    %esi
  800a92:	5f                   	pop    %edi
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800a9b:	89 c2                	mov    %eax,%edx
  800a9d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa0:	39 d0                	cmp    %edx,%eax
  800aa2:	73 15                	jae    800ab9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800aa8:	38 08                	cmp    %cl,(%eax)
  800aaa:	75 06                	jne    800ab2 <memfind+0x1d>
  800aac:	eb 0b                	jmp    800ab9 <memfind+0x24>
  800aae:	38 08                	cmp    %cl,(%eax)
  800ab0:	74 07                	je     800ab9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ab2:	83 c0 01             	add    $0x1,%eax
  800ab5:	39 c2                	cmp    %eax,%edx
  800ab7:	77 f5                	ja     800aae <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	57                   	push   %edi
  800abf:	56                   	push   %esi
  800ac0:	53                   	push   %ebx
  800ac1:	83 ec 04             	sub    $0x4,%esp
  800ac4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aca:	0f b6 02             	movzbl (%edx),%eax
  800acd:	3c 20                	cmp    $0x20,%al
  800acf:	74 04                	je     800ad5 <strtol+0x1a>
  800ad1:	3c 09                	cmp    $0x9,%al
  800ad3:	75 0e                	jne    800ae3 <strtol+0x28>
		s++;
  800ad5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ad8:	0f b6 02             	movzbl (%edx),%eax
  800adb:	3c 20                	cmp    $0x20,%al
  800add:	74 f6                	je     800ad5 <strtol+0x1a>
  800adf:	3c 09                	cmp    $0x9,%al
  800ae1:	74 f2                	je     800ad5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ae3:	3c 2b                	cmp    $0x2b,%al
  800ae5:	75 0c                	jne    800af3 <strtol+0x38>
		s++;
  800ae7:	83 c2 01             	add    $0x1,%edx
  800aea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800af1:	eb 15                	jmp    800b08 <strtol+0x4d>
	else if (*s == '-')
  800af3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800afa:	3c 2d                	cmp    $0x2d,%al
  800afc:	75 0a                	jne    800b08 <strtol+0x4d>
		s++, neg = 1;
  800afe:	83 c2 01             	add    $0x1,%edx
  800b01:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b08:	85 db                	test   %ebx,%ebx
  800b0a:	0f 94 c0             	sete   %al
  800b0d:	74 05                	je     800b14 <strtol+0x59>
  800b0f:	83 fb 10             	cmp    $0x10,%ebx
  800b12:	75 18                	jne    800b2c <strtol+0x71>
  800b14:	80 3a 30             	cmpb   $0x30,(%edx)
  800b17:	75 13                	jne    800b2c <strtol+0x71>
  800b19:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b1d:	8d 76 00             	lea    0x0(%esi),%esi
  800b20:	75 0a                	jne    800b2c <strtol+0x71>
		s += 2, base = 16;
  800b22:	83 c2 02             	add    $0x2,%edx
  800b25:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2a:	eb 15                	jmp    800b41 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b2c:	84 c0                	test   %al,%al
  800b2e:	66 90                	xchg   %ax,%ax
  800b30:	74 0f                	je     800b41 <strtol+0x86>
  800b32:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b37:	80 3a 30             	cmpb   $0x30,(%edx)
  800b3a:	75 05                	jne    800b41 <strtol+0x86>
		s++, base = 8;
  800b3c:	83 c2 01             	add    $0x1,%edx
  800b3f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b41:	b8 00 00 00 00       	mov    $0x0,%eax
  800b46:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b48:	0f b6 0a             	movzbl (%edx),%ecx
  800b4b:	89 cf                	mov    %ecx,%edi
  800b4d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b50:	80 fb 09             	cmp    $0x9,%bl
  800b53:	77 08                	ja     800b5d <strtol+0xa2>
			dig = *s - '0';
  800b55:	0f be c9             	movsbl %cl,%ecx
  800b58:	83 e9 30             	sub    $0x30,%ecx
  800b5b:	eb 1e                	jmp    800b7b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800b5d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800b60:	80 fb 19             	cmp    $0x19,%bl
  800b63:	77 08                	ja     800b6d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800b65:	0f be c9             	movsbl %cl,%ecx
  800b68:	83 e9 57             	sub    $0x57,%ecx
  800b6b:	eb 0e                	jmp    800b7b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800b6d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800b70:	80 fb 19             	cmp    $0x19,%bl
  800b73:	77 15                	ja     800b8a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800b75:	0f be c9             	movsbl %cl,%ecx
  800b78:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b7b:	39 f1                	cmp    %esi,%ecx
  800b7d:	7d 0b                	jge    800b8a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800b7f:	83 c2 01             	add    $0x1,%edx
  800b82:	0f af c6             	imul   %esi,%eax
  800b85:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800b88:	eb be                	jmp    800b48 <strtol+0x8d>
  800b8a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800b8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b90:	74 05                	je     800b97 <strtol+0xdc>
		*endptr = (char *) s;
  800b92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b95:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800b97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b9b:	74 04                	je     800ba1 <strtol+0xe6>
  800b9d:	89 c8                	mov    %ecx,%eax
  800b9f:	f7 d8                	neg    %eax
}
  800ba1:	83 c4 04             	add    $0x4,%esp
  800ba4:	5b                   	pop    %ebx
  800ba5:	5e                   	pop    %esi
  800ba6:	5f                   	pop    %edi
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    
  800ba9:	00 00                	add    %al,(%eax)
	...

00800bac <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 0c             	sub    $0xc,%esp
  800bb2:	89 1c 24             	mov    %ebx,(%esp)
  800bb5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bb9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bc7:	89 d1                	mov    %edx,%ecx
  800bc9:	89 d3                	mov    %edx,%ebx
  800bcb:	89 d7                	mov    %edx,%edi
  800bcd:	89 d6                	mov    %edx,%esi
  800bcf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bd1:	8b 1c 24             	mov    (%esp),%ebx
  800bd4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bd8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bdc:	89 ec                	mov    %ebp,%esp
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	89 1c 24             	mov    %ebx,(%esp)
  800be9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bed:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	89 c3                	mov    %eax,%ebx
  800bfe:	89 c7                	mov    %eax,%edi
  800c00:	89 c6                	mov    %eax,%esi
  800c02:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c04:	8b 1c 24             	mov    (%esp),%ebx
  800c07:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c0b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c0f:	89 ec                	mov    %ebp,%esp
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	83 ec 38             	sub    $0x38,%esp
  800c19:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c1f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c22:	be 00 00 00 00       	mov    $0x0,%esi
  800c27:	b8 12 00 00 00       	mov    $0x12,%eax
  800c2c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c35:	8b 55 08             	mov    0x8(%ebp),%edx
  800c38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800c3a:	85 c0                	test   %eax,%eax
  800c3c:	7e 28                	jle    800c66 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c42:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800c49:	00 
  800c4a:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800c51:	00 
  800c52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c59:	00 
  800c5a:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800c61:	e8 96 17 00 00       	call   8023fc <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800c66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c6f:	89 ec                	mov    %ebp,%esp
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	89 1c 24             	mov    %ebx,(%esp)
  800c7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c80:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c89:	b8 11 00 00 00       	mov    $0x11,%eax
  800c8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	89 df                	mov    %ebx,%edi
  800c96:	89 de                	mov    %ebx,%esi
  800c98:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800c9a:	8b 1c 24             	mov    (%esp),%ebx
  800c9d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ca1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ca5:	89 ec                	mov    %ebp,%esp
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	89 1c 24             	mov    %ebx,(%esp)
  800cb2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cb6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbf:	b8 10 00 00 00       	mov    $0x10,%eax
  800cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc7:	89 cb                	mov    %ecx,%ebx
  800cc9:	89 cf                	mov    %ecx,%edi
  800ccb:	89 ce                	mov    %ecx,%esi
  800ccd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800ccf:	8b 1c 24             	mov    (%esp),%ebx
  800cd2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cd6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cda:	89 ec                	mov    %ebp,%esp
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    

00800cde <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 38             	sub    $0x38,%esp
  800ce4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ce7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800cea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800cf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfd:	89 df                	mov    %ebx,%edi
  800cff:	89 de                	mov    %ebx,%esi
  800d01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7e 28                	jle    800d2f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d12:	00 
  800d13:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800d1a:	00 
  800d1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d22:	00 
  800d23:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800d2a:	e8 cd 16 00 00       	call   8023fc <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800d2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d38:	89 ec                	mov    %ebp,%esp
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	89 1c 24             	mov    %ebx,(%esp)
  800d45:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d49:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d52:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d57:	89 d1                	mov    %edx,%ecx
  800d59:	89 d3                	mov    %edx,%ebx
  800d5b:	89 d7                	mov    %edx,%edi
  800d5d:	89 d6                	mov    %edx,%esi
  800d5f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800d61:	8b 1c 24             	mov    (%esp),%ebx
  800d64:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d68:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d6c:	89 ec                	mov    %ebp,%esp
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 38             	sub    $0x38,%esp
  800d76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d79:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d84:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	89 cb                	mov    %ecx,%ebx
  800d8e:	89 cf                	mov    %ecx,%edi
  800d90:	89 ce                	mov    %ecx,%esi
  800d92:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7e 28                	jle    800dc0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800da3:	00 
  800da4:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800dab:	00 
  800dac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db3:	00 
  800db4:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800dbb:	e8 3c 16 00 00       	call   8023fc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dc0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dc3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dc6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dc9:	89 ec                	mov    %ebp,%esp
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 0c             	sub    $0xc,%esp
  800dd3:	89 1c 24             	mov    %ebx,(%esp)
  800dd6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dda:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dde:	be 00 00 00 00       	mov    $0x0,%esi
  800de3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800deb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df6:	8b 1c 24             	mov    (%esp),%ebx
  800df9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dfd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e01:	89 ec                	mov    %ebp,%esp
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 38             	sub    $0x38,%esp
  800e0b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e0e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e11:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e19:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	89 df                	mov    %ebx,%edi
  800e26:	89 de                	mov    %ebx,%esi
  800e28:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	7e 28                	jle    800e56 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e32:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e39:	00 
  800e3a:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800e41:	00 
  800e42:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e49:	00 
  800e4a:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800e51:	e8 a6 15 00 00       	call   8023fc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e59:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e5c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e5f:	89 ec                	mov    %ebp,%esp
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 38             	sub    $0x38,%esp
  800e69:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e77:	b8 09 00 00 00       	mov    $0x9,%eax
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	89 df                	mov    %ebx,%edi
  800e84:	89 de                	mov    %ebx,%esi
  800e86:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	7e 28                	jle    800eb4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e90:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e97:	00 
  800e98:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800e9f:	00 
  800ea0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea7:	00 
  800ea8:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800eaf:	e8 48 15 00 00       	call   8023fc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ebd:	89 ec                	mov    %ebp,%esp
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    

00800ec1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 38             	sub    $0x38,%esp
  800ec7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eca:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ecd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed5:	b8 08 00 00 00       	mov    $0x8,%eax
  800eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	89 df                	mov    %ebx,%edi
  800ee2:	89 de                	mov    %ebx,%esi
  800ee4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	7e 28                	jle    800f12 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eea:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eee:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ef5:	00 
  800ef6:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800efd:	00 
  800efe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f05:	00 
  800f06:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800f0d:	e8 ea 14 00 00       	call   8023fc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f12:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f15:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f18:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f1b:	89 ec                	mov    %ebp,%esp
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	83 ec 38             	sub    $0x38,%esp
  800f25:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f28:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f2b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f33:	b8 06 00 00 00       	mov    $0x6,%eax
  800f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	89 df                	mov    %ebx,%edi
  800f40:	89 de                	mov    %ebx,%esi
  800f42:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f44:	85 c0                	test   %eax,%eax
  800f46:	7e 28                	jle    800f70 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f48:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f53:	00 
  800f54:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800f5b:	00 
  800f5c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f63:	00 
  800f64:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800f6b:	e8 8c 14 00 00       	call   8023fc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f70:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f73:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f76:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f79:	89 ec                	mov    %ebp,%esp
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 38             	sub    $0x38,%esp
  800f83:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f86:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f89:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8c:	b8 05 00 00 00       	mov    $0x5,%eax
  800f91:	8b 75 18             	mov    0x18(%ebp),%esi
  800f94:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	7e 28                	jle    800fce <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800faa:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fb1:	00 
  800fb2:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  800fb9:	00 
  800fba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc1:	00 
  800fc2:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  800fc9:	e8 2e 14 00 00       	call   8023fc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fd4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fd7:	89 ec                	mov    %ebp,%esp
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 38             	sub    $0x38,%esp
  800fe1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fe4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fea:	be 00 00 00 00       	mov    $0x0,%esi
  800fef:	b8 04 00 00 00       	mov    $0x4,%eax
  800ff4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	89 f7                	mov    %esi,%edi
  800fff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801001:	85 c0                	test   %eax,%eax
  801003:	7e 28                	jle    80102d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801005:	89 44 24 10          	mov    %eax,0x10(%esp)
  801009:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801010:	00 
  801011:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  801018:	00 
  801019:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801020:	00 
  801021:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  801028:	e8 cf 13 00 00       	call   8023fc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80102d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801030:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801033:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801036:	89 ec                	mov    %ebp,%esp
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 0c             	sub    $0xc,%esp
  801040:	89 1c 24             	mov    %ebx,(%esp)
  801043:	89 74 24 04          	mov    %esi,0x4(%esp)
  801047:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104b:	ba 00 00 00 00       	mov    $0x0,%edx
  801050:	b8 0b 00 00 00       	mov    $0xb,%eax
  801055:	89 d1                	mov    %edx,%ecx
  801057:	89 d3                	mov    %edx,%ebx
  801059:	89 d7                	mov    %edx,%edi
  80105b:	89 d6                	mov    %edx,%esi
  80105d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80105f:	8b 1c 24             	mov    (%esp),%ebx
  801062:	8b 74 24 04          	mov    0x4(%esp),%esi
  801066:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80106a:	89 ec                	mov    %ebp,%esp
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    

0080106e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	89 1c 24             	mov    %ebx,(%esp)
  801077:	89 74 24 04          	mov    %esi,0x4(%esp)
  80107b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107f:	ba 00 00 00 00       	mov    $0x0,%edx
  801084:	b8 02 00 00 00       	mov    $0x2,%eax
  801089:	89 d1                	mov    %edx,%ecx
  80108b:	89 d3                	mov    %edx,%ebx
  80108d:	89 d7                	mov    %edx,%edi
  80108f:	89 d6                	mov    %edx,%esi
  801091:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801093:	8b 1c 24             	mov    (%esp),%ebx
  801096:	8b 74 24 04          	mov    0x4(%esp),%esi
  80109a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80109e:	89 ec                	mov    %ebp,%esp
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    

008010a2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 38             	sub    $0x38,%esp
  8010a8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ab:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ae:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b6:	b8 03 00 00 00       	mov    $0x3,%eax
  8010bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010be:	89 cb                	mov    %ecx,%ebx
  8010c0:	89 cf                	mov    %ecx,%edi
  8010c2:	89 ce                	mov    %ecx,%esi
  8010c4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	7e 28                	jle    8010f2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ce:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010d5:	00 
  8010d6:	c7 44 24 08 3f 2b 80 	movl   $0x802b3f,0x8(%esp)
  8010dd:	00 
  8010de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e5:	00 
  8010e6:	c7 04 24 5c 2b 80 00 	movl   $0x802b5c,(%esp)
  8010ed:	e8 0a 13 00 00       	call   8023fc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010fb:	89 ec                	mov    %ebp,%esp
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    
	...

00801100 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	05 00 00 00 30       	add    $0x30000000,%eax
  80110b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	89 04 24             	mov    %eax,(%esp)
  80111c:	e8 df ff ff ff       	call   801100 <fd2num>
  801121:	05 20 00 0d 00       	add    $0xd0020,%eax
  801126:	c1 e0 0c             	shl    $0xc,%eax
}
  801129:	c9                   	leave  
  80112a:	c3                   	ret    

0080112b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
  801131:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801134:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801139:	a8 01                	test   $0x1,%al
  80113b:	74 36                	je     801173 <fd_alloc+0x48>
  80113d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801142:	a8 01                	test   $0x1,%al
  801144:	74 2d                	je     801173 <fd_alloc+0x48>
  801146:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80114b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801150:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801155:	89 c3                	mov    %eax,%ebx
  801157:	89 c2                	mov    %eax,%edx
  801159:	c1 ea 16             	shr    $0x16,%edx
  80115c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80115f:	f6 c2 01             	test   $0x1,%dl
  801162:	74 14                	je     801178 <fd_alloc+0x4d>
  801164:	89 c2                	mov    %eax,%edx
  801166:	c1 ea 0c             	shr    $0xc,%edx
  801169:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80116c:	f6 c2 01             	test   $0x1,%dl
  80116f:	75 10                	jne    801181 <fd_alloc+0x56>
  801171:	eb 05                	jmp    801178 <fd_alloc+0x4d>
  801173:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801178:	89 1f                	mov    %ebx,(%edi)
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80117f:	eb 17                	jmp    801198 <fd_alloc+0x6d>
  801181:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801186:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80118b:	75 c8                	jne    801155 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80118d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801193:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801198:	5b                   	pop    %ebx
  801199:	5e                   	pop    %esi
  80119a:	5f                   	pop    %edi
  80119b:	5d                   	pop    %ebp
  80119c:	c3                   	ret    

0080119d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	83 f8 1f             	cmp    $0x1f,%eax
  8011a6:	77 36                	ja     8011de <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011a8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8011ad:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	c1 ea 16             	shr    $0x16,%edx
  8011b5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011bc:	f6 c2 01             	test   $0x1,%dl
  8011bf:	74 1d                	je     8011de <fd_lookup+0x41>
  8011c1:	89 c2                	mov    %eax,%edx
  8011c3:	c1 ea 0c             	shr    $0xc,%edx
  8011c6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011cd:	f6 c2 01             	test   $0x1,%dl
  8011d0:	74 0c                	je     8011de <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d5:	89 02                	mov    %eax,(%edx)
  8011d7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8011dc:	eb 05                	jmp    8011e3 <fd_lookup+0x46>
  8011de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    

008011e5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011eb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	89 04 24             	mov    %eax,(%esp)
  8011f8:	e8 a0 ff ff ff       	call   80119d <fd_lookup>
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	78 0e                	js     80120f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801201:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801204:	8b 55 0c             	mov    0xc(%ebp),%edx
  801207:	89 50 04             	mov    %edx,0x4(%eax)
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
  801216:	83 ec 10             	sub    $0x10,%esp
  801219:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80121f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801224:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801229:	be e8 2b 80 00       	mov    $0x802be8,%esi
		if (devtab[i]->dev_id == dev_id) {
  80122e:	39 08                	cmp    %ecx,(%eax)
  801230:	75 10                	jne    801242 <dev_lookup+0x31>
  801232:	eb 04                	jmp    801238 <dev_lookup+0x27>
  801234:	39 08                	cmp    %ecx,(%eax)
  801236:	75 0a                	jne    801242 <dev_lookup+0x31>
			*dev = devtab[i];
  801238:	89 03                	mov    %eax,(%ebx)
  80123a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80123f:	90                   	nop
  801240:	eb 31                	jmp    801273 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801242:	83 c2 01             	add    $0x1,%edx
  801245:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801248:	85 c0                	test   %eax,%eax
  80124a:	75 e8                	jne    801234 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80124c:	a1 74 60 80 00       	mov    0x806074,%eax
  801251:	8b 40 4c             	mov    0x4c(%eax),%eax
  801254:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125c:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  801263:	e8 c5 ee ff ff       	call   80012d <cprintf>
	*dev = 0;
  801268:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80126e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	5b                   	pop    %ebx
  801277:	5e                   	pop    %esi
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    

0080127a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	53                   	push   %ebx
  80127e:	83 ec 24             	sub    $0x24,%esp
  801281:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801284:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	89 04 24             	mov    %eax,(%esp)
  801291:	e8 07 ff ff ff       	call   80119d <fd_lookup>
  801296:	85 c0                	test   %eax,%eax
  801298:	78 53                	js     8012ed <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80129a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a4:	8b 00                	mov    (%eax),%eax
  8012a6:	89 04 24             	mov    %eax,(%esp)
  8012a9:	e8 63 ff ff ff       	call   801211 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 3b                	js     8012ed <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8012b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ba:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8012be:	74 2d                	je     8012ed <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012c0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012c3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012ca:	00 00 00 
	stat->st_isdir = 0;
  8012cd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012d4:	00 00 00 
	stat->st_dev = dev;
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012da:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012e7:	89 14 24             	mov    %edx,(%esp)
  8012ea:	ff 50 14             	call   *0x14(%eax)
}
  8012ed:	83 c4 24             	add    $0x24,%esp
  8012f0:	5b                   	pop    %ebx
  8012f1:	5d                   	pop    %ebp
  8012f2:	c3                   	ret    

008012f3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	53                   	push   %ebx
  8012f7:	83 ec 24             	sub    $0x24,%esp
  8012fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801300:	89 44 24 04          	mov    %eax,0x4(%esp)
  801304:	89 1c 24             	mov    %ebx,(%esp)
  801307:	e8 91 fe ff ff       	call   80119d <fd_lookup>
  80130c:	85 c0                	test   %eax,%eax
  80130e:	78 5f                	js     80136f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801310:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801313:	89 44 24 04          	mov    %eax,0x4(%esp)
  801317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131a:	8b 00                	mov    (%eax),%eax
  80131c:	89 04 24             	mov    %eax,(%esp)
  80131f:	e8 ed fe ff ff       	call   801211 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801324:	85 c0                	test   %eax,%eax
  801326:	78 47                	js     80136f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801328:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80132b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80132f:	75 23                	jne    801354 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801331:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801336:	8b 40 4c             	mov    0x4c(%eax),%eax
  801339:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80133d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801341:	c7 04 24 8c 2b 80 00 	movl   $0x802b8c,(%esp)
  801348:	e8 e0 ed ff ff       	call   80012d <cprintf>
  80134d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801352:	eb 1b                	jmp    80136f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801357:	8b 48 18             	mov    0x18(%eax),%ecx
  80135a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80135f:	85 c9                	test   %ecx,%ecx
  801361:	74 0c                	je     80136f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136a:	89 14 24             	mov    %edx,(%esp)
  80136d:	ff d1                	call   *%ecx
}
  80136f:	83 c4 24             	add    $0x24,%esp
  801372:	5b                   	pop    %ebx
  801373:	5d                   	pop    %ebp
  801374:	c3                   	ret    

00801375 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	53                   	push   %ebx
  801379:	83 ec 24             	sub    $0x24,%esp
  80137c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801382:	89 44 24 04          	mov    %eax,0x4(%esp)
  801386:	89 1c 24             	mov    %ebx,(%esp)
  801389:	e8 0f fe ff ff       	call   80119d <fd_lookup>
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 66                	js     8013f8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801392:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801395:	89 44 24 04          	mov    %eax,0x4(%esp)
  801399:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139c:	8b 00                	mov    (%eax),%eax
  80139e:	89 04 24             	mov    %eax,(%esp)
  8013a1:	e8 6b fe ff ff       	call   801211 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 4e                	js     8013f8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ad:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8013b1:	75 23                	jne    8013d6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8013b3:	a1 74 60 80 00       	mov    0x806074,%eax
  8013b8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c3:	c7 04 24 ad 2b 80 00 	movl   $0x802bad,(%esp)
  8013ca:	e8 5e ed ff ff       	call   80012d <cprintf>
  8013cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8013d4:	eb 22                	jmp    8013f8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8013dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e1:	85 c9                	test   %ecx,%ecx
  8013e3:	74 13                	je     8013f8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f3:	89 14 24             	mov    %edx,(%esp)
  8013f6:	ff d1                	call   *%ecx
}
  8013f8:	83 c4 24             	add    $0x24,%esp
  8013fb:	5b                   	pop    %ebx
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	53                   	push   %ebx
  801402:	83 ec 24             	sub    $0x24,%esp
  801405:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801408:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140f:	89 1c 24             	mov    %ebx,(%esp)
  801412:	e8 86 fd ff ff       	call   80119d <fd_lookup>
  801417:	85 c0                	test   %eax,%eax
  801419:	78 6b                	js     801486 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801425:	8b 00                	mov    (%eax),%eax
  801427:	89 04 24             	mov    %eax,(%esp)
  80142a:	e8 e2 fd ff ff       	call   801211 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 53                	js     801486 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801436:	8b 42 08             	mov    0x8(%edx),%eax
  801439:	83 e0 03             	and    $0x3,%eax
  80143c:	83 f8 01             	cmp    $0x1,%eax
  80143f:	75 23                	jne    801464 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801441:	a1 74 60 80 00       	mov    0x806074,%eax
  801446:	8b 40 4c             	mov    0x4c(%eax),%eax
  801449:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80144d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801451:	c7 04 24 ca 2b 80 00 	movl   $0x802bca,(%esp)
  801458:	e8 d0 ec ff ff       	call   80012d <cprintf>
  80145d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801462:	eb 22                	jmp    801486 <read+0x88>
	}
	if (!dev->dev_read)
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	8b 48 08             	mov    0x8(%eax),%ecx
  80146a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146f:	85 c9                	test   %ecx,%ecx
  801471:	74 13                	je     801486 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	89 44 24 08          	mov    %eax,0x8(%esp)
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801481:	89 14 24             	mov    %edx,(%esp)
  801484:	ff d1                	call   *%ecx
}
  801486:	83 c4 24             	add    $0x24,%esp
  801489:	5b                   	pop    %ebx
  80148a:	5d                   	pop    %ebp
  80148b:	c3                   	ret    

0080148c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	57                   	push   %edi
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	83 ec 1c             	sub    $0x1c,%esp
  801495:	8b 7d 08             	mov    0x8(%ebp),%edi
  801498:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80149b:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	85 f6                	test   %esi,%esi
  8014ac:	74 29                	je     8014d7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ae:	89 f0                	mov    %esi,%eax
  8014b0:	29 d0                	sub    %edx,%eax
  8014b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014b6:	03 55 0c             	add    0xc(%ebp),%edx
  8014b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014bd:	89 3c 24             	mov    %edi,(%esp)
  8014c0:	e8 39 ff ff ff       	call   8013fe <read>
		if (m < 0)
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 0e                	js     8014d7 <readn+0x4b>
			return m;
		if (m == 0)
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	74 08                	je     8014d5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014cd:	01 c3                	add    %eax,%ebx
  8014cf:	89 da                	mov    %ebx,%edx
  8014d1:	39 f3                	cmp    %esi,%ebx
  8014d3:	72 d9                	jb     8014ae <readn+0x22>
  8014d5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014d7:	83 c4 1c             	add    $0x1c,%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5f                   	pop    %edi
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    

008014df <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	56                   	push   %esi
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 20             	sub    $0x20,%esp
  8014e7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014ea:	89 34 24             	mov    %esi,(%esp)
  8014ed:	e8 0e fc ff ff       	call   801100 <fd2num>
  8014f2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014f9:	89 04 24             	mov    %eax,(%esp)
  8014fc:	e8 9c fc ff ff       	call   80119d <fd_lookup>
  801501:	89 c3                	mov    %eax,%ebx
  801503:	85 c0                	test   %eax,%eax
  801505:	78 05                	js     80150c <fd_close+0x2d>
  801507:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80150a:	74 0c                	je     801518 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80150c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801510:	19 c0                	sbb    %eax,%eax
  801512:	f7 d0                	not    %eax
  801514:	21 c3                	and    %eax,%ebx
  801516:	eb 3d                	jmp    801555 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801518:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151f:	8b 06                	mov    (%esi),%eax
  801521:	89 04 24             	mov    %eax,(%esp)
  801524:	e8 e8 fc ff ff       	call   801211 <dev_lookup>
  801529:	89 c3                	mov    %eax,%ebx
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 16                	js     801545 <fd_close+0x66>
		if (dev->dev_close)
  80152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801532:	8b 40 10             	mov    0x10(%eax),%eax
  801535:	bb 00 00 00 00       	mov    $0x0,%ebx
  80153a:	85 c0                	test   %eax,%eax
  80153c:	74 07                	je     801545 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80153e:	89 34 24             	mov    %esi,(%esp)
  801541:	ff d0                	call   *%eax
  801543:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801545:	89 74 24 04          	mov    %esi,0x4(%esp)
  801549:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801550:	e8 ca f9 ff ff       	call   800f1f <sys_page_unmap>
	return r;
}
  801555:	89 d8                	mov    %ebx,%eax
  801557:	83 c4 20             	add    $0x20,%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801564:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801567:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	89 04 24             	mov    %eax,(%esp)
  801571:	e8 27 fc ff ff       	call   80119d <fd_lookup>
  801576:	85 c0                	test   %eax,%eax
  801578:	78 13                	js     80158d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80157a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801581:	00 
  801582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801585:	89 04 24             	mov    %eax,(%esp)
  801588:	e8 52 ff ff ff       	call   8014df <fd_close>
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 18             	sub    $0x18,%esp
  801595:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801598:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015a2:	00 
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	89 04 24             	mov    %eax,(%esp)
  8015a9:	e8 55 03 00 00       	call   801903 <open>
  8015ae:	89 c3                	mov    %eax,%ebx
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 1b                	js     8015cf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8015b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bb:	89 1c 24             	mov    %ebx,(%esp)
  8015be:	e8 b7 fc ff ff       	call   80127a <fstat>
  8015c3:	89 c6                	mov    %eax,%esi
	close(fd);
  8015c5:	89 1c 24             	mov    %ebx,(%esp)
  8015c8:	e8 91 ff ff ff       	call   80155e <close>
  8015cd:	89 f3                	mov    %esi,%ebx
	return r;
}
  8015cf:	89 d8                	mov    %ebx,%eax
  8015d1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015d4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015d7:	89 ec                	mov    %ebp,%esp
  8015d9:	5d                   	pop    %ebp
  8015da:	c3                   	ret    

008015db <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	53                   	push   %ebx
  8015df:	83 ec 14             	sub    $0x14,%esp
  8015e2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8015e7:	89 1c 24             	mov    %ebx,(%esp)
  8015ea:	e8 6f ff ff ff       	call   80155e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ef:	83 c3 01             	add    $0x1,%ebx
  8015f2:	83 fb 20             	cmp    $0x20,%ebx
  8015f5:	75 f0                	jne    8015e7 <close_all+0xc>
		close(i);
}
  8015f7:	83 c4 14             	add    $0x14,%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 58             	sub    $0x58,%esp
  801603:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801606:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801609:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80160c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80160f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801612:	89 44 24 04          	mov    %eax,0x4(%esp)
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	89 04 24             	mov    %eax,(%esp)
  80161c:	e8 7c fb ff ff       	call   80119d <fd_lookup>
  801621:	89 c3                	mov    %eax,%ebx
  801623:	85 c0                	test   %eax,%eax
  801625:	0f 88 e0 00 00 00    	js     80170b <dup+0x10e>
		return r;
	close(newfdnum);
  80162b:	89 3c 24             	mov    %edi,(%esp)
  80162e:	e8 2b ff ff ff       	call   80155e <close>

	newfd = INDEX2FD(newfdnum);
  801633:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801639:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80163c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80163f:	89 04 24             	mov    %eax,(%esp)
  801642:	e8 c9 fa ff ff       	call   801110 <fd2data>
  801647:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801649:	89 34 24             	mov    %esi,(%esp)
  80164c:	e8 bf fa ff ff       	call   801110 <fd2data>
  801651:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801654:	89 da                	mov    %ebx,%edx
  801656:	89 d8                	mov    %ebx,%eax
  801658:	c1 e8 16             	shr    $0x16,%eax
  80165b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801662:	a8 01                	test   $0x1,%al
  801664:	74 43                	je     8016a9 <dup+0xac>
  801666:	c1 ea 0c             	shr    $0xc,%edx
  801669:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801670:	a8 01                	test   $0x1,%al
  801672:	74 35                	je     8016a9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801674:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80167b:	25 07 0e 00 00       	and    $0xe07,%eax
  801680:	89 44 24 10          	mov    %eax,0x10(%esp)
  801684:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801687:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80168b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801692:	00 
  801693:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801697:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80169e:	e8 da f8 ff ff       	call   800f7d <sys_page_map>
  8016a3:	89 c3                	mov    %eax,%ebx
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 3f                	js     8016e8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8016a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ac:	89 c2                	mov    %eax,%edx
  8016ae:	c1 ea 0c             	shr    $0xc,%edx
  8016b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016be:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016c2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016cd:	00 
  8016ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d9:	e8 9f f8 ff ff       	call   800f7d <sys_page_map>
  8016de:	89 c3                	mov    %eax,%ebx
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	78 04                	js     8016e8 <dup+0xeb>
  8016e4:	89 fb                	mov    %edi,%ebx
  8016e6:	eb 23                	jmp    80170b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f3:	e8 27 f8 ff ff       	call   800f1f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801706:	e8 14 f8 ff ff       	call   800f1f <sys_page_unmap>
	return r;
}
  80170b:	89 d8                	mov    %ebx,%eax
  80170d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801710:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801713:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801716:	89 ec                	mov    %ebp,%esp
  801718:	5d                   	pop    %ebp
  801719:	c3                   	ret    
	...

0080171c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	53                   	push   %ebx
  801720:	83 ec 14             	sub    $0x14,%esp
  801723:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801725:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80172b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801732:	00 
  801733:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80173a:	00 
  80173b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173f:	89 14 24             	mov    %edx,(%esp)
  801742:	e8 19 0d 00 00       	call   802460 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801747:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80174e:	00 
  80174f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801753:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80175a:	e8 67 0d 00 00       	call   8024c6 <ipc_recv>
}
  80175f:	83 c4 14             	add    $0x14,%esp
  801762:	5b                   	pop    %ebx
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    

00801765 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	8b 40 0c             	mov    0xc(%eax),%eax
  801771:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801776:	8b 45 0c             	mov    0xc(%ebp),%eax
  801779:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80177e:	ba 00 00 00 00       	mov    $0x0,%edx
  801783:	b8 02 00 00 00       	mov    $0x2,%eax
  801788:	e8 8f ff ff ff       	call   80171c <fsipc>
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8b 40 0c             	mov    0xc(%eax),%eax
  80179b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	b8 06 00 00 00       	mov    $0x6,%eax
  8017aa:	e8 6d ff ff ff       	call   80171c <fsipc>
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8017c1:	e8 56 ff ff ff       	call   80171c <fsipc>
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 14             	sub    $0x14,%esp
  8017cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d8:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e2:	b8 05 00 00 00       	mov    $0x5,%eax
  8017e7:	e8 30 ff ff ff       	call   80171c <fsipc>
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	78 2b                	js     80181b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017f0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8017f7:	00 
  8017f8:	89 1c 24             	mov    %ebx,(%esp)
  8017fb:	e8 ea ef ff ff       	call   8007ea <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801800:	a1 80 30 80 00       	mov    0x803080,%eax
  801805:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80180b:	a1 84 30 80 00       	mov    0x803084,%eax
  801810:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801816:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80181b:	83 c4 14             	add    $0x14,%esp
  80181e:	5b                   	pop    %ebx
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    

00801821 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 18             	sub    $0x18,%esp
  801827:	8b 45 10             	mov    0x10(%ebp),%eax
  80182a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80182f:	76 05                	jbe    801836 <devfile_write+0x15>
  801831:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801836:	8b 55 08             	mov    0x8(%ebp),%edx
  801839:	8b 52 0c             	mov    0xc(%edx),%edx
  80183c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801842:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801847:	89 44 24 08          	mov    %eax,0x8(%esp)
  80184b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801852:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801859:	e8 47 f1 ff ff       	call   8009a5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	b8 04 00 00 00       	mov    $0x4,%eax
  801868:	e8 af fe ff ff       	call   80171c <fsipc>
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	53                   	push   %ebx
  801873:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	8b 40 0c             	mov    0xc(%eax),%eax
  80187c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801889:	ba 00 30 80 00       	mov    $0x803000,%edx
  80188e:	b8 03 00 00 00       	mov    $0x3,%eax
  801893:	e8 84 fe ff ff       	call   80171c <fsipc>
  801898:	89 c3                	mov    %eax,%ebx
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 17                	js     8018b5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80189e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018a2:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8018a9:	00 
  8018aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ad:	89 04 24             	mov    %eax,(%esp)
  8018b0:	e8 f0 f0 ff ff       	call   8009a5 <memmove>
	return r;
}
  8018b5:	89 d8                	mov    %ebx,%eax
  8018b7:	83 c4 14             	add    $0x14,%esp
  8018ba:	5b                   	pop    %ebx
  8018bb:	5d                   	pop    %ebp
  8018bc:	c3                   	ret    

008018bd <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	53                   	push   %ebx
  8018c1:	83 ec 14             	sub    $0x14,%esp
  8018c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8018c7:	89 1c 24             	mov    %ebx,(%esp)
  8018ca:	e8 d1 ee ff ff       	call   8007a0 <strlen>
  8018cf:	89 c2                	mov    %eax,%edx
  8018d1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8018d6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8018dc:	7f 1f                	jg     8018fd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8018de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018e2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8018e9:	e8 fc ee ff ff       	call   8007ea <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8018ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f3:	b8 07 00 00 00       	mov    $0x7,%eax
  8018f8:	e8 1f fe ff ff       	call   80171c <fsipc>
}
  8018fd:	83 c4 14             	add    $0x14,%esp
  801900:	5b                   	pop    %ebx
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    

00801903 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 28             	sub    $0x28,%esp
  801909:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80190c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80190f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801912:	89 34 24             	mov    %esi,(%esp)
  801915:	e8 86 ee ff ff       	call   8007a0 <strlen>
  80191a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80191f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801924:	7f 5e                	jg     801984 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801926:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801929:	89 04 24             	mov    %eax,(%esp)
  80192c:	e8 fa f7 ff ff       	call   80112b <fd_alloc>
  801931:	89 c3                	mov    %eax,%ebx
  801933:	85 c0                	test   %eax,%eax
  801935:	78 4d                	js     801984 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801937:	89 74 24 04          	mov    %esi,0x4(%esp)
  80193b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801942:	e8 a3 ee ff ff       	call   8007ea <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80194f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801952:	b8 01 00 00 00       	mov    $0x1,%eax
  801957:	e8 c0 fd ff ff       	call   80171c <fsipc>
  80195c:	89 c3                	mov    %eax,%ebx
  80195e:	85 c0                	test   %eax,%eax
  801960:	79 15                	jns    801977 <open+0x74>
	{
		fd_close(fd,0);
  801962:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801969:	00 
  80196a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196d:	89 04 24             	mov    %eax,(%esp)
  801970:	e8 6a fb ff ff       	call   8014df <fd_close>
		return r; 
  801975:	eb 0d                	jmp    801984 <open+0x81>
	}
	return fd2num(fd);
  801977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197a:	89 04 24             	mov    %eax,(%esp)
  80197d:	e8 7e f7 ff ff       	call   801100 <fd2num>
  801982:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801984:	89 d8                	mov    %ebx,%eax
  801986:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801989:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80198c:	89 ec                	mov    %ebp,%esp
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    

00801990 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801996:	c7 44 24 04 fc 2b 80 	movl   $0x802bfc,0x4(%esp)
  80199d:	00 
  80199e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a1:	89 04 24             	mov    %eax,(%esp)
  8019a4:	e8 41 ee ff ff       	call   8007ea <strcpy>
	return 0;
}
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019bc:	89 04 24             	mov    %eax,(%esp)
  8019bf:	e8 9e 02 00 00       	call   801c62 <nsipc_close>
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019d3:	00 
  8019d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e8:	89 04 24             	mov    %eax,(%esp)
  8019eb:	e8 ae 02 00 00       	call   801c9e <nsipc_send>
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ff:	00 
  801a00:	8b 45 10             	mov    0x10(%ebp),%eax
  801a03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	8b 40 0c             	mov    0xc(%eax),%eax
  801a14:	89 04 24             	mov    %eax,(%esp)
  801a17:	e8 f5 02 00 00       	call   801d11 <nsipc_recv>
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	56                   	push   %esi
  801a22:	53                   	push   %ebx
  801a23:	83 ec 20             	sub    $0x20,%esp
  801a26:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2b:	89 04 24             	mov    %eax,(%esp)
  801a2e:	e8 f8 f6 ff ff       	call   80112b <fd_alloc>
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	85 c0                	test   %eax,%eax
  801a37:	78 21                	js     801a5a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801a39:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a40:	00 
  801a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a4f:	e8 87 f5 ff ff       	call   800fdb <sys_page_alloc>
  801a54:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a56:	85 c0                	test   %eax,%eax
  801a58:	79 0a                	jns    801a64 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801a5a:	89 34 24             	mov    %esi,(%esp)
  801a5d:	e8 00 02 00 00       	call   801c62 <nsipc_close>
		return r;
  801a62:	eb 28                	jmp    801a8c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a64:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a82:	89 04 24             	mov    %eax,(%esp)
  801a85:	e8 76 f6 ff ff       	call   801100 <fd2num>
  801a8a:	89 c3                	mov    %eax,%ebx
}
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	83 c4 20             	add    $0x20,%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    

00801a95 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	89 04 24             	mov    %eax,(%esp)
  801aaf:	e8 62 01 00 00       	call   801c16 <nsipc_socket>
  801ab4:	85 c0                	test   %eax,%eax
  801ab6:	78 05                	js     801abd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801ab8:	e8 61 ff ff ff       	call   801a1e <alloc_sockfd>
}
  801abd:	c9                   	leave  
  801abe:	66 90                	xchg   %ax,%ax
  801ac0:	c3                   	ret    

00801ac1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ac7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801aca:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ace:	89 04 24             	mov    %eax,(%esp)
  801ad1:	e8 c7 f6 ff ff       	call   80119d <fd_lookup>
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	78 15                	js     801aef <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ada:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801add:	8b 0a                	mov    (%edx),%ecx
  801adf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ae4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801aea:	75 03                	jne    801aef <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801aec:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	e8 c2 ff ff ff       	call   801ac1 <fd2sockid>
  801aff:	85 c0                	test   %eax,%eax
  801b01:	78 0f                	js     801b12 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b0a:	89 04 24             	mov    %eax,(%esp)
  801b0d:	e8 2e 01 00 00       	call   801c40 <nsipc_listen>
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	e8 9f ff ff ff       	call   801ac1 <fd2sockid>
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 16                	js     801b3c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801b26:	8b 55 10             	mov    0x10(%ebp),%edx
  801b29:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b30:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b34:	89 04 24             	mov    %eax,(%esp)
  801b37:	e8 55 02 00 00       	call   801d91 <nsipc_connect>
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	e8 75 ff ff ff       	call   801ac1 <fd2sockid>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	78 0f                	js     801b5f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b53:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b57:	89 04 24             	mov    %eax,(%esp)
  801b5a:	e8 1d 01 00 00       	call   801c7c <nsipc_shutdown>
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	e8 52 ff ff ff       	call   801ac1 <fd2sockid>
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	78 16                	js     801b89 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801b73:	8b 55 10             	mov    0x10(%ebp),%edx
  801b76:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b81:	89 04 24             	mov    %eax,(%esp)
  801b84:	e8 47 02 00 00       	call   801dd0 <nsipc_bind>
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	e8 28 ff ff ff       	call   801ac1 <fd2sockid>
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 1f                	js     801bbc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b9d:	8b 55 10             	mov    0x10(%ebp),%edx
  801ba0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bab:	89 04 24             	mov    %eax,(%esp)
  801bae:	e8 5c 02 00 00       	call   801e0f <nsipc_accept>
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 05                	js     801bbc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801bb7:	e8 62 fe ff ff       	call   801a1e <alloc_sockfd>
}
  801bbc:	c9                   	leave  
  801bbd:	8d 76 00             	lea    0x0(%esi),%esi
  801bc0:	c3                   	ret    
	...

00801bd0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801bdc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801be3:	00 
  801be4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801beb:	00 
  801bec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf0:	89 14 24             	mov    %edx,(%esp)
  801bf3:	e8 68 08 00 00       	call   802460 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bf8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bff:	00 
  801c00:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c07:	00 
  801c08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0f:	e8 b2 08 00 00       	call   8024c6 <ipc_recv>
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c27:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801c34:	b8 09 00 00 00       	mov    $0x9,%eax
  801c39:	e8 92 ff ff ff       	call   801bd0 <nsipc>
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c51:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801c56:	b8 06 00 00 00       	mov    $0x6,%eax
  801c5b:	e8 70 ff ff ff       	call   801bd0 <nsipc>
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801c70:	b8 04 00 00 00       	mov    $0x4,%eax
  801c75:	e8 56 ff ff ff       	call   801bd0 <nsipc>
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801c92:	b8 03 00 00 00       	mov    $0x3,%eax
  801c97:	e8 34 ff ff ff       	call   801bd0 <nsipc>
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	53                   	push   %ebx
  801ca2:	83 ec 14             	sub    $0x14,%esp
  801ca5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801cb0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cb6:	7e 24                	jle    801cdc <nsipc_send+0x3e>
  801cb8:	c7 44 24 0c 08 2c 80 	movl   $0x802c08,0xc(%esp)
  801cbf:	00 
  801cc0:	c7 44 24 08 14 2c 80 	movl   $0x802c14,0x8(%esp)
  801cc7:	00 
  801cc8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801ccf:	00 
  801cd0:	c7 04 24 29 2c 80 00 	movl   $0x802c29,(%esp)
  801cd7:	e8 20 07 00 00       	call   8023fc <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cdc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801cee:	e8 b2 ec ff ff       	call   8009a5 <memmove>
	nsipcbuf.send.req_size = size;
  801cf3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801cf9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801d01:	b8 08 00 00 00       	mov    $0x8,%eax
  801d06:	e8 c5 fe ff ff       	call   801bd0 <nsipc>
}
  801d0b:	83 c4 14             	add    $0x14,%esp
  801d0e:	5b                   	pop    %ebx
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    

00801d11 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	56                   	push   %esi
  801d15:	53                   	push   %ebx
  801d16:	83 ec 10             	sub    $0x10,%esp
  801d19:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801d24:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d32:	b8 07 00 00 00       	mov    $0x7,%eax
  801d37:	e8 94 fe ff ff       	call   801bd0 <nsipc>
  801d3c:	89 c3                	mov    %eax,%ebx
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	78 46                	js     801d88 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d42:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d47:	7f 04                	jg     801d4d <nsipc_recv+0x3c>
  801d49:	39 c6                	cmp    %eax,%esi
  801d4b:	7d 24                	jge    801d71 <nsipc_recv+0x60>
  801d4d:	c7 44 24 0c 35 2c 80 	movl   $0x802c35,0xc(%esp)
  801d54:	00 
  801d55:	c7 44 24 08 14 2c 80 	movl   $0x802c14,0x8(%esp)
  801d5c:	00 
  801d5d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801d64:	00 
  801d65:	c7 04 24 29 2c 80 00 	movl   $0x802c29,(%esp)
  801d6c:	e8 8b 06 00 00       	call   8023fc <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d71:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d75:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801d7c:	00 
  801d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d80:	89 04 24             	mov    %eax,(%esp)
  801d83:	e8 1d ec ff ff       	call   8009a5 <memmove>
	}

	return r;
}
  801d88:	89 d8                	mov    %ebx,%eax
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	5b                   	pop    %ebx
  801d8e:	5e                   	pop    %esi
  801d8f:	5d                   	pop    %ebp
  801d90:	c3                   	ret    

00801d91 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	53                   	push   %ebx
  801d95:	83 ec 14             	sub    $0x14,%esp
  801d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801daa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dae:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801db5:	e8 eb eb ff ff       	call   8009a5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dba:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  801dc0:	b8 05 00 00 00       	mov    $0x5,%eax
  801dc5:	e8 06 fe ff ff       	call   801bd0 <nsipc>
}
  801dca:	83 c4 14             	add    $0x14,%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    

00801dd0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 14             	sub    $0x14,%esp
  801dd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801de2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ded:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801df4:	e8 ac eb ff ff       	call   8009a5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801df9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  801dff:	b8 02 00 00 00       	mov    $0x2,%eax
  801e04:	e8 c7 fd ff ff       	call   801bd0 <nsipc>
}
  801e09:	83 c4 14             	add    $0x14,%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    

00801e0f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 18             	sub    $0x18,%esp
  801e15:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e18:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e23:	b8 01 00 00 00       	mov    $0x1,%eax
  801e28:	e8 a3 fd ff ff       	call   801bd0 <nsipc>
  801e2d:	89 c3                	mov    %eax,%ebx
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 25                	js     801e58 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e33:	be 10 50 80 00       	mov    $0x805010,%esi
  801e38:	8b 06                	mov    (%esi),%eax
  801e3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e3e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801e45:	00 
  801e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e49:	89 04 24             	mov    %eax,(%esp)
  801e4c:	e8 54 eb ff ff       	call   8009a5 <memmove>
		*addrlen = ret->ret_addrlen;
  801e51:	8b 16                	mov    (%esi),%edx
  801e53:	8b 45 10             	mov    0x10(%ebp),%eax
  801e56:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801e58:	89 d8                	mov    %ebx,%eax
  801e5a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e5d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e60:	89 ec                	mov    %ebp,%esp
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    
	...

00801e70 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 18             	sub    $0x18,%esp
  801e76:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e79:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e7c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	89 04 24             	mov    %eax,(%esp)
  801e85:	e8 86 f2 ff ff       	call   801110 <fd2data>
  801e8a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801e8c:	c7 44 24 04 4a 2c 80 	movl   $0x802c4a,0x4(%esp)
  801e93:	00 
  801e94:	89 34 24             	mov    %esi,(%esp)
  801e97:	e8 4e e9 ff ff       	call   8007ea <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e9c:	8b 43 04             	mov    0x4(%ebx),%eax
  801e9f:	2b 03                	sub    (%ebx),%eax
  801ea1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801ea7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801eae:	00 00 00 
	stat->st_dev = &devpipe;
  801eb1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  801eb8:	60 80 00 
	return 0;
}
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ec3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ec6:	89 ec                	mov    %ebp,%esp
  801ec8:	5d                   	pop    %ebp
  801ec9:	c3                   	ret    

00801eca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	53                   	push   %ebx
  801ece:	83 ec 14             	sub    $0x14,%esp
  801ed1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ed4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ed8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801edf:	e8 3b f0 ff ff       	call   800f1f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ee4:	89 1c 24             	mov    %ebx,(%esp)
  801ee7:	e8 24 f2 ff ff       	call   801110 <fd2data>
  801eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef7:	e8 23 f0 ff ff       	call   800f1f <sys_page_unmap>
}
  801efc:	83 c4 14             	add    $0x14,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    

00801f02 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	57                   	push   %edi
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
  801f08:	83 ec 2c             	sub    $0x2c,%esp
  801f0b:	89 c7                	mov    %eax,%edi
  801f0d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801f10:	a1 74 60 80 00       	mov    0x806074,%eax
  801f15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f18:	89 3c 24             	mov    %edi,(%esp)
  801f1b:	e8 10 06 00 00       	call   802530 <pageref>
  801f20:	89 c6                	mov    %eax,%esi
  801f22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f25:	89 04 24             	mov    %eax,(%esp)
  801f28:	e8 03 06 00 00       	call   802530 <pageref>
  801f2d:	39 c6                	cmp    %eax,%esi
  801f2f:	0f 94 c0             	sete   %al
  801f32:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801f35:	8b 15 74 60 80 00    	mov    0x806074,%edx
  801f3b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f3e:	39 cb                	cmp    %ecx,%ebx
  801f40:	75 08                	jne    801f4a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801f42:	83 c4 2c             	add    $0x2c,%esp
  801f45:	5b                   	pop    %ebx
  801f46:	5e                   	pop    %esi
  801f47:	5f                   	pop    %edi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801f4a:	83 f8 01             	cmp    $0x1,%eax
  801f4d:	75 c1                	jne    801f10 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801f4f:	8b 52 58             	mov    0x58(%edx),%edx
  801f52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f5e:	c7 04 24 51 2c 80 00 	movl   $0x802c51,(%esp)
  801f65:	e8 c3 e1 ff ff       	call   80012d <cprintf>
  801f6a:	eb a4                	jmp    801f10 <_pipeisclosed+0xe>

00801f6c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	57                   	push   %edi
  801f70:	56                   	push   %esi
  801f71:	53                   	push   %ebx
  801f72:	83 ec 1c             	sub    $0x1c,%esp
  801f75:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f78:	89 34 24             	mov    %esi,(%esp)
  801f7b:	e8 90 f1 ff ff       	call   801110 <fd2data>
  801f80:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f82:	bf 00 00 00 00       	mov    $0x0,%edi
  801f87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f8b:	75 54                	jne    801fe1 <devpipe_write+0x75>
  801f8d:	eb 60                	jmp    801fef <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f8f:	89 da                	mov    %ebx,%edx
  801f91:	89 f0                	mov    %esi,%eax
  801f93:	e8 6a ff ff ff       	call   801f02 <_pipeisclosed>
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	74 07                	je     801fa3 <devpipe_write+0x37>
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	eb 53                	jmp    801ff6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801fa3:	90                   	nop
  801fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fa8:	e8 8d f0 ff ff       	call   80103a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fad:	8b 43 04             	mov    0x4(%ebx),%eax
  801fb0:	8b 13                	mov    (%ebx),%edx
  801fb2:	83 c2 20             	add    $0x20,%edx
  801fb5:	39 d0                	cmp    %edx,%eax
  801fb7:	73 d6                	jae    801f8f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fb9:	89 c2                	mov    %eax,%edx
  801fbb:	c1 fa 1f             	sar    $0x1f,%edx
  801fbe:	c1 ea 1b             	shr    $0x1b,%edx
  801fc1:	01 d0                	add    %edx,%eax
  801fc3:	83 e0 1f             	and    $0x1f,%eax
  801fc6:	29 d0                	sub    %edx,%eax
  801fc8:	89 c2                	mov    %eax,%edx
  801fca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fcd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  801fd1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fd5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fd9:	83 c7 01             	add    $0x1,%edi
  801fdc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  801fdf:	76 13                	jbe    801ff4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fe1:	8b 43 04             	mov    0x4(%ebx),%eax
  801fe4:	8b 13                	mov    (%ebx),%edx
  801fe6:	83 c2 20             	add    $0x20,%edx
  801fe9:	39 d0                	cmp    %edx,%eax
  801feb:	73 a2                	jae    801f8f <devpipe_write+0x23>
  801fed:	eb ca                	jmp    801fb9 <devpipe_write+0x4d>
  801fef:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  801ff4:	89 f8                	mov    %edi,%eax
}
  801ff6:	83 c4 1c             	add    $0x1c,%esp
  801ff9:	5b                   	pop    %ebx
  801ffa:	5e                   	pop    %esi
  801ffb:	5f                   	pop    %edi
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    

00801ffe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 28             	sub    $0x28,%esp
  802004:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802007:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80200a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80200d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802010:	89 3c 24             	mov    %edi,(%esp)
  802013:	e8 f8 f0 ff ff       	call   801110 <fd2data>
  802018:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80201a:	be 00 00 00 00       	mov    $0x0,%esi
  80201f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802023:	75 4c                	jne    802071 <devpipe_read+0x73>
  802025:	eb 5b                	jmp    802082 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802027:	89 f0                	mov    %esi,%eax
  802029:	eb 5e                	jmp    802089 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80202b:	89 da                	mov    %ebx,%edx
  80202d:	89 f8                	mov    %edi,%eax
  80202f:	90                   	nop
  802030:	e8 cd fe ff ff       	call   801f02 <_pipeisclosed>
  802035:	85 c0                	test   %eax,%eax
  802037:	74 07                	je     802040 <devpipe_read+0x42>
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	eb 49                	jmp    802089 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802040:	e8 f5 ef ff ff       	call   80103a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802045:	8b 03                	mov    (%ebx),%eax
  802047:	3b 43 04             	cmp    0x4(%ebx),%eax
  80204a:	74 df                	je     80202b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80204c:	89 c2                	mov    %eax,%edx
  80204e:	c1 fa 1f             	sar    $0x1f,%edx
  802051:	c1 ea 1b             	shr    $0x1b,%edx
  802054:	01 d0                	add    %edx,%eax
  802056:	83 e0 1f             	and    $0x1f,%eax
  802059:	29 d0                	sub    %edx,%eax
  80205b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802060:	8b 55 0c             	mov    0xc(%ebp),%edx
  802063:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802066:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802069:	83 c6 01             	add    $0x1,%esi
  80206c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80206f:	76 16                	jbe    802087 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802071:	8b 03                	mov    (%ebx),%eax
  802073:	3b 43 04             	cmp    0x4(%ebx),%eax
  802076:	75 d4                	jne    80204c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802078:	85 f6                	test   %esi,%esi
  80207a:	75 ab                	jne    802027 <devpipe_read+0x29>
  80207c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802080:	eb a9                	jmp    80202b <devpipe_read+0x2d>
  802082:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802087:	89 f0                	mov    %esi,%eax
}
  802089:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80208c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80208f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802092:	89 ec                	mov    %ebp,%esp
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    

00802096 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	89 04 24             	mov    %eax,(%esp)
  8020a9:	e8 ef f0 ff ff       	call   80119d <fd_lookup>
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	78 15                	js     8020c7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	89 04 24             	mov    %eax,(%esp)
  8020b8:	e8 53 f0 ff ff       	call   801110 <fd2data>
	return _pipeisclosed(fd, p);
  8020bd:	89 c2                	mov    %eax,%edx
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	e8 3b fe ff ff       	call   801f02 <_pipeisclosed>
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 48             	sub    $0x48,%esp
  8020cf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020d2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020d5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020d8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8020de:	89 04 24             	mov    %eax,(%esp)
  8020e1:	e8 45 f0 ff ff       	call   80112b <fd_alloc>
  8020e6:	89 c3                	mov    %eax,%ebx
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	0f 88 42 01 00 00    	js     802232 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020f0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020f7:	00 
  8020f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802106:	e8 d0 ee ff ff       	call   800fdb <sys_page_alloc>
  80210b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80210d:	85 c0                	test   %eax,%eax
  80210f:	0f 88 1d 01 00 00    	js     802232 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802115:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802118:	89 04 24             	mov    %eax,(%esp)
  80211b:	e8 0b f0 ff ff       	call   80112b <fd_alloc>
  802120:	89 c3                	mov    %eax,%ebx
  802122:	85 c0                	test   %eax,%eax
  802124:	0f 88 f5 00 00 00    	js     80221f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80212a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802131:	00 
  802132:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802135:	89 44 24 04          	mov    %eax,0x4(%esp)
  802139:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802140:	e8 96 ee ff ff       	call   800fdb <sys_page_alloc>
  802145:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802147:	85 c0                	test   %eax,%eax
  802149:	0f 88 d0 00 00 00    	js     80221f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80214f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802152:	89 04 24             	mov    %eax,(%esp)
  802155:	e8 b6 ef ff ff       	call   801110 <fd2data>
  80215a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80215c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802163:	00 
  802164:	89 44 24 04          	mov    %eax,0x4(%esp)
  802168:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80216f:	e8 67 ee ff ff       	call   800fdb <sys_page_alloc>
  802174:	89 c3                	mov    %eax,%ebx
  802176:	85 c0                	test   %eax,%eax
  802178:	0f 88 8e 00 00 00    	js     80220c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80217e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802181:	89 04 24             	mov    %eax,(%esp)
  802184:	e8 87 ef ff ff       	call   801110 <fd2data>
  802189:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802190:	00 
  802191:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802195:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80219c:	00 
  80219d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a8:	e8 d0 ed ff ff       	call   800f7d <sys_page_map>
  8021ad:	89 c3                	mov    %eax,%ebx
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	78 49                	js     8021fc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021b3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  8021b8:	8b 08                	mov    (%eax),%ecx
  8021ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021bd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021c2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8021c9:	8b 10                	mov    (%eax),%edx
  8021cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ce:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8021da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021dd:	89 04 24             	mov    %eax,(%esp)
  8021e0:	e8 1b ef ff ff       	call   801100 <fd2num>
  8021e5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8021e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ea:	89 04 24             	mov    %eax,(%esp)
  8021ed:	e8 0e ef ff ff       	call   801100 <fd2num>
  8021f2:	89 47 04             	mov    %eax,0x4(%edi)
  8021f5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8021fa:	eb 36                	jmp    802232 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8021fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802207:	e8 13 ed ff ff       	call   800f1f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80220c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80220f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802213:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80221a:	e8 00 ed ff ff       	call   800f1f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80221f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802222:	89 44 24 04          	mov    %eax,0x4(%esp)
  802226:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222d:	e8 ed ec ff ff       	call   800f1f <sys_page_unmap>
    err:
	return r;
}
  802232:	89 d8                	mov    %ebx,%eax
  802234:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802237:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80223a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80223d:	89 ec                	mov    %ebp,%esp
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    
	...

00802250 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802253:	b8 00 00 00 00       	mov    $0x0,%eax
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    

0080225a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802260:	c7 44 24 04 69 2c 80 	movl   $0x802c69,0x4(%esp)
  802267:	00 
  802268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226b:	89 04 24             	mov    %eax,(%esp)
  80226e:	e8 77 e5 ff ff       	call   8007ea <strcpy>
	return 0;
}
  802273:	b8 00 00 00 00       	mov    $0x0,%eax
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	57                   	push   %edi
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	be 00 00 00 00       	mov    $0x0,%esi
  802290:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802294:	74 3f                	je     8022d5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802296:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80229c:	8b 55 10             	mov    0x10(%ebp),%edx
  80229f:	29 c2                	sub    %eax,%edx
  8022a1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8022a3:	83 fa 7f             	cmp    $0x7f,%edx
  8022a6:	76 05                	jbe    8022ad <devcons_write+0x33>
  8022a8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022b1:	03 45 0c             	add    0xc(%ebp),%eax
  8022b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b8:	89 3c 24             	mov    %edi,(%esp)
  8022bb:	e8 e5 e6 ff ff       	call   8009a5 <memmove>
		sys_cputs(buf, m);
  8022c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022c4:	89 3c 24             	mov    %edi,(%esp)
  8022c7:	e8 14 e9 ff ff       	call   800be0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022cc:	01 de                	add    %ebx,%esi
  8022ce:	89 f0                	mov    %esi,%eax
  8022d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022d3:	72 c7                	jb     80229c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8022d5:	89 f0                	mov    %esi,%eax
  8022d7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8022dd:	5b                   	pop    %ebx
  8022de:	5e                   	pop    %esi
  8022df:	5f                   	pop    %edi
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    

008022e2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022f5:	00 
  8022f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022f9:	89 04 24             	mov    %eax,(%esp)
  8022fc:	e8 df e8 ff ff       	call   800be0 <sys_cputs>
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802309:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80230d:	75 07                	jne    802316 <devcons_read+0x13>
  80230f:	eb 28                	jmp    802339 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802311:	e8 24 ed ff ff       	call   80103a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802316:	66 90                	xchg   %ax,%ax
  802318:	e8 8f e8 ff ff       	call   800bac <sys_cgetc>
  80231d:	85 c0                	test   %eax,%eax
  80231f:	90                   	nop
  802320:	74 ef                	je     802311 <devcons_read+0xe>
  802322:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802324:	85 c0                	test   %eax,%eax
  802326:	78 16                	js     80233e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802328:	83 f8 04             	cmp    $0x4,%eax
  80232b:	74 0c                	je     802339 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	88 10                	mov    %dl,(%eax)
  802332:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802337:	eb 05                	jmp    80233e <devcons_read+0x3b>
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802346:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802349:	89 04 24             	mov    %eax,(%esp)
  80234c:	e8 da ed ff ff       	call   80112b <fd_alloc>
  802351:	85 c0                	test   %eax,%eax
  802353:	78 3f                	js     802394 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802355:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80235c:	00 
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	89 44 24 04          	mov    %eax,0x4(%esp)
  802364:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80236b:	e8 6b ec ff ff       	call   800fdb <sys_page_alloc>
  802370:	85 c0                	test   %eax,%eax
  802372:	78 20                	js     802394 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802374:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	89 04 24             	mov    %eax,(%esp)
  80238f:	e8 6c ed ff ff       	call   801100 <fd2num>
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80239c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80239f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 ef ed ff ff       	call   80119d <fd_lookup>
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	78 11                	js     8023c3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  8023bd:	0f 94 c0             	sete   %al
  8023c0:	0f b6 c0             	movzbl %al,%eax
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8023cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023d2:	00 
  8023d3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e1:	e8 18 f0 ff ff       	call   8013fe <read>
	if (r < 0)
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	78 0f                	js     8023f9 <getchar+0x34>
		return r;
	if (r < 1)
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	7f 07                	jg     8023f5 <getchar+0x30>
  8023ee:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023f3:	eb 04                	jmp    8023f9 <getchar+0x34>
		return -E_EOF;
	return c;
  8023f5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    
	...

008023fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	53                   	push   %ebx
  802400:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  802403:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  802406:	a1 78 60 80 00       	mov    0x806078,%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 10                	je     80241f <_panic+0x23>
		cprintf("%s: ", argv0);
  80240f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802413:	c7 04 24 75 2c 80 00 	movl   $0x802c75,(%esp)
  80241a:	e8 0e dd ff ff       	call   80012d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80241f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802422:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	89 44 24 08          	mov    %eax,0x8(%esp)
  80242d:	a1 00 60 80 00       	mov    0x806000,%eax
  802432:	89 44 24 04          	mov    %eax,0x4(%esp)
  802436:	c7 04 24 7a 2c 80 00 	movl   $0x802c7a,(%esp)
  80243d:	e8 eb dc ff ff       	call   80012d <cprintf>
	vcprintf(fmt, ap);
  802442:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802446:	8b 45 10             	mov    0x10(%ebp),%eax
  802449:	89 04 24             	mov    %eax,(%esp)
  80244c:	e8 7b dc ff ff       	call   8000cc <vcprintf>
	cprintf("\n");
  802451:	c7 04 24 62 2c 80 00 	movl   $0x802c62,(%esp)
  802458:	e8 d0 dc ff ff       	call   80012d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80245d:	cc                   	int3   
  80245e:	eb fd                	jmp    80245d <_panic+0x61>

00802460 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	57                   	push   %edi
  802464:	56                   	push   %esi
  802465:	53                   	push   %ebx
  802466:	83 ec 1c             	sub    $0x1c,%esp
  802469:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80246c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80246f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802472:	85 db                	test   %ebx,%ebx
  802474:	75 2d                	jne    8024a3 <ipc_send+0x43>
  802476:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80247b:	eb 26                	jmp    8024a3 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80247d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802480:	74 1c                	je     80249e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802482:	c7 44 24 08 98 2c 80 	movl   $0x802c98,0x8(%esp)
  802489:	00 
  80248a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802491:	00 
  802492:	c7 04 24 bc 2c 80 00 	movl   $0x802cbc,(%esp)
  802499:	e8 5e ff ff ff       	call   8023fc <_panic>
		sys_yield();
  80249e:	e8 97 eb ff ff       	call   80103a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8024a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8024a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	89 04 24             	mov    %eax,(%esp)
  8024b5:	e8 13 e9 ff ff       	call   800dcd <sys_ipc_try_send>
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	78 bf                	js     80247d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8024be:	83 c4 1c             	add    $0x1c,%esp
  8024c1:	5b                   	pop    %ebx
  8024c2:	5e                   	pop    %esi
  8024c3:	5f                   	pop    %edi
  8024c4:	5d                   	pop    %ebp
  8024c5:	c3                   	ret    

008024c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	56                   	push   %esi
  8024ca:	53                   	push   %ebx
  8024cb:	83 ec 10             	sub    $0x10,%esp
  8024ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	75 05                	jne    8024e0 <ipc_recv+0x1a>
  8024db:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8024e0:	89 04 24             	mov    %eax,(%esp)
  8024e3:	e8 88 e8 ff ff       	call   800d70 <sys_ipc_recv>
  8024e8:	85 c0                	test   %eax,%eax
  8024ea:	79 16                	jns    802502 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8024ec:	85 db                	test   %ebx,%ebx
  8024ee:	74 06                	je     8024f6 <ipc_recv+0x30>
			*from_env_store = 0;
  8024f0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8024f6:	85 f6                	test   %esi,%esi
  8024f8:	74 2c                	je     802526 <ipc_recv+0x60>
			*perm_store = 0;
  8024fa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802500:	eb 24                	jmp    802526 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802502:	85 db                	test   %ebx,%ebx
  802504:	74 0a                	je     802510 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802506:	a1 74 60 80 00       	mov    0x806074,%eax
  80250b:	8b 40 74             	mov    0x74(%eax),%eax
  80250e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802510:	85 f6                	test   %esi,%esi
  802512:	74 0a                	je     80251e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802514:	a1 74 60 80 00       	mov    0x806074,%eax
  802519:	8b 40 78             	mov    0x78(%eax),%eax
  80251c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80251e:	a1 74 60 80 00       	mov    0x806074,%eax
  802523:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802526:	83 c4 10             	add    $0x10,%esp
  802529:	5b                   	pop    %ebx
  80252a:	5e                   	pop    %esi
  80252b:	5d                   	pop    %ebp
  80252c:	c3                   	ret    
  80252d:	00 00                	add    %al,(%eax)
	...

00802530 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	89 c2                	mov    %eax,%edx
  802538:	c1 ea 16             	shr    $0x16,%edx
  80253b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802542:	f6 c2 01             	test   $0x1,%dl
  802545:	74 26                	je     80256d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802547:	c1 e8 0c             	shr    $0xc,%eax
  80254a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802551:	a8 01                	test   $0x1,%al
  802553:	74 18                	je     80256d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802555:	c1 e8 0c             	shr    $0xc,%eax
  802558:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80255b:	c1 e2 02             	shl    $0x2,%edx
  80255e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802563:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802568:	0f b7 c0             	movzwl %ax,%eax
  80256b:	eb 05                	jmp    802572 <pageref+0x42>
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    
	...

00802580 <__udivdi3>:
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	57                   	push   %edi
  802584:	56                   	push   %esi
  802585:	83 ec 10             	sub    $0x10,%esp
  802588:	8b 45 14             	mov    0x14(%ebp),%eax
  80258b:	8b 55 08             	mov    0x8(%ebp),%edx
  80258e:	8b 75 10             	mov    0x10(%ebp),%esi
  802591:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802594:	85 c0                	test   %eax,%eax
  802596:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802599:	75 35                	jne    8025d0 <__udivdi3+0x50>
  80259b:	39 fe                	cmp    %edi,%esi
  80259d:	77 61                	ja     802600 <__udivdi3+0x80>
  80259f:	85 f6                	test   %esi,%esi
  8025a1:	75 0b                	jne    8025ae <__udivdi3+0x2e>
  8025a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a8:	31 d2                	xor    %edx,%edx
  8025aa:	f7 f6                	div    %esi
  8025ac:	89 c6                	mov    %eax,%esi
  8025ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025b1:	31 d2                	xor    %edx,%edx
  8025b3:	89 f8                	mov    %edi,%eax
  8025b5:	f7 f6                	div    %esi
  8025b7:	89 c7                	mov    %eax,%edi
  8025b9:	89 c8                	mov    %ecx,%eax
  8025bb:	f7 f6                	div    %esi
  8025bd:	89 c1                	mov    %eax,%ecx
  8025bf:	89 fa                	mov    %edi,%edx
  8025c1:	89 c8                	mov    %ecx,%eax
  8025c3:	83 c4 10             	add    $0x10,%esp
  8025c6:	5e                   	pop    %esi
  8025c7:	5f                   	pop    %edi
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    
  8025ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025d0:	39 f8                	cmp    %edi,%eax
  8025d2:	77 1c                	ja     8025f0 <__udivdi3+0x70>
  8025d4:	0f bd d0             	bsr    %eax,%edx
  8025d7:	83 f2 1f             	xor    $0x1f,%edx
  8025da:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8025dd:	75 39                	jne    802618 <__udivdi3+0x98>
  8025df:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8025e2:	0f 86 a0 00 00 00    	jbe    802688 <__udivdi3+0x108>
  8025e8:	39 f8                	cmp    %edi,%eax
  8025ea:	0f 82 98 00 00 00    	jb     802688 <__udivdi3+0x108>
  8025f0:	31 ff                	xor    %edi,%edi
  8025f2:	31 c9                	xor    %ecx,%ecx
  8025f4:	89 c8                	mov    %ecx,%eax
  8025f6:	89 fa                	mov    %edi,%edx
  8025f8:	83 c4 10             	add    $0x10,%esp
  8025fb:	5e                   	pop    %esi
  8025fc:	5f                   	pop    %edi
  8025fd:	5d                   	pop    %ebp
  8025fe:	c3                   	ret    
  8025ff:	90                   	nop
  802600:	89 d1                	mov    %edx,%ecx
  802602:	89 fa                	mov    %edi,%edx
  802604:	89 c8                	mov    %ecx,%eax
  802606:	31 ff                	xor    %edi,%edi
  802608:	f7 f6                	div    %esi
  80260a:	89 c1                	mov    %eax,%ecx
  80260c:	89 fa                	mov    %edi,%edx
  80260e:	89 c8                	mov    %ecx,%eax
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	5e                   	pop    %esi
  802614:	5f                   	pop    %edi
  802615:	5d                   	pop    %ebp
  802616:	c3                   	ret    
  802617:	90                   	nop
  802618:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80261c:	89 f2                	mov    %esi,%edx
  80261e:	d3 e0                	shl    %cl,%eax
  802620:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802623:	b8 20 00 00 00       	mov    $0x20,%eax
  802628:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80262b:	89 c1                	mov    %eax,%ecx
  80262d:	d3 ea                	shr    %cl,%edx
  80262f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802633:	0b 55 ec             	or     -0x14(%ebp),%edx
  802636:	d3 e6                	shl    %cl,%esi
  802638:	89 c1                	mov    %eax,%ecx
  80263a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80263d:	89 fe                	mov    %edi,%esi
  80263f:	d3 ee                	shr    %cl,%esi
  802641:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802645:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802648:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80264b:	d3 e7                	shl    %cl,%edi
  80264d:	89 c1                	mov    %eax,%ecx
  80264f:	d3 ea                	shr    %cl,%edx
  802651:	09 d7                	or     %edx,%edi
  802653:	89 f2                	mov    %esi,%edx
  802655:	89 f8                	mov    %edi,%eax
  802657:	f7 75 ec             	divl   -0x14(%ebp)
  80265a:	89 d6                	mov    %edx,%esi
  80265c:	89 c7                	mov    %eax,%edi
  80265e:	f7 65 e8             	mull   -0x18(%ebp)
  802661:	39 d6                	cmp    %edx,%esi
  802663:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802666:	72 30                	jb     802698 <__udivdi3+0x118>
  802668:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80266b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80266f:	d3 e2                	shl    %cl,%edx
  802671:	39 c2                	cmp    %eax,%edx
  802673:	73 05                	jae    80267a <__udivdi3+0xfa>
  802675:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802678:	74 1e                	je     802698 <__udivdi3+0x118>
  80267a:	89 f9                	mov    %edi,%ecx
  80267c:	31 ff                	xor    %edi,%edi
  80267e:	e9 71 ff ff ff       	jmp    8025f4 <__udivdi3+0x74>
  802683:	90                   	nop
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	31 ff                	xor    %edi,%edi
  80268a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80268f:	e9 60 ff ff ff       	jmp    8025f4 <__udivdi3+0x74>
  802694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802698:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80269b:	31 ff                	xor    %edi,%edi
  80269d:	89 c8                	mov    %ecx,%eax
  80269f:	89 fa                	mov    %edi,%edx
  8026a1:	83 c4 10             	add    $0x10,%esp
  8026a4:	5e                   	pop    %esi
  8026a5:	5f                   	pop    %edi
  8026a6:	5d                   	pop    %ebp
  8026a7:	c3                   	ret    
	...

008026b0 <__umoddi3>:
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	57                   	push   %edi
  8026b4:	56                   	push   %esi
  8026b5:	83 ec 20             	sub    $0x20,%esp
  8026b8:	8b 55 14             	mov    0x14(%ebp),%edx
  8026bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026be:	8b 7d 10             	mov    0x10(%ebp),%edi
  8026c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026c4:	85 d2                	test   %edx,%edx
  8026c6:	89 c8                	mov    %ecx,%eax
  8026c8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8026cb:	75 13                	jne    8026e0 <__umoddi3+0x30>
  8026cd:	39 f7                	cmp    %esi,%edi
  8026cf:	76 3f                	jbe    802710 <__umoddi3+0x60>
  8026d1:	89 f2                	mov    %esi,%edx
  8026d3:	f7 f7                	div    %edi
  8026d5:	89 d0                	mov    %edx,%eax
  8026d7:	31 d2                	xor    %edx,%edx
  8026d9:	83 c4 20             	add    $0x20,%esp
  8026dc:	5e                   	pop    %esi
  8026dd:	5f                   	pop    %edi
  8026de:	5d                   	pop    %ebp
  8026df:	c3                   	ret    
  8026e0:	39 f2                	cmp    %esi,%edx
  8026e2:	77 4c                	ja     802730 <__umoddi3+0x80>
  8026e4:	0f bd ca             	bsr    %edx,%ecx
  8026e7:	83 f1 1f             	xor    $0x1f,%ecx
  8026ea:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8026ed:	75 51                	jne    802740 <__umoddi3+0x90>
  8026ef:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8026f2:	0f 87 e0 00 00 00    	ja     8027d8 <__umoddi3+0x128>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	29 f8                	sub    %edi,%eax
  8026fd:	19 d6                	sbb    %edx,%esi
  8026ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	89 f2                	mov    %esi,%edx
  802707:	83 c4 20             	add    $0x20,%esp
  80270a:	5e                   	pop    %esi
  80270b:	5f                   	pop    %edi
  80270c:	5d                   	pop    %ebp
  80270d:	c3                   	ret    
  80270e:	66 90                	xchg   %ax,%ax
  802710:	85 ff                	test   %edi,%edi
  802712:	75 0b                	jne    80271f <__umoddi3+0x6f>
  802714:	b8 01 00 00 00       	mov    $0x1,%eax
  802719:	31 d2                	xor    %edx,%edx
  80271b:	f7 f7                	div    %edi
  80271d:	89 c7                	mov    %eax,%edi
  80271f:	89 f0                	mov    %esi,%eax
  802721:	31 d2                	xor    %edx,%edx
  802723:	f7 f7                	div    %edi
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	f7 f7                	div    %edi
  80272a:	eb a9                	jmp    8026d5 <__umoddi3+0x25>
  80272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802730:	89 c8                	mov    %ecx,%eax
  802732:	89 f2                	mov    %esi,%edx
  802734:	83 c4 20             	add    $0x20,%esp
  802737:	5e                   	pop    %esi
  802738:	5f                   	pop    %edi
  802739:	5d                   	pop    %ebp
  80273a:	c3                   	ret    
  80273b:	90                   	nop
  80273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802740:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802744:	d3 e2                	shl    %cl,%edx
  802746:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802749:	ba 20 00 00 00       	mov    $0x20,%edx
  80274e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802751:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802754:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802758:	89 fa                	mov    %edi,%edx
  80275a:	d3 ea                	shr    %cl,%edx
  80275c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802760:	0b 55 f4             	or     -0xc(%ebp),%edx
  802763:	d3 e7                	shl    %cl,%edi
  802765:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802769:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80276c:	89 f2                	mov    %esi,%edx
  80276e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802771:	89 c7                	mov    %eax,%edi
  802773:	d3 ea                	shr    %cl,%edx
  802775:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802779:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80277c:	89 c2                	mov    %eax,%edx
  80277e:	d3 e6                	shl    %cl,%esi
  802780:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802784:	d3 ea                	shr    %cl,%edx
  802786:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80278a:	09 d6                	or     %edx,%esi
  80278c:	89 f0                	mov    %esi,%eax
  80278e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802791:	d3 e7                	shl    %cl,%edi
  802793:	89 f2                	mov    %esi,%edx
  802795:	f7 75 f4             	divl   -0xc(%ebp)
  802798:	89 d6                	mov    %edx,%esi
  80279a:	f7 65 e8             	mull   -0x18(%ebp)
  80279d:	39 d6                	cmp    %edx,%esi
  80279f:	72 2b                	jb     8027cc <__umoddi3+0x11c>
  8027a1:	39 c7                	cmp    %eax,%edi
  8027a3:	72 23                	jb     8027c8 <__umoddi3+0x118>
  8027a5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027a9:	29 c7                	sub    %eax,%edi
  8027ab:	19 d6                	sbb    %edx,%esi
  8027ad:	89 f0                	mov    %esi,%eax
  8027af:	89 f2                	mov    %esi,%edx
  8027b1:	d3 ef                	shr    %cl,%edi
  8027b3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027b7:	d3 e0                	shl    %cl,%eax
  8027b9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027bd:	09 f8                	or     %edi,%eax
  8027bf:	d3 ea                	shr    %cl,%edx
  8027c1:	83 c4 20             	add    $0x20,%esp
  8027c4:	5e                   	pop    %esi
  8027c5:	5f                   	pop    %edi
  8027c6:	5d                   	pop    %ebp
  8027c7:	c3                   	ret    
  8027c8:	39 d6                	cmp    %edx,%esi
  8027ca:	75 d9                	jne    8027a5 <__umoddi3+0xf5>
  8027cc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027cf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8027d2:	eb d1                	jmp    8027a5 <__umoddi3+0xf5>
  8027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	39 f2                	cmp    %esi,%edx
  8027da:	0f 82 18 ff ff ff    	jb     8026f8 <__umoddi3+0x48>
  8027e0:	e9 1d ff ff ff       	jmp    802702 <__umoddi3+0x52>
