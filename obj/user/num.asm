
obj/user/num:     file format elf32-i386


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
  80002c:	e8 9f 01 00 00       	call   8001d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <num>:
int bol = 1;
int line = 0;

void
num(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800043:	8d 5d e7             	lea    -0x19(%ebp),%ebx
  800046:	e9 81 00 00 00       	jmp    8000cc <num+0x98>
		if (bol) {
  80004b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800052:	74 27                	je     80007b <num+0x47>
			printf("%5d ", ++line);
  800054:	a1 78 60 80 00       	mov    0x806078,%eax
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	a3 78 60 80 00       	mov    %eax,0x806078
  800061:	89 44 24 04          	mov    %eax,0x4(%esp)
  800065:	c7 04 24 a0 2a 80 00 	movl   $0x802aa0,(%esp)
  80006c:	e8 b2 1b 00 00       	call   801c23 <printf>
			bol = 0;
  800071:	c7 05 00 60 80 00 00 	movl   $0x0,0x806000
  800078:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  80007b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800082:	00 
  800083:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80008e:	e8 b2 14 00 00       	call   801545 <write>
  800093:	83 f8 01             	cmp    $0x1,%eax
  800096:	74 24                	je     8000bc <num+0x88>
			panic("write error copying %s: %e", s, r);
  800098:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000a0:	c7 44 24 08 a5 2a 80 	movl   $0x802aa5,0x8(%esp)
  8000a7:	00 
  8000a8:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000af:	00 
  8000b0:	c7 04 24 c0 2a 80 00 	movl   $0x802ac0,(%esp)
  8000b7:	e8 80 01 00 00       	call   80023c <_panic>
		if (c == '\n')
  8000bc:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8000c0:	75 0a                	jne    8000cc <num+0x98>
			bol = 1;
  8000c2:	c7 05 00 60 80 00 01 	movl   $0x1,0x806000
  8000c9:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d3:	00 
  8000d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d8:	89 34 24             	mov    %esi,(%esp)
  8000db:	e8 ee 14 00 00       	call   8015ce <read>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	0f 8f 63 ff ff ff    	jg     80004b <num+0x17>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	79 24                	jns    800110 <num+0xdc>
		panic("error reading %s: %e", s, n);
  8000ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000f4:	c7 44 24 08 cb 2a 80 	movl   $0x802acb,0x8(%esp)
  8000fb:	00 
  8000fc:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800103:	00 
  800104:	c7 04 24 c0 2a 80 00 	movl   $0x802ac0,(%esp)
  80010b:	e8 2c 01 00 00       	call   80023c <_panic>
}
  800110:	83 c4 3c             	add    $0x3c,%esp
  800113:	5b                   	pop    %ebx
  800114:	5e                   	pop    %esi
  800115:	5f                   	pop    %edi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 3c             	sub    $0x3c,%esp
	int f, i;

	argv0 = "num";
  800121:	c7 05 80 60 80 00 e0 	movl   $0x802ae0,0x806080
  800128:	2a 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 0b                	je     80013c <umain+0x24>
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800131:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800135:	7f 1b                	jg     800152 <umain+0x3a>
  800137:	e9 86 00 00 00       	jmp    8001c2 <umain+0xaa>
{
	int f, i;

	argv0 = "num";
	if (argc == 1)
		num(0, "<stdin>");
  80013c:	c7 44 24 04 e4 2a 80 	movl   $0x802ae4,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014b:	e8 e4 fe ff ff       	call   800034 <num>
  800150:	eb 70                	jmp    8001c2 <umain+0xaa>
  800152:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800155:	83 c3 04             	add    $0x4,%ebx
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800160:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800167:	00 
  800168:	8b 03                	mov    (%ebx),%eax
  80016a:	89 04 24             	mov    %eax,(%esp)
  80016d:	e8 61 19 00 00       	call   801ad3 <open>
  800172:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800174:	85 c0                	test   %eax,%eax
  800176:	79 29                	jns    8001a1 <umain+0x89>
				panic("can't open %s: %e", argv[i], f);
  800178:	89 44 24 10          	mov    %eax,0x10(%esp)
  80017c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80017f:	8b 02                	mov    (%edx),%eax
  800181:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800185:	c7 44 24 08 ec 2a 80 	movl   $0x802aec,0x8(%esp)
  80018c:	00 
  80018d:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  800194:	00 
  800195:	c7 04 24 c0 2a 80 00 	movl   $0x802ac0,(%esp)
  80019c:	e8 9b 00 00 00       	call   80023c <_panic>
			else {
				num(f, argv[i]);
  8001a1:	8b 03                	mov    (%ebx),%eax
  8001a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a7:	89 34 24             	mov    %esi,(%esp)
  8001aa:	e8 85 fe ff ff       	call   800034 <num>
				close(f);
  8001af:	89 34 24             	mov    %esi,(%esp)
  8001b2:	e8 77 15 00 00       	call   80172e <close>

	argv0 = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001b7:	83 c7 01             	add    $0x1,%edi
  8001ba:	83 c3 04             	add    $0x4,%ebx
  8001bd:	39 7d 08             	cmp    %edi,0x8(%ebp)
  8001c0:	7f 9b                	jg     80015d <umain+0x45>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001c2:	e8 59 00 00 00       	call   800220 <exit>
}
  8001c7:	83 c4 3c             	add    $0x3c,%esp
  8001ca:	5b                   	pop    %ebx
  8001cb:	5e                   	pop    %esi
  8001cc:	5f                   	pop    %edi
  8001cd:	5d                   	pop    %ebp
  8001ce:	c3                   	ret    
	...

008001d0 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 18             	sub    $0x18,%esp
  8001d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001d9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8001df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8001e2:	e8 57 10 00 00       	call   80123e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8001e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f4:	a3 7c 60 80 00       	mov    %eax,0x80607c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f9:	85 f6                	test   %esi,%esi
  8001fb:	7e 07                	jle    800204 <libmain+0x34>
		binaryname = argv[0];
  8001fd:	8b 03                	mov    (%ebx),%eax
  8001ff:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	umain(argc, argv);
  800204:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800208:	89 34 24             	mov    %esi,(%esp)
  80020b:	e8 08 ff ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  800210:	e8 0b 00 00 00       	call   800220 <exit>
}
  800215:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800218:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80021b:	89 ec                	mov    %ebp,%esp
  80021d:	5d                   	pop    %ebp
  80021e:	c3                   	ret    
	...

00800220 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800226:	e8 80 15 00 00       	call   8017ab <close_all>
	sys_env_destroy(0);
  80022b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800232:	e8 3b 10 00 00       	call   801272 <sys_env_destroy>
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    
  800239:	00 00                	add    %al,(%eax)
	...

0080023c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	53                   	push   %ebx
  800240:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800243:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800246:	a1 80 60 80 00       	mov    0x806080,%eax
  80024b:	85 c0                	test   %eax,%eax
  80024d:	74 10                	je     80025f <_panic+0x23>
		cprintf("%s: ", argv0);
  80024f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800253:	c7 04 24 15 2b 80 00 	movl   $0x802b15,(%esp)
  80025a:	e8 a2 00 00 00       	call   800301 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800266:	8b 45 08             	mov    0x8(%ebp),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	a1 04 60 80 00       	mov    0x806004,%eax
  800272:	89 44 24 04          	mov    %eax,0x4(%esp)
  800276:	c7 04 24 1a 2b 80 00 	movl   $0x802b1a,(%esp)
  80027d:	e8 7f 00 00 00       	call   800301 <cprintf>
	vcprintf(fmt, ap);
  800282:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800286:	8b 45 10             	mov    0x10(%ebp),%eax
  800289:	89 04 24             	mov    %eax,(%esp)
  80028c:	e8 0f 00 00 00       	call   8002a0 <vcprintf>
	cprintf("\n");
  800291:	c7 04 24 62 2f 80 00 	movl   $0x802f62,(%esp)
  800298:	e8 64 00 00 00       	call   800301 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029d:	cc                   	int3   
  80029e:	eb fd                	jmp    80029d <_panic+0x61>

008002a0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b0:	00 00 00 
	b.cnt = 0;
  8002b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d5:	c7 04 24 1b 03 80 00 	movl   $0x80031b,(%esp)
  8002dc:	e8 cc 01 00 00       	call   8004ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f1:	89 04 24             	mov    %eax,(%esp)
  8002f4:	e8 b7 0a 00 00       	call   800db0 <sys_cputs>

	return b.cnt;
}
  8002f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ff:	c9                   	leave  
  800300:	c3                   	ret    

00800301 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800307:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80030a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	89 04 24             	mov    %eax,(%esp)
  800314:	e8 87 ff ff ff       	call   8002a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	53                   	push   %ebx
  80031f:	83 ec 14             	sub    $0x14,%esp
  800322:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800325:	8b 03                	mov    (%ebx),%eax
  800327:	8b 55 08             	mov    0x8(%ebp),%edx
  80032a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80032e:	83 c0 01             	add    $0x1,%eax
  800331:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800333:	3d ff 00 00 00       	cmp    $0xff,%eax
  800338:	75 19                	jne    800353 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80033a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800341:	00 
  800342:	8d 43 08             	lea    0x8(%ebx),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	e8 63 0a 00 00       	call   800db0 <sys_cputs>
		b->idx = 0;
  80034d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800353:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800357:	83 c4 14             	add    $0x14,%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    
  80035d:	00 00                	add    %al,(%eax)
	...

00800360 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 4c             	sub    $0x4c,%esp
  800369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036c:	89 d6                	mov    %edx,%esi
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800374:	8b 55 0c             	mov    0xc(%ebp),%edx
  800377:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80037a:	8b 45 10             	mov    0x10(%ebp),%eax
  80037d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800380:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800383:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800386:	b9 00 00 00 00       	mov    $0x0,%ecx
  80038b:	39 d1                	cmp    %edx,%ecx
  80038d:	72 15                	jb     8003a4 <printnum+0x44>
  80038f:	77 07                	ja     800398 <printnum+0x38>
  800391:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800394:	39 d0                	cmp    %edx,%eax
  800396:	76 0c                	jbe    8003a4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800398:	83 eb 01             	sub    $0x1,%ebx
  80039b:	85 db                	test   %ebx,%ebx
  80039d:	8d 76 00             	lea    0x0(%esi),%esi
  8003a0:	7f 61                	jg     800403 <printnum+0xa3>
  8003a2:	eb 70                	jmp    800414 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003a4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003a8:	83 eb 01             	sub    $0x1,%ebx
  8003ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003b7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003bb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003be:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003c1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003cf:	00 
  8003d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d3:	89 04 24             	mov    %eax,(%esp)
  8003d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003dd:	e8 4e 24 00 00       	call   802830 <__udivdi3>
  8003e2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003e5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003f0:	89 04 24             	mov    %eax,(%esp)
  8003f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003f7:	89 f2                	mov    %esi,%edx
  8003f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fc:	e8 5f ff ff ff       	call   800360 <printnum>
  800401:	eb 11                	jmp    800414 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800403:	89 74 24 04          	mov    %esi,0x4(%esp)
  800407:	89 3c 24             	mov    %edi,(%esp)
  80040a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80040d:	83 eb 01             	sub    $0x1,%ebx
  800410:	85 db                	test   %ebx,%ebx
  800412:	7f ef                	jg     800403 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800414:	89 74 24 04          	mov    %esi,0x4(%esp)
  800418:	8b 74 24 04          	mov    0x4(%esp),%esi
  80041c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80041f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800423:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80042a:	00 
  80042b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80042e:	89 14 24             	mov    %edx,(%esp)
  800431:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800434:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800438:	e8 23 25 00 00       	call   802960 <__umoddi3>
  80043d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800441:	0f be 80 36 2b 80 00 	movsbl 0x802b36(%eax),%eax
  800448:	89 04 24             	mov    %eax,(%esp)
  80044b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80044e:	83 c4 4c             	add    $0x4c,%esp
  800451:	5b                   	pop    %ebx
  800452:	5e                   	pop    %esi
  800453:	5f                   	pop    %edi
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    

00800456 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800459:	83 fa 01             	cmp    $0x1,%edx
  80045c:	7e 0e                	jle    80046c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80045e:	8b 10                	mov    (%eax),%edx
  800460:	8d 4a 08             	lea    0x8(%edx),%ecx
  800463:	89 08                	mov    %ecx,(%eax)
  800465:	8b 02                	mov    (%edx),%eax
  800467:	8b 52 04             	mov    0x4(%edx),%edx
  80046a:	eb 22                	jmp    80048e <getuint+0x38>
	else if (lflag)
  80046c:	85 d2                	test   %edx,%edx
  80046e:	74 10                	je     800480 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800470:	8b 10                	mov    (%eax),%edx
  800472:	8d 4a 04             	lea    0x4(%edx),%ecx
  800475:	89 08                	mov    %ecx,(%eax)
  800477:	8b 02                	mov    (%edx),%eax
  800479:	ba 00 00 00 00       	mov    $0x0,%edx
  80047e:	eb 0e                	jmp    80048e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800480:	8b 10                	mov    (%eax),%edx
  800482:	8d 4a 04             	lea    0x4(%edx),%ecx
  800485:	89 08                	mov    %ecx,(%eax)
  800487:	8b 02                	mov    (%edx),%eax
  800489:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80048e:	5d                   	pop    %ebp
  80048f:	c3                   	ret    

00800490 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800496:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80049a:	8b 10                	mov    (%eax),%edx
  80049c:	3b 50 04             	cmp    0x4(%eax),%edx
  80049f:	73 0a                	jae    8004ab <sprintputch+0x1b>
		*b->buf++ = ch;
  8004a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004a4:	88 0a                	mov    %cl,(%edx)
  8004a6:	83 c2 01             	add    $0x1,%edx
  8004a9:	89 10                	mov    %edx,(%eax)
}
  8004ab:	5d                   	pop    %ebp
  8004ac:	c3                   	ret    

008004ad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	57                   	push   %edi
  8004b1:	56                   	push   %esi
  8004b2:	53                   	push   %ebx
  8004b3:	83 ec 5c             	sub    $0x5c,%esp
  8004b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004bf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004c6:	eb 11                	jmp    8004d9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	0f 84 ec 03 00 00    	je     8008bc <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8004d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d4:	89 04 24             	mov    %eax,(%esp)
  8004d7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d9:	0f b6 03             	movzbl (%ebx),%eax
  8004dc:	83 c3 01             	add    $0x1,%ebx
  8004df:	83 f8 25             	cmp    $0x25,%eax
  8004e2:	75 e4                	jne    8004c8 <vprintfmt+0x1b>
  8004e4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004e8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004ef:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800502:	eb 06                	jmp    80050a <vprintfmt+0x5d>
  800504:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800508:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	0f b6 13             	movzbl (%ebx),%edx
  80050d:	0f b6 c2             	movzbl %dl,%eax
  800510:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800513:	8d 43 01             	lea    0x1(%ebx),%eax
  800516:	83 ea 23             	sub    $0x23,%edx
  800519:	80 fa 55             	cmp    $0x55,%dl
  80051c:	0f 87 7d 03 00 00    	ja     80089f <vprintfmt+0x3f2>
  800522:	0f b6 d2             	movzbl %dl,%edx
  800525:	ff 24 95 80 2c 80 00 	jmp    *0x802c80(,%edx,4)
  80052c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800530:	eb d6                	jmp    800508 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800535:	83 ea 30             	sub    $0x30,%edx
  800538:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80053b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80053e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800541:	83 fb 09             	cmp    $0x9,%ebx
  800544:	77 4c                	ja     800592 <vprintfmt+0xe5>
  800546:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800549:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80054f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800552:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800556:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800559:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80055c:	83 fb 09             	cmp    $0x9,%ebx
  80055f:	76 eb                	jbe    80054c <vprintfmt+0x9f>
  800561:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800564:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800567:	eb 29                	jmp    800592 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800569:	8b 55 14             	mov    0x14(%ebp),%edx
  80056c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80056f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800572:	8b 12                	mov    (%edx),%edx
  800574:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800577:	eb 19                	jmp    800592 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800579:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80057c:	c1 fa 1f             	sar    $0x1f,%edx
  80057f:	f7 d2                	not    %edx
  800581:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800584:	eb 82                	jmp    800508 <vprintfmt+0x5b>
  800586:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80058d:	e9 76 ff ff ff       	jmp    800508 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800592:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800596:	0f 89 6c ff ff ff    	jns    800508 <vprintfmt+0x5b>
  80059c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80059f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005a2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8005a5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005a8:	e9 5b ff ff ff       	jmp    800508 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ad:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8005b0:	e9 53 ff ff ff       	jmp    800508 <vprintfmt+0x5b>
  8005b5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 50 04             	lea    0x4(%eax),%edx
  8005be:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	89 04 24             	mov    %eax,(%esp)
  8005ca:	ff d7                	call   *%edi
  8005cc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8005cf:	e9 05 ff ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  8005d4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 50 04             	lea    0x4(%eax),%edx
  8005dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	89 c2                	mov    %eax,%edx
  8005e4:	c1 fa 1f             	sar    $0x1f,%edx
  8005e7:	31 d0                	xor    %edx,%eax
  8005e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005eb:	83 f8 0f             	cmp    $0xf,%eax
  8005ee:	7f 0b                	jg     8005fb <vprintfmt+0x14e>
  8005f0:	8b 14 85 e0 2d 80 00 	mov    0x802de0(,%eax,4),%edx
  8005f7:	85 d2                	test   %edx,%edx
  8005f9:	75 20                	jne    80061b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8005fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ff:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800606:	00 
  800607:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060b:	89 3c 24             	mov    %edi,(%esp)
  80060e:	e8 31 03 00 00       	call   800944 <printfmt>
  800613:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800616:	e9 be fe ff ff       	jmp    8004d9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80061b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80061f:	c7 44 24 08 26 2f 80 	movl   $0x802f26,0x8(%esp)
  800626:	00 
  800627:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062b:	89 3c 24             	mov    %edi,(%esp)
  80062e:	e8 11 03 00 00       	call   800944 <printfmt>
  800633:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800636:	e9 9e fe ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  80063b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80063e:	89 c3                	mov    %eax,%ebx
  800640:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800646:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 50 04             	lea    0x4(%eax),%edx
  80064f:	89 55 14             	mov    %edx,0x14(%ebp)
  800652:	8b 00                	mov    (%eax),%eax
  800654:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800657:	85 c0                	test   %eax,%eax
  800659:	75 07                	jne    800662 <vprintfmt+0x1b5>
  80065b:	c7 45 e0 50 2b 80 00 	movl   $0x802b50,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800662:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800666:	7e 06                	jle    80066e <vprintfmt+0x1c1>
  800668:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80066c:	75 13                	jne    800681 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800671:	0f be 02             	movsbl (%edx),%eax
  800674:	85 c0                	test   %eax,%eax
  800676:	0f 85 99 00 00 00    	jne    800715 <vprintfmt+0x268>
  80067c:	e9 86 00 00 00       	jmp    800707 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800685:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800688:	89 0c 24             	mov    %ecx,(%esp)
  80068b:	e8 fb 02 00 00       	call   80098b <strnlen>
  800690:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800693:	29 c2                	sub    %eax,%edx
  800695:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800698:	85 d2                	test   %edx,%edx
  80069a:	7e d2                	jle    80066e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80069c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8006a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006a3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8006a6:	89 d3                	mov    %edx,%ebx
  8006a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006af:	89 04 24             	mov    %eax,(%esp)
  8006b2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b4:	83 eb 01             	sub    $0x1,%ebx
  8006b7:	85 db                	test   %ebx,%ebx
  8006b9:	7f ed                	jg     8006a8 <vprintfmt+0x1fb>
  8006bb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8006be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006c5:	eb a7                	jmp    80066e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006cb:	74 18                	je     8006e5 <vprintfmt+0x238>
  8006cd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006d0:	83 fa 5e             	cmp    $0x5e,%edx
  8006d3:	76 10                	jbe    8006e5 <vprintfmt+0x238>
					putch('?', putdat);
  8006d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006e0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006e3:	eb 0a                	jmp    8006ef <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e9:	89 04 24             	mov    %eax,(%esp)
  8006ec:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ef:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006f3:	0f be 03             	movsbl (%ebx),%eax
  8006f6:	85 c0                	test   %eax,%eax
  8006f8:	74 05                	je     8006ff <vprintfmt+0x252>
  8006fa:	83 c3 01             	add    $0x1,%ebx
  8006fd:	eb 29                	jmp    800728 <vprintfmt+0x27b>
  8006ff:	89 fe                	mov    %edi,%esi
  800701:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800704:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800707:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070b:	7f 2e                	jg     80073b <vprintfmt+0x28e>
  80070d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800710:	e9 c4 fd ff ff       	jmp    8004d9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800715:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800718:	83 c2 01             	add    $0x1,%edx
  80071b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80071e:	89 f7                	mov    %esi,%edi
  800720:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800723:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800726:	89 d3                	mov    %edx,%ebx
  800728:	85 f6                	test   %esi,%esi
  80072a:	78 9b                	js     8006c7 <vprintfmt+0x21a>
  80072c:	83 ee 01             	sub    $0x1,%esi
  80072f:	79 96                	jns    8006c7 <vprintfmt+0x21a>
  800731:	89 fe                	mov    %edi,%esi
  800733:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800736:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800739:	eb cc                	jmp    800707 <vprintfmt+0x25a>
  80073b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80073e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800741:	89 74 24 04          	mov    %esi,0x4(%esp)
  800745:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80074c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074e:	83 eb 01             	sub    $0x1,%ebx
  800751:	85 db                	test   %ebx,%ebx
  800753:	7f ec                	jg     800741 <vprintfmt+0x294>
  800755:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800758:	e9 7c fd ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  80075d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800760:	83 f9 01             	cmp    $0x1,%ecx
  800763:	7e 16                	jle    80077b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8d 50 08             	lea    0x8(%eax),%edx
  80076b:	89 55 14             	mov    %edx,0x14(%ebp)
  80076e:	8b 10                	mov    (%eax),%edx
  800770:	8b 48 04             	mov    0x4(%eax),%ecx
  800773:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800776:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800779:	eb 32                	jmp    8007ad <vprintfmt+0x300>
	else if (lflag)
  80077b:	85 c9                	test   %ecx,%ecx
  80077d:	74 18                	je     800797 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8d 50 04             	lea    0x4(%eax),%edx
  800785:	89 55 14             	mov    %edx,0x14(%ebp)
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078d:	89 c1                	mov    %eax,%ecx
  80078f:	c1 f9 1f             	sar    $0x1f,%ecx
  800792:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800795:	eb 16                	jmp    8007ad <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 50 04             	lea    0x4(%eax),%edx
  80079d:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a5:	89 c2                	mov    %eax,%edx
  8007a7:	c1 fa 1f             	sar    $0x1f,%edx
  8007aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ad:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007b0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007b3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007bc:	0f 89 9b 00 00 00    	jns    80085d <vprintfmt+0x3b0>
				putch('-', putdat);
  8007c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007cd:	ff d7                	call   *%edi
				num = -(long long) num;
  8007cf:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007d2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007d5:	f7 d9                	neg    %ecx
  8007d7:	83 d3 00             	adc    $0x0,%ebx
  8007da:	f7 db                	neg    %ebx
  8007dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e1:	eb 7a                	jmp    80085d <vprintfmt+0x3b0>
  8007e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e6:	89 ca                	mov    %ecx,%edx
  8007e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007eb:	e8 66 fc ff ff       	call   800456 <getuint>
  8007f0:	89 c1                	mov    %eax,%ecx
  8007f2:	89 d3                	mov    %edx,%ebx
  8007f4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007f9:	eb 62                	jmp    80085d <vprintfmt+0x3b0>
  8007fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007fe:	89 ca                	mov    %ecx,%edx
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
  800803:	e8 4e fc ff ff       	call   800456 <getuint>
  800808:	89 c1                	mov    %eax,%ecx
  80080a:	89 d3                	mov    %edx,%ebx
  80080c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800811:	eb 4a                	jmp    80085d <vprintfmt+0x3b0>
  800813:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800816:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800821:	ff d7                	call   *%edi
			putch('x', putdat);
  800823:	89 74 24 04          	mov    %esi,0x4(%esp)
  800827:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80082e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800830:	8b 45 14             	mov    0x14(%ebp),%eax
  800833:	8d 50 04             	lea    0x4(%eax),%edx
  800836:	89 55 14             	mov    %edx,0x14(%ebp)
  800839:	8b 08                	mov    (%eax),%ecx
  80083b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800840:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800845:	eb 16                	jmp    80085d <vprintfmt+0x3b0>
  800847:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80084a:	89 ca                	mov    %ecx,%edx
  80084c:	8d 45 14             	lea    0x14(%ebp),%eax
  80084f:	e8 02 fc ff ff       	call   800456 <getuint>
  800854:	89 c1                	mov    %eax,%ecx
  800856:	89 d3                	mov    %edx,%ebx
  800858:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80085d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800861:	89 54 24 10          	mov    %edx,0x10(%esp)
  800865:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800868:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80086c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800870:	89 0c 24             	mov    %ecx,(%esp)
  800873:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800877:	89 f2                	mov    %esi,%edx
  800879:	89 f8                	mov    %edi,%eax
  80087b:	e8 e0 fa ff ff       	call   800360 <printnum>
  800880:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800883:	e9 51 fc ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  800888:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80088b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80088e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800892:	89 14 24             	mov    %edx,(%esp)
  800895:	ff d7                	call   *%edi
  800897:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80089a:	e9 3a fc ff ff       	jmp    8004d9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80089f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008a3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008aa:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8008af:	80 38 25             	cmpb   $0x25,(%eax)
  8008b2:	0f 84 21 fc ff ff    	je     8004d9 <vprintfmt+0x2c>
  8008b8:	89 c3                	mov    %eax,%ebx
  8008ba:	eb f0                	jmp    8008ac <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8008bc:	83 c4 5c             	add    $0x5c,%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5f                   	pop    %edi
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	83 ec 28             	sub    $0x28,%esp
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008d0:	85 c0                	test   %eax,%eax
  8008d2:	74 04                	je     8008d8 <vsnprintf+0x14>
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	7f 07                	jg     8008df <vsnprintf+0x1b>
  8008d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008dd:	eb 3b                	jmp    80091a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800901:	89 44 24 04          	mov    %eax,0x4(%esp)
  800905:	c7 04 24 90 04 80 00 	movl   $0x800490,(%esp)
  80090c:	e8 9c fb ff ff       	call   8004ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800914:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800917:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800922:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800925:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800929:	8b 45 10             	mov    0x10(%ebp),%eax
  80092c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
  800933:	89 44 24 04          	mov    %eax,0x4(%esp)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 04 24             	mov    %eax,(%esp)
  80093d:	e8 82 ff ff ff       	call   8008c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80094a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80094d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800951:	8b 45 10             	mov    0x10(%ebp),%eax
  800954:	89 44 24 08          	mov    %eax,0x8(%esp)
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	89 04 24             	mov    %eax,(%esp)
  800965:	e8 43 fb ff ff       	call   8004ad <vprintfmt>
	va_end(ap);
}
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    
  80096c:	00 00                	add    %al,(%eax)
	...

00800970 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	80 3a 00             	cmpb   $0x0,(%edx)
  80097e:	74 09                	je     800989 <strlen+0x19>
		n++;
  800980:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800983:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800987:	75 f7                	jne    800980 <strlen+0x10>
		n++;
	return n;
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	53                   	push   %ebx
  80098f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800992:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800995:	85 c9                	test   %ecx,%ecx
  800997:	74 19                	je     8009b2 <strnlen+0x27>
  800999:	80 3b 00             	cmpb   $0x0,(%ebx)
  80099c:	74 14                	je     8009b2 <strnlen+0x27>
  80099e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8009a3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a6:	39 c8                	cmp    %ecx,%eax
  8009a8:	74 0d                	je     8009b7 <strnlen+0x2c>
  8009aa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8009ae:	75 f3                	jne    8009a3 <strnlen+0x18>
  8009b0:	eb 05                	jmp    8009b7 <strnlen+0x2c>
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	53                   	push   %ebx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009c4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009cd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009d0:	83 c2 01             	add    $0x1,%edx
  8009d3:	84 c9                	test   %cl,%cl
  8009d5:	75 f2                	jne    8009c9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	56                   	push   %esi
  8009de:	53                   	push   %ebx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e8:	85 f6                	test   %esi,%esi
  8009ea:	74 18                	je     800a04 <strncpy+0x2a>
  8009ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009f1:	0f b6 1a             	movzbl (%edx),%ebx
  8009f4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009f7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009fa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009fd:	83 c1 01             	add    $0x1,%ecx
  800a00:	39 ce                	cmp    %ecx,%esi
  800a02:	77 ed                	ja     8009f1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a04:	5b                   	pop    %ebx
  800a05:	5e                   	pop    %esi
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	56                   	push   %esi
  800a0c:	53                   	push   %ebx
  800a0d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a13:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a16:	89 f0                	mov    %esi,%eax
  800a18:	85 c9                	test   %ecx,%ecx
  800a1a:	74 27                	je     800a43 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a1c:	83 e9 01             	sub    $0x1,%ecx
  800a1f:	74 1d                	je     800a3e <strlcpy+0x36>
  800a21:	0f b6 1a             	movzbl (%edx),%ebx
  800a24:	84 db                	test   %bl,%bl
  800a26:	74 16                	je     800a3e <strlcpy+0x36>
			*dst++ = *src++;
  800a28:	88 18                	mov    %bl,(%eax)
  800a2a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a2d:	83 e9 01             	sub    $0x1,%ecx
  800a30:	74 0e                	je     800a40 <strlcpy+0x38>
			*dst++ = *src++;
  800a32:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a35:	0f b6 1a             	movzbl (%edx),%ebx
  800a38:	84 db                	test   %bl,%bl
  800a3a:	75 ec                	jne    800a28 <strlcpy+0x20>
  800a3c:	eb 02                	jmp    800a40 <strlcpy+0x38>
  800a3e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a40:	c6 00 00             	movb   $0x0,(%eax)
  800a43:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a45:	5b                   	pop    %ebx
  800a46:	5e                   	pop    %esi
  800a47:	5d                   	pop    %ebp
  800a48:	c3                   	ret    

00800a49 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a49:	55                   	push   %ebp
  800a4a:	89 e5                	mov    %esp,%ebp
  800a4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a52:	0f b6 01             	movzbl (%ecx),%eax
  800a55:	84 c0                	test   %al,%al
  800a57:	74 15                	je     800a6e <strcmp+0x25>
  800a59:	3a 02                	cmp    (%edx),%al
  800a5b:	75 11                	jne    800a6e <strcmp+0x25>
		p++, q++;
  800a5d:	83 c1 01             	add    $0x1,%ecx
  800a60:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a63:	0f b6 01             	movzbl (%ecx),%eax
  800a66:	84 c0                	test   %al,%al
  800a68:	74 04                	je     800a6e <strcmp+0x25>
  800a6a:	3a 02                	cmp    (%edx),%al
  800a6c:	74 ef                	je     800a5d <strcmp+0x14>
  800a6e:	0f b6 c0             	movzbl %al,%eax
  800a71:	0f b6 12             	movzbl (%edx),%edx
  800a74:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	53                   	push   %ebx
  800a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a85:	85 c0                	test   %eax,%eax
  800a87:	74 23                	je     800aac <strncmp+0x34>
  800a89:	0f b6 1a             	movzbl (%edx),%ebx
  800a8c:	84 db                	test   %bl,%bl
  800a8e:	74 24                	je     800ab4 <strncmp+0x3c>
  800a90:	3a 19                	cmp    (%ecx),%bl
  800a92:	75 20                	jne    800ab4 <strncmp+0x3c>
  800a94:	83 e8 01             	sub    $0x1,%eax
  800a97:	74 13                	je     800aac <strncmp+0x34>
		n--, p++, q++;
  800a99:	83 c2 01             	add    $0x1,%edx
  800a9c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a9f:	0f b6 1a             	movzbl (%edx),%ebx
  800aa2:	84 db                	test   %bl,%bl
  800aa4:	74 0e                	je     800ab4 <strncmp+0x3c>
  800aa6:	3a 19                	cmp    (%ecx),%bl
  800aa8:	74 ea                	je     800a94 <strncmp+0x1c>
  800aaa:	eb 08                	jmp    800ab4 <strncmp+0x3c>
  800aac:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ab1:	5b                   	pop    %ebx
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab4:	0f b6 02             	movzbl (%edx),%eax
  800ab7:	0f b6 11             	movzbl (%ecx),%edx
  800aba:	29 d0                	sub    %edx,%eax
  800abc:	eb f3                	jmp    800ab1 <strncmp+0x39>

00800abe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac8:	0f b6 10             	movzbl (%eax),%edx
  800acb:	84 d2                	test   %dl,%dl
  800acd:	74 15                	je     800ae4 <strchr+0x26>
		if (*s == c)
  800acf:	38 ca                	cmp    %cl,%dl
  800ad1:	75 07                	jne    800ada <strchr+0x1c>
  800ad3:	eb 14                	jmp    800ae9 <strchr+0x2b>
  800ad5:	38 ca                	cmp    %cl,%dl
  800ad7:	90                   	nop
  800ad8:	74 0f                	je     800ae9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	0f b6 10             	movzbl (%eax),%edx
  800ae0:	84 d2                	test   %dl,%dl
  800ae2:	75 f1                	jne    800ad5 <strchr+0x17>
  800ae4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af5:	0f b6 10             	movzbl (%eax),%edx
  800af8:	84 d2                	test   %dl,%dl
  800afa:	74 18                	je     800b14 <strfind+0x29>
		if (*s == c)
  800afc:	38 ca                	cmp    %cl,%dl
  800afe:	75 0a                	jne    800b0a <strfind+0x1f>
  800b00:	eb 12                	jmp    800b14 <strfind+0x29>
  800b02:	38 ca                	cmp    %cl,%dl
  800b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b08:	74 0a                	je     800b14 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b0a:	83 c0 01             	add    $0x1,%eax
  800b0d:	0f b6 10             	movzbl (%eax),%edx
  800b10:	84 d2                	test   %dl,%dl
  800b12:	75 ee                	jne    800b02 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	83 ec 0c             	sub    $0xc,%esp
  800b1c:	89 1c 24             	mov    %ebx,(%esp)
  800b1f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b23:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b27:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b30:	85 c9                	test   %ecx,%ecx
  800b32:	74 30                	je     800b64 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b34:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b3a:	75 25                	jne    800b61 <memset+0x4b>
  800b3c:	f6 c1 03             	test   $0x3,%cl
  800b3f:	75 20                	jne    800b61 <memset+0x4b>
		c &= 0xFF;
  800b41:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b44:	89 d3                	mov    %edx,%ebx
  800b46:	c1 e3 08             	shl    $0x8,%ebx
  800b49:	89 d6                	mov    %edx,%esi
  800b4b:	c1 e6 18             	shl    $0x18,%esi
  800b4e:	89 d0                	mov    %edx,%eax
  800b50:	c1 e0 10             	shl    $0x10,%eax
  800b53:	09 f0                	or     %esi,%eax
  800b55:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b57:	09 d8                	or     %ebx,%eax
  800b59:	c1 e9 02             	shr    $0x2,%ecx
  800b5c:	fc                   	cld    
  800b5d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b5f:	eb 03                	jmp    800b64 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b61:	fc                   	cld    
  800b62:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b64:	89 f8                	mov    %edi,%eax
  800b66:	8b 1c 24             	mov    (%esp),%ebx
  800b69:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b6d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b71:	89 ec                	mov    %ebp,%esp
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	89 34 24             	mov    %esi,(%esp)
  800b7e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b88:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b8b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b8d:	39 c6                	cmp    %eax,%esi
  800b8f:	73 35                	jae    800bc6 <memmove+0x51>
  800b91:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b94:	39 d0                	cmp    %edx,%eax
  800b96:	73 2e                	jae    800bc6 <memmove+0x51>
		s += n;
		d += n;
  800b98:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b9a:	f6 c2 03             	test   $0x3,%dl
  800b9d:	75 1b                	jne    800bba <memmove+0x45>
  800b9f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ba5:	75 13                	jne    800bba <memmove+0x45>
  800ba7:	f6 c1 03             	test   $0x3,%cl
  800baa:	75 0e                	jne    800bba <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800bac:	83 ef 04             	sub    $0x4,%edi
  800baf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bb2:	c1 e9 02             	shr    $0x2,%ecx
  800bb5:	fd                   	std    
  800bb6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb8:	eb 09                	jmp    800bc3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bba:	83 ef 01             	sub    $0x1,%edi
  800bbd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800bc0:	fd                   	std    
  800bc1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bc3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc4:	eb 20                	jmp    800be6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bcc:	75 15                	jne    800be3 <memmove+0x6e>
  800bce:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bd4:	75 0d                	jne    800be3 <memmove+0x6e>
  800bd6:	f6 c1 03             	test   $0x3,%cl
  800bd9:	75 08                	jne    800be3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800bdb:	c1 e9 02             	shr    $0x2,%ecx
  800bde:	fc                   	cld    
  800bdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be1:	eb 03                	jmp    800be6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800be3:	fc                   	cld    
  800be4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800be6:	8b 34 24             	mov    (%esp),%esi
  800be9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bed:	89 ec                	mov    %ebp,%esp
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 04 24             	mov    %eax,(%esp)
  800c0b:	e8 65 ff ff ff       	call   800b75 <memmove>
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	8b 75 08             	mov    0x8(%ebp),%esi
  800c1b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c21:	85 c9                	test   %ecx,%ecx
  800c23:	74 36                	je     800c5b <memcmp+0x49>
		if (*s1 != *s2)
  800c25:	0f b6 06             	movzbl (%esi),%eax
  800c28:	0f b6 1f             	movzbl (%edi),%ebx
  800c2b:	38 d8                	cmp    %bl,%al
  800c2d:	74 20                	je     800c4f <memcmp+0x3d>
  800c2f:	eb 14                	jmp    800c45 <memcmp+0x33>
  800c31:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c36:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c3b:	83 c2 01             	add    $0x1,%edx
  800c3e:	83 e9 01             	sub    $0x1,%ecx
  800c41:	38 d8                	cmp    %bl,%al
  800c43:	74 12                	je     800c57 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c45:	0f b6 c0             	movzbl %al,%eax
  800c48:	0f b6 db             	movzbl %bl,%ebx
  800c4b:	29 d8                	sub    %ebx,%eax
  800c4d:	eb 11                	jmp    800c60 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c4f:	83 e9 01             	sub    $0x1,%ecx
  800c52:	ba 00 00 00 00       	mov    $0x0,%edx
  800c57:	85 c9                	test   %ecx,%ecx
  800c59:	75 d6                	jne    800c31 <memcmp+0x1f>
  800c5b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c6b:	89 c2                	mov    %eax,%edx
  800c6d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c70:	39 d0                	cmp    %edx,%eax
  800c72:	73 15                	jae    800c89 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c78:	38 08                	cmp    %cl,(%eax)
  800c7a:	75 06                	jne    800c82 <memfind+0x1d>
  800c7c:	eb 0b                	jmp    800c89 <memfind+0x24>
  800c7e:	38 08                	cmp    %cl,(%eax)
  800c80:	74 07                	je     800c89 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c82:	83 c0 01             	add    $0x1,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	77 f5                	ja     800c7e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 04             	sub    $0x4,%esp
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c9a:	0f b6 02             	movzbl (%edx),%eax
  800c9d:	3c 20                	cmp    $0x20,%al
  800c9f:	74 04                	je     800ca5 <strtol+0x1a>
  800ca1:	3c 09                	cmp    $0x9,%al
  800ca3:	75 0e                	jne    800cb3 <strtol+0x28>
		s++;
  800ca5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca8:	0f b6 02             	movzbl (%edx),%eax
  800cab:	3c 20                	cmp    $0x20,%al
  800cad:	74 f6                	je     800ca5 <strtol+0x1a>
  800caf:	3c 09                	cmp    $0x9,%al
  800cb1:	74 f2                	je     800ca5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cb3:	3c 2b                	cmp    $0x2b,%al
  800cb5:	75 0c                	jne    800cc3 <strtol+0x38>
		s++;
  800cb7:	83 c2 01             	add    $0x1,%edx
  800cba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cc1:	eb 15                	jmp    800cd8 <strtol+0x4d>
	else if (*s == '-')
  800cc3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cca:	3c 2d                	cmp    $0x2d,%al
  800ccc:	75 0a                	jne    800cd8 <strtol+0x4d>
		s++, neg = 1;
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cd8:	85 db                	test   %ebx,%ebx
  800cda:	0f 94 c0             	sete   %al
  800cdd:	74 05                	je     800ce4 <strtol+0x59>
  800cdf:	83 fb 10             	cmp    $0x10,%ebx
  800ce2:	75 18                	jne    800cfc <strtol+0x71>
  800ce4:	80 3a 30             	cmpb   $0x30,(%edx)
  800ce7:	75 13                	jne    800cfc <strtol+0x71>
  800ce9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ced:	8d 76 00             	lea    0x0(%esi),%esi
  800cf0:	75 0a                	jne    800cfc <strtol+0x71>
		s += 2, base = 16;
  800cf2:	83 c2 02             	add    $0x2,%edx
  800cf5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfa:	eb 15                	jmp    800d11 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cfc:	84 c0                	test   %al,%al
  800cfe:	66 90                	xchg   %ax,%ax
  800d00:	74 0f                	je     800d11 <strtol+0x86>
  800d02:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d07:	80 3a 30             	cmpb   $0x30,(%edx)
  800d0a:	75 05                	jne    800d11 <strtol+0x86>
		s++, base = 8;
  800d0c:	83 c2 01             	add    $0x1,%edx
  800d0f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d18:	0f b6 0a             	movzbl (%edx),%ecx
  800d1b:	89 cf                	mov    %ecx,%edi
  800d1d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d20:	80 fb 09             	cmp    $0x9,%bl
  800d23:	77 08                	ja     800d2d <strtol+0xa2>
			dig = *s - '0';
  800d25:	0f be c9             	movsbl %cl,%ecx
  800d28:	83 e9 30             	sub    $0x30,%ecx
  800d2b:	eb 1e                	jmp    800d4b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d2d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d30:	80 fb 19             	cmp    $0x19,%bl
  800d33:	77 08                	ja     800d3d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d35:	0f be c9             	movsbl %cl,%ecx
  800d38:	83 e9 57             	sub    $0x57,%ecx
  800d3b:	eb 0e                	jmp    800d4b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d3d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d40:	80 fb 19             	cmp    $0x19,%bl
  800d43:	77 15                	ja     800d5a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d45:	0f be c9             	movsbl %cl,%ecx
  800d48:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d4b:	39 f1                	cmp    %esi,%ecx
  800d4d:	7d 0b                	jge    800d5a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d4f:	83 c2 01             	add    $0x1,%edx
  800d52:	0f af c6             	imul   %esi,%eax
  800d55:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d58:	eb be                	jmp    800d18 <strtol+0x8d>
  800d5a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d60:	74 05                	je     800d67 <strtol+0xdc>
		*endptr = (char *) s;
  800d62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d65:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d6b:	74 04                	je     800d71 <strtol+0xe6>
  800d6d:	89 c8                	mov    %ecx,%eax
  800d6f:	f7 d8                	neg    %eax
}
  800d71:	83 c4 04             	add    $0x4,%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    
  800d79:	00 00                	add    %al,(%eax)
	...

00800d7c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
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
  800d92:	b8 01 00 00 00       	mov    $0x1,%eax
  800d97:	89 d1                	mov    %edx,%ecx
  800d99:	89 d3                	mov    %edx,%ebx
  800d9b:	89 d7                	mov    %edx,%edi
  800d9d:	89 d6                	mov    %edx,%esi
  800d9f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800da1:	8b 1c 24             	mov    (%esp),%ebx
  800da4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800da8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dac:	89 ec                	mov    %ebp,%esp
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	89 1c 24             	mov    %ebx,(%esp)
  800db9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dbd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	89 c3                	mov    %eax,%ebx
  800dce:	89 c7                	mov    %eax,%edi
  800dd0:	89 c6                	mov    %eax,%esi
  800dd2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dd4:	8b 1c 24             	mov    (%esp),%ebx
  800dd7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ddb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ddf:	89 ec                	mov    %ebp,%esp
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 38             	sub    $0x38,%esp
  800de9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800def:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df2:	be 00 00 00 00       	mov    $0x0,%esi
  800df7:	b8 12 00 00 00       	mov    $0x12,%eax
  800dfc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	7e 28                	jle    800e36 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e12:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800e19:	00 
  800e1a:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  800e21:	00 
  800e22:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e29:	00 
  800e2a:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  800e31:	e8 06 f4 ff ff       	call   80023c <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800e36:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e39:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e3c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e3f:	89 ec                	mov    %ebp,%esp
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 0c             	sub    $0xc,%esp
  800e49:	89 1c 24             	mov    %ebx,(%esp)
  800e4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e50:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e54:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e59:	b8 11 00 00 00       	mov    $0x11,%eax
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	8b 55 08             	mov    0x8(%ebp),%edx
  800e64:	89 df                	mov    %ebx,%edi
  800e66:	89 de                	mov    %ebx,%esi
  800e68:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800e6a:	8b 1c 24             	mov    (%esp),%ebx
  800e6d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e71:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e75:	89 ec                	mov    %ebp,%esp
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 0c             	sub    $0xc,%esp
  800e7f:	89 1c 24             	mov    %ebx,(%esp)
  800e82:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e86:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8f:	b8 10 00 00 00       	mov    $0x10,%eax
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	89 cb                	mov    %ecx,%ebx
  800e99:	89 cf                	mov    %ecx,%edi
  800e9b:	89 ce                	mov    %ecx,%esi
  800e9d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800e9f:	8b 1c 24             	mov    (%esp),%ebx
  800ea2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ea6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eaa:	89 ec                	mov    %ebp,%esp
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    

00800eae <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 38             	sub    $0x38,%esp
  800eb4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800eb7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ec7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eca:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecd:	89 df                	mov    %ebx,%edi
  800ecf:	89 de                	mov    %ebx,%esi
  800ed1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	7e 28                	jle    800eff <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800edb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ee2:	00 
  800ee3:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  800eea:	00 
  800eeb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef2:	00 
  800ef3:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  800efa:	e8 3d f3 ff ff       	call   80023c <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800eff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f02:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f05:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f08:	89 ec                	mov    %ebp,%esp
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 0c             	sub    $0xc,%esp
  800f12:	89 1c 24             	mov    %ebx,(%esp)
  800f15:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f19:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f22:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f27:	89 d1                	mov    %edx,%ecx
  800f29:	89 d3                	mov    %edx,%ebx
  800f2b:	89 d7                	mov    %edx,%edi
  800f2d:	89 d6                	mov    %edx,%esi
  800f2f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800f31:	8b 1c 24             	mov    (%esp),%ebx
  800f34:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f38:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f3c:	89 ec                	mov    %ebp,%esp
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 38             	sub    $0x38,%esp
  800f46:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f49:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f4c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f54:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	89 cb                	mov    %ecx,%ebx
  800f5e:	89 cf                	mov    %ecx,%edi
  800f60:	89 ce                	mov    %ecx,%esi
  800f62:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7e 28                	jle    800f90 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f68:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f73:	00 
  800f74:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  800f7b:	00 
  800f7c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f83:	00 
  800f84:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  800f8b:	e8 ac f2 ff ff       	call   80023c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f90:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f93:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f96:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f99:	89 ec                	mov    %ebp,%esp
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	83 ec 0c             	sub    $0xc,%esp
  800fa3:	89 1c 24             	mov    %ebx,(%esp)
  800fa6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800faa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fae:	be 00 00 00 00       	mov    $0x0,%esi
  800fb3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fb8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc6:	8b 1c 24             	mov    (%esp),%ebx
  800fc9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fcd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fd1:	89 ec                	mov    %ebp,%esp
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 38             	sub    $0x38,%esp
  800fdb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fde:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff4:	89 df                	mov    %ebx,%edi
  800ff6:	89 de                	mov    %ebx,%esi
  800ff8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	7e 28                	jle    801026 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801002:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801009:	00 
  80100a:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  801011:	00 
  801012:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801019:	00 
  80101a:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  801021:	e8 16 f2 ff ff       	call   80023c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801026:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801029:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80102c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80102f:	89 ec                	mov    %ebp,%esp
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 38             	sub    $0x38,%esp
  801039:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80103c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80103f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801042:	bb 00 00 00 00       	mov    $0x0,%ebx
  801047:	b8 09 00 00 00       	mov    $0x9,%eax
  80104c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	89 df                	mov    %ebx,%edi
  801054:	89 de                	mov    %ebx,%esi
  801056:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801058:	85 c0                	test   %eax,%eax
  80105a:	7e 28                	jle    801084 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80105c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801060:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801067:	00 
  801068:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  80106f:	00 
  801070:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801077:	00 
  801078:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  80107f:	e8 b8 f1 ff ff       	call   80023c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801084:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801087:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80108a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80108d:	89 ec                	mov    %ebp,%esp
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    

00801091 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 38             	sub    $0x38,%esp
  801097:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80109a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80109d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8010aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	89 df                	mov    %ebx,%edi
  8010b2:	89 de                	mov    %ebx,%esi
  8010b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	7e 28                	jle    8010e2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010be:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010c5:	00 
  8010c6:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  8010cd:	00 
  8010ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d5:	00 
  8010d6:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  8010dd:	e8 5a f1 ff ff       	call   80023c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010eb:	89 ec                	mov    %ebp,%esp
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    

008010ef <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	83 ec 38             	sub    $0x38,%esp
  8010f5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010f8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010fb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801103:	b8 06 00 00 00       	mov    $0x6,%eax
  801108:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	89 df                	mov    %ebx,%edi
  801110:	89 de                	mov    %ebx,%esi
  801112:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801114:	85 c0                	test   %eax,%eax
  801116:	7e 28                	jle    801140 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801118:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801123:	00 
  801124:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  80112b:	00 
  80112c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801133:	00 
  801134:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  80113b:	e8 fc f0 ff ff       	call   80023c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801140:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801143:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801146:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801149:	89 ec                	mov    %ebp,%esp
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    

0080114d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 38             	sub    $0x38,%esp
  801153:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801156:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801159:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115c:	b8 05 00 00 00       	mov    $0x5,%eax
  801161:	8b 75 18             	mov    0x18(%ebp),%esi
  801164:	8b 7d 14             	mov    0x14(%ebp),%edi
  801167:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80116a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116d:	8b 55 08             	mov    0x8(%ebp),%edx
  801170:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801172:	85 c0                	test   %eax,%eax
  801174:	7e 28                	jle    80119e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801176:	89 44 24 10          	mov    %eax,0x10(%esp)
  80117a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801181:	00 
  801182:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  801189:	00 
  80118a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801191:	00 
  801192:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  801199:	e8 9e f0 ff ff       	call   80023c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80119e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011a1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011a7:	89 ec                	mov    %ebp,%esp
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 38             	sub    $0x38,%esp
  8011b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ba:	be 00 00 00 00       	mov    $0x0,%esi
  8011bf:	b8 04 00 00 00       	mov    $0x4,%eax
  8011c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cd:	89 f7                	mov    %esi,%edi
  8011cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	7e 28                	jle    8011fd <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8011e0:	00 
  8011e1:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  8011e8:	00 
  8011e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f0:	00 
  8011f1:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  8011f8:	e8 3f f0 ff ff       	call   80023c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801200:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801203:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801206:	89 ec                	mov    %ebp,%esp
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    

0080120a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	83 ec 0c             	sub    $0xc,%esp
  801210:	89 1c 24             	mov    %ebx,(%esp)
  801213:	89 74 24 04          	mov    %esi,0x4(%esp)
  801217:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
  801220:	b8 0b 00 00 00       	mov    $0xb,%eax
  801225:	89 d1                	mov    %edx,%ecx
  801227:	89 d3                	mov    %edx,%ebx
  801229:	89 d7                	mov    %edx,%edi
  80122b:	89 d6                	mov    %edx,%esi
  80122d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80122f:	8b 1c 24             	mov    (%esp),%ebx
  801232:	8b 74 24 04          	mov    0x4(%esp),%esi
  801236:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80123a:	89 ec                	mov    %ebp,%esp
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    

0080123e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 0c             	sub    $0xc,%esp
  801244:	89 1c 24             	mov    %ebx,(%esp)
  801247:	89 74 24 04          	mov    %esi,0x4(%esp)
  80124b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80124f:	ba 00 00 00 00       	mov    $0x0,%edx
  801254:	b8 02 00 00 00       	mov    $0x2,%eax
  801259:	89 d1                	mov    %edx,%ecx
  80125b:	89 d3                	mov    %edx,%ebx
  80125d:	89 d7                	mov    %edx,%edi
  80125f:	89 d6                	mov    %edx,%esi
  801261:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801263:	8b 1c 24             	mov    (%esp),%ebx
  801266:	8b 74 24 04          	mov    0x4(%esp),%esi
  80126a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80126e:	89 ec                	mov    %ebp,%esp
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 38             	sub    $0x38,%esp
  801278:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80127b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80127e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801281:	b9 00 00 00 00       	mov    $0x0,%ecx
  801286:	b8 03 00 00 00       	mov    $0x3,%eax
  80128b:	8b 55 08             	mov    0x8(%ebp),%edx
  80128e:	89 cb                	mov    %ecx,%ebx
  801290:	89 cf                	mov    %ecx,%edi
  801292:	89 ce                	mov    %ecx,%esi
  801294:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801296:	85 c0                	test   %eax,%eax
  801298:	7e 28                	jle    8012c2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80129a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80129e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8012a5:	00 
  8012a6:	c7 44 24 08 3f 2e 80 	movl   $0x802e3f,0x8(%esp)
  8012ad:	00 
  8012ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012b5:	00 
  8012b6:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  8012bd:	e8 7a ef ff ff       	call   80023c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012c5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012cb:	89 ec                	mov    %ebp,%esp
  8012cd:	5d                   	pop    %ebp
  8012ce:	c3                   	ret    
	...

008012d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012db:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	89 04 24             	mov    %eax,(%esp)
  8012ec:	e8 df ff ff ff       	call   8012d0 <fd2num>
  8012f1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8012f6:	c1 e0 0c             	shl    $0xc,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	57                   	push   %edi
  8012ff:	56                   	push   %esi
  801300:	53                   	push   %ebx
  801301:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801304:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801309:	a8 01                	test   $0x1,%al
  80130b:	74 36                	je     801343 <fd_alloc+0x48>
  80130d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801312:	a8 01                	test   $0x1,%al
  801314:	74 2d                	je     801343 <fd_alloc+0x48>
  801316:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80131b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801320:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801325:	89 c3                	mov    %eax,%ebx
  801327:	89 c2                	mov    %eax,%edx
  801329:	c1 ea 16             	shr    $0x16,%edx
  80132c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80132f:	f6 c2 01             	test   $0x1,%dl
  801332:	74 14                	je     801348 <fd_alloc+0x4d>
  801334:	89 c2                	mov    %eax,%edx
  801336:	c1 ea 0c             	shr    $0xc,%edx
  801339:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80133c:	f6 c2 01             	test   $0x1,%dl
  80133f:	75 10                	jne    801351 <fd_alloc+0x56>
  801341:	eb 05                	jmp    801348 <fd_alloc+0x4d>
  801343:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801348:	89 1f                	mov    %ebx,(%edi)
  80134a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80134f:	eb 17                	jmp    801368 <fd_alloc+0x6d>
  801351:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801356:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80135b:	75 c8                	jne    801325 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80135d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801363:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801368:	5b                   	pop    %ebx
  801369:	5e                   	pop    %esi
  80136a:	5f                   	pop    %edi
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	83 f8 1f             	cmp    $0x1f,%eax
  801376:	77 36                	ja     8013ae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801378:	05 00 00 0d 00       	add    $0xd0000,%eax
  80137d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801380:	89 c2                	mov    %eax,%edx
  801382:	c1 ea 16             	shr    $0x16,%edx
  801385:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80138c:	f6 c2 01             	test   $0x1,%dl
  80138f:	74 1d                	je     8013ae <fd_lookup+0x41>
  801391:	89 c2                	mov    %eax,%edx
  801393:	c1 ea 0c             	shr    $0xc,%edx
  801396:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139d:	f6 c2 01             	test   $0x1,%dl
  8013a0:	74 0c                	je     8013ae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a5:	89 02                	mov    %eax,(%edx)
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8013ac:	eb 05                	jmp    8013b3 <fd_lookup+0x46>
  8013ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    

008013b5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013bb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	89 04 24             	mov    %eax,(%esp)
  8013c8:	e8 a0 ff ff ff       	call   80136d <fd_lookup>
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 0e                	js     8013df <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d7:	89 50 04             	mov    %edx,0x4(%eax)
  8013da:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 10             	sub    $0x10,%esp
  8013e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8013ef:	b8 08 60 80 00       	mov    $0x806008,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8013f4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013f9:	be e8 2e 80 00       	mov    $0x802ee8,%esi
		if (devtab[i]->dev_id == dev_id) {
  8013fe:	39 08                	cmp    %ecx,(%eax)
  801400:	75 10                	jne    801412 <dev_lookup+0x31>
  801402:	eb 04                	jmp    801408 <dev_lookup+0x27>
  801404:	39 08                	cmp    %ecx,(%eax)
  801406:	75 0a                	jne    801412 <dev_lookup+0x31>
			*dev = devtab[i];
  801408:	89 03                	mov    %eax,(%ebx)
  80140a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80140f:	90                   	nop
  801410:	eb 31                	jmp    801443 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801412:	83 c2 01             	add    $0x1,%edx
  801415:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	75 e8                	jne    801404 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80141c:	a1 7c 60 80 00       	mov    0x80607c,%eax
  801421:	8b 40 4c             	mov    0x4c(%eax),%eax
  801424:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142c:	c7 04 24 6c 2e 80 00 	movl   $0x802e6c,(%esp)
  801433:	e8 c9 ee ff ff       	call   800301 <cprintf>
	*dev = 0;
  801438:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80143e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	5b                   	pop    %ebx
  801447:	5e                   	pop    %esi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    

0080144a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	53                   	push   %ebx
  80144e:	83 ec 24             	sub    $0x24,%esp
  801451:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801454:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	89 04 24             	mov    %eax,(%esp)
  801461:	e8 07 ff ff ff       	call   80136d <fd_lookup>
  801466:	85 c0                	test   %eax,%eax
  801468:	78 53                	js     8014bd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801474:	8b 00                	mov    (%eax),%eax
  801476:	89 04 24             	mov    %eax,(%esp)
  801479:	e8 63 ff ff ff       	call   8013e1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 3b                	js     8014bd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801482:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801487:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80148e:	74 2d                	je     8014bd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801490:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801493:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80149a:	00 00 00 
	stat->st_isdir = 0;
  80149d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014a4:	00 00 00 
	stat->st_dev = dev;
  8014a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014aa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014b7:	89 14 24             	mov    %edx,(%esp)
  8014ba:	ff 50 14             	call   *0x14(%eax)
}
  8014bd:	83 c4 24             	add    $0x24,%esp
  8014c0:	5b                   	pop    %ebx
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	53                   	push   %ebx
  8014c7:	83 ec 24             	sub    $0x24,%esp
  8014ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d4:	89 1c 24             	mov    %ebx,(%esp)
  8014d7:	e8 91 fe ff ff       	call   80136d <fd_lookup>
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 5f                	js     80153f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ea:	8b 00                	mov    (%eax),%eax
  8014ec:	89 04 24             	mov    %eax,(%esp)
  8014ef:	e8 ed fe ff ff       	call   8013e1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	78 47                	js     80153f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014fb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014ff:	75 23                	jne    801524 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801501:	a1 7c 60 80 00       	mov    0x80607c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801506:	8b 40 4c             	mov    0x4c(%eax),%eax
  801509:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80150d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801511:	c7 04 24 8c 2e 80 00 	movl   $0x802e8c,(%esp)
  801518:	e8 e4 ed ff ff       	call   800301 <cprintf>
  80151d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801522:	eb 1b                	jmp    80153f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801527:	8b 48 18             	mov    0x18(%eax),%ecx
  80152a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80152f:	85 c9                	test   %ecx,%ecx
  801531:	74 0c                	je     80153f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153a:	89 14 24             	mov    %edx,(%esp)
  80153d:	ff d1                	call   *%ecx
}
  80153f:	83 c4 24             	add    $0x24,%esp
  801542:	5b                   	pop    %ebx
  801543:	5d                   	pop    %ebp
  801544:	c3                   	ret    

00801545 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	53                   	push   %ebx
  801549:	83 ec 24             	sub    $0x24,%esp
  80154c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801552:	89 44 24 04          	mov    %eax,0x4(%esp)
  801556:	89 1c 24             	mov    %ebx,(%esp)
  801559:	e8 0f fe ff ff       	call   80136d <fd_lookup>
  80155e:	85 c0                	test   %eax,%eax
  801560:	78 66                	js     8015c8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801562:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801565:	89 44 24 04          	mov    %eax,0x4(%esp)
  801569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156c:	8b 00                	mov    (%eax),%eax
  80156e:	89 04 24             	mov    %eax,(%esp)
  801571:	e8 6b fe ff ff       	call   8013e1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801576:	85 c0                	test   %eax,%eax
  801578:	78 4e                	js     8015c8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801581:	75 23                	jne    8015a6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801583:	a1 7c 60 80 00       	mov    0x80607c,%eax
  801588:	8b 40 4c             	mov    0x4c(%eax),%eax
  80158b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80158f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801593:	c7 04 24 ad 2e 80 00 	movl   $0x802ead,(%esp)
  80159a:	e8 62 ed ff ff       	call   800301 <cprintf>
  80159f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8015a4:	eb 22                	jmp    8015c8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8015ac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b1:	85 c9                	test   %ecx,%ecx
  8015b3:	74 13                	je     8015c8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c3:	89 14 24             	mov    %edx,(%esp)
  8015c6:	ff d1                	call   *%ecx
}
  8015c8:	83 c4 24             	add    $0x24,%esp
  8015cb:	5b                   	pop    %ebx
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 24             	sub    $0x24,%esp
  8015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015df:	89 1c 24             	mov    %ebx,(%esp)
  8015e2:	e8 86 fd ff ff       	call   80136d <fd_lookup>
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 6b                	js     801656 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	8b 00                	mov    (%eax),%eax
  8015f7:	89 04 24             	mov    %eax,(%esp)
  8015fa:	e8 e2 fd ff ff       	call   8013e1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 53                	js     801656 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801603:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801606:	8b 42 08             	mov    0x8(%edx),%eax
  801609:	83 e0 03             	and    $0x3,%eax
  80160c:	83 f8 01             	cmp    $0x1,%eax
  80160f:	75 23                	jne    801634 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801611:	a1 7c 60 80 00       	mov    0x80607c,%eax
  801616:	8b 40 4c             	mov    0x4c(%eax),%eax
  801619:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80161d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801621:	c7 04 24 ca 2e 80 00 	movl   $0x802eca,(%esp)
  801628:	e8 d4 ec ff ff       	call   800301 <cprintf>
  80162d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801632:	eb 22                	jmp    801656 <read+0x88>
	}
	if (!dev->dev_read)
  801634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801637:	8b 48 08             	mov    0x8(%eax),%ecx
  80163a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80163f:	85 c9                	test   %ecx,%ecx
  801641:	74 13                	je     801656 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801643:	8b 45 10             	mov    0x10(%ebp),%eax
  801646:	89 44 24 08          	mov    %eax,0x8(%esp)
  80164a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801651:	89 14 24             	mov    %edx,(%esp)
  801654:	ff d1                	call   *%ecx
}
  801656:	83 c4 24             	add    $0x24,%esp
  801659:	5b                   	pop    %ebx
  80165a:	5d                   	pop    %ebp
  80165b:	c3                   	ret    

0080165c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	57                   	push   %edi
  801660:	56                   	push   %esi
  801661:	53                   	push   %ebx
  801662:	83 ec 1c             	sub    $0x1c,%esp
  801665:	8b 7d 08             	mov    0x8(%ebp),%edi
  801668:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80166b:	ba 00 00 00 00       	mov    $0x0,%edx
  801670:	bb 00 00 00 00       	mov    $0x0,%ebx
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
  80167a:	85 f6                	test   %esi,%esi
  80167c:	74 29                	je     8016a7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80167e:	89 f0                	mov    %esi,%eax
  801680:	29 d0                	sub    %edx,%eax
  801682:	89 44 24 08          	mov    %eax,0x8(%esp)
  801686:	03 55 0c             	add    0xc(%ebp),%edx
  801689:	89 54 24 04          	mov    %edx,0x4(%esp)
  80168d:	89 3c 24             	mov    %edi,(%esp)
  801690:	e8 39 ff ff ff       	call   8015ce <read>
		if (m < 0)
  801695:	85 c0                	test   %eax,%eax
  801697:	78 0e                	js     8016a7 <readn+0x4b>
			return m;
		if (m == 0)
  801699:	85 c0                	test   %eax,%eax
  80169b:	74 08                	je     8016a5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80169d:	01 c3                	add    %eax,%ebx
  80169f:	89 da                	mov    %ebx,%edx
  8016a1:	39 f3                	cmp    %esi,%ebx
  8016a3:	72 d9                	jb     80167e <readn+0x22>
  8016a5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016a7:	83 c4 1c             	add    $0x1c,%esp
  8016aa:	5b                   	pop    %ebx
  8016ab:	5e                   	pop    %esi
  8016ac:	5f                   	pop    %edi
  8016ad:	5d                   	pop    %ebp
  8016ae:	c3                   	ret    

008016af <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 20             	sub    $0x20,%esp
  8016b7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016ba:	89 34 24             	mov    %esi,(%esp)
  8016bd:	e8 0e fc ff ff       	call   8012d0 <fd2num>
  8016c2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016c9:	89 04 24             	mov    %eax,(%esp)
  8016cc:	e8 9c fc ff ff       	call   80136d <fd_lookup>
  8016d1:	89 c3                	mov    %eax,%ebx
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	78 05                	js     8016dc <fd_close+0x2d>
  8016d7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016da:	74 0c                	je     8016e8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8016dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e0:	19 c0                	sbb    %eax,%eax
  8016e2:	f7 d0                	not    %eax
  8016e4:	21 c3                	and    %eax,%ebx
  8016e6:	eb 3d                	jmp    801725 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ef:	8b 06                	mov    (%esi),%eax
  8016f1:	89 04 24             	mov    %eax,(%esp)
  8016f4:	e8 e8 fc ff ff       	call   8013e1 <dev_lookup>
  8016f9:	89 c3                	mov    %eax,%ebx
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 16                	js     801715 <fd_close+0x66>
		if (dev->dev_close)
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	8b 40 10             	mov    0x10(%eax),%eax
  801705:	bb 00 00 00 00       	mov    $0x0,%ebx
  80170a:	85 c0                	test   %eax,%eax
  80170c:	74 07                	je     801715 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80170e:	89 34 24             	mov    %esi,(%esp)
  801711:	ff d0                	call   *%eax
  801713:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801715:	89 74 24 04          	mov    %esi,0x4(%esp)
  801719:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801720:	e8 ca f9 ff ff       	call   8010ef <sys_page_unmap>
	return r;
}
  801725:	89 d8                	mov    %ebx,%eax
  801727:	83 c4 20             	add    $0x20,%esp
  80172a:	5b                   	pop    %ebx
  80172b:	5e                   	pop    %esi
  80172c:	5d                   	pop    %ebp
  80172d:	c3                   	ret    

0080172e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801734:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801737:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	89 04 24             	mov    %eax,(%esp)
  801741:	e8 27 fc ff ff       	call   80136d <fd_lookup>
  801746:	85 c0                	test   %eax,%eax
  801748:	78 13                	js     80175d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80174a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801751:	00 
  801752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801755:	89 04 24             	mov    %eax,(%esp)
  801758:	e8 52 ff ff ff       	call   8016af <fd_close>
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 18             	sub    $0x18,%esp
  801765:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801768:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80176b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801772:	00 
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	89 04 24             	mov    %eax,(%esp)
  801779:	e8 55 03 00 00       	call   801ad3 <open>
  80177e:	89 c3                	mov    %eax,%ebx
  801780:	85 c0                	test   %eax,%eax
  801782:	78 1b                	js     80179f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801784:	8b 45 0c             	mov    0xc(%ebp),%eax
  801787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178b:	89 1c 24             	mov    %ebx,(%esp)
  80178e:	e8 b7 fc ff ff       	call   80144a <fstat>
  801793:	89 c6                	mov    %eax,%esi
	close(fd);
  801795:	89 1c 24             	mov    %ebx,(%esp)
  801798:	e8 91 ff ff ff       	call   80172e <close>
  80179d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80179f:	89 d8                	mov    %ebx,%eax
  8017a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8017a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8017a7:	89 ec                	mov    %ebp,%esp
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    

008017ab <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	53                   	push   %ebx
  8017af:	83 ec 14             	sub    $0x14,%esp
  8017b2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8017b7:	89 1c 24             	mov    %ebx,(%esp)
  8017ba:	e8 6f ff ff ff       	call   80172e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017bf:	83 c3 01             	add    $0x1,%ebx
  8017c2:	83 fb 20             	cmp    $0x20,%ebx
  8017c5:	75 f0                	jne    8017b7 <close_all+0xc>
		close(i);
}
  8017c7:	83 c4 14             	add    $0x14,%esp
  8017ca:	5b                   	pop    %ebx
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    

008017cd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 58             	sub    $0x58,%esp
  8017d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	89 04 24             	mov    %eax,(%esp)
  8017ec:	e8 7c fb ff ff       	call   80136d <fd_lookup>
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	0f 88 e0 00 00 00    	js     8018db <dup+0x10e>
		return r;
	close(newfdnum);
  8017fb:	89 3c 24             	mov    %edi,(%esp)
  8017fe:	e8 2b ff ff ff       	call   80172e <close>

	newfd = INDEX2FD(newfdnum);
  801803:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801809:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80180c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180f:	89 04 24             	mov    %eax,(%esp)
  801812:	e8 c9 fa ff ff       	call   8012e0 <fd2data>
  801817:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801819:	89 34 24             	mov    %esi,(%esp)
  80181c:	e8 bf fa ff ff       	call   8012e0 <fd2data>
  801821:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801824:	89 da                	mov    %ebx,%edx
  801826:	89 d8                	mov    %ebx,%eax
  801828:	c1 e8 16             	shr    $0x16,%eax
  80182b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801832:	a8 01                	test   $0x1,%al
  801834:	74 43                	je     801879 <dup+0xac>
  801836:	c1 ea 0c             	shr    $0xc,%edx
  801839:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801840:	a8 01                	test   $0x1,%al
  801842:	74 35                	je     801879 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801844:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80184b:	25 07 0e 00 00       	and    $0xe07,%eax
  801850:	89 44 24 10          	mov    %eax,0x10(%esp)
  801854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801857:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80185b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801862:	00 
  801863:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801867:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80186e:	e8 da f8 ff ff       	call   80114d <sys_page_map>
  801873:	89 c3                	mov    %eax,%ebx
  801875:	85 c0                	test   %eax,%eax
  801877:	78 3f                	js     8018b8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80187c:	89 c2                	mov    %eax,%edx
  80187e:	c1 ea 0c             	shr    $0xc,%edx
  801881:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801888:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80188e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801892:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801896:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80189d:	00 
  80189e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a9:	e8 9f f8 ff ff       	call   80114d <sys_page_map>
  8018ae:	89 c3                	mov    %eax,%ebx
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	78 04                	js     8018b8 <dup+0xeb>
  8018b4:	89 fb                	mov    %edi,%ebx
  8018b6:	eb 23                	jmp    8018db <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018c3:	e8 27 f8 ff ff       	call   8010ef <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d6:	e8 14 f8 ff ff       	call   8010ef <sys_page_unmap>
	return r;
}
  8018db:	89 d8                	mov    %ebx,%eax
  8018dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018e0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018e6:	89 ec                	mov    %ebp,%esp
  8018e8:	5d                   	pop    %ebp
  8018e9:	c3                   	ret    
	...

008018ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 14             	sub    $0x14,%esp
  8018f3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018f5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8018fb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801902:	00 
  801903:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80190a:	00 
  80190b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190f:	89 14 24             	mov    %edx,(%esp)
  801912:	e8 f9 0d 00 00       	call   802710 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801917:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80191e:	00 
  80191f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801923:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80192a:	e8 47 0e 00 00       	call   802776 <ipc_recv>
}
  80192f:	83 c4 14             	add    $0x14,%esp
  801932:	5b                   	pop    %ebx
  801933:	5d                   	pop    %ebp
  801934:	c3                   	ret    

00801935 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8b 40 0c             	mov    0xc(%eax),%eax
  801941:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80194e:	ba 00 00 00 00       	mov    $0x0,%edx
  801953:	b8 02 00 00 00       	mov    $0x2,%eax
  801958:	e8 8f ff ff ff       	call   8018ec <fsipc>
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	8b 40 0c             	mov    0xc(%eax),%eax
  80196b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801970:	ba 00 00 00 00       	mov    $0x0,%edx
  801975:	b8 06 00 00 00       	mov    $0x6,%eax
  80197a:	e8 6d ff ff ff       	call   8018ec <fsipc>
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801987:	ba 00 00 00 00       	mov    $0x0,%edx
  80198c:	b8 08 00 00 00       	mov    $0x8,%eax
  801991:	e8 56 ff ff ff       	call   8018ec <fsipc>
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	53                   	push   %ebx
  80199c:	83 ec 14             	sub    $0x14,%esp
  80199f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a8:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b2:	b8 05 00 00 00       	mov    $0x5,%eax
  8019b7:	e8 30 ff ff ff       	call   8018ec <fsipc>
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 2b                	js     8019eb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019c0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8019c7:	00 
  8019c8:	89 1c 24             	mov    %ebx,(%esp)
  8019cb:	e8 ea ef ff ff       	call   8009ba <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019d0:	a1 80 30 80 00       	mov    0x803080,%eax
  8019d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019db:	a1 84 30 80 00       	mov    0x803084,%eax
  8019e0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8019eb:	83 c4 14             	add    $0x14,%esp
  8019ee:	5b                   	pop    %ebx
  8019ef:	5d                   	pop    %ebp
  8019f0:	c3                   	ret    

008019f1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	83 ec 18             	sub    $0x18,%esp
  8019f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fa:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019ff:	76 05                	jbe    801a06 <devfile_write+0x15>
  801a01:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a06:	8b 55 08             	mov    0x8(%ebp),%edx
  801a09:	8b 52 0c             	mov    0xc(%edx),%edx
  801a0c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801a12:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801a17:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a22:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801a29:	e8 47 f1 ff ff       	call   800b75 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a33:	b8 04 00 00 00       	mov    $0x4,%eax
  801a38:	e8 af fe ff ff       	call   8018ec <fsipc>
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	53                   	push   %ebx
  801a43:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801a51:	8b 45 10             	mov    0x10(%ebp),%eax
  801a54:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801a59:	ba 00 30 80 00       	mov    $0x803000,%edx
  801a5e:	b8 03 00 00 00       	mov    $0x3,%eax
  801a63:	e8 84 fe ff ff       	call   8018ec <fsipc>
  801a68:	89 c3                	mov    %eax,%ebx
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	78 17                	js     801a85 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801a6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a72:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a79:	00 
  801a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7d:	89 04 24             	mov    %eax,(%esp)
  801a80:	e8 f0 f0 ff ff       	call   800b75 <memmove>
	return r;
}
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	83 c4 14             	add    $0x14,%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	53                   	push   %ebx
  801a91:	83 ec 14             	sub    $0x14,%esp
  801a94:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a97:	89 1c 24             	mov    %ebx,(%esp)
  801a9a:	e8 d1 ee ff ff       	call   800970 <strlen>
  801a9f:	89 c2                	mov    %eax,%edx
  801aa1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801aa6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801aac:	7f 1f                	jg     801acd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801aae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ab2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801ab9:	e8 fc ee ff ff       	call   8009ba <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801abe:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac3:	b8 07 00 00 00       	mov    $0x7,%eax
  801ac8:	e8 1f fe ff ff       	call   8018ec <fsipc>
}
  801acd:	83 c4 14             	add    $0x14,%esp
  801ad0:	5b                   	pop    %ebx
  801ad1:	5d                   	pop    %ebp
  801ad2:	c3                   	ret    

00801ad3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 28             	sub    $0x28,%esp
  801ad9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801adc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801adf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801ae2:	89 34 24             	mov    %esi,(%esp)
  801ae5:	e8 86 ee ff ff       	call   800970 <strlen>
  801aea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801af4:	7f 5e                	jg     801b54 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af9:	89 04 24             	mov    %eax,(%esp)
  801afc:	e8 fa f7 ff ff       	call   8012fb <fd_alloc>
  801b01:	89 c3                	mov    %eax,%ebx
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 4d                	js     801b54 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801b07:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b0b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801b12:	e8 a3 ee ff ff       	call   8009ba <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b22:	b8 01 00 00 00       	mov    $0x1,%eax
  801b27:	e8 c0 fd ff ff       	call   8018ec <fsipc>
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	79 15                	jns    801b47 <open+0x74>
	{
		fd_close(fd,0);
  801b32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b39:	00 
  801b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3d:	89 04 24             	mov    %eax,(%esp)
  801b40:	e8 6a fb ff ff       	call   8016af <fd_close>
		return r; 
  801b45:	eb 0d                	jmp    801b54 <open+0x81>
	}
	return fd2num(fd);
  801b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4a:	89 04 24             	mov    %eax,(%esp)
  801b4d:	e8 7e f7 ff ff       	call   8012d0 <fd2num>
  801b52:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801b54:	89 d8                	mov    %ebx,%eax
  801b56:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b59:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b5c:	89 ec                	mov    %ebp,%esp
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    

00801b60 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	53                   	push   %ebx
  801b64:	83 ec 14             	sub    $0x14,%esp
  801b67:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b69:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b6d:	7e 34                	jle    801ba3 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b6f:	8b 40 04             	mov    0x4(%eax),%eax
  801b72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b76:	8d 43 10             	lea    0x10(%ebx),%eax
  801b79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7d:	8b 03                	mov    (%ebx),%eax
  801b7f:	89 04 24             	mov    %eax,(%esp)
  801b82:	e8 be f9 ff ff       	call   801545 <write>
		if (result > 0)
  801b87:	85 c0                	test   %eax,%eax
  801b89:	7e 03                	jle    801b8e <writebuf+0x2e>
			b->result += result;
  801b8b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b8e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b91:	74 10                	je     801ba3 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801b93:	85 c0                	test   %eax,%eax
  801b95:	0f 9f c2             	setg   %dl
  801b98:	0f b6 d2             	movzbl %dl,%edx
  801b9b:	83 ea 01             	sub    $0x1,%edx
  801b9e:	21 d0                	and    %edx,%eax
  801ba0:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801ba3:	83 c4 14             	add    $0x14,%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801bbb:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801bc2:	00 00 00 
	b.result = 0;
  801bc5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bcc:	00 00 00 
	b.error = 1;
  801bcf:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801bd6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bdc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf1:	c7 04 24 66 1c 80 00 	movl   $0x801c66,(%esp)
  801bf8:	e8 b0 e8 ff ff       	call   8004ad <vprintfmt>
	if (b.idx > 0)
  801bfd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c04:	7e 0b                	jle    801c11 <vfprintf+0x68>
		writebuf(&b);
  801c06:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c0c:	e8 4f ff ff ff       	call   801b60 <writebuf>

	return (b.result ? b.result : b.error);
  801c11:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c17:	85 c0                	test   %eax,%eax
  801c19:	75 06                	jne    801c21 <vfprintf+0x78>
  801c1b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801c29:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801c2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c3e:	e8 66 ff ff ff       	call   801ba9 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801c4b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	89 04 24             	mov    %eax,(%esp)
  801c5f:	e8 45 ff ff ff       	call   801ba9 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	53                   	push   %ebx
  801c6a:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801c6d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c70:	8b 43 04             	mov    0x4(%ebx),%eax
  801c73:	8b 55 08             	mov    0x8(%ebp),%edx
  801c76:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c7a:	83 c0 01             	add    $0x1,%eax
  801c7d:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801c80:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c85:	75 0e                	jne    801c95 <putch+0x2f>
		writebuf(b);
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	e8 d2 fe ff ff       	call   801b60 <writebuf>
		b->idx = 0;
  801c8e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c95:	83 c4 04             	add    $0x4,%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    
  801c9b:	00 00                	add    %al,(%eax)
  801c9d:	00 00                	add    %al,(%eax)
	...

00801ca0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ca6:	c7 44 24 04 fc 2e 80 	movl   $0x802efc,0x4(%esp)
  801cad:	00 
  801cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb1:	89 04 24             	mov    %eax,(%esp)
  801cb4:	e8 01 ed ff ff       	call   8009ba <strcpy>
	return 0;
}
  801cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccc:	89 04 24             	mov    %eax,(%esp)
  801ccf:	e8 9e 02 00 00       	call   801f72 <nsipc_close>
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cdc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ce3:	00 
  801ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf8:	89 04 24             	mov    %eax,(%esp)
  801cfb:	e8 ae 02 00 00       	call   801fae <nsipc_send>
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d08:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d0f:	00 
  801d10:	8b 45 10             	mov    0x10(%ebp),%eax
  801d13:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	8b 40 0c             	mov    0xc(%eax),%eax
  801d24:	89 04 24             	mov    %eax,(%esp)
  801d27:	e8 f5 02 00 00       	call   802021 <nsipc_recv>
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	56                   	push   %esi
  801d32:	53                   	push   %ebx
  801d33:	83 ec 20             	sub    $0x20,%esp
  801d36:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3b:	89 04 24             	mov    %eax,(%esp)
  801d3e:	e8 b8 f5 ff ff       	call   8012fb <fd_alloc>
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	85 c0                	test   %eax,%eax
  801d47:	78 21                	js     801d6a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801d49:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d50:	00 
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d5f:	e8 47 f4 ff ff       	call   8011ab <sys_page_alloc>
  801d64:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d66:	85 c0                	test   %eax,%eax
  801d68:	79 0a                	jns    801d74 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801d6a:	89 34 24             	mov    %esi,(%esp)
  801d6d:	e8 00 02 00 00       	call   801f72 <nsipc_close>
		return r;
  801d72:	eb 28                	jmp    801d9c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d74:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d92:	89 04 24             	mov    %eax,(%esp)
  801d95:	e8 36 f5 ff ff       	call   8012d0 <fd2num>
  801d9a:	89 c3                	mov    %eax,%ebx
}
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	83 c4 20             	add    $0x20,%esp
  801da1:	5b                   	pop    %ebx
  801da2:	5e                   	pop    %esi
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    

00801da5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801dab:	8b 45 10             	mov    0x10(%ebp),%eax
  801dae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	89 04 24             	mov    %eax,(%esp)
  801dbf:	e8 62 01 00 00       	call   801f26 <nsipc_socket>
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	78 05                	js     801dcd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801dc8:	e8 61 ff ff ff       	call   801d2e <alloc_sockfd>
}
  801dcd:	c9                   	leave  
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	c3                   	ret    

00801dd1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dd7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dda:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dde:	89 04 24             	mov    %eax,(%esp)
  801de1:	e8 87 f5 ff ff       	call   80136d <fd_lookup>
  801de6:	85 c0                	test   %eax,%eax
  801de8:	78 15                	js     801dff <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ded:	8b 0a                	mov    (%edx),%ecx
  801def:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801df4:	3b 0d 24 60 80 00    	cmp    0x806024,%ecx
  801dfa:	75 03                	jne    801dff <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801dfc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	e8 c2 ff ff ff       	call   801dd1 <fd2sockid>
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	78 0f                	js     801e22 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801e13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e16:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e1a:	89 04 24             	mov    %eax,(%esp)
  801e1d:	e8 2e 01 00 00       	call   801f50 <nsipc_listen>
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	e8 9f ff ff ff       	call   801dd1 <fd2sockid>
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 16                	js     801e4c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801e36:	8b 55 10             	mov    0x10(%ebp),%edx
  801e39:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e40:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e44:	89 04 24             	mov    %eax,(%esp)
  801e47:	e8 55 02 00 00       	call   8020a1 <nsipc_connect>
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	e8 75 ff ff ff       	call   801dd1 <fd2sockid>
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	78 0f                	js     801e6f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801e60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e63:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e67:	89 04 24             	mov    %eax,(%esp)
  801e6a:	e8 1d 01 00 00       	call   801f8c <nsipc_shutdown>
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	e8 52 ff ff ff       	call   801dd1 <fd2sockid>
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	78 16                	js     801e99 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801e83:	8b 55 10             	mov    0x10(%ebp),%edx
  801e86:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e91:	89 04 24             	mov    %eax,(%esp)
  801e94:	e8 47 02 00 00       	call   8020e0 <nsipc_bind>
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	e8 28 ff ff ff       	call   801dd1 <fd2sockid>
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 1f                	js     801ecc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ead:	8b 55 10             	mov    0x10(%ebp),%edx
  801eb0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ebb:	89 04 24             	mov    %eax,(%esp)
  801ebe:	e8 5c 02 00 00       	call   80211f <nsipc_accept>
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	78 05                	js     801ecc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801ec7:	e8 62 fe ff ff       	call   801d2e <alloc_sockfd>
}
  801ecc:	c9                   	leave  
  801ecd:	8d 76 00             	lea    0x0(%esi),%esi
  801ed0:	c3                   	ret    
	...

00801ee0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ee6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801eec:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ef3:	00 
  801ef4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801efb:	00 
  801efc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f00:	89 14 24             	mov    %edx,(%esp)
  801f03:	e8 08 08 00 00       	call   802710 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f08:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f0f:	00 
  801f10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f17:	00 
  801f18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1f:	e8 52 08 00 00       	call   802776 <ipc_recv>
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f37:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801f44:	b8 09 00 00 00       	mov    $0x9,%eax
  801f49:	e8 92 ff ff ff       	call   801ee0 <nsipc>
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f61:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801f66:	b8 06 00 00 00       	mov    $0x6,%eax
  801f6b:	e8 70 ff ff ff       	call   801ee0 <nsipc>
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801f80:	b8 04 00 00 00       	mov    $0x4,%eax
  801f85:	e8 56 ff ff ff       	call   801ee0 <nsipc>
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801fa2:	b8 03 00 00 00       	mov    $0x3,%eax
  801fa7:	e8 34 ff ff ff       	call   801ee0 <nsipc>
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	53                   	push   %ebx
  801fb2:	83 ec 14             	sub    $0x14,%esp
  801fb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801fc0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fc6:	7e 24                	jle    801fec <nsipc_send+0x3e>
  801fc8:	c7 44 24 0c 08 2f 80 	movl   $0x802f08,0xc(%esp)
  801fcf:	00 
  801fd0:	c7 44 24 08 14 2f 80 	movl   $0x802f14,0x8(%esp)
  801fd7:	00 
  801fd8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801fdf:	00 
  801fe0:	c7 04 24 29 2f 80 00 	movl   $0x802f29,(%esp)
  801fe7:	e8 50 e2 ff ff       	call   80023c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801ffe:	e8 72 eb ff ff       	call   800b75 <memmove>
	nsipcbuf.send.req_size = size;
  802003:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  802009:	8b 45 14             	mov    0x14(%ebp),%eax
  80200c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  802011:	b8 08 00 00 00       	mov    $0x8,%eax
  802016:	e8 c5 fe ff ff       	call   801ee0 <nsipc>
}
  80201b:	83 c4 14             	add    $0x14,%esp
  80201e:	5b                   	pop    %ebx
  80201f:	5d                   	pop    %ebp
  802020:	c3                   	ret    

00802021 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	56                   	push   %esi
  802025:	53                   	push   %ebx
  802026:	83 ec 10             	sub    $0x10,%esp
  802029:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  802034:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80203a:	8b 45 14             	mov    0x14(%ebp),%eax
  80203d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802042:	b8 07 00 00 00       	mov    $0x7,%eax
  802047:	e8 94 fe ff ff       	call   801ee0 <nsipc>
  80204c:	89 c3                	mov    %eax,%ebx
  80204e:	85 c0                	test   %eax,%eax
  802050:	78 46                	js     802098 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802052:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802057:	7f 04                	jg     80205d <nsipc_recv+0x3c>
  802059:	39 c6                	cmp    %eax,%esi
  80205b:	7d 24                	jge    802081 <nsipc_recv+0x60>
  80205d:	c7 44 24 0c 35 2f 80 	movl   $0x802f35,0xc(%esp)
  802064:	00 
  802065:	c7 44 24 08 14 2f 80 	movl   $0x802f14,0x8(%esp)
  80206c:	00 
  80206d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802074:	00 
  802075:	c7 04 24 29 2f 80 00 	movl   $0x802f29,(%esp)
  80207c:	e8 bb e1 ff ff       	call   80023c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802081:	89 44 24 08          	mov    %eax,0x8(%esp)
  802085:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80208c:	00 
  80208d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802090:	89 04 24             	mov    %eax,(%esp)
  802093:	e8 dd ea ff ff       	call   800b75 <memmove>
	}

	return r;
}
  802098:	89 d8                	mov    %ebx,%eax
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	5b                   	pop    %ebx
  80209e:	5e                   	pop    %esi
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    

008020a1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	53                   	push   %ebx
  8020a5:	83 ec 14             	sub    $0x14,%esp
  8020a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020be:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8020c5:	e8 ab ea ff ff       	call   800b75 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020ca:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8020d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8020d5:	e8 06 fe ff ff       	call   801ee0 <nsipc>
}
  8020da:	83 c4 14             	add    $0x14,%esp
  8020dd:	5b                   	pop    %ebx
  8020de:	5d                   	pop    %ebp
  8020df:	c3                   	ret    

008020e0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 14             	sub    $0x14,%esp
  8020e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020f2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fd:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  802104:	e8 6c ea ff ff       	call   800b75 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802109:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  80210f:	b8 02 00 00 00       	mov    $0x2,%eax
  802114:	e8 c7 fd ff ff       	call   801ee0 <nsipc>
}
  802119:	83 c4 14             	add    $0x14,%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    

0080211f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 18             	sub    $0x18,%esp
  802125:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802128:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802133:	b8 01 00 00 00       	mov    $0x1,%eax
  802138:	e8 a3 fd ff ff       	call   801ee0 <nsipc>
  80213d:	89 c3                	mov    %eax,%ebx
  80213f:	85 c0                	test   %eax,%eax
  802141:	78 25                	js     802168 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802143:	be 10 50 80 00       	mov    $0x805010,%esi
  802148:	8b 06                	mov    (%esi),%eax
  80214a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80214e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802155:	00 
  802156:	8b 45 0c             	mov    0xc(%ebp),%eax
  802159:	89 04 24             	mov    %eax,(%esp)
  80215c:	e8 14 ea ff ff       	call   800b75 <memmove>
		*addrlen = ret->ret_addrlen;
  802161:	8b 16                	mov    (%esi),%edx
  802163:	8b 45 10             	mov    0x10(%ebp),%eax
  802166:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802168:	89 d8                	mov    %ebx,%eax
  80216a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80216d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802170:	89 ec                	mov    %ebp,%esp
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
	...

00802180 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
  802186:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802189:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80218c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	89 04 24             	mov    %eax,(%esp)
  802195:	e8 46 f1 ff ff       	call   8012e0 <fd2data>
  80219a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80219c:	c7 44 24 04 4a 2f 80 	movl   $0x802f4a,0x4(%esp)
  8021a3:	00 
  8021a4:	89 34 24             	mov    %esi,(%esp)
  8021a7:	e8 0e e8 ff ff       	call   8009ba <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021ac:	8b 43 04             	mov    0x4(%ebx),%eax
  8021af:	2b 03                	sub    (%ebx),%eax
  8021b1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8021b7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8021be:	00 00 00 
	stat->st_dev = &devpipe;
  8021c1:	c7 86 88 00 00 00 40 	movl   $0x806040,0x88(%esi)
  8021c8:	60 80 00 
	return 0;
}
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021d3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021d6:	89 ec                	mov    %ebp,%esp
  8021d8:	5d                   	pop    %ebp
  8021d9:	c3                   	ret    

008021da <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	53                   	push   %ebx
  8021de:	83 ec 14             	sub    $0x14,%esp
  8021e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021e4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ef:	e8 fb ee ff ff       	call   8010ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021f4:	89 1c 24             	mov    %ebx,(%esp)
  8021f7:	e8 e4 f0 ff ff       	call   8012e0 <fd2data>
  8021fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802207:	e8 e3 ee ff ff       	call   8010ef <sys_page_unmap>
}
  80220c:	83 c4 14             	add    $0x14,%esp
  80220f:	5b                   	pop    %ebx
  802210:	5d                   	pop    %ebp
  802211:	c3                   	ret    

00802212 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 2c             	sub    $0x2c,%esp
  80221b:	89 c7                	mov    %eax,%edi
  80221d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802220:	a1 7c 60 80 00       	mov    0x80607c,%eax
  802225:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802228:	89 3c 24             	mov    %edi,(%esp)
  80222b:	e8 b0 05 00 00       	call   8027e0 <pageref>
  802230:	89 c6                	mov    %eax,%esi
  802232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802235:	89 04 24             	mov    %eax,(%esp)
  802238:	e8 a3 05 00 00       	call   8027e0 <pageref>
  80223d:	39 c6                	cmp    %eax,%esi
  80223f:	0f 94 c0             	sete   %al
  802242:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802245:	8b 15 7c 60 80 00    	mov    0x80607c,%edx
  80224b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80224e:	39 cb                	cmp    %ecx,%ebx
  802250:	75 08                	jne    80225a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802252:	83 c4 2c             	add    $0x2c,%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80225a:	83 f8 01             	cmp    $0x1,%eax
  80225d:	75 c1                	jne    802220 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80225f:	8b 52 58             	mov    0x58(%edx),%edx
  802262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802266:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80226e:	c7 04 24 51 2f 80 00 	movl   $0x802f51,(%esp)
  802275:	e8 87 e0 ff ff       	call   800301 <cprintf>
  80227a:	eb a4                	jmp    802220 <_pipeisclosed+0xe>

0080227c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	57                   	push   %edi
  802280:	56                   	push   %esi
  802281:	53                   	push   %ebx
  802282:	83 ec 1c             	sub    $0x1c,%esp
  802285:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802288:	89 34 24             	mov    %esi,(%esp)
  80228b:	e8 50 f0 ff ff       	call   8012e0 <fd2data>
  802290:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802292:	bf 00 00 00 00       	mov    $0x0,%edi
  802297:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80229b:	75 54                	jne    8022f1 <devpipe_write+0x75>
  80229d:	eb 60                	jmp    8022ff <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80229f:	89 da                	mov    %ebx,%edx
  8022a1:	89 f0                	mov    %esi,%eax
  8022a3:	e8 6a ff ff ff       	call   802212 <_pipeisclosed>
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	74 07                	je     8022b3 <devpipe_write+0x37>
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b1:	eb 53                	jmp    802306 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022b3:	90                   	nop
  8022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	e8 4d ef ff ff       	call   80120a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022bd:	8b 43 04             	mov    0x4(%ebx),%eax
  8022c0:	8b 13                	mov    (%ebx),%edx
  8022c2:	83 c2 20             	add    $0x20,%edx
  8022c5:	39 d0                	cmp    %edx,%eax
  8022c7:	73 d6                	jae    80229f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022c9:	89 c2                	mov    %eax,%edx
  8022cb:	c1 fa 1f             	sar    $0x1f,%edx
  8022ce:	c1 ea 1b             	shr    $0x1b,%edx
  8022d1:	01 d0                	add    %edx,%eax
  8022d3:	83 e0 1f             	and    $0x1f,%eax
  8022d6:	29 d0                	sub    %edx,%eax
  8022d8:	89 c2                	mov    %eax,%edx
  8022da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022dd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8022e1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022e5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022e9:	83 c7 01             	add    $0x1,%edi
  8022ec:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8022ef:	76 13                	jbe    802304 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022f1:	8b 43 04             	mov    0x4(%ebx),%eax
  8022f4:	8b 13                	mov    (%ebx),%edx
  8022f6:	83 c2 20             	add    $0x20,%edx
  8022f9:	39 d0                	cmp    %edx,%eax
  8022fb:	73 a2                	jae    80229f <devpipe_write+0x23>
  8022fd:	eb ca                	jmp    8022c9 <devpipe_write+0x4d>
  8022ff:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802304:	89 f8                	mov    %edi,%eax
}
  802306:	83 c4 1c             	add    $0x1c,%esp
  802309:	5b                   	pop    %ebx
  80230a:	5e                   	pop    %esi
  80230b:	5f                   	pop    %edi
  80230c:	5d                   	pop    %ebp
  80230d:	c3                   	ret    

0080230e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 28             	sub    $0x28,%esp
  802314:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802317:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80231a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80231d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802320:	89 3c 24             	mov    %edi,(%esp)
  802323:	e8 b8 ef ff ff       	call   8012e0 <fd2data>
  802328:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80232a:	be 00 00 00 00       	mov    $0x0,%esi
  80232f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802333:	75 4c                	jne    802381 <devpipe_read+0x73>
  802335:	eb 5b                	jmp    802392 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802337:	89 f0                	mov    %esi,%eax
  802339:	eb 5e                	jmp    802399 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80233b:	89 da                	mov    %ebx,%edx
  80233d:	89 f8                	mov    %edi,%eax
  80233f:	90                   	nop
  802340:	e8 cd fe ff ff       	call   802212 <_pipeisclosed>
  802345:	85 c0                	test   %eax,%eax
  802347:	74 07                	je     802350 <devpipe_read+0x42>
  802349:	b8 00 00 00 00       	mov    $0x0,%eax
  80234e:	eb 49                	jmp    802399 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802350:	e8 b5 ee ff ff       	call   80120a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802355:	8b 03                	mov    (%ebx),%eax
  802357:	3b 43 04             	cmp    0x4(%ebx),%eax
  80235a:	74 df                	je     80233b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80235c:	89 c2                	mov    %eax,%edx
  80235e:	c1 fa 1f             	sar    $0x1f,%edx
  802361:	c1 ea 1b             	shr    $0x1b,%edx
  802364:	01 d0                	add    %edx,%eax
  802366:	83 e0 1f             	and    $0x1f,%eax
  802369:	29 d0                	sub    %edx,%eax
  80236b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802370:	8b 55 0c             	mov    0xc(%ebp),%edx
  802373:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802376:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802379:	83 c6 01             	add    $0x1,%esi
  80237c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80237f:	76 16                	jbe    802397 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802381:	8b 03                	mov    (%ebx),%eax
  802383:	3b 43 04             	cmp    0x4(%ebx),%eax
  802386:	75 d4                	jne    80235c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802388:	85 f6                	test   %esi,%esi
  80238a:	75 ab                	jne    802337 <devpipe_read+0x29>
  80238c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802390:	eb a9                	jmp    80233b <devpipe_read+0x2d>
  802392:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802397:	89 f0                	mov    %esi,%eax
}
  802399:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80239c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80239f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023a2:	89 ec                	mov    %ebp,%esp
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    

008023a6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	89 04 24             	mov    %eax,(%esp)
  8023b9:	e8 af ef ff ff       	call   80136d <fd_lookup>
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	78 15                	js     8023d7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	89 04 24             	mov    %eax,(%esp)
  8023c8:	e8 13 ef ff ff       	call   8012e0 <fd2data>
	return _pipeisclosed(fd, p);
  8023cd:	89 c2                	mov    %eax,%edx
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	e8 3b fe ff ff       	call   802212 <_pipeisclosed>
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	83 ec 48             	sub    $0x48,%esp
  8023df:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023e2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023e5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023e8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8023ee:	89 04 24             	mov    %eax,(%esp)
  8023f1:	e8 05 ef ff ff       	call   8012fb <fd_alloc>
  8023f6:	89 c3                	mov    %eax,%ebx
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	0f 88 42 01 00 00    	js     802542 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802400:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802407:	00 
  802408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802416:	e8 90 ed ff ff       	call   8011ab <sys_page_alloc>
  80241b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80241d:	85 c0                	test   %eax,%eax
  80241f:	0f 88 1d 01 00 00    	js     802542 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802425:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802428:	89 04 24             	mov    %eax,(%esp)
  80242b:	e8 cb ee ff ff       	call   8012fb <fd_alloc>
  802430:	89 c3                	mov    %eax,%ebx
  802432:	85 c0                	test   %eax,%eax
  802434:	0f 88 f5 00 00 00    	js     80252f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802441:	00 
  802442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802445:	89 44 24 04          	mov    %eax,0x4(%esp)
  802449:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802450:	e8 56 ed ff ff       	call   8011ab <sys_page_alloc>
  802455:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802457:	85 c0                	test   %eax,%eax
  802459:	0f 88 d0 00 00 00    	js     80252f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80245f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802462:	89 04 24             	mov    %eax,(%esp)
  802465:	e8 76 ee ff ff       	call   8012e0 <fd2data>
  80246a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80246c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802473:	00 
  802474:	89 44 24 04          	mov    %eax,0x4(%esp)
  802478:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80247f:	e8 27 ed ff ff       	call   8011ab <sys_page_alloc>
  802484:	89 c3                	mov    %eax,%ebx
  802486:	85 c0                	test   %eax,%eax
  802488:	0f 88 8e 00 00 00    	js     80251c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802491:	89 04 24             	mov    %eax,(%esp)
  802494:	e8 47 ee ff ff       	call   8012e0 <fd2data>
  802499:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024a0:	00 
  8024a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024ac:	00 
  8024ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b8:	e8 90 ec ff ff       	call   80114d <sys_page_map>
  8024bd:	89 c3                	mov    %eax,%ebx
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	78 49                	js     80250c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024c3:	b8 40 60 80 00       	mov    $0x806040,%eax
  8024c8:	8b 08                	mov    (%eax),%ecx
  8024ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024cd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024d2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8024d9:	8b 10                	mov    (%eax),%edx
  8024db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024de:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8024ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ed:	89 04 24             	mov    %eax,(%esp)
  8024f0:	e8 db ed ff ff       	call   8012d0 <fd2num>
  8024f5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8024f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024fa:	89 04 24             	mov    %eax,(%esp)
  8024fd:	e8 ce ed ff ff       	call   8012d0 <fd2num>
  802502:	89 47 04             	mov    %eax,0x4(%edi)
  802505:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80250a:	eb 36                	jmp    802542 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80250c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802510:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802517:	e8 d3 eb ff ff       	call   8010ef <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80251c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802523:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80252a:	e8 c0 eb ff ff       	call   8010ef <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80252f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802532:	89 44 24 04          	mov    %eax,0x4(%esp)
  802536:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80253d:	e8 ad eb ff ff       	call   8010ef <sys_page_unmap>
    err:
	return r;
}
  802542:	89 d8                	mov    %ebx,%eax
  802544:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802547:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80254a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80254d:	89 ec                	mov    %ebp,%esp
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    
	...

00802560 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802563:	b8 00 00 00 00       	mov    $0x0,%eax
  802568:	5d                   	pop    %ebp
  802569:	c3                   	ret    

0080256a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802570:	c7 44 24 04 69 2f 80 	movl   $0x802f69,0x4(%esp)
  802577:	00 
  802578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257b:	89 04 24             	mov    %eax,(%esp)
  80257e:	e8 37 e4 ff ff       	call   8009ba <strcpy>
	return 0;
}
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	57                   	push   %edi
  80258e:	56                   	push   %esi
  80258f:	53                   	push   %ebx
  802590:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
  80259b:	be 00 00 00 00       	mov    $0x0,%esi
  8025a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025a4:	74 3f                	je     8025e5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025a6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8025ac:	8b 55 10             	mov    0x10(%ebp),%edx
  8025af:	29 c2                	sub    %eax,%edx
  8025b1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8025b3:	83 fa 7f             	cmp    $0x7f,%edx
  8025b6:	76 05                	jbe    8025bd <devcons_write+0x33>
  8025b8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025bd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025c1:	03 45 0c             	add    0xc(%ebp),%eax
  8025c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c8:	89 3c 24             	mov    %edi,(%esp)
  8025cb:	e8 a5 e5 ff ff       	call   800b75 <memmove>
		sys_cputs(buf, m);
  8025d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025d4:	89 3c 24             	mov    %edi,(%esp)
  8025d7:	e8 d4 e7 ff ff       	call   800db0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025dc:	01 de                	add    %ebx,%esi
  8025de:	89 f0                	mov    %esi,%eax
  8025e0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025e3:	72 c7                	jb     8025ac <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025e5:	89 f0                	mov    %esi,%eax
  8025e7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025ed:	5b                   	pop    %ebx
  8025ee:	5e                   	pop    %esi
  8025ef:	5f                   	pop    %edi
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    

008025f2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802605:	00 
  802606:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802609:	89 04 24             	mov    %eax,(%esp)
  80260c:	e8 9f e7 ff ff       	call   800db0 <sys_cputs>
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802619:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80261d:	75 07                	jne    802626 <devcons_read+0x13>
  80261f:	eb 28                	jmp    802649 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802621:	e8 e4 eb ff ff       	call   80120a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802626:	66 90                	xchg   %ax,%ax
  802628:	e8 4f e7 ff ff       	call   800d7c <sys_cgetc>
  80262d:	85 c0                	test   %eax,%eax
  80262f:	90                   	nop
  802630:	74 ef                	je     802621 <devcons_read+0xe>
  802632:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802634:	85 c0                	test   %eax,%eax
  802636:	78 16                	js     80264e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802638:	83 f8 04             	cmp    $0x4,%eax
  80263b:	74 0c                	je     802649 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80263d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802640:	88 10                	mov    %dl,(%eax)
  802642:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802647:	eb 05                	jmp    80264e <devcons_read+0x3b>
  802649:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802656:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802659:	89 04 24             	mov    %eax,(%esp)
  80265c:	e8 9a ec ff ff       	call   8012fb <fd_alloc>
  802661:	85 c0                	test   %eax,%eax
  802663:	78 3f                	js     8026a4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802665:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80266c:	00 
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	89 44 24 04          	mov    %eax,0x4(%esp)
  802674:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80267b:	e8 2b eb ff ff       	call   8011ab <sys_page_alloc>
  802680:	85 c0                	test   %eax,%eax
  802682:	78 20                	js     8026a4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802684:	8b 15 5c 60 80 00    	mov    0x80605c,%edx
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	89 04 24             	mov    %eax,(%esp)
  80269f:	e8 2c ec ff ff       	call   8012d0 <fd2num>
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	89 04 24             	mov    %eax,(%esp)
  8026b9:	e8 af ec ff ff       	call   80136d <fd_lookup>
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	78 11                	js     8026d3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	3b 05 5c 60 80 00    	cmp    0x80605c,%eax
  8026cd:	0f 94 c0             	sete   %al
  8026d0:	0f b6 c0             	movzbl %al,%eax
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026e2:	00 
  8026e3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f1:	e8 d8 ee ff ff       	call   8015ce <read>
	if (r < 0)
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	78 0f                	js     802709 <getchar+0x34>
		return r;
	if (r < 1)
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	7f 07                	jg     802705 <getchar+0x30>
  8026fe:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802703:	eb 04                	jmp    802709 <getchar+0x34>
		return -E_EOF;
	return c;
  802705:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    
  80270b:	00 00                	add    %al,(%eax)
  80270d:	00 00                	add    %al,(%eax)
	...

00802710 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	57                   	push   %edi
  802714:	56                   	push   %esi
  802715:	53                   	push   %ebx
  802716:	83 ec 1c             	sub    $0x1c,%esp
  802719:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80271c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80271f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802722:	85 db                	test   %ebx,%ebx
  802724:	75 2d                	jne    802753 <ipc_send+0x43>
  802726:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80272b:	eb 26                	jmp    802753 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80272d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802730:	74 1c                	je     80274e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802732:	c7 44 24 08 78 2f 80 	movl   $0x802f78,0x8(%esp)
  802739:	00 
  80273a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802741:	00 
  802742:	c7 04 24 9c 2f 80 00 	movl   $0x802f9c,(%esp)
  802749:	e8 ee da ff ff       	call   80023c <_panic>
		sys_yield();
  80274e:	e8 b7 ea ff ff       	call   80120a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802753:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802757:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80275b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	89 04 24             	mov    %eax,(%esp)
  802765:	e8 33 e8 ff ff       	call   800f9d <sys_ipc_try_send>
  80276a:	85 c0                	test   %eax,%eax
  80276c:	78 bf                	js     80272d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80276e:	83 c4 1c             	add    $0x1c,%esp
  802771:	5b                   	pop    %ebx
  802772:	5e                   	pop    %esi
  802773:	5f                   	pop    %edi
  802774:	5d                   	pop    %ebp
  802775:	c3                   	ret    

00802776 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	56                   	push   %esi
  80277a:	53                   	push   %ebx
  80277b:	83 ec 10             	sub    $0x10,%esp
  80277e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802781:	8b 45 0c             	mov    0xc(%ebp),%eax
  802784:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802787:	85 c0                	test   %eax,%eax
  802789:	75 05                	jne    802790 <ipc_recv+0x1a>
  80278b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802790:	89 04 24             	mov    %eax,(%esp)
  802793:	e8 a8 e7 ff ff       	call   800f40 <sys_ipc_recv>
  802798:	85 c0                	test   %eax,%eax
  80279a:	79 16                	jns    8027b2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80279c:	85 db                	test   %ebx,%ebx
  80279e:	74 06                	je     8027a6 <ipc_recv+0x30>
			*from_env_store = 0;
  8027a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8027a6:	85 f6                	test   %esi,%esi
  8027a8:	74 2c                	je     8027d6 <ipc_recv+0x60>
			*perm_store = 0;
  8027aa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8027b0:	eb 24                	jmp    8027d6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8027b2:	85 db                	test   %ebx,%ebx
  8027b4:	74 0a                	je     8027c0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8027b6:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8027bb:	8b 40 74             	mov    0x74(%eax),%eax
  8027be:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  8027c0:	85 f6                	test   %esi,%esi
  8027c2:	74 0a                	je     8027ce <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  8027c4:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8027c9:	8b 40 78             	mov    0x78(%eax),%eax
  8027cc:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  8027ce:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8027d3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	5b                   	pop    %ebx
  8027da:	5e                   	pop    %esi
  8027db:	5d                   	pop    %ebp
  8027dc:	c3                   	ret    
  8027dd:	00 00                	add    %al,(%eax)
	...

008027e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	89 c2                	mov    %eax,%edx
  8027e8:	c1 ea 16             	shr    $0x16,%edx
  8027eb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027f2:	f6 c2 01             	test   $0x1,%dl
  8027f5:	74 26                	je     80281d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8027f7:	c1 e8 0c             	shr    $0xc,%eax
  8027fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802801:	a8 01                	test   $0x1,%al
  802803:	74 18                	je     80281d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802805:	c1 e8 0c             	shr    $0xc,%eax
  802808:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80280b:	c1 e2 02             	shl    $0x2,%edx
  80280e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802813:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802818:	0f b7 c0             	movzwl %ax,%eax
  80281b:	eb 05                	jmp    802822 <pageref+0x42>
  80281d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802822:	5d                   	pop    %ebp
  802823:	c3                   	ret    
	...

00802830 <__udivdi3>:
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	57                   	push   %edi
  802834:	56                   	push   %esi
  802835:	83 ec 10             	sub    $0x10,%esp
  802838:	8b 45 14             	mov    0x14(%ebp),%eax
  80283b:	8b 55 08             	mov    0x8(%ebp),%edx
  80283e:	8b 75 10             	mov    0x10(%ebp),%esi
  802841:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802844:	85 c0                	test   %eax,%eax
  802846:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802849:	75 35                	jne    802880 <__udivdi3+0x50>
  80284b:	39 fe                	cmp    %edi,%esi
  80284d:	77 61                	ja     8028b0 <__udivdi3+0x80>
  80284f:	85 f6                	test   %esi,%esi
  802851:	75 0b                	jne    80285e <__udivdi3+0x2e>
  802853:	b8 01 00 00 00       	mov    $0x1,%eax
  802858:	31 d2                	xor    %edx,%edx
  80285a:	f7 f6                	div    %esi
  80285c:	89 c6                	mov    %eax,%esi
  80285e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802861:	31 d2                	xor    %edx,%edx
  802863:	89 f8                	mov    %edi,%eax
  802865:	f7 f6                	div    %esi
  802867:	89 c7                	mov    %eax,%edi
  802869:	89 c8                	mov    %ecx,%eax
  80286b:	f7 f6                	div    %esi
  80286d:	89 c1                	mov    %eax,%ecx
  80286f:	89 fa                	mov    %edi,%edx
  802871:	89 c8                	mov    %ecx,%eax
  802873:	83 c4 10             	add    $0x10,%esp
  802876:	5e                   	pop    %esi
  802877:	5f                   	pop    %edi
  802878:	5d                   	pop    %ebp
  802879:	c3                   	ret    
  80287a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802880:	39 f8                	cmp    %edi,%eax
  802882:	77 1c                	ja     8028a0 <__udivdi3+0x70>
  802884:	0f bd d0             	bsr    %eax,%edx
  802887:	83 f2 1f             	xor    $0x1f,%edx
  80288a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80288d:	75 39                	jne    8028c8 <__udivdi3+0x98>
  80288f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802892:	0f 86 a0 00 00 00    	jbe    802938 <__udivdi3+0x108>
  802898:	39 f8                	cmp    %edi,%eax
  80289a:	0f 82 98 00 00 00    	jb     802938 <__udivdi3+0x108>
  8028a0:	31 ff                	xor    %edi,%edi
  8028a2:	31 c9                	xor    %ecx,%ecx
  8028a4:	89 c8                	mov    %ecx,%eax
  8028a6:	89 fa                	mov    %edi,%edx
  8028a8:	83 c4 10             	add    $0x10,%esp
  8028ab:	5e                   	pop    %esi
  8028ac:	5f                   	pop    %edi
  8028ad:	5d                   	pop    %ebp
  8028ae:	c3                   	ret    
  8028af:	90                   	nop
  8028b0:	89 d1                	mov    %edx,%ecx
  8028b2:	89 fa                	mov    %edi,%edx
  8028b4:	89 c8                	mov    %ecx,%eax
  8028b6:	31 ff                	xor    %edi,%edi
  8028b8:	f7 f6                	div    %esi
  8028ba:	89 c1                	mov    %eax,%ecx
  8028bc:	89 fa                	mov    %edi,%edx
  8028be:	89 c8                	mov    %ecx,%eax
  8028c0:	83 c4 10             	add    $0x10,%esp
  8028c3:	5e                   	pop    %esi
  8028c4:	5f                   	pop    %edi
  8028c5:	5d                   	pop    %ebp
  8028c6:	c3                   	ret    
  8028c7:	90                   	nop
  8028c8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028cc:	89 f2                	mov    %esi,%edx
  8028ce:	d3 e0                	shl    %cl,%eax
  8028d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028d3:	b8 20 00 00 00       	mov    $0x20,%eax
  8028d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028db:	89 c1                	mov    %eax,%ecx
  8028dd:	d3 ea                	shr    %cl,%edx
  8028df:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028e3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8028e6:	d3 e6                	shl    %cl,%esi
  8028e8:	89 c1                	mov    %eax,%ecx
  8028ea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8028ed:	89 fe                	mov    %edi,%esi
  8028ef:	d3 ee                	shr    %cl,%esi
  8028f1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028fb:	d3 e7                	shl    %cl,%edi
  8028fd:	89 c1                	mov    %eax,%ecx
  8028ff:	d3 ea                	shr    %cl,%edx
  802901:	09 d7                	or     %edx,%edi
  802903:	89 f2                	mov    %esi,%edx
  802905:	89 f8                	mov    %edi,%eax
  802907:	f7 75 ec             	divl   -0x14(%ebp)
  80290a:	89 d6                	mov    %edx,%esi
  80290c:	89 c7                	mov    %eax,%edi
  80290e:	f7 65 e8             	mull   -0x18(%ebp)
  802911:	39 d6                	cmp    %edx,%esi
  802913:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802916:	72 30                	jb     802948 <__udivdi3+0x118>
  802918:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80291f:	d3 e2                	shl    %cl,%edx
  802921:	39 c2                	cmp    %eax,%edx
  802923:	73 05                	jae    80292a <__udivdi3+0xfa>
  802925:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802928:	74 1e                	je     802948 <__udivdi3+0x118>
  80292a:	89 f9                	mov    %edi,%ecx
  80292c:	31 ff                	xor    %edi,%edi
  80292e:	e9 71 ff ff ff       	jmp    8028a4 <__udivdi3+0x74>
  802933:	90                   	nop
  802934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802938:	31 ff                	xor    %edi,%edi
  80293a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80293f:	e9 60 ff ff ff       	jmp    8028a4 <__udivdi3+0x74>
  802944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802948:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80294b:	31 ff                	xor    %edi,%edi
  80294d:	89 c8                	mov    %ecx,%eax
  80294f:	89 fa                	mov    %edi,%edx
  802951:	83 c4 10             	add    $0x10,%esp
  802954:	5e                   	pop    %esi
  802955:	5f                   	pop    %edi
  802956:	5d                   	pop    %ebp
  802957:	c3                   	ret    
	...

00802960 <__umoddi3>:
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	57                   	push   %edi
  802964:	56                   	push   %esi
  802965:	83 ec 20             	sub    $0x20,%esp
  802968:	8b 55 14             	mov    0x14(%ebp),%edx
  80296b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80296e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802971:	8b 75 0c             	mov    0xc(%ebp),%esi
  802974:	85 d2                	test   %edx,%edx
  802976:	89 c8                	mov    %ecx,%eax
  802978:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80297b:	75 13                	jne    802990 <__umoddi3+0x30>
  80297d:	39 f7                	cmp    %esi,%edi
  80297f:	76 3f                	jbe    8029c0 <__umoddi3+0x60>
  802981:	89 f2                	mov    %esi,%edx
  802983:	f7 f7                	div    %edi
  802985:	89 d0                	mov    %edx,%eax
  802987:	31 d2                	xor    %edx,%edx
  802989:	83 c4 20             	add    $0x20,%esp
  80298c:	5e                   	pop    %esi
  80298d:	5f                   	pop    %edi
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    
  802990:	39 f2                	cmp    %esi,%edx
  802992:	77 4c                	ja     8029e0 <__umoddi3+0x80>
  802994:	0f bd ca             	bsr    %edx,%ecx
  802997:	83 f1 1f             	xor    $0x1f,%ecx
  80299a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80299d:	75 51                	jne    8029f0 <__umoddi3+0x90>
  80299f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8029a2:	0f 87 e0 00 00 00    	ja     802a88 <__umoddi3+0x128>
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	29 f8                	sub    %edi,%eax
  8029ad:	19 d6                	sbb    %edx,%esi
  8029af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	89 f2                	mov    %esi,%edx
  8029b7:	83 c4 20             	add    $0x20,%esp
  8029ba:	5e                   	pop    %esi
  8029bb:	5f                   	pop    %edi
  8029bc:	5d                   	pop    %ebp
  8029bd:	c3                   	ret    
  8029be:	66 90                	xchg   %ax,%ax
  8029c0:	85 ff                	test   %edi,%edi
  8029c2:	75 0b                	jne    8029cf <__umoddi3+0x6f>
  8029c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c9:	31 d2                	xor    %edx,%edx
  8029cb:	f7 f7                	div    %edi
  8029cd:	89 c7                	mov    %eax,%edi
  8029cf:	89 f0                	mov    %esi,%eax
  8029d1:	31 d2                	xor    %edx,%edx
  8029d3:	f7 f7                	div    %edi
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	f7 f7                	div    %edi
  8029da:	eb a9                	jmp    802985 <__umoddi3+0x25>
  8029dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029e0:	89 c8                	mov    %ecx,%eax
  8029e2:	89 f2                	mov    %esi,%edx
  8029e4:	83 c4 20             	add    $0x20,%esp
  8029e7:	5e                   	pop    %esi
  8029e8:	5f                   	pop    %edi
  8029e9:	5d                   	pop    %ebp
  8029ea:	c3                   	ret    
  8029eb:	90                   	nop
  8029ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029f4:	d3 e2                	shl    %cl,%edx
  8029f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029f9:	ba 20 00 00 00       	mov    $0x20,%edx
  8029fe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802a01:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802a04:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a08:	89 fa                	mov    %edi,%edx
  802a0a:	d3 ea                	shr    %cl,%edx
  802a0c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a10:	0b 55 f4             	or     -0xc(%ebp),%edx
  802a13:	d3 e7                	shl    %cl,%edi
  802a15:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a19:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a1c:	89 f2                	mov    %esi,%edx
  802a1e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802a21:	89 c7                	mov    %eax,%edi
  802a23:	d3 ea                	shr    %cl,%edx
  802a25:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802a2c:	89 c2                	mov    %eax,%edx
  802a2e:	d3 e6                	shl    %cl,%esi
  802a30:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a34:	d3 ea                	shr    %cl,%edx
  802a36:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a3a:	09 d6                	or     %edx,%esi
  802a3c:	89 f0                	mov    %esi,%eax
  802a3e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a41:	d3 e7                	shl    %cl,%edi
  802a43:	89 f2                	mov    %esi,%edx
  802a45:	f7 75 f4             	divl   -0xc(%ebp)
  802a48:	89 d6                	mov    %edx,%esi
  802a4a:	f7 65 e8             	mull   -0x18(%ebp)
  802a4d:	39 d6                	cmp    %edx,%esi
  802a4f:	72 2b                	jb     802a7c <__umoddi3+0x11c>
  802a51:	39 c7                	cmp    %eax,%edi
  802a53:	72 23                	jb     802a78 <__umoddi3+0x118>
  802a55:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a59:	29 c7                	sub    %eax,%edi
  802a5b:	19 d6                	sbb    %edx,%esi
  802a5d:	89 f0                	mov    %esi,%eax
  802a5f:	89 f2                	mov    %esi,%edx
  802a61:	d3 ef                	shr    %cl,%edi
  802a63:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a67:	d3 e0                	shl    %cl,%eax
  802a69:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a6d:	09 f8                	or     %edi,%eax
  802a6f:	d3 ea                	shr    %cl,%edx
  802a71:	83 c4 20             	add    $0x20,%esp
  802a74:	5e                   	pop    %esi
  802a75:	5f                   	pop    %edi
  802a76:	5d                   	pop    %ebp
  802a77:	c3                   	ret    
  802a78:	39 d6                	cmp    %edx,%esi
  802a7a:	75 d9                	jne    802a55 <__umoddi3+0xf5>
  802a7c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a7f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802a82:	eb d1                	jmp    802a55 <__umoddi3+0xf5>
  802a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a88:	39 f2                	cmp    %esi,%edx
  802a8a:	0f 82 18 ff ff ff    	jb     8029a8 <__umoddi3+0x48>
  802a90:	e9 1d ff ff ff       	jmp    8029b2 <__umoddi3+0x52>
