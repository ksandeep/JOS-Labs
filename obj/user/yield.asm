
obj/user/yield:     file format elf32-i386


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
  80002c:	e8 6f 00 00 00       	call   8000a0 <libmain>
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
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", env->env_id);
  80003b:	a1 74 60 80 00       	mov    0x806074,%eax
  800040:	8b 40 4c             	mov    0x4c(%eax),%eax
  800043:	89 44 24 04          	mov    %eax,0x4(%esp)
  800047:	c7 04 24 40 28 80 00 	movl   $0x802840,(%esp)
  80004e:	e8 1a 01 00 00       	call   80016d <cprintf>
  800053:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < 5; i++) {
		sys_yield();
  800058:	e8 1d 10 00 00       	call   80107a <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			env->env_id, i);
  80005d:	a1 74 60 80 00       	mov    0x806074,%eax
	int i;

	cprintf("Hello, I am environment %08x.\n", env->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  800062:	8b 40 4c             	mov    0x4c(%eax),%eax
  800065:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800069:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006d:	c7 04 24 60 28 80 00 	movl   $0x802860,(%esp)
  800074:	e8 f4 00 00 00       	call   80016d <cprintf>
umain(void)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", env->env_id);
	for (i = 0; i < 5; i++) {
  800079:	83 c3 01             	add    $0x1,%ebx
  80007c:	83 fb 05             	cmp    $0x5,%ebx
  80007f:	75 d7                	jne    800058 <umain+0x24>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			env->env_id, i);
	}
	cprintf("All done in environment %08x.\n", env->env_id);
  800081:	a1 74 60 80 00       	mov    0x806074,%eax
  800086:	8b 40 4c             	mov    0x4c(%eax),%eax
  800089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008d:	c7 04 24 8c 28 80 00 	movl   $0x80288c,(%esp)
  800094:	e8 d4 00 00 00       	call   80016d <cprintf>
}
  800099:	83 c4 14             	add    $0x14,%esp
  80009c:	5b                   	pop    %ebx
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    
	...

008000a0 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 18             	sub    $0x18,%esp
  8000a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8000af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8000b2:	e8 f7 0f 00 00       	call   8010ae <sys_getenvid>
	env = &envs[ENVX(envid)];
  8000b7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000bc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c4:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c9:	85 f6                	test   %esi,%esi
  8000cb:	7e 07                	jle    8000d4 <libmain+0x34>
		binaryname = argv[0];
  8000cd:	8b 03                	mov    (%ebx),%eax
  8000cf:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  8000d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d8:	89 34 24             	mov    %esi,(%esp)
  8000db:	e8 54 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000e0:	e8 0b 00 00 00       	call   8000f0 <exit>
}
  8000e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000e8:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000eb:	89 ec                	mov    %ebp,%esp
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    
	...

008000f0 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000f6:	e8 20 15 00 00       	call   80161b <close_all>
	sys_env_destroy(0);
  8000fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800102:	e8 db 0f 00 00       	call   8010e2 <sys_env_destroy>
}
  800107:	c9                   	leave  
  800108:	c3                   	ret    
  800109:	00 00                	add    %al,(%eax)
	...

0080010c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80010c:	55                   	push   %ebp
  80010d:	89 e5                	mov    %esp,%ebp
  80010f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800115:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80011c:	00 00 00 
	b.cnt = 0;
  80011f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800126:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80012c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800130:	8b 45 08             	mov    0x8(%ebp),%eax
  800133:	89 44 24 08          	mov    %eax,0x8(%esp)
  800137:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800141:	c7 04 24 87 01 80 00 	movl   $0x800187,(%esp)
  800148:	e8 d0 01 00 00       	call   80031d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80014d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800153:	89 44 24 04          	mov    %eax,0x4(%esp)
  800157:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80015d:	89 04 24             	mov    %eax,(%esp)
  800160:	e8 bb 0a 00 00       	call   800c20 <sys_cputs>

	return b.cnt;
}
  800165:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80016b:	c9                   	leave  
  80016c:	c3                   	ret    

0080016d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800173:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800176:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017a:	8b 45 08             	mov    0x8(%ebp),%eax
  80017d:	89 04 24             	mov    %eax,(%esp)
  800180:	e8 87 ff ff ff       	call   80010c <vcprintf>
	va_end(ap);

	return cnt;
}
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	53                   	push   %ebx
  80018b:	83 ec 14             	sub    $0x14,%esp
  80018e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800191:	8b 03                	mov    (%ebx),%eax
  800193:	8b 55 08             	mov    0x8(%ebp),%edx
  800196:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80019a:	83 c0 01             	add    $0x1,%eax
  80019d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80019f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a4:	75 19                	jne    8001bf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001a6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001ad:	00 
  8001ae:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b1:	89 04 24             	mov    %eax,(%esp)
  8001b4:	e8 67 0a 00 00       	call   800c20 <sys_cputs>
		b->idx = 0;
  8001b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001bf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c3:	83 c4 14             	add    $0x14,%esp
  8001c6:	5b                   	pop    %ebx
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    
  8001c9:	00 00                	add    %al,(%eax)
  8001cb:	00 00                	add    %al,(%eax)
  8001cd:	00 00                	add    %al,(%eax)
	...

008001d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	57                   	push   %edi
  8001d4:	56                   	push   %esi
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 4c             	sub    $0x4c,%esp
  8001d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001dc:	89 d6                	mov    %edx,%esi
  8001de:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001f0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001fb:	39 d1                	cmp    %edx,%ecx
  8001fd:	72 15                	jb     800214 <printnum+0x44>
  8001ff:	77 07                	ja     800208 <printnum+0x38>
  800201:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800204:	39 d0                	cmp    %edx,%eax
  800206:	76 0c                	jbe    800214 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800208:	83 eb 01             	sub    $0x1,%ebx
  80020b:	85 db                	test   %ebx,%ebx
  80020d:	8d 76 00             	lea    0x0(%esi),%esi
  800210:	7f 61                	jg     800273 <printnum+0xa3>
  800212:	eb 70                	jmp    800284 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800214:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800218:	83 eb 01             	sub    $0x1,%ebx
  80021b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80021f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800223:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800227:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80022b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80022e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800231:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800234:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800238:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80023f:	00 
  800240:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800243:	89 04 24             	mov    %eax,(%esp)
  800246:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800249:	89 54 24 04          	mov    %edx,0x4(%esp)
  80024d:	e8 6e 23 00 00       	call   8025c0 <__udivdi3>
  800252:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800255:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800258:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80025c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800260:	89 04 24             	mov    %eax,(%esp)
  800263:	89 54 24 04          	mov    %edx,0x4(%esp)
  800267:	89 f2                	mov    %esi,%edx
  800269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026c:	e8 5f ff ff ff       	call   8001d0 <printnum>
  800271:	eb 11                	jmp    800284 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800273:	89 74 24 04          	mov    %esi,0x4(%esp)
  800277:	89 3c 24             	mov    %edi,(%esp)
  80027a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80027d:	83 eb 01             	sub    $0x1,%ebx
  800280:	85 db                	test   %ebx,%ebx
  800282:	7f ef                	jg     800273 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800284:	89 74 24 04          	mov    %esi,0x4(%esp)
  800288:	8b 74 24 04          	mov    0x4(%esp),%esi
  80028c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800293:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80029a:	00 
  80029b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80029e:	89 14 24             	mov    %edx,(%esp)
  8002a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8002a4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8002a8:	e8 43 24 00 00       	call   8026f0 <__umoddi3>
  8002ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b1:	0f be 80 c2 28 80 00 	movsbl 0x8028c2(%eax),%eax
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002be:	83 c4 4c             	add    $0x4c,%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002c9:	83 fa 01             	cmp    $0x1,%edx
  8002cc:	7e 0e                	jle    8002dc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002ce:	8b 10                	mov    (%eax),%edx
  8002d0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002d3:	89 08                	mov    %ecx,(%eax)
  8002d5:	8b 02                	mov    (%edx),%eax
  8002d7:	8b 52 04             	mov    0x4(%edx),%edx
  8002da:	eb 22                	jmp    8002fe <getuint+0x38>
	else if (lflag)
  8002dc:	85 d2                	test   %edx,%edx
  8002de:	74 10                	je     8002f0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002e0:	8b 10                	mov    (%eax),%edx
  8002e2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 02                	mov    (%edx),%eax
  8002e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ee:	eb 0e                	jmp    8002fe <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002f5:	89 08                	mov    %ecx,(%eax)
  8002f7:	8b 02                	mov    (%edx),%eax
  8002f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002fe:	5d                   	pop    %ebp
  8002ff:	c3                   	ret    

00800300 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800306:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80030a:	8b 10                	mov    (%eax),%edx
  80030c:	3b 50 04             	cmp    0x4(%eax),%edx
  80030f:	73 0a                	jae    80031b <sprintputch+0x1b>
		*b->buf++ = ch;
  800311:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800314:	88 0a                	mov    %cl,(%edx)
  800316:	83 c2 01             	add    $0x1,%edx
  800319:	89 10                	mov    %edx,(%eax)
}
  80031b:	5d                   	pop    %ebp
  80031c:	c3                   	ret    

0080031d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	57                   	push   %edi
  800321:	56                   	push   %esi
  800322:	53                   	push   %ebx
  800323:	83 ec 5c             	sub    $0x5c,%esp
  800326:	8b 7d 08             	mov    0x8(%ebp),%edi
  800329:	8b 75 0c             	mov    0xc(%ebp),%esi
  80032c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80032f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800336:	eb 11                	jmp    800349 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800338:	85 c0                	test   %eax,%eax
  80033a:	0f 84 ec 03 00 00    	je     80072c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800340:	89 74 24 04          	mov    %esi,0x4(%esp)
  800344:	89 04 24             	mov    %eax,(%esp)
  800347:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800349:	0f b6 03             	movzbl (%ebx),%eax
  80034c:	83 c3 01             	add    $0x1,%ebx
  80034f:	83 f8 25             	cmp    $0x25,%eax
  800352:	75 e4                	jne    800338 <vprintfmt+0x1b>
  800354:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800358:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80035f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800366:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80036d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800372:	eb 06                	jmp    80037a <vprintfmt+0x5d>
  800374:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800378:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	0f b6 13             	movzbl (%ebx),%edx
  80037d:	0f b6 c2             	movzbl %dl,%eax
  800380:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800383:	8d 43 01             	lea    0x1(%ebx),%eax
  800386:	83 ea 23             	sub    $0x23,%edx
  800389:	80 fa 55             	cmp    $0x55,%dl
  80038c:	0f 87 7d 03 00 00    	ja     80070f <vprintfmt+0x3f2>
  800392:	0f b6 d2             	movzbl %dl,%edx
  800395:	ff 24 95 00 2a 80 00 	jmp    *0x802a00(,%edx,4)
  80039c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003a0:	eb d6                	jmp    800378 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a5:	83 ea 30             	sub    $0x30,%edx
  8003a8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8003ab:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8003ae:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8003b1:	83 fb 09             	cmp    $0x9,%ebx
  8003b4:	77 4c                	ja     800402 <vprintfmt+0xe5>
  8003b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003b9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003bc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8003bf:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003c2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8003c6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8003c9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8003cc:	83 fb 09             	cmp    $0x9,%ebx
  8003cf:	76 eb                	jbe    8003bc <vprintfmt+0x9f>
  8003d1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003d4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003d7:	eb 29                	jmp    800402 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8003dc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8003df:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8003e2:	8b 12                	mov    (%edx),%edx
  8003e4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8003e7:	eb 19                	jmp    800402 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8003e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003ec:	c1 fa 1f             	sar    $0x1f,%edx
  8003ef:	f7 d2                	not    %edx
  8003f1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8003f4:	eb 82                	jmp    800378 <vprintfmt+0x5b>
  8003f6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003fd:	e9 76 ff ff ff       	jmp    800378 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800402:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800406:	0f 89 6c ff ff ff    	jns    800378 <vprintfmt+0x5b>
  80040c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80040f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800412:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800415:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800418:	e9 5b ff ff ff       	jmp    800378 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80041d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800420:	e9 53 ff ff ff       	jmp    800378 <vprintfmt+0x5b>
  800425:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800428:	8b 45 14             	mov    0x14(%ebp),%eax
  80042b:	8d 50 04             	lea    0x4(%eax),%edx
  80042e:	89 55 14             	mov    %edx,0x14(%ebp)
  800431:	89 74 24 04          	mov    %esi,0x4(%esp)
  800435:	8b 00                	mov    (%eax),%eax
  800437:	89 04 24             	mov    %eax,(%esp)
  80043a:	ff d7                	call   *%edi
  80043c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80043f:	e9 05 ff ff ff       	jmp    800349 <vprintfmt+0x2c>
  800444:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800447:	8b 45 14             	mov    0x14(%ebp),%eax
  80044a:	8d 50 04             	lea    0x4(%eax),%edx
  80044d:	89 55 14             	mov    %edx,0x14(%ebp)
  800450:	8b 00                	mov    (%eax),%eax
  800452:	89 c2                	mov    %eax,%edx
  800454:	c1 fa 1f             	sar    $0x1f,%edx
  800457:	31 d0                	xor    %edx,%eax
  800459:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80045b:	83 f8 0f             	cmp    $0xf,%eax
  80045e:	7f 0b                	jg     80046b <vprintfmt+0x14e>
  800460:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  800467:	85 d2                	test   %edx,%edx
  800469:	75 20                	jne    80048b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80046b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046f:	c7 44 24 08 d3 28 80 	movl   $0x8028d3,0x8(%esp)
  800476:	00 
  800477:	89 74 24 04          	mov    %esi,0x4(%esp)
  80047b:	89 3c 24             	mov    %edi,(%esp)
  80047e:	e8 31 03 00 00       	call   8007b4 <printfmt>
  800483:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800486:	e9 be fe ff ff       	jmp    800349 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80048b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048f:	c7 44 24 08 a6 2c 80 	movl   $0x802ca6,0x8(%esp)
  800496:	00 
  800497:	89 74 24 04          	mov    %esi,0x4(%esp)
  80049b:	89 3c 24             	mov    %edi,(%esp)
  80049e:	e8 11 03 00 00       	call   8007b4 <printfmt>
  8004a3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004a6:	e9 9e fe ff ff       	jmp    800349 <vprintfmt+0x2c>
  8004ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004ae:	89 c3                	mov    %eax,%ebx
  8004b0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bc:	8d 50 04             	lea    0x4(%eax),%edx
  8004bf:	89 55 14             	mov    %edx,0x14(%ebp)
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c7:	85 c0                	test   %eax,%eax
  8004c9:	75 07                	jne    8004d2 <vprintfmt+0x1b5>
  8004cb:	c7 45 e0 dc 28 80 00 	movl   $0x8028dc,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8004d2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8004d6:	7e 06                	jle    8004de <vprintfmt+0x1c1>
  8004d8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004dc:	75 13                	jne    8004f1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e1:	0f be 02             	movsbl (%edx),%eax
  8004e4:	85 c0                	test   %eax,%eax
  8004e6:	0f 85 99 00 00 00    	jne    800585 <vprintfmt+0x268>
  8004ec:	e9 86 00 00 00       	jmp    800577 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004f5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f8:	89 0c 24             	mov    %ecx,(%esp)
  8004fb:	e8 fb 02 00 00       	call   8007fb <strnlen>
  800500:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800503:	29 c2                	sub    %eax,%edx
  800505:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800508:	85 d2                	test   %edx,%edx
  80050a:	7e d2                	jle    8004de <vprintfmt+0x1c1>
					putch(padc, putdat);
  80050c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800510:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800513:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800516:	89 d3                	mov    %edx,%ebx
  800518:	89 74 24 04          	mov    %esi,0x4(%esp)
  80051c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800524:	83 eb 01             	sub    $0x1,%ebx
  800527:	85 db                	test   %ebx,%ebx
  800529:	7f ed                	jg     800518 <vprintfmt+0x1fb>
  80052b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80052e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800535:	eb a7                	jmp    8004de <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800537:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80053b:	74 18                	je     800555 <vprintfmt+0x238>
  80053d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800540:	83 fa 5e             	cmp    $0x5e,%edx
  800543:	76 10                	jbe    800555 <vprintfmt+0x238>
					putch('?', putdat);
  800545:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800549:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800550:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800553:	eb 0a                	jmp    80055f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800555:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800559:	89 04 24             	mov    %eax,(%esp)
  80055c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800563:	0f be 03             	movsbl (%ebx),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	74 05                	je     80056f <vprintfmt+0x252>
  80056a:	83 c3 01             	add    $0x1,%ebx
  80056d:	eb 29                	jmp    800598 <vprintfmt+0x27b>
  80056f:	89 fe                	mov    %edi,%esi
  800571:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800574:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800577:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80057b:	7f 2e                	jg     8005ab <vprintfmt+0x28e>
  80057d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800580:	e9 c4 fd ff ff       	jmp    800349 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800585:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800588:	83 c2 01             	add    $0x1,%edx
  80058b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80058e:	89 f7                	mov    %esi,%edi
  800590:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800593:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800596:	89 d3                	mov    %edx,%ebx
  800598:	85 f6                	test   %esi,%esi
  80059a:	78 9b                	js     800537 <vprintfmt+0x21a>
  80059c:	83 ee 01             	sub    $0x1,%esi
  80059f:	79 96                	jns    800537 <vprintfmt+0x21a>
  8005a1:	89 fe                	mov    %edi,%esi
  8005a3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005a6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005a9:	eb cc                	jmp    800577 <vprintfmt+0x25a>
  8005ab:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8005ae:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005b5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005bc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005be:	83 eb 01             	sub    $0x1,%ebx
  8005c1:	85 db                	test   %ebx,%ebx
  8005c3:	7f ec                	jg     8005b1 <vprintfmt+0x294>
  8005c5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8005c8:	e9 7c fd ff ff       	jmp    800349 <vprintfmt+0x2c>
  8005cd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005d0:	83 f9 01             	cmp    $0x1,%ecx
  8005d3:	7e 16                	jle    8005eb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 50 08             	lea    0x8(%eax),%edx
  8005db:	89 55 14             	mov    %edx,0x14(%ebp)
  8005de:	8b 10                	mov    (%eax),%edx
  8005e0:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8005e6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005e9:	eb 32                	jmp    80061d <vprintfmt+0x300>
	else if (lflag)
  8005eb:	85 c9                	test   %ecx,%ecx
  8005ed:	74 18                	je     800607 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 50 04             	lea    0x4(%eax),%edx
  8005f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fd:	89 c1                	mov    %eax,%ecx
  8005ff:	c1 f9 1f             	sar    $0x1f,%ecx
  800602:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800605:	eb 16                	jmp    80061d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8d 50 04             	lea    0x4(%eax),%edx
  80060d:	89 55 14             	mov    %edx,0x14(%ebp)
  800610:	8b 00                	mov    (%eax),%eax
  800612:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800615:	89 c2                	mov    %eax,%edx
  800617:	c1 fa 1f             	sar    $0x1f,%edx
  80061a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80061d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800620:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800623:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800628:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80062c:	0f 89 9b 00 00 00    	jns    8006cd <vprintfmt+0x3b0>
				putch('-', putdat);
  800632:	89 74 24 04          	mov    %esi,0x4(%esp)
  800636:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80063d:	ff d7                	call   *%edi
				num = -(long long) num;
  80063f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800642:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800645:	f7 d9                	neg    %ecx
  800647:	83 d3 00             	adc    $0x0,%ebx
  80064a:	f7 db                	neg    %ebx
  80064c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800651:	eb 7a                	jmp    8006cd <vprintfmt+0x3b0>
  800653:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800656:	89 ca                	mov    %ecx,%edx
  800658:	8d 45 14             	lea    0x14(%ebp),%eax
  80065b:	e8 66 fc ff ff       	call   8002c6 <getuint>
  800660:	89 c1                	mov    %eax,%ecx
  800662:	89 d3                	mov    %edx,%ebx
  800664:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800669:	eb 62                	jmp    8006cd <vprintfmt+0x3b0>
  80066b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80066e:	89 ca                	mov    %ecx,%edx
  800670:	8d 45 14             	lea    0x14(%ebp),%eax
  800673:	e8 4e fc ff ff       	call   8002c6 <getuint>
  800678:	89 c1                	mov    %eax,%ecx
  80067a:	89 d3                	mov    %edx,%ebx
  80067c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800681:	eb 4a                	jmp    8006cd <vprintfmt+0x3b0>
  800683:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800686:	89 74 24 04          	mov    %esi,0x4(%esp)
  80068a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800691:	ff d7                	call   *%edi
			putch('x', putdat);
  800693:	89 74 24 04          	mov    %esi,0x4(%esp)
  800697:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80069e:	ff d7                	call   *%edi
			num = (unsigned long long)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 50 04             	lea    0x4(%eax),%edx
  8006a6:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a9:	8b 08                	mov    (%eax),%ecx
  8006ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006b5:	eb 16                	jmp    8006cd <vprintfmt+0x3b0>
  8006b7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006ba:	89 ca                	mov    %ecx,%edx
  8006bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8006bf:	e8 02 fc ff ff       	call   8002c6 <getuint>
  8006c4:	89 c1                	mov    %eax,%ecx
  8006c6:	89 d3                	mov    %edx,%ebx
  8006c8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006cd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8006d1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e0:	89 0c 24             	mov    %ecx,(%esp)
  8006e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006e7:	89 f2                	mov    %esi,%edx
  8006e9:	89 f8                	mov    %edi,%eax
  8006eb:	e8 e0 fa ff ff       	call   8001d0 <printnum>
  8006f0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006f3:	e9 51 fc ff ff       	jmp    800349 <vprintfmt+0x2c>
  8006f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8006fb:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800702:	89 14 24             	mov    %edx,(%esp)
  800705:	ff d7                	call   *%edi
  800707:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80070a:	e9 3a fc ff ff       	jmp    800349 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80070f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800713:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80071a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80071c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80071f:	80 38 25             	cmpb   $0x25,(%eax)
  800722:	0f 84 21 fc ff ff    	je     800349 <vprintfmt+0x2c>
  800728:	89 c3                	mov    %eax,%ebx
  80072a:	eb f0                	jmp    80071c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80072c:	83 c4 5c             	add    $0x5c,%esp
  80072f:	5b                   	pop    %ebx
  800730:	5e                   	pop    %esi
  800731:	5f                   	pop    %edi
  800732:	5d                   	pop    %ebp
  800733:	c3                   	ret    

00800734 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	83 ec 28             	sub    $0x28,%esp
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800740:	85 c0                	test   %eax,%eax
  800742:	74 04                	je     800748 <vsnprintf+0x14>
  800744:	85 d2                	test   %edx,%edx
  800746:	7f 07                	jg     80074f <vsnprintf+0x1b>
  800748:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074d:	eb 3b                	jmp    80078a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800752:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800767:	8b 45 10             	mov    0x10(%ebp),%eax
  80076a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800771:	89 44 24 04          	mov    %eax,0x4(%esp)
  800775:	c7 04 24 00 03 80 00 	movl   $0x800300,(%esp)
  80077c:	e8 9c fb ff ff       	call   80031d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800784:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800787:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    

0080078c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800792:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800795:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800799:	8b 45 10             	mov    0x10(%ebp),%eax
  80079c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	89 04 24             	mov    %eax,(%esp)
  8007ad:	e8 82 ff ff ff       	call   800734 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b2:	c9                   	leave  
  8007b3:	c3                   	ret    

008007b4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8007ba:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8007bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	89 04 24             	mov    %eax,(%esp)
  8007d5:	e8 43 fb ff ff       	call   80031d <vprintfmt>
	va_end(ap);
}
  8007da:	c9                   	leave  
  8007db:	c3                   	ret    
  8007dc:	00 00                	add    %al,(%eax)
	...

008007e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	80 3a 00             	cmpb   $0x0,(%edx)
  8007ee:	74 09                	je     8007f9 <strlen+0x19>
		n++;
  8007f0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f7:	75 f7                	jne    8007f0 <strlen+0x10>
		n++;
	return n;
}
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	53                   	push   %ebx
  8007ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800802:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800805:	85 c9                	test   %ecx,%ecx
  800807:	74 19                	je     800822 <strnlen+0x27>
  800809:	80 3b 00             	cmpb   $0x0,(%ebx)
  80080c:	74 14                	je     800822 <strnlen+0x27>
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800813:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800816:	39 c8                	cmp    %ecx,%eax
  800818:	74 0d                	je     800827 <strnlen+0x2c>
  80081a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80081e:	75 f3                	jne    800813 <strnlen+0x18>
  800820:	eb 05                	jmp    800827 <strnlen+0x2c>
  800822:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800827:	5b                   	pop    %ebx
  800828:	5d                   	pop    %ebp
  800829:	c3                   	ret    

0080082a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	53                   	push   %ebx
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800834:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800839:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80083d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800840:	83 c2 01             	add    $0x1,%edx
  800843:	84 c9                	test   %cl,%cl
  800845:	75 f2                	jne    800839 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800847:	5b                   	pop    %ebx
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	56                   	push   %esi
  80084e:	53                   	push   %ebx
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 55 0c             	mov    0xc(%ebp),%edx
  800855:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800858:	85 f6                	test   %esi,%esi
  80085a:	74 18                	je     800874 <strncpy+0x2a>
  80085c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800861:	0f b6 1a             	movzbl (%edx),%ebx
  800864:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800867:	80 3a 01             	cmpb   $0x1,(%edx)
  80086a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80086d:	83 c1 01             	add    $0x1,%ecx
  800870:	39 ce                	cmp    %ecx,%esi
  800872:	77 ed                	ja     800861 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800874:	5b                   	pop    %ebx
  800875:	5e                   	pop    %esi
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	56                   	push   %esi
  80087c:	53                   	push   %ebx
  80087d:	8b 75 08             	mov    0x8(%ebp),%esi
  800880:	8b 55 0c             	mov    0xc(%ebp),%edx
  800883:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800886:	89 f0                	mov    %esi,%eax
  800888:	85 c9                	test   %ecx,%ecx
  80088a:	74 27                	je     8008b3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80088c:	83 e9 01             	sub    $0x1,%ecx
  80088f:	74 1d                	je     8008ae <strlcpy+0x36>
  800891:	0f b6 1a             	movzbl (%edx),%ebx
  800894:	84 db                	test   %bl,%bl
  800896:	74 16                	je     8008ae <strlcpy+0x36>
			*dst++ = *src++;
  800898:	88 18                	mov    %bl,(%eax)
  80089a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80089d:	83 e9 01             	sub    $0x1,%ecx
  8008a0:	74 0e                	je     8008b0 <strlcpy+0x38>
			*dst++ = *src++;
  8008a2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008a5:	0f b6 1a             	movzbl (%edx),%ebx
  8008a8:	84 db                	test   %bl,%bl
  8008aa:	75 ec                	jne    800898 <strlcpy+0x20>
  8008ac:	eb 02                	jmp    8008b0 <strlcpy+0x38>
  8008ae:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008b0:	c6 00 00             	movb   $0x0,(%eax)
  8008b3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8008b5:	5b                   	pop    %ebx
  8008b6:	5e                   	pop    %esi
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c2:	0f b6 01             	movzbl (%ecx),%eax
  8008c5:	84 c0                	test   %al,%al
  8008c7:	74 15                	je     8008de <strcmp+0x25>
  8008c9:	3a 02                	cmp    (%edx),%al
  8008cb:	75 11                	jne    8008de <strcmp+0x25>
		p++, q++;
  8008cd:	83 c1 01             	add    $0x1,%ecx
  8008d0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008d3:	0f b6 01             	movzbl (%ecx),%eax
  8008d6:	84 c0                	test   %al,%al
  8008d8:	74 04                	je     8008de <strcmp+0x25>
  8008da:	3a 02                	cmp    (%edx),%al
  8008dc:	74 ef                	je     8008cd <strcmp+0x14>
  8008de:	0f b6 c0             	movzbl %al,%eax
  8008e1:	0f b6 12             	movzbl (%edx),%edx
  8008e4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	53                   	push   %ebx
  8008ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  8008f5:	85 c0                	test   %eax,%eax
  8008f7:	74 23                	je     80091c <strncmp+0x34>
  8008f9:	0f b6 1a             	movzbl (%edx),%ebx
  8008fc:	84 db                	test   %bl,%bl
  8008fe:	74 24                	je     800924 <strncmp+0x3c>
  800900:	3a 19                	cmp    (%ecx),%bl
  800902:	75 20                	jne    800924 <strncmp+0x3c>
  800904:	83 e8 01             	sub    $0x1,%eax
  800907:	74 13                	je     80091c <strncmp+0x34>
		n--, p++, q++;
  800909:	83 c2 01             	add    $0x1,%edx
  80090c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80090f:	0f b6 1a             	movzbl (%edx),%ebx
  800912:	84 db                	test   %bl,%bl
  800914:	74 0e                	je     800924 <strncmp+0x3c>
  800916:	3a 19                	cmp    (%ecx),%bl
  800918:	74 ea                	je     800904 <strncmp+0x1c>
  80091a:	eb 08                	jmp    800924 <strncmp+0x3c>
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800921:	5b                   	pop    %ebx
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800924:	0f b6 02             	movzbl (%edx),%eax
  800927:	0f b6 11             	movzbl (%ecx),%edx
  80092a:	29 d0                	sub    %edx,%eax
  80092c:	eb f3                	jmp    800921 <strncmp+0x39>

0080092e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800938:	0f b6 10             	movzbl (%eax),%edx
  80093b:	84 d2                	test   %dl,%dl
  80093d:	74 15                	je     800954 <strchr+0x26>
		if (*s == c)
  80093f:	38 ca                	cmp    %cl,%dl
  800941:	75 07                	jne    80094a <strchr+0x1c>
  800943:	eb 14                	jmp    800959 <strchr+0x2b>
  800945:	38 ca                	cmp    %cl,%dl
  800947:	90                   	nop
  800948:	74 0f                	je     800959 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80094a:	83 c0 01             	add    $0x1,%eax
  80094d:	0f b6 10             	movzbl (%eax),%edx
  800950:	84 d2                	test   %dl,%dl
  800952:	75 f1                	jne    800945 <strchr+0x17>
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800965:	0f b6 10             	movzbl (%eax),%edx
  800968:	84 d2                	test   %dl,%dl
  80096a:	74 18                	je     800984 <strfind+0x29>
		if (*s == c)
  80096c:	38 ca                	cmp    %cl,%dl
  80096e:	75 0a                	jne    80097a <strfind+0x1f>
  800970:	eb 12                	jmp    800984 <strfind+0x29>
  800972:	38 ca                	cmp    %cl,%dl
  800974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800978:	74 0a                	je     800984 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	0f b6 10             	movzbl (%eax),%edx
  800980:	84 d2                	test   %dl,%dl
  800982:	75 ee                	jne    800972 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	89 1c 24             	mov    %ebx,(%esp)
  80098f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800993:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800997:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a0:	85 c9                	test   %ecx,%ecx
  8009a2:	74 30                	je     8009d4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009aa:	75 25                	jne    8009d1 <memset+0x4b>
  8009ac:	f6 c1 03             	test   $0x3,%cl
  8009af:	75 20                	jne    8009d1 <memset+0x4b>
		c &= 0xFF;
  8009b1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b4:	89 d3                	mov    %edx,%ebx
  8009b6:	c1 e3 08             	shl    $0x8,%ebx
  8009b9:	89 d6                	mov    %edx,%esi
  8009bb:	c1 e6 18             	shl    $0x18,%esi
  8009be:	89 d0                	mov    %edx,%eax
  8009c0:	c1 e0 10             	shl    $0x10,%eax
  8009c3:	09 f0                	or     %esi,%eax
  8009c5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8009c7:	09 d8                	or     %ebx,%eax
  8009c9:	c1 e9 02             	shr    $0x2,%ecx
  8009cc:	fc                   	cld    
  8009cd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009cf:	eb 03                	jmp    8009d4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d1:	fc                   	cld    
  8009d2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009d4:	89 f8                	mov    %edi,%eax
  8009d6:	8b 1c 24             	mov    (%esp),%ebx
  8009d9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009dd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009e1:	89 ec                	mov    %ebp,%esp
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	89 34 24             	mov    %esi,(%esp)
  8009ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8009f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009fb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009fd:	39 c6                	cmp    %eax,%esi
  8009ff:	73 35                	jae    800a36 <memmove+0x51>
  800a01:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a04:	39 d0                	cmp    %edx,%eax
  800a06:	73 2e                	jae    800a36 <memmove+0x51>
		s += n;
		d += n;
  800a08:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0a:	f6 c2 03             	test   $0x3,%dl
  800a0d:	75 1b                	jne    800a2a <memmove+0x45>
  800a0f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a15:	75 13                	jne    800a2a <memmove+0x45>
  800a17:	f6 c1 03             	test   $0x3,%cl
  800a1a:	75 0e                	jne    800a2a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a1c:	83 ef 04             	sub    $0x4,%edi
  800a1f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a22:	c1 e9 02             	shr    $0x2,%ecx
  800a25:	fd                   	std    
  800a26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a28:	eb 09                	jmp    800a33 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a2a:	83 ef 01             	sub    $0x1,%edi
  800a2d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a30:	fd                   	std    
  800a31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a33:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a34:	eb 20                	jmp    800a56 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3c:	75 15                	jne    800a53 <memmove+0x6e>
  800a3e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a44:	75 0d                	jne    800a53 <memmove+0x6e>
  800a46:	f6 c1 03             	test   $0x3,%cl
  800a49:	75 08                	jne    800a53 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a4b:	c1 e9 02             	shr    $0x2,%ecx
  800a4e:	fc                   	cld    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a51:	eb 03                	jmp    800a56 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a53:	fc                   	cld    
  800a54:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a56:	8b 34 24             	mov    (%esp),%esi
  800a59:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a5d:	89 ec                	mov    %ebp,%esp
  800a5f:	5d                   	pop    %ebp
  800a60:	c3                   	ret    

00800a61 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a67:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	89 04 24             	mov    %eax,(%esp)
  800a7b:	e8 65 ff ff ff       	call   8009e5 <memmove>
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	57                   	push   %edi
  800a86:	56                   	push   %esi
  800a87:	53                   	push   %ebx
  800a88:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a91:	85 c9                	test   %ecx,%ecx
  800a93:	74 36                	je     800acb <memcmp+0x49>
		if (*s1 != *s2)
  800a95:	0f b6 06             	movzbl (%esi),%eax
  800a98:	0f b6 1f             	movzbl (%edi),%ebx
  800a9b:	38 d8                	cmp    %bl,%al
  800a9d:	74 20                	je     800abf <memcmp+0x3d>
  800a9f:	eb 14                	jmp    800ab5 <memcmp+0x33>
  800aa1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800aa6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800aab:	83 c2 01             	add    $0x1,%edx
  800aae:	83 e9 01             	sub    $0x1,%ecx
  800ab1:	38 d8                	cmp    %bl,%al
  800ab3:	74 12                	je     800ac7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800ab5:	0f b6 c0             	movzbl %al,%eax
  800ab8:	0f b6 db             	movzbl %bl,%ebx
  800abb:	29 d8                	sub    %ebx,%eax
  800abd:	eb 11                	jmp    800ad0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abf:	83 e9 01             	sub    $0x1,%ecx
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	85 c9                	test   %ecx,%ecx
  800ac9:	75 d6                	jne    800aa1 <memcmp+0x1f>
  800acb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800ad0:	5b                   	pop    %ebx
  800ad1:	5e                   	pop    %esi
  800ad2:	5f                   	pop    %edi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800adb:	89 c2                	mov    %eax,%edx
  800add:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae0:	39 d0                	cmp    %edx,%eax
  800ae2:	73 15                	jae    800af9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ae8:	38 08                	cmp    %cl,(%eax)
  800aea:	75 06                	jne    800af2 <memfind+0x1d>
  800aec:	eb 0b                	jmp    800af9 <memfind+0x24>
  800aee:	38 08                	cmp    %cl,(%eax)
  800af0:	74 07                	je     800af9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800af2:	83 c0 01             	add    $0x1,%eax
  800af5:	39 c2                	cmp    %eax,%edx
  800af7:	77 f5                	ja     800aee <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	57                   	push   %edi
  800aff:	56                   	push   %esi
  800b00:	53                   	push   %ebx
  800b01:	83 ec 04             	sub    $0x4,%esp
  800b04:	8b 55 08             	mov    0x8(%ebp),%edx
  800b07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0a:	0f b6 02             	movzbl (%edx),%eax
  800b0d:	3c 20                	cmp    $0x20,%al
  800b0f:	74 04                	je     800b15 <strtol+0x1a>
  800b11:	3c 09                	cmp    $0x9,%al
  800b13:	75 0e                	jne    800b23 <strtol+0x28>
		s++;
  800b15:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b18:	0f b6 02             	movzbl (%edx),%eax
  800b1b:	3c 20                	cmp    $0x20,%al
  800b1d:	74 f6                	je     800b15 <strtol+0x1a>
  800b1f:	3c 09                	cmp    $0x9,%al
  800b21:	74 f2                	je     800b15 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b23:	3c 2b                	cmp    $0x2b,%al
  800b25:	75 0c                	jne    800b33 <strtol+0x38>
		s++;
  800b27:	83 c2 01             	add    $0x1,%edx
  800b2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b31:	eb 15                	jmp    800b48 <strtol+0x4d>
	else if (*s == '-')
  800b33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b3a:	3c 2d                	cmp    $0x2d,%al
  800b3c:	75 0a                	jne    800b48 <strtol+0x4d>
		s++, neg = 1;
  800b3e:	83 c2 01             	add    $0x1,%edx
  800b41:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b48:	85 db                	test   %ebx,%ebx
  800b4a:	0f 94 c0             	sete   %al
  800b4d:	74 05                	je     800b54 <strtol+0x59>
  800b4f:	83 fb 10             	cmp    $0x10,%ebx
  800b52:	75 18                	jne    800b6c <strtol+0x71>
  800b54:	80 3a 30             	cmpb   $0x30,(%edx)
  800b57:	75 13                	jne    800b6c <strtol+0x71>
  800b59:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b5d:	8d 76 00             	lea    0x0(%esi),%esi
  800b60:	75 0a                	jne    800b6c <strtol+0x71>
		s += 2, base = 16;
  800b62:	83 c2 02             	add    $0x2,%edx
  800b65:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6a:	eb 15                	jmp    800b81 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b6c:	84 c0                	test   %al,%al
  800b6e:	66 90                	xchg   %ax,%ax
  800b70:	74 0f                	je     800b81 <strtol+0x86>
  800b72:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b77:	80 3a 30             	cmpb   $0x30,(%edx)
  800b7a:	75 05                	jne    800b81 <strtol+0x86>
		s++, base = 8;
  800b7c:	83 c2 01             	add    $0x1,%edx
  800b7f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
  800b86:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b88:	0f b6 0a             	movzbl (%edx),%ecx
  800b8b:	89 cf                	mov    %ecx,%edi
  800b8d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800b90:	80 fb 09             	cmp    $0x9,%bl
  800b93:	77 08                	ja     800b9d <strtol+0xa2>
			dig = *s - '0';
  800b95:	0f be c9             	movsbl %cl,%ecx
  800b98:	83 e9 30             	sub    $0x30,%ecx
  800b9b:	eb 1e                	jmp    800bbb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800b9d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ba0:	80 fb 19             	cmp    $0x19,%bl
  800ba3:	77 08                	ja     800bad <strtol+0xb2>
			dig = *s - 'a' + 10;
  800ba5:	0f be c9             	movsbl %cl,%ecx
  800ba8:	83 e9 57             	sub    $0x57,%ecx
  800bab:	eb 0e                	jmp    800bbb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800bad:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800bb0:	80 fb 19             	cmp    $0x19,%bl
  800bb3:	77 15                	ja     800bca <strtol+0xcf>
			dig = *s - 'A' + 10;
  800bb5:	0f be c9             	movsbl %cl,%ecx
  800bb8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bbb:	39 f1                	cmp    %esi,%ecx
  800bbd:	7d 0b                	jge    800bca <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800bbf:	83 c2 01             	add    $0x1,%edx
  800bc2:	0f af c6             	imul   %esi,%eax
  800bc5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800bc8:	eb be                	jmp    800b88 <strtol+0x8d>
  800bca:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 05                	je     800bd7 <strtol+0xdc>
		*endptr = (char *) s;
  800bd2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bd5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800bd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bdb:	74 04                	je     800be1 <strtol+0xe6>
  800bdd:	89 c8                	mov    %ecx,%eax
  800bdf:	f7 d8                	neg    %eax
}
  800be1:	83 c4 04             	add    $0x4,%esp
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    
  800be9:	00 00                	add    %al,(%eax)
	...

00800bec <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 0c             	sub    $0xc,%esp
  800bf2:	89 1c 24             	mov    %ebx,(%esp)
  800bf5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bf9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800c02:	b8 01 00 00 00       	mov    $0x1,%eax
  800c07:	89 d1                	mov    %edx,%ecx
  800c09:	89 d3                	mov    %edx,%ebx
  800c0b:	89 d7                	mov    %edx,%edi
  800c0d:	89 d6                	mov    %edx,%esi
  800c0f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c11:	8b 1c 24             	mov    (%esp),%ebx
  800c14:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c18:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c1c:	89 ec                	mov    %ebp,%esp
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 0c             	sub    $0xc,%esp
  800c26:	89 1c 24             	mov    %ebx,(%esp)
  800c29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c2d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
  800c36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c39:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3c:	89 c3                	mov    %eax,%ebx
  800c3e:	89 c7                	mov    %eax,%edi
  800c40:	89 c6                	mov    %eax,%esi
  800c42:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c44:	8b 1c 24             	mov    (%esp),%ebx
  800c47:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c4b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c4f:	89 ec                	mov    %ebp,%esp
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 38             	sub    $0x38,%esp
  800c59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800c5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800c5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c62:	be 00 00 00 00       	mov    $0x0,%esi
  800c67:	b8 12 00 00 00       	mov    $0x12,%eax
  800c6c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c75:	8b 55 08             	mov    0x8(%ebp),%edx
  800c78:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800c7a:	85 c0                	test   %eax,%eax
  800c7c:	7e 28                	jle    800ca6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c82:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800c89:	00 
  800c8a:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  800c91:	00 
  800c92:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c99:	00 
  800c9a:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  800ca1:	e8 96 17 00 00       	call   80243c <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800ca6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ca9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800caf:	89 ec                	mov    %ebp,%esp
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	89 1c 24             	mov    %ebx,(%esp)
  800cbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cc0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc9:	b8 11 00 00 00       	mov    $0x11,%eax
  800cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd4:	89 df                	mov    %ebx,%edi
  800cd6:	89 de                	mov    %ebx,%esi
  800cd8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800cda:	8b 1c 24             	mov    (%esp),%ebx
  800cdd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ce1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ce5:	89 ec                	mov    %ebp,%esp
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 0c             	sub    $0xc,%esp
  800cef:	89 1c 24             	mov    %ebx,(%esp)
  800cf2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cf6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cff:	b8 10 00 00 00       	mov    $0x10,%eax
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	89 cb                	mov    %ecx,%ebx
  800d09:	89 cf                	mov    %ecx,%edi
  800d0b:	89 ce                	mov    %ecx,%esi
  800d0d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800d0f:	8b 1c 24             	mov    (%esp),%ebx
  800d12:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d16:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d1a:	89 ec                	mov    %ebp,%esp
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	83 ec 38             	sub    $0x38,%esp
  800d24:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d27:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d2a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d32:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	89 df                	mov    %ebx,%edi
  800d3f:	89 de                	mov    %ebx,%esi
  800d41:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7e 28                	jle    800d6f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d47:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d4b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d52:	00 
  800d53:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  800d5a:	00 
  800d5b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d62:	00 
  800d63:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  800d6a:	e8 cd 16 00 00       	call   80243c <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800d6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d78:	89 ec                	mov    %ebp,%esp
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	83 ec 0c             	sub    $0xc,%esp
  800d82:	89 1c 24             	mov    %ebx,(%esp)
  800d85:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d89:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d92:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d97:	89 d1                	mov    %edx,%ecx
  800d99:	89 d3                	mov    %edx,%ebx
  800d9b:	89 d7                	mov    %edx,%edi
  800d9d:	89 d6                	mov    %edx,%esi
  800d9f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800da1:	8b 1c 24             	mov    (%esp),%ebx
  800da4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800da8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dac:	89 ec                	mov    %ebp,%esp
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 38             	sub    $0x38,%esp
  800db6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800db9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dbc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	89 cb                	mov    %ecx,%ebx
  800dce:	89 cf                	mov    %ecx,%edi
  800dd0:	89 ce                	mov    %ecx,%esi
  800dd2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	7e 28                	jle    800e00 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddc:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800de3:	00 
  800de4:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  800deb:	00 
  800dec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df3:	00 
  800df4:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  800dfb:	e8 3c 16 00 00       	call   80243c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e00:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e03:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e06:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e09:	89 ec                	mov    %ebp,%esp
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	89 1c 24             	mov    %ebx,(%esp)
  800e16:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e1a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1e:	be 00 00 00 00       	mov    $0x0,%esi
  800e23:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e28:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e36:	8b 1c 24             	mov    (%esp),%ebx
  800e39:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e3d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e41:	89 ec                	mov    %ebp,%esp
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 38             	sub    $0x38,%esp
  800e4b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e4e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e51:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	8b 55 08             	mov    0x8(%ebp),%edx
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e6a:	85 c0                	test   %eax,%eax
  800e6c:	7e 28                	jle    800e96 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e72:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e79:	00 
  800e7a:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  800e81:	00 
  800e82:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e89:	00 
  800e8a:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  800e91:	e8 a6 15 00 00       	call   80243c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e96:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e99:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e9c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e9f:	89 ec                	mov    %ebp,%esp
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 38             	sub    $0x38,%esp
  800ea9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eaf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb7:	b8 09 00 00 00       	mov    $0x9,%eax
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	89 df                	mov    %ebx,%edi
  800ec4:	89 de                	mov    %ebx,%esi
  800ec6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	7e 28                	jle    800ef4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecc:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ed7:	00 
  800ed8:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  800edf:	00 
  800ee0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee7:	00 
  800ee8:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  800eef:	e8 48 15 00 00       	call   80243c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800efa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800efd:	89 ec                	mov    %ebp,%esp
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    

00800f01 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 38             	sub    $0x38,%esp
  800f07:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f0d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f15:	b8 08 00 00 00       	mov    $0x8,%eax
  800f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	89 df                	mov    %ebx,%edi
  800f22:	89 de                	mov    %ebx,%esi
  800f24:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f26:	85 c0                	test   %eax,%eax
  800f28:	7e 28                	jle    800f52 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f35:	00 
  800f36:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  800f3d:	00 
  800f3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f45:	00 
  800f46:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  800f4d:	e8 ea 14 00 00       	call   80243c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f55:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f58:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5b:	89 ec                	mov    %ebp,%esp
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    

00800f5f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 38             	sub    $0x38,%esp
  800f65:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f68:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f73:	b8 06 00 00 00       	mov    $0x6,%eax
  800f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	89 df                	mov    %ebx,%edi
  800f80:	89 de                	mov    %ebx,%esi
  800f82:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f84:	85 c0                	test   %eax,%eax
  800f86:	7e 28                	jle    800fb0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f88:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f93:	00 
  800f94:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  800f9b:	00 
  800f9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa3:	00 
  800fa4:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  800fab:	e8 8c 14 00 00       	call   80243c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fb9:	89 ec                	mov    %ebp,%esp
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 38             	sub    $0x38,%esp
  800fc3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fc9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcc:	b8 05 00 00 00       	mov    $0x5,%eax
  800fd1:	8b 75 18             	mov    0x18(%ebp),%esi
  800fd4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	7e 28                	jle    80100e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fea:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ff1:	00 
  800ff2:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  800ff9:	00 
  800ffa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801001:	00 
  801002:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  801009:	e8 2e 14 00 00       	call   80243c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80100e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801011:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801014:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801017:	89 ec                	mov    %ebp,%esp
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 38             	sub    $0x38,%esp
  801021:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801024:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801027:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102a:	be 00 00 00 00       	mov    $0x0,%esi
  80102f:	b8 04 00 00 00       	mov    $0x4,%eax
  801034:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103a:	8b 55 08             	mov    0x8(%ebp),%edx
  80103d:	89 f7                	mov    %esi,%edi
  80103f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801041:	85 c0                	test   %eax,%eax
  801043:	7e 28                	jle    80106d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801045:	89 44 24 10          	mov    %eax,0x10(%esp)
  801049:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801050:	00 
  801051:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  801058:	00 
  801059:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801060:	00 
  801061:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  801068:	e8 cf 13 00 00       	call   80243c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80106d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801070:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801073:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801076:	89 ec                	mov    %ebp,%esp
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    

0080107a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 0c             	sub    $0xc,%esp
  801080:	89 1c 24             	mov    %ebx,(%esp)
  801083:	89 74 24 04          	mov    %esi,0x4(%esp)
  801087:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108b:	ba 00 00 00 00       	mov    $0x0,%edx
  801090:	b8 0b 00 00 00       	mov    $0xb,%eax
  801095:	89 d1                	mov    %edx,%ecx
  801097:	89 d3                	mov    %edx,%ebx
  801099:	89 d7                	mov    %edx,%edi
  80109b:	89 d6                	mov    %edx,%esi
  80109d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80109f:	8b 1c 24             	mov    (%esp),%ebx
  8010a2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010aa:	89 ec                	mov    %ebp,%esp
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    

008010ae <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 0c             	sub    $0xc,%esp
  8010b4:	89 1c 24             	mov    %ebx,(%esp)
  8010b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010bb:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c4:	b8 02 00 00 00       	mov    $0x2,%eax
  8010c9:	89 d1                	mov    %edx,%ecx
  8010cb:	89 d3                	mov    %edx,%ebx
  8010cd:	89 d7                	mov    %edx,%edi
  8010cf:	89 d6                	mov    %edx,%esi
  8010d1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010d3:	8b 1c 24             	mov    (%esp),%ebx
  8010d6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010da:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010de:	89 ec                	mov    %ebp,%esp
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    

008010e2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 38             	sub    $0x38,%esp
  8010e8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010eb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ee:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f6:	b8 03 00 00 00       	mov    $0x3,%eax
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	89 cb                	mov    %ecx,%ebx
  801100:	89 cf                	mov    %ecx,%edi
  801102:	89 ce                	mov    %ecx,%esi
  801104:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801106:	85 c0                	test   %eax,%eax
  801108:	7e 28                	jle    801132 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801115:	00 
  801116:	c7 44 24 08 bf 2b 80 	movl   $0x802bbf,0x8(%esp)
  80111d:	00 
  80111e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801125:	00 
  801126:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  80112d:	e8 0a 13 00 00       	call   80243c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801132:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801135:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801138:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80113b:	89 ec                	mov    %ebp,%esp
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    
	...

00801140 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	05 00 00 00 30       	add    $0x30000000,%eax
  80114b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	89 04 24             	mov    %eax,(%esp)
  80115c:	e8 df ff ff ff       	call   801140 <fd2num>
  801161:	05 20 00 0d 00       	add    $0xd0020,%eax
  801166:	c1 e0 0c             	shl    $0xc,%eax
}
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	57                   	push   %edi
  80116f:	56                   	push   %esi
  801170:	53                   	push   %ebx
  801171:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801174:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801179:	a8 01                	test   $0x1,%al
  80117b:	74 36                	je     8011b3 <fd_alloc+0x48>
  80117d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801182:	a8 01                	test   $0x1,%al
  801184:	74 2d                	je     8011b3 <fd_alloc+0x48>
  801186:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80118b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801190:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801195:	89 c3                	mov    %eax,%ebx
  801197:	89 c2                	mov    %eax,%edx
  801199:	c1 ea 16             	shr    $0x16,%edx
  80119c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80119f:	f6 c2 01             	test   $0x1,%dl
  8011a2:	74 14                	je     8011b8 <fd_alloc+0x4d>
  8011a4:	89 c2                	mov    %eax,%edx
  8011a6:	c1 ea 0c             	shr    $0xc,%edx
  8011a9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8011ac:	f6 c2 01             	test   $0x1,%dl
  8011af:	75 10                	jne    8011c1 <fd_alloc+0x56>
  8011b1:	eb 05                	jmp    8011b8 <fd_alloc+0x4d>
  8011b3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8011b8:	89 1f                	mov    %ebx,(%edi)
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8011bf:	eb 17                	jmp    8011d8 <fd_alloc+0x6d>
  8011c1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011c6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011cb:	75 c8                	jne    801195 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011cd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8011d3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5f                   	pop    %edi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	83 f8 1f             	cmp    $0x1f,%eax
  8011e6:	77 36                	ja     80121e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011e8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8011ed:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	c1 ea 16             	shr    $0x16,%edx
  8011f5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011fc:	f6 c2 01             	test   $0x1,%dl
  8011ff:	74 1d                	je     80121e <fd_lookup+0x41>
  801201:	89 c2                	mov    %eax,%edx
  801203:	c1 ea 0c             	shr    $0xc,%edx
  801206:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80120d:	f6 c2 01             	test   $0x1,%dl
  801210:	74 0c                	je     80121e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801212:	8b 55 0c             	mov    0xc(%ebp),%edx
  801215:	89 02                	mov    %eax,(%edx)
  801217:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80121c:	eb 05                	jmp    801223 <fd_lookup+0x46>
  80121e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801223:	5d                   	pop    %ebp
  801224:	c3                   	ret    

00801225 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
  801228:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80122b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80122e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	89 04 24             	mov    %eax,(%esp)
  801238:	e8 a0 ff ff ff       	call   8011dd <fd_lookup>
  80123d:	85 c0                	test   %eax,%eax
  80123f:	78 0e                	js     80124f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801241:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801244:	8b 55 0c             	mov    0xc(%ebp),%edx
  801247:	89 50 04             	mov    %edx,0x4(%eax)
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
  801256:	83 ec 10             	sub    $0x10,%esp
  801259:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80125f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801264:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801269:	be 68 2c 80 00       	mov    $0x802c68,%esi
		if (devtab[i]->dev_id == dev_id) {
  80126e:	39 08                	cmp    %ecx,(%eax)
  801270:	75 10                	jne    801282 <dev_lookup+0x31>
  801272:	eb 04                	jmp    801278 <dev_lookup+0x27>
  801274:	39 08                	cmp    %ecx,(%eax)
  801276:	75 0a                	jne    801282 <dev_lookup+0x31>
			*dev = devtab[i];
  801278:	89 03                	mov    %eax,(%ebx)
  80127a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80127f:	90                   	nop
  801280:	eb 31                	jmp    8012b3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801282:	83 c2 01             	add    $0x1,%edx
  801285:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801288:	85 c0                	test   %eax,%eax
  80128a:	75 e8                	jne    801274 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80128c:	a1 74 60 80 00       	mov    0x806074,%eax
  801291:	8b 40 4c             	mov    0x4c(%eax),%eax
  801294:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801298:	89 44 24 04          	mov    %eax,0x4(%esp)
  80129c:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  8012a3:	e8 c5 ee ff ff       	call   80016d <cprintf>
	*dev = 0;
  8012a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8012ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5d                   	pop    %ebp
  8012b9:	c3                   	ret    

008012ba <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 24             	sub    $0x24,%esp
  8012c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	89 04 24             	mov    %eax,(%esp)
  8012d1:	e8 07 ff ff ff       	call   8011dd <fd_lookup>
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 53                	js     80132d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e4:	8b 00                	mov    (%eax),%eax
  8012e6:	89 04 24             	mov    %eax,(%esp)
  8012e9:	e8 63 ff ff ff       	call   801251 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 3b                	js     80132d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8012f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8012fe:	74 2d                	je     80132d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801300:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801303:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80130a:	00 00 00 
	stat->st_isdir = 0;
  80130d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801314:	00 00 00 
	stat->st_dev = dev;
  801317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801320:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801324:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801327:	89 14 24             	mov    %edx,(%esp)
  80132a:	ff 50 14             	call   *0x14(%eax)
}
  80132d:	83 c4 24             	add    $0x24,%esp
  801330:	5b                   	pop    %ebx
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	53                   	push   %ebx
  801337:	83 ec 24             	sub    $0x24,%esp
  80133a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801340:	89 44 24 04          	mov    %eax,0x4(%esp)
  801344:	89 1c 24             	mov    %ebx,(%esp)
  801347:	e8 91 fe ff ff       	call   8011dd <fd_lookup>
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 5f                	js     8013af <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801350:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801353:	89 44 24 04          	mov    %eax,0x4(%esp)
  801357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135a:	8b 00                	mov    (%eax),%eax
  80135c:	89 04 24             	mov    %eax,(%esp)
  80135f:	e8 ed fe ff ff       	call   801251 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801364:	85 c0                	test   %eax,%eax
  801366:	78 47                	js     8013af <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801368:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80136f:	75 23                	jne    801394 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801371:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801376:	8b 40 4c             	mov    0x4c(%eax),%eax
  801379:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80137d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801381:	c7 04 24 0c 2c 80 00 	movl   $0x802c0c,(%esp)
  801388:	e8 e0 ed ff ff       	call   80016d <cprintf>
  80138d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801392:	eb 1b                	jmp    8013af <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	8b 48 18             	mov    0x18(%eax),%ecx
  80139a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139f:	85 c9                	test   %ecx,%ecx
  8013a1:	74 0c                	je     8013af <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013aa:	89 14 24             	mov    %edx,(%esp)
  8013ad:	ff d1                	call   *%ecx
}
  8013af:	83 c4 24             	add    $0x24,%esp
  8013b2:	5b                   	pop    %ebx
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    

008013b5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 24             	sub    $0x24,%esp
  8013bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c6:	89 1c 24             	mov    %ebx,(%esp)
  8013c9:	e8 0f fe ff ff       	call   8011dd <fd_lookup>
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 66                	js     801438 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dc:	8b 00                	mov    (%eax),%eax
  8013de:	89 04 24             	mov    %eax,(%esp)
  8013e1:	e8 6b fe ff ff       	call   801251 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 4e                	js     801438 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ed:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8013f1:	75 23                	jne    801416 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8013f3:	a1 74 60 80 00       	mov    0x806074,%eax
  8013f8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801403:	c7 04 24 2d 2c 80 00 	movl   $0x802c2d,(%esp)
  80140a:	e8 5e ed ff ff       	call   80016d <cprintf>
  80140f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801414:	eb 22                	jmp    801438 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801419:	8b 48 0c             	mov    0xc(%eax),%ecx
  80141c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801421:	85 c9                	test   %ecx,%ecx
  801423:	74 13                	je     801438 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801425:	8b 45 10             	mov    0x10(%ebp),%eax
  801428:	89 44 24 08          	mov    %eax,0x8(%esp)
  80142c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801433:	89 14 24             	mov    %edx,(%esp)
  801436:	ff d1                	call   *%ecx
}
  801438:	83 c4 24             	add    $0x24,%esp
  80143b:	5b                   	pop    %ebx
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	53                   	push   %ebx
  801442:	83 ec 24             	sub    $0x24,%esp
  801445:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801448:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80144b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144f:	89 1c 24             	mov    %ebx,(%esp)
  801452:	e8 86 fd ff ff       	call   8011dd <fd_lookup>
  801457:	85 c0                	test   %eax,%eax
  801459:	78 6b                	js     8014c6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801465:	8b 00                	mov    (%eax),%eax
  801467:	89 04 24             	mov    %eax,(%esp)
  80146a:	e8 e2 fd ff ff       	call   801251 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 53                	js     8014c6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801473:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801476:	8b 42 08             	mov    0x8(%edx),%eax
  801479:	83 e0 03             	and    $0x3,%eax
  80147c:	83 f8 01             	cmp    $0x1,%eax
  80147f:	75 23                	jne    8014a4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801481:	a1 74 60 80 00       	mov    0x806074,%eax
  801486:	8b 40 4c             	mov    0x4c(%eax),%eax
  801489:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80148d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801491:	c7 04 24 4a 2c 80 00 	movl   $0x802c4a,(%esp)
  801498:	e8 d0 ec ff ff       	call   80016d <cprintf>
  80149d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8014a2:	eb 22                	jmp    8014c6 <read+0x88>
	}
	if (!dev->dev_read)
  8014a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8014aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014af:	85 c9                	test   %ecx,%ecx
  8014b1:	74 13                	je     8014c6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c1:	89 14 24             	mov    %edx,(%esp)
  8014c4:	ff d1                	call   *%ecx
}
  8014c6:	83 c4 24             	add    $0x24,%esp
  8014c9:	5b                   	pop    %ebx
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	57                   	push   %edi
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 1c             	sub    $0x1c,%esp
  8014d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014db:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	85 f6                	test   %esi,%esi
  8014ec:	74 29                	je     801517 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ee:	89 f0                	mov    %esi,%eax
  8014f0:	29 d0                	sub    %edx,%eax
  8014f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014f6:	03 55 0c             	add    0xc(%ebp),%edx
  8014f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014fd:	89 3c 24             	mov    %edi,(%esp)
  801500:	e8 39 ff ff ff       	call   80143e <read>
		if (m < 0)
  801505:	85 c0                	test   %eax,%eax
  801507:	78 0e                	js     801517 <readn+0x4b>
			return m;
		if (m == 0)
  801509:	85 c0                	test   %eax,%eax
  80150b:	74 08                	je     801515 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80150d:	01 c3                	add    %eax,%ebx
  80150f:	89 da                	mov    %ebx,%edx
  801511:	39 f3                	cmp    %esi,%ebx
  801513:	72 d9                	jb     8014ee <readn+0x22>
  801515:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801517:	83 c4 1c             	add    $0x1c,%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5e                   	pop    %esi
  80151c:	5f                   	pop    %edi
  80151d:	5d                   	pop    %ebp
  80151e:	c3                   	ret    

0080151f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	56                   	push   %esi
  801523:	53                   	push   %ebx
  801524:	83 ec 20             	sub    $0x20,%esp
  801527:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80152a:	89 34 24             	mov    %esi,(%esp)
  80152d:	e8 0e fc ff ff       	call   801140 <fd2num>
  801532:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801535:	89 54 24 04          	mov    %edx,0x4(%esp)
  801539:	89 04 24             	mov    %eax,(%esp)
  80153c:	e8 9c fc ff ff       	call   8011dd <fd_lookup>
  801541:	89 c3                	mov    %eax,%ebx
  801543:	85 c0                	test   %eax,%eax
  801545:	78 05                	js     80154c <fd_close+0x2d>
  801547:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80154a:	74 0c                	je     801558 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80154c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801550:	19 c0                	sbb    %eax,%eax
  801552:	f7 d0                	not    %eax
  801554:	21 c3                	and    %eax,%ebx
  801556:	eb 3d                	jmp    801595 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801558:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155f:	8b 06                	mov    (%esi),%eax
  801561:	89 04 24             	mov    %eax,(%esp)
  801564:	e8 e8 fc ff ff       	call   801251 <dev_lookup>
  801569:	89 c3                	mov    %eax,%ebx
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 16                	js     801585 <fd_close+0x66>
		if (dev->dev_close)
  80156f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801572:	8b 40 10             	mov    0x10(%eax),%eax
  801575:	bb 00 00 00 00       	mov    $0x0,%ebx
  80157a:	85 c0                	test   %eax,%eax
  80157c:	74 07                	je     801585 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80157e:	89 34 24             	mov    %esi,(%esp)
  801581:	ff d0                	call   *%eax
  801583:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801585:	89 74 24 04          	mov    %esi,0x4(%esp)
  801589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801590:	e8 ca f9 ff ff       	call   800f5f <sys_page_unmap>
	return r;
}
  801595:	89 d8                	mov    %ebx,%eax
  801597:	83 c4 20             	add    $0x20,%esp
  80159a:	5b                   	pop    %ebx
  80159b:	5e                   	pop    %esi
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	89 04 24             	mov    %eax,(%esp)
  8015b1:	e8 27 fc ff ff       	call   8011dd <fd_lookup>
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 13                	js     8015cd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8015ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015c1:	00 
  8015c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c5:	89 04 24             	mov    %eax,(%esp)
  8015c8:	e8 52 ff ff ff       	call   80151f <fd_close>
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 18             	sub    $0x18,%esp
  8015d5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015d8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015e2:	00 
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	89 04 24             	mov    %eax,(%esp)
  8015e9:	e8 55 03 00 00       	call   801943 <open>
  8015ee:	89 c3                	mov    %eax,%ebx
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	78 1b                	js     80160f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8015f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fb:	89 1c 24             	mov    %ebx,(%esp)
  8015fe:	e8 b7 fc ff ff       	call   8012ba <fstat>
  801603:	89 c6                	mov    %eax,%esi
	close(fd);
  801605:	89 1c 24             	mov    %ebx,(%esp)
  801608:	e8 91 ff ff ff       	call   80159e <close>
  80160d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80160f:	89 d8                	mov    %ebx,%eax
  801611:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801614:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801617:	89 ec                	mov    %ebp,%esp
  801619:	5d                   	pop    %ebp
  80161a:	c3                   	ret    

0080161b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	53                   	push   %ebx
  80161f:	83 ec 14             	sub    $0x14,%esp
  801622:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801627:	89 1c 24             	mov    %ebx,(%esp)
  80162a:	e8 6f ff ff ff       	call   80159e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80162f:	83 c3 01             	add    $0x1,%ebx
  801632:	83 fb 20             	cmp    $0x20,%ebx
  801635:	75 f0                	jne    801627 <close_all+0xc>
		close(i);
}
  801637:	83 c4 14             	add    $0x14,%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5d                   	pop    %ebp
  80163c:	c3                   	ret    

0080163d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 58             	sub    $0x58,%esp
  801643:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801646:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801649:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80164c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80164f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801652:	89 44 24 04          	mov    %eax,0x4(%esp)
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	89 04 24             	mov    %eax,(%esp)
  80165c:	e8 7c fb ff ff       	call   8011dd <fd_lookup>
  801661:	89 c3                	mov    %eax,%ebx
  801663:	85 c0                	test   %eax,%eax
  801665:	0f 88 e0 00 00 00    	js     80174b <dup+0x10e>
		return r;
	close(newfdnum);
  80166b:	89 3c 24             	mov    %edi,(%esp)
  80166e:	e8 2b ff ff ff       	call   80159e <close>

	newfd = INDEX2FD(newfdnum);
  801673:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801679:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80167c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167f:	89 04 24             	mov    %eax,(%esp)
  801682:	e8 c9 fa ff ff       	call   801150 <fd2data>
  801687:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801689:	89 34 24             	mov    %esi,(%esp)
  80168c:	e8 bf fa ff ff       	call   801150 <fd2data>
  801691:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801694:	89 da                	mov    %ebx,%edx
  801696:	89 d8                	mov    %ebx,%eax
  801698:	c1 e8 16             	shr    $0x16,%eax
  80169b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016a2:	a8 01                	test   $0x1,%al
  8016a4:	74 43                	je     8016e9 <dup+0xac>
  8016a6:	c1 ea 0c             	shr    $0xc,%edx
  8016a9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016b0:	a8 01                	test   $0x1,%al
  8016b2:	74 35                	je     8016e9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8016b4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8016c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016d2:	00 
  8016d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016de:	e8 da f8 ff ff       	call   800fbd <sys_page_map>
  8016e3:	89 c3                	mov    %eax,%ebx
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 3f                	js     801728 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8016e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ec:	89 c2                	mov    %eax,%edx
  8016ee:	c1 ea 0c             	shr    $0xc,%edx
  8016f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016f8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016fe:	89 54 24 10          	mov    %edx,0x10(%esp)
  801702:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801706:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80170d:	00 
  80170e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801712:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801719:	e8 9f f8 ff ff       	call   800fbd <sys_page_map>
  80171e:	89 c3                	mov    %eax,%ebx
  801720:	85 c0                	test   %eax,%eax
  801722:	78 04                	js     801728 <dup+0xeb>
  801724:	89 fb                	mov    %edi,%ebx
  801726:	eb 23                	jmp    80174b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801728:	89 74 24 04          	mov    %esi,0x4(%esp)
  80172c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801733:	e8 27 f8 ff ff       	call   800f5f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801738:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80173b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801746:	e8 14 f8 ff ff       	call   800f5f <sys_page_unmap>
	return r;
}
  80174b:	89 d8                	mov    %ebx,%eax
  80174d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801750:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801753:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801756:	89 ec                	mov    %ebp,%esp
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    
	...

0080175c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	53                   	push   %ebx
  801760:	83 ec 14             	sub    $0x14,%esp
  801763:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801765:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80176b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801772:	00 
  801773:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80177a:	00 
  80177b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177f:	89 14 24             	mov    %edx,(%esp)
  801782:	e8 19 0d 00 00       	call   8024a0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801787:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80178e:	00 
  80178f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801793:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80179a:	e8 67 0d 00 00       	call   802506 <ipc_recv>
}
  80179f:	83 c4 14             	add    $0x14,%esp
  8017a2:	5b                   	pop    %ebx
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    

008017a5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  8017b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017be:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c3:	b8 02 00 00 00       	mov    $0x2,%eax
  8017c8:	e8 8f ff ff ff       	call   80175c <fsipc>
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017db:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  8017e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e5:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ea:	e8 6d ff ff ff       	call   80175c <fsipc>
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	b8 08 00 00 00       	mov    $0x8,%eax
  801801:	e8 56 ff ff ff       	call   80175c <fsipc>
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	53                   	push   %ebx
  80180c:	83 ec 14             	sub    $0x14,%esp
  80180f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8b 40 0c             	mov    0xc(%eax),%eax
  801818:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80181d:	ba 00 00 00 00       	mov    $0x0,%edx
  801822:	b8 05 00 00 00       	mov    $0x5,%eax
  801827:	e8 30 ff ff ff       	call   80175c <fsipc>
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 2b                	js     80185b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801830:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801837:	00 
  801838:	89 1c 24             	mov    %ebx,(%esp)
  80183b:	e8 ea ef ff ff       	call   80082a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801840:	a1 80 30 80 00       	mov    0x803080,%eax
  801845:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80184b:	a1 84 30 80 00       	mov    0x803084,%eax
  801850:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80185b:	83 c4 14             	add    $0x14,%esp
  80185e:	5b                   	pop    %ebx
  80185f:	5d                   	pop    %ebp
  801860:	c3                   	ret    

00801861 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 18             	sub    $0x18,%esp
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80186f:	76 05                	jbe    801876 <devfile_write+0x15>
  801871:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801876:	8b 55 08             	mov    0x8(%ebp),%edx
  801879:	8b 52 0c             	mov    0xc(%edx),%edx
  80187c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801882:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801887:	89 44 24 08          	mov    %eax,0x8(%esp)
  80188b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801892:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801899:	e8 47 f1 ff ff       	call   8009e5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80189e:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8018a8:	e8 af fe ff ff       	call   80175c <fsipc>
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	53                   	push   %ebx
  8018b3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bc:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  8018c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c4:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  8018c9:	ba 00 30 80 00       	mov    $0x803000,%edx
  8018ce:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d3:	e8 84 fe ff ff       	call   80175c <fsipc>
  8018d8:	89 c3                	mov    %eax,%ebx
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 17                	js     8018f5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  8018de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018e2:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8018e9:	00 
  8018ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ed:	89 04 24             	mov    %eax,(%esp)
  8018f0:	e8 f0 f0 ff ff       	call   8009e5 <memmove>
	return r;
}
  8018f5:	89 d8                	mov    %ebx,%eax
  8018f7:	83 c4 14             	add    $0x14,%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    

008018fd <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	53                   	push   %ebx
  801901:	83 ec 14             	sub    $0x14,%esp
  801904:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801907:	89 1c 24             	mov    %ebx,(%esp)
  80190a:	e8 d1 ee ff ff       	call   8007e0 <strlen>
  80190f:	89 c2                	mov    %eax,%edx
  801911:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801916:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  80191c:	7f 1f                	jg     80193d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  80191e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801922:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801929:	e8 fc ee ff ff       	call   80082a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  80192e:	ba 00 00 00 00       	mov    $0x0,%edx
  801933:	b8 07 00 00 00       	mov    $0x7,%eax
  801938:	e8 1f fe ff ff       	call   80175c <fsipc>
}
  80193d:	83 c4 14             	add    $0x14,%esp
  801940:	5b                   	pop    %ebx
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 28             	sub    $0x28,%esp
  801949:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80194c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80194f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801952:	89 34 24             	mov    %esi,(%esp)
  801955:	e8 86 ee ff ff       	call   8007e0 <strlen>
  80195a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80195f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801964:	7f 5e                	jg     8019c4 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801966:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801969:	89 04 24             	mov    %eax,(%esp)
  80196c:	e8 fa f7 ff ff       	call   80116b <fd_alloc>
  801971:	89 c3                	mov    %eax,%ebx
  801973:	85 c0                	test   %eax,%eax
  801975:	78 4d                	js     8019c4 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801977:	89 74 24 04          	mov    %esi,0x4(%esp)
  80197b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801982:	e8 a3 ee ff ff       	call   80082a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80198f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801992:	b8 01 00 00 00       	mov    $0x1,%eax
  801997:	e8 c0 fd ff ff       	call   80175c <fsipc>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	79 15                	jns    8019b7 <open+0x74>
	{
		fd_close(fd,0);
  8019a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019a9:	00 
  8019aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ad:	89 04 24             	mov    %eax,(%esp)
  8019b0:	e8 6a fb ff ff       	call   80151f <fd_close>
		return r; 
  8019b5:	eb 0d                	jmp    8019c4 <open+0x81>
	}
	return fd2num(fd);
  8019b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ba:	89 04 24             	mov    %eax,(%esp)
  8019bd:	e8 7e f7 ff ff       	call   801140 <fd2num>
  8019c2:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  8019c4:	89 d8                	mov    %ebx,%eax
  8019c6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8019c9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019cc:	89 ec                	mov    %ebp,%esp
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    

008019d0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8019d6:	c7 44 24 04 7c 2c 80 	movl   $0x802c7c,0x4(%esp)
  8019dd:	00 
  8019de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e1:	89 04 24             	mov    %eax,(%esp)
  8019e4:	e8 41 ee ff ff       	call   80082a <strcpy>
	return 0;
}
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fc:	89 04 24             	mov    %eax,(%esp)
  8019ff:	e8 9e 02 00 00       	call   801ca2 <nsipc_close>
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a0c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a13:	00 
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	8b 40 0c             	mov    0xc(%eax),%eax
  801a28:	89 04 24             	mov    %eax,(%esp)
  801a2b:	e8 ae 02 00 00       	call   801cde <nsipc_send>
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a38:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a3f:	00 
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	8b 40 0c             	mov    0xc(%eax),%eax
  801a54:	89 04 24             	mov    %eax,(%esp)
  801a57:	e8 f5 02 00 00       	call   801d51 <nsipc_recv>
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	56                   	push   %esi
  801a62:	53                   	push   %ebx
  801a63:	83 ec 20             	sub    $0x20,%esp
  801a66:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	e8 f8 f6 ff ff       	call   80116b <fd_alloc>
  801a73:	89 c3                	mov    %eax,%ebx
  801a75:	85 c0                	test   %eax,%eax
  801a77:	78 21                	js     801a9a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801a79:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a80:	00 
  801a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8f:	e8 87 f5 ff ff       	call   80101b <sys_page_alloc>
  801a94:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a96:	85 c0                	test   %eax,%eax
  801a98:	79 0a                	jns    801aa4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801a9a:	89 34 24             	mov    %esi,(%esp)
  801a9d:	e8 00 02 00 00       	call   801ca2 <nsipc_close>
		return r;
  801aa2:	eb 28                	jmp    801acc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801aa4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aad:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac2:	89 04 24             	mov    %eax,(%esp)
  801ac5:	e8 76 f6 ff ff       	call   801140 <fd2num>
  801aca:	89 c3                	mov    %eax,%ebx
}
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	83 c4 20             	add    $0x20,%esp
  801ad1:	5b                   	pop    %ebx
  801ad2:	5e                   	pop    %esi
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    

00801ad5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801adb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ade:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	89 04 24             	mov    %eax,(%esp)
  801aef:	e8 62 01 00 00       	call   801c56 <nsipc_socket>
  801af4:	85 c0                	test   %eax,%eax
  801af6:	78 05                	js     801afd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801af8:	e8 61 ff ff ff       	call   801a5e <alloc_sockfd>
}
  801afd:	c9                   	leave  
  801afe:	66 90                	xchg   %ax,%ax
  801b00:	c3                   	ret    

00801b01 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b07:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b0e:	89 04 24             	mov    %eax,(%esp)
  801b11:	e8 c7 f6 ff ff       	call   8011dd <fd_lookup>
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 15                	js     801b2f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b1d:	8b 0a                	mov    (%edx),%ecx
  801b1f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b24:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801b2a:	75 03                	jne    801b2f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801b2c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	e8 c2 ff ff ff       	call   801b01 <fd2sockid>
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 0f                	js     801b52 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b4a:	89 04 24             	mov    %eax,(%esp)
  801b4d:	e8 2e 01 00 00       	call   801c80 <nsipc_listen>
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	e8 9f ff ff ff       	call   801b01 <fd2sockid>
  801b62:	85 c0                	test   %eax,%eax
  801b64:	78 16                	js     801b7c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801b66:	8b 55 10             	mov    0x10(%ebp),%edx
  801b69:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b74:	89 04 24             	mov    %eax,(%esp)
  801b77:	e8 55 02 00 00       	call   801dd1 <nsipc_connect>
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	e8 75 ff ff ff       	call   801b01 <fd2sockid>
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 0f                	js     801b9f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b93:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b97:	89 04 24             	mov    %eax,(%esp)
  801b9a:	e8 1d 01 00 00       	call   801cbc <nsipc_shutdown>
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	e8 52 ff ff ff       	call   801b01 <fd2sockid>
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	78 16                	js     801bc9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801bb3:	8b 55 10             	mov    0x10(%ebp),%edx
  801bb6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bc1:	89 04 24             	mov    %eax,(%esp)
  801bc4:	e8 47 02 00 00       	call   801e10 <nsipc_bind>
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	e8 28 ff ff ff       	call   801b01 <fd2sockid>
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	78 1f                	js     801bfc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bdd:	8b 55 10             	mov    0x10(%ebp),%edx
  801be0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801be4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801beb:	89 04 24             	mov    %eax,(%esp)
  801bee:	e8 5c 02 00 00       	call   801e4f <nsipc_accept>
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 05                	js     801bfc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801bf7:	e8 62 fe ff ff       	call   801a5e <alloc_sockfd>
}
  801bfc:	c9                   	leave  
  801bfd:	8d 76 00             	lea    0x0(%esi),%esi
  801c00:	c3                   	ret    
	...

00801c10 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c16:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801c1c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c23:	00 
  801c24:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801c2b:	00 
  801c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c30:	89 14 24             	mov    %edx,(%esp)
  801c33:	e8 68 08 00 00       	call   8024a0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c38:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c3f:	00 
  801c40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c47:	00 
  801c48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c4f:	e8 b2 08 00 00       	call   802506 <ipc_recv>
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c67:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801c6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801c74:	b8 09 00 00 00       	mov    $0x9,%eax
  801c79:	e8 92 ff ff ff       	call   801c10 <nsipc>
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c91:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801c96:	b8 06 00 00 00       	mov    $0x6,%eax
  801c9b:	e8 70 ff ff ff       	call   801c10 <nsipc>
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801cb0:	b8 04 00 00 00       	mov    $0x4,%eax
  801cb5:	e8 56 ff ff ff       	call   801c10 <nsipc>
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccd:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801cd2:	b8 03 00 00 00       	mov    $0x3,%eax
  801cd7:	e8 34 ff ff ff       	call   801c10 <nsipc>
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	53                   	push   %ebx
  801ce2:	83 ec 14             	sub    $0x14,%esp
  801ce5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801cf0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cf6:	7e 24                	jle    801d1c <nsipc_send+0x3e>
  801cf8:	c7 44 24 0c 88 2c 80 	movl   $0x802c88,0xc(%esp)
  801cff:	00 
  801d00:	c7 44 24 08 94 2c 80 	movl   $0x802c94,0x8(%esp)
  801d07:	00 
  801d08:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801d0f:	00 
  801d10:	c7 04 24 a9 2c 80 00 	movl   $0x802ca9,(%esp)
  801d17:	e8 20 07 00 00       	call   80243c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d1c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d27:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801d2e:	e8 b2 ec ff ff       	call   8009e5 <memmove>
	nsipcbuf.send.req_size = size;
  801d33:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801d39:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801d41:	b8 08 00 00 00       	mov    $0x8,%eax
  801d46:	e8 c5 fe ff ff       	call   801c10 <nsipc>
}
  801d4b:	83 c4 14             	add    $0x14,%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	56                   	push   %esi
  801d55:	53                   	push   %ebx
  801d56:	83 ec 10             	sub    $0x10,%esp
  801d59:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801d64:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801d6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d72:	b8 07 00 00 00       	mov    $0x7,%eax
  801d77:	e8 94 fe ff ff       	call   801c10 <nsipc>
  801d7c:	89 c3                	mov    %eax,%ebx
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	78 46                	js     801dc8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d82:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d87:	7f 04                	jg     801d8d <nsipc_recv+0x3c>
  801d89:	39 c6                	cmp    %eax,%esi
  801d8b:	7d 24                	jge    801db1 <nsipc_recv+0x60>
  801d8d:	c7 44 24 0c b5 2c 80 	movl   $0x802cb5,0xc(%esp)
  801d94:	00 
  801d95:	c7 44 24 08 94 2c 80 	movl   $0x802c94,0x8(%esp)
  801d9c:	00 
  801d9d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801da4:	00 
  801da5:	c7 04 24 a9 2c 80 00 	movl   $0x802ca9,(%esp)
  801dac:	e8 8b 06 00 00       	call   80243c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801db1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801dbc:	00 
  801dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc0:	89 04 24             	mov    %eax,(%esp)
  801dc3:	e8 1d ec ff ff       	call   8009e5 <memmove>
	}

	return r;
}
  801dc8:	89 d8                	mov    %ebx,%eax
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5e                   	pop    %esi
  801dcf:	5d                   	pop    %ebp
  801dd0:	c3                   	ret    

00801dd1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	53                   	push   %ebx
  801dd5:	83 ec 14             	sub    $0x14,%esp
  801dd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801de3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dee:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801df5:	e8 eb eb ff ff       	call   8009e5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dfa:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  801e00:	b8 05 00 00 00       	mov    $0x5,%eax
  801e05:	e8 06 fe ff ff       	call   801c10 <nsipc>
}
  801e0a:	83 c4 14             	add    $0x14,%esp
  801e0d:	5b                   	pop    %ebx
  801e0e:	5d                   	pop    %ebp
  801e0f:	c3                   	ret    

00801e10 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	53                   	push   %ebx
  801e14:	83 ec 14             	sub    $0x14,%esp
  801e17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e22:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2d:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801e34:	e8 ac eb ff ff       	call   8009e5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e39:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  801e3f:	b8 02 00 00 00       	mov    $0x2,%eax
  801e44:	e8 c7 fd ff ff       	call   801c10 <nsipc>
}
  801e49:	83 c4 14             	add    $0x14,%esp
  801e4c:	5b                   	pop    %ebx
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    

00801e4f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 18             	sub    $0x18,%esp
  801e55:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e58:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e63:	b8 01 00 00 00       	mov    $0x1,%eax
  801e68:	e8 a3 fd ff ff       	call   801c10 <nsipc>
  801e6d:	89 c3                	mov    %eax,%ebx
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 25                	js     801e98 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e73:	be 10 50 80 00       	mov    $0x805010,%esi
  801e78:	8b 06                	mov    (%esi),%eax
  801e7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e7e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801e85:	00 
  801e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e89:	89 04 24             	mov    %eax,(%esp)
  801e8c:	e8 54 eb ff ff       	call   8009e5 <memmove>
		*addrlen = ret->ret_addrlen;
  801e91:	8b 16                	mov    (%esi),%edx
  801e93:	8b 45 10             	mov    0x10(%ebp),%eax
  801e96:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801e98:	89 d8                	mov    %ebx,%eax
  801e9a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e9d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ea0:	89 ec                	mov    %ebp,%esp
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    
	...

00801eb0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 18             	sub    $0x18,%esp
  801eb6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801eb9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	89 04 24             	mov    %eax,(%esp)
  801ec5:	e8 86 f2 ff ff       	call   801150 <fd2data>
  801eca:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801ecc:	c7 44 24 04 ca 2c 80 	movl   $0x802cca,0x4(%esp)
  801ed3:	00 
  801ed4:	89 34 24             	mov    %esi,(%esp)
  801ed7:	e8 4e e9 ff ff       	call   80082a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801edc:	8b 43 04             	mov    0x4(%ebx),%eax
  801edf:	2b 03                	sub    (%ebx),%eax
  801ee1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801ee7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801eee:	00 00 00 
	stat->st_dev = &devpipe;
  801ef1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  801ef8:	60 80 00 
	return 0;
}
  801efb:	b8 00 00 00 00       	mov    $0x0,%eax
  801f00:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f03:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f06:	89 ec                	mov    %ebp,%esp
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    

00801f0a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	53                   	push   %ebx
  801f0e:	83 ec 14             	sub    $0x14,%esp
  801f11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f14:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1f:	e8 3b f0 ff ff       	call   800f5f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f24:	89 1c 24             	mov    %ebx,(%esp)
  801f27:	e8 24 f2 ff ff       	call   801150 <fd2data>
  801f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f37:	e8 23 f0 ff ff       	call   800f5f <sys_page_unmap>
}
  801f3c:	83 c4 14             	add    $0x14,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    

00801f42 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	57                   	push   %edi
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	83 ec 2c             	sub    $0x2c,%esp
  801f4b:	89 c7                	mov    %eax,%edi
  801f4d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801f50:	a1 74 60 80 00       	mov    0x806074,%eax
  801f55:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f58:	89 3c 24             	mov    %edi,(%esp)
  801f5b:	e8 10 06 00 00       	call   802570 <pageref>
  801f60:	89 c6                	mov    %eax,%esi
  801f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f65:	89 04 24             	mov    %eax,(%esp)
  801f68:	e8 03 06 00 00       	call   802570 <pageref>
  801f6d:	39 c6                	cmp    %eax,%esi
  801f6f:	0f 94 c0             	sete   %al
  801f72:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801f75:	8b 15 74 60 80 00    	mov    0x806074,%edx
  801f7b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f7e:	39 cb                	cmp    %ecx,%ebx
  801f80:	75 08                	jne    801f8a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801f82:	83 c4 2c             	add    $0x2c,%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5f                   	pop    %edi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801f8a:	83 f8 01             	cmp    $0x1,%eax
  801f8d:	75 c1                	jne    801f50 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801f8f:	8b 52 58             	mov    0x58(%edx),%edx
  801f92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f96:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f9a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f9e:	c7 04 24 d1 2c 80 00 	movl   $0x802cd1,(%esp)
  801fa5:	e8 c3 e1 ff ff       	call   80016d <cprintf>
  801faa:	eb a4                	jmp    801f50 <_pipeisclosed+0xe>

00801fac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	57                   	push   %edi
  801fb0:	56                   	push   %esi
  801fb1:	53                   	push   %ebx
  801fb2:	83 ec 1c             	sub    $0x1c,%esp
  801fb5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fb8:	89 34 24             	mov    %esi,(%esp)
  801fbb:	e8 90 f1 ff ff       	call   801150 <fd2data>
  801fc0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fcb:	75 54                	jne    802021 <devpipe_write+0x75>
  801fcd:	eb 60                	jmp    80202f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fcf:	89 da                	mov    %ebx,%edx
  801fd1:	89 f0                	mov    %esi,%eax
  801fd3:	e8 6a ff ff ff       	call   801f42 <_pipeisclosed>
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	74 07                	je     801fe3 <devpipe_write+0x37>
  801fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe1:	eb 53                	jmp    802036 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801fe3:	90                   	nop
  801fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fe8:	e8 8d f0 ff ff       	call   80107a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fed:	8b 43 04             	mov    0x4(%ebx),%eax
  801ff0:	8b 13                	mov    (%ebx),%edx
  801ff2:	83 c2 20             	add    $0x20,%edx
  801ff5:	39 d0                	cmp    %edx,%eax
  801ff7:	73 d6                	jae    801fcf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ff9:	89 c2                	mov    %eax,%edx
  801ffb:	c1 fa 1f             	sar    $0x1f,%edx
  801ffe:	c1 ea 1b             	shr    $0x1b,%edx
  802001:	01 d0                	add    %edx,%eax
  802003:	83 e0 1f             	and    $0x1f,%eax
  802006:	29 d0                	sub    %edx,%eax
  802008:	89 c2                	mov    %eax,%edx
  80200a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80200d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802011:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802015:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802019:	83 c7 01             	add    $0x1,%edi
  80201c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80201f:	76 13                	jbe    802034 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802021:	8b 43 04             	mov    0x4(%ebx),%eax
  802024:	8b 13                	mov    (%ebx),%edx
  802026:	83 c2 20             	add    $0x20,%edx
  802029:	39 d0                	cmp    %edx,%eax
  80202b:	73 a2                	jae    801fcf <devpipe_write+0x23>
  80202d:	eb ca                	jmp    801ff9 <devpipe_write+0x4d>
  80202f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802034:	89 f8                	mov    %edi,%eax
}
  802036:	83 c4 1c             	add    $0x1c,%esp
  802039:	5b                   	pop    %ebx
  80203a:	5e                   	pop    %esi
  80203b:	5f                   	pop    %edi
  80203c:	5d                   	pop    %ebp
  80203d:	c3                   	ret    

0080203e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 28             	sub    $0x28,%esp
  802044:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802047:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80204a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80204d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802050:	89 3c 24             	mov    %edi,(%esp)
  802053:	e8 f8 f0 ff ff       	call   801150 <fd2data>
  802058:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80205a:	be 00 00 00 00       	mov    $0x0,%esi
  80205f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802063:	75 4c                	jne    8020b1 <devpipe_read+0x73>
  802065:	eb 5b                	jmp    8020c2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802067:	89 f0                	mov    %esi,%eax
  802069:	eb 5e                	jmp    8020c9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80206b:	89 da                	mov    %ebx,%edx
  80206d:	89 f8                	mov    %edi,%eax
  80206f:	90                   	nop
  802070:	e8 cd fe ff ff       	call   801f42 <_pipeisclosed>
  802075:	85 c0                	test   %eax,%eax
  802077:	74 07                	je     802080 <devpipe_read+0x42>
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
  80207e:	eb 49                	jmp    8020c9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802080:	e8 f5 ef ff ff       	call   80107a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802085:	8b 03                	mov    (%ebx),%eax
  802087:	3b 43 04             	cmp    0x4(%ebx),%eax
  80208a:	74 df                	je     80206b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80208c:	89 c2                	mov    %eax,%edx
  80208e:	c1 fa 1f             	sar    $0x1f,%edx
  802091:	c1 ea 1b             	shr    $0x1b,%edx
  802094:	01 d0                	add    %edx,%eax
  802096:	83 e0 1f             	and    $0x1f,%eax
  802099:	29 d0                	sub    %edx,%eax
  80209b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8020a6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020a9:	83 c6 01             	add    $0x1,%esi
  8020ac:	39 75 10             	cmp    %esi,0x10(%ebp)
  8020af:	76 16                	jbe    8020c7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  8020b1:	8b 03                	mov    (%ebx),%eax
  8020b3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020b6:	75 d4                	jne    80208c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020b8:	85 f6                	test   %esi,%esi
  8020ba:	75 ab                	jne    802067 <devpipe_read+0x29>
  8020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020c0:	eb a9                	jmp    80206b <devpipe_read+0x2d>
  8020c2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020c7:	89 f0                	mov    %esi,%eax
}
  8020c9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020cc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020d2:	89 ec                	mov    %ebp,%esp
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    

008020d6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	89 04 24             	mov    %eax,(%esp)
  8020e9:	e8 ef f0 ff ff       	call   8011dd <fd_lookup>
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 15                	js     802107 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	89 04 24             	mov    %eax,(%esp)
  8020f8:	e8 53 f0 ff ff       	call   801150 <fd2data>
	return _pipeisclosed(fd, p);
  8020fd:	89 c2                	mov    %eax,%edx
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	e8 3b fe ff ff       	call   801f42 <_pipeisclosed>
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 48             	sub    $0x48,%esp
  80210f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802112:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802115:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802118:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80211b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80211e:	89 04 24             	mov    %eax,(%esp)
  802121:	e8 45 f0 ff ff       	call   80116b <fd_alloc>
  802126:	89 c3                	mov    %eax,%ebx
  802128:	85 c0                	test   %eax,%eax
  80212a:	0f 88 42 01 00 00    	js     802272 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802130:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802137:	00 
  802138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802146:	e8 d0 ee ff ff       	call   80101b <sys_page_alloc>
  80214b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80214d:	85 c0                	test   %eax,%eax
  80214f:	0f 88 1d 01 00 00    	js     802272 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802155:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802158:	89 04 24             	mov    %eax,(%esp)
  80215b:	e8 0b f0 ff ff       	call   80116b <fd_alloc>
  802160:	89 c3                	mov    %eax,%ebx
  802162:	85 c0                	test   %eax,%eax
  802164:	0f 88 f5 00 00 00    	js     80225f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80216a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802171:	00 
  802172:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802175:	89 44 24 04          	mov    %eax,0x4(%esp)
  802179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802180:	e8 96 ee ff ff       	call   80101b <sys_page_alloc>
  802185:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802187:	85 c0                	test   %eax,%eax
  802189:	0f 88 d0 00 00 00    	js     80225f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80218f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802192:	89 04 24             	mov    %eax,(%esp)
  802195:	e8 b6 ef ff ff       	call   801150 <fd2data>
  80219a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80219c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021a3:	00 
  8021a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021af:	e8 67 ee ff ff       	call   80101b <sys_page_alloc>
  8021b4:	89 c3                	mov    %eax,%ebx
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	0f 88 8e 00 00 00    	js     80224c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c1:	89 04 24             	mov    %eax,(%esp)
  8021c4:	e8 87 ef ff ff       	call   801150 <fd2data>
  8021c9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021d0:	00 
  8021d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021dc:	00 
  8021dd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e8:	e8 d0 ed ff ff       	call   800fbd <sys_page_map>
  8021ed:	89 c3                	mov    %eax,%ebx
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	78 49                	js     80223c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021f3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  8021f8:	8b 08                	mov    (%eax),%ecx
  8021fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021fd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802202:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802209:	8b 10                	mov    (%eax),%edx
  80220b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80220e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802210:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802213:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80221a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221d:	89 04 24             	mov    %eax,(%esp)
  802220:	e8 1b ef ff ff       	call   801140 <fd2num>
  802225:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80222a:	89 04 24             	mov    %eax,(%esp)
  80222d:	e8 0e ef ff ff       	call   801140 <fd2num>
  802232:	89 47 04             	mov    %eax,0x4(%edi)
  802235:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80223a:	eb 36                	jmp    802272 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80223c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802247:	e8 13 ed ff ff       	call   800f5f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80224c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802253:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80225a:	e8 00 ed ff ff       	call   800f5f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80225f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802262:	89 44 24 04          	mov    %eax,0x4(%esp)
  802266:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80226d:	e8 ed ec ff ff       	call   800f5f <sys_page_unmap>
    err:
	return r;
}
  802272:	89 d8                	mov    %ebx,%eax
  802274:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802277:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80227a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80227d:	89 ec                	mov    %ebp,%esp
  80227f:	5d                   	pop    %ebp
  802280:	c3                   	ret    
	...

00802290 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    

0080229a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022a0:	c7 44 24 04 e9 2c 80 	movl   $0x802ce9,0x4(%esp)
  8022a7:	00 
  8022a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ab:	89 04 24             	mov    %eax,(%esp)
  8022ae:	e8 77 e5 ff ff       	call   80082a <strcpy>
	return 0;
}
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	57                   	push   %edi
  8022be:	56                   	push   %esi
  8022bf:	53                   	push   %ebx
  8022c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cb:	be 00 00 00 00       	mov    $0x0,%esi
  8022d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d4:	74 3f                	je     802315 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022dc:	8b 55 10             	mov    0x10(%ebp),%edx
  8022df:	29 c2                	sub    %eax,%edx
  8022e1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8022e3:	83 fa 7f             	cmp    $0x7f,%edx
  8022e6:	76 05                	jbe    8022ed <devcons_write+0x33>
  8022e8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022ed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022f1:	03 45 0c             	add    0xc(%ebp),%eax
  8022f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f8:	89 3c 24             	mov    %edi,(%esp)
  8022fb:	e8 e5 e6 ff ff       	call   8009e5 <memmove>
		sys_cputs(buf, m);
  802300:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802304:	89 3c 24             	mov    %edi,(%esp)
  802307:	e8 14 e9 ff ff       	call   800c20 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80230c:	01 de                	add    %ebx,%esi
  80230e:	89 f0                	mov    %esi,%eax
  802310:	3b 75 10             	cmp    0x10(%ebp),%esi
  802313:	72 c7                	jb     8022dc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802315:	89 f0                	mov    %esi,%eax
  802317:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5f                   	pop    %edi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    

00802322 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
  802325:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80232e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802335:	00 
  802336:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802339:	89 04 24             	mov    %eax,(%esp)
  80233c:	e8 df e8 ff ff       	call   800c20 <sys_cputs>
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802349:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234d:	75 07                	jne    802356 <devcons_read+0x13>
  80234f:	eb 28                	jmp    802379 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802351:	e8 24 ed ff ff       	call   80107a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802356:	66 90                	xchg   %ax,%ax
  802358:	e8 8f e8 ff ff       	call   800bec <sys_cgetc>
  80235d:	85 c0                	test   %eax,%eax
  80235f:	90                   	nop
  802360:	74 ef                	je     802351 <devcons_read+0xe>
  802362:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802364:	85 c0                	test   %eax,%eax
  802366:	78 16                	js     80237e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802368:	83 f8 04             	cmp    $0x4,%eax
  80236b:	74 0c                	je     802379 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80236d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802370:	88 10                	mov    %dl,(%eax)
  802372:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802377:	eb 05                	jmp    80237e <devcons_read+0x3b>
  802379:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802386:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802389:	89 04 24             	mov    %eax,(%esp)
  80238c:	e8 da ed ff ff       	call   80116b <fd_alloc>
  802391:	85 c0                	test   %eax,%eax
  802393:	78 3f                	js     8023d4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802395:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80239c:	00 
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ab:	e8 6b ec ff ff       	call   80101b <sys_page_alloc>
  8023b0:	85 c0                	test   %eax,%eax
  8023b2:	78 20                	js     8023d4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8023b4:	8b 15 58 60 80 00    	mov    0x806058,%edx
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	89 04 24             	mov    %eax,(%esp)
  8023cf:	e8 6c ed ff ff       	call   801140 <fd2num>
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	89 04 24             	mov    %eax,(%esp)
  8023e9:	e8 ef ed ff ff       	call   8011dd <fd_lookup>
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	78 11                	js     802403 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  8023fd:	0f 94 c0             	sete   %al
  802400:	0f b6 c0             	movzbl %al,%eax
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80240b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802412:	00 
  802413:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802416:	89 44 24 04          	mov    %eax,0x4(%esp)
  80241a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802421:	e8 18 f0 ff ff       	call   80143e <read>
	if (r < 0)
  802426:	85 c0                	test   %eax,%eax
  802428:	78 0f                	js     802439 <getchar+0x34>
		return r;
	if (r < 1)
  80242a:	85 c0                	test   %eax,%eax
  80242c:	7f 07                	jg     802435 <getchar+0x30>
  80242e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802433:	eb 04                	jmp    802439 <getchar+0x34>
		return -E_EOF;
	return c;
  802435:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    
	...

0080243c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	53                   	push   %ebx
  802440:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  802443:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  802446:	a1 78 60 80 00       	mov    0x806078,%eax
  80244b:	85 c0                	test   %eax,%eax
  80244d:	74 10                	je     80245f <_panic+0x23>
		cprintf("%s: ", argv0);
  80244f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802453:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  80245a:	e8 0e dd ff ff       	call   80016d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80245f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	89 44 24 08          	mov    %eax,0x8(%esp)
  80246d:	a1 00 60 80 00       	mov    0x806000,%eax
  802472:	89 44 24 04          	mov    %eax,0x4(%esp)
  802476:	c7 04 24 fa 2c 80 00 	movl   $0x802cfa,(%esp)
  80247d:	e8 eb dc ff ff       	call   80016d <cprintf>
	vcprintf(fmt, ap);
  802482:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802486:	8b 45 10             	mov    0x10(%ebp),%eax
  802489:	89 04 24             	mov    %eax,(%esp)
  80248c:	e8 7b dc ff ff       	call   80010c <vcprintf>
	cprintf("\n");
  802491:	c7 04 24 e2 2c 80 00 	movl   $0x802ce2,(%esp)
  802498:	e8 d0 dc ff ff       	call   80016d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80249d:	cc                   	int3   
  80249e:	eb fd                	jmp    80249d <_panic+0x61>

008024a0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	57                   	push   %edi
  8024a4:	56                   	push   %esi
  8024a5:	53                   	push   %ebx
  8024a6:	83 ec 1c             	sub    $0x1c,%esp
  8024a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8024ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024af:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8024b2:	85 db                	test   %ebx,%ebx
  8024b4:	75 2d                	jne    8024e3 <ipc_send+0x43>
  8024b6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8024bb:	eb 26                	jmp    8024e3 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8024bd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024c0:	74 1c                	je     8024de <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  8024c2:	c7 44 24 08 18 2d 80 	movl   $0x802d18,0x8(%esp)
  8024c9:	00 
  8024ca:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8024d1:	00 
  8024d2:	c7 04 24 3c 2d 80 00 	movl   $0x802d3c,(%esp)
  8024d9:	e8 5e ff ff ff       	call   80243c <_panic>
		sys_yield();
  8024de:	e8 97 eb ff ff       	call   80107a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8024e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8024e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	89 04 24             	mov    %eax,(%esp)
  8024f5:	e8 13 e9 ff ff       	call   800e0d <sys_ipc_try_send>
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	78 bf                	js     8024bd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8024fe:	83 c4 1c             	add    $0x1c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    

00802506 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	56                   	push   %esi
  80250a:	53                   	push   %ebx
  80250b:	83 ec 10             	sub    $0x10,%esp
  80250e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802511:	8b 45 0c             	mov    0xc(%ebp),%eax
  802514:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802517:	85 c0                	test   %eax,%eax
  802519:	75 05                	jne    802520 <ipc_recv+0x1a>
  80251b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802520:	89 04 24             	mov    %eax,(%esp)
  802523:	e8 88 e8 ff ff       	call   800db0 <sys_ipc_recv>
  802528:	85 c0                	test   %eax,%eax
  80252a:	79 16                	jns    802542 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80252c:	85 db                	test   %ebx,%ebx
  80252e:	74 06                	je     802536 <ipc_recv+0x30>
			*from_env_store = 0;
  802530:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802536:	85 f6                	test   %esi,%esi
  802538:	74 2c                	je     802566 <ipc_recv+0x60>
			*perm_store = 0;
  80253a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802540:	eb 24                	jmp    802566 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802542:	85 db                	test   %ebx,%ebx
  802544:	74 0a                	je     802550 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802546:	a1 74 60 80 00       	mov    0x806074,%eax
  80254b:	8b 40 74             	mov    0x74(%eax),%eax
  80254e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802550:	85 f6                	test   %esi,%esi
  802552:	74 0a                	je     80255e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802554:	a1 74 60 80 00       	mov    0x806074,%eax
  802559:	8b 40 78             	mov    0x78(%eax),%eax
  80255c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80255e:	a1 74 60 80 00       	mov    0x806074,%eax
  802563:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802566:	83 c4 10             	add    $0x10,%esp
  802569:	5b                   	pop    %ebx
  80256a:	5e                   	pop    %esi
  80256b:	5d                   	pop    %ebp
  80256c:	c3                   	ret    
  80256d:	00 00                	add    %al,(%eax)
	...

00802570 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	89 c2                	mov    %eax,%edx
  802578:	c1 ea 16             	shr    $0x16,%edx
  80257b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802582:	f6 c2 01             	test   $0x1,%dl
  802585:	74 26                	je     8025ad <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802587:	c1 e8 0c             	shr    $0xc,%eax
  80258a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802591:	a8 01                	test   $0x1,%al
  802593:	74 18                	je     8025ad <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802595:	c1 e8 0c             	shr    $0xc,%eax
  802598:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80259b:	c1 e2 02             	shl    $0x2,%edx
  80259e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8025a3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8025a8:	0f b7 c0             	movzwl %ax,%eax
  8025ab:	eb 05                	jmp    8025b2 <pageref+0x42>
  8025ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    
	...

008025c0 <__udivdi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	57                   	push   %edi
  8025c4:	56                   	push   %esi
  8025c5:	83 ec 10             	sub    $0x10,%esp
  8025c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8025cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ce:	8b 75 10             	mov    0x10(%ebp),%esi
  8025d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8025d9:	75 35                	jne    802610 <__udivdi3+0x50>
  8025db:	39 fe                	cmp    %edi,%esi
  8025dd:	77 61                	ja     802640 <__udivdi3+0x80>
  8025df:	85 f6                	test   %esi,%esi
  8025e1:	75 0b                	jne    8025ee <__udivdi3+0x2e>
  8025e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e8:	31 d2                	xor    %edx,%edx
  8025ea:	f7 f6                	div    %esi
  8025ec:	89 c6                	mov    %eax,%esi
  8025ee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025f1:	31 d2                	xor    %edx,%edx
  8025f3:	89 f8                	mov    %edi,%eax
  8025f5:	f7 f6                	div    %esi
  8025f7:	89 c7                	mov    %eax,%edi
  8025f9:	89 c8                	mov    %ecx,%eax
  8025fb:	f7 f6                	div    %esi
  8025fd:	89 c1                	mov    %eax,%ecx
  8025ff:	89 fa                	mov    %edi,%edx
  802601:	89 c8                	mov    %ecx,%eax
  802603:	83 c4 10             	add    $0x10,%esp
  802606:	5e                   	pop    %esi
  802607:	5f                   	pop    %edi
  802608:	5d                   	pop    %ebp
  802609:	c3                   	ret    
  80260a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802610:	39 f8                	cmp    %edi,%eax
  802612:	77 1c                	ja     802630 <__udivdi3+0x70>
  802614:	0f bd d0             	bsr    %eax,%edx
  802617:	83 f2 1f             	xor    $0x1f,%edx
  80261a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80261d:	75 39                	jne    802658 <__udivdi3+0x98>
  80261f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802622:	0f 86 a0 00 00 00    	jbe    8026c8 <__udivdi3+0x108>
  802628:	39 f8                	cmp    %edi,%eax
  80262a:	0f 82 98 00 00 00    	jb     8026c8 <__udivdi3+0x108>
  802630:	31 ff                	xor    %edi,%edi
  802632:	31 c9                	xor    %ecx,%ecx
  802634:	89 c8                	mov    %ecx,%eax
  802636:	89 fa                	mov    %edi,%edx
  802638:	83 c4 10             	add    $0x10,%esp
  80263b:	5e                   	pop    %esi
  80263c:	5f                   	pop    %edi
  80263d:	5d                   	pop    %ebp
  80263e:	c3                   	ret    
  80263f:	90                   	nop
  802640:	89 d1                	mov    %edx,%ecx
  802642:	89 fa                	mov    %edi,%edx
  802644:	89 c8                	mov    %ecx,%eax
  802646:	31 ff                	xor    %edi,%edi
  802648:	f7 f6                	div    %esi
  80264a:	89 c1                	mov    %eax,%ecx
  80264c:	89 fa                	mov    %edi,%edx
  80264e:	89 c8                	mov    %ecx,%eax
  802650:	83 c4 10             	add    $0x10,%esp
  802653:	5e                   	pop    %esi
  802654:	5f                   	pop    %edi
  802655:	5d                   	pop    %ebp
  802656:	c3                   	ret    
  802657:	90                   	nop
  802658:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80265c:	89 f2                	mov    %esi,%edx
  80265e:	d3 e0                	shl    %cl,%eax
  802660:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802663:	b8 20 00 00 00       	mov    $0x20,%eax
  802668:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80266b:	89 c1                	mov    %eax,%ecx
  80266d:	d3 ea                	shr    %cl,%edx
  80266f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802673:	0b 55 ec             	or     -0x14(%ebp),%edx
  802676:	d3 e6                	shl    %cl,%esi
  802678:	89 c1                	mov    %eax,%ecx
  80267a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80267d:	89 fe                	mov    %edi,%esi
  80267f:	d3 ee                	shr    %cl,%esi
  802681:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802685:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802688:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80268b:	d3 e7                	shl    %cl,%edi
  80268d:	89 c1                	mov    %eax,%ecx
  80268f:	d3 ea                	shr    %cl,%edx
  802691:	09 d7                	or     %edx,%edi
  802693:	89 f2                	mov    %esi,%edx
  802695:	89 f8                	mov    %edi,%eax
  802697:	f7 75 ec             	divl   -0x14(%ebp)
  80269a:	89 d6                	mov    %edx,%esi
  80269c:	89 c7                	mov    %eax,%edi
  80269e:	f7 65 e8             	mull   -0x18(%ebp)
  8026a1:	39 d6                	cmp    %edx,%esi
  8026a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8026a6:	72 30                	jb     8026d8 <__udivdi3+0x118>
  8026a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ab:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026af:	d3 e2                	shl    %cl,%edx
  8026b1:	39 c2                	cmp    %eax,%edx
  8026b3:	73 05                	jae    8026ba <__udivdi3+0xfa>
  8026b5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8026b8:	74 1e                	je     8026d8 <__udivdi3+0x118>
  8026ba:	89 f9                	mov    %edi,%ecx
  8026bc:	31 ff                	xor    %edi,%edi
  8026be:	e9 71 ff ff ff       	jmp    802634 <__udivdi3+0x74>
  8026c3:	90                   	nop
  8026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	31 ff                	xor    %edi,%edi
  8026ca:	b9 01 00 00 00       	mov    $0x1,%ecx
  8026cf:	e9 60 ff ff ff       	jmp    802634 <__udivdi3+0x74>
  8026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026d8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8026db:	31 ff                	xor    %edi,%edi
  8026dd:	89 c8                	mov    %ecx,%eax
  8026df:	89 fa                	mov    %edi,%edx
  8026e1:	83 c4 10             	add    $0x10,%esp
  8026e4:	5e                   	pop    %esi
  8026e5:	5f                   	pop    %edi
  8026e6:	5d                   	pop    %ebp
  8026e7:	c3                   	ret    
	...

008026f0 <__umoddi3>:
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
  8026f3:	57                   	push   %edi
  8026f4:	56                   	push   %esi
  8026f5:	83 ec 20             	sub    $0x20,%esp
  8026f8:	8b 55 14             	mov    0x14(%ebp),%edx
  8026fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026fe:	8b 7d 10             	mov    0x10(%ebp),%edi
  802701:	8b 75 0c             	mov    0xc(%ebp),%esi
  802704:	85 d2                	test   %edx,%edx
  802706:	89 c8                	mov    %ecx,%eax
  802708:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80270b:	75 13                	jne    802720 <__umoddi3+0x30>
  80270d:	39 f7                	cmp    %esi,%edi
  80270f:	76 3f                	jbe    802750 <__umoddi3+0x60>
  802711:	89 f2                	mov    %esi,%edx
  802713:	f7 f7                	div    %edi
  802715:	89 d0                	mov    %edx,%eax
  802717:	31 d2                	xor    %edx,%edx
  802719:	83 c4 20             	add    $0x20,%esp
  80271c:	5e                   	pop    %esi
  80271d:	5f                   	pop    %edi
  80271e:	5d                   	pop    %ebp
  80271f:	c3                   	ret    
  802720:	39 f2                	cmp    %esi,%edx
  802722:	77 4c                	ja     802770 <__umoddi3+0x80>
  802724:	0f bd ca             	bsr    %edx,%ecx
  802727:	83 f1 1f             	xor    $0x1f,%ecx
  80272a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80272d:	75 51                	jne    802780 <__umoddi3+0x90>
  80272f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802732:	0f 87 e0 00 00 00    	ja     802818 <__umoddi3+0x128>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	29 f8                	sub    %edi,%eax
  80273d:	19 d6                	sbb    %edx,%esi
  80273f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	89 f2                	mov    %esi,%edx
  802747:	83 c4 20             	add    $0x20,%esp
  80274a:	5e                   	pop    %esi
  80274b:	5f                   	pop    %edi
  80274c:	5d                   	pop    %ebp
  80274d:	c3                   	ret    
  80274e:	66 90                	xchg   %ax,%ax
  802750:	85 ff                	test   %edi,%edi
  802752:	75 0b                	jne    80275f <__umoddi3+0x6f>
  802754:	b8 01 00 00 00       	mov    $0x1,%eax
  802759:	31 d2                	xor    %edx,%edx
  80275b:	f7 f7                	div    %edi
  80275d:	89 c7                	mov    %eax,%edi
  80275f:	89 f0                	mov    %esi,%eax
  802761:	31 d2                	xor    %edx,%edx
  802763:	f7 f7                	div    %edi
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	f7 f7                	div    %edi
  80276a:	eb a9                	jmp    802715 <__umoddi3+0x25>
  80276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802770:	89 c8                	mov    %ecx,%eax
  802772:	89 f2                	mov    %esi,%edx
  802774:	83 c4 20             	add    $0x20,%esp
  802777:	5e                   	pop    %esi
  802778:	5f                   	pop    %edi
  802779:	5d                   	pop    %ebp
  80277a:	c3                   	ret    
  80277b:	90                   	nop
  80277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802780:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802784:	d3 e2                	shl    %cl,%edx
  802786:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802789:	ba 20 00 00 00       	mov    $0x20,%edx
  80278e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802791:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802794:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802798:	89 fa                	mov    %edi,%edx
  80279a:	d3 ea                	shr    %cl,%edx
  80279c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027a0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8027a3:	d3 e7                	shl    %cl,%edi
  8027a5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027ac:	89 f2                	mov    %esi,%edx
  8027ae:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8027b1:	89 c7                	mov    %eax,%edi
  8027b3:	d3 ea                	shr    %cl,%edx
  8027b5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8027bc:	89 c2                	mov    %eax,%edx
  8027be:	d3 e6                	shl    %cl,%esi
  8027c0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027c4:	d3 ea                	shr    %cl,%edx
  8027c6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027ca:	09 d6                	or     %edx,%esi
  8027cc:	89 f0                	mov    %esi,%eax
  8027ce:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8027d1:	d3 e7                	shl    %cl,%edi
  8027d3:	89 f2                	mov    %esi,%edx
  8027d5:	f7 75 f4             	divl   -0xc(%ebp)
  8027d8:	89 d6                	mov    %edx,%esi
  8027da:	f7 65 e8             	mull   -0x18(%ebp)
  8027dd:	39 d6                	cmp    %edx,%esi
  8027df:	72 2b                	jb     80280c <__umoddi3+0x11c>
  8027e1:	39 c7                	cmp    %eax,%edi
  8027e3:	72 23                	jb     802808 <__umoddi3+0x118>
  8027e5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027e9:	29 c7                	sub    %eax,%edi
  8027eb:	19 d6                	sbb    %edx,%esi
  8027ed:	89 f0                	mov    %esi,%eax
  8027ef:	89 f2                	mov    %esi,%edx
  8027f1:	d3 ef                	shr    %cl,%edi
  8027f3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027f7:	d3 e0                	shl    %cl,%eax
  8027f9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027fd:	09 f8                	or     %edi,%eax
  8027ff:	d3 ea                	shr    %cl,%edx
  802801:	83 c4 20             	add    $0x20,%esp
  802804:	5e                   	pop    %esi
  802805:	5f                   	pop    %edi
  802806:	5d                   	pop    %ebp
  802807:	c3                   	ret    
  802808:	39 d6                	cmp    %edx,%esi
  80280a:	75 d9                	jne    8027e5 <__umoddi3+0xf5>
  80280c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80280f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802812:	eb d1                	jmp    8027e5 <__umoddi3+0xf5>
  802814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802818:	39 f2                	cmp    %esi,%edx
  80281a:	0f 82 18 ff ff ff    	jb     802738 <__umoddi3+0x48>
  802820:	e9 1d ff ff ff       	jmp    802742 <__umoddi3+0x52>
