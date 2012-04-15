
obj/user/cat:     file format elf32-i386


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
  80002c:	e8 43 01 00 00       	call   800174 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800043:	eb 40                	jmp    800085 <cat+0x51>
		if ((r = write(1, buf, n)) != n)
  800045:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800049:	c7 44 24 04 80 60 80 	movl   $0x806080,0x4(%esp)
  800050:	00 
  800051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800058:	e8 98 14 00 00       	call   8014f5 <write>
  80005d:	39 c3                	cmp    %eax,%ebx
  80005f:	74 24                	je     800085 <cat+0x51>
			panic("write error copying %s: %e", s, r);
  800061:	89 44 24 10          	mov    %eax,0x10(%esp)
  800065:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800069:	c7 44 24 08 60 2a 80 	movl   $0x802a60,0x8(%esp)
  800070:	00 
  800071:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800078:	00 
  800079:	c7 04 24 7b 2a 80 00 	movl   $0x802a7b,(%esp)
  800080:	e8 5b 01 00 00       	call   8001e0 <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800085:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 80 60 80 	movl   $0x806080,0x4(%esp)
  800094:	00 
  800095:	89 34 24             	mov    %esi,(%esp)
  800098:	e8 e1 14 00 00       	call   80157e <read>
  80009d:	89 c3                	mov    %eax,%ebx
  80009f:	85 c0                	test   %eax,%eax
  8000a1:	7f a2                	jg     800045 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	79 24                	jns    8000cb <cat+0x97>
		panic("error reading %s: %e", s, n);
  8000a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000af:	c7 44 24 08 86 2a 80 	movl   $0x802a86,0x8(%esp)
  8000b6:	00 
  8000b7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 7b 2a 80 00 	movl   $0x802a7b,(%esp)
  8000c6:	e8 15 01 00 00       	call   8001e0 <_panic>
}
  8000cb:	83 c4 2c             	add    $0x2c,%esp
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 2c             	sub    $0x2c,%esp
  8000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	int f, i;

	argv0 = "cat";
  8000df:	c7 05 84 80 80 00 9b 	movl   $0x802a9b,0x808084
  8000e6:	2a 80 00 
	if (argc == 1)
  8000e9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ed:	74 0d                	je     8000fc <umain+0x29>
		cat(0, "<stdin>");
  8000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
	else
		for (i = 1; i < argc; i++) {
  8000f4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000f8:	7f 18                	jg     800112 <umain+0x3f>
  8000fa:	eb 70                	jmp    80016c <umain+0x99>
{
	int f, i;

	argv0 = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
  8000fc:	c7 44 24 04 9f 2a 80 	movl   $0x802a9f,0x4(%esp)
  800103:	00 
  800104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010b:	e8 24 ff ff ff       	call   800034 <cat>
  800110:	eb 5a                	jmp    80016c <umain+0x99>
	if (n < 0)
		panic("error reading %s: %e", s, n);
}

void
umain(int argc, char **argv)
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	argv0 = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800115:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80011c:	00 
  80011d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800120:	89 04 24             	mov    %eax,(%esp)
  800123:	e8 5b 19 00 00       	call   801a83 <open>
  800128:	89 c7                	mov    %eax,%edi
			if (f < 0)
  80012a:	85 c0                	test   %eax,%eax
  80012c:	79 1c                	jns    80014a <umain+0x77>
				printf("can't open %s: %e\n", argv[i], f);
  80012e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800132:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800135:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013c:	c7 04 24 a7 2a 80 00 	movl   $0x802aa7,(%esp)
  800143:	e8 8b 1a 00 00       	call   801bd3 <printf>
  800148:	eb 1a                	jmp    800164 <umain+0x91>
			else {
				cat(f, argv[i]);
  80014a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014d:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800150:	89 44 24 04          	mov    %eax,0x4(%esp)
  800154:	89 3c 24             	mov    %edi,(%esp)
  800157:	e8 d8 fe ff ff       	call   800034 <cat>
				close(f);
  80015c:	89 3c 24             	mov    %edi,(%esp)
  80015f:	e8 7a 15 00 00       	call   8016de <close>

	argv0 = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800164:	83 c3 01             	add    $0x1,%ebx
  800167:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  80016a:	7f a6                	jg     800112 <umain+0x3f>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80016c:	83 c4 2c             	add    $0x2c,%esp
  80016f:	5b                   	pop    %ebx
  800170:	5e                   	pop    %esi
  800171:	5f                   	pop    %edi
  800172:	5d                   	pop    %ebp
  800173:	c3                   	ret    

00800174 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	83 ec 18             	sub    $0x18,%esp
  80017a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80017d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800180:	8b 75 08             	mov    0x8(%ebp),%esi
  800183:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800186:	e8 63 10 00 00       	call   8011ee <sys_getenvid>
	env = &envs[ENVX(envid)];
  80018b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800190:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 80 80 80 00       	mov    %eax,0x808080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019d:	85 f6                	test   %esi,%esi
  80019f:	7e 07                	jle    8001a8 <libmain+0x34>
		binaryname = argv[0];
  8001a1:	8b 03                	mov    (%ebx),%eax
  8001a3:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  8001a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ac:	89 34 24             	mov    %esi,(%esp)
  8001af:	e8 1f ff ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001b4:	e8 0b 00 00 00       	call   8001c4 <exit>
}
  8001b9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001bc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001bf:	89 ec                	mov    %ebp,%esp
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
	...

008001c4 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001ca:	e8 8c 15 00 00       	call   80175b <close_all>
	sys_env_destroy(0);
  8001cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001d6:	e8 47 10 00 00       	call   801222 <sys_env_destroy>
}
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    
  8001dd:	00 00                	add    %al,(%eax)
	...

008001e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	53                   	push   %ebx
  8001e4:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8001e7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8001ea:	a1 84 80 80 00       	mov    0x808084,%eax
  8001ef:	85 c0                	test   %eax,%eax
  8001f1:	74 10                	je     800203 <_panic+0x23>
		cprintf("%s: ", argv0);
  8001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f7:	c7 04 24 d1 2a 80 00 	movl   $0x802ad1,(%esp)
  8001fe:	e8 a2 00 00 00       	call   8002a5 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80020a:	8b 45 08             	mov    0x8(%ebp),%eax
  80020d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800211:	a1 00 60 80 00       	mov    0x806000,%eax
  800216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021a:	c7 04 24 d6 2a 80 00 	movl   $0x802ad6,(%esp)
  800221:	e8 7f 00 00 00       	call   8002a5 <cprintf>
	vcprintf(fmt, ap);
  800226:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80022a:	8b 45 10             	mov    0x10(%ebp),%eax
  80022d:	89 04 24             	mov    %eax,(%esp)
  800230:	e8 0f 00 00 00       	call   800244 <vcprintf>
	cprintf("\n");
  800235:	c7 04 24 22 2f 80 00 	movl   $0x802f22,(%esp)
  80023c:	e8 64 00 00 00       	call   8002a5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800241:	cc                   	int3   
  800242:	eb fd                	jmp    800241 <_panic+0x61>

00800244 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80024d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800254:	00 00 00 
	b.cnt = 0;
  800257:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800261:	8b 45 0c             	mov    0xc(%ebp),%eax
  800264:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800275:	89 44 24 04          	mov    %eax,0x4(%esp)
  800279:	c7 04 24 bf 02 80 00 	movl   $0x8002bf,(%esp)
  800280:	e8 d8 01 00 00       	call   80045d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800285:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800295:	89 04 24             	mov    %eax,(%esp)
  800298:	e8 c3 0a 00 00       	call   800d60 <sys_cputs>

	return b.cnt;
}
  80029d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002ab:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b5:	89 04 24             	mov    %eax,(%esp)
  8002b8:	e8 87 ff ff ff       	call   800244 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	53                   	push   %ebx
  8002c3:	83 ec 14             	sub    $0x14,%esp
  8002c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002c9:	8b 03                	mov    (%ebx),%eax
  8002cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ce:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002d2:	83 c0 01             	add    $0x1,%eax
  8002d5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002dc:	75 19                	jne    8002f7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002de:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002e5:	00 
  8002e6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002e9:	89 04 24             	mov    %eax,(%esp)
  8002ec:	e8 6f 0a 00 00       	call   800d60 <sys_cputs>
		b->idx = 0;
  8002f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002f7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002fb:	83 c4 14             	add    $0x14,%esp
  8002fe:	5b                   	pop    %ebx
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    
	...

00800310 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	57                   	push   %edi
  800314:	56                   	push   %esi
  800315:	53                   	push   %ebx
  800316:	83 ec 4c             	sub    $0x4c,%esp
  800319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031c:	89 d6                	mov    %edx,%esi
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800324:	8b 55 0c             	mov    0xc(%ebp),%edx
  800327:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80032a:	8b 45 10             	mov    0x10(%ebp),%eax
  80032d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800330:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800333:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800336:	b9 00 00 00 00       	mov    $0x0,%ecx
  80033b:	39 d1                	cmp    %edx,%ecx
  80033d:	72 15                	jb     800354 <printnum+0x44>
  80033f:	77 07                	ja     800348 <printnum+0x38>
  800341:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800344:	39 d0                	cmp    %edx,%eax
  800346:	76 0c                	jbe    800354 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800348:	83 eb 01             	sub    $0x1,%ebx
  80034b:	85 db                	test   %ebx,%ebx
  80034d:	8d 76 00             	lea    0x0(%esi),%esi
  800350:	7f 61                	jg     8003b3 <printnum+0xa3>
  800352:	eb 70                	jmp    8003c4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800354:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800358:	83 eb 01             	sub    $0x1,%ebx
  80035b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80035f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800363:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800367:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80036b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80036e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800371:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800374:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800378:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80037f:	00 
  800380:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800383:	89 04 24             	mov    %eax,(%esp)
  800386:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800389:	89 54 24 04          	mov    %edx,0x4(%esp)
  80038d:	e8 4e 24 00 00       	call   8027e0 <__udivdi3>
  800392:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800395:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800398:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80039c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003a0:	89 04 24             	mov    %eax,(%esp)
  8003a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003a7:	89 f2                	mov    %esi,%edx
  8003a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ac:	e8 5f ff ff ff       	call   800310 <printnum>
  8003b1:	eb 11                	jmp    8003c4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b7:	89 3c 24             	mov    %edi,(%esp)
  8003ba:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003bd:	83 eb 01             	sub    $0x1,%ebx
  8003c0:	85 db                	test   %ebx,%ebx
  8003c2:	7f ef                	jg     8003b3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003c8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003da:	00 
  8003db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003de:	89 14 24             	mov    %edx,(%esp)
  8003e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003e8:	e8 23 25 00 00       	call   802910 <__umoddi3>
  8003ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f1:	0f be 80 f2 2a 80 00 	movsbl 0x802af2(%eax),%eax
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003fe:	83 c4 4c             	add    $0x4c,%esp
  800401:	5b                   	pop    %ebx
  800402:	5e                   	pop    %esi
  800403:	5f                   	pop    %edi
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800409:	83 fa 01             	cmp    $0x1,%edx
  80040c:	7e 0e                	jle    80041c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80040e:	8b 10                	mov    (%eax),%edx
  800410:	8d 4a 08             	lea    0x8(%edx),%ecx
  800413:	89 08                	mov    %ecx,(%eax)
  800415:	8b 02                	mov    (%edx),%eax
  800417:	8b 52 04             	mov    0x4(%edx),%edx
  80041a:	eb 22                	jmp    80043e <getuint+0x38>
	else if (lflag)
  80041c:	85 d2                	test   %edx,%edx
  80041e:	74 10                	je     800430 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800420:	8b 10                	mov    (%eax),%edx
  800422:	8d 4a 04             	lea    0x4(%edx),%ecx
  800425:	89 08                	mov    %ecx,(%eax)
  800427:	8b 02                	mov    (%edx),%eax
  800429:	ba 00 00 00 00       	mov    $0x0,%edx
  80042e:	eb 0e                	jmp    80043e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800430:	8b 10                	mov    (%eax),%edx
  800432:	8d 4a 04             	lea    0x4(%edx),%ecx
  800435:	89 08                	mov    %ecx,(%eax)
  800437:	8b 02                	mov    (%edx),%eax
  800439:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80043e:	5d                   	pop    %ebp
  80043f:	c3                   	ret    

00800440 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800446:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80044a:	8b 10                	mov    (%eax),%edx
  80044c:	3b 50 04             	cmp    0x4(%eax),%edx
  80044f:	73 0a                	jae    80045b <sprintputch+0x1b>
		*b->buf++ = ch;
  800451:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800454:	88 0a                	mov    %cl,(%edx)
  800456:	83 c2 01             	add    $0x1,%edx
  800459:	89 10                	mov    %edx,(%eax)
}
  80045b:	5d                   	pop    %ebp
  80045c:	c3                   	ret    

0080045d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	57                   	push   %edi
  800461:	56                   	push   %esi
  800462:	53                   	push   %ebx
  800463:	83 ec 5c             	sub    $0x5c,%esp
  800466:	8b 7d 08             	mov    0x8(%ebp),%edi
  800469:	8b 75 0c             	mov    0xc(%ebp),%esi
  80046c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80046f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800476:	eb 11                	jmp    800489 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800478:	85 c0                	test   %eax,%eax
  80047a:	0f 84 ec 03 00 00    	je     80086c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800480:	89 74 24 04          	mov    %esi,0x4(%esp)
  800484:	89 04 24             	mov    %eax,(%esp)
  800487:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800489:	0f b6 03             	movzbl (%ebx),%eax
  80048c:	83 c3 01             	add    $0x1,%ebx
  80048f:	83 f8 25             	cmp    $0x25,%eax
  800492:	75 e4                	jne    800478 <vprintfmt+0x1b>
  800494:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800498:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80049f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004a6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004b2:	eb 06                	jmp    8004ba <vprintfmt+0x5d>
  8004b4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004b8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	0f b6 13             	movzbl (%ebx),%edx
  8004bd:	0f b6 c2             	movzbl %dl,%eax
  8004c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c3:	8d 43 01             	lea    0x1(%ebx),%eax
  8004c6:	83 ea 23             	sub    $0x23,%edx
  8004c9:	80 fa 55             	cmp    $0x55,%dl
  8004cc:	0f 87 7d 03 00 00    	ja     80084f <vprintfmt+0x3f2>
  8004d2:	0f b6 d2             	movzbl %dl,%edx
  8004d5:	ff 24 95 40 2c 80 00 	jmp    *0x802c40(,%edx,4)
  8004dc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004e0:	eb d6                	jmp    8004b8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e5:	83 ea 30             	sub    $0x30,%edx
  8004e8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8004eb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004ee:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004f1:	83 fb 09             	cmp    $0x9,%ebx
  8004f4:	77 4c                	ja     800542 <vprintfmt+0xe5>
  8004f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004fc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8004ff:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800502:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800506:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800509:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80050c:	83 fb 09             	cmp    $0x9,%ebx
  80050f:	76 eb                	jbe    8004fc <vprintfmt+0x9f>
  800511:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800514:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800517:	eb 29                	jmp    800542 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800519:	8b 55 14             	mov    0x14(%ebp),%edx
  80051c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80051f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800522:	8b 12                	mov    (%edx),%edx
  800524:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800527:	eb 19                	jmp    800542 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800529:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80052c:	c1 fa 1f             	sar    $0x1f,%edx
  80052f:	f7 d2                	not    %edx
  800531:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800534:	eb 82                	jmp    8004b8 <vprintfmt+0x5b>
  800536:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80053d:	e9 76 ff ff ff       	jmp    8004b8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800542:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800546:	0f 89 6c ff ff ff    	jns    8004b8 <vprintfmt+0x5b>
  80054c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80054f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800552:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800555:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800558:	e9 5b ff ff ff       	jmp    8004b8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80055d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800560:	e9 53 ff ff ff       	jmp    8004b8 <vprintfmt+0x5b>
  800565:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 50 04             	lea    0x4(%eax),%edx
  80056e:	89 55 14             	mov    %edx,0x14(%ebp)
  800571:	89 74 24 04          	mov    %esi,0x4(%esp)
  800575:	8b 00                	mov    (%eax),%eax
  800577:	89 04 24             	mov    %eax,(%esp)
  80057a:	ff d7                	call   *%edi
  80057c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80057f:	e9 05 ff ff ff       	jmp    800489 <vprintfmt+0x2c>
  800584:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 50 04             	lea    0x4(%eax),%edx
  80058d:	89 55 14             	mov    %edx,0x14(%ebp)
  800590:	8b 00                	mov    (%eax),%eax
  800592:	89 c2                	mov    %eax,%edx
  800594:	c1 fa 1f             	sar    $0x1f,%edx
  800597:	31 d0                	xor    %edx,%eax
  800599:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80059b:	83 f8 0f             	cmp    $0xf,%eax
  80059e:	7f 0b                	jg     8005ab <vprintfmt+0x14e>
  8005a0:	8b 14 85 a0 2d 80 00 	mov    0x802da0(,%eax,4),%edx
  8005a7:	85 d2                	test   %edx,%edx
  8005a9:	75 20                	jne    8005cb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8005ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005af:	c7 44 24 08 03 2b 80 	movl   $0x802b03,0x8(%esp)
  8005b6:	00 
  8005b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005bb:	89 3c 24             	mov    %edi,(%esp)
  8005be:	e8 31 03 00 00       	call   8008f4 <printfmt>
  8005c3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005c6:	e9 be fe ff ff       	jmp    800489 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005cf:	c7 44 24 08 e6 2e 80 	movl   $0x802ee6,0x8(%esp)
  8005d6:	00 
  8005d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005db:	89 3c 24             	mov    %edi,(%esp)
  8005de:	e8 11 03 00 00       	call   8008f4 <printfmt>
  8005e3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8005e6:	e9 9e fe ff ff       	jmp    800489 <vprintfmt+0x2c>
  8005eb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005ee:	89 c3                	mov    %eax,%ebx
  8005f0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 50 04             	lea    0x4(%eax),%edx
  8005ff:	89 55 14             	mov    %edx,0x14(%ebp)
  800602:	8b 00                	mov    (%eax),%eax
  800604:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800607:	85 c0                	test   %eax,%eax
  800609:	75 07                	jne    800612 <vprintfmt+0x1b5>
  80060b:	c7 45 e0 0c 2b 80 00 	movl   $0x802b0c,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800612:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800616:	7e 06                	jle    80061e <vprintfmt+0x1c1>
  800618:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80061c:	75 13                	jne    800631 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800621:	0f be 02             	movsbl (%edx),%eax
  800624:	85 c0                	test   %eax,%eax
  800626:	0f 85 99 00 00 00    	jne    8006c5 <vprintfmt+0x268>
  80062c:	e9 86 00 00 00       	jmp    8006b7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800631:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800635:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800638:	89 0c 24             	mov    %ecx,(%esp)
  80063b:	e8 fb 02 00 00       	call   80093b <strnlen>
  800640:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800643:	29 c2                	sub    %eax,%edx
  800645:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800648:	85 d2                	test   %edx,%edx
  80064a:	7e d2                	jle    80061e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80064c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800650:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800653:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800656:	89 d3                	mov    %edx,%ebx
  800658:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800664:	83 eb 01             	sub    $0x1,%ebx
  800667:	85 db                	test   %ebx,%ebx
  800669:	7f ed                	jg     800658 <vprintfmt+0x1fb>
  80066b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800675:	eb a7                	jmp    80061e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800677:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80067b:	74 18                	je     800695 <vprintfmt+0x238>
  80067d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800680:	83 fa 5e             	cmp    $0x5e,%edx
  800683:	76 10                	jbe    800695 <vprintfmt+0x238>
					putch('?', putdat);
  800685:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800689:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800690:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800693:	eb 0a                	jmp    80069f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800695:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800699:	89 04 24             	mov    %eax,(%esp)
  80069c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006a3:	0f be 03             	movsbl (%ebx),%eax
  8006a6:	85 c0                	test   %eax,%eax
  8006a8:	74 05                	je     8006af <vprintfmt+0x252>
  8006aa:	83 c3 01             	add    $0x1,%ebx
  8006ad:	eb 29                	jmp    8006d8 <vprintfmt+0x27b>
  8006af:	89 fe                	mov    %edi,%esi
  8006b1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006b4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bb:	7f 2e                	jg     8006eb <vprintfmt+0x28e>
  8006bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8006c0:	e9 c4 fd ff ff       	jmp    800489 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c8:	83 c2 01             	add    $0x1,%edx
  8006cb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006ce:	89 f7                	mov    %esi,%edi
  8006d0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006d3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8006d6:	89 d3                	mov    %edx,%ebx
  8006d8:	85 f6                	test   %esi,%esi
  8006da:	78 9b                	js     800677 <vprintfmt+0x21a>
  8006dc:	83 ee 01             	sub    $0x1,%esi
  8006df:	79 96                	jns    800677 <vprintfmt+0x21a>
  8006e1:	89 fe                	mov    %edi,%esi
  8006e3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006e6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006e9:	eb cc                	jmp    8006b7 <vprintfmt+0x25a>
  8006eb:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8006ee:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006fc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fe:	83 eb 01             	sub    $0x1,%ebx
  800701:	85 db                	test   %ebx,%ebx
  800703:	7f ec                	jg     8006f1 <vprintfmt+0x294>
  800705:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800708:	e9 7c fd ff ff       	jmp    800489 <vprintfmt+0x2c>
  80070d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800710:	83 f9 01             	cmp    $0x1,%ecx
  800713:	7e 16                	jle    80072b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 50 08             	lea    0x8(%eax),%edx
  80071b:	89 55 14             	mov    %edx,0x14(%ebp)
  80071e:	8b 10                	mov    (%eax),%edx
  800720:	8b 48 04             	mov    0x4(%eax),%ecx
  800723:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800726:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800729:	eb 32                	jmp    80075d <vprintfmt+0x300>
	else if (lflag)
  80072b:	85 c9                	test   %ecx,%ecx
  80072d:	74 18                	je     800747 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8d 50 04             	lea    0x4(%eax),%edx
  800735:	89 55 14             	mov    %edx,0x14(%ebp)
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073d:	89 c1                	mov    %eax,%ecx
  80073f:	c1 f9 1f             	sar    $0x1f,%ecx
  800742:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800745:	eb 16                	jmp    80075d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	89 55 14             	mov    %edx,0x14(%ebp)
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800755:	89 c2                	mov    %eax,%edx
  800757:	c1 fa 1f             	sar    $0x1f,%edx
  80075a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80075d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800760:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800763:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800768:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80076c:	0f 89 9b 00 00 00    	jns    80080d <vprintfmt+0x3b0>
				putch('-', putdat);
  800772:	89 74 24 04          	mov    %esi,0x4(%esp)
  800776:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80077d:	ff d7                	call   *%edi
				num = -(long long) num;
  80077f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800782:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800785:	f7 d9                	neg    %ecx
  800787:	83 d3 00             	adc    $0x0,%ebx
  80078a:	f7 db                	neg    %ebx
  80078c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800791:	eb 7a                	jmp    80080d <vprintfmt+0x3b0>
  800793:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800796:	89 ca                	mov    %ecx,%edx
  800798:	8d 45 14             	lea    0x14(%ebp),%eax
  80079b:	e8 66 fc ff ff       	call   800406 <getuint>
  8007a0:	89 c1                	mov    %eax,%ecx
  8007a2:	89 d3                	mov    %edx,%ebx
  8007a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007a9:	eb 62                	jmp    80080d <vprintfmt+0x3b0>
  8007ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007ae:	89 ca                	mov    %ecx,%edx
  8007b0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b3:	e8 4e fc ff ff       	call   800406 <getuint>
  8007b8:	89 c1                	mov    %eax,%ecx
  8007ba:	89 d3                	mov    %edx,%ebx
  8007bc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8007c1:	eb 4a                	jmp    80080d <vprintfmt+0x3b0>
  8007c3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8007c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ca:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007d1:	ff d7                	call   *%edi
			putch('x', putdat);
  8007d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007de:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e9:	8b 08                	mov    (%eax),%ecx
  8007eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007f5:	eb 16                	jmp    80080d <vprintfmt+0x3b0>
  8007f7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007fa:	89 ca                	mov    %ecx,%edx
  8007fc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ff:	e8 02 fc ff ff       	call   800406 <getuint>
  800804:	89 c1                	mov    %eax,%ecx
  800806:	89 d3                	mov    %edx,%ebx
  800808:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80080d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800811:	89 54 24 10          	mov    %edx,0x10(%esp)
  800815:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800818:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80081c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800820:	89 0c 24             	mov    %ecx,(%esp)
  800823:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800827:	89 f2                	mov    %esi,%edx
  800829:	89 f8                	mov    %edi,%eax
  80082b:	e8 e0 fa ff ff       	call   800310 <printnum>
  800830:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800833:	e9 51 fc ff ff       	jmp    800489 <vprintfmt+0x2c>
  800838:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80083b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800842:	89 14 24             	mov    %edx,(%esp)
  800845:	ff d7                	call   *%edi
  800847:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80084a:	e9 3a fc ff ff       	jmp    800489 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80084f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800853:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80085a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80085f:	80 38 25             	cmpb   $0x25,(%eax)
  800862:	0f 84 21 fc ff ff    	je     800489 <vprintfmt+0x2c>
  800868:	89 c3                	mov    %eax,%ebx
  80086a:	eb f0                	jmp    80085c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80086c:	83 c4 5c             	add    $0x5c,%esp
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5f                   	pop    %edi
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 28             	sub    $0x28,%esp
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800880:	85 c0                	test   %eax,%eax
  800882:	74 04                	je     800888 <vsnprintf+0x14>
  800884:	85 d2                	test   %edx,%edx
  800886:	7f 07                	jg     80088f <vsnprintf+0x1b>
  800888:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088d:	eb 3b                	jmp    8008ca <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800892:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800899:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b5:	c7 04 24 40 04 80 00 	movl   $0x800440,(%esp)
  8008bc:	e8 9c fb ff ff       	call   80045d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    

008008cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008d2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 04 24             	mov    %eax,(%esp)
  8008ed:	e8 82 ff ff ff       	call   800874 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f2:	c9                   	leave  
  8008f3:	c3                   	ret    

008008f4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8008fa:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8008fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800901:	8b 45 10             	mov    0x10(%ebp),%eax
  800904:	89 44 24 08          	mov    %eax,0x8(%esp)
  800908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	89 04 24             	mov    %eax,(%esp)
  800915:	e8 43 fb ff ff       	call   80045d <vprintfmt>
	va_end(ap);
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    
  80091c:	00 00                	add    %al,(%eax)
	...

00800920 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	80 3a 00             	cmpb   $0x0,(%edx)
  80092e:	74 09                	je     800939 <strlen+0x19>
		n++;
  800930:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800933:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800937:	75 f7                	jne    800930 <strlen+0x10>
		n++;
	return n;
}
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800942:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800945:	85 c9                	test   %ecx,%ecx
  800947:	74 19                	je     800962 <strnlen+0x27>
  800949:	80 3b 00             	cmpb   $0x0,(%ebx)
  80094c:	74 14                	je     800962 <strnlen+0x27>
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800953:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800956:	39 c8                	cmp    %ecx,%eax
  800958:	74 0d                	je     800967 <strnlen+0x2c>
  80095a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80095e:	75 f3                	jne    800953 <strnlen+0x18>
  800960:	eb 05                	jmp    800967 <strnlen+0x2c>
  800962:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800967:	5b                   	pop    %ebx
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	53                   	push   %ebx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800974:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800979:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80097d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800980:	83 c2 01             	add    $0x1,%edx
  800983:	84 c9                	test   %cl,%cl
  800985:	75 f2                	jne    800979 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
  800995:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800998:	85 f6                	test   %esi,%esi
  80099a:	74 18                	je     8009b4 <strncpy+0x2a>
  80099c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009a1:	0f b6 1a             	movzbl (%edx),%ebx
  8009a4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009aa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ad:	83 c1 01             	add    $0x1,%ecx
  8009b0:	39 ce                	cmp    %ecx,%esi
  8009b2:	77 ed                	ja     8009a1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c6:	89 f0                	mov    %esi,%eax
  8009c8:	85 c9                	test   %ecx,%ecx
  8009ca:	74 27                	je     8009f3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8009cc:	83 e9 01             	sub    $0x1,%ecx
  8009cf:	74 1d                	je     8009ee <strlcpy+0x36>
  8009d1:	0f b6 1a             	movzbl (%edx),%ebx
  8009d4:	84 db                	test   %bl,%bl
  8009d6:	74 16                	je     8009ee <strlcpy+0x36>
			*dst++ = *src++;
  8009d8:	88 18                	mov    %bl,(%eax)
  8009da:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009dd:	83 e9 01             	sub    $0x1,%ecx
  8009e0:	74 0e                	je     8009f0 <strlcpy+0x38>
			*dst++ = *src++;
  8009e2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e5:	0f b6 1a             	movzbl (%edx),%ebx
  8009e8:	84 db                	test   %bl,%bl
  8009ea:	75 ec                	jne    8009d8 <strlcpy+0x20>
  8009ec:	eb 02                	jmp    8009f0 <strlcpy+0x38>
  8009ee:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009f0:	c6 00 00             	movb   $0x0,(%eax)
  8009f3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8009f5:	5b                   	pop    %ebx
  8009f6:	5e                   	pop    %esi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a02:	0f b6 01             	movzbl (%ecx),%eax
  800a05:	84 c0                	test   %al,%al
  800a07:	74 15                	je     800a1e <strcmp+0x25>
  800a09:	3a 02                	cmp    (%edx),%al
  800a0b:	75 11                	jne    800a1e <strcmp+0x25>
		p++, q++;
  800a0d:	83 c1 01             	add    $0x1,%ecx
  800a10:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a13:	0f b6 01             	movzbl (%ecx),%eax
  800a16:	84 c0                	test   %al,%al
  800a18:	74 04                	je     800a1e <strcmp+0x25>
  800a1a:	3a 02                	cmp    (%edx),%al
  800a1c:	74 ef                	je     800a0d <strcmp+0x14>
  800a1e:	0f b6 c0             	movzbl %al,%eax
  800a21:	0f b6 12             	movzbl (%edx),%edx
  800a24:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	53                   	push   %ebx
  800a2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a35:	85 c0                	test   %eax,%eax
  800a37:	74 23                	je     800a5c <strncmp+0x34>
  800a39:	0f b6 1a             	movzbl (%edx),%ebx
  800a3c:	84 db                	test   %bl,%bl
  800a3e:	74 24                	je     800a64 <strncmp+0x3c>
  800a40:	3a 19                	cmp    (%ecx),%bl
  800a42:	75 20                	jne    800a64 <strncmp+0x3c>
  800a44:	83 e8 01             	sub    $0x1,%eax
  800a47:	74 13                	je     800a5c <strncmp+0x34>
		n--, p++, q++;
  800a49:	83 c2 01             	add    $0x1,%edx
  800a4c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a4f:	0f b6 1a             	movzbl (%edx),%ebx
  800a52:	84 db                	test   %bl,%bl
  800a54:	74 0e                	je     800a64 <strncmp+0x3c>
  800a56:	3a 19                	cmp    (%ecx),%bl
  800a58:	74 ea                	je     800a44 <strncmp+0x1c>
  800a5a:	eb 08                	jmp    800a64 <strncmp+0x3c>
  800a5c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a61:	5b                   	pop    %ebx
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a64:	0f b6 02             	movzbl (%edx),%eax
  800a67:	0f b6 11             	movzbl (%ecx),%edx
  800a6a:	29 d0                	sub    %edx,%eax
  800a6c:	eb f3                	jmp    800a61 <strncmp+0x39>

00800a6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a78:	0f b6 10             	movzbl (%eax),%edx
  800a7b:	84 d2                	test   %dl,%dl
  800a7d:	74 15                	je     800a94 <strchr+0x26>
		if (*s == c)
  800a7f:	38 ca                	cmp    %cl,%dl
  800a81:	75 07                	jne    800a8a <strchr+0x1c>
  800a83:	eb 14                	jmp    800a99 <strchr+0x2b>
  800a85:	38 ca                	cmp    %cl,%dl
  800a87:	90                   	nop
  800a88:	74 0f                	je     800a99 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	0f b6 10             	movzbl (%eax),%edx
  800a90:	84 d2                	test   %dl,%dl
  800a92:	75 f1                	jne    800a85 <strchr+0x17>
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa5:	0f b6 10             	movzbl (%eax),%edx
  800aa8:	84 d2                	test   %dl,%dl
  800aaa:	74 18                	je     800ac4 <strfind+0x29>
		if (*s == c)
  800aac:	38 ca                	cmp    %cl,%dl
  800aae:	75 0a                	jne    800aba <strfind+0x1f>
  800ab0:	eb 12                	jmp    800ac4 <strfind+0x29>
  800ab2:	38 ca                	cmp    %cl,%dl
  800ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ab8:	74 0a                	je     800ac4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	0f b6 10             	movzbl (%eax),%edx
  800ac0:	84 d2                	test   %dl,%dl
  800ac2:	75 ee                	jne    800ab2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 0c             	sub    $0xc,%esp
  800acc:	89 1c 24             	mov    %ebx,(%esp)
  800acf:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ad3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ad7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  800add:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae0:	85 c9                	test   %ecx,%ecx
  800ae2:	74 30                	je     800b14 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aea:	75 25                	jne    800b11 <memset+0x4b>
  800aec:	f6 c1 03             	test   $0x3,%cl
  800aef:	75 20                	jne    800b11 <memset+0x4b>
		c &= 0xFF;
  800af1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af4:	89 d3                	mov    %edx,%ebx
  800af6:	c1 e3 08             	shl    $0x8,%ebx
  800af9:	89 d6                	mov    %edx,%esi
  800afb:	c1 e6 18             	shl    $0x18,%esi
  800afe:	89 d0                	mov    %edx,%eax
  800b00:	c1 e0 10             	shl    $0x10,%eax
  800b03:	09 f0                	or     %esi,%eax
  800b05:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b07:	09 d8                	or     %ebx,%eax
  800b09:	c1 e9 02             	shr    $0x2,%ecx
  800b0c:	fc                   	cld    
  800b0d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b0f:	eb 03                	jmp    800b14 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b11:	fc                   	cld    
  800b12:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b14:	89 f8                	mov    %edi,%eax
  800b16:	8b 1c 24             	mov    (%esp),%ebx
  800b19:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b1d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b21:	89 ec                	mov    %ebp,%esp
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	89 34 24             	mov    %esi,(%esp)
  800b2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b38:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b3b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b3d:	39 c6                	cmp    %eax,%esi
  800b3f:	73 35                	jae    800b76 <memmove+0x51>
  800b41:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b44:	39 d0                	cmp    %edx,%eax
  800b46:	73 2e                	jae    800b76 <memmove+0x51>
		s += n;
		d += n;
  800b48:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4a:	f6 c2 03             	test   $0x3,%dl
  800b4d:	75 1b                	jne    800b6a <memmove+0x45>
  800b4f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b55:	75 13                	jne    800b6a <memmove+0x45>
  800b57:	f6 c1 03             	test   $0x3,%cl
  800b5a:	75 0e                	jne    800b6a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b5c:	83 ef 04             	sub    $0x4,%edi
  800b5f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b62:	c1 e9 02             	shr    $0x2,%ecx
  800b65:	fd                   	std    
  800b66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b68:	eb 09                	jmp    800b73 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b6a:	83 ef 01             	sub    $0x1,%edi
  800b6d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b70:	fd                   	std    
  800b71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b73:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b74:	eb 20                	jmp    800b96 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b76:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b7c:	75 15                	jne    800b93 <memmove+0x6e>
  800b7e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b84:	75 0d                	jne    800b93 <memmove+0x6e>
  800b86:	f6 c1 03             	test   $0x3,%cl
  800b89:	75 08                	jne    800b93 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b8b:	c1 e9 02             	shr    $0x2,%ecx
  800b8e:	fc                   	cld    
  800b8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b91:	eb 03                	jmp    800b96 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b93:	fc                   	cld    
  800b94:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b96:	8b 34 24             	mov    (%esp),%esi
  800b99:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b9d:	89 ec                	mov    %ebp,%esp
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ba7:	8b 45 10             	mov    0x10(%ebp),%eax
  800baa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	89 04 24             	mov    %eax,(%esp)
  800bbb:	e8 65 ff ff ff       	call   800b25 <memmove>
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	57                   	push   %edi
  800bc6:	56                   	push   %esi
  800bc7:	53                   	push   %ebx
  800bc8:	8b 75 08             	mov    0x8(%ebp),%esi
  800bcb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800bce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd1:	85 c9                	test   %ecx,%ecx
  800bd3:	74 36                	je     800c0b <memcmp+0x49>
		if (*s1 != *s2)
  800bd5:	0f b6 06             	movzbl (%esi),%eax
  800bd8:	0f b6 1f             	movzbl (%edi),%ebx
  800bdb:	38 d8                	cmp    %bl,%al
  800bdd:	74 20                	je     800bff <memcmp+0x3d>
  800bdf:	eb 14                	jmp    800bf5 <memcmp+0x33>
  800be1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800be6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800beb:	83 c2 01             	add    $0x1,%edx
  800bee:	83 e9 01             	sub    $0x1,%ecx
  800bf1:	38 d8                	cmp    %bl,%al
  800bf3:	74 12                	je     800c07 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800bf5:	0f b6 c0             	movzbl %al,%eax
  800bf8:	0f b6 db             	movzbl %bl,%ebx
  800bfb:	29 d8                	sub    %ebx,%eax
  800bfd:	eb 11                	jmp    800c10 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bff:	83 e9 01             	sub    $0x1,%ecx
  800c02:	ba 00 00 00 00       	mov    $0x0,%edx
  800c07:	85 c9                	test   %ecx,%ecx
  800c09:	75 d6                	jne    800be1 <memcmp+0x1f>
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c1b:	89 c2                	mov    %eax,%edx
  800c1d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c20:	39 d0                	cmp    %edx,%eax
  800c22:	73 15                	jae    800c39 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c28:	38 08                	cmp    %cl,(%eax)
  800c2a:	75 06                	jne    800c32 <memfind+0x1d>
  800c2c:	eb 0b                	jmp    800c39 <memfind+0x24>
  800c2e:	38 08                	cmp    %cl,(%eax)
  800c30:	74 07                	je     800c39 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c32:	83 c0 01             	add    $0x1,%eax
  800c35:	39 c2                	cmp    %eax,%edx
  800c37:	77 f5                	ja     800c2e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	83 ec 04             	sub    $0x4,%esp
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4a:	0f b6 02             	movzbl (%edx),%eax
  800c4d:	3c 20                	cmp    $0x20,%al
  800c4f:	74 04                	je     800c55 <strtol+0x1a>
  800c51:	3c 09                	cmp    $0x9,%al
  800c53:	75 0e                	jne    800c63 <strtol+0x28>
		s++;
  800c55:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c58:	0f b6 02             	movzbl (%edx),%eax
  800c5b:	3c 20                	cmp    $0x20,%al
  800c5d:	74 f6                	je     800c55 <strtol+0x1a>
  800c5f:	3c 09                	cmp    $0x9,%al
  800c61:	74 f2                	je     800c55 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c63:	3c 2b                	cmp    $0x2b,%al
  800c65:	75 0c                	jne    800c73 <strtol+0x38>
		s++;
  800c67:	83 c2 01             	add    $0x1,%edx
  800c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c71:	eb 15                	jmp    800c88 <strtol+0x4d>
	else if (*s == '-')
  800c73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c7a:	3c 2d                	cmp    $0x2d,%al
  800c7c:	75 0a                	jne    800c88 <strtol+0x4d>
		s++, neg = 1;
  800c7e:	83 c2 01             	add    $0x1,%edx
  800c81:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c88:	85 db                	test   %ebx,%ebx
  800c8a:	0f 94 c0             	sete   %al
  800c8d:	74 05                	je     800c94 <strtol+0x59>
  800c8f:	83 fb 10             	cmp    $0x10,%ebx
  800c92:	75 18                	jne    800cac <strtol+0x71>
  800c94:	80 3a 30             	cmpb   $0x30,(%edx)
  800c97:	75 13                	jne    800cac <strtol+0x71>
  800c99:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c9d:	8d 76 00             	lea    0x0(%esi),%esi
  800ca0:	75 0a                	jne    800cac <strtol+0x71>
		s += 2, base = 16;
  800ca2:	83 c2 02             	add    $0x2,%edx
  800ca5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800caa:	eb 15                	jmp    800cc1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cac:	84 c0                	test   %al,%al
  800cae:	66 90                	xchg   %ax,%ax
  800cb0:	74 0f                	je     800cc1 <strtol+0x86>
  800cb2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800cb7:	80 3a 30             	cmpb   $0x30,(%edx)
  800cba:	75 05                	jne    800cc1 <strtol+0x86>
		s++, base = 8;
  800cbc:	83 c2 01             	add    $0x1,%edx
  800cbf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cc8:	0f b6 0a             	movzbl (%edx),%ecx
  800ccb:	89 cf                	mov    %ecx,%edi
  800ccd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cd0:	80 fb 09             	cmp    $0x9,%bl
  800cd3:	77 08                	ja     800cdd <strtol+0xa2>
			dig = *s - '0';
  800cd5:	0f be c9             	movsbl %cl,%ecx
  800cd8:	83 e9 30             	sub    $0x30,%ecx
  800cdb:	eb 1e                	jmp    800cfb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800cdd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ce0:	80 fb 19             	cmp    $0x19,%bl
  800ce3:	77 08                	ja     800ced <strtol+0xb2>
			dig = *s - 'a' + 10;
  800ce5:	0f be c9             	movsbl %cl,%ecx
  800ce8:	83 e9 57             	sub    $0x57,%ecx
  800ceb:	eb 0e                	jmp    800cfb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800ced:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800cf0:	80 fb 19             	cmp    $0x19,%bl
  800cf3:	77 15                	ja     800d0a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800cf5:	0f be c9             	movsbl %cl,%ecx
  800cf8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cfb:	39 f1                	cmp    %esi,%ecx
  800cfd:	7d 0b                	jge    800d0a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800cff:	83 c2 01             	add    $0x1,%edx
  800d02:	0f af c6             	imul   %esi,%eax
  800d05:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d08:	eb be                	jmp    800cc8 <strtol+0x8d>
  800d0a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d10:	74 05                	je     800d17 <strtol+0xdc>
		*endptr = (char *) s;
  800d12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d15:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d1b:	74 04                	je     800d21 <strtol+0xe6>
  800d1d:	89 c8                	mov    %ecx,%eax
  800d1f:	f7 d8                	neg    %eax
}
  800d21:	83 c4 04             	add    $0x4,%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
  800d29:	00 00                	add    %al,(%eax)
	...

00800d2c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
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
  800d42:	b8 01 00 00 00       	mov    $0x1,%eax
  800d47:	89 d1                	mov    %edx,%ecx
  800d49:	89 d3                	mov    %edx,%ebx
  800d4b:	89 d7                	mov    %edx,%edi
  800d4d:	89 d6                	mov    %edx,%esi
  800d4f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d51:	8b 1c 24             	mov    (%esp),%ebx
  800d54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d5c:	89 ec                	mov    %ebp,%esp
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	89 1c 24             	mov    %ebx,(%esp)
  800d69:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d6d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	89 c3                	mov    %eax,%ebx
  800d7e:	89 c7                	mov    %eax,%edi
  800d80:	89 c6                	mov    %eax,%esi
  800d82:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d84:	8b 1c 24             	mov    (%esp),%ebx
  800d87:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d8b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d8f:	89 ec                	mov    %ebp,%esp
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 38             	sub    $0x38,%esp
  800d99:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d9c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d9f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da2:	be 00 00 00 00       	mov    $0x0,%esi
  800da7:	b8 12 00 00 00       	mov    $0x12,%eax
  800dac:	8b 7d 14             	mov    0x14(%ebp),%edi
  800daf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	7e 28                	jle    800de6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbe:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800dc9:	00 
  800dca:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800dd1:	00 
  800dd2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd9:	00 
  800dda:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800de1:	e8 fa f3 ff ff       	call   8001e0 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800de6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800de9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800def:	89 ec                	mov    %ebp,%esp
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	89 1c 24             	mov    %ebx,(%esp)
  800dfc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e00:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	b8 11 00 00 00       	mov    $0x11,%eax
  800e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800e1a:	8b 1c 24             	mov    (%esp),%ebx
  800e1d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e21:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e25:	89 ec                	mov    %ebp,%esp
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 0c             	sub    $0xc,%esp
  800e2f:	89 1c 24             	mov    %ebx,(%esp)
  800e32:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e36:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3f:	b8 10 00 00 00       	mov    $0x10,%eax
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	89 cb                	mov    %ecx,%ebx
  800e49:	89 cf                	mov    %ecx,%edi
  800e4b:	89 ce                	mov    %ecx,%esi
  800e4d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800e4f:	8b 1c 24             	mov    (%esp),%ebx
  800e52:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e56:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e5a:	89 ec                	mov    %ebp,%esp
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 38             	sub    $0x38,%esp
  800e64:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e67:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e6a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	89 df                	mov    %ebx,%edi
  800e7f:	89 de                	mov    %ebx,%esi
  800e81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7e 28                	jle    800eaf <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e92:	00 
  800e93:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800e9a:	00 
  800e9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea2:	00 
  800ea3:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800eaa:	e8 31 f3 ff ff       	call   8001e0 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800eaf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eb5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eb8:	89 ec                	mov    %ebp,%esp
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	89 1c 24             	mov    %ebx,(%esp)
  800ec5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ec9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ed7:	89 d1                	mov    %edx,%ecx
  800ed9:	89 d3                	mov    %edx,%ebx
  800edb:	89 d7                	mov    %edx,%edi
  800edd:	89 d6                	mov    %edx,%esi
  800edf:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800ee1:	8b 1c 24             	mov    (%esp),%ebx
  800ee4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ee8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eec:	89 ec                	mov    %ebp,%esp
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 38             	sub    $0x38,%esp
  800ef6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ef9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800efc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f04:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	89 cb                	mov    %ecx,%ebx
  800f0e:	89 cf                	mov    %ecx,%edi
  800f10:	89 ce                	mov    %ecx,%esi
  800f12:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f14:	85 c0                	test   %eax,%eax
  800f16:	7e 28                	jle    800f40 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f18:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f23:	00 
  800f24:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800f2b:	00 
  800f2c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f33:	00 
  800f34:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800f3b:	e8 a0 f2 ff ff       	call   8001e0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f40:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f43:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f46:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f49:	89 ec                	mov    %ebp,%esp
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	83 ec 0c             	sub    $0xc,%esp
  800f53:	89 1c 24             	mov    %ebx,(%esp)
  800f56:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f5a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5e:	be 00 00 00 00       	mov    $0x0,%esi
  800f63:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f68:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f76:	8b 1c 24             	mov    (%esp),%ebx
  800f79:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f7d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f81:	89 ec                	mov    %ebp,%esp
  800f83:	5d                   	pop    %ebp
  800f84:	c3                   	ret    

00800f85 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 38             	sub    $0x38,%esp
  800f8b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f8e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f91:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f99:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa4:	89 df                	mov    %ebx,%edi
  800fa6:	89 de                	mov    %ebx,%esi
  800fa8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800faa:	85 c0                	test   %eax,%eax
  800fac:	7e 28                	jle    800fd6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fae:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fb9:	00 
  800fba:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800fc1:	00 
  800fc2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc9:	00 
  800fca:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800fd1:	e8 0a f2 ff ff       	call   8001e0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fd6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fdc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fdf:	89 ec                	mov    %ebp,%esp
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	83 ec 38             	sub    $0x38,%esp
  800fe9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fef:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff7:	b8 09 00 00 00       	mov    $0x9,%eax
  800ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	89 df                	mov    %ebx,%edi
  801004:	89 de                	mov    %ebx,%esi
  801006:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801008:	85 c0                	test   %eax,%eax
  80100a:	7e 28                	jle    801034 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80100c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801010:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801017:	00 
  801018:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  80101f:	00 
  801020:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801027:	00 
  801028:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  80102f:	e8 ac f1 ff ff       	call   8001e0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801034:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801037:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80103a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80103d:	89 ec                	mov    %ebp,%esp
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 38             	sub    $0x38,%esp
  801047:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80104a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80104d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801050:	bb 00 00 00 00       	mov    $0x0,%ebx
  801055:	b8 08 00 00 00       	mov    $0x8,%eax
  80105a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105d:	8b 55 08             	mov    0x8(%ebp),%edx
  801060:	89 df                	mov    %ebx,%edi
  801062:	89 de                	mov    %ebx,%esi
  801064:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801066:	85 c0                	test   %eax,%eax
  801068:	7e 28                	jle    801092 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80106e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801075:	00 
  801076:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  80107d:	00 
  80107e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801085:	00 
  801086:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  80108d:	e8 4e f1 ff ff       	call   8001e0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801092:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801095:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801098:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80109b:	89 ec                	mov    %ebp,%esp
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 38             	sub    $0x38,%esp
  8010a5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010a8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ab:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b3:	b8 06 00 00 00       	mov    $0x6,%eax
  8010b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010be:	89 df                	mov    %ebx,%edi
  8010c0:	89 de                	mov    %ebx,%esi
  8010c2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	7e 28                	jle    8010f0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010cc:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  8010db:	00 
  8010dc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e3:	00 
  8010e4:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  8010eb:	e8 f0 f0 ff ff       	call   8001e0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010f9:	89 ec                	mov    %ebp,%esp
  8010fb:	5d                   	pop    %ebp
  8010fc:	c3                   	ret    

008010fd <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
  801100:	83 ec 38             	sub    $0x38,%esp
  801103:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801106:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801109:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110c:	b8 05 00 00 00       	mov    $0x5,%eax
  801111:	8b 75 18             	mov    0x18(%ebp),%esi
  801114:	8b 7d 14             	mov    0x14(%ebp),%edi
  801117:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80111a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111d:	8b 55 08             	mov    0x8(%ebp),%edx
  801120:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801122:	85 c0                	test   %eax,%eax
  801124:	7e 28                	jle    80114e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801126:	89 44 24 10          	mov    %eax,0x10(%esp)
  80112a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801131:	00 
  801132:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801139:	00 
  80113a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801141:	00 
  801142:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801149:	e8 92 f0 ff ff       	call   8001e0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80114e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801151:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801154:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801157:	89 ec                	mov    %ebp,%esp
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 38             	sub    $0x38,%esp
  801161:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801164:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801167:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116a:	be 00 00 00 00       	mov    $0x0,%esi
  80116f:	b8 04 00 00 00       	mov    $0x4,%eax
  801174:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117a:	8b 55 08             	mov    0x8(%ebp),%edx
  80117d:	89 f7                	mov    %esi,%edi
  80117f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801181:	85 c0                	test   %eax,%eax
  801183:	7e 28                	jle    8011ad <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801185:	89 44 24 10          	mov    %eax,0x10(%esp)
  801189:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801190:	00 
  801191:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801198:	00 
  801199:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a0:	00 
  8011a1:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  8011a8:	e8 33 f0 ff ff       	call   8001e0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011ad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011b0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011b3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011b6:	89 ec                	mov    %ebp,%esp
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	83 ec 0c             	sub    $0xc,%esp
  8011c0:	89 1c 24             	mov    %ebx,(%esp)
  8011c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011c7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011d5:	89 d1                	mov    %edx,%ecx
  8011d7:	89 d3                	mov    %edx,%ebx
  8011d9:	89 d7                	mov    %edx,%edi
  8011db:	89 d6                	mov    %edx,%esi
  8011dd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011df:	8b 1c 24             	mov    (%esp),%ebx
  8011e2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011e6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ea:	89 ec                	mov    %ebp,%esp
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    

008011ee <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 0c             	sub    $0xc,%esp
  8011f4:	89 1c 24             	mov    %ebx,(%esp)
  8011f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011fb:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801204:	b8 02 00 00 00       	mov    $0x2,%eax
  801209:	89 d1                	mov    %edx,%ecx
  80120b:	89 d3                	mov    %edx,%ebx
  80120d:	89 d7                	mov    %edx,%edi
  80120f:	89 d6                	mov    %edx,%esi
  801211:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801213:	8b 1c 24             	mov    (%esp),%ebx
  801216:	8b 74 24 04          	mov    0x4(%esp),%esi
  80121a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80121e:	89 ec                	mov    %ebp,%esp
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 38             	sub    $0x38,%esp
  801228:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80122b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80122e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801231:	b9 00 00 00 00       	mov    $0x0,%ecx
  801236:	b8 03 00 00 00       	mov    $0x3,%eax
  80123b:	8b 55 08             	mov    0x8(%ebp),%edx
  80123e:	89 cb                	mov    %ecx,%ebx
  801240:	89 cf                	mov    %ecx,%edi
  801242:	89 ce                	mov    %ecx,%esi
  801244:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801246:	85 c0                	test   %eax,%eax
  801248:	7e 28                	jle    801272 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80124e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801255:	00 
  801256:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  80125d:	00 
  80125e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801265:	00 
  801266:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  80126d:	e8 6e ef ff ff       	call   8001e0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801272:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801275:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801278:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80127b:	89 ec                	mov    %ebp,%esp
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    
	...

00801280 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	05 00 00 00 30       	add    $0x30000000,%eax
  80128b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	89 04 24             	mov    %eax,(%esp)
  80129c:	e8 df ff ff ff       	call   801280 <fd2num>
  8012a1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8012a6:	c1 e0 0c             	shl    $0xc,%eax
}
  8012a9:	c9                   	leave  
  8012aa:	c3                   	ret    

008012ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012ab:	55                   	push   %ebp
  8012ac:	89 e5                	mov    %esp,%ebp
  8012ae:	57                   	push   %edi
  8012af:	56                   	push   %esi
  8012b0:	53                   	push   %ebx
  8012b1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8012b4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8012b9:	a8 01                	test   $0x1,%al
  8012bb:	74 36                	je     8012f3 <fd_alloc+0x48>
  8012bd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8012c2:	a8 01                	test   $0x1,%al
  8012c4:	74 2d                	je     8012f3 <fd_alloc+0x48>
  8012c6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8012cb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8012d0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8012d5:	89 c3                	mov    %eax,%ebx
  8012d7:	89 c2                	mov    %eax,%edx
  8012d9:	c1 ea 16             	shr    $0x16,%edx
  8012dc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8012df:	f6 c2 01             	test   $0x1,%dl
  8012e2:	74 14                	je     8012f8 <fd_alloc+0x4d>
  8012e4:	89 c2                	mov    %eax,%edx
  8012e6:	c1 ea 0c             	shr    $0xc,%edx
  8012e9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8012ec:	f6 c2 01             	test   $0x1,%dl
  8012ef:	75 10                	jne    801301 <fd_alloc+0x56>
  8012f1:	eb 05                	jmp    8012f8 <fd_alloc+0x4d>
  8012f3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8012f8:	89 1f                	mov    %ebx,(%edi)
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8012ff:	eb 17                	jmp    801318 <fd_alloc+0x6d>
  801301:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801306:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80130b:	75 c8                	jne    8012d5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80130d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801313:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801318:	5b                   	pop    %ebx
  801319:	5e                   	pop    %esi
  80131a:	5f                   	pop    %edi
  80131b:	5d                   	pop    %ebp
  80131c:	c3                   	ret    

0080131d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	83 f8 1f             	cmp    $0x1f,%eax
  801326:	77 36                	ja     80135e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801328:	05 00 00 0d 00       	add    $0xd0000,%eax
  80132d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801330:	89 c2                	mov    %eax,%edx
  801332:	c1 ea 16             	shr    $0x16,%edx
  801335:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80133c:	f6 c2 01             	test   $0x1,%dl
  80133f:	74 1d                	je     80135e <fd_lookup+0x41>
  801341:	89 c2                	mov    %eax,%edx
  801343:	c1 ea 0c             	shr    $0xc,%edx
  801346:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80134d:	f6 c2 01             	test   $0x1,%dl
  801350:	74 0c                	je     80135e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801352:	8b 55 0c             	mov    0xc(%ebp),%edx
  801355:	89 02                	mov    %eax,(%edx)
  801357:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80135c:	eb 05                	jmp    801363 <fd_lookup+0x46>
  80135e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    

00801365 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80136b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80136e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	89 04 24             	mov    %eax,(%esp)
  801378:	e8 a0 ff ff ff       	call   80131d <fd_lookup>
  80137d:	85 c0                	test   %eax,%eax
  80137f:	78 0e                	js     80138f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801384:	8b 55 0c             	mov    0xc(%ebp),%edx
  801387:	89 50 04             	mov    %edx,0x4(%eax)
  80138a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	56                   	push   %esi
  801395:	53                   	push   %ebx
  801396:	83 ec 10             	sub    $0x10,%esp
  801399:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80139c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80139f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8013a4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013a9:	be a8 2e 80 00       	mov    $0x802ea8,%esi
		if (devtab[i]->dev_id == dev_id) {
  8013ae:	39 08                	cmp    %ecx,(%eax)
  8013b0:	75 10                	jne    8013c2 <dev_lookup+0x31>
  8013b2:	eb 04                	jmp    8013b8 <dev_lookup+0x27>
  8013b4:	39 08                	cmp    %ecx,(%eax)
  8013b6:	75 0a                	jne    8013c2 <dev_lookup+0x31>
			*dev = devtab[i];
  8013b8:	89 03                	mov    %eax,(%ebx)
  8013ba:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8013bf:	90                   	nop
  8013c0:	eb 31                	jmp    8013f3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013c2:	83 c2 01             	add    $0x1,%edx
  8013c5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	75 e8                	jne    8013b4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8013cc:	a1 80 80 80 00       	mov    0x808080,%eax
  8013d1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013d4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013dc:	c7 04 24 2c 2e 80 00 	movl   $0x802e2c,(%esp)
  8013e3:	e8 bd ee ff ff       	call   8002a5 <cprintf>
	*dev = 0;
  8013e8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	5b                   	pop    %ebx
  8013f7:	5e                   	pop    %esi
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    

008013fa <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	53                   	push   %ebx
  8013fe:	83 ec 24             	sub    $0x24,%esp
  801401:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801404:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	89 04 24             	mov    %eax,(%esp)
  801411:	e8 07 ff ff ff       	call   80131d <fd_lookup>
  801416:	85 c0                	test   %eax,%eax
  801418:	78 53                	js     80146d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801424:	8b 00                	mov    (%eax),%eax
  801426:	89 04 24             	mov    %eax,(%esp)
  801429:	e8 63 ff ff ff       	call   801391 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 3b                	js     80146d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801432:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80143e:	74 2d                	je     80146d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801440:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801443:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80144a:	00 00 00 
	stat->st_isdir = 0;
  80144d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801454:	00 00 00 
	stat->st_dev = dev;
  801457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801460:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801467:	89 14 24             	mov    %edx,(%esp)
  80146a:	ff 50 14             	call   *0x14(%eax)
}
  80146d:	83 c4 24             	add    $0x24,%esp
  801470:	5b                   	pop    %ebx
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    

00801473 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	53                   	push   %ebx
  801477:	83 ec 24             	sub    $0x24,%esp
  80147a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801480:	89 44 24 04          	mov    %eax,0x4(%esp)
  801484:	89 1c 24             	mov    %ebx,(%esp)
  801487:	e8 91 fe ff ff       	call   80131d <fd_lookup>
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 5f                	js     8014ef <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801490:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801493:	89 44 24 04          	mov    %eax,0x4(%esp)
  801497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	89 04 24             	mov    %eax,(%esp)
  80149f:	e8 ed fe ff ff       	call   801391 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 47                	js     8014ef <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ab:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014af:	75 23                	jne    8014d4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8014b1:	a1 80 80 80 00       	mov    0x808080,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014b6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c1:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  8014c8:	e8 d8 ed ff ff       	call   8002a5 <cprintf>
  8014cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8014d2:	eb 1b                	jmp    8014ef <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8014d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d7:	8b 48 18             	mov    0x18(%eax),%ecx
  8014da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014df:	85 c9                	test   %ecx,%ecx
  8014e1:	74 0c                	je     8014ef <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ea:	89 14 24             	mov    %edx,(%esp)
  8014ed:	ff d1                	call   *%ecx
}
  8014ef:	83 c4 24             	add    $0x24,%esp
  8014f2:	5b                   	pop    %ebx
  8014f3:	5d                   	pop    %ebp
  8014f4:	c3                   	ret    

008014f5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	53                   	push   %ebx
  8014f9:	83 ec 24             	sub    $0x24,%esp
  8014fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801502:	89 44 24 04          	mov    %eax,0x4(%esp)
  801506:	89 1c 24             	mov    %ebx,(%esp)
  801509:	e8 0f fe ff ff       	call   80131d <fd_lookup>
  80150e:	85 c0                	test   %eax,%eax
  801510:	78 66                	js     801578 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801512:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801515:	89 44 24 04          	mov    %eax,0x4(%esp)
  801519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	89 04 24             	mov    %eax,(%esp)
  801521:	e8 6b fe ff ff       	call   801391 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801526:	85 c0                	test   %eax,%eax
  801528:	78 4e                	js     801578 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80152a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80152d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801531:	75 23                	jne    801556 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801533:	a1 80 80 80 00       	mov    0x808080,%eax
  801538:	8b 40 4c             	mov    0x4c(%eax),%eax
  80153b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80153f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801543:	c7 04 24 6d 2e 80 00 	movl   $0x802e6d,(%esp)
  80154a:	e8 56 ed ff ff       	call   8002a5 <cprintf>
  80154f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801554:	eb 22                	jmp    801578 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	8b 48 0c             	mov    0xc(%eax),%ecx
  80155c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801561:	85 c9                	test   %ecx,%ecx
  801563:	74 13                	je     801578 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801565:	8b 45 10             	mov    0x10(%ebp),%eax
  801568:	89 44 24 08          	mov    %eax,0x8(%esp)
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801573:	89 14 24             	mov    %edx,(%esp)
  801576:	ff d1                	call   *%ecx
}
  801578:	83 c4 24             	add    $0x24,%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5d                   	pop    %ebp
  80157d:	c3                   	ret    

0080157e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	53                   	push   %ebx
  801582:	83 ec 24             	sub    $0x24,%esp
  801585:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801588:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158f:	89 1c 24             	mov    %ebx,(%esp)
  801592:	e8 86 fd ff ff       	call   80131d <fd_lookup>
  801597:	85 c0                	test   %eax,%eax
  801599:	78 6b                	js     801606 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a5:	8b 00                	mov    (%eax),%eax
  8015a7:	89 04 24             	mov    %eax,(%esp)
  8015aa:	e8 e2 fd ff ff       	call   801391 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	78 53                	js     801606 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b6:	8b 42 08             	mov    0x8(%edx),%eax
  8015b9:	83 e0 03             	and    $0x3,%eax
  8015bc:	83 f8 01             	cmp    $0x1,%eax
  8015bf:	75 23                	jne    8015e4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8015c1:	a1 80 80 80 00       	mov    0x808080,%eax
  8015c6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d1:	c7 04 24 8a 2e 80 00 	movl   $0x802e8a,(%esp)
  8015d8:	e8 c8 ec ff ff       	call   8002a5 <cprintf>
  8015dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8015e2:	eb 22                	jmp    801606 <read+0x88>
	}
	if (!dev->dev_read)
  8015e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e7:	8b 48 08             	mov    0x8(%eax),%ecx
  8015ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ef:	85 c9                	test   %ecx,%ecx
  8015f1:	74 13                	je     801606 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801601:	89 14 24             	mov    %edx,(%esp)
  801604:	ff d1                	call   *%ecx
}
  801606:	83 c4 24             	add    $0x24,%esp
  801609:	5b                   	pop    %ebx
  80160a:	5d                   	pop    %ebp
  80160b:	c3                   	ret    

0080160c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	57                   	push   %edi
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
  801612:	83 ec 1c             	sub    $0x1c,%esp
  801615:	8b 7d 08             	mov    0x8(%ebp),%edi
  801618:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80161b:	ba 00 00 00 00       	mov    $0x0,%edx
  801620:	bb 00 00 00 00       	mov    $0x0,%ebx
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
  80162a:	85 f6                	test   %esi,%esi
  80162c:	74 29                	je     801657 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80162e:	89 f0                	mov    %esi,%eax
  801630:	29 d0                	sub    %edx,%eax
  801632:	89 44 24 08          	mov    %eax,0x8(%esp)
  801636:	03 55 0c             	add    0xc(%ebp),%edx
  801639:	89 54 24 04          	mov    %edx,0x4(%esp)
  80163d:	89 3c 24             	mov    %edi,(%esp)
  801640:	e8 39 ff ff ff       	call   80157e <read>
		if (m < 0)
  801645:	85 c0                	test   %eax,%eax
  801647:	78 0e                	js     801657 <readn+0x4b>
			return m;
		if (m == 0)
  801649:	85 c0                	test   %eax,%eax
  80164b:	74 08                	je     801655 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80164d:	01 c3                	add    %eax,%ebx
  80164f:	89 da                	mov    %ebx,%edx
  801651:	39 f3                	cmp    %esi,%ebx
  801653:	72 d9                	jb     80162e <readn+0x22>
  801655:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801657:	83 c4 1c             	add    $0x1c,%esp
  80165a:	5b                   	pop    %ebx
  80165b:	5e                   	pop    %esi
  80165c:	5f                   	pop    %edi
  80165d:	5d                   	pop    %ebp
  80165e:	c3                   	ret    

0080165f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 20             	sub    $0x20,%esp
  801667:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80166a:	89 34 24             	mov    %esi,(%esp)
  80166d:	e8 0e fc ff ff       	call   801280 <fd2num>
  801672:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801675:	89 54 24 04          	mov    %edx,0x4(%esp)
  801679:	89 04 24             	mov    %eax,(%esp)
  80167c:	e8 9c fc ff ff       	call   80131d <fd_lookup>
  801681:	89 c3                	mov    %eax,%ebx
  801683:	85 c0                	test   %eax,%eax
  801685:	78 05                	js     80168c <fd_close+0x2d>
  801687:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80168a:	74 0c                	je     801698 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80168c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801690:	19 c0                	sbb    %eax,%eax
  801692:	f7 d0                	not    %eax
  801694:	21 c3                	and    %eax,%ebx
  801696:	eb 3d                	jmp    8016d5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801698:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169f:	8b 06                	mov    (%esi),%eax
  8016a1:	89 04 24             	mov    %eax,(%esp)
  8016a4:	e8 e8 fc ff ff       	call   801391 <dev_lookup>
  8016a9:	89 c3                	mov    %eax,%ebx
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 16                	js     8016c5 <fd_close+0x66>
		if (dev->dev_close)
  8016af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b2:	8b 40 10             	mov    0x10(%eax),%eax
  8016b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	74 07                	je     8016c5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8016be:	89 34 24             	mov    %esi,(%esp)
  8016c1:	ff d0                	call   *%eax
  8016c3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d0:	e8 ca f9 ff ff       	call   80109f <sys_page_unmap>
	return r;
}
  8016d5:	89 d8                	mov    %ebx,%eax
  8016d7:	83 c4 20             	add    $0x20,%esp
  8016da:	5b                   	pop    %ebx
  8016db:	5e                   	pop    %esi
  8016dc:	5d                   	pop    %ebp
  8016dd:	c3                   	ret    

008016de <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	89 04 24             	mov    %eax,(%esp)
  8016f1:	e8 27 fc ff ff       	call   80131d <fd_lookup>
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 13                	js     80170d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8016fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801701:	00 
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	89 04 24             	mov    %eax,(%esp)
  801708:	e8 52 ff ff ff       	call   80165f <fd_close>
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 18             	sub    $0x18,%esp
  801715:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801718:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80171b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801722:	00 
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	89 04 24             	mov    %eax,(%esp)
  801729:	e8 55 03 00 00       	call   801a83 <open>
  80172e:	89 c3                	mov    %eax,%ebx
  801730:	85 c0                	test   %eax,%eax
  801732:	78 1b                	js     80174f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801734:	8b 45 0c             	mov    0xc(%ebp),%eax
  801737:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173b:	89 1c 24             	mov    %ebx,(%esp)
  80173e:	e8 b7 fc ff ff       	call   8013fa <fstat>
  801743:	89 c6                	mov    %eax,%esi
	close(fd);
  801745:	89 1c 24             	mov    %ebx,(%esp)
  801748:	e8 91 ff ff ff       	call   8016de <close>
  80174d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80174f:	89 d8                	mov    %ebx,%eax
  801751:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801754:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801757:	89 ec                	mov    %ebp,%esp
  801759:	5d                   	pop    %ebp
  80175a:	c3                   	ret    

0080175b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	53                   	push   %ebx
  80175f:	83 ec 14             	sub    $0x14,%esp
  801762:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801767:	89 1c 24             	mov    %ebx,(%esp)
  80176a:	e8 6f ff ff ff       	call   8016de <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80176f:	83 c3 01             	add    $0x1,%ebx
  801772:	83 fb 20             	cmp    $0x20,%ebx
  801775:	75 f0                	jne    801767 <close_all+0xc>
		close(i);
}
  801777:	83 c4 14             	add    $0x14,%esp
  80177a:	5b                   	pop    %ebx
  80177b:	5d                   	pop    %ebp
  80177c:	c3                   	ret    

0080177d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 58             	sub    $0x58,%esp
  801783:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801786:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801789:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80178c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80178f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801792:	89 44 24 04          	mov    %eax,0x4(%esp)
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	89 04 24             	mov    %eax,(%esp)
  80179c:	e8 7c fb ff ff       	call   80131d <fd_lookup>
  8017a1:	89 c3                	mov    %eax,%ebx
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	0f 88 e0 00 00 00    	js     80188b <dup+0x10e>
		return r;
	close(newfdnum);
  8017ab:	89 3c 24             	mov    %edi,(%esp)
  8017ae:	e8 2b ff ff ff       	call   8016de <close>

	newfd = INDEX2FD(newfdnum);
  8017b3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8017b9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8017bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017bf:	89 04 24             	mov    %eax,(%esp)
  8017c2:	e8 c9 fa ff ff       	call   801290 <fd2data>
  8017c7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017c9:	89 34 24             	mov    %esi,(%esp)
  8017cc:	e8 bf fa ff ff       	call   801290 <fd2data>
  8017d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8017d4:	89 da                	mov    %ebx,%edx
  8017d6:	89 d8                	mov    %ebx,%eax
  8017d8:	c1 e8 16             	shr    $0x16,%eax
  8017db:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017e2:	a8 01                	test   $0x1,%al
  8017e4:	74 43                	je     801829 <dup+0xac>
  8017e6:	c1 ea 0c             	shr    $0xc,%edx
  8017e9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017f0:	a8 01                	test   $0x1,%al
  8017f2:	74 35                	je     801829 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8017f4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017fb:	25 07 0e 00 00       	and    $0xe07,%eax
  801800:	89 44 24 10          	mov    %eax,0x10(%esp)
  801804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801807:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80180b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801812:	00 
  801813:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801817:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80181e:	e8 da f8 ff ff       	call   8010fd <sys_page_map>
  801823:	89 c3                	mov    %eax,%ebx
  801825:	85 c0                	test   %eax,%eax
  801827:	78 3f                	js     801868 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80182c:	89 c2                	mov    %eax,%edx
  80182e:	c1 ea 0c             	shr    $0xc,%edx
  801831:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801838:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80183e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801842:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801846:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80184d:	00 
  80184e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801852:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801859:	e8 9f f8 ff ff       	call   8010fd <sys_page_map>
  80185e:	89 c3                	mov    %eax,%ebx
  801860:	85 c0                	test   %eax,%eax
  801862:	78 04                	js     801868 <dup+0xeb>
  801864:	89 fb                	mov    %edi,%ebx
  801866:	eb 23                	jmp    80188b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801868:	89 74 24 04          	mov    %esi,0x4(%esp)
  80186c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801873:	e8 27 f8 ff ff       	call   80109f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801878:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80187b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801886:	e8 14 f8 ff ff       	call   80109f <sys_page_unmap>
	return r;
}
  80188b:	89 d8                	mov    %ebx,%eax
  80188d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801890:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801893:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801896:	89 ec                	mov    %ebp,%esp
  801898:	5d                   	pop    %ebp
  801899:	c3                   	ret    
	...

0080189c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 14             	sub    $0x14,%esp
  8018a3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018a5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8018ab:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018b2:	00 
  8018b3:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  8018ba:	00 
  8018bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bf:	89 14 24             	mov    %edx,(%esp)
  8018c2:	e8 f9 0d 00 00       	call   8026c0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018ce:	00 
  8018cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018da:	e8 47 0e 00 00       	call   802726 <ipc_recv>
}
  8018df:	83 c4 14             	add    $0x14,%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5d                   	pop    %ebp
  8018e4:	c3                   	ret    

008018e5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  8018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801903:	b8 02 00 00 00       	mov    $0x2,%eax
  801908:	e8 8f ff ff ff       	call   80189c <fsipc>
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8b 40 0c             	mov    0xc(%eax),%eax
  80191b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801920:	ba 00 00 00 00       	mov    $0x0,%edx
  801925:	b8 06 00 00 00       	mov    $0x6,%eax
  80192a:	e8 6d ff ff ff       	call   80189c <fsipc>
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	b8 08 00 00 00       	mov    $0x8,%eax
  801941:	e8 56 ff ff ff       	call   80189c <fsipc>
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	53                   	push   %ebx
  80194c:	83 ec 14             	sub    $0x14,%esp
  80194f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	8b 40 0c             	mov    0xc(%eax),%eax
  801958:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80195d:	ba 00 00 00 00       	mov    $0x0,%edx
  801962:	b8 05 00 00 00       	mov    $0x5,%eax
  801967:	e8 30 ff ff ff       	call   80189c <fsipc>
  80196c:	85 c0                	test   %eax,%eax
  80196e:	78 2b                	js     80199b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801970:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801977:	00 
  801978:	89 1c 24             	mov    %ebx,(%esp)
  80197b:	e8 ea ef ff ff       	call   80096a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801980:	a1 80 30 80 00       	mov    0x803080,%eax
  801985:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80198b:	a1 84 30 80 00       	mov    0x803084,%eax
  801990:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801996:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80199b:	83 c4 14             	add    $0x14,%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    

008019a1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 18             	sub    $0x18,%esp
  8019a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019aa:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019af:	76 05                	jbe    8019b6 <devfile_write+0x15>
  8019b1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019bc:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  8019c2:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  8019c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d2:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8019d9:	e8 47 f1 ff ff       	call   800b25 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e3:	b8 04 00 00 00       	mov    $0x4,%eax
  8019e8:	e8 af fe ff ff       	call   80189c <fsipc>
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	53                   	push   %ebx
  8019f3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019fc:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801a01:	8b 45 10             	mov    0x10(%ebp),%eax
  801a04:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801a09:	ba 00 30 80 00       	mov    $0x803000,%edx
  801a0e:	b8 03 00 00 00       	mov    $0x3,%eax
  801a13:	e8 84 fe ff ff       	call   80189c <fsipc>
  801a18:	89 c3                	mov    %eax,%ebx
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 17                	js     801a35 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801a1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a22:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a29:	00 
  801a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2d:	89 04 24             	mov    %eax,(%esp)
  801a30:	e8 f0 f0 ff ff       	call   800b25 <memmove>
	return r;
}
  801a35:	89 d8                	mov    %ebx,%eax
  801a37:	83 c4 14             	add    $0x14,%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    

00801a3d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	53                   	push   %ebx
  801a41:	83 ec 14             	sub    $0x14,%esp
  801a44:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a47:	89 1c 24             	mov    %ebx,(%esp)
  801a4a:	e8 d1 ee ff ff       	call   800920 <strlen>
  801a4f:	89 c2                	mov    %eax,%edx
  801a51:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a56:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a5c:	7f 1f                	jg     801a7d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a62:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a69:	e8 fc ee ff ff       	call   80096a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801a6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a73:	b8 07 00 00 00       	mov    $0x7,%eax
  801a78:	e8 1f fe ff ff       	call   80189c <fsipc>
}
  801a7d:	83 c4 14             	add    $0x14,%esp
  801a80:	5b                   	pop    %ebx
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 28             	sub    $0x28,%esp
  801a89:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a8c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a8f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801a92:	89 34 24             	mov    %esi,(%esp)
  801a95:	e8 86 ee ff ff       	call   800920 <strlen>
  801a9a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a9f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aa4:	7f 5e                	jg     801b04 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801aa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa9:	89 04 24             	mov    %eax,(%esp)
  801aac:	e8 fa f7 ff ff       	call   8012ab <fd_alloc>
  801ab1:	89 c3                	mov    %eax,%ebx
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 4d                	js     801b04 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801ab7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801abb:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801ac2:	e8 a3 ee ff ff       	call   80096a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aca:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801acf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad7:	e8 c0 fd ff ff       	call   80189c <fsipc>
  801adc:	89 c3                	mov    %eax,%ebx
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	79 15                	jns    801af7 <open+0x74>
	{
		fd_close(fd,0);
  801ae2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ae9:	00 
  801aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aed:	89 04 24             	mov    %eax,(%esp)
  801af0:	e8 6a fb ff ff       	call   80165f <fd_close>
		return r; 
  801af5:	eb 0d                	jmp    801b04 <open+0x81>
	}
	return fd2num(fd);
  801af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afa:	89 04 24             	mov    %eax,(%esp)
  801afd:	e8 7e f7 ff ff       	call   801280 <fd2num>
  801b02:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b09:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b0c:	89 ec                	mov    %ebp,%esp
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	53                   	push   %ebx
  801b14:	83 ec 14             	sub    $0x14,%esp
  801b17:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b19:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b1d:	7e 34                	jle    801b53 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b1f:	8b 40 04             	mov    0x4(%eax),%eax
  801b22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b26:	8d 43 10             	lea    0x10(%ebx),%eax
  801b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2d:	8b 03                	mov    (%ebx),%eax
  801b2f:	89 04 24             	mov    %eax,(%esp)
  801b32:	e8 be f9 ff ff       	call   8014f5 <write>
		if (result > 0)
  801b37:	85 c0                	test   %eax,%eax
  801b39:	7e 03                	jle    801b3e <writebuf+0x2e>
			b->result += result;
  801b3b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b3e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b41:	74 10                	je     801b53 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801b43:	85 c0                	test   %eax,%eax
  801b45:	0f 9f c2             	setg   %dl
  801b48:	0f b6 d2             	movzbl %dl,%edx
  801b4b:	83 ea 01             	sub    $0x1,%edx
  801b4e:	21 d0                	and    %edx,%eax
  801b50:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b53:	83 c4 14             	add    $0x14,%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    

00801b59 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b6b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b72:	00 00 00 
	b.result = 0;
  801b75:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b7c:	00 00 00 
	b.error = 1;
  801b7f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801b86:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b89:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b93:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b97:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba1:	c7 04 24 16 1c 80 00 	movl   $0x801c16,(%esp)
  801ba8:	e8 b0 e8 ff ff       	call   80045d <vprintfmt>
	if (b.idx > 0)
  801bad:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801bb4:	7e 0b                	jle    801bc1 <vfprintf+0x68>
		writebuf(&b);
  801bb6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bbc:	e8 4f ff ff ff       	call   801b10 <writebuf>

	return (b.result ? b.result : b.error);
  801bc1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	75 06                	jne    801bd1 <vfprintf+0x78>
  801bcb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801bd9:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801bdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bee:	e8 66 ff ff ff       	call   801b59 <vfprintf>
	va_end(ap);

	return cnt;
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801bfb:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801bfe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	89 04 24             	mov    %eax,(%esp)
  801c0f:	e8 45 ff ff ff       	call   801b59 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801c1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c20:	8b 43 04             	mov    0x4(%ebx),%eax
  801c23:	8b 55 08             	mov    0x8(%ebp),%edx
  801c26:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c2a:	83 c0 01             	add    $0x1,%eax
  801c2d:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801c30:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c35:	75 0e                	jne    801c45 <putch+0x2f>
		writebuf(b);
  801c37:	89 d8                	mov    %ebx,%eax
  801c39:	e8 d2 fe ff ff       	call   801b10 <writebuf>
		b->idx = 0;
  801c3e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c45:	83 c4 04             	add    $0x4,%esp
  801c48:	5b                   	pop    %ebx
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    
  801c4b:	00 00                	add    %al,(%eax)
  801c4d:	00 00                	add    %al,(%eax)
	...

00801c50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c56:	c7 44 24 04 bc 2e 80 	movl   $0x802ebc,0x4(%esp)
  801c5d:	00 
  801c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c61:	89 04 24             	mov    %eax,(%esp)
  801c64:	e8 01 ed ff ff       	call   80096a <strcpy>
	return 0;
}
  801c69:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7c:	89 04 24             	mov    %eax,(%esp)
  801c7f:	e8 9e 02 00 00       	call   801f22 <nsipc_close>
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c8c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c93:	00 
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca8:	89 04 24             	mov    %eax,(%esp)
  801cab:	e8 ae 02 00 00       	call   801f5e <nsipc_send>
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cb8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cbf:	00 
  801cc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd4:	89 04 24             	mov    %eax,(%esp)
  801cd7:	e8 f5 02 00 00       	call   801fd1 <nsipc_recv>
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	56                   	push   %esi
  801ce2:	53                   	push   %ebx
  801ce3:	83 ec 20             	sub    $0x20,%esp
  801ce6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ce8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ceb:	89 04 24             	mov    %eax,(%esp)
  801cee:	e8 b8 f5 ff ff       	call   8012ab <fd_alloc>
  801cf3:	89 c3                	mov    %eax,%ebx
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	78 21                	js     801d1a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801cf9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d00:	00 
  801d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d0f:	e8 47 f4 ff ff       	call   80115b <sys_page_alloc>
  801d14:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d16:	85 c0                	test   %eax,%eax
  801d18:	79 0a                	jns    801d24 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801d1a:	89 34 24             	mov    %esi,(%esp)
  801d1d:	e8 00 02 00 00       	call   801f22 <nsipc_close>
		return r;
  801d22:	eb 28                	jmp    801d4c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d24:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d32:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	89 04 24             	mov    %eax,(%esp)
  801d45:	e8 36 f5 ff ff       	call   801280 <fd2num>
  801d4a:	89 c3                	mov    %eax,%ebx
}
  801d4c:	89 d8                	mov    %ebx,%eax
  801d4e:	83 c4 20             	add    $0x20,%esp
  801d51:	5b                   	pop    %ebx
  801d52:	5e                   	pop    %esi
  801d53:	5d                   	pop    %ebp
  801d54:	c3                   	ret    

00801d55 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	89 04 24             	mov    %eax,(%esp)
  801d6f:	e8 62 01 00 00       	call   801ed6 <nsipc_socket>
  801d74:	85 c0                	test   %eax,%eax
  801d76:	78 05                	js     801d7d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801d78:	e8 61 ff ff ff       	call   801cde <alloc_sockfd>
}
  801d7d:	c9                   	leave  
  801d7e:	66 90                	xchg   %ax,%ax
  801d80:	c3                   	ret    

00801d81 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d87:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d8e:	89 04 24             	mov    %eax,(%esp)
  801d91:	e8 87 f5 ff ff       	call   80131d <fd_lookup>
  801d96:	85 c0                	test   %eax,%eax
  801d98:	78 15                	js     801daf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9d:	8b 0a                	mov    (%edx),%ecx
  801d9f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801da4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801daa:	75 03                	jne    801daf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801dac:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	e8 c2 ff ff ff       	call   801d81 <fd2sockid>
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 0f                	js     801dd2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dca:	89 04 24             	mov    %eax,(%esp)
  801dcd:	e8 2e 01 00 00       	call   801f00 <nsipc_listen>
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	e8 9f ff ff ff       	call   801d81 <fd2sockid>
  801de2:	85 c0                	test   %eax,%eax
  801de4:	78 16                	js     801dfc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801de6:	8b 55 10             	mov    0x10(%ebp),%edx
  801de9:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df0:	89 54 24 04          	mov    %edx,0x4(%esp)
  801df4:	89 04 24             	mov    %eax,(%esp)
  801df7:	e8 55 02 00 00       	call   802051 <nsipc_connect>
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	e8 75 ff ff ff       	call   801d81 <fd2sockid>
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	78 0f                	js     801e1f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e13:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e17:	89 04 24             	mov    %eax,(%esp)
  801e1a:	e8 1d 01 00 00       	call   801f3c <nsipc_shutdown>
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	e8 52 ff ff ff       	call   801d81 <fd2sockid>
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 16                	js     801e49 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801e33:	8b 55 10             	mov    0x10(%ebp),%edx
  801e36:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e41:	89 04 24             	mov    %eax,(%esp)
  801e44:	e8 47 02 00 00       	call   802090 <nsipc_bind>
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	e8 28 ff ff ff       	call   801d81 <fd2sockid>
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	78 1f                	js     801e7c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e5d:	8b 55 10             	mov    0x10(%ebp),%edx
  801e60:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e67:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e6b:	89 04 24             	mov    %eax,(%esp)
  801e6e:	e8 5c 02 00 00       	call   8020cf <nsipc_accept>
  801e73:	85 c0                	test   %eax,%eax
  801e75:	78 05                	js     801e7c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801e77:	e8 62 fe ff ff       	call   801cde <alloc_sockfd>
}
  801e7c:	c9                   	leave  
  801e7d:	8d 76 00             	lea    0x0(%esi),%esi
  801e80:	c3                   	ret    
	...

00801e90 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e96:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801e9c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ea3:	00 
  801ea4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801eab:	00 
  801eac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb0:	89 14 24             	mov    %edx,(%esp)
  801eb3:	e8 08 08 00 00       	call   8026c0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801eb8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ebf:	00 
  801ec0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ec7:	00 
  801ec8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ecf:	e8 52 08 00 00       	call   802726 <ipc_recv>
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee7:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801eec:	8b 45 10             	mov    0x10(%ebp),%eax
  801eef:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801ef4:	b8 09 00 00 00       	mov    $0x9,%eax
  801ef9:	e8 92 ff ff ff       	call   801e90 <nsipc>
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801f16:	b8 06 00 00 00       	mov    $0x6,%eax
  801f1b:	e8 70 ff ff ff       	call   801e90 <nsipc>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801f30:	b8 04 00 00 00       	mov    $0x4,%eax
  801f35:	e8 56 ff ff ff       	call   801e90 <nsipc>
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801f52:	b8 03 00 00 00       	mov    $0x3,%eax
  801f57:	e8 34 ff ff ff       	call   801e90 <nsipc>
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	53                   	push   %ebx
  801f62:	83 ec 14             	sub    $0x14,%esp
  801f65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801f70:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f76:	7e 24                	jle    801f9c <nsipc_send+0x3e>
  801f78:	c7 44 24 0c c8 2e 80 	movl   $0x802ec8,0xc(%esp)
  801f7f:	00 
  801f80:	c7 44 24 08 d4 2e 80 	movl   $0x802ed4,0x8(%esp)
  801f87:	00 
  801f88:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801f8f:	00 
  801f90:	c7 04 24 e9 2e 80 00 	movl   $0x802ee9,(%esp)
  801f97:	e8 44 e2 ff ff       	call   8001e0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f9c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801fae:	e8 72 eb ff ff       	call   800b25 <memmove>
	nsipcbuf.send.req_size = size;
  801fb3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801fc1:	b8 08 00 00 00       	mov    $0x8,%eax
  801fc6:	e8 c5 fe ff ff       	call   801e90 <nsipc>
}
  801fcb:	83 c4 14             	add    $0x14,%esp
  801fce:	5b                   	pop    %ebx
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    

00801fd1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	56                   	push   %esi
  801fd5:	53                   	push   %ebx
  801fd6:	83 ec 10             	sub    $0x10,%esp
  801fd9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801fe4:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801fea:	8b 45 14             	mov    0x14(%ebp),%eax
  801fed:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ff2:	b8 07 00 00 00       	mov    $0x7,%eax
  801ff7:	e8 94 fe ff ff       	call   801e90 <nsipc>
  801ffc:	89 c3                	mov    %eax,%ebx
  801ffe:	85 c0                	test   %eax,%eax
  802000:	78 46                	js     802048 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802002:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802007:	7f 04                	jg     80200d <nsipc_recv+0x3c>
  802009:	39 c6                	cmp    %eax,%esi
  80200b:	7d 24                	jge    802031 <nsipc_recv+0x60>
  80200d:	c7 44 24 0c f5 2e 80 	movl   $0x802ef5,0xc(%esp)
  802014:	00 
  802015:	c7 44 24 08 d4 2e 80 	movl   $0x802ed4,0x8(%esp)
  80201c:	00 
  80201d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802024:	00 
  802025:	c7 04 24 e9 2e 80 00 	movl   $0x802ee9,(%esp)
  80202c:	e8 af e1 ff ff       	call   8001e0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802031:	89 44 24 08          	mov    %eax,0x8(%esp)
  802035:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80203c:	00 
  80203d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802040:	89 04 24             	mov    %eax,(%esp)
  802043:	e8 dd ea ff ff       	call   800b25 <memmove>
	}

	return r;
}
  802048:	89 d8                	mov    %ebx,%eax
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	5b                   	pop    %ebx
  80204e:	5e                   	pop    %esi
  80204f:	5d                   	pop    %ebp
  802050:	c3                   	ret    

00802051 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	53                   	push   %ebx
  802055:	83 ec 14             	sub    $0x14,%esp
  802058:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802063:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80206e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  802075:	e8 ab ea ff ff       	call   800b25 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80207a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  802080:	b8 05 00 00 00       	mov    $0x5,%eax
  802085:	e8 06 fe ff ff       	call   801e90 <nsipc>
}
  80208a:	83 c4 14             	add    $0x14,%esp
  80208d:	5b                   	pop    %ebx
  80208e:	5d                   	pop    %ebp
  80208f:	c3                   	ret    

00802090 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	53                   	push   %ebx
  802094:	83 ec 14             	sub    $0x14,%esp
  802097:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ad:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8020b4:	e8 6c ea ff ff       	call   800b25 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020b9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  8020bf:	b8 02 00 00 00       	mov    $0x2,%eax
  8020c4:	e8 c7 fd ff ff       	call   801e90 <nsipc>
}
  8020c9:	83 c4 14             	add    $0x14,%esp
  8020cc:	5b                   	pop    %ebx
  8020cd:	5d                   	pop    %ebp
  8020ce:	c3                   	ret    

008020cf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 18             	sub    $0x18,%esp
  8020d5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020d8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e8:	e8 a3 fd ff ff       	call   801e90 <nsipc>
  8020ed:	89 c3                	mov    %eax,%ebx
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 25                	js     802118 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020f3:	be 10 50 80 00       	mov    $0x805010,%esi
  8020f8:	8b 06                	mov    (%esi),%eax
  8020fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020fe:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802105:	00 
  802106:	8b 45 0c             	mov    0xc(%ebp),%eax
  802109:	89 04 24             	mov    %eax,(%esp)
  80210c:	e8 14 ea ff ff       	call   800b25 <memmove>
		*addrlen = ret->ret_addrlen;
  802111:	8b 16                	mov    (%esi),%edx
  802113:	8b 45 10             	mov    0x10(%ebp),%eax
  802116:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802118:	89 d8                	mov    %ebx,%eax
  80211a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80211d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802120:	89 ec                	mov    %ebp,%esp
  802122:	5d                   	pop    %ebp
  802123:	c3                   	ret    
	...

00802130 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 18             	sub    $0x18,%esp
  802136:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802139:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80213c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	89 04 24             	mov    %eax,(%esp)
  802145:	e8 46 f1 ff ff       	call   801290 <fd2data>
  80214a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80214c:	c7 44 24 04 0a 2f 80 	movl   $0x802f0a,0x4(%esp)
  802153:	00 
  802154:	89 34 24             	mov    %esi,(%esp)
  802157:	e8 0e e8 ff ff       	call   80096a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80215c:	8b 43 04             	mov    0x4(%ebx),%eax
  80215f:	2b 03                	sub    (%ebx),%eax
  802161:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802167:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80216e:	00 00 00 
	stat->st_dev = &devpipe;
  802171:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  802178:	60 80 00 
	return 0;
}
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
  802180:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802183:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802186:	89 ec                	mov    %ebp,%esp
  802188:	5d                   	pop    %ebp
  802189:	c3                   	ret    

0080218a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	53                   	push   %ebx
  80218e:	83 ec 14             	sub    $0x14,%esp
  802191:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802194:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802198:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80219f:	e8 fb ee ff ff       	call   80109f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021a4:	89 1c 24             	mov    %ebx,(%esp)
  8021a7:	e8 e4 f0 ff ff       	call   801290 <fd2data>
  8021ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b7:	e8 e3 ee ff ff       	call   80109f <sys_page_unmap>
}
  8021bc:	83 c4 14             	add    $0x14,%esp
  8021bf:	5b                   	pop    %ebx
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    

008021c2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 2c             	sub    $0x2c,%esp
  8021cb:	89 c7                	mov    %eax,%edi
  8021cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8021d0:	a1 80 80 80 00       	mov    0x808080,%eax
  8021d5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021d8:	89 3c 24             	mov    %edi,(%esp)
  8021db:	e8 b0 05 00 00       	call   802790 <pageref>
  8021e0:	89 c6                	mov    %eax,%esi
  8021e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e5:	89 04 24             	mov    %eax,(%esp)
  8021e8:	e8 a3 05 00 00       	call   802790 <pageref>
  8021ed:	39 c6                	cmp    %eax,%esi
  8021ef:	0f 94 c0             	sete   %al
  8021f2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8021f5:	8b 15 80 80 80 00    	mov    0x808080,%edx
  8021fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021fe:	39 cb                	cmp    %ecx,%ebx
  802200:	75 08                	jne    80220a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802202:	83 c4 2c             	add    $0x2c,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80220a:	83 f8 01             	cmp    $0x1,%eax
  80220d:	75 c1                	jne    8021d0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80220f:	8b 52 58             	mov    0x58(%edx),%edx
  802212:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802216:	89 54 24 08          	mov    %edx,0x8(%esp)
  80221a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80221e:	c7 04 24 11 2f 80 00 	movl   $0x802f11,(%esp)
  802225:	e8 7b e0 ff ff       	call   8002a5 <cprintf>
  80222a:	eb a4                	jmp    8021d0 <_pipeisclosed+0xe>

0080222c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	57                   	push   %edi
  802230:	56                   	push   %esi
  802231:	53                   	push   %ebx
  802232:	83 ec 1c             	sub    $0x1c,%esp
  802235:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802238:	89 34 24             	mov    %esi,(%esp)
  80223b:	e8 50 f0 ff ff       	call   801290 <fd2data>
  802240:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802242:	bf 00 00 00 00       	mov    $0x0,%edi
  802247:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80224b:	75 54                	jne    8022a1 <devpipe_write+0x75>
  80224d:	eb 60                	jmp    8022af <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80224f:	89 da                	mov    %ebx,%edx
  802251:	89 f0                	mov    %esi,%eax
  802253:	e8 6a ff ff ff       	call   8021c2 <_pipeisclosed>
  802258:	85 c0                	test   %eax,%eax
  80225a:	74 07                	je     802263 <devpipe_write+0x37>
  80225c:	b8 00 00 00 00       	mov    $0x0,%eax
  802261:	eb 53                	jmp    8022b6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802263:	90                   	nop
  802264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802268:	e8 4d ef ff ff       	call   8011ba <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80226d:	8b 43 04             	mov    0x4(%ebx),%eax
  802270:	8b 13                	mov    (%ebx),%edx
  802272:	83 c2 20             	add    $0x20,%edx
  802275:	39 d0                	cmp    %edx,%eax
  802277:	73 d6                	jae    80224f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802279:	89 c2                	mov    %eax,%edx
  80227b:	c1 fa 1f             	sar    $0x1f,%edx
  80227e:	c1 ea 1b             	shr    $0x1b,%edx
  802281:	01 d0                	add    %edx,%eax
  802283:	83 e0 1f             	and    $0x1f,%eax
  802286:	29 d0                	sub    %edx,%eax
  802288:	89 c2                	mov    %eax,%edx
  80228a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80228d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802291:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802295:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802299:	83 c7 01             	add    $0x1,%edi
  80229c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80229f:	76 13                	jbe    8022b4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8022a4:	8b 13                	mov    (%ebx),%edx
  8022a6:	83 c2 20             	add    $0x20,%edx
  8022a9:	39 d0                	cmp    %edx,%eax
  8022ab:	73 a2                	jae    80224f <devpipe_write+0x23>
  8022ad:	eb ca                	jmp    802279 <devpipe_write+0x4d>
  8022af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8022b4:	89 f8                	mov    %edi,%eax
}
  8022b6:	83 c4 1c             	add    $0x1c,%esp
  8022b9:	5b                   	pop    %ebx
  8022ba:	5e                   	pop    %esi
  8022bb:	5f                   	pop    %edi
  8022bc:	5d                   	pop    %ebp
  8022bd:	c3                   	ret    

008022be <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 28             	sub    $0x28,%esp
  8022c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8022c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8022ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8022cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022d0:	89 3c 24             	mov    %edi,(%esp)
  8022d3:	e8 b8 ef ff ff       	call   801290 <fd2data>
  8022d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022da:	be 00 00 00 00       	mov    $0x0,%esi
  8022df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022e3:	75 4c                	jne    802331 <devpipe_read+0x73>
  8022e5:	eb 5b                	jmp    802342 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8022e7:	89 f0                	mov    %esi,%eax
  8022e9:	eb 5e                	jmp    802349 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8022eb:	89 da                	mov    %ebx,%edx
  8022ed:	89 f8                	mov    %edi,%eax
  8022ef:	90                   	nop
  8022f0:	e8 cd fe ff ff       	call   8021c2 <_pipeisclosed>
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	74 07                	je     802300 <devpipe_read+0x42>
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fe:	eb 49                	jmp    802349 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802300:	e8 b5 ee ff ff       	call   8011ba <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802305:	8b 03                	mov    (%ebx),%eax
  802307:	3b 43 04             	cmp    0x4(%ebx),%eax
  80230a:	74 df                	je     8022eb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80230c:	89 c2                	mov    %eax,%edx
  80230e:	c1 fa 1f             	sar    $0x1f,%edx
  802311:	c1 ea 1b             	shr    $0x1b,%edx
  802314:	01 d0                	add    %edx,%eax
  802316:	83 e0 1f             	and    $0x1f,%eax
  802319:	29 d0                	sub    %edx,%eax
  80231b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802320:	8b 55 0c             	mov    0xc(%ebp),%edx
  802323:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802326:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802329:	83 c6 01             	add    $0x1,%esi
  80232c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80232f:	76 16                	jbe    802347 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802331:	8b 03                	mov    (%ebx),%eax
  802333:	3b 43 04             	cmp    0x4(%ebx),%eax
  802336:	75 d4                	jne    80230c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802338:	85 f6                	test   %esi,%esi
  80233a:	75 ab                	jne    8022e7 <devpipe_read+0x29>
  80233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802340:	eb a9                	jmp    8022eb <devpipe_read+0x2d>
  802342:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802347:	89 f0                	mov    %esi,%eax
}
  802349:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80234c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80234f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802352:	89 ec                	mov    %ebp,%esp
  802354:	5d                   	pop    %ebp
  802355:	c3                   	ret    

00802356 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80235c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	89 04 24             	mov    %eax,(%esp)
  802369:	e8 af ef ff ff       	call   80131d <fd_lookup>
  80236e:	85 c0                	test   %eax,%eax
  802370:	78 15                	js     802387 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	89 04 24             	mov    %eax,(%esp)
  802378:	e8 13 ef ff ff       	call   801290 <fd2data>
	return _pipeisclosed(fd, p);
  80237d:	89 c2                	mov    %eax,%edx
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	e8 3b fe ff ff       	call   8021c2 <_pipeisclosed>
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 48             	sub    $0x48,%esp
  80238f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802392:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802395:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802398:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80239b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80239e:	89 04 24             	mov    %eax,(%esp)
  8023a1:	e8 05 ef ff ff       	call   8012ab <fd_alloc>
  8023a6:	89 c3                	mov    %eax,%ebx
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	0f 88 42 01 00 00    	js     8024f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023b0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023b7:	00 
  8023b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c6:	e8 90 ed ff ff       	call   80115b <sys_page_alloc>
  8023cb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	0f 88 1d 01 00 00    	js     8024f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8023d8:	89 04 24             	mov    %eax,(%esp)
  8023db:	e8 cb ee ff ff       	call   8012ab <fd_alloc>
  8023e0:	89 c3                	mov    %eax,%ebx
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	0f 88 f5 00 00 00    	js     8024df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ea:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023f1:	00 
  8023f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802400:	e8 56 ed ff ff       	call   80115b <sys_page_alloc>
  802405:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802407:	85 c0                	test   %eax,%eax
  802409:	0f 88 d0 00 00 00    	js     8024df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80240f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802412:	89 04 24             	mov    %eax,(%esp)
  802415:	e8 76 ee ff ff       	call   801290 <fd2data>
  80241a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80241c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802423:	00 
  802424:	89 44 24 04          	mov    %eax,0x4(%esp)
  802428:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80242f:	e8 27 ed ff ff       	call   80115b <sys_page_alloc>
  802434:	89 c3                	mov    %eax,%ebx
  802436:	85 c0                	test   %eax,%eax
  802438:	0f 88 8e 00 00 00    	js     8024cc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802441:	89 04 24             	mov    %eax,(%esp)
  802444:	e8 47 ee ff ff       	call   801290 <fd2data>
  802449:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802450:	00 
  802451:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802455:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80245c:	00 
  80245d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802461:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802468:	e8 90 ec ff ff       	call   8010fd <sys_page_map>
  80246d:	89 c3                	mov    %eax,%ebx
  80246f:	85 c0                	test   %eax,%eax
  802471:	78 49                	js     8024bc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802473:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  802478:	8b 08                	mov    (%eax),%ecx
  80247a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80247d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80247f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802482:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802489:	8b 10                	mov    (%eax),%edx
  80248b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802490:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802493:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80249a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80249d:	89 04 24             	mov    %eax,(%esp)
  8024a0:	e8 db ed ff ff       	call   801280 <fd2num>
  8024a5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8024a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024aa:	89 04 24             	mov    %eax,(%esp)
  8024ad:	e8 ce ed ff ff       	call   801280 <fd2num>
  8024b2:	89 47 04             	mov    %eax,0x4(%edi)
  8024b5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8024ba:	eb 36                	jmp    8024f2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8024bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c7:	e8 d3 eb ff ff       	call   80109f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024da:	e8 c0 eb ff ff       	call   80109f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024ed:	e8 ad eb ff ff       	call   80109f <sys_page_unmap>
    err:
	return r;
}
  8024f2:	89 d8                	mov    %ebx,%eax
  8024f4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8024f7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8024fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8024fd:	89 ec                	mov    %ebp,%esp
  8024ff:	5d                   	pop    %ebp
  802500:	c3                   	ret    
	...

00802510 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	5d                   	pop    %ebp
  802519:	c3                   	ret    

0080251a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802520:	c7 44 24 04 29 2f 80 	movl   $0x802f29,0x4(%esp)
  802527:	00 
  802528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252b:	89 04 24             	mov    %eax,(%esp)
  80252e:	e8 37 e4 ff ff       	call   80096a <strcpy>
	return 0;
}
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	57                   	push   %edi
  80253e:	56                   	push   %esi
  80253f:	53                   	push   %ebx
  802540:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
  80254b:	be 00 00 00 00       	mov    $0x0,%esi
  802550:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802554:	74 3f                	je     802595 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802556:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80255c:	8b 55 10             	mov    0x10(%ebp),%edx
  80255f:	29 c2                	sub    %eax,%edx
  802561:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802563:	83 fa 7f             	cmp    $0x7f,%edx
  802566:	76 05                	jbe    80256d <devcons_write+0x33>
  802568:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80256d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802571:	03 45 0c             	add    0xc(%ebp),%eax
  802574:	89 44 24 04          	mov    %eax,0x4(%esp)
  802578:	89 3c 24             	mov    %edi,(%esp)
  80257b:	e8 a5 e5 ff ff       	call   800b25 <memmove>
		sys_cputs(buf, m);
  802580:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802584:	89 3c 24             	mov    %edi,(%esp)
  802587:	e8 d4 e7 ff ff       	call   800d60 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80258c:	01 de                	add    %ebx,%esi
  80258e:	89 f0                	mov    %esi,%eax
  802590:	3b 75 10             	cmp    0x10(%ebp),%esi
  802593:	72 c7                	jb     80255c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802595:	89 f0                	mov    %esi,%eax
  802597:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80259d:	5b                   	pop    %ebx
  80259e:	5e                   	pop    %esi
  80259f:	5f                   	pop    %edi
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    

008025a2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
  8025a5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8025b5:	00 
  8025b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025b9:	89 04 24             	mov    %eax,(%esp)
  8025bc:	e8 9f e7 ff ff       	call   800d60 <sys_cputs>
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
  8025c6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8025c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025cd:	75 07                	jne    8025d6 <devcons_read+0x13>
  8025cf:	eb 28                	jmp    8025f9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025d1:	e8 e4 eb ff ff       	call   8011ba <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025d6:	66 90                	xchg   %ax,%ax
  8025d8:	e8 4f e7 ff ff       	call   800d2c <sys_cgetc>
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	90                   	nop
  8025e0:	74 ef                	je     8025d1 <devcons_read+0xe>
  8025e2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	78 16                	js     8025fe <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8025e8:	83 f8 04             	cmp    $0x4,%eax
  8025eb:	74 0c                	je     8025f9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8025ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f0:	88 10                	mov    %dl,(%eax)
  8025f2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8025f7:	eb 05                	jmp    8025fe <devcons_read+0x3b>
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fe:	c9                   	leave  
  8025ff:	c3                   	ret    

00802600 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802606:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802609:	89 04 24             	mov    %eax,(%esp)
  80260c:	e8 9a ec ff ff       	call   8012ab <fd_alloc>
  802611:	85 c0                	test   %eax,%eax
  802613:	78 3f                	js     802654 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802615:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80261c:	00 
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	89 44 24 04          	mov    %eax,0x4(%esp)
  802624:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80262b:	e8 2b eb ff ff       	call   80115b <sys_page_alloc>
  802630:	85 c0                	test   %eax,%eax
  802632:	78 20                	js     802654 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802634:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	89 04 24             	mov    %eax,(%esp)
  80264f:	e8 2c ec ff ff       	call   801280 <fd2num>
}
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80265c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80265f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	89 04 24             	mov    %eax,(%esp)
  802669:	e8 af ec ff ff       	call   80131d <fd_lookup>
  80266e:	85 c0                	test   %eax,%eax
  802670:	78 11                	js     802683 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  80267d:	0f 94 c0             	sete   %al
  802680:	0f b6 c0             	movzbl %al,%eax
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80268b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802692:	00 
  802693:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802696:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a1:	e8 d8 ee ff ff       	call   80157e <read>
	if (r < 0)
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	78 0f                	js     8026b9 <getchar+0x34>
		return r;
	if (r < 1)
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	7f 07                	jg     8026b5 <getchar+0x30>
  8026ae:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026b3:	eb 04                	jmp    8026b9 <getchar+0x34>
		return -E_EOF;
	return c;
  8026b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    
  8026bb:	00 00                	add    %al,(%eax)
  8026bd:	00 00                	add    %al,(%eax)
	...

008026c0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	57                   	push   %edi
  8026c4:	56                   	push   %esi
  8026c5:	53                   	push   %ebx
  8026c6:	83 ec 1c             	sub    $0x1c,%esp
  8026c9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026cf:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8026d2:	85 db                	test   %ebx,%ebx
  8026d4:	75 2d                	jne    802703 <ipc_send+0x43>
  8026d6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8026db:	eb 26                	jmp    802703 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8026dd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026e0:	74 1c                	je     8026fe <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  8026e2:	c7 44 24 08 38 2f 80 	movl   $0x802f38,0x8(%esp)
  8026e9:	00 
  8026ea:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8026f1:	00 
  8026f2:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  8026f9:	e8 e2 da ff ff       	call   8001e0 <_panic>
		sys_yield();
  8026fe:	e8 b7 ea ff ff       	call   8011ba <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802703:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802707:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80270b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	89 04 24             	mov    %eax,(%esp)
  802715:	e8 33 e8 ff ff       	call   800f4d <sys_ipc_try_send>
  80271a:	85 c0                	test   %eax,%eax
  80271c:	78 bf                	js     8026dd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80271e:	83 c4 1c             	add    $0x1c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	56                   	push   %esi
  80272a:	53                   	push   %ebx
  80272b:	83 ec 10             	sub    $0x10,%esp
  80272e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802731:	8b 45 0c             	mov    0xc(%ebp),%eax
  802734:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802737:	85 c0                	test   %eax,%eax
  802739:	75 05                	jne    802740 <ipc_recv+0x1a>
  80273b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802740:	89 04 24             	mov    %eax,(%esp)
  802743:	e8 a8 e7 ff ff       	call   800ef0 <sys_ipc_recv>
  802748:	85 c0                	test   %eax,%eax
  80274a:	79 16                	jns    802762 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80274c:	85 db                	test   %ebx,%ebx
  80274e:	74 06                	je     802756 <ipc_recv+0x30>
			*from_env_store = 0;
  802750:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802756:	85 f6                	test   %esi,%esi
  802758:	74 2c                	je     802786 <ipc_recv+0x60>
			*perm_store = 0;
  80275a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802760:	eb 24                	jmp    802786 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802762:	85 db                	test   %ebx,%ebx
  802764:	74 0a                	je     802770 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802766:	a1 80 80 80 00       	mov    0x808080,%eax
  80276b:	8b 40 74             	mov    0x74(%eax),%eax
  80276e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802770:	85 f6                	test   %esi,%esi
  802772:	74 0a                	je     80277e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802774:	a1 80 80 80 00       	mov    0x808080,%eax
  802779:	8b 40 78             	mov    0x78(%eax),%eax
  80277c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80277e:	a1 80 80 80 00       	mov    0x808080,%eax
  802783:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802786:	83 c4 10             	add    $0x10,%esp
  802789:	5b                   	pop    %ebx
  80278a:	5e                   	pop    %esi
  80278b:	5d                   	pop    %ebp
  80278c:	c3                   	ret    
  80278d:	00 00                	add    %al,(%eax)
	...

00802790 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802793:	8b 45 08             	mov    0x8(%ebp),%eax
  802796:	89 c2                	mov    %eax,%edx
  802798:	c1 ea 16             	shr    $0x16,%edx
  80279b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027a2:	f6 c2 01             	test   $0x1,%dl
  8027a5:	74 26                	je     8027cd <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8027a7:	c1 e8 0c             	shr    $0xc,%eax
  8027aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027b1:	a8 01                	test   $0x1,%al
  8027b3:	74 18                	je     8027cd <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8027b5:	c1 e8 0c             	shr    $0xc,%eax
  8027b8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8027bb:	c1 e2 02             	shl    $0x2,%edx
  8027be:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8027c3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8027c8:	0f b7 c0             	movzwl %ax,%eax
  8027cb:	eb 05                	jmp    8027d2 <pageref+0x42>
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d2:	5d                   	pop    %ebp
  8027d3:	c3                   	ret    
	...

008027e0 <__udivdi3>:
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	57                   	push   %edi
  8027e4:	56                   	push   %esi
  8027e5:	83 ec 10             	sub    $0x10,%esp
  8027e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8027eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ee:	8b 75 10             	mov    0x10(%ebp),%esi
  8027f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8027f9:	75 35                	jne    802830 <__udivdi3+0x50>
  8027fb:	39 fe                	cmp    %edi,%esi
  8027fd:	77 61                	ja     802860 <__udivdi3+0x80>
  8027ff:	85 f6                	test   %esi,%esi
  802801:	75 0b                	jne    80280e <__udivdi3+0x2e>
  802803:	b8 01 00 00 00       	mov    $0x1,%eax
  802808:	31 d2                	xor    %edx,%edx
  80280a:	f7 f6                	div    %esi
  80280c:	89 c6                	mov    %eax,%esi
  80280e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802811:	31 d2                	xor    %edx,%edx
  802813:	89 f8                	mov    %edi,%eax
  802815:	f7 f6                	div    %esi
  802817:	89 c7                	mov    %eax,%edi
  802819:	89 c8                	mov    %ecx,%eax
  80281b:	f7 f6                	div    %esi
  80281d:	89 c1                	mov    %eax,%ecx
  80281f:	89 fa                	mov    %edi,%edx
  802821:	89 c8                	mov    %ecx,%eax
  802823:	83 c4 10             	add    $0x10,%esp
  802826:	5e                   	pop    %esi
  802827:	5f                   	pop    %edi
  802828:	5d                   	pop    %ebp
  802829:	c3                   	ret    
  80282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802830:	39 f8                	cmp    %edi,%eax
  802832:	77 1c                	ja     802850 <__udivdi3+0x70>
  802834:	0f bd d0             	bsr    %eax,%edx
  802837:	83 f2 1f             	xor    $0x1f,%edx
  80283a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80283d:	75 39                	jne    802878 <__udivdi3+0x98>
  80283f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802842:	0f 86 a0 00 00 00    	jbe    8028e8 <__udivdi3+0x108>
  802848:	39 f8                	cmp    %edi,%eax
  80284a:	0f 82 98 00 00 00    	jb     8028e8 <__udivdi3+0x108>
  802850:	31 ff                	xor    %edi,%edi
  802852:	31 c9                	xor    %ecx,%ecx
  802854:	89 c8                	mov    %ecx,%eax
  802856:	89 fa                	mov    %edi,%edx
  802858:	83 c4 10             	add    $0x10,%esp
  80285b:	5e                   	pop    %esi
  80285c:	5f                   	pop    %edi
  80285d:	5d                   	pop    %ebp
  80285e:	c3                   	ret    
  80285f:	90                   	nop
  802860:	89 d1                	mov    %edx,%ecx
  802862:	89 fa                	mov    %edi,%edx
  802864:	89 c8                	mov    %ecx,%eax
  802866:	31 ff                	xor    %edi,%edi
  802868:	f7 f6                	div    %esi
  80286a:	89 c1                	mov    %eax,%ecx
  80286c:	89 fa                	mov    %edi,%edx
  80286e:	89 c8                	mov    %ecx,%eax
  802870:	83 c4 10             	add    $0x10,%esp
  802873:	5e                   	pop    %esi
  802874:	5f                   	pop    %edi
  802875:	5d                   	pop    %ebp
  802876:	c3                   	ret    
  802877:	90                   	nop
  802878:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80287c:	89 f2                	mov    %esi,%edx
  80287e:	d3 e0                	shl    %cl,%eax
  802880:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802883:	b8 20 00 00 00       	mov    $0x20,%eax
  802888:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80288b:	89 c1                	mov    %eax,%ecx
  80288d:	d3 ea                	shr    %cl,%edx
  80288f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802893:	0b 55 ec             	or     -0x14(%ebp),%edx
  802896:	d3 e6                	shl    %cl,%esi
  802898:	89 c1                	mov    %eax,%ecx
  80289a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80289d:	89 fe                	mov    %edi,%esi
  80289f:	d3 ee                	shr    %cl,%esi
  8028a1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ab:	d3 e7                	shl    %cl,%edi
  8028ad:	89 c1                	mov    %eax,%ecx
  8028af:	d3 ea                	shr    %cl,%edx
  8028b1:	09 d7                	or     %edx,%edi
  8028b3:	89 f2                	mov    %esi,%edx
  8028b5:	89 f8                	mov    %edi,%eax
  8028b7:	f7 75 ec             	divl   -0x14(%ebp)
  8028ba:	89 d6                	mov    %edx,%esi
  8028bc:	89 c7                	mov    %eax,%edi
  8028be:	f7 65 e8             	mull   -0x18(%ebp)
  8028c1:	39 d6                	cmp    %edx,%esi
  8028c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028c6:	72 30                	jb     8028f8 <__udivdi3+0x118>
  8028c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028cf:	d3 e2                	shl    %cl,%edx
  8028d1:	39 c2                	cmp    %eax,%edx
  8028d3:	73 05                	jae    8028da <__udivdi3+0xfa>
  8028d5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8028d8:	74 1e                	je     8028f8 <__udivdi3+0x118>
  8028da:	89 f9                	mov    %edi,%ecx
  8028dc:	31 ff                	xor    %edi,%edi
  8028de:	e9 71 ff ff ff       	jmp    802854 <__udivdi3+0x74>
  8028e3:	90                   	nop
  8028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028e8:	31 ff                	xor    %edi,%edi
  8028ea:	b9 01 00 00 00       	mov    $0x1,%ecx
  8028ef:	e9 60 ff ff ff       	jmp    802854 <__udivdi3+0x74>
  8028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8028fb:	31 ff                	xor    %edi,%edi
  8028fd:	89 c8                	mov    %ecx,%eax
  8028ff:	89 fa                	mov    %edi,%edx
  802901:	83 c4 10             	add    $0x10,%esp
  802904:	5e                   	pop    %esi
  802905:	5f                   	pop    %edi
  802906:	5d                   	pop    %ebp
  802907:	c3                   	ret    
	...

00802910 <__umoddi3>:
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
  802913:	57                   	push   %edi
  802914:	56                   	push   %esi
  802915:	83 ec 20             	sub    $0x20,%esp
  802918:	8b 55 14             	mov    0x14(%ebp),%edx
  80291b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80291e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802921:	8b 75 0c             	mov    0xc(%ebp),%esi
  802924:	85 d2                	test   %edx,%edx
  802926:	89 c8                	mov    %ecx,%eax
  802928:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80292b:	75 13                	jne    802940 <__umoddi3+0x30>
  80292d:	39 f7                	cmp    %esi,%edi
  80292f:	76 3f                	jbe    802970 <__umoddi3+0x60>
  802931:	89 f2                	mov    %esi,%edx
  802933:	f7 f7                	div    %edi
  802935:	89 d0                	mov    %edx,%eax
  802937:	31 d2                	xor    %edx,%edx
  802939:	83 c4 20             	add    $0x20,%esp
  80293c:	5e                   	pop    %esi
  80293d:	5f                   	pop    %edi
  80293e:	5d                   	pop    %ebp
  80293f:	c3                   	ret    
  802940:	39 f2                	cmp    %esi,%edx
  802942:	77 4c                	ja     802990 <__umoddi3+0x80>
  802944:	0f bd ca             	bsr    %edx,%ecx
  802947:	83 f1 1f             	xor    $0x1f,%ecx
  80294a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80294d:	75 51                	jne    8029a0 <__umoddi3+0x90>
  80294f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802952:	0f 87 e0 00 00 00    	ja     802a38 <__umoddi3+0x128>
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	29 f8                	sub    %edi,%eax
  80295d:	19 d6                	sbb    %edx,%esi
  80295f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	89 f2                	mov    %esi,%edx
  802967:	83 c4 20             	add    $0x20,%esp
  80296a:	5e                   	pop    %esi
  80296b:	5f                   	pop    %edi
  80296c:	5d                   	pop    %ebp
  80296d:	c3                   	ret    
  80296e:	66 90                	xchg   %ax,%ax
  802970:	85 ff                	test   %edi,%edi
  802972:	75 0b                	jne    80297f <__umoddi3+0x6f>
  802974:	b8 01 00 00 00       	mov    $0x1,%eax
  802979:	31 d2                	xor    %edx,%edx
  80297b:	f7 f7                	div    %edi
  80297d:	89 c7                	mov    %eax,%edi
  80297f:	89 f0                	mov    %esi,%eax
  802981:	31 d2                	xor    %edx,%edx
  802983:	f7 f7                	div    %edi
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	f7 f7                	div    %edi
  80298a:	eb a9                	jmp    802935 <__umoddi3+0x25>
  80298c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802990:	89 c8                	mov    %ecx,%eax
  802992:	89 f2                	mov    %esi,%edx
  802994:	83 c4 20             	add    $0x20,%esp
  802997:	5e                   	pop    %esi
  802998:	5f                   	pop    %edi
  802999:	5d                   	pop    %ebp
  80299a:	c3                   	ret    
  80299b:	90                   	nop
  80299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029a0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029a4:	d3 e2                	shl    %cl,%edx
  8029a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029a9:	ba 20 00 00 00       	mov    $0x20,%edx
  8029ae:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8029b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8029b4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029b8:	89 fa                	mov    %edi,%edx
  8029ba:	d3 ea                	shr    %cl,%edx
  8029bc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029c0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8029c3:	d3 e7                	shl    %cl,%edi
  8029c5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029cc:	89 f2                	mov    %esi,%edx
  8029ce:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8029d1:	89 c7                	mov    %eax,%edi
  8029d3:	d3 ea                	shr    %cl,%edx
  8029d5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8029dc:	89 c2                	mov    %eax,%edx
  8029de:	d3 e6                	shl    %cl,%esi
  8029e0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029e4:	d3 ea                	shr    %cl,%edx
  8029e6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029ea:	09 d6                	or     %edx,%esi
  8029ec:	89 f0                	mov    %esi,%eax
  8029ee:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8029f1:	d3 e7                	shl    %cl,%edi
  8029f3:	89 f2                	mov    %esi,%edx
  8029f5:	f7 75 f4             	divl   -0xc(%ebp)
  8029f8:	89 d6                	mov    %edx,%esi
  8029fa:	f7 65 e8             	mull   -0x18(%ebp)
  8029fd:	39 d6                	cmp    %edx,%esi
  8029ff:	72 2b                	jb     802a2c <__umoddi3+0x11c>
  802a01:	39 c7                	cmp    %eax,%edi
  802a03:	72 23                	jb     802a28 <__umoddi3+0x118>
  802a05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a09:	29 c7                	sub    %eax,%edi
  802a0b:	19 d6                	sbb    %edx,%esi
  802a0d:	89 f0                	mov    %esi,%eax
  802a0f:	89 f2                	mov    %esi,%edx
  802a11:	d3 ef                	shr    %cl,%edi
  802a13:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a17:	d3 e0                	shl    %cl,%eax
  802a19:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a1d:	09 f8                	or     %edi,%eax
  802a1f:	d3 ea                	shr    %cl,%edx
  802a21:	83 c4 20             	add    $0x20,%esp
  802a24:	5e                   	pop    %esi
  802a25:	5f                   	pop    %edi
  802a26:	5d                   	pop    %ebp
  802a27:	c3                   	ret    
  802a28:	39 d6                	cmp    %edx,%esi
  802a2a:	75 d9                	jne    802a05 <__umoddi3+0xf5>
  802a2c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a2f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802a32:	eb d1                	jmp    802a05 <__umoddi3+0xf5>
  802a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a38:	39 f2                	cmp    %esi,%edx
  802a3a:	0f 82 18 ff ff ff    	jb     802958 <__umoddi3+0x48>
  802a40:	e9 1d ff ff ff       	jmp    802962 <__umoddi3+0x52>
